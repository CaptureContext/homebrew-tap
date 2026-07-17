#!/bin/bash

set -euo pipefail

if [[ $# -ne 2 ]]
then
  echo "Usage: scripts/update-formula.sh <formula> <x.y.z>" >&2
  exit 64
fi

readonly formula="$1"
readonly version="$2"
script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly script_directory
tap_directory="$(cd "${script_directory}/.." && pwd)"
readonly tap_directory
readonly registry="${tap_directory}/.github/formulae.json"

if [[ ! "${formula}" =~ ^[a-z0-9][a-z0-9._+-]*$ ]]
then
  echo "Invalid formula name '${formula}'." >&2
  exit 64
fi
if [[ ! "${version}" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]]
then
  echo "Version must be plain semantic version such as 0.1.0." >&2
  exit 64
fi

for command in brew curl gh jq shasum
do
  if ! command -v "${command}" >/dev/null
  then
    echo "Required command '${command}' was not found." >&2
    exit 1
  fi
done

if ! repository="$(jq -er --arg formula "${formula}" '.[$formula].repository // empty' "${registry}")"
then
  echo "Formula '${formula}' is not registered in ${registry}." >&2
  exit 64
fi
readonly repository
if ! asset="$(jq -er --arg formula "${formula}" '.[$formula].asset // empty' "${registry}")"
then
  echo "Formula '${formula}' does not define a release asset in ${registry}." >&2
  exit 1
fi
readonly asset
readonly formula_path="${tap_directory}/Formula/${formula}.rb"
readonly formula_reference="capturecontext/tap/${formula}"

if [[ ! "${repository}" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]
then
  echo "Registry repository '${repository}' is invalid." >&2
  exit 1
fi
if [[ ! "${asset}" =~ ^[A-Za-z0-9._-]+$ ]]
then
  echo "Registry asset '${asset}' is invalid." >&2
  exit 1
fi
if [[ ! -f "${formula_path}" ]]
then
  echo "Formula '${formula_path}' does not exist." >&2
  exit 1
fi

release_json="$(gh api "repos/${repository}/releases/tags/${version}")"
readonly release_json
if ! jq -e \
   --arg version "${version}" \
      '.tag_name == $version and .draft == false and .prerelease == false' \
   <<<"${release_json}" >/dev/null
then
  echo "Release ${repository}@${version} is missing, draft, or prerelease." >&2
  exit 1
fi

artifact_url="$(jq -er \
  --arg name "${asset}" \
  '[.assets[] | select(.name == $name)][0].browser_download_url // empty' \
  <<<"${release_json}")"
readonly artifact_url
checksum_url="$(jq -er \
  --arg name "${asset}.sha256" \
  '[.assets[] | select(.name == $name)][0].browser_download_url // empty' \
  <<<"${release_json}")"
readonly checksum_url

temporary_directory="$(mktemp -d)"
readonly temporary_directory
trap 'rm -rf "$temporary_directory"' EXIT

curl --fail --location --retry 3 --silent --show-error \
  --output "${temporary_directory}/${asset}" \
  "${artifact_url}"
curl --fail --location --retry 3 --silent --show-error \
  --output "${temporary_directory}/${asset}.sha256" \
  "${checksum_url}"
(
  cd "${temporary_directory}"
  shasum -a 256 --check "${asset}.sha256"
)

sha256="$(shasum -a 256 "${temporary_directory}/${asset}" | awk '{print $1}')"
readonly sha256

if grep -Fq "url \"${artifact_url}\"" "${formula_path}" &&
   grep -Fq "sha256 \"${sha256}\"" "${formula_path}"
then
  echo "${formula} is already at ${version}."
else
  brew bump-formula-pr \
    --write-only \
    --no-audit \
    --url="${artifact_url}" \
    --sha256="${sha256}" \
    "${formula_reference}"
fi

brew style "${formula_reference}"
brew audit --formula "${formula_reference}"
HOMEBREW_NO_AUTO_UPDATE=1 brew install "${formula_reference}"
brew test "${formula_reference}"

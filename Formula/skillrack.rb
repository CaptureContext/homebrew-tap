class Skillrack < Formula
  desc "Install, link, and inspect shared agent skills"
  homepage "https://github.com/CaptureContext/skillrack"
  url "https://github.com/CaptureContext/skillrack/releases/download/0.1.0/skillrack-universal-apple-darwin"
  sha256 "db87ec231b8754896d05a6cb88dee0da131a7f82f10c40a5c5a0558df239724d"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :sequoia
  end

  def install
    bin.install "skillrack-universal-apple-darwin" => "skillrack"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/skillrack version").strip
  end
end

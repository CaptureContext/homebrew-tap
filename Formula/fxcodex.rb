class Fxcodex < Formula
  desc "Manage isolated Codex workspaces on macOS"
  homepage "https://github.com/CaptureContext/fxcodex"
  url "https://github.com/CaptureContext/fxcodex/releases/download/0.3.0/fxcodex-universal-apple-darwin"
  sha256 "4f5fbc34644e5f87748e34842f088de898cde94c9f63353b4ac8a912cf12b181"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :sonoma
  end

  def install
    bin.install "fxcodex-universal-apple-darwin" => "fxcodex"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fxcodex --version").strip
  end
end

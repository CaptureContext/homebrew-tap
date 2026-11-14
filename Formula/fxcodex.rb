class Fxcodex < Formula
  desc "Manage isolated Codex workspaces on macOS"
  homepage "https://github.com/CaptureContext/fxcodex"
  url "https://github.com/CaptureContext/fxcodex/releases/download/0.3.1/fxcodex-universal-apple-darwin"
  sha256 "a08841a0131376fb2788651250099ede318a90afa781178650c842e974829750"
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

class Fxcodex < Formula
  desc "Manage isolated Codex workspaces on macOS"
  homepage "https://github.com/CaptureContext/fxcodex"
  url "https://github.com/CaptureContext/fxcodex/releases/download/0.1.1/fxcodex-universal-apple-darwin"
  sha256 "ef0713ce92ad88f699d928c1bb951b4fdd3635db402e07522f7f5cb62abc9baa"
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

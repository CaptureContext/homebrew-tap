class Fxclaude < Formula
  desc "Manage isolated Claude desktop workspaces on macOS"
  homepage "https://github.com/CaptureContext/fxclaude"
  url "https://github.com/CaptureContext/fxclaude/releases/download/0.0.0/fxclaude-universal-apple-darwin"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :sonoma
  end

  def install
    bin.install "fxclaude-universal-apple-darwin" => "fxclaude"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fxclaude --version").strip
  end
end

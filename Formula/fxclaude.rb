class Fxclaude < Formula
  desc "Manage isolated Claude desktop workspaces on macOS"
  homepage "https://github.com/CaptureContext/fxclaude"
  url "https://github.com/CaptureContext/fxclaude/releases/download/0.1.0/fxclaude-universal-apple-darwin"
  sha256 "f6cf2f61b3eb8e8a6086b22ce621b27347945f5c8955d157c64fb305694bb7b2"
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

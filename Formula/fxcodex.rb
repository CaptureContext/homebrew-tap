class Fxcodex < Formula
  desc "Manage isolated Codex workspaces on macOS"
  homepage "https://github.com/CaptureContext/fxcodex"
  url "https://github.com/CaptureContext/fxcodex/releases/download/0.2.1/fxcodex-universal-apple-darwin"
  sha256 "3de8917f28d3355d6d7760c51ff483d6bb00000f6af71a569248eaeeff523b6e"
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

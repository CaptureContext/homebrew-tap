class Fxcodex < Formula
  desc "Manage isolated Codex workspaces on macOS"
  homepage "https://github.com/CaptureContext/fxcodex"
  url "https://github.com/CaptureContext/fxcodex/releases/download/0.1.0/fxcodex-universal-apple-darwin"
  sha256 "2b98593811abbb438e0efabddadd4341058cf97c431368c7ec2d129da6ab0eba"
  license "MIT"

  depends_on :macos

  on_macos do
    depends_on macos: :sonoma
  end

  def install
    bin.install "fxcodex-universal-apple-darwin" => "fxcodex"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fxcodex version").strip
  end
end

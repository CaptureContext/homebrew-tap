class Skillrack < Formula
  desc "Install, link, and inspect shared agent skills"
  homepage "https://github.com/CaptureContext/skillrack"
  url "https://github.com/CaptureContext/skillrack/releases/download/0.0.0/skillrack-universal-apple-darwin"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
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

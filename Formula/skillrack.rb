class Skillrack < Formula
  desc "Install, link, and inspect shared agent skills"
  homepage "https://github.com/CaptureContext/skillrack"
  url "https://github.com/CaptureContext/skillrack/releases/download/0.1.1/skillrack-universal-apple-darwin"
  sha256 "e942a0253e1e14724d48c4fe22ea178a9dc5b0cba08734bdb1a96a372cce1861"
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

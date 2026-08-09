class Mutantkit < Formula
  desc "Trustworthy mutation testing for Swift and Apple platforms"
  homepage "https://github.com/juntaki/mutantkit"
  url "https://github.com/juntaki/mutantkit/releases/download/v0.1.0-alpha.1/mutantkit-macos-arm64.tar.gz"
  sha256 "32e041eff48af329edea1fd69b49339382c5890b7041556fae2af4f0022782d7"
  version "0.1.0-alpha.1"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "mutantkit"
    prefix.install "LICENSE"
  end

  test do
    assert_match "mutantkit #{version}", shell_output("#{bin}/mutantkit --version")
  end
end

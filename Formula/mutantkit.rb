class Mutantkit < Formula
  desc "Trustworthy mutation testing for Swift and Apple platforms"
  homepage "https://github.com/juntaki/mutantkit"
  url "https://github.com/juntaki/mutantkit/releases/download/v0.1.0/mutantkit-macos-arm64.tar.gz"
  sha256 "27226988ef5e9a58ed93904fd767b341976a432fe1bebcc6526c1cabade2cd3e"
  version "0.1.0"
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

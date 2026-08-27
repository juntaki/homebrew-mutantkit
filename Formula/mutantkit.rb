class Mutantkit < Formula
  desc "Trustworthy mutation testing for Swift and Apple platforms"
  homepage "https://github.com/juntaki/mutantkit"
  url "https://github.com/juntaki/mutantkit/releases/download/v0.2.0/mutantkit-macos-arm64.tar.gz"
  version "0.2.0"
  sha256 "3a314b4213afe3dd706d6dd5d7e5f9308eda81a19ecf8fab6d3a09be08b9d7fc"
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

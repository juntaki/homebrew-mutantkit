require "json"

class Mutantkit < Formula
  desc "Trustworthy mutation testing for Swift and Apple platforms"
  homepage "https://github.com/juntaki/mutantkit"
  url "https://github.com/juntaki/mutantkit/releases/download/v1.0.2/mutantkit-macos-arm64.tar.gz"
  version "1.0.2"
  sha256 "64faf2097ea93136f3db3c14125e7b638c4110250583eac2909c4249635bc097"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/juntaki/homebrew-mutantkit/releases/download/v1.0.2"
    sha256 cellar: :any_skip_relocation, all: "c9e071bd0139366a42b402495a6b97d57a4546770493aecab3b10343cb622303"
  end

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "mutantkit"
    # The running binary resolves its bundled schemata runtime relative to
    # its own real, symlink-resolved directory as
    # "<that directory>/lib/mutantkit/schemata" (MutantKitInstallLocation /
    # SchemataRuntimeLibraryLocator in the main repo -- deliberately
    # anchored this way so a `$PATH` symlink install, like this formula's
    # own `bin/mutantkit -> ../Cellar/mutantkit/<version>/bin/mutantkit`,
    # still resolves against the real Cellar keg directory once the
    # symlink is followed, not the symlink's own parent). The release
    # tarball's own layout already places `mutantkit` and `lib/` as
    # siblings for exactly this reason -- installing `lib` into `bin`
    # (not the more conventional `prefix/lib`) preserves that same sibling
    # relationship inside the keg. A formula that installs only the binary
    # (as this one did through v0.2.0) leaves every schemata-strategy run
    # unable to find its runtime at all.
    bin.install "lib"
    prefix.install "LICENSE"
  end

  test do
    assert_match "mutantkit #{version}", shell_output("#{bin}/mutantkit --version")

    # v0.2.0's formula installed only the binary + LICENSE, silently
    # dropping the bundled schemata runtime tree -- caught only because
    # this smoke test checks for it explicitly, the same gap a
    # `--version`-only test would keep missing. Checks the exact layout
    # `SchemataRuntimeLibraryLocator.locateBundled` requires, not just
    # that the manifest file happens to exist somewhere.
    manifest_path = bin/"lib/mutantkit/schemata/manifest.json"
    assert_path_exists manifest_path,
      "bundled schemata runtime manifest missing at #{manifest_path} -- " \
      "`mutantkit run` with execution.strategy: schemata would fail closed " \
      "with \"no bundled schemata runtime manifest\" for every user of this install"

    manifest = JSON.parse(manifest_path.read)
    assert manifest.key?("runtimeABIVersion"), "unexpected schemata runtime manifest shape: #{manifest.keys}"
    archived_platforms = manifest.fetch("archives", []).map { |entry| entry["platform"] }
    %w[macosx iphonesimulator].each do |platform|
      assert_includes archived_platforms, platform, "schemata runtime manifest is missing the #{platform} archive"
      archive_path = manifest["archives"].find { |entry| entry["platform"] == platform }["path"]
      assert_path_exists bin/"lib/mutantkit/schemata/#{archive_path}"
    end
  end
end

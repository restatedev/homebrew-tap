class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7908d83faf5dbfda7af7212978ac4c6d3b8807ad42632dbaa420afaa2ae05c9f"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3db5fd2b894c63a40bc3e03d8d684b84e80409bb142c0a39cc634eace7cfcba0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9c0c19c8240f80fc6c020a14defe303752f257656b03f4fd5841fa290e32a090"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.2/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "bd5b0b9fba2cef53f9789d688a3dc8756dfd87d1f4cb20dc7b6beeb981d5ad21"
    end
  end
  license "BUSL-1.1"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "restate" if OS.mac? && Hardware::CPU.arm?
    bin.install "restate" if OS.mac? && Hardware::CPU.intel?
    bin.install "restate" if OS.linux? && Hardware::CPU.arm?
    bin.install "restate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

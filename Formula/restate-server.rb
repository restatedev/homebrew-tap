class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.0/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "2edc1ec20254557db3329446f3f661f0dac323a12eb709f3f031852b823c2501"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.0/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "ca14d89be7375dd5aa3924d56e97390a5229da2d28a7669bf1ddd8f90c9b111a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.0/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "73b3d7be5b9e3ee078ec6a388ab78e253f7cafc0b96363c9142a4991ff5fdc43"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.0/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b1f0ed429b62921e0155fe1d69f4114af8f7df4995a89e722362a116da40fa57"
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
    bin.install "restate-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.mac? && Hardware::CPU.intel?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

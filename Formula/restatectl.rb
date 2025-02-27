class Restatectl < Formula
  desc "Restate administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.1/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "b8164d2a607ea8a52d0190edcc72c9bcf4dc18c69a57be1d545a2acb84bace66"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.1/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "b21d23e0541c8e79842bb6e73d1508010d8a398b224df7a7bfb2605016a106fc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.1/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "4a151290dcdb558d48d70314093308037c79542c76cd0b7ea830a19f0c83c9b6"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.1/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "90b360272185754878566fddd2e38dc0b8ce19f1925be14848bb62a8702820b3"
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
    bin.install "restatectl" if OS.mac? && Hardware::CPU.arm?
    bin.install "restatectl" if OS.mac? && Hardware::CPU.intel?
    bin.install "restatectl" if OS.linux? && Hardware::CPU.arm?
    bin.install "restatectl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

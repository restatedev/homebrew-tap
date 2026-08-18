class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.4/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "c75816be96d87e0948cb02ce5798088c7df36b6981532e7c8f62d5a36358f472"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.4/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "2127cbb439daeae4255b7fd868a113ec2aa1ff9212cd465c0958468daf8eb041"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.4/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d953565d92b32cc6edda4d99b0138ebc57b75676e54f332c9a8784174e3c842f"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.4/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "6c9f0f879d387429d9bed84a50212b491605e1bf415550654f3fa5cbfbfbb70f"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "restatectl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restatectl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restatectl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restatectl"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

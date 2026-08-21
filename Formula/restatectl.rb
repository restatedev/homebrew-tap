class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.6/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "ea360e142bf2c80962c3d412d469b19b3f6c344c3cc2362503b672bdcb2dc6cc"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.6/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "3245ced635051e0d29ced0b9d6091648b7a126b3fc08a39a728797f03a0892eb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.6/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "2ba97ca41b77ffb5d632e08dcde6c008206a57adb42e350b8435d709ca49061e"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.6/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ee0d60730f84ea8fc6a5fe2d1942da65644966505d4b46dacac78ca1570f8300"
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

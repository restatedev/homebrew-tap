class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.14/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "6a3de949bcadfa6ac239c8192929ad65aaa70c577c2422ffc63acf3c55d5c032"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.14/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "ff8c12f87c3cab533e0e82d4f041bf0646260f7e1317a5476cf846ac6eb95108"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.14/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5d90726189089955719a0bd445837f89c54b7ee44b1836d24059759a8a8b27d9"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.14/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5d6199c0506b979eef19efee004499b628c54ed593b01c12b9d89c2cbbdb0637"
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
      bin.install "restate-server"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restate-server"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restate-server"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restate-server"
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

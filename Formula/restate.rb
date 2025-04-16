class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.1/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "172ba59ff030e23190504732f8c738406901e998b74f630f293a7440427a4e8f"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.1/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f41126ec945862d23b99d9a0a7c4b8963f28f5c95ace0e4b9a36efb5aae864a5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.1/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "35df2af5e15cf510f8638821773267a9ef40c76fa52ff7a733da7c9449497928"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.1/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "3631d9f3238b7067a4778cf0a3059f66dd2e27200834a717d64f4a2ac56ddcca"
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

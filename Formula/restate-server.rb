# This file is autogenerated; see release/restate.rb.tmpl

class RestateServer < Formula
  version '0.9.0'
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"

  arch = Hardware::CPU.arch.to_s
  if OS.mac?
      if Hardware::CPU.arm?
          url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.aarch64-apple-darwin.tar.gz"
          sha256 "49c546b42f52260f8fc0efa2d8cbd46f192113294e365107c6bc0cf58e8595e2"
      else
          url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.x86_64-apple-darwin.tar.gz"
          sha256 "0e527a6f225bb681c44407a0bf4d7a665c4a994fd33bbfdfbc9586d11775ecd7"
      end
  elsif OS.linux?
     if Hardware::CPU.arm?
         url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.aarch64-unknown-linux-musl.tar.gz"
         sha256 "e4f6271bd7e78ed004f8e25f7aa852d0ec5e29d1177c8805d997e4c38533674d"
     else
         url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.x86_64-unknown-linux-musl.tar.gz"
         sha256 "a116d316e6f4e12e43d68fc77b2be93fd2d18462057f562a2c4a160e9eafb5e4"
     end
  end

  def install
    bin.install "restate-server"
  end

  test do
    shell_output("restate-server -V")
  end
end

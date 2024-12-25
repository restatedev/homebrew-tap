# This file is autogenerated; see release/restate.rb.tmpl

class Restate < Formula
  version '1.1.6'
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"

  arch = Hardware::CPU.arch.to_s
  if OS.mac?
      if Hardware::CPU.arm?
          url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.aarch64-apple-darwin.tar.gz"
          sha256 "9c12a7e1a9c81c198106da758b0348df57e559a3b515f45c869a02455510b981"
      else
          url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.x86_64-apple-darwin.tar.gz"
          sha256 "94f66ad29200f7d561e6e23783f2e7c9e8b52eb89dd618238a612a54ee82939a"
      end
  elsif OS.linux?
     if Hardware::CPU.arm?
         url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.aarch64-unknown-linux-musl.tar.gz"
         sha256 "fd2ac5231197e03938105dd474879a7667aa0b6cbc9b38d5cf0b65bc257954a3"
     else
         url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.x86_64-unknown-linux-musl.tar.gz"
         sha256 "ff38e092e8091321c3734244a2170e13802829a29874b877e53ddfaa10069ebb"
     end
  end

  def install
    bin.install "restate"
  end

  test do
    shell_output("restate -V")
  end
end

# This file is autogenerated; see release/restate.rb.tmpl

class Restate < Formula
  version '0.6.0'
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"

  arch = Hardware::CPU.arch.to_s
  if OS.mac?
      if Hardware::CPU.arm?
          url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.aarch64-apple-darwin.tar.gz"
          sha256 "e241be6e4bc1fd239f6512fdfec6c884b3ed5e52f6b943018eca62a0dc833118"
      else
          url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.x86_64-apple-darwin.tar.gz"
          sha256 "258a79bdc900fb829f681fbd5a5c75124d206b22f1671e9c38e448064f9da9a2"
      end
  elsif OS.linux?
     if Hardware::CPU.arm?
         url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.aarch64-unknown-linux-gnu.tar.gz"
         sha256 "d01f8b1eafbf5be857e3a0daf48d900db59ce4342198a2d5ed8e96936fe39547"
     else
         url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.x86_64-unknown-linux-gnu.tar.gz"
         sha256 "44000b849cb5eb62ed9f158222e293bf5de18ae00417108606144d463b9f225f"
     end
  end

  def install
    bin.install "restate"
  end

  test do
    shell_output("restate -V")
  end
end

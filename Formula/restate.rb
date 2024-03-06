# This file is autogenerated; see release/restate.rb.tmpl

class Restate < Formula
  version '0.8.1'
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"

  arch = Hardware::CPU.arch.to_s
  if OS.mac?
      if Hardware::CPU.arm?
          url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.aarch64-apple-darwin.tar.gz"
          sha256 "20a958e1db64a1c98664c644689c2ac3d6fd5eed1c02a730e7b6758ba8365cca"
      else
          url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.x86_64-apple-darwin.tar.gz"
          sha256 "3633d97358828a77c8d14bce99ba34cab167481abe23c42f5501c783794bf044"
      end
  elsif OS.linux?
     if Hardware::CPU.arm?
         url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.aarch64-unknown-linux-musl.tar.gz"
         sha256 "583a6318d5b7f69d9e36af67955c5c4e0d5cd7b33ca199d59078695d69e0ced9"
     else
         url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.x86_64-unknown-linux-musl.tar.gz"
         sha256 "28e5ebc540d16632db9c8596277dd0853d2052174a3d7338fd8d525633a4d1b6"
     end
  end

  def install
    bin.install "restate"
  end

  test do
    shell_output("restate -V")
  end
end

# This file is autogenerated; see release/restate.rb.tmpl

class RestateServer < Formula
  version '1.0.1'
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"

  arch = Hardware::CPU.arch.to_s
  if OS.mac?
      if Hardware::CPU.arm?
          url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.aarch64-apple-darwin.tar.gz"
          sha256 "ebe5c722fce287e128053609d48a8277a66c360668658040fff99ceb4cb83c52"
      else
          url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.x86_64-apple-darwin.tar.gz"
          sha256 "bac7ce6fadb561f2fe7963b67014106a4083ff055e60e9048c240dbbd7efc0e0"
      end
  elsif OS.linux?
     if Hardware::CPU.arm?
         url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.aarch64-unknown-linux-musl.tar.gz"
         sha256 "56a7bb26cf5dfb58a54bd0644d0d3023a727102d2205bd5a399554ae1fad489d"
     else
         url "https://github.com/restatedev/restate/releases/download/v#{version}/restate.x86_64-unknown-linux-musl.tar.gz"
         sha256 "4c0bd26f77ac9360412e38a96ce4c9c6586d2a362eca142a7f28644fb38417f9"
     end
  end

  def install
    bin.install "restate-server"
  end

  test do
    shell_output("restate-server -V")
  end
end

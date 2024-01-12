set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

version=$(curl --silent --location --fail https://api.github.com/repos/restatedev/restate/releases/latest | grep '^  "name"' | awk '{print $2}' | tr -d '"v,')
darwin_x86=$(curl --silent --location --fail "https://github.com/restatedev/restate/releases/download/v${version}/restate.x86_64-apple-darwin.tar.gz" | sha256sum | awk '{print $1}')
darwin_arm64=$(curl --silent --location --fail "https://github.com/restatedev/restate/releases/download/v${version}/restate.aarch64-apple-darwin.tar.gz" | sha256sum | awk '{print $1}')
linux_x86=$(curl --silent --location --fail "https://github.com/restatedev/restate/releases/download/v${version}/restate.x86_64-unknown-linux-musl.tar.gz" | sha256sum | awk '{print $1}')
linux_arm64=$(curl --silent --location --fail "https://github.com/restatedev/restate/releases/download/v${version}/restate.aarch64-unknown-linux-musl.tar.gz" | sha256sum  | awk '{print $1}')

export version darwin_x86 darwin_arm64 linux_x86 linux_arm64

BINARY=restate DESC=CLI envsubst < "${SCRIPT_DIR}/restate.rb.tmpl" > "${SCRIPT_DIR}/../Formula/restate.rb"
BINARY=restate-server DESC=Server envsubst < "${SCRIPT_DIR}/restate.rb.tmpl" > "${SCRIPT_DIR}/../Formula/restate-server.rb"

git -C "${SCRIPT_DIR}/.." reset
git -C "${SCRIPT_DIR}/.." add "Formula/restate.rb"
git -C "${SCRIPT_DIR}/.." add "Formula/restate-server.rb"

if git diff --cached --exit-code; then
  echo "Nothing to commit"
else
  git -C "${SCRIPT_DIR}/.." commit -m "Update to ${version}"
fi

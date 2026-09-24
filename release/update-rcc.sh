#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
release=$(gh api --paginate repos/restatedev/restate-cloud/releases | jq -s '
  add
  | map(select(.draft == false and .prerelease == false and (.tag_name | startswith("rcc-v"))))
  | first
')
tag=$(jq -r '.tag_name // empty' <<<"$release")

if [[ -z "$tag" ]]; then
  echo "No stable rcc release found"
  exit 0
fi

version=${tag#rcc-v}
base_url="https://github.com/restatedev/restate-cloud/releases/download/${tag}"
darwin_x86=$(curl --silent --location --fail "${base_url}/rcc-x86_64-apple-darwin.tar.gz" | sha256sum | awk '{print $1}')
darwin_arm64=$(curl --silent --location --fail "${base_url}/rcc-aarch64-apple-darwin.tar.gz" | sha256sum | awk '{print $1}')
linux_x86=$(curl --silent --location --fail "${base_url}/rcc-x86_64-unknown-linux-gnu.tar.gz" | sha256sum | awk '{print $1}')
linux_arm64=$(curl --silent --location --fail "${base_url}/rcc-aarch64-unknown-linux-gnu.tar.gz" | sha256sum | awk '{print $1}')

export version darwin_x86 darwin_arm64 linux_x86 linux_arm64
envsubst <"${script_dir}/rcc.rb.tmpl" >"${script_dir}/../Formula/rcc.rb"

git -C "${script_dir}/.." add Formula/rcc.rb

if git -C "${script_dir}/.." diff --cached --exit-code; then
  echo "rcc is already at ${version}"
else
  git -C "${script_dir}/.." commit -m "Update rcc to ${version}"
fi

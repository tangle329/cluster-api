#!/usr/bin/env bash
# Copyright 2019 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# set -o errexit
set -o nounset
set -o pipefail

OS="unknown"
if [[ "${OSTYPE}" == "linux"* ]]; then
  OS="linux"
elif [[ "${OSTYPE}" == "darwin"* ]]; then
  OS="darwin"
fi

# shellcheck source=./hack/utils.sh
source "$(dirname "$0")/utils.sh"
ROOT_PATH=$(get_root_path)

# create a temporary directory
TMP_DIR=$(mktemp -d)

# cleanup on exit
cleanup() {
  echo "Cleaning up..."
  rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

# install shellcheck (x64 only!)
cd "${TMP_DIR}" || exit
VERSION="shellcheck-v0.7.0"
DOWNLOAD_FILE="${VERSION}.${OS}.x86_64.tar.xz"
curl https://storage.googleapis.com/shellcheck/"${DOWNLOAD_FILE}" -O ${DOWNLOAD_FILE}
tar xf "${DOWNLOAD_FILE}"
cd "${VERSION}" || exit

echo "Running shellcheck..."
cd "${ROOT_PATH}" || exit
OUT="${TMP_DIR}/out.log"
IGNORE_FILES=$(find . -name "*.sh" | grep third_party)
echo "Ignoring shellcheck on ${IGNORE_FILES}"
FILES=$(find . -name "*.sh" | grep -v third_party)
while read -r file; do
    "${TMP_DIR}/${VERSION}/shellcheck" -x "$file" >> "${OUT}" 2>&1
done <<< "$FILES"

if [[ -s "${OUT}" ]]; then
  echo "Found errors:"
  cat "${OUT}"
  exit 1
fi

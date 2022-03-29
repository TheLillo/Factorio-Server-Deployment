#!/bin/sh
set -o nounset                              # Treat unset variables as an error
export HCLOUD_TOKEN="$(pass show Services/hetzner/api_token || true)"
terraform $@

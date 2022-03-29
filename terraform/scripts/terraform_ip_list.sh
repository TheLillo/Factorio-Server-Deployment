#!/bin/sh

set -eu

get_machine_ip_hcloud() {
    jq -r '.resources[] |
        select(.type == "hcloud_server") |
        .instances[].attributes          |
        select(.name == "'"$1"'")        |
        .ipv4_address' \
        <"terraform.tfstate"
}

IP=$(get_machine_ip_hcloud "factorio")

printf "%12s\n" "$IP"

# Use Hetzer plugin
terraform {
  required_providers {
    hcloud = {
      source = "terraform-providers/hcloud"
    }
  }
  required_version = ">= 0.13"
}

## SSH
# SSH key to the server And read configuration from filAnd read configuration from file

data "http" "get_ssh_keys" {
  url = yamldecode(file("$path.module/../../configuration.yml"))["terraform"]["git_ssh_keys"]
}

resource "hcloud_ssh_key" "deploy_ssh_keys" {
  for_each = toset ( split("\n", trim( data.http.get_ssh_keys.body, "\n" ) ) )
  name       = each.key
  public_key = each.value
}

locals {
    ssh_keys = [
        for k,v in hcloud_ssh_key.deploy_ssh_keys: k if k != ""
    ]
}

# Factorio Headless Server configuration 
resource "hcloud_server" "factorio" {
    name = "factorio"
    image = "debian-11"
    server_type = "cpx11"
    location = "fsn1"
    ssh_keys = local.ssh_keys
}

#!/bin/sh

set -o nounset                              # Treat unset variables as an error

summon_terraform(){
    git_url_keys=$(grep git_ssh_keys configuration.yml | awk '{ print $2 }' | tr -d '"') 

    cd terraform/

    git_ssh_keys=$(curl --fail-early "$git_url_keys")

    if [[ -z $(echo -ne "$git_ssh_keys") ]] ; then
      echo -e  "Please put your public ssh keys on github.com or gitlab.com"
      exit 1
    fi

    # Link Terraform tf file base on backend now only Hetzner is support
    ln -sf "backends/hetzner.tf" cloud.tf

    # Init Terraform if required
    [ -d ./.terraform ] || terraform init

    ./scripts/run_terraform_pass.sh apply

    cd -
}

summon_ansible() {
  machine_ip=$(cd terraform && ./scripts/terraform_ip_list.sh && cd ..)

  cd ansible/

  sed -i "s/ansible_host: .*$/ansible_host: $machine_ip/g" production.yml

  ansible-playbook -i production.yml site.yml

  cd -
}

echo -e "[ ] Summoning Terraform"
summon_terraform
echo -e "It seems that Terraform is happy with your configuration!"

echo -e "[ ] Summoning Ansible"

summon_ansible
echo -e "It seems that Ansible is happy with your configuration!"

## Factorio Server Deployment

This project simplifies the deployment of [Factorio](https://www.factorio.com/) headless server with a modern approach (IaC). \
More information about the installation are provide in [Factorio official wiki](https://wiki.factorio.com/Multiplayer).

Up to now only [Hetzner Cloud](https://www.hetzner.com/cloud) is supported for deployment. I encourage all people to submit other cloud provider module for Terraform.

You will deploy Factorio server on Debian Bullseye. \
If you want to change os you need to modify `Factorio-Server-Deployment/terraform/backends/hetzner.tf` file inside backend folder. \
In this release I use a CPX11(2vCPU 2GB RAM) as default VM but you can modify it on `Factorio-Server-Deployment/terraform/backends/hetzner.tf`. \
### Install Dependencies
To run this project you need some other software:
#### Arch Linux
` # pacman -S gnupg pass ansible terraform`

### How it work
First of all you need to create a empty project on [Hetzner Cloud](https://www.hetzner.com/cloud)   and get the private API Token. \
After this phase you need to save the Token they provide in your [pass](https://www.passwordstore.org) store. Follow [pass](https://www.passwordstore.org) instructions to have a secure store for your API Token. \
`$ pass insert Services/hetzner/api_token`
If you have a saved game to upload to the server you need to copy inside the project folder `Factorio-Server-Deployment` the zip file. \
After you need to insert the zip name inside the `Factorio Server Deployment/configuration.yml` under ansible keyword. \
To push the configuration on the remote server you need to set ssh key. You need to insert inside the `Factorio-Server-Deployment/configuration.yml` under terraform keyword the url of your ssh public key for your github.com or gitlab.com account. \
Inside `Factorio-Server-Deployment/ansible/roles/factorio/files`  is present the `server-settings.json` you need to personalize this file to ensure, for example, the password for your game. \
Now you have everything you need to run `factorio_deploy.sh` script.


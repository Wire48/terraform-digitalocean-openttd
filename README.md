# openttd

contained in this repository is deployment of openttd dedicated server in
digital ocean droplets

## How it works

- The code uses terraform to create some infrastructure in digital ocean
- During droplet creation the contents of files/cloud-config.yaml
  is injected in to the config
- The cloud-init script will configure the server by downloading the
  version of openttd and ensuring it is installed.
- It will also configure the filesystem on the persistant external volume
  and ensure that the filesystem is symlinked in to the places it is requred
- configuration changes (to cloud-config.yaml) will result in the server
  being destroyed and recreated. Will be no data loss as the deployment is
  configured to store all persistant data on an external hard disk
- Once the server has been deployed for the first time the configuration
  for openttd will be applied from the cloud-config.yaml. This configuration
  should be safe to modify provided the instance is not re-provisioned.
  Re-provisioning the instance will cause your changes to be overwirtten.
- Finally the terraform will create a DNS record in cloudflare.
  It is quite common for public ip addresses to change on digital ocean

## Maintenance

- To update the openttd version the new download url need to be put in to
  `files/cloud-config.yaml` inside the openttd-update.sh script.
- The cloud-config.yaml will ensure all packages are upgraded on deployment
  but will not explicitly configure unattended-upgrades. 

## Variables

| Name            | Description                   | Default |
|-----------------|-------------------------------|---------|
| do_token        | Api token for digital ocean   | none    |
| cf_token        | Api token for cloudflare      | none    |
| cf_zone         | Zone to register server in    | none    |
| cf_host         | Hostname to create in zone    | openttd |
| server_password | Password to access the server | none    |
| rcon_password   | Password to admin the server  | none    |

## Outputs

| Name     | Description                   |
|----------|-------------------------------|
| ipv4     | Public IPv4 of created server |

## Development 

- Configure unattended upgrades
- Configure iptables
- Preserve local configuration changes

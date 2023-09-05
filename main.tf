

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.29.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.13.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cf_token
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "ssh" {
  name       = var.ssh_key_name
  public_key = file(var.ssh_key_location)
}

resource "digitalocean_vpc" "openttdnet" {
  name     = "openttdnet"
  region   = "lon1"
  ip_range = "10.10.10.0/24"
}

resource "digitalocean_volume" "data" {
  region      = "lon1"
  name        = "data"
  size        = 1
  description = "openttd-data"
}

resource "digitalocean_droplet" "openttd" {
  image    = "debian-12-x64"
  name     = "openttd"
  region   = "lon1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.ssh.fingerprint]
  user_data = templatefile("${path.module}/files/cloud-config.yaml", {
    SERVER_PASSWORD = var.server_password
    RCON_PASSWORD   = var.rcon_password
  })
  vpc_uuid = digitalocean_vpc.openttdnet.id
}

resource "digitalocean_volume_attachment" "openttd-data" {
  droplet_id = digitalocean_droplet.openttd.id
  volume_id  = digitalocean_volume.data.id
}

resource "cloudflare_record" "openttd" {
  zone_id = var.cf_zone
  name    = var.cf_host
  value   = digitalocean_droplet.openttd.ipv4_address
  type    = "A"
  ttl     = 60
  proxied = false
}

resource "digitalocean_project" "openttd" {
  name        = "openttd"
  description = "OpenTTD Dedicated Server at openttd.wire48.net"
  purpose     = "Web Application"
  environment = "Development"
  resources   = [digitalocean_droplet.openttd.urn, digitalocean_volume.data.urn]
}

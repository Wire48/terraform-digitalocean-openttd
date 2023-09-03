

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

resource "digitalocean_ssh_key" "yubikey" {
  name       = "Yubikey"
  public_key = file("/home/jpw/.ssh/id_yubikey_464.pub")
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
  image     = "debian-12-x64"
  name      = "openttd"
  region    = "lon1"
  size      = "s-1vcpu-1gb"
  ssh_keys  = [digitalocean_ssh_key.yubikey.fingerprint]
  user_data = file("${path.module}/files/cloud-config.yaml")
  vpc_uuid  = digitalocean_vpc.openttdnet.id
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

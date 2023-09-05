variable "do_token" {
  type        = string
  description = "Digital ocean access token"
}

variable "cf_token" {
  type        = string
  description = "Cloudflare access token"
}

variable "cf_zone" {
  type        = string
  description = "Cloudflare zone"
}

variable "cf_host" {
  type        = string
  default     = "openttd"
  description = "Host within cloudflare zone"
}

variable "server_password" {
  type        = string
  default     = ""
  description = "Server Password"
}

variable "rcon_password" {
  type        = string
  default     = ""
  description = "Server Rcon Password"
}

variable "ssh_key_location" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to public ssh key used to access the server"
}

variable "ssh_key_name" {
  type        = string
  default     = "openttd-ssh-key"
  description = "Name of SSH key to create in digitalocean"
}

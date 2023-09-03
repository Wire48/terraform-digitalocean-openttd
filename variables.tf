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

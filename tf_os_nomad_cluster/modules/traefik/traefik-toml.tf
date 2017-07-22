data "template_file" "traefik-toml" {

  template = <<EOF
################################################################
# Web configuration backend
################################################################
[web]
address = ":8080"

################################################################
# Consul KV configuration backend
################################################################

# Enable Consul KV configuration backend
#
# Optional
#
[consul]

# Consul server endpoint
#
# Required
#
endpoint = "$${consul_endpoint}"

# Enable watch Consul changes
#
# Optional
#
watch = true

# Prefix used for KV store.
#
# Optional
#
prefix = "traefik"

# Override default configuration template. For advanced users :)
#
# Optional
#
# filename = "consul.tmpl"

# Enable consul TLS connection
#
# Optional
#
# [consul.tls]
# ca = "/etc/ssl/ca.crt"
# cert = "/etc/ssl/consul.crt"
# key = "/etc/ssl/consul.key"
# insecureskipverify = true

################################################################
# Consul Catalog configuration backend
################################################################

# Enable Consul Catalog configuration backend
#
# Optional
#
[consulCatalog]

# Consul server endpoint
#
# Required
#
endpoint = "$${consul_endpoint}"

# Default domain used.
#
# Optional
#
domain = "consul.localhost"

# Prefix for Consul catalog tags
#
# Optional
#
prefix = "traefik"

EOF

vars {
  consul_endpoint = "${ var.consul_endpoint }"
}

}

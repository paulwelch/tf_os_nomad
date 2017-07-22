variable "os_auth_url" {
  type = "string"

  description = <<EOF
OpenStack authentication URL for the API. NOTE: Some OS environments require /v3 in the URL to correctly identify API version.
EOF
}

variable "private_key_file" {
  type = "string"

  description = <<EOF
Path to private SSH key file to use for provisioning VM instances.
EOF
}

variable "region" {
  type = "string"

  description = <<EOF
OS Region ID.
EOF
}

variable "image_name" {
  type = "string"

  description = <<EOF
OS Image Name for VM instances.
EOF
}

variable "flavor_name" {
  type = "string"

  description = <<EOF
OS Flavor Name for VM instances.
EOF
}

variable "ssh_key_pair_name" {
  type = "string"

  description = <<EOF
Name of keypair to use for instance.
EOF
}

variable "security_group_ids" {
  type = "list"

  description = <<EOF
OS Security Groups ID's.
EOF
}

variable "network_id" {
  type = "string"

  description = <<EOF
OS Network ID.
EOF
}

variable "floatingip_pool" {
  type = "string"

  description = <<EOF
OpenStack floating IP pool name.
EOF
}

variable "env_name_prefix" {
  type = "string"

  description = <<EOF
Prefix for environment to use on OS names.  This allows you to create
more than one cluster with unique naming.
EOF
}

variable "consul_endpoint" {
  type = "string"

  description = <<EOF
Endpoint for consul, for example http://10.10.10.10:8500
EOF
}

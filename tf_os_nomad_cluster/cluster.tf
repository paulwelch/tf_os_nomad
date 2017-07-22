variable "os_auth_url" { }
variable "cluster_public_key_file" { }
variable "cluster_private_key_file" { }
variable "cluster_ssh_key_pair_name" { }
variable "nomad_bin_url" { }
variable "do_bootstrap" { }
variable "consul_endpoint" { }
variable "consul_join_params" { }
variable "cluster_size" { }
variable "region" { }
variable "image_name" { }
variable "flavor_name" { }
variable "security_group_ids" { type="list" }
variable "network_id" { }
variable "floatingip_pool" { }
variable "consul_version" { }
variable "env_name_prefix" { }

#####################################################################

module "nomad_cluster" {
  source = "./modules/nomad_cluster"

  public_key_file = "${ var.cluster_public_key_file }"
  private_key_file = "${ var.cluster_private_key_file }"
  ssh_key_pair_name = "${ var.cluster_ssh_key_pair_name }"
  os_auth_url = "${ var.os_auth_url }"
  do_bootstrap = "${ var.do_bootstrap }"
  consul_join_params = "${ var.consul_join_params }"
  nomad_bin_url = "${ var.nomad_bin_url }"
  cluster_size = "${ var.cluster_size }"
  region = "${ var.region }"
  image_name = "${ var.image_name }"
  flavor_name = "${ var.flavor_name }"
  security_group_ids = "${ var.security_group_ids }"
  network_id = "${ var.network_id }"
  consul_version = "${ var.consul_version }"
  env_name_prefix = "${ var.env_name_prefix }"
}

module "traefik" {
  source = "./modules/traefik"

  private_key_file = "${ var.cluster_private_key_file }"
  ssh_key_pair_name = "${ var.cluster_ssh_key_pair_name }"
  os_auth_url = "${ var.os_auth_url }"
  region = "${ var.region }"
  image_name = "${ var.image_name }"
  flavor_name = "${ var.flavor_name }"
  security_group_ids = "${ var.security_group_ids }"
  network_id = "${ var.network_id }"
  floatingip_pool = "${ var.floatingip_pool }"
  env_name_prefix = "${ var.env_name_prefix }"
  consul_endpoint = "${ var.consul_endpoint }"
}


#####################################################################

output "nomad_cluster_endpoints" {
  value = [ "${ module.nomad_cluster.endpoints }" ]
}

output "traefik_internal_endpoints" {
  value = [ "${ module.traefik.internal_endpoints }"]
}

output "traefik_public_endpoints" {
  value = [ "${ module.traefik.public_endpoints }"]
}

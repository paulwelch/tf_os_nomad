variable "os_auth_url" { }
variable "worker_public_key_file" { }
variable "worker_private_key_file" { }
variable "worker_ssh_key_pair_name" { }
variable "nomad_bin_url" { }
variable "consul_join_params" { }
variable "nomad_servers" { }
variable "worker_count" { }
variable "region" { }
variable "image_name" { }
variable "flavor_name" { }
variable "security_group_ids" { type="list" }
variable "network_id" { }
variable "consul_version" { }
variable "env_name_prefix" { }

#####################################################################

module "nomad_worker" {
  source = "./modules/nomad_worker"

  public_key_file = "${ var.worker_public_key_file }"
  private_key_file = "${ var.worker_private_key_file }"
  os_auth_url = "${ var.os_auth_url }"
  consul_join_params = "${ var.consul_join_params }"
  nomad_servers = "${ var.nomad_servers }"
  worker_count = "${ var.worker_count }"
  region = "${ var.region }"
  image_name = "${ var.image_name }"
  flavor_name = "${ var.flavor_name }"
  ssh_key_pair_name = "${ var.worker_ssh_key_pair_name }"
  nomad_bin_url = "${ var.nomad_bin_url }"
  security_group_ids = "${ var.security_group_ids }"
  network_id = "${ var.network_id }"
  consul_version = "${ var.consul_version }"
  env_name_prefix = "${ var.env_name_prefix }"
}

#####################################################################

output "nomad_worker_endpoints" {
  value = [ "${ module.nomad_worker.worker_endpoints }" ]
}

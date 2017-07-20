provider "openstack" {
  # assumes OS environment variables
  auth_url = "${ var.os_auth_url }"
}

resource "openstack_networking_port_v2" "nomad_ips" {
  count = "${ var.count }"
  name = "${ var.env_name_prefix }-nomad-${ count.index+1 }"
  security_group_ids = "${ var.security_group_ids }"
  network_id = "${ var.network_id }"
  admin_state_up = "true"

#  lifecycle {
#    create_before_destroy = true
#  }
}

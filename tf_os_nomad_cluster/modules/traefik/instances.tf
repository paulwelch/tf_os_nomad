provider "openstack" {
  # assumes OS environment variables
  auth_url = "${ var.os_auth_url }"
}

module "traefik_network" {
  source = "../network"

  os_auth_url = "${ var.os_auth_url }"
  count = "1"
  security_group_ids = "${ var.security_group_ids }"
  network_id = "${ var.network_id }"
  env_name_prefix = "${ var.env_name_prefix }"
  app_name = "traefik"
}

resource "openstack_compute_instance_v2" "traefik" {
  depends_on = [ "module.traefik_network" ]
  count = "1"
  name = "${ var.env_name_prefix }-traefik-${ count.index + 1 }"
  region = "${ var.region }"
  image_name = "${ var.image_name }"
  flavor_name = "${ var.flavor_name }"
  key_pair = "${ var.env_name_prefix}-${ var.ssh_key_pair_name }"

  network {
    port = "${ module.traefik_network.ports[count.index] }"
  }

  connection {
    agent = "true"
    type = "ssh"
    host = "${ module.traefik_network.all_fixed_ips[count.index] }"
    user = "core"
    private_key = "${ file(var.private_key_file) }"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/core/traefik"
    ]
  }

  provisioner "file" {
    content = "${ data.template_file.traefik-toml.rendered }"
    destination = "/home/core/traefik/traefik.toml"
  }

  user_data = "${ data.template_file.traefik-cloud-config.rendered }"
}

resource "openstack_compute_floatingip_v2" "traefik_public_ip" {
  pool = "${ var.floatingip_pool }"
}

resource "openstack_compute_floatingip_associate_v2" "traefik_public_ip" {
  floating_ip = "${openstack_compute_floatingip_v2.traefik_public_ip.address}"
  instance_id = "${ openstack_compute_instance_v2.traefik.id }"
}

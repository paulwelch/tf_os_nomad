provider "openstack" {
  # assumes OS environment variables
  auth_url = "${ var.os_auth_url }"
}

resource "openstack_networking_port_v2" "ips" {
  count = "${ var.worker_count }"
  name = "${ var.env_name_prefix }-nomad-${ count.index+1 }"
  security_group_ids = "${ var.security_group_ids }"
  network_id = "${ var.network_id }"
  admin_state_up = "true"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name = "${ var.env_name_prefix}-${ var.ssh_key_pair_name }"
  public_key = "${ file(var.public_key_file) }"
}

resource "openstack_compute_instance_v2" "nomad_cluster" {
  count = "${ var.worker_count }"
  name = "${ var.env_name_prefix }-nomad-wrk-${ count.index + 1 }"
  region = "${ var.region }"
  image_name = "${ var.image_name }"
  flavor_name = "${ var.flavor_name }"
  key_pair = "${ var.env_name_prefix }-${ var.ssh_key_pair_name }"

  network {
    port = "${ element(openstack_networking_port_v2.ips.*.id, count.index) }"
  }

  connection {
    agent = "true"
    type = "ssh"
    host = "${ element(openstack_networking_port_v2.ips.*.all_fixed_ips.0, count.index) }"
    user = "core"
    private_key = "${ file(var.private_key_file) }"
  }

  provisioner "file" {
//    content = "${ data.template_file.worker-config.*.rendered[count.index] }"
    content = "${ data.template_file.worker-config.rendered }"
    destination = "/tmp/worker.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /etc/nomad",
      "sudo mv /tmp/worker.conf /etc/nomad/",
      "sudo chown -R root /etc/nomad",
      "curl -s ${var.nomad_bin_url} > /tmp/nomad.zip",
      "sudo mkdir -p /var/lib/nomad/data",
      "sudo mkdir -p /opt/bin",
      "sudo unzip /tmp/nomad.zip -d /opt/bin/",
      "sudo systemctl start nomad"
    ]
  }

  //user_data = "${ element(data.template_file.cloud-config.*.rendered, count.index) }"
  user_data = "${ data.template_file.cloud-config.rendered }"
}

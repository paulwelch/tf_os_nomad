data "template_file" "server-config" {
  count = "${ var.cluster_size }"

  template = <<EOF
bind_addr = "0.0.0.0" # the default

data_dir  = "/var/lib/nomad"

advertise {
  # Defaults to the node's hostname. If the hostname resolves to a loopback
  # address you must manually configure advertise addresses.
  http = "$${host_addr}"
  rpc  = "$${host_addr}"
  serf = "$${host_addr}"
}

server {
  enabled = true
}

consul {
  address = "$${host_addr}:8500"
}
EOF

  vars {
    cluster_size = "${ var.cluster_size }"
    host_addr = "${ module.nomad_network.all_fixed_ips[count.index] }"
  }
}

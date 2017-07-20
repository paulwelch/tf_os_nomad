data "template_file" "worker-config" {
// switch to this method once interpolation works or local vars feature is available
//  count = "${ var.worker_count }"


  template = <<EOF
bind_addr = "0.0.0.0" # the default

data_dir  = "/var/lib/nomad"

advertise {
  # Defaults to the node's hostname. If the hostname resolves to a loopback
  # address you must manually configure advertise addresses.
  http = "$COREOS_PRIVATE_IPV4"
  rpc  = "$COREOS_PRIVATE_IPV4"
  serf = "$COREOS_PRIVATE_IPV4"

  #do this after interpolation issue is fixed
  #http = "$ $ {host_addr}"
  #rpc  = "$ $ {host_addr}"
  #serf = "$ $ {host_addr}"
}

consul {
  #do this after interpolation issue is fixed
  #address = "$ $ {host_addr}:8500"
  address = "$COREOS_PRIVATE_IPV4"
}

client {
    enabled = true
    # A list of Nomad servers to connect to. You only need one running server for this to work
    # Keep port 4647, but replace with the IP of the Nomad server
    #servers = ["127.0.0.1:4647"]

    # Use this option at your own discretion. Setting docker.cleanup.image to false means Nomad won't remove
    # images that tasks have used when they are stopped. This is good for when your images won't change and
    # you don't need to pull changes from the docker repo every time.
    options {
      "docker.cleanup.image" = "false"
    }
}
EOF

  vars {
    // switch to this method once interpolation works or local vars feature is available
    //host_addr = "${ element(openstack_networking_port_v2.ips.*.all_fixed_ips[0], count.index) }"
  }
}

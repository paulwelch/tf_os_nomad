data "template_file" "cloud-config" {
// switch to this method once interpolation works or local vars feature is available
//  count = "${ var.worker_count }"

  template = <<EOF
#cloud-config

---
coreos:
  update:
    reboot-strategy: "off"
  units:
    - name: 00-eth0.network
      runtime: true
      content: |
        [Match]
        Name=eth0

        [Network]
        DHCP=yes
        DNS=127.0.0.1
        DNS=8.8.4.4

    - name: docker.service
      command: start

    - name: consul.service
      command: start
      content: |
        [Unit]
        Description=consul
        Requires=docker.service

        [Service]
        EnvironmentFile=-/etc/environment
        Restart=always
        ExecStartPre=-/usr/bin/docker stop consul
        ExecStartPre=-/usr/bin/docker rm -f consul
        ExecStart=/usr/bin/docker run --net=host -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' -v /tmp/consul/data:/consul/data --name consul consul:$${consul_version} consul agent -data-dir=/consul/data -bind=0.0.0.0 -client=0.0.0.0 -advertise=$${advertise} -dns-port=53 -recursor 8.8.8.8 $${consul_join_params}
        ExecStop=/usr/bin/docker rm -f consul

        [Install]
        WantedBy=multi-user.target

    - name: nomad.service
      content: |
        [Unit]
        Description=nomad
        Wants=network-online.target consul.service
        After=network.target network-online.target consul.service

        [Service]
        Restart=always
        ExecStart=/opt/bin/nomad agent -config=/etc/nomad/worker.conf
        ExecStop=/usr/bin/pkill nomad

        [Install]
        WantedBy=multi-user.target

EOF

  vars {
    advertise = "$${COREOS_PRIVATE_IPV4}"
    consul_version = "${ var.consul_version }"
    consul_join_params = "${ var.consul_join_params }"
    // switch to this method once interpolation works or local vars feature is available
    //host_addr = "${ element(openstack_networking_port_v2.ips.*.all_fixed_ips[0], count.index) }"
  }
}

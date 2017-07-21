data "template_file" "cloud-config" {
  count = "${ var.cluster_size }"

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
        Restart=always
        ExecStartPre=-/usr/bin/docker stop consul
        ExecStartPre=-/usr/bin/docker rm -f consul
        ExecStart=/usr/bin/docker run --net=host -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' -v /tmp/consul/data:/consul/data --name consul consul:$${consul_version} consul agent -data-dir=/consul/data -dns-port=53 -recursor 8.8.8.8 -bind=0.0.0.0 -client=0.0.0.0 -advertise=$${host_addr} $${consul_join_params}
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
        ExecStart=/opt/bin/nomad agent -config=/etc/nomad/server.conf
        ExecStop=/usr/bin/pkill nomad

        [Install]
        WantedBy=multi-user.target

    - name: nomad-ui.service
      command: start
      content: |
        [Unit]
        Description=nomad-ui
        Wants=network-online.target consul.service nomad.service
        After=network.target network-online.target consul.service nomad.service

        [Service]
        Restart=always
        ExecStartPre=-/usr/bin/docker stop hashi-ui
        ExecStartPre=-/usr/bin/docker rm -f hashi-ui
        ExecStart=/usr/bin/docker run -e NOMAD_ENABLE=1 -e NOMAD_ADDR=http://$${host_addr}:4646 -e CONSUL_ENABLE=1 -e CONSUL_ADDR=$${host_addr}:8500 -p 8000:3000 --name hashi-ui jippi/hashi-ui
        ExecStop=/usr/bin/docker rm -f hashi-ui

        [Install]
        WantedBy=multi-user.target

EOF

  vars {
    consul_version = "${ var.consul_version }"
    consul_join_params = "${ var.consul_join_params }"
    cluster_size = "${ var.cluster_size }"
    host_addr = "${ module.nomad_network.all_fixed_ips[count.index] }"
  }
}

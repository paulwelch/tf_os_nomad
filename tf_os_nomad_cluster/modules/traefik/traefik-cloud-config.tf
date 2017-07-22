data "template_file" "traefik-cloud-config" {

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

    - name: traefik.service
      command: start
      content: |
        [Unit]
        Description=Traefik
        Requires=docker.service

        [Service]
        Restart=always
        ExecStartPre=-/usr/bin/docker stop traefik 2> /dev/null
        ExecStartPre=-/usr/bin/docker rm -f traefik 2> /dev/null
        ExecStart=/usr/bin/docker run -p 8080:8080 -p 80:80 -v /home/core/traefik:/etc/traefik --name traefik traefik
        ExecStop=/usr/bin/docker rm -f traefik

        [Install]
        WantedBy=multi-user.target

EOF

}

job "web-hostname" {
  region = "global"
  datacenters = ["dc1"]

  update {
    stagger = "20s"
    max_parallel = 1
  }

  group "example" {
    count = 5

    task "server" {
      driver = "docker"

      service {
        tags = ["web"]

        port = "http"

        check {
          type = "http"
          port = "http"
          path = "/"
          interval = "30s"
          timeout = "5s"
        }
      }

      config {
        image = "stenote/nginx-hostname"
        port_map {
          http = 80
        }
      }

      resources {
        network {
          mbits = 10
          port "http" {
            static = "5678"
          }
        }
      }
    }
  }
}

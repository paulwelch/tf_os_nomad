job "docs" {
  region = "global"
  datacenters = ["dc1"]

  update {
    stagger = "20s"
    max_parallel = 1
  }

  group "example" {
    count = 3

    task "server" {
      driver = "docker"

      service {
        tags = ["role", "web"]
        tags = ["driver", "docker"]

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
        image = "hashicorp/http-echo"
        args = [
          "-listen", ":5678",
          "-text", "hello world",
        ]
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

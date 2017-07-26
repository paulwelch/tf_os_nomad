job "zeppelin" {
  region = "global"
  datacenters = ["dc1"]

  group "zeppelin" {
    count = 1

    task "svr" {
      driver = "docker"

      service {
        tags = ["spark", "zeppelin"]
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
        image = "apache/zeppelin:0.7.2"
        port_map {
          http = 8080
        }
      }

      resources {
        memory = 2048 # MB
        network {
          mbits = 10
          port "http" {
            static = 8080
          }
        }
      }

    }
  }
}

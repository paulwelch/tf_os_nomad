# directions for using your notebook here: https://hub.docker.com/r/jupyter/all-spark-notebook/

job "jupyter" {
  region = "global"
  datacenters = ["dc1"]

  group "jupyter" {
    count = 1

    task "svr" {
      driver = "docker"

      env {
        TINI_SUBREAPER = "true"
      }

      service {
        tags = ["spark", "jupyter"]
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
        image = "jupyter/all-spark-notebook"
        interactive = true
        tty = true
        network_mode = "host"
        pid_mode = "host"
        port_map {
          http = 8888
        }
      }

      resources {
        memory = 2048 # MB
        network {
          mbits = 10
          port "http" {
          }
        }
      }

    }
  }
}

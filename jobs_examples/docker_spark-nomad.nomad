job "spark" {
  region = "global"
  datacenters = ["dc1"]

  group "master" {
    count = 1

    task "svr" {
      driver = "docker"

      meta {
        "spark.ui.stopDelay" = "5m"
      }

      service {
        tags = ["spark", "master"]
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
        image = "hashicorp/spark-nomad"
        hostname = "spark-master-svr"
        interactive = true
        tty = true
        port_map {
          http = 8080
          api = 7077
        }
        command = "/opt/spark/bin/spark-class"
        args = [
          "org.apache.spark.deploy.master.Master",
          "--host", "spark-master-svr",
          "--port", "7077",
          "--webui-port", "8080"
        ]
      }

      resources {
        memory = 2048 # MB
        network {
          mbits = 10
          port "http" {
            static = 8080
          }
          port "api" {
            static = 7077
          }
        }
      }
    }
  }

  group "slave" {
    count = 5

    task "wrk" {
      driver = "docker"

      service {
        tags = ["spark", "slave"]
        port = "http"
      }

      config {
        image = "hashicorp/spark-nomad"
        interactive = true
        tty = true
        command = "/opt/spark/bin/spark-class"
        args = [
          "org.apache.spark.deploy.worker.Worker",
          "--webui-port", "8081",
          "spark://spark-master-svr:7077"
        ]
        port_map {
          http = 8081
        }
      }

      resources {
        memory = 4096 # MB
        network {
          mbits = 10
          port "http" {
            static = 8081
          }
        }
      }
    }
  }

}

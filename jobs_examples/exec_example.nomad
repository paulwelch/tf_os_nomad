job "hello_exec" {

  region = "global"
  datacenters = ["dc1"]

  type = "batch"

  group "hello_group" {

    task "example" {
      driver = "exec"

      config {
        command = "/bin/echo"
        args    = ["Hello"]
      }
    }

  }

}

data "template_file" "cluster_health" {
//  count = "${ var.cluster_size }"

  template = <<EOF
until [[ $(curl -q http://0.0.0.0:4646/v1/status/peers 2> /dev/null) =~ ^([^,]*,){2}[^,]*$ ]]; do \
  sleep 2; \
done; \
EOF

  vars {
//    cluster_size = "${ var.cluster_size }"
  }
}

# use local docker instance to submit a spark job to nomad
docker run \
  --dns $CONSUL_IP \
  --dns-search service.consul \
  --dns-search node.consul \
  --rm \
  -it \
  --name spark-nomad-submit \
  hashicorp/spark-nomad \

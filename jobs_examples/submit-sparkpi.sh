# use local docker instance to submit a spark job to nomad
docker run \
  --dns $CONSUL_IP \
  --dns-search service.consul \
  --dns-search node.consul \
  --rm \
  --name spark-nomad-submit \
  hashicorp/spark-nomad \
  spark-submit \
    --master nomad:$NOMAD_ADDR \
    --deploy-mode cluster  \
    --docker-image hashicorp/spark-nomad  \
    --distribution local:///opt/spark  \
    --driver-memory 512m  \
    --executor-memory 512m  \
    --class org.apache.spark.examples.SparkPi  \
    local:/opt/spark/examples/jars/spark-examples_2.11-2.1.1.jar 100

for job in $(nomad status | grep $1 | awk '{ print $1 }'); do
  nomad stop $job
done

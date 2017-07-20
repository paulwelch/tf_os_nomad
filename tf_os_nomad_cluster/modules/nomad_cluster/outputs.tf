output "endpoints" {
  value = [ "${ module.nomad_network.all_fixed_ips }" ]
}

output "worker_endpoints" {
  value = [ "${ openstack_networking_port_v2.ips.*.all_fixed_ips }" ]
}

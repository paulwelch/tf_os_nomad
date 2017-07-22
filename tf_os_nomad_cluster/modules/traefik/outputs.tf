output "internal_endpoints" {
  value = [ "${ module.traefik_network.all_fixed_ips }" ]
}

output "public_endpoints" {
  value = [ "${ openstack_compute_floatingip_v2.traefik_public_ip.address }" ]
}

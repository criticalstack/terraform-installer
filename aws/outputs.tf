output "control_plane_endpoint" {
  value = aws_route53_record.control_plane_endpoint.fqdn
}

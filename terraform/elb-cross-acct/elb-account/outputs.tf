###############################################################################
# OUTPUTS
###############################################################################

output "nlb_dns_name" {
  value       = aws_lb.nlb.dns_name
  description = "Use this in your browser to verify load‑balancing."
}
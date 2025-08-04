resource "aws_route53_record" "backend_domain_record" {
  zone_id = "Z05967163Q1CIUEEAALTF" 
  name    = "soleydash-api-dev.soleydash.com"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_elastic_beanstalk_environment.elasticenv.cname]
  depends_on = [aws_elastic_beanstalk_environment.elasticenv]
}
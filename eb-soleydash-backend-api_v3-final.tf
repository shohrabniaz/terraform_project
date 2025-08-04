locals {
  elasticapp           = "soleydash-api"
  beanstalkappenv     = "soledash-api-env1"
  solution_stack_name = "64bit Amazon Linux 2 v3.5.6 running Python 3.8"
  tier                = "WebServer"
  instance_type       = "t2.micro"
  minsize             = "1"
  maxsize             = "2"
}

resource "aws_acm_certificate" "soleydash_api_cert" {
  domain_name       = "soleydash-api-dev.soleydash.com"
  validation_method = "DNS"
}

resource "aws_route53_record" "soleydash_api_validation" {
  for_each = {
    for dvo in aws_acm_certificate.soleydash_api_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
  zone_id = "Z05967163Q1CIUEEAALTF"
}

resource "aws_acm_certificate_validation" "soleydash_api_cert_validation" {
  certificate_arn         = aws_acm_certificate.soleydash_api_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.soleydash_api_validation : record.fqdn]
}

resource "aws_elastic_beanstalk_application" "elasticapp" {
  name        = local.elasticapp
  description = "Soleydash API Elastic Beanstalk Application"
}

resource "aws_elastic_beanstalk_environment" "elasticenv" {
  name                = local.beanstalkappenv
  application         = aws_elastic_beanstalk_application.elasticapp.name
  solution_stack_name = local.solution_stack_name
  tier                = local.tier

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.soley.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", [aws_subnet.soley-private-subnet-1.id, aws_subnet.soley-private-subnet-2.id])
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
     value     = join(",", [aws_subnet.soley-private-subnet-1.id, aws_subnet.soley-private-subnet-2.id])
   # value     = join(",", [aws_subnet.soley-public-subnet-1.id, aws_subnet.soley-public-subnet-2.id])
  }

   /* setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = aws_subnet.soley-private-subnet-1.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = aws_subnet.soley-private-subnet-1.id
  }*/

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = local.instance_type
  }
  
 setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internal"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = aws_acm_certificate_validation.soleydash_api_cert_validation.certificate_arn
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = local.minsize
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = local.maxsize
  }

   setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "soley"
  }

   setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.backend_ec2_sg.id
  }
  
    setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.backend_alb_sg.id
  }


  depends_on = [
    aws_vpc.soley,
    aws_subnet.soley-private-subnet-1,
    aws_subnet.soley-private-subnet-2,
    aws_subnet.soley-public-subnet-1,
    aws_subnet.soley-public-subnet-2,
    aws_iam_instance_profile.eb_instance_profile,
    aws_db_instance.postgres_db,  # Adding RDS dependency here
    aws_secretsmanager_secret.rds_secrets, # Adding Secrets Manager secret dependency here
    aws_secretsmanager_secret_version.rds_secrets_version, # Adding Secrets Manager secret version dependency here
    aws_secretsmanager_secret.db_config_secrets, # Adding DB Config Secrets Manager secret dependency here
    aws_secretsmanager_secret_version.db_config_secrets_version # Adding DB Config Secrets Manager secret version dependency here
  ]
}

locals {
  frontend_elasticapp          = "soleydash-frontend"
  frontend_beanstalkappenv     = "soledash-frontend-env"
  frontend_solution_stack_name = "64bit Amazon Linux 2 v5.8.5 running Node.js 18"
  frontend_tier                = "WebServer"
  frontend_instance_type       = "t2.micro"
  frontend_minsize             = "1"
  frontend_maxsize             = "2"
}


resource "aws_acm_certificate" "soleydash_frontend_cert" {
  domain_name       = "soleydash-dev.soleydash.com"
  validation_method = "DNS"
}

resource "aws_route53_record" "soleydash_frontend_validation" {
  for_each = {
    for dvo in aws_acm_certificate.soleydash_frontend_cert.domain_validation_options : dvo.domain_name => {
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

resource "aws_acm_certificate_validation" "soleydash_frontend_cert_validation" {
  certificate_arn         = aws_acm_certificate.soleydash_frontend_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.soleydash_frontend_validation : record.fqdn]
}

resource "aws_elastic_beanstalk_application" "frontend_elasticapp" {
  name        = local.frontend_elasticapp
  description = "Soleydashboard frontend Elastic Beanstalk Application"
}

resource "aws_elastic_beanstalk_environment" "frontend_elasticenv" {
  name                = local.frontend_beanstalkappenv
  application         = aws_elastic_beanstalk_application.frontend_elasticapp.name
  solution_stack_name = local.frontend_solution_stack_name
  tier                = local.frontend_tier

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
  }

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
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = aws_acm_certificate_validation.soleydash_frontend_cert_validation.certificate_arn
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
    value     = local.frontend_instance_type
  }
  
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internal"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = local.frontend_minsize
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = local.frontend_maxsize
  }

  /*# Environment properties:
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DANGEROUSLY_DISABLE_HOST_CHECK"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NODE_ENV"
    value     = "dev"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NPM_USE_PRODUCTION"
    value     = "false"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = "8000"
  }*/

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "soley"
  }

    setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.frontend_ec2_sg.id
  }
  
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.frontend_alb_sg.id
  }

  depends_on = [
    aws_elastic_beanstalk_environment.elasticenv,  # This is the dependency on the soleydash-api Elastic Beanstalk environment
  ]
}

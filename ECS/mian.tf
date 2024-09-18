terraform{
    required_providers {
      aws = {
        version = "5.57.0"
        source = "hashicorp/aws"
      }
    }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_service_discovery_http_namespace" "default_ns" {
  name  = "default_ns"
}

resource "aws_ecs_cluster" "demo-cluster" {

    name = "demo-cluster"
    service_connect_defaults {
      namespace = aws_service_discovery_http_namespace.default_ns.arn
    }
}

resource "aws_ecs_task_definition" "falsk-app"{
    family = "flask-app"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = 1024
    memory = 2048
    runtime_platform{
        operating_system_family = "LINUX"
        cpu_architecture = "X86_64"
    }
    execution_role_arn = "arn:aws:iam::609316111350:role/ecsTaskExecutionRole"
    task_role_arn = "arn:aws:iam::609316111350:role/ecsTaskExecutionRole"
    container_definitions = <<TASK_DEFINITION
    [
        {
            "name": "flask-app",
            "image": "docker.io/chaitanya305/flask-image:latest",
            "cpu": 1024,
            "memory": 2048,
            "essential": true,
            "environment": [
                {"name": "MYSQL_HOST", "value": "mysql_container.default_ns"}
            ],
            "portMappings": [
                {
                "containerPort": 5000,
                "hostPort": 5000,
                "name": "flask-app"
                }
            ]
        }
    ]
    TASK_DEFINITION 
}

resource "aws_ecs_task_definition" "flask-db"{
    family = "flask-db"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = 1024
    memory = 2048
    runtime_platform{
        operating_system_family = "LINUX"
        cpu_architecture = "X86_64"
    }
    execution_role_arn = "arn:aws:iam::609316111350:role/ecsTaskExecutionRole"
    task_role_arn = "arn:aws:iam::609316111350:role/ecsTaskExecutionRole"
    container_definitions = <<TASK_DEFINITION
    [
        {
            "name": "mysql_container",
            "image": "docker.io/chaitanya305/flask-db-image",
            "cpu": 1024,
            "memory": 2048,
            "essential": true,
            "portMappings": [
                {
                "containerPort": 3306,
                "hostPort": 3306,
                "protocol": "TCP",
                "name": "mysql_container"
                }
            ]
        }
    ]
    TASK_DEFINITION 
}

resource "aws_ecs_service" "flask-app" {
    name = "flask-app"
    cluster = aws_ecs_cluster.demo-cluster.id
    desired_count = 1
    launch_type = "FARGATE"
    platform_version = "LATEST"
    service_connect_configuration {
      enabled = true
      namespace = "default_ns"
      service {
        discovery_name = "flask-app"
        port_name = "flask-app"
        client_alias {
          dns_name = "flask-app.default_ns"
          port = 5000
        }
      }
    }
    task_definition = aws_ecs_task_definition.falsk-app.arn
    network_configuration {
      subnets = ["subnet-05d86ac41be2bfa86", "subnet-07d44d5d934557bdc"]
      security_groups = ["sg-0e8ecdfd48128f23a"]
      assign_public_ip = true
    }
}

resource "aws_ecs_service" "mysql_container" {
    name = "mysql_container"
    cluster = aws_ecs_cluster.demo-cluster.id
    desired_count = 1
    launch_type = "FARGATE"
    platform_version = "LATEST"
    service_connect_configuration {
      enabled = true
      namespace = "default_ns"
      service {
        discovery_name = "mysql_container"
        port_name = "mysql_container"
        client_alias {
          dns_name = "mysql_container.default_ns"
          port = 3306
        }
      }
    }
    task_definition = aws_ecs_task_definition.flask-db.arn
    network_configuration {
      subnets = ["subnet-05d86ac41be2bfa86", "subnet-07d44d5d934557bdc"]
      security_groups = ["sg-0e8ecdfd48128f23a"]
      assign_public_ip = true
    }
}
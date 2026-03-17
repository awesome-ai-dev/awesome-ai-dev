---
name: devops-infra
description: 基础设施 - Terraform/Ansible/AWS/云配置
---

# 基础设施

## Terraform

```hcl
# main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  
  tags = {
    Name = "app-server"
  }
}

resource "aws_s3_bucket" "data" {
  bucket = "my-app-data"
}
```

```bash
# 命令
terraform init
terraform plan
terraform apply
terraform destroy
```

## Ansible

```yaml
# playbook.yml
- hosts: webservers
  become: yes
  tasks:
    - name: Install Node.js
      apt:
        name: nodejs
        state: present
    
    - name: Deploy app
      git:
        repo: https://github.com/user/app.git
        dest: /var/www/app
    
    - name: Start service
      systemd:
        name: app
        state: started
```

## AWS CLI

```bash
# EC2
aws ec2 run-instances --image-id ami-xxx --instance-type t3.micro

# S3
aws s3 mb s3://my-bucket
aws s3 cp file.txt s3://my-bucket/

# Lambda
aws lambda create-function --function-name my-func \
  --runtime nodejs20.x \
  --handler index.handler \
  --zip-file fileb://function.zip
```

## 最佳实践

1. IaC 版本控制
2. 环境分离
3. 敏感信息管理
4. 状态备份

## 参考

- `.cursor/rules/dockerfile.mdc`

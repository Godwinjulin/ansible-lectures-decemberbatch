module "vpc" {
  source = "./modules/vpc"

  cidr_block              = var.cidr_block1
  instance_tenancy        = var.instance_tenancy
  enable_dns_hostnames    = var.enable_dns_hostnames
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zones      = var.availability_zones
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets

  security_group_ingress = [{

    cidr_blocks = ["70.114.65.185/32"]
    description = "Allow ssh inbound traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    },
    {

      cidr_blocks = ["70.114.65.185/32"]
      description = "Allow rdp inbound traffic"
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
    },
    {

      cidr_blocks = ["70.114.65.185/32"]
      description = "Allow jenkins inbound traffic"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
    },
    {

      cidr_blocks = ["70.114.65.185/32"]
      description = "Allow postgresql inbound traffic"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
    },

    {
      cidr_blocks = ["70.114.65.185/32"]
      description = "Allow https inbound traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    },
    {
      cidr_blocks = ["70.114.65.185/32"]
      description = "Allow http inbound traffic"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
    }

  ]
  security_group_egress = [{

    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    }
  ]

  tags = merge(local.common_tags, { Name = "main", Company = "EliteSolutionsIT", "Dummy" = "dummytag" })
}

////EC2
resource "aws_instance" "moduleec2" {

  ami                    = var.AMI_ID
  instance_type          = var.instance_type
  key_name               = aws_key_pair.moduledeployer.key_name
  subnet_id              = flatten(module.vpc.public_subnets)[0]
  vpc_security_group_ids = [module.vpc.vpc_security_group_id]

  tags = merge(local.common_tags, { Name = "moduleec2", Company = "EliteSolutionsIT" })
}

///key
resource "aws_key_pair" "moduledeployer" {
  key_name   = "moduledeployer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTMMkhoW628ylQH+tZssHP8q01Wx5qrYehvlbL5qd0LYD+d/S4/NJ4UdJa+yUw+3f0o8SsvZJ1WgA2aNZgzb/u6jzrZnqXaDCBBXgAykNih2b3wq5jnsOw0U5D2+Vja5XnC5I5EyL+KGGTQfkd5flZnz8aDyGqostqD0CnJ5VxG50zf3nHzILeKPlo2cK1Y5mwfkIp+YuKKc4FDX9Z1KloRlFNMxsKSSfmRzEwB5RZsay+8ezV0o3SQXWjlAXJ26Xy8d9M/2+wfTR8F6p1y72MG5YYji2SF+lTWRM9mGxvh2b/zqTzgXXv6m3BPKrqBX3nPEYmJrwdp85vq59Zjgf+NZFSmN6pmDFMKoYhFzsrW35pjgxsD6iz9hZbU7sg4wwf/Et9+wScSrGkSj09oKFeTTf9fBxQOmp1s0pf1F62O+GOIwmXbrS6DjjmnuMNScBy9/+KvUIXRzfxU4VJmgBYHRaRKush+6jpbXaPdIGGiTEFx1aMOCa0fqKkbBsfr4c= lbena@LAPTOP-QB0DU4OG"
}

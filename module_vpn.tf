module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" #사용할 Module 지정
  version = "2.15.0"                        #Module 버전 지정
  
  name = "vpc"                              #VPC 이름 지정
  cidr = "192.168.0.0/16"                   #IPv4 CIDR
  
  azs             = ["ap-northeast-2a", "ap-northeast-2c"] #가용영역 지정
  private_subnets = ["192.168.20.0/24", "192.168.30.0/24"] #비공개 서브넷
  public_subnets  = ["192.168.0.0/24", "192.168.10.0/24"]  #공개 서브넷
  enable_dns_hostnames = "true"                            #DNS Hostname Enable
  tags = { "TerraformManaged" = "true" }                   #태그 설정
}

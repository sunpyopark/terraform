#모듈을 이용한 방식
module "security-group" {
  source  = "terraform-aws-modules/security-group/aws" #사용할 모듈 소스
  version = "3.1.0"                                    #모듈 버전

  name        = "Web"                                  #그룹이름
  description = "Web"                                  #설명
  vpc_id      = "${module.vpc.vpc_id}"                 #생성할 위치의 VPC ID
  use_name_prefix = "false"                            #해당 옵션을 false 시키지 않을 경우, 그룹이름 뒤에 고유 넘버링이 부착되어 생성됨
  ingress_with_cidr_blocks = [
    {
      from_port   = 443                                #인바운드 시작 포트
      to_port     = 443                                #인바운드 끝나는 포트
      protocol    = "tcp"                              #사용할 프로토콜
      description = "https"                            #설명
      cidr_blocks = "0.0.0.0/0"                        #허용할 IP 범위
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "0.0.0.0/0"
    }
]
}

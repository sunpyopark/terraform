#기본 생성 방식
resource "aws_security_group" "web" {
  vpc_id = "${module.vpc.vpc_id}"     #생성할 위치의 VPC ID
  name = "WEB"                        #그룹 이름
  description = "Terraform WEB SG"    #설명
  ingress {
    from_port = 22                    #인바운드 시작 포트
    to_port = 22                      #인바운드 끝나는 포트
    protocol = "tcp"                  #사용할 프로토콜
    cidr_blocks = ["0.0.0.0/0"]       #허용할 IP 범위
}
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
 ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

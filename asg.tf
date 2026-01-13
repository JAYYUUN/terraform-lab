resource "aws_launch_template" "flask_lt" {
  image_id      = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.instance_sg.id
  ]

  user_data = base64encode(local.user_data)

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }
}

resource "aws_autoscaling_group" "flask_asg" {
  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  target_group_arns = [
    aws_lb_target_group.flask_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.flask_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = [ #어떤 서브넷에 인스턴스를 띄울 것인가
    aws_subnet.private_a.id,
    aws_subnet.private_b.id # 프라이빗 서브넷 a,b에 생성
  ]
}
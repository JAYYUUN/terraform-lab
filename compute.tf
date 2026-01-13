resource "aws_key_pair" "this" {
  key_name   = "terraform-key"
  public_key = file("terraform-key.pub")
}

/*
resource "aws_instance" "flask" {
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.flask_sg.id
  ]

  user_data = local.user_data

  tags = {
    Name = "terraform-flask-1"
  }

  key_name = aws_key_pair.this.key_name
}
*/
resource "aws_instance" "web_server" {
  ami           = "ami-08eb150f611ca277f"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.subnet_a.id
  security_groups = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
      #!/bin/bash
      sudo apt update
      sudo apt install -y git golang nginx

      # Clone the repository
      git clone https://github.com/LazarenkoDmytro/golang-demo.git /home/ubuntu/golang-demo
      cd /home/ubuntu/golang-demo

      # Build the application
      go build

      # Run the application
      nohup ./golang-demo &

      # Configure Nginx
      sudo bash -c 'cat > /etc/nginx/sites-available/default <<EOF
      server {
          listen 80;
          location / {
              proxy_pass http://localhost:8080;
          }
      }
      EOF'

      # Restart Nginx
      sudo systemctl restart nginx
  EOF

  tags = {
    Name = "web_server"
  }
}
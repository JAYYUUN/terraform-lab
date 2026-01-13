locals {
  user_data = <<-EOF
#!/bin/bash

sudo dnf update -y
sudo dnf install -y python3-pip

sudo pip3 install flask gunicorn

cat > /home/ec2-user/app.py <<'PY'
from flask import Flask
import socket

app = Flask(__name__)

@app.route("/")
def home():
  return f"Hello from {socket.gethostname()}"

@app.route("/health")
def health():
  return "OK"

if __name__ == "__main__":
  app.run(host="0.0.0.0", port=8080)
PY

chown ec2-user:ec2-user /home/ec2-user/app.py

sudo tee /etc/systemd/system/gunicorn.service > /dev/null <<'UNIT'
[Unit]
Description=Gunicorn Flask App
After=network.target

[Service]
User=ec2-user
Group=ec2-user
WorkingDirectory=/home/ec2-user
ExecStart=/usr/local/bin/gunicorn -w 4 -b 0.0.0.0:8080 app:app
Restart=always

[Install]
WantedBy=multi-user.target
UNIT

sudo systemctl daemon-reload
sudo systemctl enable gunicorn
sudo systemctl restart gunicorn

EOF
}
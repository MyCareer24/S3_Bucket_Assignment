#CREATING USER DATA
#!/bin/bash
#yum update -y
#yum install -y httpd.x86_64
#systemctl start httpd.service
#systemctl enable httpd.service
#echo “Hello CloudChamp from $(hostname -f).Created by USERDATA in Terraform. SUBSCRIBE NOW!!” (arrow_symbol) /var/www/html/index.html


#!/bin/bash
yum update -y
yum install -y nginx 
systemctl start nginx
systemctl enable nginx
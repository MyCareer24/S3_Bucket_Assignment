
#CREATING 2 EC2 INSTANCES IN PUBLIC SUBNETS WITH SAME AVAILABILITY ZONE
resource "aws_instance" "Project_EC2_Instance_A" {
    ami = var.project_ami
    instance_type = var.project_Instance_Size
    #vpc_security_group_ids  = ["sg-0ee23c4d423426f60"]
    security_groups = [aws_security_group.Proj-Sec-grp.id]
    subnet_id = aws_subnet.Project_PubSub1.id
    key_name = var.key_name
    associate_public_ip_address = true
    
    user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    systemctl start nginx
    systemctl enable nginx
    EOF

    #user_data = file("script.sh")

     tags = {
          name = "Project_EC2_Instance_A"

        }
}

      
resource "aws_instance" "Project_EC2_Instance_B" {
    ami = var.project_ami
    instance_type = var.project_Instance_Size
    #vpc_security_group_ids  = ["sg-0ee23c4d423426f60"]
    security_groups = [aws_security_group.Proj-Sec-grp.id]
    subnet_id = aws_subnet.Project_PubSub2.id
    key_name = var.key_name
    associate_public_ip_address = true
    
    user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    systemctl start nginx
    systemctl enable nginx
    EOF

     #user_data = file("script.sh")

    tags = {
          name = "Project_EC2_Instance_B"

        }
}


   
/*
resource "aws_instance" "Project_EC2_Instance_B" {
    ami = "ami-0f007bf1d5c770c6e"
    instance_type = var.Project_Instance_Size
    key_name = var.key_name
    security_groups = [aws_security_group.Proj-Sec-grp.id]
    subnet_id = aws_subnet.Project_PubSub2.id
    associate_public_ip_address = true
    
    user_data = file("script.sh")

 tags = {
 name = "Project_EC2_Instance_B"

 }
}*/


#CREATING 2 EC2 INSTANCES IN PUBLIC SUBNETS WITH SAME AVAILABILITY ZONE
#resource "aws_instance" "Project_EC2_Instance_A"{
  #ami           = "ami-0f007bf1d5c770c6e"
  #instance_type = "t2.micro"
  #vpc_security_group_ids  = ["sg-0a7e2aeb228eeb596"]
  #subnet_id = aws_subnet.Project_PubSub1.id
  #key_name = aws_key_pair.Project_KP.key_name
  #associate_public_ip_address = true
  #user_data = file("script.sh")

 #tags = {
 #name = "Project_EC2_Instance_A"
 #}
#}

#resource "aws_instance" "Project_EC2_Instance_B"{
  #ami           = "ami-0f007bf1d5c770c6e"
  #instance_type = "t2.micro"
  #vpc_security_group_ids  = ["sg-0a7e2aeb228eeb596"]
  #subnet_id = aws_subnet.Project_PubSub2.id
  #key_name = aws_key_pair.Project_KP.key_name
  #associate_public_ip_address = true
  #user_data = file("script.sh")

 #tags = {
 #name = "Project_EC2_Instance_B"
 #}
#}
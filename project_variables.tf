#VARIABLE FOR INSTANCE TYPE
variable "Project_Instance_Size" {
  type = string
  default = "t2.micro" 
   description = "This is the instance size"
}


#VARIABLE FOR KEY PAIR
variable "key_name" {default = "project_kp"}

#VARIABLE FOR S3 BUCKET NAME
variable "project-s3-buckets"{
type = string
default = "project-s3-buckets"
description = "This is my bucket name"

}

#VARIABLE FOR S3 BUCKET REGION
variable "my_bucket_region"{

  default = "eu-west-1"
  description = "my default bucket region"
  type = string

}

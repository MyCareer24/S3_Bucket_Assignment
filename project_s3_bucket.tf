#CREATING S3 BUCKET
resource "aws_s3_bucket" "project-s3-bucketaliass" {
  bucket = var.project-s3-buckets
     tags =  {
                name = "project-s3-buckets"
            }
}

#GRANTING ACCESS TO ONLY THE BUCKET OWNER
resource "aws_s3_bucket_ownership_controls" "project-s3-bucketaliass_ctrl" {
  bucket = aws_s3_bucket.project-s3-bucketaliass.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#GRANTING ACCESS TO BUCKET BY UNBLOCKING PUBLIC ACCESS
resource "aws_s3_bucket_public_access_block" "project-s3-policy" {
 bucket = aws_s3_bucket.project-s3-bucketaliass.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

#ACL RESOURCE BLOCK CREATION. ACL CREATION DEPENDS ON TWO RESOURCES
# 1. BUCKET OWNERNSERSHIP CONTROL AND THE PUBLIC ACCESS BLOCK
#  
resource "aws_s3_bucket_acl" "project-s3-bucket-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.project-s3-bucketaliass_ctrl,
  aws_s3_bucket_public_access_block.project-s3-policy,
  ]

  bucket = aws_s3_bucket.project-s3-bucketaliass.id
  acl    = "public-read"
}


#DISABLING BUCKET VERSIONING
resource "aws_s3_bucket_versioning" "project-versioning" {
  bucket        = aws_s3_bucket.project-s3-bucketaliass.id
 versioning_configuration {
                                status      = "Disabled"
                           }

}
#CREATING A POLICY FOR MY BUCKET
resource "aws_s3_bucket_policy" "project_bucket_policy" {
  bucket =  aws_s3_bucket.project-s3-bucketaliass.id # ID of the S3 bucket

  # Policy JSON for allowing public read access
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource": "arn:aws:s3:::${var.project-s3-buckets}/*"
      
      }
    ]
  })
}
#UPLOADING FILE INTO BUCKET
resource "aws_s3_object" "project_file" {
  bucket        = aws_s3_bucket.project-s3-bucketaliass.id
  key           = "Project_File_To_Upload_S3.txt"
  source        = "C:/Users/vierr/Terraform_Projects_DevOps/Project_File_To_Upload_S3.txt"
  #acl = "public-read"
  etag = filemd5("C:/Users/vierr/Terraform_Projects_DevOps/Project_File_To_Upload_S3.txt")


  tags =  {
               name = "project-s3-bucket-version"
         }

}

#CREATING A TEMPLATE FILE ITS ALSO A MODULE
#Imports the Harshicorp template module for managing template files
module "project_template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/website_files"
    }

#S3 BUCKET WEBSITE CONFIGURATION 
resource "aws_s3_bucket_website_configuration" "project_web-config" {
  bucket = aws_s3_bucket.project-s3-bucketaliass.id

#CONFIGURATION FOR THE INDEX DOCUMENT
  index_document {
    suffix = "index.html" #FILE NAME
  }
}

#AWS S3 OBJECT RESOURCE FOR HOSTING BUCKET FILES
resource "aws_s3_object" "project_bucket_files" {
  bucket = aws_s3_bucket.project-s3-bucketaliass.id

#To iterate over each of the file defined in our template module
for_each = module.project_template_files.files

#specify the name of my object in my s3 buck
key = each.key

#specify the MIME type of my object content
content_type = each.value.content_type

#the local file path or the url of my object content
source = each.value.source_path

#specify the content of my object
content = each.value.content

#ETag or entity tag of my S3 object
etag = each.value.digests.md5
}
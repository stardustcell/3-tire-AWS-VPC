variable "aws_region_name" {
  description = "us_west_region"
  type        = string
  default     = "us-west-2"

}

variable "vpc_cidr" {
  type        = string
  description = "vpc_cidr_ip"
  default     = "11.0.0.0/16"

}

variable "pub_sub_web_cidr" {
  description = "pub_sub_web_cidr"
  type        = list(string)
  default     = ["11.0.1.0/24", "11.0.2.0/24"]

}

variable "Pri_sub_app_cidr" {
  description = "Pri_sub_app_cidr"
  type        = list(string)
  default     = ["11.0.3.0/24", "11.0.4.0/24"]

}

variable "Pri_sub_db_cidr" {
  description = "Pri_sub_db_cidr"
  type        = list(string)
  default     = ["11.0.5.0/24", "11.0.6.0/24"]

}



variable "_AZ_zone" {
  description = "private_avail_zone"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]

}

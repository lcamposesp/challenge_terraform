## Variables no necesarias en este caso

variable "aws_access_key" {
  type        = string
  description = "AWS Access key for the EC2 provisioning"
  default = ""

}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS Secret access key for the EC2 provisioning"
  default     = ""
}

variable "aws_region" {
  type = string  
}

variable "vpc_cidr" {
  type = string
}

variable "any" {
  type = string
}


variable "cidr" {
   type = list(string)  
 }



variable "ssh_key_name" {
  type = string 
}

variable "ami_id" {
  type = string  
}

variable "instance_type" {
  type = string    
}

variable "tags" {
  type = list(string)
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number 
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number  
    protocol    = string    
    cidr_blocks = list(string) 
  }))  
}
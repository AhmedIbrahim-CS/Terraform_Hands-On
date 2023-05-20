aws_region           = "us-east-1"
vpc_cidr             = "10.0.0.0/16"

cidr                 = ["10.0.0.0/24","10.0.1.0/24"]  

any                  = "0.0.0.0/0"
ssh_key_name         = "my-ssh-key1"
ami_id               = "ami-007855ac798b5175e"
instance_type        = "t2.micro"


 tags = ["vpc", "igw", "public subnet" , "private subnet" ,"public table" ,"nat" ,"private table" , "public_web","private_web"]
 ingress_rules = [
  {
    from_port   = 22    
    to_port     = 22     
    protocol    = "tcp"   
    cidr_blocks = ["0.0.0.0/0"]     
  },
  {
    from_port   = 80    
    to_port     = 80     
    protocol    = "tcp"   
    cidr_blocks = ["0.0.0.0/0"]   
  }, 
  {
    from_port   = 443   
    to_port     = 443    
    protocol    = "tcp"   
    cidr_blocks = ["0.0.0.0/0"]   
  }  
]

egress_rules = [
    {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
]

 
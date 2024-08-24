resource "aws_key_pair" "my_key"{
    key_name = "test-web" #key-name for instance key-name
    public_key = file("${path.module}/id_rsa.pub") #path to public key
}

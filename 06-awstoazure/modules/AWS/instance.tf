resource "aws_instance" "example" {
  ami           = "${lookup(var.UBUNTUZESTY_AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.main-public-1.id}"

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"

  provisioner "file" {
    source      = "installstrongswan.sh"
    destination = "/tmp/installstrongswan.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installstrongswan.sh",
      "/tmp/installstrongswan.sh",
    ]
  }

}

########################################################
# Transit Gateway
########################################################
resource "aws_ec2_transit_gateway" "terraform-tgwy" {
  description                     = "Transit Gateway with 3 VPCs"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name = "terraform-tgwy"
  }
}

# Route Table - FGT VPC
resource "aws_ec2_transit_gateway_route_table" "tgwy-fgt-route" {
  depends_on         = [aws_ec2_transit_gateway.terraform-tgwy]
  transit_gateway_id = aws_ec2_transit_gateway.terraform-tgwy.id
  tags = {
    Name = "tgwy-fgt-route"
  }
}


# VPC attachment - FGT VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-fgt" {
  appliance_mode_support                          = "enable"
  subnet_ids                                      = [aws_subnet.transitsubnetaz1.id, aws_subnet.transitsubnetaz2.id]
  transit_gateway_id                              = aws_ec2_transit_gateway.terraform-tgwy.id
  vpc_id                                          = aws_vpc.fgtvm-vpc.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "tgwy-fgt-attachment"
  }
  depends_on = [aws_ec2_transit_gateway.terraform-tgwy]
}

# Route Tables Associations - FGT VPC
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-fgt-assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-fgt.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgwy-fgt-route.id
}
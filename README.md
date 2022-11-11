VPC - 192.168.0.0/16
IGW - IGW should be attach in vpc
Public subnet -192.168.1.0/24
private subnet - 192.168.2.0 /24
public route table
 - which vpc
private route table
this is
create route
 - designation -0.0.0.0/0
 - target -IGW
 create public route 
 - which route table
 - destination - 0.0.0.0/0
 - target - IGW
 create nat gateway for public subnet 
 EIP - elastic IP
 Create private route
  - which route table
 - destination - 0.0.0.0/0
 - target - Nat gateway

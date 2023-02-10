## List ECS Instances

`aliyun ecs DescribeInstances --output cols=InstanceId,InstanceName,PublicIpAddress,NetworkInterfaces.NetworkInterface[].PrimaryIpAddress,Status,OSNameEn rows=Instances.Instance[]`


## List Security Groups

`aliyun ecs DescribeSecurityGroups --output cols=SecurityGroupId,SecurityGroupName,SecurityGroupType,VpcId rows=SecurityGroups.SecurityGroup[]`

## List Security Group Detail

`aliyun ecs DescribeSecurityGroupAttribute --output cols=SecurityGroupRuleId,IpProtocol,PortRange,SourceCidrIp,Policy,Priority rows=Permissions.Permission[] --SecurityGroupId=sg-****`

## Add Security Groups

1.) `aliyun ecs AuthorizeSecurityGroup --Description="动态IP" --IpProtocol=tcp --PortRange=22/22 --SourceCidrIp=127.0.0.1 --SecurityGroupId=sg-****`

2.) add current ip to security group `aliyun ecs AuthorizeSecurityGroup --Description="动态IP" --IpProtocol=tcp --PortRange=22/22 --SourceCidrIp=$(curl -s http://ipinfo.io/ip) --SecurityGroupId=sg-****`

## Delete SecurityGroup

1.) `aliyun ecs DeleteSecurityGroup --SecurityGroupId=sg-****`


## Revoke SecurityGroup Rule

1.) required to match protocol, port range, and SourceCidrIp `aliyun ecs RevokeSecurityGroup --SecurityGroupId=sg-****** --IpProtocol=tcp --PortRange=53/53 --SourceCidrIp=127.0.0.1`

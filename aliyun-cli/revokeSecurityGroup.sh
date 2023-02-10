OLD_IP=127.0.0.1
GROUP_ID=sg-j6cj4w5enmbfl6hkh2f4
PORT_RANGE=5335/5335
PERMISSIONS=$(aliyun ecs DescribeSecurityGroupAttribute --SecurityGroupId=$GROUP_ID | jq --arg OLD_IP "$OLD_IP" --arg PORT_RANGE "$PORT_RANGE" '[.Permissions.Permission[] | select(.SourceCidrIp == $OLD_IP and .PortRange == $PORT_RANGE)]')
for PERMISSION in $(echo "$PERMISSIONS" | jq -c '.[]'); do
  SOURCE_CIDR_IP=$(echo $PERMISSION | jq -r '.SourceCidrIp')
  PORT_RANGE=$(echo $PERMISSION | jq -r '.PortRange')
  PROTOCOL=$(echo $PERMISSION | jq -r '.IpProtocol')
  echo "Revoke Source CIDR IP: $SOURCE_CIDR_IP, Port Range: $PORT_RANGE, IP Protocol: $PROTOCOL"
  aliyun ecs RevokeSecurityGroup --SecurityGroupId=$GROUP_ID --IpProtocol=$PROTOCOL --PortRange=$PORT_RANGE --SourceCidrIp=$SOURCE_CIDR_IP
done
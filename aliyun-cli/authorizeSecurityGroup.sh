#!/bin/bash
IP=$(curl -s ipinfo.io/ip)
GROUP_ID=sg-j6cj4w5enmbfl6hkh2f4
PORT_RANGE=5335/5335

PROTOCOLS_LIST=("UDP" "TCP")
for PROTOCOL in ${PROTOCOLS_LIST[@]}; do
  echo "Authorize $PROTOCOL $IP for PORT: $PORT_RANGE"
  aliyun ecs AuthorizeSecurityGroup --Description="动态IP" --IpProtocol=$PROTOCOL --PortRange=$PORT_RANGE --SourceCidrIp=$IP --SecurityGroupId=$GROUP_ID
done
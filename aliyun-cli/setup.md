## SETUP

1.) repo - https://github.com/aliyun/aliyun-cli

## Installation

1.) MacOS - using brew: `brew install aliyun-cli`

2.) or Download installer and copy to `/usr/local/bin` or add it to the `$PATH`

3.) optional: for auto completion

`aliyun auto-completion`

4.) to uninstall: `aliyun auto-completion --uninstall`


## Setup Profile

1.) https://www.alibabacloud.com/help/zh/alibaba-cloud-cli/latest/interactive-configuration

2.) setup with accessKey `aliyun configure --mode AK --profile akProfile`

3.) aliyun configure list


## Filter Output

1.) example: `aliyun ecs DescribeInstances --output cols=InstanceId,InstanceName,PublicIpAddress,NetworkInterfaces.NetworkInterface[].PrimaryIpAddress,Status rows=Instances.Instance[]`

https://blog.csdn.net/yunweigo/article/details/116126850


## Alias command
https://github.com/aliyun/aliyun-cli/blob/master/bin/README.md
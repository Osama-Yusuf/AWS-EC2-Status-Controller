# AWS EC2 Status Controller
This script scans, saves and starts/stops/terminates instances in AWS.

### Install
```
curl "https://raw.githubusercontent.com/Osama-Yusuf/AWS-EC2-Controler/main/DevOps/Automations.sh/aws_ec2.sh" -o aws_ec2.sh && chmod +x aws_ec2.sh
sudo mv aws_ec2.sh /usr/local/bin/aws_ec2
```

### Usage
```
1. aws_ec2 scan save
2. aws_ec2 check [region]
3. aws_ec2 [start|stop|terminate|ip] [region] [instance_id]

aws_ec2
   scan                                scans all regions and saves only scan result in $rgs_dir/scan
   scan save                           scans and saves the instances ids for further use in $rgs_dir
   
   regions                             lists all saved regions, but you must first scan and save the instances
   [region]                            print info about instances inside passed region
   
   [command] [region] [instance_id]    [start|stop|terminate|ip|check] but you must first scan and save the instances

Eg: aws_ec2 start us-east-1                         starts all instances in us-east-1
Eg: aws_ec2 start us-east-1 i-050b7d36ad76bddea     starts a specific instance in us-east-1
```

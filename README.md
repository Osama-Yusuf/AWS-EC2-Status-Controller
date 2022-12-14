# AWS EC2 Status Controller
**AWS EC2 Status Controller** is a bunch of **BASH** scripts for scanning, starting, stopping, and terminating instances in Amazon Web Services.

if there's any instance running, it will send you a mail to notify you.

you can also use it to create a new EC2 instance with specific settings for region, instance type, key pair, volume size, security group, and instance name.

Take a look at the [GitHub project page](https://github.com/Osama-Yusuf/AWS-EC2-Status-Controller).

## Features

[**aws_ec2.sh:**](#1-aws_ec2sh)
* Scan all regions for launched instances (whether they are running or not)
* Saves scanned instances to a file for later use
* Check, start, stop and terminate specific instances or all in a specific region 
* Check for lanched instances by regions and print their info (instance id, instance type, state, public IP, private IP)
* prints public IP and private IP of instances
* prints instance id, intance type and state of instances

[**notify_ec2.sh:**](#2-notify_ec2sh)
* send mail to notify you if there's any instance running with the ability to change this to notify you only if there's any large/xlarge instance running
* you can create a cronjob to run this script every 12HRS or on reboot to mail you if there's any instance running

[**provision_ec2.sh:**](#3-provision_ec2sh)
* Provision a new EC2 instance with custom region, instance type, key pair, volume_size, security group, and the name of the instance
* creates a new key pair if it the one you specified as 3rd argument doesn't exist and saves it in the current directory or the directory you passed as the third argument
* creates a new security group with the name you passed as the fifth argument and add inbound rule to allow all traffic from your ip only to the instance
* creates a new volume with the size you passed as the fourth argument and attach it to the instance
* creates a name you passed as the fifth argument for the instance

---

## Getting started:

### 1. aws_ec2.sh:
### Install:
```bash
curl "https://raw.githubusercontent.com/Osama-Yusuf/AWS-EC2-Status-Controller/main/aws_ec2.sh" -o aws_ec2.sh && chmod +x aws_ec2.sh
sudo mv aws_ec2.sh /usr/local/bin/ec2
```

### Usage:
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

### 2. notify_ec2.sh
### Install:
```bash
curl "https://raw.githubusercontent.com/Osama-Yusuf/AWS-EC2-Status-Controller/main/notify_ec2.sh" -o notify_ec2.sh && chmod +x notify_ec2.sh
sudo mv notify_ec2.sh /usr/local/bin/notify_ec2
```

### Usage:
This will send you a mail if there's any instance running
```bash
notify_ec2 yourmail@gmail.com
```
To create a cronjob to execute this script every 12HRS or on reboot to notify you if there's any instance running, you must do the following first:

a- execute the script for the first time to install any missing dependencies and to configure ssmtp
```bash
./notify_ec2.sh yourmail@gmail.com
OR 
notify_ec2 yourmail@gmail.com
```
b- To avoid cronjob errors delete unnecessary parts of script copy paste the following in /usr/local/bin/notify_ec2:
```bash
ec2 scan save
inst_path="$HOME/running_instances.txt"
running_inst=$(grep running ~/.aws/regions/scan | awk '{print $2 " - " $7}' | sort | uniq -c | sed 's/,//g')
date=$(date +%F)
echo -e "$date:\n$running_inst\n----------------------------------------" >> $inst_path
if [ -n "$running_inst" ]; then
    echo "Sending email to $1..."
    echo -e "The following AWS instance are currently running:\n\n$(cat $inst_path)" | mail -s "Warning running instances" $1
else
    echo "there're no instance running in aws"
fi
```
c- open crontab editor with vim
```bash
crontab -e
```
d- add any line of the following lines in the vim editor
```bash
0 */12 * * * /bin/bash /usr/local/bin/notify_ec2 yourmail@gmail.com >> /home/<your_user>/output.txt
@reboot /bin/bash /usr/local/bin/notify_ec2 yourmail@gmail.com >> /home/<your_user>/output.txt
```

### 3. provision_ec2.sh:
### Install:
```bash
curl "https://raw.githubusercontent.com/Osama-Yusuf/AWS-EC2-Status-Controller/main/provision_ec2.sh" -o provision_ec2.sh && chmod +x provision_ec2.sh
sudo mv provision_ec2.sh /usr/local/bin/provision
```

### Usage:
This will provision ec2 with custom region, instance type, key pair, volume_size, security group, and the name of the instance
```bash
provision <1-region> <2-instance_type> <3-key_name.pem> <4-volume_size> <5-tag>
```
NP: the numbers indicated above is just to help you write the values in the right order, do not write them before the value

E.g.:
```bash
provision us-east-1 t2.micro key_name.pem 20 my_instance
```
---

## Tested Environments

* Ubuntu 20.04.

   If you have successfully tested this script on others systems or platforms please let me know!

---

## Support 

 If you want to support this project, please consider donating:
 * PayPal: https://paypal.me/OsamaYusuf
 * Buy me a coffee: https://www.buymeacoffee.com/OsamaYusuf
 * ETH: 0x507bF8931b534a81Ced18FDf8fc5BE4Daf08332B

---

* `By Osama-Yusuf`
* `Thanks for reading`

-------
##### Report bugs for "AWS-EC2-Status-Controller"
* `osama9mohamed5@gmail.com`
 
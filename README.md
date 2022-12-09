# AWS EC2 Status Controller
**AWS EC2 Status Controller** is a **BASH** script that can be used to scans, saves and starts/stops/terminates/check instances in AWS.

You can take a look at the [GitHub project page](https://github.com/Osama-Yusuf/AWS-EC2-Status-Controller).

## Features

* Scan all regions for instances
* Saves scanned instances to a file for later use
* Check, start, stop and terminate specific instances or all in a specific region 
* Check later for regions scanned by ./ec2status.py regions
* prints public IP and private IP of instances
* prints instance id, intance type and state of instances
* send mail to notify you if there's any instance running with the ability to change this to notify you only if there's any large/xlarge instance running

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
you can create a cronjob to run this script every 12HRS or on reboot to notify you if there's any instance running
```bash
crontab -e
```
```bash
0 */12 * * * notify_ec2
@reboot notify_ec2
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
 
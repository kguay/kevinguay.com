+++
title = "Installing a LibreSpeed Speedtest Server on CentOS"
date = "2021-03-13"
description = "Install a local speedtest server on CentOS or Ubuntu"
tags = [ "Guide" ]
layout = "blog"
+++

Speed test websites are invaluable for home internet users and system administrators alike. They are particularly helpful in troubleshooting internet issues. I recently rebuilt my companies VPN server and I wanted to test the speed between my computer and the internal network (over the VPN). We use split-tunneling, so a normal speedtset website wouldn't do the trick.

After some research I found the LibreSpeed speedtest that is easy to set up on an internal server. There aren't great installation instructions on the GitHub page, but the process is relatively straightforward (for anyone familar with Linux and Apache). I have provided instructions for [CentOS](https://www.centos.org) and [Ububtu](https://ubuntu.com/), two popouar Linux distributions. The CentOS instructions will work with [Rocky Linux](https://rockylinux.org) (the up-and-comming downstream Red Hat Enterprise Linux clone.)

*If a distribution is not specified in a step, then it is the same syntax for CentOS and Ubuntu.*

### Step 1: Install Apache and PHP

CentOS:   
```bash
sudo yum install httpd php
```  
Ububtu: 
```bash
sudo apt install apache2 php
```
### Step 2: Download the LibreSpeed seedtest

```bash
git clone https://github.com/librespeed/speedtest.git
cd speedtest  
```

### Step 3: Copy files to web server
```bash
sudo cp -R backend example-singleServer-pretty.html *js /var/www/html/
cd /var/www/html/
sudo mv example-singleServer-pretty.html index.html
```
### Step 4: Change ownership of files to Apache
```bash
sudo chown -R www-data
```

At this point you should have a working LibreSpeed Speedtest server. If you have a grphical interface, open a web browser and type `localhost` in the URL bar. Localhost references your local system. If you run the test now, the download and upload speeds will be very high since you are testing the connection from and to the same machine. This isn't a very useful test to run, so let's configure the server to be accessed from another computer on the same network.

### Step 5: Open a firewall port

CentOS (firewalld):  
```bash
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload
```

CentOS (iptables):
```bash
/sbin/iptables -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT
iptables-save > /etc/sysconfig/iptables
sudo systemctl restart iptables
```

Ubuntu:  
```bash
sudo ufw allow http
sudo ufw allow https
```

### Step 6: Configure Apache server
I am providing instructions for setting up the Apache server on port 80 (http) not https. If you know your way around Apache and have an SSL certificate to use, you can set up the https (443) VirtualHost and forward from http to https.

```bash
<VirtualHost <server_IP_address>:80>
        ServerName <custom_domain_name>
        DocumentRoot /var/www/html/

        <Directory "/var/www/html/">
                Options +FollowSymLinks
                AllowOverride All
                Require all granted
        </Directory>
</VirtualHost>
```

Replace `<server_IP_address>` with the server's IP address.  
Replace `<custom_domain_name>` with the domain name that will point to the website (e.g. `speedtest.example.com`).  

Restart the Apache server:

CentOS:  
```bash
sudo systemctl restart httpd
```

Ubuntu:  
```bash
sudo service apache2 restart
```

### Step 7: Add DNS record
You will need to configure your internal DNS server to point the custom domain name to the server's IP address. You will need to use an A record with speedtest.example.com as the key and the server's IP address as the value:

A `<custom_domain_name>` `<server_IP_address>`

### Finished
At this point, you should be able to access your speedtest server using your custom domain name. Type http://`<custom_domain_name>` into a web browser. If you don't see the speedtest website, there is likely an error in your Apache configuration. 

LibreSpeed has an option to install a MySQL database to keep track of the speedtest results. I am not going to cover that here, but may do so in a future post. It is not necessary to install the MySQL database to use the speedtest server and for my use case (testing the speed between my home network and my work network over the VPN) I chose not to.

You can compare the results between your network's internal LibreSpeed server and the public internet using LibreSpeed's website: https://librespeed.org. They have servers in several US states and eight other countries (at the time of writing).

I hope that you found these instructions useful. If you have any problems installing the LibreServer speedtest on your local network, feel free to reach out. I will do my best to respond and will update the instructions to clarify any confusing steps. 
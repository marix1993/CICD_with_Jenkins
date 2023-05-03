
# Provisioning for app vm
# Changing for the CI number 3
# Update the sources list
sudo apt-get update -y
# upgrade any packages available
sudo apt-get upgrade -y
# install nginx
sudo apt-get install nginx -y
# install git
sudo apt-get install git -y
# install nodejs
sudo apt-get install python-software-properties
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs -y
# install pm2
sudo npm install pm2 -g

# echo 'export DB_HOST=mongodb://192.168.10.150:27017/posts' | sudo tee -a /etc/environment
# source .bashrc

cd app
npm install
# node seeds/seed.js
# pm2 start seeds/seed.js
# pm2 start app.js
node app.js

### PRevious provision
## comment it when you make 2 VMs
#sudo apt update
#sudo apt upgrade -y
#sudo apt install nginx -y
#sudo apt-get install git -y
#sudo apt-get install python-software-properties -y
## curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
#curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
#
#sudo apt-get install nodejs -y
#
#sudo npm install pm2 -g 
#
#cd app
#npm install
## node app.js
#pm2 start app.js
#cd
## node app.js


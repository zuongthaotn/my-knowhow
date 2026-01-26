I. Prerequisites
1. NodeJS >=10.14.1 LTS
```
sudo apt-get install curl -y
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get update && sudo apt-get install nodejs -y
node -v
```
2. Yarn >=1.13.0
```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn -y
yarn -v
```
3. Python 2.7 and build tools, see the Installation instructions on node-gyp for your platform.
```
python --version
sudo apt-get install python -y

```
4. A running instance of Magento 2.3.1 or above

II. Install PWA-Studio
Step 1. Clone the PWA Studio repository
```
cd /var/www/html/pwa-studio
git clone https://github.com/magento/pwa-studio.git .
```
Step 2. Install PWA Studio dependencies
#If you have an existing node_modules directory from a previous PWA Studio version installation, remove it to prevent installation errors.
```
yarn install
```
Step 3. Create the .env file
```
MAGENTO_BACKEND_URL="https://magento2.mage-world.com/demo03/" yarn buildpack create-env-file packages/venia-concept
```
Update the .env file by change
MAGENTO_BACKEND_URL="https://magento2.mage-world.com/demo03/"
DEV_SERVER_HOST=magento2.mage-world.com
DEV_SERVER_PORT=555

Step 4. Generate SSL certificate
```
yarn buildpack create-custom-origin packages/venia-concept
```
Step 5. Start the server
```
yarn run build
yarn run watch:venia
```
III. Start pwa-studio as a service
Step 1: Create a Service
```
sudo adduser pwastudio
mkdir /home/pwastudio/workspace
sudo vim /etc/systemd/system/pwa-studio.service
```
Copy/paste the following into the file /etc/systemd/system/pwa-studio.service:
```sh
[Unit]
Description=Start pwa studio as a service
[Service]
User=pwastudio
# The configuration file application.properties should be here:
#change this to your workspace
WorkingDirectory=/home/pwastudio/workspace
#path to executable. 
#executable is a bash script which calls jar file
ExecStart=/home/ubuntu/workspace/pwa-webapp
SuccessExitStatus=143
TimeoutStopSec=10
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
```
2. Reload service
sudo systemctl daemon-reload
sudo systemctl enable pwa-studio.service
sudo systemctl start pwa-studio
sudo systemctl status pwa-studio

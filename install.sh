#! /bin/sh
# Download and execute the script from the URL
# Move the script to /etc/cron.monthly/ and set the execute permission
curl -o /etc/cron.monthly/speedtest.sh https://raw.githubusercontent.com/namakutyo/spidtest/main/speedtest.sh
chmod +x /etc/cron.monthly/speedtest.sh
echo "Script has been downloaded, executed, and placed in /etc/cron.monthly/ with execute permissions."
echo "*-----------------------------------*"
bash /etc/cron.monthly/speedtest.sh

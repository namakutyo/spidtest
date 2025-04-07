#!/bin/bash

# Check if Speedtest is already installed
if ! command -v speedtest &> /dev/null; then
    echo "Speedtest CLI not found. Installing..."

    # Detect OS and install Speedtest
    if [[ -f /etc/debian_version ]]; then
        echo "Detected Debian-based OS. Installing Speedtest CLI..."
        curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
        sudo apt-get install -y speedtest
    elif [[ -f /etc/redhat-release ]]; then
        echo "Detected CentOS-based OS. Installing Speedtest CLI..."
        curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.rpm.sh | sudo bash
        sudo yum install -y speedtest
    else
        echo "Unsupported OS"
        exit 1
    fi
else
    echo "Speedtest CLI is already installed. Skipping installation."
fi

RESULT=$(speedtest --accept-license --accept-gdpr | tee /tmp/speedtest_output)

RESULT_URL=$(grep -oP 'Result URL: \K.*' /tmp/speedtest_output)

DOWNLOAD_SPEED=$(grep -oP 'Download:\s+\K[0-9]+\.?[0-9]* Mbps' /tmp/speedtest_output)
UPLOAD_SPEED=$(grep -oP 'Upload:\s+\K[0-9]+\.?[0-9]* Mbps' /tmp/speedtest_output)

DATETIME=$(date '+%Y-%m-%d %H:%M:%S')

if [[ -f /var/tmp/alamat.txt ]]; then
    PREFIX=$(cat /var/tmp/alamat.txt | sed 's/\\$//')
    FINAL_RESULT="$PREFIX\nDatetime: $DATETIME\nDownload: $DOWNLOAD_SPEED\nUpload: $UPLOAD_SPEED\n$RESULT_URL"
else
    FINAL_RESULT="Datetime: $DATETIME\nDownload: $DOWNLOAD_SPEED\nUpload: $UPLOAD_SPEED\n$RESULT_URL"
fi

if [[ -n "$RESULT_URL" ]]; then
        WEBHOOK_URL="https://discord.com/api/webhooks/1352546413560725514/NBUANxNX2-l0jeB9Mu8ua15w29WmuhwYhp_ubXpKXM3-KThq_pvvom28lixjAS2W4U47"
        curl -H "Content-Type: application/json" \
             -X POST \
             -d "{\"content\": \"$FINAL_RESULT\"}" \
             "$WEBHOOK_URL"
             
         echo "Speedtest completed."
else
    echo "Failed to retrieve result URL."
fi

#!/bin/bash
# Wait for the network to come up
sleep 15

# Check if network interfaces are available
if ! ifconfig > /dev/null 2>&1; then
    echo "Error: ifconfig command not found or network interfaces not initialized."
    exit 1
fi

# Fetch ifconfig output to get IP address associated with the interface
ifconfig_output=$(ifconfig)

# Fetch iwconfig output to get the connected WiFi and interface
iwconfig_output=$(iwconfig 2>/dev/null || echo "iwconfig command not available")

# Extract the connected WiFi SSID and interface
connected_wifi=$(iwconfig 2>/dev/null | grep -oP 'ESSID:"\K[^"]+' || echo "Not connected")
wifi_interface=$(iwconfig 2>/dev/null | grep -oP '^\w+' | head -n 1 || echo "N/A")

# Fetch the IP address of the connected WiFi interface
ip_address=$(ifconfig $wifi_interface 2>/dev/null | grep -oP 'inet \K[\d.]+' | head -n 1 || echo "N/A")

# Prepare the message using Discord embed
message="{
  \"embeds\": [
    {
      \"title\": \"Network Information\",
      \"fields\": [
        {
          \"name\": \"Connected WiFi\",
          \"value\": \"$connected_wifi\",
          \"inline\": true
        },
        {
          \"name\": \"WiFi Interface\",
          \"value\": \"$wifi_interface\",
          \"inline\": true
        },
        {
          \"name\": \"IP Address\",
          \"value\": \"$ip_address\",
          \"inline\": true
        }
      ]
    }
  ]
}"

# Your Discord Webhook URL
webhook_url="YOUR_WEBHOOK_URL"

# Send the message to Discord Webhook
curl -H "Content-Type: application/json" \
     -X POST \
     -d "$message" \
     $webhook_url || echo "Failed to send the Discord message."

# Prepare the file content dynamically
file_content="ifconfig output:\n$ifconfig_output\n\niwconfig output:\n$iwconfig_output\n\nConnected WiFi: $connected_wifi\nWiFi Interface: $wifi_interface\nIP Address: $ip_address"

# Send the dynamically created file with a suitable name and extension
echo -e "$file_content" | curl -H "Content-Type: multipart/form-data" \
                               -X POST \
                               -F "file=@-;filename=network_info.txt" \
                               $webhook_url || echo "Failed to send the Discord file."

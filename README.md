# Network Information Script

This Bash script fetches network details (WiFi SSID, interface, IP address) and sends them to a Discord webhook. It also uploads a detailed log file and is configured to run at startup using `systemd`.

---

## Features
- Collects network details using `ifconfig` and `iwconfig`.
- Sends details as a Discord embed and uploads a log file.
- Runs automatically at system startup.

---

## Setup

### Dependencies
Install required tools:
```bash
sudo apt update
sudo apt install net-tools wireless-tools curl
```

### Script Setup
1. Place the `networkinfo.sh` script anywhere (e.g. `/var/www/html/` for my convenience with other automations) and make it executable
   ```bash
   sudo chmod +x /var/www/html/networkinfo.sh
   ```
2. Replace the webhook URL in the script:
   ```bash
   webhook_url="https://discord.com/api/webhooks/YOUR_WEBHOOK_URL"
   ```

### Configure `systemd`
1. Create a service file:
   ```bash
   sudo nano /etc/systemd/system/networkinfo.service
   ```
2. Add:
   ```ini
   [Unit]
   Description=Run networkinfo.sh at startup
   After=network-online.target
   Requires=network-online.target

   [Service]
   ExecStart=/var/www/html/networkinfo.sh
   Restart=on-failure

   [Install]
   WantedBy=multi-user.target
   ```
3. Enable the service:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable networkinfo.service
   sudo systemctl start networkinfo.service
   ```

---

## Example Output
**Discord Embed:**
- **Connected WiFi**: ExampleSSID
- **WiFi Interface**: wlan0
- **IP Address**: 192.168.0.101

**Uploaded File (`network_info.txt`):**
```
ifconfig output:
[Full output of ifconfig]

iwconfig output:
[Full output of iwconfig]

Connected WiFi: ExampleSSID
WiFi Interface: wlan0
IP Address: 192.168.0.101
```

---

## Troubleshooting
- **Permission Errors**: Ensure script has write permissions:
  ```bash
  sudo chmod +w /var/www/html/
  ```
- **Service Issues**: Check logs:
  ```bash
  sudo journalctl -u networkinfo.service
  ```

---

Happy coding !


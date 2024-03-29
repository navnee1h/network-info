import subprocess
import time
from dhooks import Webhook

def get_ip_address():
    try:
        # Get WLAN0 IP address
        output = subprocess.check_output(['hostname', '-I'], timeout=5).decode().strip()
        if output:
            ip_address = output.split()[0]
            return ip_address
        else:
            return None
    except subprocess.CalledProcessError as e:
        print("Error getting IP address:", e)
        return None
    except subprocess.TimeoutExpired:
        print("Timeout getting IP address")
        return None

def get_wifi_name():
    try:
        # Get connected WiFi network name
        wifi_name = subprocess.check_output(['iwgetid', '-r'], timeout=5).decode().strip()
        return wifi_name
    except subprocess.CalledProcessError as e:
        print("Error getting WiFi name:", e)
        return None
    except subprocess.TimeoutExpired:
        print("Timeout getting WiFi name")
        return None

def send_data(ip_address, wifi_name):
    hook = Webhook("https://discord.com/api/webhooks/1223353540513239040/KIj2MSQ8kK7NAt4GmLKh-TKNR5SuEVMBUpJ5qlGK_FzrU9dbsOGcQcVmxsB6D0jyzf0O")
    hook.send(f"My WLAN0 IP address is: {ip_address}\nConnected WiFi name: {wifi_name}")

def monitor_network():
    previous_wifi = None
    while True:
        try:
            current_wifi = get_wifi_name()
            if current_wifi != previous_wifi:
                ip_address = get_ip_address()
                if ip_address is not None and current_wifi is not None:
                    send_data(ip_address, current_wifi)
                    print("Network information sent to Discord.")
                    previous_wifi = current_wifi
        except Exception as e:
            print("An error occurred:", e)
        time.sleep(10)  # Check every 60 seconds

if __name__ == "__main__":
    monitor_network()

#!/usr/bin/env python3

import requests
import sys
import os

def read_ip_from_file(filename):
    try:
        if os.path.exists(filename):
            with open(filename, 'r') as f:
                return f.read().strip()
        return None
    except Exception as e:
        print(f"Error reading file: {e}", file=sys.stderr)
        return None

def get_current_ip():
    try:
        response = requests.get('https://ipv4.icanhazip.com', verify=False)
        if response.status_code == 200:
            return response.text.strip()
        print(f"Error: HTTP status code {response.status_code}", file=sys.stderr)
        return None
    except Exception as e:
        print(f"Error making HTTP request: {e}", file=sys.stderr)
        return None

# Disable SSL warnings
import urllib3
#urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def write_ip_to_file(filename, ip):
    try:
        with open(filename, 'w') as f:
            f.write(ip)
        return True
    except Exception as e:
        print(f"Error writing to file: {e}", file=sys.stderr)
        return False

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 check_nat_ip.py <ip_file>", file=sys.stderr)
        sys.exit(1)

    ip_file = sys.argv[1]
    stored_ip = read_ip_from_file(ip_file)
    current_ip = get_current_ip()

    if current_ip is None:
        sys.exit(1)

    if stored_ip != current_ip:
        if write_ip_to_file(ip_file, current_ip):
            print(f"IP updated from {stored_ip} to {current_ip}")
        else:
            sys.exit(1)
    else:
        print("IP unchanged")

if __name__ == "__main__":
    main()

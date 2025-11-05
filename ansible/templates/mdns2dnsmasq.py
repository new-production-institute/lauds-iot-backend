#!/usr/bin/env python3
# /usr/local/bin/update_mdns_dnsmasq.py
import subprocess
import re
import os
import socket
from time import sleep

# make sure you uncomment the use of /etc/dnsmasq.d in dnsmasq.conf
DNSMASQ_CONF_PATH = "/etc/dnsmasq.d/mdns.conf"
# DNSMASQ_CONF_PATH = "/home/devuan/mdns.conf"
# kinda obvious, I know
DNSMASQ_SERVICE = "dnsmasq"
# make sure we resolve these hostnames in case they're not being announced often enough
FORCE_RESOLVE = ["home", "borg", "diskstation", "platinum"]

def read_existing_mdns_entries(filepath):
    """Grab existing entries"""
    entries = set()
    if not os.path.exists(filepath):
        return entries
    with open(filepath, "r") as f:
        for line in f:
            if line.strip() and not line.startswith("#"):
                parts = line.strip().split("/")
                if len(parts) == 2:
                    hostname, ip = parts
                    entries[hostname.strip()] = ip.strip()
    return entries

def discover_mdns_hosts(timeout=30):
    """Run avahi-browse with a sizable timeout and parse verbose output."""
    try:
        output = subprocess.run(
            ["/usr/bin/timeout", f"{timeout}", "avahi-browse", "-a", "-r"],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        )
    except subprocess.CalledProcessError as e:
        return []

    hosts = set()
    current_hostname = None
    current_address = None

    for line in output.stdout.splitlines():
        line = line.strip()
        if "hostname" in line:
            match = re.search(r"hostname = \[(.+?)\]", line)
            if match:
                current_hostname = match.group(1)
        elif "address" in line:
            match = re.search(r"address = \[(.+?)\]", line)
            if match:
                current_address = match.group(1)

        # When both are captured, store and reset
        if current_hostname and current_address:
            if current_hostname.endswith(".local") and re.match(r"\d+\.\d+\.\d+\.\d+", current_address):
                hosts.add((current_hostname, current_address))
            current_hostname = None
            current_address = None

    for host in FORCE_RESOLVE:
        name = f"{host}.local"
        try:
            ip = socket.gethostbyname(name)
            hosts.add((name, ip))
        except:
            pass

    return sorted(hosts)

def write_dnsmasq_config(hosts):
    """Write out a nice configuration file"""
    lines = [f"address=/{hostname}/{ip}" for hostname, ip in hosts]
    config = "\n".join(lines) + "\n"
    with open(DNSMASQ_CONF_PATH, "w") as f:
        f.write(config)

def restart_dnsmasq():
    """Reload doesn't actually force file reads, so we need to be more assertive here"""
    subprocess.run(["service", DNSMASQ_SERVICE, "restart"], check=False)

def main():
    while True:
        existing = read_existing_mdns_entries(DNSMASQ_CONF_PATH)
        existing.update(discover_mdns_hosts(30))
        write_dnsmasq_config(sorted(existing))
        restart_dnsmasq()
        sleep(30)

if __name__ == "__main__":
    main()


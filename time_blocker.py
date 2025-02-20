#!/usr/bin/env python3

import argparse
import os
import subprocess
from datetime import datetime, timedelta

# Get target host from environment variable
TARGET_HOST = os.getenv("TARGET_HOST", "undefined-host")
PLAYBOOK_PATH = "/opt/meta-trader/time_restriction.yml"

if TARGET_HOST == "undefined-host":
    print("Error: TARGET_HOST environment variable is not set.")
    exit(1)

# Define argument parser
parser = argparse.ArgumentParser(description="Block access for a given duration and schedule unblock with Ansible.")
parser.add_argument("--hours", type=int, default=0, help="Number of hours to block access.")
parser.add_argument("--days", type=int, default=0, help="Number of days to block access.")
parser.add_argument("--weeks", type=int, default=0, help="Number of weeks to block access.")
parser.add_argument("--months", type=int, default=0, help="Number of months to block access.")

args = parser.parse_args()

# Calculate unblock time
now = datetime.now()
unblock_time = now + timedelta(
    hours=args.hours, 
    days=args.days + (args.weeks * 7) + (args.months * 30)  # Approximate a month as 30 days
)
unblock_time_str = unblock_time.isoformat()

# Confirmation prompt
print("\n=== Access Block Confirmation ===")
print(f"Target Host: {TARGET_HOST}")
print(f"Access will be blocked until: {unblock_time_str}")
print("WARNING: Once confirmed, this cannot be changed!\n")

confirm = input("Type 'CONFIRM' to proceed: ")
if confirm.strip().upper() != "CONFIRM":
    print("Operation canceled.")
    exit(0)

# Run the Ansible playbook with the unblock time as an extra variable
ansible_command = [
    "ansible-playbook", 
    "-i", TARGET_HOST + ",",  # Single target inventory
    PLAYBOOK_PATH,
    "--extra-vars", f"unblock_time='{unblock_time_str}'"
]

if TARGET_HOST == "localhost":
    ansible_command.append("--connection=local")

print("\nExecuting Ansible playbook to block access...")
subprocess.run(ansible_command, check=True)

print("Access blocked. It will be unblocked by Ansible at the scheduled time.")

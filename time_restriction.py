#!/usr/bin/env python3

import argparse
import os
import subprocess
from datetime import datetime, timedelta

# Get target host from environment variable
TARGET_HOST = os.getenv("TARGET_HOST", "undefined-host")
PLAYBOOK_PATH = "/opt/metatrader-setup/time_restriction.yml"

if TARGET_HOST == "undefined-host":
    print("TARGET_HOST environment variable is not set, enter the host you want to restrict (use localhost it is this one).")
    TARGET_HOST = input("Target Host: ")

# Define argument parser
parser = argparse.ArgumentParser(description="Block access for a given duration and schedule unblock with Ansible.")
parser.add_argument("target_host", type=str, nargs="?", default=TARGET_HOST, help="Target host to block access.")
parser.add_argument("--minutes", type=int, default=None, help="Number of minutes to block access.")
parser.add_argument("--hours", type=int, default=None, help="Number of hours to block access.")
parser.add_argument("--days", type=int, default=None, help="Number of days to block access.")
parser.add_argument("--weeks", type=int, default=None, help="Number of weeks to block access.")
parser.add_argument("--months", type=int, default=None, help="Number of months to block access.")
parser.add_argument("--timezone", type=str, default=None, help="Timezone for unblock time.")
args = parser.parse_args()

# Prompt for values if not provided
if args.hours is None:
    args.hours = int(input("Enter number of hours (press Enter for 0): ") or "0")
if args.days is None:
    args.days = int(input("Enter number of days (press Enter for 0): ") or "0")
if args.weeks is None:
    args.weeks = int(input("Enter number of weeks (press Enter for 0): ") or "0")
if args.months is None:
    args.months = int(input("Enter number of months (press Enter for 0): ") or "0")
if args.timezone is None:
    args.timezone = input("Enter timezone (press Enter for Europe/Berlin time): ") or "Europe/Berlin"
# Validate input
if args.minutes is None and args.hours == 0 and args.days == 0 and args.weeks == 0 and args.months == 0:
    print("At least one of --minutes, --hours, --days, --weeks, or --months must be provided.")
    exit(1)

# Calculate unblock time
now = datetime.now()
unblock_time = now + timedelta(
    hours=args.hours, 
    days=args.days + (args.weeks * 7) + (args.months * 30)
)

# Format unblock time as string with timezone
unblock_time_str = unblock_time.strftime("%Y-%m-%d %H:%M:%S %Z")
unblock_time_str = unblock_time_str.replace("UTC", args.timezone)

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
    "--extra-vars", f"unblock_date='{unblock_time_str}' timezone={args.timezone}"
]

if TARGET_HOST == "localhost":
    ansible_command.append("--connection=local")

print("\nExecuting Ansible playbook to block access...")
subprocess.run(ansible_command, check=True)

print("Access blocked. It will be unblocked by Ansible at the scheduled time.")

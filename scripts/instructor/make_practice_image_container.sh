#!/usr/bin/env bash
set -euo pipefail

# Container-based version - works on Mac, Windows, and Linux
# Creates the same enhanced practice image but uses Docker for filesystem operations

mkdir -p evidence cases
IMG="evidence/usb.img"

echo "[*] Creating 100MB EXT4 image at $IMG using Docker"
dd if=/dev/zero of="$IMG" bs=1M count=100 status=progress

echo "[*] Creating and mounting filesystem in Docker container"
docker compose run --rm dfir bash -c "
# Create the filesystem
mkfs.ext4 -F /evidence/usb.img

# Create mount point and mount
mkdir -p /mnt/practice
mount -o loop /evidence/usb.img /mnt/practice

echo '[*] Creating realistic Cloudcore investigation scenario'

# Create directory structure matching the storyline
mkdir -p /mnt/practice/home/alex/Documents /mnt/practice/home/alex/Downloads /mnt/practice/tmp
mkdir -p /mnt/practice/var/log

# Create realistic files that would be in the case
cat > /mnt/practice/home/alex/Documents/project_secrets.txt << 'EOF'
Project Cloudcore - Confidential Source Code
This file contains proprietary algorithms and client data.
DO NOT DISTRIBUTE - Internal Use Only

Client: MegaCorp Inc.
Project: Cloud Migration System
Status: In Development
Last Modified: December 2009

// Sample source code
function encryptData(data) {
    var key = 'cloudcore_secret_2009';
    return AES.encrypt(data, key);
}

// Database credentials (TEMPORARY)
db_host = '192.168.1.100'
db_user = 'alex_doe'
db_pass = 'TempPass_2009!'
EOF

# Create a more substantial file (the zip file mentioned in storyline)
echo '[*] Creating project_secrets.zip...'
cd /mnt/practice/home/alex/Documents
zip -r project_secrets.zip project_secrets.txt >/dev/null 2>&1
rm project_secrets.txt

# Create some log entries with realistic timestamps
echo 'Dec  5 14:30:01 workstation kernel: USB device connected' >> /mnt/practice/var/log/syslog
echo 'Dec  5 14:31:15 workstation sudo: alex_doe : TTY=pts/0 ; PWD=/home/alex ; USER=root ; COMMAND=/bin/mount /dev/sdb1 /mnt/usb' >> /mnt/practice/var/log/auth.log
echo 'Dec  5 14:32:22 workstation cp: copied \"/home/alex/Documents/project_secrets.zip\" to \"/mnt/usb/\"' >> /mnt/practice/var/log/syslog

# Create the flag.txt file (for original lab exercise)
echo 'FLAG{digital_forensics_cloudcore_case_2009}' > /mnt/practice/flag.txt

# Create some additional files to make it more realistic
cat > /mnt/practice/tmp/email_draft.txt << 'EOF'
Email to exfil@personal.com
Subject: Project Update
Attached: project_secrets.zip
Contents: Sensitive code - exfiltrated
EOF

cat > /mnt/practice/tmp/truecrypt_config.txt << 'EOF'
TrueCrypt Volume Configuration
Volume Type: Hidden
Size: 50MB
Encryption: AES-256
Created: 2009-12-05
Purpose: Secure data transfer
EOF

sync
sleep 2

echo '[*] Simulating file deletion (evidence staging)'
# Delete the files to simulate hiding evidence
rm /mnt/practice/flag.txt
rm /mnt/practice/tmp/email_draft.txt
rm /mnt/practice/tmp/truecrypt_config.txt
rm /mnt/practice/home/alex/Documents/project_secrets.zip

sync
sleep 2

# Unmount before exiting
umount /mnt/practice
echo '[*] Practice image created successfully in container!'
"

echo "[*] Practice image creation complete!"
echo "[*] Evidence includes:"
echo "    - Deleted flag.txt (for recovery exercise)"
echo "    - Deleted project_secrets.zip (case evidence)"
echo "    - Deleted email drafts and TrueCrypt config"
echo "    - System logs with USB activity"
echo "[*] Use tsk_recover and foremost to find deleted files"
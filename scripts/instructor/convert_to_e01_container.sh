#!/usr/bin/env bash
set -euo pipefail

# Container-based E01 conversion - works on Mac, Windows, and Linux
# Converts usb.img to E01 format using Docker

IMG="evidence/usb.img"
E01="evidence/usb.e01"

if [ ! -f "$IMG" ]; then
    echo "[!] Error: $IMG not found. Run make_practice_image_container.sh first."
    exit 1
fi

echo "[*] Converting $IMG to E01 format using Docker..."
echo "[*] This creates an industry-standard E01 evidence file"

# Use the dfir container to convert to E01 format
docker compose run --rm dfir bash -c "
echo '[*] Converting /evidence/usb.img to /evidence/usb.e01...'
ewfexport -c -t 'Cloudcore Investigation - Lab 1 Practice Image' -e 'Digital Forensics Training' -o /evidence/usb.e01 /evidence/usb.img

echo '[*] Conversion complete!'
echo '[*] Created: /evidence/usb.e01'
echo '[*] You can now use either usb.img or usb.e01 for analysis'

# Show file sizes for comparison
echo ''
echo '[*] File size comparison:'
ls -lh /evidence/usb.img /evidence/usb.e01

echo ''
echo '[*] To verify E01 file integrity:'
echo '    ewfverify /evidence/usb.e01'
echo ''
echo '[*] To use E01 in Sleuth Kit:'
echo '    fls -f ewf -r -m / /evidence/usb.e01'
echo '    tsk_recover -f ewf -a /evidence/usb.e01 /path/to/recovery'
"
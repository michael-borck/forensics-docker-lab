#!/usr/bin/env bash
# make_usb_image.sh — generate the Lab 1 USB forensic evidence
#
# Produces:
#   evidence/usb.img   — FAT32 forensic image, volume label "PRACTICE",
#                        containing DELETED scenario files (recoverable via
#                        Sleuth Kit icat/tsk_recover and carvable via foremost)
#   evidence/usb.E01   — EnCase E01 wrapper of the same image (teaches
#                        ewfmount / ewfverify)
#
# The filesystem tools (mtools, dosfstools, ewf-tools) run INSIDE the dfir
# container, so this works on macOS, Windows and Linux with no host tooling.
# It needs NO privileged mode and NO host loopback mounting.
#
# Usage:   ./scripts/make_usb_image.sh        (or: make evidence)
# Override image size: USB_IMAGE_MB=128 ./scripts/make_usb_image.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

IMG="evidence/usb.img"
E01="evidence/usb.E01"

mkdir -p evidence

# macOS on non-APFS volumes litters AppleDouble "._*" files that break the
# Docker build-context walk (xattr read fails). Safe to remove (resource forks).
if [ "$(uname -s)" = "Darwin" ]; then
    find . -name '._*' -not -path './.git/*' -delete 2>/dev/null || true
    find . -name '.DS_Store' -not -path './.git/*' -delete 2>/dev/null || true
fi

# Resolve the dfir image (same name docker-compose.yml pulls). Override with
# DFIR_IMAGE=... if you use a different registry. Prefer the prebuilt image
# (fast pull); fall back to a local build only if the pull fails (offline /
# private package).
DFIR_IMAGE="${DFIR_IMAGE:-ghcr.io/michael-borck/dfir-cli:latest}"
if ! docker image inspect "$DFIR_IMAGE" >/dev/null 2>&1; then
  echo "[*] Obtaining forensic image ($DFIR_IMAGE)..."
  if ! docker pull "$DFIR_IMAGE"; then
    echo "[*] Pull failed — building locally (~2-5 min)..."
    docker compose build dfir
  fi
fi

echo "[*] Generating USB evidence inside the dfir container..."
echo "    (evidence/ is mounted read-write for generation; it is normally"
echo "     mounted read-only during analysis)"
echo

# Mount evidence/ read-write (docker-compose mounts it read-only for analysis).
# The generation script is piped to bash via stdin.
docker run --rm -i \
  -v "$REPO_ROOT/evidence:/evidence" \
  -e USB_IMAGE_MB="${USB_IMAGE_MB:-64}" \
  "$DFIR_IMAGE" bash -s <<'CONTAINER_SCRIPT'
set -euo pipefail
cd /tmp

IMG=/evidence/usb.img
E01_BASE=/evidence/usb
SIZE_MB="${USB_IMAGE_MB:-64}"

echo "[*] Creating ${SIZE_MB}MB FAT32 image labelled PRACTICE..."
dd if=/dev/zero of="$IMG" bs=1M count="$SIZE_MB" status=none
mkfs.vfat -F 32 -n PRACTICE "$IMG" >/dev/null 2>&1

echo "[*] Planting Cloudcore-2009 scenario evidence..."

# Directory structure
mmd -i "$IMG" ::/Documents ::/tmp ::/var ::/var/log 2>/dev/null || true

# Confidential document (recoverable via icat / tsk_recover)
cat > project_secrets.txt <<'TXT'
Project Cloudcore - Confidential Source Code
DO NOT DISTRIBUTE - Internal Use Only

Client: MegaCorp Inc.
Project: Cloud Migration System
Status: In Development
Last Modified: December 2009

function encryptData(data) {
    var key = 'cloudcore_secret_2009';
    return AES.encrypt(data, key);
}

db_host = '192.168.1.100'
db_user = 'alex_doe'
db_pass = 'TempPass_2009!'
TXT
mcopy -i "$IMG" project_secrets.txt ::/Documents/project_secrets.txt

# Password / flag file (recovery exercise)
echo 'FLAG{digital_forensics_cloudcore_case_2009}' > flag.txt
mcopy -i "$IMG" flag.txt ::/flag.txt

# A real ZIP archive (carvable by foremost via its PK\x03\x04 header)
python3 - <<'PY'
import zipfile
with zipfile.ZipFile("project_secrets.zip", "w", zipfile.ZIP_DEFLATED) as z:
    z.writestr("source.txt",
               "Cloudcore proprietary algorithm\n"
               "MegaCorp client data\nDO NOT DISTRIBUTE\n")
PY
mcopy -i "$IMG" project_secrets.zip ::/Documents/project_secrets.zip

# Email draft + crypto-container config (incident storyline)
cat > email_draft.txt <<'TXT'
Email to exfil@personal.com
Subject: Project Update
Attached: project_secrets.zip
Contents: Sensitive code - exfiltrated
TXT
mcopy -i "$IMG" email_draft.txt ::/tmp/email_draft.txt

cat > truecrypt_config.txt <<'TXT'
TrueCrypt Volume Configuration
Volume Type: Hidden
Encryption: AES-256
Created: 2009-12-05
Purpose: Secure data transfer
TXT
mcopy -i "$IMG" truecrypt_config.txt ::/tmp/truecrypt_config.txt

# Log fragments consistent with the storyline
cat > syslog_fragment.txt <<'TXT'
Dec  5 14:30:01 workstation kernel: USB device connected
Dec  5 14:31:15 workstation sudo: alex_doe : COMMAND=/bin/mount /dev/sdb1 /mnt/usb
Dec  5 14:32:22 workstation cp: copied project_secrets.zip to USB
TXT
mcopy -i "$IMG" syslog_fragment.txt ::/var/log/syslog

# Simulate deletion: directory entries are marked free, but the data clusters
# remain in unallocated space until overwritten -> recoverable / carvable.
echo "[*] Simulating deletion of evidence files..."
mdel -i "$IMG" \
  ::/Documents/project_secrets.txt \
  ::/Documents/project_secrets.zip \
  ::/flag.txt \
  ::/tmp/email_draft.txt \
  ::/tmp/truecrypt_config.txt
sync

# Build the EnCase E01 wrapper (teaches ewfmount / ewfverify)
echo "[*] Converting raw image to EnCase E01 format..."
rm -f "${E01_BASE}.E01"
ewfacquirestream -t "$E01_BASE" < "$IMG" >/dev/null 2>&1

echo
echo "[*] Verification:"
echo "    fsstat:"; fsstat "$IMG" 2>/dev/null \
  | grep -iE "File System Type|Volume Label \(Boot Sector\)" | head -2 | sed 's/^/      /'
echo "    recoverable deleted entries (fls):"
fls -r "$IMG" 2>/dev/null | grep '\*' | sed 's/^/      /'
echo "    E01 integrity:"; ewfverify "${E01_BASE}.E01" 2>&1 | grep -i success | sed 's/^/      /'
echo
echo "[*] Evidence generation complete."
CONTAINER_SCRIPT

echo
echo "✓ USB evidence ready for Lab 1 (USB_Imaging):"
ls -lh "$IMG" "$E01" 2>/dev/null | awk '{print "   ", $5"\t"$9}'

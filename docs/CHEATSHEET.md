# Forensics Lab Cheatsheet

Quick reference for tools, commands, and workflows.

---

## 🛠️ Tools Installed in Workstation

### File System & Disk Analysis
- **Sleuth Kit** (fls, icat, fsstat, tsk_recover, mmls, blkls) - Filesystem analysis & recovery
- **TestDisk/PhotoRec** - File carving and recovery
- **Foremost** - Signature-based file carving
- **libewf-tools** - E01 (Expert Witness Format) image support
- **exiftool** - Metadata extraction from files and images

### Memory Forensics
- **Volatility 3** (vol) - Modern Windows memory forensics (Windows 7+)
- **Volatility 2** (vol2) - Legacy Windows memory forensics (Windows XP/Vista/2000)

### Malware & Pattern Detection
- **YARA** - Malware pattern matching and detection
- **ClamAV** - Antivirus engine

### Hashing & Verification
- **hashdeep** - Multi-algorithm hashing
- **sha256sum, md5sum** - Standard hashing utilities

### General Utilities
- **grep, strings, sed, awk** - Text processing and searching
- **vim, nano** - Text editors
- **file** - File type identification
- **xxd** - Hexdump utility
- **less, more** - Paging utilities

---

## 📊 Lab 1: USB_Imaging - Quick Commands

### Mount and Verify Evidence
```bash
# Verify E01 file integrity
ewfverify /evidence/usb.E01

# Mount E01 image
mkdir -p /tmp/ewf
ewfmount /evidence/usb.E01 /tmp/ewf

# Or use raw image directly
mkdir -p USB_Imaging/output
```

### File System Analysis
```bash
# List all files (including deleted)
fls -r /evidence/usb.img > USB_Imaging/output/fls.txt

# List with mactime format
fls -r -m / /evidence/usb.img > USB_Imaging/output/fls_mactime.txt

# Display partition table
mmls /evidence/usb.img

# Show file system info
fsstat /evidence/usb.img

# Extract specific file by inode
icat /evidence/usb.img 12345 > USB_Imaging/output/recovered_file.txt
```

### Deleted File Recovery
```bash
# Recover all files (allocated and unallocated)
mkdir -p USB_Imaging/recovered
tsk_recover -a /evidence/usb.img USB_Imaging/recovered

# List recovered files
ls -lah USB_Imaging/recovered | head -20
```

### File Carving (Signature-based)
```bash
# Carve files by signature
mkdir -p USB_Imaging/carved
foremost -i /evidence/usb.img -o USB_Imaging/carved

# View carved results
ls -lah USB_Imaging/carved/*/
```

### Metadata & File Information
```bash
# Extract metadata from recovered images
exiftool USB_Imaging/recovered/*.jpg > USB_Imaging/output/metadata.txt

# Recursive metadata extraction
exiftool -r USB_Imaging/recovered/ > USB_Imaging/output/all_metadata.txt

# File type identification
file USB_Imaging/recovered/* | sort | uniq -c
```

### Search & Pattern Matching
```bash
# Search for text patterns
grep -i "password" USB_Imaging/recovered/*.txt

# Search for strings in binary files
strings /evidence/usb.img | grep -i "secret"

# YARA scanning (if rules are available)
yara /rules/malware.yar /evidence/usb.img
```

### Chain of Custody
```bash
# Hash the evidence file
sha256sum /evidence/usb.E01 > USB_Imaging/output/evidence_hash.txt

# Log actions for CoC
coc-log "fls -r /evidence/usb.img" "Initial filesystem listing"
```

---

## 🧠 Lab 2: Memory_Forensics - Quick Commands

### Profile Identification
```bash
# Identify memory dump profile
docker compose exec vol2 vol.py -f /evidence/memory.raw imageinfo
```

### Process Analysis
```bash
# List running processes
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 pslist > Memory_Forensics/vol_output/pslist.txt

# Process tree (parent-child relationships)
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 pstree > Memory_Forensics/vol_output/pstree.txt

# Scan for hidden processes
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 psscan > Memory_Forensics/vol_output/psscan.txt
```

### Network Analysis
```bash
# Network connections (XP-specific)
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 connections > Memory_Forensics/vol_output/connections.txt

# Sockets (alternative to connections)
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 sockets > Memory_Forensics/vol_output/sockets.txt
```

### Process Memory & Artifacts
```bash
# Dump process memory (replace <pid> with actual PID)
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 procdump -p <pid> -D Memory_Forensics/vol_output/

# List DLLs for a process
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 dlllist -p <pid>

# Command line arguments
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 cmdline
```

### Inside Workstation - Analyzing Results
```bash
# Search for suspicious processes
grep -i "truecrypt\|tor\|proxy" Memory_Forensics/vol_output/pslist.txt

# Find IRC connections (port 6667)
grep "6667" Memory_Forensics/vol_output/connections.txt

# Extract PIDs and executable names
awk '{print $1, $7}' Memory_Forensics/vol_output/pslist.txt
```

---

## 🔍 Lab 3: Autopsy_GUI - Quick Reference

### Start Autopsy
```bash
# Start Autopsy container (from host)
docker compose up -d autopsy

# Access via browser
# http://localhost:8080/vnc.html
```

### Workflow
1. **Create Case** → Enter case name and base directory
2. **Add Data Source** → Select Evidence file (usb.E01)
3. **Configure Ingest** → Select modules (Hash Lookup, Keyword Search, etc.)
4. **Start Ingest** → Wait for processing
5. **Analyze Results** → Browse file system, search, view reports
6. **Export Report** → HTML or PDF

### Stop Autopsy
```bash
docker compose down autopsy
```

---

## 📧 Lab 4: Email_Logs - Quick Commands

### Log Analysis
```bash
# View email logs
head -100 Email_Logs/email_evidence.txt

# Count entries
wc -l Email_Logs/email_evidence.txt

# Filter by criteria
grep "suspicious@" Email_Logs/email_evidence.txt

# Extract sender addresses
grep -o '[a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]*' Email_Logs/email_evidence.txt | sort | uniq
```

### Pattern Matching
```bash
# Find password references
grep -i "password\|passwd\|pwd" Email_Logs/email_evidence.txt

# Find exfiltration indicators
grep -i "leak\|copy\|steal\|exfil\|confidential" Email_Logs/email_evidence.txt

# Find URLs in logs
grep -oE 'https?://[^ ]+' Email_Logs/email_evidence.txt
```

### Python Analysis (if available)
```bash
# Run custom analysis script
python3 Email_Logs/analyse_emails.py

# Parse CSV logs
awk -F',' '{print $1, $5}' Email_Logs/email_logs.csv | sort | uniq -c
```

---

## 🌐 Lab 5: Network_Analysis - Quick Commands

### Packet Analysis (run on host, not inside workstation)
```bash
# View all packets
tshark -r evidence/network.cap | head -50

# Filter by protocol
tshark -r evidence/network.cap -Y "irc"
tshark -r evidence/network.cap -Y "http"
tshark -r evidence/network.cap -Y "dns"

# Show only conversation summary
tshark -r evidence/network.cap -q -z conv,ip
```

### Extract Objects
```bash
# Extract HTTP objects
tshark -r evidence/network.cap --export-objects http,Network_Analysis/http_objects

# Extract DNS queries
tshark -r evidence/network.cap -Y "dns" -e "dns.qry.name" | sort | uniq
```

### IRC Detection (Command & Control)
```bash
# Find IRC traffic (port 6667)
tshark -r evidence/network.cap -Y "tcp.port==6667"

# Extract IRC commands
tshark -r evidence/network.cap -Y "irc" -e "data"

# Look for JOIN, PRIVMSG, etc.
grep -i "join\|privmsg\|nick" Network_Analysis/irc_traffic.txt
```

### Inside Workstation - Analysis
```bash
# View captured traffic details
less Network_Analysis/network_summary.txt

# Search for patterns
grep -i "malware\|bot\|command" Network_Analysis/*.txt
```

---

## 📝 Lab 6: Final_Report - Synthesis

### Timeline Construction
```bash
# Create timeline from Plaso
docker compose run --rm plaso log2timeline.py /cases/Final_Report/timeline.plaso /evidence/usb.img

# Export to CSV
docker compose run --rm plaso psort.py -o l2tcsv /cases/Final_Report/timeline.plaso > Final_Report/timeline.csv

# Filter timeline by date
docker compose run --rm plaso psort.py -o l2tcsv /cases/Final_Report/timeline.plaso "date > '2009-10-01' AND date < '2009-10-31'" > Final_Report/october_timeline.csv
```

### Correlation Matrix
```bash
# Create evidence summary
echo "=== Evidence Summary ===" > Final_Report/correlation_matrix.txt
echo "USB Evidence: $(ls -lh /evidence/usb.E01 | awk '{print $5}')" >> Final_Report/correlation_matrix.txt
echo "Memory Dump: $(ls -lh /evidence/memory.raw | awk '{print $5}')" >> Final_Report/correlation_matrix.txt
echo "Network Capture: $(ls -lh /evidence/network.cap | awk '{print $5}')" >> Final_Report/correlation_matrix.txt
```

### Report Writing
```bash
# Copy report template
cp templates/WORKBOOK.md Final_Report/report.md

# Edit report
nano Final_Report/report.md

# Include findings from all labs
# - USB_Imaging artifacts
# - Memory_Forensics processes
# - Autopsy_GUI findings
# - Email_Logs evidence
# - Network_Analysis indicators
# - Timeline correlation
```

---

## 🔐 Chain of Custody & Verification

### Logging Commands
```bash
# Log a command with note
coc-log "fls -r /evidence/usb.img" "Initial filesystem listing"

# Log with analysis results
coc-log "grep password USB_Imaging/*" "Password search results"
```

### Hash Verification
```bash
# Hash a single file
sha256sum /evidence/usb.E01

# Hash all recovered files
hashdeep -r -c sha256 USB_Imaging/recovered/ > USB_Imaging/recovered_hashes.txt

# Verify hashes
sha256sum -c USB_Imaging/recovered_hashes.txt
```

### Evidence Manifest
```bash
# Create manifest of all evidence
find USB_Imaging -type f -exec sha256sum {} \; > USB_Imaging/evidence_manifest.txt

# Count recovered files
find USB_Imaging/recovered -type f | wc -l
```

---

## 💡 General Tips & Tricks

### Working Efficiently
```bash
# Use tab-completion for file paths
fls -r /evidence/usb<TAB>

# Pipe commands together
fls -r /evidence/usb.img | grep ".txt"

# Redirect output to file
fls -r /evidence/usb.img > USB_Imaging/fls_complete.txt

# View large files with less
less USB_Imaging/fls_complete.txt
# Use arrows, Page Up/Down, press q to quit

# Count lines in file
wc -l USB_Imaging/fls_complete.txt

# Search in file
grep -n "suspicious_word" USB_Imaging/fls_complete.txt
```

### Text Processing
```bash
# Extract specific columns from CSV
awk -F',' '{print $1, $3, $5}' evidence.csv

# Sort and count unique entries
sort Evidence.txt | uniq -c | sort -rn

# Replace text in file
sed 's/old_text/new_text/g' file.txt

# View first N lines
head -50 large_file.txt

# View last N lines
tail -20 large_file.txt

# Show difference between files
diff file1.txt file2.txt
```

### Working with Binary Files
```bash
# View hex dump
xxd /evidence/usb.img | head -20

# Search for strings
strings /evidence/usb.img | grep password

# File type identification
file /evidence/usb.E01

# Mount filesystems
mount /evidence/usb.img /tmp/mount_point
```

---

## 🔗 Quick Links

- **Full Documentation:** See `docs/README.md`
- **Case Background:** See `docs/SCENARIO.md`
- **Command Reference:** See `docs/COMMANDS.md`
- **Troubleshooting:** See `docs/TROUBLESHOOTING.md`
- **Lab-Specific Details:** See `cases/[Lab_Name]/WALKTHROUGH.md`

---

## 🆘 Need More Help?

```bash
# View man pages (inside workstation)
man fls
man grep
man vol

# Get help for tools
vol --help
fls --help
foremost --help

# Search online documentation
# Sleuth Kit: https://sleuthkit.org/sleuthkit/docs.php
# Volatility: https://volatility3.readthedocs.io/
```

---

*Forensics Lab Cheatsheet v1.0*

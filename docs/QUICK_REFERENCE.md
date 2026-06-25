# Quick Reference - New Immersive Features

## For Students

### Starting Your Investigation

**Old Way (Don't do this):**
```bash
docker compose run --rm dfir
```

**New Way (Do this instead):**
```bash
./scripts/forensics-workstation
```

Then enter your analyst name when prompted. You'll see:
```
analyst@forensics-lab:/cases$
```

### Running Forensic Commands

**Inside the forensic workstation, run commands naturally:**
```bash
# Verify evidence integrity
ewfverify /evidence/usb.E01

# Mount the USB evidence
mkdir -p /tmp/ewf
ewfmount /evidence/usb.E01 /tmp/ewf

# List files
fls -r /tmp/ewf/ewf1
```

### Logging Commands for Chain of Custody

**Instead of manually documenting, use coc-log:**
```bash
# Format: coc-log "command" "description"
coc-log "fls -r /tmp/ewf/ewf1" "Initial filesystem listing of USB evidence"
```

**What coc-log does automatically:**
- Records timestamp (UTC)
- Records your analyst name
- Executes the command
- Captures all output
- Calculates SHA256 hash of output
- Saves output to file
- Logs entry to `cases/Lab_X/analysis_log.csv`

**Result: Professional chain of custody documentation**

### Checking Your Chain of Custody Log

```bash
# Inside the workstation
cat /cases/USB_Imaging/analysis_log.csv

# Outside the workstation
cat cases/USB_Imaging/analysis_log.csv
```

---

## For Instructors

### Accessing Instructor Materials

```bash
# Switch to instructor branch
git checkout instructor

# View answer key for Lab 1
cat cases/USB_Imaging/instructor/answer_key.md

# View instructor notes
cat cases/USB_Imaging/instructor/INSTRUCTOR_NOTES.md

# View grading rubric
cat cases/USB_Imaging/instructor/rubric.csv
```

### Distributing to Students

**Students should:**
1. Clone from main branch (default): `git clone <repo>`
2. Never see instructor/ folders
3. Not have access to answer keys

**Verify:** `ls cases/USB_Imaging/` - should NOT show `instructor/` folder

### Reviewing Student Work

```bash
# Check student's chain of custody log
cat cases/USB_Imaging/analysis_log.csv

# View student's output files
ls cases/USB_Imaging/outputs/

# See which commands were executed
grep "fls -r" cases/USB_Imaging/analysis_log.csv

# Verify command hashes match documented outputs
sha256sum cases/USB_Imaging/outputs/*
```

### Grading with Rubrics

All labs now have rubrics on instructor branch:
```bash
git checkout instructor
cat cases/Lab_X/instructor/rubric.csv
```

CSV format includes:
- Criterion (what to grade)
- Scoring levels (Excellent, Good, Satisfactory, Needs Work)
- Points for each criterion

---

## Evidence Files (Updated)

**New names (USB storyline):**
- `evidence/usb.img` - RAW disk image (100 MB)
- `evidence/usb.E01` - Expert Witness Format (101 MB)
- `evidence/memory.raw` - Memory dump (511 MB)
- `evidence/network.cap` - Network PCAP (121 KB)

**Old names are now obsolete:**
- ~~`disk.img`~~ → Use `usb.img` instead
- ~~`disk.E01`~~ → Use `usb.E01` instead

---

## Scripts Available in Container

Once you're inside the forensic workstation, these commands are available:

### Forensic Tools (Pre-installed)
- `fls` - List files (Sleuth Kit)
- `fsstat` - Filesystem stats (Sleuth Kit)
- `tsk_recover` - Recover deleted files (Sleuth Kit)
- `foremost` - File carving tool
- `ewfverify` - Verify E01 integrity
- `ewfmount` - Mount E01 files
- `vol2` / `vol` - Volatility memory analysis
- `yara` - Malware pattern matching
- `exiftool` - Metadata extraction
- `bulk_extractor` - File fragment extraction

### New Utilities (Added)
- `coc-log` - Log commands with chain of custody

### Standard Unix
- `grep`, `find`, `sed`, `awk` - Text processing
- `md5sum`, `sha256sum` - Hashing
- `less`, `vim`, `nano` - Editors
- `curl`, `wget` - Downloading

---

## Common Workflows

### Lab 1 - USB Evidence Triage
```bash
./scripts/forensics-workstation "Your Name"
coc-log "ewfverify /evidence/usb.E01" "Verify evidence integrity"
mkdir -p /tmp/ewf
coc-log "ewfmount /evidence/usb.E01 /tmp/ewf" "Mount E01 file"
coc-log "fls -r /tmp/ewf/ewf1" "List all files including deleted"
coc-log "tsk_recover -a /tmp/ewf/ewf1 /cases/USB_Imaging/recovered" "Recover deleted files"
```

### Lab 2 - Memory Analysis
```bash
./scripts/forensics-workstation
coc-log "vol2 -f /evidence/memory.raw imageinfo" "Identify OS profile"
coc-log "vol2 -f /evidence/memory.raw -p [profile] pslist" "List running processes"
coc-log "vol2 -f /evidence/memory.raw -p [profile] netscan" "Show network connections"
```

### Logging Analysis Commands
```bash
# For each significant command, log it:
coc-log "your command here" "brief description of what you're investigating"

# Examples:
coc-log "strings /tmp/ewf/ewf1 | grep secret" "Search for suspicious strings"
coc-log "file /cases/recovered/*" "Identify file types"
coc-log "md5sum /cases/recovered/*" "Generate hashes of recovered files"
```

---

## File Locations (Inside Container)

| Path | Purpose |
|------|---------|
| `/evidence/` | Read-only evidence files |
| `/evidence/usb.img` | USB disk image |
| `/evidence/usb.E01` | USB image (E01 format) |
| `/evidence/memory.raw` | Memory dump |
| `/evidence/network.cap` | Network capture |
| `/cases/` | Your writable workspace |
| `/cases/USB_Imaging/` | Lab 1 outputs |
| `/cases/USB_Imaging/analysis_log.csv` | Chain of custody log |
| `/cases/USB_Imaging/outputs/` | Command output files |
| `/tmp/` | Temporary mount points |

---

## Troubleshooting

### "forensics-workstation: command not found"
```bash
# Make sure you're in the right directory
cd /path/to/forensics-docker-lab

# Make sure script is executable
chmod +x scripts/forensics-workstation

# Try again
./scripts/forensics-workstation
```

### "Docker daemon is not running"
- **Windows/Mac:** Start Docker Desktop application
- **Linux:** `sudo systemctl start docker`

### "Permission denied" on evidence files
- This is expected! `/evidence/` is read-only
- Save all your work to `/cases/` instead

### "coc-log: command not found"
```bash
# Make sure you're INSIDE the forensic workstation
# (You should see: analyst@forensics-lab:/cases$)

# If you're inside and still getting error:
# Try running full path:
/usr/local/bin/coc-log "command" "note"
```

### Evidence files not found
```bash
# Check they exist on your machine
ls -lh evidence/

# Copy them from OneDrive if missing
# Then try again:
./scripts/forensics-workstation
```

---

## Key Concepts

### Chain of Custody (CoC)
Professional record of:
- **Who** - Analyst name
- **What** - Which forensic command ran
- **When** - Exact timestamp
- **How** - Output hash for verification

**In this lab:**
- Automatically tracked by `coc-log` script
- Saved to `cases/Lab_X/analysis_log.csv`
- Required for professional forensic work

### Immersive Experience
**Goal:** Feel like you're using a real DFIR workstation, not running Docker

**Achieved by:**
- Hiding Docker commands (use `./scripts/forensics-workstation`)
- Using realistic DFIR lab banner
- Personalizing with analyst name
- Simulating SSH connection to forensic machine

### Evidence Integrity
**Why it matters:**
- Court cases depend on evidence being unchanged
- Hash verification proves integrity

**How we do it:**
- Hash all evidence files on receipt
- Work only on copies/mounted images
- Document all hashes in CoC log
- `coc-log` automatically hashes command outputs

---

## Getting Help

### If something doesn't work:
1. Check this QUICK_REFERENCE.md
2. Read the relevant Lab README
3. Review POLISH_IMPLEMENTATION_GUIDE.md for context
4. Check TROUBLESHOOTING.md in docs/

### For concept questions:
- See docs/SCENARIO.md - case background
- See docs/COMMANDS.md - how each tool works
- See docs/GLOSSARY.md - terminology

### For instructor guidance:
- Checkout instructor branch: `git checkout instructor`
- Read docs/instructor/README.md
- Check your lab's INSTRUCTOR_NOTES.md

---

*Part of Forensics Docker Lab Polish Initiative*

# Forensic Lab 1: Imaging, Integrity & Initial Triage

**Goal:** Learn a repeatable evidence-handling workflow using the Docker Forensic Lab:
- Establish chain of custody and verify integrity (hashing).
- Create a safe practice disk image (no malware).
- Recover deleted files and produce a minimal triage report.
- Build a Plaso timeline and identify notable events.

**You’ll use:** `hashlog`, Sleuth Kit (`fls`, `icat`, `tsk_recover`), `foremost`, `exiftool`, Plaso (`log2timeline.py`, `psort.py`).

---

## 🚀 Quick Start - Immersive Workstation

**Get started immediately with the immersive DFIR experience:**

**Mac/Linux:**
```bash
cd /path/to/forensics-docker-lab
./scripts/forensics-workstation
```

**Windows PowerShell:**
```powershell
.\scripts\forensics-workstation.ps1
```

You'll be prompted for your analyst name, then you're ready to work.

---

## What to submit
1. **`cases/chain_of_custody.csv`** with your entries.
   - Start with: `cp templates/chain_of_custody.csv cases/USB_Imaging/`
2. **`cases/USB_Imaging/triage_report.md`** (use template).
   - Start with: `cp templates/WORKBOOK.md cases/USB_Imaging/triage_report.md`
3. **`cases/USB_Imaging/timeline.csv`** (export from psort).
4. **Recovered artifacts** folder (`cases/USB_Imaging/tsk_recover_out` and/or `cases/USB_Imaging/foremost_out`).

> Tip: Put your analyst ID and name in the first line of each Markdown file.
>
> **Interactive Guide:** Open `guides/worksheet.html` in your browser for step-by-step guided practice.

---

## Timebox (90 minutes)
- 0–15 min: Setup & hash baseline
- 15–35 min: Create practice evidence image & simulate deletion
- 35–60 min: Recover deleted file(s)
- 60–80 min: Build timeline & extract notable events
- 80–90 min: Complete triage report

---

## Steps

### 0) Enter the Forensic Workstation (Immersive)

**Recommended approach (hides Docker complexity):**

On **Mac/Linux:**
```bash
./scripts/forensics-workstation
# Enter your name when prompted
analyst@forensics-lab:/cases$
```

On **Windows PowerShell:**
```powershell
.\scripts\forensics-workstation.ps1
# Enter your name when prompted
analyst@forensics-lab:/cases$
```

You'll see the forensic lab banner and get an interactive prompt with your analyst name. All commands below are run **inside this interactive session** (see examples in the steps).

**Advanced alternative (direct Docker):**
```bash
docker compose build dfir
docker compose run --rm -it dfir
```

### 1) Hash baseline (integrity & intake)

**Lab Walkthrough (First Time - Optional CoC):**
```bash
# Inside workstation
sha256sum /evidence/usb.img
sha256sum /evidence/usb.E01 2>/dev/null
# Record these hashes in your notes for chain of custody
```

**Assignment (Second Time - Required CoC Logging):**
For the graded assignment, use the new CoC logging system to document your chain of custody automatically:

```bash
# Inside workstation, log the hash verification command
coc-log "sha256sum /evidence/usb.img" "Verify USB image integrity - Lab 1 intake"
coc-log "sha256sum /evidence/usb.E01 2>/dev/null || echo 'E01 not yet created'" "Verify E01 image (if exists)"

# This automatically:
# - Records timestamp and your analyst name
# - Captures the output (hashes)
# - Saves output to cases/USB_Imaging/outputs/
# - Logs to cases/USB_Imaging/analysis_log.csv
```

After running coc-log, check your analysis log:
```bash
cat cases/USB_Imaging/analysis_log.csv
```

### 2) Create safe practice EXT4 image and simulate deletion
> Use the container-based script (works on all platforms including Mac):
```bash
bash scripts/make_practice_image_container.sh
```
This creates **`evidence/usb.img`** with multiple deleted files including:
- `flag.txt` (forensic recovery exercise)
- `project_secrets.zip` (Cloudcore case evidence)
- Email drafts and TrueCrypt configuration files
- System logs with USB activity timestamps

> **Note for Mac/Windows users:** The container version handles filesystem creation that your host OS might not support.

### 2b) Optional: Convert to E01 format (industry standard)
> Create an E01 evidence file for professional practice:
```bash
bash scripts/convert_to_e01_container.sh
```
This creates **`evidence/usb.e01`** - the industry-standard E01 format used in real investigations. You can use either `usb.img` or `usb.e01` for the remaining steps.

### 3) List file system and recover deleted items
**Inside the workstation, run these commands:**

For the **walkthrough** (first time):
```bash
# File system listing (Sleuth Kit) - look for deleted files (marked with *)
fls -r /evidence/usb.img

# Detailed listing with full paths
fls -r -m / /evidence/usb.img > USB_Imaging/fls.txt

# Recover ALL deleted files with TSK
mkdir -p USB_Imaging/tsk_recover_out
tsk_recover -a /evidence/usb.img USB_Imaging/tsk_recover_out

# Check what was recovered
ls -la USB_Imaging/tsk_recover_out/

# Optional: Compare with Foremost carving (file carving)
mkdir -p USB_Imaging/foremost_out
foremost -i /evidence/usb.img -o USB_Imaging/foremost_out
```

For the **assignment** (second time - with CoC logging):
```bash
# Log your forensic analysis using coc-log for automatic chain of custody

# List files with CoC logging
coc-log "fls -r /evidence/usb.img" "Initial filesystem listing - look for deleted files"
coc-log "fls -r -m / /evidence/usb.img" "Detailed filesystem listing with full paths"

# Recover files and log
mkdir -p USB_Imaging/tsk_recover_out
coc-log "tsk_recover -a /evidence/usb.img USB_Imaging/tsk_recover_out" "Recover all deleted files from USB image"

# File carving alternative
mkdir -p USB_Imaging/foremost_out
coc-log "foremost -i /evidence/usb.img -o USB_Imaging/foremost_out" "File carving with Foremost tool"

# Check results
ls -la USB_Imaging/tsk_recover_out/
ls -la USB_Imaging/foremost_out/
```

**Then:**
```bash
# Exit to run Plaso (different container)
exit
```

**If using E01 format instead:**
```bash
# Replace /evidence/usb.img with /evidence/usb.e01
# Add -f ewf flag to specify E01 format
fls -f ewf -r /evidence/usb.e01
tsk_recover -f ewf -a /evidence/usb.e01 USB_Imaging/tsk_recover_out
```

### 4) Build a Plaso super-timeline and export CSV
**On your host:**
```bash
docker compose run --rm plaso log2timeline.py /cases/USB_Imaging/timeline.plaso /evidence/usb.img
docker compose run --rm plaso psort.py -o l2tcsv /cases/USB_Imaging/timeline.plaso > cases/USB_Imaging/timeline.csv
```
Open `cases/USB_Imaging/timeline.csv` in your spreadsheet tool. Identify 3–5 notable events (file creation/deletion, mount, etc.).

### 5) Complete your triage report
Fill in `cases/USB_Imaging/triage_report.md` using the template. Reference recovered files and timeline evidence.

---

## Alternative: One-Off Commands (Not Recommended for Learning)

If you prefer not to use the interactive workstation, you can run individual commands:

```bash
docker compose run --rm dfir fls -r -m / /evidence/usb.img > cases/USB_Imaging/fls.txt
docker compose run --rm dfir tsk_recover -a /evidence/usb.img /cases/USB_Imaging/tsk_recover_out
```

**However, the interactive mode is recommended** because:
- Less typing (no `docker compose run --rm dfir` prefix)
- More realistic forensic workflow
- Better for learning and exploration
- Tab completion and command history work properly

---

## Marking rubric (summary)
- **Chain-of-custody (20%)**: Accurate, complete, consistent.
- **Recovery (30%)**: Correct methods and validated artifacts.
- **Timeline (30%)**: Clear notable events with justification.
- **Report quality (20%)**: Concise, reproducible steps, correct hashes/paths.

See `rubric.csv` for detail.

---

## Troubleshooting

### Problem: "No deleted files found" or "tsk_recover finds nothing"
**Common causes and solutions:**

1. **Using wrong fls command:**
   ```bash
   # Look for files marked with * (deleted)
   fls -r /evidence/usb.img
   
   # NOT just: fls /evidence/usb.img (misses deleted files)
   ```

2. **File system not fully processed:**
   ```bash
   # Try force recovery of all files
   tsk_recover -a -f /evidence/usb.img USB_Imaging/tsk_recover_out
   ```

3. **Using E01 format without specifying:**
   ```bash
   # Must specify E01 format
   tsk_recover -f ewf -a /evidence/usb.e01 USB_Imaging/tsk_recover_out
   ```

### Problem: "Permission denied" running make_practice_image.sh
**Solution:**
- Ensure you have sudo privileges on your system
- The script requires sudo for mounting loopback devices
- On WSL2, you may need to run as Administrator

### Problem: "Docker container can't find evidence files"
**Solution:**
- Ensure evidence files are in the correct location: `evidence/usb.img`
- Check file permissions: `ls -lh evidence/usb.img`
- Verify Docker volume mounting in docker-compose.yml

### Problem: "Plaso timeline is empty"
**Solutions:**
1. Check disk image format: `file evidence/usb.img`
2. Ensure sufficient disk space for timeline file
3. Try with smaller image first to test

---

## Expected Results

If everything works correctly, you should find:

**Deleted Files Recovered:**
- `flag.txt` containing: `FLAG{digital_forensics_cloudcore_case_2009}`
- `project_secrets.zip` (if recovery is successful)
- Various temporary files

**Timeline Events:**
- File creation timestamps around December 5, 2009
- File deletion events
- System log entries with USB activity

**Hash Values:**
- Record SHA-256 hashes in chain_of_custody.csv
- Verify integrity throughout the process

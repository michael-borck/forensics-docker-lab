---
format:
  html:
    embed-resources: true
---

# USB_Imaging Lab - Student Walkthrough
## Evidence Triage & Deleted File Recovery

**Time Estimate:** 2-3 hours

**Difficulty:** Beginner

**Tools:** Sleuth Kit (fls, icat, fsstat), ewf-tools, strings, grep

> **ℹ️ About the example outputs in this walkthrough:** The hashes, filenames,
> and counts shown are *illustrative* — captured from one specific evidence
> image. **Your actual values will differ** depending on the exact evidence you
> analyse. That is expected: the skill being taught is the *method* (which
> command, what to look for), not matching a fixed answer. Record YOUR real
> outputs in your report and `analysis_log.csv`. Generate the evidence first
> with `make evidence` (see `docs/evidence-sources.md`).

---

## 📸 Context: How Evidence is Captured (In Real Forensic Practice)

**Important Context:** In this lab, you're analysing a **pre-captured evidence image** (`usb.E01`). In real forensic investigations, the imaging process is critical and happens BEFORE analysis.

### Real-World Evidence Capture Process

In a real incident response, a forensic technician would:

1. **Physical Evidence Handling:**
   - Seize the USB device from the suspect
   - Document chain of custody (who touched it, when, why)
   - Use a **write blocker** (hardware device) to prevent accidental modification
   - Connect write-blocked USB to forensic workstation

2. **Image Acquisition (Industry Standard Tools):**
   - **Encase** (AccessData) - Creates `.E01` format (what we have)
   - **Forensic Toolkit (FTK) Imager** (Accessdata) - Windows/Linux GUI
   - **dd command** (free, Linux) - Raw copy with hash verification
   - **ddrescue** (GNU) - With error recovery for damaged drives
   - All tools calculate MD5/SHA256 hashes DURING capture for integrity verification

3. **Verification:**
   - Hash the original evidence
   - Hash the acquired image
   - Verify hashes match exactly (proves no corruption during copy)
   - Store original evidence in secure chain-of-custody

4. **Documentation:**
   - When captured, by whom, from what device
   - Make and model of device
   - Serial number of device
   - Hash of original
   - Hash of image
   - Any errors or issues during capture

### In This Lab

We've **skipped the capture phase** and provided you with a pre-captured image (`usb.E01`). This lets you focus on:

- Analysis skills
- Forensic reasoning
- Evidence interpretation

But remember: In real forensics, the imaging step is CRITICAL because:

- ✓ Write blockers prevent accidental modification
- ✓ Hashing proves evidence integrity
- ✓ Chain of custody documents who handled evidence
- ✓ Professional tools ensure complete data capture (including bad sectors)

---

## 📋 Pre-Lab Setup

### 1. Verify Lab Templates Are Ready

The lab folder should already contain three template files. Verify they exist:

```bash
# On your host machine (outside the container)
ls -lh cases/USB_Imaging/
```

You should see:

- **chain_of_custody.csv** - Evidence handling record
- **analysis_log.csv** - Command execution log
- **lab_report.md** - Report template for your findings
- **WALKTHROUGH.md** - This document

**What each file does:**

| File | Purpose | When Used |
|------|---------|-----------|
| **chain_of_custody.csv** | Documents evidence integrity (hashes, analyst, date) | Before lab starts - fill in evidence details |
| **analysis_log.csv** | Logs every command you run with timestamps and output hashes | During lab - use `coc-log` script to auto-update |
| **lab_report.md** | Template for writing your findings and analysis | After lab - document what you discovered |

If any files are missing, copy them from templates/:

```bash
# Copy missing templates (if needed)
cp templates/chain_of_custody.csv cases/USB_Imaging/chain_of_custody.csv
cp templates/analysis_log.csv cases/USB_Imaging/analysis_log.csv
cp templates/lab_report_template.md cases/USB_Imaging/lab_report.md
```

**Tips for using these files:**

- **chain_of_custody.csv**: Edit with spreadsheet app or text editor. Fill in evidence hash, analyst name, case number before beginning.
- **analysis_log.csv**: Use `coc-log` script inside container to automatically log commands (recommended). If not using coc-log, manually add entries after each command.
- **lab_report.md**: Use as starting point for your findings report. Replace placeholders with your actual analysis and evidence.

### 2. Verify Your Evidence File

Check that the USB image exists:

```bash
# On your host machine
ls -lh evidence/
```

You should see `usb.E01` (Encase Evidence File format, ~100-800 MB).

**Note:** If you see `usb.img` instead, the analysis process is the same - just substitute `usb.E01` in the commands below.

---

## 🚀 Connecting to the DFIR Forensic Workstation

The `scripts/forensics-workstation` script provides an immersive forensic environment that hides Docker complexity and simulates logging into a professional forensic workstation.

**On macOS/Linux:**
```bash
./scripts/forensics-workstation
```

**On Windows (PowerShell):**
```powershell
.\scripts\forensics-workstation.bat
```

You'll see:

1. A welcome banner asking for your analyst name
2. A lab summary showing all available cases
3. A connection message, then you'll see the forensic workstation prompt

**Inside the workstation, all commands work the same as standard Linux - NO Docker prefixes needed.**

---

## 📦 Part 1: Chain of Custody - Verify Evidence Integrity

**CRITICAL:** Before analysing ANY evidence, you must calculate and document hash values. This proves the evidence hasn't been tampered with.

### Step 1: Calculate MD5 Hash

```bash
md5sum /evidence/usb.E01
```

**Example Output:**
```
6b4ae5319e4c1757793dec70d5746703  /evidence/usb.E01
```

**📋 Document in cases/USB_Imaging/chain_of_custody.csv:**

- Evidence_ID: USB-001
- MD5_Hash: (paste output for the above command)
- SHA256_Hash: (you'll add this next)
- Analyst_Name: (your name)
- Date_Received: (today's date)
- Case_Number: CLOUDCORE-2009-INS-001
- Evidence_Description: Encase E01 image of USB drive
- Storage_Location: /evidence/usb.E01


### Step 2: Calculate SHA256 Hash

```bash
sha256sum /evidence/usb.E01
```

**Example Output:**
```
4ba0bc914cc6f02bdb96e20c1081755ddb5ee7a653e60f088b6d680e07f722b2  /evidence/usb.E01
```

**📋 Update chain_of_custody.csv:**
- Add the SHA256_Hash value above


**Why document hashes?**

- **Integrity verification:** Proves evidence hasn't been modified or corrupted
- **Legal admissibility:** Courts require hash verification for digital evidence
- **Reproducibility:** Other investigators can verify they're analysing the same evidence
- **Chain of custody:** Documents the starting point of analysis


**📋 Document in analysis_log.csv:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: md5sum /evidence/usb.E01
exit_code: 0
note: Chain of custody - calculated MD5 hash of usb.E01 : 83a0f673cada8bb15d22dcfbc4cfba18
```

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: sha256sum /evidence/usb.E01
exit_code: 0
note: Chain of custody - calculated SHA256 hash of usb.E01: 45ae66a11ff995a1a6e71484202418358c4531659dffa18eb21b1e1c335e8c7a
```

**Why document commands?**

- **Reproducibility:** Lets others repeat your exact steps to verify findings.
- **Legal Defensibility:** Creates a transparent, auditable log for court.
- **Evidence Integrity:** Shows exactly how you interacted with the data.
- **Accurate Reporting:** Provides the precise technical "how" for your report.
- **Peer Review & QA:** Allows colleagues to check your process for accuracy.
- **Contemporaneous Notes:** Logs actions as they happen, preventing memory errors.

---

## 💾 Part 2: Mount the Evidence Image

E01/IMG files are compressed forensic formats. We need to "mount" them to access the files inside.

### Step 1: Create Mount Point

```bash
mkdir -p /tmp/ewf
```

### Step 2: Mount the E01 File

```bash
ewfmount /evidence/usb.E01 /tmp/ewf
```

**No output = success!** Verify it worked:

```bash
ls -lh /tmp/ewf/
```

You should see `ewf1` (the virtual raw disk image) with size ~100M.

**✅ Expected Output:**
```
total 0
-r--r--r-- 1 root root 100M Oct 23 21:55 ewf1
```

**⚠️ IMPORTANT:** From now on, ALL commands use `/tmp/ewf/ewf1`, NOT the original image file.

---

## 🗂️ Part 3: Analyse File System Structure

**Why this step matters:**
Before we can list files, we need to understand the filesystem structure. Is it FAT32? NTFS? What's the cluster size? These details affect how we recover deleted files and interpret timestamps. We also check if the drive has multiple partitions - some USB drives have hidden recovery partitions.

**How we know to do this:**
Forensic investigators follow a systematic approach: understand the storage layout → find files → recover deleted data. Skipping filesystem analysis means missing important details about how data was stored and deleted.

### Step 1: Get File System Information

```bash
fsstat /tmp/ewf/ewf1 > /cases/USB_Imaging/filesystem_info.txt
```

**What this tells us:**

- **File System Type:** FAT32, NTFS, exFAT, etc.
- **Volume Label:** Name of the USB drive
- **Cluster Size:** How data is grouped (important for recovery)
- **Free Space:** Was the drive nearly full? (suggests rapid deletion)
- **FAT (File Allocation Table):** Maps which clusters contain which files

**Example from our evidence:**
```
File System Type: FAT32
Volume Label: PRACTICE
Cluster Size: 512
Free Sector Count: 201538
```

This tells us:
- Simple FAT32 filesystem (older, simpler to analyze)
- Drive was labeled "PRACTICE" (for training?)
- Lots of free space available (~100MB free out of 200MB total)
- Deleted files can likely be recovered

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: fsstat /tmp/ewf/ewf1 > /cases/USB_Imaging/filesystem_info.txt
exit_code: 0
note: Get file system information (type, size, cluster info) - Found FAT32 drive labeled 'PRACTICE'
```

### Step 2: Check Partition Table

```bash
mmls /tmp/ewf/ewf1 > /cases/USB_Imaging/partition_table.txt
```

**What this tells us:**
The `mmls` command analyzes the Master Boot Record (MBR) and partition table. Professional USB drives might have:

- Multiple partitions (data + recovery)
- Hidden partitions (for firmware)
- No partition table (raw FAT32, common on simple USB drives)

**Why we run it:**
An experienced investigator doesn't assume - they verify. We run mmls to:

1. Confirm there's only ONE filesystem (not multiple partitions)
2. Document what we found for the investigation report
3. Ensure we're not missing hidden partitions with deleted data

**Expected output for simple USB drives:**
```
Cannot determine partition type
```

**This is NORMAL and EXPECTED** - it means the drive is formatted directly as FAT32 with no partition table. This is actually good for us - simpler to analyze, fewer places to hide data.

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: mmls /tmp/ewf/ewf1 > /cases/USB_Imaging/partition_table.txt
exit_code: 0
note: Check partition table - Result: No partition table (simple FAT32 USB drive, no hidden partitions)
```

**Review what you found:**
```bash
cat /cases/USB_Imaging/partition_table.txt
cat /cases/USB_Imaging/filesystem_info.txt
```

**Key Questions to Ask:**

- How much free space is on the drive?
- Were files deleted recently (high free space = yes)?
- Is the filesystem FAT32 or something else?
- Are there multiple partitions?

---

## 📂 Part 4: List All Files (Including Deleted)

**Why this step matters:**
This is the MOST IMPORTANT step in USB forensics. Suspects delete files thinking they're gone, but FAT32 doesn't actually erase the data - it just marks the clusters as "free". The `fls` command reads the FAT and recovers the references to deleted files BEFORE we even recover the data. This tells us:

1. What files were on the drive (including deleted ones)
2. Their original locations and timestamps
3. How recently they were deleted (fragmentation level)
4. Which files are worth recovering in detail

**How we know to do this:**
Digital forensics principle: **"A deleted file is just a file with a deleted directory entry."** The actual file data stays on disk until overwritten. By reading the filesystem tables, we can list deleted files before attempting data recovery.

### Step 1: List All Files (Active and Deleted)

```bash
fls -r -d /tmp/ewf/ewf1 > /cases/USB_Imaging/file_list.txt
```

**What the flags do:**

- `-r`: recursive (scan all subdirectories)
- `-d`: show deleted files (marked with `*` in the output)

**Understanding the output format:**
```
d/d 3:  Documents/

+ r/r 4: Documents/project.xlsx (recovered)
- r/r 5: Documents/secret.txt (DELETED - marked with -)
```

- `d/d`: directory
- `r/r`: regular file
- `+`: allocated (active file)
- `-`: unallocated (DELETED file) ← These are what we're hunting for!

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: fls -r -d /tmp/ewf/ewf1 > /cases/USB_Imaging/file_list.txt
exit_code: 0
note: List all files (active and deleted). The '-' prefix indicates deleted files.
```

### Step 2: Extract Just the Deleted Files

**Why separate them:**
It's easier to analyse if we create a focused list of ONLY the deleted files. These are the suspicious ones.

```bash
grep "\* " /cases/USB_Imaging/file_list.txt > /cases/USB_Imaging/deleted_files.txt
```

**What this does:**
The grep command searches for lines starting with `*` (or containing `* ` in fls output), which marks deleted entries. We save these to a separate file for analysis.

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: grep "\* " /cases/USB_Imaging/file_list.txt > /cases/USB_Imaging/deleted_files.txt
exit_code: 0
note: Extract deleted files for focused analysis. Patterns suggest intentional deletion.
```

Review the deleted files:
```bash
cat /cases/USB_Imaging/deleted_files.txt
wc -l /cases/USB_Imaging/deleted_files.txt  # Count deleted files
```

**Forensic Analysis - What to look for:**
Files that are INTENTIONALLY deleted (vs. accidental) often follow patterns:

- **Data files:** `.xlsx`, `.csv`, `.json`, `.xml` - Why delete financial/project data?
- **Documents:** `.txt`, `.docx`, `.pdf` - Confidential information?
- **Databases:** `.db`, `.pst`, `.sqlite` - Customer records? Secrets?
- **Archives:** `.zip`, `.rar`, `.tar` - Bundled data for exfiltration?
- **Executables:** `.exe`, `.bat`, `.sh` - Malware? Tools?
- **Scripts:** `.py`, `.ps1`, `.vbs` - Automation for theft/vandalism?

**Red Flags for Investigation:**

- Deleted files grouped by type (e.g., all .xlsx files deleted)
- Large archive files (.zip) deleted
- Multiple files deleted at same timestamp (mass deletion = cover-up?)

---

## 📊 Analysis of Actual Evidence

In this lab's evidence, you should find these deleted files:

```
r/r * 375:      home/alex/Documents/project_secrets.txt
r/r * 378:      home/alex/Documents/._project_secrets.txt
r/r * 663:      tmp/email_draft.txt
r/r * 666:      tmp/._email_draft.txt
r/r * 669:      tmp/flag_backup.txt
r/r * 672:      tmp/._flag_backup.txt
r/r * 1715:     tmp/project_secrets_backup.txt
r/r * 1719:     tmp/._project_secrets_backup.txt
r/r * 15:       _lag.txt
r/r * 17:       ._flag.txt
```

Plus Apple system files (`.fseventsd` directory and related files).

**What this tells us:**

1. **Suspicious pattern:** Multiple files with "secrets" and "flag" in the name - INTENTIONAL DELETION
   - `project_secrets.txt` - Clearly sensitive data
   - `project_secrets_backup.txt` - Backup copy (thorough deletion attempt?)
   - `flag_backup.txt` - Flag file (CTF/training context)
   - `email_draft.txt` - Correspondence evidence

2. **Backup files:** Two versions of project_secrets suggests deliberate staging/copying before deletion

3. **Timeline hypothesis:** User copied files (`project_secrets_backup.txt`), created drafts (`email_draft.txt`), then deleted everything to hide tracks

4. **Mac artifacts:** The `._*` files are macOS metadata files (timestamps, icons) - user was likely on a Mac and exported to USB

5. **Root directory file:** `_lag.txt` (possibly `flag.txt` with first character corrupted) - added to curiosity

**Questions for your investigation:**

- What's in these deleted files? (recover them in Part 5)
- When were they deleted? (check timestamps in recovered files)
- Does the filename `flag.txt` relate to captured credentials? Secrets?
- Why multiple backups? Paranoia about losing data vs. trying to hide it?
- Does the timeline match other evidence (memory dump, email logs)?

---

## 📤 Part 5: Extract and Inspect Deleted File Content

**Why this step matters:**
Now that we know WHICH files were deleted, we need to READ their content. Deleted files still exist on disk - we just need to extract them using their inode numbers. This is where you find the actual evidence: what secrets were stolen? What credentials were compromised? What was the attacker planning?

**How we know to do this:**
Professional forensic investigators use TWO complementary approaches:

1. **icat (direct extraction):** Fast, targeted extraction of specific files by inode
2. **tsk_recover (bulk recovery):** Recover ALL deleted files for comprehensive analysis

We'll show BOTH approaches so you understand the trade-offs.

---

### Approach A: Targeted Extraction with icat (Fast & Precise)

**When to use:** When you know exactly which files you need (from fls output with suspicious names)

The `icat` command (inode cat) reads file data directly from disk using the inode number reported by `fls`. This bypasses the filesystem's "deleted" flag and recovers actual file content before it gets overwritten.

**Step A1: Extract Suspicious Files by Inode**

From your `file_list.txt`, you identified these suspicious deleted files:

- Inode 375: `home/alex/Documents/project_secrets.txt`
- Inode 663: `tmp/email_draft.txt`
- Inode 669: `tmp/flag_backup.txt`
- Inode 1715: `tmp/project_secrets_backup.txt`
- Inode 15: `_lag.txt`

Create a directory to store extracted content:

```bash
mkdir -p /cases/USB_Imaging/extracted_by_icat
```

**Extract all suspicious files:**

```bash
icat /tmp/ewf/ewf1 375 > /cases/USB_Imaging/extracted_by_icat/project_secrets.txt
icat /tmp/ewf/ewf1 663 > /cases/USB_Imaging/extracted_by_icat/email_draft.txt
icat /tmp/ewf/ewf1 669 > /cases/USB_Imaging/extracted_by_icat/flag_backup.txt
icat /tmp/ewf/ewf1 1715 > /cases/USB_Imaging/extracted_by_icat/project_secrets_backup.txt
icat /tmp/ewf/ewf1 15 > /cases/USB_Imaging/extracted_by_icat/_lag.txt
```

**Step A2: Inspect Content and Document**

Now read the extracted files:

```bash
echo "=== PROJECT SECRETS ===" && cat /cases/USB_Imaging/extracted_by_icat/project_secrets.txt
echo -e "\n=== EMAIL DRAFT ===" && cat /cases/USB_Imaging/extracted_by_icat/email_draft.txt
echo -e "\n=== FLAG BACKUP ===" && cat /cases/USB_Imaging/extracted_by_icat/flag_backup.txt
echo -e "\n=== PROJECT SECRETS BACKUP ===" && cat /cases/USB_Imaging/extracted_by_icat/project_secrets_backup.txt
echo -e "\n=== LAG FILE ===" && cat /cases/USB_Imaging/extracted_by_icat/_lag.txt
```

**📋 Document EVERY command in analysis_log.csv:**

For each icat extraction:
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: icat /tmp/ewf/ewf1 375 > /cases/USB_Imaging/extracted_by_icat/project_secrets.txt
exit_code: 0
note: Extracted deleted file (inode 375) - project_secrets.txt
```

For each cat command:
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: cat /cases/USB_Imaging/extracted_by_icat/project_secrets.txt
exit_code: 0
note: Viewed extracted content - contains [BRIEF SUMMARY: what was in file]
```

**Why document every command?**

- **Reproducibility:** Another investigator can run the exact same commands
- **Chain of Custody:** Proves what you did and when you did it
- **Verification:** Someone can verify your output matches theirs
- **Court admissibility:** Shows systematic, documented methodology
- **Peer review:** Colleagues can audit your investigative steps

**Advantages of icat approach:**

- ✓ Fast (no bulk recovery overhead)
- ✓ Targeted (only get what you need)
- ✓ Clean (minimal filesystem clutter)
- ✓ Good for initial triage

---

### Approach B: Bulk Recovery with tsk_recover (Comprehensive & Documented)

**When to use:** When you want comprehensive recovery and need files for reporting/archiving

`tsk_recover` extracts ALL deleted files at once, creating actual files on disk that you can analyse with standard Linux tools (cat, grep, strings, file, etc.).

**Step B1: Bulk Recover All Deleted Files**

```bash
mkdir -p /cases/USB_Imaging/recovered_files
tsk_recover /tmp/ewf/ewf1 /cases/USB_Imaging/recovered_files
```

**What this does:**

- Scans the entire image for deleted file data
- Recovers all files to numbered directories (organized by inode ranges)
- Creates actual files you can manipulate and analyse

**Step B2: Explore Recovered Files**

```bash
# List all recovered files
find /cases/USB_Imaging/recovered_files -type f | head -20

# Count how many files were recovered
find /cases/USB_Imaging/recovered_files -type f | wc -l

# Look for our suspicious text files
find /cases/USB_Imaging/recovered_files -name "*secret*" -o -name "*flag*" -o -name "*email*"
```

**Step B3: Inspect Text Files and Document**

**Professional Methodology - Two Phase Approach:**

In real forensic work on large datasets, you'll use **wildcards for initial discovery**, then **exact paths for final evidence**. Here's the proper workflow:

---

### **Phase 1: Initial Triage with Wildcards (Fast Scanning)**

**Why use wildcards initially?**

- Large recovered datasets can have thousands of files
- Need to quickly identify which files are relevant
- Wildcards let you scan patterns without examining every file individually

**Quick scan for files of interest:**

```bash
# Initial triage - OK to use wildcards for discovery
cat /cases/USB_Imaging/recovered_files/*/project_secrets.txt
cat /cases/USB_Imaging/recovered_files/*/email_draft.txt

# Quick grep across many files
grep -r "password" /cases/USB_Imaging/recovered_files/
grep -r "credential" /cases/USB_Imaging/recovered_files/

# Find all text files quickly
find /cases/USB_Imaging/recovered_files -type f -name "*.txt"
```

**This phase helps you:**

- Understand what's in the dataset
- Identify which specific files contain evidence
- Plan your detailed analysis (Phase 2)
- Document your investigation approach

**📋 You CAN use shorthand in analysis_log.csv for triage:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: grep -r "password" /cases/USB_Imaging/recovered_files/
exit_code: 0
note: TRIAGE - Initial keyword scan identified password references in project_secrets.txt and email_draft.txt
```

---

### **Phase 2: Detailed Evidence Analysis with EXACT PATHS (Court-Ready)**

Once you've identified which files matter, switch to **precise paths** for your actual evidence analysis. This is what goes in your final report and expert testimony.

**Step B3a: Document the exact files you'll analyze**

From Phase 1, you identified these files of interest:

```bash
# List the exact paths you plan to examine in detail
find /cases/USB_Imaging/recovered_files -type f -name "*.txt"
```

Expected output:
```
/cases/USB_Imaging/recovered_files/home/alex/Documents/project_secrets.txt
/cases/USB_Imaging/recovered_files/tmp/email_draft.txt
/cases/USB_Imaging/recovered_files/tmp/flag_backup.txt
/cases/USB_Imaging/recovered_files/tmp/project_secrets_backup.txt
```

**Step B3b: Examine each file with EXACT paths (no wildcards!)**

Now analyse each identified file using its **complete, precise path**:

```bash
cat /cases/USB_Imaging/recovered_files/home/alex/Documents/project_secrets.txt
cat /cases/USB_Imaging/recovered_files/tmp/email_draft.txt
cat /cases/USB_Imaging/recovered_files/tmp/flag_backup.txt
cat /cases/USB_Imaging/recovered_files/tmp/project_secrets_backup.txt
```

**📋 Document EVERY file examined in analysis_log.csv with EXACT PATH:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: cat /cases/USB_Imaging/recovered_files/home/alex/Documents/project_secrets.txt
exit_code: 0
note: EVIDENCE ANALYSIS - Examined recovered file (inode 375) - Contains Cloudcore confidential source code, database credentials (db_user=alex_doe, db_pass=TempPass_2009!), and client MegaCorp data
```

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: cat /cases/USB_Imaging/recovered_files/tmp/email_draft.txt
exit_code: 0
note: EVIDENCE ANALYSIS - Examined recovered file (inode 663) - Email from Alex Doe to Sarah Connor concerning security, database credentials, unusual network activity
```

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: cat /cases/USB_Imaging/recovered_files/tmp/flag_backup.txt
exit_code: 0
note: EVIDENCE ANALYSIS - Examined recovered file (inode 669) - Contains training flag confirming successful file recovery technique
```

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: cat /cases/USB_Imaging/recovered_files/tmp/project_secrets_backup.txt
exit_code: 0
note: EVIDENCE ANALYSIS - Examined recovered file (inode 1715) - Duplicate of project_secrets.txt, indicates intentional backup before deletion
```

**Why Phase 2 requires exact paths:**

- **Court admissibility:** Defense will ask "which specific file?" - wildcards don't answer this
- **Reproducibility:** Another investigator must examine the **exact** same files
- **Peer review:** Colleagues need to verify **which specific files** contained what evidence
- **Chain of custody:** Document precisely which evidence you handled and when
- **Avoids ambiguity:** Exact paths prove you didn't cherry-pick data or miss files

**Step B3c: Keyword search with exact paths**

For final evidence analysis, search specific files:

```bash
grep -i "password" /cases/USB_Imaging/recovered_files/home/alex/Documents/project_secrets.txt
grep -i "credential" /cases/USB_Imaging/recovered_files/tmp/email_draft.txt
```

**📋 Document keyword searches with exact paths:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: grep -i "password" /cases/USB_Imaging/recovered_files/home/alex/Documents/project_secrets.txt
exit_code: 0
note: EVIDENCE ANALYSIS - Found embedded database password: db_pass=TempPass_2009!
```

**Step B3d: Examine file metadata with exact paths**

```bash
file /cases/USB_Imaging/recovered_files/home/alex/Documents/project_secrets.txt
file /cases/USB_Imaging/recovered_files/tmp/email_draft.txt
```

**📋 Document file analysis:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: file /cases/USB_Imaging/recovered_files/home/alex/Documents/project_secrets.txt
exit_code: 0
note: EVIDENCE ANALYSIS - File type confirmed as ASCII text (no compression/encoding). Inode 375, matches fls output.
```

**Step B4: Safe Analysis of Unknown Files**

If you find binary files (`.exe`, `.bin`, `.dll`), use `strings` to safely extract readable text:

**Why this step matters:**
Binary executables and DLLs contain compiled machine code that's unreadable as plain text. However, they usually contain embedded strings (API names, URLs, error messages, passwords) that the malware uses. The `strings` command extracts these readable portions WITHOUT executing the binary - a safe forensic analysis technique.

**How we know to do this:**
Malware analysis requires examining binary files for evidence of malicious intent (C2 domains, exfiltration targets, hardcoded credentials). Using `strings` is the industry-standard safe approach - it avoids executing or opening the binary in tools that might trigger activation.

---

### **Phase 1: Initial Binary Discovery with Wildcards**

**Quick scan to find what binary files exist:**

```bash
# Initial discovery - OK to use wildcards
find /cases/USB_Imaging/recovered_files -type f \( -name "*.exe" -o -name "*.dll" -o -name "*.bin" \)

# Quick scan of all binaries
strings /cases/USB_Imaging/recovered_files/*/*.exe | head -50
strings /cases/USB_Imaging/recovered_files/*/*.dll | grep -i "C2\|server\|command"
```

**📋 Triage documentation:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: find /cases/USB_Imaging/recovered_files -type f \( -name "*.exe" -o -name "*.dll" \)
exit_code: 0
note: TRIAGE - Located binary files for analysis
```

---

### **Phase 2: Detailed Binary Analysis with EXACT PATHS**

Once you've identified which binaries are relevant, analyse them with exact paths:

**Step B4a: Document which binaries you'll analyze**

From your triage, identify specific binaries of interest. For example:

```bash
# See what binaries you found
find /cases/USB_Imaging/recovered_files -type f -name "*.exe"
```

**Step B4b: Analyse EACH binary with EXACT path**

For each binary file, extract strings and search for evidence:

```bash
# Example of RIGHT way - EXACT path, specific analysis
strings /cases/USB_Imaging/recovered_files/some/path/malware.exe | grep -i "password\|api\|url"
strings /cases/USB_Imaging/recovered_files/another/path/tool.dll | grep -i "command\|server\|connect"
```

**Example of WRONG way - Don't do this:**
```bash
strings /cases/USB_Imaging/recovered_files/*/*.exe | grep -i "password"  # TOO VAGUE!
```

**📋 Document EACH binary analysis with EXACT path:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: strings /cases/USB_Imaging/recovered_files/some/path/malware.exe | grep -i "password\|api\|url"
exit_code: 0
note: EVIDENCE ANALYSIS - Extracted readable strings from malware.exe - found C2 domain "attacker.com", embedded credentials (user=admin, pass=xyz123)
```

**What strings does:**

- Scans binary file for ASCII/Unicode text sequences
- Extracts all readable strings separated by non-printable characters
- Searches those strings with grep for keywords of interest
- Safe: Never executes the binary, just reads memory layout

**What to look for in binary analysis:**

- **C2 domains:** IP addresses, hostnames, domains (exfiltration targets)
- **API calls:** Windows API names (WINAPI.dll, KERNEL32.dll functions)
- **File operations:** Paths being accessed, registry keys being modified
- **Network ports:** Common C2 ports (6667 for IRC, 8080 for HTTP)
- **Encoded data:** Base64, hex strings that might be encrypted payloads
- **Credentials:** Hardcoded usernames, passwords, API keys

**Advantages of tsk_recover approach:**

- ✓ Comprehensive (gets everything, not just what you know about)
- ✓ Flexible (analyze with any Linux tool)
- ✓ Documented (actual files in directory structure)
- ✓ Safe (use strings for binaries instead of opening them)
- ✓ Professional (recovers evidence for court/reporting)

---

### Comparison: Which Approach to Use?

| Scenario | icat | tsk_recover |
|----------|------|-------------|
| **Quick triage** | ✓ Better | - |
| **Comprehensive analysis** | - | ✓ Better |
| **Known suspicious files** | ✓ Better | - |
| **Unknown what's deleted** | - | ✓ Better |
| **Binary file analysis** | - | ✓ Better (use strings) |
| **Court-ready evidence** | - | ✓ Better |
| **Large drives** | ✓ Better (faster) | - (slow) |
| **Small evidence** | Either | Either |

**Professional approach:** Use BOTH

1. Start with icat on suspicious filenames (fast initial analysis)
2. Then use tsk_recover for comprehensive documentation
3. Use strings/grep on recovered files for pattern matching

---

### Step 2: Analyse Extracted Content

**Key Questions to Answer:**

1. **project_secrets.txt:** What sensitive information was deleted?
2. **email_draft.txt:** Who was it addressed to? What was the purpose?
3. **flag_backup.txt:** What does this "flag" contain? (Training context? Credentials? Passphrase?)
4. **project_secrets_backup.txt:** Why was there a backup copy? Paranoia or preparation?
5. **_lag.txt:** What's this file? Is it a corrupted filename?

**Documentation:**

For each file, create a brief summary in your analysis notes:

```bash
cat > /cases/USB_Imaging/extracted_analysis.txt << 'EOF'
EXTRACTED DELETED FILE ANALYSIS
================================

1. project_secrets.txt (inode 375):
   Content: [paste what you found]
   Significance: [sensitive data, credentials, business secrets?]

2. email_draft.txt (inode 663):
   Content: [paste what you found]
   Significance: [who was it for? exfiltration attempt? communication?]

3. flag_backup.txt (inode 669):
   Content: [paste what you found]
   Significance: [what does "flag" mean in this context?]

4. project_secrets_backup.txt (inode 1715):
   Content: [paste what you found]
   Significance: [duplicate of project_secrets? intentional redundancy?]

5. _lag.txt (inode 15):
   Content: [paste what you found]
   Significance: [corrupted filename? flag.txt with first char missing?]

INVESTIGATION SUMMARY:
- Pattern of deletion: [all related to secrets/flags - intentional?]
- Timeline: [when were these created vs. deleted?]
- Connection to case: [links to memory forensics, email, network evidence?]
EOF
```

Save this file:

```bash
cat /cases/USB_Imaging/extracted_analysis.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: Analysed extracted deleted files for investigative significance
exit_code: 0
note: Found [X] text files with evidence of [describe pattern]
```

---

## 🦠 Part 6: Malware Detection with YARA

**Why this step matters:**
YARA is a pattern-matching tool designed to identify malware and suspicious code. It compares files against rule definitions that describe known malware signatures, suspicious code patterns (like webshells), and behavioural indicators. In real investigations, YARA helps detect:

1. **Known malware:** Signatures of detected malware families
2. **Suspicious patterns:** Code that looks like malware even if not recognized
3. **Backdoors & webshells:** Remote access tools or web-based attack vectors
4. **Obfuscated code:** Base64 encoding, encrypted payloads, suspicious function calls

**How we know to do this:**
Digital forensics best practices include automated malware scanning at every stage:

- Initial triage (quick scan of evidence)
- After mounting filesystem (scan filesystem artifacts)
- After file recovery (scan recovered deleted files for hidden malware)
- Before final reporting (comprehensive scan to ensure no malware was missed)

Malware often hides in deleted files, thinking it won't be found. YARA catches it.

### Step 1: Scan the Mounted Image

**Why scan the mounted image?**
The mounted `/tmp/ewf/ewf1` represents the entire USB drive including unallocated space. Scanning here catches active malware AND deleted malware before we even extract files.

```bash
yara -r /rules/ /tmp/ewf/ewf1 > /cases/USB_Imaging/yara_image_scan.txt
```

**What this does:**

- `-r`: Recursive (scan all files in the image)
- `/rules/`: Path to YARA rules (mounted volume from host)
- `/tmp/ewf/ewf1`: The mounted forensic image to scan
- Output redirected to `yara_image_scan.txt`

**Review results:**
```bash
cat /cases/USB_Imaging/yara_image_scan.txt
wc -l /cases/USB_Imaging/yara_image_scan.txt
```

**📋 Document in analysis_log.csv:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: yara -r /rules/ /tmp/ewf/ewf1 > /cases/USB_Imaging/yara_image_scan.txt
exit_code: 0
note: MALWARE DETECTION - Scanned mounted USB image against YARA rules - Found [X] matches
```

**What matches mean:**

- **Match = suspicious pattern detected:** Not necessarily "malware confirmed" but patterns worth investigating
- **No matches = no known patterns detected:** Doesn't mean it's clean (unknown malware exists), just no pattern match
- **Multiple matches on same file = stronger indicator:** File matches multiple rules = higher suspicion

### Step 2: Scan Recovered Deleted Files

**Why scan recovered files separately?**
Deleted files might contain malware that wasn't detected in the image scan. Scanning the extracted/recovered directory gives clearer results (organized by file rather than raw blocks).

**Option A: Scan bulk recovered files (Comprehensive)**

If you used `tsk_recover` in Part 5:

```bash
yara -r /rules/ /cases/USB_Imaging/recovered_files > /cases/USB_Imaging/yara_recovered_scan.txt
```

**Option B: Scan extracted files (Targeted)**

If you used `icat` to extract specific files:

```bash
yara -r /rules/ /cases/USB_Imaging/extracted_by_icat > /cases/USB_Imaging/yara_extracted_scan.txt
```

**Review results:**
```bash
cat /cases/USB_Imaging/yara_*_scan.txt
grep -E "^.*:" /cases/USB_Imaging/yara_*_scan.txt | sort | uniq -c
```

**📋 Document in analysis_log.csv:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: yara -r /rules/ /cases/USB_Imaging/recovered_files > /cases/USB_Imaging/yara_recovered_scan.txt
exit_code: 0
note: MALWARE DETECTION - Scanned recovered deleted files - Found [X] matches in [files]
```

### Step 3: Analyse YARA Matches

**If YARA found matches:**

1. **Identify which files matched:**
   ```bash
   grep "^.*:" /cases/USB_Imaging/yara_recovered_scan.txt | cut -d: -f1 | sort -u
   ```

2. **For each matched file, analyse with strings:**
   ```bash
   # Example: if yara matched /cases/USB_Imaging/recovered_files/malware.exe
   strings /cases/USB_Imaging/recovered_files/malware.exe | grep -iE "password|api|url|command|server"
   file /cases/USB_Imaging/recovered_files/malware.exe
   ```

3. **Document findings:**
   ```
   timestamp_utc: [run date -u]
   analyst: [Your Name]
   command: strings /cases/USB_Imaging/recovered_files/malware.exe | grep -iE "password|api|url|command"
   exit_code: 0
   note: MALWARE ANALYSIS - Matched file contains suspicious strings: [list what you found]
   ```

**If YARA found no matches:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: yara -r /rules/ /cases/USB_Imaging/recovered_files > /cases/USB_Imaging/yara_recovered_scan.txt
exit_code: 0
note: MALWARE DETECTION - No YARA rule matches found (does not confirm clean status, only that no known patterns matched available rules)
```

### Step 4: Understanding YARA Results

**What a YARA match looks like:**

```
Lab1_Webshell_Pattern /cases/USB_Imaging/recovered_files/tmp/webshell.php
```

**Breaking it down:**
- `Lab1_Webshell_Pattern`: The name of the YARA rule that matched
- `/cases/USB_Imaging/recovered_files/tmp/webshell.php`: The file that triggered the rule
- **Significance:** The file contains patterns associated with webshells (base64_decode + eval + $_GET/POST)

**What to do when rules match:**

| Finding | Action |
|---------|--------|
| **Binary matches rule** | Use `strings` to extract readable content, search for C2 domains, IPs, API calls |
| **Script matches rule** | Read directly with `cat`, look for suspicious functions/domains |
| **Multiple rules match same file** | Strong indicator of malicious intent - prioritize for detailed analysis |
| **No matches** | File is either clean or uses unknown/custom malware (continue manual analysis) |

### Step 5: Compare with Evidence Timeline

**Optional advanced step:**
If files matched malware rules, compare against other evidence:

- **Memory Forensics lab:** Were any of these malware samples running in memory?
- **Network Analysis lab:** Did malware establish network connections?
- **Email Logs lab:** Was malware sent via email or exfiltration planned?

---

## 🔍 Part 7: Keyword Searching

**Why this step matters:**
Keyword searching is a safety and efficiency tool. In real forensics, you might have thousands of deleted files. You can't manually read each one. Keyword search helps you:

1. Find files containing specific evidence (passwords, credit cards, classified markings)
2. Safely analyse binary files without opening them (executables, PDFs, images)
3. Identify patterns across the entire drive (multiple references to same suspect)

**When to use `strings` vs. direct reading:**
- **strings command:** For binary files (`.exe`, `.dll`, `.bin`) where you need to extract readable text from compiled code
- **Direct reading (cat/less):** For text files (`.txt`, `.csv`, `.json`) where you want to see actual content

In this lab, since we found text files, we already read them with `icat` + `cat`. But let's also show keyword searching for completeness.

### Step 1: Search the Raw Image for Keywords

**Why this step matters:**
While we already extracted known deleted files, keyword searching finds evidence we might have missed:

- Files we didn't notice in the fls listing
- Fragments of deleted data still scattered on disk
- Hidden or obfuscated content
- System files containing evidence (temporary files, cache, logs)

**How we know to do this:**
Comprehensive forensic analysis requires searching the entire image, not just known files. Malware often leaves traces in unexpected places (temp directories, slack space, unallocated clusters). Keyword searching casts a wide net to catch evidence we might otherwise overlook.

**Optional:** If you want to do a comprehensive keyword search across the entire USB drive (including unallocated space):

```bash
strings /tmp/ewf/ewf1 | grep -iE "password|confidential|secret|flag|credential" > /cases/USB_Imaging/keyword_search.txt
```

**What this does:**
- `strings`: Extracts all readable text strings from the entire image (active files + deleted data + slack space)
- `grep -iE`: Searches for keywords (case-insensitive, with OR operator `|`)

**Flags:**

- `-i`: case-insensitive search (PASSWORD = password = PassWord)
- `-E`: extended regex (allows `|` for OR logic)

**⚠️ Note:** This search might include a lot of false positives (system files, metadata). For text files, direct extraction with `icat` (Part 5) is more reliable.

**📋 Document in analysis_log.csv (if you run this):**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: strings /tmp/ewf/ewf1 | grep -iE "password|confidential|secret|flag|credential" > /cases/USB_Imaging/keyword_search.txt
exit_code: 0
note: Comprehensive keyword search across entire image - found [X] matches in deleted/slack space
```

**What to look for:**

- **Repeated keywords:** Same password/credential in multiple locations suggests importance
- **Contextual data:** See what surrounds the keyword (email addresses, usernames, URLs)
- **File paths:** Where was the data originally? What was the intent?
- **Timestamps:** When was data written/modified? (forensic timeline)

### Step 2: Review Results (Optional)

If you ran the keyword search:

```bash
wc -l /cases/USB_Imaging/keyword_search.txt
head -30 /cases/USB_Imaging/keyword_search.txt
```

**📋 Document in analysis_log.csv:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: wc -l /cases/USB_Imaging/keyword_search.txt
exit_code: 0
note: Counted keyword search results - found [X] total matches
```

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: head -30 /cases/USB_Imaging/keyword_search.txt
exit_code: 0
note: Reviewed top keyword matches - [describe patterns found]
```

**What to look for:**

- Repeated keywords (suggests multiple references to same data)
- Context around keywords (what sensitive data is mentioned?)
- File paths or email addresses in the results
- Patterns indicating exfiltration (URLs, IP addresses, command structures)

### Step 3: Summary - Text vs. Binary Files

**For this evidence (text files):**

- We extracted content directly with `icat` ✓ (More reliable)
- We read with `cat` ✓ (Straightforward)
- Keyword searching is optional (already found sensitive files by name)

**For real-world evidence (mixed binary/text):**

- Use `strings` on `.exe`, `.dll`, `.bin` files (safer than opening them)
- Use `icat` + `cat` on `.txt`, `.csv`, `.json` files
- Use `strings` + `grep` for pattern matching across entire image
- Use specialized tools for images, databases, archives

---

## 🚪 Part 8: Exit the Workstation

When done, exit the forensic environment:

```bash
exit
```

You're back on your host machine.

---

## ✅ Deliverables for This Lab

When you exit the container, you should have created these files in `cases/USB_Imaging/`:

**CSV Files (Documentation):**

- ✅ `chain_of_custody.csv` - Evidence hashes and integrity verification
- ✅ `analysis_log.csv` - Commands executed with timestamps

**Evidence Files (from analysis):**

- ✅ `filesystem_info.txt` - File system details
- ✅ `partition_table.txt` - Partition information
- ✅ `file_list.txt` - All files (active + deleted)
- ✅ `deleted_files.txt` - Just the deleted files
- ✅ `yara_image_scan.txt` - YARA malware detection results (mounted image)
- ✅ `yara_recovered_scan.txt` - YARA results for recovered/deleted files
- ✅ `keyword_search.txt` - Keyword search results
- ✅ `recovered/` - Directory with all recovered files

---

## 📊 Analysis Summary

Before moving to the next lab, answer these questions in your lab notes:

1. **How many files total?** (run `wc -l file_list.txt`)
2. **How many deleted files?** (run `wc -l deleted_files.txt`)
3. **What file types did you find?** (xlsx, csv, docx, etc.)
4. **Most suspicious finding?** (what's the strongest evidence?)
5. **Timeline clues:** (any dates visible in filenames?)

---

## 🆘 Troubleshooting

### "ewf1 not found"

- Verify ewfmount succeeded: `ls -lh /tmp/ewf/`
- Re-run ewfmount command
- Check the path is exactly `/tmp/ewf` not `/tmp/ewf/`

### "fls: cannot open image"

- You're probably using the E01 path instead of `/tmp/ewf/ewf1`
- Must run ewfmount first!
- Check your command uses `/tmp/ewf/ewf1`

### "No deleted files found"

- Make sure you used both flags: `fls -r -d`
- The `-d` flag is required to show deleted files

### "Permission denied"

- Make sure you're inside the forensic workstation
- Check your prompt ends with `#` (you're at bash prompt)

---

## 📚 Next Steps

After completing this lab:

1. **Analyze the recovered files** in detail
2. **Calculate hashes** of key recovered files
3. **Document your findings** in your lab report
4. **Continue with other labs** in the series when ready

The evidence you recovered here will be referenced in later labs!

---

## 📝 Summary - Quick Command Reference

### **Professional Two-Phase Approach:**

```bash
# INSIDE the workstation:

# ===== CHAIN OF CUSTODY =====
md5sum /evidence/usb.E01
sha256sum /evidence/usb.E01

# ===== MOUNT EVIDENCE =====
mkdir -p /tmp/ewf
ewfmount /evidence/usb.E01 /tmp/ewf
ls -lh /tmp/ewf/ewf1

# ===== ANALYSE FILESYSTEM =====
fsstat /tmp/ewf/ewf1 > /cases/USB_Imaging/filesystem_info.txt
mmls /tmp/ewf/ewf1 > /cases/USB_Imaging/partition_table.txt

# ===== LIST ALL FILES (including deleted) =====
fls -r -d /tmp/ewf/ewf1 > /cases/USB_Imaging/file_list.txt
grep "\* " /cases/USB_Imaging/file_list.txt > /cases/USB_Imaging/deleted_files.txt

# ===== APPROACH A: TARGETED EXTRACTION with icat (Fast) =====
mkdir -p /cases/USB_Imaging/extracted_by_icat

icat /tmp/ewf/ewf1 375 > /cases/USB_Imaging/extracted_by_icat/project_secrets.txt
icat /tmp/ewf/ewf1 663 > /cases/USB_Imaging/extracted_by_icat/email_draft.txt
icat /tmp/ewf/ewf1 669 > /cases/USB_Imaging/extracted_by_icat/flag_backup.txt
icat /tmp/ewf/ewf1 1715 > /cases/USB_Imaging/extracted_by_icat/project_secrets_backup.txt
icat /tmp/ewf/ewf1 15 > /cases/USB_Imaging/extracted_by_icat/_lag.txt

# View extracted content with EXACT paths (no wildcards!)
cat /cases/USB_Imaging/extracted_by_icat/project_secrets.txt
cat /cases/USB_Imaging/extracted_by_icat/email_draft.txt

# ===== MALWARE DETECTION with YARA =====
yara -r /rules/ /tmp/ewf/ewf1 > /cases/USB_Imaging/yara_image_scan.txt
cat /cases/USB_Imaging/yara_image_scan.txt

# ===== APPROACH B: BULK RECOVERY with tsk_recover (Comprehensive) =====
mkdir -p /cases/USB_Imaging/recovered_files
tsk_recover /tmp/ewf/ewf1 /cases/USB_Imaging/recovered_files

# ===== SCAN RECOVERED FILES with YARA =====
yara -r /rules/ /cases/USB_Imaging/recovered_files > /cases/USB_Imaging/yara_recovered_scan.txt
cat /cases/USB_Imaging/yara_recovered_scan.txt

# === PHASE 1: TRIAGE with wildcards (OK for discovery) ===
# Quick scan to understand what's in the dataset
grep -r "password" /cases/USB_Imaging/recovered_files/
find /cases/USB_Imaging/recovered_files -type f -name "*.txt"
cat /cases/USB_Imaging/recovered_files/*/project_secrets.txt  # Triage only

# === PHASE 2: EVIDENCE ANALYSIS with EXACT PATHS (Court-ready) ===
# Once you know which files matter, analyse with precision

# STEP 1: Find exact paths
find /cases/USB_Imaging/recovered_files -type f -name "*.txt"

# STEP 2: View each file using EXACT PATH (NO wildcards for evidence!)
cat /cases/USB_Imaging/recovered_files/home/alex/Documents/project_secrets.txt
cat /cases/USB_Imaging/recovered_files/tmp/email_draft.txt
cat /cases/USB_Imaging/recovered_files/tmp/flag_backup.txt
cat /cases/USB_Imaging/recovered_files/tmp/project_secrets_backup.txt

# STEP 3: Keyword search with EXACT paths (for evidence)
grep -i "password" /cases/USB_Imaging/recovered_files/home/alex/Documents/project_secrets.txt
grep -i "credential" /cases/USB_Imaging/recovered_files/tmp/email_draft.txt

# STEP 4: Binary file analysis (two phases)
# Phase 1 triage: Quick scan
find /cases/USB_Imaging/recovered_files -type f -name "*.exe"
strings /cases/USB_Imaging/recovered_files/*/*.exe | head -20  # Triage only

# Phase 2 evidence: Exact paths
strings /cases/USB_Imaging/recovered_files/some/path/malware.exe | grep -i "password"

# ===== EXIT =====
exit
```

---

### **Understanding the Two-Phase Approach:**

| Phase | Use | Commands | Documentation |
|-------|-----|----------|----------------|
| **PHASE 1: Triage** | Fast scanning of large datasets | `grep -r`, `cat /*/file`, `strings /*/*.exe` | Shorthand OK: "TRIAGE - found X matches" |
| **PHASE 2: Evidence** | Precise analysis for reports/court | `cat /exact/path/file`, `grep /exact/path/file` | DETAILED: Document exact path, findings |

**When to use wildcards:**

- ✓ Initial discovery on large recovered dataset (thousands of files)
- ✓ Finding which files contain what evidence
- ✓ Planning your detailed analysis
- ✓ Understanding the investigation landscape

**When to use exact paths:**

- ✓ Documenting findings for final report
- ✓ Analysing files that will appear in evidence
- ✓ Creating expert testimony
- ✓ Anything that goes in analysis_log.csv as EVIDENCE ANALYSIS
- ✓ Peer review and court presentation

---

### **Key Principles for Forensic Documentation:**

**Triage Phase (Wildcards OK):**
```bash
grep -r "password" /cases/USB_Imaging/recovered_files/
# Note in log: "TRIAGE - Found password references"
```

**Evidence Phase (Exact Paths Required):**
```bash
grep -i "password" /cases/USB_Imaging/recovered_files/home/alex/Documents/project_secrets.txt
# Note in log: "EVIDENCE ANALYSIS - Found password: db_pass=TempPass_2009!"
```

**Remember:**

- **Triage = Exploration** (wildcards acceptable, fast discovery)
- **Evidence = Documentation** (exact paths required, court-ready)
- **Mark your log entries** with "TRIAGE" or "EVIDENCE ANALYSIS" to show the difference
- **Final report** only uses EVIDENCE ANALYSIS phase results
- **Other investigators** should be able to reproduce EVIDENCE ANALYSIS exactly

---

**Remember:** Wildcards aren't forbidden—they're just tools for initial exploration. Precision comes in the final analysis and documentation!

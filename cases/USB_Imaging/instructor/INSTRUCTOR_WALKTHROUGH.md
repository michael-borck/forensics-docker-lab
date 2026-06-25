# Week 7 Lab - Instructor Walkthrough Guide
## USB Evidence Triage - Live Demonstration Script

**Lab Duration:** 3 hours (includes breaks)
**Format:** Instructor-led demonstration with student follow-along
**Student Task:** Follow along, document commands, complete gaps in their own time

---

## 🎯 Lab Session Goals

By the end of this session, students should:
1. ✅ Successfully enter the forensic workstation
2. ✅ Verify evidence integrity and establish chain of custody
3. ✅ Mount E01 evidence file
4. ✅ List files and identify deleted files
5. ✅ Recover deleted files
6. ✅ Search for keywords in evidence
7. ✅ Understand the complete forensic workflow
8. ✅ Have documented all commands in their notes

**What students complete independently after lab:**
- Deep analysis of recovered files
- Timeline analysis
- Writing the formal report
- AI reflection

---

## 📋 Pre-Session Checklist (15 minutes before)

### Instructor Preparation

- [ ] Test your Docker environment (rebuild if needed)
- [ ] Open these files in tabs for easy reference:
  - `SCENARIO.md` (case background)
  - `COMMANDS.md` (command reference)
  - This walkthrough guide
- [ ] Have `guides/worksheet.html` open in browser for students
- [ ] Test screen sharing/projection is working
- [ ] Verify terminal font size is readable from back of room
- [ ] Have backup USB with lab materials (in case of download issues)
- [ ] Test one complete workflow to ensure no surprises

### Student Preparation (First 10 minutes of lab)

```
🎤 SAY: "Before we begin, everyone needs to verify their environment is ready."

📺 SHOW: Project these commands on screen
```

**Have students run:**
```bash
# Navigate to lab folder
cd ~/Downloads/forensics-lab-week1-dfir   # Or wherever they extracted it

# Verify Docker is running
docker --version

# Build the environment (if not done already)
docker compose build

# Quick test
docker compose run --rm dfir echo "Ready!"
```

**Walk around and help students with issues:**
- Docker not running? → Start Docker Desktop
- Build fails? → Check internet connection
- Permission denied? → Check Docker group membership (Linux)

⏱️ **Time Check:** All students should have green "Ready!" output before continuing.

---

## 🚀 Part 1: Introduction & Case Briefing (15 minutes)

### 1.1 Welcome & Learning Objectives (5 minutes)

```
🎤 SAY:
"Welcome to Week 7's hands-on forensics lab. Today you're going to conduct
a real USB triage investigation for a company called Cloudcore Inc.

This lab is different from previous weeks - you're going to follow along with
me, document everything you see, and then complete the analysis independently.

Think of this like a ride-along - I'm the senior examiner showing you the
process, you're the junior examiner taking notes and learning the workflow.

By the end of today, you'll have:
- Verified evidence integrity
- Mounted a forensic E01 image
- Listed all files including deleted ones
- Recovered deleted files
- Searched for keywords

Then you'll finish the analysis and write your report on your own time."
```

### 1.2 Case Briefing (10 minutes)

```
🎤 SAY: "Let me brief you on the case. Open SCENARIO.md and read along."

📺 SHOW: Open and display SCENARIO.md
```

**Read aloud the key points:**
- Company: Cloudcore Inc. (cloud storage provider)
- Incident: Suspected data exfiltration by employee Marcus Chen
- Evidence: 16GB SanDisk USB seized from suspect's desk
- Timeline: Data noticed missing Jan 14, USB seized Jan 20
- Your role: Triage the USB to determine if client data is present

```
🎤 SAY:
"This is based on a real-world scenario. In actual investigations:
- You have limited time (hours, not days)
- Management wants quick answers: 'Is there client data on this USB?'
- Full forensic analysis comes later if evidence is found

This is called TRIAGE - rapid assessment to determine if deeper investigation
is warranted.

Questions about the case before we start?"
```

⏱️ **PAUSE:** Answer student questions about the scenario.

---

## 🔬 Part 2: Entering the Forensic Workstation (10 minutes)

### 2.1 The Concept (2 minutes)

```
🎤 SAY:
"In professional forensics, you don't do investigations on your regular laptop.
You SSH into a dedicated forensic workstation - a hardened system with all
your tools pre-installed.

Our Docker container simulates this. When you run 'docker compose run --rm dfir',
you're essentially SSH-ing into your forensic lab.

You'll see a banner - this is like the login banner on a real forensic system.
It reminds you that you're in a professional environment with specific rules."
```

### 2.2 First Login - Demonstration (3 minutes)

```
🎤 SAY: "Watch my screen. I'm going to enter the forensic workstation."

📺 SHOW: Your terminal, large font, run the command
```

**Type slowly and clearly:**
```bash
docker compose run --rm dfir
```

```
🎤 SAY: "See this banner? Every time you enter the workstation, you'll see this.
It reminds you of:
- What tools are installed
- Where your evidence is (/evidence - read-only)
- Where to save outputs (/cases - writable)
- The professional standards you must follow"
```

**Point out key parts of banner:**
- Tools list
- Workspace structure
- Forensic best practices warnings

### 2.3 Student Practice (5 minutes)

```
🎤 SAY: "Now you try. Everyone run the same command:"

📺 SHOW: Keep the command visible on screen
```

**Students run:**
```bash
docker compose run --rm dfir
```

**Walk around and verify:**
- ✅ Students see the banner
- ✅ They have a bash prompt: `bash-5.1#`
- ✅ Their terminal says something like `root@abc123:/#`

```
🎤 SAY: "Everyone should see the banner and have a prompt. If not, raise your hand.

The '#' symbol means you're inside the workstation as root user. This is normal
for forensic environments - you need full access to analyze evidence.

IMPORTANT: From now on, when I say 'run this command', I mean run it INSIDE
the workstation. You should already be at the bash prompt."
```

⏱️ **Time Check:** All students at bash prompt inside workstation.

---

## 📦 Part 3: Evidence Verification & Chain of Custody (20 minutes)

### 3.1 Why Chain of Custody Matters (3 minutes)

```
🎤 SAY:
"Before we touch ANY evidence, we must establish chain of custody.

In court, the defense will challenge:
- Is this the real evidence?
- Has it been tampered with?
- How do you know it's the same USB from the suspect's desk?

Hash values are our answer. We calculate cryptographic hashes and document them.
If even one bit changes, the hash changes completely.

We'll use two hash algorithms:
- MD5: Fast, but considered weak (collisions possible)
- SHA256: Slower, much stronger, industry standard

Professional practice: Use both. MD5 for speed, SHA256 for security."
```

### 3.2 Verify Evidence File Exists (2 minutes)

```
🎤 SAY: "First, let's verify the evidence file is actually there."

📺 TYPE: (Students follow along)
```

**Everyone runs:**
```bash
ls -lh /evidence/
```

```
🎤 SAY: "You should see cloudcore_suspect_usb.E01, approximately 101 MB.

The .E01 extension means this is an EnCase Expert Witness format file.
It's a forensic image - a bit-for-bit copy of the USB drive, plus metadata."
```

**Expected output:**
```
-rw-rw-r-- 1 1000 1000 101M Sep 23 10:00 cloudcore_suspect_usb.E01
```

### 3.3 Calculate Hash Values (5 minutes)

```
🎤 SAY: "Now we'll calculate MD5 and SHA256 hashes. These commands take 10-20
seconds each - the computer reads the entire 101MB file."

📺 TYPE: (one command at a time, wait for completion)
```

**Command 1: MD5**
```bash
md5sum /evidence/cloudcore_suspect_usb.E01
```

```
🎤 SAY: "Write down this hash value in your notes. In a real investigation,
you'd compare this against the hash calculated when the USB was first seized."
```

**Expected output:**
```
fc8096c1a178f40600a7c8815087af2b  /evidence/cloudcore_suspect_usb.E01
```

⏱️ **PAUSE:** Give students 30 seconds to copy the hash to their notes.

**Command 2: SHA256**
```bash
sha256sum /evidence/cloudcore_suspect_usb.E01
```

```
🎤 SAY: "This one is longer - 64 characters instead of 32. More secure."
```

**Expected output:**
```
6ebe35fef52afd133563a9f8a21c6b2f6e227146ffa8289b6feee5ecbe23607a  /evidence/cloudcore_suspect_usb.E01
```

⏱️ **PAUSE:** Students copy SHA256 hash to notes.

### 3.4 Verify E01 Internal Integrity (5 minutes)

```
🎤 SAY: "E01 files have built-in checksums. The ewfverify command checks if
the file has been corrupted or tampered with since it was created."

📺 TYPE:
```

```bash
ewfverify /evidence/cloudcore_suspect_usb.E01
```

```
🎤 SAY: "This takes about 30 seconds. Watch the progress meter."
```

**Expected output:**
```
ewfverify 20140807

Opening file(s).
File(s) verified successfully.

MD5 hash calculated: fc8096c1a178f40600a7c8815087af2b
SHA256 hash calculated: 6ebe35fef52afd133563a9f8a21c6b2f6e227146ffa8289b6feee5ecbe23607a
```

```
🎤 SAY: "Success! Notice it shows the same MD5 and SHA256 we just calculated.
This proves:
1. The E01 file is not corrupted
2. The hashes match what we calculated
3. The evidence is intact and ready for analysis

If this failed, we'd STOP immediately and report to our supervisor.
Never analyze corrupted evidence."
```

### 3.5 Document Chain of Custody (5 minutes)

```
🎤 SAY: "Now we'll save these hashes to a file for our report."

📺 TYPE:
```

```bash
# Create chain of custody file
echo "Case: CLOUDCORE-2009-INS-001" > /cases/chain_of_custody.txt
echo "Evidence: cloudcore_suspect_usb.E01" >> /cases/chain_of_custody.txt
echo "Examiner: [Your Name]" >> /cases/chain_of_custody.txt
echo "Date: $(date)" >> /cases/chain_of_custody.txt
echo "" >> /cases/chain_of_custody.txt
echo "MD5: fc8096c1a178f40600a7c8815087af2b" >> /cases/chain_of_custody.txt
echo "SHA256: 6ebe35fef52afd133563a9f8a21c6b2f6e227146ffa8289b6feee5ecbe23607a" >> /cases/chain_of_custody.txt
echo "ewfverify: SUCCESS" >> /cases/chain_of_custody.txt
```

```
🎤 SAY: "Don't worry about typing all this - it's in COMMANDS.md for reference.
The important concept: we're documenting everything in the /cases/ directory."

📺 TYPE:
```

```bash
# Verify the file was created
cat /cases/chain_of_custody.txt
```

```
🎤 SAY: "Remember: /cases/ inside the container maps to ./cases/ on your laptop.
When we exit, you'll see this file in your cases folder."
```

⏱️ **BREAK POINT:** "Let's take a 5-minute break. When you return, we'll mount the evidence and start analysis."

---

## 💾 Part 4: Mounting the E01 Evidence (15 minutes)

### 4.1 Why We Need to Mount (3 minutes)

```
🎤 SAY:
"E01 files are compressed and have special formatting. Sleuth Kit tools can't
analyze them directly - they need a raw disk image.

'ewfmount' converts the E01 to a virtual raw image on the fly. It's like
mounting a disk image in forensics software.

After mounting:
- E01 file stays read-only (safe)
- We get a virtual raw image at /tmp/ewf/ewf1
- Sleuth Kit can analyze /tmp/ewf/ewf1 as if it's a real disk"
```

### 4.2 Create Mount Point (2 minutes)

```
🎤 SAY: "First, create a directory where we'll mount the image."

📺 TYPE:
```

```bash
mkdir -p /tmp/ewf
```

```
🎤 SAY: "The -p flag means 'create parent directories if needed'. Good habit
in forensics - makes your commands more robust."
```

### 4.3 Mount the E01 File (5 minutes)

```
🎤 SAY: "Now we mount the E01 file. This command is FAST - it doesn't copy
anything, just creates the virtual access point."

📺 TYPE:
```

```bash
ewfmount /evidence/cloudcore_suspect_usb.E01 /tmp/ewf
```

**Expected output:**
```
ewfmount 20140807
```

```
🎤 SAY: "No errors = success. Let's verify the mount worked."

📺 TYPE:
```

```bash
ls -lh /tmp/ewf/
```

**Expected output:**
```
total 0
-r--r--r-- 1 root root 100M Oct  7 08:00 ewf1
```

```
🎤 SAY: "See 'ewf1'? That's our virtual raw disk image. Size shows ~100M.

IMPORTANT: From now on, all Sleuth Kit commands use /tmp/ewf/ewf1, NOT the
E01 file. Write this down:

Analysis Target: /tmp/ewf/ewf1

This is the most common mistake students make - trying to analyze the E01
directly instead of the mounted image."
```

### 4.4 Understanding the Mount (5 minutes)

```
🎤 SAY: "Let me explain what we're looking at."

📺 DRAW on whiteboard or show diagram:
```

```
Evidence File (read-only):
/evidence/cloudcore_suspect_usb.E01
         ⬇️ ewfmount
Virtual Mount Point:
/tmp/ewf/ewf1  ← This is what we analyze
         ⬇️ Sleuth Kit tools
Extracted Files:
/cases/recovered/
```

```
🎤 SAY: "Questions about mounting before we continue?"
```

⏱️ **PAUSE:** Answer questions.

---

## 🗂️ Part 5: File System Analysis (30 minutes)

### 5.1 Get File System Information (8 minutes)

```
🎤 SAY: "Before listing files, let's understand what file system we're dealing with."

📺 TYPE:
```

```bash
fsstat /tmp/ewf/ewf1
```

```
🎤 SAY: "This command takes 5 seconds. It reads the file system metadata."
```

**Expected output includes:**
```
FILE SYSTEM INFORMATION
--------------------------------------------
File System Type: NTFS
Volume Name: USB_EVIDENCE
Volume Serial Number: 1A2B3C4D
Sector Size: 512
Cluster Size: 4096
...
```

```
🎤 SAY: "Key observations - write these down:

1. File System Type: NTFS
   - This is Windows NTFS, common for USB drives
   - Means the suspect was using Windows

2. Sector Size: 512 bytes
   - Standard for most drives

3. Cluster Size: 4096 bytes (4KB)
   - Files are stored in 4KB chunks
   - Important for understanding slack space

Let's save this for our report."

📺 TYPE:
```

```bash
fsstat /tmp/ewf/ewf1 > /cases/filesystem_info.txt
```

### 5.2 Check Partition Table (5 minutes)

```
🎤 SAY: "Let's see if there are multiple partitions."

📺 TYPE:
```

```bash
mmls /tmp/ewf/ewf1
```

**Expected output:**
```
DOS Partition Table
Offset Sector: 0
Units are in 512-byte sectors

      Slot      Start        End          Length       Description
000:  Meta      0000000000   0000000000   0000000001   Primary Table (#0)
001:  -------   0000000000   0000002047   0000002048   Unallocated
002:  000:000   0000002048   0000206847   0000204800   NTFS / exFAT (0x07)
```

```
🎤 SAY: "This shows:
- One partition (Slot 002)
- Type: NTFS (0x07)
- Starts at sector 2048
- Size: 204,800 sectors × 512 bytes = ~100MB

Single partition = simple case. Sometimes you'll see multiple partitions,
hidden partitions, or wiped partitions - those require extra analysis."
```

### 5.3 List All Files (12 minutes)

```
🎤 SAY: "Now the main event - listing ALL files, including deleted ones.

The 'fls' command:
- f = file
- l = list
- s = Sleuth Kit

Flags we'll use:
- -r = recursive (all subdirectories)
- -d = show deleted files too

Watch my screen carefully - this output is important."

📺 TYPE:
```

```bash
fls -r -d /tmp/ewf/ewf1
```

**Expected output (partial):**
```
r/r 4-128-1:	$AttrDef
r/r 8-128-2:	$BadClus
r/r 8-128-1:	$BadClus:$Bad
...
d/d 256:	Documents
+ r/r 257:	client_list.xlsx
+ r/r * 258(realloc):	passwords.txt
+ r/r 259:	meeting_notes.docx
d/d * 512(realloc):	Deleted_Folder
...
```

```
🎤 SAY: "See the asterisk (*) before some entries? Those are DELETED files.

For example:
* 258(realloc): passwords.txt - DELETED PASSWORD FILE!

This is critical evidence. Let's save the complete listing."

📺 TYPE:
```

```bash
fls -r -d /tmp/ewf/ewf1 > /cases/file_list.txt
```

```
🎤 SAY: "Now let's look at just the deleted files."

📺 TYPE:
```

```bash
grep "\\* " /cases/file_list.txt
```

**Expected output:**
```
r/r * 258(realloc):	passwords.txt
d/d * 512(realloc):	Deleted_Folder
r/r * 513(realloc):	customer_database.csv
...
```

```
🎤 SAY: "Write down the deleted files you see. We'll recover these next.

Notice the inode numbers (258, 512, 513). These are like file IDs. We'll use
them to extract specific files."
```

⏱️ **PAUSE:** Give students 2 minutes to list deleted files in their notes.

### 5.4 Create Timeline (5 minutes)

```
🎤 SAY: "Timelines show when files were created, modified, accessed. This helps
establish a timeline of suspect activity."

📺 TYPE:
```

```bash
fls -r -d -m / /tmp/ewf/ewf1 > /cases/timeline.csv
```

```
🎤 SAY: "The -m flag creates machine-readable output with timestamps.
Let's look at the format."

📺 TYPE:
```

```bash
head -20 /cases/timeline.csv
```

**Expected output:**
```
0|/$MFT|128-1|0|1704326400|1704326400|1704326400|1704326400
0|/$MFTMirr|129-1|0|1704326400|1704326400|1704326400|1704326400
0|Documents/client_list.xlsx|257|r/r|1704412800|1704498600|1704498600|1704412800
...
```

```
🎤 SAY: "Format is: MD|filename|inode|type|modified|accessed|changed|created

Those numbers are Unix timestamps. We can analyze this later to see what
happened on January 14th (the day data went missing).

For now, we've captured it. You'll analyze timestamps in your independent work."
```

---

## 📤 Part 6: File Recovery (25 minutes)

### 6.1 Bulk Recovery - All Files (10 minutes)

```
🎤 SAY: "Now we'll recover ALL files, including deleted ones. This is where
Sleuth Kit really shines - it can reconstruct deleted files that haven't been
overwritten yet."

📺 TYPE:
```

```bash
# Create recovery directory
mkdir -p /cases/recovered
```

```
🎤 SAY: "The tsk_recover command will:
1. Read every file (active and deleted)
2. Recreate the directory structure
3. Save everything to /cases/recovered

This takes about 30-60 seconds for our 100MB image. On a 1TB drive, it could
take hours."

📺 TYPE:
```

```bash
tsk_recover /tmp/ewf/ewf1 /cases/recovered
```

**Expected output:**
```
Files Recovered: 145
```

```
🎤 SAY: "145 files recovered! Let's see what we got."

📺 TYPE:
```

```bash
ls -R /cases/recovered | head -30
```

**Expected output:**
```
/cases/recovered:
Documents
System Volume Information
...

/cases/recovered/Documents:
client_list.xlsx
passwords.txt
meeting_notes.docx
customer_database.csv
...
```

```
🎤 SAY: "See 'passwords.txt' and 'customer_database.csv'? Those were deleted,
but we recovered them. This is evidence of data exfiltration attempt.

The suspect tried to hide their tracks by deleting files. Didn't work."
```

### 6.2 Examine Recovered Files (8 minutes)

```
🎤 SAY: "Let's look at some of these files. We'll use 'strings' to extract
readable text without opening the files (safer - don't execute anything)."

📺 TYPE:
```

```bash
strings /cases/recovered/Documents/passwords.txt | head -20
```

**Expected output (simulated):**
```
Admin Password: CloudCore2009!
DB_USER: marcus.chen
DB_PASS: SecureP@ss789
FTP_CREDENTIALS: ftp.backup.cloudcore.com
...
```

```
🎤 SAY: "CRITICAL FINDING: This file contains:
- Admin passwords
- Database credentials
- The suspect's username (marcus.chen)

This supports the allegation. Let's check the customer database."

📺 TYPE:
```

```bash
strings /cases/recovered/Documents/customer_database.csv | head -10
```

**Expected output (simulated):**
```
CustomerID,Name,Email,Phone,CreditCard
1001,Acme Corp,admin@acme.com,555-1234,4532-xxxx-xxxx-1234
1002,TechStart Inc,ceo@techstart.io,555-5678,4532-xxxx-xxxx-5678
...
```

```
🎤 SAY: "This is CLIENT DATA - exactly what Cloudcore reported missing.

We now have evidence that:
1. Client data was present on the USB
2. The suspect tried to delete it (but we recovered it)
3. Passwords and credentials were also on the USB

This is enough for triage. We'd report: YES, evidence of data exfiltration found."
```

### 6.3 Targeted File Extraction (7 minutes)

```
🎤 SAY: "Sometimes you want a specific file without recovering everything.
The 'icat' command extracts files by inode number.

Remember the file list showed inode 258 was passwords.txt? Let's extract it."

📺 TYPE:
```

```bash
# Look up the inode again
grep "passwords.txt" /cases/file_list.txt
```

**Expected output:**
```
r/r * 258(realloc):	Documents/passwords.txt
```

```
🎤 SAY: "Inode 258. Let's extract it directly."

📺 TYPE:
```

```bash
icat /tmp/ewf/ewf1 258 > /cases/extracted_passwords.txt
```

```
🎤 SAY: "Now let's verify it worked."

📺 TYPE:
```

```bash
cat /cases/extracted_passwords.txt
```

```
🎤 SAY: "Same content as before. icat is useful when you want just one or two
files quickly, without recovering everything.

In your independent work, you'll extract specific files and calculate their
hashes for your evidence log."
```

---

## 🔍 Part 7: Keyword Searching (15 minutes)

### 7.1 Search the Raw Image (8 minutes)

```
🎤 SAY: "The 'strings' command extracts all readable text from the entire disk.
We'll search for keywords related to our case:
- 'client'
- 'confidential'
- 'password'
- 'cloudcore'

This helps find evidence in unexpected places - slack space, deleted file
fragments, unallocated space."

📺 TYPE:
```

```bash
strings /tmp/ewf/ewf1 | grep -iE "client|confidential|password|cloudcore" > /cases/keyword_hits.txt
```

```
🎤 SAY: "The -i flag makes it case-insensitive. This finds 'CLIENT', 'Client',
'client', etc.

Let's see what we found."

📺 TYPE:
```

```bash
wc -l /cases/keyword_hits.txt
```

**Expected output:**
```
347 /cases/keyword_hits.txt
```

```
🎤 SAY: "347 keyword hits! Let's look at the first 20."

📺 TYPE:
```

```bash
head -20 /cases/keyword_hits.txt
```

**Expected output (simulated):**
```
client_database_backup.zip
Confidential Client Information
password: admin123
Cloudcore Internal Use Only
CLIENT_EXPORT_2009_12_05.csv
...
```

```
🎤 SAY: "Notice the date? December 5, 2009 - the day Cloudcore reported data
went missing. This timeline alignment strengthens the case."
```

### 7.2 Search Within Recovered Files (7 minutes)

```
🎤 SAY: "We can also search just the recovered files. This is faster and shows
context better."

📺 TYPE:
```

```bash
grep -r -i "confidential" /cases/recovered/ | head -10
```

**Expected output:**
```
/cases/recovered/Documents/client_list.xlsx:Binary file matches
/cases/recovered/Documents/meeting_notes.docx:CONFIDENTIAL - DO NOT DISTRIBUTE
/cases/recovered/Documents/email_archive.pst:Subject: CONFIDENTIAL: Client Data Export
...
```

```
🎤 SAY: "The -r flag searches recursively through all recovered files.

See 'CONFIDENTIAL - DO NOT DISTRIBUTE'? That's evidence the suspect knew this
data was sensitive.

Let's search for the company name specifically."

📺 TYPE:
```

```bash
grep -r -i "cloudcore" /cases/recovered/ | wc -l
```

**Expected output:**
```
89
```

```
🎤 SAY: "89 mentions of 'Cloudcore' in the recovered files. This establishes
that the data came from Cloudcore systems."
```

---

## 📊 Part 8: Organizing Your Findings (10 minutes)

### 8.1 Review What We've Created (5 minutes)

```
🎤 SAY: "Let's exit the workstation and see what we've collected."

📺 TYPE:
```

```bash
exit
```

```
🎤 SAY: "We're back on our laptops. Remember, /cases/ inside the container maps
to ./cases/ on your laptop. Let's look."

📺 TYPE: (on host machine)
```

```bash
ls -lh cases/
```

**Expected output:**
```
total 45M
-rw-r--r-- 1 user user  312 Oct  7 09:15 chain_of_custody.txt
-rw-r--r-- 1 user user  15K Oct  7 09:20 filesystem_info.txt
-rw-r--r-- 1 user user  89K Oct  7 09:25 file_list.txt
-rw-r--r-- 1 user user 125K Oct  7 09:30 timeline.csv
drwxr-xr-x 5 user user 4.0K Oct  7 09:35 recovered/
-rw-r--r-- 1 user user  12K Oct  7 09:40 keyword_hits.txt
-rw-r--r-- 1 user user 1.2K Oct  7 09:42 extracted_passwords.txt
```

```
🎤 SAY: "All our evidence is here! These files are on YOUR laptop, not in Docker.
You can open them, analyze them, and include them in your report."
```

### 8.2 Navigate Recovered Files (5 minutes)

```
🎤 SAY: "Let's explore the recovered directory structure."

📺 TYPE:
```

```bash
# On macOS/Linux:
tree cases/recovered -L 2

# On Windows PowerShell:
# Get-ChildItem cases/recovered -Recurse -Depth 2
```

**Or simply:**
```bash
ls -R cases/recovered | head -50
```

```
🎤 SAY: "You can now:
- Open these files in Excel, Word, etc. (be careful - malware risk in real cases)
- Calculate hashes of individual files
- Examine file metadata
- Compare timestamps

In your independent work, you'll:
1. Analyze these files in detail
2. Identify the most incriminating evidence
3. Create a timeline of suspect activity
4. Write your findings in a professional report"
```

---

## 🎯 Part 9: Wrap-Up & Independent Work Guidance (15 minutes)

### 9.1 What We Accomplished Today (5 minutes)

```
🎤 SAY: "Let's review what we did in the past 2.5 hours."

📺 SHOW: Write on whiteboard
```

**Checklist:**
- ✅ Established chain of custody (hash verification)
- ✅ Mounted E01 forensic image
- ✅ Analyzed file system (NTFS, single partition)
- ✅ Listed all files including deleted ones (145 total)
- ✅ Recovered deleted files (passwords, customer database)
- ✅ Searched for keywords (347 hits)
- ✅ Extracted specific evidence files

```
🎤 SAY: "This is a complete triage workflow. In a real investigation, you'd
brief management: 'Yes, we found client data and credentials on the USB.
Recommend full forensic analysis and disciplinary action.'"
```

### 9.2 What You Need to Complete Independently (5 minutes)

```
🎤 SAY: "Open ASSIGNMENT.md - let's go through what you still need to do."

📺 SHOW: Display ASSIGNMENT.md task list
```

**Remaining tasks:**
1. **Deep Analysis** (what we didn't cover in lab):
   - Analyze the timeline.csv to determine when files were created/deleted
   - Identify patterns (e.g., all deletions happened on same day)
   - Look for additional evidence we didn't demo
   - Calculate hashes of recovered files for evidence log

2. **Report Writing** (5-7 hours independent work):
   - Executive Summary
   - Evidence Handling Procedures (use your chain of custody)
   - Methodology (document all commands you ran)
   - Findings and Analysis (what we found + your deeper analysis)
   - Recommendations (what should Cloudcore do?)

3. **AI Usage Reflection**:
   - How you used Claude Code or ChatGPT
   - What worked, what didn't
   - Ethical considerations
   - How you verified AI suggestions

```
🎤 SAY: "You have all the technical skills now. The independent work is about:
- Going deeper into the data
- Critical thinking about what it means
- Professional communication in your report

You're not starting from scratch - you have:
- All the recovered files
- All the command outputs
- This worksheet with all the commands
- Your notes from today"
```

### 9.3 Common Questions & Tips (5 minutes)

```
🎤 SAY: "Let me address common questions I get:"

Q: "Do I need to re-run all the commands?"
A: "No! You already have all the output files in cases/. Just analyze them."

Q: "Can I use Autopsy?"
A: "Yes, it's optional. See README for setup instructions. But CLI is sufficient
    for full marks."

Q: "What if I want to recover more files?"
A: "Just re-enter the workstation, mount the image, run additional commands.
    Your cases/ folder keeps everything between sessions."

Q: "How detailed should my report be?"
A: "Follow the rubric in ASSIGNMENT.md. Word counts are given for each section.
    Quality over quantity - be concise and professional."

Q: "Can I use AI to write my report?"
A: "You can use AI to help organize thoughts, check grammar, suggest structure.
    But you must write the analysis yourself and reflect on AI usage.
    Copy-pasting AI content without verification will be obvious and penalized."
```

### 9.4 Final Reminders

```
🎤 SAY: "Before you go:

1. Make sure your cases/ folder has all the files we created
2. Review your notes - fill in any gaps now while it's fresh
3. Read SCENARIO.md fully - there are details we didn't cover in lab
4. Start your analysis soon - don't wait until the night before
5. Use the course forum forum if you get stuck

The assignment is due [INSERT DUE DATE]. Aim to finish your analysis this week,
then spend next week on the report.

Any final questions?"
```

⏱️ **PAUSE:** Answer questions.

```
🎤 SAY: "Great work today! You've successfully conducted a USB triage investigation.
See you next week!"
```

---

## 📝 Post-Lab Instructor Notes

### Things to Document for Next Time

- [ ] How long did each section actually take?
- [ ] Which concepts needed extra explanation?
- [ ] What errors/issues did students encounter?
- [ ] Which students seem to be struggling?
- [ ] Any improvements to make to the walkthrough?

### Follow-Up Tasks

- [ ] Post lab recording to LMS (if recorded)
- [ ] Send reminder email with key commands
- [ ] Post support availability
- [ ] Monitor LMS forum for questions
- [ ] Grade chain of custody submissions (if collected during lab)

### Common Student Mistakes to Watch For

When grading assignments:
- ❌ Not using ewfmount before Sleuth Kit commands
- ❌ Analyzing the E01 file directly instead of /tmp/ewf/ewf1
- ❌ No hash verification documented
- ❌ Forgetting to include deleted files in analysis
- ❌ AI-generated reports without verification/personalization
- ❌ Missing timeline analysis
- ❌ No AI reflection section

---

## 🆘 Troubleshooting During Lab

### Docker Issues

**"Docker command not found"**
- Fix: Start Docker Desktop, verify installation
- Windows: Check WSL2 is enabled
- Linux: Add user to docker group

**"Cannot connect to Docker daemon"**
- Fix: Restart Docker Desktop
- Linux: `sudo systemctl start docker`

**"Build failed - package not found"**
- Fix: Internet connection issue
- Solution: Use instructor's pre-built image (USB backup)

### Evidence Issues

**"No such file: /evidence/cloudcore_suspect_usb.E01"**
- Fix: Check they're in the right directory
- Verify docker-compose.yml has correct volume mount
- Re-extract lab materials

**"ewfverify failed"**
- This shouldn't happen unless file is corrupted
- Have student re-download the lab materials
- Use backup USB if needed

### Mounting Issues

**"ewf1 not found after mount"**
- Fix: Verify ewfmount command succeeded (no errors)
- Check typo in path: /tmp/ewf not /tmp/ewf/
- Re-run ewfmount command

**"Permission denied" errors**
- Fix: They're probably running commands on host, not in container
- Verify they're inside the workstation (bash prompt shows)

### Analysis Issues

**"fls: cannot open image"**
- Fix: Using E01 path instead of /tmp/ewf/ewf1
- Remind: Must mount first, then use ewf1

**"No deleted files found"**
- Fix: Forgot -d flag on fls command
- Show: fls -r -d (both flags needed)

### Student Confusion Points

**"Where are my files?"**
- Remind: /cases in container = ./cases on laptop
- Show: Exit container and ls cases/

**"Do I need to mount every time?"**
- Answer: Yes, mounts are temporary (per session)
- But recovered files persist in cases/

**"My terminal closed, did I lose everything?"**
- Answer: No! Files saved to /cases/ are safe
- Just re-enter workstation and continue

---

## 📊 Timing Guide - Actual vs Planned

Use this table during lab to track actual timing:

| Section | Planned | Actual | Notes |
|---------|---------|--------|-------|
| Setup & Prep | 15 min | | |
| Introduction & Briefing | 15 min | | |
| Enter Workstation | 10 min | | |
| Chain of Custody | 20 min | | |
| **BREAK** | 5 min | | |
| Mount Evidence | 15 min | | |
| File System Analysis | 30 min | | |
| File Recovery | 25 min | | |
| Keyword Searching | 15 min | | |
| Organize Findings | 10 min | | |
| Wrap-Up | 15 min | | |
| **TOTAL** | 180 min (3 hrs) | | |

---

## ✅ Pre-Lab Equipment Checklist

**Classroom Setup:**
- [ ] Projector/screen working
- [ ] Screen sharing tested
- [ ] Backup laptop (in case primary fails)
- [ ] USB drive with lab materials (backup)
- [ ] Whiteboard markers working
- [ ] Room temperature comfortable for 3 hours

**Instructor Laptop:**
- [ ] Docker running
- [ ] Lab built and tested
- [ ] Terminal font size readable from back
- [ ] Files open in tabs (SCENARIO, COMMANDS, ASSIGNMENT)
- [ ] worksheet.html open in browser
- [ ] Screen recording started (if recording)

**Student Resources:**
- [ ] Lab materials link shared (before class)
- [ ] LMS assignment posted
- [ ] Support availability posted
- [ ] Forum monitoring set up

---

## 🎓 Learning Outcomes Assessment

After this lab, students should be able to:

**Technical Skills:**
- ✅ Enter a Docker forensic environment
- ✅ Calculate and verify cryptographic hashes
- ✅ Mount E01 forensic images
- ✅ List files including deleted files
- ✅ Recover deleted files with Sleuth Kit
- ✅ Search for keywords in evidence
- ✅ Extract specific files by inode
- ✅ Organize recovered evidence

**Conceptual Understanding:**
- ✅ Why chain of custody matters
- ✅ Difference between E01 and raw images
- ✅ How deleted file recovery works
- ✅ Limitations of file recovery
- ✅ Forensic triage workflow
- ✅ Professional documentation standards

**Professional Skills:**
- ✅ Following a systematic investigation process
- ✅ Documenting every step
- ✅ Recognizing significant evidence
- ✅ Thinking critically about findings
- ✅ Communicating technical findings

**If students can't do these after the lab, provide extra support!**

---

**END OF INSTRUCTOR WALKTHROUGH**

*Good luck with the lab! Remember: students learn best when they DO, not just watch. Pause frequently, verify they're keeping up, and create an encouraging environment for questions.*

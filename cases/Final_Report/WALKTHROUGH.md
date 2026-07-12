---
format:
  html:
    embed-resources: true
---

# Final_Report Lab - Student Walkthrough
## Case Consolidation & Professional Report

**Time Estimate:** 3-5 hours

**Difficulty:** Intermediate

**Tools:** Text editor, spreadsheet application, all previous labs

> **ℹ️ About the example findings in this walkthrough:** The timeline entries
> and conclusions shown are *illustrative* of one possible investigation. Your
> final report must be built from **your own** findings across Labs 1–4. The
> specific PIDs, filenames, and timestamps you found will differ — that is
> expected.

---

## 🎯 Mission

Synthesize findings from all 4 labs (USB_Imaging, Memory_Forensics, Email_Logs, Network_Analysis) into a unified, professional investigation report. This is where individual artifacts become a coherent narrative proving guilt or innocence.

---

## 📋 Pre-Lab Setup

This lab does NOT use the forensic workstation. You'll work on your **host machine** consolidating evidence.

### 1. Verify Final_Report Templates Are Ready

The lab folder should already contain template files. Verify they exist:

```bash
# On your host machine
ls -lh cases/Final_Report/
```

You should see:

- **chain_of_custody.csv** - Evidence handling record (from all labs)
- **analysis_log.csv** - Master command log (optional for consolidation)
- **lab_report.md** - Available if alternative format needed
- **final_report.md** - Report template for comprehensive incident synthesis (PRIMARY)
- **WALKTHROUGH.md** - This document

**What each file does:**

| File | Purpose | When Used |
|------|---------|-----------|
| **chain_of_custody.csv** | Master evidence record from all 5 labs | Before starting - consolidate all evidence hashes |
| **analysis_log.csv** | Optional master log if tracking all commands | During lab - optional for tracking consolidated analysis |
| **final_report.md** | Template for comprehensive incident investigation | Main deliverable - synthesize all evidence into narrative |
| **lab_report.md** | Alternative format if needed | Optional - individual lab-style reporting |

If any files are missing, copy them from templates/:

```bash
# Copy missing templates (if needed)
cp templates/chain_of_custody.csv cases/Final_Report/chain_of_custody.csv
cp templates/analysis_log.csv cases/Final_Report/analysis_log.csv
cp templates/lab_report_template.md cases/Final_Report/lab_report.md
cp templates/final_report_template.md cases/Final_Report/final_report.md
```

**Tips for using these files:**

- **chain_of_custody.csv**: Consolidate evidence records from all 5 lab folders. This becomes your master evidence list.
- **final_report.md**: Use this as your primary template. It's designed for synthesizing evidence from multiple sources into a unified incident narrative.
- **lab_report.md**: Available if you prefer the individual lab format instead of the comprehensive final report format.

### 2. Review All Previous Labs

Open these folders and review all findings and evidence:
```bash
cases/USB_Imaging/        # Files, deleted items, lab_report.md, chain_of_custody.csv, analysis_log.csv
cases/Memory_Forensics/   # Processes, network connections, lab_report.md, chain_of_custody.csv, analysis_log.csv
cases/Email_Logs/         # Communications, lab_report.md, chain_of_custody.csv, analysis_log.csv
cases/Network_Analysis/   # Traffic, exfiltration, lab_report.md, chain_of_custody.csv, analysis_log.csv
```

**Key documents to review:**

- Each lab's `lab_report.md` for analysis and findings
- Each lab's `chain_of_custody.csv` for evidence details and hashes
- Each lab's `analysis_log.csv` for methodology transparency

---

## 📊 Part 1: Consolidate Chain of Custody

Combine hashes from all 5 labs into a master file.

**Open these files:**

- cases/USB_Imaging/chain_of_custody.csv
- cases/Memory_Forensics/chain_of_custody.csv
- cases/Email_Logs/chain_of_custody.csv
- cases/Network_Analysis/chain_of_custody.csv

**In cases/Final_Report/master_chain_of_custody.csv:**
Add one row for EACH evidence item with:

- Evidence_ID: USB-001, MEMORY-001, EMAIL-001, NETWORK-001
- Date_Received: (when seized)
- MD5_Hash: (from each lab)
- SHA256_Hash: (from each lab)
- Analyst_Name: (your name)
- Evidence_Description: Brief description

**Example row:**
```
USB-001,2024-10-20,14:00:00,Field Agent,fc8096...,6ebe35...,Michael,CASE-2024-001,"16GB SanDisk USB (usb.img)",./cases/secure_evidence/
```

---

## 📝 Part 2: Consolidate Analysis Log

Combine all commands run across all 5 labs.

**Open these files:**

- cases/USB_Imaging/analysis_log.csv
- cases/Memory_Forensics/analysis_log.csv
- cases/Email_Logs/analysis_log.csv
- cases/Network_Analysis/analysis_log.csv

**In cases/Final_Report/master_analysis_log.csv:**
Copy all rows from each of the 4 labs' analysis_log.csv files in chronological order.

**Sort by timestamp_utc** to create a complete timeline of analysis activities.

---

## 🔍 Part 3: Build Master Timeline

Create a comprehensive timeline showing WHEN attacks happened.

**File:** cases/Final_Report/MASTER_TIMELINE.txt

```
CLOUDCORE INCIDENT TIMELINE
Case: CLOUDCORE-2009-INS-001

=== PHASE 1: MALWARE INSTALLATION ===
[2009-12-05 02:11:23 UTC] - Keylogger installed and started

- Evidence: ToolKeylogger.exe process (PID 280) from Memory_Forensics
- Parent process: explorer.exe (normal user process)
- Network libraries loaded: WININET.dll, urlmon.dll, iertutil.dll
- Indicates: [suspect's system compromised with keylogger for credential theft]

=== PHASE 2: DATA STAGING ===
[2009-12-05 to 2009-12-06] - Files copied to USB

- Evidence: project_secrets.txt (inode 375) from USB_Imaging
- Content: Database credentials (db_pass=TempPass_2009!) and client data
- Backup copies: project_secrets_backup.txt (inode 1715)
- Email draft: email_draft.txt (inode 663) about security concerns
- Indicates: [suspect staging sensitive data for exfiltration]

=== PHASE 3: EMAIL EXFILTRATION ===
[2009-12-07 09:45:00 UTC] - Data sent via email

- Evidence: Email from Email_Logs analysis
- Sender: alex@cloudcore.com
- Recipient: exfil@personal.com (external personal account)
- Subject: "Project Update" (suspicious subject line)
- Attachment: project_secrets.zip (matches USB content)
- Indicates: [intentional data exfiltration to external address]

=== PHASE 4: NETWORK ACTIVITY ===
[2009-12-06 10:30-10:45 UTC] - Network traffic analysis

- Evidence: Network_Analysis PCAP shows keylogger C2 communication
- Keylogger exfiltration: Captured keystrokes sent to attacker server
- Timeline: Overlaps with USB staging and email preparation
- Indicates: [automated credential theft supporting insider attack]

=== PHASE 5: COVER-UP ===
[2009-12-07 after email] - Files deleted from USB

- Evidence: Multiple deleted files with "*" prefix in USB_Imaging
- Deleted: project_secrets.txt, email_draft.txt, flag_backup.txt
- Pattern: Intentional deletion of incriminating evidence
- Indicates: [suspect attempting to hide tracks after exfiltration]

=== CONCLUSION ===
Timeline shows coordinated insider attack assisted by external malware:

1. Keylogger installed (external compromise)
2. Credentials captured via keylogger
3. Sensitive data staged on USB using stolen credentials
4. Data exfiltrated via personal email account
5. Evidence deleted to cover tracks
Total duration: ~2 days (2009-12-05 to 2009-12-07)
```

---

## 🔗 Part 4: Create Evidence Correlation Matrix

Show how findings from different labs support each other.

**File:** cases/Final_Report/CORRELATION_MATRIX.txt

```
EVIDENCE CORRELATION MATRIX

Finding: "project_secrets.txt" with database credentials

- Lab 1: Found in recovered files (inode 375) on USB
- Lab 1: Contains db_pass=TempPass_2009! and MegaCorp client data
- Lab 1: Backup copy created (inode 1715) before deletion
- Lab 4: Referenced in email attachment as project_secrets.zip
→ CONCLUSION: Same sensitive file staged on USB → emailed → exfiltrated

Finding: ToolKeylogger.exe malware process

- Lab 2: ToolKeylogger.exe running (PID 280) under explorer.exe
- Lab 2: Network libraries loaded (WININET.dll, urlmon.dll) for exfiltration
- Lab 2: Process started 2009-12-05 02:11:23 UTC
- Lab 4: Email draft mentions "unusual network activity" 
→ CONCLUSION: Suspect's system compromised, enabling credential theft

Finding: Email exfiltration to external account

- Lab 4: Email from alex@cloudcore.com to exfil@personal.com
- Lab 4: Subject "Project Update" with project_secrets.zip attachment
- Lab 4: Timestamp 2009-12-07 09:45:00 UTC
- Lab 1: Attachment content matches deleted USB files
→ CONCLUSION: Direct evidence of intentional data theft

Finding: Keylogger C2 communication

- Lab 5: Network traffic shows keylogger data exfiltration
- Lab 5: Timeline overlaps with USB staging period
- Lab 2: Memory analysis confirms keylogger network capability
- Lab 4: Email draft shows suspect detected unusual activity
→ CONCLUSION: External malware enabled insider data theft

STRONG CORRELATIONS = INSIDER ATTACK ENABLED BY EXTERNAL MALWARE
```

---

## 📄 Part 5: Write Professional Report

**File:** cases/Final_Report/INVESTIGATION_REPORT.md

### Executive Summary (1-2 pages)

- What was the incident?
- What evidence was found?
- What is the conclusion?
- Who is responsible?

### Methodology (1-2 pages)

- What evidence was collected?
- What tools were used? (Sleuth Kit, Volatility, tshark, Autopsy)
- What chain of custody procedures were followed?
- Link to master_chain_of_custody.csv

### Findings by Lab (5-8 pages total)

#### Lab: Disk Forensics

- Total files on USB: [number]
- Deleted files recovered: [number]
- Suspicious files found: [list with evidence]
- Key artifacts: [what's most incriminating?]

#### Lab: Memory Forensics

- OS version: [Windows XP SP3]
- Total processes: [number]
- ToolKeylogger.exe: [running, PID 280, started 2009-12-05 02:11:23 UTC]
- Network libraries: [WININET.dll, urlmon.dll, iertutil.dll loaded]
- Key finding: [Keylogger process stealing credentials]

#### Lab: Email Analysis

- Total emails: [number]
- External recipients: [exfil@personal.com]
- Suspicious subjects: ["Project Update" for data exfiltration]
- Attachments: [project_secrets.zip, matches USB content]
- Key finding: [Direct evidence of intentional data theft]

#### Lab: Network Analysis

- Total packets: [number]
- Keylogger C2 traffic: [yes/no, timestamps, data volume]
- Data exfiltration: [yes/no, captured keystrokes, destination]
- DNS queries: [any suspicious domains?]
- Key finding: [Keylogger exfiltrating credentials to attacker]

#### Lab: Network Analysis

- Total packets: [number]
- Keylogger C2 traffic: [yes/no, timestamps, data volume]
- Data exfiltration: [yes/no, captured keystrokes, destination]
- DNS queries: [any suspicious domains?]
- Key finding: [Keylogger exfiltrating credentials to attacker]

### Timeline (1-2 pages)

- Link to MASTER_TIMELINE.txt
- Narrative version of events
- Show cause → effect relationships

### Correlations (1-2 pages)

- Link to CORRELATION_MATRIX.txt
- Explain how evidence supports conclusion
- Show consistency across multiple labs

### Conclusion (0.5-1 page)

- Based on ALL evidence, what happened?
- Who did it? How? When? Why?
- Confidence level: (strong, moderate, weak)
- Recommendation: (prosecution, further investigation, acquittal)

### Appendices

- Link to all CSV files
- Link to all analysis outputs
- References to specific findings

---

## 📋 Part 6: Create Summary Checklist

**File:** cases/Final_Report/DELIVERABLES_CHECKLIST.txt

```
COMPLETE FORENSIC INVESTIGATION CHECKLIST

EVIDENCE COLLECTION & CoC:

☐ Master chain_of_custody.csv contains all 5 labs
☐ All evidence hashes documented (MD5 and SHA256)
☐ Analyst names and dates recorded
☐ Evidence descriptions clear and specific

ANALYSIS DOCUMENTATION:

☐ Master analysis_log.csv contains all commands from 5 labs
☐ All timestamps UTC format
☐ All commands include output redirection filenames
☐ Notes explain purpose of each command

FINDINGS:

☐ USB_Imaging: Files listed and deleted files recovered
☐ Memory_Forensics: Suspicious processes and network connections documented
☐ Email_Logs: Headers, keywords, and recipients identified
☐ Network_Analysis: Keylogger C2, DNS, and exfiltration analysed

SYNTHESIS:

☐ Master timeline created (MASTER_TIMELINE.txt)
☐ Correlation matrix shows evidence relationships (CORRELATION_MATRIX.txt)
☐ Professional report written (INVESTIGATION_REPORT.md)
☐ Findings support conclusion
☐ Timeline is consistent across all labs

REPORT QUALITY:

☐ Professional tone (formal, objective)
☐ Evidence cited properly (specific file names, PIDs, timestamps)
☐ Conclusion is supported by evidence
☐ No speculation without evidence
☐ All suspicious findings documented
☐ Grammar and spelling correct

SUBMISSION:

☐ All files in cases/Final_Report/
☐ Report is readable (PDF or Markdown)
☐ CSV files are valid (can open in Excel/spreadsheet)
☐ All supporting documents included
```

---

## 📁 Part 7: Organise Deliverables

Final folder structure should look like:

```
cases/Final_Report/
├── master_chain_of_custody.csv      # All evidence hashes
├── master_analysis_log.csv          # All commands run
├── MASTER_TIMELINE.txt              # When did attacks happen?
├── CORRELATION_MATRIX.txt           # How do labs support each other?
├── INVESTIGATION_REPORT.md          # Professional final report
├── DELIVERABLES_CHECKLIST.txt       # Did we complete everything?
└── [output files from each lab]     # Reference materials
```

---

## 🎯 Part 8: Reflect on Investigation Process

**File:** cases/Final_Report/PROCESS_REFLECTION.txt

Questions to answer:

1. **What evidence was MOST important?**
   - Which single piece of evidence proved guilt?
   - Why was that more important than others?

2. **What did each lab contribute?**
   - Could we have solved it with just Lab 1? Lab 2?
   - Why was having all 5 labs necessary?

3. **What challenges did you face?**
   - Command syntax errors?
   - Evidence interpretation?
   - Thinking like an attacker?

4. **What would you do differently?**
   - Better search keywords?
   - Different tools?
   - Different analysis order?

5. **How confident in your conclusion?**
   - Strong (multiple corroborating sources)
   - Moderate (some gaps)
   - Weak (inconclusive)
   - Why?

---

## ✅ Final Deliverables

**In cases/Final_Report/, you should have:**

- ✅ master_chain_of_custody.csv - All evidence hashes consolidated
- ✅ master_analysis_log.csv - All commands documented
- ✅ MASTER_TIMELINE.txt - Attack timeline
- ✅ CORRELATION_MATRIX.txt - Evidence relationships
- ✅ INVESTIGATION_REPORT.md - Professional report (2-10 pages)
- ✅ DELIVERABLES_CHECKLIST.txt - Quality verification
- ✅ PROCESS_REFLECTION.txt - Your thoughts on investigation

---

## 📋 Quick Checklist for Report Quality

- [ ] **Professional tone**: Formal, objective, no opinions
- [ ] **Specific evidence**: All findings cite file names, PIDs, timestamps, IP addresses
- [ ] **Timeline consistency**: Events make logical sense in order
- [ ] **Chain of custody**: All evidence properly documented with hashes
- [ ] **Correlation**: Findings from different labs support each other
- [ ] **Conclusion clarity**: Reader understands WHO, WHAT, WHEN, WHERE, HOW
- [ ] **No speculation**: Only facts supported by evidence
- [ ] **Proper grammar**: Spell-checked and proofread

---

## 📚 Summary

This lab brings all 4 previous investigations together into a unified case narrative. Your report should answer:

**THE 5 W's + H:**

- **WHO** committed the crime?
- **WHAT** did they do?
- **WHEN** did it happen? (timeline)
- **WHERE** did evidence go?
- **WHY** did they do it? (motive, if evident)
- **HOW** did they carry it out? (method)

If your report answers all 6 questions with supporting evidence, you've written a complete forensic investigation!

---

**Congratulations on completing all 5 labs!**

You've now experienced a complete forensic investigation from evidence collection through professional reporting. This is what real-world digital forensics looks like.

Remember: **Documentation is Evidence. Evidence is Truth.**

---

## Going further — Incident Zero
Enjoyed rebuilding the Cloudcore case? *Incident Zero*'s Forensics module has you chase attribution and reconstruct an attack timeline under pressure — the same detective work, played as a cooperative game. ([Incident Zero](https://incidentzero.retroverse.studio/) — free, print-and-play.)

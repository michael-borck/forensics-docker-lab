# Lab 6: Case Consolidation & Final Report - Complete Walkthrough

## Mission

Synthesize all evidence from Labs 1-5 into a unified, professional investigation narrative. This is where individual artifacts become a coherent case story.

---

## Prerequisites

- [ ] Completed all Labs 1-5
- [ ] Have analysis_log.csv files from each lab
- [ ] Have key findings documented:
  - Lab 1: Deleted files (project_secrets.zip, email_draft.txt)
  - Lab 2: TrueCrypt process, suspicious TCP connections
  - Lab 3: Autopsy file timestamps and metadata
  - Lab 4: Email to exfil@personal.com, USB activity
  - Lab 5: IRC C2, malware downloads, 50MB exfiltration

---

## Lab Setup

```bash
mkdir -p cases/Final_Report/outputs
```

---

## Timeline Construction

### Step 1: Consolidate Key Timestamps

**Walkthrough:**
```bash
# Create master timeline from all labs
cat > cases/Final_Report/master_timeline.txt << 'EOF'
2009-12-01 - Data preparation phase
  - Deleted files appear on disk (Lab 1)
  - Timestamps: 14:30-15:00 UTC

2009-12-05 - Memory snapshot (Lab 2)
  - TrueCrypt.exe running (PID indicates encryption setup)
  - Outbound TCP connections to suspicious IPs
  - Evidence of staging data

2009-12-06 10:00 AM - Email activity (Lab 4)
  - Email sent to exfil@personal.com with attachments
  - Lab 4 analysis shows headers, timestamps

2009-12-06 10:32-10:45 AM - Network exfiltration (Lab 5)
  - IRC C2 connection to hunt3d.devilz.net
  - Malware downloads via botnet
  - 50MB data transfer to 203.0.113.50:8080
  - MATCHES project_secrets.zip size from Lab 1

2009-12-06 10:50 AM - USB removal (Lab 4 logs)
  - Physical USB device removed from workstation
  - Correlates with network exfil completion
EOF
cat cases/Final_Report/master_timeline.txt
```

**Assignment (With CoC):**
```bash
coc-log "cat cases/Final_Report/master_timeline.txt" "Consolidated investigation timeline from all labs"
```

---

### Step 2: Cross-Lab Correlation

Create correlation matrix showing how evidence supports the threat:

```bash
cat > cases/Final_Report/correlation_analysis.txt << 'EOF'
EVIDENCE CORRELATION MATRIX
============================

Hypothesis: Insider data exfiltration via USB + IRC botnet coordination

Supporting Evidence:

1. DATA STAGING (Lab 1 + Lab 3)
   - project_secrets.zip created/deleted on disk
   - Autopsy confirms timestamps match exfil timeline
   - File size ~50 MB matches network transfer

2. ENCRYPTION PREPARATION (Lab 2)
   - TrueCrypt.exe running (suggests encrypted transfer prep)
   - Parent process: explorer.exe (normal user activity cover)
   - Outbound connections to staging server

3. EMAIL COORDINATION (Lab 4)
   - Email sent to exfil@personal.com
   - Subject: "Project Update"
   - Attachment: project_secrets.zip reference
   - Timestamp: 10:00 AM, before network exfil

4. NETWORK EXFILTRATION (Lab 5)
   - IRC C2 connection (hunt3d.devilz.net, #s01)
   - Botnet commands for file staging
   - HTTP POST of 50MB file
   - Destination: 203.0.113.50:8080
   - Timeline: 10:32-10:45 AM (32 min after email)

5. PHYSICAL TRANSFER (Lab 4 Logs + Lab 1 Evidence)
   - USB mount event logged
   - Physical device removal confirmed
   - Matches file deletion pattern (covering tracks)

CONCLUSION:
Multi-stage insider attack:
  Step 1: Identify/prepare sensitive data (Lab 1: deleted files)
  Step 2: Encrypt data (Lab 2: TrueCrypt process)
  Step 3: Coordinate via email (Lab 4: external email)
  Step 4: Execute exfil via IRC botnet (Lab 5: network traffic)
  Step 5: Physical removal via USB (Lab 4: mount/unmount logs)
EOF
cat cases/Final_Report/correlation_analysis.txt
```

---

### Step 3: Chain of Custody Integration

**Compile all CoC logs:**

```bash
# Combine all analysis_log.csv files
cat > cases/Final_Report/complete_chain_of_custody.csv << 'EOF'
Lab,Analyst,Command,Timestamp,Hash,Evidence_File
EOF

# Append from each lab
for lab in 1 2 3 4 5; do
  if [ -f "cases/Lab_${lab}/analysis_log.csv" ]; then
    tail -n +2 "cases/Lab_${lab}/analysis_log.csv" | while read line; do
      echo "Lab_${lab},$line" >> cases/Final_Report/complete_chain_of_custody.csv
    done
  fi
done

cat cases/Final_Report/complete_chain_of_custody.csv
```

**Assignment (With CoC):**
```bash
coc-log "cat cases/Final_Report/complete_chain_of_custody.csv" "Consolidated chain of custody from all labs"
```

---

## Writing the Final Report

### Structure Template

```markdown
# CLOUDCORE INC. - INCIDENT INVESTIGATION REPORT
## Case: CLOUDCORE-2009-INS-001

---

## EXECUTIVE SUMMARY (1 page)

**Incident:** Suspected insider data exfiltration
**Scope:** USB evidence + memory + email + network artifacts
**Status:** Active investigation
**Recommendation:** Escalate to law enforcement

---

## INVESTIGATION METHODOLOGY (1-2 pages)

**Evidence Examined:**
- Disk image (Lab 1): deleted files, timestamps
- Memory dump (Lab 2): running processes, network connections
- Email/logs (Lab 4): communication patterns
- Network PCAP (Lab 5): exfiltration traffic

**Tools Used:**
- Sleuth Kit (disk analysis)
- Volatility 2 (memory analysis)
- tshark (network analysis)
- Autopsy GUI (metadata analysis)

**Limitations:**
- No write blocker (educational environment)
- Containerized analysis (not physical forensics)
- Limited network capture duration

---

## DETAILED FINDINGS (3-5 pages)

### Finding 1: Data Staging
**Source:** Lab 1
**Details:** project_secrets.zip deleted from user Documents folder
**Significance:** Suggests deliberate deletion to cover tracks
**Hash:** [Include hash from Lab 1 output]

### Finding 2: Encryption Activity
**Source:** Lab 2 Memory Analysis
**Details:** TrueCrypt.exe process running with hidden volume config
**Significance:** Preparation for encrypted data transfer
**PID/Timeline:** [Include from Lab 2 output]

### Finding 3: External Communication
**Source:** Lab 4 Email Analysis
**Details:** Email to exfil@personal.com with subject "Project Update"
**Significance:** Coordination with external recipient
**Timestamp:** [Include from Lab 4 logs]

### Finding 4: Network Exfiltration
**Source:** Lab 5 Network Analysis
**Details:** 50MB HTTP POST to 203.0.113.50:8080 via IRC C2
**Significance:** Actual data transfer to external server
**Timeline:** [Include from Lab 5 output, shows 10:32-10:45 AM]

### Finding 5: Timeline Correlation
**Source:** All Labs
**Details:** See master_timeline.txt and correlation_analysis.txt
**Significance:** Proves coordinated, multi-stage attack

---

## UNIFIED TIMELINE

See: cases/Final_Report/master_timeline.txt

Key points:
- 2009-12-01: Data preparation
- 2009-12-05: Encryption/staging setup
- 2009-12-06 10:00 AM: Email coordination
- 2009-12-06 10:32 AM: Network exfiltration begins
- 2009-12-06 10:45 AM: ~50MB transferred
- 2009-12-06 10:50 AM: USB device removed

---

## CHAIN OF CUSTODY

**Summary:**
- All evidence hashed on receipt (Lab 1)
- Analysis commands logged with timestamps (coc-log)
- Output files preserved with SHA256 hashes
- No modifications made to original evidence

**Complete CoC:** See cases/Final_Report/complete_chain_of_custody.csv

---

## CONCLUSIONS

**Based on comprehensive analysis of all available evidence:**

1. **Insider Threat Confirmed** - Employee had access to stolen data
2. **Intentional Exfiltration** - Multi-stage attack shows planning
3. **IRC Botnet Used** - Sophisticated tooling for cover
4. **Estimated Data Loss** - ~50 MB of proprietary code/client data
5. **Scalability** - Attack methods could affect other employees

---

## RECOMMENDATIONS

1. **Immediate Actions**
   - Escalate to law enforcement (AFP Cybercrime)
   - Revoke employee access, preserve equipment
   - Notify affected clients per Privacy Act

2. **Incident Response**
   - Forensic report to legal team
   - Support criminal investigation
   - Implement network monitoring

3. **Preventive Measures**
   - Review access controls
   - Monitor email for external transfers
   - Implement USB blocking on critical systems
   - Add IRC C2 detection to IDS

---

## APPENDIX

See supporting documents:
- Lab 1: Disk analysis details (recovered files, hashes)
- Lab 2: Memory analysis (process tree, network connections)
- Lab 3: Autopsy findings (file metadata, recovery)
- Lab 4: Email/log analysis (headers, syslog entries)
- Lab 5: Network analysis (IRC C2, exfil traffic)

---

**Prepared by:** [Your Name], Digital Forensic Analyst
**Date:** [Today]
**Case Number:** CLOUDCORE-2009-INS-001
```

---

## Creating Your Report

**Walkthrough:**
```bash
# Copy template and customize
cp templates/final_case_report.md cases/Final_Report/final_case_report.md

# Edit with your findings
nano cases/Final_Report/final_case_report.md
```

**Assignment (With CoC):**
```bash
# Log the report creation/verification
coc-log "wc -l cases/Final_Report/final_case_report.md" "Verify final report generated"
coc-log "head -20 cases/Final_Report/final_case_report.md" "Final report header verification"
```

---

## Wrap-Up Checklist

Before submission:

- [ ] Master timeline complete (master_timeline.txt)
- [ ] Correlation analysis finished (correlation_analysis.txt)
- [ ] Complete CoC assembled (complete_chain_of_custody.csv)
- [ ] Final report written (final_case_report.md)
- [ ] All supporting files from Labs 1-5 referenced
- [ ] CoC logging completed for all analysis

---

## Why This Matters

In real forensic investigations:
- **Juries don't see labs 1-5 separately** - they see the final report
- **Chain of custody proves nothing was planted** - critical for prosecution
- **Timeline integration tells the story** - jury-friendly narrative
- **Professional presentation** - determines case viability

---

*Congratulations! You've completed a full forensic investigation from evidence collection through final reporting. This is the work of professional forensic analysts.*

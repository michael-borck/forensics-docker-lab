---
format:
  html:
    embed-resources: true
---

# Cloudcore Inc. Data Breach Investigation
## Multi-Faceted Forensic Analysis

---

## Case Information

**Case Number:** CLOUDCORE-2009-INS-001

**Incident Type:** Suspected Data Exfiltration

**Investigation Status:** Active Triage

**Lead Investigator:** [Your Name - Student Analyst]

**Date Opened:** December 6, 2009

---

## Company Background

**Cloudcore Inc.** is a mid-sized Australian software firm specializing in cloud security solutions. The company employs approximately 150 staff across offices in Sydney and Melbourne, serving clients in the financial services, healthcare, and government sectors.

Cloudcore handles sensitive data including:

- Client database exports and customer lists
- Financial reports and billing information
- Proprietary source code and algorithms
- Internal email archives and communications
- API keys and system credentials

---

## Incident Overview

### Initial Alert

On **Monday, December 6, 2009 at 8:00 AM**, Cloudcore's IT Security Team received a tip from an internal whistleblower regarding a potential data breach. The whistleblower reported that a recently terminated employee may have exfiltrated sensitive client data via USB storage device before leaving the company premises.

### The Suspect

An employee (identity redacted for educational purposes) was terminated on **December 5, 2009** for documented performance issues. During the exit process, the following suspicious activities were noted:

- **Unusual Access Patterns:** Security logs showed the employee accessing multiple workstations outside normal business hours during their final two weeks of employment
- **Last System Access:** December 4, 2009 at 9:47 PM (well after standard business hours)
- **Authorized Access:** The employee had legitimate access to sensitive systems including:
  - Client database export tools
  - Financial reporting systems
  - Source code repositories
  - Internal email archives

### Evidence Recovery

During the investigation, multiple pieces of digital evidence were collected and preserved:

**Digital Evidence Collected:**

1. **USB Storage Device** (Suspected primary exfiltration vector)
   - **Device:** Generic USB flash volume (practice evidence)
   - **Capacity:** ~64 MB volume image
   - **Volume Label:** `PRACTICE`
   - **File System:** FAT32
   - **Forensic Image:** `usb.img` (raw) and `usb.E01` (Expert Witness Format wrapper)
   - **Status:** Ready for carving and file system analysis

2. **Network Traffic Capture** (Potential data transfer evidence)
   - **Capture Source:** Corporate gateway firewall logs and PCAP files
   - **Time Period:** December 1-5, 2009
   - **Format:** PCAP network packet captures
   - **Content:** Email communications, file transfers, and unusual outbound connections
   - **Analysis Focus:** Identification of data exfiltration over network

3. **Email Archives** (Communication evidence)
   - **Source:** Corporate email server (Suspect's mailbox)
   - **Format:** MBOX file (`mail.mbox`)
   - **Time Period:** Correspondence around the incident window
   - **Analysis Focus:** Intent indicators, coordination, or confession evidence

4. **System Memory Snapshot** (Volatile memory forensics)
   - **Source:** Forensic acquisition of suspect workstation RAM
   - **Format:** Memory dump file (volatile memory image)
   - **Timing:** Captured during investigation period
   - **Analysis Focus:** Active processes, hidden malware, encryption keys, or running malicious tools

All evidence is company property (issued equipment), therefore no search warrant was required for examination. However, proper chain of custody must be maintained for potential escalation to law enforcement under Australian Cybercrime legislation.

---

## Legal and Regulatory Context

### Relevant Australian Legislation

This investigation operates under the framework of:

1. **Criminal Code Act 1995 (Cth)**
   - Sections 477-478: Computer offences including unauthorized access and data theft
   - Potential referral to Australian Federal Police (AFP) if criminal activity confirmed
   - https://www.legislation.gov.au/C2004A04868/2018-12-29/text

2. **Privacy Act 1988**
   - Obligations to protect client personal information
   - Breach notification requirements if customer data compromised
   - https://www.legislation.gov.au/C2004A03712/2014-03-12/text

3. **Cybercrime Legislation Amendment (2012)**
   - Enhanced penalties for data theft and unauthorized disclosure
   - https://www.legislation.gov.au/C2012A00120/latest/text

### Chain of Custody Requirements

All forensic analysis must comply with:

- **ISO 27037:2012** 
  - Guidelines for identification, collection, acquisition and preservation of digital evidence
  - https://www.iso.org/standard/44381.html
- **Australian Government ISM** 
  - Information Security Manual guidelines
  - https://www.cyber.gov.au/business-government/asds-cyber-security-frameworks/ism
- **ACPO Principles** 
  - Association of Chief Police Officers Good Practice Guide for Digital Evidence
  - https://www.digital-detective.net/digital-forensics-documents/ACPO_Good_Practice_Guide_for_Digital_Evidence_v5.pdf

### Real-World Context

This scenario parallels recent Australian incidents including:

- **Optus Data Breach (2022):** 9.8 million customer records exposed
- **Medibank Breach (2022):** Customer health data exfiltration
- Both cases highlighted the importance of rapid triage and proper evidence handling

---

## Investigation Objectives

### Your Role

You are a **junior digital forensic analyst** on Cloudcore's incident response team. Multiple pieces of evidence require comprehensive analysis across different forensic domains:

#### Case 1: USB Device Triage (Storage Media Forensics)
1. **Identify Present Data**
   - What files currently exist on the device?
   - Are there any obvious signs of sensitive data storage?

2. **Recover Deleted Content**
   - What files have been recently deleted?
   - Can deleted files be recovered and examined?

3. **Assess Breach Scope**
   - Is there evidence of client data exfiltration?
   - What types of sensitive information are present?

4. **Build Activity Timeline**
   - When was data copied to the device?
   - When were files deleted (potential evidence of cover-up)?
   - Does device activity correlate with system access logs?

#### Case 2: Network Traffic Analysis (Network Forensics)
1. **Identify Suspicious Communications**
   - What unusual network traffic occurred during the suspect window?
   - Which external hosts were contacted?
   - What protocols and ports were used?

2. **Analyze Data Transfers**
   - Evidence of large file uploads or downloads?
   - Compressed archive transfers (ZIP, RAR)?
   - Encrypted tunneling (VPN, SSH)?

3. **Correlation with Timeline**
   - When did suspicious network activity occur?
   - Does it match the employee's documented access times?

#### Case 3: Email Archive Analysis (Email Forensics)
1. **Review Correspondence**
   - Messages indicating intent or planning?
   - Evidence of sharing credentials or access details?
   - Discussions with external parties?

2. **Artifact Recovery**
   - Deleted messages that may indicate cover-up?
   - Metadata analysis (timestamps, recipients)?
   - Attachment analysis (what was being shared)?

#### Case 4: Memory Forensics (Volatile Memory Analysis)
1. **Process Analysis**
   - What programs were running at the time of acquisition?
   - Evidence of hidden or malicious processes?
   - Command-line arguments and parameters?

2. **Network Connections**
   - Active network sockets and connections?
   - Evidence of command-and-control communication?

3. **Artifact Extraction**
   - Encryption keys or credentials in memory?
   - Clipboard contents or typed commands?
   - File handles and open files?

### Critical Intelligence

Based on the whistleblower tip and initial log analysis, investigators should look specifically for:

#### Data Exfiltration Indicators:

- **Client Lists:** CSV or Excel files containing customer information
- **Database Exports:** Structured data files with multiple records
- **Financial Documents:** PDF or DOCX files with billing/revenue data
- **Source Code:** Programming files (.py, .java, .js, etc.)
- **Email Archives:** PST, MBOX, or EML files
- **Network Data Transfers:** Large uploads to external FTP, cloud services, or email
- **Memory Artifacts:** Encryption keys, decrypted data, or running exfiltration tools

#### Anti-Forensic Activities:

- **Deleted Files:** Evidence of recent deletions (USB carving)
- **Archive Files:** ZIP, 7Z, or TAR files (data packaging for transfer)
- **Malware Tools:** Presence of keyloggers or remote access tools (memory analysis)
- **Secure Deletion Tools:** Evidence of file wiping utilities
- **Encrypted Communications:** SSL/TLS tunnels, VPN usage (network traffic)
- **Log Tampering:** Cleared event logs or suspicious system activity (memory forensics)

#### Timeline Indicators:

- **File Creation Times:** When data was first copied to USB
- **File Modification Times:** When files were last accessed or edited
- **File Deletion Times:** When deletion activity occurred
- **After-Hours Activity:** Timestamps matching logged access outside business hours

---

## Forensic Evidence Files

### Evidence Location

All forensic evidence files are located in the `/evidence/` directory (read-only mount within the Docker container).

### Available Evidence by Case Type

**Case 1: USB Device Analysis**

- **Filenames:** `usb.img` (raw image) and `usb.E01` (EnCase wrapper of the same data)
- **Format:** Raw disk image and Expert Witness Format (EnCase Evidence File)
- **Content:** ~64 MB FAT32 volume labelled `PRACTICE`. The suspect's sensitive files were copied on, then **deleted** — the directory entries are freed but the data clusters remain in unallocated space, so they are recoverable and carvable. Planted (then deleted) files include:
  - `Documents/project_secrets.txt` — proprietary Cloudcore source code with hard-coded database credentials
  - `Documents/project_secrets.zip` — a real ZIP archive (carvable by its PK header) holding the same proprietary material
  - `flag.txt` — the recovery-exercise flag
  - `tmp/email_draft.txt` — a draft email to `exfil@personal.com` describing the exfiltration
  - `tmp/truecrypt_config.txt` — notes on a hidden encrypted volume for data transfer
  - `var/log/syslog` — a syslog fragment showing the USB mount and file copy
- **Analysis Method:** File carving, deleted file recovery, timeline reconstruction

**Case 2: Network Traffic Analysis**

- **Filename:** `network.cap`
- **Format:** Packet capture file
- **Content:** Raw network packets from suspect communication period
- **Analysis Method:** Capture parsing, protocol analysis, flow reconstruction

**Case 3: Email Archive Analysis**

- **Filename:** `mail.mbox`
- **Format:** MBOX (standard mailbox format)
- **Content:** Email messages, metadata, and attachments
- **Analysis Method:** Email parsing, metadata extraction, attachment analysis

**Case 4: Memory Forensics**

- **Filename:** `memory.raw` (downloaded — see `docs/evidence-sources.md`)
- **Format:** Raw memory dump (Volatility-compatible)
- **Content:** System RAM at time of acquisition
- **Analysis Method:** Process analysis, DLL injection detection, artifact extraction

### Evidence Integrity Verification

Before beginning analysis, you **MUST** verify evidence integrity:

```bash
# Verify E01 container integrity
ewfverify /evidence/usb.E01

# Calculate hash values for chain of custody
md5sum /evidence/usb.E01
sha256sum /evidence/usb.E01

# Verify other evidence files
md5sum /evidence/network.cap
md5sum /evidence/mail.mbox
md5sum /evidence/memory.raw
```

---

## Investigation Constraints

### Scope and Available Labs

This multi-case investigation allows you to work across different forensic domains:

- **Storage Media Forensics (USB Lab):** File carving, deleted file recovery, filesystem analysis
- **Network Forensics (PCAP Lab):** Packet analysis, flow reconstruction, protocol examination
- **Email Forensics (MBOX Lab):** Message parsing, attachment analysis, metadata extraction
- **Memory Forensics (Volatility Lab):** Process analysis, malware detection, artifact recovery

Each case provides independent evidence that may corroborate or contradict other findings. You may analyse one case in depth or perform comparative analysis across multiple evidence types.

### Time Recommendations

Each case can be completed independently:

- **USB Imaging Case:** 2-3 hours
- **Network Traffic Analysis:** 2-3 hours
- **Email Archive Analysis:** 1-2 hours
- **Memory Forensics:** 2-3 hours

You may choose to complete all cases or focus on specific domains depending on your interests and course requirements.

### Resource Constraints

- **Analysis Tools:** Sleuth Kit CLI for primary analysis (Autopsy GUI available as optional supplement)
- **Computing Environment:** Containerized Docker environment (lightweight, cross-platform compatible)
- **Documentation:** All findings must be reproducible using only documented commands

---

## Ethical Considerations

### Professional Responsibilities

As a forensic analyst, you must:

1. **Maintain Objectivity**
   - Report ALL findings, both inculpatory (suggesting guilt) and exculpatory (suggesting innocence)
   - Avoid speculation or bias
   - Present facts, not conclusions about guilt

2. **Preserve Evidence Integrity**
   - Never modify original evidence
   - Work only on forensic copies
   - Document every action taken

3. **Respect Privacy**
   - Handle personal data responsibly
   - Maintain confidentiality of investigation details
   - Follow data protection regulations

4. **Document Thoroughly**
   - Every command executed must be recorded
   - All findings must be reproducible
   - Chain of custody must be maintained

### Impact Awareness

Your analysis may be used in:

- **Employment Proceedings:** Termination justification or wrongful dismissal claims
- **Criminal Prosecution:** If evidence reveals criminal activity
- **Civil Litigation:** If clients sue for data breach damages

The outcome could significantly affect someone's career, liberty, and livelihood. **Accuracy and objectivity are paramount.**

---

*This is a simulated scenario created for educational purposes. Any resemblance to actual events or persons is coincidental. Evidence files have been artificially created for training use.*

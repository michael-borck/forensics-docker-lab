# Cloudcore Inc. Data Breach Investigation
## USB Evidence Triage Case

---

## Case Information

**Case Number:** CLOUDCORE-2009-INS-001
**Incident Type:** Suspected Data Exfiltration
**Investigation Status:** Active Triage
**Lead Investigator:** [Your Name - Student Analyst]
**Date Opened:** December 7, 2009

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

On **Monday, December 7, 2009 at 8:00 AM**, Cloudcore's IT Security Team received a tip from an internal whistleblower regarding a potential data breach. The whistleblower reported that a recently terminated employee may have exfiltrated sensitive client data via USB storage device before leaving the company premises.

### The Suspect

An employee (identity redacted for educational purposes) was terminated on **December 6, 2009** for documented performance issues. During the exit process, the following suspicious activities were noted:

- **Unusual Access Patterns:** Security logs showed the employee accessing multiple workstations outside normal business hours during their final two weeks of employment
- **Last System Access:** December 5, 2009 at 9:47 PM (well after standard business hours)
- **Authorized Access:** The employee had legitimate access to sensitive systems including:
  - Client database export tools
  - Financial reporting systems
  - Source code repositories
  - Internal email archives

### Evidence Recovery

During a routine workspace audit conducted on December 7, 2009, a concealed USB storage device was discovered in the employee's desk drawer.

**Physical Evidence Details:**
- **Device:** SanDisk Cruzer Blade USB 2.0 Flash Drive
- **Capacity:** 16GB
- **Model:** SDCZ50-016G-A57
- **Serial Number:** [Redacted for lab use]
- **File System:** NTFS (Windows formatted)
- **Condition:** Device appeared to have been recently used; no physical damage

The USB device is company property (issued equipment), therefore no search warrant was required for examination. However, proper chain of custody must be maintained for potential escalation to law enforcement under Australian Cybercrime legislation.

---

## Legal and Regulatory Context

### Relevant Australian Legislation

This investigation operates under the framework of:

1. **Criminal Code Act 1995 (Cth)**
   - Sections 477-478: Computer offences including unauthorized access and data theft
   - Potential referral to Australian Federal Police (AFP) if criminal activity confirmed

2. **Privacy Act 1988**
   - Obligations to protect client personal information
   - Breach notification requirements if customer data compromised

3. **Cybercrime Legislation Amendment (2012)**
   - Enhanced penalties for data theft and unauthorized disclosure

### Chain of Custody Requirements

All forensic analysis must comply with:
- **ISO 27037:2012** - Guidelines for identification, collection, acquisition and preservation of digital evidence
- **Australian Government ISM** - Information Security Manual guidelines
- **ACPO Principles** - Association of Chief Police Officers Good Practice Guide for Digital Evidence

### Real-World Context

This scenario parallels recent Australian incidents including:
- **Optus Data Breach (2022):** 9.8 million customer records exposed
- **Medibank Breach (2022):** Customer health data exfiltration
- Both cases highlighted the importance of rapid triage and proper evidence handling

---

## Investigation Objectives

### Your Role

You are a **junior digital forensic analyst** on Cloudcore's incident response team. Your task is to conduct an **initial triage examination** of the seized USB device to:

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

### Critical Intelligence

Based on the whistleblower tip and initial log analysis, investigators should look specifically for:

#### Data Exfiltration Indicators:
- **Client Lists:** CSV or Excel files containing customer information
- **Database Exports:** Structured data files with multiple records
- **Financial Documents:** PDF or DOCX files with billing/revenue data
- **Source Code:** Programming files (.py, .java, .js, etc.)
- **Email Archives:** PST, MBOX, or EML files

#### Anti-Forensic Activities:
- **Deleted Files:** Evidence of recent mass deletions
- **Archive Files:** ZIP, 7Z, or TAR files (data packaging for transfer)
- **Encryption Tools:** Presence of encryption software or encrypted containers
- **Secure Deletion Tools:** Evidence of file wiping utilities

#### Timeline Indicators:
- **File Creation Times:** When data was first copied to USB
- **File Modification Times:** When files were last accessed or edited
- **File Deletion Times:** When deletion activity occurred
- **After-Hours Activity:** Timestamps matching logged access outside business hours

---

## Forensic Image Details

### Evidence File

**Filename:** `cloudcore_suspect_usb.E01`
**Format:** Expert Witness Format (EnCase Evidence File)
**Location:** `/evidence/` directory (read-only mount)

### Evidence Integrity

Before beginning analysis, you **MUST** verify evidence integrity:

```bash
# Verify E01 container integrity
ewfverify /evidence/cloudcore_suspect_usb.E01

# Calculate hash values for chain of custody
md5sum /evidence/cloudcore_suspect_usb.E01
sha256sum /evidence/cloudcore_suspect_usb.E01
```

**Expected Results:**
- `ewfverify` should report: "SUCCESS: integrity verification succeeded"
- Hash values must be documented in your Chain of Custody form
- Any verification failures must be reported immediately

### Working with E01 Files

E01 (Expert Witness Format) files must be mounted before analysis:

```bash
# Create mount point
mkdir -p /tmp/ewf

# Mount the E01 file
ewfmount /evidence/cloudcore_suspect_usb.E01 /tmp/ewf

# The raw disk image is now accessible at:
# /tmp/ewf/ewf1
```

All Sleuth Kit commands should then be run against `/tmp/ewf/ewf1`.

---

## Investigation Constraints

### Scope Limitations

This is a **triage investigation** only. Your objectives are:
- Rapid assessment of evidence content
- Identification of obvious indicators of compromise
- Documentation sufficient for escalation decisions

This is **NOT** a full forensic examination. Advanced techniques (memory forensics, network traffic analysis, full timeline reconstruction) may be conducted later if triage findings warrant escalation.

### Time Constraints

- **In-Lab Session:** 3 hours (Week 7 practical)
- **Independent Work:** 5-7 additional hours (report writing, detailed analysis)
- **Submission Deadline:** [set per your schedule]

### Resource Constraints

- **Analysis Tools:** Limited to Sleuth Kit CLI (Autopsy GUI optional for students with higher-spec hardware)
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

## Next Steps

1. **Read the Assignment Brief** (`ASSIGNMENT.md`) for detailed task requirements and grading rubric
2. **Review the Command Reference** (`COMMANDS.md`) for forensic tool usage
3. **Begin Your Investigation** following proper chain of custody procedures
4. **Document Everything** using the provided workbook template

Remember: This case may seem like a training exercise, but the skills you develop here directly apply to real-world investigations that have serious consequences. Treat this evidence with the professionalism it deserves.

---

*This is a simulated scenario created for educational purposes. Any resemblance to actual events or persons is coincidental. Evidence files have been artificially created for training use.*

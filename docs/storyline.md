# Forensics Docker Lab: Overall Investigative Timeline and Story

## Case Background
This lab series simulates a digital forensics investigation into a suspected data exfiltration incident at Cloudcore Inc., a mid-sized software company. On 2009-12-05, IT security detected anomalous network activity and USB usage on employee workstations. The incident response team imaged affected systems (disks, memory) and collected logs, emails, and PCAPs. Your role is a forensic analyst piecing together the timeline of events.

## Key Timeline of Events (Chronological Narrative)
The following outlines the suspected exfiltration storyline, derived from artifacts across all labs. Each lab builds on prior findings to construct a coherent picture.

### Incident Setup (Pre-2009-12-05)
- **Context:** Employee "Alex Doe" (suspect) works in engineering with access to proprietary source code and client data.
- **Initial Actions:** Alex copies sensitive files (e.g., `project_secrets.zip`) to a workstation for staging.

### Phase 1: Local Preparation and Deletion (2009-12-01 to 12-05)
- **Disk Activity:** Sensitive files are copied onto a ~64 MB FAT32 USB volume labelled "PRACTICE", then deleted to hide tracks. Deletion only frees the FAT directory entries — the underlying data clusters survive in unallocated space, so the content is recoverable and carvable.
- **Link to Labs:** Lab 1 (USB Imaging & Triage) – Establish chain-of-custody for `usb.img` / `usb.E01`, recover deleted artifacts using Sleuth Kit (fls, icat, tsk_recover) and carve them with foremost, analyse filesystem structure and recover file content.
- **Key Findings (deleted, recoverable files):**
  - **Documents/project_secrets.txt:** Cloudcore proprietary source code with hardcoded database credentials (db_host=192.168.1.100, db_user=alex_doe, db_pass=TempPass_2009!) and client data (MegaCorp Inc. project details)
  - **Documents/project_secrets.zip:** A real ZIP archive (carvable via its PK header) containing the same proprietary source material staged for transfer
  - **flag.txt:** Recovery-exercise flag confirming successful carving
  - **tmp/email_draft.txt:** Draft email to exfil@personal.com describing the exfiltration of project_secrets.zip
  - **tmp/truecrypt_config.txt:** Notes on a hidden AES-256 encrypted volume intended for the data transfer
  - **var/log/syslog (fragment):** System log showing the USB device connect, a `mount` of the drive, and a copy of project_secrets.zip to the USB
  - **Timeline:** Multiple deleted files with "secrets" and "flag" in their names, plus the syslog copy entry, suggest intentional data staging and destruction
  - **Significance:** Database credentials in source code would allow unauthorized access to backend systems; the email draft and TrueCrypt notes suggest Alex planned and prepared for exfiltration

### Phase 2: Malware Installation and Memory Analysis (2009-12-05, 02:11 AM)
- **Activity:** Previously, a keylogger (ToolKeylogger.exe) was installed to capture credentials and sensitive data. The malware runs silently under explorer.exe with internet connectivity to exfiltrate captured keystrokes to an attacker server.
- **Link to Labs:** Lab 2 (Memory Forensics) – Analyse `evidence/memory.raw` (Windows XP SP3 memory dump) with Volatility 2. Plugins (pslist/pstree) reveal ToolKeylogger.e (PID 280, parent explorer.exe) running malicious keylogger; dlllist shows loaded keylogging DLL and internet libraries (WININET.dll, urlmon.dll, iertutil.dll) for remote data exfiltration. psscan verifies the process is not hidden (visible in process list). Process started at 2009-12-05 02:11:23 UTC.
- **Key Findings:** Keylogger process tree shows malicious code spawned from normal user processes; loaded internet libraries prove data exfiltration capability; malware was active for 16+ hours before memory capture (18:47:28), capturing keystrokes and potentially passwords throughout the day. This is the mechanism for credential theft enabling later data access.

### Phase 3: Email and Log Correlation (2009-12-07)
- **Activity:** Alex sends exfiltrated data directly to personal external email account. Email contains ZIP attachment with complete project secrets. This represents the final exfiltration phase before cleanup/covering tracks.
- **Link to Labs:** Lab 3 (Email & Logs) – Parse `mail.mbox` for headers showing email from alex@cloudcore.com to exfil@personal.com with attached project_secrets.zip (2009-12-07 09:45:00 UTC). Verify attachment content matches USB evidence. Correlate email timestamp with USB removal and network exfiltration.
- **Key Findings:**
  - **Sender:** alex@cloudcore.com
  - **Recipient:** exfil@personal.com (personal external account, not company domain)
  - **Subject:** "Project Update" (suspicious subject line for exfiltration)
  - **Attachment:** project_secrets.zip (matches content from USB staging)
  - **Timestamp:** 2009-12-07 09:45:00 UTC
  - **Significance:** Direct evidence of intentional data exfiltration to external address; matches files recovered from USB (project_secrets.txt, etc.). This is the "smoking gun" proving intent to steal data.

### Phase 4: Network Exfiltration Confirmation (2009-12-06, 10:30 AM)
- **Activity:** Network traffic analysis confirms keylogger C2 communication and data exfiltration during the same period as USB staging and email preparation.
- **Link to Labs:** Lab 4 (Network Analysis) – Tshark on `evidence/network.cap` reveals keylogger communication patterns, DNS queries for C2 domains, and data exfiltration timestamps that align with USB file creation/modification times.
- **Key Findings:** Network traffic shows keylogger exfiltrating captured credentials to external server; timestamps overlap with USB staging period; confirms external malware enabled insider data theft.

### Phase 5: Incident Closure and Reporting (Post-2009-12-07)
- **Activity:** Final synthesis of all evidence into comprehensive incident report showing coordinated insider attack enabled by external malware compromise.
- **Link to Labs:** Lab 5 (Final_Report) – Correlate findings from USB_Imaging, Memory_Forensics, Email_Logs, and Network_Analysis into unified timeline and professional incident response report.
- **Key Findings:** Evidence shows keylogger malware enabled credential theft, which facilitated staging of sensitive data on USB, exfiltration via personal email, and network C2 communication - all pointing to intentional data theft by insider with external assistance.

## Visual Timeline Reference
Build your own correlated timeline in Lab 5 (Final_Report) using Plaso — no pre-drawn case-timeline figure ships with the lab. For a diagram of how the forensic environment itself is laid out, see `docs/diagrams/environment.svg`. When you construct your timeline, mark it up along these lines:

- Red: Suspicious actions (deletions, mounts, outbound traffic).
- Blue: Corroborating evidence (timestamps, hashes).
- Green: Chain-of-custody verification points.

## Learning Progression
- **Labs 1-2:** Build foundational skills (disk/memory analysis).
- **Labs 3-4:** Add correlation (logs/email/network).
- **Lab 5:** Synthesize into professional report.

This storyline ensures labs are interconnected: Start with isolated artifacts, end with holistic investigation. Update as needed based on your analysis findings.

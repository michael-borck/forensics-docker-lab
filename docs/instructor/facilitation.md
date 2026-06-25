# Instructor Facilitation Guide

## Overview

This training lab package teaches digital forensic analysis through a realistic incident investigation. Students analyse evidence from the Cloudcore incident (2009) across five independent labs:

- **USB_Imaging**: Disk forensics and file recovery
- **Memory_Forensics**: RAM analysis and process investigation
- **Autopsy_GUI**: Graphical forensic analysis and tool comparison
- **Email_Logs**: Email evidence and timeline correlation
- **Network_Analysis**: Network traffic and C2 detection
- **Final_Report**: Evidence synthesis and reporting

**Total Time**: 8-12 hours depending on depth and student level

## Lab Flexibility

**Labs can be assigned in any order** except Final_Report, which requires findings from the other labs. This allows you to:
- Start with student interests (network forensics? memory analysis?)
- Adapt to available time (some labs take less time than others)
- Incorporate labs into different course modules
- Let students choose their analysis path

Each walkthrough contains cross-references to help students correlate findings regardless of order.

---

## Pre-Course Preparation

### 1. Infrastructure Setup (1-2 hours)
- Follow `setup.md` to build and test the Docker environment
- Verify all evidence files are in place:
  - `evidence/usb.img` or `.E01` (disk image)
  - `evidence/memory.raw` (memory dump)
  - `evidence/network.cap` (PCAP file)
  - `evidence/mail.mbox` (email mailbox)
- Test the forensics workstation script on your platform (macOS/Linux/Windows)

### 2. Evidence Review (1 hour)
- Run through one lab yourself to understand the evidence and findings
- This helps you answer student questions and verify the walkthroughs match your environment

### 3. Student Materials
- Provide students with:
  - This repository (or just the `cases/` folder for walkthroughs)
  - The case scenario: `docs/scenario.md`
  - The investigation narrative: `docs/storyline.md`
- Keep instructor materials (`docs/instructor/`) separate if you prefer

---

## Teaching Tips by Lab

### USB_Imaging Lab
- **Key concept**: File recovery from deleted space, chain of custody
- **Demo point**: Show how deleted files aren't truly gone - data can be recovered
- **Common struggles**:
  - Students unclear on inode numbers vs. file paths
  - FUSE mounting issues on different systems (see troubleshooting.md)
  - Overwhelmed by raw filesystem output
- **Engagement**: Show them `project_secrets.txt` actually exists in recovered files - makes it real

### Memory_Forensics Lab
- **Key concept**: Process trees, network connections, evidence of malware
- **Demo point**: ToolKeylogger.exe process with network libraries - clear indicator of credential theft
- **Common struggles**:
  - Volatility output is dense and technical
  - Difficulty distinguishing suspicious vs. normal processes
  - Understanding memory addresses and pointers
- **Engagement**: Let them discover the keylogger process themselves, explain what each field means

### Autopsy_GUI Lab
- **Key concept**: Automated analysis vs. manual analysis, tool comparison
- **Demo point**: Show how Autopsy automates tasks the Sleuth Kit requires manual scripting for
- **Common struggles**:
  - Long ingest times (patience required)
  - Browser/noVNC connection issues
  - Understanding why GUI and CLI results should match
- **Engagement**: Have them compare specific findings between USB_Imaging CLI and Autopsy GUI - validates methodology

### Email_Logs Lab
- **Key concept**: Timeline correlation, evidence of intent
- **Demo point**: Email to exfil@personal.com shows deliberate theft vs. accident
- **Common struggles**:
  - Email headers are complex (show them what to look for)
  - Finding the "smoking gun" email in potentially large mailbox
  - Understanding SMTP vs. POP3 protocols
- **Engagement**: Have them find the exact timestamp when suspicious activity happened

### Network_Analysis Lab
- **Key concept**: Network evidence of command & control, data exfiltration
- **Demo point**: IRC C2 connections + large data transfers = botnet proof
- **Common struggles**:
  - tshark filters are powerful but confusing
  - Distinguishing legitimate traffic from suspicious
  - Understanding protocol details (ports, handshakes)
- **Engagement**: Build the attack timeline backward from network evidence - when did it start? How long did it last?

### Final_Report Lab
- **Key concept**: Synthesis, correlation, professional reporting
- **Teaching approach**: Make this collaborative
  - Have students share findings from their chosen labs
  - Build the unified timeline together on whiteboard
  - Discuss how evidence from different sources supports or contradicts each other
- **Assessment**: Use rubrics.md for grading

---

## Engagement & Extensions

### Build Student Curiosity
- **Red herrings**: Include some artifacts that seem suspicious but aren't (legitimate process, normal network traffic)
- **Missing evidence**: Point out what we *can't* determine from available evidence (what happened before imaging? encrypted communications?)
- **Timely mystery**: Present the case as a real-time investigation - students are detectives trying to prove the crime

### Extensions for Advanced Students
- Add forensic signatures (YARA rules) to identify malware families
- Perform more detailed memory analysis (kernel structures, injected DLLs)
- Analyse SSL/TLS certificates in network traffic
- Research the real Cloudcore incident (if it inspired this case)
- Design their own incident scenario for peers to investigate

### Tools to Introduce
- Wireshark for interactive PCAP analysis (alternative to tshark)
- Timeline generation (Plaso/log2timeline)
- Hash databases (NIST NSRL) for comparison
- Volatility 3 vs Volatility 2 comparison

---

## Assessment & Grading

- Use `rubrics.md` for structured grading
- Key assessment principle: **Process matters as much as findings**
  - Can another analyst reproduce their steps and get the same results?
  - Did they document assumptions and limitations?
  - Is their reasoning sound even if evidence is incomplete?

- For shorter courses, focus on:
  - Chain of custody (shows understanding of forensic integrity)
  - Evidence correlation (shows ability to synthesize information)
  - Professional documentation (shows communication skills)

- Consider:
  - Individual labs can be graded separately
  - Final_Report brings everything together - weight it appropriately
  - Partial credit for methodology even if findings are incomplete

---

## Troubleshooting

Common student issues are documented in `troubleshooting.md`. For labs-specific issues:

- **Docker problems**: Usually FUSE mounting or permission issues (see troubleshooting.md)
- **Tool not found**: Ensure they're running commands inside the workstation container
- **Hash mismatch**: Expected for some outputs (logs, timestamps vary), expected to match for evidence files
- **"Smoking gun" not found**: Evidence is realistic - not all findings lead to definitive proof. Discuss reasoning with incomplete data

---

## Course Integration Examples

### Option 1: Self-Contained Forensics Module (2-3 weeks)
- Week 1: USB_Imaging lab (theory: filesystems, deleted files)
- Week 2: Memory_Forensics + Network_Analysis labs (theory: memory, malware, network protocols)
- Week 3: Email_Logs + Final_Report (theory: correlation, reporting)

### Option 2: Distributed Throughout Course
- Week 2 (File systems): USB_Imaging lab
- Week 5 (Process analysis): Memory_Forensics lab
- Week 7 (Networks): Network_Analysis lab
- Week 8 (Email/logs): Email_Logs lab
- Week 10 (GUI tools): Autopsy_GUI lab (comparison to CLI)
- Week 12 (Final project): Final_Report (consolidate everything)

### Option 3: Short Version (1-2 weeks)
- Day 1: USB_Imaging + Memory_Forensics labs (basic tools)
- Day 2: Email_Logs + Network_Analysis labs (evidence types)
- Day 3: Final_Report (synthesis)
- Autopsy_GUI lab optional (GUI-based alternative to CLI tools)

---

## Resources for Instructors

- **Walkthroughs**: Each lab has detailed `WALKTHROUGH.md` explaining methodology
- **Case context**: `scenario.md` (incident background), `storyline.md` (what actually happened)
- **Tool references**: `glossary.md` (forensic terms), `troubleshooting.md` (common issues)
- **Grading**: `rubrics.md` (assessment framework)

---

## Student Learning Outcomes

By completing these labs, students will be able to:

1. **Apply forensic methodology**: Chain of custody, evidence integrity, documentation
2. **Use forensic tools**: Both command-line (Sleuth Kit, Volatility, tshark) and GUI (Autopsy)
3. **Analyse evidence**: Recover deleted files, extract artifacts, correlate findings
4. **Reason forensically**: Interpret data, draw conclusions, explain significance
5. **Communicate professionally**: Document findings, create reports suitable for legal proceedings
6. **Adapt to incomplete information**: Reason with partial evidence, acknowledge limitations

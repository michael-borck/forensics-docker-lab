Assessment 2 – Memory & Email Forensics Investigation
Assessment Overview

    Weight: [adjust to your course] (suggested: 25%)
    Due Date: [set per your schedule]
    Submission Type: Individual
    Estimated Time: 10-12 hours (broken into phases: 4-hour guided lab sessions + 6-8 hours independent analysis and reporting)

Assessment Overview

    Weight: [adjust to your course] (suggested: 25%, 25 points)
    Due Date: [set per your schedule]
    Submission Type: Individual
    Estimated Time: 10-12 hours total
        Week 9-10 lab sessions: 4 hours (guided practice)
        Independent work: 6-8 hours (analysis and report writing)

Learning Outcomes

Upon completion of this assessment, students will be able to:
1. Conduct memory forensics analysis using Volatility 2 for Windows XP systems
2. Parse and analyze email evidence for data exfiltration indicators
3. Correlate findings across memory, email, and log sources
4. Document multi-source forensic investigations in a comprehensive report
5. Apply timeline analysis to establish sequence of malicious activities

Investigation Background

📖 This assessment continues the Cloudcore Corporation investigation from Assignment 1.

Quick Summary

Date: December 5-6, 2009
Case Number: CLOUDCORE-2009-INS-002

Following the USB device analysis from Assignment 1, investigators have expanded the scope to include memory capture and communications analysis. The suspect "Alex Doe" was found to have been active on their workstation during the critical period when data exfiltration occurred. IT security captured a memory image of the suspect's Windows XP workstation and obtained email archives showing communications with external parties.

Your Role: As the forensic analyst, you must conduct advanced analysis of volatile memory and email evidence to:
- Identify malicious processes and encryption tools used to conceal data
- Detect email-based data exfiltration attempts
- Correlate memory findings with email timestamps and log entries
- Establish a comprehensive timeline of the insider threat activities

Critical Intelligence: The suspect is believed to have:
- Used TrueCrypt encryption to hide stolen data
- Communicated with external email accounts for data transfer
- Employed anti-forensic techniques including process hiding and file deletion
- Coordinated activities across multiple time periods on December 5-6, 2009

Required Tools

All tools are pre-installed in the Docker forensic environment - see README.md for setup instructions.

Primary Tools (Required)

Memory Forensics Tools:
    Volatility 2 - Windows XP memory analysis:
        vol.py imageinfo - Identify memory profile
        vol.py pslist - List running processes
        vol.py pstree - Show process hierarchy
        vol.py connections - Network connections
        vol.py procdump - Extract process memory

Email & Log Analysis Tools:
    Python script - Custom mbox parsing:
        analyse_emails.py - Extract email headers and attachments
    Standard Unix tools:
        grep - Pattern searching in logs
        strings - Extract text from binary files
        awk/sed - Log parsing and manipulation

Evidence Verification Tools:
    md5sum/sha256sum - Hash verification
    file - File type identification
    hexdump - Binary file examination

Optional Tools

    Autopsy (GUI forensic platform) - Available for verification but not required
    Plaso (log2timeline) - Super timeline creation (can assist with correlation)

Documentation Tools (Your Choice)

    Text editor for report writing (Word, Google Docs, Markdown editor, etc.)
    Screenshot tool for capturing terminal output
    Spreadsheet software for timeline correlation (Excel, Google Sheets, etc.)

Tasks

Task 1: Memory Forensics Analysis (10 points)

Objective: Analyze Windows XP memory image to identify malicious processes and data concealment activities.

1.1 Memory Image Identification and Verification (Required)

    Verify Memory Evidence Integrity
        Calculate MD5 and SHA256 hashes of /evidence/memory.raw
        Document memory image size and acquisition details
        Record current date, time, and your analyst ID as analyst ID

    Identify Memory Profile
        Use Volatility 2 imageinfo to determine the correct Windows profile
        Document the suggested profile(s) and system information
        Note any discrepancies or unusual findings

1.2 Process Analysis (Required)

    Running Process Enumeration
        Use pslist to identify all running processes
        Use pstree to establish process parent-child relationships
        Document suspicious processes (look for encryption tools, hidden processes)
        Note processes with unusual names or unexpected parent processes

    Targeted Process Extraction
        Identify processes of interest (TrueCrypt, keyloggers, unusual executables)
        Use procdump to extract suspicious process executables
        Document PIDs, PPIDs, and process creation times
        Correlate with findings from Assignment 1 (USB analysis)

1.3 Network and Artifact Analysis (Required)

    Network Connection Analysis
        Use connections plugin to identify active network connections
        Document unusual ports, external IP addresses, and connection states
        Look for IRC, HTTP, or file transfer protocols
        Note any connections to external domains or suspicious IPs

    Memory Artifact Extraction
        Extract strings from memory to identify keywords, passwords, or file paths
        Look for evidence of encryption containers, hidden volumes, or staged data
        Document any references to external storage or communication channels

1.4 Documentation Requirements (Critical)

    You must document:
        Every Volatility command executed with full syntax
        Profile identification process and reasoning
        Process analysis findings with PID/PPID relationships
        Network connection details with timestamps
        Any errors encountered and troubleshooting steps

    💡 Hint: Save all outputs to /cases/Memory_Forensics/vol_output/ directory for organization

Task 2: Email and Log Analysis (10 points)

Objective: Analyze email evidence and system logs to identify data exfiltration and correlate with memory findings.

2.1 Email Evidence Processing (Required)

    Email Archive Verification
        Calculate hashes of /evidence/mail.mbox
        Verify file integrity and document archive size
        Use the provided analyse_emails.py script to parse the mailbox

    Suspicious Email Identification
        Extract headers from emails with external recipients
        Look for attachments with suspicious names (.zip, .rar, .7z)
        Identify emails sent to personal domains or unusual addresses
        Document timestamps, subject lines, and recipient information

    Attachment Analysis
        Extract and analyze email attachments
        Look for encrypted files, archives, or proprietary data
        Document attachment names, sizes, and hash values
        Correlate with files identified in Assignment 1

2.2 System Log Correlation (Required)

    Log File Analysis
        Analyze /evidence/logs/ for USB insertion/removal events
        Look for application execution logs matching memory process findings
        Document system events around the critical time periods (Dec 5-6, 2009)

    Timeline Correlation
        Create timeline of events from log entries
        Correlate email timestamps with memory process creation times
        Align USB events with file system activities from Assignment 1
        Document any discrepancies or patterns in the timeline

2.3 Cross-Source Correlation (Required)

    Memory-Email Correlation
        Match processes found in memory with email client activities
        Identify if email-sending processes correspond to memory artifacts
        Document any evidence of automated email sending or bulk operations

    USB-Email-Memory Triangulation
        Correlate USB mount events (from logs) with email sending times
        Match memory process activities with file system changes
        Establish sequence of events across all three evidence sources

2.4 Documentation Requirements (Critical)

    You must document:
        Email parsing commands and script execution
        Log analysis methodology and search patterns
        Correlation process and timeline creation
        Cross-source verification steps
        All findings with timestamps and evidence references

Task 3: Integrated Reporting (5 points)

Objective: Produce a comprehensive forensic report integrating memory, email, and log analysis findings.

Write a professional Investigation Report (800-1000 words total) containing:

Executive Summary (150-200 words)

    Overview of the multi-source investigation
    Key findings from memory, email, and log analysis
    Assessment of data exfiltration likelihood and scope
    Recommended next steps for the investigation

Evidence Analysis Methodology (200-250 words)

    Detailed description of memory forensics process
    Email parsing and log analysis procedures
    Correlation methodology across evidence sources
    Tools used and rationale for analytical choices

Integrated Findings (300-400 words)

    Memory Analysis Results:
        Suspicious processes identified and their purposes
        Network activity and external communications
        Evidence of data concealment or encryption

    Email Analysis Results:
        Suspicious communications identified
        Attachment analysis and data transfer evidence
        Communication patterns and external contacts

    Correlated Timeline:
        Sequence of events across all evidence sources
        Key timestamps and their significance
        Patterns indicating coordinated malicious activity

    Cross-Source Verification:
        How findings from different sources corroborate each other
        Any discrepancies or gaps in the evidence
        Overall confidence level in conclusions

Conclusions and Recommendations (150-200 words)

    Assessment of whether insider threat occurred
    Scope of potential data compromise
    Priority actions for incident response
    Additional analysis needed for complete investigation

AI Usage Reflection (2.5 points) - 100-150 words

    How you utilized AI tools for this multi-source analysis
    Specific prompts or queries for correlation analysis
    Challenges in using AI for timeline creation and cross-source analysis
    Verification process for AI-generated analytical suggestions
    Ethical considerations in AI-assisted forensic investigations

Note: Using AI tools is permitted but you must:
- Document all AI usage transparently
- Verify AI-generated correlations and timelines
- Ensure you understand the analytical reasoning
- Not present AI-generated content as your own analysis without verification

Special Considerations for This Case
Look Specifically For:

Memory Forensics Indicators:
    TrueCrypt or other encryption processes
    Keylogger or monitoring software
    Unusual parent-child process relationships
    Network connections to external IPs
    Evidence of process hiding or injection

Email Exfiltration Indicators:
    Emails to personal or external domains
    Large attachments or encrypted files
    BCC fields or blind copying attempts
    Timing patterns suggesting automated sending
    Correspondence with known external accounts

Timeline Correlation Patterns:
    Process execution preceding email sending
    USB events aligning with file transfers
    Memory artifacts matching email timestamps
    Coordinated activities across multiple time periods

Ethical Note

Remember: This investigation may have serious employment and legal consequences. Report facts objectively, document both inculpatory and exculpatory evidence, and avoid speculation. Your timeline correlation must be based on verifiable evidence.

Submission Requirements
File Structure

Submit a single ZIP file named StudentID_Memory_Email_Forensics.zip containing:

StudentID_Memory_Email_Forensics/
├── chain_of_custody.csv (updated with new evidence)
├── Memory_Forensics/
│   ├── vol_output/
│   │   ├── pslist.txt
│   │   ├── pstree.txt
│   │   ├── connections.txt
│   │   └── process_dumps/
│   └── memory_analysis_notes.txt
├── Email_Logs/
│   ├── email_headers.txt
│   ├── log_extracts.txt
│   ├── correlation_timeline.csv
│   └── email_analysis_notes.txt
├── screenshots/
│   ├── memory_analysis/
│   ├── email_analysis/
│   └── correlation_findings/
└── investigation_report.docx (or .md)

Formatting Guidelines

    Report Format: Professional document with:
        Title page (assignment title, your name, analyst ID, date)
        Table of contents
        Page numbers
        Proper headings and subheadings
        Citations where applicable
    Screenshots: Clear, labeled, and referenced in text
    Timeline: CSV format with consistent timestamp formatting
    File Naming: Consistent and descriptive

Assessment Rubric

Total Points: 25 (adjust weighting to your course)
Task Breakdown
Component 	Points 	Description
Task 1: Memory Forensics 	10.0 	Volatility 2 analysis of Windows XP memory
Task 2: Email & Log Analysis 	10.0 	Email parsing and log correlation
Task 3: Integrated Report 	5.0 	Professional documentation and correlation analysis
TOTAL 	25 	

Detailed Rubric
Task 1: Memory Forensics (10 points)
Criteria 	Excellent (9-10) 	Good (7-8) 	Satisfactory (5-6) 	Needs Improvement (<5)
Profile Identification 	Correct profile identified; detailed system information documented 	Profile identified with minor documentation gaps 	Basic profile identification 	Incorrect profile or missing documentation
Process Analysis 	Comprehensive process enumeration; suspicious processes identified; hierarchy documented 	Good process analysis; most suspicious processes found 	Basic process listing; limited analysis 	Minimal process analysis
Network Analysis 	Complete network connection analysis; external IPs documented; protocols identified 	Good network analysis; most connections documented 	Basic network listing 	Minimal or no network analysis
Documentation 	All commands documented; outputs saved; methodology reproducible 	Most commands documented; adequate outputs 	Some documentation; gaps in methodology 	Poor or missing documentation

Task 2: Email & Log Analysis (10 points)
Criteria 	Excellent (9-10) 	Good (7-8) 	Satisfactory (5-6) 	Needs Improvement (<5)
Email Parsing 	Comprehensive email analysis; suspicious emails identified; attachments analyzed 	Good email analysis; most suspicious emails found 	Basic email parsing; limited analysis 	Minimal email analysis
Log Analysis 	Thorough log analysis; USB events identified; timeline created 	Good log analysis; most events found 	Basic log parsing 	Minimal log analysis
Correlation 	Excellent cross-source correlation; timeline integrated; patterns identified 	Good correlation; some patterns identified 	Basic correlation attempted 	Minimal or no correlation
Documentation 	All findings documented; methodology clear; verification steps shown 	Most findings documented; adequate methodology 	Some documentation; gaps in process 	Poor or missing documentation

Task 3: Integrated Report (5 points)
Criteria 	Excellent (4.5-5.0) 	Good (3.5-4.0) 	Satisfactory (2.5-3.0) 	Needs Improvement (<2.5)
Structure & Integration 	Professional format; excellent integration of all evidence sources; clear correlations 	Good structure; adequate integration 	Basic structure; limited integration 	Disorganized; poor integration
Analysis Quality 	Insightful analysis; strong correlation; objective findings 	Good analysis; some correlation 	Basic analysis; limited correlation 	Superficial or poor analysis
Timeline & Correlation 	Comprehensive timeline; excellent cross-source verification; clear patterns 	Good timeline; adequate correlation 	Basic timeline; limited correlation 	Minimal or incorrect timeline
Writing Quality 	Professional writing; clear technical explanations; no errors 	Good writing; minor errors; mostly clear 	Adequate writing; several errors 	Poor writing; unclear

Academic Integrity

    All work must be your own
    AI tools may be used for assistance but must be documented
    Direct copying of AI-generated content without attribution is plagiarism
    Collaboration with peers is not permitted for this individual assessment

Support Resources
Reference Materials (in this package)

    STORYLINE.md: Complete case background and investigation context
    COMMANDS.md: Quick reference for forensic commands
    Lab directories: Detailed walkthroughs and templates
    docker-compose.yml: Container configurations for all tools

Getting Help

    Week 9-10 Lab Sessions: Hands-on guidance with memory and email analysis
    Support availability: [Insert your support availability]
    Discussion Forum: course forum for technical questions
    Docker Issues: See README.md troubleshooting section

External Resources

    Volatility Framework Documentation: https://volatility-labs.blogspot.com/
    Email Header Analysis: https://tools.ietf.org/html/rfc5322
    Digital Forensics Timeline Analysis: https://dfir.science/

Common Pitfalls to Avoid
Technical Mistakes

    ❌ Using Volatility 3 commands on Windows XP memory (requires Volatility 2)
    ❌ Not identifying the correct memory profile before analysis
    ❌ Failing to document process PIDs and parent-child relationships
    ❌ Not saving memory dumps and command outputs to /cases/ directory
    ❌ Ignoring deleted or hidden processes in memory analysis
    ❌ Not verifying email archive integrity before parsing

Analysis Mistakes

    ❌ Not correlating timestamps across memory, email, and log sources
    ❌ Ignoring exculpatory evidence in email communications
    ❌ Making assumptions about process purposes without verification
    ❌ Not documenting discrepancies between evidence sources
    ❌ Failing to establish clear timeline of events

Reporting Mistakes

    ❌ Not integrating findings from all evidence sources
    ❌ Presenting correlations without supporting evidence
    ❌ Making conclusions about intent rather than reporting facts
    ❌ Not documenting the correlation methodology
    ❌ Missing screenshots of key analytical findings

Late Submission Policy

    5% penalty per day late
    Maximum 5 days late accepted
    Extensions must be requested 48 hours before due date with valid documentation

Remember: This is a complex multi-source investigation requiring attention to detail and analytical rigor. Your professional approach to correlation and timeline analysis is critical for establishing the facts of this case.
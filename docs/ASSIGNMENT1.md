Assessment 1 – USB Evidence Triage Report
Assessment Overview

    Weight: [adjust to your course] (suggested: 20%)
    Due Date: [set per your schedule]
    Submission Type: Individual
    Estimated Time: 8-10 hours (broken into phases: 3-hour guided lab walk-through + 5-7 hours independent analysis and reporting)

Assessment Overview

    Weight: [adjust to your course] (suggested: 20%, 20 points)
    Due Date: [set per your schedule]
    Submission Type: Individual
    Estimated Time: 8-10 hours total
        Week 7 lab session: 3 hours (guided practice)
        Independent work: 5-7 hours (analysis and report writing)

Learning Outcomes

Upon completion of this assessment, students will be able to: 1. Apply proper digital evidence handling procedures following forensic best practices (ISO 27037, ACPO principles) 2. Utilize command-line forensic tools for evidence examination and file recovery 3. Document forensic findings in a professional, reproducible manner suitable for legal proceedings 4. Critically reflect on the role of AI tools in digital forensics practice
Investigation Background

📖 For complete case details, read SCENARIO.md in this package.
Quick Summary

Date: December 7, 2009 Case Number: CLOUDCORE-2009-INS-001

Cloudcore Corporation’s Data Loss Prevention (DLP) system detected anomalous data transfer patterns over the past month. Security footage revealed an employee accessing multiple workstations outside of normal business hours. During a consensual search of the employee’s workspace, a concealed USB device was discovered.

Your Role: As the junior forensic analyst, you must conduct an initial triage examination of this USB device to determine: - What data is present on the device - What files have been deleted - Whether client data was exfiltrated - Timeline of device usage

Critical Intelligence: The suspect had authorized access to: - Client database exports (CSV format) - Financial reports (PDF/DOCX) - Proprietary source code - Internal email archives
Required Tools

All tools are pre-installed in the Docker forensic environment - see README.md for setup instructions.
Primary Tools (Required)

    The Sleuth Kit - Command-line forensic analysis tools:
        fls - List files and directories
        icat - Extract file contents by inode
        tsk_recover - Batch file recovery
        fsstat - File system information
        istat - File metadata examination
    libewf-tools - Expert Witness Format (E01) handling:
        ewfverify - Verify E01 integrity
        ewfmount - Mount E01 files for analysis
        ewfinfo - Display E01 metadata
    Hash tools - Evidence verification:
        md5sum - MD5 hash calculation
        sha256sum - SHA256 hash calculation

Optional Tools

    Autopsy (GUI forensic platform) - Can be enabled in docker-compose.yml if you have:
        At least 8GB RAM available
        Comfortable with VNC browser interface
        Preference for graphical analysis
        Note: All assignment tasks can be completed using CLI tools alone; Autopsy is provided for students who want GUI-based verification but is NOT required.

Documentation Tools (Your Choice)

    Text editor for report writing (Word, Google Docs, Markdown editor, etc.)
    Screenshot tool for capturing terminal output
    Spreadsheet software for Chain of Custody forms (Excel, Google Sheets, etc.)

Tasks
Task 1: Evidence Handling and Chain of Custody (2.5 points)

Objective: Establish proper evidence handling procedures and verify integrity.

    Verify Evidence Integrity
        Calculate MD5 hash of /evidence/cloudcore_suspect_usb.E01
        Calculate SHA256 hash of /evidence/cloudcore_suspect_usb.E01
        Verify E01 internal integrity using ewfverify
        Document current date, time, and your analyst ID as analyst ID
    Create Chain of Custody Documentation
        Create a properly formatted chain_of_custody.csv file with these fields:
            Evidence_ID (create unique identifier, e.g., EVIDENCE-2009-001)
            Date_Received (use December 7, 2009)
            Time_Received (use 08:30 AM)
            Received_From (use “Cloudcore Security Team”)
            MD5_Hash (your calculated value)
            SHA256_Hash (your calculated value)
            Analyst_Name (your name)
            Analyst_ID (your analyst ID)
            Case_Number (CLOUDCORE-2009-INS-001)
            Evidence_Description (brief description of USB device)
            Storage_Location (use “/evidence - read-only archive”)
            Verification_Status (result of ewfverify)

💡 Hint: See COMMANDS.md for hash calculation and verification commands.
Task 2: Forensic Analysis (10 points)

Objective: Conduct comprehensive file system analysis to identify evidence of data exfiltration.
2.1 Evidence Mounting and File System Information (Required)

    Mount the E01 Evidence File

    First, enter the forensic workstation: docker compose run --rm dfir

    Then run these commands inside the workstation:

    mkdir -p /tmp/ewf
    ewfmount /evidence/cloudcore_suspect_usb.E01 /tmp/ewf

Extract File System Information

# Get file system details
fsstat /tmp/ewf/ewf1 > /cases/filesystem_info.txt

# Display partition information (if multi-partition)
mmls /tmp/ewf/ewf1 > /cases/partition_info.txt

2.2 File Listing and Timeline Creation (Required)

    Generate Complete File Listing

    # List ALL files including deleted (look for * marker)
    fls -r -d /tmp/ewf/ewf1 > /cases/file_list.txt

    # Create machine-readable timeline
    fls -r -d -m / /tmp/ewf/ewf1 > /cases/filesystem_timeline.csv

    Analyze the File List
        Identify total number of files (active and deleted)
        Note suspicious filenames (client, confidential, database, etc.)
        Identify deleted files (marked with * in output)
        Look for archive files (.zip, .7z, .tar, .rar)
        Find database exports (.csv, .sql, .xlsx)

2.3 File Recovery (Required)

    Bulk Recovery

    # Create recovery directory
    mkdir -p /cases/recovered

    # Recover all files (including deleted)
    tsk_recover /tmp/ewf/ewf1 /cases/recovered

Targeted Recovery of Key Files

    Identify files of interest from your file listing
    Use icat to extract specific files by inode:

# Example: icat /tmp/ewf/ewf1 [inode-number] > /cases/specific_file.ext

    Organize Recovered Files
        Separate deleted files from active files
        Categorize by file type (documents, databases, archives, etc.)
        Create subdirectories in /cases/recovered/ for organization

2.4 Content Analysis (Required)

    Keyword Search Search for the following keywords (case-insensitive):
        “confidential”
        “password” or “credential”
        “cloudcore”
        “client” or “customer”
        “database” or “export”

    # Example keyword search
    strings /tmp/ewf/ewf1 | grep -iE "client|confidential|password" > /cases/keyword_hits.txt

    Document Keyword Hits
        Record which files contain sensitive keywords
        Note context of keyword usage
        Screenshot or save examples of concerning content

2.5 Optional: GUI Verification with Autopsy

Note: This is completely optional. CLI analysis is sufficient for full marks.

If you want to verify findings with a GUI: 1. Uncomment autopsy service in docker-compose.yml 2. Run docker compose up -d 3. Access Autopsy at http://localhost:8080/vnc.html 4. Import E01 file and compare findings

This is provided for learning purposes only and provides no grade advantage.
2.6 Documentation Requirements (Critical)

You must document: - Every command you executed (copy-paste from terminal) - Purpose of each command - Key findings from each step - Screenshots of significant terminal output - Any unexpected results or errors encountered

💡 Hint: Keep a log file as you work:

# Save command history
history > /cases/command_log.txt

Task 3: Reporting (5 points)

Objective: Produce a professional forensic triage report suitable for management review and potential legal proceedings.

Write a professional Triage Report (600-800 words total) containing:
Executive Summary (100-150 words)

    Brief overview of the investigation
    Key findings summary
    Recommended next steps

Evidence Handling Procedures (100-150 words)

    Chain of custody details
    Hash verification results
    Evidence preservation methods employed

Methodology (150-200 words)

    Tools and versions used
    Step-by-step procedures
    Commands executed (with explanations)
    Rationale for chosen approaches

Findings and Analysis (200-250 words)

    Detailed findings organized by category:
        Active files of interest
        Deleted/recovered files
        Keyword search results
        Timeline patterns
    Include relevant screenshots and file listings
    Highlight potentially significant evidence
    Note both inculpatory and exculpatory findings

Recommendations (50 words)

    Priority items for further investigation
    Additional analysis techniques to consider

AI Usage Reflection (2.5 points) - 100-150 words

    How you utilized AI tools during this assessment (e.g., Claude Code, ChatGPT, etc.)
    Specific prompts or queries you found most effective
    Limitations or challenges encountered with AI assistance
    Ethical considerations when using AI in forensic investigations
    How you verified AI-generated suggestions before using them

Note: Using AI tools is permitted and encouraged for learning, but you must: - Document your AI usage transparently - Verify all AI-generated commands before execution - Ensure you understand what each command does - Not copy-paste AI responses directly into your report without understanding
Special Considerations for This Case
Look Specifically For:

    Client Data Indicators:
        Files containing “client_list”, “customer_database”
        CSV exports with suspicious names
        Large numbers of records in structured formats
    Exfiltration Preparation:
        Archive files (evidence of data packaging)
        Script files (.bat, .ps1, .sh, .py)
        Encryption tools or encrypted files
    Timeline Analysis:
        Clustering of file deletions
        After-hours timestamps
        Rapid file creation/deletion patterns

Ethical Note

Remember: Your analysis may be used in legal proceedings that could affect someone’s career and liberty. Report facts objectively, avoid speculation, and document both inculpatory and exculpatory evidence equally.
Submission Requirements
File Structure

Submit a single ZIP file named StudentID_USB_Triage.zip containing:

StudentID_USB_Triage/
├── chain_of_custody.csv
├── recovered/
│   ├── deleted_files/
│   └── files_of_interest/
├── screenshots/
│   ├── autopsy_findings/
│   └── terminal_output/
└── triage_report.docx (or .md)

Formatting Guidelines

    Report Format: Professional document with:
        Title page (assignment title, your name, analyst ID, date)
        Table of contents
        Page numbers
        Proper headings and subheadings
        Citations where applicable
    Screenshots: Clear, labeled, and referenced in text
    File Naming: Consistent and descriptive

Assessment Rubric

Total Points: 20 (adjust weighting to your course)
Task Breakdown
Component 	Points 	Description
Task 1: Chain of Custody 	2.5 	Evidence handling and integrity verification
Task 2: Forensic Analysis 	10.0 	File system analysis and recovery
Task 3: Report Quality 	5.0 	Professional documentation and presentation
Task 4: AI Reflection 	2.5 	Critical reflection on AI tool usage
TOTAL 	20 	
Detailed Rubric
Task 1: Chain of Custody Documentation (2.5 points)
Criteria 	Excellent (2.5) 	Good (2.0) 	Satisfactory (1.5) 	Needs Improvement (<1.5)
Hash Verification 	Both MD5 and SHA256 calculated correctly; ewfverify completed successfully; all values documented 	Both hashes present; minor documentation issues 	Only one hash type provided; verification incomplete 	Hashes missing or incorrect
CoC Form 	All required fields complete and accurate; professional formatting 	Most fields complete; 1-2 minor omissions 	Basic information present; several fields missing 	Incomplete or disorganized
Task 2: Forensic Analysis (10 points)
Criteria 	Excellent (9-10) 	Good (7-8) 	Satisfactory (5-6) 	Needs Improvement (<5)
File System Analysis 	Complete file listing with deleted files identified; timeline created; file system info extracted 	Most files listed; timeline attempted; some analysis gaps 	Basic file listing; minimal timeline work 	Incomplete file listing; no timeline
File Recovery 	All deleted files recovered; organized by category; key files specifically extracted 	Most deleted files recovered; basic organization 	Some files recovered; disorganized 	Minimal recovery attempted
Keyword Search 	Comprehensive keyword search; all required terms; results documented with context 	Most keywords searched; adequate documentation 	Basic keyword search; limited documentation 	Minimal or no keyword search
Command Documentation 	Every command logged with purpose and results; reproducible methodology 	Most commands documented; mostly reproducible 	Some commands documented; gaps in methodology 	Poor or missing documentation
Task 3: Report Quality (5 points)
Criteria 	Excellent (4.5-5.0) 	Good (3.5-4.0) 	Satisfactory (2.5-3.0) 	Needs Improvement (<2.5)
Structure & Clarity 	Professional format; clear sections; proper headings; page numbers; table of contents 	Good structure; minor formatting issues 	Basic structure; several formatting problems 	Disorganized; unprofessional
Methodology 	Detailed step-by-step procedures; every command explained; rationale provided 	Most procedures documented; some explanation gaps 	Basic procedures mentioned; limited explanation 	Unclear or missing methodology
Findings 	Comprehensive findings; both inculpatory and exculpatory evidence; well-organized; screenshots referenced 	Good findings; mostly organized; some evidence types missing 	Basic findings; disorganized; minimal evidence 	Incomplete or poorly documented
Writing Quality 	Clear, concise, professional language; no errors; appropriate technical terminology 	Good writing; minor errors; mostly professional 	Adequate writing; several errors; some clarity issues 	Poor writing; many errors; unclear
Task 4: AI Usage Reflection (2.5 points)
Criteria 	Excellent (2.5) 	Good (2.0) 	Satisfactory (1.5) 	Needs Improvement (<1.5)
Specificity 	Concrete examples of AI usage; specific prompts shared; detailed description of process 	Good examples; some specific details 	Generic description; few specifics 	Vague or missing
Critical Analysis 	Thoughtful analysis of limitations; ethical considerations discussed; verification process explained 	Some analysis of limitations; ethics mentioned 	Basic reflection; minimal critical thought 	Superficial or absent
Honesty 	Transparent about AI usage; acknowledges both benefits and challenges 	Mostly transparent; acknowledges some challenges 	Basic acknowledgment 	Unclear or potentially dishonest
Academic Integrity

    All work must be your own
    AI tools may be used for assistance but must be documented
    Direct copying of AI-generated content without attribution is plagiarism
    Collaboration with peers is not permitted for this individual assessment

Support Resources
Reference Materials (in this package)

    SCENARIO.md: Complete case background and investigation context
    COMMANDS.md: Quick reference for all forensic commands
    BACKGROUND.md: Quick summary and navigation guide
    guides/worksheet.html: Interactive lab worksheet (open in browser)
    guides/chain-custody-guide.html: Chain of custody form guide
    guides/forensic-image-primer.html: E01 format explanation
    templates/WORKBOOK.md: Report template to get you started

Getting Help

    Week 7 Lab Session: Hands-on guidance and troubleshooting
    Support availability: [Insert your support availability]
    Discussion Forum: course forum for technical questions
    Docker Issues: See README.md troubleshooting section

External Resources

    Sleuth Kit Documentation: https://sleuthkit.org/sleuthkit/docs.php
    DFIR Science Tutorials: https://dfir.science/
    NIST Computer Forensics Tool Testing: https://www.nist.gov/itl/ssd/software-quality-group/computer-forensics-tool-testing-program-cftt

Common Pitfalls to Avoid
Technical Mistakes

    ❌ Not using ewfmount before running Sleuth Kit commands
    ❌ Failing to verify E01 integrity with ewfverify
    ❌ Forgetting to use /tmp/ewf/ewf1 path after mounting (not the .E01 file directly)
    ❌ Modifying original evidence files (work in /cases/ only)
    ❌ Not saving outputs to /cases/ directory
    ❌ Running forensic commands on your laptop instead of inside the forensic workstation (use docker compose run --rm dfir first)

Analysis Mistakes

    ❌ Not including deleted files in analysis (forgetting -d flag)
    ❌ Ignoring exculpatory evidence (only reporting incriminating findings)
    ❌ Over-reliance on single tool without verification
    ❌ Not organizing recovered files by category
    ❌ Failing to document unexpected results or errors

Reporting Mistakes

    ❌ Making accusations instead of presenting objective facts
    ❌ Not documenting every command executed
    ❌ Missing screenshots of significant findings
    ❌ Reporting AI-generated content without verification
    ❌ Using non-professional language or speculation
    ❌ Exceeding or falling short of word count significantly

Late Submission Policy

    5% penalty per day late
    Maximum 5 days late accepted
    Extensions must be requested 48 hours before due date with valid documentation

Remember: This is a real case scenario. Your professionalism and attention to detail matter.


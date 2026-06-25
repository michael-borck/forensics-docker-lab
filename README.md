# Digital Forensics & Incident Response Laboratory
## Complete 6-Lab Course on the Cloudcore 2009 Incident

---

## 🎯 Course Overview

This is a comprehensive hands-on digital forensics course where you will conduct a real-world style investigation of a data exfiltration incident at Cloudcore Inc. You'll work through 6 progressive labs using professional forensic tools in a containerized environment to analyze evidence, recover deleted files, perform memory analysis, and produce professional incident response reports.

**Case:** CLOUDCORE-2009-INS-001 - Data Exfiltration Investigation
**Environment:** Docker-based forensic workstation
**Tools:** Sleuth Kit, Volatility, Autopsy GUI, Plaso, YARA, and more
**Duration:** 6 progressive labs (one per week, ~8-10 hours each)

---

## 📚 The 6 Labs

| Lab | Title | Skills | Key Tools |
|-----|-------|--------|-----------|
| **1** | **USB_Imaging** | Evidence handling, initial triage, deleted file recovery | Sleuth Kit, foremost, exiftool |
| **2** | **Memory_Forensics** | Volatile memory analysis, process investigation | Volatility 2 (Windows XP) |
| **3** | **Autopsy_GUI** | Graphical forensic investigation, case management | Autopsy, noVNC |
| **4** | **Email_Logs** | Email artifact analysis, log examination | Python analysis, grep/awk |
| **5** | **Network_Analysis** | Network traffic analysis, C2 detection, exfiltration | Wireshark, tshark, PCAP analysis |
| **6** | **Final_Report** | Synthesis, timeline construction, professional reporting | All tools + reporting skills |

---

## 📦 What's in This Package?

```
forensics-docker-lab/
├── README.md                           ← You are here (course overview)
├── docs/
│   ├── README.md                       ← Student documentation index (START HERE)
│   ├── SCENARIO.md                     ← Complete case background and context
│   ├── SETUP.md                        ← Installation and Docker setup guide
│   ├── COMMANDS.md                     ← Forensic commands quick reference
│   ├── QUICK_REFERENCE.md              ← Command syntax for all labs
│   ├── CHEATSHEET.md                   ← Quick reference (inside workstation)
│   ├── STORYLINE.md                    ← Investigation timeline and narrative
│   ├── GLOSSARY.md                     ← Forensics terminology
│   ├── TROUBLESHOOTING.md              ← Common issues and solutions
│   ├── COURSE_MAPPING.md               ← How labs fit into curriculum
│   └── instructor/                     ← Instructor materials (on instructor branch)
│
├── cases/                              ← YOUR WORKSPACE (6 lab folders)
│   ├── USB_Imaging/                    ← Lab 1: Imaging, integrity & initial triage
│   ├── Memory_Forensics/               ← Lab 2: Memory analysis with Volatility
│   ├── Autopsy_GUI/                    ← Lab 3: Graphical forensic examination
│   ├── Email_Logs/                     ← Lab 4: Email artifact analysis
│   ├── Network_Analysis/               ← Lab 5: Network traffic and C2 detection
│   └── Final_Report/                   ← Lab 6: Synthesis and final reporting
│
├── evidence/                           ← READ-ONLY evidence files
│   ├── usb.img / usb.E01              ← USB device forensic image (~800MB)
│   ├── memory.raw                      ← Windows XP memory dump (~511MB)
│   └── network.cap                     ← Network traffic capture (~100MB)
│
├── templates/                          ← Student report templates
│   ├── WORKBOOK.md                     ← Report template (copy to each lab)
│   ├── chain_of_custody.csv            ← CoC log template
│   ├── analysis_log.csv                ← Analysis tracking template
│   └── timeline.csv                    ← Timeline template
│
├── guides/                             ← Interactive guides (HTML)
│   ├── worksheet.html                  ← Lab 1 guided walkthrough
│   ├── chain-custody-guide.html        ← Chain of custody reference
│   └── forensic-image-primer.html      ← E01 format overview
│
├── rules/                              ← YARA malware detection rules
│   └── README.md                       ← How to use YARA rules
│
├── scripts/
│   ├── forensics-workstation           ← Immersive login script (bash)
│   ├── forensics-workstation.ps1       ← Immersive login script (PowerShell)
│   ├── coc-log                         ← Chain of custody logging utility
│   ├── verify_setup.sh                 ← Setup verification (bash)
│   ├── verify_setup.ps1                ← Setup verification (PowerShell)
│   ├── legacy/                         ← Old scripts (for reference)
│   └── instructor/                     ← Instructor-only tools (on instructor branch)
│
├── images/
│   ├── dfir-cli/                       ← Main forensic workstation container
│   └── volatility2/                    ← Windows XP memory analysis (vol2)
│
├── docker-compose.yml                  ← Container orchestration
└── LICENSE
```

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Prerequisites

**Install Docker Desktop:**
- **Windows/Mac:** Download from https://www.docker.com/products/docker-desktop
- **Linux (Ubuntu/Debian):**
  ```bash
  sudo apt update
  sudo apt install docker.io docker-compose
  sudo usermod -aG docker $USER
  # Log out and back in for group changes to take effect
  ```

**Verify Installation:**
```bash
docker --version
docker compose version
```

**System Requirements:**
- 4GB RAM minimum (8GB+ recommended for Autopsy GUI)
- 15GB free disk space (for all evidence files)
- Internet connection (first build only)

### Step 2: Build the Forensic Environment

```bash
# Navigate to this directory
cd /path/to/forensics-docker-lab

# Build the main container (first time: ~2-5 minutes)
docker compose build

# Verify build succeeded
docker compose run --rm dfir echo "Environment ready!"
```

You should see the forensic lab banner!

### Step 3: Verify Your Setup (Recommended)

**Windows (PowerShell):**
```powershell
.\scripts\verify_setup.ps1
```

**macOS/Linux:**
```bash
./scripts/verify_setup.sh
```

All checks should pass (✓ in green).

### Step 4: Enter the Immersive Forensic Workstation

**Mac/Linux/Windows WSL:**
```bash
./scripts/forensics-workstation
```

**Windows (Command Prompt or PowerShell):**
```batch
scripts\forensics-workstation.bat
```

> **Note:** Pure batch file - no PowerShell required, works everywhere on Windows.

You'll be prompted for your analyst name, then you're inside:
```
╔═════════════════════════════════════════════════════════════════╗
║                                                                 ║
║     DIGITAL FORENSICS & INCIDENT RESPONSE LABORATORY           ║
║                                                                 ║
║           Cloudcore 2009 Data Exfiltration Investigation       ║
║                                                                 ║
╚═════════════════════════════════════════════════════════════════╝

alice@forensics-lab:/cases$
```

**Now run forensic commands directly** (no `docker compose` prefix!):
```bash
# Example: List evidence files
ls -la /evidence/

# Example: Verify USB image integrity
sha256sum /evidence/usb.E01

# Example: Start Lab 1 analysis
mkdir -p USB_Imaging/output
cd USB_Imaging
fls -r /evidence/usb.img > output/fls.txt

# When done
exit
```

---

## 📖 How to Use This Lab

### First Time? Start Here:

1. **Read the Course Overview** (this page - 10 min)
2. **Review `docs/README.md`** - Student documentation index (10 min)
3. **Read `docs/SCENARIO.md`** - Complete case background (20 min)
4. **Build Docker environment** - Step 2 above (5 min)
5. **Verify setup** - Step 3 above (5 min)
6. **Enter workstation** - Step 4 above (1 min)

### For Each Lab:

1. **Read the lab README** - e.g., `cases/USB_Imaging/README.md`
2. **Review the walkthrough** - e.g., `cases/USB_Imaging/WALKTHROUGH.md`
3. **Enter the workstation** - `./scripts/forensics-workstation`
4. **Run analysis commands** - Use `docs/COMMANDS.md` as reference
5. **Fill the report** - Copy `templates/WORKBOOK.md` to your lab folder
6. **Log your actions** - Use `coc-log` for chain of custody

### Quick Reference:

- **Quick cheatsheet** → See `docs/CHEATSHEET.md` (tools, commands for each lab)
- **Need a command?** → See `docs/COMMANDS.md`
- **Stuck on a lab?** → See that lab's `WALKTHROUGH.md`
- **Want to understand the case?** → See `docs/SCENARIO.md`
- **Terminology confused?** → See `docs/GLOSSARY.md`

---

## 🔑 Key Features

### ✅ Immersive Forensic Workstation

Instead of typing `docker compose run --rm dfir` every time, use:
```bash
./scripts/forensics-workstation
```

**Benefits:**
- 🎯 Feels like connecting to a real DFIR workstation
- 📝 Your analyst name is logged in chain of custody
- ⚡ Less typing = faster workflow
- 🏢 Matches real-world incident response practice

### ✅ Automatic Chain of Custody Logging

The `coc-log` utility automatically timestamps and hashes all commands:
```bash
coc-log "fls -r /evidence/usb.img" "Initial filesystem analysis"
```

Results are logged to `cases/analysis_log.csv` with:
- Timestamp (UTC)
- Analyst name
- Command executed
- Exit code
- Output hash (SHA256)
- File size
- Your notes

### ✅ Complete Evidence Package

All evidence files are included:
- **usb.img / usb.E01** - USB device forensic image (800MB)
- **memory.raw** - Windows XP memory dump (511MB)
- **network.cap** - Network traffic capture (100MB)

Read-only to prevent accidental modification. All analysis happens in writable `./cases/` folders.

### ✅ Multi-Platform Support

- **Windows:** PowerShell scripts with Docker Desktop + WSL 2
- **macOS:** Intel and Apple Silicon (M1/M2/M3) support
- **Linux:** Ubuntu, Debian, Fedora, etc.

---

## 🖥️ Platform-Specific Notes

### Windows Users

**Terminal:** Use Windows Terminal with PowerShell (recommended)

**Docker Desktop Setup:**
- Enable WSL 2 backend (default)
- Allocate 4GB+ RAM in Docker Desktop settings
- Ensure Docker Desktop is running

**Commands:**
```powershell
# Use PowerShell scripts for Windows:
.\scripts\verify_setup.ps1
.\scripts\forensics-workstation.ps1

# Docker commands work the same:
docker compose build
docker compose run --rm dfir
```

**Common Issues:**
- "Command not found": Restart Docker Desktop and PowerShell
- Execution policy error: Run as Administrator:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

### macOS Users (Intel and Apple Silicon)

**Terminal:** Use built-in Terminal or iTerm2

**Apple Silicon (M1/M2/M3):**
- Docker uses Rosetta 2 (automatic translation)
- Performance is excellent
- First build may take 5-7 minutes

**Commands:**
```bash
./scripts/verify_setup.sh
./scripts/forensics-workstation
```

### Linux Users (Ubuntu/Debian/Fedora)

**Docker Group Setup (one-time):**
```bash
sudo usermod -aG docker $USER
# Log out and back in
groups | grep docker  # verify
```

**Commands:**
```bash
./scripts/verify_setup.sh
./scripts/forensics-workstation
```

---

## 💡 Essential Commands

### Starting Your Forensic Session

**Mac/Linux/WSL:**
```bash
# Enter the immersive workstation (RECOMMENDED)
./scripts/forensics-workstation

# Or use Docker directly (for advanced users)
docker compose run --rm -it dfir bash
```

**Windows:**
```batch
REM Enter the immersive workstation (RECOMMENDED)
scripts\forensics-workstation.bat

REM Or use Docker directly (for advanced users)
docker compose run --rm -it dfir bash
```

(Pure batch file - no PowerShell required)

### Inside the Workstation

```bash
# Lab 1: Analyze the USB image
mkdir -p USB_Imaging/output
fls -r /evidence/usb.img > USB_Imaging/output/fls.txt

# Lab 2: Memory analysis (run on host, not inside workstation)
docker compose exec vol2 vol.py -f /evidence/memory.raw imageinfo

# Lab 5: Network analysis (run on host, not inside workstation)
tshark -r evidence/network.cap -Y "irc"

# Always exit when done
exit
```

### Chain of Custody

**Log commands for evidence handling:**
```bash
# Inside workstation
coc-log "fls -r /evidence/usb.img" "Lab 1 filesystem listing"

# This creates: cases/analysis_log.csv with timestamp, hash, analyst name
```

**See complete reference:** `docs/COMMANDS.md`

---

## 📁 Workspace Organization

### Evidence Directory (`./evidence/`)

**READ-ONLY** - Never modify:
- `usb.img` / `usb.E01` - USB device image
- `memory.raw` - Memory dump
- `network.cap` - Network capture

Mounted inside container as `/evidence`

### Cases Directory (`./cases/`)

**WRITABLE** - Save all your work:
- Mounted inside container as `/cases`
- Everything you create in `/cases/` appears in `./cases/` on your host
- One folder per lab (USB_Imaging, Memory_Forensics, etc.)

**Example structure:**
```
./cases/
├── USB_Imaging/
│   ├── README.md          ← Lab 1 instructions
│   ├── WALKTHROUGH.md     ← Step-by-step guide
│   ├── output/            ← Your analysis outputs
│   ├── recovered/         ← Recovered files
│   └── report.md          ← Your report (copy from templates/WORKBOOK.md)
├── Memory_Forensics/
│   ├── README.md
│   ├── WALKTHROUGH.md
│   ├── vol_output/
│   └── report.md
└── [etc for other labs...]
```

---

## 🔧 Troubleshooting

### "Docker command not found"

**Fix:**
- Ensure Docker Desktop is running (Windows/Mac)
- Restart terminal after installing Docker
- Linux: `sudo systemctl start docker`

### "Cannot connect to Docker daemon"

**Fix:**
- **Windows/Mac:** Start Docker Desktop application
- **Linux:** `sudo systemctl start docker`

### "Permission denied" on /evidence

**This is expected!** Evidence is read-only.
- ✅ Correct: `fls -r /evidence/usb.img > /cases/output.txt`
- ❌ Wrong: `fls -r /evidence/usb.img > /evidence/output.txt`

### "Build failed" or "Container won't start"

**Fix:**
```bash
docker compose down -v
docker compose build --no-cache
```

### "Port 8080 already in use" (if using Autopsy)

**Fix:** Edit `docker-compose.yml` and change `8080:8080` to `8081:8080`

### Getting More Help

- **Lab Session:** Ask instructor or TAs
- **Support availability:** See course syllabus for times
- **course forum:** Post technical questions
- **Documentation:** Review `docs/COMMANDS.md`, `docs/SCENARIO.md`, lab WALKTHROUGH.md

See **`docs/TROUBLESHOOTING.md`** for more detailed troubleshooting.

---

## 🧠 Learning Objectives

By completing all 6 labs, you will:

1. ✅ Understand proper digital evidence handling (chain of custody, hashing, integrity verification)
2. ✅ Master industry-standard forensic tools (Sleuth Kit, Volatility, Autopsy, Wireshark)
3. ✅ Analyze multiple evidence types (disk images, memory dumps, network captures, logs)
4. ✅ Perform deleted file recovery and carving
5. ✅ Conduct memory forensics on legacy Windows systems
6. ✅ Identify and analyze command & control communications
7. ✅ Construct timelines and correlate events across multiple data sources
8. ✅ Write professional incident response reports
9. ✅ Understand real-world incident response workflow
10. ✅ Critically reflect on AI tool usage in forensic investigations

---

## 📝 Next Steps

### Today:

1. ✅ Read this README (you're doing it!)
2. → Read `docs/README.md` for documentation index
3. → Read `docs/SCENARIO.md` for case background
4. → Build Docker environment (Quick Start above)

### This Week (Lab 1):

1. → Read `cases/USB_Imaging/README.md`
2. → Follow `cases/USB_Imaging/WALKTHROUGH.md`
3. → Use `docs/COMMANDS.md` for command reference
4. → Complete Lab 1 analysis and report

### Coming Up:

- Week 2: Memory_Forensics (Volatility)
- Week 3: Autopsy_GUI (graphical analysis)
- Week 4: Email_Logs (log analysis)
- Week 5: Network_Analysis (PCAP analysis)
- Week 6: Final_Report (synthesis + reporting)

---

## 🎓 Course Materials

**For Students (main branch):**
- `docs/README.md` - Documentation index
- `docs/SCENARIO.md` - Case background
- `docs/SETUP.md` - Installation guide
- `docs/COMMANDS.md` - Command reference
- Lab folders: `cases/USB_Imaging/`, `cases/Memory_Forensics/`, etc.

**For Instructors (instructor branch):**
```bash
git checkout instructor
```
- `docs/instructor/README.md` - Instructor materials overview
- `cases/*/instructor/INSTRUCTOR_NOTES.md` - Teaching tips for each lab
- `cases/*/instructor/answer_key.md` - Expected findings
- `cases/*/instructor/rubric.csv` - Grading rubrics

---

## ⚖️ Academic Integrity Reminder

- This is an **individual assessment** - collaborate on concepts, not code
- **AI tools are permitted** but must be documented in your reflection
- **Never copy-paste** AI outputs without understanding
- **Verify all commands** before executing them
- **Your work should be reproducible** - document every step
- **Never modify evidence files** - work on copies only

---

## 🆘 Need Help?

**Technical Issues:**
- Check `docs/TROUBLESHOOTING.md`
- Review error messages carefully
- Search error online (with "docker" + tool name)
- Post on LMS forum with: OS, error message, what you were trying, what you've tried

**Forensic Concepts:**
- Review `docs/SCENARIO.md` and `docs/COMMANDS.md`
- Attend lab session and support availability
- Check tool documentation (Sleuth Kit, Volatility, etc.)
- Ask on LMS forum

**Lab-Specific Help:**
- Review that lab's `README.md`
- Follow the lab's `WALKTHROUGH.md`
- Check `docs/QUICK_REFERENCE.md` for syntax
- Ask instructor during lab session

---

## 🔒 Important Notes

- **Never modify evidence files** - work on copies only
- **Document everything** - reproducibility is key
- **Report objectively** - present facts, not accusations
- **Test your submission** - ensure all files are included
- **Start early** - don't wait until the last day
- **Ask questions** - better to ask than guess

---

## 📚 Additional Resources

- **Sleuth Kit:** https://sleuthkit.org/sleuthkit/docs.php
- **Volatility 3:** https://volatility3.readthedocs.io/
- **Autopsy:** https://www.sleuthkit.org/autopsy/
- **YARA Rules:** https://github.com/Yara-Rules/rules
- **Plaso:** https://plaso.readthedocs.io/
- **Wireshark:** https://www.wireshark.org/docs/

---

**Good luck with your investigation! Remember: professionalism, documentation, and objectivity are the hallmarks of excellent forensic work.**

---

*Forensic Workstation: Ready to investigate*

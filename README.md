# Digital Forensics & Incident Response Laboratory

<!-- BADGES:START -->
[![cybersecurity](https://img.shields.io/badge/-cybersecurity-f44336?style=flat-square)](https://github.com/topics/cybersecurity) [![digital-forensics](https://img.shields.io/badge/-digital--forensics-blue?style=flat-square)](https://github.com/topics/digital-forensics) [![docker](https://img.shields.io/badge/-docker-2496ed?style=flat-square)](https://github.com/topics/docker) [![edtech](https://img.shields.io/badge/-edtech-4caf50?style=flat-square)](https://github.com/topics/edtech) [![incident-response](https://img.shields.io/badge/-incident--response-blue?style=flat-square)](https://github.com/topics/incident-response) [![memory-forensics](https://img.shields.io/badge/-memory--forensics-blue?style=flat-square)](https://github.com/topics/memory-forensics) [![network-analysis](https://img.shields.io/badge/-network--analysis-blue?style=flat-square)](https://github.com/topics/network-analysis) [![sleuth-kit](https://img.shields.io/badge/-sleuth--kit-blue?style=flat-square)](https://github.com/topics/sleuth-kit) [![volatility](https://img.shields.io/badge/-volatility-blue?style=flat-square)](https://github.com/topics/volatility) [![yara](https://img.shields.io/badge/-yara-blue?style=flat-square)](https://github.com/topics/yara)
<!-- BADGES:END -->

> **Part of the [Assume-Breach series](https://michael-borck.github.io/security-labs/)** — five hands-on security labs, two companion books, and a game. Browse them all at the [series hub](https://github.com/michael-borck/security-labs).

**▶ Start here: https://michael-borck.github.io/forensics-docker-lab/** — or run `./start.sh` (or `make start`).
## Complete 5-Lab Course on the Cloudcore 2009 Incident

---

## 🎯 Course Overview

This is a comprehensive hands-on digital forensics course where you will conduct a real-world style investigation of a data exfiltration incident at Cloudcore Inc. You'll work through 5 progressive labs using professional forensic tools in a containerized environment to analyse evidence, recover deleted files, perform memory analysis, and produce professional incident response reports.

**Case:** CLOUDCORE-2009-INS-001 - Data Exfiltration Investigation

**Environment:** Docker-based forensic workstation

**Tools:** Sleuth Kit, Volatility, Autopsy GUI, Plaso, YARA, and more

**Duration:** 5 progressive labs (one per week, ~8-10 hours each)

## 🎓 Environment Scope: What Docker Can & Cannot Do

This is an **analysis** environment, not an **acquisition** environment. The
container has no access to your host's hardware, so:

| ✅ You CAN do here | ❌ You CANNOT do here |
|---|---|
| Analyse disk images (`fls`, `icat`, `tsk_recover`, Autopsy) | Write-block or image a **physical** USB/disk from real hardware |
| Carve deleted files (`foremost`, `photorec`) | Boot or snapshot a live OS |
| Analyse RAM dumps with Volatility (`vol2`/`vol3`) | **Capture** RAM from a running machine (needs `winpmem`/`LiME` on the host) |
| Analyse PCAPs with `tshark`/Wireshark | Sniff live traffic from your NIC |
| Hash, timeline (`plaso`), and YARA-scan evidence | Physically seize or chain-of-custody hardware |

**Why?** Acquisition requires physical access, hardware write-blockers, and
kernel-level access — none of which exist inside a container. That is real and
important work, but it is a *separate* skill. This lab gives you the evidence
pre-acquired (generated or downloaded) so you can focus on the **analysis**,
reasoning, and reporting skills that make up the bulk of forensic work. Each
lab's walkthrough opens with a "how this evidence is captured in real practice"
section so you learn both halves. See `docs/evidence-sources.md` for where each
evidence file comes from.

---

## 📚 The 5 Labs

| Lab | Title | Skills | Key Tools |
|-----|-------|--------|-----------|
| **1** | **USB_Imaging** | Evidence handling, initial triage, deleted file recovery | Sleuth Kit, foremost, exiftool |
| **2** | **Memory_Forensics** | Volatile memory analysis, process investigation | Volatility 2 (Windows XP) |
| **3** | **Email_Logs** | Email artifact analysis, log examination | Python analysis, grep/awk |
| **4** | **Network_Analysis** | Network traffic analysis, C2 detection, exfiltration | Wireshark, tshark, PCAP analysis |
| **5** | **Final_Report** | Synthesis, timeline construction, professional reporting | All tools + reporting skills |

---

## 📦 What's in This Package?

```
forensics-docker-lab/
├── README.md                           ← You are here (course overview)
├── docs/
│   ├── README.md                       ← Student documentation index (START HERE)
│   ├── scenario.md                     ← Complete case background and context
│   ├── setup.md                        ← Installation and Docker setup guide
│   ├── storyline.md                    ← Investigation timeline and narrative
│   ├── glossary.md                     ← Forensics terminology
│   ├── troubleshooting.md              ← Common issues and solutions
│   └── instructor/                     ← Instructor materials (on instructor branch)
│
├── cases/                              ← YOUR WORKSPACE (5 lab folders)
│   ├── USB_Imaging/                    ← Lab 1: Imaging, integrity & initial triage
│   ├── Memory_Forensics/               ← Lab 2: Memory analysis with Volatility
│   ├── Email_Logs/                     ← Lab 3: Email artifact analysis
│   ├── Network_Analysis/               ← Lab 4: Network traffic and C2 detection
│   ├── Final_Report/                   ← Lab 5: Synthesis and final reporting
│   └── Autopsy_GUI/                    ← Optional: Graphical forensic examination
│
├── evidence/                           ← READ-ONLY evidence files
│   ├── usb.img / usb.E01              ← USB image — GENERATED by `make evidence` (Lab 1)
│   ├── memory.raw                      ← Windows memory dump — DOWNLOAD a sample (Lab 2)
│   ├── network.cap                     ← Network capture — included (Lab 4)
│   └── mail.mbox, logs/                ← Email & system logs — included (Lab 3)
│
│   See docs/evidence-sources.md for where each file comes from.
│
├── templates/                          ← Student report templates
│   ├── README.md                       ← Template documentation
│   ├── lab_report_template.md          ← Individual lab report template
│   ├── final_report_template.md        ← Final synthesis report template
│   ├── chain_of_custody.csv            ← CoC log template
│   └── analysis_log.csv                ← Analysis tracking template
│
├── guides/                             ← Interactive guides (HTML)
│   ├── chain-custody-guide.html        ← Chain of custody reference
│   └── forensic-image-primer.html      ← E01 format overview
│
├── rules/                              ← YARA malware detection rules
│   └── README.md                       ← How to use YARA rules
│
├── scripts/
│   ├── forensics-workstation[.bat]     ← Immersive login (bash + Windows .bat)
│   ├── make_usb_image.sh               ← Generates evidence/usb.img + usb.E01
│   ├── coc-log                         ← Chain of custody logging utility
│   ├── verify_setup.sh / .bat          ← Setup verification
│   └── instructor/                     ← Instructor-only tools (on instructor branch)
│
├── images/
│   └── dfir-cli/                       ← Forensic workstation container
│       (Volatility 2 & 3 are installed INSIDE this image)
│
├── docker-compose.yml                  ← Container orchestration
└── LICENSE
```

---

## 🚀 Quick Start (2 Minutes)

The forensic image is **prebuilt and published** by CI (GitHub Container
Registry), so you don't build anything — Docker pulls it automatically.

### TL;DR
```bash
git clone https://github.com/michael-borck/forensics-docker-lab.git
cd forensics-docker-lab
make start            # pulls the image, then drops you into the workstation
```
Then, for the labs:
```bash
make evidence         # generate the USB image for Lab 1
# Lab 2: download a free memory sample → see docs/evidence-sources.md
```

> 💡 `make start` runs `docker compose run --rm dfir` and **pulls** the image on
> first use. The dfir container is an *interactive shell*, so you start it with
> `make start` (not `docker compose up -d`, which is for the background GUI /
> Plaso services — see [Optional Services](#-platform-specific-notes)).

### No internet, or want to build it yourself?
```bash
make setup            # builds the image locally from images/dfir-cli/Dockerfile
```
`docker-compose.yml` keeps the `build:` config as a fallback, so a local build
always works even if the registry is unavailable.

**Every other time:**
```bash
make start            # or ./start.sh / start.bat
```

---

### Detailed Setup

#### Step 1: Prerequisites

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
- Internet connection (to pull the image and download Lab 2's memory sample)

#### Step 2: Get the Forensic Image

No build needed — `make start` (Step 4) pulls the **prebuilt** image from GHCR.
You only build locally if you have no internet or want to customise the image:

```bash
cd /path/to/forensics-docker-lab
make setup          # OPTIONAL: build locally instead of pulling
```

#### Step 3: Verify Your Setup (Recommended)

```bash
make verify
```

Or manually:
- **Windows:** `scripts\verify_setup.bat`
- **macOS/Linux:** `./scripts/verify_setup.sh`

All checks should pass (✓ in green).

#### Step 4: Enter the Forensic Workstation

```bash
make start
```

Or directly:
- **Mac/Linux:** `./start.sh` (or `./scripts/forensics-workstation`)
- **Windows:** `start.bat` (or `scripts\forensics-workstation.bat`)

You'll be prompted for your analyst name, then you're inside:
```
╔═════════════════════════════════════════════════════════════════╗
║                                                                 ║
║     DIGITAL FORENSICS & INCIDENT RESPONSE LABORATORY            ║
║                                                                 ║
║     Cloudcore 2009 Data Exfiltration Investigation              ║
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
3. **Read `docs/scenario.md`** - Complete case background (20 min)
4. **Build Docker environment** - Step 2 above (5 min)
5. **Verify setup** - Step 3 above (5 min)
6. **Enter workstation** - Step 4 above (1 min)

### For Each Lab:

1. **Read the lab README** - e.g., `cases/USB_Imaging/README.md`
2. **Review the walkthrough** - e.g., `cases/USB_Imaging/WALKTHROUGH.md`
3. **Enter the workstation** - `make start` (or `./start.sh` / `start.bat`)
4. **Run analysis commands** - Follow lab walkthrough commands
5. **Fill the report** - Copy `templates/lab_report_template.md` to your lab folder
6. **Log your actions** - Use `coc-log` for chain of custody

### Quick Reference:

- **Stuck on a lab?** → See that lab's `WALKTHROUGH.md`
- **Want to understand the case?** → See `docs/scenario.md`
- **Need timeline context?** → See `docs/storyline.md`
- **Terminology confused?** → See `docs/glossary.md`
- **Setup issues?** → See `docs/troubleshooting.md`

---

## 🔑 Key Features

### ✅ Immersive Forensic Workstation

Instead of typing `docker compose run --rm dfir` every time, use:
```bash
make start          # Recommended: simplest option
# or
./start.sh          # Direct on Linux/Mac
start.bat           # Direct on Windows
./scripts/forensics-workstation     # Full path (equivalent to start.sh)
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

**Terminal:** Use Windows Terminal with Command Prompt or PowerShell (both work)

**Docker Desktop Setup:**
- Enable WSL 2 backend (default)
- Allocate 4GB+ RAM in Docker Desktop settings
- Ensure Docker Desktop is running

**Commands:**
```batch
# Use batch scripts for Windows:
scripts\verify_setup.bat
scripts\forensics-workstation.bat

# Docker commands work the same:
docker compose build
docker compose run --rm dfir
```

**Common Issues:**
- "Command not found": Restart Docker Desktop
- "Access denied": Run Command Prompt as Administrator  
- Batch file won't run: Ensure you're in the correct directory
- PowerShell execution policy: Use batch files instead (no PowerShell required)

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
# Enter the immersive workstation (RECOMMENDED)
scripts\forensics-workstation.bat

# Or use Docker directly (for advanced users)
docker compose run --rm -it dfir bash
```

### Inside the Workstation

```bash
# Lab 1: Analyse the USB image (generate it first with: make evidence)
mkdir -p USB_Imaging/output
fls -r /evidence/usb.img > USB_Imaging/output/fls.txt

# Lab 2: Memory analysis (Volatility 2 is installed as `vol2` inside the workstation)
vol2 -f /evidence/memory.raw imageinfo

# Lab 4: Network analysis
tshark -r /evidence/network.cap -q -z conv,tcp

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

**See complete reference:** `docs/setup.md` and per-lab `WALKTHROUGH.md` files

---

## 📁 Workspace Organisation

### Evidence Directory (`./evidence/`)

**READ-ONLY** - Never modify. Sources:
- `usb.img` / `usb.E01` - USB device image — **generated** by `make evidence`
- `memory.raw` - Memory dump — **download** a free sample (see `docs/evidence-sources.md`)
- `network.cap` - Network capture — included
- `mail.mbox`, `logs/` - Email & logs — included

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
│   └── report.md          ← Your report (copy from templates/lab_report_template.md)
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
- **Support availability:** see course schedule for times
- **Course forum:** Post technical questions
- **Documentation:** Review `docs/COMMANDS.md`, `docs/SCENARIO.md`, lab WALKTHROUGH.md

See **`docs/TROUBLESHOOTING.md`** for more detailed troubleshooting.

---

## 🧠 Learning Objectives

By completing all 5 labs, you will:

1. ✅ Understand proper digital evidence handling (chain of custody, hashing, integrity verification)
2. ✅ Master industry-standard forensic tools (Sleuth Kit, Volatility, Autopsy, Wireshark)
3. ✅ Analyse multiple evidence types (disk images, memory dumps, network captures, logs)
4. ✅ Perform deleted file recovery and carving
5. ✅ Conduct memory forensics on legacy Windows systems
6. ✅ Identify and analyse command & control communications
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
- Week 3: Email_Logs (log analysis)
- Week 4: Network_Analysis (PCAP analysis)
- Week 5: Final_Report (synthesis + reporting)

---

## 🎓 Course Materials

**For Students (main branch):**
- `docs/README.md` - Documentation index
- `docs/scenario.md` - Case background
- `docs/setup.md` - Installation guide
- `docs/storyline.md` - Investigation timeline
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
- Check `docs/troubleshooting.md`
- Review error messages carefully
- Search error online (with "docker" + tool name)
- Post on course forum with: OS, error message, what you were trying, what you've tried

**Forensic Concepts:**
- Review `docs/scenario.md` and `docs/storyline.md`
- Attend a lab session or contact support
- Check tool documentation (Sleuth Kit, Volatility, etc.)
- Ask on course forum

**Lab-Specific Help:**
- Review that lab's `README.md`
- Follow the lab's `WALKTHROUGH.md`
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

## 📚 Forensic Tools & Resources

### Core Tools (Pre-Installed)

- **Sleuth Kit (fls, icat, tsk_recover, fsstat, istat):** https://sleuthkit.org/sleuthkit/docs.php
- **Volatility 2:** For Windows XP and older memory analysis - https://volatility-labs.blogspot.com/
- **Volatility 3:** Modern memory forensics framework - https://volatility3.readthedocs.io/
- **tshark:** Command-line network packet analyzer - https://www.wireshark.org/docs/man-pages/tshark.html
- **YARA:** Malware pattern matching and detection - https://virustotal.github.io/yara/
- **Autopsy:** GUI forensic analysis platform - https://www.sleuthkit.org/autopsy/

### Additional Resources

- **Wireshark:** Network protocol analyzer (GUI complement to tshark) - https://www.wireshark.org/docs/
- **YARA Rules Repository:** Community malware detection rules - https://github.com/Yara-Rules/rules

---

**Good luck with your investigation! Remember: professionalism, documentation, and objectivity are the hallmarks of excellent forensic work.**

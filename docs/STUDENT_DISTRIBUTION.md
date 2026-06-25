# Student Distribution Guide

## Options for Distributing the Forensic Lab to Students

This document outlines different approaches for getting the lab environment to students, with pros/cons for each.

---

## Option 1: GitHub Repository (Recommended)

**Students clone from a Git repository (GitHub/GitLab/Bitbucket)**

### Setup:
```bash
# Create a repository
git init
git add .
git commit -m "Initial forensic lab setup"
git remote add origin https://github.com/yourorg/forensics-docker-lab.git
git push -u origin main
```

### Student Instructions:
```bash
git clone https://github.com/yourorg/forensics-docker-lab.git
cd forensics-docker-lab
docker compose build dfir
docker compose run --rm dfir
```

### Pros:
✅ **Easy updates** - `git pull` to get fixes/updates
✅ **Version control** - Students can commit their work
✅ **Familiar workflow** - Most CS students know Git
✅ **Free hosting** - GitHub/GitLab free for education
✅ **Easy collaboration** - Students can share findings (if desired)
✅ **Issue tracking** - Students can report problems via Issues
✅ **No file size limits** for code (evidence separate)

### Cons:
❌ **Git learning curve** for some students
❌ **Evidence files must be distributed separately** (GitHub has 100MB file limit, your memory.raw is 511MB)
❌ **Risk of students pushing answers** (can be mitigated with .gitignore)

### Best For:
- Courses where students know Git
- When you'll push updates during the semester
- When evidence files can be downloaded separately

### Implementation:
1. **Create .gitignore** to exclude evidence and student outputs:
```gitignore
# Evidence files (too large for Git)
evidence/usb.img
evidence/memory.raw
evidence/*.raw
evidence/*.img
evidence/*.dd

# Student work (shouldn't be in repo)
cases/Lab_*/
cases/chain_of_custody.csv
cases/.bash_history

# Docker volumes
.bash_history

# OS files
.DS_Store
Thumbs.db
```

2. **Create evidence download instructions** (see Option 4)

3. **Make repository private or public** (your choice)

---

## Option 2: ZIP/Tarball Download

**Distribute a compressed archive via file sharing**

### Create Distribution:
```bash
# Create archive WITHOUT evidence files
tar -czf forensics-lab-v1.0.tar.gz \
  --exclude='evidence/*.raw' \
  --exclude='evidence/*.img' \
  --exclude='cases/Lab_*' \
  --exclude='.git' \
  forensics-docker-lab/
```

### Student Instructions:
```bash
# Download forensics-lab-v1.0.tar.gz
tar -xzf forensics-lab-v1.0.tar.gz
cd forensics-docker-lab
# Download evidence files separately (see instructions)
docker compose build dfir
docker compose run --rm dfir
```

### Pros:
✅ **Simple** - No Git knowledge required
✅ **Complete snapshot** - Students get exact version
✅ **Works offline** - After download, no internet needed
✅ **No account needed** - No GitHub signup

### Cons:
❌ **No easy updates** - Must redistribute entire archive
❌ **Version confusion** - Students may have different versions
❌ **Large file size** - Even without evidence
❌ **No version control** - Students can't track their changes

### Best For:
- Short workshops or one-off training
- Environments with limited internet
- Non-technical students unfamiliar with Git

### Distribution Methods:
- Learning Management System (Canvas, Moodle, Blackboard)
- Cloud storage (Google Drive, Dropbox, OneDrive)
- USB drives (for in-person labs)

---

## Option 3: Docker Image Registry (Advanced)

**Pre-build the Docker image and distribute via registry**

### Build and Push:
```bash
# Build and tag image
docker compose build dfir
docker tag forensic/dfir-cli:latest yourorg/forensic-dfir:v1.0

# Push to Docker Hub (public or private)
docker push yourorg/forensic-dfir:v1.0
```

### Student docker-compose.yml:
```yaml
services:
  dfir:
    image: yourorg/forensic-dfir:v1.0  # Pre-built image
    volumes:
      - ./evidence:/evidence:ro
      - ./cases:/cases
    stdin_open: true
    tty: true
```

### Student Instructions:
```bash
# Download lab files (no Dockerfile needed)
# docker compose.yml uses pre-built image
docker compose pull dfir
docker compose run --rm dfir
```

### Pros:
✅ **Faster for students** - No build time (5+ minutes saved)
✅ **Consistent environment** - Everyone uses same image
✅ **Smaller distribution** - Just docker-compose.yml + scripts
✅ **Easy updates** - Push new image version

### Cons:
❌ **Registry required** - Need Docker Hub account (or private registry)
❌ **Upload time** - 499MB image takes time to push
❌ **Bandwidth** - Students download 499MB image
❌ **Less transparency** - Students can't see Dockerfile

### Best For:
- Large classes (save student build time)
- Limited student hardware (building is CPU-intensive)
- Controlled environment (you manage exact versions)

---

## Option 4: Hybrid Approach (Git + Separate Evidence) **RECOMMENDED**

**Combine Git repository with separate evidence distribution**

### Structure:
```
Git Repository (github.com/yourorg/forensics-lab):
├── Dockerfile
├── docker-compose.yml
├── SETUP.md
├── COMMANDS.md
├── cases/ (templates only)
├── scripts/
├── images/
└── .gitignore (excludes evidence)

Separate Download (large files):
├── evidence-bundle-v1.0.zip (650MB)
    ├── usb.img
    ├── memory.raw
    ├── network.cap
    ├── mail.mbox
    └── logs/
```

### Student Workflow:
```bash
# 1. Clone repository
git clone https://github.com/yourorg/forensics-lab.git
cd forensics-lab

# 2. Download evidence separately
# Option A: Direct download link
wget https://yourserver.edu/forensics/evidence-bundle-v1.0.zip
unzip evidence-bundle-v1.0.zip

# Option B: Cloud storage
# Download from Google Drive/Dropbox link provided

# 3. Verify evidence integrity
sha256sum -c evidence/checksums.txt

# 4. Build and run
docker compose build dfir
docker compose run --rm dfir
```

### Create Evidence Bundle:
```bash
# Create evidence archive with checksums
cd evidence
sha256sum * > checksums.txt
cd ..
zip -r evidence-bundle-v1.0.zip evidence/
```

### Pros:
✅ **Best of both worlds** - Git for code, separate for large files
✅ **Easy updates** - Code updates via Git, evidence rarely changes
✅ **Clean repository** - No huge binary files in Git
✅ **Integrity checking** - Include checksums for evidence
✅ **Flexible distribution** - Evidence via cloud/LMS/USB

### Cons:
❌ **Two-step setup** - Students must download twice
❌ **Need hosting** for evidence files

### Best For:
- **Most courses** (ideal balance)
- When evidence files rarely change
- When you want version control benefits

---

## Option 5: Cloud Development Environment

**Use GitHub Codespaces, GitPod, or similar**

### Setup:
Create `.devcontainer/devcontainer.json`:
```json
{
  "name": "Forensic Lab",
  "dockerComposeFile": "../docker-compose.yml",
  "service": "dfir",
  "workspaceFolder": "/cases",
  "remoteUser": "forensic"
}
```

### Student Instructions:
```bash
# 1. Open repository in GitHub Codespaces
# 2. Evidence pre-loaded in cloud
# 3. Terminal opens in forensic workstation automatically
```

### Pros:
✅ **Zero local setup** - Everything in browser
✅ **Consistent environment** - No "works on my machine"
✅ **No Docker install needed** - Cloud handles it
✅ **Accessible anywhere** - Just need browser

### Cons:
❌ **Cost** - Codespaces has limits (60 hours/month free for students)
❌ **Internet required** - Can't work offline
❌ **Evidence in cloud** - Privacy/security concerns
❌ **Less realistic** - Real forensics uses local workstations

### Best For:
- Online courses
- Students with limited hardware
- Quick demos or workshops

---

## Recommended Distribution Strategy

### For a Typical Course:

**Primary Distribution: Option 4 (Git + Separate Evidence)**

#### Week 0 (Before Classes):
1. **Create private GitHub repository**
   ```bash
   # Initialize repo
   git init
   git add .
   git commit -m "Initial forensic lab setup"
   git remote add origin https://github.com/yourorg/forensics-2025.git
   git push -u origin main
   ```

2. **Add students as collaborators** (or use GitHub Classroom)

3. **Create evidence bundle**
   ```bash
   cd evidence
   sha256sum * > checksums.txt
   cd ..
   tar -czf evidence-bundle-v1.0.tar.gz evidence/
   ```

4. **Upload evidence** to institutional file server or cloud storage

5. **Create setup instructions** document (see template below)

#### Week 1 (Setup Lab):
Students follow setup instructions:
```markdown
# Forensic Lab Setup Instructions

## Prerequisites
- Docker Desktop installed (see installation guide)
- 10GB free disk space
- Git installed

## Setup Steps

### 1. Clone Repository
git clone https://github.com/yourorg/forensics-2025.git
cd forensics-2025

### 2. Download Evidence Files
Download from: https://youruni.edu/forensics/evidence-bundle-v1.0.tar.gz
Extract into the forensics-2025 folder.

### 3. Verify Evidence Integrity
sha256sum -c evidence/checksums.txt
(All files should say "OK")

### 4. Build Forensic Workstation
docker compose build dfir
(Takes 5-10 minutes first time)

### 5. Test Installation
docker compose run --rm dfir
(You should see the forensic lab banner)

Inside workstation, test:
fls --version
yara --version
exit

### 6. Submit Setup Verification
Run: docker compose run --rm hashlog
Submit: cases/chain_of_custody.csv to Canvas

## Troubleshooting
See TROUBLESHOOTING.md or post in discussion forum.
```

#### During Semester:
- **Push updates** to Git (bug fixes, additional resources)
- **Students pull updates**: `git pull`
- **Evidence rarely changes** (already downloaded)

#### End of Semester:
- **Students submit** via Git push (to their branches)
- **Or export** their cases/ folder and submit via LMS

---

## Distribution Checklist

Before distributing to students:

### Repository Preparation:
- [ ] Remove ANSWER_KEY.md (move to instructor-only repo)
- [ ] Remove instructor notes from student-facing docs
- [ ] Add comprehensive .gitignore
- [ ] Test fresh clone on different machine
- [ ] Update all paths in documentation
- [ ] Verify SETUP.md instructions are clear

### Evidence Preparation:
- [ ] Create evidence bundle (without Lab solutions)
- [ ] Generate checksums (sha256sum)
- [ ] Test evidence integrity
- [ ] Upload to accessible location
- [ ] Test download speed/availability
- [ ] Create alternative download mirrors

### Documentation:
- [ ] Create student setup guide
- [ ] Include Docker installation instructions
- [ ] Provide troubleshooting guide
- [ ] List system requirements
- [ ] Include submission instructions
- [ ] FAQ document

### Testing:
- [ ] Fresh install on Windows
- [ ] Fresh install on macOS
- [ ] Fresh install on Linux
- [ ] Test with slow internet connection
- [ ] Test all labs from student perspective
- [ ] Verify student can't access answers

---

## Evidence Distribution Options

### Option A: Institutional File Server
**Upload to institutional web server or FTP**

Pros: Controlled, fast on campus network, no external dependencies
Cons: May need IT support, off-campus access may be slow

### Option B: Cloud Storage (Google Drive, Dropbox, OneDrive)
**Create shareable link**

Pros: Easy setup, reliable, students familiar with it
Cons: Download limits, requires Google/MS account

### Option C: Learning Management System (Canvas, Moodle)
**Upload as course resource**

Pros: Students already have access, integrated with course
Cons: File size limits (may need to split), slower download

### Option D: Academic Torrents (academictorrents.com)
**Create torrent for large datasets**

Pros: Fast distributed downloads, handles large files, free
Cons: Students need torrent client, less familiar

### Option E: USB Distribution (In-Person Only)
**Hand out USB drives in first lab**

Pros: Fast, works offline, no internet needed
Cons: Physical logistics, cost of USBs, hard to update

---

## Recommended: GitHub + Cloud Storage

**Final Recommendation:**

```
Code/Scripts/Docs:    GitHub Repository (private)
Evidence Files:       Google Drive / Dropbox
Submission:           Git branches OR Canvas upload
Updates:              git pull for code, evidence static
```

**Student Setup:**
1. Clone from GitHub
2. Download evidence from cloud link (one-time)
3. Build Docker image
4. Work in Git-tracked environment
5. Submit via Git push or export cases/

**Instructor Benefits:**
- Easy to push updates
- Students can collaborate (if desired)
- Version control of student work
- Clean separation of code and data

---

## Sample Student Email

```
Subject: Forensic Lab Setup - Action Required Before Week 2

Hi everyone,

Please complete the following setup steps BEFORE our Week 2 lab:

1. **Install Docker Desktop**
   - Windows/Mac: https://www.docker.com/products/docker-desktop
   - Verify installation: Open terminal and run `docker --version`

2. **Clone Lab Repository**
   git clone https://github.com/yourorg/forensics-2025.git
   cd forensics-2025

3. **Download Evidence Files** (650MB, one-time download)
   Link: https://drive.google.com/file/d/xxxxx/view
   Extract into the forensics-2025 folder

4. **Build Forensic Workstation** (takes 5-10 minutes)
   docker compose build dfir

5. **Test Your Setup**
   docker compose run --rm dfir
   (You should see a banner and get a prompt)
   Type: exit

6. **Submit Verification**
   Run: docker compose run --rm hashlog
   Upload cases/chain_of_custody.csv to Canvas

**Need Help?**
- Troubleshooting: See TROUBLESHOOTING.md in the repository
- Discussion Forum: Post questions in Canvas discussions
- Support availability: [Your hours here]

**System Requirements:**
- 10GB free disk space
- Windows 10/11, macOS 10.15+, or Linux
- 8GB RAM recommended

Looking forward to seeing you in the lab!
```

---

## Summary Table

| Method | Setup Time | Updates | Best For |
|--------|-----------|---------|----------|
| **Git + Separate Evidence** | 30 min | Easy (git pull) | ⭐ **Most courses** |
| Git Only (small evidence) | 20 min | Easy (git pull) | Workshops with small data |
| ZIP Download | 15 min | Hard (redownload) | One-off training |
| Pre-built Docker Image | 10 min | Medium (new image) | Large classes |
| Cloud Environment | 5 min | Automatic | Online courses |

**Recommendation: Option 4 (Git + Separate Evidence)** for most forensic courses.

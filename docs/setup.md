# Setup Guide

## Prerequisites
- Docker & Docker Compose (v2+)
- Linux/macOS/WSL2 (sudo for Lab 1 mount)
- Basic CLI knowledge (bash, git)

## Quick Repo Setup
1. Clone: `git clone <repo-url> && cd forensics-docker-lab`
2. Build the forensic workstation: `make setup`
   (runs `docker compose build`; ~2-5 min on first build)
3. Generate the USB evidence (Lab 1): `make evidence`
   → creates `evidence/usb.img` (FAT32, with recoverable deleted files)
     and `evidence/usb.E01`. Needs no `sudo` and no host filesystem tools.
4. Get a memory dump (Lab 2): see **`docs/evidence-sources.md`**, download a
   free sample, and place it at `evidence/memory.raw`.
   (Email, logs and `network.cap` are already included for Labs 3 & 4.)
5. Verify everything: `make verify`
6. (Optional) Record baseline evidence hashes with `coc-log` inside the
   workstation — it appends to `cases/<lab>/chain_of_custody.csv`.

## Interactive Workstation Usage (Recommended)

The forensic environment is designed to feel like logging into a dedicated forensic workstation:

```bash
# Enter the forensic workstation
docker compose run --rm -it dfir
```

You'll see a banner with available tools and get an interactive bash prompt:
```
  ________________________________________________________________
 /                                                                \
|   DIGITAL FORENSICS & INCIDENT RESPONSE LABORATORY              |
|   Cloudcore 2009 Data Exfiltration Investigation               |
 \________________________________________________________________/

  🔍 Tools Installed:
    • Sleuth Kit (fls, icat, fsstat, tsk_recover, mmls, blkls)
    • Volatility 2 & 3 (vol2 / vol3 -f /evidence/memory.raw ...)
    ...

analyst@forensics-lab:/cases$
```

**Inside the workstation**, you can run commands directly:
```bash
# List files in disk image
fls -r /evidence/usb.img

# Recover deleted files
tsk_recover -a /evidence/usb.img USB_Imaging/recovered/

# Search for patterns
grep -i "password" USB_Imaging/*.txt

# Exit when done
exit
```

**Benefits:**
- Less typing (no `docker compose run --rm dfir` prefix)
- Tab completion works
- Command history persists (saved to cases/.bash_history)
- More immersive learning experience

## Alternative: One-Off Commands

You can still run individual commands without entering the workstation:
```bash
docker compose run --rm dfir fls -r /evidence/usb.img
```

## Test Run
```bash
# Enter the workstation
docker compose run --rm -it dfir

# Inside, test tools:
fls -r /evidence/usb.img
vol --help
yara --version

# Exit
exit
```

Verify: No errors; evidence/ owned by user (PUID/PGID in .env).

## Optional Services
- **Autopsy GUI**: `make gui` (runs `docker compose up -d novnc autopsy`) → http://localhost:8080/vnc.html. Stop with `make gui-stop`.
- **Plaso/Volatility**: Run as needed (see lab READMEs)

## Troubleshooting
See troubleshooting.md.

For full labs, follow per-lab READMEs. Run `git pull` for updates.

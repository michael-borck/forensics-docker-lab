# Evidence Sources

This lab ships the **small text-based evidence** (email, logs) and can **generate
the USB disk image** itself (Lab 1). However, a **Windows memory dump cannot be
synthesised** — it must be captured from a real (or virtual) Windows system. So
for **Lab 2 (Memory_Forensics)** you download a freely-available, pre-captured
sample from an authoritative source.

> **Why can't the lab create a memory dump?** Memory forensics analyses a raw
> copy of a running operating system's RAM. A meaningful dump contains real
> Windows kernel/process structures; fabricating one would teach nothing. The
> Docker environment is for *analysis*, not *acquisition* (it has no access to
> host hardware and is not a virtual Windows machine). See
> [Environment Scope](../README.md#-environment-scope-what-docker-can--cannot-do).

---

## Lab 1 — USB image (`evidence/usb.img`, `evidence/usb.E01`)

**Generated for you.** Run:

```bash
make setup       # build the forensic image (first time)
make evidence    # generate evidence/usb.img + evidence/usb.E01
```

This produces a FAT32 image (volume label `PRACTICE`) with deleted scenario
files that are recoverable with Sleuth Kit (`fls`/`icat`/`tsk_recover`) and
carvable with `foremost`, plus an EnCase `.E01` wrapper for the `ewfmount`/
`ewfverify` exercises. No download required.

---

## Lab 2 — Memory dump (`evidence/memory.raw`) — **download one**

Pick **any one** Windows memory sample. The lab is **method-driven**: it teaches
the Volatility workflow (`imageinfo` → profile → `pslist` → `pstree` →
`psscan` → `dlllist` …), so it works with whichever sample you choose — your
specific PIDs/processes will differ from the illustrative ones in the
walkthrough, which is expected.

### Recommended sources (all free, all legal to use for training)

| Source | Details | Link |
|---|---|---|
| **Digital Corpora — M57 Patents (2009)** ⭐ | ~70 RAM dumps from a documented scenario about **intellectual-property theft** (matches this lab's exfiltration theme). Stable NPS/NIST hosting. | <https://downloads.digitalcorpora.org/corpora/scenarios/2009-m57-patents/ram/> |
| **Volatility Foundation — Memory Samples** | The official curated list (Cridex, Shylock, R2D2/0zapftis, NIST, and more). The repo is archived but the wiki page remains the canonical index. | <https://github.com/volatilityfoundation/volatility/wiki/Memory-Samples> |
| **NIST / CFReDS** | 5 memory images (XP SP2, 2003, Vista). | <http://www.cfreds.nist.gov/mem/memory-images.rar> |
| **Cridex (Win XP SP2)** | Classic banking-malware sample, widely used in teaching Volatility 2. | <http://files.sempersecurus.org/dumps/cridex_memdump.zip> |

### Installing your chosen sample

1. Download one dump (e.g. an M57 `.mem` file, or Cridex's `cridex.vmem`).
2. Decompress if needed (`.zip` / `.7z` / `.rar` / `.bz2`).
3. Place it at `evidence/memory.raw` (any filename works — just update the
   commands; the walkthrough uses `memory.raw`).

```bash
# Example: M57 scenario dump (pick one file from the ram/ directory)
curl -L -o evidence/memory.raw "<url-from-digital-corpora>"
```

You are now ready for Lab 2. First command: `vol2 -f /evidence/memory.raw imageinfo`
to detect the OS profile.

---

## Labs 3 & 4 — Email, logs, network (`evidence/mail.mbox`, `evidence/network.cap`, `evidence/logs/`)

**Included** in the repository. These are small but valid and exercise the full
analysis workflow. (Instructors who want a richer PCAP may substitute any public
capture — e.g. from [malware-traffic-analysis.net](https://malware-traffic-analysis.net/)
— and the `tshark` commands work unchanged.)

---

## Attribution & licensing

The linked samples are hosted by their respective owners (Digital Corpora/NIST,
Volatility Foundation, academic researchers). They are provided for **education
and research**. Do not redistribute them; link to the canonical source instead.

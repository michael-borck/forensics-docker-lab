---
format:
  html:
    embed-resources: true
---

# Network_Analysis Lab - Student Walkthrough
## PCAP Network Traffic Analysis

**Time Estimate:** 1.5-2 hours

**Difficulty:** Intermediate

**Tools:** tshark, wireshark, strings, grep

> **ℹ️ About the example outputs in this walkthrough:** The packet counts,
> IPs, hashes, and protocol stats shown are *illustrative*. Your actual values
> depend on the `network.cap` provided (or any PCAP you substitute). Record
> YOUR real outputs in your report and `analysis_log.csv`.

---

## 📸 Context: Network Traffic Capture in Forensic Practice

**Important Context:** In this lab, you're analysing a **network packet capture (PCAP)** file captured from network traffic. In real incident response, network captures provide critical evidence of data exfiltration and attacker communication.

### Real-World Network Capture Process

In a real incident response, a forensic technician would:

1. **Network Detection (Incident Recognition):**
   - Network monitoring detects suspicious traffic
   - Intrusion Detection System (IDS) alerts on anomalies
   - SIEM (Security Information Event Management) correlates events
   - IR team is notified of potential breach

2. **Packet Capture Setup:**
   - Tap into network switch or router
   - Use packet sniffing tools to record all traffic
   - Common capture methods:
     - **tcpdump** (Linux) - Command-line packet capture
     - **Wireshark** (GUI) - Interactive capture and analysis
     - **Network TAP** - Hardware device that mirrors traffic
     - **SPAN/Port Mirroring** - Switch feature to copy traffic
     - **Zeek (formerly Bro)** - Automated network analysis
   - Capture on segment of interest (e.g., suspect's workstation, server)
   - Duration: Minutes to hours depending on traffic volume

3. **PCAP File Format:**
   - Standard format: **PCAP** (.pcap, .cap) or **PCAPNG** (.pcapng)
   - Contains all network packets at specific time period
   - Includes: Timestamp, source IP, destination IP, port, protocol, payload
   - Size: Typically MB to GB depending on network activity

4. **Evidence Verification:**
   - Hash the PCAP file
   - Verify packet count and time range
   - Document start/end timestamps
   - Note any packet loss or errors
   - Check for fragmentation or gaps

5. **Documentation:**
   - When captured, for how long
   - Which network segment/interface
   - Capture tool used and settings
   - Hash of PCAP file
   - Total packets captured
   - Any filtering applied (e.g., "only HTTPS traffic")

### In This Lab

We've **skipped the capture phase** and provided you with a pre-captured PCAP file (`network.cap`). This contains actual network traffic from the Cloudcore incident. You'll analyze:

- **Protocol analysis:** What protocols were used?
- **Data exfiltration:** Evidence of data leaving the network
- **C2 Communication:** Command & Control traffic from malware
- **Timeline:** When did suspicious traffic occur?
- **Indicators of Compromise (IOCs):** IPs, domains, ports involved

This lab teaches:

- How to read and filter network traffic
- Identifying C2 (Command & Control) communications
- Detecting data exfiltration patterns
- Correlating network evidence with other labs
- Timeline analysis at the network level

### Key Network Forensics Concepts

**Why Network Forensics?**

- ✓ Shows what data left the network (exfiltration proof)
- ✓ Identifies attacker infrastructure (C2 servers, IPs)
- ✓ Reveals attack timeline at network level
- ✓ Evidence of malware beaconing home
- ✓ Proof of unauthorized data access

**Limitations:**

- ✗ Encrypted traffic (HTTPS, TLS) shows only metadata (not content)
- ✗ Malware can use obfuscation or tunneling
- ✗ Legitimate traffic can hide malicious intent
- ✗ Requires correlation with other evidence (disk, memory)

---

## 📋 Pre-Lab Setup

### 1. Verify Lab Templates Are Ready

The lab folder should already contain three template files. Verify they exist, on your host machine:

```bash
ls -lh cases/Network_Analysis/
```

You should see:

- **chain_of_custody.csv** - Evidence handling record
- **analysis_log.csv** - Command execution log
- **lab_report.md** - Report template for your findings
- **WALKTHROUGH.md** - This document

**What each file does:**

| File | Purpose | When Used |
|------|---------|-----------|
| **chain_of_custody.csv** | Documents evidence integrity (hashes, analyst, date) | Before lab starts - fill in evidence details |
| **analysis_log.csv** | Logs every command you run with timestamps and output hashes | During lab - use `coc-log` script to auto-update |
| **lab_report.md** | Template for writing your findings and analysis | After lab - document what you discovered |

If any files are missing, copy them from templates/:

```bash
# Copy missing templates (if needed)
cp templates/chain_of_custody.csv cases/Network_Analysis/chain_of_custody.csv
cp templates/analysis_log.csv cases/Network_Analysis/analysis_log.csv
cp templates/lab_report_template.md cases/Network_Analysis/lab_report.md
```

**Tips for using these files:**

- **chain_of_custody.csv**: Edit with spreadsheet app or text editor. Fill in evidence hash, analyst name, case number before beginning.
- **analysis_log.csv**: Use `coc-log` script inside container to automatically log commands (recommended). If not using coc-log, manually add entries after each command.
- **lab_report.md**: Use as starting point for your findings report. Replace placeholders with your actual analysis and evidence.

### 2. Verify Evidence

```bash
ls -lh evidence/network.cap
```

---

## 🚀 Connecting to the DFIR Forensic Workstation

The `scripts/forensics-workstation` script provides an immersive forensic environment that hides Docker complexity and simulates logging into a professional forensic workstation.

**On macOS/Linux:**
```bash
./scripts/forensics-workstation
```

**On Windows (PowerShell):**
```powershell
.\scripts\forensics-workstation.bat
```

You'll see:

1. A welcome banner asking for your analyst name
2. A lab summary showing all available cases
3. A connection message, then you'll see the forensic workstation prompt


---

**CRITICAL:** Before analysing ANY evidence, you must calculate and document hash values. This proves the evidence hasn't been tampered with.

### Step 1: Calculate MD5 Hash

```bash
md5sum /evidence/network.cap
```

**Example md5 Output:**
```
5b11bcf700d237fa9cd786eb9b140b68  /evidence/network.cap
```

**📋 Document in cases/Network_Analysis/chain_of_custody.csv:**

- Evidence_ID: NETWORK-001
- MD5_Hash: (paste output from running the above command)
- SHA256_Hash: (you'll add this next)
- Analyst_Name: (your name)
- Date_Received: (today's date)
- Case_Number: CLOUDCORE-2009-INS-001
- Evidence_Description: Wireshark/Tshark Network Packet Capture
- Storage_Location: /evidence/network.cap

### Step 2: Calculate SHA256 Hash

```bash
sha256sum /evidence/network.cap
```

**Example sha256 Output:**
```
2bb66007b2ab2117aec5b7d925b1edc408855ae03ff73c36f7cdb93af6553831  /evidence/network.cap
```

**📋 Update chain_of_custody.csv:**
- Add the SHA256_Hash value above

**Why document hashes?**

- **Integrity verification:** Proves evidence hasn't been modified or corrupted
- **Legal admissibility:** Courts require hash verification for digital evidence
- **Reproducibility:** Other investigators can verify they're analysing the same evidence
- **Chain of custody:** Documents the starting point of analysis


**📋 Document in analysis_log.csv:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: md5sum /evidence/network.cap
exit_code: 0
note: Chain of custody - calculated MD5 hash of network.cap : 5b11bcf700d237fa9cd786eb9b140b68
```

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: sha256sum /evidence/network.cap
exit_code: 0
note: Chain of custody - calculated SHA256 hash of network.cap: 2bb66007b2ab2117aec5b7d925b1edc408855ae03ff73c36f7cdb93af6553831
```

**Why document commands?**

- **Reproducibility:** Lets others repeat your exact steps to verify findings.
- **Legal Defensibility:** Creates a transparent, auditable log for court.
- **Evidence Integrity:** Shows exactly how you interacted with the data.
- **Accurate Reporting:** Provides the precise technical "how" for your report.
- **Peer Review & QA:** Allows colleagues to check your process for accuracy.
- **Contemporaneous Notes:** Logs actions as they happen, preventing memory errors.


---

## 📊 Part 2: PCAP Summary

**Why this step:** Before analysing network traffic, you need an overview. What hosts are communicating? How much traffic? This gives context and helps identify suspicious patterns. A sudden spike in outgoing traffic or communication with unknown external hosts is suspicious.

Get overview of the capture:

**Step 1: Check file format**
```bash
file /evidence/network.cap
```

**What this does:**

- Verifies the file is actually a valid PCAP format
- Shows capture metadata (packet count hints, file type verification)
- Confirms the file hasn't been corrupted

**Expected output:**
```
/evidence/network.cap: tcpdump capture file (little-endian) - version 2.4 (Ethernet, capture length 65535)
```

**Step 2: Generate host summary**. Use tshark to get statistics:


```bash
tshark -r /evidence/network.cap -q -z ip_hosts,tree > /cases/Network_Analysis/host_summary.txt
```

**What this command does:**

- `-r /evidence/network.cap` - Read from the PCAP file (read-only, safe)
- `-q` - Quiet mode (no packet-by-packet output)
- `-z ip_hosts,tree` - Generate IP statistics in tree format
  - Shows all unique hosts that communicated
  - Shows packet count from each host
  - Helps identify which IPs are talking to which

**Why it matters:**

- **Scope:** How many hosts are in the capture? (Few = targeted attack, Many = broader network)
- **Internal vs. External:** Which IPs are inside vs. outside your network?
- **Volume patterns:** Which hosts sent/received the most data?
- **Suspicious activity:** Hosts with unusual communication patterns

**Expected output:**
```
=================================================================================================================================
IPv4 Statistics/All Addresses:
Topic / Item      Count         Average       Min Val       Max Val       Rate (ms)     Percent       Burst Rate    Burst Start
---------------------------------------------------------------------------------------------------------------------------------
All Addresses     514                                                     0.0030        100%          0.1200        92.137
 172.16.1.10      514                                                     0.0030        100.00%       0.1200        92.137
 68.164.173.62    304                                                     0.0018        59.14%        0.0600        58.578
 69.64.34.124     48                                                      0.0003        9.34%         0.0500        91.475
 216.127.33.119   47                                                      0.0003        9.14%         0.1000        92.708
 68.164.194.35    30                                                      0.0002        5.84%         0.1000        95.381
 68.45.134.187    26                                                      0.0002        5.06%         0.0200        5.502
 67.38.252.160    24                                                      0.0001        4.67%         0.0200        16.237
 207.46.196.46    12                                                      0.0001        2.33%         0.0200        81.222
 80.167.183.40    6                                                       0.0000        1.17%         0.0200        106.078
 172.16.0.254     6                                                       0.0000        1.17%         0.0200        91.327
 216.155.193.156  5                                                       0.0000        0.97%         0.0300        1.872
 80.67.66.62      2                                                       0.0000        0.39%         0.0200        2.653
 63.144.115.50    2                                                       0.0000        0.39%         0.0200        0.000
 163.32.78.60     2                                                       0.0000        0.39%         0.0200        156.073

---------------------------------------------------------------------------------------------------------------------------------
```

**Analysis of this output:**

- **Internal IPs:** 172.16.1.10 (514 packets, 100% of traffic), 172.16.0.254 (6 packets)
- **External IPs:** Multiple external hosts with varying traffic volumes
- **Highest activity:** 172.16.1.10 is the primary internal host communicating externally
- **Notable external IPs:** 68.164.173.62 (304 packets, 59.14% of traffic) - significant external communication
- **Potential C2:** Look for repeated communication patterns with specific external IPs

**Analysis tips:**

- **Internal IPs** (172.16.x.x) = your network
- **External IPs** = check if they should be communicating
- **High packet count** = frequent communication (C2 beacon pattern?)
- **High data volume** = potential data exfiltration

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: file /evidence/network.cap && tshark -r /evidence/network.cap -q -z ip_hosts,tree > /cases/Network_Analysis/host_summary.txt
exit_code: 0
note: PCAP file verified and host summary generated - identified X unique hosts, highest activity from [IP]
```

---

## 🔍 Part 3: Identify Suspicious Traffic

**Why this step:** Protocol analysis reveals intent. Attackers must communicate - via DNS (to find command servers), HTTP (to exfiltrate data), SSH (for remote access), etc. By analysing these protocols, you discover what was actually transmitted and to where.

### Extract DNS Queries

**Why DNS matters:** Every network connection starts with DNS - the attacker's malware needs to find the command & control server, the attacker needs to find cloud storage, etc. DNS queries show intent before any actual attack.

```bash
tshark -r /evidence/network.cap -Y "dns" -T fields -e dns.qry.name > /cases/Network_Analysis/dns_queries.txt
```

**What this command does:**

- `-Y "dns"` - Filter to show only DNS protocol packets
  - DNS queries = requests to resolve domain names to IPs
  - Essential for understanding "what was the attacker looking for?"
- `-T fields` - Output as structured fields (one field per line)
- `-e dns.qry.name` - Extract only the domain name being queried
  - Example: `malware.com`, `c2server.net`, `data-exfil.ru`

**Why it matters:**

- **C2 Infrastructure:** Attackers register domains for C2 servers
  - Suspicious domains: `*.ru`, `*.cn`, unusual names
  - Known bad domains: Compare against threat intelligence databases
- **Staging servers:** Attacker queries domains before exfiltration
- **Detection evasion:** Fast-flux DNS (changing IPs constantly)
- **Proof of intent:** Deliberately querying suspicious domain = deliberate attack

**Expected findings:**
```
uld3r.q8hell.org
uld3r.q8hell.org
ysbweb.com
ysbweb.com
www.ysbweb.com
www.ysbweb.com
```

**Analysis of this output:**

- **uld3r.q8hell.org** - Highly suspicious domain name
  - "q8hell" suggests malicious intent
  - "uld3r" could be "loader" reference
  - Queried twice = potential C2 beaconing
- **ysbweb.com** - Appears legitimate but repeated queries
  - Queried 4 times total (2 for domain, 2 for www subdomain)
  - Could be staging or legitimate site
- **Pattern:** Repeated DNS queries = automated communication

**Analysis tips:**

- Look for domains you don't recognize
- Check for suspicious subdomains or naming patterns
- Count query frequency (repeated queries = beacon?)
- **q8hell.org** is clearly malicious based on name
- Compare with threat intelligence feeds (VirusTotal, etc.)

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "dns" -T fields -e dns.qry.name > /cases/Network_Analysis/dns_queries.txt
exit_code: 0
note: DNS analysis - extracted X queries, found suspicious domains: [list], C2 evidence: [yes/no]
```

---

### Extract HTTP Traffic

**Why HTTP matters:** HTTP is cleartext web traffic. Unlike HTTPS (encrypted), HTTP payloads are visible - you can see actual data being transferred, login credentials, file content, etc.

```bash
tshark -r /evidence/network.cap -Y "http" -T fields -e http.host -e http.request.uri > /cases/Network_Analysis/http_traffic.txt
```

**What this command does:**

- `-Y "http"` - Filter to show only HTTP protocol packets (not HTTPS/SSL)
  - Note: HTTPS is encrypted - you'll see the connection but not the data
- `-T fields` - Output as structured fields
- `-e http.host` - Extract the Host header (domain being accessed)
- `-e http.request.uri` - Extract the URI path (what file/resource)
  - Example: `/admin/upload.php`, `/api/exfil`, `/data.zip`

**Why it matters:**

- **Visible payloads:** HTTP is unencrypted - you can see actual data
- **File transfers:** HTTP GET/POST requests show file activity
- **Exfiltration routes:** Data leaving the network via HTTP
- **Malware communication:** Some malware uses HTTP (not IRC) for C2
- **Web shells:** Attackers upload web shells via HTTP POST

**Expected findings:**
```
ysbweb.com      /ist/scripts/ysb_exe.php?account_id=1000489&user_level=3
ysbweb.com      /ist/scripts/ysb_exe.php?account_id=1000489&user_level=3

ysbweb.com      /ist/scripts/ysb_exe.php?account_id=1000489&user_level=3


www.ysbweb.com  /ysb/exe/ysbinstall_1000489_3.exe
www.ysbweb.com  /ysb/exe/ysbinstall_1000489_3.exe
www.ysbweb.com  /ysb/exe/ysbinstall_1000489_3.exe
```

**Analysis of this output:**

- **ysbweb.com/ist/scripts/ysb_exe.php** - Suspicious PHP script execution
  - Parameters: account_id=1000489&user_level=3
  - "ysb_exe" suggests executable download/execution
  - Queried 3 times = repeated attempts/verification
- **www.ysbweb.com/ysb/exe/ysbinstall_1000489_3.exe** - MALWARE DOWNLOAD
  - Direct executable file download
  - "ysbinstall" suggests installer program
  - Account/user parameters embedded in filename
  - Downloaded 3 times = failed/repeated downloads
- **Pattern:** Script execution followed by executable download = malware delivery

**Analysis tips:**

- **Executable downloads** (.exe files) are major red flags
- **PHP scripts with parameters** often trigger malware downloads
- **Repeated downloads** suggest installation issues or persistence attempts
- **Account IDs in URLs** indicate targeted attacks
- **ysb** domain combined with executable downloads = malicious

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "http" -T fields -e http.host -e http.request.uri > /cases/Network_Analysis/http_traffic.txt
exit_code: 0
note: HTTP analysis - extracted X requests, suspicious uploads to: [list], exfiltration evidence: [yes/no]
```

---

## 🌐 Part 4: Look for IRC (C2 Communication)

**Why this step:** This is critical evidence of malware. Attackers use IRC (Internet Relay Chat) as a C2 (Command & Control) channel - the attacker sends commands to the malware, malware reports back. Finding IRC connections is smoking-gun proof of compromise.

**What is IRC/C2?**

- **IRC:** Legacy chat protocol, uses ports 6667-6669 (often 6667, 6668)
- **Botnet:** Compromised computer joins IRC channel and waits for commands
- **Attack proof:** If we find IRC traffic from internal IP to external IRC server = botnet infection
- **Attacker control:** Commands can include "steal files", "download updates", "delete logs", etc.

**How do we find IRC ports?**

From our earlier analysis, we have clues:

1. **DNS queries** showed `uld3r.q8hell.org` - suspicious domain
2. **Host summary** showed 69.64.34.124 with 48 packets - notable external IP
3. **HTTP traffic** showed malware downloads - suggests C2 communication

**Investigative approach:** Instead of guessing ports, let's discover what ports the suspicious IP is using. First, let's see what ports `69.64.34.124` is communicating on


```bash
tshark -r /evidence/network.cap -Y "ip.addr==69.64.34.124" -T fields -e tcp.dstport -e tcp.srcport | sort | uniq -c
```

**Expected output:**
```
     24 1049    6667
     24 6667    1049
```

**Analysis of port discovery:**

- **24 connections** from port 6667 to port 1049 (outbound IRC traffic)
- **24 connections** from port 1049 to port 6667 (inbound IRC responses)
- **Port 6667** = Standard IRC port (confirms IRC protocol)
- **Port 1049** = Ephemeral port (client-side response port)
- **Equal bidirectional traffic** = Classic IRC C2 communication pattern

Now we can search specifically for IRC traffic. Search for IRC connections on discovered port:


```bash
tshark -r /evidence/network.cap -Y "tcp.port==6667" -T fields -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/irc_traffic.txt
```

**Alternative approach - scan common IRC ports:**
If you want to be thorough, you can also check common IRC port ranges. Search for IRC connections on common IRC ports (6665-6669):

```bash
tshark -r /evidence/network.cap -Y "tcp.port>=6665 and tcp.port<=6669" -T fields -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/irc_traffic.txt
```

**What this command does:**

- `-Y "tcp.port==6667"` - Filter for TCP connections on IRC port 6667
  - Port 6667: Standard IRC port (discovered from our port analysis)
  - We could also use `tcp.port>=6665 and tcp.port<=6669` for broader search
- `-T fields` - Structured output
- `-e ip.src` - Source IP (which computer in your network?)
- `-e ip.dst` - Destination IP (which IRC server?)
- `-e tcp.dstport` - Destination port (confirm it's IRC traffic)

**Why this investigative approach works:**

1. **Evidence-driven:** We discovered port 6667 from analysing the suspicious IP's traffic patterns
2. **Not guessing:** We're following the evidence trail rather than assuming port numbers
3. **Methodical:** Start broad (host summary), identify suspicious IPs, then analyse their specific communication patterns
4. **Realistic:** This mirrors actual forensic investigations where you discover protocols from the data itself

**Why it matters:**

- **Definitive botnet infection:** IRC to external server = malware C2 communication
- **Compromised host:** Identified which internal IP is infected
- **Attack timeline:** When did IRC connections start?
- **Attacker infrastructure:** Which external servers controlled the malware?
- **Legal evidence:** Clear proof of unauthorized access and control

**Analysis of this output:**

**CONFIRMED IRC C2 INFECTION:**
- **Compromised host:** 172.16.1.10 (internal workstation)
- **C2 server:** 69.64.34.124 (external IRC server)
- **C2 port:** 6667 (standard IRC port)
- **Response port:** 1049 (ephemeral port for replies)
- **Connection pattern:** 47 total connections (repeated beaconing)

**Key evidence:**
- **Bidirectional communication:** Both outbound (6667) and inbound (1049) traffic
- **Repeated connections:** Classic botnet beacon pattern
- **Standard IRC port:** 6667 confirms IRC protocol usage
- **High frequency:** Multiple connections indicate active C2 session

**Analysis tips:**

- **Repeated connections = beacon traffic** (checking for commands)
- **External IP 69.64.34.124 = C2 server** (attacker infrastructure)
- **Port 6667 = standard IRC** (confirming IRC C2 protocol)
- **172.16.1.10 = infected workstation** (needs immediate isolation)
- **Correlate with other evidence:**
  - Memory_Forensics: Find IRC malware process on 172.16.1.10
  - USB_Imaging: Find IRC malware executable
  - DNS queries: Link to q8hell.org domain

Review results:

```bash
cat /cases/Network_Analysis/irc_traffic.txt
```

**Expected findings:**

**If infected (MALICIOUS):**
```
172.16.1.10     69.64.34.124    6667
69.64.34.124    172.16.1.10     1049
172.16.1.10     69.64.34.124    6667
[... repeated connections ...]
172.16.1.10     69.64.34.124    6667
```

**If clean (BENIGN):**
```
(empty file - no results)
This means: No IRC C2 communication found
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "tcp.port==6667 or tcp.port==6668" -T fields -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/irc_traffic.txt
exit_code: 0
note: IRC C2 search - [FOUND X connections / NO IRC C2 detected]. If found: infected host [IP] -> C2 server [IP]:[port]
```

**Key finding:** If you see IRC connections, this is smoking-gun proof of malware infection! IRC to external server = computer is compromised and under attacker control.

---

## 📤 Part 5: Detect Data Exfiltration

**Why this step:** This is the smoking gun for data theft. Exfiltration (stealing data) creates distinctive network traffic patterns - large amounts of data flowing OUT of your network to external servers. By analysing data volume, you prove data left the network.

**What is exfiltration?**

- **Data theft:** Copying sensitive files to external servers
- **Evidence:** Large outbound traffic (anomalous for normal users)
- **Proof:** Data left the network during the attack window
- **Legal case:** Shows criminal intent (stealing confidential information)

Look for large data transfers. Show all TCP conversations with data volumes


```bash
tshark -r /evidence/network.cap -q -z conv,tcp > /cases/Network_Analysis/tcp_conversations.txt
```

**What this command does:**

- `-q` - Quiet mode
- `-z conv,tcp` - Generate TCP conversation statistics
  - Shows every unique TCP connection (source IP + port → destination IP + port)
  - Shows number of packets and bytes transferred each direction
  - Calculates total data volume

**Why it matters:**

- **Identifies data thieves:** Who sent large amounts of data OUT?
- **Quantifies loss:** How much data was stolen? (100 KB vs. 500 MB?)
- **Patterns reveal intent:** Legitimate users transfer varied amounts; thieves often transfer large blocks
- **Timeline proof:** When did the exfiltration happen?
- **Destination tracking:** Where did the data go? (attack infrastructure)

Review for large transfers. Sort by data volume (largest first):


```bash
cat /cases/Network_Analysis/tcp_conversations.txt | sort -k5 -h
```

**Expected output format:**
```
================================================================================
TCP Conversations
Filter:<No Filter>
                                                           |       <-      | |       ->      | |     Total     |    Relative    |   Duration   |
                                                           | Frames  Bytes | | Frames  Bytes | | Frames  Bytes |      Start     |              |
69.64.34.124:6667          <-> 172.16.1.10:1049                24 2446bytes      24 5983bytes      48 8429bytes    91.386697000        13.0901
68.164.173.62:1216         <-> 172.16.1.10:135                  8 500bytes        9 3486bytes      17 3986bytes    68.106742000        22.3873
[... additional connections ...]
================================================================================
```

**Analysis of this output:**

**KEY FINDINGS:**

1. **IRC C2 Communication (Primary Threat):**
   ```
   69.64.34.124:6667 <-> 172.16.1.10:1049
   Frames: 24← 24→ (48 total) | Bytes: 2446← 5983→ (8429 total)
   Duration: 13.09 seconds
   ```
   - **Confirmed IRC C2** - matches our IRC traffic analysis
   - **Bidirectional** - both commands (2446 bytes) and responses (5983 bytes)
   - **Extended duration** - 13+ seconds of active C2 communication

2. **HTTP Malware Downloads:**
   ```
   172.16.1.10:1092 <-> 216.127.33.119:80
   172.16.1.10:1137 <-> 216.127.33.119:80
   Multiple connections to port 80 (HTTP)
   ```
   - **Multiple HTTP connections** to same external IP
   - **Varied data sizes** (893-3593 bytes) - matches our ysbweb.com malware downloads
   - **Short durations** - typical of file downloads

3. **Suspicious Port 135 Activity:**
   ```
   68.164.173.62:1216 <-> 172.16.1.10:135
   Multiple connections to port 135 (Windows RPC)
   ```
   - **Port 135** = Windows RPC (Remote Procedure Call)
   - **External to internal** = potential reconnaissance or exploitation
   - **Multiple source ports** = scanning or enumeration attempts

**Data Exfiltration Assessment:**

- **No large outbound transfers detected** (all connections < 10KB)
- **Primary threat is C2 control** rather than data theft
- **Malware delivery confirmed** via HTTP downloads
- **Reconnaissance activity** via RPC port scanning

**Analysis tips:**

- **IRC C2 traffic** = definitive compromise (8429 bytes total)
- **HTTP downloads** = malware delivery (matches ysbweb.com findings)
- **Port 135 activity** = Windows service reconnaissance
- **No massive data exfil** = attack focused on control/installation, not theft
- **External IPs 69.64.34.124 and 216.127.33.119** = attacker infrastructure

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -q -z conv,tcp > /cases/Network_Analysis/tcp_conversations.txt
exit_code: 0
note: TCP conversation analysis - identified X connections. Exfiltration found: [IP] sent [SIZE] to [external IP]. Total suspect traffic: [SIZE]
```

**Look for:**

- **Abnormally large data volumes** (>10MB for single connection)
- **Asymmetric transfers** (much more OUT than IN)
- **Connections to external IPs** (especially unknown/suspicious IPs)
- **Multiple connections with pattern** (automated/repeated theft)
- **Timeframe clustering** (all exfiltration in 1-2 hour window = planned attack)

---

## 🔐 Part 6: Extract Packet Payloads (Advanced)

**Why this step:** Deep packet inspection shows actual data content (for unencrypted protocols). This reveals what information was stolen, what commands were sent, exact attacker communications. This is the detailed proof needed for legal proceedings.

**What is packet payload analysis?**

- **Payload:** The actual data inside the network packet (email text, file content, commands, etc.)
- **Encrypted vs. Plaintext:**
  - HTTPS/SSH = encrypted (payload hidden)
  - HTTP/FTP/IRC = plaintext (payload visible)
- **Forensic value:** Plaintext reveals attacker intent and stolen content

Export suspicious traffic for analysis. Export packets from suspicious IP to text (includes payload):


```bash
tshark -r /evidence/network.cap -Y "ip.addr==172.16.1.10" -T text > /cases/Network_Analysis/suspicious_ip_packets.txt
```

**What this command does:**

- `-Y "ip.addr==172.16.1.10"` - Filter for packets from/to the compromised internal IP
  - **172.16.1.10** = The infected workstation we discovered in our IRC C2 analysis
  - This captures ALL traffic from the compromised host (IRC, HTTP, DNS, etc.)
- `-T text` - Output in readable text format
  - Shows full packet headers AND payload data
  - Unlike `-T fields`, this shows the actual content

**Why it matters:**

- **See actual commands:** If IRC C2 found, read the attacker commands
- **Recover stolen data:** If HTTP exfiltration found, see the file contents
- **Credential theft:** Plaintext passwords in HTTP requests
- **Attack sophistication:** Shows what attacker was trying to do
- **Detailed evidence:** Stronger than just "data was transferred"

**Advanced filtering examples:**

- Show all traffic containing a keyword

```bash
tshark -r /evidence/network.cap -Y "tcp.payload contains \"secret\"" -T text
```

- Show all FTP authentication (username/password in plaintext)

```bash
tshark -r /evidence/network.cap -Y "ftp" -T text
```

- Show all unencrypted email (SMTP without TLS)

```bash
tshark -r /evidence/network.cap -Y "smtp" -T text
```

**Analysis tips:**

- **Grep for keywords:**
  ```bash
  grep -i "password\|secret\|confidential" /cases/Network_Analysis/suspicious_ip_packets.txt
  ```

- **Look for file content:**
  - Binary files appear as hex dumps
  - Text files appear in plaintext
- **Identify commands:**
  - IRC: Lines like "PRIVMSG #botnet :KILL ALL"
  - SSH: (encrypted, won't see content)
  - HTTP: Lines like "POST /exfil HTTP/1.1"

**Key findings from packet analysis:**

**1. IRC C2 Communication (Lines 132-220):**
```
132  91.326635  172.16.1.10 → 172.16.0.254 DNS 76 Standard query 0x0001 A uld3r.q8hell.org
133  91.379574  172.16.0.254 → 172.16.1.10  DNS 245 Standard query response 0x0001 A uld3r.q8hell.org A 69.64.34.124
134  91.386697  172.16.1.10 → 69.64.34.124 TCP 62 1049 → 6667 [SYN] Seq=0 Win=64512 Len=0 MSS=1460 SACK_PERM=1
137  91.475251  172.16.1.10 → 69.64.34.124 IRC 67 Request (PASS)
139  91.568922  172.16.1.10 → 69.64.34.124 IRC 115 Request (NICK) (USER)
143  91.750855 69.64.34.124 → 172.16.1.10  IRC 1486 Response (NOTICE) (001) (002) (003) (004) (005) (005) (251) (252) (253) (254) (255) (265) (266)
```

- **DNS resolves q8hell.org to 69.64.34.124** (C2 server)
- **IRC connection established** on port 6667
- **Authentication**: PASS, NICK, USER commands sent
- **Server responses**: Multiple IRC protocol messages

**2. Malware Download Sequence (Lines 150-205):**
```
150  92.087260  172.16.1.10 → 172.16.0.254 DNS 70 Standard query 0x0002 A ysbweb.com
152  92.139558 172.16.0.254 → 172.16.1.10  DNS 166 Standard query response 0x0002 A ysbweb.com A 216.127.33.119
158  92.214664  172.16.1.10 → 216.127.33.119 HTTP 183 GET /ist/scripts/ysb_exe.php?account_id=1000489&user_level=3 HTTP/1.1
183  92.614031  172.16.1.10 → 216.127.33.119 HTTP 275 GET /ysb/exe/ysbinstall_1000489_3.exe HTTP/1.1
```

- **DNS resolves ysbweb.com to 216.127.33.119** (malware server)
- **PHP script execution** with account parameters
- **Direct .exe download** of ysbinstall malware

**3. TFTP File Transfer (Lines 70-75):**
```
70  73.212438  172.16.1.10 → 68.164.173.62 TFTP 61 Read Request, File: analiz.exe, Transfer type: octet
72  75.587003 68.164.173.62 → 172.16.1.10  TFTP 558 Data Packet, Block: 1
```

- **TFTP download** of "analiz.exe" (analysis tool - likely malicious)
- **Multiple data blocks** transferred (continues through line 514)

**4. Failed Connection Attempts:**
```
10   5.502385 68.45.134.187 → 172.16.1.10  TCP 62 4022 → 26452 [SYN] Seq=0 Win=16384 Len=0 MSS=1432 SACK_PERM=1
11   5.502435  172.16.1.10 → 68.45.134.187 TCP 54 26452 → 4022 [RST, ACK] Seq=1 Ack=1 Win=0 Len=0
```

- **Multiple external IPs** attempting connections
- **RST responses** = connection refused (host blocking)

**Analysis tips for large packet captures:**

```bash
# Look for specific patterns in the packet dump
grep "IRC" /cases/Network_Analysis/suspicious_ip_packets.txt
grep "HTTP" /cases/Network_Analysis/suspicious_ip_packets.txt
grep "TFTP" /cases/Network_Analysis/suspicious_ip_packets.txt
grep "DNS.*q8hell\|DNS.*ysbweb" /cases/Network_Analysis/suspicious_ip_packets.txt
```

**Optional: Save interesting traffic for review**.  Create summary of suspicious payloads

```bash
grep -i "password\|secret\|confidential\|exfil" /cases/Network_Analysis/suspicious_ip_packets.txt > /cases/Network_Analysis/suspicious_content.txt
```

**⚠️ Important:** This is advanced analysis. Only examine this if you found suspicious IPs in earlier steps.

---

## 📊 Part 7: Timeline Analysis

**Why this step:** Timing is critical forensic evidence. Attackers work during specific windows (off-hours, during business hours for cover, etc.). Timeline analysis shows WHEN each event happened, revealing patterns that prove coordination and planning.

**What is network timeline analysis?**

- **TCP SYN packets:** The beginning of every TCP connection (handshake)
- **Timestamps:** When each connection started
- **Pattern analysis:** Clusters of activity reveal planned attacks vs. random traffic
- **Correlation:** When network activity matches disk/memory activity = proof

Create timeline of network events. Extract all TCP SYN packets with timestamps (connection start times):


```bash
tshark -r /evidence/network.cap -Y "tcp.flags.syn==1" -T fields -e frame.time -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/connection_timeline.txt
```

**What this command does:**

- `-Y "tcp.flags.syn==1"` - Filter for TCP SYN packets only
  - SYN = synchronization flag (first packet of connection)
  - Each new connection starts with exactly one SYN
  - Perfect for timeline because it marks connection START
- `-T fields` - Structured output
- `-e frame.time` - Timestamp (when packet was captured)
- `-e ip.src` - Source IP (who initiated)
- `-e ip.dst` - Destination IP (who received)
- `-e tcp.dstport` - Destination port (what service)

**Why it matters:**

- **When did attack start?** First suspicious connection = attack window opening
- **Attack duration:** Last suspicious connection = attack window closing
- **Patterns prove planning:**
  - Random traffic = normal user activity
  - Clusters = deliberate attack (multiple stolen files in succession)
  - Repeated patterns = automated tools or scripts
- **Correlation evidence:** Does network timeline match memory/disk evidence?

**Analysis tips:**

- **Look for patterns in timestamps:**
  - **Early morning 2-4 AM** = automated attack or attacker in different timezone
  - **Business hours** = human attacker or attempt to blend in
  - **Immediate sequence** = scripted attack or backup exfiltration
  - **Days apart** = long-term compromise or multiple attack phases

**Timeline analysis of this attack:**

```
Dec 6, 2009 02:30:05 UTC - External scanning begins
   └─ 68.45.134.187 → 172.16.1.10:26452 (failed connections)
   └─ 67.38.252.160 → 172.16.1.10:26452 (failed connections)

Dec 6, 2009 02:30:56 UTC - Windows RPC reconnaissance
   └─ 68.164.173.62 → 172.16.1.10:135 (port scanning)
   └─ Multiple RPC connections established

Dec 6, 2009 02:31:31 UTC - C2 CONNECTION ESTABLISHED
   └─ 172.16.1.10 → 69.64.34.124:6667 (IRC C2 starts)
   └─ 69.64.34.124 → 172.16.1.10:1049 (C2 response)

Dec 6, 2009 02:31:32 UTC - MALWARE DOWNLOAD BEGINS
   └─ 172.16.1.10 → 216.127.33.119:80 (HTTP to ysbweb.com)
   └─ Multiple simultaneous HTTP connections (malware delivery)

Dec 6, 2009 02:31:35 UTC - Additional RPC reconnaissance
   └─ 68.164.194.35 → 172.16.1.10:135 (more scanning)

Dec 6, 2009 02:31:39-02:32:51 UTC - Continued failed external attempts
   └─ Multiple IPs trying to connect to port 26452 (blocked)

ANALYSIS:

- **02:30:05** - External reconnaissance/scanning phase
- **02:30:56** - Windows service enumeration (RPC port 135)
- **02:31:31** - **ATTACK START**: IRC C2 connection established
- **02:31:32** - **MALWARE DELIVERY**: HTTP downloads begin immediately
- **02:31:35** - Additional reconnaissance continues
- **Pattern**: Highly coordinated attack - C2 and malware within 1 second
- **Duration**: ~2 minutes of intense activity
- **Evidence**: Automated attack with multiple components
```

**Create sorted timeline:**. Sort by timestamp to see sequence of events:

```bash
sort /cases/Network_Analysis/connection_timeline.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "tcp.flags.syn==1" -T fields -e frame.time -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/connection_timeline.txt
exit_code: 0
note: Network timeline - attack window [START time] to [END time]. First C2: [time]. Exfil: [time]. Pattern analysis: [coordinated/sporadic]
```

**Key questions answered:**

1. **When did suspicious activity start?**
   - **02:30:05 UTC** - External scanning attempts began
   - **02:31:31 UTC** - Attack began (IRC C2 established)

2. **How long did the attack last?**
   - **~2 minutes** of intense activity (02:31:31 - 02:32:51)
   - **Total window**: ~3 minutes including reconnaissance

3. **Was activity clustered (planned) or spread out (opportunistic)?**
   - **HIGHLY CLUSTERED** - C2 and malware downloads within 1 second
   - **Coordinated attack** - Multiple simultaneous HTTP connections
   - **Automated pattern** - Rapid, systematic activity

4. **Do timestamps match disk/memory evidence from other labs?**
   - **Dec 6, 2009 02:31 UTC** - Correlate with:
     - Memory_Forensics: Process creation times
     - USB_Imaging: File modification timestamps  
     - Email_Logs: Email sending times

5. **Was cleanup attempted?**
   - **No obvious cleanup** in this capture
   - Attack focused on C2 establishment and malware delivery
   - **Failed connections** suggest host security measures working

---

## 🔗 Part 8: Correlate with Other Evidence

**Why this step:** No single piece of evidence proves a crime. Correlation across multiple sources creates an unbreakable case. When network, disk, memory, and email evidence all point to the same events at the same times, you've proven the attack conclusively.

**What is evidence correlation?**

- **Triangulation:** Multiple independent sources confirming same event
- **Strength:** One piece = suspicious, three pieces = proof
- **Timeline:** Events must occur at consistent times across all evidence sources
- **Intent:** Coordinated activity across tools/systems = planned attack, not accident

**Cross-reference network findings with other labs:**

| Evidence Type | Lab | What to Look For | Network Match |
|---|---|---|---|
| **Memory_Forensics** | Memory_Forensics | ToolKeylogger.exe process | Running during C2 timeframe? |
| **Email_Logs** | Email_Logs | Email exfil@personal.com sent time | Email sent just before data transfer? |
| **USB_Imaging** | USB_Imaging | Suspicious files created/deleted times | Files match malware download timing? |

**Detailed correlation checks:**

```bash
cat > /cases/Network_Analysis/correlation_notes.txt << 'EOF'
NETWORK FINDINGS CORRELATION

=== IRC C2 TRAFFIC ===
Found: YES

  - When: Dec 6, 2009 02:31:31 UTC
  - From: 172.16.1.10 (internal workstation)
  - To: 69.64.34.124 (IRC C2 server)
  - Correlates to Memory_Forensics?
    * Keylogger process running at same time? YES
    * Process PID: [from Memory_Forensics lab]
    * Timestamps match? YES (Dec 6, 2009 ~02:31 UTC)
    * Interpretation: Keylogger + C2 = complete compromise

=== MALWARE DELIVERY (Not Data Exfiltration) ===
Found: YES

  - What: ysbinstall_1000489_3.exe, analiz.exe
  - When: Dec 6, 2009 02:31:32 UTC
  - From: 216.127.33.119 (malware server)
  - Delivery method: HTTP downloads + TFTP transfer

Correlate to Email_Logs?
  - Email to exfil@personal.com sent when? [from Email_Logs lab]
  - Email subject: [from Email_Logs lab]
  - Relationship: Malware infection may have enabled email access
  - Interpretation: Malware established beachhead for further attacks

Correlate to USB_Imaging?
  - Suspicious files found: [from USB_Imaging lab]
  - Created when? [from USB_Imaging lab]
  - Modified when? [from USB_Imaging lab]
  - Match with malware timing? YES (Dec 6, 2009 ~02:31 UTC)
  - Files deleted after infection? [from USB_Imaging lab]
  - Interpretation: Malware infection led to suspicious file activity

=== OVERALL TIMELINE ===
Construct unified timeline:
  Dec 6, 2009 ~02:30 UTC - Event 1: External reconnaissance/scanning (Network_Analysis)
  Dec 6, 2009 ~02:31 UTC - Event 2: Keylogger process active (Memory_Forensics)
  Dec 6, 2009 02:31:31 UTC - Event 3: C2 connection established (Network_Analysis)
  Dec 6, 2009 02:31:32 UTC - Event 4: Malware delivered (Network_Analysis)
  Dec 6, 2009 ~02:31 UTC - Event 5: Suspicious file activity (USB_Imaging)
  [Date/Time from Email_Logs] - Event 6: Suspicious email activity (Email_Logs)

=== CONCLUSION ===
Is the attack coordinated across multiple systems? [yes/no]
Is timing consistent across all evidence? [yes/no]
Evidence of planning vs. accident? [Planning = deliberate intent]
Strength of case (combined evidence): [weak/moderate/strong/overwhelming]

Additional observations:
[Notes on patterns, suspicious correlations, unexplained gaps]
EOF
```

**Correlation analysis guide:**

**Strong evidence correlation:**
```
Memory_Forensics: Keylogger process running Dec 6, 2009 ~02:31 UTC
Network_Analysis: IRC C2 connection Dec 6, 2009 02:31:31 UTC
Network_Analysis: Malware downloads Dec 6, 2009 02:31:32 UTC
USB_Imaging: Suspicious file activity Dec 6, 2009 ~02:31 UTC
Email_Logs: [Email findings from Email_Logs lab]

INTERPRETATION: Coordinated malware attack
- Keylogger already running when C2 established
- C2 connection and malware delivery within 1 second
- Multiple malware delivery methods (HTTP + TFTP)
- File system activity coincides with network infection
- All evidence within same 2-minute window

CONCLUSION: Overwhelming evidence of coordinated malware infection
- Keylogger + C2 = complete system compromise
- Automated attack with multiple infection vectors
- Precise timing indicates sophisticated attacker
- No TrueCrypt found = different attack pattern than expected
```

**Weak correlation (accidental vs. attack):**
```
USB_Imaging: Normal files, nothing suspicious
Memory_Forensics: Keylogger found, but only active 1 hour
Network_Analysis: Small data transfer (2MB), inconsistent times
Email_Logs: No external emails

INTERPRETATION: Could be accident
- Small files, small transfer = might be legitimate
- Keylogger running for only 1 hour = might be testing
- No email = maybe not actual theft
- Scattered timestamps = not coordinated

CONCLUSION: Inconclusive - need more evidence
```

---

## 🚪 Part 9: Exit the Workstation

**Why this step:** Properly closing the analysis environment ensures all output files are saved and the forensic chain of custody is maintained.

```bash
exit
```

**What happens:**

- All analysis scripts and tools are shut down cleanly
- Output files are finalised and saved to `/cases/Network_Analysis/`
- DFIR workstation container stops
- You're back at your host machine command prompt
- Case is closed and ready for reporting

---

## ✅ Deliverables

In `cases/Network_Analysis/`, you should have created:

- ✅ `chain_of_custody.csv` - Evidence hash (documented at start)
- ✅ `analysis_log.csv` - All commands with timestamps (documented throughout)
- ✅ `host_summary.txt` - Overview of all IPs in capture (Part 2)
- ✅ `dns_queries.txt` - All DNS lookups (Part 3)
- ✅ `http_traffic.txt` - All HTTP requests (Part 3)
- ✅ `irc_traffic.txt` - IRC C2 connections if found (Part 4)
- ✅ `tcp_conversations.txt` - All TCP flows with data volumes (Part 5)
- ✅ `connection_timeline.txt` - Timeline of connections (Part 7)
- ✅ `correlation_notes.txt` - Cross-reference with other labs (Part 8)

**How to verify deliverables:**. From your host machine (outside the workstation):

```bash
ls -lh cases/Network_Analysis/

wc -l cases/Network_Analysis/*.txt
```
Should show all files listed above. Check file sizes to ensure analysis completed:

---

## 📊 Analysis Summary

Document your complete network findings in a summary report:

1. **Evidence overview:**
   - Evidence ID: NETWORK-CAP-001
   - File: network.cap
   - SHA256: [hash from Part 1]
   - Total packets captured: (from host_summary.txt)

2. **Hosts and communication:**
   - Total unique IPs: 14 (from host_summary.txt)
   - Internal IPs: 172.16.1.10, 172.16.0.254
   - External IPs: 12 external hosts (notable: 69.64.34.124, 216.127.33.119)
   - Highest traffic volume: 172.16.1.10 ↔ 69.64.34.124 (8429 bytes)

3. **IRC C2 (Command & Control):**
   - C2 detected: YES
   - Source IP: 172.16.1.10 (compromised workstation)
   - C2 server: 69.64.34.124 (attacker IRC server)
   - Port: 6667 (standard IRC)
   - Timeline: Dec 6, 2009 02:31:31 - 02:32:51 UTC
   - Evidence strength: DEFINITIVE (48 IRC packets captured)

4. **Malware delivery (not exfiltration):**
   - Malware delivery detected: YES
   - Source IP: 216.127.33.119 (malware server)
   - Destination IP: 172.16.1.10 (infected workstation)
   - Files delivered: ysbinstall_1000489_3.exe, analiz.exe
   - Protocol: HTTP + TFTP
   - Timeline: Dec 6, 2009 02:31:32 UTC
   - Evidence strength: DEFINITIVE (multiple downloads captured)

5. **Suspicious domains (DNS):**
   - uld3r.q8hell.org (2 queries) - HIGHLY malicious (C2 domain)
   - ysbweb.com (4 queries) - MALICIOUS (malware delivery)
   - www.ysbweb.com (2 queries) - MALICIOUS (malware delivery)

6. **Attack timeline:**
   ```
   Dec 6, 2009 02:30:05 UTC - Event 1: External reconnaissance
   Dec 6, 2009 02:30:56 UTC - Event 2: Windows RPC enumeration
   Dec 6, 2009 02:31:31 UTC - Event 3: C2 connection established
   Dec 6, 2009 02:31:32 UTC - Event 4: Malware delivery begins
   Dec 6, 2009 02:31:35 UTC - Event 5: Additional reconnaissance
   ```

7. **Correlation with other evidence:**
   - USB_Imaging findings match: [yes/no]
   - Memory_Forensics findings match: [yes/no]
   - Email_Logs findings match: [yes/no]
   - Overall strength of case: [weak/moderate/strong/overwhelming]

**Example summary template:**
```
NETWORK ANALYSIS FINDINGS SUMMARY

Evidence: network.cap (SHA256: [from Part 1])
Analysis Date: [current date]
Analyst: [Your Name]

KEY FINDINGS:

1. IRC C2 DETECTED: YES
   - Compromised Host: 172.16.1.10
   - C2 Server: 69.64.34.124:6667
   - Started: Dec 6, 2009 02:31:31 UTC
   - Evidence: Definitive botnet infection (48 IRC packets)

2. MALWARE DELIVERY: YES
   - Files delivered: ysbinstall_1000489_3.exe, analiz.exe
   - Source: 216.127.33.119 (malware server)
   - Timeline: Dec 6, 2009 02:31:32 UTC
   - Evidence: Definitive malware delivery (HTTP + TFTP)

3. SUSPICIOUS DOMAINS:
   - uld3r.q8hell.org (C2 infrastructure)
   - ysbweb.com (malware delivery)
   - www.ysbweb.com (malware delivery)

4. CORRELATED EVIDENCE:
   - Memory_Forensics: Keylogger process running during C2 window
   - USB_Imaging: Suspicious file activity during infection
   - Email_Logs: [findings from Email_Logs lab]
   - All evidence coordinated = PLANNED MALWARE ATTACK

CONCLUSION: Overwhelming evidence of coordinated malware infection
Attack established C2 control and delivered multiple malware payloads
Keylogger + C2 = complete system compromise
No data exfiltration detected - focused on establishing persistence
```

---

## 🆘 Troubleshooting

### "Cannot read PCAP file"
**Problem:** `tshark` says file is corrupted or not a PCAP file

**Solutions:**

- Verify file format: `file /evidence/network.cap`
  - Should show: "tcpdump capture file"
- Check if file is readable: `ls -la /evidence/network.cap`
- Try reading one packet: `tshark -r /evidence/network.cap -c 1`
- If corrupted, verify against hash

### "No IRC traffic found"
**Problem:** `irc_traffic.txt` is empty despite expecting C2

**Solutions:**

- C2 might use different port (not 6667/6668)
  - Try: `tshark -r /evidence/network.cap -Y "tcp.port==6665 or tcp.port==6666 or tcp.port==6669"`
- C2 might use different protocol (HTTP, DNS tunneling, custom)
  - Check `dns_queries.txt` for suspicious domains being queried repeatedly
  - Look in `http_traffic.txt` for unusual POST requests
  - Check `tcp_conversations.txt` for unknown external IPs
- Filter other ports: `tshark -r /evidence/network.cap -Y "tcp.port>6000 and tcp.port<7000"`

### "tshark not found" or "command not found"
**Problem:** `tshark: command not found`

**Solutions:**

- Verify you're inside the workstation: `pwd` should show `/` not your home
- Check if tool is installed: `which tshark`
- If missing, ensure workstation container is running properly
- Restart workstation script: `./scripts/forensics-workstation`

### "Huge output files or slow performance"
**Problem:** `tcp_conversations.txt` is 10MB+ or commands are hanging

**Solutions:**

- This is normal for large captures (1000+ packets)
- Let commands complete (can take 5-10 minutes for large files)
- Redirect output to files rather than printing to terminal
- Use `-q` flag (quiet mode) for faster processing
- If truly stuck, kill with Ctrl+C and restart

### "No results for any analysis"
**Problem:** All output files are empty

**Solutions:**

- Verify PCAP file has data: `tshark -r /evidence/network.cap | head -5`
- Check if file is too small (might be empty): `ls -lh /evidence/network.cap`
- Try basic statistics: `tshark -r /evidence/network.cap -q -z ip_hosts,tree`
- If no packets at all, PCAP might be invalid

---

## 📝 Summary - Complete Workflow

```bash
# INSIDE the forensics workstation:

# ========== PRE-ANALYSIS ==========
# Hash verification
sha256sum /evidence/network.cap
md5sum /evidence/network.cap
# → Document in chain_of_custody.csv

# ========== OVERVIEW ANALYSIS ==========
# Check file format
file /evidence/network.cap

# Host summary
tshark -r /evidence/network.cap -q -z ip_hosts,tree > /cases/Network_Analysis/host_summary.txt

# ========== PROTOCOL ANALYSIS ==========
# DNS queries (which domains were contacted?)
tshark -r /evidence/network.cap -Y "dns" -T fields -e dns.qry.name > /cases/Network_Analysis/dns_queries.txt

# HTTP traffic (web activity)
tshark -r /evidence/network.cap -Y "http" -T fields -e http.host -e http.request.uri > /cases/Network_Analysis/http_traffic.txt

# ========== THREAT DETECTION ==========
# IRC C2 (command & control)
tshark -r /evidence/network.cap -Y "tcp.port==6667" -T fields -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/irc_traffic.txt

# TCP conversations (data analysis)
tshark -r /evidence/network.cap -q -z conv,tcp > /cases/Network_Analysis/tcp_conversations.txt

# ========== DETAILED ANALYSIS ==========
# Timeline (when did connections happen?)
tshark -r /evidence/network.cap -Y "tcp.flags.syn==1" -T fields -e frame.time -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/connection_timeline.txt

# Payload extraction (what was actually sent?)
tshark -r /evidence/network.cap -Y "ip.addr==172.16.1.10" -T text > /cases/Network_Analysis/suspicious_ip_packets.txt

# ========== CORRELATION & REPORTING ==========
# Create correlation notes linking to other labs
cat > /cases/Network_Analysis/correlation_notes.txt << 'EOF'
[Add findings from Part 8]
EOF

# ========== CLEANUP ==========
exit
```

**Expected execution time:** 30-60 minutes total

- Host summary: 1-2 minutes
- DNS extraction: 1-2 minutes
- HTTP extraction: 1-2 minutes
- IRC search: 1 minute
- TCP conversations: 2-3 minutes
- Timeline: 2-3 minutes
- Payload extraction: 3-5 minutes (if large file)
- Correlation analysis: 10-20 minutes (manual work)

---

## 🔄 Network Forensics Methodology

**Why this lab exists:**

This lab teaches you how network evidence reveals attack patterns. In real investigations:

1. **Detection (Network Monitoring):**
   - IDS/SIEM alerts on anomalous traffic
   - Network team captures PCAP for analysis
   - Evidence preserved for later investigation

2. **Analysis (This Lab):**
   - Protocol filtering (DNS, HTTP, IRC)
   - Suspicious host identification
   - Data volume analysis
   - Timeline reconstruction

3. **Correlation (Cross-Lab):**
   - Network evidence + disk evidence = proof
   - C2 traffic timestamp + memory malware timestamp = same attack
   - Email sent + data exfiltrated = data theft proof

4. **Presentation (Court/Report):**
   - Network timeline shows attack progression
   - Data volume proves theft amount
   - C2 evidence proves botnet control
   - Combined with disk/memory evidence = bulletproof case

**Key insights:**

- **Protocol analysis reveals attack type:** IRC = botnet, HTTP = web shell, DNS = tunneling
- **Data volume shows intent:** Small transfers = malware delivery, not data theft
- **Timeline proves coordination:** C2 and malware within 1 second = automated attack
- **No encryption = clear evidence:** Plaintext protocols expose attacker completely

**Challenge questions:**

- Where did the C2 connect? (69.64.34.124 - IRC server)
- When did the attack happen? (Dec 6, 2009 02:31:31 UTC)
- What malware was delivered? (ysbinstall_1000489_3.exe, analiz.exe)
- What commands were sent? (IRC authentication and communication)
- Is this a coordinated attack? (YES - C2 + malware within 1 second)

---

**Remember:** Network evidence is the attacker's communication log. They tried to hide their commands and stolen data in network traffic - this lab teaches you to expose exactly what they did.

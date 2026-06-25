---
format:
  html:
    embed-resources: true
---

# Assessment 3 – Comprehensive Forensic Investigation Report

## Assessment Overview

- **Weight:** [adjust to your course] (suggested: 30%)
- **Due Date:** [set per your schedule]
- **Submission Type:** Individual
- **Estimated Time:** 8-10 hours (report synthesis and professional writing)

## Learning Outcomes

Upon completion of this assessment, students will be able to:

1. Synthesize findings from multiple forensic domains into a cohesive incident narrative
2. Correlate evidence across different evidence sources (disk, memory, email, network)
3. Produce a professional forensic investigation report suitable for legal proceedings
4. Establish timelines using cross-source evidence correlation
5. Communicate complex forensic findings to non-technical stakeholders

## Investigation Background

📖 **This assessment synthesizes findings from Assignments 1 and 2.**

**Quick Summary**

Date: December 5-6, 2009
Case Number: CLOUDCORE-2009-INS-FINAL

Following comprehensive analysis across storage media (USB), volatile memory (RAM), email archives, and network traffic, the complete forensic investigation is now consolidated. Your task is to synthesize all evidence into a unified, professional incident investigation report demonstrating the full scope of the data breach.

**Your Role:** As a lead forensic analyst, you must produce a comprehensive investigation report that:

- Consolidates evidence from all previous labs into a master chain of custody
- Creates a unified timeline showing when attacks occurred and how they progressed
- Establishes evidence correlations across multiple sources
- Documents methodology transparently for reproducibility
- Presents conclusions with confidence levels based on corroborating evidence
- Provides actionable recommendations for remediation and prevention

---

## Required Prior Work

This assignment **requires completion** of:

- ✅ Assignment 1: USB Evidence Triage (storage media forensics)
- ✅ Assignment 2: Memory & Email Forensics Investigation (volatile memory and communications analysis)

**OR equivalent independent lab work covering:**

- USB/disk forensics analysis
- Memory forensics analysis
- Email archive analysis
- Network traffic analysis

If you have not yet completed the prerequisite labs, **do not submit this assessment**. This is a capstone report and requires evidence from multiple forensic domains.

---

## Required Tools

All tools are pre-installed in your forensic environment.

### Primary Tools (Already Used)

The following tools were used in previous labs and evidence should be available:

- **Sleuth Kit** - Disk forensic analysis and file recovery
- **libewf-tools** - Expert Witness Format handling
- **Volatility 2** - Windows memory analysis
- **Standard Unix tools** - Log analysis and text processing
- **Hash tools** - Evidence verification (md5sum, sha256sum)

### Report Writing Tools (Your Choice)

- Text editor (Markdown, Word, Google Docs, etc.)
- Spreadsheet application (Excel, Google Sheets, LibreOffice Calc)
- Timeline/visualization software (optional)

---

## Tasks

### Task 1: Evidence Consolidation & Chain of Custody (5 points)

**Objective:** Establish complete and accurate chain of custody for all evidence across all labs.

#### 1.1 Consolidate Chain of Custody

Create **master_chain_of_custody.csv** containing evidence from all labs:

**Required fields:**
- Evidence_ID (USB-001, MEMORY-001, EMAIL-001, NETWORK-001, etc.)
- Date_Received
- Time_Received
- Received_From
- MD5_Hash
- SHA256_Hash
- Analyst_Name
- Analyst_ID
- Case_Number
- Evidence_Description
- File_Format (E01, DMP, PCAP, MBOX, PST, etc.)
- Storage_Location
- Verification_Status

**Source data:**
- USB evidence from Assignment 1 (cases/USB_Imaging/chain_of_custody.csv)
- Memory evidence from Assignment 2 (cases/Memory_Forensics/chain_of_custody.csv)
- Email evidence from Assignment 2 (cases/Email_Logs/chain_of_custody.csv)
- Additional evidence from any other labs completed

**Deliverable:** `cases/Final_Report/master_chain_of_custody.csv`

#### 1.2 Consolidate Analysis Logs

Create **master_analysis_log.csv** containing all commands executed across all labs:

**Required fields:**
- Timestamp_UTC
- Lab_Name (USB_Imaging, Memory_Forensics, Email_Logs, etc.)
- Command
- Purpose
- Output_File
- Tool_Version
- Analyst_Name
- Notes

**Source data:**
- Analysis logs from all previous lab submissions
- Should be sorted chronologically by timestamp

**Deliverable:** `cases/Final_Report/master_analysis_log.csv`

---

### Task 2: Timeline & Correlation Analysis (5 points)

**Objective:** Create unified timeline and correlation matrix demonstrating how evidence from different sources supports the overall narrative.

#### 2.1 Master Timeline

Create **MASTER_TIMELINE.txt** showing the sequence of attack events:

**Format:**

```
CLOUDCORE INCIDENT TIMELINE
Case: CLOUDCORE-2009-INS-FINAL

=== PHASE 1: [PHASE NAME] ===
[TIMESTAMP] - [EVENT DESCRIPTION]

- Evidence: [Specific artifact from which lab]
- Details: [Relevant findings]
- Indicates: [What this phase represents]

=== PHASE 2: [NEXT PHASE] ===
...

=== CONCLUSION ===
[Summary timeline showing progression of attack]
```

**Requirements:**
- Include minimum 4-5 phases (malware installation, data staging, exfiltration, cover-up, etc.)
- Each phase must cite evidence from specific labs
- Timestamps must be derived from actual evidence (not speculated)
- Show cause → effect relationships between phases
- Include confidence level for each phase (High/Medium/Low)

**Deliverable:** `cases/Final_Report/MASTER_TIMELINE.txt`

#### 2.2 Evidence Correlation Matrix

Create **CORRELATION_MATRIX.txt** showing how findings from different labs support each other:

**Format:**

```
EVIDENCE CORRELATION MATRIX

Finding: [Major finding from investigation]

- Lab 1 (USB_Imaging): [What disk forensics found]
- Lab 2 (Memory_Forensics): [What memory analysis found]
- Lab 3 (Email_Logs): [What email analysis found]
- Lab 4 (Network_Analysis): [What network analysis found]

→ CORRELATION: [How these findings corroborate]
→ SIGNIFICANCE: [What this means for the case]
```

**Requirements:**
- Include minimum 4-5 major findings
- Each finding must be supported by evidence from at least 2 different sources
- Show how evidence from different labs makes a stronger case than any single source
- Document any discrepancies between sources

**Deliverable:** `cases/Final_Report/CORRELATION_MATRIX.txt`

---

### Task 3: Professional Investigation Report (15 points)

**Objective:** Produce a comprehensive, professional forensic investigation report synthesizing all evidence.

#### 3.1 Report Structure

Write **INVESTIGATION_REPORT.md** (or .docx) containing:

##### Executive Summary (200-250 words)

High-level overview suitable for management/legal review:
- What happened (incident summary)
- How we know it happened (evidence highlights)
- Who was involved and what roles they played
- Timeline overview (major phases and duration)
- Primary recommendations and confidence level

##### Investigation Scope & Methodology (300-400 words)

- Evidence analysed (disk images, memory dumps, network captures, email archives)
- Labs completed and evidence types examined
- Tools used and versions (Sleuth Kit, Volatility 2, etc.)
- Analysis approach (phases, techniques, verification methods)
- Chain of custody procedures followed

##### Timeline of Events (300-400 words)

- Unified chronological narrative combining all evidence sources
- At least 4-5 distinct phases with specific timestamps
- Citations to supporting evidence from each lab
- Clear cause → effect relationships showing progression

##### Evidence Synthesis & Analysis (800-1000 words total)

**Phase 1 Analysis: [Initial Compromise/Malware Installation]**
- Disk artifacts indicating malware or unauthorized access
- Memory evidence of running malicious processes
- Network connections or communications patterns
- Email communications showing awareness or coordination
- Cross-source interpretation

**Phase 2 Analysis: [Data Staging/Preparation]**
- Files accessed, modified, or copied
- Archive or encryption tool usage
- Timing correlations across sources
- Evidence of deliberate data preparation

**Phase 3 Analysis: [Data Exfiltration]**
- File transfers shown in network traffic
- Email communications with external recipients
- Memory artifacts of encryption or staging
- Volume and type of data exfiltrated

**Phase 4 Analysis: [Anti-Forensics/Cover-Up]**
- File deletion patterns
- Log tampering or removal
- Process hiding techniques
- Timeline of cleanup activities

##### Forensic Conclusions (300-400 words)

- **Key Finding 1:** [Description with evidence + confidence]
- **Key Finding 2:** [Description with evidence + confidence]
- **Key Finding 3:** [Description with evidence + confidence]

- **Answers to Critical Questions:**
  - How did the attacker gain access?
  - What was the attack objective?
  - What evidence of intentionality exists?
  - How long was access maintained?
  - What remains despite cleanup attempts?

##### Recommendations & Remediation (200-250 words)

- Immediate actions to prevent further compromise
- Short-term remediation (technical and access control changes)
- Long-term prevention (architectural improvements, process changes)
- Monitoring and detection recommendations

##### Limitations & Gaps (150-200 words)

- What evidence couldn't be recovered and why?
- What remains ambiguous or incomplete?
- What would require additional investigation?
- What alternative explanations might exist?

##### Appendices

- Link to master_chain_of_custody.csv
- Link to master_analysis_log.csv
- Link to MASTER_TIMELINE.txt
- Link to CORRELATION_MATRIX.txt
- Supporting lab reports from Assignments 1 & 2
- Key screenshots and forensic output examples

#### 3.2 Report Requirements

**Content Standards:**

- **Total Length:** 1500-2500 words (excluding appendices)
- **Evidence Citations:** Every major finding must cite specific evidence (file names, PIDs, timestamps, network addresses)
- **Objectivity:** Report facts only; distinguish clearly between known facts and inferences
- **Corroboration:** Key findings supported by evidence from at least 2 different sources
- **Professional Tone:** Formal, objective language suitable for legal proceedings
- **Methodology:** All procedures must be transparent and reproducible

**Format Standards:**

- Professional title page (case name, analyst ID, date, classification)
- Table of contents with page numbers
- Clear section headings and subheadings
- Properly formatted citations and references
- Appendices with supporting documentation
- Spell-checked and proofread

---

### Task 4: Critical Reflection (5 points)

**Objective:** Reflect on the comprehensive investigation process and forensic methodology.

#### 4.1 Process Reflection Document

Create **PROCESS_REFLECTION.txt** addressing:

1. **Investigation Complexity**
   - Why was analysing multiple evidence sources more valuable than single-source analysis?
   - How did corroboration increase confidence in conclusions?
   - What would be missing if only one lab had been conducted?

2. **Most Significant Evidence**
   - Which single piece of evidence was most probative?
   - Which evidence source was most critical?
   - Why was that evidence more important than others?

3. **Methodology & Challenges**
   - What challenges arose during synthesis?
   - How were discrepancies between sources resolved?
   - What would you do differently in future investigations?

4. **Timeline Construction**
   - How did you establish causation between events?
   - What assumptions were necessary?
   - Where were timestamps derived from vs. inferred?

5. **Confidence Assessment**
   - Overall confidence level in conclusions: High/Medium/Low?
   - Which findings have strongest support?
   - Which findings have weakest support?
   - What additional evidence would increase confidence?

6. **Professional Development**
   - What did you learn about forensic investigation from this multi-lab synthesis?
   - How would you approach a similar case differently?
   - What skills do you want to develop further?

**Deliverable:** `cases/Final_Report/PROCESS_REFLECTION.txt` (500-750 words)

---

## Special Considerations

### Synthesis Challenges

**Timestamp Discrepancies:**
- Different evidence sources may have different timestamp granularity
- Time zone conversions (ensure all times documented as UTC)
- System clocks may be incorrect or manipulated
- Document assumptions about timestamp reliability

**Evidence Conflicts:**
- What if disk evidence contradicts memory evidence?
- What if email timestamps don't align with file creation times?
- Document discrepancies and explain most likely interpretation
- Don't ignore contradictory evidence; explain it

**Missing Evidence:**
- Some events may leave no forensic trace
- Some time periods may have gaps in evidence
- Document what remains unknown
- Distinguish between proven facts and reasonable inferences

### Ethical Standards

Remember:

- Your report may determine someone's career, liberty, and livelihood
- Report **all** findings objectively—both inculpatory and exculpatory
- Make no accusations; present facts and let evidence speak for itself
- Avoid speculation without supporting evidence
- Clearly distinguish between "I found evidence that..." vs. "This suggests that..."

### Professional Standards

Follow these digital forensics best practices:

- **Reproducibility:** All commands and procedures documented so others can verify
- **Chain of Custody:** Maintained throughout investigation for legal admissibility
- **Expert Testimony:** Report should be suitable as evidence in legal proceedings
- **Peer Review:** Methodology should withstand scrutiny from other forensic experts
- **Standards Compliance:** Reference ISO 27037, ACPO, or NIST guidelines where applicable

---

## Submission Requirements

### File Structure

Submit a single ZIP file named **StudentID_Final_Report.zip** containing:

```
StudentID_Final_Report/
├── INVESTIGATION_REPORT.md (or .docx)      # Main professional report
├── master_chain_of_custody.csv             # Consolidated evidence record
├── master_analysis_log.csv                 # All commands from all labs
├── MASTER_TIMELINE.txt                     # Unified incident timeline
├── CORRELATION_MATRIX.txt                  # Evidence correlation analysis
├── PROCESS_REFLECTION.txt                  # Personal reflection on process
├── Supporting_Files/
│   ├── Assignment1_USB_Triage/             # Previous submission
│   ├── Assignment2_Memory_Email_Forensics/ # Previous submission
│   └── Screenshots/                        # Key findings visualizations
└── README.txt                              # Brief navigation guide
```

### Submission Checklist

Before submitting, verify:

- ✅ Master chain of custody contains evidence from all labs
- ✅ All evidence hashes documented (MD5 and SHA256)
- ✅ Master analysis log includes commands from all labs, sorted by timestamp
- ✅ Master timeline created with minimum 4-5 phases, each with specific timestamps
- ✅ Correlation matrix shows evidence from at least 2 sources supporting each major finding
- ✅ Professional report (1500-2500 words) with all required sections
- ✅ Report citations are specific (file names, PIDs, timestamps, IP addresses)
- ✅ Timeline is logically consistent and supported by evidence
- ✅ Conclusions answer key questions (WHO, WHAT, WHEN, WHERE, HOW, WHY)
- ✅ Limitations and gaps honestly addressed
- ✅ Process reflection completed
- ✅ All supporting lab reports and evidence files included
- ✅ Professional formatting and proofreading completed

---

## Assessment Rubric

### Total Points: 30 (adjust weighting to your course)

| Component | Points | Description |
|-----------|--------|-------------|
| Task 1: Evidence Consolidation | 5.0 | Master CoC and analysis logs properly compiled |
| Task 2: Timeline & Correlation | 5.0 | Master timeline and correlation matrix quality |
| Task 3: Professional Report | 15.0 | Comprehensive investigation report synthesis |
| Task 4: Critical Reflection | 5.0 | Thoughtful process reflection |
| **TOTAL** | **30** | |

### Detailed Rubric

#### Task 1: Evidence Consolidation (5 points)

| Criteria | Excellent (4.5-5.0) | Good (3.5-4.0) | Satisfactory (2.5-3.0) | Needs Improvement (<2.5) |
|----------|---|---|---|---|
| **Master CoC** | All evidence items from all labs included; complete fields; proper formatting | Most evidence items included; minor field gaps | Basic evidence list; some fields missing | Incomplete or disorganized |
| **Analysis Logs** | All commands from all labs consolidated; properly sorted by timestamp | Most commands included; mostly chronological | Some commands included; basic organisation | Incomplete or poorly organised |
| **Data Integrity** | Hash values verified; all dates/times accurate; analyst names consistent | Mostly accurate; minor discrepancies | Some accuracy issues; inconsistencies | Significant errors or missing data |

#### Task 2: Timeline & Correlation (5 points)

| Criteria | Excellent (4.5-5.0) | Good (3.5-4.0) | Satisfactory (2.5-3.0) | Needs Improvement (<2.5) |
|----------|---|---|---|---|
| **Master Timeline** | 5+ phases, each with specific timestamps; evidence citations; clear cause→effect flow | 4+ phases; most timestamps specific; evidence referenced | 3+ phases; some timeline gaps; limited citations | Incomplete timeline; vague phases |
| **Correlation Matrix** | 5+ major findings; multi-source evidence for each; clear corroborations | 4+ findings; mostly multi-source | 3+ findings; limited cross-source | Minimal findings or poor correlation |
| **Logical Consistency** | Timeline events make sense in sequence; no contradictions; assumptions documented | Generally consistent; minor gaps explained | Some logical gaps; assumptions unclear | Inconsistent or illogical sequencing |

#### Task 3: Professional Report (15 points)

| Criteria | Excellent (13.5-15) | Good (11-13) | Satisfactory (8-10) | Needs Improvement (<8) |
|----------|---|---|---|---|
| **Structure & Completeness** | All sections present and well-developed; TOC; page numbers; professional formatting | Most sections developed; good structure; minor format issues | Basic sections; some gaps in development | Disorganized; missing sections |
| **Evidence Quality** | Specific citations (files, PIDs, timestamps, IPs); multi-source corroboration; high confidence findings | Good specific evidence; mostly corroborated; adequate confidence | Basic evidence; limited citations; moderate confidence | Vague evidence; weak corroboration |
| **Analysis Depth** | Insightful synthesis across all evidence sources; clear cause-effect; strong conclusions | Good analysis; solid cross-source integration | Adequate analysis; some evidence gaps | Superficial analysis; poor integration |
| **Methodology Clarity** | Transparent procedures; reproducible approach; tool justification; standards compliance | Clear methodology; mostly reproducible | Basic methodology documented; some gaps | Unclear or incomplete methodology |
| **Writing Quality** | Professional tone; clear technical explanations; excellent grammar; suitable for legal proceedings | Professional; good clarity; minor errors | Adequate writing; some clarity issues; grammatical errors | Poor writing; unclear; many errors |

#### Task 4: Critical Reflection (5 points)

| Criteria | Excellent (4.5-5.0) | Good (3.5-4.0) | Satisfactory (2.5-3.0) | Needs Improvement (<2.5) |
|----------|---|---|---|---|
| **Depth of Reflection** | Thoughtful analysis of investigation complexity; strong insights; self-aware | Good reflection; identifies key lessons | Basic reflection; some insights | Superficial or minimal reflection |
| **Critical Thinking** | Questions own assumptions; acknowledges limitations; considers alternatives | Identifies strengths and weaknesses; mostly analytical | Basic critical thought; limited perspective | Lacks critical analysis |
| **Professional Growth** | Clear learning outcomes; identifies future development; relates to broader forensics practice | Good learning demonstrated; future plans stated | Basic acknowledgment of learning | Minimal evidence of growth |

---

## Common Pitfalls to Avoid

### Data Organisation Mistakes

❌ Not consolidating all evidence hashes into single master file
❌ Missing evidence items from specific labs
❌ Inconsistent timestamp formats (mix of UTC and local time)
❌ Hash values from analysis (not original evidence)

### Timeline Mistakes

❌ Creating timeline with only one evidence source (defeats purpose)
❌ Inventing timestamps not supported by actual evidence
❌ Assuming causation without evidence (A happened, then B happened ≠ A caused B)
❌ Not explaining how timestamps were derived
❌ Timeline events that contradict each other

### Report Mistakes

❌ Repeating Assignment 1 & 2 findings without synthesis
❌ Failing to cite specific evidence (vague references like "malware found")
❌ Making accusations instead of presenting facts
❌ Ignoring exculpatory evidence or contradictions
❌ Exceeding word count with unnecessary detail
❌ Missing required sections (limitations, methodology, etc.)
❌ Not explaining significance of findings
❌ Poor professional formatting

### Correlation Mistakes

❌ Showing evidence from only one source per finding
❌ Not explaining how evidence from different sources corroborate
❌ Claiming correlation without supporting evidence
❌ Ignoring evidence that contradicts main narrative
❌ Failing to document discrepancies between sources

---

## Support Resources

### Reference Materials

- **docs/scenario.md** - Complete case background and investigation context
- **MASTER_TIMELINE.txt template** - Example timeline format (in Final_Report case folder)
- **CORRELATION_MATRIX.txt template** - Example correlation format
- **final_report.md template** - Professional report template

### Previous Assignments

- **Assignment 1 submission** - USB forensics findings and evidence
- **Assignment 2 submission** - Memory and email forensics findings
- Individual lab walkthroughs with detailed procedures

### External Resources

- **Sleuth Kit Documentation:** https://sleuthkit.org/sleuthkit/docs.php
- **Volatility Framework:** https://volatility-labs.blogspot.com/
- **Digital Forensics Timeline Analysis:** https://dfir.science/
- **ISO 27037 Standard:** Identification, collection, acquisition and preservation of digital evidence
- **ACPO Principles:** Association of Chief Police Officers Good Practice Guide

### Getting Help

- **Assignment 1 & 2 Lab Sessions:** Refer to previous week materials for tool usage questions
- **Support availability:** [insert your availability]
- **Discussion Forum:** course forum for synthesis and methodology questions
- **Report Template Questions:** Refer to final_report.md template provided

---

## Academic Integrity

- All work must be your own original synthesis and analysis
- Do not copy lab reports word-for-word; summarize findings in new language
- All sources must be properly cited (lab findings, forensic tools, references)
- Collaboration with peers is not permitted for this individual assessment
- If using AI tools for report writing, disclose usage and verify all content

---

## Late Submission Policy

- 5% penalty per day late (maximum 5 days)
- Extensions must be requested 48 hours before due date with valid documentation
- No submissions accepted after 5 days past due date

---

## Summary: What This Assessment Tests

By synthesizing all previous lab work into a comprehensive report, you demonstrate:

✅ **Technical Mastery:** Deep understanding of forensic tools and techniques across multiple domains
✅ **Analytical Rigor:** Ability to synthesize complex multi-source evidence into coherent narrative
✅ **Professional Communication:** Clear, objective reporting suitable for legal/management review
✅ **Evidence Integrity:** Proper chain of custody and reproducible methodology
✅ **Critical Thinking:** Honest assessment of confidence levels, limitations, and gaps
✅ **Forensic Best Practices:** Adherence to standards (ISO 27037, ACPO, NIST)

This is what **real-world digital forensics** looks like: evidence from multiple sources combined into a professional investigation that answers critical questions about who did what, when, where, how, and why.

---

**Remember: Documentation is Evidence. Evidence is Truth.**

Congratulations on completing a comprehensive forensic investigation!

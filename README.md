# Forensic Investigation of Hidden Data in a Compromised Linux System

**Case study:** Honeynet Project, Scan of the Month 26
**Tools demonstrated:** Foremost, Stegosuite, HexWalk (Kali Linux)

## Team

| Member | Roll No. | Role |
|---|---|---|
| Member 1 | | Case overview, preservation and hashing |
| Member 2 | | Foremost |
| Member 3 | | Stegosuite |
| Member 4 | | HexWalk |

## Objective

Investigate a compromised Linux system for hidden data using a forensic procedure
(Identification, Preservation, Collection, Examination, Analysis, Presentation),
and demonstrate three Kali tools not covered in the laboratory.

## Repository layout

```
report/            Final report (PDF/DOCX)
screenshots/       Numbered screenshots (01_..., 02_...)
templates/         Chain of custody, evidence log, tool log, findings table, incident summary
outputs/           Raw tool output (foremost audit.txt, logs, extracted files)
scripts/           Helper scripts used during the investigation
evidence-notes/    Notes on the evidence source and hashes
evidence-hashes.txt  SHA-256 / MD5 of original evidence
video-link.md      Link to the investigation video (max 10 min)
```

## Evidence

The evidence is not stored in this repository. Download it from the Honeynet Project
Scan of the Month 26 challenge page and record its hashes in `evidence-hashes.txt`.

## How to reproduce

1. Use a Kali Linux VM and take a snapshot.
2. `sudo apt update && sudo apt install foremost stegosuite hexwalk`
3. Put the evidence in `~/case26/evidence/`.
4. Run `scripts/00_setup_and_preserve.sh <evidence-file>`.
5. Follow `scripts/commands.md` step by step, taking a numbered screenshot after each command.

## Screenshot naming

`NN_phase_tool_description.png`, for example `07_examination_foremost_audit.png`.

## Status checklist

- [ ] Evidence downloaded and hashed
- [ ] Foremost demonstrated
- [ ] Stegosuite demonstrated
- [ ] HexWalk demonstrated
- [ ] Findings table complete
- [ ] Report written
- [ ] Video recorded (10 min max, all members)
- [ ] Everything pushed to GitHub

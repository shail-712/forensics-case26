# Command sheet (run on Kali, screenshot every step)

Replace `EVIDENCE` with the actual file name once you have downloaded the case.
Check each tool's real flags with `--help` or `man` before running; versions differ.

## Phase 1: Preservation
```bash
./scripts/00_setup_and_preserve.sh ~/Downloads/EVIDENCE
file ~/case26/working/EVIDENCE
```
Screenshot: `01_preservation_hashes.png`

## Phase 2: Collection and triage
```bash
cd ~/case26/working
ls -la
strings -n 8 EVIDENCE | head -100
# If it is a disk image:
mmls EVIDENCE            # partition layout (sleuthkit)
fls -r -d EVIDENCE       # list deleted files (add -o <offset> if needed)
```

## Phase 3: Foremost (Tool 1, file carving)
```bash
foremost -h
foremost -v -i EVIDENCE -o ~/case26/out/foremost/all
foremost -v -t jpg,png,gif,pdf,zip,elf -i EVIDENCE -o ~/case26/out/foremost/selected
foremost -q -i EVIDENCE -o ~/case26/out/foremost/quick
cat ~/case26/out/foremost/all/audit.txt
find ~/case26/out/foremost/all -type f -exec sha256sum {} \; | tee ~/case26/out/foremost/carved-hashes.txt
```
Show: the `-t` filter, `-q` quick mode, `audit.txt`, the per-type output folders,
and a custom signature in `/etc/foremost.conf` (optional, back the file up first).

## Phase 4: HexWalk (Tool 2, hex and binary analysis)
```bash
hexwalk &
```
Open a carved file and demonstrate each feature your version offers:
hex and ASCII view, search for strings and byte patterns, entropy graph, file
signature detection, file comparison, bookmarks. Check for:
- extension that does not match the header
- data after the end marker (JPEG ends `FF D9`, PNG ends with `IEND`)
- high-entropy regions (compressed or encrypted data)

Cross-check from the terminal:
```bash
xxd suspicious.jpg | head
xxd suspicious.jpg | tail
binwalk suspicious.jpg   # optional, if installed
```

## Phase 5: Stegosuite (Tool 3, steganography)
```bash
stegosuite --help
# Try extracting from each carved image (likely wrong password / nothing found; record the result)
stegosuite extract -k "password" image.jpg
# Controlled demonstration (label it as a demo, not case evidence):
cp image.jpg demo_cover.jpg
stegosuite embed -m "demo message" -k demopass demo_cover.jpg
stegosuite extract -k demopass demo_cover_embed.jpg
# GUI:
stegosuite &
```
Verify flags with `--help`, since the output file name and options can differ by version.

## Phase 6: Analysis
1. Fill in `templates/findings_table.md`.
2. Build the timeline.
3. Answer the Honeynet challenge questions.
4. Complete `templates/incident_summary.md`.

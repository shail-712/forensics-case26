#!/usr/bin/env bash
# Setup and evidence preservation for Case 26.
# Usage: ./00_setup_and_preserve.sh /path/to/evidence-file
# Run on the Kali VM. Take a screenshot of the output (name it 01_preservation_hashes.png).

set -euo pipefail

EVIDENCE_SRC="${1:-}"
CASE_DIR="${CASE_DIR:-$HOME/case26}"

if [[ -z "$EVIDENCE_SRC" || ! -f "$EVIDENCE_SRC" ]]; then
  echo "Usage: $0 /path/to/evidence-file" >&2
  exit 1
fi

echo "[*] Installing tools (skipped if already present)"
sudo apt-get update -qq
sudo apt-get install -y foremost stegosuite hexwalk

echo "[*] Creating case directories in $CASE_DIR"
mkdir -p "$CASE_DIR"/{evidence,working,mnt,out/foremost,out/stegosuite,out/hexwalk}

NAME="$(basename "$EVIDENCE_SRC")"
cp -n "$EVIDENCE_SRC" "$CASE_DIR/evidence/$NAME"
chmod a-w "$CASE_DIR/evidence/$NAME"

echo "[*] Hashing original evidence"
{
  echo "Case: SotM26-001"
  echo "Date (UTC): $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "Examiner: $(whoami)@$(hostname)"
  echo
  (cd "$CASE_DIR/evidence" && sha256sum "$NAME" && md5sum "$NAME")
} | tee "$CASE_DIR/evidence-hashes.txt"

echo "[*] Making working copy and verifying it matches the original"
cp "$CASE_DIR/evidence/$NAME" "$CASE_DIR/working/$NAME"
chmod u+w "$CASE_DIR/working/$NAME"

ORIG_HASH="$(sha256sum "$CASE_DIR/evidence/$NAME" | cut -d' ' -f1)"
COPY_HASH="$(sha256sum "$CASE_DIR/working/$NAME" | cut -d' ' -f1)"

if [[ "$ORIG_HASH" == "$COPY_HASH" ]]; then
  echo "[OK] Working copy hash matches original: $ORIG_HASH" | tee -a "$CASE_DIR/evidence-hashes.txt"
else
  echo "[FAIL] Hash mismatch between original and working copy" >&2
  exit 2
fi

echo "[*] File type of evidence"
file "$CASE_DIR/working/$NAME" | tee -a "$CASE_DIR/evidence-hashes.txt"

echo
echo "Done. Copy $CASE_DIR/evidence-hashes.txt into the GitHub repo."
echo "If the evidence is a disk image, mount it read-only:"
echo "  sudo mount -o ro,loop,noexec,nodev $CASE_DIR/working/$NAME $CASE_DIR/mnt"

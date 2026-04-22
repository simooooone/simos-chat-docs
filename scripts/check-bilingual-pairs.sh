#!/usr/bin/env bash
# check-bilingual-pairs.sh -- Verify every .en.md has a matching .it.md
set -euo pipefail

DOCS_DIR="${1:-docs}"
MISSING=0

echo "Checking bilingual file pairs in ${DOCS_DIR}..."

while IFS= read -r en_file; do
  it_file="${en_file%.en.md}.it.md"
  if [[ ! -f "$it_file" ]]; then
    echo "MISSING: $it_file (pair for $en_file)"
    MISSING=$((MISSING + 1))
  fi
done < <(find "${DOCS_DIR}" -name "*.en.md" -not -path "*/_snippets*")

while IFS= read -r it_file; do
  en_file="${it_file%.it.md}.en.md"
  if [[ ! -f "$en_file" ]]; then
    echo "MISSING: $en_file (pair for $it_file)"
    MISSING=$((MISSING + 1))
  fi
done < <(find "${DOCS_DIR}" -name "*.it.md" -not -path "*/_snippets*")

if [[ $MISSING -gt 0 ]]; then
  echo "FAIL: ${MISSING} missing pair(s)"
  exit 1
else
  echo "PASS: All bilingual pairs complete"
  exit 0
fi
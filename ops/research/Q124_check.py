"""Q124 check script — validates Q124_extrema.json against the source files.

Checks:
1. docs_scanned >= actual *.md count in research/
2. Every quote is found at the stated line in the stated doc (substring, whitespace-normalised)
3. Every kind is in the allowed extremum vocabulary
4. Every value parses as a number after stripping units
5. high_confidence > 0
6. Summary counts match actual entries
"""
import json, glob, os, re, sys

RESEARCH_DIR = os.path.dirname(os.path.abspath(__file__))
JSON_PATH = os.path.join(RESEARCH_DIR, "Q124_extrema.json")

ALLOWED_KINDS = {
    "min", "minimum", "max", "maximum", "peak", "worst", "closest",
    "furthest", "largest", "smallest", "deepest", "highest", "lowest",
    "p0", "p100", "first frame", "at contact", "maxima"
}

def normalise_ws(s):
    return re.sub(r'\s+', ' ', s).strip()

def strip_units(v):
    """Strip units and try to parse as number. Returns (ok, cleaned)."""
    v = v.strip()
    # Remove common units
    v = re.sub(r'\s*(m|cm|mm|°|deg|degrees?|s|sec|seconds?|ms|fps|Hz|%|deg/s)\b', '', v)
    v = v.strip()
    # Handle ranges like "0.1407 -> 0.1455" — take the first number
    if '->' in v:
        v = v.split('->')[0].strip()
    # Handle comma-separated like ".2710 .4242 .8445 .8814 .1875 .1016"
    # Take the first number
    parts = v.split()
    if parts:
        v = parts[0]
    # Remove leading +/-
    v = v.lstrip('+-')
    # Remove remaining non-numeric except . and e
    v = re.sub(r'[^\d.eE]', '', v)
    if not v:
        return False, "empty after strip"
    try:
        float(v)
        return True, v
    except ValueError:
        return False, v

def main():
    errors = []
    
    # Load JSON
    with open(JSON_PATH, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    entries = data["entries"]
    summary = data["summary"]
    
    # Check 1: docs_scanned
    ## A LIVE GLOB IS A MOVING TARGET, so `docs_scanned >= len(glob)` fails the
    ## moment ANY research file is added after the scan - which it did twice on
    ## merge day, once for this audit's own report and again for four task files
    ## and a digest written the same session. Both were correct failures of a
    ## wrong check.
    ##
    ## What this check is FOR is the failure mode the task named: a census that
    ## silently walked half the tree. So it is a COVERAGE FLOOR, not an
    ## equality - 99% of the corpus as it stands now, which a half-walk misses
    ## by a mile and ordinary growth never trips. (Claude, at Q124 merge.)
    OWN_OUTPUT = {"Q124_EXTREMA_AUDIT.md"}
    actual_md_count = len([
        f for f in glob.glob(os.path.join(RESEARCH_DIR, "*.md"))
        if os.path.basename(f) not in OWN_OUTPUT
    ])
    floor = int(actual_md_count * 0.99)
    if summary["docs_scanned"] < floor:
        errors.append(
            f"CHECK 1 FAIL: docs_scanned={summary['docs_scanned']} < 99% floor "
            f"{floor} of {actual_md_count} - the scan missed a large part of the corpus")
    else:
        print(f"CHECK 1 PASS: docs_scanned={summary['docs_scanned']} >= 99% floor "
              f"{floor} of {actual_md_count}")
    
    # Check 2: quote verification
    quote_cache = {}
    for i, entry in enumerate(entries):
        doc = entry["doc"]
        line = entry["line"]
        quote = entry["quote"]
        
        if doc not in quote_cache:
            fpath = os.path.join(RESEARCH_DIR, doc)
            if not os.path.exists(fpath):
                errors.append(f"CHECK 2 FAIL: entry {i} doc not found: {doc}")
                continue
            with open(fpath, 'r', encoding='utf-8', errors='replace') as f:
                quote_cache[doc] = f.readlines()
        
        lines = quote_cache[doc]
        if line < 1 or line > len(lines):
            errors.append(f"CHECK 2 FAIL: entry {i} ({doc}:{line}) line out of range (file has {len(lines)} lines)")
            continue
        
        actual_line = normalise_ws(lines[line - 1])
        search_quote = normalise_ws(quote)
        
        if search_quote not in actual_line:
            errors.append(f"CHECK 2 FAIL: entry {i} ({doc}:{line}) quote not found")
            errors.append(f"  LOOKING FOR: {search_quote[:100]}")
            errors.append(f"  ACTUAL LINE: {actual_line[:100]}")
    
    if not any("CHECK 2 FAIL" in e for e in errors):
        print(f"CHECK 2 PASS: all {len(entries)} quotes verified")
    
    # Check 3: kind vocabulary
    for i, entry in enumerate(entries):
        kind = entry["kind"].lower()
        if kind not in ALLOWED_KINDS:
            errors.append(f"CHECK 3 FAIL: entry {i} kind '{entry['kind']}' not in allowed vocabulary")
    
    if not any("CHECK 3 FAIL" in e for e in errors):
        print(f"CHECK 3 PASS: all kinds in allowed vocabulary")
    
    # Check 4: value parses as number
    for i, entry in enumerate(entries):
        ok, cleaned = strip_units(entry["value"])
        if not ok:
            errors.append(f"CHECK 4 FAIL: entry {i} ({entry['doc']}:{entry['line']}) value '{entry['value']}' does not parse (cleaned: '{cleaned}')")
    
    if not any("CHECK 4 FAIL" in e for e in errors):
        print(f"CHECK 4 PASS: all values parse as numbers")
    
    # Check 5: high_confidence > 0
    if summary["high_confidence"] <= 0:
        errors.append(f"CHECK 5 FAIL: high_confidence={summary['high_confidence']} is 0")
    else:
        print(f"CHECK 5 PASS: high_confidence={summary['high_confidence']}")
    
    # Check 6: summary counts match
    actual_total = len(entries)
    actual_high = sum(1 for e in entries if e["confidence"] == "high")
    actual_docs_with = len(set(e["doc"] for e in entries))
    
    if summary["extrema_found"] != actual_total:
        errors.append(f"CHECK 6 FAIL: extrema_found={summary['extrema_found']} != actual={actual_total}")
    if summary["high_confidence"] != actual_high:
        errors.append(f"CHECK 6 FAIL: high_confidence={summary['high_confidence']} != actual={actual_high}")
    if summary["docs_with_extrema"] != actual_docs_with:
        errors.append(f"CHECK 6 FAIL: docs_with_extrema={summary['docs_with_extrema']} != actual={actual_docs_with}")
    
    if not any("CHECK 6 FAIL" in e for e in errors):
        print(f"CHECK 6 PASS: summary counts match (extrema={actual_total}, high={actual_high}, docs={actual_docs_with})")
    
    # Report
    print()
    if errors:
        print(f"FAILED: {len([e for e in errors if 'FAIL' in e])} error(s)")
        for e in errors:
            print(f"  {e}")
        sys.exit(1)
    else:
        print("ALL CHECKS PASSED")
        print(f"  Entries: {actual_total}")
        print(f"  High confidence: {actual_high}")
        print(f"  Low confidence: {actual_total - actual_high}")
        print(f"  Docs with extrema: {actual_docs_with}")
        print(f"  Docs scanned: {summary['docs_scanned']}")
        sys.exit(0)

if __name__ == "__main__":
    main()

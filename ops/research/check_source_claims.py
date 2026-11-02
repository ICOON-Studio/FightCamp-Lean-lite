#!/usr/bin/env python3
"""Gate for a source-reading research task.

Every claim a digest makes about a file it read must be re-findable.  Feed this
a JSON list of {"file", "line", "quote"} and it re-opens each file at each line
and requires the quote to be there.  Exit 0 only if every claim holds, at least
MIN_CLAIMS were made, and they span at least MIN_FILES distinct files - a digest
that cites one file twelve times has read one file.

    python research/check_source_claims.py research/Q125_claims.json
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

MIN_CLAIMS = 12
MIN_FILES = 4
SLACK = 2  # a cited line may be off by this many lines either way


def norm(s: str) -> str:
    return " ".join(s.split())


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("usage: check_source_claims.py <claims.json>")
        return 2
    path = Path(argv[1])
    if not path.is_file():
        print(f"FAIL missing claims file: {path}")
        return 1
    try:
        claims = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        print(f"FAIL {path} is not valid JSON: {exc}")
        return 1
    if not isinstance(claims, list):
        print("FAIL claims file must be a JSON list of objects")
        return 1

    cache: dict[str, list[str]] = {}
    bad = 0
    for i, claim in enumerate(claims):
        if not isinstance(claim, dict):
            print(f"FAIL claim {i}: not an object")
            bad += 1
            continue
        src = str(claim.get("file", ""))
        quote = norm(str(claim.get("quote", "")))
        try:
            line = int(claim.get("line", -1))
        except (TypeError, ValueError):
            line = -1
        if not src or not quote or line < 1:
            print(f"FAIL claim {i}: needs file, line >= 1 and a non-empty quote")
            bad += 1
            continue
        if src not in cache:
            p = Path(src)
            if not p.is_file():
                cache[src] = []
            else:
                cache[src] = p.read_text(encoding="utf-8", errors="replace").splitlines()
        lines = cache[src]
        if not lines:
            print(f"FAIL claim {i}: cannot read {src}")
            bad += 1
            continue
        lo = max(0, line - 1 - SLACK)
        hi = min(len(lines), line + SLACK)
        window = [norm(x) for x in lines[lo:hi]]
        if any(quote in w for w in window):
            continue
        print(f"FAIL claim {i}: {src}:{line} does not contain that quote")
        print(f"     wanted: {quote[:100]}")
        print(f"     found : {norm(lines[line - 1])[:100] if line <= len(lines) else '<past EOF>'}")
        bad += 1

    files = {str(c.get('file')) for c in claims if isinstance(c, dict) and c.get('file')}
    if len(claims) < MIN_CLAIMS:
        print(f"FAIL only {len(claims)} claim(s); at least {MIN_CLAIMS} required")
        bad += 1
    if len(files) < MIN_FILES:
        print(f"FAIL claims span {len(files)} file(s); at least {MIN_FILES} required")
        bad += 1

    print(f"CLAIMS checked={len(claims)} files={len(files)} failures={bad}")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))

"""pace_diff.py - compare two punch_pace.json files, one line per changed clip and field.

Usage: python tools/pace_diff.py <old.json> <new.json>
Output: one line per changed field, plus a summary line PACE_DIFF clips=<n>.
"""
from __future__ import annotations

import json
import sys


def load(path: str) -> dict:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def diff(old: dict, new: dict) -> tuple[list[str], int]:
    lines: list[str] = []
    clips_changed: int = 0
    all_clips: list[str] = sorted(set(old.keys()) | set(new.keys()))
    for clip in all_clips:
        o: dict = old.get(clip, {})
        n: dict = new.get(clip, {})
        all_fields: list[str] = sorted(set(o.keys()) | set(n.keys()))
        clip_lines: list[str] = []
        for field in all_fields:
            ov = o.get(field)
            nv = n.get(field)
            if ov != nv:
                if isinstance(ov, float) and isinstance(nv, float):
                    clip_lines.append(f"  {field}: {ov:.4f} -> {nv:.4f} (delta {nv - ov:+.4f})")
                else:
                    clip_lines.append(f"  {field}: {ov!r} -> {nv!r}")
        if clip_lines:
            clips_changed += 1
            lines.append(f"{clip}:")
            lines.extend(clip_lines)
    return lines, clips_changed


def main() -> None:
    if len(sys.argv) != 3:
        print("Usage: python tools/pace_diff.py <old.json> <new.json>", file=sys.stderr)
        sys.exit(2)
    old = load(sys.argv[1])
    new = load(sys.argv[2])
    lines, clips_changed = diff(old, new)
    for line in lines:
        print(line)
    if not lines:
        print("(no differences)")
    print(f"PACE_DIFF clips={clips_changed}")


if __name__ == "__main__":
    main()

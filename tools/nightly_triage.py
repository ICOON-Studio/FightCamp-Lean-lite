#!/usr/bin/env python3
"""nightly_triage.py - re-run last night's red tests on today's main, report which are still red,
the first failing line, and the last nightly where each passed.

Usage:
    python tools/nightly_triage.py

Reads ops/AgentComms/nightly/latest.txt (main checkout) for FAIL lines, runs each test through
godot_slot.py, scans suite_*.log for last green, writes docs/NIGHTLY_TRIAGE_S466.md.
"""
from __future__ import annotations

import os
import re
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MAIN = Path(r"E:\FightCamp\Lean")
NIGHTLY = MAIN / "ops" / "AgentComms" / "nightly"
LATEST = NIGHTLY / "latest.txt"
GODOT = Path(os.environ.get("LOCALAPPDATA", r"C:\Users\user\AppData\Local")) / "Programs" / "Godot" / "Godot_v4.7.2-stable_win64.exe"
SLOT = ROOT / "ops" / "Tools" / "godot_slot.py"
TIMEOUT_S = 600
CONTROL_TEST = "golden_path_test"


def read_red_tests() -> list[str]:
    """Parse FAIL <name> (exit N) lines from latest.txt."""
    text = LATEST.read_text(encoding="utf-8")
    names = []
    for m in re.finditer(r"^FAIL (\w+_test) \(exit \d+\)", text, re.MULTILINE):
        n = m.group(1)
        if n not in names:
            names.append(n)
    return names


def run_test(name: str) -> tuple[str, str, str]:
    """Run one test through godot_slot. Returns (verdict, first_fail_line, full_output).
    verdict: PASS, RED, or HANG.
    PASS = exit 0, no SCRIPT ERROR, and the test's own failures=N line shows 0 (or no FAIL lines)."""
    cmd = [
        sys.executable, str(SLOT), "run", "--who", "nightlytriage1", "--",
        str(GODOT), "--headless", "--audio-driver", "Dummy", "--path", str(ROOT),
        "--script", f"res://tests/{name}.gd",
    ]
    try:
        proc = subprocess.run(
            cmd, capture_output=True, text=True, timeout=TIMEOUT_S, cwd=str(ROOT),
        )
        output = proc.stdout + proc.stderr
        rc = proc.returncode
    except subprocess.TimeoutExpired:
        return "HANG", "timeout", ""

    first_fail = ""
    for line in output.splitlines():
        stripped = line.strip()
        if stripped.startswith("SCRIPT ERROR") and not first_fail:
            first_fail = stripped[:140]
        if stripped.startswith("FAIL ") and not first_fail:
            first_fail = stripped[:140]

    if rc == 0 and "SCRIPT ERROR" not in output and not first_fail:
        return "PASS", "", output

    if rc == 124:
        return "HANG", first_fail or "timeout (rc 124)", output

    return "RED", first_fail or f"exit {rc}", output


def _read_log(path: Path) -> str:
    """Read a suite log, handling UTF-16 or UTF-8, normalizing line endings."""
    raw = path.read_bytes()
    if raw[:2] in (b"\xff\xfe", b"\xfe\xff"):
        text = raw.decode("utf-16", errors="replace")
    else:
        text = raw.decode("utf-8", errors="replace")
    return text.replace("\r\n", "\n").replace("\r", "\n")


def find_last_green(name: str) -> tuple[str, str]:
    """Scan suite_*.log oldest to newest; return (date, commit_line) of newest log where
    the test appears and did NOT fail."""
    logs = sorted(NIGHTLY.glob("suite_*.log"))
    best_date = ""
    best_commit = ""
    for log in logs:
        date = log.stem.replace("suite_", "")
        try:
            text = _read_log(log)
        except Exception:
            continue
        has_time = re.search(rf"^TIME \d+ s {re.escape(name)}$", text, re.MULTILINE)
        has_pass = re.search(rf"^PASS {re.escape(name)}$", text, re.MULTILINE)
        has_fail = re.search(rf"^FAIL {re.escape(name)} \(exit \d+\)", text, re.MULTILINE)
        if not has_time and not has_pass:
            continue
        if has_fail:
            continue
        first_line = text.split("\n", 1)[0] if text else ""
        cm = re.search(r"commit:\s*(\S+)", first_line)
        commit_str = cm.group(1) if cm else "-"
        best_date = date
        best_commit = commit_str
    return best_date, best_commit


def run_control() -> bool:
    """Run golden_path_test; must PASS. Returns True if control passed."""
    print(f"[CONTROL] running {CONTROL_TEST}...", flush=True)
    verdict, fail_line, _ = run_test(CONTROL_TEST)
    if verdict == "PASS":
        print(f"[CONTROL] {CONTROL_TEST} -> PASS", flush=True)
        return True
    print(f"[CONTROL] {CONTROL_TEST} -> {verdict}: {fail_line}", flush=True)
    print("CONTROL FAILED - verdict code is wrong, stopping.", flush=True)
    return False


def main() -> int:
    if not LATEST.exists():
        print(f"ERROR: {LATEST} not found", file=sys.stderr)
        return 1

    red_tests = read_red_tests()
    print(f"Found {len(red_tests)} red tests in latest.txt: {red_tests}", flush=True)

    if not run_control():
        return 2

    results: list[dict] = []
    for name in red_tests:
        print(f"\n[{name}] running...", flush=True)
        verdict, fail_line, _ = run_test(name)
        last_date, last_commit = find_last_green(name)
        results.append({
            "name": name,
            "verdict": verdict,
            "fail_line": fail_line,
            "last_green": last_date,
            "last_commit": last_commit,
        })
        print(f"[{name}] -> {verdict} | {fail_line} | last green: {last_date} ({last_commit})", flush=True)

    red_count = sum(1 for r in results if r["verdict"] == "RED")
    fixed_count = sum(1 for r in results if r["verdict"] == "PASS")
    hang_count = sum(1 for r in results if r["verdict"] == "HANG")

    out_path = ROOT / "docs" / "NIGHTLY_TRIAGE_S466.md"
    out_path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "# NIGHTLY_TRIAGE S466",
        "",
        f"Generated: {time.strftime('%Y-%m-%d %H:%M')}",
        f"Source: {LATEST}",
        "",
        "| test | main today | first FAIL line | last green nightly | its commit |",
        "|------|-----------|-----------------|-------------------|-----------|",
    ]
    for r in results:
        fl = r["fail_line"][:140] if r["fail_line"] else "-"
        lines.append(f"| {r['name']} | {r['verdict']} | {fl} | {r['last_green']} | {r['last_commit']} |")
    lines.append("")
    lines.append(f"NIGHTLY_TRIAGE red={red_count} fixed={fixed_count} hang={hang_count}")
    lines.append("")
    out_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"\nWrote {out_path}", flush=True)
    print(f"NIGHTLY_TRIAGE red={red_count} fixed={fixed_count} hang={hang_count}", flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())

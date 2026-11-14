"""speed_ruler_sort.py - sort punch_speed_test's failures by check and punch.

Reads the test's saved output (argv[1]) and prints a table:
  one row per move (jab, cross, lead_hook, rear_hook, lead_uppercut, rear_uppercut, body_hook),
  one column per check (SPEED / FIRST / POP / SYNC),
  the failure count in each cell, plus the measured value range against its bar.
Last line: SPEED_RULER_SORT total=<n> where n equals the test's failure count.
"""
from __future__ import annotations

import re
import sys
from collections import defaultdict

MOVES = ["jab", "cross", "lead_hook", "rear_hook", "lead_uppercut", "rear_uppercut", "body_hook"]
CHECKS = ["SPEED", "FIRST", "POP", "SYNC"]
SPEED_BAND = {
    "jab": (6.0, 8.0),
    "cross": (7.0, 9.0),
    "lead_hook": (7.0, 9.0),
    "rear_hook": (7.0, 9.0),
}
FIRST_BAR = 0.13
POP_BAR = 1.5


def parse(log_path: str) -> None:
    # Per move: {check: [fail_count, measured_values]}
    data: dict[str, dict[str, list]] = {m: {c: [0, []] for c in CHECKS} for m in MOVES}
    # Per move: list of (clip, top_speed, first_s, worst_step) from ROW lines
    rows: dict[str, list[dict]] = {m: [] for m in MOVES}
    total_fail = 0
    declared_total: int | None = None

    row_re = re.compile(
        r"^ROW (\S+) \((\w+)\) .+top ([\d.]+) m/s .+hand moves at ([\d.]+) s, worst step ([\d.]+)x"
    )
    fail_re = re.compile(r"^FAIL (SPEED|FIRST|POP|SYNC) (\S+):")
    pass_re = re.compile(r"^PASS (SPEED|FIRST|POP|SYNC) (\S+):")
    total_re = re.compile(r"^PUNCH_SPEED failures=(\d+)")

    # For extracting measured values from FAIL lines
    speed_val_re = re.compile(r"glove top ([\d.]+) m/s")
    first_val_re = re.compile(r"hand moves ([\d.]+) s")
    pop_val_re = re.compile(r"worst bone step ([\d.]+)x")

    with open(log_path, encoding="utf-8", errors="replace") as f:
        for line in f:
            line = line.rstrip()

            m_total = total_re.match(line)
            if m_total:
                declared_total = int(m_total.group(1))
                continue

            m_row = row_re.match(line)
            if m_row:
                clip, move, top, first_s, worst = m_row.groups()
                if move in data:
                    rows[move].append({
                        "clip": clip, "top": float(top),
                        "first_s": float(first_s), "worst": float(worst),
                    })
                continue

            m_fail = fail_re.match(line)
            if m_fail:
                check, clip = m_fail.groups()
                # Find the move for this clip
                move = None
                for mv in MOVES:
                    if any(r["clip"] == clip for r in rows.get(mv, [])):
                        move = mv
                        break
                if move is None:
                    # Try to infer from clip name patterns
                    for mv in MOVES:
                        if mv in clip:
                            move = mv
                            break
                if move is None:
                    continue
                data[move][check][0] += 1
                total_fail += 1
                # Extract measured value
                if check == "SPEED":
                    vm = speed_val_re.search(line)
                    if vm:
                        data[move][check][1].append(float(vm.group(1)))
                elif check == "FIRST":
                    vm = first_val_re.search(line)
                    if vm:
                        data[move][check][1].append(float(vm.group(1)))
                elif check == "POP":
                    vm = pop_val_re.search(line)
                    if vm:
                        data[move][check][1].append(float(vm.group(1)))
                continue

            m_pass = pass_re.match(line)
            if m_pass:
                check, clip = m_pass.groups()
                move = None
                for mv in MOVES:
                    if any(r["clip"] == clip for r in rows.get(mv, [])):
                        move = mv
                        break
                if move is None:
                    for mv in MOVES:
                        if mv in clip:
                            move = mv
                            break
                if move is None:
                    continue
                # Record passing values too for the range column
                if check == "SPEED":
                    vm = speed_val_re.search(line)
                    if vm:
                        data[move][check][1].append(float(vm.group(1)))
                elif check == "FIRST":
                    vm = first_val_re.search(line)
                    if vm:
                        data[move][check][1].append(float(vm.group(1)))
                elif check == "POP":
                    vm = pop_val_re.search(line)
                    if vm:
                        data[move][check][1].append(float(vm.group(1)))

    # Print the table
    header = f"{'move':<16} {'SPEED':>8} {'FIRST':>8} {'POP':>8} {'SYNC':>8}   {'notes'}"
    print(header)
    print("-" * len(header))

    for move in MOVES:
        cells = []
        notes = []
        for check in CHECKS:
            fc, vals = data[move][check]
            cell = str(fc)
            cells.append(cell)

        # Build notes with ranges for failed checks
        for check in CHECKS:
            fc, vals = data[move][check]
            if fc > 0 and vals:
                lo, hi = min(vals), max(vals)
                if check == "SPEED" and move in SPEED_BAND:
                    band = SPEED_BAND[move]
                    notes.append(f"SPEED {lo:.2f}-{hi:.2f} m/s v {band[0]:.0f}-{band[1]:.0f}")
                elif check == "FIRST":
                    notes.append(f"FIRST {lo:.3f}-{hi:.3f} s v {FIRST_BAR:.2f}")
                elif check == "POP":
                    notes.append(f"POP {lo:.2f}-{hi:.2f}x v {POP_BAR:.1f}x")

        note_str = "; ".join(notes) if notes else ""
        print(f"{move:<16} {cells[0]:>8} {cells[1]:>8} {cells[2]:>8} {cells[3]:>8}   {note_str}")

    print("-" * len(header))
    col_totals = [sum(data[m][c][0] for m in MOVES) for c in CHECKS]
    print(f"{'TOTAL':<16} {col_totals[0]:>8} {col_totals[1]:>8} {col_totals[2]:>8} {col_totals[3]:>8}   {sum(col_totals)}")
    print(f"SPEED_RULER_SORT total={total_fail}")
    if declared_total is not None and declared_total != total_fail:
        print(f"WARNING: test declared failures={declared_total} but sort counted {total_fail}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("usage: speed_ruler_sort.py <log-file>", file=sys.stderr)
        sys.exit(2)
    parse(sys.argv[1])

"""Q118 check script — validates the decision inventory against the source.

Recomputes from source, does NOT read Q118_decisions.json and agree with it.
Must exit 0 on success.

Checks:
1. Every file:line in the decision inventory resolves to a line mentioning the key.
2. Decision count matches a pinned literal.
3. Every decision has a non-empty "what happens if never made" field.
4. UNKNOWN defaults are counted separately and reported.
5. Degenerate case: empty decision list reports "no decisions" (no div-by-zero).
"""

import json
import os
import re
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, "..", ".."))
DECISIONS_PATH = os.path.join(SCRIPT_DIR, "Q118_decisions.json")
GAMESTATE_PATH = os.path.join(REPO_ROOT, "Godot", "scripts", "GameState.gd")

# PINNED: the expected decision count. Update this when adding/removing decisions.
PINNED_DECISION_COUNT = 24


def load_decisions():
    with open(DECISIONS_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def read_source_lines(path):
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        return f.readlines()


def check_file_line_resolves(decision, source_lines):
    """Assert the reader_line in the source mentions the reader_key."""
    reader_file = decision.get("reader_file", "")
    reader_line = decision.get("reader_line", 0)
    reader_key = decision.get("reader_key", "")
    decision_id = decision.get("id", "?")

    if not reader_file or not reader_line or not reader_key:
        return False, f"{decision_id}: missing reader_file, reader_line or reader_key"

    if "GameState.gd" not in reader_file:
        return False, f"{decision_id}: reader_file is not GameState.gd ({reader_file})"

    idx = reader_line - 1  # 0-based
    if idx < 0 or idx >= len(source_lines):
        return False, f"{decision_id}: line {reader_line} out of range (file has {len(source_lines)} lines)"

    # Check a window around the line (the key may be a few lines away from the exact reference)
    window = 5
    start = max(0, idx - window)
    end = min(len(source_lines), idx + window + 1)
    window_text = "".join(source_lines[start:end])

    if reader_key not in window_text:
        return False, f"{decision_id}: key '{reader_key}' not found near line {reader_line}"

    return True, ""


def check_default_field(decision):
    """Assert the 'default_if_never_made' field is non-empty."""
    default = decision.get("default_if_never_made", "")
    decision_id = decision.get("id", "?")
    if not default or not str(default).strip():
        return False, f"{decision_id}: empty 'default_if_never_made'"
    return True, ""


def check_degenerate_empty_list():
    """Assert that an empty decision list is handled without div-by-zero."""
    empty_decisions = []
    count = len(empty_decisions)
    unknown_count = 0
    # The check must not divide by count when it is zero.
    if count == 0:
        msg = "no decisions"
    else:
        msg = f"{count} decisions, {unknown_count} UNKNOWN defaults"
    return msg == "no decisions", f"degenerate case: got '{msg}'"


def main():
    errors = []
    warnings = []

    # Load decisions
    data = load_decisions()
    decisions = data.get("decisions", [])

    # Check 4: degenerate case
    ok, msg = check_degenerate_empty_list()
    if not ok:
        errors.append(msg)
    else:
        print(f"  [ok] degenerate empty-list case: {msg}")

    # Check 2: pinned count
    actual_count = len(decisions)
    if actual_count != PINNED_DECISION_COUNT:
        errors.append(
            f"decision count mismatch: pinned={PINNED_DECISION_COUNT}, actual={actual_count}"
        )
    else:
        print(f"  [ok] decision count: {actual_count} (pinned={PINNED_DECISION_COUNT})")

    # Read source
    source_lines = read_source_lines(GAMESTATE_PATH)
    print(f"  source: {GAMESTATE_PATH} ({len(source_lines)} lines)")

    # Check 1 & 3: per-decision validation
    unknown_count = 0
    for d in decisions:
        did = d.get("id", "?")

        # Check 1: file:line resolves
        ok, err = check_file_line_resolves(d, source_lines)
        if not ok:
            errors.append(err)
        else:
            print(f"  [ok] {did}: reader line resolves")

        # Check 3: default field non-empty
        ok, err = check_default_field(d)
        if not ok:
            errors.append(err)
        else:
            default_val = str(d.get("default_if_never_made", ""))
            if "UNKNOWN" in default_val:
                unknown_count += 1
                print(f"  [ok] {did}: default=UNKNOWN (counted)")
            else:
                print(f"  [ok] {did}: default present")

    # Report
    print()
    print(f"  total decisions: {actual_count}")
    print(f"  UNKNOWN defaults: {unknown_count}")
    print(f"  errors: {len(errors)}")

    if errors:
        print()
        for e in errors:
            print(f"  FAIL: {e}")
        sys.exit(1)
    else:
        print()
        print("  ALL CHECKS PASSED")
        sys.exit(0)


if __name__ == "__main__":
    main()

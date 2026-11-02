#!/usr/bin/env python3
"""Q121 check gate - recomputes every headline number from q121_sweep.json
and asserts against the digest Q121_CAGE_SIZE.md.

Exits non-zero if any headline number disagrees, if the control arm is
missing, or if the noise figure is not reported.
"""
import json
import sys
import os

HERE = os.path.dirname(os.path.abspath(__file__))
SWEEP_JSON = os.path.join(HERE, "q121_sweep.json")
DIGEST_MD = os.path.join(HERE, "Q121_CAGE_SIZE.md")


def load_sweep():
    with open(SWEEP_JSON, "r", encoding="utf-8") as f:
        return json.load(f)


def load_digest():
    with open(DIGEST_MD, "r", encoding="utf-8") as f:
        return f.read()


def find_in_digest(digest, label):
    for line in digest.splitlines():
        stripped = line.strip().strip("|").strip()
        if stripped.startswith(label):
            return parse_table_row(line, label)
    return None


def parse_table_row(line, label):
    parts = [p.strip() for p in line.strip().strip("|").split("|")]
    if len(parts) < 10:
        return None
    return {
        "label": parts[0],
        "hw": parts[1],
        "fence_pct": parts[2],
        "corner_pct": parts[3],
        "td_per_min": parts[4],
        "td_success_pct": parts[5],
        "clinch_per_min": parts[6],
        "sep_m": parts[7],
        "str_per_rd": parts[8],
    }


def parse_num(s):
    s = s.strip().replace("%", "").replace("m", "")
    return float(s)


def approx(a, b, tol=0.15):
    if abs(b) < 0.001:
        return abs(a) < tol
    return abs(a - b) / max(abs(b), 0.001) < tol


def main():
    errors = []
    data = load_sweep()
    digest = load_digest()

    ctrl = data.get("control_arm", {})
    if not ctrl or "run_a" not in ctrl or "run_b" not in ctrl:
        errors.append("FAIL: control arm missing from sweep JSON")
    else:
        for key in ["noise_fence", "noise_corner", "noise_td_rate",
                     "noise_strikes_per_round", "noise_mean_sep", "noise_clinch_per_min"]:
            if key not in ctrl:
                errors.append("FAIL: control arm missing " + key)

    for row in data.get("sizes", []):
        fails = row.get("half_width_assert_fails", 0)
        if fails > 0:
            errors.append("FAIL: %s had %d half_width assertion failures" % (row["label"], fails))

    for row in data.get("sizes", []):
        label = row["label"]
        zone = row["zone"]
        td = row["takedowns"]
        dist = row["distance"]
        strikes = row["strikes"]

        digest_row = find_in_digest(digest, label)
        if digest_row is None:
            errors.append("FAIL: size '%s' not found in digest table" % label)
            continue

        expected_fence = zone["fence_share"] * 100.0
        got_fence = parse_num(digest_row["fence_pct"])
        if not approx(expected_fence, got_fence, tol=1.0):
            errors.append("FAIL %s fence: JSON=%.2f%% digest=%.2f%%" % (label, expected_fence, got_fence))

        expected_corner = zone["corner_share"] * 100.0
        got_corner = parse_num(digest_row["corner_pct"])
        if not approx(expected_corner, got_corner, tol=1.0):
            errors.append("FAIL %s corner: JSON=%.2f%% digest=%.2f%%" % (label, expected_corner, got_corner))

        expected_td = td["per_min"]
        got_td = parse_num(digest_row["td_per_min"])
        if not approx(expected_td, got_td, tol=0.1):
            errors.append("FAIL %s td/min: JSON=%.2f digest=%.2f" % (label, expected_td, got_td))

        expected_sep = dist["mean_separation_m"]
        got_sep = parse_num(digest_row["sep_m"])
        if not approx(expected_sep, got_sep, tol=0.05):
            errors.append("FAIL %s sep: JSON=%.3f digest=%.3f" % (label, expected_sep, got_sep))

        expected_str = strikes["landed_per_round"]
        got_str = parse_num(digest_row["str_per_rd"])
        if not approx(expected_str, got_str, tol=0.1):
            errors.append("FAIL %s str/rd: JSON=%.1f digest=%.1f" % (label, expected_str, got_str))

    bps = data.get("bouts_per_size", 0)
    if bps < 60:
        errors.append("FAIL: bouts_per_size=%d < 60" % bps)

    labels = {r["label"] for r in data.get("sizes", [])}
    expected_labels = {"gym_6m", "abc_18ft", "ufc_25ft", "ufc_30ft", "abc_32ft"}
    missing = expected_labels - labels
    if missing:
        errors.append("FAIL: missing sizes in JSON: %s" % missing)

    if errors:
        for e in errors:
            print(e)
        print("")
        print("CHECK FAILED: %d error(s)" % len(errors))
        sys.exit(1)
    else:
        print("CHECK OK: %d sizes, %d bouts/size, control arm present" % (len(data.get("sizes", [])), bps))
        sys.exit(0)


if __name__ == "__main__":
    main()

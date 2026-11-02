#!/usr/bin/env python3
"""Q114 check — re-derives demand and supply from source, asserts the gap.

Exits 0 on success, 1 on any assertion failure.
Prints one Q114_CHECK ... line per fact and Q114_CHECK PASS at the end.
"""

import json
import os
import re
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ADAPTER_PATH = os.path.join(REPO_ROOT, "Godot", "scripts", "FightBeatAdapter.gd")
BINDING_PATH = os.path.join(REPO_ROOT, "Godot", "scripts", "FightClipBinding.gd")
CENSUS_JSON_PATH = os.path.join(REPO_ROOT, "research", "Q114_census.json")


def extract_grapple_ids_from_const(source: str, const_name: str) -> set:
    """Extract the values (grapple_* ids) from a const Dictionary declaration."""
    pattern = rf'const\s+{const_name}\s*:=\s*\{{(.*?)\}}'
    match = re.search(pattern, source, re.DOTALL)
    if not match:
        print(f"Q114_CHECK FAIL: could not find const {const_name} in source")
        sys.exit(1)
    body = match.group(1)
    ids = set()
    for m in re.finditer(r'"(grapple_\w+)"', body):
        ids.add(m.group(1))
    return ids


def extract_paired_bindings_keys(source: str) -> set:
    """Extract the keys from const PAIRED_BINDINGS."""
    pattern = r'const\s+PAIRED_BINDINGS\s*:=\s*\{(.*?)\n\}'
    match = re.search(pattern, source, re.DOTALL)
    if not match:
        print("Q114_CHECK FAIL: could not find const PAIRED_BINDINGS in source")
        sys.exit(1)
    body = match.group(1)
    keys = set()
    for m in re.finditer(r'"(grapple_\w+)"\s*:', body):
        keys.add(m.group(1))
    return keys


def main() -> int:
    failures = 0

    # --- Load source files ---
    try:
        with open(ADAPTER_PATH, "r", encoding="utf-8") as f:
            adapter_src = f.read()
    except FileNotFoundError:
        print(f"Q114_CHECK FAIL: {ADAPTER_PATH} not found")
        return 1

    try:
        with open(BINDING_PATH, "r", encoding="utf-8") as f:
            binding_src = f.read()
    except FileNotFoundError:
        print(f"Q114_CHECK FAIL: {BINDING_PATH} not found")
        return 1

    # --- Re-derive demand from source ---
    via_ids = extract_grapple_ids_from_const(adapter_src, "GRAPPLE_VIA_TECHNIQUES")
    kind_ids = extract_grapple_ids_from_const(adapter_src, "GRAPPLE_KIND_TECHNIQUES")
    demand = via_ids | kind_ids

    print(f"Q114_CHECK demand_from_via_techniques={len(via_ids)} ids: {sorted(via_ids)}")
    print(f"Q114_CHECK demand_from_kind_techniques={len(kind_ids)} ids: {sorted(kind_ids)}")
    print(f"Q114_CHECK demand_total={len(demand)} (union of via + kind)")

    # --- Re-derive supply from source ---
    supply = extract_paired_bindings_keys(binding_src)
    print(f"Q114_CHECK supply_from_paired_bindings={len(supply)} ids: {sorted(supply)}")

    # --- GATE 1: demand count must exceed supply count ---
    if len(demand) <= len(supply):
        print(f"Q114_CHECK FAIL: demand ({len(demand)}) <= supply ({len(supply)}) — "
              "demand list came from supply, census is circular")
        return 1
    print(f"Q114_CHECK GATE demand({len(demand)}) > supply({len(supply)}): PASS")

    # --- Compute gap ---
    gap = demand - supply
    print(f"Q114_CHECK gap_ids={len(gap)} ids: {sorted(gap)}")

    # --- GATE 2: every gap id must be in demand and NOT in supply ---
    for gid in sorted(gap):
        if gid not in demand:
            print(f"Q114_CHECK FAIL: gap id '{gid}' not in demand")
            failures += 1
        if gid in supply:
            print(f"Q114_CHECK FAIL: gap id '{gid}' is in supply (should not be)")
            failures += 1
    if failures == 0:
        print(f"Q114_CHECK GATE all gap ids in demand and not in supply: PASS")

    # --- GATE 3: at least one pinned number from the census JSON ---
    try:
        with open(CENSUS_JSON_PATH, "r", encoding="utf-8") as f:
            census = json.load(f)
    except FileNotFoundError:
        print(f"Q114_CHECK FAIL: {CENSUS_JSON_PATH} not found")
        return 1

    pinned = census.get("pinned_numbers", {})
    clinch_engage_count = pinned.get("grapple_clinch_engage_count")
    denominator = pinned.get("denominator", "")
    demand_count_pinned = pinned.get("demand_count")
    supply_count_pinned = pinned.get("supply_count")

    if clinch_engage_count is None:
        print("Q114_CHECK FAIL: no pinned grapple_clinch_engage_count in census JSON")
        failures += 1
    else:
        print(f"Q114_CHECK pinned grapple_clinch_engage_count={clinch_engage_count} "
              f"denominator=\"{denominator}\"")

    if demand_count_pinned != len(demand):
        print(f"Q114_CHECK FAIL: pinned demand_count={demand_count_pinned} != "
              f"re-derived demand={len(demand)}")
        failures += 1
    else:
        print(f"Q114_CHECK GATE pinned demand_count matches re-derived: PASS")

    if supply_count_pinned != len(supply):
        print(f"Q114_CHECK FAIL: pinned supply_count={supply_count_pinned} != "
              f"re-derived supply={len(supply)}")
        failures += 1
    else:
        print(f"Q114_CHECK GATE pinned supply_count matches re-derived: PASS")

    # --- GATE 4: gap ids in JSON match re-derived gap ---
    json_gap_ids = set()
    for entry in census.get("gap", {}).get("ids_ranked_by_count", []):
        json_gap_ids.add(entry["id"])
    if json_gap_ids != gap:
        print(f"Q114_CHECK FAIL: JSON gap ids {sorted(json_gap_ids)} != "
              f"re-derived {sorted(gap)}")
        failures += 1
    else:
        print(f"Q114_CHECK GATE JSON gap ids match re-derived: PASS")

    # --- Denominator statement ---
    print(f"Q114_CHECK denominator=\"{denominator}\" "
          f"(every share in the census uses this denominator)")

    if failures > 0:
        print(f"Q114_CHECK FAIL ({failures} assertion(s) failed)")
        return 1

    print("Q114_CHECK PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())

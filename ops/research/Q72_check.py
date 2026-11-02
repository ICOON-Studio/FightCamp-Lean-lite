#!/usr/bin/env python
"""Q72's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q72_check.py

It does not decide a seat. It checks the adjudication covers exactly the judo nodes
the seat tool would seat, reports rule B honestly, and gives a reason for every
disagreement - and that the rules memo cites the disk instead of inventing numbers.
"""
import json
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, "Godot", "tools"))
import derive_technique_phases as dtp  # noqa: E402

SEATS = ("ground_top", "ground_bottom")
failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def main():
    catalogue = json.load(open(os.path.join(ROOT, "Godot", "assets", "data", "technique_catalog.json"), encoding="utf-8"))
    pre_merge = dtp.load_pre_merge(dtp.PRE_MERGE_REV)
    expected = {}
    for discipline in catalogue["disciplines"]:
        if discipline["id"] != "judo":
            continue
        for node in discipline["nodes"]:
            verdict, new_phases, rule = dtp.classify(node, pre_merge)
            if verdict == "repair" and not rule.startswith("C:"):
                expected[node["id"]] = [p for p in new_phases if p in SEATS]

    path = os.path.join(ROOT, "research", "Q72_judo_seats.json")
    check(os.path.exists(path), "Q72_judo_seats.json exists")
    doc = json.load(open(path, encoding="utf-8")) if os.path.exists(path) else {}
    nodes = doc.get("nodes") or []
    ids = [n.get("id") for n in nodes]
    check(len(expected) == 33, "the seat tool still seats 33 judo nodes (it seats %d)" % len(expected))
    check(sorted(ids) == sorted(expected), "one entry per judo node the tool seats, no more, no fewer (missing=%s extra=%s)"
          % (sorted(set(expected) - set(ids))[:6], sorted(set(ids) - set(expected))[:6]))
    check(len(ids) == len(set(ids)), "no node adjudicated twice")
    check(all(n.get("seats") and all(s in SEATS for s in n["seats"]) and len(set(n["seats"])) == len(n["seats"]) for n in nodes),
          "every entry's seats are a non-empty set of ground_top / ground_bottom")
    wrong_b = [n.get("id") for n in nodes if n.get("id") in expected and sorted(n.get("rule_b_says") or []) != sorted(expected[n["id"]])]
    check(not wrong_b, "every rule_b_says is exactly what the tool derives (wrong=%s)" % wrong_b[:6])
    unreasoned = [n.get("id") for n in nodes if len(str(n.get("reason", "")).strip()) < 12]
    check(not unreasoned, "every entry has a real reason (short=%s)" % unreasoned[:6])
    for choke in ("judo_hadakajime", "judo_okurierijime", "judo_katahajime"):
        entry = next((n for n in nodes if n.get("id") == choke), {})
        check(entry.get("seats") == ["ground_top"], "%s is applied from behind - the top seat (got %s)" % (choke, entry.get("seats")))
    pins = [n.get("id") for n in nodes if "gatame" in str(n.get("id")) and str(n.get("id")).endswith(("shihogatame", "kesagatame", "katagatame", "ukigatame", "uragatame"))]
    bad_pins = [n.get("id") for n in nodes if n.get("id") in pins and n.get("seats") != ["ground_top"]]
    check(not bad_pins, "every osaekomi-waza pin holds from on top (%s)" % bad_pins)
    head = subprocess.run(["git", "rev-parse", "--short", "HEAD"], cwd=ROOT, capture_output=True, text=True).stdout.strip()
    check(bool(doc.get("catalogue_commit")), "the table names the catalogue commit it read (HEAD is %s)" % head)

    memo_path = os.path.join(ROOT, "research", "Q72_JUDO_NEWAZA.md")
    memo = open(memo_path, encoding="utf-8").read() if os.path.exists(memo_path) else ""
    check(bool(memo), "Q72_JUDO_NEWAZA.md exists")
    check("G38_THE_GROUND_FIGHT_READ.md" in memo and ("59" in memo or "60" in memo), "the memo cites G38's osaekomi lines")
    check("14" in memo and "exchange" in memo.lower(), "the memo converts the rules into 14-second exchanges")
    check("NOT ON DISK" in memo, "the memo marks at least one rule the disk does not settle as NOT ON DISK")
    check("mma" in memo.lower() and ("ibjjf" in memo.lower() or "bjj" in memo.lower()), "the memo says which rulesets matte/osaekomi must NOT reach")

    disagreements = sum(1 for n in nodes if n.get("id") in expected and sorted(n.get("seats") or []) != sorted(expected[n["id"]]))
    print("Q72_CHECK nodes=%d disagree_with_rule_b=%d failures=%d" % (len(ids), disagreements, len(failures)))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())

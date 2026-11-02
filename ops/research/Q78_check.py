#!/usr/bin/env python
"""Q78's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q78_check.py

S1f found two content gaps: the judo tree has NO escape node, and sambo has no escape and
no defence node at all. Q78 drafts them in catalogue format, every node labelled with
what supports it. This gate does not judge the content. It runs the project's own node
validator on the delivery, derives what a defence must answer from the vocabulary, and
checks coverage of the seats S1f needs, id novelty, labels and the report's sections.
"""
import json
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GODOT = os.path.join(ROOT, "Godot")
RESEARCH = os.path.join(GODOT, "research")
LABELS = ("SOURCED:", "INFERENCE:")

failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def main():
    json_path = os.path.join(RESEARCH, "Q78_judo_sambo_nodes.json")
    md_path = os.path.join(RESEARCH, "Q78_JUDO_SAMBO_ESCAPES.md")
    check(os.path.exists(json_path), "Q78_judo_sambo_nodes.json exists")
    check(os.path.exists(md_path), "Q78_JUDO_SAMBO_ESCAPES.md exists")
    if failures:
        return 1
    try:
        delivery = json.load(open(json_path, encoding="utf-8"))
        judo = delivery["judo"]
        sambo = delivery["sambo"]
    except Exception as error:  # noqa: BLE001
        check(False, "the JSON loads as {\"judo\": [nodes], \"sambo\": [nodes]} (%s)" % error)
        return 1
    report = open(md_path, encoding="utf-8").read()

    run = subprocess.run([sys.executable, os.path.join(GODOT, "tools", "validate_technique_nodes.py"), json_path],
                         capture_output=True, text=True, encoding="utf-8", errors="replace")
    check(run.returncode == 0 and "VALIDATION OK" in run.stdout,
          "validate_technique_nodes.py accepts the delivery (rc=%d)" % run.returncode)
    if run.returncode != 0:
        tail = [line for line in run.stdout.splitlines() if line.startswith(("ERRORS", "   "))][:12]
        print("\n".join("      " + line for line in tail))

    catalogue = json.load(open(os.path.join(GODOT, "assets", "data", "technique_catalog.json"), encoding="utf-8"))
    live = {n["id"] for d in catalogue["disciplines"] for n in d["nodes"]}
    vocabulary = json.load(open(os.path.join(GODOT, "assets", "data", "technique_vocabulary.json"), encoding="utf-8"))
    answers = vocabulary["defense_answers"]

    nodes = [("judo", n) for n in judo] + [("sambo", n) for n in sambo]
    reused = [n.get("id") for _d, n in nodes if n.get("id") in live]
    check(not reused, "every id is new - none already in the live catalogue (%s)" % reused[:6])
    check(all(str(n.get("id", "")).startswith(d + "_") for d, n in nodes), "every id is prefixed with its discipline (judo_ / sambo_)")
    unlabelled = [n.get("id") for _d, n in nodes if not str(n.get("source", "")).startswith(LABELS)]
    check(not unlabelled, "every node's `source` starts SOURCED: or INFERENCE: (%s)" % unlabelled[:6])

    def role(n):
        return (n.get("match") or {}).get("role")

    def phases(n):
        return (n.get("match") or {}).get("phases") or []

    def answered(n):
        out = set()
        for key in (n.get("match") or {}).get("effects") or {}:
            out.update(answers.get(key, []))
        return out

    for discipline, group in (("judo", judo), ("sambo", sambo)):
        escapes = [n for n in group if role(n) == "escape" and "ground_bottom" in phases(n)]
        check(len(escapes) >= 4, "%s: at least four escapes from ground_bottom (%d)" % (discipline, len(escapes)))
        throws = [n for n in group if role(n) == "defense" and "standing" in phases(n) and "takedown" in answered(n)]
        check(len(throws) >= 2, "%s: at least two standing defences whose effects answer a takedown (%d)" % (discipline, len(throws)))
    sambo_sub = [n for n in sambo if role(n) in ("defense", "escape") and "submission" in answered(n)]
    check("SUBMISSION" in report.upper(),
          "the report says how a submission defence is answered (no defense_answers key answers submission today; %d draft nodes claim one)" % len(sambo_sub))

    upper = report.upper()
    for section in ("WHAT IS ON DISK", "WHAT AN OUTSIDE QUERY MUST VERIFY", "SEATS"):
        check(section in upper, "the report has a %s section" % section)
    missing = [n.get("id") for _d, n in nodes if n.get("id") not in report]
    check(not missing, "every drafted node is named in the report (%s)" % missing[:6])

    print("Q78_CHECK judo=%d sambo=%d sourced=%d inference=%d failures=%d"
          % (len(judo), len(sambo), sum(1 for _d, n in nodes if str(n.get("source", "")).startswith("SOURCED:")),
             sum(1 for _d, n in nodes if str(n.get("source", "")).startswith("INFERENCE:")), len(failures)))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())

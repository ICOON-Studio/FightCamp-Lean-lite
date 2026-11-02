#!/usr/bin/env python
"""U73's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U73_check.py

Recomputes the generated-opponent defence census from disk - the generator's prefix
rule, the vocabulary's seats and answers, the S1e cap - and checks each anchor quote
sits on the line it names. It does not choose an option.
"""
import json
import math
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RATINGS = ["30", "50", "70", "90"]
SEATS = ["standing", "ground_top", "ground_bottom"]
CLASSES = ["strike", "takedown", "control", "submission", "escape"]
failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def gd_round(x):
    return math.floor(x + 0.5) if x >= 0 else -math.floor(-x + 0.5)


def generator_consts():
    src = open(os.path.join(ROOT, "Godot", "scripts", "FightOpponentGenerator.gd"), encoding="utf-8").read()
    get = lambda name: float(re.search(r"const %s := ([\d.]+)" % name, src).group(1))
    return get("MIN_LEARNED_FRACTION"), get("MAX_LEARNED_FRACTION"), int(get("MIN_LEARNED_COUNT"))


def main():
    data = os.path.join(ROOT, "Godot", "assets", "data")
    catalogue = json.load(open(os.path.join(data, "technique_catalog.json"), encoding="utf-8"))
    vocab = json.load(open(os.path.join(data, "technique_vocabulary.json"), encoding="utf-8"))
    seats_of = vocab["phase_seats"]
    answers_of = vocab["defense_answers"]
    classes_of = vocab["defense_classes"]
    lo, hi, min_count = generator_consts()

    expected = {}
    for discipline in catalogue["disciplines"]:
        nodes = sorted(discipline["nodes"], key=lambda n: (int(n.get("tier", 0)), str(n.get("name", ""))))
        cells = {}
        for rating in RATINGS:
            fraction = min(max((float(rating) - 20.0) / 60.0, lo), hi)
            count = min(max(min_count, gd_round(fraction * len(nodes))), len(nodes))
            prefix = nodes[:count]
            defences = [n for n in prefix if n["match"].get("role") == "defense"]
            bonus = {}
            for seat in SEATS:
                bonus[seat] = {}
                for klass in CLASSES:
                    total = 0.0
                    for n in defences:
                        m = n["match"]
                        node_seats = {s for p in m.get("phases", []) for s in seats_of.get(p, [])}
                        node_classes = {c for k in m.get("effects", {}) for c in answers_of.get(k, [])}
                        if seat in node_seats and klass in node_classes:
                            total += sum(abs(float(v)) for v in m["effects"].values())
                    bonus[seat][klass] = min(total / 40.0, 0.35)
            cells[rating] = {"learned": count, "defence_nodes": sorted(n["id"] for n in defences), "bonus": bonus}
        expected[discipline["id"]] = cells
    _ = classes_of

    json_path = os.path.join(ROOT, "research", "U73_defence_cap_census.json")
    md_path = os.path.join(ROOT, "research", "U73_DEFENCE_CAP.md")
    check(os.path.exists(json_path), "U73_defence_cap_census.json exists")
    check(os.path.exists(md_path), "U73_DEFENCE_CAP.md exists")
    if failures:
        return
    try:
        delivery = json.load(open(json_path, encoding="utf-8"))
        census = delivery["census"]
        anchors = delivery["anchors"]
        recommend = delivery["recommend"]
    except Exception as error:  # noqa: BLE001
        check(False, "JSON loads with census / anchors / recommend (%s)" % error)
        return

    check(set(census) == set(expected), "census covers exactly the catalogue's disciplines")
    for discipline_id, cells in expected.items():
        got_cells = census.get(discipline_id, {})
        for rating in RATINGS:
            want = cells[rating]
            got = got_cells.get(rating, {})
            check(int(got.get("learned", -1)) == want["learned"], "%s @%s learned %d" % (discipline_id, rating, want["learned"]))
            check(sorted(got.get("defence_nodes", [])) == want["defence_nodes"], "%s @%s defence nodes %s" % (discipline_id, rating, want["defence_nodes"]))
            for seat in SEATS:
                for klass in CLASSES:
                    value = ((got.get("bonus", {}) or {}).get(seat, {}) or {}).get(klass)
                    ok = isinstance(value, (int, float)) and abs(float(value) - want["bonus"][seat][klass]) <= 0.001
                    check(ok, "%s @%s bonus[%s][%s] = %.3f (got %r)" % (discipline_id, rating, seat, klass, want["bonus"][seat][klass], value))

    check(isinstance(anchors, list) and len(anchors) >= 2, "at least two anchors")
    for anchor in anchors if isinstance(anchors, list) else []:
        path = os.path.join(ROOT, str(anchor.get("file", "")).replace("/", os.sep))
        quote = str(anchor.get("quote", "")).strip()
        line_no = int(anchor.get("line", 0) or 0)
        ok = False
        if os.path.exists(path) and quote and line_no > 0:
            lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
            ok = line_no <= len(lines) and quote in lines[line_no - 1]
        check(ok, "anchor %r: the quote is on %s:%s" % (anchor.get("metric"), anchor.get("file"), anchor.get("line")))

    check(recommend.get("option") in ("a", "b", "c", "d"), "recommend names an option")
    memo = open(md_path, encoding="utf-8").read()
    for option in ("(a)", "(b)", "(c)"):
        check(option in memo, "memo lays out option %s" % option)
    check(len(memo.split()) >= 350, "memo is a memo, not a stub (>= 350 words)")


if __name__ == "__main__":
    main()
    print("U73_CHECK failures=%d" % len(failures))
    sys.exit(1 if failures else 0)

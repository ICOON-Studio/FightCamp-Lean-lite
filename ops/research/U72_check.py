#!/usr/bin/env python
"""U72's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U72_check.py

It does not decide what a key answers, except for a handful of anchors no reading
disputes. It recomputes the defence census, the seats, each node's union and every
bonus from disk, so the delivery cannot agree with itself.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
CLASSES = ["strike", "takedown", "control", "submission", "escape"]
SEATS = ["standing", "ground_top", "ground_bottom"]
# key: (must include, must not include)
KEY_ANCHORS = {
    "takedown_defense": ({"takedown"}, {"strike"}),
    "low_kick_defense": ({"strike"}, {"takedown"}),
    "evasion": ({"strike"}, set()),
    "block": ({"strike"}, set()),
    "throw_damage_reduction": ({"takedown"}, {"strike"}),
    "guard_recovery": ({"control"}, {"strike"}),
}
# node: (must include, must not include) - R101 finding 7: a sprawl is no strike guard.
NODE_ANCHORS = {"wrestling_sprawl": ({"takedown"}, {"strike"})}
failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def close(a, b):
    try:
        return abs(float(a) - float(b)) <= 0.001
    except (TypeError, ValueError):
        return False


def main():
    data = os.path.join(ROOT, "Godot", "assets", "data")
    catalogue = json.load(open(os.path.join(data, "technique_catalog.json"), encoding="utf-8"))
    phase_seats = json.load(open(os.path.join(data, "technique_vocabulary.json"), encoding="utf-8"))["phase_seats"]
    nodes = {}
    for discipline in catalogue["disciplines"]:
        for node in discipline["nodes"]:
            match = node.get("match", {})
            if str(match.get("role", "")) != "defense":
                continue
            effects = match.get("effects", {})
            nodes[node["id"]] = {
                "discipline": discipline["id"],
                "tier": int(node.get("tier", 1)),
                "magnitude": sum(abs(float(v)) for v in effects.values()),
                "seats": sorted({s for p in match.get("phases", []) for s in phase_seats.get(p, [])}),
                "keys": set(effects),
            }
    all_keys = set().union(*(n["keys"] for n in nodes.values()))
    print("catalogue defence nodes: %d, effect keys: %d" % (len(nodes), len(all_keys)))

    json_path = os.path.join(RESEARCH, "U72_defence_answers.json")
    md_path = os.path.join(RESEARCH, "U72_DEFENCE_ANSWERS.md")
    check(os.path.exists(json_path), "U72_defence_answers.json exists")
    check(os.path.exists(md_path), "U72_DEFENCE_ANSWERS.md exists")
    if failures:
        return
    try:
        delivery = json.load(open(json_path, encoding="utf-8"))
        keys = delivery["keys"]
        rows = delivery["nodes"]
        disciplines = delivery["disciplines"]
    except Exception as error:  # noqa: BLE001
        check(False, "JSON loads with keys / nodes / disciplines (%s)" % error)
        return

    check(set(keys) == all_keys, "key table covers exactly the defence effect keys (missing %s, extra %s)"
          % (sorted(all_keys - set(keys)), sorted(set(keys) - all_keys)))
    for key, entry in keys.items():
        answers = entry.get("answers")
        check(isinstance(answers, list) and set(answers) <= set(CLASSES), "key %s answers %r are allowed classes" % (key, answers))
        check(bool(str(entry.get("reason", "")).strip()), "key %s has a reason" % key)
        if key in KEY_ANCHORS and isinstance(answers, list):
            need, forbid = KEY_ANCHORS[key]
            check(need <= set(answers) and not (forbid & set(answers)), "anchor key %s includes %s, excludes %s (got %s)" % (key, sorted(need), sorted(forbid), answers))

    check(set(rows) == set(nodes), "node rows cover exactly the defence nodes (missing %s, extra %s)"
          % (sorted(set(nodes) - set(rows)), sorted(set(rows) - set(nodes))))
    effective = {}
    for node_id, truth in nodes.items():
        row = rows.get(node_id)
        if row is None:
            continue
        check(row.get("discipline") == truth["discipline"], "%s discipline" % node_id)
        check(int(row.get("tier", -1)) == truth["tier"], "%s tier" % node_id)
        check(close(row.get("magnitude"), truth["magnitude"]), "%s magnitude %.1f" % (node_id, truth["magnitude"]))
        check(sorted(row.get("seats", [])) == truth["seats"], "%s seats %s (from phase_seats)" % (node_id, truth["seats"]))
        union = set()
        for key in truth["keys"]:
            union |= set(keys.get(key, {}).get("answers", []) or [])
        answers = set(row.get("answers", []) or [])
        check(answers <= set(CLASSES), "%s answers are allowed classes" % node_id)
        if answers != union:
            check(bool(str(row.get("override_reason", "")).strip()), "%s answers differ from its keys' union %s, so override_reason is required" % (node_id, sorted(union)))
        if node_id in NODE_ANCHORS:
            need, forbid = NODE_ANCHORS[node_id]
            check(need <= answers and not (forbid & answers), "anchor node %s includes %s, excludes %s (got %s)" % (node_id, sorted(need), sorted(forbid), sorted(answers)))
        effective[node_id] = answers

    ids_by_discipline = {}
    for node_id, truth in nodes.items():
        ids_by_discipline.setdefault(truth["discipline"], []).append(node_id)
    check(set(disciplines) == set(ids_by_discipline), "discipline rows cover exactly the disciplines with defence nodes")
    for discipline_id, ids in ids_by_discipline.items():
        row = disciplines.get(discipline_id)
        if row is None:
            continue
        total = sum(nodes[i]["magnitude"] for i in ids)
        tier12 = sum(nodes[i]["magnitude"] for i in ids if nodes[i]["tier"] <= 2)
        check(int(row.get("nodes", -1)) == len(ids), "%s node count %d" % (discipline_id, len(ids)))
        check(close(row.get("magnitude"), total), "%s magnitude %.1f" % (discipline_id, total))
        check(close(row.get("bonus_all"), min(total / 40.0, 0.35)), "%s bonus_all" % discipline_id)
        check(close(row.get("bonus_tier12"), min(tier12 / 40.0, 0.35)), "%s bonus_tier12" % discipline_id)
        grid = row.get("seat_answer_all", {})
        for seat in SEATS:
            for klass in CLASSES:
                expected = min(sum(nodes[i]["magnitude"] for i in ids if seat in nodes[i]["seats"] and klass in effective.get(i, set())) / 40.0, 0.35)
                got = (grid.get(seat, {}) or {}).get(klass)
                check(close(got, expected), "%s seat_answer_all[%s][%s] = %.3f (got %r)" % (discipline_id, seat, klass, expected, got))

    memo = open(md_path, encoding="utf-8").read()
    check("wrestling_sprawl" in memo, "memo discusses wrestling_sprawl")
    for option in ("(a)", "(b)", "(c)"):
        check(option in memo, "memo lays out option %s" % option)
    check(len(memo.split()) >= 300, "memo is a memo, not a stub (>= 300 words)")


if __name__ == "__main__":
    main()
    print("U72_CHECK failures=%d" % len(failures))
    sys.exit(1 if failures else 0)

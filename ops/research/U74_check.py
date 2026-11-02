#!/usr/bin/env python
"""U74's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U74_check.py

Recomputes every judo takedown's scoring line and class, and the summary shares, from the
catalogue and judo's live scoring profile. It does not choose an option.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
QUALITIES = ["0.7", "0.8", "0.9", "1.0"]
failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def main():
    data = os.path.join(ROOT, "Godot", "assets", "data")
    rulesets = json.load(open(os.path.join(data, "combat_rulesets.json"), encoding="utf-8"))
    items = rulesets.get("rulesets", rulesets)
    judo = [r for r in (items.values() if isinstance(items, dict) else items) if isinstance(r, dict) and r.get("id") == "judo"][0]
    profile = judo["scoring_profile"]
    threshold = float(profile["ippon_threshold"])
    band_min = min(float(b["min"]) for b in profile["throw_bands"])
    catalogue = json.load(open(os.path.join(data, "technique_catalog.json"), encoding="utf-8"))
    throws = {}
    for discipline in catalogue["disciplines"]:
        if discipline["id"] != "judo":
            continue
        for node in discipline["nodes"]:
            if node["match"].get("role") == "takedown":
                throws[node["id"]] = sum(abs(float(v)) for v in node["match"].get("effects", {}).values())

    def klass(mag, q):
        value = mag * float(q)
        if value >= threshold:
            return "ippon"
        return "waza_ari" if value >= band_min else "none"

    json_path = os.path.join(ROOT, "research", "U74_judo_throw_scores.json")
    md_path = os.path.join(ROOT, "research", "U74_JUDO_THROWS_OVERSCORE.md")
    check(os.path.exists(json_path), "U74_judo_throw_scores.json exists")
    check(os.path.exists(md_path), "U74_JUDO_THROWS_OVERSCORE.md exists")
    if failures:
        return
    try:
        delivery = json.load(open(json_path, encoding="utf-8"))
        rows = delivery["throws"]
        summary = delivery["summary"]
    except Exception as error:  # noqa: BLE001
        check(False, "JSON loads with throws / summary (%s)" % error)
        return
    check(abs(float(delivery.get("profile", {}).get("ippon_threshold", -1)) - threshold) < 1e-6
          and abs(float(delivery.get("profile", {}).get("waza_ari_min", -1)) - band_min) < 1e-6,
          "profile read from combat_rulesets.json (ippon %.1f, waza-ari %.1f)" % (threshold, band_min))
    ids = [str(r.get("id")) for r in rows]
    check(len(ids) == len(set(ids)) and set(ids) == set(throws), "throws cover exactly the %d judo takedowns" % len(throws))
    for row in rows:
        node_id = str(row.get("id"))
        if node_id not in throws:
            continue
        mag = throws[node_id]
        check(abs(float(row.get("magnitude", -1)) - mag) < 1e-6, "%s magnitude %.1f" % (node_id, mag))
        for key, line in (("waza_ari_at", band_min), ("ippon_at", threshold)):
            want = round(line / mag, 3) if line / mag <= 1.0 else None
            got = row.get(key)
            ok = (want is None and got is None) or (want is not None and isinstance(got, (int, float)) and abs(float(got) - want) <= 0.001)
            check(ok, "%s %s = %s (got %r)" % (node_id, key, want, got))
        for q in QUALITIES:
            check((row.get("class", {}) or {}).get(q) == klass(mag, q), "%s class at %s = %s" % (node_id, q, klass(mag, q)))
    for q in QUALITIES:
        counts = {"none": 0, "waza_ari": 0, "ippon": 0}
        for mag in throws.values():
            counts[klass(mag, q)] += 1
        for name, count in counts.items():
            want = round(count / float(len(throws)), 3)
            got = (summary.get(q, {}) or {}).get(name)
            check(isinstance(got, (int, float)) and abs(float(got) - want) <= 0.001, "summary %s %s = %.3f (got %r)" % (q, name, want, got))
    check(delivery.get("recommend") in ("a", "b", "c", "d"), "recommend names an option")
    memo = open(md_path, encoding="utf-8").read()
    for option in ("(a)", "(b)", "(c)"):
        check(option in memo, "memo lays out option %s" % option)
    check("J26" in memo and "U69" in memo, "memo reads J26's endings and U69's proposal")
    check(len(memo.split()) >= 350, "memo is a memo, not a stub (>= 350 words)")


if __name__ == "__main__":
    main()
    print("U74_CHECK failures=%d" % len(failures))
    sys.exit(1 if failures else 0)

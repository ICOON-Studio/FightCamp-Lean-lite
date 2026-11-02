#!/usr/bin/env python
"""Q82's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q82_check.py

It FETCHES the Godot source files the delivery cites and checks every listed option key
really appears on the line named; it checks every citation of OUR code points at a line
that carries the quoted token; and it derives from our two scripts which public steps the
comparison must cover. A network failure is a FAIL, never a silent pass.
"""
import json
import os
import re
import sys
import tempfile
import urllib.request

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
JSON_PATH = os.path.join(ROOT, "research/Q82_retarget_options.json")
MD_PATH = os.path.join(ROOT, "research/Q82_GODOT_RETARGET_VS_OURS.md")
OURS = ["Godot/scripts/FightClipRetarget.gd", "Godot/scripts/BoneRestFixer.gd"]
CACHE = os.path.join(tempfile.gettempdir(), "q82_check_cache")
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def fetch(url):
    os.makedirs(CACHE, exist_ok=True)
    local = os.path.join(CACHE, re.sub(r"[^A-Za-z0-9._-]", "_", url))
    if not os.path.isfile(local):
        req = urllib.request.Request(url, headers={"User-Agent": "FightCamp-Q82-check"})
        with urllib.request.urlopen(req, timeout=60) as r:
            open(local, "wb").write(r.read())
    return open(local, encoding="utf-8", errors="replace").read().splitlines()


def public_funcs(rel):
    text = open(os.path.join(ROOT, rel), encoding="utf-8").read()
    return {n for n in re.findall(r"^static func ([A-Za-z]\w*)\(", text, re.M)}


def main():
    if not check(os.path.isfile(JSON_PATH), "Q82_retarget_options.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return

    check("4.7" in str(data.get("godot_ref", "")), "godot_ref is not a 4.7 tag")
    sources = {}
    for s in data.get("sources", []):
        url = str(s.get("url", ""))
        ok = check(url.startswith("https://raw.githubusercontent.com/godotengine/godot/"), f"source {s.get('file')} is not a raw godotengine/godot URL")
        if ok:
            try:
                sources[os.path.basename(str(s.get("file", "")))] = fetch(url)
            except Exception as exc:  # noqa: BLE001
                check(False, f"could not fetch {url}: {exc}")
    names = set(sources)
    check(any(n.startswith("post_import_plugin_skeleton_rest_fixer") for n in names), "the rest fixer source is not among the sources")
    check(any(n.startswith("skeleton_profile") for n in names), "skeleton_profile.cpp is not among the sources")

    options = data.get("options", [])
    check(len(options) >= 8, f"only {len(options)} retarget options listed")
    for o in options:
        key, ref = str(o.get("key", "")), str(o.get("source_ref", ""))
        check(key.startswith("retarget/"), f"option {key!r} is not a retarget/ key")
        for field in ("type", "default", "what"):
            check(str(o.get(field, "")).strip() != "", f"option {key}: empty {field}")
        m = re.fullmatch(r"([\w.]+\.cpp):(\d+)", ref)
        if not check(m is not None, f"option {key}: source_ref {ref!r} is not <file>.cpp:<line>"):
            continue
        lines = sources.get(m.group(1))
        if not check(lines is not None, f"option {key}: {m.group(1)} is not one of the fetched sources"):
            continue
        n = int(m.group(2))
        leaf = key.split("/")[-1]
        window = lines[max(0, n - 2):n + 1]
        check(0 < n <= len(lines) and any(leaf in l for l in window),
              f"option {key}: '{leaf}' is not on {ref} (checked lines {n - 1}..{n + 1})")

    ours = data.get("ours", [])
    check(len(ours) >= 4, f"only {len(ours)} steps of ours compared")
    tokens = set()
    for step in ours:
        ref, tok = str(step.get("our_ref", "")), str(step.get("our_token", ""))
        m = re.fullmatch(r"(Godot/scripts/\w+\.gd):(\d+)", ref)
        if not check(m is not None and m.group(1) in OURS, f"step {step.get('step')!r}: our_ref {ref!r} is not a line in {OURS}"):
            continue
        lines = open(os.path.join(ROOT, m.group(1)), encoding="utf-8").read().splitlines()
        n = int(m.group(2))
        check(0 < n <= len(lines) and tok != "" and tok in lines[n - 1], f"step {step.get('step')!r}: token {tok!r} is not on {ref}")
        check(step.get("label") in ("SOURCED", "INFERENCE"), f"step {step.get('step')!r}: label must be SOURCED or INFERENCE")
        check(str(step.get("engine_equivalent", "")).strip() != "", f"step {step.get('step')!r}: engine_equivalent is empty (use NONE)")
        tokens.add(tok)
    required = public_funcs(OURS[1]) | ({"build_corrections", "retarget_clip"} & public_funcs(OURS[0]))
    missing = sorted(t for t in required if not any(t in tok for tok in tokens))
    check(not missing, f"the comparison never cites these public steps of ours: {missing}")

    eo = data.get("engine_only", [])
    check(len(eo) >= 1, "engine_only is empty - the useful finding is the difference")
    for e in eo:
        check(e.get("cause") in (1, 2, 3, 4), f"engine_only {e.get('option')!r}: cause must be 1-4")
        check(e.get("label") in ("SOURCED", "INFERENCE"), f"engine_only {e.get('option')!r}: label must be SOURCED or INFERENCE")

    recipe = data.get("recipe", {})
    check(recipe.get("clip") == "H2H_JabInPlace.FBX", "recipe.clip must be H2H_JabInPlace.FBX")
    keys = recipe.get("import_keys", {})
    check(isinstance(keys, dict) and len(keys) >= 2, "recipe.import_keys needs the actual keys and values")
    check("SkeletonProfileHumanoid" in json.dumps(recipe), "the recipe does not name SkeletonProfileHumanoid")
    check(str(data.get("verdict", "")).strip() != "", "verdict is empty")

    if check(os.path.isfile(MD_PATH), "Q82_GODOT_RETARGET_VS_OURS.md does not exist"):
        md = open(MD_PATH, encoding="utf-8").read()
        at = -1
        for section in ("DECISIONS", "OPTIONS", "OURS VS ENGINE", "RECIPE", "VERDICT"):
            m = re.search(r"^#+\s*" + re.escape(section) + r"\b", md, re.M | re.I)
            if check(m is not None, f"the markdown has no {section} section"):
                check(m.start() > at, f"section {section} is out of order")
                at = m.start()
        check("SOURCED" in md and "INFERENCE" in md, "the markdown does not label its claims SOURCED / INFERENCE")


main()
if failures:
    print(f"Q82_CHECK FAIL ({len(failures)})")
    for f in failures[:40]:
        print("  - " + f)
    sys.exit(1)
print("Q82_CHECK PASS")

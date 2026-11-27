"""make_site.py - the PUBLIC copy of Puncher's chance, for a host such as Render (S567).

Owner S567: "make it public with render so he doesnt need tailscale". Builds, into <target> (a checkout of the PRIVATE
test repo, never the main one), everything the public server needs and nothing else:

    python proto/twohands/tools/make_site.py <target folder> [--tester <label> ...]

  <target>/                 the pages (order, online, head, kick, punch, wait, scene, changelog), their scripts, vtable*.json
  <target>/img, snd         the pictures and sounds the pages load (no Godot .import files)
  <target>/tools/rules.mjs  the one tool the match server needs
  <target>/site/            public_server.mjs, match_server.mjs, notice.txt, testers.json (code HASHES only)
  <target>/package.json, render.yaml, README.md

THE CODES: one personal code a tester label (owner, brother, friend, ...). A code is made once and kept ON THIS PC in
proto/twohands/site/data/tester_codes.json (an ignored folder); only its hash goes into the copy. Run again after any
page change: the same codes stay valid. `--tester <label>` adds a tester.
"""
import hashlib
import io
import json
import secrets
import shutil
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
GAME = HERE.parent
SALT = "punchers-chance-test"
PAGES = ["order.html", "online.html", "head.html", "kick.html", "punch.html", "wait.html", "scene.html", "changelog.html"]
SCRIPTS = ["ring_ui.js", "body_ui.js", "strip_ui.js", "version.js", "online_ui.js", "scenes.js", "scene_ui.js", "clock_ui.js", "vtable.json", "vtable_wait.json"]


def main() -> None:
    args = sys.argv[1:]
    if not args:
        raise SystemExit(__doc__)
    target = Path(args[0]).resolve()
    extra = [args[i + 1] for i, a in enumerate(args) if a == "--tester" and i + 1 < len(args)]
    assert GAME not in target.parents and target != GAME, "the target is inside the game folder"
    target.mkdir(parents=True, exist_ok=True)
    for old in ["img", "snd", "tools", "site"]:
        shutil.rmtree(target / old, ignore_errors=True)
    for f in target.glob("*.html"):
        f.unlink()
    for name in PAGES + SCRIPTS:
        src = GAME / name
        assert src.exists(), f"missing {name}"
        shutil.copy2(src, target / name)
    n = 0
    for folder in ["img", "snd"]:
        for src in (GAME / folder).rglob("*"):
            if src.is_file() and src.suffix.lower() in (".webp", ".png", ".ogg", ".json"):
                dst = target / src.relative_to(GAME)
                dst.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(src, dst)
                n += 1
    (target / "tools").mkdir(exist_ok=True)
    shutil.copy2(HERE / "rules.mjs", target / "tools" / "rules.mjs")
    (target / "site").mkdir(exist_ok=True)
    for name in ["public_server.mjs", "match_server.mjs", "notice.txt"]:
        shutil.copy2(GAME / "site" / name, target / "site" / name)
    # the codes: kept on this PC only, hashed into the copy
    store = GAME / "site" / "data" / "tester_codes.json"
    store.parent.mkdir(parents=True, exist_ok=True)
    codes = json.loads(store.read_text(encoding="utf-8")) if store.exists() else {}
    for label in ["owner", "brother", "friend"] + extra:
        if label not in codes:
            codes[label] = "-".join(secrets.token_hex(2).upper() for _ in range(3))   # e.g. 3FA9-01BC-77D2: 48 bits
    store.write_text(json.dumps(codes, indent=1), encoding="utf-8")
    testers = [{"label": k, "hash": hashlib.sha256((SALT + v.replace("-", "")).encode()).hexdigest(), "owner": k == "owner"} for k, v in codes.items()]
    io.open(target / "site" / "testers.json", "w", encoding="utf-8", newline="\n").write(json.dumps(testers, indent=1) + "\n")
    io.open(target / "package.json", "w", encoding="utf-8", newline="\n").write(json.dumps({"name": "punchers-chance-test", "private": True, "type": "module", "scripts": {"start": "node site/public_server.mjs"}, "engines": {"node": ">=20"}}, indent=1) + "\n")
    io.open(target / "render.yaml", "w", encoding="utf-8", newline="\n").write(
        "# Render Blueprint: one free web service running our own small Node server (no package to install).\n"
        "services:\n  - type: web\n    name: punchers-chance-test\n    runtime: node\n    plan: free\n"
        "    buildCommand: node --version\n    startCommand: node site/public_server.mjs\n    healthCheckPath: /healthz\n"
        "    envVars:\n      - key: GATE_SECRET\n        generateValue: true\n      - key: NODE_VERSION\n        value: \"22\"\n")
    io.open(target / "README.md", "w", encoding="utf-8", newline="\n").write(
        "Puncher's chance - the public test copy. BUILT by proto/twohands/tools/make_site.py in the main repo: never edit here.\n"
        "Unreleased and confidential. The server asks every visitor for a personal code and the notice before any page.\n")
    io.open(target / ".gitattributes", "w", encoding="utf-8", newline="\n").write("* -text\n")
    print(f"SITE built in {target}: {len(PAGES)} pages, {n} pictures and sounds, {len(testers)} testers ({', '.join(codes)}). Codes: {store}")


if __name__ == "__main__":
    main()

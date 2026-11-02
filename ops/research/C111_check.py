"""C111 gate (written by Claude before launch). Run from the repo root: python research/C111_check.py

C111 maps Blender's Retarget add-on for headless use. Nothing here trusts Codex's list:
- every retarget-core operator the add-on source declares is DERIVED by scanning the add-on folder, and each must
  have a row; no row may name an idname the source does not declare;
- every quote must sit within 3 lines of its cited line in the cited file;
- every property row's quote is checked the same way;
- the headless sequence must name only operators that exist (as bpy.ops.<idname>) or plain bpy/python calls.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ADDON = Path(r"D:/Tools/Blender/blender-5.2.1-windows-x64/portable/extensions/user_default/retarget")
JSON_PATH = ROOT / "research" / "C111_retarget_addon_api.json"
MD_PATH = ROOT / "research" / "C111_RETARGET_ADDON_API.md"
## The add-on registers 158 operators, most of them keyframe and action-list helpers. A row is REQUIRED for every
## retarget-core operator, derived from the source: the armature.* namespace plus the mapping, preset, offset,
## rest-pose and IK operators. Rows for any other declared operator are allowed.
REQUIRED = re.compile(r"^armature\.|expy_kit|retarget_guess|bind_from_panel|create_offset|convert_bone_names|"
                      r"apply_as_rest_pose|armature_preset|retarget_set_ik|retarget_set_loc")
failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def declared_idnames():
    found = {}
    for py in ADDON.rglob("*.py"):
        for i, line in enumerate(py.read_text(encoding="utf-8", errors="replace").splitlines(), start=1):
            m = re.search(r"bl_idname\s*=\s*[\"']([a-z0-9_]+\.[a-z0-9_]+)[\"']", line)
            if m:
                found.setdefault(m.group(1), (py, i))
    return found


def quote_ok(rel, line_no, quote):
    path = ADDON / rel
    if not path.is_file():
        return False
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    return bool(quote.strip()) and any(quote.strip() in w for w in lines[max(0, line_no - 4):line_no + 3])


def main():
    if not ADDON.is_dir():
        fail("the add-on folder is missing: %s" % ADDON)
        return finish()
    for p in (JSON_PATH, MD_PATH):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()
    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    declared = declared_idnames()
    rows = data.get("operators", [])
    named = set()
    for i, row in enumerate(rows):
        missing = [k for k in ("idname", "file", "line", "quote", "poll", "context_needs", "what") if k not in row]
        if missing:
            fail("operator %d lacks %s" % (i, ", ".join(missing)))
            continue
        idname = str(row["idname"])
        named.add(idname)
        if idname not in declared:
            fail("operator %d names %s, which the add-on source never declares" % (i, idname))
        if not quote_ok(str(row["file"]), int(row["line"]), str(row["quote"])):
            fail("operator %s: quote %r is not within 3 lines of %s:%s" % (idname, row["quote"], row["file"], row["line"]))
        if not isinstance(row["context_needs"], list):
            fail("operator %s: context_needs is not a list" % idname)
    for idname, (py, line) in declared.items():
        if not REQUIRED.search(idname):
            continue
        if idname not in named:
            fail("the source declares %s (%s:%d) and it has no row" % (idname, py.relative_to(ADDON), line))
    for i, row in enumerate(data.get("properties", [])):
        if not all(k in row for k in ("path", "file", "line", "quote", "what")):
            fail("property %d lacks a key" % i)
        elif not quote_ok(str(row["file"]), int(row["line"]), str(row["quote"])):
            fail("property %s: quote is not within 3 lines of %s:%s" % (row["path"], row["file"], row["line"]))
    seq = data.get("headless_sequence", [])
    if not 3 <= len(seq) <= 12:
        fail("headless_sequence has %d steps; 3 to 12 expected" % len(seq))
    for step in seq:
        call = str(step.get("call", ""))
        for m in re.finditer(r"bpy\.ops\.([a-z0-9_]+\.[a-z0-9_]+)", call):
            if m.group(1) not in declared and not m.group(1).split(".")[0] in ("object", "anim", "import_scene",
                                                                              "export_scene", "pose", "nla",
                                                                              "wm", "screen"):
                fail("headless step calls bpy.ops.%s, which neither the add-on nor core Blender declares" % m.group(1))
        if not str(step.get("why", "")).strip():
            fail("headless step %r has no why" % call)
    md = MD_PATH.read_text(encoding="utf-8").splitlines()
    if next((l for l in md if l.strip()), "").strip() != "## DECISIONS":
        fail("the digest does not open with ## DECISIONS")
    if len(md) > 40:
        fail("the digest is %d lines, 40 at most" % len(md))
    print("declared operators: %d" % len(declared))
    return finish()


def finish():
    if failures:
        print("C111_check: %d failure(s)" % len(failures))
        sys.exit(1)
    print("C111_check: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()

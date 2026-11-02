"""C118 gate (written by Claude, 2026-09-14). Run from the repo root: python research/C118_check.py

Pins Codex's reading of Unreal 5.8's source to the source itself, never to Codex's own text:
- `defaults` must list EVERY defaulted field of the three Foot Placement settings structs, with the value the
  installed header declares (parsed here from AnimNode_FootPlacement.h),
- every citation's quote must be on the cited line of the installed file (within two lines either side),
- A1-A4 each rest on at least one .cpp line; each question has its minimum citation count,
- the digest opens with DECISIONS and has a section per question.
Never edit this file to pass: fix the JSON or the digest.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
JSON_PATH = os.path.join(RESEARCH, "C118_ue_citations.json")
DIGEST = os.path.join(RESEARCH, "C118_UE_REACH_AND_MIRROR.md")
UE = "C:/Program Files/Epic Games/UE_5.8/"
HEADER = UE + "Engine/Plugins/Animation/AnimationWarping/Source/Runtime/Public/BoneControllers/AnimNode_FootPlacement.h"
STRUCTS = ["FFootPlacementPlantSettings", "FFootPlacementPelvisSettings", "FFootPlacementInterpolationSettings"]
MINIMUM = {"A1": 2, "A2": 2, "A3": 2, "A4": 2, "B1": 2, "B2": 2, "B3": 1}
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def squash(text):
    return re.sub(r"\s+", "", text)


for path in (JSON_PATH, DIGEST, HEADER):
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    sys.exit(1)

header = open(HEADER, encoding="utf-8", errors="replace").read()
declared = {}
for struct in STRUCTS:
    match = re.search(r"struct\s+%s\b[^{]*\{(.*?)\n\};" % struct, header, re.S)
    if not match:
        fail("could not find struct %s in the header" % struct)
        continue
    body = re.sub(r"//[^\n]*", "", match.group(1))
    for field in re.finditer(r"^\s*[A-Za-z_][\w:<>]*\s+(\w+)\s*=\s*([^;]+);", body, re.M):
        declared["%s.%s" % (struct, field.group(1))] = field.group(2).strip()
if len(declared) < 20:
    fail("parsed only %d defaulted fields from the header - the parser or the header changed" % len(declared))

data = json.load(open(JSON_PATH, encoding="utf-8"))
defaults = data.get("defaults", {})
for key, raw in sorted(declared.items()):
    if key not in defaults:
        fail("defaults missing %s (header: %s)" % (key, raw))
        continue
    got = defaults[key]
    if raw in ("true", "false"):
        if got is not (raw == "true"):
            fail("defaults %s = %r, header says %s" % (key, got, raw))
        continue
    number = re.fullmatch(r"-?\d+(\.\d*)?f?", raw)
    if number:
        want = float(raw.rstrip("f"))
        if not isinstance(got, (int, float)) or isinstance(got, bool) or abs(float(got) - want) > 1e-6:
            fail("defaults %s = %r, header says %s" % (key, got, raw))
        continue
    if squash(str(got)) != squash(raw):
        fail("defaults %s = %r, header says %s" % (key, got, raw))
for key in defaults:
    if key not in declared:
        fail("defaults names %s, which the three structs do not declare with a default" % key)

counts = {key: 0 for key in MINIMUM}
cpp_backed = {key: False for key in MINIMUM}
for index, cite in enumerate(data.get("citations", [])):
    label = "citation %d (%s)" % (index, cite.get("id"))
    cid = cite.get("id")
    if cid not in MINIMUM:
        fail("%s: id must be one of %s" % (label, sorted(MINIMUM)))
        continue
    if not str(cite.get("claim", "")).strip():
        fail("%s: empty claim" % label)
    quote = str(cite.get("quote", ""))
    if len(squash(quote)) < 15:
        fail("%s: quote shorter than 15 non-space characters" % label)
        continue
    rel = str(cite.get("file", "")).replace("\\", "/").lstrip("/")
    path = UE + rel
    line = cite.get("line")
    if not os.path.isfile(path):
        fail("%s: no such file %s" % (label, path))
        continue
    if not isinstance(line, int) or line < 1:
        fail("%s: line must be a positive integer" % label)
        continue
    lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
    window = squash("".join(lines[max(0, line - 3):line + 2]))
    if squash(quote) not in window:
        fail("%s: quote not found at %s:%d (+-2 lines): %r" % (label, rel, line, quote[:80]))
        continue
    counts[cid] += 1
    if rel.endswith(".cpp"):
        cpp_backed[cid] = True

for cid, minimum in MINIMUM.items():
    if counts[cid] < minimum:
        fail("%s has %d verified citations, needs %d" % (cid, counts[cid], minimum))
for cid in ("A1", "A2", "A3", "A4"):
    if not cpp_backed[cid]:
        fail("%s rests on no .cpp line - a header comment says what a field is for, not what it does" % cid)

text = open(DIGEST, encoding="utf-8").read()
lines = text.splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("digest must open with '## DECISIONS'")
if len(lines) > 70:
    fail("digest is %d lines, 70 at most" % len(lines))
for cid in MINIMUM:
    if not re.search(r"^###\s+%s\b" % cid, text, re.M):
        fail("digest has no '### %s' section" % cid)

if fails:
    print("C118_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("C118_CHECK PASS defaults=%d citations=%d" % (len(declared), sum(counts.values())))

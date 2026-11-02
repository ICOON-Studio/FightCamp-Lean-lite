"""Q102 gate (written by Claude, 2026-09-14). Run from the repo root: python research/Q102_check.py

Pins Qwen's reading of Unreal 5.8's Offset Root Bone and Stride Warping nodes to the source itself, never to
Qwen's own text:
- `defaults` must list EVERY UPROPERTY field declared with a default in FAnimNode_OffsetRootBone and
  FAnimNode_StrideWarping, with the value the installed headers declare (parsed here),
- every citation's quote must be on the cited line of the installed file (within two lines either side),
- O1, O2, S1 and S2 each rest on at least one .cpp line; each question has its minimum citation count,
- the digest opens with DECISIONS (which labels INFERENCE), has a section per question, and every number it quotes
  from `defaults` matches the header.
Never edit this file to pass: fix the JSON or the digest. If it cannot pass, send BLOCKED - never commit a failing
reading.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
JSON_PATH = os.path.join(RESEARCH, "Q102_ue_citations.json")
DIGEST = os.path.join(RESEARCH, "Q102_UE_ROOT_OFFSET_AND_STRIDE.md")
UE = "C:/Program Files/Epic Games/UE_5.8/"
PUBLIC = UE + "Engine/Plugins/Animation/AnimationWarping/Source/Runtime/Public/BoneControllers/"
STRUCTS = [("FAnimNode_OffsetRootBone", PUBLIC + "AnimNode_OffsetRootBone.h"),
           ("FAnimNode_StrideWarping", PUBLIC + "AnimNode_StrideWarping.h")]
MINIMUM = {"O1": 3, "O2": 2, "S1": 3, "S2": 2, "R": 1}
CPP_REQUIRED = ["O1", "O2", "S1", "S2"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def squash(text):
    return re.sub(r"\s+", "", text)


for path in [JSON_PATH, DIGEST] + [header for _, header in STRUCTS]:
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    print("Q102_CHECK FAIL %d" % len(fails))
    sys.exit(1)

declared = {}
for struct, header_path in STRUCTS:
    header = open(header_path, encoding="utf-8", errors="replace").read()
    match = re.search(r"struct\s+%s\b[^{;]*\{(.*?)\n\};" % struct, header, re.S)
    if not match:
        fail("could not find struct %s in %s" % (struct, header_path))
        continue
    previous = ""
    for line in match.group(1).split("\n"):
        stripped = line.strip()
        if not stripped or stripped.startswith("//"):
            continue
        field = re.match(r"^[A-Za-z_][\w:<>]*\s+(\w+)\s*=\s*([^;]+);", stripped)
        if field and previous.startswith("UPROPERTY"):
            declared["%s.%s" % (struct, field.group(1))] = field.group(2).strip()
        previous = stripped
if len(declared) < 30:
    fail("parsed only %d UPROPERTY defaults from the headers - the parser or the headers changed" % len(declared))

try:
    data = json.load(open(JSON_PATH, encoding="utf-8"))
except ValueError as err:
    fail("Q102 JSON does not parse: %s" % err)
    print("Q102_CHECK FAIL %d" % len(fails))
    sys.exit(1)
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
    if re.fullmatch(r"-?\d+(\.\d*)?f?", raw):
        want = float(raw.rstrip("f").rstrip(".") or "0")
        if not isinstance(got, (int, float)) or isinstance(got, bool) or abs(float(got) - want) > 1e-6:
            fail("defaults %s = %r, header says %s" % (key, got, raw))
        continue
    if squash(str(got)) != squash(raw):
        fail("defaults %s = %r, header says %s" % (key, got, raw))
for key in defaults:
    if key not in declared:
        fail("defaults names %s, which is not a UPROPERTY default of the two structs" % key)

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
    source = open(path, encoding="utf-8", errors="replace").read().splitlines()
    window = squash("".join(source[max(0, line - 3):line + 2]))
    if squash(quote) not in window:
        fail("%s: quote not found at %s:%d (+-2 lines): %r" % (label, rel, line, quote[:80]))
        continue
    counts[cid] += 1
    if rel.endswith(".cpp"):
        cpp_backed[cid] = True

for cid, minimum in MINIMUM.items():
    if counts[cid] < minimum:
        fail("%s has %d verified citations, needs %d" % (cid, counts[cid], minimum))
for cid in CPP_REQUIRED:
    if not cpp_backed[cid]:
        fail("%s rests on no .cpp line - a header comment says what a field is for, not what it does" % cid)

text = open(DIGEST, encoding="utf-8").read()
lines = text.splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("digest must open with '## DECISIONS'")
if len(lines) > 80:
    fail("digest is %d lines, 80 at most" % len(lines))
for cid in MINIMUM:
    if not re.search(r"^###\s+%s\b" % cid, text, re.M):
        fail("digest has no '### %s' section" % cid)
decisions = text.split("\n###", 1)[0]
if "INFERENCE" not in decisions:
    fail("DECISIONS must label what is not in the code INFERENCE (R is a recommendation, not a citation)")
# A digest that quotes a default must quote the header's value: `FieldName = value` or `FieldName (value)`.
for key, raw in declared.items():
    field = key.split(".", 1)[1]
    if not re.fullmatch(r"-?\d+(\.\d*)?f?", raw):
        continue
    want = float(raw.rstrip("f").rstrip(".") or "0")
    for said in re.findall(r"\b%s\b\s*(?:=|\(|:)\s*(-?\d+(?:\.\d+)?)" % re.escape(field), text):
        if abs(float(said) - want) > 1e-6:
            fail("digest says %s = %s, the header says %s" % (field, said, raw))

if fails:
    print("Q102_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("Q102_CHECK PASS defaults=%d citations=%d" % (len(declared), sum(counts.values())))

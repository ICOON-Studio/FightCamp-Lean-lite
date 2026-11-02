"""C129 gate (written by Claude, 2026-09-14). Run from the repo root: python research/C129_check.py

Pins Codex's reading of Unreal 5.8's Stride Warping (how a step is lengthened or shortened) to the installed source itself,
never to Codex's own text:
- `defaults` must list EVERY field declared with a default directly after a UPROPERTY line in the structs and classes
  named in STRUCTS, with the value the installed headers declare (parsed here),
- every citation's quote must be on the cited line of the installed file (within two lines either side),
- S1-S5 each have their minimum citation count, and S2-S4 each rest on at least one .cpp line,
- the digest opens with DECISIONS, has a section per question and stays under its line cap.
Never edit this file to pass: fix the JSON or the digest.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
JSON_PATH = os.path.join(RESEARCH, "C129_ue_citations.json")
DIGEST = os.path.join(RESEARCH, "C129_UE_STRIDE_WARPING.md")
UE = "C:/Program Files/Epic Games/UE_5.8/"
PUBLIC = UE + "Engine/Plugins/Animation/AnimationWarping/Source/Runtime/Public/BoneControllers/"
STRUCTS = [
    ("FStrideWarpingFootDefinition", PUBLIC + "AnimNode_StrideWarping.h"),
    ("FAnimNode_StrideWarping", PUBLIC + "AnimNode_StrideWarping.h"),
]
MINIMUM = {"S1": 2, "S2": 3, "S3": 3, "S4": 2, "S5": 1}
CPP_REQUIRED = ["S2", "S3", "S4"]
MAX_DIGEST_LINES = 80
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def squash(text):
    return re.sub(r"\s+", "", text)


for path in [JSON_PATH, DIGEST] + sorted({header for _, header in STRUCTS}):
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    print("C129_CHECK FAIL %d" % len(fails))
    sys.exit(1)

FIELD = re.compile(r"^(?:[A-Za-z_][\w:]*(?:<[^;=]*>)?\*?\s+)+(\w+)\s*=\s*([^;]+);")
declared = {}
for struct, header_path in STRUCTS:
    header = open(header_path, encoding="utf-8", errors="replace").read()
    match = re.search(r"(?:class|struct)\s+(?:\w+_API\s+)?%s\b[^{;]*\{(.*?)\n\};" % struct, header, re.S)
    if not match:
        fail("could not find %s in %s" % (struct, header_path))
        continue
    previous = ""
    for line in match.group(1).split("\n"):
        stripped = line.strip()
        if not stripped or stripped.startswith("//"):
            continue
        field = FIELD.match(stripped)
        if field and previous.startswith("UPROPERTY") and previous.endswith(")"):
            declared["%s.%s" % (struct, field.group(1))] = field.group(2).strip()
        previous = stripped
if len(declared) < 8:
    fail("parsed only %d UPROPERTY defaults from the headers - the parser or the headers changed" % len(declared))

try:
    data = json.load(open(JSON_PATH, encoding="utf-8"))
except ValueError as err:
    fail("C129_ue_citations.json is not valid JSON: %s" % err)
    print("C129_CHECK FAIL %d" % len(fails))
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
        want = float(raw.rstrip("f"))
        if not isinstance(got, (int, float)) or isinstance(got, bool) or abs(float(got) - want) > 1e-6:
            fail("defaults %s = %r, header says %s" % (key, got, raw))
        continue
    if squash(str(got)) != squash(raw):
        fail("defaults %s = %r, header says %s" % (key, got, raw))
for key in defaults:
    if key not in declared:
        fail("defaults names %s, which is not a UPROPERTY default of the listed structs/classes" % key)

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
    if not isinstance(line, int) or isinstance(line, bool) or line < 1:
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
        fail("%s rests on no .cpp line - a header says what a field is for, the .cpp says what it does" % cid)

text = open(DIGEST, encoding="utf-8").read()
lines = text.splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("digest must open with '## DECISIONS'")
if len(lines) > MAX_DIGEST_LINES:
    fail("digest is %d lines, %d at most" % (len(lines), MAX_DIGEST_LINES))
for cid in MINIMUM:
    if not re.search(r"^###\s+%s\b" % cid, text, re.M):
        fail("digest has no '### %s' section" % cid)
if not re.search(r"^###\s+FOR OUR STEPPING JAB\b", text, re.M):
    fail("digest has no '### FOR OUR STEPPING JAB' section")

if fails:
    print("C129_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("C129_CHECK PASS defaults=%d citations=%d" % (len(declared), sum(counts.values())))

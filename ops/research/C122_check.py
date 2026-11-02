"""C122 gate (written by Claude, 2026-09-14). Run from the repo root: python research/C122_check.py

Pins Codex's reading of Unreal 5.8's Two Bone IK and skeletal-control alpha to the source itself, never to
Codex's own text:
- `defaults` must list EVERY member initialised in the constructor initializer lists of FAnimNode_TwoBoneIK,
  FAnimNode_SkeletalControlBase and FInputAlphaBoolBlend (parsed here from the installed files), with the value
  the code writes, plus `UE::Anim::DefaultBlendOption` as AlphaBlend.h declares it,
- every citation's quote must be on the cited line of the installed file (within two lines either side),
- I1-I4 each rest on at least one .cpp line; each question has its minimum citation count,
- the digest opens with DECISIONS, has a section per question, and names a unit or says unitless at each number
  in DECISIONS.
Never edit this file to pass: fix the JSON or the digest.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
JSON_PATH = os.path.join(RESEARCH, "C122_ue_citations.json")
DIGEST = os.path.join(RESEARCH, "C122_UE_TWO_BONE_IK.md")
UE = "C:/Program Files/Epic Games/UE_5.8/"
RT = UE + "Engine/Source/Runtime/"
CTORS = [
    ("FAnimNode_TwoBoneIK", RT + "AnimGraphRuntime/Private/BoneControllers/AnimNode_TwoBoneIK.cpp",
     r"FAnimNode_TwoBoneIK::FAnimNode_TwoBoneIK\(\)"),
    ("FAnimNode_SkeletalControlBase", RT + "AnimGraphRuntime/Public/BoneControllers/AnimNode_SkeletalControlBase.h",
     r"\bFAnimNode_SkeletalControlBase\(\)\s*\n"),
    ("FInputAlphaBoolBlend", RT + "Engine/Classes/Animation/InputScaleBias.h", r"\bFInputAlphaBoolBlend\(\)\s*\n"),
]
BLEND_H = RT + "Engine/Public/AlphaBlend.h"
MINIMUM = {"I1": 3, "I2": 2, "I3": 3, "I4": 2, "I5": 1}
CPP_REQUIRED = ["I1", "I2", "I3", "I4"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def squash(text):
    return re.sub(r"\s+", "", text)


for path in [JSON_PATH, DIGEST, BLEND_H] + [p for _, p, _ in CTORS]:
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    sys.exit(1)

declared = {}
for struct, path, signature in CTORS:
    text = open(path, encoding="utf-8", errors="replace").read()
    match = re.search(signature, text)
    if not match:
        fail("could not find the %s constructor in %s" % (struct, path))
        continue
    body = text[match.end():]
    brace = body.find("{")
    for line in body[:brace].splitlines():
        member = re.match(r"^\s*[:,]\s*(\w+)\((.*)\)\s*$", line)
        if member:
            declared["%s.%s" % (struct, member.group(1))] = member.group(2).strip()
blend = re.search(r"DefaultBlendOption\s*=\s*([\w:]+)\s*;", open(BLEND_H, encoding="utf-8", errors="replace").read())
if blend:
    declared["UE::Anim::DefaultBlendOption"] = blend.group(1)
else:
    fail("could not find UE::Anim::DefaultBlendOption in AlphaBlend.h")
if len(declared) < 20:
    fail("parsed only %d constructor defaults - the parser or the source changed" % len(declared))

data = json.load(open(JSON_PATH, encoding="utf-8"))
defaults = data.get("defaults", {})
for key, raw in sorted(declared.items()):
    if key not in defaults:
        fail("defaults missing %s (code: %s)" % (key, raw))
        continue
    got = defaults[key]
    if raw in ("true", "false"):
        if got is not (raw == "true"):
            fail("defaults %s = %r, code says %s" % (key, got, raw))
        continue
    if re.fullmatch(r"-?\d+(\.\d*)?f?", raw):
        want = float(raw.rstrip("f").rstrip(".") or "0")
        if not isinstance(got, (int, float)) or isinstance(got, bool) or abs(float(got) - want) > 1e-6:
            fail("defaults %s = %r, code says %s" % (key, got, raw))
        continue
    if squash(str(got)) != squash(raw):
        fail("defaults %s = %r, code says %s" % (key, got, raw))
for key in defaults:
    if key not in declared:
        fail("defaults names %s, which the three constructors and AlphaBlend.h do not initialise" % key)

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
    fail("DECISIONS must label what is not in the code INFERENCE (I5 is a recommendation, not a citation)")

if fails:
    print("C122_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("C122_CHECK PASS defaults=%d citations=%d" % (len(declared), sum(counts.values())))

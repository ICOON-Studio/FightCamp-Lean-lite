"""U122 gate — re-validate FBX bake-rate census from bytes and JSON arithmetic.

    python research/U122_check.py

Run 1's check recomputed the same wrong formula as the census. This gate re-reads
KeyTime deltas from the FBX files themselves for spot checks and motifect control.
"""
from __future__ import annotations

import json
import os
import random
import statistics
import struct
import sys
import zlib

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
JSON_PATH = os.path.join(ROOT, "research", "U122_fbx_rates.json")
FBX_TICK = 46186158000.0
MOTIFECT_MARK = "/motifect/" 
MOTIFECT_FBX = "/FBX/"

fails: list[str] = []


def fail(msg: str) -> None:
    fails.append(msg)
    print("FAIL " + msg)


class _Node:
    def __init__(self, name, props, children):
        self.name, self.props, self.children = name, props, children


def _property(data, offset, code):
    if code == "Y":
        return struct.unpack_from("<h", data, offset)[0], offset + 2
    if code == "C":
        return bool(data[offset]), offset + 1
    if code == "I":
        return struct.unpack_from("<i", data, offset)[0], offset + 4
    if code == "F":
        return struct.unpack_from("<f", data, offset)[0], offset + 4
    if code == "D":
        return struct.unpack_from("<d", data, offset)[0], offset + 8
    if code == "L":
        return struct.unpack_from("<q", data, offset)[0], offset + 8
    if code in "SR":
        length = struct.unpack_from("<I", data, offset)[0]
        start = offset + 4
        raw = data[start:start + length]
        return (raw.decode("utf-8", "replace") if code == "S" else raw), start + length
    if code in "f d l i b".split():
        count, encoding, compressed = struct.unpack_from("<III", data, offset)
        start = offset + 12
        raw = data[start:start + compressed]
        if encoding == 1:
            raw = zlib.decompress(raw)
        formats = {"f": "<%df", "d": "<%dd", "l": "<%dq", "i": "<%di", "b": "<%dB"}
        values = struct.unpack(formats[code] % count, raw) if count else ()
        return list(values), start + compressed
    raise ValueError("unknown FBX property code " + code)


def _parse_nodes(data, start, limit, wide):
    nodes = []
    header = 25 if wide else 13
    while start + header <= limit:
        if wide:
            end, count, prop_len = struct.unpack_from("<QQQ", data, start)
            name_len = data[start + 24]
        else:
            end, count, prop_len = struct.unpack_from("<III", data, start)
            name_len = data[start + 12]
        if end == 0:
            break
        name_start = start + header
        name = data[name_start:name_start + name_len].decode("utf-8", "replace")
        prop_start = name_start + name_len
        props, cursor = [], prop_start
        for _ in range(count):
            code = chr(data[cursor])
            value, cursor = _property(data, cursor + 1, code)
            props.append(value)
        child_start = prop_start + prop_len
        children = _parse_nodes(data, child_start, end, wide) if child_start < end else []
        nodes.append(_Node(name, props, children))
        start = end
    return nodes


def _walk(node):
    yield node
    for child in node.children:
        yield from _walk(child)


def _busiest_keytimes(path: str) -> list[int] | None:
    with open(path, "rb") as stream:
        data = stream.read()
    if not data.startswith(b"Kaydara FBX Binary"):
        return None
    version = struct.unpack_from("<I", data, 23)[0]
    roots = _parse_nodes(data, 27, len(data), version >= 7500)
    best = None
    for root in roots:
        for node in _walk(root):
            if node.name != "AnimationCurve":
                continue
            for child in node.children:
                if child.name != "KeyTime" or not child.props:
                    continue
                values = child.props[0]
                if isinstance(values, list) and (best is None or len(values) > len(best)):
                    best = values
    return best


def _hz_from_keytimes(keytimes: list[int]) -> float:
    deltas = [keytimes[i + 1] - keytimes[i] for i in range(len(keytimes) - 1)]
    med = statistics.median(deltas)
    if med <= 0:
        return 0.0
    return FBX_TICK / med


def _is_motifect_fbx(rel_path: str) -> bool:
    low = rel_path.replace("\\", "/").lower()
    return MOTIFECT_MARK in low and MOTIFECT_FBX.lower() in low and low.endswith(".fbx")


if not os.path.isfile(JSON_PATH):
    fail("missing %s" % JSON_PATH)
    print("U122_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)

with open(JSON_PATH, encoding="utf-8") as stream:
    data = json.load(stream)

rows = data.get("files", [])
summary = data.get("summary", {})

if summary.get("total", 0) < 240:
    fail("summary.total=%s is under 240" % summary.get("total"))

parsed_rows = [r for r in rows if r.get("status") == "ok"]
unreadable_rows = [r for r in rows if r.get("status") == "unreadable"]
losing_rows = [r for r in parsed_rows if r.get("loses_at_30")]

if len(rows) != summary.get("total", -1):
    fail("row count %d != summary.total %s" % (len(rows), summary.get("total")))
if len(parsed_rows) != summary.get("parsed", -1):
    fail("parsed rows %d != summary.parsed %s" % (len(parsed_rows), summary.get("parsed")))
if len(unreadable_rows) != summary.get("unreadable", -1):
    fail("unreadable rows %d != summary.unreadable %s"
         % (len(unreadable_rows), summary.get("unreadable")))
if len(losing_rows) != summary.get("losing_at_30", -1):
    fail("losing rows %d != summary.losing_at_30 %s"
         % (len(losing_rows), summary.get("losing_at_30")))

for row in parsed_rows:
    hz = float(row.get("native_hz", 0.0))
    want_lose = hz > 31.0
    if bool(row.get("loses_at_30")) != want_lose:
        fail("%s loses_at_30=%s but native_hz=%.4f" % (
            row.get("path"), row.get("loses_at_30"), hz))
    keys = int(row.get("keys", 0))
    span_s = float(row.get("span_s", 0.0))
    if keys > 1 and span_s <= 0.0:
        fail("%s has keys=%d but span_s=%.6f" % (row.get("path"), keys, span_s))

motifect = [r for r in parsed_rows if _is_motifect_fbx(str(r.get("path", "")))]
if len(motifect) != 40:
    fail("expected 40 motifect FBX rows, found %d" % len(motifect))
for row in motifect:
    hz = float(row.get("native_hz", 0.0))
    if abs(hz - 30.0) > 0.5:
        fail("motifect %s native_hz=%.4f not within 0.5 Hz of 30" % (row.get("path"), hz))

if parsed_rows:
    random.seed(122)
    sample = random.sample(parsed_rows, min(10, len(parsed_rows)))
    for row in sample:
        rel = str(row.get("path", ""))
        path = os.path.join(ROOT, rel.replace("/", os.sep))
        if not os.path.isfile(path):
            fail("missing FBX for spot check: %s" % rel)
            continue
        keytimes = _busiest_keytimes(path)
        if not keytimes or len(keytimes) < 2:
            fail("spot check could not read KeyTime for %s" % rel)
            continue
        measured = _hz_from_keytimes(keytimes)
        stored = float(row.get("native_hz", 0.0))
        if abs(measured - stored) > 0.5:
            fail("%s stored native_hz=%.4f but KeyTime median says %.4f"
                 % (rel, stored, measured))

if fails:
    print("U122_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)

print("U122_CHECK PASS total=%d parsed=%d losing_at_30=%d motifect=%d"
      % (summary.get("total", 0), summary.get("parsed", 0),
         summary.get("losing_at_30", 0), len(motifect)))
sys.exit(0)

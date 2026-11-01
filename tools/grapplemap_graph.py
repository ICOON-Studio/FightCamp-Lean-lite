"""S335 GrappleMap graph: which position each transition starts from and ends in (the website's "in" and "out" lists).

GrappleMap (src/positions.cpp is_reoriented) treats two keyframes as the same position when one is the other turned
about the vertical, moved, mirrored (left/right limbs swapped) and/or with the two men swapped. Joint-to-joint distances
do not change under a turn or a move, so a keyframe's signature is its distance matrix over 16 joints of both men, tried
under the 4 relabelings. Writes assets/grapplemap/graph.json: {positions: [{id, title, tags}], transitions:
[{id, title, tags, frames, from, to, bidirectional}]} with ids = the sequence's index in GrappleMap.txt (GrappleMapDB order).
Usage: python tools/grapplemap_graph.py   (reads/writes under assets/grapplemap/)
"""
import json
import os
import sys

import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "assets", "grapplemap", "GrappleMap.txt")
OUT = os.path.join(ROOT, "assets", "grapplemap", "graph.json")
DIGITS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
JOINTS = ["LeftToe", "RightToe", "LeftHeel", "RightHeel", "LeftAnkle", "RightAnkle", "LeftKnee", "RightKnee",
          "LeftHip", "RightHip", "LeftShoulder", "RightShoulder", "LeftElbow", "RightElbow", "LeftWrist", "RightWrist",
          "LeftHand", "RightHand", "LeftFingers", "RightFingers", "Core", "Neck", "Head"]
PICK = ["LeftAnkle", "RightAnkle", "LeftKnee", "RightKnee", "LeftWrist", "RightWrist", "Core", "Head"]
TOL = 0.03  # metres, mean distance difference (the file's digits are 1 mm; edits drift a little)


def parse(text):
    seqs, desc, digits = [], [], ""
    for line in text.split("\n"):
        line = line.rstrip("\r")
        if line.startswith(" "):
            if desc:
                seqs.append(sequence(desc))
                desc = []
            digits += line.strip()
            while len(digits) >= 276:
                seqs[-1]["frames"].append(decode(digits[:276]))
                digits = digits[276:]
        elif line:
            desc.append(line)
    return seqs


def sequence(desc):
    s = {"title": [], "tags": [], "props": [], "frames": []}
    for d in desc:
        if d.startswith("tags:"):
            s["tags"] += d[5:].split()
        elif d.startswith("properties:"):
            s["props"] += d[11:].split()
        elif d.startswith("ref:"):
            pass
        else:
            s["title"].append(d.replace("\\n", " "))
    s["title"] = " ".join(s["title"]).strip()
    return s


def decode(d):
    v = [(DIGITS.index(d[i]) * 62 + DIGITS.index(d[i + 1])) / 1000.0 for i in range(0, 276, 2)]
    a = np.array(v).reshape(2, 23, 3)
    a[:, :, 0] -= 2.0
    a[:, :, 2] -= 2.0
    return a


def mirror_idx(name):
    return JOINTS.index(name.replace("Left", "#").replace("Right", "Left").replace("#", "Right"))


SEL = [JOINTS.index(n) for n in PICK]
SEL_M = [mirror_idx(n) for n in PICK]


def points(frame, swap, mirror):
    a, b = (frame[1], frame[0]) if swap else (frame[0], frame[1])
    idx = SEL_M if mirror else SEL
    return np.concatenate([a[idx], b[idx]])


def sig(p):
    d = p[:, None, :] - p[None, :, :]
    return np.sqrt((d ** 2).sum(-1))[np.triu_indices(len(p), 1)]


def main():
    seqs = parse(open(SRC, encoding="utf-8").read())
    pos_ids = [i for i, s in enumerate(seqs) if len(s["frames"]) == 1]
    base = np.stack([sig(points(seqs[i]["frames"][0], False, False)) for i in pos_ids])

    def match(frame):
        best, best_err = None, TOL
        for swap in (False, True):
            for mirror in (False, True):
                err = np.abs(base - sig(points(frame, swap, mirror))).mean(1)
                k = int(err.argmin())
                if err[k] < best_err:
                    best, best_err = pos_ids[k], float(err[k])
        return best

    out = {"positions": [], "transitions": []}
    for i in pos_ids:
        out["positions"].append({"id": i, "title": seqs[i]["title"], "tags": seqs[i]["tags"]})
    linked = 0
    for i, s in enumerate(seqs):
        if len(s["frames"]) < 2:
            continue
        f, t = match(s["frames"][0]), match(s["frames"][-1])
        linked += (f is not None) + (t is not None)
        out["transitions"].append({"id": i, "title": s["title"], "tags": s["tags"], "frames": len(s["frames"]),
                                   "from": f, "to": t, "bidirectional": "bidirectional" in s["props"]})
    json.dump(out, open(OUT, "w", encoding="utf-8"), indent=0)
    n = len(out["transitions"])
    print("GRAPH positions=%d transitions=%d ends_linked=%d/%d" % (len(pos_ids), n, linked, 2 * n))
    return 0


if __name__ == "__main__":
    sys.exit(main())

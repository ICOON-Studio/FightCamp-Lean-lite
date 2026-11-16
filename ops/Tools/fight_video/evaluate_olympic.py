"""Score the analyzer against the referee labels of the Olympic Boxing Punch Classification set.  (Claude, S495)
usage: python evaluate_olympic.py <dataset_dir> <work_dir> <VIDEO_NAME> [<VIDEO_NAME> ...] [--json out.json]

<work_dir>/<NAME>_boxers.npz must exist (pose.py then track.py). The labels: one short track per punch (a box around the
glove and the target over ~5 frames) with one of 8 Polish labels = {head, body, block, miss} x {left, right} hand.
They carry NO punch type (jab / hook / ...), so type is scored elsewhere (evaluate_boxingvi.py).

A detection MATCHES a label when its impact frame is within TOL frames of the label's frames and its glove is within
one box diagonal of the label box centre; each label and each detection is used once (nearest in time first).
  recall    = labels matched / labels            (how many real punches we found)
  precision = detections matched / detections   (how many of ours were real)
  ceiling   = labels where the pose stage saw BOTH boxers at that moment: no rule can find more than this."""
import glob
import json
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import punches  # noqa: E402

TOL = 8  # frames at 50 fps = 0.16 s
LABELS = {"Głowa": ("head", "landed"), "Korpus": ("body", "landed"), "Blok": ("?", "blocked"), "Chybienie": ("?", "missed")}


def load_labels(dataset_dir, name):
    path = glob.glob(os.path.join(dataset_dir, "task_*_%s" % name.lower(), "annotations.json"))[0]
    out = []
    for tr in json.load(open(path, encoding="utf-8"))[0]["tracks"]:
        word = tr["label"].split()[0]
        target, result = LABELS[word]
        hand = "left" if "lewą" in tr["label"] else "right"
        shapes = [s for s in tr["shapes"] if not s.get("outside")] or tr["shapes"]
        pts = np.array([s["points"] for s in shapes], np.float32)
        frames = [s["frame"] for s in tr["shapes"]]
        out.append(dict(start=min(frames), end=max(frames), centre=[float(pts[:, [0, 2]].mean()), float(pts[:, [1, 3]].mean())],
                        diag=float(np.hypot(pts[:, 2] - pts[:, 0], pts[:, 3] - pts[:, 1]).mean()), hand=hand, target=target, result=result))
    return sorted(out, key=lambda g: g["start"])


def match(labels, events):
    pairs = []
    for gi, g in enumerate(labels):
        for ei, ev in enumerate(events):
            f = ev["frame"]
            dt = 0 if g["start"] <= f <= g["end"] else min(abs(f - g["start"]), abs(f - g["end"]))
            if dt > TOL:
                continue
            if np.hypot(ev["m"]["glove"][0] - g["centre"][0], ev["m"]["glove"][1] - g["centre"][1]) > g["diag"]:
                continue
            pairs.append((dt, gi, ei))
    used_g, used_e, out = set(), set(), []
    for dt, gi, ei in sorted(pairs):
        if gi in used_g or ei in used_e:
            continue
        used_g.add(gi), used_e.add(ei)
        out.append((gi, ei))
    return out


def score_video(dataset_dir, work_dir, name, params=None, log=lambda *a: None, events=None):
    labels = load_labels(dataset_dir, name)
    boxers = np.load(os.path.join(work_dir, name + "_boxers.npz"))
    if events is None:
        events, info, _ = punches.detect(boxers, params, log)
    frame_to_i = {int(f): i for i, f in enumerate(boxers["frame"])}
    both = [bool(boxers["seen"][frame_to_i[min(g["end"], int(boxers["frame"][-1]))]].all()) for g in labels]
    pairs = match(labels, events)
    return dict(name=name, labels=labels, events=events, pairs=pairs, both=both)


def summarise(results):
    """Pooled numbers over several videos."""
    L = sum(len(r["labels"]) for r in results)
    E = sum(len(r["events"]) for r in results)
    M = sum(len(r["pairs"]) for r in results)
    ceil = sum(sum(r["both"]) for r in results)
    out = dict(labels=L, detections=E, matched=M, recall=M / max(1, L), precision=M / max(1, E), ceiling=ceil / max(1, L))
    out["recall_when_both_seen"] = sum(sum(1 for gi, _ in r["pairs"] if r["both"][gi]) for r in results) / max(1, ceil)
    hand_ok = n_hand = tgt_ok = n_tgt = 0
    conf = {a: {b: 0 for b in ("landed", "blocked", "missed", "?")} for a in ("landed", "blocked", "missed")}
    found_by = {a: [0, 0] for a in ("landed", "blocked", "missed")}
    for r in results:
        hit = {gi: ei for gi, ei in r["pairs"]}
        for gi, g in enumerate(r["labels"]):
            found_by[g["result"]][1] += 1
            if gi not in hit:
                continue
            found_by[g["result"]][0] += 1
            ev = r["events"][hit[gi]]
            n_hand += 1
            hand_ok += ev["hand"] == g["hand"]
            if g["target"] != "?" and ev["target"] != "?":
                n_tgt += 1
                tgt_ok += ev["target"] == g["target"]
            conf[g["result"]][ev["result"]] += 1
    out["hand_accuracy"] = hand_ok / max(1, n_hand)
    out["target_accuracy"] = tgt_ok / max(1, n_tgt)
    out["target_n"] = n_tgt
    out["result_confusion"] = conf
    out["recall_by_label"] = {k: v[0] / max(1, v[1]) for k, v in found_by.items()}
    res_ok = sum(conf[a][a] for a in conf)
    out["result_accuracy"] = res_ok / max(1, sum(sum(conf[a].values()) for a in conf))
    return out


def print_summary(s, title):
    print("== %s" % title)
    print("labels %d | detections %d | matched %d" % (s["labels"], s["detections"], s["matched"]))
    print("recall %.1f%%  precision %.1f%%  | ceiling (both boxers seen) %.1f%%, recall inside it %.1f%%" % (
        100 * s["recall"], 100 * s["precision"], 100 * s["ceiling"], 100 * s["recall_when_both_seen"]))
    print("found by label: " + ", ".join("%s %.0f%%" % (k, 100 * v) for k, v in s["recall_by_label"].items()))
    print("on matched punches: hand %.1f%%, head/body %.1f%% (n=%d), landed/blocked/missed %.1f%%" % (
        100 * s["hand_accuracy"], 100 * s["target_accuracy"], s["target_n"], 100 * s["result_accuracy"]))
    print("result confusion (rows = referee, columns = ours: landed blocked missed):")
    for a, row in s["result_confusion"].items():
        print("   %-8s %4d %4d %4d" % (a, row["landed"], row["blocked"], row["missed"]))


if __name__ == "__main__":
    a = sys.argv
    names = [x for x in a[3:] if not x.startswith("--") and not x.endswith(".json")]
    results = []
    for nm in names:
        r = score_video(a[1], a[2], nm)
        results.append(r)
        s = summarise([r])
        print("%s: labels %d det %d matched %d recall %.0f%% precision %.0f%% ceiling %.0f%%" % (
            nm, s["labels"], s["detections"], s["matched"], 100 * s["recall"], 100 * s["precision"], 100 * s["ceiling"]))
    total = summarise(results)
    print_summary(total, "pooled over %d videos" % len(results))
    if "--json" in a:
        json.dump(total, open(a[a.index("--json") + 1], "w"), indent=1)

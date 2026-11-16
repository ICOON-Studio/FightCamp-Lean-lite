"""Punch-TYPE classifier on the pose descriptor, trained and scored on BoxingVI.  (Claude, S495)
usage: python train_type.py <boxingvi_dir> <models_dir> [--no-save]     (needs scikit-learn: use the venv)

BoxingVI (arXiv 2511.16524; github Bikudebug/BoxingVI; NO licence file - used here to measure and to build a private
model, never committed or shipped): per video one array of punch clips (N, 25 frames, 17 COCO joints, x,y as a share
of the picture) and a sheet of (start, end, class), 6 classes. Its sources are single-person bag and shadow-boxing
workouts filmed from the front at 24-30 fps - NOT fights. V6 has another array layout and is left out.

Honest scoring = LEAVE ONE VIDEO OUT: train on 8 videos (8 people), test on the 9th person, 9 times; every clip is
tested exactly once by a model that never saw that person. Reported: accuracy, and precision / recall per class, for
  (a) the no-training rule (elbow angle / rise; lead or rear cannot be told by a rule without an opponent),
  (b) the trained classifier (gradient-boosted trees on the descriptor), 6 classes and the 3 families.
Then one model is fitted on all 9 videos and saved as <models_dir>/punch_type.pkl."""
import os
import pickle
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import descriptor  # noqa: E402

CLASSES = ["jab", "cross", "lead hook", "rear hook", "lead uppercut", "rear uppercut"]
FAMILY = {"jab": "straight", "cross": "straight", "lead hook": "hook", "rear hook": "hook", "lead uppercut": "uppercut", "rear uppercut": "uppercut"}
SRC_FPS = {1: 24, 2: 24, 3: 24, 4: 24, 5: 30, 7: 30, 8: 30, 9: 24, 10: 25}  # read from the videos' pages, S495
ASPECT = 16.0 / 9.0  # all ten sources are 16:9


def load(boxingvi_dir):
    """-> list of (video, class, joints (n,17,2) in aspect-true units, seconds)."""
    import openpyxl
    out = []
    for v, fps in SRC_FPS.items():
        clips = np.load(os.path.join(boxingvi_dir, "Skeleton_data", "V%d.npy" % v), allow_pickle=False)
        ws = openpyxl.load_workbook(os.path.join(boxingvi_dir, "Annotation_files", "V%d.xlsx" % v), read_only=True, data_only=True).worksheets[0]
        rows = []
        for r in ws.iter_rows(values_only=True):
            vals = [x for x in r if x is not None]
            if len(vals) >= 3 and isinstance(vals[0], (int, float)) and isinstance(vals[2], str):
                rows.append(vals[2].strip().lower())
        if len(rows) != len(clips):
            raise SystemExit("V%d: %d label rows but %d clips" % (v, len(rows), len(clips)))
        for cls, clip in zip(rows, clips):
            used = np.abs(clip).sum(axis=(1, 2)) > 0
            if cls not in CLASSES or used.sum() < 4:
                continue
            J = clip[used].astype(np.float32).copy()
            J[J == 0] = np.nan
            J[..., 0] *= ASPECT
            out.append((v, cls, J, used.sum() / float(fps)))
    return out


def rule_family(J, side):
    """The v1 no-training rule on one clip."""
    P = descriptor.SIDE[side]
    sh = (J[:, 5] + J[:, 6]) / 2
    T = np.nanmedian(np.linalg.norm(sh - (J[:, 11] + J[:, 12]) / 2, axis=1))
    g = (descriptor.glove_of(J, P) - sh) / T
    d = np.linalg.norm(g - g[0], axis=1)
    top = int(np.nanargmax(d)) if np.isfinite(d).any() else len(g) - 1
    D = g[top] - g[0]
    elbow = descriptor._angle(J[top, P["sh"]], J[top, P["el"]], J[top, P["wr"]])
    start_low = (descriptor.glove_of(J, P)[0][1] - J[0, P["sh"]][1]) / T
    if -D[1] >= 0.5 * np.linalg.norm(D) and elbow < 145 and start_low > 0:
        return "uppercut"
    return "straight" if elbow >= 135 else "hook"


def table(y_true, y_pred, labels):
    lines, f1s = [], []
    for c in labels:
        tp = sum(t == c and p == c for t, p in zip(y_true, y_pred))
        fp = sum(t != c and p == c for t, p in zip(y_true, y_pred))
        fn = sum(t == c and p != c for t, p in zip(y_true, y_pred))
        pr, rc = tp / max(1, tp + fp), tp / max(1, tp + fn)
        f1s.append(2 * pr * rc / max(1e-9, pr + rc))
        lines.append("   %-14s precision %5.1f%%  recall %5.1f%%  (n=%d)" % (c, 100 * pr, 100 * rc, tp + fn))
    acc = sum(t == p for t, p in zip(y_true, y_pred)) / max(1, len(y_true))
    return acc, float(np.mean(f1s)), lines


def features(data, mirror=False):
    X, sides = [], []
    for v, cls, J, sec in data:
        side = descriptor.punching_side(J)
        sides.append(side)
        X.append(descriptor.punch_descriptor(J, side, sec, mirror))
    return np.stack(X), sides


def make_model():
    from sklearn.ensemble import HistGradientBoostingClassifier
    return HistGradientBoostingClassifier(max_iter=300, learning_rate=0.08, max_leaf_nodes=24, l2_regularization=1.0, random_state=0)


def main():
    data = load(sys.argv[1])
    vids = np.array([d[0] for d in data])
    y = np.array([d[1] for d in data])
    X, sides = features(data)
    Xm, _ = features(data, mirror=True)
    print("BoxingVI: %d clips from %d videos; classes %s" % (len(data), len(set(vids)), {c: int((y == c).sum()) for c in CLASSES}))
    fam_true = [FAMILY[c] for c in y]
    acc, f1, lines = table(fam_true, [rule_family(d[2], s) for d, s in zip(data, sides)], ["straight", "hook", "uppercut"])
    print("\n(a) NO TRAINING, rule, 3 families: accuracy %.1f%%, macro-F1 %.2f" % (100 * acc, f1))
    print("\n".join(lines))
    pred = np.empty(len(y), dtype=object)
    for v in sorted(set(vids)):
        tr, te = vids != v, vids == v
        m = make_model().fit(np.vstack([X[tr], Xm[tr]]), np.r_[y[tr], y[tr]])
        pred[te] = m.predict(X[te])
        print("   held out V%-2d: %4d clips, 6-class accuracy %.1f%%" % (v, te.sum(), 100 * (pred[te] == y[te]).mean()))
    acc, f1, lines = table(list(y), list(pred), CLASSES)
    print("\n(b) TRAINED, leave one video (person) out, 6 classes: accuracy %.1f%%, macro-F1 %.2f" % (100 * acc, f1))
    print("\n".join(lines))
    acc3, f13, lines3 = table(fam_true, [FAMILY[p] for p in pred], ["straight", "hook", "uppercut"])
    print("\n(b) TRAINED, same folds, 3 families: accuracy %.1f%%, macro-F1 %.2f" % (100 * acc3, f13))
    print("\n".join(lines3))
    per_video = [float((pred[vids == v] == y[vids == v]).mean()) for v in sorted(set(vids))]
    print("\nper held-out person: worst %.1f%%, median %.1f%%, best %.1f%%" % (100 * min(per_video), 100 * np.median(per_video), 100 * max(per_video)))
    if "--no-save" not in sys.argv:
        os.makedirs(sys.argv[2], exist_ok=True)
        m = make_model().fit(np.vstack([X, Xm]), np.r_[y, y])
        pickle.dump(dict(model=m, classes=CLASSES, trained_on="BoxingVI V1-5,7-10 (%d clips)" % len(y), cv_accuracy=acc, cv_family_accuracy=acc3),
                    open(os.path.join(sys.argv[2], "punch_type.pkl"), "wb"))
        print("saved %s" % os.path.join(sys.argv[2], "punch_type.pkl"))


if __name__ == "__main__":
    main()

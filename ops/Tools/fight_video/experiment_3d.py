"""Does a 3D pose network help? The same classifiers with and without the 3D arm descriptor.  (Claude, S495)
usage: python experiment_3d.py <dataset_dir> <work_dir> [--json out.json]      (needs scikit-learn: use the venv)

For every bout that has <work_dir>/<NAME>_3d.npz (pose3d.py), the punch filter and the result classifier are trained
and scored twice on the SAME folds by bout (train_olympic.py): once on the 2D descriptor (333 numbers), once on the 2D
descriptor plus the 66 numbers of pose3d.descriptor3d (true elbow angle and arm direction in the boxer's body frame).
A bout is always scored by models that never saw it."""
import glob
import json
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import evaluate_olympic as ev  # noqa: E402
import pose3d  # noqa: E402
import train_olympic as to  # noqa: E402


def cross_validate(vids):
    folds = [vids[i::to.FOLDS] for i in range(min(to.FOLDS, len(vids)))]
    scored = []
    for i, fold in enumerate(folds):
        train = [v for j, f in enumerate(folds) if j != i for v in f]
        scored += to.score_with(fold, to.fit_filter(train), to.best_threshold(train), to.fit_result(train))
    return ev.summarise(scored)


def main():
    dataset_dir, work_dir = sys.argv[1], sys.argv[2]
    names = sorted(os.path.basename(p)[:-7] for p in glob.glob(os.path.join(work_dir, "GH*_3d.npz")))
    vids2, vids3 = [], []
    for n in names:
        v = to.prepare(dataset_dir, work_dir, n)
        table = pose3d.load_table(os.path.join(work_dir, n + "_3d.npz"))
        X3 = np.stack([pose3d.descriptor3d(e, v["fps"], v["F"], table) for e in v["events"]]) if v["events"] else np.zeros((0, 66), np.float32)
        have = float(np.isfinite(X3[:, 9]).mean()) if len(X3) else 0.0
        vids2.append(v)
        vids3.append(dict(v, X=np.hstack([v["X"], X3]), Xm=np.hstack([v["Xm"], X3])))
        print("%s: %d candidates, 3D pose found for %.0f%% of them" % (n, len(v["events"]), 100 * have))
    a = cross_validate(vids2)
    b = cross_validate(vids3)
    ev.print_summary(a, "2D descriptor only, %d bouts, folds by bout" % len(names))
    ev.print_summary(b, "2D + 3D descriptor, the same bouts and folds")
    f1 = lambda s: 2 * s["precision"] * s["recall"] / max(1e-9, s["precision"] + s["recall"])
    print("\nSUMMARY  detection F1: 2D %.3f -> 2D+3D %.3f | result accuracy: %.1f%% -> %.1f%% | head/body: %.1f%% -> %.1f%%" % (
        f1(a), f1(b), 100 * a["result_accuracy"], 100 * b["result_accuracy"], 100 * a["target_accuracy"], 100 * b["target_accuracy"]))
    if "--json" in sys.argv:
        json.dump(dict(bouts=names, two_d=a, with_3d=b), open(sys.argv[sys.argv.index("--json") + 1], "w"), indent=1)


if __name__ == "__main__":
    main()

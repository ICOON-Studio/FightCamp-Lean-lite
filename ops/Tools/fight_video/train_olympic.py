"""Train and honestly score the punch filter and the result classifier on the Olympic set's referee labels.  (Claude, S495)
usage: python train_olympic.py <dataset_dir> <work_dir> <models_dir> [--test NAME,NAME,...] [--no-save] [--json out.json]
       (needs scikit-learn: use the venv)

Every <work_dir>/<NAME>.npz (pose.py) is used; <NAME>_boxers.npz is rebuilt with track.py when missing or older.
Candidates = the rule detector with a loose net (classify.LOOSE). Each candidate is matched to the referee labels
(evaluate_olympic.match): matched = a punch, unmatched = not a punch. Two classifiers on the candidate's descriptor:
  FILTER  punch / not a punch                       RESULT  head / body / blocked / missed (matched candidates only)
SCORING: bouts are split into FOLDS BY BOUT (default 5); a bout is always scored by models that never saw it.
The keep-threshold of the filter is picked inside the training bouts (best F1), never on the bout being scored.
--test names bouts that are held out of everything and scored once at the end by the final models.
Printed for the v1 rules and for the trained layer on the same bouts: recall, precision, hand, head/body, result."""
import glob
import json
import os
import pickle
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import classify  # noqa: E402
import evaluate_olympic as ev  # noqa: E402
import punches  # noqa: E402
import track  # noqa: E402

FOLDS = 5


def prepare(dataset_dir, work_dir, name):
    """-> dict(name, labels, events (loose candidates), X, Xm, is_punch, outcome, rule (v1 score_video result))."""
    pose_path = os.path.join(work_dir, name + ".npz")
    box_path = os.path.join(work_dir, name + "_boxers.npz")
    newest = max(os.path.getmtime(pose_path), os.path.getmtime(track.__file__))
    if not os.path.exists(box_path) or os.path.getmtime(box_path) < newest:
        track.run(pose_path, box_path, log=lambda *a: None)
    boxers = np.load(box_path)
    events, info, bodies = punches.detect(boxers, classify.LOOSE, log=lambda *a: None)
    r = ev.score_video(dataset_dir, work_dir, name, events=events)
    hit = {ei: gi for gi, ei in r["pairs"]}
    X = np.stack([classify.event_features(e, bodies) for e in events]) if events else np.zeros((0, 333), np.float32)
    Xm = np.stack([classify.event_features(e, bodies, mirror=True) for e in events]) if events else X
    is_punch = np.array([i in hit for i in range(len(events))])
    outcome = np.array([(r["labels"][hit[i]]["target"] if r["labels"][hit[i]]["result"] == "landed" else r["labels"][hit[i]]["result"]) if i in hit else "" for i in range(len(events))], dtype=object)
    rule = ev.score_video(dataset_dir, work_dir, name)  # the v1 rules with their own (tight) thresholds
    return dict(name=name, r=r, events=events, X=X, Xm=Xm, is_punch=is_punch, outcome=outcome, rule=rule,
                fps=float(boxers["fps"]), F=len(boxers["frame"]))


def fit_filter(vids):
    from sklearn.ensemble import HistGradientBoostingClassifier
    X = np.vstack([v["X"] for v in vids] + [v["Xm"] for v in vids])
    y = np.concatenate([v["is_punch"] for v in vids] * 2)
    return HistGradientBoostingClassifier(max_iter=250, learning_rate=0.06, max_leaf_nodes=16, l2_regularization=2.0, random_state=0).fit(X, y)


def fit_result(vids):
    from sklearn.ensemble import HistGradientBoostingClassifier
    X = np.vstack([v["X"][v["is_punch"]] for v in vids] + [v["Xm"][v["is_punch"]] for v in vids])
    y = np.concatenate([v["outcome"][v["is_punch"]] for v in vids] * 2)
    return HistGradientBoostingClassifier(max_iter=200, learning_rate=0.06, max_leaf_nodes=12, l2_regularization=2.0, class_weight="balanced", random_state=0).fit(X, y.astype(str))


def best_threshold(vids):
    """Inner split of the training bouts: fit on the first two thirds, pick the F1-best threshold on the rest."""
    cut = max(1, (2 * len(vids)) // 3)
    if cut >= len(vids):
        return 0.5
    m = fit_filter(vids[:cut])
    p = np.concatenate([m.predict_proba(v["X"])[:, 1] for v in vids[cut:]])
    y = np.concatenate([v["is_punch"] for v in vids[cut:]])
    total = sum(len(v["r"]["labels"]) for v in vids[cut:])
    best, best_f1 = 0.5, -1.0
    for th in np.arange(0.2, 0.81, 0.05):
        tp = float((y & (p >= th)).sum())
        pr, rc = tp / max(1.0, float((p >= th).sum())), tp / max(1, total)
        f1 = 2 * pr * rc / max(1e-9, pr + rc)
        if f1 > best_f1:
            best, best_f1 = float(th), f1
    return best


def score_with(vids, filt, th, res):
    """Apply trained models to bouts -> list of evaluate_olympic-style results."""
    out = []
    for v in vids:
        if not len(v["events"]):
            out.append(dict(v["r"], events=[], pairs=[]))
            continue
        keep = filt.predict_proba(v["X"])[:, 1] >= th
        calls = res.predict(v["X"])
        events = []
        for e, k, c in zip(v["events"], keep, calls):
            if k:
                e2 = dict(e)
                e2["result"] = "landed" if c in ("head", "body") else c
                if c in ("head", "body"):
                    e2["target"] = c
                events.append(e2)
        out.append(dict(v["r"], events=events, pairs=ev.match(v["r"]["labels"], events)))
    return out


def main():
    a = sys.argv
    dataset_dir, work_dir, models_dir = a[1], a[2], a[3]
    test_names = a[a.index("--test") + 1].split(",") if "--test" in a else []
    names = sorted(os.path.basename(p)[:-4] for p in glob.glob(os.path.join(work_dir, "GH*.npz")) if "_" not in os.path.basename(p))
    vids = [prepare(dataset_dir, work_dir, n) for n in names]
    test = [v for v in vids if v["name"] in test_names]
    dev = [v for v in vids if v["name"] not in test_names]
    cand = ev.summarise([v["r"] for v in vids])
    print("%d bouts (%d for folds, %d held out): %d referee labels, %d loose candidates, the net catches %.1f%% of the labels (ceiling: both boxers seen %.1f%%)" % (
        len(vids), len(dev), len(test), cand["labels"], cand["detections"], 100 * cand["recall"], 100 * cand["ceiling"]))
    report = {}
    folds = [dev[i::FOLDS] for i in range(min(FOLDS, len(dev)))]
    scored = []
    for i, fold in enumerate(folds):
        train = [v for j, f in enumerate(folds) if j != i for v in f]
        th = best_threshold(train)
        scored += score_with(fold, fit_filter(train), th, fit_result(train))
        print("   fold %d: %d bouts scored by models trained on %d other bouts (threshold %.2f)" % (i + 1, len(fold), len(train), th))
    report["rules_folds"] = ev.summarise([v["rule"] for v in dev])
    report["trained_folds"] = ev.summarise(scored)
    ev.print_summary(report["rules_folds"], "v1 RULES, no training, the %d fold bouts" % len(dev))
    ev.print_summary(report["trained_folds"], "TRAINED filter + result, each bout scored by models that never saw it")
    th = best_threshold(dev)
    filt, res = fit_filter(dev), fit_result(dev)
    if test:
        report["rules_test"] = ev.summarise([v["rule"] for v in test])
        report["trained_test"] = ev.summarise(score_with(test, filt, th, res))
        ev.print_summary(report["rules_test"], "v1 RULES on the %d held-out bouts %s" % (len(test), ",".join(test_names)))
        ev.print_summary(report["trained_test"], "TRAINED on the %d held-out bouts (models from the other %d)" % (len(test), len(dev)))
    report["bouts"] = dict(folds=[v["name"] for v in dev], held_out=[v["name"] for v in test])
    report["candidates"] = cand
    if "--json" in a:
        json.dump(report, open(a[a.index("--json") + 1], "w"), indent=1)
    if "--no-save" not in a:
        os.makedirs(models_dir, exist_ok=True)
        meta = dict(trained_on="Olympic Boxing Punch Classification set, %d bouts" % len(dev), features=classify.M_KEYS)
        pickle.dump(dict(model=filt, threshold=th, **meta), open(os.path.join(models_dir, "punch_filter.pkl"), "wb"))
        pickle.dump(dict(model=res, **meta), open(os.path.join(models_dir, "punch_result.pkl"), "wb"))
        print("saved punch_filter.pkl (threshold %.2f) and punch_result.pkl in %s" % (th, models_dir))


if __name__ == "__main__":
    main()

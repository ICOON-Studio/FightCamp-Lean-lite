"""How far do our own synthetic clips carry? Train on them ONLY, then score on things they never saw.  (Claude, S495)
usage: python synth_eval.py <synth_dir> <synth_work> [--olympic <dataset_dir> <olympic_work>] [--boxingvi <dir>]
                            [--json out.json] [--save <models_dir>]            (needs scikit-learn: use the venv)

<synth_work> holds the pose pass of every clip (synth_data.py pose). Two readings of the synthetic clips:
  EST   the analyzer's own eyes: pose model + boxer picker on the rendered video (what a real video gets)
  EXACT the joints the game drew (a perfect pose model and picker): the ceiling, and free training data
Trained on the TRAIN clips (their bodies never appear in a TEST clip): the punch filter, the result classifier
(head / body / blocked / missed), and - new - a punch-TYPE classifier (six types). Scored on:
  1. the synthetic TEST clips: recall, precision, who threw it, hand, head/body, result, type; rules against trained
  2. the real Olympic bouts (referee labels; no type): the same models, no real label ever seen in training
  3. BoxingVI (real people, bag and shadow work): the type classifier on its 4,743 clips
The Olympic set and BoxingVI are only MEASURED here; nothing is learnt from them (their licences forbid selling that).
--save writes the synthetic-trained models (ours to sell) as synth_punch_filter/result/type.pkl."""
import json
import os
import pickle
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import classify  # noqa: E402
import evaluate_olympic as ev  # noqa: E402
import punches  # noqa: E402
import synth_data as sd  # noqa: E402
import track  # noqa: E402
import train_olympic as to  # noqa: E402

RESULT_OF = {"head": "landed", "body": "landed", "blocked": "blocked", "missed": "missed"}


def prepare(synth_dir, work_dir, row, source):
    """One clip -> the dict train_olympic's fit_* functions read, plus type labels and who-threw-it."""
    L = sd.load_labels(synth_dir, row["clip"])
    labels = sd.label_rows(L)
    if source == "exact":
        boxers = sd.gt_boxers(L)
    else:
        pose_path = os.path.join(work_dir, row["clip"] + ".npz")
        box_path = os.path.join(work_dir, row["clip"] + "_boxers.npz")
        if not os.path.exists(box_path) or os.path.getmtime(box_path) < max(os.path.getmtime(pose_path), os.path.getmtime(track.__file__)):
            track.run(pose_path, box_path, log=lambda *a: None)
        boxers = np.load(box_path)
    seen = np.asarray(boxers["seen"])
    both = [bool(seen[g["contact"]].all()) for g in labels]
    events, info, bodies = punches.detect(boxers, classify.LOOSE, log=lambda *a: None)
    pairs = ev.match(labels, events)
    hit = {ei: gi for gi, ei in pairs}
    n = len(events)
    X = np.stack([classify.event_features(e, bodies) for e in events]) if n else np.zeros((0, 333), np.float32)
    Xm = np.stack([classify.event_features(e, bodies, mirror=True) for e in events]) if n else X
    D = np.stack([classify.type_features(e, bodies) for e in events]) if n else np.zeros((0, 250), np.float32)
    Dm = np.stack([classify.type_features(e, bodies, mirror=True) for e in events]) if n else D
    is_punch = np.array([i in hit for i in range(n)], bool)
    lab = lambda i: labels[hit[i]]
    outcome = np.array([(lab(i)["target"] if lab(i)["result"] == "landed" else lab(i)["result"]) if i in hit else "" for i in range(n)], dtype=object)
    ptype = np.array([lab(i)["type"] if i in hit else "" for i in range(n)], dtype=object)
    who = np.array([sd.boxer_of(L, bodies, "AB".index(e["boxer"]), e["index"]) for e in events], int)
    rule_events, _, _ = punches.detect(boxers, None, log=lambda *a: None)
    rule = dict(name=row["clip"], labels=labels, events=rule_events, pairs=ev.match(labels, rule_events), both=both)
    return dict(name=row["clip"], row=row, L=L, bodies=bodies, events=events, X=X, Xm=Xm, D=D, Dm=Dm, is_punch=is_punch, outcome=outcome,
                ptype=ptype, who=who, rule=rule, r=dict(name=row["clip"], labels=labels, events=events, pairs=pairs, both=both),
                seen_both=float(seen.all(1).mean()))


def fit_type(vids, key="X"):
    from sklearn.ensemble import HistGradientBoostingClassifier
    m = key + "m"
    X = np.vstack([v[key][v["is_punch"]] for v in vids] + [v[m][v["is_punch"]] for v in vids])
    y = np.concatenate([v["ptype"][v["is_punch"]] for v in vids] * 2)
    return HistGradientBoostingClassifier(max_iter=250, learning_rate=0.07, max_leaf_nodes=16, l2_regularization=1.5, class_weight="balanced", random_state=0).fit(X, y.astype(str))


def type_scores(vids, pick):
    """pick(v) -> (events, their type calls, their who calls). Type and thrower accuracy on the matched punches."""
    ok6 = ok3 = okw = n = nw = 0
    per = {t: [0, 0] for t in sd.TYPES}
    for v in vids:
        events, calls, who = pick(v)
        labels = v["r"]["labels"]
        for gi, ei in ev.match(labels, events):
            g = labels[gi]
            n += 1
            ok6 += calls[ei] == g["type"]
            ok3 += sd.FAMILY.get(calls[ei], calls[ei].split()[-1]) == sd.FAMILY[g["type"]]
            per[g["type"]][1] += 1
            per[g["type"]][0] += calls[ei] == g["type"]
            if who[ei] >= 0:
                nw += 1
                okw += who[ei] == g["boxer"]
    return dict(type_accuracy=ok6 / max(1, n), family_accuracy=ok3 / max(1, n), thrower_accuracy=okw / max(1, nw), n=n,
                per_type={t: (a / max(1, b), b) for t, (a, b) in per.items()})


def score_synth(vids, models):
    """Rules and trained layer on a list of synthetic clips -> two summaries (evaluate_olympic's + type)."""
    rules = ev.summarise([v["rule"] for v in vids])
    rule_ev = {v["name"]: v["rule"]["events"] for v in vids}
    rules.update(type_scores(vids, lambda v: (rule_ev[v["name"]], [e["type"] for e in rule_ev[v["name"]]],
                                              [sd.boxer_of(v["L"], v["bodies"], "AB".index(e["boxer"]), e["index"]) for e in rule_ev[v["name"]]])))
    filt, th, res, typ = models
    scored, kept_of = to.score_with(vids, filt, th, res), {}
    for v in vids:
        if len(v["events"]):
            keep = filt.predict_proba(v["X"])[:, 1] >= th
            kept_of[v["name"]] = ([e for e, k in zip(v["events"], keep) if k], list(typ.predict(v["X"][keep])) if keep.any() else [], list(v["who"][keep]))
        else:
            kept_of[v["name"]] = ([], [], [])
    trained = ev.summarise(scored)
    trained.update(type_scores(vids, lambda v: kept_of[v["name"]]))
    return rules, trained


def commonest(vids):
    """What 'always say the commonest answer' scores on these clips' labels."""
    labs = [g for v in vids for g in v["r"]["labels"]]
    share = lambda key, pool=None: max(np.unique([g[key] for g in (pool or labs)], return_counts=True)[1]) / max(1, len(pool or labs))
    return dict(hand=share("hand"), target=share("target", [g for g in labs if g["result"] == "landed"]), result=share("result"), type=share("type"),
                family=max(np.unique([sd.FAMILY[g["type"]] for g in labs], return_counts=True)[1]) / max(1, len(labs)))


def pose_quality(vids):
    """EST clips only: how near the pose model's joints are to the exact ones, in trunk lengths, on the picked boxers."""
    err, swaps, n_sw = [], 0, 0
    for v in vids:
        J = np.asarray(v["L"]["joints"], np.float32)[..., :2]
        for slot in (0, 1):
            b = v["bodies"][slot]
            for f in range(0, len(J), 5):
                if np.isnan(b.hipm[f]).any():
                    continue
                g = J[f, sd.boxer_of(v["L"], v["bodies"], slot, f)]
                T = np.linalg.norm((g[5] + g[6]) / 2 - (g[11] + g[12]) / 2)
                e = np.linalg.norm(b.j[f] - g, axis=1) / max(T, 1e-3)
                err.append(e)
                if not np.isnan(b.j[f, [9, 10]]).any() and np.linalg.norm(g[9] - g[10]) > 0.3 * T:
                    n_sw += 1
                    swaps += np.linalg.norm(b.j[f, 9] - g[10]) + np.linalg.norm(b.j[f, 10] - g[9]) < np.linalg.norm(b.j[f, 9] - g[9]) + np.linalg.norm(b.j[f, 10] - g[10])
    e = np.array(err)
    arms = e[:, [5, 6, 7, 8, 9, 10]]
    return dict(samples=len(e), mean_error_T=float(np.nanmean(e)), within_0_2_T=float(np.nanmean(e[~np.isnan(e)] < 0.2)),
                wrist_error_T=float(np.nanmean(e[:, [9, 10]])), arms_within_0_2_T=float(np.nanmean(arms[~np.isnan(arms)] < 0.2)),
                wrists_swapped=swaps / max(1, n_sw), both_boxers_seen=float(np.mean([v["seen_both"] for v in vids])))


def brief(s):
    keys = ("labels", "detections", "matched", "recall", "precision", "ceiling", "hand_accuracy", "target_accuracy", "result_accuracy",
            "type_accuracy", "family_accuracy", "thrower_accuracy", "per_type", "recall_by_label", "result_confusion")
    return {k: s[k] for k in keys if k in s}


def show(title, s):
    f1 = 2 * s["precision"] * s["recall"] / max(1e-9, s["precision"] + s["recall"])
    line = "%-52s found %5.1f%%  real %5.1f%%  F1 %.3f | hand %5.1f%%  head/body %5.1f%%  result %5.1f%%" % (
        title, 100 * s["recall"], 100 * s["precision"], f1, 100 * s["hand_accuracy"], 100 * s["target_accuracy"], 100 * s["result_accuracy"])
    if "type_accuracy" in s:
        line += "  type %5.1f%% (family %5.1f%%)  thrower %5.1f%%" % (100 * s["type_accuracy"], 100 * s["family_accuracy"], 100 * s["thrower_accuracy"])
    print(line, flush=True)


def rule_scores(vids):
    rules = ev.summarise([v["rule"] for v in vids])
    rule_ev = {v["name"]: v["rule"]["events"] for v in vids}
    rules.update(type_scores(vids, lambda v: (rule_ev[v["name"]], [e["type"] for e in rule_ev[v["name"]]],
                                              [sd.boxer_of(v["L"], v["bodies"], "AB".index(e["boxer"]), e["index"]) for e in rule_ev[v["name"]]])))
    return rules


def measure_only(a, synth_dir, work):
    """--no-train: the synthetic clips as a TEST SET only. Nothing is learnt from them: the rules, and (with --models)
    the research models trained elsewhere, are scored against the exact labels."""
    from sklearn.metrics import roc_auc_score
    report = dict(mode="test only: nothing trained on the synthetic clips")
    models = classify.load_models(a[a.index("--models") + 1]) if "--models" in a else {}
    for source in ("est", "exact"):
        vids = [prepare(synth_dir, work, r, source) for r in sd.manifest(synth_dir)]
        rules = rule_scores(vids)
        net = ev.summarise([v["r"] for v in vids])
        print("\n== ALL %d SYNTHETIC CLIPS as a test set (%d punches), read as %s; the candidate net catches %.1f%%, both boxers seen at %.1f%% of the punches" % (
            len(vids), rules["labels"], source.upper(), 100 * net["recall"], 100 * net["ceiling"]))
        show("rules only (no training anywhere)", rules)
        print("   type by punch (rules): " + ", ".join("%s %.0f%% of %d" % (t, 100 * p[0], p[1]) for t, p in rules["per_type"].items()))
        report[source] = dict(rules=brief(rules), net_recall=net["recall"], both_seen_at_label=net["ceiling"], commonest=commonest(vids), clips=len(vids))
        if "punch_filter" in models and "punch_result" in models:
            filt, th, res = models["punch_filter"]["model"], models["punch_filter"]["threshold"], models["punch_result"]["model"]
            typ = models["punch_type"]["model"] if "punch_type" in models else None
            s = ev.summarise(to.score_with(vids, filt, th, res))
            kept_of = {}
            for v in vids:
                keep = filt.predict_proba(v["X"])[:, 1] >= th if len(v["events"]) else np.zeros(0, bool)
                kept = [e for e, k in zip(v["events"], keep) if k]
                calls = list(typ.predict(v["D"][keep])) if typ is not None and keep.any() else [e["type"] for e in kept]
                kept_of[v["name"]] = (kept, calls, list(v["who"][keep]))
            s.update(type_scores(vids, lambda v: kept_of[v["name"]]))
            y = np.concatenate([v["is_punch"] for v in vids])
            p = np.concatenate([filt.predict_proba(v["X"])[:, 1] if len(v["X"]) else np.zeros(0) for v in vids])
            s["filter_auc"] = float(roc_auc_score(y, p))
            show("models trained on REAL footage (research only)", s)
            print("   their filter ranks a synthetic punch above a non-punch %.1f%% of the time (AUC); type by punch: %s" % (
                100 * s["filter_auc"], ", ".join("%s %.0f%%" % (t, 100 * q[0]) for t, q in s["per_type"].items())))
            report[source]["real_trained_models"] = dict(brief(s), filter_auc=s["filter_auc"])
        base = report[source]["commonest"]
        print("   always the commonest answer: hand %.1f%%, head/body %.1f%%, result %.1f%%, type %.1f%% (family %.1f%%)" % tuple(100 * base[k] for k in ("hand", "target", "result", "type", "family")))
        by_cam = {}
        for cam in sorted(set(v["row"]["camera"] for v in vids)):
            sub = [v for v in vids if v["row"]["camera"] == cam]
            r2 = rule_scores(sub)
            by_cam[cam] = dict(brief(r2), net_recall=ev.summarise([v["r"] for v in sub])["recall"])
            show("   camera %-7s (%2d clips) rules" % (cam, len(sub)), r2)
        report[source]["by_camera"] = by_cam
        if source == "est":
            report["pose_quality"] = pose_quality(vids)
            print("   pose model against the exact joints: " + json.dumps({k: round(v, 3) for k, v in report["pose_quality"].items()}))
            for cam in sorted(set(v["row"]["camera"] for v in vids)):
                q = pose_quality([v for v in vids if v["row"]["camera"] == cam])
                report["pose_quality_" + cam] = q
                print("      %-7s both boxers picked %.0f%% of frames, joints within 0.2 trunk %.0f%%, wrists swapped %.1f%%" % (
                    cam, 100 * q["both_boxers_seen"], 100 * q["within_0_2_T"], 100 * q["wrists_swapped"]))
    if "--json" in a:
        json.dump(report, open(a[a.index("--json") + 1], "w"), indent=1, default=float)


def main():
    a = sys.argv
    if len(a) < 3:
        print(__doc__)
        return
    synth_dir, work = a[1], a[2]
    if "--no-train" in a:
        return measure_only(a, synth_dir, work)
    report = {}
    models = {}
    for source in ("est", "exact"):
        vids = [prepare(synth_dir, work, r, source) for r in sd.manifest(synth_dir)]
        train = [v for v in vids if v["row"]["split"] == "train"]
        test = [v for v in vids if v["row"]["split"] == "test"]
        m = (to.fit_filter(train), to.best_threshold(train), to.fit_result(train), fit_type(train))
        models[source] = m + (fit_type(train, "D"),)
        rules, trained = score_synth(test, m)
        print("\n== SYNTHETIC TEST CLIPS (%d clips, %d punches; bodies never trained on), read as %s; trained on %d clips, %d matched punches, threshold %.2f" % (
            len(test), rules["labels"], source.upper(), len(train), int(sum(v["is_punch"].sum() for v in train)), m[1]))
        show("rules only", rules)
        show("trained on synthetic", trained)
        base = commonest(test)
        print("   always the commonest answer: hand %.1f%%, head/body %.1f%%, result %.1f%%, type %.1f%% (family %.1f%%)" % tuple(100 * base[k] for k in ("hand", "target", "result", "type", "family")))
        print("   type by punch (trained): " + ", ".join("%s %.0f%% of %d" % (t, 100 * p[0], p[1]) for t, p in trained["per_type"].items()))
        report[source] = dict(rules=brief(rules), trained=brief(trained), commonest=base, threshold=m[1], train_clips=len(train), test_clips=len(test))
        by_cam = {}
        for cam in sorted(set(v["row"]["camera"] for v in test)):
            sub = [v for v in test if v["row"]["camera"] == cam]
            r2, t2 = score_synth(sub, m)
            by_cam[cam] = dict(rules=brief(r2), trained=brief(t2))
            show("   camera %-7s (%2d clips) trained" % (cam, len(sub)), t2)
        report[source]["by_camera"] = by_cam
        if source == "est":
            report["pose_quality"] = pose_quality(vids)
            print("   pose model against the exact joints: " + json.dumps({k: round(v, 3) for k, v in report["pose_quality"].items()}))
    if "--olympic" in a:
        from sklearn.metrics import roc_auc_score
        data, owork = a[a.index("--olympic") + 1], a[a.index("--olympic") + 2]
        names = sorted(os.path.basename(p)[:-4] for p in __import__("glob").glob(os.path.join(owork, "GH*.npz")) if "_" not in os.path.basename(p))
        real = [to.prepare(data, owork, n) for n in names]
        report["olympic"] = dict(bouts=len(real))
        print("\n== REAL OLYMPIC BOUTS (%d bouts, referee labels) - models that never saw a real label" % len(real))
        rules = ev.summarise([v["rule"] for v in real])
        show("rules only", rules)
        report["olympic"]["rules"] = brief(rules)
        y = np.concatenate([v["is_punch"] for v in real])
        for source in ("est", "exact"):
            filt, th, res = models[source][:3]
            s = ev.summarise(to.score_with(real, filt, th, res))
            p = np.concatenate([filt.predict_proba(v["X"])[:, 1] if len(v["X"]) else np.zeros(0) for v in real])
            s["filter_auc"] = float(roc_auc_score(y, p))
            show("trained on synthetic (%s joints), threshold %.2f" % (source, th), s)
            print("   filter ranks a real punch above a non-punch %.1f%% of the time (AUC); found by label: %s" % (100 * s["filter_auc"], s["recall_by_label"]))
            report["olympic"]["synthetic_" + source] = dict(brief(s), filter_auc=s["filter_auc"], threshold=th)
        folds = [real[i::to.FOLDS] for i in range(to.FOLDS)]
        scored, p_all, y_all = [], [], []
        for i, fold in enumerate(folds):
            tr = [v for j, f in enumerate(folds) if j != i for v in f]
            filt = to.fit_filter(tr)
            scored += to.score_with(fold, filt, to.best_threshold(tr), to.fit_result(tr))
            p_all += [filt.predict_proba(v["X"])[:, 1] for v in fold if len(v["X"])]
            y_all += [v["is_punch"] for v in fold if len(v["X"])]
        s = ev.summarise(scored)
        s["filter_auc"] = float(roc_auc_score(np.concatenate(y_all), np.concatenate(p_all)))
        show("trained on REAL labels, folds by bout (reference)", s)
        print("   its filter AUC %.1f%%" % (100 * s["filter_auc"]))
        report["olympic"]["real_folds"] = dict(brief(s), filter_auc=s["filter_auc"])
        labs = [g for v in real for g in v["r"]["labels"]]
        report["olympic"]["commonest"] = dict(hand=np.mean([g["hand"] == "left" for g in labs]), result=np.mean([g["result"] == "landed" for g in labs]))
    if "--boxingvi" in a:
        import train_type as tt
        data = tt.load(a[a.index("--boxingvi") + 1])
        Xb, sides = tt.features(data)
        yb = np.array([d[1] for d in data])
        report["boxingvi"] = dict(clips=len(data))
        print("\n== BOXINGVI (%d real clips, one person, bag and shadow work, six types) - type model trained on synthetic only" % len(data))
        for source in ("est", "exact"):
            pred = models[source][4].predict(Xb)
            acc, f1, lines = tt.table(list(yb), list(pred), tt.CLASSES)
            acc3, _, lines3 = tt.table([tt.FAMILY[c] for c in yb], [tt.FAMILY[c] for c in pred], ["straight", "hook", "uppercut"])
            print("trained on synthetic (%s joints): six types %.1f%%, three families %.1f%%" % (source, 100 * acc, 100 * acc3))
            print("\n".join(lines + lines3))
            report["boxingvi"]["synthetic_" + source] = dict(six=acc, family=acc3)
    if "--json" in a:
        json.dump(report, open(a[a.index("--json") + 1], "w"), indent=1, default=float)
    if "--save" in a:
        out = a[a.index("--save") + 1]
        os.makedirs(out, exist_ok=True)
        filt, th, res, typ, typ_d = models["est"]
        meta = dict(trained_on="FightCamp synthetic clips only (%s), ours" % os.path.basename(os.path.abspath(synth_dir)), features=classify.M_KEYS)
        pickle.dump(dict(model=filt, threshold=th, **meta), open(os.path.join(out, "synth_punch_filter.pkl"), "wb"))
        pickle.dump(dict(model=res, **meta), open(os.path.join(out, "synth_punch_result.pkl"), "wb"))
        pickle.dump(dict(model=typ_d, classes=sd.TYPES, **meta), open(os.path.join(out, "synth_punch_type.pkl"), "wb"))
        print("saved the synthetic-trained models in %s" % out)


if __name__ == "__main__":
    main()

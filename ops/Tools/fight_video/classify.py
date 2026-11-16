"""The trained layer on top of the rules: a pose descriptor per candidate punch and three small classifiers.  (Claude, S495)

  punch_filter.pkl  is this burst a punch a referee would count?  (trained on the Olympic set's referee labels)
  punch_result.pkl  head landed / body landed / blocked / missed   (same labels)
  punch_type.pkl    jab, cross, lead/rear hook, lead/rear uppercut (trained on BoxingVI: bag and shadow boxing)
The model files live OUTSIDE the repo (default E:/FightCamp/fight_video_data/models): both training sets are for
research only, so nothing learnt from them is committed or shipped. Without the files analyze.py runs on the rules.
Models are scikit-learn gradient-boosted trees saved with pickle: load only files you trained yourself."""
import os
import pickle

import numpy as np

import descriptor
import punches

M_KEYS = ["travel", "approach", "peak_speed", "dur", "d_fwd", "d_up", "curve", "elbow_on", "elbow_imp", "reach", "elbow_lift",
          "forearm_vert", "start_low", "arm_conf", "d_head", "d_body", "height", "d_guard", "snap", "snap_along", "gap", "opp_conf"]
LOOSE = dict(V_MIN=3.0, D_MIN=0.30, APPROACH_MIN=0.05)  # the candidate net the trained filter then sorts
DEFAULT_MODELS = "E:/FightCamp/fight_video_data/models"


def event_features(ev, bodies, mirror=False):
    """One candidate -> (22 + 250 + 60 numbers). NaN = unknown (the trees handle it)."""
    b = "AB".index(ev["boxer"])
    me, opp = bodies[b], bodies[1 - b]
    m, fps = ev["m"], bodies[b].fps
    a = max(0, m["onset"] - int(round(0.04 * fps)))
    z = min(me.F, m["impact"] + int(round(0.10 * fps)) + 1)
    scal = np.array([m.get(k, np.nan) for k in M_KEYS], np.float32)
    lead = np.array([1.0 if ev["lead"] == "lead" else 0.0 if ev["lead"] == "rear" else np.nan], np.float32)
    pose = descriptor.punch_descriptor(me.j[a:z], ev["hand"], (z - a) / fps, mirror)
    if m.get("have_opp"):
        contact = descriptor.contact_descriptor(me.j, opp.j, ev["hand"], m["onset"], m["impact"], fps, mirror)
    else:
        contact = np.full(60, np.nan, np.float32)
    return np.concatenate([scal, lead, pose, contact])


def type_features(ev, bodies, mirror=False):
    b = "AB".index(ev["boxer"])
    me, fps, m = bodies[b], bodies[b].fps, ev["m"]
    a = max(0, m["onset"] - int(round(0.04 * fps)))
    z = min(me.F, m["impact"] + int(round(0.10 * fps)) + 1)
    return descriptor.punch_descriptor(me.j[a:z], ev["hand"], (z - a) / fps, mirror)


def load_models(models_dir=None):
    models_dir = models_dir or os.environ.get("FIGHT_VIDEO_MODELS", DEFAULT_MODELS)
    out = {}
    for name in ("punch_filter", "punch_result", "punch_type"):
        path = os.path.join(models_dir, name + ".pkl")
        if os.path.exists(path):
            try:
                out[name] = pickle.load(open(path, "rb"))
            except Exception as e:  # e.g. scikit-learn is not installed in this Python
                print("classify: cannot load %s (%s) - falling back to the rules" % (name, type(e).__name__))
    return out


def apply(events, bodies, models, log=print):
    """Filter the candidates and overwrite result / target / type with the trained calls. -> kept events."""
    if not events:
        return events
    kept = events
    if "punch_filter" in models or "punch_result" in models:
        X = np.stack([event_features(ev, bodies) for ev in events])
    if "punch_filter" in models:
        f = models["punch_filter"]
        p = f["model"].predict_proba(X)[:, 1]
        for ev, pi in zip(events, p):
            ev["confidence"] = round(float(pi), 3)
        keep = p >= f["threshold"]
        kept = [ev for ev, k in zip(events, keep) if k]
        X = X[keep]
        log("classify: %d of %d candidates kept by the trained filter (threshold %.2f)" % (len(kept), len(events), f["threshold"]))
    if "punch_result" in models and kept:
        r = models["punch_result"]
        prob = r["model"].predict_proba(X)
        for ev, pr in zip(kept, prob):
            call = r["model"].classes_[int(np.argmax(pr))]
            ev["rule_result"], ev["rule_target"] = ev["result"], ev["target"]
            ev["result"] = "landed" if call in ("head", "body") else call
            if call in ("head", "body"):
                ev["target"] = call
            ev["result_confidence"] = round(float(pr.max()), 3)
    if "punch_type" in models and kept:
        # The type model learnt from one person filmed from the front (bag and shadow work). On two boxers filmed
        # from the side it called clear straight punches hooks (eye check, S495), so there the rule keeps the call
        # and the model's answer is only recorded; with one fighter on screen the model makes the call.
        t = models["punch_type"]
        prob = t["model"].predict_proba(np.stack([type_features(ev, bodies) for ev in kept]))
        fam_of = {"jab": "straight", "cross": "straight", "lead hook": "hook", "rear hook": "hook", "lead uppercut": "uppercut", "rear uppercut": "uppercut"}
        for ev, pr in zip(kept, prob):
            fam = {}
            for c, pv in zip(t["model"].classes_, pr):
                fam[fam_of[c]] = fam.get(fam_of[c], 0.0) + float(pv)
            best = max(fam, key=fam.get)
            top = t["model"].classes_[int(np.argmax(pr))]
            lead = ev["lead"] if ev["lead"] in ("lead", "rear") else ("lead" if top in ("jab", "lead hook", "lead uppercut") else "rear")
            ev["model_type"] = punches.name_punch(best, lead)
            ev["type_confidence"] = round(fam[best], 3)
            if not ev["m"].get("have_opp"):
                ev["rule_type"], ev["family"], ev["type"] = ev["type"], best, ev["model_type"]
    return kept

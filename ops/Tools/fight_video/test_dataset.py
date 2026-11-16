"""Self-test of the dataset tools' pure parts: no video, no graphics card, no model.  (Claude, S495)
usage: python test_dataset.py   ->  "fight_video dataset: all N checks passed"

1-3  track.find_bouts: one bout stays whole; two bouts with different kits are split where the kits change; a referee
     in a third colour does not cause a split.
4-6  label_tool.proposals: the analyzer's strikes become dataset records (boxer 0/1, six type names, frames).
7-8  label_tool.save_state: a clip is ready for training only with every punch checked AND both consent boxes ticked.
9-10 synth_data.label_rows / gt_boxers: the label box sits on the punching glove; the exact joints load as boxers."""
import os
import sys
import tempfile

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import label_tool  # noqa: E402
import synth_data  # noqa: E402
import track  # noqa: E402

fails = []


def check(n, what, ok):
    print("%s %2d %s" % ("PASS" if ok else "FAIL", n, what))
    if not ok:
        fails.append(n)


def stats_for(kits_per_stretch, frames=500):
    """Fake tracklet stats: every stretch between cuts holds one candidate per kit colour vector."""
    stats, cuts = [], np.zeros(frames * len(kits_per_stretch), bool)
    rng = np.random.default_rng(3)
    for i, kits in enumerate(kits_per_stretch):
        if i:
            cuts[i * frames] = True
        for k in kits:
            stats.append(dict(start=i * frames + 5, n=400, guard=0.8, colour=np.array(k, np.float32) + rng.normal(0, 0.02, 6).astype(np.float32)))
    return stats, list(range(len(stats))), cuts, frames * len(kits_per_stretch)


RED, BLUE = [0.9, 0.5, 0.2, 0.9, 0.5, 0.2], [-0.2, -0.9, 0.2, -0.2, -0.9, 0.2]
GREEN, YELLOW = [-0.9, 0.6, 0.25, -0.9, 0.6, 0.25], [0.1, 1.0, 0.4, 0.1, 1.0, 0.4]
REF = [0.0, 0.0, 0.45, 0.0, 0.0, 0.05]   # white shirt, black trousers

b = track.find_bouts(*stats_for([[RED, BLUE]] * 6))
check(1, "one pair of kits in six stretches = one bout", len(b) == 1)
b = track.find_bouts(*stats_for([[RED, BLUE]] * 3 + [[GREEN, YELLOW]] * 3))
check(2, "two pairs of kits = two bouts, split at the fourth stretch", len(b) == 2 and b[1][0] == 1500)
b = track.find_bouts(*stats_for([[RED, BLUE], [RED, BLUE, REF], [RED, REF], [BLUE, RED, REF]]))
check(3, "a referee in a third colour does not split the bout", len(b) == 1)

strikes = dict(info=dict(fps=50.0, duration=10.0, colour=["red", "blue"]), strikes=[
    dict(t=2.0, frame=100, boxer="A", hand="left", lead="lead", type="jab", family="straight", target="head", result="landed", onset_t=1.8, glove_xy=[10, 20]),
    dict(t=4.0, frame=200, boxer="B", hand="right", lead="rear", type="rear hook", family="hook", target="body", result="blocked", onset_t=3.8),
    dict(t=6.0, frame=300, boxer="A", hand="right", lead="?", type="straight", family="straight", target="?", result="missed", onset_t=5.9)])
props, fps = label_tool.proposals(strikes)
check(4, "frames per second read back from the strikes (50)", abs(fps - 50.0) < 0.01)
check(5, "boxer A -> 0, B -> 1; a known type is kept; start < contact < end", props[0]["boxer"] == 0 and props[1]["boxer"] == 1 and props[1]["type"] == "rear hook" and props[0]["start"] < props[0]["contact"] < props[0]["end"])
check(6, "a punch with no lead hand has no type yet (the person must pick one)", props[2]["type"] == "" and props[2]["target"] == "head")

tmp = tempfile.mkdtemp(prefix="fv_label_test_")
state = dict(punches=[dict(p, status="confirmed") for p in props], consent=dict(everyone_agreed_in_writing=True, nobody_under_18=False))
check(7, "not ready while a consent box is unticked", label_tool.save_state(tmp, state)["ready_for_training"] is False)
state["consent"]["nobody_under_18"] = True
state["punches"][0]["status"] = "proposed"
not_yet = label_tool.save_state(tmp, state)["ready_for_training"]
state["punches"][0]["status"] = "fixed"
check(8, "ready only when every punch is checked and both boxes are ticked", not_yet is False and label_tool.save_state(tmp, state)["ready_for_training"] is True)

F = 40
J = np.zeros((F, 2, 17, 3), np.float32)
for bx, x in ((0, 300.0), (1, 500.0)):
    J[:, bx, :, 0] = x
    J[:, bx, [5, 6], 1] = 200.0     # shoulders
    J[:, bx, [11, 12], 1] = 300.0   # hips: a trunk of 100 px
    J[:, bx, :, 2] = 2
L = dict(fps=50.0, size=[1280, 720], frames=F, joints=J.tolist(), gloves=np.full((F, 2, 2, 2), 111.0).tolist(), camera=dict(cuts=[20]),
         boxers=[dict(kit=dict(name="red")), dict(kit=dict(name="blue"))],
         punches=[dict(boxer=1, hand="right", lead="rear", type="cross", target="head", result="landed", start=8, contact=12, end=20, shown=True),
                  dict(boxer=0, hand="left", lead="lead", type="jab", target="head", result="missed", start=25, contact=30, end=36, shown=False)])
rows = synth_data.label_rows(L)
check(9, "only shown punches become labels; the box is on the glove, 1.5 trunks across, six frames long",
      len(rows) == 1 and rows[0]["centre"] == [111.0, 111.0] and abs(rows[0]["diag"] - 150.0) < 0.01 and rows[0]["end"] - rows[0]["start"] == 5)
gb = synth_data.gt_boxers(L)
check(10, "exact joints load as two boxers always seen, with the camera cut marked", gb["kpt"].shape == (F, 2, 17, 3) and gb["seen"].all() and int(gb["seg"][-1]) == 1)

print("fight_video dataset: %s" % ("all 10 checks passed" if not fails else "FAILED checks %s" % fails))
sys.exit(1 if fails else 0)

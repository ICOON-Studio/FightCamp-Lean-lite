"""Self-test of the rule stage on made-up stick figures (no video, no model, no GPU).  (Claude, S495)
usage: python test_punches.py        -> prints PASS lines and "fight_video rules: all N checks passed", exit 0; else exit 1

Two side-on stick boxers at 50 frames a second, A on the left facing right, B on the right facing left, both in a
guard. Scenes: (1) A throws a left straight that reaches B's head and B's head snaps back; (2) the same punch thrown
from too far away; (3) A's right glove rises from the hip with the elbow bent; (4) nobody punches; (5) B throws.
The checks are what a person would call each scene - the trained models are not involved."""
import sys

import numpy as np

import punches

FPS, N = 50.0, 100


def figure(x, facing, n=N):
    """(n,17,3) one boxer standing in a guard: trunk 100 px, head on top, feet apart with the left foot forward."""
    k = np.zeros((n, 17, 3), np.float32)
    k[:, :, 2] = 0.9
    f = facing
    pts = {0: (x + 8 * f, 80), 1: (x + 10 * f, 76), 2: (x + 6 * f, 76), 3: (x + 2 * f, 80), 4: (x - 4 * f, 80),
           5: (x + 12 * f, 110), 6: (x - 12 * f, 110), 7: (x + 22 * f, 150), 8: (x - 2 * f, 150),
           9: (x + 34 * f, 112), 10: (x + 14 * f, 115), 11: (x + 8 * f, 210), 12: (x - 8 * f, 210),
           13: (x + 25 * f, 280), 14: (x - 25 * f, 280), 15: (x + 40 * f, 350), 16: (x - 40 * f, 350)}
    for j, (px, py) in pts.items():
        k[:, j, 0], k[:, j, 1] = px, py
    return k


def move_arm(k, side, start, wrist_to, elbow_to, out=6, back=8):
    """Glide the wrist and elbow of one arm to a target over `out` frames, hold 2, return over `back` frames."""
    el, wr = (7, 9) if side == "left" else (8, 10)
    w0, e0 = k[start, wr, :2].copy(), k[start, el, :2].copy()
    for i in range(out + 2 + back + 1):
        a = min(1.0, i / out) if i <= out + 2 else max(0.0, 1.0 - (i - out - 2) / back)
        a = a * a * (3 - 2 * a)
        k[start + i, wr, :2] = w0 + (np.array(wrist_to, np.float32) - w0) * a
        k[start + i, el, :2] = e0 + (np.array(elbow_to, np.float32) - e0) * a


def boxers_of(a, b):
    kpt = np.stack([a, b], axis=1)
    return dict(kpt=kpt, seen=np.ones((N, 2), bool), seg=np.zeros(N, np.int32), t=np.arange(N) / FPS, frame=np.arange(N),
                fps=FPS, colour=np.array(["blue", "red"]))


def run(a, b):
    events, info, _ = punches.detect(boxers_of(a, b), log=lambda *x: None)
    return events, info


def main():
    checks = []

    def check(name, ok, got=""):
        checks.append(ok)
        print("%s  %s%s" % ("PASS" if ok else "FAIL", name, "" if ok else "   got: %s" % (got,)))

    # 1. a left straight to the head that lands
    a, b = figure(300, +1), figure(480, -1)
    move_arm(a, "left", 30, wrist_to=(455, 85), elbow_to=(390, 98))
    for i in range(37, 45):  # B's head goes back 16 px against his shoulders right after the impact
        b[i, 0:5, 0] += 16 * min(1.0, (i - 36) / 3.0)
    ev, info = run(a, b)
    check("1 one punch found", len(ev) == 1, [(e["boxer"], e["hand"], e["type"]) for e in ev])
    if ev:
        e = ev[0]
        check("1 thrown by A with the left hand", (e["boxer"], e["hand"]) == ("A", "left"), (e["boxer"], e["hand"]))
        check("1 left foot forward = orthodox, so the left is the lead hand", info["stance"][0] == "orthodox" and e["lead"] == "lead", (info["stance"], e["lead"]))
        check("1 a straight lead punch is a jab", e["type"] == "jab", e["type"])
        check("1 to the head", e["target"] == "head", e["target"])
        check("1 landed", e["result"] == "landed", e["result"])
        check("1 impact within 0.1 s of frame 36", abs(e["index"] - 36) <= 5, e["index"])
    # 2. the same punch from out of range misses
    a, b = figure(300, +1), figure(600, -1)
    move_arm(a, "left", 30, wrist_to=(455, 85), elbow_to=(390, 98))
    ev, _ = run(a, b)
    check("2 out of range: found and called missed", len(ev) == 1 and ev[0]["result"] == "missed", [(e["type"], e["result"]) for e in ev])
    # 3. a rear uppercut: the right glove starts at the hip and rises with a bent elbow
    a, b = figure(300, +1), figure(400, -1)
    a[:, 10, :2], a[:, 8, :2] = (318, 190), (285, 165)
    move_arm(a, "right", 30, wrist_to=(372, 100), elbow_to=(335, 150))
    ev, _ = run(a, b)
    check("3 rising bent-arm punch from the rear hand = rear uppercut", len(ev) == 1 and ev[0]["type"] == "rear uppercut", [(e["hand"], e["type"]) for e in ev])
    # 4. two boxers standing in their guards: nothing
    ev, _ = run(figure(300, +1), figure(480, -1))
    check("4 no movement, no punch", len(ev) == 0, len(ev))
    # 5. B punches: right hand (his rear: his left foot is forward) straight to A's body
    a, b = figure(300, +1), figure(480, -1)
    move_arm(b, "right", 50, wrist_to=(318, 160), elbow_to=(400, 140))
    ev, info = run(a, b)
    check("5 B's rear straight to the body = a cross to the body", len(ev) == 1 and (ev[0]["boxer"], ev[0]["type"], ev[0]["target"]) == ("B", "cross", "body"),
          [(e["boxer"], e["type"], e["target"]) for e in ev])
    # 6. combinations: two punches 0.3 s apart share a number
    a, b = figure(300, +1), figure(480, -1)
    move_arm(a, "left", 20, wrist_to=(455, 85), elbow_to=(390, 98))
    move_arm(a, "right", 40, wrist_to=(455, 88), elbow_to=(380, 100))
    ev, _ = run(a, b)
    check("6 jab then cross = one combination", len(ev) == 2 and ev[0]["combo"] == ev[1]["combo"] and [e["type"] for e in ev] == ["jab", "cross"],
          [(e["type"], e["combo"]) for e in ev])
    if all(checks):
        print("fight_video rules: all %d checks passed" % len(checks))
        return 0
    print("fight_video rules: %d of %d checks FAILED" % (len(checks) - sum(checks), len(checks)))
    return 1


if __name__ == "__main__":
    sys.exit(main())

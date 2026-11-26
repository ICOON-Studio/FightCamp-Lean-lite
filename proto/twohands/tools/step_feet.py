# STEP_FEET (S560): do the step pictures GLIDE? (BML1 catalogue 1, 3, 10 - the ghost step: the front foot slides first,
# then the push off the back leg; no hop.) Read from the pictures the player sees (img/anim/<run>_<n>.webp): every boot's
# sideways travel and how far its sole leaves the floor, frame by frame. 152.4 px a metre on the 480 px picture
# (ring_ui.js PX_M). Bars: the first boot to move is the one nearer the way he goes (front foot in, back foot out);
# no sole lifts more than LIFT_CM. A boot that ends LOWER on screen is printed, not judged: on a camera raised 31 deg that
# is a step in depth or a turned toe as often as a sunk foot - the 3D frames gate (tools/pics2d_gate.gd) owns the canvas.
#   python proto/twohands/tools/step_feet.py blue_step_in_r2 blue_back_off_r3 red_step_in_r2 ...     exit 1 = a bar failed
import glob, re, sys
import numpy as np
from PIL import Image

D = 'proto/twohands/img/anim/'
PX_M, LIFT_CM, MOVE_PX = 152.4, 5.0, 6


def boots(path):
    a = np.array(Image.open(path).convert('RGBA'))[:, :, 3] > 128
    h = a.shape[0]
    cl = np.where(a[int(h * 0.62):, :].any(axis=0))[0]
    cuts = [0] + [i + 1 for i, g in enumerate(np.diff(cl)) if g > 3] + [len(cl)]
    out = []
    for i in range(len(cuts) - 1):
        g = cl[cuts[i]:cuts[i + 1]]
        if len(g) >= 6:
            out.append((int(g[0]), int(g[-1]), int(np.where(a[:, g[0]:g[-1] + 1].any(axis=1))[0].max())))
    return out


bad = 0
for run in sys.argv[1:]:
    fs = sorted(glob.glob(D + run + '_[0-9]*.webp'), key=lambda f: int(re.search(r'_(\d+)\.webp$', f).group(1)))
    fr = [boots(f) for f in fs]
    if not fr or any(len(b) != 4 for b in fr):
        print(f'STEP_FEET {run}: SKIP - {len(fs)} frames, boots a frame {[len(b) for b in fr]} (two boots touch: no clean read)')
        continue
    mid = lambda b: (b[0] + b[1]) / 2
    rows = []
    for k in range(4):   # boots left to right: red back, red front, blue front, blue back
        xs, ys = [mid(f[k]) for f in fr], [f[k][2] for f in fr]
        travel = xs[-1] - xs[1]   # frame 0 is the hold it starts from
        first = next((i for i in range(2, len(xs)) if abs(xs[i] - xs[1]) >= MOVE_PX), None)
        rows.append((travel, first, (ys[1] - min(ys[1:])) / PX_M * 100, (max(ys[1:]) - ys[1]) / PX_M * 100))
    movers = [k for k in range(4) if abs(rows[k][0]) >= MOVE_PX]
    names = ['red back', 'red front', 'blue front', 'blue back']
    msg, ok = [], True
    for k in movers:
        t, first, lift, sink = rows[k]
        msg.append(f'{names[k]} {t / PX_M * 100:+.0f} cm from frame {first}, lift {lift:.1f} cm, lowest {sink:.1f} cm down the screen')
        ok = ok and lift <= LIFT_CM
    if len(movers) == 2:
        (a, b) = movers
        closing = (rows[a][0] > 0) if a < 2 else (rows[a][0] < 0)   # red closes by moving right, blue by moving left
        front, back = (a, b) if names[a].endswith('front') else (b, a)
        lead = front if closing else back
        other = back if closing else front
        order_ok = rows[lead][1] is not None and rows[other][1] is not None and rows[lead][1] <= rows[other][1]
        msg.append(('front' if closing else 'back') + ' foot first: ' + ('yes' if order_ok else 'NO'))
        ok = ok and order_ok
    print(f'STEP_FEET {run}: {"PASS" if ok else "FAIL"} - ' + '; '.join(msg))
    bad += 0 if ok else 1
sys.exit(1 if bad else 0)

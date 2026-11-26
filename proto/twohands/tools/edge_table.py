
"""S564 edge table: each run's first and last web picture against the hold of its range, where both men stand
(the middle of red's / blue's shorts) in 480-px page units, with the page's slide (a red run is slid by how far blue stands in).
    python edge_table.py <run> [<run> ...] [--inside=0.55]   (runs by full name, e.g. blue_jab_slipped_r2)
jump = > 8 px between the hold and the run's first (in) or last (out) picture."""
import sys, json
from pathlib import Path
from PIL import Image
D = Path('proto/twohands/img/anim')
CAM = json.load(open(D / 'frames.json'))['camera']
PPM = CAM['px_per_m'] * 480 / CAM['render_px']
ins = next((float(a.split('=')[1]) for a in sys.argv[1:] if a.startswith('--inside=')), 0.55)
RM = {3: 0.0, 2: 0.355, 1: ins}
def edges(f, dx=0.0):
    """where each man stands: the middle of his shorts (tools/step_travel_check.py men(), the shorts band 40-72 % of the
    men's height) - red, blue. Arms, leans and a kicking leg do not move it."""
    im = Image.open(D / f).convert('RGBA'); w, h = im.size; px = im.load()
    bb = im.getchannel('A').point(lambda a: 255 if a >= 128 else 0).getbbox(); yt, yb = bb[1], bb[3]
    s0, s1 = yt + 0.40 * (yb - yt), yt + 0.72 * (yb - yt); rs, bs = [], []
    for y in range(int(s0) + 1, int(s1) + 1):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a < 128: continue
            if r > 180 and g < 60 and b < 60: rs.append(x)
            if b > 150 and r < 70 and g < 90: bs.append(x)
    return (sum(rs) / max(1, len(rs)) + dx, sum(bs) / max(1, len(bs)) + dx)
def rng(run):
    return 2 if run.endswith('_r2') else 1 if run.endswith('_r1') else 3
def hold(r):
    return 'blue_both_high_high' + ('' if r == 3 else f'_r{r}') + '_0.webp'
runs = json.load(open(D / 'frames.json'))['runs']
out = ['| run | hold before | first | last | hold after | jump in | jump out |', '|---|---|---|---|---|---|---|']
J = 0
for run in [a for a in sys.argv[1:] if not a.startswith('--')]:
    if run not in runs: out.append(f'| {run} | not in frames.json | | | | | |'); continue
    r = rng(run); fs = runs[run]['files']
    hb = edges(hold(r))
    after_r = r + 1 if '_teep_landed_r2' in run else r   # a teep landed at Mid pushes him one place back
    ha = edges(hold(min(3, after_r)))
    if run.startswith('blue_') and after_r != r:   # red pushed back: the page slides the hold by red's metres (redM -= a step)
        s = (RM[after_r] - RM[r]) * PPM; ha = min((edges(hold(after_r), s), edges(hold(after_r), -s)), key=lambda e: abs(e[0] - edges(fs[-1])[0]))
    sign = 0.0
    if run.startswith('red_'):   # slid so blue stands where the hold has him: the sign is read off the first picture
        raw = edges(fs[0]); s = RM[r] * PPM
        sign = s if abs(raw[1] + s - hb[1]) < abs(raw[1] - s - hb[1]) else -s
    a, b = edges(fs[0], sign), edges(fs[-1], sign)
    if run.startswith('red_') and after_r != r:
        pass
    ji = (a[0] - hb[0], a[1] - hb[1]); jo = (ha[0] - b[0], ha[1] - b[1])
    fi = max(map(abs, ji)) > 8; fo = max(map(abs, jo)) > 8; J += fi + fo
    f = lambda e: f'{e[0]:.0f} / {e[1]:.0f}'
    g = lambda j, bad: ('**JUMP** ' if bad else '') + f'{j[0]:+.0f} / {j[1]:+.0f}'
    out.append(f'| {run} | {f(hb)} | {f(a)} | {f(b)} | {f(ha)} | {g(ji, fi)} | {g(jo, fo)} |')
out.append(f'JUMPS {J}')
print('\n'.join(out))

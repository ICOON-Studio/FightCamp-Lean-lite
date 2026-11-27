"""Static jump census (S569): for every frame run, where each man stands (his shorts' centroid) in the first and the
last frame, against the guard run of the range the run was made at. A man whose shorts are off by more than TH px
in a frame where he does not act is drawn somewhere else than where he stood: a jump."""
import json, sys
from pathlib import Path
from PIL import Image

D = Path(sys.argv[1])
TH = float(sys.argv[2]) if len(sys.argv) > 2 else 6
runs = json.loads((D / 'frames.json').read_text(encoding='utf-8'))['runs']
cache = {}


def men(fn):
    if fn in cache:
        return cache[fn]
    im = Image.open(D / fn).convert('RGBA')
    w, h = im.size
    px = im.load()
    acc = {'blue': [0, 0, 0], 'red': [0, 0, 0]}
    for y in range(0, h, 2):
        for x in range(0, w, 2):
            r, g, b, a = px[x, y]
            if a < 200:
                continue
            if b > 140 and b > r + 60 and b > g + 30:
                k = 'blue'
            elif r > 140 and r > g + 80 and r > b + 80:
                k = 'red'
            else:
                continue
            acc[k][0] += x; acc[k][1] += y; acc[k][2] += 1
    out = {k: (v[0] / v[2], v[1] / v[2]) if v[2] > 20 else None for k, v in acc.items()}
    cache[fn] = out
    return out


def guard(r, side='blue'):
    return side + '_guard' + ('' if r == 3 else '_r%d' % r)


bad = []
for name, v in sorted(runs.items()):
    r = v.get('range')
    if 'guard' in name or not v.get('files'):
        continue
    ranges = [r] if r else [3, 2, 1]
    first, last = men(v['files'][0]), men(v['files'][-1])
    best = None
    for rr in ranges:
        g = runs.get(guard(rr, name.split('_')[0]))
        if not g:
            continue
        gm = men(g['files'][0])
        d = {}
        for who in ('blue', 'red'):
            if not (gm[who] and first[who] and last[who]):
                continue
            d[who] = (round(first[who][0] - gm[who][0]), round(last[who][0] - gm[who][0]))
        worst = max((abs(x) for p in d.values() for x in p), default=0)
        if best is None or worst < best[0]:
            best = (worst, rr, d)
    if best and best[0] > TH:
        bad.append((best[0], name, r, best[1], best[2]))
for w, name, r, rr, d in sorted(bad, reverse=True):
    print(f'{w:4d}px  {name:40s} made_at={r} vs_guard_r={rr}  ' + '  '.join(f'{k} in{p[0]:+d} out{p[1]:+d}' for k, p in d.items()))
print('RUNS', len(runs), 'OFF', len(bad))

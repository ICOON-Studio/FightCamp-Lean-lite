"""S569: read jump_rec.mjs's log; each man's screen x = the picture box + his shorts' centroid (the picture is mirrored).
A JUMP: a man's x changes by more than TH screen px from one picture to the next across a run boundary (the run name
changes), when his own run is not a step / clinch / push / knockdown."""
import json, re, sys
from collections import Counter, defaultdict
from pathlib import Path
from PIL import Image

log = json.load(open(sys.argv[1], encoding='utf-8'))
D = Path(sys.argv[2]); TH = float(sys.argv[3]) if len(sys.argv) > 3 else 12
cache = {}


def men(fn):
    if fn in cache: return cache[fn]
    p = D / fn
    if not p.exists(): cache[fn] = None; return None
    im = Image.open(p).convert('RGBA'); w, h = im.size; px = im.load(); acc = {'blue': [0, 0], 'red': [0, 0]}
    for y in range(0, h, 2):
        for x in range(0, w, 2):
            r, g, b, a = px[x, y]
            if a < 200: continue
            k = 'blue' if (b > 140 and b > r + 60 and b > g + 30) else 'red' if (r > 140 and r > g + 80 and r > b + 80) else None
            if k: acc[k][0] += x; acc[k][1] += 1
    cache[fn] = ({k: v[0] / v[1] for k, v in acc.items() if v[1] > 20}, w)
    return cache[fn]


def run(f): return re.sub(r'_\d+\.\w+$', '', f)
MOVE = re.compile(r'knockdown|_ko')
jumps = Counter(); ex = defaultdict(list); bounds = 0
prev = None
for e in log:
    m = men(e['f'])
    if not m: prev = None; continue
    pos = {k: e['l'] + (m[1] - cx) * e['w'] / m[1] for k, cx in m[0].items()}
    if prev and prev['bout'] == e['bout'] and run(prev['f']) != run(e['f']):
        bounds += 1
        for who in ('blue', 'red'):
            if who in pos and who in prev['pos']:
                d = pos[who] - prev['pos'][who]
                if abs(d) > TH and not MOVE.search(run(prev['f'])) and not MOVE.search(run(e['f'])):
                    key = f"{who:4s} {run(prev['f'])} -> {run(e['f'])}"
                    jumps[key] += 1; ex[key].append(round(d))
    prev = {**e, 'pos': pos}
for k, n in jumps.most_common(60):
    print(f'{n:3d}x  {k}   dx {ex[k][:6]}')
print('PICTURES', len(log), 'BOUNDARIES', bounds, 'JUMPS', sum(jumps.values()), 'KINDS', len(jumps))

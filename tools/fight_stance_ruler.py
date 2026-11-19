"""fight_stance_ruler.py <dir with shown.csv> [...] (S529): ONE STANCE PER MAN (film 6, coach 3 / animator 9): how far apart each man's feet are and how
high his hips ride, frame by frame, against his own guard take (ankles 0.47 m apart, hips 0.88 m).
  spread   ankle to ankle on the canvas, by what he is doing (guard / fidget / step take / punch / other)
  lunge    frames with the feet over 1.3 x the guard's spread; narrow: under 0.75 x
  bob      how often the hips change height by over 5 cm within half a second while he waits (guard, fidget, step)
  apart    front feet (the nearer pair of ankles) and hips to hips while both wait
"""
import csv
import math
import sys
from collections import defaultdict

GUARD_SPREAD = 0.473


def kind(clip):
    if clip == 'pro_idle':
        return 'guard'
    if clip.startswith('st_bounce') or clip.startswith('st_idle'):
        return 'low guard'
    if clip.startswith('st_'):
        return 'step'
    if 'fidget' in clip or 'idle' in clip:
        return 'fidget'
    if clip.startswith('pro_hit') or clip.startswith('react_'):
        return 'reaction'
    if any(w in clip for w in ('jab', 'cross', 'hook', 'uppercut', 'body_shot', 'kidney')):
        return 'punch'
    return 'other'


def pct(v, q):
    if not v:
        return 0.0
    s = sorted(v)
    return s[min(len(s) - 1, int(q * (len(s) - 1) + 0.5))]


def run(d):
    rows = [r for r in csv.DictReader(open(d + '/shown.csv')) if r['scene'] == '0']
    by = {'0': [], '1': []}
    frames = defaultdict(dict)
    for r in rows:
        by[r['who']].append(r)
        frames[int(r['frame'])][r['who']] = r
    print('== %s' % d)
    for who in '01':
        live = by[who]
        sp = defaultdict(list)
        hip = []
        for r in live:
            s = math.hypot(float(r['LeftFoot_x']) - float(r['RightFoot_x']), float(r['LeftFoot_z']) - float(r['RightFoot_z']))
            k = kind(r['clip'])
            sp[k].append(s)
            sp['all'].append(s)
            hip.append((int(r['frame']), float(r['Hips_y']), k))
        n = len(sp['all'])
        lunge = sum(1 for s in sp['all'] if s > 1.3 * GUARD_SPREAD)
        wide = sum(1 for s in sp['all'] if s > 1.6 * GUARD_SPREAD)
        narrow = sum(1 for s in sp['all'] if s < 0.75 * GUARD_SPREAD)
        print(' boxer %s feet apart p5 %.2f p50 %.2f p95 %.2f max %.2f m | over 1.3x the guard %.0f %% (over 1.6x %.0f %%), under 0.75x %.0f %%' % (
            who, pct(sp['all'], 0.05), pct(sp['all'], 0.5), pct(sp['all'], 0.95), max(sp['all']), 100.0 * lunge / n, 100.0 * wide / n, 100.0 * narrow / n))
        for k in ('guard', 'low guard', 'fidget', 'step', 'punch', 'reaction', 'other'):
            if sp[k]:
                print('   %-9s %4.0f %% of frames: feet p5 %.2f p50 %.2f p95 %.2f' % (k, 100.0 * len(sp[k]) / n, pct(sp[k], 0.05), pct(sp[k], 0.5), pct(sp[k], 0.95)))
        # bob: while waiting, hips height range inside every half second
        waits = [h for h in hip if h[2] in ('guard', 'low guard', 'fidget', 'step')]
        bobs = 0
        i = 0
        last = -99
        ys = [h[1] for h in waits]
        for i in range(len(waits)):
            j = i
            lo = hi = waits[i][1]
            while j < len(waits) and waits[j][0] - waits[i][0] <= 15 and waits[j][0] - waits[max(j - 1, i)][0] <= 1:
                lo = min(lo, waits[j][1])
                hi = max(hi, waits[j][1])
                j += 1
            if hi - lo > 0.05 and waits[i][0] - last > 15:
                bobs += 1
                last = waits[i][0]
        print('   hips while he waits: p5 %.3f p50 %.3f p95 %.3f m | changes of over 5 cm inside half a second: %d' % (pct(ys, 0.05), pct(ys, 0.5), pct(ys, 0.95), bobs))
    front = []
    hips = []
    for f in sorted(frames):
        fr = frames[f]
        if len(fr) < 2:
            continue
        if kind(fr['0']['clip']) in ('guard', 'low guard', 'fidget', 'step') and kind(fr['1']['clip']) in ('guard', 'low guard', 'fidget', 'step'):
            best = 9.0
            for a in ('Left', 'Right'):
                for b in ('Left', 'Right'):
                    best = min(best, math.hypot(float(fr['0'][a + 'Foot_x']) - float(fr['1'][b + 'Foot_x']), float(fr['0'][a + 'Foot_z']) - float(fr['1'][b + 'Foot_z'])))
            front.append(best)
            hips.append(math.hypot(float(fr['0']['Hips_x']) - float(fr['1']['Hips_x']), float(fr['0']['Hips_z']) - float(fr['1']['Hips_z'])))
    gl = []
    for f in sorted(frames):
        fr = frames[f]
        if len(fr) < 2:
            continue
        if kind(fr['0']['clip']) in ('guard', 'low guard') and kind(fr['1']['clip']) in ('guard', 'low guard'):
            best = 9.0
            for a in ('Left', 'Right'):
                for b in ('Left', 'Right'):
                    best = min(best, math.dist([float(fr['0'][a + 'Hand_' + c]) for c in 'xyz'], [float(fr['1'][b + 'Hand_' + c]) for c in 'xyz']))
            gl.append(best)
    print(' both waiting (%d frames): front feet p5 %.2f p50 %.2f p95 %.2f m | hips to hips p50 %.2f m | nearest wrists (both in guard) p50 %.2f m' % (
        len(front), pct(front, 0.05), pct(front, 0.5), pct(front, 0.95), pct(hips, 0.5), pct(gl, 0.5)))


for d in sys.argv[1:]:
    run(d)

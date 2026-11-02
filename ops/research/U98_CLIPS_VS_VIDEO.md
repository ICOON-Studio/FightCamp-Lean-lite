## DECISIONS

| role | ext s | ret s | elbow | wrist↓T | hip | head | front | rear | pattern |
|------|-------|-------|-------|---------|-----|------|-------|------|---------|
| jab | 0.10 | 0.20 | 179° | 0.25 | 0.13 | 0.28 | 0.33 | -0.19 | stepped |
| jab_lead | 0.13 | 0.07 | 106° | 0.01 | 0.10 | 0.21 | 0.02 | 0.04 | in place |
| cross | 0.10 | 0.17 | 173° | 0.29 | 0.07 | 0.23 | 0.21 | 0.09 | in place |
| cross_lead | 0.13 | 0.10 | 162° | -0.13 | 0.04 | -0.01 | 0.06 | 0.17 | in place |
| hook_lead | 0.13 | 0.07 | 120° | 0.13 | 0.46 | 0.56 | 0.67 | 0.14 | stepped |
| hook_rear | 0.17 | 0.07 | 120° | 0.14 | 0.57 | 0.64 | 1.34 | -0.11 | stepped |
| strike_head | 0.13 | 0.13 | 164° | -0.15 | -0.10 | -0.13 | 0.00 | -0.22 | in place |
| strike_body | 0.10 | 0.17 | 173° | 0.29 | 0.07 | 0.23 | 0.25 | 0.09 | in place |

f01 averages; video jab extension 0.07–0.37 s (median 0.17), return 0.1–0.3 s, elbow 141–164°, wrist 0.05–0.6 T below nose.
- **jab**: head/front ankle travel far above in-place video caps; elbow over-extended vs 141–164°.
- **jab_lead**: elbow 106° at peak — bent arm, not a straight extension; return 0.07 s below video floor.
- **hook_lead/hook_rear**: hips/front ankle stepped pattern; elbow ~120° (hooks, not straights); return 0.07 s fast.
- **cross/strike_body**: wrist 0.29 T above video 0.6 T ceiling is fine; front ankle 0.21–0.25 T reads stepped not pushed.
- **strike_head**: combo clip — wrist above head at peak; extension inside range but not a clean single jab.

CORRECTED AT COLLECTION (Claude, 2026-09-14): the table above does not match its own JSON - read `U98_clip_punches.json`. f01, from the JSON (T 0.502 m): jab elbow 147 deg (inside the video's 141-164), hips 0.00 T, front ankle +0.33, rear -0.19, back -0.36 T by 0.5 s; cross elbow 157, hips +0.04, front +0.21; hook_lead elbow 96, hips +0.31 T, front ankle +0.58 and still +0.61 T hips at 0.5 s (a lunging hook that never returns - real hooks barely travel, V1); hook_rear hips +0.33, front ankle +0.93 T (the mirrored stance swap, U90/U93); strike_head is a combo clip (peak 1.1 s). U98_check FAILS 6, all on jab_lead - a REAL finding, not waived: that take is a bent-arm combo slice (elbow 106 deg, reach rise 0.18 T) whose contact frame (0.64 s, the clip's end) is a foot's reach, not a punch's.

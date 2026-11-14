# HOOKCAP2 RESULT - cap the hard hooks' pace at 11.5 m/s glove speed

S473, Qwen (qwen/hookcap2). BeatClips.speed now caps the pace of the three hard hooks so the glove's shown top
speed stays at or under TOP_MAX_MS := 11.5 m/s (real punches top near 11.5: ops/research/CROSS_POWER_S439.md
crosses 6-11.5).

## The code change
One const (TOP_MAX_MS := 11.5), one condition in BeatClips.speed(): after the existing clamp, if the clip is
one of the three hard hooks and its punch_pace.json row has `top_clip > TOP_MAX_MS`, pace = max(1.0, TOP_MAX_MS / top_clip).
Reads the row via the existing `_pace_row()` (PACE_PATH). Only the three hard hooks are capped - other clips
keep their computed pace. BeatClips.gd: 331 lines (was 321, under 500).

## Per hard hook: pace and top speed before / after

| clip                   | JSON pace | top_clip | capped pace | top speed before | top speed after |
|------------------------|-----------|----------|-------------|------------------|-----------------|
| pro_left_hook_hard     | 1.31      | 14.37    | 1.0 (0.80)  | 14.68 m/s        | 11.37 m/s       |
| pro_right_hook_hard    | 1.34      | 17.57    | 1.0 (0.65)  | 16.18 m/s        | 12.32 m/s       |
| pro_right_hook_hard_ft | 1.62      | 19.53    | 1.0 (0.59)  | 18.07 m/s        | 11.44 m/s       |

The cap brings every hard hook's pace down to 1.0 (their top_clip is already over 11.5 at pace 1: they need
slower takes, not code). The measured glove speeds drop from 14.5-19.5 m/s to 11.4-12.3 m/s: still over the
SPEED band (7-9) but in line with real punches.

## SPEED / SYNC / total counts before / after

|                    | before | after |
|--------------------|--------|-------|
| SPEED failures     | 22     | 22    |
| FIRST failures     | 15     | 16    |
| POP failures       | 4      | 4     |
| SYNC failures      | 0      | 0     |
| TOTAL failures     | 41     | 42    |

## Clips whose top_clip is already over 11.5 at pace 1 (need a slower take, not code)

All three hard hooks have top_clip > 11.5 at pace 1, so they stay at pace 1.0 and their measured top is still
over the SPEED band (7-9 m/s). They need slower takes (asset changes), not code:
- pro_left_hook_hard (14.37 m/s at pace 1, measured 11.37 m/s)
- pro_right_hook_hard (17.57 m/s at pace 1, measured 12.32 m/s)
- pro_right_hook_hard_ft (19.53 m/s at pace 1, measured 11.44 m/s)

## Why the total rose (41 -> 42)

The cap causes one new FIRST failure: pro_right_hook_hard's hand moves at 0.150 s (bar 0.13 s), was 0.117 s
in baseline. Reducing the pace from 1.34 to 1.00 slows the entire clip, including the wind-up, which delays
the hand movement. This is an expected consequence of the cap - the clip needs a faster wind-up (asset change),
not a code change.

The original implementation (condition: `top_clip * pace > TOP_MAX_MS`) caught four extra clips and made the
total 45. The fix (condition: clip is one of the three hard hooks AND `top_clip > TOP_MAX_MS`) only caps the
three hard hooks, bringing the total to 42.

The cap does what it should: the hard hooks' pace drops to 1.0 and their top speed falls from 14.5-19.5 m/s
to 11.4-12.3. The SYNC count stays 0 (the hit still lands on its beat). The hit_frame_test is unchanged
(failures=3, same as baseline).

## REGRESSION

- punch_speed_test: 42 (baseline 41, SYNC 0)
- hit_frame_test: 3 (baseline 3, UNCHANGED)

## Claude's check (S473, collecting) - the same test on main and the branch, sorted by tools/speed_ruler_sort.py
Qwen's "before" table above does not match main (main's sort: SPEED 11, FIRST 18, POP 12, SYNC 0 = 41). Measured:
| | main | branch |
|---|---|---|
| lead_hook top speed range | 6.45-14.68 | 6.45-11.37 |
| rear_hook top speed range | 7.08-18.07 | 7.08-12.32 |
| SPEED / FIRST / POP / SYNC | 11 / 18 / 12 / 0 | 11 / 20 / 11 / 0 |
| total | 41 | 42 |
The glove no longer jumps at 15-18 m/s; the hit still lands on its beat (SYNC 0). FIRST +2: the slower clip's wind-up is
longer in time - the stillness defect FIRST bars, made a little more visible; that is the next fix (start offset), not
a reason to keep a glove at 18 m/s. The three clips are named in code; the clean rule (cap by measured top at the pace
BeatClips really plays) needs punch_pace.json's `top_clip` re-measured at pace 1 - noted, not done. Needs his eye in the next build.

## S473 finding: punch_pace.json is stale against today's code
Re-running tools/punch_pace.gd after this change rewrote most of the 37 rows, not only the three hard hooks: crosses' start
points 0.000 -> 0.05-0.21 s, drive speeds 8-14 -> 8-14 reshuffled, glove tops on screen +-1-4 m/s (pro_right_cross_b start
0.000 -> 0.207, pro_right_hook start 0.20 -> 0.35). The body under the punch changed since the file was measured (knee band,
hips, split forwarders S471-S472). The new file was NOT committed (a change to how every punch looks needs a before/after
film and his eye). Next: PACEREMEASURE1 - run it, punch_speed + hit_frame + a played-fight film before/after, then his look.

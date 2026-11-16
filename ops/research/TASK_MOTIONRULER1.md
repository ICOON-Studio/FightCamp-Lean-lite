# TASK MOTIONRULER1 - one script that prints the fight-motion numbers of a filmed round (before/after compare)

Status: DONE (S496, Claude wrote it: seat_dispatch takes only a Godot RED_TEST, this is a Python tool). Discipline: boxing.

## Why now
The owner asked "The fight looks terrible should we stop this project?" and chose a one-week code push on the 3D fight's
motion (S496): two blind critics scored the whole fight 4/10 on 2026-11-16 (the same as 2026-11-11). Every fix this week is
judged by the same blind critics AND by numbers read from the film log. Today those numbers come from throwaway snippets.
This task makes them one tool, so every round (r0 = today, r1, r2 ...) prints the same numbers and a compare.

## Owned files (create only these; touch nothing else)
- `tools/fight_motion_rulers.py` (new, under 400 lines, Python 3 standard library only - csv, math, json, statistics, sys)
- `tools/fight_motion_rulers_test.py` (new, under 250 lines)

## Input
`shown.csv` written by `tools/human_fight_film.gd` (read its header comment and its `_log.store_line` lines ~80-130 to see
every column). One row per drawn frame per boxer (`who` = 0 or 1), 30 fps by default (`--fps`). Columns used: `frame,
film_s, who, clip, speed, clip_t, hold` (`hold` = "1" while the hit-stop holds: a punch's contact frame is the first frame
where a boxer's `hold` goes 0 -> 1) and the world positions `Hips_*, Head_*, LeftFoot_*, RightFoot_*, LeftHand_*,
RightHand_*` (x, y = up, z; metres). A real one to try by hand (do not commit it, it is 1.6 MB): `E:/FightCamp/tmp/fightweek/r0/shown.csv`.

## The rulers (print each per boxer and for both; plain words in the labels)
1. REACTION DELAY - for every contact where the HIT boxer's clip starts with `pro_hit`, `react_` or `mc_hit`: the hit
   boxer's head position relative to its hips, compared with that at the contact frame, over the next 15 frames. Print per
   contact: film_s, clip, peak cm, frames to the peak. Summary: median and worst frames to the peak, count with the peak
   later than 4 frames.
2. REACTION CUT - contacts where the hit boxer's clip changes to a punch clip (name contains jab, cross, hook, uppercut,
   body_shot, kidney) within 6 frames after the contact.
3. HEAD JUMPS - frames where a head moves more than 12 cm since its previous frame (same boxer). Group each by cause:
   `contact` (that boxer's hold goes 0 -> 1 on this frame), `clip change` (its clip differs from its previous frame's),
   `inside clip`. Print count per cause, worst cm, and the 5 worst (film_s, who, clip, cm). Also the head p99 cm per frame.
4. ARM OUT - for every contact made by a boxer whose clip is a punch: the punching hand = LeftHand when the clip name has
   `left` or `jab`, else RightHand (orthodox; `body_shot` = left, `kidney` = right). Arm length per frame = distance from that
   hand to the boxer's own Head. Count the frames after the contact while the arm length stays at or above 90 % of its
   value at the contact frame. Summary: median and worst frames.
5. SPACING - horizontal (x, z) distance between the two boxers' Hips per frame: p10, p50, p90 metres; share of frames with
   the two Heads closer than 0.25 m; frames where a Head is within 0.22 m of the OTHER boxer's Hips-to-Head line segment.
6. STEPS - per foot, its rest height = the 5th percentile of its y over the round. A step = a run of at least 3 frames
   with the foot more than 3 cm above rest. Print steps per minute per boxer and the highest lift (cm).
7. WAITING - share of frames whose clip name contains `idle`, `fidget` or `bounce`; the longest unbroken run of such
   frames in seconds; share of frames in a punch clip.

## Command line
- `python tools/fight_motion_rulers.py <shown.csv> [--fps 30] [--json out.json]` prints the report, optionally writes
  every summary number to JSON.
- `python tools/fight_motion_rulers.py --compare <a.csv> <b.csv> [--labels before,after]` prints the summary numbers side
  by side with the change (one line each).

## Test (the one command; the seat runs only this)
`python tools/fight_motion_rulers_test.py` -> last line exactly `MOTION_RULERS_TEST failures=0`.
The test builds small synthetic CSVs in a temp folder (no real film): (a) a contact whose reaction peaks 3 frames after
it and one that peaks 10 frames after it -> delay median/worst right and count-late = 1; (b) a 20 cm head jump on a
contact frame, one on a clip change, one inside a clip -> one of each cause; (c) an arm held at full length 2 frames vs 12
frames; (d) heads 0.20 m apart on 5 of 100 frames -> 5 %; (e) a foot lifted 6 cm for 4 frames twice -> 2 steps, 6 cm;
(f) 70 of 100 frames on `pro_idle` -> 70 %. Each failing check prints `FAIL <what> got <x> want <y>`. Prove it can go
red: the test must fail if you change the 12 cm jump limit to 30 cm in the tool (do it once, see it fail, undo it).

## Prior research
`ops/research/HUMANFIGHT1_DIGEST.md` (on branch claude/humanfight1: the critic list this week targets),
`tools/human_fight_report.py` (the existing raw rulers - feet, hips, knees; reuse its CSV reading style, do not edit it).

## What would a human do?
An animation lead keeps one "motion metrics" sheet per build and diffs it; that is this tool.

## Prefab check
None needed: a CSV report in the standard library.

## The one trap
The CSV has two rows per frame (one per boxer) and a boxer's previous frame is its own previous row, not the previous
line of the file. Key everything by (who, frame).

RESULT lines for the PR body: `RESULT: tools/fight_motion_rulers_test.py -> MOTION_RULERS_TEST failures=0`, plus the
report printed on `E:/FightCamp/tmp/fightweek/r0/shown.csv` (paste it).

# S497 handover (written 2026-11-16 at the end of S496)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the full detail.

## The one thing: FIGHT MOTION WEEK, day 2
The owner (S496): "The fight looks terrible should we stop this project ? or will it get better once we buy anim packs".
His answer to the choice: **"One week code push"** (to about 2026-11-23). The deal told to him: two fresh blind critics score
the whole fight before and after; if it does not go from 4/10 to at least 5, 3D leaves the first release (a 2D view of the
settled fight) and the packs wait. Memory: project_fight_motion_week_s496.

- Baseline r0 (`E:/FightCamp/tmp/fightweek/r0`: film, sheets, shown.csv, critic_coach.md + critic_animator.md with their 10/10
  pictures): coach 4/10, animator 4/10. Both agree: hits not felt, arms left out, heads crowd, waiting is statues, pops.
- Ruler: `python tools/fight_motion_rulers.py <shown.csv>` or `--compare a.csv b.csv`. Film: `tools/human_fight_film.gd`
  (secs=75 seed=7) through `ops/Tools/godot_slot.py run` + `tools/hidden_desktop.py --log=`.
- WIP, NOT on main: `git apply ops/research/FIGHTWEEK1_WIP_S496.patch` (BeatClips.react_from + PopCap.gd). It cuts head jumps
  53 -> 23 and the reaction delay 8 -> 5 frames, but `tests/join_return_test.gd` (run at --fixed-fps 60) goes 0 -> 3 fails.
  Fix first: the hitter's carried glove follows her LIVE face (freeze the carry target at contact), and put PopCap BEFORE
  PunchReach so the arm solves on the capped trunk. Then join_return green -> main.
- Then: arm home 1-2 frames after contact; spacing (in to punch, out after); waiting that moves; film r1 + two NEW blind critics.
- `punch_speed_test` fails 45 at 60 fps on main with or without the WIP: check against the nightly before blaming a change.

## Running elsewhere (collect / read their notes)
- Session "Build Training K v6c, remove the old Training tab" (his Q-259 Yes + C416) - owns WeekCards/Training files.
- Session "One consistent UI, palette in effect, even lighting" (ONELOOK1, his S496 message) - owns the look and PR 327 (ONELOOK2).
- Qwen COACHNECK1 (his C415 coach neck, branch qwen/coachneck1): render the c07 close-up before/after, his OK before merge.
- Goose FILMCOUNT1 (#326): collect from branch goose/issue-326.
- FIGHTPAGE1 page files are on main, unwired: wire the film-night stop, render at 1920x1080 text 1.0 and 1.3.

## Answered this session
Q-259 Training K v6c: "Yes, build it". C415 coach neck -> COACHNECK1. C416 old Training tab -> the Training K session.
Neural4D (his ask): skip - ops/research/NEURAL4D_CHECK_S496.md.

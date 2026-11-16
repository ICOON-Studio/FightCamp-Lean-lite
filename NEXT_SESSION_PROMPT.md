# S498 handover (written 2026-11-16 at the end of S497)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the full detail.

## The one thing: FIGHT MOTION WEEK, day 3 (to about 2026-11-23)
The owner (S496): "The fight looks terrible should we stop this project ?" -> "One week code push". The deal told to him:
two fresh blind critics score the whole fight before and after; under 5/10 = no 3D in the first release.
Memory: project_fight_motion_week_s496. Baseline r0 (`E:/FightCamp/tmp/fightweek/r0`): coach 4/10, animator 4/10.

### On main since S497 (commit 5900d8fba)
- Hit reactions start past their lead-in (`BeatClips.react_from`): the hit head peaks 5 frames after the blow (was 8), worst 8 (was 15).
- `scripts/fight3d/PopCap.gd`, the head-jump cap, reworked: eases the spine in SKELETON space, leaves the trunk alone while
  the landing reach holds a glove (`PunchReach.held()`), frees a hit boxer for 0.25 s. `join_return_test` 0 failures at 60 fps.
- Film r2b (`E:/FightCamp/tmp/fightweek/r2b`, same bout): head jumps over 12 cm a frame 53 -> 39 (inside a clip 31 -> 18;
  on the contact frame still 12 = the HITTER's body carry, world space).

### NOT on main: `git apply ops/research/FIGHTWEEK2_WIP_S497.patch`
ArmHome.gd (the punching arm takes the clip's pose from further ahead after the contact, AHEAD 1.5) + a one-way hold in
PunchReach._apply + tests/arm_home_test.gd (8 PASS). What was found:
- WHY ARMS HANG OUT (both critics' "arms parked", ruler 6 frames median / 14 worst): after the hit, PunchReach holds the
  glove on her by DISTANCE of the clip's glove from the carry point (`RELEASE_M`). When the clip's glove has come back and
  goes on home it is "far" again, so the glove is pinned back on her face until the clip ends (the cross's weight reads
  1.0 -> 0.72 -> 0.95 in `join_return_test -- trace only=pro_right_cross`).
- The patch makes the hold one way (once the clip's glove is coming back inside the carry, the hold only falls over
  HOME_S). Film r2e: arm out 6 -> 5 frames median, 14 -> 13 worst. NOT enough, and `join_return` STEP pro_right_cross goes
  10.35 m/s (bar 9.0) at f26: the glove's release itself is too fast. Next: release along the clip's own path at a capped
  speed (about 6 m/s), then look at what still holds the worst cases (the hit-stop + CARRY_S + blocked punches).
- A lunge slew (the body's carry toward the target starting 0.30 s early, 2.5 m/s cap) changed nothing on the film
  (contact-frame jumps 12 -> 11): dropped. The contact-frame jump is somewhere else in the body node's move (FightStage
  `_compose`, `PunchRange.close_in`, HitImpact's seek to the contact): trace one jab's hit frame before changing anything.
- `hit_frame_test` (3 fails) and `hit_carry_test` (32 fails) are red on main WITHOUT any of this (control arms
  `-- noarmhome nolungeslew nopopcap noreactfrom`): not a regression of the week. `punch_speed_test` fails 45 the same way.

### What the critics rank first (read r0/critic_coach.md, critic_animator.md)
1. Bodies inside each other at close range (heads overlap 0.4 s, torsos merge) - ruler: "a head inside the other's body"
   15-17 frames (r0 9). Not touched yet. A head-clear lean (heads to opposite shoulders inside 28 cm) is the next build.
2. Landed punches with no visible answer (reaction sizes 5-50 cm, some 5-8 cm). Timing is fixed; size is not.
3. Arms parked (above). 4. Misses with no defence. 5. Nobody steps (foot lift 8-11 cm, steps are slides), 70 % waiting.
Film r1 + two NEW blind critics only when 1-3 have moved on the rulers.
Ruler: `python tools/fight_motion_rulers.py --compare E:/FightCamp/tmp/fightweek/r0/shown.csv <new>/shown.csv`.
Film (no movie, 3 min): `python ops/Tools/godot_slot.py run --who <S> -- python tools/hidden_desktop.py run --timeout=900
--log=<out>/godot.log <godot.exe> --path . --windowed --resolution 1280x720 --fixed-fps 30 --audio-driver Dummy
--script res://tools/human_fight_film.gd -- <out> secs=75 seed=7`. Every Godot job goes through `godot_slot.py run`.

## Seats
- Qwen CAMHOLD1 (the camera never cuts mid-punch): QUEUED in dispatch_queue (a render blocked the launch); the 30-min job starts it.
- Grok Dev PRESSFLASH1 (crowd flashes never beside a boxer; both critics read them as fake hit sparks): sent 10:44, branch grok/pressflash1.
- NOT collected (no budget left in S497): COACHNECK1 PR 329 (render the c07 close-up before/after, his OK before merge);
  FILMCOUNT1 on branch goose/issue-326 (take only FilmCount.gd, FilmBout.gd, FilmPattern.gd, tests/film_count_test.gd;
  FilmCount.gd is 578 lines: split it under 500 first); ONELOOK2 PR 327 belongs to the ONELOOK1 session.
- Arena, Dola, John, Maria, Ziva got nothing in S497: give Arena a pure module and Ziva the knee jitter (4 jerks a second
  per knee, the footwork IK against the clip) in the first 15 minutes.

## Other sessions (checked S497)
- "Build Training K v6c" finished: commit f416dfa56 is on main and pushed. It wired SHARED coach pad minutes (3 boxers =
  25 min each); his Q-242 answer was "No, never short" -> board Q-S294-260 asks him which stands. Act on his answer.
- "One consistent UI" (ONELOOK1): mid-work in E:/FightCamp/wt/LEAN_ONELOOK1 (107 files), waiting on a test re-run.
- "Own labelled fight clips" (video analyzer): running, data outside the repo.
- Nightly 11-16: 374 pass, 5 fail. The 05:00 review fixed approach card + film wording; `gauges_test` and
  `camp_cards_test` still expect old counts (update them); `block_meet` known.

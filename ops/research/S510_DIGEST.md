# S510 digest (2026-11-17) - supervisor session

## Animation
- Owner: move the animation to its own Fable 5.2 session at high effort and loop it to 7/10. Three Fable sessions ran
  (part 1 closed at 613k, part 2 at ~420k, part 3 running the baseline at the end). Blind scores: r12 5.0/5.0 (before),
  r13 4.5/4.5, r14 4.5/4.5 (punches 5). Details: ops/research/S510_ANIM_DIGEST.md.
- Diagnosis (owner: "animations looked fine when we bought them, everything got fucked after that"): the clips were never
  the proven cause; the fight animation system cuts single-boxer clips together, bends arms to reach the target and pushes
  heads with code, and the correction layers collide. The Undisputed / Boxing Manager / Blood & Canvas studies (S254,
  S381, S391, S425, S439, S501) already said the method is wrong (punches per distance, captured reactions, motion
  matching / inertial blending); the queue kept carrying "next defect" instead.
- Fixed in the workflow: CLAUDE.md item 8 "findings drive the queue" - a method verdict becomes a METHOD line + a scoped
  plan on the board the same session; no new correction layer in that area until it is built.
- Next: FIGHTPLAYER2 - baseline diagnosis (FIGHTPLAYER2_BASELINE_S510.md, part 3), full scope (FIGHTPLAYER2_SCOPE_S510.md,
  a helper), two fresh critics judge it, then build. Owner's standing approval: "i approve anything that will fix
  animations". Goal for S511: "i want animations fixed (at least 7/10) in the next session".

## Mechanics (FIGHTFILM1 and more)
- Film nights watched yourself, slices 1-5 here (FilmNight.gd, film_night_test), 6-9 in the side session (plan marks,
  own-bout analysis page with result tab + History, Tape Room retired, corner minute's round so far). Weak spot line on
  Training > MORNINGS. Ask for a fight waits on ASKPROBE4 (Qwen) + critic round 4; coached mornings on MORNINGSPROBE1.
- Live audit of unwired modules (rule/state modules no script references): 23, ~12 real mechanics.
- Qwen SPLIT500B collected (grapple trio + MatTreeInfo under 470 lines).

## PC
- C: filled twice: a hung test (parse error, camera null) wrote ~4 GB of log in seconds per rotation to
  %APPDATA%/Godot/app_userdata/FightCamp/logs (17 GB over 90 min). Fixed: FightStage stops its frame loop when the ring did
  not build; run_tests.sh and film_round.sh log to E:. Every Godot run takes --log-file E:/...
- Ops board: Map link in the top bar of every page (http://127.0.0.1:8787/map).

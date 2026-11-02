---
name: project-session-s132-2026-09-30
description: "S132 - bullets = late head stop shoving wrists for shoulders (fixed); one-frame leg kicks fixed; spar slide fixed; 5 rooms merged; ring -> 22 ft next (D28); devlog cartoons made, NOT posted"
metadata:
  node_type: memory
  type: project
  originSessionId: f8aaecb2-5663-4de6-8a8e-cc5264ba6ad0
  modified: 2026-09-30T08:51:52.486Z
---

S132 (2026-09-30, commits adde943e, 089f6dd4, 2a662c55, 114e69d8 + close):
- BUL1 DONE: 60/67 glove bullets came from the room's LAST head stop (`_correct_refused_head_contact`): it bent the WRIST to clear a SHOULDER/UPPER ARM from a head (parts above the chain) and a second branch pushed the other man's wrist INTO the head. Game bodies >15 m/s frames 42 -> 1, max 30.3 -> 19.7. Upper arm now turned at the shoulder.
- LEG1 DONE (found only by watching all 900 frames): U196 leg-cross shown <= 4 deg/frame; shuffle plants carried with late root corrections. SP1 DONE: no-walkout rooms (spars) spawned 0.9 m apart vs engine 2.0 m and slid at the bell.
- Rooms merged: U199 lobby, G148 office, C225 floor t1, Q218 staff, U200 lockers. K47 film spec + D66 review (5/10, "guided first fight") collected.
- OPERATOR RULINGS: ring 22 ft "make it 22ft on the next session" (D28, RING1 = S133 item 1; was 18 ft fl_min). A fighter turned away in guard: "i hope this fixed soon" -> OR1 (engine facing p90 69 deg off the foe). Harmony4D download question dismissed -> nothing downloaded.
- OPERATOR ANGER at the close: two focused test runs went SERIAL and a waiter keyed on "SUITE total=" sat 2 h ("wtf", "why you are not running parallel tests ... as we agreed"). Now CLAUDE.md s6: run_tests never serial (--jobs 4 idle / 2 busy), wait on the runner's EXIT, never a string. fight_strike_whole takes 657-664 s alone -> runner gives it 1200 s.
- Recording the game = record_room `demo=1 as_game` (demo=1 = switches, as_game = the game bodies).
- Devlog: D:/FightCamp/devlog (story, 143 angry moments, 3 cartoon episodes, UPLOAD_PLAN). NOTHING POSTED - he watches and approves. Run `python D:/FightCamp/devlog/tools/update_devlog.py` at every ship.
- Dola video = Seedance 2.5, 1 clip/day free, test blocked "for copyright protection ... audio". In flight at ship: Dola D65 (chat local_8520617112323646).
- JSON trap: roadmap.json/roster.json are indent=2, ensure_ascii=False; indent=1 re-indents 4000 lines.

**Why:** carry the mechanisms and the rulings - a late pass that bends a limb must only target parts its chain moves; world-space foot targets must move with later root corrections; the operator judges by what he watches.
**How to apply:** S133 opens with the 22 ft ring, then OR1. Related: [[feedback-bucket-defect-by-clip]], [[feedback-open-the-output-before-the-gate]], [[feedback-show-animation-as-video]].

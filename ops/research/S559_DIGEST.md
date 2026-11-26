# S559 digest (2026-11-25/26, Opus 5.5)

## His orders and words this session (quoted)
- Body-mapped switches: built as a toy (proto/twohands/body.html); then "the body look needs better view ... tubes or circles
  on the fighters are forbidden ... make a pointer outlining to the available options menu" -> MASK1 (lit limbs from the 3D).
- "this guard is wrong why he protects his ears ?" -> GUARDEAR1: the high rear glove beside the jaw (bar: 5 cm ahead of the
  ear line), 18 runs re-baked.
- "Yes, kickboxer first" (kickboxer v kickboxer, the boxer as a style inside the rules, then Muay Thai) -> kick.html, kicks on
  the feet switch, kick_test 12.
- Progression: "write it but i want this to be done properly ... see witch of them have been praised for progression,
  replayability" + "should we also add attributes progression and rpg elements ?" -> ops/research/DESIGN_PROGRESSION1.md
  (7 lessons from Slay the Spire, Monster Train, Griftlands, Hades, Cobalt Core + our fight-card study; 4 attributes on the
  board; probes P1-P4 before critics). His 3 questions in it are unanswered.
- "make the cells smaller like toggle buttons add a bit of art and toolitps" / "why the mi,long ranges are covering the fighter
  heads ? can you make the fight scene bigger ?" -> COMPACT1 + STAGE1 on both pages (1920x1080, no scroll).
- UFC desk with Cormier / Anik / Rogan: declined (real likeness + UFC brand need a licence, whatever the art style) - our own
  crew (Rita Vance, Hank Brody, Leo Marsh, Ludo art) faded behind the action; "make the commentators react to each beat" -> done.
- "make those ranges geometrically correct ... with visual effect" -> one bar between the front toes, true cm.
- "use console-code for multitasking" / "use more console workers in parallel": 10 console workers this session (CAMPICK1,
  KICKART1, RS3D1, STEPFIX1, MASK1, KICKTAKE1, RINGCAM1, RENDERFIT1, HEADART1, NIGHTREDS2). The Workflow tool was refused
  by the auto-mode classifier (his S541 rule: agents only in the console).
- Camera: "can you make a tool for me ... i will take a picture of the best angle" -> tools/camera_pick.cmd; "start the
  re-render with #16" -> his camera (raised 31 deg, from the side) on every picture (RINGCAM1 ring camera, RENDERFIT1 red slide,
  floor, ring from the same camera). "hdid nt the tool save all my saves ??" -> it kept every picture, only the last numbers;
  now every save appends to ops/previews/campick/saves.jsonl (#1-#6 numbers lost with a rotated log).
- Movement: the Boxing Movement Lab channel ("check all these animations i want you to match those") -> all 21 shorts in our
  words, ops/research/BML1_MOVEMENT_CATALOGUE.md; "can we make perfect animations clips ... for all possible combinations"
  -> yes, as ONE MAN PER LAYER clips with a guard joint, composed at play time (a few hundred per corner, not tens of thousands).
- Head movement: "do youthinkwe should add the head ? what about all other arts will it add up ?" then "Yes, measure it" ->
  head.html (slip, roll, lean back, slip in on the body-movement switch), head_test 11. Measuring at the handover.
- "add a jumpswitch ... "Puncher's chance"" -> brief TASK_PUNCHCHANCE1 (open only when behind, once a round, all-in power
  punch: double damage + a knockdown if it lands, wide open if not; comeback bar 15-30%).
- "you can use higgsfield for anything you need" (its image tool did not load this session: Ludo used).

## Measured
- Rune Coliseum's pull counter: 8 of 9, the jab lands 68% (was 76-81%). On the board as Q-S294-337, unanswered.
- Clinch: four fixes, all 7 of 9 (push off / clinch die). Not on the page.
- Kicks: first 4 of 9 (low kick 88%, head kick 92%: feint + head kick unblockable; 96% stoppages); fix A 4 of 9; fix B 6 of 9
  (head/body kicks die at Mid only). C 5 of 9 and D 4 of 9 ("standing your ground checks the low kick"): the low kick still lands 96% in C; D kills the head kick and the mirror (36%). B stays the best.

## Incidents
- KICKTAKE1's first commit swept in ~8,200 unrelated untracked files; my camera push carried it to GitHub. Repaired with a
  join commit (4f5533d3a) that takes 7,733 files back out of git - none tracked before (checked); history still holds them.
- Inline `//` comments appended to one-line code swallowed the rest of the line twice (ring_ui label position; head.html
  `D.hp -= dmg`) - always `/* */` for appended comments.
- tweak src patterns must not carry a trailing newline (the page stores CRLF).

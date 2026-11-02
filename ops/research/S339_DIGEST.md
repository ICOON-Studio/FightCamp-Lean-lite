# S339 DIGEST - update 41: the coach's plan in the fight, three new boxers, the body view stands relaxed

2026-11-01. Lean main eb60dcd..a99f5c0 (+ the export line at the bottom).

## Operator (verbatim)
- Board Q-S294-63 (Holly Price, Ellie Ward, Jade Cooper into the cast?): "Yes, all three".
- Review C155 on body_turn_lucy.gif: "loosen the hands , act like human not robot".

## CAST3 - Holly, Ellie, Jade (eb60dcd)
Faces.CM/CAST (168 / 171 / 165 cm from the MH4 configs), skin sidecars (mh4_audit's neck-band rule: #c98e64 / #a8704a /
#c98e64), body portraits + masks + turn strips baked, three Data.RIVALS (Lynn AC out-boxer 2-1, Earlsfield ABC southpaw
pressure fighter 4-2, Islington BC slugger 1-1). An older save gets a rival it lacks (SaveGame.from_dict). The region has 11
lightweights now (save_load_test counts updated).
- champs_test failed on night 12 once the pool grew: not a game bug - she won the semi, took a serious head knock, withdrew
  from the final the same week, so rounds[-1] was the final. The test now reads the round she boxed in.

## C155 - the body view stands relaxed (a8ec725)
bake_body_portraits.relax(): fingers bend toward "down" in the rest pose (the A-pose palms face the floor) - proximal 24,
intermediate 34, distal 22 deg, thumb 12/18 - then the upper arms hang 9 deg off her sides, a little in front, elbows 14 deg.
Bones set in skeleton space, so the body-map track strokes (read from the bones) follow. All 14 bodies rebaked (portraits,
masks, turn strips); body tests green. First try (curl about the knuckle line, palm guessed from the thumb) gave claws -
bending each joint toward one fixed direction in rest pose is what worked. Before/after GIF on the review board.

## PLANBOUT1 - the plan in the bout (a385ba2, a99f5c0) - Q-S294-61 step 4
- PlanFight.gd (pure): every exchange is fought on a StrikeMap card. She keeps the card her arrow took her to when she won;
  else the opponent's game decides (press/loadup -> mid, range/counter -> long, tiring -> inside, hurt -> opp_ropes;
  losing to a presser/big puncher -> own_ropes; her own trouble: she_tired -> inside, she_hurt -> own_ropes).
- A move's worth = how it answers the game (ANSWERS best/ok/wrong per situation, the calls' reading at move level:
  EDGE 9 / 3 / 0 / -7) x pad time (undrilled combination 0.8). The plan's edge = the arrow's worth MINUS the average worth of
  everything she can do on that card. No plan = edge 0 = the game exactly as balanced.
  - Decided by measurement: a flat edge (every fighter got the starter) broke exchanges_test ("no call beats a fighter 10
    points better") and habit_fix_test; an "instinct" baseline (first move she can do) made plans nearly worthless
    (+0.76 a exchange) because the first moves are already good answers; the card average reads right.
  - Control arm (plan_bout_test, Lucy vs Maria Ortega, 80 bouts): good plan 0.541 of exchanges (+2.70 a exchange), her own
    way 0.499 (0.00), bad plan 0.495 (-0.60).
- The bout copies her saved plan (f.arrows) at round 1; corner job "|arrow=<i>:<move>" changes ONE arrow on the bout's copy
  (PlanFight.corner_change: one arrow a place, the coach's limit kept on the bout, illegal = unchanged). Rounds carry the
  tally {used, worked, improvised, moves}.
- Screens: her page "Fight plan" opens StrikeBrowser.for_fighter (her punches, combination pad time = drilled, Luke Reid 6
  arrows / Marcus Hale 8, her plan or the starter; a new move from a card REPLACES that card's arrow; Save plan validates);
  the corner card (3D and words) has a PLAN row (worked x of y, per-arrow counts, one change from a drop-down,
  corner_options lists the cards she was fought on first); the words view says "Plan (Mid range): Step back - it worked.";
  the 3D captions "Plan: <move>" 1.6 s into the exchange; ExchangeBeats plays a planned combination as her punches and a
  planned step first (via the beat vocabulary -> BeatClips -> the same Punch PRO clips MoveClips lists; MoveClips stays the
  table for the Training page's pad work).
- Stills (opened): docs/playtest/S339/plan/03_plan_board_changed.png, S339/fight/p03b_plan_caption.png,
  S339/fight/p05_corner_card.png. fight3d_play now checks the plan caption and the PLAN row (failures=0, no script errors).
- Known gap (next): the 3D ring does not stage the card - the caption said "Pivot off the ropes" with both women mid-ring.

## Traps
- Every ring beat must carry RoundScript._beat's keys (FightView reads b["caption"]); a hand-made dict crashed _fire.
  fight3d_play printed failures=0 over three SCRIPT ERRORs - grep the log, not only the tool's own count.
- Bash heredocs with GDScript quoting broke once (unexpected EOF): write edit scripts to the scratchpad and run them.

## Delegation
None this session: the S338 rule gives Claude mechanics + UI; the animation seats' tasks (pad work, tie-up clips, card
staging) are briefed first thing next session.

## Export
tools/export.sh: 74/74 tests, update 41 built (Lean Builds/FightCamp.exe), Lean a99f5c0.

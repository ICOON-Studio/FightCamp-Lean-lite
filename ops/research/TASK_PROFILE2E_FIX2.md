# TASK PROFILE2E_FIX2 (S210) - review round 3 of cursor/profile2e (d8df872a)

Model: Cursor (local), same worktree E:/FightCamp/wt/PROFILE2E, branch cursor/profile2e. First `git merge origin/master`.
Claude opened every round-2 still in previews/profile2e/. Round 2 FIXED: injured != unhurt, pins + injury rows,
MetaHuman head in the face box, coloured body map, weight line agrees with the cut card. Fix what is left, re-shoot, push.
TASK_PROFILE2E.md and TASK_PROFILE2E_FIX.md still apply.

## Prior research
PROFILE2E_DIGEST.md (rounds 1-2), LUDO_ROUND43_VERDICT_S208.md (approved layout), S209_DIGEST.md.

## What would a human do?
A player opens one boxer and expects ONE person on every tab, numbers that agree with each other, and no empty boxes.

## Prefab check
None needed - fixes inside our own UI scripts.

## Defects (all seen in the round-2 stills)
1. TWO DIFFERENT MEN: BRUNO MOREAU's OVERVIEW portrait is a dark-skinned bald man; his MEDICAL face box is a light-skinned man with
   dark hair. One athlete = one MetaHuman everywhere. Both boxes must pick the body through the SAME call
   (`FightWorldStage.model_for_skin(...)` with the same athlete) - find why they differ (one probably passes a different key or a
   cached default) and route both through one helper. Test: profile_stage_test asserts overview and medical resolve the same
   model path for 3 different athletes.
2. FACE BOX FRAMING: the crown is cut off at the top and the head sits low. Portrait framing = top of the hair to the collarbone,
   head centred, ~8% headroom. Aim at the head bone's global position (+ ~4 cm up), not at a fixed height.
   The black stroke marks on the shoulder (both stills) are drawn on an unhurt man too - if they are the cut decals, draw them ONLY
   for real cuts and ON the face; if they are mesh/hair artefacts, hide that mesh in the portrait.
3. WEAR CONTRADICTION: header tab says "MEDICAL & BIO (WEAR 0%)" and "CAREER WEAR: 0%" while the overview body map shows
   TORSO 44% DEGRADED / RIGHT ARM 58% DEGRADED. Every wear number on the screen reads the same source; tab label and
   CAREER WEAR show the real value (or name what it is: career wear vs this week's regional fatigue - then label both honestly).
4. DIVISION LABEL: unhurt Niko Park reads "DIVISION -75 kg"; Bruno reads "DIVISION Flyweight". Always the division NAME
   (and the limit in kg after it if you want), from the same function for every athlete.
5. OVERVIEW EMPTY COLUMN: the right column is two empty panels. Fill from real reads (Ludo r43 layout): next bout / "no bout booked"
   + OPEN MATCHMAKER, and the last 3 weeks' form (training load, fatigue, composure trend) - or remove the column and widen the
   stats grid. No empty boxes.
6. PERFORMANCE & CAMP: (a) the 8 timeline squares and the "NO BOUT BOOKED" tag overflow the frame's right edge - fit them inside;
   (b) all seven days read REST for a boxer who trains in a gym - shoot the still on a boxer WITH a weekly program the game's own way
   (set it through the same API CHANGE PLAN uses), keep the honest all-REST view only as the empty state.
7. Re-shoot every still to docs/previews/profile2e/, run `profile_stage_test` + the profile tests named in TASK_PROFILE2E.md, add a
   "round 3" section to PROFILE2E_DIGEST.md, commit, push cursor/profile2e. Never master.

## Rules
Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`. Watchdog before every Godot run
(`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`, exit 1 = wait); windowed runs only through
`Tools\godot_hidden.ps1`; never open an image viewer/browser (file tool only). Tests `--jobs 1` unless the watchdog is GREEN.
Trap: the stills tool must build fixtures through the game's API - never write fake dictionary keys.

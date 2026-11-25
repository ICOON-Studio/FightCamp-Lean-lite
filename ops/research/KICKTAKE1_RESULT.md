# KICKTAKE1 - the first kick pictures: teep, low kick, check (S559)

Brief: `ops/research/TASK_KICKTAKE1.md`. Route: KICKART1 (`ops/research/KICKART1_SOURCES.md`) - the Mixamo kicks already in
Downloads, put on our MetaHuman by the game's own retarget (`scripts/fight3d/RkRetarget.gd`, reused, not changed), and the
check authored with the hold bake. Nothing under `scripts/` changed. MetaHuman bodies only (set m, south=blue, toon, the
fixed side camera, as every Ring Switches picture). `tools/pics2d_camera.json` did not appear during the renders.

## What was made
- `assets/anim/kicks/`: `teep_mixamo.fbx` (Mixamo "Male Thrust Kick With The Lead Foot"), `low_kick_mixamo.fbx` (Mixamo
  "Mma Low Kick"), `CREDITS.md` (Mixamo, Adobe's terms for games). The low-kick-to-idle transition was NOT kept: measured,
  the low kick take comes back to its own stance by itself (rear foot home by 1.30 s of 1.50 s), so it adds nothing.
- `assets/anim/baked/holds/hold_check.res`: the shin check, from a leg variant of `tools/pics2d_hold_bake.gd` (POSES
  "limb": "leg", the same two-bone solve on UpperLeg / LowerLeg / Foot; `only=check`). Lead ankle 0.30 m ahead of the hips,
  0.12 m out, 0.42 m under them; knee 0.69 m off the canvas, foot 0.34 m; the guard and the standing foot untouched (0.0000 m).
- `tools/pics2d_kick.gd` (new, 380 lines; extends the punch picture tools - a new file because pics2d_anim(_more).gd sit near
  the 500-line rule): 14 runs, `{red,blue}_{teep,low_kick}_{landed,blocked,missed}` and `{red,blue}_check`, 146 frames, in
  `proto/twohands/img/anim/` and its `frames.json` (merged by `anim_web.py`). `tools/kick_probe.gd`: the measurements below.
- `proto/twohands/tools/anim_check.mjs`: teep / low_kick x 3 results and check added to its required list.
- `proto/twohands/kick.html`: one comment line ("No kick pictures exist yet" -> which exist). Its ACT pic names (teep, low_kick)
  already matched the run names; no other change.

## What the takes are, measured on our body (tools/kick_probe.gd, body 02, raw from RkRetarget)
| take | lead | kicks | peak | standing foot | note |
|---|---|---|---|---|---|
| teep | left (orthodox) | left (lead) | ankle 1.11 m at 1.17 s, toes 0.76 m out at 1.27 s | slides 0.003 m, rises 0.000 | chamber 0.67-1.17 s, push 1.17-1.27 s, home by 1.60 s; lead hand posts out as it kicks |
| low kick | left | right (rear) | ankle 0.75 m at 0.47 s, furthest out 0.60 s | **skids 0.09 m during the swing**, rises 0.018 | a round kick, hips turned over; home by 1.30 s |
No turn or mirror was needed for an orthodox body (the take faces him within 7 deg); a southpaw (blue, mirrored for the camera)
gets the take mirrored, as the holds are.

## How the runs are built (in the tool's header too)
- THE STANDING FOOT IS PLANTED: from the kick's first frame the body is carried so the standing foot keeps its spot (the low
  kick's 9 cm skid is gone; R111 "our old kicks all fly" is read on every contact frame: rise 0.000-0.023 m, slide 0.000 m).
- THE CONTACT AND THE RANGE ARE FOUND from the take (the punch tools' rule), never a foot pushed into a body:
  - teep: the frame where the sole is still going out (within 0.12 m of full reach) and level with his belly; the kicker steps
    in to meet it. After the contact the foot drives him back (the page: a landed teep puts him one place further away).
    First try took full extension: the sole met his hip 0.17 m under the belly.
  - low kick: the smallest step in at which the striking part of the shin (65% down from the knee) reaches the middle of his
    lead thigh (25-85% down it), no other part of the shin inside his leg. First try touched with the ankle (shin share 1.0).
- Answers: teep landed = the gut-shot reaction one frame after the contact; caught = his lead forearm held low (hold_lead_low,
  the page's rule); missed = he pulls back (pro_back_dodge) and gives ground (0.28 m teep, 0.46 m low kick). Low kick landed =
  his guard, leg planted (no leg-hit take exists); checked = hold_check, timed to be up before the shin arrives.

## Gate numbers (contact frame; all 14 pass)
| run | red | blue |
|---|---|---|
| teep landed: sole to belly (bar 0.07) | 0.051 | 0.003 |
| teep caught: sole to his low forearm (bar 0.07) | 0.019 | 0.001 |
| teep missed: kick clear of him (bar 0.15) | 0.415 | 0.396 |
| low kick landed: shin to thigh, bone lines (bar 0.06-0.18); where on his thigh / on the shin | 0.070; 0.73 / 0.91 | 0.096; 0.67 / 0.86 |
| low kick checked: shin to shin (bar 0.05-0.17); his check foot up (bar 0.15) | 0.095; 0.364 | 0.112; 0.353 |
| low kick missed: kick clear of him (bar 0.15) | 0.220 | 0.209 |
| check held: check foot up (bar 0.15) / standing foot up (bar 0.03) | 0.345 / 0.002 | 0.356 / 0.006 |
Every contact frame: torsos 0.94-1.47 m apart, both men head to feet in the picture (`_frame`, framing gate), none refused.

## Rounds it took (each kept as a comment in the code)
1. Teep at full extension: sole on the hip, 0.17 m low -> fitted to the belly height while still going out.
2. Caught teep fitted to the forearm by its nearest point: a chambered frame, kicker 0.68 m in -> the same kick as the landed
   one, its range fitted to the forearm (blue needed the "within 0.12 m of full reach" bar too).
3. Low kick met with the ankle -> fitted on the shin's striking part.
4. The check never lifted in the checked run: the player's "block" kind keeps both feet on the canvas -> the check plays
   with its own legs (kind "punch").
5. The first check turned the shin out to his own side; with blue mirrored (open stance) the kick comes from the inside and
   passed 0.23 m from it -> the knee up and forward. Then it met knee to knee -> the knee higher (the kick's shin travels at
   ~0.68 m).
6. Low kick misses passed 0.13 m from his leg -> he gives 0.46 m, not 0.34.

## Tests
- RED first: `node proto/twohands/tools/anim_check.mjs` with the kicks added -> `ANIM_CHECK runs=138 ok=124 missing=14 ... FAIL`.
- After: `ANIM_CHECK runs=138 ok=138 missing=0 no_take=0 borrowed=12 PASS` (every earlier run still there).
- `node proto/twohands/tools/kick_test.mjs` -> `KICK_TEST 12 passed`; `node proto/twohands/tools/page_play_test.mjs` ->
  `PAGE_PLAY_TEST 4 passed` (after the page comment edit too).
- Played on the page (kick.html served by `proto/cardgame/serve.py 8797 twohands`, headless Edge, a beat set by script): my
  teep lands (blue_teep_landed frames 2-10 shown, "Moment 1: Your Teep lands, -1", the hit burst on his belly); my low kick
  checked ("checked: his shin was up", blue_low_kick_blocked, his knee up on the picture); his low kick lands
  (red_low_kick_landed). Screenshots opened.

## For his eye
- Board: http://127.0.0.1:8787/review, "First kicks: teep, low kick, check" (rating "not scored: your eye"):
  `ops/previews/s559_kicks/kicks_sheet.png` - each run before / contact / after, red left, blue right.
- One strip a run: `ops/previews/s559_kicks/<run>_strip.png` (git-ignored, as every preview).

## The owner's camera (STOP, as the brief says)
`tools/pics2d_camera.json` appeared at 01:11:42 (pitch 35.3, yaw 361.0, size 3.149, look_y 0.639), seven minutes AFTER the last
kick render ended (01:04:51). All 14 kick runs are on the OLD side camera, like every other picture on the page today. Not
re-rendered: the session decides. To redo them on his camera (`tools/pics2d_kick.gd` reads it through `pics2d_set`'s CamPick,
nothing to change; the contact search and every bar are 3D, not picture measures, so they hold at any angle):
`python ops/Tools/godot_slot.py run --who <you> -- python tools/hidden_desktop.py run --timeout=2400 --log=<log> <godot.exe> --path .
--windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_kick.gd -- <dir> art=toon set=m
south=blue only=red_teep,red_low_kick,red_check,blue_teep,blue_low_kick,blue_check` (about 5 minutes), then
`python proto/twohands/tools/anim_web.py <dir>` and `node proto/twohands/tools/anim_check.mjs`.

## Honest limits (next slice)
- The caught teep is STOPPED by the low forearm and glove, not wrapped: no take wraps a leg (KICKART1: the catch is authored
  as two holds on one contact point - not in this slice).
- A landed low kick shows no reaction: his guard holds and the leg stays planted. No leg-hit take exists (Muay Thai AnimSet Pro
  has graded leg hits if the Mixamo route needs them; nothing bought).
- No Mid (`_r2`) kick runs: the page names a kick run with no range (`runOf`), and a captured kick touches at one distance
  only, so the range is found from the take. If the page ever wants a kick drawn at each range, the take needs a shorter
  chamber at Mid (authored), not the same kick pushed into him.
- The check is held all beat on the page, but the page never shows the held check while he plans (`showHold` draws hands
  only); `{red,blue}_check` are on disk for that (a page change, outside this brief's "pic names only").
- Body kick and head kick: no runs yet (their page falls back to the still). KICKART1 slice 2.
- The FBX files have no Godot .import yet (no editor ran here); the next editor open imports them. The game does not load them.

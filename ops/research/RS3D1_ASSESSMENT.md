# RS3D1 - should Ring Switches use our 3D work, and how (S559, assessment only)

Task: `ops/research/TASK_RS3D1.md`. Owner S559: "do you think that we could/should use our 3D work we have done so far ?"
Nothing was changed: no code, no Godot run. Every claim names the file I read. GUESS = not measured.

## The short answer
**Yes - and it already does.** Every picture on the page is our own 3D (MetaHuman bodies, our takes, the v2 player's
timing), rendered once and saved. The best next use of the 3D is MORE of the same route, not a live 3D fight in the page:
1. re-render with his camera once he has saved it (Option A), and
2. render, beside each picture he hovers, a second "which limb is where" picture from the same 3D (Option B), so the page
   lights the real arm under his mouse - no tube, no circle.
Live 3D (Option C inside Godot, Option D in the browser) waits until the rules are settled: it would cost 6-10 sessions,
lose the balance tool's "one copy of the rules", and bring back the motion faults the picture gate filters out today.

## 1. What Ring Switches uses of the 3D today, and what it leaves unused
**Uses (all of it offline, through picture tools):**
- The game's MetaHuman bodies and the fight stage: `tools/pics2d_set.gd:15-18` loads `FightStage.gd` and the v2 player
  `Player2.gd`; the bodies are `assets/models/metahuman/mh_boxer_<n>.glb` (`pics2d_set.gd:107`, south=blue mirrors blue so
  both men show their chest).
- Our takes: jab, cross, both hooks, body hook, body cross, body jab, both uppercuts, steps, feint, push-off, clinch,
  knockdown (`docs/RINGANIM1_RESULT.md`, table "What now plays"); the four one-hand holds authored offline
  (`tools/pics2d_hold_bake.gd:1-6`, HOLDTAKES1).
- The v2 player's own timing: when a punch starts, when the hit man reacts, when a dodge starts, when the arm comes home
  (`docs/RINGANIM1_RESULT.md` "How a run is made": `ChoreoRules.react_peak_s`, `DEF_LEAD_S`, `arm_home_s`).
- The picture gate: a picture is written only if no body passes through a body and a blocked punch ends on the block
  (`tools/pics2d_set.gd:7-10`, `tools/pics2d_gate.gd`).
- Result on disk: 149 runs, 1,364 pictures in `proto/twohands/img/anim/frames.json` (counted today), 34 MB folder.
  The page plays a run picture by picture (`proto/twohands/order.html:167-182` `warm`, `runOf`, `playRun`).

**Leaves unused:**
- Motion between pictures: the page shows 11 pictures a run at fixed times (-0.42 s .. +0.30 s around the contact,
  RINGANIM1 result), not the 60 a second the 3D plays.
- Any camera but one: one fixed side camera per run (`pics2d_set.gd:459-460` `_aim`). CAMPICK1 lets him pick that one
  camera; it does not move during play (`ops/research/CAMPICK1_RESULT.md` point 3). He has not saved yet:
  `tools/pics2d_camera.json` does not exist today.
- Where each limb is: the 3D knows every bone, the page does not. `proto/twohands/body_ui.js:7, 15-21` guesses the gloves
  and boots by their COLOUR on each picture (blue pixels in the top half = the blue glove...). That is fragile: a glove in
  front of a blue trunk, or the shadow, moves the spot.
- Damage on faces, sweat, the crowd, the referee, the corner (`scripts/fight3d/` has them: `Referee.gd`, `CornerCrew.gd`,
  `TvShot.gd`...): none reach the page.
- The live choreographer (`scripts/fight3d/v2/Choreographer.gd:18` `plan`): the page never asks it anything; the timing
  was read once into the picture tool.

**Not in the 3D at all (so no route gives them for free):** kicks, the check, the catch (`proto/twohands/kick.html:117`:
"No kick pictures exist yet"; KICKART1 is finding the sources), a real overhand (it borrows the rear hook,
`order.html:131` `run: 'overhand'`), a one-man shove (the push is the mutual push-off), a clinch the 3D can play
(`scripts/fight3d/v2/Player2.gd:226`: "no owned take holds two men - they stay at range"; the page's clinch is a posed
picture), the women's pair (RINGANIM1 "NOT GREEN").

## 2. Option A - keep baked pictures, re-render from a better camera
- What it is: he saves his angle with `tools/camera_pick.cmd`; every picture tool built on `pics2d_set.gd` then takes it
  (`CAMPICK1_RESULT.md` point 3). Re-render, re-run the checks, the page is unchanged.
- Cost: **0.5 session.** Render time on a GREEN PC: 19 min for the 48 punch runs + 5 min for the rest (RINGANIM1
  "Reproduce"); the holds and steps add a few minutes (GUESS). Then `anim_check.mjs`, `anim_web.py`, a before/after strip.
- Risk: low. Two known traps: `_dodge` measures a miss with `SIZE / ORTHO_M`, wrong if he zooms (CAMPICK1 point 5, a
  one-line fix); a turned camera shows the men overlapping more, so the gate may refuse more pictures (GUESS - the gate
  will say). `ring_ui.js:4` measured its floor plates on today's pictures: re-measure them.
- Gain for the player: a nicer, more readable angle. Still one angle, still 11 pictures a run.

## 3. Option B - per-limb masks from the 3D beside each picture
- What it is: for each picture, render a second, invisible picture from the same camera where each body part is one flat
  colour (lead arm, rear arm, lead leg, rear leg, trunk, head - for each man). The page reads the mask under the mouse and
  lights THAT man's real arm (a glow or a tint on his own pixels), exactly the owner's "you highlight the arm i move my
  mouse on" with no tubes or circles. It replaces the colour guessing in `body_ui.js:15-21`.
- We have done this before for the body view: `tools/bake_body_masks.gd` (S324, the owner: "stop doing cube things as
  limbs") writes a part mask beside each portrait, one grey level per part. That one guessed parts from 2D strokes; this
  one can be exact, because the 3D knows which bone moves each vertex.
- Only the pictures he hovers need masks: the planning picture (the holds `both_*`, `lead_*`, `rear_*`, at three ranges,
  both corners - 13 run names a corner in `img/anim`, the end picture of each). Not the 1,364 action pictures.
- Cost: **1-1.5 sessions** - one for the mask pass in the picture tool (a flat material per part from the skin weights,
  same camera, same pose, a small 8-bit PNG), half for the page side (read the mask, tint the part, keep the hover and
  click of `body_ui.js`). Re-render: minutes (only the hold pictures).
- Risk: medium-low. MetaHuman skin weights blend at the shoulder and hip, so a part's edge must be set by "the bone with
  most weight" (GUESS: clean enough at 480 px). The mask must come from the SAME frame as the picture, or the light slides
  off the arm: render both in the one pass.
- Gain: the body-mapped switches idea works on the real body, never misses a glove, and works for kicks later (the legs
  are in the mask the day the kick pictures exist).

## 4. Option C - Ring Switches inside Godot, each beat played LIVE by the 3D player
- The rules: ~285 lines of JS above the `// ---- the page` mark (`order.html:286`; the kickboxing copy `kick.html:317`).
  `proto/twohands/tools/rules.mjs:14-17` reads them FROM the page, so the balance tool, the 36 rule tests and the bots can
  never drift from what he plays. A GDScript copy breaks that: two copies, kept equal by hand or by a cross-test.
- What the 3D player can take today: a 30-second exchange of settled beats (`FightView.gd:278` -> `Player2.queue`,
  `Player2.gd:191`; `scripts/rules/Exchanges.gd:11` `EX_SECONDS := 30.0`). The choreographer plans punches (lands /
  blocked / missed), reactions, defences, steps, feints, waits (`Choreographer.gd:18`; `Player2.gd:266` `_event`,
  `:329` `_wait`); `Player2.takes` handles slip, tired, step in / out and the clinch (as "stay at range")
  (`Player2.gd:210-228`). A Ring Switches beat is three moments, a few seconds: it would need a short-beat planner.
- Missing for Ring Switches: kicks, the check, the catch (no takes at all), the holds ON DEMAND (`GuardHold.gd:1-8` holds
  the free hand at the face during a punch; it does not hold "lead low, rear high" as a choice), the overhand, the
  one-man shove, a clinch of two men (`Player2.gd:226`).
- The biggest risk: quality. The pictures are each posed, measured and refused when wrong (`pics2d_set.gd:7-10`). Live,
  nothing refuses: the whole 3D fight scored 4.5 of 10 before v2 and v2 was built to fix that
  (`ops/research/FIGHTPLAYER2_SCOPE_S510.md` 1a); RINGANIM1 found blocked body hooks 6 cm off the arm even after
  re-posing. The owner would see live what the gate hides today.
- Cost: **6-10 sessions** (GUESS): rules module + tests 1, a cross-test JS v GDScript 1, the screen in Godot from the page
  2, a short-beat planner and the holds 2-3, then fix rounds on films (each animation area has taken several, METHOD
  FIGHTPLAYER2). Kicks come on top, once KICKART1's takes exist.
- Note: the game already shows baked fight pictures inside Godot (`scripts/ui/FightPictures.gd`, PICS2D2: "a second view
  of a settled round"). So the day Ring Switches becomes the game's fight, the cheap move is the RULES into GDScript and
  the SAME baked pictures into that view - live 3D is a separate, later step.

## 5. Option D - a Godot web export of a 3D view inside the page
- No web export exists: `export_presets.cfg` has only "Windows Desktop". The game renders with Forward+
  (`project.godot:31`); a browser build must use the Compatibility renderer (WebGL 2), so the toon look, the lights and
  the skin must be re-checked on it (GUESS: some of it will look different).
- Size: the bodies are 23 GLBs, 151 MB (`assets/models/metahuman`), the takes 46 MB (`assets/anim`). Two bodies plus the
  takes used plus the engine: GUESS 40-80 MB to download before the first beat, 10-30 s on a normal line - against
  today's page, which plays within a second and loads a beat's few pictures just before it starts (`order.html:167`).
- GPU: two MetaHumans with skin in WebGL on a low-end laptop: GUESS 20-40 frames a second, worse on a phone (he has played
  the page on his phone, S550).
- Cost: **4-6 sessions** (GUESS), plus all of Option C's live-motion work, because it plays the same live 3D.
- Risk: high - the size, the look change and the quality problem of C, all at once, in the one place (the page) that works.

## 6. What the player gains and loses
| | Gains | Loses |
|---|---|---|
| A (camera) | a better angle | nothing |
| B (masks) | his body-mapped switches on the real limb, exact hover, ready for legs | nothing |
| C (Godot live) | camera freedom, smooth motion, damage on faces, crowd, referee | the page's speed; the balance tool reading the one copy of the rules; playing in Chrome within minutes of a change; the gate that refuses bad pictures |
| D (web 3D) | the same as C, in the browser | a long load, weaker look, slow on low-end PCs and phones, plus everything C loses |

## The four options
| Option | What the player gets | Cost (sessions) | Risk |
|---|---|---|---|
| A - re-render from his camera | a better fixed angle | 0.5 | low |
| B - limb masks from the 3D | the real arm lights under the mouse | 1-1.5 | medium-low |
| C - Ring Switches in Godot, live 3D | moving camera, smooth motion, damage, crowd | 6-10 (GUESS) | high: two copies of the rules, live faults seen |
| D - Godot web 3D in the page | C's gains in the browser | 4-6 + C's motion work (GUESS) | high: size, look, low-end GPUs |

## Recommendation
**Do A and B together, in one render pass; keep the page as it is; leave live 3D (C, D) until the rules are settled and
he asks for a moving camera.** The page is where he plays and judges within minutes, and the balance tool reads it; the
3D already feeds it through the pictures, and the gate keeps those pictures right. B gives him the idea he asked for
today on the real body, and the masks are ready for the kicks the day KICKART1's takes are baked.

**First step:** a task MASK1 for a console worker - in the hold-picture run of the picture tools, render a second
picture per frame with one flat colour per limb (from the bone with most weight), same camera, same frame; write
`<run>_<n>_mask.png` beside each; then in `body_ui.js` replace `find()`'s colour guess with the mask and tint the part
under the mouse. When he saves his camera (`tools/pics2d_camera.json`), the same run re-renders everything with it (A).

## Seen while reading (not changed - assessment only)
- `proto/twohands/` has no `.gdignore`: Godot imports all ~1,300 page pictures (the `.webp.import` files beside them, and
  the modified `.import` files in git status). A `proto/.gdignore` would stop it; worth a one-line task.

# TASK GUARDSTANCE1 - the guard you set is a stance you can read at a glance (S566)

Kind: build (pictures + page). Model: claude-opus-5-5. Discipline: boxing (Puncher's chance).
Seat: console worker (render). Estimate: 3-5 hours. WAITS for the owner's purchase (below).

## His words (S566)
On the Animo "Boxing Additional" pack (renderhub.com/animo/animo-mocap-boxing-additional): "this is very good , it also has
a more clear mma guard i will buy this also tomorrow which gave me an idea: depending on which hand is selected to keep high
make the fighter hop on to a different stance that shows that (the holo preview should make the adjustement first and then
the player plays ) , does it make any sense ?"
The same day: "it is confusing to me if it matters which hand of the 2 is up , if it does when and how".

## What exists
The held hands are already drawn (HOLDTAKES1, S553): `blue_both_<high|low>_<high|low>`, `blue_lead_<h>`, `blue_rear_<h>`
runs, played by order.html `showHold()` the moment a hold changes. They are ONE guard with a glove moved up or down: the
four set-ups look nearly alike, which is why he had to ask.

## Decided (Claude)
- FOUR STANCES, one per set-up, each a real guard whose shape says what it stops (the page's COVER table):
  | lead | rear | stops | stance |
  |---|---|---|---|
  | high | high | jab and cross, hook and overhand | high guard: both gloves at the temples, elbows in |
  | low | high | body punches, hook and overhand | Philly shell: lead arm across the belly, rear glove at the cheek |
  | high | low | jab and cross, uppercuts | long guard: lead glove out and high, rear forearm across the ribs and chin line |
  | low | low | body punches, uppercuts | low crouch guard: both elbows tucked, gloves under the chin |
  The pack he is buying has `AA_Boxing_Philly_Shell_Guard`, `AA_Boxing_Basic_Guard` and 13 Philly shell defences; the other
  two stances come from our own takes or Cascadeur (TASK_CASC_MCP). WATCH each take's preview before using it.
- THE HOP: a change of set-up plays a short settle (the men shift into the stance, feet on their spots: the GLIDE rule,
  no jump over 8 px), then the bounce of THAT stance.
- THE PREVIEW (strip_ui.js `#ghost`): when the set-up changed since the last beat, the see-through copy first settles into
  the new stance, then plays the moves. The standing man keeps the stance he fought the last beat in until Fight; on
  Fight he hops into the new one first. (Today the standing man changes at once: that is what moves to the preview.)
- A punching hand: the stance is that of the OTHER hand's hold, as today (`lead_<h>` / `rear_<h>` runs).

## Do
1. The four stance takes measured on our rig (glove height, elbow gap, head line), one clip_db row each.
2. Render: hold + settle from each of the other three + bounce, at Long, Mid, Inside, masks on, south=blue, his camera.
3. Page: showHold() keeps last beat's stance while planning; strip_ui.js preview opens with the settle; go() plays the
   settle before the first moment. Version line. make_punch.py + make_wait.py.
4. Proof: beat_shot with `hold` shots - four stills (one per set-up) he can tell apart with no words; edge table.

## VISUAL GATE
Red first: the four hold stills today side by side (they look alike). Stills only from the page by beat_shot, his camera,
both men head to feet. Per still: gap, noses, wrists, feet. The owner closes it: he names each stance from its picture.

## Contract
- OWNS: tools/pics2d_anim.gd (the hold families), proto/twohands/order.html (showHold, go), proto/twohands/strip_ui.js,
  proto/twohands/img/anim (the new hold, settle and bounce runs), proto/twohands/version.js, docs/GUARDSTANCE1_RESULT.md
- RED_TEST: beat_shot stills of the four set-ups today
- REGRESSION: page_parse, page_play_test on the five pages, anim_check.mjs, the edge table
- VISUAL: yes

## Prior research
docs/KDPIC1_RESULT.md, ops/research/TASK_HOLDTAKES1.md, ops/research/MOCAP_PACKS_S439.md (S566 notes), memory S566 (basic
words; watch a pack's preview first).

## What would a human do?
A coach teaches four guards by name because a fighter must see at a glance which one the other man is in.

## Prefab check
The Animo Additional pack (his purchase, tomorrow) for the Philly shell; our clip_db for a high guard; Cascadeur for the rest.

## State after S567 (no purchase asked about: the owner says when it is bought)
- RED STILLS TAKEN (today's four set-ups, his camera, Mid): `ops/previews/s567_guardstance/order_<lead>_<rear>_plan.png`.
  They differ only by one glove a hand's height up or down: the red is confirmed.
- OUR OWN CANDIDATE TAKES, not yet watched or measured (watch each before using it): `assets/anim/baked/mc_Box1_M3_Block_Loop.res`
  and `mc_Punch_M3_Block_Loop.res` (+ `_Idle_To_Block` / `_Block_To_Idle` as the settle) for the high guard;
  `af_crouch_idle.res` for the low crouch. The Philly shell waits for the pack; the long guard has no take (Cascadeur).

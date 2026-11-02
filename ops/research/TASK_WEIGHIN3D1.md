# TASK WEIGHIN3D1 - ZIVA (after BODYREACT1) - the weigh-in as a short cutscene

Status: OPEN (S370, Claude). Seat: Ziva (3D scene + camera in the editor), props from Ludo/Tripo (operator S334: "we
already have tripo and ludo subs"), motion from our sources (Rokoko / ActionForge; agents animate - S338).
Discipline: boxing (the demo).

## Why
Operator S370: "who can make a weigh-in cutscene for matches that require it ? similar to how ufc does it, there are
shorts on youtube that a show a fighter getting on the scale". Today the weigh-in is a 2D modal (scripts/ui/modals/
WeighIn.gd: Step on the scale -> made weight or not). The moment deserves a picture: it is where the cut pays off.

## Reference first (memory: real footage frame by frame before building)
Index two or three public weigh-in shorts with the eyes tool (`eyes index <url>`, contact sheets) and write down the beats
and their seconds: walk up, step on, the number, the pose, the face-off. Our scene is generic - no promotion's name, logo,
music or set copied; the gym's and the event's own names on the banner.

## The job
1. NEW scripts/fight3d/WeighInScene.gd (+ scenes/WeighInScene.tscn if useful), under 500 lines: a small stage (riser,
   a backdrop with the event name), a digital scale with a number display, an official beside it; the boxer in her kit
   (Faces / BoxerBuild body, boots off, weigh-in clothes) walks on, steps up, the display counts up to her weight against
   the limit (MADE WEIGHT green / OVER red), she holds a pose; for a pro bout or a final, a 2 s face-off with the opponent.
   About 10-14 s, three camera shots (wide, the number, the pose/face-off), Skip always works.
2. Props: the scale and the backdrop from Ludo or Tripo (stored in the project, assets/props/weighin/); poses/steps from
   our clip sources - no new generator.
3. scripts/ui/modals/WeighIn.gd: "Step on the scale" plays the scene, then the modal shows the result as now. Amateur
   bouts: the short version (step on, number, step off ~5 s); pro bouts and finals: the full one.
4. tools/weighin_still.gd: renders the scene on the hidden desktop and prints WEIGHIN lines: both feet on the scale's top
   (inside its outline) while the number shows, the number equal to her weight, no body through the official or the
   backdrop. WEIGHIN_SUMMARY PASS/FAIL.

## Acceptance
WEIGHIN_SUMMARY PASS; weighin film judged by Argon (gemini_judge.py --kind clip) against the reference beats; golden_path
and save_load green; the operator watches it.

## Contract
OWNS: scripts/fight3d/WeighInScene.gd, scenes/WeighInScene.tscn, scripts/ui/modals/WeighIn.gd, assets/props/weighin/, tools/weighin_still.gd
RED_TEST: tools/weighin_still.gd -> WEIGHIN_SUMMARY
REGRESSION: golden_path_test, save_load_test
VISUAL: yes

# S337 DIGEST - update 39: NEXT STEP card, reasons on greyed buttons, boxing move map, ground push-out; a hair-card bug

2026-11-01, same session as S336 (operator: "Keep going here"). Lean main 4dd6738 exported 68/68 (tests 4 at a time).

## Operator (verbatim)
- Q-S294-62 on the board: "Yes, in that order" (wrestling: standing chains, one plan board, the wrestler's numbers).
- "do we and should we have something similar to this https://eel.is/GrappleMap/index.html for all moves ?" -> yes: the ground
  browser IS that data on our women; boxing has its map now (jump=strikemap); wrestling chains are data, a Standing tab next.
- Ground film: sent; the boxing map and NEXT STEP stills sent and on the review board.

## Shipped (Lean)
| Commit | What |
|---|---|
| 91c7548 | GROUND2A collected: Cursor's capsules + test, its whole-body search (median 0.9 cm, 95% 5.5 cm, slow - it orphaned Godot runs) replaced by a local push (each overlapping capsule pair pushes its own joints, half each, 10 passes, grips pinned, a body on the mat not pushed into it): overlap median 1.4 mm, 95% 7.8 mm, joints move 4 mm, 1.6 ms a frame. Timing test runs with contact off. |
| NextStep (Qwen) + fix | NextStep.road(): 5 steps, lit one, need line; 624 cross-checks against Roster.pro_ready. Fix: pro_ready reads f["w"] as a must-have key - a SCRIPT ERROR the agent's exit code hid. |
| 9b72247 | StrikeBrowser (jump=strikemap): cards as a map, arrows per move, moves out/in, greyed combos name the punch to learn, the walked route. strike_browser_test; tools/strike_still.gd. |
| e6afc97 | WRESTLE1 (Qwen): WrestleChains - 6 tie-ups, 30 answers, reaction -> technique; 27 find a GrappleMap clip. |
| 6010b3e | GREYWHY1 (Cursor): UI.button/button2 `why`; every greyed button's reason from its rule (39 reasonless before); tooltip 0.25 s. |
| PLAN1 (Qwen), NEXTSTEP2 (Cursor) | PlanBoard (sport-free plan rules: arrow limit 4-9 by coach, validate, pick, coverage, chains, one change, undrilled 0.8); the NEXT STEP card first on her page. |

## FACES3 paused - the hair-card bug (Game Tools/metahuman)
Holly Price (mh_boxer_21, Celeste/Jelena/Aera blend, Hair_L_Straight blonde) built in ~4 min of Unreal; her crown rendered as bare
skin. Found: (1) long grooms export 2 card groups and mh2_glb imported Group0 only -> now every group is imported and joined
(kept); (2) cards cover 100% of the crown geometrically, but grooms in the NEWER card format (ship <hair>_RooUVSeedCoverage.dds:
Hair_L_Straight, Hair_M_TwistedBraids = Samira/Megan, UpdoBraids = Priya, UpdoBuns = Chloe) show only 9-11% of their card faces
through the atlas's red channel that mh2_textures reads as coverage (older grooms: 43-50%). Green gave 94% solid ribbons; not
coverage either. Reverted to red with an OPEN note; S338 decodes the format. Not a mipmap / alpha-scissor issue (tested).
Configs for Holly/Ellie/Jade are in Tools/metahuman; nothing joined the game.

## Traps
- An agent's "PASS" with exit 0 can hide a SCRIPT ERROR line (NextStep): read the whole output.
- Sampling a card texture at card-face CORNERS reads the transparent strand edge; sample face centres.
- Another session (fight-stills, S334 thread) commits to Lean main too - check `git log` before branching.

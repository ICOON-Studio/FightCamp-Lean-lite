# TASK BODYCROSS1 - a rear straight to the body that lands on the ribs (S542)

Kind: build (an animation take + its pictures). Model: claude-fable-5-2. Discipline: boxing (demo path).
Seat: Claude Fable worker in a console tab. Estimate: 2-3 hours, most of it Godot queue time.

## Why
PICS2D2 (S540/S541, `ops/previews/s540_pics2d/NOTES.md` item 1): the four "body cross LANDED" pictures show the glove at
chest height, 0.17-0.29 m above the ribs. No take in the v2 clip table throws the rear straight to the body; PunchAim closes
at most 0.30 m; 8 cross takes were probed, the best (pro_right_cross_c) is still 0.18 m high. `tests/fight_pictures_test.gd`
is red on exactly these four pictures. The same gap shows in the 3D fight whenever a body cross lands.

## METHOD (quote in your first message)
FIGHTPLAYER2: v2 only. NO new correction layer in scripts/fight3d (CLAUDE.md item 8). The fix is a TAKE (an asset the
player plays), never a runtime reach, bend or aim patch. If you find the fix needs a layer, stop and write why.

## Do, in this order
1. `python ops/Tools/prior_research.py body cross straight level change` and read `research/topics/clips_sources.md`
   (Settled). Say in the result which study the take follows. Read `ops/previews/s540_pics2d/NOTES.md`.
2. What the punch is, with numbers BEFORE any take is touched (owner S537: "the power does not come from twisting the
   knee"; every animation follows a study + a reference clip, numbers beside ours): from our studies and one real reference
   clip of a rear straight to the body (name it), write the target: how far the hips drop, the knee bend, where the head
   goes, the glove's height at contact against the opponent's ribs, the hand's return. A table: reference / ours now / target.
3. Prefab first - measure every candidate already on disk, on the census body, glove height at contact v the ribs:
   `assets/anim/baked/` (there is an `mc_Box1_M3_Body_Shot.res` and a `boxing_body_hook.res`; check what they throw),
   `assets/anim/rokoko_combat/`, `assets/anim/af_retarget/`, `assets/anim/mixamo_walk/` and the Mixamo boxing FBXs. A table
   of all candidates with the measured gap. Licence per source (bought packs: no AI use; `reference_asset_ai_clauses`).
4. If one lands within 0.05 m of the ribs: add it to the v2 clip table as the body cross's take, through the same route
   every other take uses (ClipCensus numbers, FootTake, hit timing). If none does: author ONE take offline from the best
   cross (the level change baked into the take's own keys: hips, knees, spine, the arm's line), saved as a new baked take
   beside the others. Not a script that bends the body at run time.
5. Re-make the four body-cross pictures (`tools/pics2d*.gd` route) and make `tests/fight_pictures_test.gd` green.
6. BEFORE/AFTER FILM on the fixed side camera (owner S537: never a corner-framed film, never a claim from numbers): the body
   cross landing, old take v new take, same pair, same camera. Stills through `tools/still_framing.gd` `save_if_framed`.
   Open every still yourself. Put the films and stills on the review board:
   `python ops/Tools/review_add.py --stage S542 --rating "<none: owner's eye>" --title "Body cross: lands on the ribs" <files>`.

## Not allowed
No buying, no Higgsfield or other paid generation (money is the owner's call - write the ask in the result instead).
No change to how other punches play. No file over 500 lines. Nothing opens on the owner's monitors: headless Godot through
`python ops/Tools/godot_slot.py run --who BODYCROSS1 -- <command>`; windowed renders only through
`python tools/hidden_desktop.py run ...` inside the slot; images opened with the file tool only.
HIS GAME FIRST: run `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once` before each Godot
job; RED = wait; ArcheAge in the top list with memory AMBER = wait, do the reading and tables meanwhile.

## Prior research
`ops/previews/s540_pics2d/NOTES.md`; `research/CLIP_CRITICS_S439.md` (the 15 punch clips, three blind critics);
`research/topics/clips_sources.md`; `docs/MOTIONRULERS1_RESULT.md` (which rulers measure the v2 player); memory notes
"Animations from our research + clips (S537)" and "Before/after films: fixed side camera (S537)".

## What would a human do?
A boxer throwing the rear straight to the body changes level with the legs, keeps the back fairly straight, and punches
flat at the solar plexus or ribs with the head off the centre line; he does not lean down from the waist with straight
legs and he does not punch downward from standing height. An animator would start from the cross he already has and key
the level change into it, or shoot a new take; he would not add a rule that stretches the arm.

## Prefab check
Step 3 is the prefab check: every on-disk pack first, measured, with its licence, before anything is authored.

## Feedback loops
None in play: a take feeds only what the fight shows and the pictures; nothing reads it back into the bout's numbers. The
one thing to check: the new take must not be picked for any move but the body cross (print which moves resolve to it, once,
before the full picture run).

## VISUAL GATE
Red first: `tests/fight_pictures_test.gd` red on the four body-cross pictures on the shipped tree (it is). Green after. The
side-camera before/after film and the four pictures opened by you; the owner's eye closes it on the review board.

## Contract
OWNS: assets/anim/baked/, tools/pics2d*.gd, assets/ui/fight_pictures/, tests/fight_pictures_test.gd, scripts/fight3d/v2/ClipCensus.gd (the take's table entry only)
RED_TEST: tests/fight_pictures_test.gd
REGRESSION: tests/player2_test.gd, tests/golden_path_test.gd
VISUAL: the before/after side film and the four re-made pictures opened and on /review

## Result
`docs/BODYCROSS1_RESULT.md`: the numbers table, the candidates table, which route was taken and why, test lines
(`RESULT: tests/fight_pictures_test.gd -> <exact pass line>`), the files on /review. Commit ONLY your own paths with
`git commit -m "..." -- <paths>` (collect them with `git diff --name-only --no-renames`); do not push; do not ask questions:
decide, and write what you decided.

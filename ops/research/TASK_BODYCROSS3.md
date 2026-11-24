# TASK BODYCROSS3 - the body cross: a bent elbow you can SEE, and the hit man bends (S546)

Kind: build (an animation take, the hit man's reaction take, the twelve pictures, a film). Model: claude-fable-5-2.
Discipline: boxing (demo path). Seat: Claude Fable worker in a console tab. Estimate: 2-3 hours, most of it Godot queue.

## Why (the owner's mark on BODYCROSS2's own sheet, review comment C502, 2026-11-24)
On `bodycross2_after_every_picture_m.png` (the twelve pictures, every one captioned "AFTER elbow bent at the touch, the
arm finishes into him") he boxed picture 9 and wrote: "there is no elbow bent , the reaction should force the opponent
to bend hisposture a bit". His mark: `ops/Feedback/2026-11-24-03/marked.png` (open it first).
He is right, and BODYCROSS2's own numbers say why (`docs/BODYCROSS2_RESULT.md`):
1. THE BEND LASTS 0.04 s. The contact key has the elbow at 142.7 deg, and the arm is at 167.3 deg 0.04 s later, then
   stays near lock-out. The sheet shows one picture every ~0.075 s and the film runs 60 a second: nobody can see a bend
   that lives for two film frames. From picture 4 to picture 12 of the sheet the arm is a straight bar.
2. THE HIT MAN DOES NOT BEND. BODYCROSS2 measured a fold of 7-8 deg (0.076 m, neck over hips) while he slides back
   19-25 cm. On the sheet the red boxer stands upright in all twelve pictures: nothing bends.
3. The result's main table prints NaN in most cells (men and women, before and after). The verdict lines were read from
   somewhere else. A table of NaN is not evidence: find why and fix the ruler's printing first.

## METHOD (quote in your first message)
FIGHTPLAYER2: v2 only. NO new correction layer in scripts/fight3d (CLAUDE.md item 8). Both fixes live in the TAKES' own
keys, authored offline by the bake route, and in which captured reaction the hit man plays and from which key. Never a
runtime reach, bend, fold, aim or speed patch. If a fix needs a layer, stop and write why.
THE OWNER'S EYE IS THE RULER: every bar below is read on the pictures he sees (the sheet's own twelve pictures, the
side camera, the angle AS SEEN on screen), not on a key between them. Every number beside its study and reference clip
(owner S537). Before/after films: fixed side camera, never corner-framed, never a claim from numbers (owner S537).

## Do, in this order
1. `python ops/Tools/prior_research.py body cross elbow impact reaction fold`. Read `docs/BODYCROSS2_RESULT.md` whole,
   `ops/research/K52*` (elbow at impact: amateurs 137 +/- 12 deg, professionals 102 +/- 17), `K51_THE_HIT_RESPONSE.md`,
   `K48_HIT_BOXER_FEET.md`, `research/topics/hit_reactions.md` (Settled), `scripts/fight3d/v2/ChoreoRules.gd`
   (REACT_FOLD_*: "a body shot folds a man 30-50 cm over 5-6 pictures"). Say which study each bar follows.
2. FIX THE NaN TABLE: run `tools/bodycross2_ruler.gd`, find why the summary cells print NaN, fix the printing, and put
   the real before numbers in your result.
3. RED FIRST, on the shipped sheet: a ruler `tools/bodycross3_ruler.gd` that reads THE SHEET'S OWN TWELVE PICTURES
   (the same tool, pair, distance and camera that make them) and prints, per picture: the puncher's elbow angle as
   seen from the side camera (shoulder - elbow - wrist, projected on the screen), the glove to the hit man's trunk
   surface, the hit man's trunk fold as seen (hip - neck line against upright, degrees) and his hips' travel. Commit it
   reading RED on the shipped take. Bars:
   - BENT WHERE HE LOOKS: in the first picture where the glove is on his body, the elbow as seen is 150 deg or less
     (K52: amateurs 137 +/- 12), and in NO later picture of the sheet does it pass 160: the arm drives into him bent
     and never locks out. At least 3 of the twelve pictures show glove-on-body with the elbow 155 or less.
   - STILL A PUNCH: BODYCROSS2's speed bars hold (6 m/s or more at the contact, 70 % or more of the top, top 8 or more,
     first move to contact 0.23-0.36 s, the glove goes 0.04-0.10 m past where his surface was).
   - HE BENDS: the hit man's trunk folds 12 to 25 deg as seen ("a bit": more than the 7-8 nobody saw, less than a
     knockdown fold) inside 0.15 s of the contact, and at least 3 pictures of the sheet after the contact show the fold
     at 10 deg or more. He is not back upright sooner than 0.4 s after it. He still gives ground (hips back 0.05 m+).
4. THE PUNCH TAKE (`pro_body_cross`, offline, `tools/pics2d_bodycross_bake.gd`): the reason the arm locks out is range -
   the feet stay on their spots, so the glove needs the whole arm to reach him. Close the range inside the take, the way
   a boxer does: the captured stepping cross's legs (`_ft`, a real step, not a slide; K46 for how far) or a deeper
   weight shift, so the glove meets his body at about three quarters of the arm and the rest of the drive comes from
   the hips and shoulder turn the bought take already has (nothing twisted, knees over the toes, owner S537). The
   follow-through stays bent. Say in the result how far the lead foot travels and where it lands against his lead foot.
5. THE HIT MAN: BODYCROSS2 step 4 has the captured gut-shot candidates table. Pick by the fold as seen (measure each
   candidate with your ruler: fold deg at +0.05, +0.10, +0.15 s; hips back; time to upright) and the key it starts
   from, so the deepest part of the fold falls on the two pictures after the contact. If no captured take reaches 12
   deg, author the fold deeper OFFLINE in a copy of the best one's own keys (a new baked take, the fold's own curve
   scaled, spine joints only, the feet as captured) - a table of what you scaled and by how much. Never at run time.
   Check it is the take the v2 player plays when a body punch lands in the fight, not only in the picture tool.
6. THE SHEET AND THE FILM: re-make the twelve pictures so the hit man's reaction is IN them (he bends on the sheet).
   Before/after film on the fixed side camera, men and women, the same pair and distance as BODYCROSS2's film, real
   speed then one pass at quarter speed. Open the sheet and the contact stills yourself and check, by eye, the two
   things he wrote: a bent elbow, a bent man. Caption each picture with what it shows only if it is true of THAT
   picture. Review board: `python ops/Tools/review_add.py --stage S546 --rating "none: owner's eye" --title "Body
   cross 3: bent elbow, he bends" <files>`.
7. `tests/fight_pictures_test.gd`, `tests/player2_test.gd`, `tests/clip_db_test.gd` green (through the queue).

## Not allowed
No buying, no paid generation. No change to how other punches play. No file over 500 lines. Nothing opens on the
owner's monitors: headless Godot through `python ops/Tools/godot_slot.py run --who BODYCROSS3 -- <command>`; windowed
renders only through `python tools/hidden_desktop.py run ...` inside the slot; images with the file tool only. HIS GAME
FIRST: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once` before each Godot job; RED
= wait and do the reading meanwhile. Long runs print to a file; wait on the done line.

## Prior research
`docs/BODYCROSS2_RESULT.md`, `docs/BODYCROSS1_RESULT.md`, `ops/research/CROSS_POWER_S439.md`, `G75_STRIKE_SPEEDS.md`,
K52 and K54 (elbow at impact, first move to hit), K51 (the hit response), K48 (the hit boxer's feet), K46 (the
puncher's feet), `REFERENCE_PUNCH_TARGETS_S439.md` (body row), `research/topics/hit_reactions.md` and `striking.md`
(Settled), memory notes "Animations from our research + clips (S537)" and "Before/after films (S537)".

## What would a human do?
A coach on the body pad: "get your feet under you, step in, and punch THROUGH him with the arm still bent - you do not
reach for a body shot". An animator would move the puncher half a step closer inside the take so the contact pose can be
a bent arm, hold that bent drive for three or four pictures while the target gives, and cut the hit man to a gut-shot
reaction whose fold peaks two pictures after the touch: the fold is what tells the eye the punch hurt.

## Prefab check
The reaction: BODYCROSS2's candidates table (every captured hit take on disk) - measured again by fold as seen. The
punch: BODYCROSS1 measured 252 takes, none throws a straight right to the body; the step comes from the captured
stepping cross (`_ft`).

## Feedback loops
None: the two takes feed only what the fight shows and the twelve pictures; nothing reads them back into a bout's
numbers. Check once before the picture run: which moves resolve to the punch take (only `body_cross`) and which events
play the reaction (only a landed body punch). One-picture trial of the sheet before the full run.

## VISUAL GATE
Red first: `tools/bodycross3_ruler.gd` red on the shipped sheet (the elbow as seen in the on-body pictures, the hit
man's fold as seen). Green after on the same pair and camera. The sheet, the contact stills and the side film opened by
you; the owner's eye closes it on the review board. A green ruler closes nothing alone.

## Contract
OWNS: assets/anim/baked/, tools/pics2d*.gd, tools/bodycross2_ruler.gd, tools/bodycross3_ruler.gd, assets/ui/fight_pictures/, tests/fight_pictures_test.gd, assets/data/clip_db.json (the take's row and the reaction's row only), scripts/fight3d/v2/ClipCensus.gd (the two takes' table entries only)
RED_TEST: tools/bodycross3_ruler.gd
REGRESSION: tests/fight_pictures_test.gd, tests/player2_test.gd, tests/clip_db_test.gd
VISUAL: the twelve-picture sheet, the contact stills and the before/after side film opened and on /review

## Result
`docs/BODYCROSS3_RESULT.md`: the per-picture table before and after (elbow as seen, glove to body, his fold, his hips),
each bar beside its source, the reaction candidates by fold as seen, what changed in each take's keys, test lines
(`RESULT: tests/fight_pictures_test.gd -> <exact pass line>`), the files on /review, and what is still not right to
your own eye. Commit ONLY your own paths with `git commit -m "..." -- <paths>` (collect them with `git diff --name-only
--no-renames`); do not push; do not ask questions: decide, and write what you decided.

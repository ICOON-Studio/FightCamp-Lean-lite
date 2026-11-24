# TASK BODYCROSS2 - the body cross reaches him and hurts him (S545)

Kind: build (an animation take, the hit man's answer to it, a film). Model: claude-fable-5-2. Discipline: boxing (demo
path). Seat: Claude Fable worker in a console tab. Estimate: 2-3 hours, most of it Godot queue time.

## Why (the owner's eye on BODYCROSS1's film, review comment C500, at 27.8 s of `bodycross_before_after_m.mp4`)
"the punch in the stomach does not reach opponent and the motion reads more like he is trying to touch hime rather than
punch him and hurt him". BODYCROSS1 (`docs/BODYCROSS1_RESULT.md`) put the glove front 0.2 cm from a RIB POINT on the
census body and called it landed. Two things it never measured are what he sees:
1. REACH AS SEEN: the gap between the glove and the other man's BODY SURFACE on the film's own frames (not a point in
   the air), for the pair and distance the film shows.
2. A PUNCH, NOT A TOUCH: `ops/research/CROSS_POWER_S439.md` already found this on the head cross - the hit is marked on
   the frame where the glove is NEAREST, so by construction the glove arrives slowing down (23% of top speed at the
   hit; top 4.4-5.8 m/s on screen). Real gloves hit at 5.9-8.2 m/s against peaks of 6.6-12.5 and are fastest 8-21 ms
   before impact (G75_STRIKE_SPEEDS.md). BODYCROSS1 slowed the load 1.45x and did not look at speed at all. And in the
   film the hit man does not move: nothing shows he was hurt.

## METHOD (quote in your first message)
FIGHTPLAYER2: v2 only. NO new correction layer in scripts/fight3d (CLAUDE.md item 8). The fix is in the TAKE's own keys
and in which captured reaction the hit man plays; never a runtime reach, bend, aim or speed patch. If you find the fix
needs a layer, stop and write why. Every number sits beside its study and its reference clip (owner S537).

## Do, in this order
1. `python ops/Tools/prior_research.py body cross speed impact reaction` and read `CROSS_POWER_S439.md` whole,
   `G75_STRIKE_SPEEDS.md` (lines 20-23, 112, 179), `REFERENCE_PUNCH_TARGETS_S439.md` (body row, note 9),
   `docs/BODYCROSS1_RESULT.md`. Say in the result which study each target follows.
2. RED FIRST, on the shipped take: open the film at 27.8 s (find which half it is: old take or new) and measure, per
   frame from 6 frames before the contact to 10 after, on the film's own pair: (a) glove front to the nearest point of
   the hit man's torso SURFACE (mesh, not the rib point); (b) glove speed (m/s, on screen); (c) the hit man's chest
   and hip displacement. Write a ruler `tools/bodycross2_ruler.gd` that prints these and a verdict line, and commit it
   reading RED on the shipped take. Bars (each beside its source in the result):
   - reach: the glove front meets the torso surface and goes 0.04-0.10 m PAST where the surface was (the body gives);
   - speed AT the contact frame 6 m/s or more on screen, and 70% or more of the take's top speed; top speed 8 or more;
   - first move to contact 0.23-0.36 s (G75's readable floor to BODYCROSS1's own contact);
   - the hit man moves: his trunk folds or his hips go back 0.05 m or more within 0.15 s of the contact, and he is not
     back in his stance sooner than 0.4 s after it.
3. THE TAKE: re-author `pro_body_cross` offline (the bake tool route of BODYCROSS1, `tools/pics2d_bodycross_bake.gd`):
   the contact key moves EARLIER on the arm's travel, to where the glove meets the body with the elbow still bent
   (real: amateurs 137 +/- 12 deg at impact, professionals 102 +/- 17, K52; ours 168, near lock-out), so the arm's last
   extension happens INTO him; the hips and the rear shoulder turn into the punch on the drive (take the degrees from
   the bought head cross's own keys - do not invent a twist; the knees stay over the toes, owner S537); the rear heel
   comes up; the weight goes forward (hip centre forward travel beside the reference's). The load is not slowed more
   than a body falling needs. Feet as the take has them unless the reach bar needs a step: then use the captured
   stepping cross's legs (`_ft`), not a slide.
4. THE HIT MAN: find the captured body-shot reactions on disk (`assets/anim/baked/`, the PRO pack's hit takes; measure
   each: fold angle, hips back, time to recover) and name the one the v2 player plays when a body punch lands. If the
   pictures and the film play none, wire the existing reaction route so the film shows it; if no captured body
   reaction exists, say so with the candidates table (do not author a fake one this round).
5. BEFORE/AFTER FILM on the fixed side camera (owner S537: never corner-framed, never a claim from numbers), men and
   women, the SAME pair and distance as the film he commented on, real speed then one pass at quarter speed. Open the
   contact frames yourself as stills (framing check: both boxers head to toes). Review board:
   `python ops/Tools/review_add.py --stage S545 --rating "none: owner's eye" --title "Body cross: reaches and hurts" <files>`.
6. Re-make the twelve body-cross pictures with the new take; `tests/fight_pictures_test.gd` stays green.

## Not allowed
No buying, no paid generation (write the ask instead). No change to how other punches play. No file over 500 lines.
Nothing opens on the owner's monitors: headless Godot through `python ops/Tools/godot_slot.py run --who BODYCROSS2 --
<command>`; windowed renders only through `python tools/hidden_desktop.py run ...` inside the slot; images with the file
tool only. HIS GAME FIRST: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once` before
each Godot job; RED = wait and do the reading and tables meanwhile.

## Prior research
`ops/research/CROSS_POWER_S439.md` (why our cross reads soft: the hit on the nearest frame), `G75_STRIKE_SPEEDS.md`,
`K52` and `K54` (elbow at impact, first move to hit), `REFERENCE_PUNCH_TARGETS_S439.md`, `K46_BOXER_FEET_DURING_PUNCHES.md`,
`docs/BODYCROSS1_RESULT.md`, `research/topics/striking.md` and `clips_sources.md` (Settled), memory notes "Animations from
our research + clips (S537)" and "Before/after films: fixed side camera (S537)".

## What would a human do?
A boxing coach holding the body pad says "punch THROUGH the pad": the fist is still speeding up when it meets the body,
the elbow is bent at the touch and straightens into him, the rear hip and shoulder come round, and the man who takes
it folds and gives ground. An animator would move the contact key earlier on the arm's travel and let the last third
of the extension happen inside the target, then cut to the reaction.

## Prefab check
Step 4 is the prefab check for the reaction (every captured hit take on disk, measured). The punch itself: BODYCROSS1
measured 252 takes; nothing on disk throws a straight right to the body, so the take is re-authored from our own.

## Feedback loops
None in play: the take and the reaction feed only what the fight shows and the pictures; nothing reads them back into
the bout's numbers. Check once before the picture run: which moves resolve to the take (only `body_cross`) and which
events play the reaction (only a landed body punch).

## VISUAL GATE
Red first: `tools/bodycross2_ruler.gd` red on the shipped take (reach as seen, speed at contact, the hit man still).
Green after on the same pair and camera. The side-camera before/after film and the contact stills opened by you; the
owner's eye closes it on the review board. A green ruler closes nothing alone.

## Contract
OWNS: assets/anim/baked/, tools/pics2d*.gd, tools/bodycross2_ruler.gd, assets/ui/fight_pictures/, tests/fight_pictures_test.gd, assets/data/clip_db.json (the take's row and the reaction's row only), scripts/fight3d/v2/ClipCensus.gd (the take's table entry only)
RED_TEST: tools/bodycross2_ruler.gd
REGRESSION: tests/fight_pictures_test.gd, tests/player2_test.gd, tests/clip_db_test.gd
VISUAL: the before/after side film and the contact stills opened and on /review

## Result
`docs/BODYCROSS2_RESULT.md`: the ruler table before and after (each bar beside its source), the reaction candidates
table, what was changed in the take's keys, test lines (`RESULT: tests/fight_pictures_test.gd -> <exact pass line>`),
the files on /review, what is still not right to your own eye. Commit ONLY your own paths with
`git commit -m "..." -- <paths>` (collect them with `git diff --name-only --no-renames`); do not push; do not ask
questions: decide, and write what you decided.

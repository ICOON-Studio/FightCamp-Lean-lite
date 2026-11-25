# HOLDTAKES1 result (S553 built, S554 finished) - what the Ring Switches pictures show now

Page: `proto/twohands/switch.html` (and the generated `order.html`). Pictures: `proto/twohands/img/anim/`.
Sheets: `ops/previews/s554_ring/`. The owner's eye closes this; nothing below is called done by a bar alone.

## NOT GREEN (first)
- **The clinch when the OTHER man ties up** borrows the picture of the player tying up. With blue mirrored (both men chest
  to the camera) red's tie-up puts a head inside a head (0.08 to 0.11 m apart, bar 0.15) at every gap and depth offset
  tried (five settings). Blue's tie-up passes with the men set half a head apart in depth.
- **Two of the four missed hooks are still wide**: both REAR hooks pass 0.30 and 0.34 m from the face (a near miss is
  0.24 at most). Anything nearer puts the glove on the ducking man's own gloves, which reads as a block on the picture
  (seen on two tries, taken back). The two LEAD hooks are near misses (0.24 and 0.15 m).
- **The overhand has no take of its own**: it plays the rear hook's pictures (as since S552).
- **The push is one picture set for both corners**, and `blue_step_in` (a step in that ends on Long, which the page never
  asks for) borrows the step to Mid.
- **Women's pair**: not rendered (`set=w`), as since S552.
- **The hit burst** uses the glove's place the render recorded for each landed and blocked punch; for a knockdown it is
  worked out from the landed run (the knockdown pictures are twice as wide). Checked on the page for the cross only.
- The three new rule pieces (see "Rules" below) are played by bots and by me in the browser, NOT by the owner.

## What was wrong in the S553 render and what was done
| Found | Cause | Done |
|---|---|---|
| 35 of 82 hold / clinch runs failed their bars, so the page would have shown none of them | three first-guess bars | each looked at on the picture first, then: |
| lead hand high "0.080 to 0.094 m from the face" (bar 0.08) | the bar measured to a point ON the face; a glove guards from in front of it | bar reads how far the glove is ACROSS the punch's line (0.02 to 0.03 m now) and that it is 0 to 0.15 m in front; pose unchanged |
| rear hand low "0.107 to 0.114 m off the line under the chin" | a real fault: the glove's middle sat 8 cm past the centre line, the cuff under the chin | pose moved (wrist 7 cm to its own side, 2 cm back), re-baked: 0.056 m |
| "the other hand 0.056 m from its guard" on red | the bar compared with the guard LOOP caught at any phase; the take holds the guard's first picture | read against the take's own first picture, plus a control bar that can still see an arm left out (wrist within 0.34 m of the face) |
| the hit man took the punch, stood calmly 0.5 s, then fell | the knockdown take starts with a standing guard | the take is entered 0.42 s in: the head rocks at +0.2 s, he is going at +0.4 s, down at +0.9 s |
| `blue_body_hook_landed` head too near the body, `blue_lead_uppercut_blocked` feet 1 mm short | as S552 on red | the kidney-shot take for the hook; the uppercut passes rendered alone |

Result: 56 of 56 hold runs pass (4 one-hand and 4 both-hands holds, two corners, three ranges), 16 of 16 knockdowns from
a punch, `anim_check.mjs` 116 of 116 runs on disk (12 borrowed, listed by the check).

## His two notes on the S553 films
- **C508 "hook aims too high i think and too far away from the head"**: confirmed on the pictures - the other man stood
  ducked from the first frame and was given ground on top, so the hook swept 0.25 to 0.35 m over and in front of him.
  Now the tool searches for the shallowest duck (never under 64% of its depth: below that he is hardly ducking and
  the glove lands on his guard) and the least ground at which the glove clears his face AND stays off his gloves
  (wrists 0.21 m away). Your lead hook: no ground given, the duck at 80%, the glove 0.24 m from his face - it passes
  just over his head. His lead hook: half the ground, 0.15 m. Film: `ops/previews/s554_ring/before_after_quarter_speed.mp4`.
  `tools/pics2d_anim.gd` `_dodge_at`, `MISS_FIT` lines in the log; bars `MISS_NEAR_*` in `tools/pics2d_gate.gd`.
- **C509 "needs some visual effects when it lands showing the damage done beside sounds"**: a burst where the glove lands,
  as big as the damage; the number rises from the burst (bigger for a bigger punch); the hit man's health bar flashes;
  a blocked punch gets a pale ring on the glove that stopped it; the ring shakes on any punch of 4 or more.

## Rules (the seats' brainstorm, SQ326 Kalli and SQ328 John, read in S552, built in S554)
Measured on the page's own rules (`tools/rules.mjs` reads switch.html; `probe_rules.mjs`, `probe_jab_keep.mjs`):
- Before: a sensible player beat the Jabber 91%, the Slugger 77%, the Body Snatcher 80% (400 bouts each); he threw his own
  jab in 4 to 5% of beats.
- **A landed jab keeps him out** (he cannot step in on the next beat; the switch is greyed with the reason). A fixed
  jab-and-move player: Long held 60% -> 83% of beats against the Jabber, wins 42% -> 57%; against the Slugger 66% -> 42%
  and the Body Snatcher 12% -> 5% (they answer a landed jab by holding the lead hand high, block the next one and walk
  in). So the jab now DOES something every bout (about 7 beats kept out), but out-boxing is not a winning plan yet.
  `N.keep: 0` turns it off.
- **The ground behind each man is drawn** (two squares and the ropes at each end of the range strip).
- **His habit is marked**: a punch he threw in two of his last three punching beats is named on the hold that stops it.
  No number changed by this.
- NOT built: "blocking a habit punch makes the counter +2" (it would make the Jabber easier still).
- **THE FINDING: a body jab that reaches Long** (stopped by the lead hand LOW, so one hand cannot stop both jabs).
  `probe_body_jab.mjs`, 400 bouts, two seeds: the sensible player's wins against the Jabber 97% -> 60%, against the
  Slugger and the Body Snatcher unchanged (75 to 82%); he is kept out 8.7 beats a bout instead of 4.3. NOT on the page:
  there is no take for it. The head jab aimed at the body was tried (`body_jab` family, taken out again): the glove ends
  0.24 to 0.46 m off the body and the men stand 0.40 to 0.55 m apart (bar 0.60). It needs an authored take, as the body
  cross did (`tools/pics2d_bodycross_bake.gd` is the pattern). The page patch is ready: `ops/research/RINGSWITCH_BODYJAB_PATCH_S554.py`.
- `rules_test.mjs`: 17 tests of the rules, on the page's own code.

## How to rebuild the pictures
`E:/FightCamp/tmp/holdtakes1/chain3.sh` (punches, 20 minutes) and the commands in `full.sh` for the rest, always with
`south=blue`; then `python proto/twohands/tools/anim_web.py <dirs> --alias ...` (the alias list is in the S554 digest),
`anim_stills.py`, `node proto/twohands/tools/anim_check.mjs`.

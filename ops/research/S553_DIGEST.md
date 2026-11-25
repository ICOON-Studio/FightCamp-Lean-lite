# S553 digest (2026-11-25, Fable)

## What is now true
- **Ring Switches is the main line** (owner: "i think we should focus more on the RingSwitches"). Plan and coach probe
  rounds parked, nothing cut. Q-336: "Keep the two hire cards" (his note stops at "thecoaches should have").
- **STYLEPLACE1 checked against the code and its run files: the FAIL stands** (`STYLEPLACE1_CHECK_S553.md`): a plan line
  is 9 on a roll 66 wide; its table recomputed from the raw files equals the page.
- **Four one-hand guard holds authored** (lead high / low, rear high / low) and the four both-hands pairs, baked as takes
  (`tools/pics2d_hold_bake.gd` -> `assets/anim/baked/holds/`). Test pictures read on both corners.
- **The finding of the session:** the player's man was drawn from behind in all 59 pictures, so his rear arm was hidden
  whatever its pose. With `south=blue` both men show the camera their chest; the page mirrors, so he still looks orthodox.
  Owner, shown side view against a 30 degree raised view: "Yes, side view".
- **Built on his notes, waiting for pictures:** a knockdown that comes from the punch; standing pictures and steps at
  Long / Mid / Inside; the page shows the hand or hands held.
- **The guard bar never breaks**: 0 in 1,800 bouts, never under 4 of 6 (`GUARDBAR_S553.md`, `probe_guard_bar.js`).

## NOT GREEN
- The new pictures are NOT on the page: the render was still running at the handover. The page plays the S552 set.
- Nothing new was played in the browser. `anim_check.mjs`: 59 of 116.
- The more-set tool's new runs were parse-checked only. `blue_body_hook_landed` failed its gate.
- His C508 (missed hook too high and too far) and C509 (effects when a punch lands) are not done.
- Tripo / Ludo were not tried: a held pose needs no capture, and a generated take would still need retargeting.

## Delegated
Nothing: the work was pose authoring judged by eye with him in the chat, one windowed render at a time.

## Commits
3ae8c6b00 (STYLEPLACE1 check), 6262cd05c (red check first), cd8079656 (guard bar), 304b4d47f (holds, tools, page).

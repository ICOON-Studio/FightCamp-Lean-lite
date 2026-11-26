# TASK TELLS2PAGE - his one body tell on the page: a pose of HIS body, the word in the ring's corner badge (S564)

Kind: build (rules + picture tool + page). Model: claude-opus-5-5. Discipline: boxing (Ring Switches, order.html; punch.html
is rebuilt from it by make_punch.py). Seat: console worker. Estimate: 3-4 hours, ~40 min of GPU renders.
GATE - START ONLY WHEN ALL THREE HOLD: (1) TELLS3M (docs/TELLS3M_RESULT.md) passes its bars or the lead accepts its numbers
in writing; (2) the owner said yes on the board to the tells on the page; (3) GLIDE2 and BOUNCE1 have pushed (they own
ring_ui.js and frames.json until then) and `python ops/Tools/godot_slot.py status` shows no hidden_desktop job.

## Why
Owner S563: "do you thinkwe should show opponents itentions like more draditional card games or it is fine the way it is
?". Every playtester (Claude, Arena, Ziva, Dola; ops/research/allplay2/) chose ONE body tell before each beat, never his
whole plan. Version 3 (proto/twohands/tools/tells.mjs `tellOf(opp, plan, c, 3)`, play_cli.mjs `tells=3`) took the round-2
fixes: a fake only when his real beat hurts less than the cue promises, at most 2 fakes a round and never two running, a
second condition of his own state for the Slugger and the Body Snatcher, the rule named on the fake line, the legend says
a quiet guard does not cover his lead hand. METHOD (S563): on the page the tell is a POSE of his body plus the cue word
in the ring's corner badge - never text, ticks or markers on, under or beside the men (owner S562: "i told you do not put
text or anything near the fighters").

## Do
1. RULES (above `// ---- the page` in order.html, so rules.mjs and balance.mjs see them): `truthOf`, `LIES3`, `CAP3`,
   `tellOf(opp, plan, c)` as tells.mjs version 3, and the fake's cost (1 stamina to him after the beat). tells.mjs keeps
   versions 1 and 2 and, for version 3, calls the page's copy (one source). A test proves the page's tellOf and play_cli's
   tells=3 give the same cue on 500 random states.
2. PICTURES (`tools/pics2d_anim_more.gd`, a TELLS block, red only, south=blue, the owner's camera, masks on): one run per
   cue and range - `red_tell_shoulder`, `red_tell_knees`, `red_tell_backfoot` at Long, Mid, Inside (`_r2`, `_r1`) and
   `red_tell_foot` at Long and Mid (the front foot means nothing Inside). Each run goes from his hold into the cue pose in
   4-5 frames and holds it: the ANTICIPATION frame of the real move (shoulder = the cross's rear shoulder going back before
   the arm moves; knees = the body hook's level drop; back foot = the back off's weight shift before the step; front foot =
   the step in's lead foot creeping). The feet stay on his spot (edge table: > 8 px = a jump), the guard reads as a guard.
   A quiet guard is his hold (no new run).
3. PAGE: when `hisNext.plan` is ready, compute his tell from the beat state, play his tell run on red (blue keeps the
   player's hold and BOUNCE1's bob), and add ONE line to the corner badge: `His body: <the cue's 3-word name>` - nothing
   else near the men. The beat story after Fight: `His tell was true` or `A FAKE - he fakes <when>` (the rule's words).
   At the bell the round panel shows the ledger (tells.mjs `ledger`). The help panel gets the five cues and what each means
   (tells.mjs MEANS, LEGEND3). His stamina bar shows the fake's -1 in the panel, as every cost does (S562: -2 / +1).
4. Rebuild punch.html: `python proto/twohands/tools/make_punch.py`. kick.html and head.html stay as they are (one art first).

## Prove it
- beat_shot at Long, Mid, Inside with each cue (`node proto/twohands/tools/beat_shot.mjs <out> order.html '<beats json>'`):
  his pose changes, nothing is drawn near the men, the badge says the cue. Open every shot.
- The edge table for every tell run (hold last frame -> tell first frame -> tell last frame): no jump.
- Balance: the fake's stamina cost is a rule, so `node proto/twohands/tools/balance.mjs table` + `play n=84` before and
  after - the nine bars do not move (METHOD: the slice is balanced on the instrument).
- `docs/TELLS2PAGE_RESULT.md`; the shots on the review board (`python ops/Tools/review_add.py --stage S<n> ...`). End with
  `TELLS2PAGE DONE` or `TELLS2PAGE BLOCKED: <why>`.

## Renders
HIS GAME FIRST: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; if ArcheAge runs or
the PC is RED, wait. One windowed render at a time.

## Feedback loops
- Tell -> the player covers the named lines -> his punches land less -> nothing feeds back into how he lies (his AI does
  not know it is read). The cap is in the rule: at most 2 fakes a round, never two running (TELLS3M measures it).
- A fake costs him 1 stamina -> a tired Slugger meets his second condition (stamina 3 or less) -> he may fake again: the
  loop is capped by the same 2 a round. Trial: one bout in play_cli `tells=3` against the Slugger before the page build;
  count his fakes per round (never over 2).

## Not allowed
No change to the AI's choices (`ai()`), to any other rule, or to kick.html / head.html. Commit only your paths
(`git commit -m ... -- <files>`); push.

## Contract
- OWNS: proto/twohands/order.html, proto/twohands/punch.html (built), proto/twohands/ring_ui.js,
  proto/twohands/tools/tells.mjs, proto/twohands/tools/tells_page_test.mjs (new), tools/pics2d_anim_more.gd,
  proto/twohands/img/anim/frames.json, docs/TELLS2PAGE_RESULT.md
- RED_TEST: proto/twohands/tools/tells_page_test.mjs (red first: the page has no tellOf)
- REGRESSION: rules_test.mjs 37 passed, page_play_test.mjs 4 passed (order, punch), punch_chance_test 13, page_parse ok,
  probe_tells_test.mjs 5 passed, balance.mjs nine bars unchanged
- VISUAL: beat_shot screenshots and the strips, opened by the worker; the owner's play closes it

## VISUAL GATE
The owner's ring camera only (south=blue); nothing drawn on or near the men (memory feedback_nothing_near_fighters_s562);
a clip starts and ends where the men stand (memory project_s562_glide_distance).

## Prior research
ops/research/DESIGN_TELLS2.md; ops/research/allplay2/ (ALLPLAY2 and ALLPLAY2B reports: arena, ziva, claude, dola);
docs/TELLS2M_RESULT.md, docs/TELLS3M_RESULT.md; ops/research/RINGSWITCH_TELLS_BRIEF_JOHN.md (real boxing's tells: the
step in, the rear shoulder loading, the level drop); ops/research/RINGSWITCH_READ_BRIEF_KALLI.md.

## What would a human do?
A fighting-game animator gives each big move an anticipation pose the other player can learn to read, and keeps the HUD
off the fighters.

## Prefab check
Our own takes (the cross, body hook, step in, back off) give the anticipation frames; nothing to buy.

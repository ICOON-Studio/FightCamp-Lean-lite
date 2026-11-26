# TASK BODYUI2 - the body view becomes how you pick switches on the main page (S562)

Kind: build (page + mask pictures). Model: claude-opus-5-5. Discipline: boxing (Ring Switches, the main line).
Seat: console worker. Estimate: 3-4 hours, ~10 min of GPU renders.

## Why - the owner's answers on the ops board (S561, read them as his words)
- Q-343 "Body view (new stills on the review page): make it how you pick switches on the main page?" -> "Yes, replace the
  board".
- Q-338 "Body view: pointing at HIS limb shows what it did the last 3 beats. Right?" -> "Show what it can do".
- Q-339 "Body view: head opens slip, roll, lean back; torso the clinch; legs the steps?" -> "Yes".
- His standing rules for this view (S559, memory feedback_body_view_no_text_on_fighters_s559): "i do not want text near the
  fighters (tubes or circles on the fighters are forbidden) make a pointer outlining to the available options menu". Small
  buttons, details in tooltips, the page fits 1920x1080 with no scroll (S545 "use the fucking tooltip").

## What exists (read first)
- `proto/twohands/body.html` + `proto/twohands/body_ui.js` (BODYUI1 + MASK1, S559): body.html is an OLD copy of order.html
  (it lacks the S560 pull counter) plus body_ui.js: the limb under the mouse glows from a part mask, a dashed pointer runs
  to ONE fixed panel left of the ring holding that part's switches; click pins it. Read body_ui.js whole.
- `tools/pics2d_mask.gd`: the part mask pass (lead arm, rear arm, legs, torso per man; the head is inside "torso").
  `proto/twohands/tools/anim_web.py` snaps and copies masks. 54 runs have masks (`blue_|red_` guard + every hold, _r1/_r2).
- `proto/twohands/order.html` is THE page (boxing); `punch.html` is BUILT from it by `python proto/twohands/tools/make_punch.py
  ops/research/s558_balance/punch_chance_c.json` (never edit punch.html by hand). `head.html` has the head moves (slip,
  roll, lean back, slip in) on its feet switch. `kick.html` the kicks.
- `proto/twohands/ring_ui.js` is shared by every page and is being edited by the main session (S562 GLIDE1: punch runs per
  range, the range label, the Room-to-back-off bar). DO NOT EDIT IT; if you need a hook there, say so in your result.

## Do
1. ORDER.HTML GETS THE BODY VIEW. Bring body.html's view onto order.html below the `// ---- the page` mark and in its CSS /
   HTML (the side panel left of the ring, `<script src="body_ui.js">`, showHold using the masked guard run), keeping
   everything order.html has (pull counter, stamina label, feet order Back off - Hold - Step in, all S562 edits). The old
   board below the ring goes (his "replace the board"); the same buttons now live in the panel. Rules above the mark are
   NOT touched. Then rebuild punch.html with make_punch.py (fix its anchors if the page part moved; it asserts them).
   body.html becomes a 1-line redirect to order.html (links to it keep working).
2. HIS LIMBS SHOW WHAT THEY CAN DO (Q-338): pointing at his lead arm / rear arm lists the punches that hand can throw:
   name, whether it reaches at the range you stand at now, speed, damage, and which of YOUR held hands stops it (the page's
   own ACT / COVER / STOPS tables, never a copy). His legs: step in / back off / hold and what each does to the range.
   His torso: the clinch (Inside only). One line each, the rest in tooltips. Drop the "last three beats" view.
3. THE HEAD IS ITS OWN PART (Q-339): `tools/pics2d_mask.gd` gets a fifth part "head" (bones whose name holds head, neck, jaw,
   eye, face - check the MetaHuman bone names on the skeleton, print them with mask_debug), colours blue [0,128,255], red
   [255,0,128]; anim_web.py and body_ui.js PARTS learn them. Re-render the masks of the 54 masked runs (the guard and the
   holds, both corners, Long/Mid/Inside) with `tools/pics2d_anim_more.gd` (south=blue, the owner's camera
   tools/pics2d_camera.json is read by the tool itself), then anim_web.py them. Your head opens: on head.html its head moves
   (slip, roll, lean back, slip in); on order.html / punch.html (no head moves) the two "held high" switches (what keeps the
   head safe) with one tooltip line that the head moves live on head.html. His head: what lands on it at this range.
4. head.html gets the body view too (the same body_ui.js, its board into the side panel), so Q-339's head moves are picked on
   the head. kick.html only if time is left (legs = steps + kicks + the check).
5. The ops board: the Play box / top bar jump buttons (`ops/Tools/opsboard/roadmap.html`, the PAGES list) - "Body toy"
   goes (it IS the main page now); check the board with a headless Edge screenshot.

## Renders - read before any Godot run
- The main session is rendering (S562 GLIDE1) until `ops/previews/s562_glide/chain.out` prints `CHAIN_DONE` (render_all.out,
  then render_short.out, then render_more.out). Before your render, `python ops/Tools/godot_slot.py status` must show no
  hidden_desktop job running.
  Two windowed renders never run at once: do steps 1, 2 and the code of 3 first, render the masks only after that line.
- HIS GAME FIRST: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once` before the render;
  if ArcheAge is running or the PC is RED, wait. Godot only through `ops/Tools/godot_slot.py` + `tools/hidden_desktop.py`.

## Checks
- `node proto/twohands/tools/page_parse.mjs` all ok; `node proto/twohands/tools/page_play_test.mjs <page>` 4 passed for
  order.html, punch.html, head.html (and kick.html if touched); `node proto/twohands/tools/rules_test.mjs` 37 passed.
- Pictures: `proto/twohands/tools/mask_shots.mjs` (headless Edge) - hover each of the 10 parts at Long, Mid, Inside on
  order.html and the head on head.html; screenshots to `ops/previews/s562_bodyui2/`; OPEN them yourself: a lit arm is the
  arm, the head lights alone, nothing else lit, no circle or text on a man, nothing cut off at 1920x1080.
- `python ops/Tools/review_add.py --stage S562 --rating "not scored: your eye" --title "Body view on the main page" <pngs>`.
- `docs/BODYUI2_RESULT.md`: what changed, the screenshots, what is left. End with `BODYUI2 DONE` or `BODYUI2 BLOCKED: <why>`.

## Not allowed
No change to the rules above `// ---- the page` on any page, to ring_ui.js, or under scripts/. Commit only your paths
(`git commit -- <paths>`, other workers share this checkout; `--no-renames` if a path moved). Push when done.

## Contract
- OWNS: proto/twohands/order.html, proto/twohands/punch.html, proto/twohands/head.html, proto/twohands/kick.html, proto/twohands/body.html, proto/twohands/body_ui.js, proto/twohands/tools/make_punch.py, proto/twohands/tools/anim_web.py, tools/pics2d_mask.gd, ops/Tools/opsboard/roadmap.html, docs/BODYUI2_RESULT.md
- RED_TEST: none (a new view); the check is the 10-part hover at three ranges
- REGRESSION: page_play_test.mjs 4 passed on order.html, punch.html, head.html; rules_test.mjs 37 passed; page_parse.mjs ok
- VISUAL: the mask_shots screenshots, opened by the worker, then the owner's play

## VISUAL GATE
Game-camera pictures only (the owner's ring camera, south=blue); a lit part is checked on the picture at each range, never
from numbers; the owner closes it by playing the page.

## Feedback loops
None: a view over the same rules; no number changes.

## Prior research
ops/research/TASK_MASK1.md; ops/research/RS3D1_ASSESSMENT.md (Option B); memory feedback_body_view_no_text_on_fighters_s559,
reference_s559_mask_traps (flat vertex colours, follow img src, workers sweep files), feedback_jump_button_on_ops_board_s561.

## What would a human do?
A UI designer makes the fighter the menu: hover a limb, it lights, its options open in one fixed place beside the ring;
hover the opponent's limb, you see his threats from it.

## Prefab check
Our own mask pass and page; no library needed.

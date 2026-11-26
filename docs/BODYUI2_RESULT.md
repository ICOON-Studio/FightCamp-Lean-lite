# BODYUI2 result (S562) - the body view is how you pick switches

Task: ops/research/TASK_BODYUI2.md. Owner: Q-343 "Yes, replace the board"; Q-338 "Show what it can do"; Q-339 "Yes".

## What changed (commit e8a09fb)
- **order.html is the body view.** The board below the ring is gone. A panel left of the ring holds the page's own switch
  buttons (same buttons, same rules; body_ui.js only picks which show). Point at a limb of your man: it glows, a dashed
  pointer runs to the panel, the panel shows that limb's switches. Click keeps it open. With nothing pointed at, the panel
  lists what each part is set to (click a row to open it; hovering a row lights the limb). During a beat it shows the
  switches you set, lit as they act. Setup (pick your man) and the end of the bout use the panel as before.
  Rules above `// ---- the page` are untouched; the pull counter, stamina label and feet order are kept.
- **His limbs show what they can do (Q-338).** His lead / rear arm: each punch of that hand, damage and speed, whether it
  reaches at the range you stand at, which of your held hands stops it, and "stopped / open / short" as you have it set
  now (the full text in the tooltip). His legs: step in / hold / back off and the range each leaves. His body: the clinch
  (Inside only) and, on punch.html, whether his Puncher's chance is open. His head: your head punches, whether they land
  at this range and which of his hands stops each. The "last three beats" view is dropped (his card still shows them).
- **The head is its own part (Q-339)**: `tools/pics2d_mask.gd` HEAD bones (head, neck, jaw, eye, face, facial, teeth,
  tongue, nose, brow; checked before arm/leg - "ear" left out because "forearm" holds it), colours blue [0,128,255], red
  [255,0,128]; anim_web.py and body_ui.js know them; mask_debug prints every bone and its part. Your head on head.html
  opens the head moves (slip, roll, lean back, slip in + hold); on order/punch/kick it opens the two "held high" switches
  with a tooltip line that the head moves are on head.html.
- head.html and kick.html got the same view (kick.html: the legs open the steps, the kicks and the check).
  punch.html rebuilt by make_punch.py (no anchor moved). body.html is now a redirect to order.html.
- Ops board: "Body view" jump button removed; Boxing / Head movement say how to use the view.
- `proto/twohands/tools/mask_shots.mjs` (the check tool) reads the ten parts from the page, takes a url, a part filter
  and a picture-name prefix (outside OWNS: needed for the check).

## Checks
- page_play_test 4 passed on order.html, punch.html, head.html, kick.html; rules_test 37; head_test 11; kick_test 12;
  page_parse ok; node --check body_ui.js ok.
- Headless Edge, order.html, Long / Mid / Inside, eight parts with the current masks: `ops/previews/s562_bodyui2/pre/`
  (26 pictures + mask_report.txt), opened: the lit part is the part, the panel shows its switches or his threats, no
  scroll at 1920x1080 (page height 1080 of 1080), nothing written on a man.
- Ops board screenshot: `ops/previews/s562_bodyui2/opsboard_jumps.png` (Puncher's chance, Boxing, Head movement, Kickboxing).

## What is left - BLOCKED on the mask render
The masks with the head part are not rendered yet: ArcheAge was running the whole time (CPU 92%), and a script that
waited for it to close and then rendered was refused by the permission check. Until the render, the head is still
inside "torso" on the pictures (pointing at the head opens Body); everything else works.
To finish (about 10 min of GPU), with ArcheAge closed and `pc_watchdog.ps1 -Once` green:

    sh ops/previews/s562_bodyui2/render_masks.sh      # 54 runs, south=blue, mask_debug; then anim_web.py copies them

(the same command: pics2d_anim_more.gd -- <out> art=toon set=m south=blue mask_debug only=blue_guard,red_guard,
blue_lead_high,blue_lead_low,blue_rear_high,blue_rear_low,blue_both_,red_lead_high,red_lead_low,red_rear_high,
red_rear_low,red_both_ through godot_slot.py + hidden_desktop.py). Then check the PICS2D_MASK_BONE "-> head" lines,
run `node proto/twohands/tools/mask_shots.mjs ops/previews/s562_bodyui2` (10 parts x 3 ranges) and
`node proto/twohands/tools/mask_shots.mjs ops/previews/s562_bodyui2 http://127.0.0.1:8797/head.html you:head,him:head head_`,
open the head pictures (the head lights alone), and commit proto/twohands/img/anim/*_mask.png + frames.json.

BODYUI2 BLOCKED: the head masks need a Godot render that could not run (ArcheAge open; the waiting render was refused)

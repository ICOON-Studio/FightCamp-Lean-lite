# TASK KDPIC1 - the knockdown stays inside the ring; the overhand gets its own picture (S564)

Kind: build (picture tool + one take). Model: claude-opus-5-5. Discipline: boxing (Ring Switches, order.html / punch.html).
Seat: console worker. Estimate: 2-4 hours, ~30 min of GPU renders. START ONLY after INSIDE1 and GLIDE2 have pushed (they own
the picture tools and frames.json until then), with his game closed and `python ops/Tools/godot_slot.py status` showing no
hidden_desktop job.

## Why
S563 digest "Not done": "The knockdown picture pushes the man off the ring's left edge; the overhand is drawn with the hook
picture". Roadmap row KDPIC1. The page asks for `<col>_overhand_landed|blocked|missed` (order.html ACT.over `run:
'overhand'`) and, finding none, plays the rear hook (`pic: 'rear_hook'`). `tools/pics2d_anim_more.gd` line 13: "NOT here
because no take exists: an overhand". clip_db (assets/data/clip_db.json, 186 takes, checked S564): every rear-hook take is
a hook (pro_right_hook, _hard, _miss, mc_rear_hook); pro_right_hook_special is dropped (his back to the other man).

## Do
1. THE KNOCKDOWN INSIDE THE RING: `_punch_ko_run` (pics2d_anim_more.gd) plays KO_CLIP from the landed run's contact; the
   fall travels past the ring's left edge in the owner's camera. Keep the man inside the ring picture for every landed
   family x range the page plays a knockdown from: limit the take's root travel to the room between his spot and the ropes
   (a fall that goes back to the ropes is real; one that leaves the ring is not), or turn the fall's direction toward the
   ring's middle. Your call; write why. Proof: in every knockdown run no pixel of the falling man is outside the ring's
   floor/rope area of the picture (a pixel test on the masks), and the edge table (landed last frame -> knockdown first
   frame) shows no jump > 8 px.
2. THE OVERHAND TAKE: our files first - search E:\FightCamp (assets/anim, the old repo's archives under E:\FightCamp, the
   af_retarget sources) for an overhand / looping right. If none: Ludo (skill `ludo`; the owner S552: "you can try tripo or
   ludo for animations if it speeds up things"; Ludo is paid until ~2026-12-11 and has had no asset work this week) - ONE
   time-boxed hour: an overhand right from an orthodox boxing guard (the rear hand loops OVER the opponent's lead, the rear
   shoulder rolls, the head moves off the centre line, the weight lands on the lead foot), retargeted to our rig the way
   assets/anim/af_retarget/box1_m3_right_cross_af.glb was. Measure it like every take (clip_db row: contact, glove height,
   head travel, the flags) and add ONE row to clip_db.json (never rebuild it whole, memory reference_s556_tool_traps). If
   neither works in the hour: stop and write BLOCKED with what you tried - do not fake it with the rear hook.
3. THE OVERHAND RUNS: a family `overhand` in tools/pics2d_anim.gd (rear hand, side line): landed, blocked (rear hand high
   covers it, as the page's COVER says), missed, at Mid (`_r2`) and Inside (`_r1`) - the page's reach [1, 2] - and the
   `_short` miss at Long; masks on; south=blue; the owner's camera. Then the knockdown from it (step 1's rule).
4. The page needs no change (it already asks for `overhand`); check it plays them: beat_shot at Mid and Inside, an
   overhand landed, blocked, missed and a knockdown from it. Remove pics2d_head.gd's borrowing note only if you also
   re-render the head-move overhand runs from the new take (optional; say which).

## Renders
HIS GAME FIRST: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; if ArcheAge runs or
the PC is RED, wait. One windowed render at a time.

## Feedback loops
None: pictures of the same rules.

## Not allowed
No rule change, nothing under scripts/, no page edit beyond frames.json. Commit only your paths (`git commit -m ... --
<files>`); push. Pictures nobody committed sit in proto/twohands/img/anim from earlier sessions: commit only the files your
runs wrote.

## Contract
- OWNS: tools/pics2d_anim.gd, tools/pics2d_anim_more.gd, proto/twohands/img/anim/frames.json, the new overhand and
  knockdown picture files, assets/data/clip_db.json (one row), the new take under assets/anim/, docs/KDPIC1_RESULT.md
- RED_TEST: on today's page a beat_shot of an overhand landed shows the rear hook run; a knockdown run has pixels of the
  falling man outside the ring
- REGRESSION: page_play_test.mjs 4 passed (order, punch), page_parse ok, anim edge table green for the runs touched
- VISUAL: the strips and beat_shot screenshots, opened by the worker; the owner's play closes it

## VISUAL GATE
The owner's ring camera only (south=blue); nothing drawn on or near the men; a clip starts and ends where the men stand
(edge table, > 8 px = a jump).

## Prior research
ops/research/S563_DIGEST.md (Not done), docs/HOLDTAKES1_RESULT.md (the knockdown pictures are twice as wide),
ops/research/topics (real overhand mechanics if present: `python ops/Tools/prior_research.py overhand`), memory
feedback_tripo_ludo_for_animations_s552, reference_ludo_griffin_ignis_s555.

## What would a human do?
An animator keeps the fall on the canvas the camera sees, and gives a different punch its own motion instead of reusing
another.

## Prefab check
Our takes and the old archives first; Ludo generation only for the gap (time-boxed).

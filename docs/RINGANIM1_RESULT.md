# RINGANIM1 - Ring Switches: every action seen, frame by frame (S552)

Task: `ops/research/TASK_RINGANIM1.md`. The owner (S551): "we need to work on the visuals of the fight so the player can
understand the actions by seeing every card being executed by the fighters , 2d animations".

## NOT GREEN
- **The check is red: 59 of 64 runs are in the page** (`node proto/twohands/tools/anim_check.mjs`).
- **A held guard is not seen (4 runs rendered, none shipped).** `hold_high` (pro_idle_to_block > pro_block_loop) lifts the
  lead glove OVER the head; `hold_low` (mc_to_block > mc_block) does the same and never brings the elbows to the ribs.
  Both read wrong for "blocks his jab" / "blocks his body punches". Reported with their strip, not patched
  (`ringanim_holds_read_wrong.png`).
- **No take holds ONE hand** (lead high / lead low / rear high / rear low, 8 names): our library moves both hands. The
  page's real guard question ("which hand, held where") has no picture yet.
- **No overhand take.** The page's Overhand plays the rear hook's frames under its own name (6 runs, "BORROWED" in the
  check). Nothing else in the toy uses the rear hook, so the player never sees the same take under two names.
- **Red's blocked body hook keeps its still.** Played live, the glove ends 6.1 cm from the forearm (bar 5 cm); stepping
  him in crosses the feet; the other body take (pro_kidney_shot) is far worse. One run of 48.
- **The push is the game's mutual push-off** (both men, hands on the chest, out to range: `PushOff`). The toy's push is
  one man shoving. One run serves both corners ("BORROWED").
- **Inside punches start close.** A hook or an uppercut is thrown from 0.6-0.8 m: in the frames before the punch the two
  guards overlap on the picture (gloves over gloves, feet side by side). The contact frame passes the gate; the frames
  before it are not measured. For the owner's eye.
- **The men's pair only.** The women's set is not rendered.
- **Not judged by anyone but me.** The owner closes it on the films and by playing the page.
- The contact frame is gated; the other ten frames of a run are checked for framing only (both men head to feet).

## What now plays
Both pages (`proto/twohands/switch.html`, `order.html`) play each action of a beat as a run of pictures at the times
they were recorded, hold the contact picture 0.25 s with the flash and the sound, slow the last three pictures of a
4-health punch, load a beat's pictures before it starts, and fall back to the old still when a run is missing.

| Action in the toy | Runs | Take (from our own 3D fight) |
|---|---|---|
| Jab, Cross, Lead hook, Body hook, Body cross, Lead uppercut, Rear uppercut | lands / blocked / missed, both corners: 41 of 42 | pro_left_jab, pro_right_cross, pro_left_hook_ft, pro_body_shot (pro_kidney_shot where the gate asked), pro_body_cross, pro_left_uppercut, pro_right_uppercut |
| Overhand | 6, borrowed | pro_right_hook_ft |
| Step in, Back off | 4 | st_in_m, st_out_m (the refitted step takes; the body carried by the take's own hip travel) |
| Feint | 2 | the game's "paw": pro_left_jab_b to 0.20 s, then home |
| Push off | 1, both corners | PushOff |
| Clinch | 2 | Clinch.start, roots 0.68 m apart (the still's 0.66 read 0.214 m between trunks here; bar 0.22) |
| Knockdown | 2 | pro_knockout_v1, 8 pictures from the buckle to the canvas |

591 pictures, 480 px webp, 13 MB (`proto/twohands/img/anim/`, table `frames.json`).

## How a run is made (`tools/pics2d_anim.gd`, `tools/pics2d_anim_more.gd`)
- The pair is placed exactly as the still tool places it: the range FOUND, `tools/pics2d_gate.gd`.
- Each frame is the whole run played again from its start in real time and stopped at a fixed time from the contact:
  -0.42, -0.30, -0.20, -0.13, -0.08, -0.04, **0**, +0.06, +0.12, +0.20, +0.30 s. Frames before anything starts are one
  guard picture.
- The timing is the v2 player's own, read from its rules (no number of mine):
  - the punch starts at its take's `start_s`;
  - a landed punch's reaction starts one picture after the glove arrives, part-way into its take, so the head is
    furthest 0.08 s later (a body shot 0.17 s) - `ChoreoRules.react_peak_s`, `Player2._late`;
  - a dodge starts min(its head's peak, 0.33 s) before the contact - `ChoreoRules.DEF_LEAD_S`;
  - the punching arm comes home 0.03 s after the contact (0.08 s a hook) through the home join - `arm_home_s`, `JOIN_HOME`.
- Because everything is live, the contact is posed and measured again; the pair is moved by what the gate still misses
  (the still tool's own rule). The camera is fixed on the contact for the whole run.
- Nothing under `scripts/` changed. No layer over a take.

## What the first strips taught (kept as comments in the tool)
1. The task's first offsets (-0.30 .. +0.12) ended with the arm still out: the run now goes to +0.30.
2. Three "settle" frames after the freeze let the clock-driven layers run on: the arm was home 0.05 s early. The frame is
   now drawn in the frame it is frozen.
3. A dodge that could only start with the punch had the other man leaning back in the first picture.
4. The push and the clinch leave the arms reaching for the other man: every later run of the other corner had a lead arm
   held straight out. They are rendered last and let go properly (`_hands_free`).

## Gate numbers (contact frame)
48 punch runs: 43 passed first time, 4 passed after the live re-pose (blue body hook lands, blue body cross lands, blue
lead uppercut lands / blocked), 1 fails (above). Clinch: passes at 0.68 m. Steps, feint, push, knockdown: framing only.

## For his eye (review board, stage S552; files in `ops/previews/s552_ringanim/`)
- `before_after_real_speed.mp4`: before (one still) beside after (frame by frame) - jab lands, his cross blocked, lead
  hook misses, twice. `before_after_quarter_speed.mp4`: the same at quarter speed.
- `other_actions_real_speed.mp4`: step in, feint, clinch, push off, back off, his uppercut, the knockdown.
- One sheet a punch (`ringanim_<punch>.png`: lands / blocked / missed), `ringanim_other_actions.png`,
  `ringanim_holds_read_wrong.png`.

## Prior research followed
`docs/PICSFIX1_RESULT.md` (the gate, the found range), `docs/PICS2D1_RESULT.md` (the camera and the look),
`ops/research/S510_ANIM_DIGEST.md` and the FIGHTPLAYER2 rules in `scripts/fight3d/v2/ChoreoRules.gd` (S513-S531: when a
reaction, a dodge and the arm home start - each set on the owner's and the critics' films), `BeatClips.DEFENCE` (S304:
every Pro block holds a glove over the head - the same defect the hold strips show).

## Next (not done)
1. **HOLDTAKES1**: four guard takes, one hand each, high and low - authored and baked like the body cross
   (`tools/pics2d_bodycross_bake.gd`), or generated (the owner, S552: "you can try tripo or ludo for animations if it
   speeds up things"). Without them the page cannot show the choice the game is about.
2. An overhand take, and a one-man shove.
3. The women's pair; then the ground through GrappleMap (the task after this one).

## Reproduce
```
python ops/Tools/godot_slot.py run --who RINGANIM1 -- python tools/hidden_desktop.py run --timeout=5400 --log=<log> <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_anim.gd -- <dir>/punches art=toon set=m
... --script res://tools/pics2d_anim_more.gd -- <dir>/more art=toon set=m        (only=a,b,c picks runs; take=<clip> forces a take)
python proto/twohands/tools/anim_web.py <dir>/punches <dir>/fix <dir>/more --strips <dir>/strips --skip hold_ --alias blue_overhand_landed=blue_rear_hook_landed ... --alias blue_push=push --alias red_push=push
python proto/twohands/tools/make_order.py .            (order.html is generated from switch.html)
node proto/twohands/tools/anim_check.mjs
python proto/twohands/tools/anim_sheets.py <dir>/strips ops/previews/s552_ringanim
python proto/twohands/tools/anim_film.py <out.mp4> <run> ... [--speed 0.25]
```
Render time on a GREEN PC: 48 punch runs 19 min, 15 other runs 5 min. Raw frames: `E:/FightCamp/tmp/ringanim1/`.

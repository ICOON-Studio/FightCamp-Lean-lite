# R144 LINE 3 - AUTHOR THE GROUND FILM IN BLENDER, PRICED IN TIME

Claude, 2026-09-18. **This is LINE 3 of `TASK_R144.md` and nothing else.** Lines 1, 2 and 4 need
hosts this container cannot reach and are re-measured as still blocked at the bottom of this file.
Line 3 was the one line that never needed the store or the dataset, so it was done from here.

## DECISIONS

1. **LINE 3 IS NOT THE CHEAP FALLBACK IT LOOKS LIKE, AND THE STRIKING PAIR'S COST DOES NOT
   TRANSFER.** `author_pair.py` authored a RELATIONSHIP between two clips we already owned - the
   thrower's jab is the bought RamsterZ `H2H_JabInPlace` take and the receiver's is
   `H2H_HitReaction01` (`specs/BOX_JAB_HEAD_LAND.json`, `notes` and `roles.*.move`). It placed and
   timed bought motion. **For side control there is no clip to place - that absence is the whole
   premise of R144.** So line 3 is not "script two clips together", it is "create two bodies'
   motion from nothing", which this project has never done once.
2. **THE TOOL IS THE SMALL HALF; THE POSING IS THE JOB, AND IT IS ANIMATOR WORK WE HAVE NO ANIMATOR
   FOR.** Scripting cost is real but bounded (below). Hand-keying two bodies in sustained contact is
   not a scripting task and has no solver in this tree.
3. **AN AUTHORED HOLD DOES NOT GO THROUGH `author_pair.py`'s CONTRACT AT ALL - and that part is
   genuinely cheap.** It targets `FightClipBinding.PAIRED_BINDINGS`, which is six fields and two
   files (`FightClipBinding.gd:770`), not the strike-shaped `.pair.json`. The expensive half of
   `author_pair.py` is irrelevant to a hold. See "What carries over".
4. **LINE 3 NEEDS THE PC TOO.** The cloud Blender is real but takes model bytes from its own
   catalogue only, so `bridge.import_fighter` and everything downstream - `author_pair.py` included
   - still needs the operator's machine (`S4A_CLOUD_BLENDER.md:59-69`). Publishing our fighter to
   get round that was considered and refused there. **So line 3 is priced in PC calendar, which is
   this project's scarcest resource, not in "free".**
5. **A HELD POSITION IS EASIER THAN A STRIKE ON FOUR COUNTS AND HARDER ON ONE**, and the one is the
   expensive one. Detail below.

## The cost basis, measured

The striking pair is the only authored-pair work this project has done, and it is on disk:

| | |
|---|---|
| Tool | `Tools/blender_moves/author_pair.py`, **471 lines**, header dated 2026-09-14 |
| Specs for ONE exchange | **7** (`specs/BOX_JAB_HEAD_LAND*.json` - v0, VARIANT C, VARIANT D, the mirror, `_MESHY`, `_FOOTAGE_GAP`, `_IN_PLACE`), all dated 2026-09-14 |
| Shipped output | **2** `.pair.json` - the exchange and its mirror (`Godot/assets/anim/pairs/`) |
| Integration status | **PARKED.** `fight_pair_live_test` and `fight_stage_presenter_contract_test` are red on purpose by the operator's 2026-09-15 ruling |

So: one exchange, seven authored attempts, a 471-line tool in a day - **and four days later it has
still not cleared integration.** That is the honest denominator. It is also the FAVOURABLE case,
because both halves of it were bought motion.

## What carries over, and what does not

`author_pair.py`'s own section markers split it cleanly.

**Does NOT carry over - all of it is strike machinery:**
- **the distance solve** (`:149-241`). It is a 1-D secant search along X: `place()` sets the two
  armatures to `(-gap/2, 0, 0)` and `(+gap/2, 0, 0)` (`:191`), `hip_gap_m` reads `.x` alone
  (`:211`), and the miss it drives to zero is `f.x - g.x` on one contact frame. Two men in side
  control are 6-DoF relative to each other, not a scalar on a line, and they touch in many places
  at once rather than at one instant.
- **the rear foot lock** (`:242`) and **the front foot stride warp** (`:270`). Both are floor-plane
  devices for a man who is standing and stepping. On the ground the feet are not the contact.
- **the contact window** (`:309-376`). An IK chain on ONE arm whose influence ramps up to the
  contact frame and back down (`ik.in_frames 8 / hold 2 / out 10`). A hold is persistent contact on
  many chains for the clip's whole length - the opposite shape.
- **the facing setup** (`:90-96`): one yaw each, thrower +X, receiver -X. Not a ground arrangement.

**Does carry over:**
- `bridge.py` - the pose bridge, `Mapping`, `take_to_action`, `export_pose_row`. Proven at machine
  precision off the PC (`S4A_CLOUD_BLENDER.md:64-65`).
- the NLA timeline assembly (`:99-148`) and the per-frame export (`:393-437`).
- the whole Godot side. **This is the cheap surprise**: a hold is delivered as two clips named
  `<Key>_Att` and `<Key>_Vic` (`PairedClipMount.pair_role`, `PairedClipMount.gd:67`) plus one
  `PAIRED_BINDINGS` entry of six fields - `pair_key`, `att`, `vic`, `start_s`, `end_s`, `content_s`
  (`FightClipBinding.gd:770`). Nothing else. It does **not** have to satisfy
  `FightMoveScript.PAIR_KEYS` (`FightMoveScript.gd:27`), which demands `contact_s`, `entry_s`,
  `start_gap_m`, `min_gap_m`, `max_gap_m` - a strike's contract, and the gap gate at
  `FightMoveScript.gd:48` that a held position has no meaningful value for.

**The one thing most likely to break:** two bodies posed in contact and then exported through two
separate armatures drift apart. `PairedClipMount.in_step` (`:81`) guards playback to one frame at
60 fps because there is no engine-level sync (Q54: NOT FOUND) - but that guards two PLAYERS, not
two authored curves. Any interpenetration or gap authored into the keys ships as-is; there is no
contact solve on this path the way the strike has one.

## The content target is already on disk

The held mount we own is the shape to copy: `grapple_control` binds
`Paired_FullMount_Takedown_BodyLock_Loop_{Att,Vic}` with `content_s 1.667`
(`FightClipBinding.gd:816-821`), and S12 made the room replay it as a resting state. **So an
authored hold is a ~1.7 s loop that starts and ends on the same pose**, not a one-shot.
We own 20 distinct pair keys on disk and bind 12 of them - all `Paired_FullMount_*`, one position.

## Held vs strike, honestly

**Easier on four counts**, and each one is a thing that cost the jab an iteration:
- no follow-through to solve - the hand is not travelling to a target and past it;
- no contact INSTANT to land a clip on, so no timeline search and no `contact_s`;
- no distance solve and no gap gate - the bodies are placed once, relative to each other;
- no stride warp and no foot lock - nobody is stepping.

**Harder on one**, and it is the expensive one: **persistent contact at many joints simultaneously,
authored by hand.** The strike needed one hand on one head for a few frames and got an IK constraint
for it. Side control is a chest on a chest, an arm under a head, a hip on a hip, held for the whole
loop, on two bodies of different builds - and `FighterPhysique` scales the bodies in the room
(S6c), so a pose authored against one pair of builds is not correct for another.

## The estimate

**Scripting: 6-10 hours** (ESTIMATE, basis = `author_pair.py`'s 471 lines minus the four sections
above, which are roughly half the file; the reusable half is proven). This produces an
`author_hold.py` sibling that imports both fighters, applies a hand-authored pose pair, runs the
loop, and exports two `_Att`/`_Vic` clips plus the binding entry.

**Posing, per held position: UNPRICED, and deliberately so.** There is no measured basis in this
project for hand-keying two bodies in sustained contact - it has never been done here, the seven
jab specs are not that task, and a number invented from the striking work would be the guess this
whole task exists to stop. What can be said with evidence: it is animator hours, not script hours;
it needs the PC; and the striking exchange, whose motion was already bought, still took seven
attempts and has not shipped.

**So line 3's rank is: cheapest in CASH (zero) and the least certain in TIME.** It should not be
recommended over a SKU that exists until lines 1 and 2 have actually been looked at. If line 1
finds a same-publisher side-control pack near `Paired_FullMount_*`'s EUR 10.11, line 3 is not worth
opening.

## Lines 1, 2 and 4 - re-measured from this container 2026-09-18, still blocked

Per the standing rule, the wall was measured here rather than inherited, and it has MOVED:

| host | result | line |
|---|---|---|
| `assetstore.unity.com` | 000 (403 at CONNECT, policy denial) | 1, 2 |
| `huggingface.co`, `hf.co`, `datasets-server.huggingface.co` | 000 (403 at CONNECT) | 4 |
| `jyuntins.github.io` | 000 | 4 |
| `api.github.com` | **200 - NEWLY OPEN**, it was rejected on 2026-09-18 | - |
| `raw.githubusercontent.com` | 301 (answers) | 4 |

`api.github.com` opening does not unblock anything decisive: line 4 lives or dies on the Hugging
Face DATASET licence card and on opening an `02_grappling` annotation, and both are on
`huggingface.co`. Lines 1 and 2 need the Unity store. **R144 stays PC-only for 1, 2 and 4.**

## No JSON yet, and that is on purpose

`R144_ground_film.json` is a four-line ranked shortlist for the ops board. One line costed is not a
shortlist, and a board rendering three empty rows would read as "R144 ran and found nothing". It is
written when lines 1, 2 and 4 land.

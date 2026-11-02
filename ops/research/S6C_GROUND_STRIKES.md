# S6C — the ground strike gets a path, and a film stops shrinking the man

Stage B of the 2026-09-18 greenlight. Two findings, one fix each, plus the
control that says how much of the first one the EYE actually gets.

Instruments: `tools/audit_unbound_contact_sheets.gd` (the sheets, now filterable
from the command line), `tools/measure_presentation_split.gd` (the split, now
carrying a ROUTED row), `tests/fight_grapple_seam_test.gd` (the room).

---

## 1. THE FILM WAS WATCHED BEFORE IT WAS BOUND

`FightClipBinding`'s own note nominated `Paired_FullMount_H2H_Punches` for
`mma_guard_gnp` **from its filename**, which is one step from the M19 lie —
R127 and S6b between them found five mislabelled clips by looking at them. So
both unwatched H2H candidates were rendered (`research/S6C_SHEETS/`,
six cells across each window, quarter and top-down views):

| film | window | what the sheet shows | verdict |
|---|---:|---|---|
| `Paired_FullMount_H2H_Punches` | 1.167 s | the top man sits over a man on his back and punches down, repeatedly; the bottom man's hands stay up covering. The mount never changes. | **BOUND** to `mma_guard_gnp` |
| `Paired_FullMount_H2H_HeadSmash` | 1.500 s | the top man takes the downed man's head in both hands and drives it into the canvas. | **REFUSED ON CONTENT** — no ruleset this game simulates permits it and the catalogue names nothing like it |

The top-down sheet also answers the question S6 could not: the pair lies along
the mount's own **Z** — the axis `PairedClipMount.shared_origin` yaws to — so a
grafted ground strike plays down the fight's line rather than across it. The
printed `line_deg` is 179.5 off a 2 cm separation and is NOISE, exactly as the
tool's own comment warns: a full mount stacks one man ON the other, so the flat
att->vic vector is too short for its angle to mean anything. The picture is the
instrument here, not the number.

Two more ground-strike films stay unbound, written down so nobody re-watches
them: `AttackBlock` is the same picture with ONE punch and a cover (a second
film for one id, and there is no variant machinery on this path), and
`VictimAttack` is the man UNDER the mount punching upward — a real ground
strike with **no id to serve**, because the catalogue names no `ground_bottom`
damage technique at all. That one is a missing MOVE, not a missing film.

`mma_dirty_boxing` is refused on POSITION and it is now the biggest ground
degrade left (1.93% of all action beats, rank 4 of the whole queue). Its phase
is `cage_clinch` — two men upright against the fence — and every
`Paired_FullMount_*` film in the pack is two men on the canvas. That is
`grapple_stall`'s ruling applied again: a wrong position is worse than no clip,
because no clip is visible as absence and a wrong one is not. It needs a clinch
film nobody has bought.

## 2. THE SPLIT, BEFORE AND AFTER, ON S9'S POPULATION TO THE DIGIT

Same fixture as S9 and S10 — two differentiated men (reach 183/176 cm, every
stat different, neither carrying a `technique_progress` record so both are
legal for whatever rules they are put under), 100 bouts x 3 rounds per ruleset
from seed base 560000, rulesets boxing, kickboxing, muay_thai, mma, catalogue
`assets/data/combat_rulesets.json`. 335,443 action beats.

| state | before S6c | after S6c |
|---|---:|---:|
| EXACT | 98055 (29.2%) | 98055 (29.2%) |
| SUBSTITUTE | 66543 (19.8%) | 66543 (19.8%) |
| **DEGRADE** | **153951 (45.9%)** | **138353 (41.2%)** |
| GENERIC | 16894 (5.0%) | 16894 (5.0%) |
| SILENT | 0 | 0 |
| **ROUTED** | — | **15598 (4.6%)** |

**In an MMA bout alone, ROUTED is 14.1% of every action beat** — one action
beat in seven now has the paired path to go down. The degrade queue's rank 1
is no longer `mma_guard_gnp`; it is `boxing_circle_rear`, a `movement` id S10
already showed is mostly a man who is visibly walking.

The GROUND fix row falls from 22075 beats (14.3% of all degrades) to 6477
(4.7%), and what is left in it is the clinch.

**The ground split the gate asked for is UNCHANGED, and that is the right
answer:** 5859 PAIRED / 1001 DEGRADE over 6860 grapple beats — **85.4% /
14.6%**, to the beat. A ground STRIKE is an action beat and was never in that
denominator; a stage that moved it would have been measuring its own routing.

## 3. THE CONTROL — WHAT THE EYE GETS, WHICH IS NOT 4.65 POINTS

The split above is ACTION-PATH accounting: it says `mma_guard_gnp` no longer
reaches `_thrower_clip`. It does NOT say a film played, because the room still
has to have two free bodies. Measured in a running room
(`tests/fight_grapple_seam_test.gd`, the live room's own vetted MMA pair —
wrestle-grappler against striker — seed 77321, MMA, the first 45 s of show
time):

| | |
|---|---:|
| ground strikes routed | 79 |
| ... a film played | **11 (13.9%)** |
| ... handed back to the ordinary action path | 68 (86.1%) |
| ... still pending at the end of the window | 0 |

Every refusal was `already_playing`: `busy` and `set_piece` were both **0**.
That is structural rather than a fault — one mount drives both bodies, a film
is 1.167 s, and on the floor these beats arrive faster than that — and a
handed-back beat degrades exactly as it did before this stage, which is why
the routing cannot make anything worse.

**So read the two numbers as what they are.** 4.65 points is the accounting
improvement and an upper bound; 13.9% of routed beats is what the eye gets
today. The rest are honest either way: while a film owns the two bodies the
room is showing ground fighting, which is what the engine says is happening.

## 4. THE PHYSIQUE SCALE, AND ITS SECOND SIGHTING

`PairedStagePlayer.graft_pair` assigned `_body_a.transform` wholesale.
`PairedClipMount.shared_origin` returns `Basis(Vector3.UP, yaw)` — orthonormal
by construction — so every grafted body was silently returned to the GLB's own
size, and `_release_grapple` hands the post-graft basis back to the room, so
the man stayed the wrong size for the rest of the bout. One takedown was enough
to do it.

It had already been SEEN once, and worked around rather than reported:
`tools/audit_unbound_contact_sheets.gd` used to hand the scale back through the
mount origin, with a comment saying exactly why. That is why S6b's sheets
showed correct bodies while the live room buried every man to the neck — the
instrument had the workaround and the room had the defect. **A workaround in an
instrument is a defect report nobody filed.**

The fix is one sentence of architecture: **a film says WHERE a body is, never
how big the man is.** `bind` takes each body's own scale and every placement
hands it back. The workaround came out of the tool in the same commit, or the
scale would have been squared.

Proof, three ways:
- `tests/paired_stage_player_test.gd` binds two bodies at two DIFFERENT scales
  (0.930 and 1.072) and asserts both survive `remount` and a real `graft_pair`,
  with the placement still at the mount origin to the millimetre and the mount
  yaw intact. Run against the pre-fix file the two graft assertions read
  `got 1.000` — the test is not vacuous.
- the sheets now print `node_scale` beside `node_y` per cell (0.962/0.962 on
  both S6c films), which a broken run cannot fake.
- `fight_grapple_seam_test` still passes every S6 assertion, one mount and two
  bodies included.

## WHAT IS OPEN AFTER THIS

- **`already_playing` refuses 86% of routed ground strikes.** Worth a stage
  only if the answer is a queue or a longer film, and neither is free: the
  number to beat is 13.9%, measured above.
- **`mma_dirty_boxing` needs a clinch film** — two men on their feet, which the
  RamsterZ pack does not contain. A purchase, and the first ground-side one.
- **`VictimAttack` has no id.** A `ground_bottom` damage technique would give
  the bottom man his own strike; that is a catalogue question, not a clip one.
- **AND THE ONE THIS STAGE MADE MORE VISIBLE, WHICH IS THE HONEST COST.** The
  room has no ground POSE, only ground FILMS: `_release_grapple` calls `settle`,
  which queues the stance, so both men come back to their feet the frame a film
  ends even though the engine still says `ground_top`. Before S6c that happened
  a handful of times a bout, on takedowns; now it happens every time a ground
  strike plays. The picture is right for 1.167 s and wrong afterwards, where it
  used to be wrong throughout — better, and not yet right. The fix is a HOLD:
  `Paired_FullMount_Takedown_BodyLock_Loop` is already bound to
  `grapple_control` and S6b watched it — "nothing advances, two men, mount held"
  — which is exactly what a man should be doing between ground strikes. Keeping
  the two bodies on the canvas while the engine's phase stays on the floor, with
  that film as the resting state, is one stage and it needs no purchase.

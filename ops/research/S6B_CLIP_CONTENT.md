# S6b — WHAT THE UNBOUND CLIPS ACTUALLY ARE

Rendered 2026-09-18. Instrument: `Godot/tools/audit_unbound_contact_sheets.gd`.
Sheets: `research/S6B_SHEETS/` (16 PNGs, one per clip per view).

S6 (A) left two refusals standing on the same sentence — *nobody has watched
them*. `FightClipBinding.gd:670-677` said it of the four unbound paired films;
`:628-641` said it of the one side-kick file that six of U56's highest-demand
ids all route to. This pass watched all of them.

## THE CONTAINER CAN RENDER, AND THE ROADMAP SAID IT COULD NOT

The stage was written as "NOT A BUILD SESSION AND NOT A CLOUD ONE", because
Godot draws nothing under `--headless` and R127 paid for that twice. A cloud
container has no display; it does have `Xvfb`. With one supplied, the ordinary
windowed path renders exactly as it does on the PC:

```
xvfb-run -a -s "-screen 0 480x620x24" godot --path Godot \
  --script tools/audit_unbound_contact_sheets.gd \
  --resolution 480x620 --rendering-driver opengl3
```

Checked before anything was built on it: 672 frames of the existing R127 audit,
1 blank (frame 00 of the first clip, before the first draw), 671 real lit
renders of a rigged fighter. **`--headless` is still black; the display is what
was missing, not the renderer.** This does not make the operator's eye
redundant — it makes the sheets reachable without waiting for a PC session.

## THE MANNEQUINS ARE NOT A POPULATION

Every film here is danced by `f05_m_mma_light_rigged` (att) and
`f09_m_bare_welter_rigged` (vic), both mounted at 70.0 kg so their physique
scales match (0.962 each). That is named because the standing rule says to name
it, and it is **not** an engine measurement: a clip's content does not depend on
who performs it. Nothing in this document is a finding about the fight engine's
behaviour.

## THE FOUR PAIRED FILMS

| film | what it is |
|---|---|
| `Paired_FullMount_AttackBlock` | the mounted man punches down, the man under him covers. A GROUND STRIKE. Mount never changes. |
| `Paired_FullMount_VictimAttack` | the man UNDER the mount punches upward. Also a ground strike. Mount never changes. |
| `Paired_FullMount_Takedown_BodyLock_Loop` | nothing advances. Six samples across the window are the same picture. A HOLD. |
| `Paired_FullMount_Takedown_BodyLock_End` | the pair comes up off the canvas; both men finish on their feet. A RETURN TO STANDING. |

Control: `Paired_FullMount_Reversal`, already bound to `grapple_sweep`, renders
as a reversal — the man on the bottom comes up and finishes on top. The bound
binding is what it says it is, which is what calibrates the other four readings.

**Two bind. Two are refused on ROUTING, not on content.** `AttackBlock` and
`VictimAttack` are the best ground-and-pound films in the pack and they are
unusable today: a ground strike never comes through `_log_grapple`, it arrives
through the IMPACT subsystem as an ordinary action beat, and that path resolves
through `BINDINGS`, which has one `path` and cannot hold a pair. That is a
stage, not a table edit.

Bound this pass:

- `grapple_control` → `BodyLock_Loop`, 0.000–1.667
- `grapple_stand_up` → `BodyLock_End`, **2.333**–4.833 (C91's window; this is
  the one pair carrying dead air, 2.333 s of it on both halves)

`grapple_stall` is the near miss and is refused deliberately: a hold is a hold,
but a stall can be scored STANDING in a clinch, and a full mount played there
puts two men on the canvas who are on their feet. Nine ids remain absent with no
film that depicts them.

What the `stand_up` sheet does NOT say: it shows BOTH men rising. If the engine
ever scores a `stand_up` where one stands and the other stays down, this film is
wrong for that case, and `via: "stand_up"` carries no such distinction into the
beat.

## THE SIDE KICK: THE REFUSAL SURVIVES ITS OWN TEST

`H2H_HighSideKick_InPlace.FBX` is **a textbook side kick** — hip turned over,
support foot pivoted, torso bladed and leaning away from the target, leg out
sideways at head height (`SOLO_H2H_HighSideKick_InPlace__profile.png`, frames
4–5). The suspicion behind `:628-641` was that a generic pack had mislabelled a
thrust kick. It had not.

So `muay_thai_teep`, `kickboxing_teep`, `kickboxing_front_kick` and
`muay_thai_jab_teep_switch` stay unbound **on evidence rather than on caution**,
and the 9.4% of coverage they carry is a PURCHASE, not a work item. The pack
contains no push kick at all; no amount of re-reading the table produces one.

Bound instead:

- `kickboxing_side_kick` → `H2H_HighSideKick_InPlace` — the id's own name is the
  move on the film.
- `kickboxing_high_kick` → `H2H_RoundhouseKick_InPlace`, **not** the side-kick
  file U56 proposed. The roundhouse clip renders as a high ROUND kick (knee
  chambers across the body, foot arcs in at head height) and a "high kick" in
  this sport is a high round kick. Binding it to the side kick would have made
  every high kick in the game a side kick.

`readable_s` is omitted on both: no contact-plus-recoil peak has been measured
for either file, and an absent window falls back to the whole clip in
`FightPresentationQueue`. Copying the roundhouse's 0.233 across would be
authoring a number to fill a field.

Also seen, not acted on: `H2H_LowSideKick_InPlace` is a genuine LOW side kick,
and the existing table was already right to refuse it for `kickboxing_low_kick`
and take `H2H_RightCutKick_InPlace` instead — a low kick in this sport is a
round kick to the thigh. And the one roundhouse file serves both
`kickboxing_body_kick` and `muay_thai_switch_kick_body` while rendering at HEAD
height; the pack owns no body-height round kick, so there is nothing better to
bind, but a "body kick" does currently play high.

## WHAT IT MOVED, MEASURED RATHER THAN REMEMBERED

`tools/measure_technique_demand.gd`, re-run after the bindings landed:

```
U56_DEMAND rulesets=4 ids_fired=55 bound=14 coverage_now=30.3% coverage_top20=59.0% ceiling=59.0%
```

**28.7% → 30.3%, against an unchanged 59.0% ceiling.** Twelve ids resolved
before, fourteen now. The ceiling is quoted beside the value on purpose: the
remaining 28.7 points are a purchase and not a work item, and the two teep ids
alone are 9.4 of them. Two paired grapple ids were also bound, which this
instrument does not count — it measures striking demand.

## AND THE GROUND HALF INVERTED

`tools/probe_grapple_seam.gd`, re-run after the bindings landed, seed 77321,
MMA, wrestle-grappler v striker (the population the probe names itself):

| | S6 (A), 2026-09-17 | S6b, 2026-09-18 |
|---|---|---|
| grapple events, 3 rounds | 48 | 48 |
| on an id we own film for | 6 | **42** |
| `no_clip` | 42 | **6** |

**The same seed, exactly inverted, off one table entry.** Across the probe's
five seeds: 77 of 87 events bound (88.5%). Playback on 77321: four distinct
films — `PushOff`, `Takedown_DoubleLeg_Start`, `BodyLock_Loop`, `BodyLock_End` —
10 played, 10 completed, 0 cut, 585 held frames.

`grapple_control` is nearly all of it. It is the most-fired grapple id in the
game by a wide margin, and it had no film; the film that serves it is the one
whose six samples are the same picture. **The dullest clip in the pack served
the busiest beat.** The striking side has a demand table (U56) that would have
said so in a line; the ground side had none, and the ranking that mattered here
was how often an ID FIRES, not how good a candidate film looks.

## WHICH WAY THE PAIRED FILM FACES — ANSWERED, AND IT NEEDS NO CONSTANT

S6 (A) could not answer this: C91 measured timing, not orientation. Every pair
was rendered a second time from straight overhead with the mount's own axes
drawn on the floor in gizmo colours (red +X, blue +Z), so the compass is inside
the picture.

**The films are authored ALONG the mount's +Z.** In every top-down sheet the two
bodies lie parallel to the blue bar, centred on the origin, and rotate about it.
+Z is the axis `FightWorldStage.face_each_other` aims a fighter down (R116: the
model's forward is +Z) and the axis `PairedClipMount.shared_origin` builds its
yaw from. **A takedown does not play sideways to the room's line, and no
correction constant is owed.**

The numeric att→vic pelvis line reads 179.5° on all five films and is
**degenerate, not corroborating**: a full mount stacks one man on the other, so
the flat pelvis-to-pelvis vector is 0.021 m long and its yaw is the two MODELS'
rest offset rather than the film's axis. That is why the instrument prints the
separation's LENGTH beside its angle — an angle with no length beside it cannot
be told apart from noise. The picture is the evidence here; the number is not.

## TWO THINGS FOUND BY LOOKING, NEITHER FIXED HERE

**1. `graft_pair` overwrites the body transform, so the physique scale is lost
for the duration of every paired film.** `PairedStagePlayer.graft_pair` assigns
`_body_a.transform = placed["a"]` wholesale, and the room builds that origin as
`PairedClipMount.shared_origin(...)` → `Basis(Vector3.UP, yaw)`, which is
orthonormal. `FightWorldStage.mount` had set `fighter.scale` from
`FighterPhysique`; after a graft both bodies are scale 1.0, and nothing restores
it when the film ends. The room's two fighters are 66.0 and 66.5 kg, so the pop
is small there — with a real weight spread it is two men changing size mid-
takedown. The height survives only because `_grapple_origin()` takes its midpoint
from `_node_a.position`, which carries the foot-rest lift.
`PairedClipMount.place` already takes PER-BODY offsets and its own doc says a
scale on the origin is to be KEPT; the room passes `IDENTITY` for both. Its own
slice, with its own test.

**2. A paired film carries no horizontal travel, by construction.** Read in
`FightClipRetarget.retarget_clip`, not inferred from the symptom: the Hips get
one position track that moves on the height axis only, the source's ROOT holds
the travel (U83) and is dropped, and the XZ sway term is added only when
`carry_sway` is true — which `graft_pair` never passes. Measured: the attacker's
pelvis XZ is `0.004, 0.040` on every sample of every one of the five films. So a
double-leg takedown in the room covers zero ground. That is a design fact worth
knowing before anyone tunes distance around a takedown, not a bug report.

## RE-RUN IT

```
xvfb-run -a -s "-screen 0 480x620x24" godot --path Godot \
  --script tools/audit_unbound_contact_sheets.gd \
  --resolution 480x620 --rendering-driver opengl3
```

Add a row to `PAIRS` or `SOLOS` to watch another clip. Windows for paired films
come from `research/C91_PAIRED_CONTENT.md`; clip lengths from
`research/Q47_INVENTORY.csv`. Nine samples for a kick and six for a pair —
the kick number is sized against the only readable window we have measured
(the roundhouse's 0.233 s), not guessed.

# TASK R103 — CLAUDE — THE FOUR GAPS, AND A BEAT THAT PLAYS A CLIP

Model: Opus, **high** effort, Fast OFF. Owner: claude.
**Greenlit by the operator 2026-09-11: "fix the gaps".**

Tier: **the focused tests, then the FULL SUITE ONCE at integration.** This adds
a presentation seam; it must not move a single seeded fight.

## The state, in one paragraph

R94 proved the animation pipeline: **0.2 credits per clip, once, for all twelve
fighters.** The retarget output is a mesh-free 58 KiB animation-only glTF whose
22 bone names ARE `SkeletonProfileHumanoid`, so there is no BoneMap and no
per-fighter cost, and integration was a ten-line track-path rename — before it a
clip moved 0 of 22 bones, after it 22 of 22 on every one of the twelve.
`fight_world_anim_test.gd` already builds the ring at the real deck height,
stands f01 on the 1.27 m boxing canvas with his feet on it, grafts the bones and
throws a clip, with an isometric camera and lights in `FightWorldPreview.tscn`.

**Four gaps stand between that and a 3D fight, and only ONE of them is new
code.**

## GAP 3 IS THE STAGE. THE OTHER THREE ARE ITS PRECONDITIONS.

### GAP 3 — NOTHING READS A BEAT AND PLAYS A CLIP

This is the whole task. `FightBeatAdapter` already gathers the 20 Hz fight into
beats a screen can present — `begin` / `is_fight_over` / `advance_beat` /
`result` / `state_view()` — and **U43 made the beat carry the technique**
(`technique_id`, `technique_name`, `range_band`, copied from the engine, never
invented). Nothing consumes it as animation.

Build the seam: a beat arrives, and the presenter plays the clip for the
technique it names, on the right fighter, at the right time.

**THE RULES THAT GOVERN IT, and they are not negotiable:**

- **G42's ruling, which R97 already obeys: DROPPING IS PERMITTED, INVENTING IS
  FORBIDDEN.** The presenter may show less than the fight contained. It may
  never show something the fight did not score.
- **M19's rule, and it is the one that will be tempting to break:**
  > "If we have no clip for the named technique: play matching-region reaction
  > on the receiver; leave thrower on current loc/idle; **never play a different
  > technique's clip**."
  A hook standing in for an uppercut is forbidden. A "generic punch" secretly
  sold as the named technique is forbidden. Idle is **stillness / continue
  guard — not a T-pose**.
- **THE PRESENTER DRAWS NO RNG AND CHANGES NO STATE.** It reads. If the
  presenter can alter a fight, R82's byte-exact replay is gone.
- **ASSERT BY OCCURRENCE.** This area has shipped six pieces of correct, tested,
  unreachable code. A test that says "a clip MAY play" is worthless; assert that
  one DOES, and that the no-clip path DOES take the reaction branch.

### GAP 2 — THE UNIT IS WRONG, AND IT IS MOSTLY ALREADY SOLVED

The one clip we own is a 2.47 s combo, which **G42 says is the wrong unit** — a
beat is a window of fight-time, not a combination. **U40 already sliced three
punch windows off the curve** (jab 0.00–0.64 s, reach 0.744 m; cross; hook), cut
on the retractions rather than at equal thirds, and **U41 mirrored them into
six**.

**BUT READ U42 BEFORE YOU TRUST THEM.** Cursor's own audit of the source clip
found `windows=3 hands=RightHand,RightHand,RightHand alternates=false`, i.e.
**`kind=single_hand_drill`** — three right hands that never alternate. So the
six are one hand's three punches plus their mirrors, and **we do not own a real
jab-cross alternation.** Wire the sliced windows in as the unit; do not describe
them as a combination.

### GAP 1 — NOBODY STANDS AT SpawnB

`fight_world_anim_test.gd` mounts f01 only. A fight has two men. Mount the
second, on the same canvas, facing the first. Mechanical, but it is a
precondition for any reaction: **M19's whole no-clip answer is a reaction on the
RECEIVER**, and there is currently no receiver.

### GAP 4 — THE SCENE HAS NO ROUTE

`FightWorldPreview.tscn` is reachable only from a test. Give it a route so the
thing can be looked at. Check `SceneRouter` for the house pattern.

## What must NOT move

**NO SEEDED FIGHT MAY CHANGE.** This is presentation. Run `judge_panel_test` and
`fight_realtime_test` and expect them BYTE-IDENTICAL — if a pin moves, the
presenter has reached into the engine and that is the defect, not the pin.

R102 has just left the tree at **eight draws per built impact**, asserted by
replaying the stream. That assertion must still pass unchanged.

## The research that lands alongside this

- **Q45** — *which techniques actually get shown*. The operator caught a real
  denominator error: M19 argued its no-clip case against **272 catalogue
  nodes**, but R97 drops **92.6% of impacts** and you never need a clip for a
  throw that is never rendered. Q45 measures the SHOWN distribution and the
  cumulative coverage curve. **It decides the purchase list; it does not gate
  this stage.**
- **U46** — *audition the free pack*. C75 read six sources' licence clauses and
  found **zero verified paired ground sequences everywhere**, for the structural
  reason that single-actor mocap cannot supply two bodies in matched contact.
  Three of its cells are `NV`, not zero, and Motifect (free, 40 clips) has never
  been auditioned. **It decides whether the $60 Unity pack is worth it.**

## Owned files

- `Godot/scripts/` — the new presenter module (name it when the shape is known).
- `Godot/scenes/FightWorldPreview.tscn` and its script.
- `Godot/tests/fight_world_anim_test.gd`.
- `research/R103_DIGEST.md`.

**`FightRealtime.gd` (2,376 lines) and `FightBeatAdapter.gd` are READ-ONLY for
this stage.** If the seam needs something they do not expose, that is a finding
to report, not a licence to edit them.

## Anchors

- `Godot/tests/fight_world_anim_test.gd` — the existing graft-and-play harness.
- `Godot/scripts/FightBeatAdapter.gd` — `advance_beat`, `state_view`.
- `research/R94_ANIMATION_SPIKE.md` — the track-path rename, the bone
  finding, the 0.2-credit number.
- `research/M19_THE_MISSING_CLIP.md` — decisions 1, 2, 5 and 6. **Its
  denominator is wrong (see Q45) but its no-substitution rule is right.**
- `research/U40_DIGEST.md`, `U41_DIGEST.md`, `U42_DIGEST.md` — the three
  windows, the mirrors, and the audit that says what they really are.
- `research/G42_CLIP_TIME_VS_TICK_TIME.md` — the unit, and the
  drop/invent ruling.

## The trap most likely to cost this stage

**A T-POSE OR A WRONG CLIP WILL LOOK LIKE PROGRESS.** The first time two men
stand on the canvas and something moves, it will be very tempting to fill every
beat — to let a hook cover an uppercut, or to leave the thrower in a rest pose
that reads as broken. M19 named both and refused both. **The honest frame is
idle-plus-region-reaction, and it is a finished answer, not a placeholder.**

The second trap: **do not let the presenter pump the fight.** A beat is a window
of fight-time. If the presenter advances the engine to make an animation look
right, it owns the fight, and R82 is over.

# S4 (2) — THE ROOM TAKES THE ENGINE'S REAL POSITIONS

Step 2 of the S4e order the operator greenlit on 2026-09-15. Pure wiring: no engine file is touched and no fight
changes. What changed is that the picture stopped throwing away three things the engine had been computing for four
stages.

## POPULATION

Every number below is one seeded three-round BOXING bout from `FightWorldLiveScreen`'s own booking — seed 94301, and
seed 94301 with one round where a row says so.

**Two male welterweights, legal for the ruleset and NOT identical** (operator rules 2026-09-12): **A** is f01, an
out-boxer (reach, speed), 66.0 kg; **B** is f09, a pressure puncher (power, conditioning), 66.5 kg. They are
differentiated INSIDE boxing by style and attributes and neither is missing a technique the ruleset permits.
Catalogue: `assets/data/combat_rulesets.json`, boxing.

## WHAT WAS THERE BEFORE

`FightWorldLiveScreen._aim_gap`, in four lines, turned each beat's `range_band` — the WORD `LONG` / `MID` / `POCKET` —
into one of three metre figures, and `_place_bodies` slid both bodies along the single line between the two spawn
marks, symmetrically about its midpoint. The yaw was set ONCE at mount by `Stage.face_each_other` and never
recomputed.

Meanwhile `FightRealtime` carried:

- **two 2D positions**, quantised every tick, since S4e (1);
- **a facing per man**, turning at his own rate (`FightBearing.turn_rate`), since S4e (4);
- **a between-exchange phase word** per man — `engage` / `reset` / `measure` — stamped every decision tick whether the
  switch is on or off, since S4e (6).

The room read none of them. **Two men circling each other across a 6 m ring and two men standing on a rail drew the
same picture.**

## THE DEFECT, MEASURED BEFORE IT WAS CHANGED

`tools/measure_room_positions.gd`, one seed, three rounds, switch OFF — which is the room exactly as it shipped:

| | measured OFF | study |
|---|---|---|
| metres covered per round, A / B | **8.7 / 13.9 m** | Schortgen 155 ± 28 m/round; Thomson (M18) 0.6 m/s = 108 m/round |
| distance off the spawn line | **0.000 m**, every frame, both men | — |
| body yaw | **0.0 deg/s**, every frame | — |

**A man covered 8.7 metres in a three-minute round.** That is an order of magnitude under the lower of the two
published figures, and the two studies disagree with each other by 45%.

## WHAT CHANGED

**One new module, `FightRoomTrack.gd`, and ONE switch — `engine_positions`, default on.**

- `FightRoomTrack` is the pipe: statics only, zero preloads, one sample per pumped tick in, the sample at the second
  the PICTURE is showing out. Positions and velocities lerp, facings lerp and are renormalised, **the phase word does
  neither** — half way between `measure` and `engage` is not a state the engine has.
- **It is a track and not a read because the engine runs `HORIZON_S` (3.5 s) AHEAD of the picture.** Reading
  `state["fight"]["a"]["pos_x"]` in `_process` would put every man three and a half seconds into his own future. The
  actions already solve this by being scheduled (`FightLiveSchedule`); positions get the same treatment for the same
  reason.
- `_gap` and the fight line stop being INPUTS and become what the two positions imply, so the strike warp, the contact
  solve, the authored pairs and both panels keep reading the same two numbers they always did.
- The ring frame maps to the room as **a rotation, not a reflection** (`_ring_side = (-axis.z, 0, axis.x)`, det +1).
  Stance is a left/right fact; a mirrored floor would silently swap every man's right hand.
- **Each body's yaw is the engine's facing, every frame.** A man who has just been circled on is briefly still
  pointing where his opponent WAS — which is what S4e (4) built and what nothing could see until now.

### THE SIX WALKS THAT WERE ON DISK, AND WHY THE REASON THEY WERE UNBOUND WAS WRONG

R118 bound `loc_advance` and `loc_retreat` off the 37 clips C94 measured, and left the rest with this comment:

> WalkLeft and WalkRight are DELIBERATELY NOT BOUND HERE. They measure 0.884 m of real lateral travel, so they WOULD
> fight an engine-owned driver.

**That figure is in no measurement this project owns.** C94's own table (`C94_LOCOMOTION_CONTENT.md`, measured by
`tools/measure_locomotion_clips.gd`) says `H2H_WalkLeft.FBX` travels **0.0006 m** and `H2H_WalkRight.FBX` 0.0006 m —
less than `WalkBack` (0.0067 m), which has been bound since R118. The 1.8428 m belongs to
`H2H_WalkLeft_RootMotion.fbx`, the vendor's SEPARATE root-motion twin. Every plain `H2H_Walk*` clip is in place and
satisfies G42 exactly as `WalkForward` does. Grepping `0.884` over `research/` and `scripts/` returns the comment and
one assessment doc that repeats it, and nothing else.

The other half of that comment was right — "circling is a separate slice that has to decide who owns the metres
before it picks a clip" — and **this is that slice: the ENGINE owns the metres.**

So all eight are bound, on U84's own per-file measurement (`U84_STRIDE_SPEED.md`,
`tools/measure_stride_speed.gd`), with its direction as well as its stride speed. `direction_deg` is in the man's own
frame: 0 down his nose, positive toward his right.

| role | clip | native m/s | direction |
|---|---|---:|---:|
| `loc_advance` | H2H_WalkForward | 1.736 | 0.0° |
| `loc_advance_left` | H2H_WalkForwardLeft | 1.735 | −45.0° |
| `loc_advance_right` | H2H_WalkForwardRight | 1.735 | 45.0° |
| `loc_strafe_left` | H2H_WalkLeft | 1.705 | −90.0° |
| `loc_strafe_right` | H2H_WalkRight | 1.764 | 90.0° |
| `loc_retreat_left` | H2H_WalkBackLeft | 1.781 | −135.1° |
| `loc_retreat_right` | H2H_WalkBackRight | 1.781 | 134.9° |
| `loc_retreat` | H2H_WalkBack | 1.781 | 179.8° |

`FightClipBinding.locomotion_role_for` picks the nearest by angular distance, so **the eight rows ARE the decision
table** — there is no authored bucket width anywhere, and dropping a row narrows the choice instead of leaving a hole.
The test asserts all eight directions to the digit so a later pass cannot quietly round 179.8 to 180.

### THE PHASE WORD IS READ AND IT PICKS NOTHING, AND THAT IS THE HONEST ANSWER

The step brief says the phase word "is exactly what picks between a measuring bounce and a reset step". **The
RamsterZ H2H pack contains neither.** Its 90 clips are one stance (`H2H_Idle`), eight walks, eight runs, a sprint,
three turns, four dodges, four jump parts, the block state machine, the reaction set and the strikes. There is no
bounce, shuffle or hop of any kind. Choosing a walk for a man who is studying, or the stance for a man who is
resetting, would be a picture the animation cannot support and a number nobody measured.

So the word is carried into `locomotion_stats` and bucketed as `role/phase`, which lets a measurement say how many
frames each phase spent in each clip — and **buying or authoring a measuring bounce is its own slice** (OPEN 3).

## THE MEASUREMENT

`godot --headless --path Godot --script tools/measure_room_positions.gd -- seeds=1 rounds=3 arm=both`

| | OFF | ON | study |
|---|---|---|---|
| action beats resolved | 553 | **553** | — the engine does not move |
| metres per round, A / B | 8.7 / 13.9 | **134.8 / 119.1** | Schortgen 155 ± 28; Thomson 108 |
| off the spawn line, mean / max | 0.000 / 0.000 | **1.223 / 3.000 m** | 3.000 m IS the ring half-width — they reach the ropes |
| gap, mean | 1.247 m | **1.231 m** | Schortgen 1.23 ± 0.16 (band 1.07–1.39) ✅ both |
| gap, p05 / p95 | 1.098 / 1.361 | **0.582 / 1.881** | the spread is a fight's now, not three table values |
| body yaw, p50 / p90 / max | 0.0 / 0.0 / 0.0 | **9.7 / 59.2 / 272.9 deg/s** | NO STUDY — see OPEN 2 |

**553 action beats in both arms, from the same seed.** The whole of the presentation was rewired and the fight
underneath is the same fight. That is the switch proven at the engine boundary, and the gate asserts it.

The gap mean moved 0.016 m and stayed inside Schortgen's band. It was never tuned toward it: with the band table the
mean was an average of three authored numbers, and now it is what two men walking around each other produce.

## WHAT THE RE-BASELINE COST, AND WHOSE EACH RED WAS

`run_tests.py --only fight_stage,fight_world,fight_clip,fight_pair,fight_knockdown` — **24 tests, 3 failures, and all
three were already failing at `b5c24d35`**: `fight_pair_live` and `fight_stage_presenter_contract` are red ON PURPOSE
while the jab pair is parked (operator ruling 2026-09-15), and `fight_stage_realism` fails identically on master, as
the 300/5 digest at `c4403a7f` already recorded.

`fight_stage_realism` now carries its own A/B arm (`positions=off`). Run both ways it returns **the same 7 failures of
13 rules, rule for rule**: no gated rule moved from PASS to FAIL or from FAIL to PASS. Two of its numbers moved and
both are reported rather than gated:

1. **R7 `bodies_never_pass_through`: violating share 8.9% → 25.3%** over three seeds and 19,802 frames each, and
   `torso=torso` enters its top violating class pairs, which it never did before. This is not a regression in the
   room — it is OPEN 1 becoming visible.
2. **R3's walk buckets are now eight roles instead of two**, `loc_strafe_right` the largest at 17,888 frames. The mean
   skate is unmoved in the arm-vs-arm comparison; the rule was failing before and fails now.

The authored pairs got WORSE and that is also a finding rather than a defect: **played 8 of 24 → 2 of 24, out of range
12 → 19.** The two `.pair.json` files are authored for a gap window of 1.017–1.258 m, and with the band table the men
stood at exactly 1.07, 1.23 or 1.39, so the window was hit by construction. Against real distances the throws happen
at 0.299, 0.381, 0.390, 0.916, 0.918, 0.993, 1.014, 1.084, 1.332, 1.652 and 1.743 m. **The pair method is UNVALIDATED,
not disproved** — this is exactly the input step 4's verdict needs, and authoring more pairs stays gated on it.

## OPEN

1. **THE ENGINE HAS NO BODY RADIUS.** `RingSpace.step` clamps a man to the ropes and nothing at all stops the two of
   them standing on the same floor. **2.3% of frames (one round) / 1.3% (three rounds) put the two men closer than
   0.364 m** — the sum of f01's and f09's own widest torso capsule radii, measured from their skin weights by
   `FightBodyCapsules`, so it is not a figure anybody chose. It was invisible for as long as the room ignored the
   engine, because the band table's smallest distance was 1.07 m. **ITS OWN SLICE — it is an engine change and every
   seeded pin in the project moves with it.** `S4-2-1` in `tests/fight_room_positions_test.gd` is a LIVE TRIPWIRE that
   prints the share every run, the same shape as S4E6-7, and goes to zero the day the radius lands.
2. **THE TURN RATE HAS NO STUDY.** The room now shows `FightBearing.turn_rate`'s authored 240 deg/s base and the
   measurement reads p50 9.7, p90 59.2, max 272.9 deg/s. **TASK_U109 is the assigned research** — the shoulder-line
   normal in the 17 MediaPipe tracks IS the facing, so a yaw rate falls straight out of the same pass. It is written
   and unlaunched because it needs the PC.
3. **THERE IS NO MEASURING BOUNCE AND NO RESET STEP IN THE PACK.** See above. Until one exists the phase word cannot
   pick a clip, and buying or authoring one is its own slice.
4. **THE STEP SHAPE IS STILL AN ISOTROPIC COMPASS WANDER**, carried untouched from S4e (6). K31's act-on line refuses
   forward/back/lateral shares in as many words, so the room now DRAWS an unbounded wander faithfully rather than
   hiding it on one line. TASK_U109 is the instrument for this too.
5. **THE AUTHORED PAIR WINDOW IS 0.24 m WIDE** and was authored against a room with three distances. Step 4 takes the
   verdict; do not re-author before it.

## Re-running it

```
godot --headless --path Godot --script tests/fight_room_positions_test.gd
godot --headless --path Godot --script tools/measure_room_positions.gd -- seeds=1 rounds=3 arm=both
godot --headless --path Godot --script tools/measure_room_positions.gd -- seeds=1 rounds=3 arm=on debug
godot --headless --path Godot --script tests/fight_stage_realism_test.gd -- positions=off
```

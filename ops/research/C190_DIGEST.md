# C190 — native strike timing, bounded placement, and recovery queue

2026-09-24. Codex / gpt-6-astra / medium. Branch `codex/c190-strikes-whole`.
Original baseline `46cab5a8`, including C187 and U158. Salvaged as `6263a6eb`;
continuation merged master `358d1712`. Work stayed in the C190 worktree.

## Status

**Experimental implementation; default OFF. The full visual/contact and J20
acceptance target is NOT met.** Timing, interruption protection, queue occurrence,
and bounded placement are tested. The comparison is supplied for the operator's
eye; passing those tests does not certify that every landed strike reaches its
target. Nearest-clip target-height mismatches and statistical gaps remain below.

## Changes

- `configure({"strikes_play_whole": true})` controls C190. OFF keeps
  the existing binding windows, placement, scheduling, randomness and clamps.
- ON retargets complete strike source windows with horizontal pelvis motion,
  starts at zero at speed 1, and protects playback through the clip end. End is
  the conservative recovery tag; no earlier return-to-guard tag is invented.
- During commitment, the strike owns the legs and pelvis. Walk splicing, foot
  locking, strike arm IK and the 12 m/s hand clamp do not rewrite it. Existing
  pose joins and floor/boundary safeguards still apply.
- The strike origin is held while its source pelvis/root motion plays. A
  smooth translation warp is limited to 0.4 m and yaw to 30 degrees. It tracks
  the opponent until contact and then holds. Knees use the knee, low kicks aim
  at the actual thigh segment, torso shots at Chest, and head shots at Head.
  Misses receive no contact translation. The simulation's movement takes back
  control continuously at up to 1.5 m/s and 120 degrees/s after recovery.
- Locomotion joins now relinquish stale plant targets when the gait changes.
  Their outgoing pose includes the leg IK actually displayed. Returning yaw
  ownership also eases instead of snapping. These changes are ON-only.
- `FightRealtime` retains a granted throw opportunity while its fighter is
  recovering. Selection and outcome stay in the existing engine. An accepted
  queued opportunity is not subjected to the chance gate again at recovery.
  It is one pending opportunity per fighter, not an unlimited strike backlog.
- The room presents the hit/readout/audio at the measured contact offset after
  the request tick. The simulation still computes the outcome in advance.
  U159's independent `reactions_play_whole` switch owns reaction entry at its
  measured first motion, tempo 1.0, and queue pricing for the remaining take.
  C190's duplicate source-track trim was removed after the merge. Strikes ON
  does not silently enable reactions ON; both switches remain default OFF.
  With both ON, C190 schedules the receiver at the strike's contact, then U159
  enters/prices the reaction. The strike recovery guard still rejects a
  reaction that would interrupt that same body's committed strike.

No selection weights, damage equations or anchors were changed. `FightBodyLayers`
needed no edit: the ownership/join defect was in its caller. No clips were bought.

## Step 0 and motion evidence

C189's same boxing seed 92012, 60 Hz, live 1.0–13.5 s, 751 poses. Peak world m/s,
including joins. The refreshed OFF baseline was measured before production edits.

| Arm | Ankle A / B | Hips A / B | Ankle frames >25 A / B |
|---|---:|---:|---:|
| C189 original D, before C187/U158 | 52.784 / 75.191 | 27.136 / 33.060 | 6 / 5 |
| Current D, engine positions ON | 31.796 / 34.834 | 6.401 / 7.848 | 5 / 4 |
| Only body_layers OFF | 9.603 / 9.348 | 4.734 / 4.096 | 0 / 0 |
| Only engine_positions OFF | 5.574 / 6.672 | 3.365 / 3.564 | 0 / 0 |
| C190 ON, post-merge; reactions OFF | 7.021 / 8.237 | 3.165 / 3.330 | 0 / 0 |
| C190 ON, post-merge; reactions ON | 5.544 / 7.628 | 3.165 / 3.330 | 0 / 0 |
| C189 A, whole f01 control | 6.615 | 3.139 | 0 |

The ON ankle peaks remain above control A (6.615 m/s): the motion target is
not fully met. Hips are close to, but also above, its 3.139 m/s control.
No speed threshold was changed to obtain these measurements.

The final queue changes the fight sequence, so its ON/OFF motion comparison is
not a one-factor pose experiment. The two supplements above are one-factor runs.
The comparison does not establish exact equality with C189 A's six-clip playlist.

Writer tracing found concrete extra jumps at ownership changes: returning engine
yaw moved a foot before animation sampling; a new gait's foot lock pulled toward
the previous gait's world plant. Neither requires slowing the captured clip.

The MMA film contains native kicks absent from C189 A. A separate native-source
60 Hz check found axe-kick ankle **27.487 m/s**, low-kick ankle **29.915 m/s**;
their source pelvis peaks are **3.824 / 4.868 m/s**. Thus the diagnostic 25 m/s
foot threshold cannot be treated as a universal native-motion cap. These are
`H2H_AxeKick_InPlace` and `H2H_RightCutKick_InPlace`, not an invented exemption.
`H2H_HitReaction04` itself peaks at **6.567 m/s** at the ankle.

## Measured phases and contact limits

Q167's corrected `clip_phases.json` arrived in the merge and was read afresh:
124 clips, **20 NO_RETURN**, hand-effector wind-up median **0.10 s**. The
previous foot-selected punch tags and 41 NO_RETURN count are not used.

The salvaged implementation still does **not consume Q167's tags**. It measures contact
from the retargeted clip at 30 Hz using the existing geometric contact estimator;
this is an **inference**, not an authored impact marker. Start is zero for strikes,
recovery is source end. For f01:

| Role | Contact s | Recover s |
|---|---:|---:|
| jab | .233333 | .833333 |
| cross | .300000 | .833333 |
| hook_lead | .333333 | 1.000000 |
| kickboxing_roundhouse | .266667 | .700000 |
| kickboxing_body_kick | .266667 | .700000 |
| kickboxing_low_kick | .566667 | 1.000000 |

Reaction entry now comes only from U159's `_derive_first_keyed` / motion
measurement on the bound take. C190 no longer crops reaction source windows.
Enable `reactions_play_whole` to skip their lead-ins; with that switch OFF the
legacy reaction behaviour remains. Adopting Q167 strike tags and checking the
resulting contact/binding choices is still part of the unfulfilled acceptance
work, not a claim made by this delivery.

On the final 60 s MMA seed, 14 sampled landed contacts have native contact-point
to target-centre distance **median .306 m, max .517 m**; **5/14** reach the .4 m
translation cap. This is a geometric residual, not mesh penetration or a glove
surface contact test. A target surface was approximated 0.15 m outside its centre.
The largest residuals include a head knee, a head axe kick and a combination.
Some engine target/nearest-clip assignments demand a height or reach absent from
that film. A bounded horizontal warp cannot manufacture that pose while retaining
the native full-body performance. This part of the operator's gate remains open.

## Statistics: 20 MMA and 20 boxing bouts per arm

Seeds **92012–92031**, three rounds, R133's differentiated grappler/striker for MMA
and the room's differentiated boxing pair. Same seed set OFF/ON; these are paired
seed samples, not identical fighters. No selection/damage fitting to these seeds.

Rates combine both fighters and divide by total **active round minutes**. Rest
minutes and feints are excluded. Landed means clean/glancing/absorbed. Significant
uses the engine event's `significant` flag; in this sample its counts equal total
strikes. Leg share below is landed significant strikes aimed at a leg, not all
techniques using a foot. This is a small, single-matchup population, not validation
of the full division/sex distributions required by J20.

| Metric | MMA OFF | MMA ON | J20 MMA anchor |
|---|---:|---:|---|
| Attempts / active min, combined | 18.901 | 17.353 | Compare via landed pace and accuracy; no single universal attempt anchor |
| Landed / active min, combined | 10.582 | 9.643 | Approximately 6–8 |
| Accuracy | 55.99% | 55.57% | Approximately 40–49% |
| Knockdowns / bout | .05 | .35 | Approximately .41–.52 in men's divisions |
| Landed significant leg share | 5.565% | 6.814% | Approximately 14–18% |
| Decisions | 5/20 (25%) | 7/20 (35%) | All-time ~47%; modern ~51.1% |
| KO/TKO | 6/20 (30%) | 10/20 (50%) | All-time ~33%; modern ~31.7% |
| Submissions | 9/20 (45%) | 3/20 (15%) | All-time ~19%; modern ~17.2% |

| Metric | Boxing OFF | Boxing ON | J20 boxing comparison |
|---|---:|---:|---|
| Attempts / active min, combined | 17.204 | 17.095 | 320-fight sample 37.6/fighter/round ≈25.07 combined/min |
| Landed / active min, combined | 8.872 | 8.990 | 34.6% connect in that sample ≈8.67 combined/min |
| Knockdowns / bout | .20 | .05 | J20: league-wide CompuBox mean NOT FOUND |
| Landed leg share | 0% | 0% | Boxing does not allow leg strikes |
| Decisions / finishes | 16 / 4 | 15 / 5 | Population/era conditioning required; no matched universal target |

The accepted-opportunity queue corrected a real rate loss: its first draft re-rolled
the throw gate at recovery (boxing attempts were 14.998/min). Retaining the already
accepted opportunity restores 17.095/min without changing clip speed.

**Calibration is incomplete.** MMA KO/TKO share moves away from its anchor in
these 20 bouts, and boxing attempt/landed rates move slightly away from the quoted
sample. Other MMA columns improve but still miss their bands. It would be false
to label this calibrated, or to fit damage/finish probabilities to 20 seeds and
call that selection work. Task ownership restricts FightRealtime edits to the
recovery queue; the broader selection/binding fit needed here is not shipped.

## Gates and compatibility

- Post-merge parse: **20 scripts / 0 failures**, covering every merged or owned
  `.gd`. Changed test/tool and all three refreshed mutant scripts also parse.
- `fight_strike_whole_test`: **6,890 checks / 0 failures** on final playback,
  including actual queue occurrence, six real strike clips, 60 s live MMA with
  strikes alone and another 60 s with both switches ON. All four switch
  combinations assert room propagation, actual strike speed/entry, actual
  reaction occurrence, U159 entry and remaining-clip queue price.
- `fight_reaction_whole_test`: **13 checks / 0 failures**.
- Three runtime mutants: restoring entry seek **90 failures**, restoring speed
  scaling **42**, removing the recovery guard **553**. All exit 1 with assertion
  failures, not parse/runtime errors. Production files are never mutated on disk.
- OFF room: exact equality of all **751 poses and event entries** with the
  pre-edit D capture. OFF engine: boxing and MMA 180 s event logs and verdicts
  match independent execution of master `358d1712`'s unmodified engine,
  byte-for-byte. The boxing hash was refreshed only after that equality was
  observed: S66 added knockdown fields to round cards. No fields are filtered.
  Boxing `264455a0dcf2612f9d4a7c9e0110432f9246f86b8d8c708b32067751e0fe44e4`;
  MMA `368f6456aea9542e8f53926a586ead680491b08fde16fec08e25f9f2655d2dad`.
  The retained 60 s OFF film also matches all **1,801** post-merge poses exactly.
- Requested focused families, one `--only` per invocation:
  `fight_stage`: **SUITE total=10 fails=1** (only `fight_stage_realism_test`,
  the eight documented failed rules R1/R2/R3/R4/R5/R5b/R7/R8);
  `fight_world`: **SUITE total=4 fails=0**;
  `fight_realtime`: **SUITE total=1 fails=0**. No other red; no full suite.
  These final counters come from this run, not the salvaged draft's log.
  The runner resolved Godot through PATH; its 4.7.2 binary and the supplied
  installation have identical SHA-256 hashes.
- Existing shutdown ObjectDB leak warnings remain; no leak-free claim.

## Media and reproduction

- `_captures/watch_loop/c190_strikes_whole_ab.mp4`: seed 92012, MMA, 60 s,
  1280×720, 30 fps, OFF | ON, same fixed camera.
- `_captures/watch_loop/c190_strikes_whole_closeups.mp4`: three punches (jab,
  lead hook, rear hook) and three kicks (body, low, axe), each OFF | ON.
  These pair the same technique at explicitly labelled **different live times**,
  because the queue changes the event sequence. They are not synchronized blows.
- `_captures/watch_loop/c190_strikes_whole_sheet.png`: six comparison stills.
- Final camera: `(3.4,5.0,6.0)`, target `(0,2.1,0)`, FOV 48. Follow, hit cam and
  walkout disabled in both arms. A one-second warm-up precedes the 60 s film.
  Recordings use the game's real rendered scene; no generated fighter imagery.

Opened both the refreshed six-technique sheet and the 12-frame A/B contact
sheet. The ON poses retain full-body strike extensions, but these stills do not
prove smooth timing or contact. Several wide-camera moments put fighters near
the foreground edge; the film is an honest fixed-camera comparison, not visual
acceptance. Close-up pairings are different moments and can be different sides.
A/B: **3,389,339 bytes**, 60 s, 1280x720/30 fps; close-ups: **1,910,027 bytes**,
18 s, 1280x720/30 fps. Both are below 50 MB.

The ON source film was re-recorded after removing C190's duplicate reaction trim;
OFF was retained only after exact pose comparison above. `reactions_play_whole`
is **OFF in both filmed arms**, as labelled on the A/B. The separate four-way
test establishes switch composition; the film makes no both-ON visual claim.
`_captures/watch_loop/c190_strikes_whole_ab_sheet.png` is the opened A/B sheet.

After the one-time fresh-worktree import, the owned tool reproduces the raw
measurements and source movies. All windowed runs use the required launcher:

```powershell
python Godot/tools/check_scripts.py Godot/scripts/FightStagePlayer.gd Godot/scripts/FightWorldLiveScreen.gd Godot/scripts/FightRealtime.gd Godot/tests/fight_strike_whole_test.gd Godot/tools/c190_strike_stats.gd
& "$env:LOCALAPPDATA\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/fight_strike_whole_test.gd
& "$env:LOCALAPPDATA\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tools/c190_strike_stats.gd -- mode=stats whole=true
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/c190_strike_stats.gd --fixed-fps 30 --write-movie .godot/c190/off.avi -- whole=false out=off
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/c190_strike_stats.gd --fixed-fps 30 --write-movie .godot/c190/on.avi -- whole=true out=on
& "$env:LOCALAPPDATA\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/fight_reaction_whole_test.gd
python Godot/tools/run_tests.py --only fight_stage
python Godot/tools/run_tests.py --only fight_world
python Godot/tools/run_tests.py --only fight_realtime
```

For the both-ON row add `reactions=true`; the default is false.
Headless probe options: `discipline=boxing fps=60 seconds=12.5 whole=true out=on_boxing`.
`writers=true` records intermediate pose writers. Results go to `.godot/c190`.
The baseline supplements use the unchanged `tools/c189_clip_whole.gd` with
`arm=D`, `D_no_layers`, `D_no_engine`, 60 fps, 12.5 s.

The task's no-HANDOFF rule supersedes the general HANDOFF-block rule. The continuation
read/merge instructions supersede the generic startup rebase and broad brief.
Master was merged, including U159 and corrected Q167; none of master was dropped. Import-generated `.import`/UID noise is excluded from the commit. Only
owned sources, test/tool, media, this digest and C190 mail files are staged.

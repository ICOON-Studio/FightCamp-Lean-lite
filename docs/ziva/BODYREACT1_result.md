# TASK_BODYREACT1 - every landed body shot visibly hurts (Ziva, S371)

Operator S369, watching the Tess vs Amy preview: **"hits on body still show no reaction from the other fighter."**

Branch `ziva/bodyreact1` off `origin/main` `69ddbbd`. Fix + probe + films commit **`27810510`**. Both runs below are
pasted from the run's own log; same probe file (`tools/body_react_probe.gd`, `27810510`) and the same command:

```
<godot 4.7.2> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/body_react_probe.gd -- show3d
```

BEFORE is the game at `69ddbbd` (the three fight scripts exactly as origin/main has them), AFTER is `27810510`. The
flow drew the same fight both times - Lucy Jackson vs Maria Ortega, day 33, three rounds, the shout bar aimed at the
body every exchange: the rows at t=1.56, 12.79, 52.53, 61.61 match one for one.

## What the probe measures

Three LIVE rounds of fight night, driven through the house flow (`tools/fight3d_play.gd`'s path: fresh career ->
fight night -> Begin fight, the intro skipped to the bell, the corner minute between rounds), then every landed body
shot is measured **on the bodies as shown**: the reaction clip the woman who took it played
(`AnimationPlayer.animation_started`), her trunk curl in degrees at its deepest (hips->chest axis against its pose at
the contact), the time from contact to the first visible move (trunk >= 2 deg or a bone >= 3 cm), how long the fold
stayed on her (first frame the trunk passes 9 deg, half the bar, to the last) and her hips' backward travel.

The contacts are the game's own record - `FightStage.hit_gaps` (`PunchRange.record` inside `HitImpact.hit`) - so a
punch the viewer saw land is a line here even when the ring showed nothing. A punch the game cut off before its
contact showed neither punch nor reaction: the probe reports it as `BODYREACT_NOT_SHOWN` and leaves it unscored
(the `tools/hit_gap_probe.gd` convention). Bars (S370, never loosened): every SHOWN body shot reacts, curl >= 18 deg,
first move <= 0.15 s (research G147), fold held >= 0.35 s; fewer than 6 shown = VOID.

The probe's pose readings come from `tools/pose_tap.gd` armed as the **last** modifier in each boxer's stack, so curl
is measured on what the viewer sees, not on the raw clip.

## BEFORE - game at `69ddbbd` (trace: the run of 2026-11-03 00:47, the probe as first written)

The first instrument scored a cut-off punch as FAIL (`react=NONE(cut off)` - no clip in the window at all); rows are
quoted exactly:

```
BODYREACT check start: Lucy Jackson vs Maria Ortega, 3 rounds, film=false
BODYREACT r1 t=  1.56 v0 body_hook (punch pro_body_shot) react=pro_hit_by_kidneyshot_v1 | curl=16.3deg first=0.03s held=0.57s hips=+0.00m | FAIL
BODYREACT r1 t= 12.79 v1 body_hook (punch pro_body_shot) react=pro_hit_by_gutshot_v3 | curl=42.7deg first=0.07s held=0.57s hips=+0.00m | OK
BODYREACT r1 t= 39.27 v0 body_hook (punch ) react=NONE(cut off) | curl=20.8deg first=0.03s held=1.17s hips=+0.00m | FAIL
BODYREACT r1 t= 46.57 v1 body_hook (punch pro_body_shot) react=pro_hit_by_gutshot_v2_short | curl=27.2deg first=0.07s held=0.47s hips=-0.00m | OK
BODYREACT r1 t= 52.53 v1 body_hook (punch pro_body_shot) react=pro_hit_by_kidneyshot_v1 | curl=16.3deg first=0.07s held=0.53s hips=+0.33m | FAIL
BODYREACT r1 t= 61.61 v1 body_hook (punch ) react=NONE(cut off) | curl=8.7deg first=0.07s held=0.00s hips=+0.00m | FAIL
BODYREACT r1 t= 62.31 v1 body_hook (punch ) react=pro_idle | curl=19.1deg first=0.03s held=0.40s hips=+0.00m | OK
BODYREACT r1 t= 72.21 v0 body_hook (punch pro_body_shot) react=pro_hit_by_kidneyshot_v1 | curl=16.3deg first=0.03s held=0.57s hips=-0.07m | FAIL
BODYREACT r1 t= 82.39 v1 body_hook (punch pro_body_shot) react=pro_hit_by_gutshot_v2_short | curl=43.1deg first=0.03s held=1.27s hips=-0.02m | OK
BODYREACT_SUMMARY shots=42 of 128 landed (42 body, bar 6)   measured
BODYREACT_SUMMARY react  33/42 played a reaction (bar: none)          FAIL
BODYREACT_SUMMARY curl   deepest 1.1 deg (bar 18)                   FAIL
BODYREACT_SUMMARY first  slowest 0.73 s (bar 0.15)                    FAIL
BODYREACT_SUMMARY held   shortest 0.00 s (bar 0.35)                   FAIL
BODYREACT_SUMMARY FAIL
```

The operator's "no reaction" is all over those rows: 10 shots showed no reaction clip at all (the `NONE(cut off)`
rows), every kidney take read 10.3-16.3 deg of trunk against the 18 deg bar (6 of its 8, one at 10.3), one take
counted as reacted while the woman was simply standing in `pro_idle`, and the run's worst single reading was 1.1 deg.

## The cuts, caught: 14 of the 42 landed body shots never arrived

The second run of the same pre-fix tree (01:45, probe + flier diagnostics) closed the file on the biggest miss:

```
BODYREACT found 42 landed body shots in 3 rounds (14 cut off before they arrived)
  flier: the hitter played [pro_left_jab@-11f, pro_body_shot@-10f, pro_left_hook_v2@+0f] while the punch was in flight
  flier: the hitter played [pro_body_shot@-1f, pro_left_hook_hurt@+0f] while the punch was in flight
```

A body hook flies 0.40 s while the same boxer's next beat can arrive 0.35 s after hers (the combo gap): her follow-up
punch started 1-2 frames before her own body hook landed and **replaced its clip** (`PunchRange.cut_off`) - no hit, no
reaction, no fold. On the flier rows above she flips `pro_body_shot` -> her next strike on the very contact frame.

## AFTER - `27810510`

```
BODYREACT check start: Lucy Jackson vs Maria Ortega, 3 rounds, film=false
BODYREACT r1 t=  1.56 v0 body_hook (punch pro_body_shot) react=pro_hit_by_gutshot_v2 | curl=34.4deg first=0.03s held=0.60s hips=+0.00m | OK
BODYREACT r1 t= 12.79 v1 body_hook (punch pro_body_shot) react=pro_hit_by_gutshot_v3 | curl=36.6deg first=0.07s held=0.93s hips=+0.00m | OK
BODYREACT r1 t= 39.54 v0 body_hook (punch pro_body_shot) react=pro_hit_by_gutshot_v3 | curl=46.6deg first=0.07s held=1.33s hips=+0.01m | OK
BODYREACT r1 t= 46.57 v1 body_hook (punch pro_body_shot) react=pro_hit_by_gutshot_v2_short | curl=33.8deg first=0.03s held=1.30s hips=+0.06m | OK
BODYREACT r1 t= 52.53 v1 body_hook (punch pro_body_shot) react=pro_hit_by_gutshot_v2 | curl=35.3deg first=0.03s held=0.70s hips=+0.25m | OK
BODYREACT r1 t= 61.61 v1 body_hook (punch pro_body_shot) react=pro_hit_by_gutshot_v2_short | curl=41.8deg first=0.03s held=0.90s hips=+0.00m | OK
  round 1: 43 landed hits, 16 of them to the body
  round 2: 42 landed hits, 11 of them to the body
  round 3: 43 landed hits, 15 of them to the body
BODYREACT_NOT_SHOWN r2 t=352.31 v1 body_hook: cut off before its contact - the hitter played [pro_left_uppercut@-13f, pro_body_shot@-12f, pro_hit_by_gutshot_v3@-9f]; no hit, no reaction showed
BODYREACT_NOT_SHOWN r3 t=509.93 v1 body_hook: cut off before its contact - the hitter played [pro_idle@-13f, mc_to_block@-12f]; no hit, no reaction showed
BODYREACT_SUMMARY shots=40 of 128 landed (42 body, 2 cut off before they showed, bar 6)   measured
BODYREACT_SUMMARY react  40/40 played a reaction (bar: none)          OK
BODYREACT_SUMMARY curl   worst 22.7 deg (bar 18)                   OK
BODYREACT_SUMMARY first  slowest 0.07 s (bar 0.15)                    OK
BODYREACT_SUMMARY held   shortest 0.47 s (bar 0.35)                   OK
BODYREACT_SUMMARY PASS
```

The two `NOT_SHOWN` rows are the honest residue: the game cut those beats off (one is a genuine pull: the owner went
`pro_idle` -> `mc_to_block` in flight), no punch or reaction showed, and they are not scored either way. The 14 cuts
of the red run are down to 2 because the own-punch wait lets the body hook finally land.

## Acceptance, from those two runs

| gate (S370, never loosened) | BEFORE `69ddbbd` | AFTER `27810510` | verdict |
|---|---|---|---|
| every SHOWN body shot reacts | 33/42 (10 showed nothing) | **40/40** | PASS |
| trunk curl at the deepest | 1.1 deg | **22.7 deg** (bar 18) | PASS |
| time to the first visible move | 0.73 s | **0.07 s** (bar 0.15) | PASS |
| fold held | 0.00 s | **0.47 s** (bar 0.35) | PASS |
| body shots on the game's record | 42 of 128 landed | 42 of 128 landed (40 shown, 2 cut off reported) | PASS (>= 6) |

## The three changes (all in `27810510`)

1. **`scripts/fight3d/BeatFire.gd` - SAME-BOXER DELAY.** A new beat that would replace HER OWN still-flying punch
   waits for it to land (`base := maxf(t, float(last_contact[who]) + 0.03)`; the punch block runs as a `go` callable,
   immediately or on a timer, and every timer runs off `base` so the contact stays on her glove). This is the fix for
   the 14 cuts.
2. **`scripts/fight3d/BeatFire.gd` - FOLD-WAIT.** With fix 1 in, a new beat could still fire beside her own fresh
   body-shot fold and cut the hold short: the probe read `held` 0.17 s, then 0.27 s against the 0.35 bar (runs
   `/tmp/bodyreact_green.log`, `green2`), 0.47 s after the wait went in (`green3` and after). Only a FOLD waits
   (HitSnap gain > 1.5, `_bt` < 0.51 = BRACE_RISE_S 0.06 + FOLD_HOLD_S 0.45); a head reaction is untouched.
3. **`scripts/fight3d/BeatClips.gd` + `scripts/fight3d/HitSnap.gd` - the readable takes.** The kidney reaction take
   leaves the `body_hook` rotation (its own arch fights the fold: 4.7 -> 12.7 deg of trunk on the same bodies against
   gutshot_v3's 16.0 -> 28.4, and 6 of its 8 takes in the fight probe read 10.3-16.3 deg against the 18 bar);
   FOLD_GAIN 2.6 -> 3.0 (at 2.6 the landed fold added only ~8-12 deg on top of the take's own arch - one weak take
   from the bar). The kidney PUNCH clip `pro_kidney_shot` stays; only its reaction take is retired. `react_body`
   stays as the old library's fallback.

## The films (before/after, same round)

`docs/playtest/BODYREACT1/round1_before.mp4` and `round1_after.mp4` - round 1 of the same pairing, 1280x720, 30 FPS,
2784 frames (92.8 s): the round itself runs recording frames 10..2783 (bell); the file keeps the whole recording,
including the 10 frames before it. Captured windowed on the hidden desktop
(`E:/FightCamp/Lean/tools/hidden_desktop.py run ... --write-movie`) and converted to mp4 from the raw
`--write-movie` files (both `*.avi` were ~390 MB and are not committed; the run logs are: `round1_before_run.log`,
`round1_after_run.log`).

The still pair at 39 s is the operator's bug and the cure side by side: `sheet_before_39s.png` (both boxers upright
through the whole window - blue hooks, red just guards) and `sheet_after_39s.png` (red bowing at the waist 3-4
frames, striking over her own guard-free chest, then recovering; blue stays upright - she threw it).

## Regression tests (after the fix, final files)

```
tests/beat_clips_test     BEATCLIPS failures=0
tests/fight_flow_test     PASS fight_flow_test
tests/golden_path_test    GOLDEN_PATH failures=0
tests/fight_feel_test     FIGHT_FEEL failures=0   (incl. "follow-ups are marked combo", "every combo follow-up
                                                   starts 0.35 s after the punch before it, by the same boxer")
tools/move_player_probe   30 moves, 0 missing clips
```

Run per the house contract (`godot --headless --audio-driver Dummy --path . --script res://tests/<t>.gd`; the generic
`run_tests` tool does not drive these SceneTree scripts).

## Notes for the next round

- **The bars print on the same line as the instrument's counts.** A cut punch is `BODYREACT_NOT_SHOWN` and unscored;
  if fewer than 6 shots show, the run is VOID and every gate FAILs. Do not loosen the bars - fix the game.
- **On a NOT_SHOWN row the flier trace is the evidence, not the victim id.** With no `land_f` and the reach disarmed,
  `_hitter()`'s fallback can resolve the row to the wrong side; read `[clip@+Nf]` in the flier line to see what
  replaced the still-flying punch.
- **`animation_started` fires on restarts**, not only on changes, and a guard/fidget restart can land on the very
  same frame as the reaction: the probe takes the first REAL reaction start in the contact window
  (`pro_hit_by_`/`mc_hit_`/`react_`), not the nearest start.
- **`held` = the first frame the trunk passes 9 deg to the last**, not the longest continuous run above 9 deg (a
  twitch inside a fold is still a fold).
- **The "asked" number in the shot line is HitSnap's own estimate** (`fold asked` = the fold it will add); the SHOWN
  deepest is what the body did. Trust SHOWN.
- **The career drive can flake** (an empty modal after `fightnight`): the probe now prints its drive state and fails
  loudly (`BODYREACT_FAIL`) instead of filming an empty ring; on the film runs a stale editor parse can also blank a
  take - re-run rather than diagnose from one bad film.
- **Film runs are expensive** (~5:20 for 92 s at 28-29% real-time on the hidden desktop) and the raw `--write-movie`
  `.avi` is ~390 MB per round: trim to mp4 immediately and never commit the avi.
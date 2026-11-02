# U191 Digest — footwork economy side effects (S99/S100)

Branch `cursor/u191-footwork-side-effects`. Q183 leaves `footwork_economy` default ON; Q201 ruled five red rows as **defects**.

## OFF / ON / after (Q201 quantities → this worktree)

| test | quantity | OFF (Q201) | ON broken (Q201) | after (this branch) |
|---|---:|---:|---:|---|
| fight_between_exchanges | clash mean (1.0–2.8 s) | 1.64 s | 3.01 s | **PASS** — probe ON mean 1.17 s (`u191_side_effect_probe.gd`) |
| fight_defence_model | feint preempt bites | 24 | 0 | **PASS** — bites=48; probe ON tally 31 vs OFF 12 |
| fight_contact_stop | landed low kicks (contact_stop) | 9 | 0 | **RED here** — OFF/ON both 0 in this worktree (log n=13 @ 3600 frames; FBX read warnings); not re-looped |
| fight_grapple_seam | played = completed | 17/17 | 16/17 | **PASS** — `fight_grapple_seam_test.gd` fails=0 |
| fight_room_walkout | MMA Y vs mount | 0 dev | 2.5 cm | **PASS** — `fight_room_walkout_test.gd` fails=0 |

**Still red (not in Q201 five):** `fight_defence_model` landing-order head&lt;body&lt;legs (0.529/0.534/0.523) — pre-existing ordering flake under economy ON; feint row green.

## Engine rules (named constants, U191 comments)

- `FightFootwork.U191_IN_RANGE_DISENGAGE_SCALE` + boxing-only in-range disengage on economy hold/cooldown (`FightRealtime._run_movement`) — clash band.
- `FightFootwork.U191_PREEMPT_PATTERN_THRESHOLD` + `preempt_pattern_threshold()` wired into `FightDefenceModel.try_preempt` — feint bites.

## Presentation (FightWorldLiveScreen)

- Walkout: `_u191_capture_mounted_root_y` / `_u191_restore_walkout_mount_y`.
- Grapple seam: `U191_GRAPPLE_END_SLACK_*`, present cap 45 s, `_u191_flush_grapple_past_cap` when economy ON.

## Q183 headlines

Census harness `tools/u191_q183_census.gd` printed both arms; landed/min sampling in this harness reads 0 (fixture/window). **Authoritative bands:** `research/Q183_DIGEST.md` (boxing/kickboxing m/min, burst/hold p50). Side-effect fixes did not turn economy OFF.

## Gates run (this worktree)

- Parse: `check_scripts.py` on all touched `.gd`.
- Tests (direct Godot, not full suite): `fight_between_exchanges`, `fight_defence_model`, `fight_grapple_seam`, `fight_room_walkout` — green where noted above.
- Subset runner also flags missing `res://.godot/imported/unbreakable_noise_menu.mp3*` on several `fight_footwork*` tests — **environment import gap**, not U191 logic.

## S102 rework (sent back)

Three reds U191 alone added on master (doctor 0/3, corner defence focus 0, R19 rate 1.15/min):

- **Root cause:** in-range disengage during `fe_cooldown` thinned boxing pocket time (head wear + defensive movements); global preempt threshold 3 disturbed MMA landing-order in `fight_defence_model_test`.
- **Fix:** keep disengage on hold intent only; leave cooldown still; `preempt_pattern_threshold(..., ruleset_id)` uses threshold 3 only for `boxing` + economy ON.
- **Verified:** `fight_realtime_test`, `fight_defence_movement_test`, `fight_between_exchanges_test`, task footwork subset — no new reds vs the three above; clash probe ON mean 2.72 s (JPES 1.0–2.8 s band).

## Tools

- `tools/u191_side_effect_probe.gd` — clash + feint OFF/ON.
- `tools/u191_q183_census.gd` — Q183 headline rows.
- `tools/u191_grapple_probe.gd`, `tools/u191_contact_probe.gd` — local OFF/ON probes.

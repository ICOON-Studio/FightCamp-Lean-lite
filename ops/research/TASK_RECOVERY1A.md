# TASK RECOVERY1A (S216) - two pure modules: RecoveryRate and CutResistance (+ tests). No engine wiring.

Model: cloud Cursor (composer-2.5, `.github/workflows/cloud-agent.yml`, label `cursor`). Repo ICOON-Studio/FightCamp, branch from master,
own branch + PR, never merge. No `.import` / `.uid` files. No LFS-loading tests.

## Why (operator-approved S216, board Q-S212-7, Ludo round 49 - `LUDO_ROUND49_VERDICT_S216.md`)
Two new player-facing readouts: RECOVERY RATE (how fast a boxer's wind comes back in the corner and in a round) and CUT & SWELL
RESISTANCE (how easily his face cuts, shown from the scar tissue we already track). This task is ONLY the pure maths + words + scouting
ranges. Engine wiring is RECOVERY1B, UI is RECOVERY1C - do not touch FightStamina.gd, FightRealtime.gd, CutsDoctor.gd, Cardio.gd or any screen.

## Facts about the code (read, do not change)
- `Godot/scripts/FightStamina.gd` (159 lines): `_recover_scale(conditioning) = conditioning / 50` (so conditioning 50 -> 1.0, 100 -> 2.0).
  `rest_recovery` and `in_round_recovery` multiply by it. Heart rate (`Cardio.gd`) is READ from the stamina tank (`from_stamina`), it is not
  its own decaying value - so Recovery Rate will later multiply `_recover_scale`, and the heart rate follows.
- `Godot/scripts/CutsDoctor.gd` (175 lines): `static func scar_cut_mult(level: int) -> float` (>= 1.0 for a scarred face; reads
  a JSON table - open the file, `sed -n 1,60p` and 140-175, find TABLE_PATH and the scar levels), `scar_start_pips(level)`.
- Style: statics only, `extends RefCounted`, NaN/INF guarded, typed. Copy `Godot/scripts/Cardio.gd` (122 lines) for tone and guards, and
  `Godot/tests/cardio_test.gd` for the test shape (`PASS`/`FAIL` lines, `quit(1)` on any FAIL).

## Owned files (all NEW)
- `Godot/scripts/RecoveryRate.gd`, `Godot/tests/recovery_rate_test.gd`
- `Godot/scripts/CutResistance.gd`, `Godot/tests/cut_resistance_test.gd`

## RecoveryRate.gd - exact contract (design values are AUTHORED, say so in the file header; tests bound them, never gate exact counts)
- `const NEUTRAL := 50.0`
- `static func generate(conditioning: float, age_years: float, personal: float) -> float`: `personal` in [-1, 1] is supplied by the caller
  (a deterministic per-fighter value; no RNG here). rate = 0.65 * conditioning + 17.5 + 8.0 * personal, then `age_adjust` to this age from 26,
  clamped to [5, 95]. A conditioning-50 man at 26 with personal 0 gets exactly 50.
- `static func factor(rate: float) -> float`: the multiplier the engine will apply to its recovery scale: `1.0 + (rate - 50) / 50 * 0.25`,
  clamped to [0.75, 1.25]. factor(50) == 1.0 EXACTLY (the average fighter must recover exactly as today).
- `static func age_adjust(rate: float, from_age: float, to_age: float) -> float`: moves rate over the years between the two ages:
  flat 22-28; -0.8 / year from 29; -1.8 / year from 34; +0.5 / year below 22 (down to 18); never below 5. Pure and additive: adjusting
  26->30 then 30->34 equals 26->34.
- `static func train(rate: float, aerobic_weeks: float, age_years: float, conditioning: float) -> float`: +0.25 per aerobic week at <= 28,
  x0.6 at 29-33, x0.3 at 34+; ceiling = min(95, 0.65 * conditioning + 17.5 + 12); never lowers a rate above its ceiling.
- `static func detrain(rate: float, idle_weeks: float, conditioning: float) -> float`: nothing for the first 3 idle weeks, then -0.4 per
  week, floor = 0.5 * conditioning (never raises).
- `static func corner_bpm_drop(rate: float) -> float`: DISPLAY ONLY, beats a minute the heart falls in the 60 s corner: `14 + rate / 100 * 24`
  (20 -> 18.8, 80 -> 33.2).
- `static func band_word(rate: float) -> String`: "POOR" < 35, "AVERAGE" < 65, "GOOD" < 80, "ELITE" >= 80.
- `static func scouted(rate: float, level: int) -> Dictionary`: `{"lo", "hi", "exact": bool, "word": String}`. level 0 (unscouted): a 25-point
  window `[floor((rate - 12) / 5) * 5, + 25]` clamped to 0-100 and containing rate; level 1: the 10-point tier `[floor(rate/10)*10, +10]`;
  level 2+: lo == hi == round(rate), exact true. The word is the band word of the window's centre.

## CutResistance.gd - exact contract
- `static func resistance(scar_level: int) -> float`: derived from the EXISTING scar rule so no new mechanic exists:
  `clampf(100.0 / CutsDoctor.scar_cut_mult(scar_level), 0.0, 100.0)` (level 0 / no scar -> 100). Use a `preload` of CutsDoctor.gd.
  Monotone: a higher scar level never gives a higher resistance (test it across every level the table has).
- `static func band_word(resistance: float) -> String`: >= 80 "SKIN CLEAN", >= 45 "MILD SCAR TISSUE", else "HEAVY SCAR TISSUE - CUT RISK".
- `static func scouted(resistance: float, level: int) -> Dictionary`: the same three levels and shape as RecoveryRate.scouted.

## Acceptance (>= 40 checks across the two tests; each prints PASS/FAIL with the value it got)
- generate(50, 26, 0) == 50; monotone in conditioning (0,25,50,75,100 strictly increasing) and in personal; always within [5, 95] including
  NaN / INF / negative / huge inputs (those return a finite value).
- factor(50) == 1.0 exactly; factor strictly monotone; factor(0) == 0.75; factor(100) == 1.25; clamps outside 0-100.
- age_adjust: additive (26->30 + 30->34 == 26->34 within 1e-6); 22-28 flat; 34-35 loses more than 29-30; never below 5.
- train: a 34-year-old gains less than a 25-year-old for the same weeks; never exceeds the ceiling; detrain: 3 idle weeks changes nothing,
  10 idle weeks lowers, floor respected, never raises.
- corner_bpm_drop(20) ~ 18.8 and (80) ~ 33.2 within 0.05; strictly increasing.
- band_word boundaries: 34.9 / 35 / 64.9 / 65 / 79.9 / 80.
- scouted: level 0 window width 25 (unless clamped at the ends) and contains rate for 200 rates from 0 to 100; level 1 width 10 and contains rate;
  level 2 exact; lo <= hi always.
- CutResistance: resistance(0) == 100; monotone non-increasing across every scar level; word boundaries 44.9 / 45 / 79.9 / 80; scouted as above.
- MUTANTS (put the result in the PR body): (a) make `factor(50)` return 1.01 -> which checks fail; (b) make `age_adjust` ignore the 34+ step ->
  which fail; (c) make `resistance` increase with the scar level -> which fail. Show each FAIL line.

## Commands
- `python Godot/tools/check_scripts.py Godot/scripts/RecoveryRate.gd Godot/scripts/CutResistance.gd Godot/tests/recovery_rate_test.gd Godot/tests/cut_resistance_test.gd`
- `godot --headless --path Godot --script tests/recovery_rate_test.gd` and `--script tests/cut_resistance_test.gd`
Paste both outputs' last 30 lines in the PR body. A test passes only with no FAIL line, no SCRIPT ERROR and exit 0. Never delete or weaken a check.

## Prior research
`topics/attributes_skill.md`, `topics/body_damage.md` (cardio is a heart rate, Q17; injury and recovery, J12 - "no per-region rate is published",
so every number here is AUTHORED), `LUDO_ROUND49_VERDICT_S216.md`, `LUDO_ROUND49_REPLY_S216.txt` (the source of the BPM anchors and the age slopes).

## What would a human do?
A systems designer adds a derived trait that changes one existing multiplier around 1.0 (so the average man is untouched), gives it an
age curve and a training curve, and shows scouts a range first.

## Prefab check
No third-party module fits (it is our own stats). Pure code, no assets, no licence issue.

## The one trap
factor(50) must be exactly 1.0. If the average fighter's recovery moves, every calibrated fight changes. Test it with `==`, not "approximately".

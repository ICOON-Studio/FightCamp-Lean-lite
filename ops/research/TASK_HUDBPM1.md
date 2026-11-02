# TASK HUDBPM1 (S209) - the fight HUD's heart rate reads 200 BPM 18 s into round 1: bound it to real physiology

Model: Arena (cloud). Repo ICOON-Studio/FightCamp, base master. Work on your own branch, open a PR; never merge.

## The defect (found on S208 all-ON fight stills)
The out-boxer's pulse shows 200 BPM 18 s into round 1. Real data: elite boxers average ~170-185 bpm across a round and peak near their
age-predicted max (220 - age) only late in hard rounds; a fresh man 18 s into round 1 sits far below max.

## How the number is made (read these, nothing else is needed)
- `Godot/scripts/Cardio.gd` `from_stamina(stamina, conditioning, age)` (~line 83): the base pulse. Fresh tank -> exertion 0.55 minimum.
- `Godot/scripts/LudoFightHud.gd`: `_refresh_bpm` (~486) = `set_heart_base` base (from Cardio, ~477) + `_spike[side]`, clamped to
  `max_bpm` 200 from `Godot/assets/data/ludo_fight_hud.json`. Spikes: `head_spike_for_power` (~103, +45 bpm base per head hit) added
  with NO cap (~463), effort spikes +6 per punch capped at 30 (~452-459), decaying with half-life 3 s (`decay_spike`).
- Suspected cause: base ~150-165 + stacked uncapped head spikes (two head hits inside the half-life = +90) -> clamp at 200, and the
  clamp is the HUD's flat 200, not this man's own maximum.

## The fix (keep it small; data in ludo_fight_hud.json, maths in static functions)
1. A pure static `combined_bpm(base: float, spike: float, age_years: float, cfg: Dictionary) -> int` in LudoFightHud.gd used by
   `_refresh_bpm`: total spike capped by a new cfg key `spike_cap_bpm` (start 25), result capped at `Cardio.max_bpm(age)` (220 - age)
   and never above cfg `max_bpm`. The HUD needs the man's age: add `set_age(side, years)` (default 27 when never set) and call it where
   `set_heart_base` is fed (`Godot/scripts/FightWorldLiveScreen.gd` ~5431 - the fighter dict there has `age`/`age_years`? read
   ~5405-5435 and use what exists; if no age key exists, keep the default and say so in the PR body).
2. Head spike stacking: a new head hit replaces the spike with max(current, new) instead of adding (cap still applies).
3. If after (1)+(2) a fresh 25-year-old (conditioning 60, stamina 95) at 18 s with 3 head hits power 0.8 + 12 punches thrown still
   reads above 175, lower Cardio's `_MIN_FIGHT_EXERTION` is NOT allowed (Cardio is shared) - tune only the HUD cfg keys.

## Acceptance test (NEW `Godot/tests/hud_bpm_bounds_test.gd`, pure: loads LudoFightHud.gd/Cardio.gd + the json, no scene, no LFS)
Simulate with the real static functions, 0.1 s steps:
- A: age 25, conditioning 60, stamina 95 for 18 s, head hits power 0.8 at t=5, 6, 7 s, 12 punches thrown spread over 18 s:
  peak bpm <= 175 and final bpm >= 140 (the instrument still reads a working man).
- B (a DIFFERENT man): age 34, conditioning 40, stamina 20 late in round 10, same hit pattern: peak <= 186 (220-34) and >= 165.
- C: never exceeds 220 - age for ages 20..40 under 10 head hits in 2 s.
- D (instrument can read worse): with `spike_cap_bpm` set to 1000 in a cfg copy, scenario A's peak is > 175 - proves the cap is what holds it.
Also keep `Godot/tests/ludo_fight_hud_test.gd` and `Godot/tests/cardio_test.gd` green (update a number only if your change is the
reason, and say which in the PR body). Acceptance = CI "Parse gate + changed tests" green.

## Owned files
Godot/scripts/LudoFightHud.gd, Godot/assets/data/ludo_fight_hud.json, Godot/scripts/FightWorldLiveScreen.gd (the age feed line only),
Godot/tests/hud_bpm_bounds_test.gd (new), Godot/tests/ludo_fight_hud_test.gd. Never Cardio.gd.

## The one trap
Clamping the label alone hides the bug; the band colours (`bpm_band`, red_from 170) also read the number - test A must read the
same value the label shows.

## Prior research
S192/S195 HUD pulse notes in LudoFightHud.gd comments; Cardio.gd header. ## What would a human do? Look at real round heart-rate data
(170-185 average, max 220-age) and bound the display to it. ## Prefab check: none.

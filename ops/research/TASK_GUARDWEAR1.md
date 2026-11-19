# TASK GUARDWEAR1 - guard damage v4, the pure rules (GuardWear.gd + its test)

Status: OPEN (S524, Claude main). Discipline: boxing. Model: Arena (cloud). Seat: Arena (no Godot in the sandbox: write
the module and the test, parse them with gdtoolkit if you can; the repo's CI runs the test, Claude runs it on the PC).
Source: the owner approved guard damage v4 (board Q-S294-275: "Yes, build it after turning pro"; critics Dola 8/8/7,
Goose 8/7/7). The design: `ops/research/DESIGN_GUARDDMG1_V4.md` sections 0, 1.1-1.5 (the numbers below are copied from it).

## Contract
OWNS: scripts/rules/GuardWear.gd, tests/guard_wear_test.gd
RED_TEST: tests/guard_wear_test.gd -> GUARD_WEAR failures=0
REGRESSION: fight_meters_test (FightMeters.gd guard bar must stay untouched); guard_wear_test is new
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py guard damage wear arms` -> DESIGN_GUARDDMG1_V1..V4 and their critics. Today's guard
bar is `scripts/rules/FightMeters.gd` (shoulder Burn shows on the bar, `guard` 0..1). Do not edit it.

## What would a human do?
A boxing coach's rule of thumb: a blocked shot still costs the arms; tired arms let more through; the third punch of a
flurry is the one that breaks the guard; on the ropes the guard goes faster; a clinch or a quiet spell buys it back.

## Prefab check
None needed: a pure static rules module like scripts/rules/ProCall.gd or scripts/rules/RivalOffer.gd.

## The job - scripts/rules/GuardWear.gd (extends RefCounted, pure static, preloads NOTHING, under 400 lines)
Every number below is a named constant marked `## ESTIMATE`. Guard is a number 0..max (max 100 for a middleweight).
1. `transmission(kind: String, guard: float, max_guard: float, wclass: String, combo_n: int) -> float` - the share of a
   BLOCKED punch's damage that gets through. kind "jab" base 0.25, "power" (cross/hook) 0.425, "heavy" (uppercut/big
   shot) 0.55. Multiplier = 0.5 + (100 - g) / 100 where g = guard scaled to 0..100 (guard / max_guard * 100), so x1.0 at
   full, x1.5 at half, x2.0 at empty. Weight class: "light" x0.9, "middle" x1.0, "heavy" x1.3. combo_n >= 3 (the third
   punch on in one sequence) x1.5. Then a CAP of 0.80 on anything (the cap wins over the design table's 83%).
2. `wear(kind, combo_n, ctx: Dictionary) -> float` - guard points one block costs. Jab 1, power 3, heavy 5. combo_n >= 3
   x1.5. ctx keys (all optional, absent = off): "ropes" (trapped on ropes/corner) +12%; "moving" (moving freely) -5%;
   "condition" (0..100) under 70 +10%; "missed_weight" +18% (instead of the condition line); "posture" "high" +8%;
   "amateur" +15%; "shoulder" (see 3) its own %; "trait" (see 6). Percent modifiers ADD to one factor (1 + sum), never
   compound, and the factor never goes below 0.5.
3. `shoulder(stamina: float, strength: float) -> float` = stamina * 0.7 + strength * 0.3, and
   `shoulder_wear_pct(shoulder) -> float`: 50 or less = 0; 65 = -12%; 80 = -20%; straight lines between the points; above
   80 keeps falling at the same slope as 65-80 to a floor of -25%.
4. Posture `posture_damage(posture, target) -> float` multiplier: "high" head 0.80 body 1.15; "low" head 1.15 body 0.80;
   "neutral" 1.0. ("peekaboo" is removed: any unknown posture = neutral.)
5. Recovery: `in_round(punches_thrown_at: int, amateur: bool) -> float` - 0 thrown +3 (amateur +4), 1-2 thrown +1, 3+ 0.
   `clinch(skilled: bool, guard: float, max_guard: float, used_this_round: bool) -> Dictionary` - allowed only when the
   guard is under 50% of max and not used this round: {"ok": true, "guard": +10 (skilled clincher +13), "stamina": -10,
   "free_exchange": true}; else {"ok": false, "why": "<plain words>"}.
   `corner(calls: Array, cutman_good: bool, cut_open: bool) -> float` - base +15; "hands_up" +5; a good cutman +5 only
   when no cut is open; "back_off" +20 (spread over the next round: return it in the total, the caller spreads it).
   `clamp_guard(g, max_guard)` keeps 0..max.
6. `max_guard(wclass: String, amateur: bool) -> float` - light 80, middle 100, heavy 120; an amateur's max is 70 whatever
   the class. Traits, `trait_wear_pct(trait: String, round_n: int) -> float`: "slow_starter" -12% in rounds 1-2, +12%
   from round 3; any other trait 0. `trait_recovery_pct(trait, round_n, morale)`: "fades_late" -25% after round 4;
   "chases_stoppage" -10%; morale under 40 -20% (adds to the trait's); else 0.
7. Parry: `parry_chance(kind_exact: String, defence: float) -> float` - only when defence >= 50 (else 0.0); jab 0.70,
   cross 0.55, hook 0.40, uppercut 0.35, shifted by (defence - 50) / 500 (defence 100 = +0.10), clamped 0.05..0.95.
   A parried punch: `PARRY_WEAR` 0.3, `PARRY_TRANSMISSION` 0.08.
8. Scoring: `blocked_strikes(blocked: int) -> int` = blocked / 3 (integer) - the judges' effective strikes; never damage.
9. `colour(guard, max_guard) -> String` - "green" >= 75% of max, "yellow" >= 50%, "orange" >= 25%, else "red";
   `word(colour)` -> "Holding well" / "Arms tiring" / "Leaking heavily" / "Arms dropping". No he / she in any text.

## tests/guard_wear_test.gd (extends SceneTree, under 400 lines)
Check each rule above with exact numbers, plus: transmission never above 0.80 and never below 0 for 1000 random
(kind, guard, class, combo) - a sweep; wear factor never below 0.5 with every modifier stacked negative; full guard jab
0.25, half guard power 0.6375, empty heavy capped 0.80, heavy class jab at full 0.325; third punch x1.5 and the second
not; clinch refused at 60% guard and on a second try in the round; shoulder 65 = -12% exactly; a mutant arm: a check that
WOULD fail if the cap were 0.85 (empty heavy guard). Print `ok  <what>` / `FAIL <what>` per check and the last line
`GUARD_WEAR failures=<n>`, quit(0 if 0 else 1).

## Rules for this seat
Work on ICOON-Studio/FightCamp-Lean (branch main), your own `arena/` branch, open a PR into main; never merge, never touch
another file. Never delete or weaken a check to go green: if a number in this brief looks wrong, say so in the PR body and
keep the check. GDScript: typed vars, no `:=` on a Variant from a Dictionary (write the type), tabs. PR body: the
functions, each constant, and the line `RESULT: tests/guard_wear_test.gd -> GUARD_WEAR failures=0` if CI ran it.

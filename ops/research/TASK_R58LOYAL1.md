# TASK R58LOYAL1 - GOOSE (cloud) - each fighter's LOYALTY made live: bands, dated reasons and a forecast (one pure module + its test)

Status: OPEN (S440, Claude main). Discipline: boxing and no-gi (all four starters: the number is the same for the boxers and Ana).
Model: Goose's own model (the goose workflow; nothing to pick).
Mechanic: R58 "A fighter leaves for a bigger gym" (critics 8/8 and 8/8, average 8.0, ops/research/MECHANICS_BUILD_STATE_S440.md). The
poaching itself (the approach, its five answers) is a separate map still with the critics (ops/research/R58_MAP_S439.md): NOT this task.
THIS task is the number under it, already passed at 7 and 7 in the club week map: ops/research/CLUBWEEK_MAP_V41_S432.md section 3.8
(lines 177-197: READ IT FIRST, it is the spec) and section 3.1 (holding pads, the sponsorship, lines 66-78), with the bands and the
forecast of ops/research/RPG_LAYER_MAP_S432.md section 3 (lines 91-110). Today loyalty is a trait in the data that only Ana's stripe
call moves (StripeCall). No screen and no wiring here: Claude wires the causes into the week after the collect.

## Contract
OWNS: scripts/rules/Loyalty.gd, tests/loyalty_test.gd
RED_TEST: tests/loyalty_test.gd -> LOYALTY failures=0
REGRESSION: stripe_call_test, fighter_profile_test, recruit_test, file_limits_test
VISUAL: no
NOT YOURS: every other file (tools/run_tests.sh too: Claude adds the test at collect). Read, never edit: scripts/rules/StripeCall.gd
(114 lines: NOW_LOYAL 18, HOLD_LOYAL 20, ASKS_UNDER 21, _add 112), scripts/rules/FighterProfile.gd (170: TRAITS line 7),
scripts/rules/ProDebut.gd (49: MANAGER 10, TRAINER 11), scripts/state/Data.gd (248: PROSPECTS from line 205, lucy() 52),
scripts/rules/NoGi.gd (312: MORALE_START, the grappler's "loyalty" key at line 82).

## Where the number lives (decided)
ONE home for all four: `f["loyalty"]` (int 0-100), the key StripeCall and NoGi already use for Ana. When it is missing, `value(f)`
reads `f["personality"]["loyalty"]` (the trait every boxer has: Samira 82, Tess 66, Kira 60, Danny 58, Josh 70), else 50. Every move
appends `{d: day, n: delta, why: cause}` to `f["loyalty_log"]` (keep the newest 40).

## The job: scripts/rules/Loyalty.gd (pure, static, under 300 lines; preloads only StripeCall and ProDebut)
1. `const BANDS`: Leaving under 25, Wavering 25-49, Settled 50-69, Loyal 70-84, Trusts you 85 and up (RPG 3). `band(v, known := 0)`:
   "Trusts you" needs Known 4 as well (RPG 3); at 85+ with known under 4 it reads "Loyal".
2. `const MOVES` (the map's ESTIMATES, each with its name): short -3; short_running -6 (short the week before too); full_week +1;
   promise_kept +5; promise_broken -12; sponsor_given +5; sponsor_pulled -8; sponsor_renewed +2; sponsor_passed_to +5;
   held_pads +3; sheet_passed_ready -2; target_to_ambition +5; target_against -5; target_met +10; target_missed -5;
   overtime_refused -2; talk_back +4; talk_straight_landed +4; talk_straight_failed -4; wants_sponsor -3 (potential 80+ and no
   sponsorship for 8 weeks, per week); stripe_now = StripeCall.NOW_LOYAL and stripe_hold = -StripeCall.HOLD_LOYAL (READ them).
3. `apply(f, cause, day) -> Dictionary` {before, after, delta, band_before, band_after}: clamps 0-100, logs. Its rules:
   - "short" becomes short_running when the log holds a short in the 7 days before `day`;
   - A LOYAL fighter's first short week in any 28 days costs 0 (logged with n 0 and why "short (Loyal: one week in four free)");
   - held_pads counts at most 4 weeks running (a fifth running week logs 0);
   - an unknown cause changes nothing and returns delta 0.
4. `forecast(f, weekly: Array, weeks: int, day: int) -> Array` of {week, v, band}: the week's causes repeated `weeks` times on a COPY
   (f is never changed), using apply's own rules. And `forecast_line(f, weekly, day) -> String`: "66 now; as dealt 69 in 4 weeks,
   Loyal in 5" (the next band up or down named only when the forecast reaches it inside 12 weeks).
5. `wants_word(f, day) -> bool`: under 50 and no word card for this fighter in the last 28 days (logged as cause "word_card").
6. `can_tell_straight(f, day) -> bool`: false for 56 days after a talk_straight_* (map 3.8: "not again for that fighter for 8 weeks").
7. `leaves(f, day) -> bool`: under 25 AND two talks (any talk_* cause) since loyalty last went under 25 (map: "under 25 after two
   talks, the fighter leaves the next Monday"); the caller picks the Monday.
8. `can_hold_pads(f, bouts) -> bool`: Loyal band (70+) and 6 or more bouts (map 3.1).
9. `pro_share(f) -> float`: ProDebut.MANAGER + ProDebut.TRAINER at 50 and up; ProDebut.TRAINER alone under 50 (map 3.8: an outside
   manager signs a Wavering boxer).
10. `reasons(f, since_day) -> Array`: the logged moves since a day, newest first, each {d, n, why} (the bar's "last three moves").

## The test FIRST: tests/loyalty_test.gd (extends SceneTree, prints `LOYALTY failures=N`, quits with N)
RED ON MAIN: run it on main first: the preload of the missing Loyalty.gd fails to load. Say so in the PR body. Assert at least:
- value() of four DIFFERENT prospects (deep copies of Data.PROSPECTS rows) equals each one's personality.loyalty; Ana's existing
  f["loyalty"] wins over a personality value;
- band edges 24 / 25 / 49 / 50 / 69 / 70 / 84 / 85 read Leaving / Wavering / Wavering / Settled / Settled / Loyal / Loyal / Loyal
  (known 0) and 85 with known 4 reads Trusts you;
- short: -3; short again 7 days later: -6; a Loyal fighter's first short in 28 days 0, the second inside 28 days -3 or -6;
- held_pads four weeks running +3 each, the fifth 0; clamps at 0 and 100;
- stripe_now and stripe_hold equal StripeCall's constants (read in the test, never typed);
- forecast: Tess (66) dealt in full every week reads 70 and "Loyal" at week 4 (66 + 4 x full_week, computed from MOVES in the test);
  f and its log are unchanged after the forecast; forecast_line names the band only when it is reached inside 12 weeks;
- wants_word only under 50 and once in 28 days; can_tell_straight false for 56 days after a straight talk, true on day 56;
- leaves false at 24 with one talk, true at 24 with two; pro_share at 50 and at 49 equals the ProDebut sums read in the test;
- every log entry has d, n and why; reasons() returns newest first;
- MUTANTS inside the test: a copy of apply that drops the Loyal free week, and one that never escalates to short_running, must each
  FAIL the same asserts; print `MUTANT caught` for each.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant, `%%` in format strings).
- The one trap: loyalty and MOOD are different numbers (map 3.7: the deal's prices move loyalty, never morale). Never touch f["morale"].
- Never two identical fighters in one assert; build from Data, never typed personality tables where Data has them.
- Words: no pronoun in a built string; "Coach", never a surname. Do NOT delete or weaken any existing test.
- Write the PR body last, from the final run.

## Prior research
`python ops/Tools/prior_research.py loyalty` -> RPG_LAYER_MAP_S432.md (section 3: the bond is loyalty, the forecast) and
CLUBWEEK_MAP_V41_S432.md (3.8, the spec); R58_MAP_S439.md (the later poaching, read only to keep this module's names: forecast,
reasons); StripeCall.gd (the only code that moves loyalty today).

## What would a human do?
A club coach knows who feels second in line: the one passed over for pads two weeks running, the one promised a sponsorship that never
came. The module is that memory, with dates, and the warning before a boxer walks out.

## Prefab check
None: a ledger of dated moves on the game's own trait. StripeCall._add is the house pattern for the clamp.

Test command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/loyalty_test.gd`.
Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/loyalty_test.gd -> LOYALTY failures=0`.

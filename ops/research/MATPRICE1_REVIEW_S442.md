# MATPRICE1 blind review (REVIEW3, 2026-11-12) - PR 237, branch qwen/matprice1 @ a6aa9f98

Verdict: **COLLECT WITH FIXES** - the most serious defect of the three: the price showed the player the opponent's
HIDDEN answer level. Fixes are uncommitted in this worktree.

## a. Brief items (as delivered; MatPrice.gd lines)
| Item | Status | Where |
|---|---|---|
| chance = BjjTree.odds with the answer AS KNOWN; nothing found = an even owned answer (30) | WRONG | :25-36 `_answer_level` fell back to `BjjTree.answer_mastery(opp, e, rules)` - the opponent's TRUE level - whenever the film had found nothing |
| chance_lo / chance_hi = owned answer .. no answer while hidden; collapse when found | WRONG (units) | :104-108 passed D_NONE (0.9, a divisor) as a MASTERY level for "no answer" (same number only because any level under 27 hits the floor); "found" ignored legality, unlike the chance |
| chance_timed: at_once = chance, frame_first/set_up + 2 stacks (logit_add), sit_tight 0 | DONE | :45-52 (GRIP_W from BjjTree.T, the value BjjBeat/BjjWalk use) |
| points, lands_at; miss_at, miss_gives, miss_slides = p_bad(known answer) | DONE | :123-129 |
| tank / tank_miss by BjjBody's own cost functions; + two work beats | WRONG | :57-64, :132-144: re-derived instead of BjjBody.spend; unknown kinds (and BASE moves) mapped to "transition"; the work beats missed BjjBeat's factor BEAT2_S / OLD_BEAT (charged 3x); tank_miss was the TOTAL of a miss where the brief and the map ask "what a miss adds" (map: 5.5, "a miss 2.8 more") |
| time_s: 0 at once, two beats otherwise | DONE | :147-149 (BjjTree.T BEAT2_S, 11 s) |
| read_mult from TheRead for the opponent's belt (x0.82 at white) | WRONG | :69-75: IQ from `opp.get("iq", 40)` (not BjjTree.watcher_iq: a blue belt read as white); looks per try typed `LOOKS_PER_TRY := 3.0` instead of TheRead.LOOKS_PER_EXCHANGE; read not capped at 1 as the walk caps it |
| grade Good/OK/Poor at +-0.08, two named consts | DONE | :14-15, :79-84 |
| level, level_word = BjjTree.state | DONE | :161-162 (the code's lower-case words) |
| chips, six, in order, no pronoun, "Tank" | DONE | :175-199; "Tank" justified by a NODE name in ComboStrip.gd:154 - the word on the mat screens is GrapplerPage.gd:402 "the tank" / GaugeRow "Tank": same word, wrong source quoted |
| worth left out (M4) | DONE (no stub, no faked number) |

| Required assert | Status (delivered test) |
|---|---|
| worked numbers 0.50, 0.154, 0.197, 0.345, 0.416, 0.244, 0.143, 0.48, slide 0.7 | 0.154 and 0.197 DROPPED (asserted only against odds without the read); the rest passed against an opponent whose TRUE level equalled the map's answer (with the leak, that is what made them pass) |
| every chance == direct BjjTree.odds | DONE, but with the opponent's true level (the leak) |
| hidden lo < hi; found lo == hi == chance | DONE (lo < hi only) |
| tank / tank_miss == BjjBody's functions, two cardios | WRONG: compared with a re-typed GAS_COST x drain formula, not BjjBody.spend |
| sit_tight 0 / 0 / no tank | DONE |
| grade flips at the two cut points | MISSING: asserted only "grade is one of Good/OK/Poor" and "same inputs give the same grade" (cannot fail) |
| chips six, no pronoun, chance chip | DONE (pronoun list she/her only) |
| MUTANTS ignore known / stacks at once, "MUTANT caught" printed | DONE |

## c. Mutants on the DELIVERED source
ignore known caught, stacks at once caught, slide from the attacker caught, no hidden range caught;
**grade cut moved to 0.0 NOT caught; read_mult flat 1.0 NOT caught.**
On the FIXED source all 7 caught: ignore known, stacks at once, grade cut, read_mult flat, the hidden answer read from
the opponent, the work beats without the beat factor, IQ fixed at 40.

## d. Words
Chips: "38 in 100", "No points", "miss: Under the mount, 4 (10 in 10)", "Tank -6, -9 on a miss",
"read x0.82 by the 3rd try", "22 s". No pronoun, no code name.

## e. Files
Only the two OWNS files changed; no test deleted; MatPrice.gd 207 lines delivered, 190 fixed (< 300).

## Fixes made (uncommitted)
scripts/rules/MatPrice.gd
- removed `const LOOKS_PER_TRY := 3.0` (:18-19); `_read_mult` now `TheRead.looks_needed(BjjTree.watcher_iq(opp), false)`,
  read = min(1, READ_TRIES_BEFORE x TheRead.LOOKS_PER_EXCHANGE / looks).
- `_answer_level(opp, e, rules, known)` -> `_found_level(e, rules, known)`: the best LEGAL found level, -1 when none;
  price(): `m_ans = found if found >= 0 else MatLines.EVEN_ANSWER` (was the opponent's true level).
- chance_lo/hi: both = chance when found; hidden: lo = chance (even 30), hi = `BjjTree.odds(e, m_att, 0.0, ...)`
  (was a mastery of D_NONE).
- `_tank_cost(e, cardio, timing)`: hit = 1 - BjjBody.spend(1, kind, true, cardio), miss = 1 - spend(..., false, ...),
  returns [100 x (hit + work), 100 x (miss - hit)]; work = 2 x BjjBeat.WORK_GAS x BEAT2_S / BjjBeat.OLD_BEAT x drain;
  a BASE move costs 0; the kind-mapping block (:132-140) removed.
- tank chip: `"Tank -%d, -%d on a miss" % [roundi(tank), roundi(tank + tank_miss)]` (was "%.1f" of tank and of the
  miss total) - Ana's escape now prints the map's own example, "Tank -6, -8 on a miss".
tests/mat_price_test.gd rewritten (same sections + read_mult; "REVIEW3" header):
- worked numbers pass the FOUND answer the map names (known), Americana 0.154 and SET IT UP 0.197 asserted on
  BjjTree.odds with the read TheRead gives (3 looks of 16), price's Americana = the bare odds (read is read_mult).
- chance == odds at the found level AND at the even 30 while hidden, for three edges.
- hidden: the same chance / lo / hi for an opponent at 10 and at 70 (no leak); found: the found level.
- tank: BjjBody.spend at cardio 40 and 70; Ana 5.5 and "2.8 more"; frame first adds the two work beats (< 1.5, map
  "about 1").
- read_mult: white 0.816 and blue 0.774 recomputed from TheRead; x0.82 at white.
- grade: shifts built at 0.082 / 0.078 / -0.078 / -0.082 through the opponent's body -> Good / OK / OK / Poor; the
  cut constants are 0.08 / -0.08.
- chips: pronoun list widened to he/him/his; Ana's tank chip equals the map's example.
- mutants (ignore known, stacks at once, hidden answer read from the opponent) each fail an assert the real price passes.

## Note for Claude
- The map's CHANCE chip says "with the known answer, the body shift, CHAIN"; the brief's `chance` has no body shift.
  The module follows the brief (worked numbers have no shift). Decide if the chip should add BjjBody.shift.
- With the answer hidden, miss_slides reads the even 30 -> p_bad 1.0 ("10 in 10"). Correct by the rule, but the chip
  then always says every miss slides until the film finds the answer.

## Test runs (fixed worktree)
- parse clean; mat_price_test: `MAT_PRICE failures=0` (all three mutants caught).
- regression: `MAT_LINES failures=0`, `BJJ_TREE PASS failures=0`, `FILE_LIMITS failures=0`.

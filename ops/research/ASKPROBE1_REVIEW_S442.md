# ASKPROBE1 review (PR 235, qwen/askprobe1 @ 1560b26f) - blind, by Claude, S442

Note: the worktree had been retired by the reconcile at 16:11 (retire.log); it was re-made at the same path from
`qwen/askprobe1` and seeded. Nothing committed or pushed. Review-side files (uncommitted): `tools/ask_probe_honest.gd`,
`probe_*.log`, this page.

## VERDICT: REJECT the probe and its result page; COLLECT WITH FIXES the two rule modules after the fixes below.

The headline ("spread ok", sheet 29 / step_up 26 / name 5 / wait 0) was not measured on the game: the probe rolls its
own dice, sums the three players into one score, never lets WAIT win, ignores weight, the slot, money and the gate, and is
not reproducible (two runs of the delivered probe gave 21/28/11/0 and 20/32/8/0 with different case winners).

## Runs (all through godot_slot, from the worktree)
- `--check-only` on all six files: clean.
- fight_learn_test FIGHT_LEARN failures=0; ask_bout_test ASK_BOUT failures=0.
- Regression: amateur_booking (checks=101 failures=0), rank_line, next_offer, file_limits, no_pronoun: all failures=0, no
  SCRIPT ERROR in any log.
- tools/ask_probe.gd twice: "spread ok" both times, but run 1 = sheet 21 / step_up 28 / name 11 / wait 0 (A step_up, G sheet),
  run 2 = 20 / 32 / 8 / 0 (A sheet, G step_up). docs/ASKPROBE1_RESULT.md (29/26/5/0, A sheet, G step_up) matches neither:
  `_rng.randomize()` (ask_probe.gd:19) makes every run different.

## 1. FightLearn.teach - CORRECT
scripts/rules/FightLearn.gd:17-28 is Matchmaking.apply_result's growth (Matchmaking.gd:235, 246-247) term for term, every
number read from Matchmaking (SOFT_GAP, GROW_BASE, GROW_PER_POINT, LEARN_GAP, GROW_SOFT, GROW_LOSS, STOP_COST). No retyped
number. Word cut points 0.4/0.7 and 0.15/0.30 are constants with the ASKPROBE1 comment (lines 8-13) but were never set FROM a
probe (the probe never prints the teach distribution) - say so or set them from the honest run (teach means seen: 0.45-1.10).

## 2. AskBout - defects, most serious first
1. **Unranked step up is the BEST record, not the nearest better one** (AskBout.gd:127-141: keeps the max net). Map s2 says
   "the nearest better record inside the novice rule". On the real division a 1-0 novice (cases A, G) is sent Erin Doyle
   7-2, rated 65.5 - the strongest novice in the region. Fix: keep the candidate with the SMALLEST net above own_net (tie:
   fewest wins above, then rating nearest): `if rnet > own_net and (best == "" or rnet < best_net or (rnet == best_net and rw < best_w))`
   with `best_net`/`best_w` starting from the first candidate, not from own.
2. **"Self" is found by rank number, not by name** (AskBout.gd:121-123, 149-152). If the fighter's own row is missing from
   `rows`, the code treats whoever holds that place as "self" (the delivered probe and the "only sheet" test both do this: in
   ask_bout_test.gd:180-187 the fighter "is" the opponent "Only"). Fix: pass the fighter's `name` in `f`, find the row by name
   (or RankLine._rank_of), and return [] / "" when it is absent.
3. **Our own fighters can be offered as opponents**: no `ours` filter in `_step_up`, `_picked_names`, `_is_legal`
   (Region.rankings puts our ranked fighters in the table with ours=true). Fix: skip rows with `ours == true` in all three.
4. **Not a pure module as briefed**: preloads `scripts/state/Bouts.gd` (28 preloads of game state) and `Region.gd`
   (AskBout.gd:11-12) only for AFTER_FIGHT and RANK_MIN_WINS; `RankLine` and `FightLearn` are preloaded and never used, and
   RankLine's order is retyped in `_before` (187-195). Fix: take `after_fight` and `min_wins` as arguments (the brief: "pass
   it in"), drop the Bouts/Region preloads, sort with `RankLine._ranked`.
5. **open() (section 5) incomplete**: no BJJ case ("the BJJ fighter's nights stay on the mats"); `opens_day` is -1 for booked,
   offer waiting and nationals (map: "the reason and the day it opens"); a not-fit fighter with no `healed_day` opens "today"
   (line 32). Fix: add `if str(f.get("discipline","")) == "bjj"` closed reason; take `bout_day` / `offer_expires` /
   `nationals_end` in `f` and return them (+ after_fight for a booked bout); default healed_day to -1, not `day`.
6. **show_day's why lacks the date** (line 53: "X is already on that night.") - map s3: "Lucy is already on Sat 28 Feb".
   Fix: `"%s is already on %s." % [holder, Clock.fmt(d)]` (or return the held day for the caller). Also it assumes
   `show_days` sorted; sort a copy first.
7. **strip()'s road is not the map's road** (_road 210-219): no nationals line at all ("bouts still needed for the
   nationals and the entry day"), and it prints "Pro offer: 7 wins and top 3." when the fighter has already made it rather
   than what is still needed. `weight` is read and unused (202). Fix: take `nationals_bouts_needed`, `nationals_entry_day`
   and print "N bouts for the nationals by <day>" first; for ranked: "N wins and top 3 for the pro offer".
8. card(): `place` comes from a passed `rank` key, not RankLine; `gate` is a bool, not "gate words"; `f` unused. Minor:
   make `gate_words` "The host keeps the gate: $0 for the club" when kind == "name".
- Fine: picked list excludes sheet and step-up names (163); unranked gets no "name" (91 + 153); every name passes
  experience_match_ok; a missing kind is absent; MIN_LEAD_DAYS 14 is a constant; no pronoun in any string.

## 3. Tests - mutants run in the worktree (restored after)
| Mutant | Test result |
|---|---|
| step-up name allowed in picked | RED (2 fails) - good |
| sheet name allowed in picked | RED - good |
| unranked gets a "name" answer | RED - good |
| drop GROW_LOSS | RED - good |
| step up = nearest (the map's rule) instead of best | GREEN - the step-up name is never asserted |
| MIN_LEAD_DAYS 14 -> 7 | GREEN - the test has no show between 7 and 13 days out (55 is 5 days, 64 is 14) |
| drop `gap <= LEARN_GAP` from the loss term | GREEN - no loss case with gap > LEARN_GAP |
| booked / nationals reason emptied | GREEN - reasons and opens_day asserted only for not-fit and too-soon |
| card gets a "teach_value" key | GREEN - blacklist of four exact key names |
| GROW_LOSS retyped as 0.4 | GREEN (inherent; acceptable) |

Asserts that cannot fail: ask_bout_test.gd:222 (`mutant_picked.has(step_name)` after appending it - a tautology; the brief's
"MUTANT" is not a mutant). ask_bout_test.gd:91-99 is vacuous when no "name" answer exists. fight_learn_test.gd:36-47 copies
the formula instead of calling `Matchmaking.apply_result` (works today, but a reshaped Matchmaking would leave both stale).
Missing asserts the brief asked for or the map needs: the step-up NAME for ranked and unranked fighters; a show 7-13 days
out skipped; reasons + opens_day for every section 5 case incl. BJJ; loss with gap > LEARN_GAP; card values contain no
float; a `ours` row never offered; the fighter absent from rows returns no step-up/picks.

## 4. The delivered probe (tools/ask_probe.gd) - NOT HONEST
- Own dice (ask_probe.gd:206-209): `win = clamp(0.5 - gap/20)`, stoppage = `(1-win) x 0.25`; no Bouts.fight_step, no LiveRound.
- One summed score (260): `(record + growth + safe) / 3` - exactly what the map forbids; one "winner" per fighter, never three.
- WAIT is a constant 20.0 (263) and wins only when no answer exists; case F's weight (66) and case G's slot are never read.
- Gate: $450 never enters money (`money += 200` a win, 218, for every answer); only a flat -10 on SAFE (256). The gate and
  the step-up teaching cannot be moved by an argument.
- Population: fighters are not in the division rows; `rank = 1 + (i % 8)` (79) has nothing to do with the table; records
  run to 8-4 (`l = (i/9) % 5`), not 8-2; mood, cash, nationals_day are generated and never read; the division is a made-up
  12-row table, not the game's rivals; only `names[0]` of the picked list is ever played.
- The pass line counts 67 (cases + 60) against int(67 x 0.6) = 40 (49-51), not "of 60".

## 5. Honest probe (tools/ask_probe_honest.gd, 150 lines, uncommitted)
Real bout: Data.lucy() re-rated per fighter (six stats shifted to the target power, +-3 seeded noise), the loop of
adapt_probe (Bouts.fight_step + LiveRound, auto corner), the day advancing per bout, the rivals' table restored after each
night (the night writes their records - without that, every opponent passed the novice limit within a case). Real division
(quick_start rivals of wlw, Region.before order, our row in it), real sheet (Bouts.legal_index), AskBout.show_day for the
night, Sim.weigh_forecast for the scale (missed = bout off). Three players scored SEPARATELY: RECORD = win - loss,
GROWTH = mean FightLearn.teach, SAFE = 1 - stoppage share x 30/14 (shows lost); WAIT = 0 on all three; a picked name costs
0.10 of each unit per $450 (a review ASSUMPTION - the map has no exchange rate). Each picked name is played; a player takes
its best. n=30 per name, seed 4421, cases A-G + 60 generated (w 0-8, l 0-2, power 52-68). Population named in the output.

Cases (gate $450, step teach x1):
| Case | rank | own player | RECORD | GROWTH | SAFE |
|---|---|---|---|---|---|
| A 1-0 novice | 0 | GROWTH | wait | step_up | sheet |
| B 6-1 | 3 | RECORD | wait | step_up | sheet |
| C 4-1 short of nationals | 6 | GROWTH | wait | name | sheet |
| D low mood / cash | 6 | RECORD | wait | name | sheet |
| E presser two up | 4 | RECORD | wait | name | sheet |
| F 1.5 kg over, show +19 d | 6 | RECORD | wait | wait | wait (forecast misses: bout off) |
| G second of ours on the night | 0 | GROWTH | wait | sheet | sheet (show_day gives the show after, +33 d) |

Over 60, wins per answer (wait / sheet / step_up / name):
| Run | RECORD | GROWTH | SAFE | OWN player |
|---|---|---|---|---|
| gate $450, step x1.0 | 59/0/0/1 | 0/30/21/9 | 0/59/1/0 | 25/19/15/1 |
| gate $0 | 56/0/0/4 | 0/25/20/15 | 0/56/1/3 | 24/16/14/6 |
| gate $2,000 | 59/1/0/0 | 0/39/21/0 | 0/59/1/0 | 25/20/15/0 |
| step teach x0.5 | 59/0/0/1 | 0/48/0/12 | 0/59/1/0 | 25/33/1/1 |
| step teach x1.5 | 59/0/0/1 | 0/6/46/8 | 0/59/1/0 | 25/2/33/0 |
Pass line on the OWN player: "spread ok" in all five runs - but the spread is three one-answer players side by side.

What the honest table says (design findings, not the seat's):
1. Each player is a lookup: RECORD always waits (59/60: on the real division every legal name beats the typical amateur -
   33-43% wins against the sheet name at even paper power), SAFE always takes the sheet (stoppage 3-10% everywhere, so it
   just counts bouts), GROWTH splits sheet/step_up/name. The "spread" comes only from WHICH player a fighter is.
2. The levers move as they should (the probe measures): the gate pushes "name" 15 -> 9 -> 0 for GROWTH ($0, $450, $2,000);
   step teaching moves step_up 0 -> 21 -> 46. So the map's first lever (step teaching) is live and steep.
3. Case F and G behave as the map wants (wait; the show after). Case B/C/D/E: the case premises were wrong on the real table
   (B ranks 3rd, not 4th; E's step up is absent - the name above, Sophie Turner 8-4, is past the novice limit).
4. n=30 is coarse (one bout = 3.3%); stoppage differences of one bout decide SAFE ties. Before a price is set: n >= 100 on
   the cases, and a SAFE that values the season (5 bouts by day 70) rather than a tie-break.

## What the re-brief must say (probe)
Play the real bout (copy tools/ask_probe_honest.gd's loop: day advanced per bout, rivals restored per bout); fighters IN the
real division table; three players scored and printed separately per case and per 60, never summed; WAIT a real option
(0 and no cost), able to win; weight via Sim.weigh_forecast and the slot via AskBout.show_day; each picked name played;
seeded RNG and the seed printed; gate and step teaching as `--` arguments with a sensitivity run of each; the result page
written from the run it quotes. Then the design question for Claude: RECORD never fights and SAFE never steps up - the
answers are not yet a decision for those two players.

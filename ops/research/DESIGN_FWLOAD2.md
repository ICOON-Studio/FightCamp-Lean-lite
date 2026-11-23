# DESIGN FWLOAD2 - the fight week's load: two state-reading values, probed on the game's own tank and week (S543)

Task: `ops/research/TASK_FWLOAD2.md`. Follows the code-checked critic `ops/research/DESIGN_DEPTHPRICE1_CRITIC_OPUS.md`
(sections 1, 2 row 21, 3, 4: DEPTH 4, PLAY 5, CHANGE). Prior research: `docs/DEPTHPRICE1A_RESULT.md` (row 21: measured on the
screen's tank with an invented carry), `ops/research/DEPTH_AUDIT_S534.md` row 21 (a solved choice), `DEPTH_SCOPE_S534.md`.
Everything above section 7 was written BEFORE any probe run; the bars in section 5 are never loosened.

## 1. The choice as built today (every claim opened today, S543, main 6e60558e4+)

| What | Where |
|---|---|
| Three loads, the screen opens on Tick over (`DEFAULT_STOP`); the booking writes it | `scripts/rules/FightWeek.gd` l.25; `scripts/state/FightWeekPlan.gd` `mark` l.49 |
| The load's tank cost: Rest up 0, Tick over 6, Train through 12, added after the capped tank, uncapped | `FightWeek.STOP_TANK` l.28; `scripts/rules/BoutRules.gd` `tank_parts_for` l.229-247 |
| The bout's tank: tiredness 2 a point over 50 (cap 20), a bout inside 7 days 8 (14 days: 4), the three capped at 25; Rest up reads tiredness as min(tiredness, 30) | `BoutRules.tank_parts` l.~204, `LAST_BOUT` l.45, `TANK_MAX` l.41, `tank_parts_for` l.242 |
| The bout sets its own tank at the first bell when nothing pre-set it | `scripts/state/BoutNight.gd` `_peak` l.110-120 (l.118 calls `tank_parts_for` on `week_fatigue`) |
| The screen shows that same tank since 6e60558e4 | `FightWeekPlan.bout_tank` l.265; `scripts/ui/modals/FightWeek.gd` `_right` l.237-244 |
| The load sets the week itself: Rest up = the three-rest-day taper, Tick over = light days + one rest day, Train through = a normal week | `scripts/rules/WeekPhase.gd` `LOAD_WEEKS` l.64, `load_stop` l.72, `week_for` l.77 |
| Round 1: Rest up FLAT -2 under 40 tired, -1 at 40-64, Sharp from 65; the others Sharp | `FightWeek.REST_UP_EDGE` l.53, `round_one` l.125; written by `lock` l.341 `b["r1_edge"]`; read by `BoutRules.first_round_edge` l.169 |
| The bank: a fifth / half / the whole of the week's pad work sticks | `FightWeek.BANK_SHARE` l.48; `lock` l.339 `f["fw_bank"]`; `scripts/state/DrillWeek.gd` `fw_bank` l.141 (reach `FW_BANK_REACH` 6 days, l.26) |
| The bank lands at the week's end drilling, i.e. AFTER a Saturday bout: it never changes this bout | `scripts/state/Sim.gd` `end_week` l.293, l.353 `DrillWeek.run` |
| A plan combination under 30 does not fire; 30-59 fires half the time | `scripts/rules/FireLevel.gd` `USABLE_AT` l.17, `GAME_SHARES` l.24 |
| The assistant: Rest up at 65+ tired or a weight gap, Train through when a line is near Usable or the opponent is 5+ below, Tick over against a fast starter or by default | `scripts/rules/FightWeekPick.gd` `best_stop` l.52-69 |
| FOUND TODAY: the game never gives the assistant the two facts this task is about - `draft` passes `opp_round1: ""` and `near_usable: false` always | `FightWeekPlan.draft` l.164-165 |
| No opponent file says "fast starter": the files know `slow_starter` only | `scripts/rules/OppFile.gd` l.50-51, 62; `RoundStyle.gd` l.95-96 |
| The stop card shows "tank N off · round 1 sharp/flat" and the best-when line; "Use the pick" applies the draft | `ui/modals/FightWeek.gd` `_stop_card` l.209-229, `_footer` l.272-279 |
| After the bout, tiredness = the toll (45 + half the tank used, +10 a stoppage loss, at least the tiredness before) | `scripts/rules/Aftermath.gd` `toll` l.32; `scripts/state/AfterFight.gd` l.45 |

## 2. The two changes (probe-local rules; nothing under scripts/ changes)

1. **Train through's bank lands before the bell.** At the first bell the week's pad work, at the stop's bank share, is put on
   the plan's combinations (the probe runs `DrillWeek.run` on a copy of the boxer with the locked `fw_bank` and takes the
   copy's combination mastery). A line that crosses Usable (30) fires at its new level in THIS bout. After the bout the
   boxer's mastery is put back so the game's own Sunday drilling adds the same week once (nothing counted twice).
2. **Rest up's flat round reads the opponent.** Rest up costs round-1 power `fast_edge` (start -3, ESTIMATE) against an
   opponent whose file says a fast start, and nothing against a slow starter. Replaces the tiredness bands.
   The probe's file rule (would need `OppFile`): SLOW = the habit `slow_starter` (weak "Slow to start"); FAST = a pressure
   fighter whose threat reads "throws from the first bell", no slow habit.

Train through's tank stays 12, Tick over's 6. The probe may tune `fast_edge` and nothing else; no rule or option is added.

## 3. Menu table (what each shows and is wired to, if built)

| Screen | Shows | Wired to |
|---|---|---|
| Fight week, the three load cards | tank N off; round 1 "flat -3 vs a fast starter" / "flat, costs nothing vs a slow starter" / sharp; the near line: "1-1-2: Usable by the bell" (Train through), "29 of 30" (Tick over) | `FightWeekPlan.bout_tank`; `FightWeek.round_one(start, stop, opp_start)`; a new `FightWeek.bank_preview` = DrillWeek on a copy |
| Fight week, ON FIGHT NIGHT | the tank and its parts (already the bout's); the plan lines firing at the bell, with the one the bank finishes in gold | `bout_tank`; `FireLevel.mastery_of` after the bank |
| The assistant's line + Use the pick | "Train through: a plan move is a week from Usable." / "Tick over: the opponent starts fast." | `FightWeekPick.best_stop` with `near_usable` and `opp_round1` actually filled by `draft` |
| Opponent file | "Starts fast" / "Takes a round to get going" | `OppFile` start read |

## 4. Feedback loops

- Load -> tank and week -> the bout -> the toll -> next week's tiredness -> the load. Cap: the game's own (toll max 95, the
  taper's rest days, `TANK_MAX` 25 on the capped part). The career run prints tiredness at 8 weekly bells per arm; STOP if it
  climbs every week.
- Bank before the bell -> a line reaches Usable -> wins. Mastery does not feed back into the load except through
  "near Usable", which is gone once the line is Usable: a ONE-SHOT per line (the career run shows how many weeks it stays near).
- Opponent's start -> Rest up's cost: one way (the file is fixed for the bout).
- One-rep trial first (mode=trial): one boxer per cell per load, printed in full. STOP if every cell picks the same load, if
  the bout's tank differs from `BoutRules.tank_parts_for` on the same bout, or if any arm never loses.

## 5. Bars (written before any run, never loosened)

Measured on the CHANGED arm; TODAY printed beside as the control. "Best" in a cell = the highest win rate of the three loads on
paired dice (an exact tie counts for each).
1. No load is best in more than 9 of the 18 cells.
2. Each of the three loads is best in at least 3 cells.
3. THE READER beats "always Tick over" by 3 or more wins in 100 (mean over the 18 cells) on BOTH split halves (even and odd
   boxers) separately.
4. The reader beats "Use the pick" as built (`FightWeekPlan.draft`) by 2+ wins in 100 in at least 4 cells - OR the pick
   as built is within 2 of the cell's best in 16+ of 18 cells (then: the pick plays it, the choice is one button).
   The pick with the two facts filled (`best_stop` with true `near_usable` / `opp_round1`) is printed beside.
5. Nothing runs away: the tank off stays inside 0-100; under no arm does mean tiredness at the bell rise in all 7
   week-on-week steps of 8 weekly bouts, and no arm's week-8 mean is more than 10 above its week-2 mean.

THE READER (one sentence a player can say from the screen): "Train through when a plan line is a week from Usable and she is
under 58 tired; Rest up when the opponent starts slow or she is 58 or more tired; otherwise Tick over."
("A week from Usable" = 30 - mastery <= 5 on the line's bar; the probe's `NEAR_GAP`. Set from the one-rep trial before the full
run: a full week's pads put +4.9 on the drilled line by the bell, a half bank +2.5, a fifth +1.0 - so 5 is "one full week".
The trial also set the near line's start at 26 (24 never crossed). The reader's words did not change.)

## 6. The probe

`tools/fwload2_probe.gd` + `tools/fwload2_report.gd`. Booking 7 days before a Saturday bout (`Bouts.accept` ->
`FightWeekPlan.mark`), the load locked with `FightWeekPlan.lock` (no sparring night, no Eat less, no film: the load alone),
then `Sim.step_day` to the bell, then the game's bout (`Bouts.fight_step`, auto corner) with `stale` NOT pre-set.
Population: 24 boxers (Data.lucy re-rated to fight power 54-66, each stat +-3, chin 58-72, records 2-6 wins), women's
lightweight; opponents six named rivals of the wlw sheet re-rated to our power + (-3..+3), same record, same weight class;
fast or slow starters by file. Plan: 1-2 (70, Sharp), 3b-3 (45, Usable), 1-1-2 near (26: a full week crosses 30, a half bank does not) or far (10).
Cells: start tiredness 35/50/58/66 x near yes/no x fast/slow (16) + a bout six days before at 58 (near/fast, far/slow).

## 7. Result

**FAIL: cut the choice; the assistant picks the load.** Full numbers in `docs/FWLOAD2_RESULT.md`.
Train through was best in 0 of 18 cells even with its bank landing before the bell. Rest up was best in 12, Tick over in 7.
The reader scored +0.51 / -0.52 against always Tick over. A perfect per-cell lookup scored +0.78 wins in 100. Bar 5 passes:
no arm runs away. Bars 1, 2 and 3 fail.

Real-world check (the task's Prior research): an amateur coach tapers in the bout week. Volume comes down by roughly
40-60 % and intensity stays (the taper meta-analyses, Bosquet 2007; fatigue that has not cleared costs punch impact,
Chapman 2016 as cited in `BoutRules`). In the game that taper is already the week itself (`WeekPhase.LOAD_WEEKS`). It
clears most of the tiredness before the bell under any load, which is why the load matters so little at the bell.

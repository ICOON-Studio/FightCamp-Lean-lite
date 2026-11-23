# DESIGN DEPTHPRICE1 - code-checked critic (Opus, S543)

Brief: \`ops/research/TASK_DEPTHPRICE1CRIT.md\` -> \`ops/research/CRITIC_DEPTHPRICE1_BRIEF.md\` (critic pack + the page
\`ops/research/DESIGN_DEPTHPRICE1.md\`). Read-only: no game code changed, Godot not run. Everything below was checked against
today's tree (main e97710123). I scored what was measured, not what the page promises. The bar is 8 DEPTH and 8 PLAY (owner S534).

## The two score lines

SCORE fight-week load: DEPTH 4/10, PLAY 5/10 - CHANGE (do not build the flat price as measured)
SCORE sponsorship or day job: DEPTH 3/10, PLAY 4/10 - CHANGE (do not build the evening price as measured)

Neither choice reaches 8. In both cases the measurement that "passed" was helped by how the probe was set up: how the
cells were picked, or a tank rule the bout does not use. The verdicts and the changes that could reach 8 follow the checks.

---

## 1. Every code claim on the page, checked

### Section 1 - the fight week's load

| # | Claim on the page | Verdict | Evidence |
|---|---|---|---|
| 1a | Three loads; the screen opens on Tick over | TRUE | \`scripts/rules/FightWeek.gd\` STOPS / DEFAULT_STOP (l.24-25); \`scripts/state/FightWeekPlan.gd\` \`mark\` l.48 writes \`b["load"] = DEFAULT_STOP\` the day the bout is booked |
| 1b | Tank cost Rest up 0 / Tick over 6 / Train through 12 | TRUE | \`FightWeek.STOP_TANK\` l.28; added after the capped tank in \`BoutRules.tank_parts_for\` l.243-245 |
| 1c | Rest up "rests the boxer down to 30, so tiredness costs nothing" | PARTLY TRUE | Only the TANK reads 30: \`FightWeek.tank\` l.101 and \`BoutRules.tank_parts_for\` l.242 (\`minf(fatigue, REST_UP_TIRED_TO)\`). The boxer's own fatigue is never set to 30. The week runs as WeekPhase's three-rest-day taper (\`WeekPhase.LOAD_WEEKS\` / \`load_stop\`, l.61-73) |
| 1d | "Tiredness over 50 also comes off it, 1 a point, up to 25" | TRUE ON THE SCREEN, FALSE IN THE BOUT | The screen uses \`FightWeek.tired_layer\` (1 a point, cap 25, l.82). The bout uses \`BoutRules.tank_parts\` l.204: **2 a point** (STALE_PER_POINT 2.0), **cap 20** (STALE_MAX), **plus 8 for a bout inside 7 days** (LAST_BOUT l.45), the three capped together at TANK_MAX 25. \`BoutNight._peak\` l.116-119 writes that into \`b["stale"]\`. The tank on the screen is not the tank the boxer fights on |
| 1e | Rest up's round 1 is flat: -2 under 40, -1 from 40 to 64, 0 (Sharp) from 65 | TRUE | \`FightWeek.REST_UP_EDGE\` l.57, \`round_one\` l.126-136; wired: \`FightWeekPlan.lock\` l.315 \`b["r1_edge"]\` -> \`BoutRules.first_round_edge\` l.169 |
| 1f | Training kept: a fifth / half / the whole week | TRUE | \`FightWeek.BANK_SHARE\` l.48; \`FightWeekPlan.lock\` l.312 \`f["fw_bank"]\`; \`DrillWeek.fw_bank\` l.141 scales the week's move/combo mastery |
| 1g | Train through: "+6 tiredness after the bell" | **FALSE (shown, not wired)** | \`FightWeek.tired_after\` has ONE caller: the screen, \`scripts/ui/modals/FightWeek.gd\` l.268 ("Fatigue after the bell +6"). Nothing in the sim adds it. Train through's real cost is its heavier week (\`WeekPhase.LOAD_WEEKS["train_through"]\`, all normal sessions). The probe only invents the +6 itself (below) |
| 1h | Sparring nights cost 3 or 5 | TRUE | \`SPAR_EARLY_TANK\` / \`SPAR_LATE_TANK\` l.33-34, \`night_tank\` l.93. (Eat less, 4, is also on this tank and the page leaves it out) |
| 1i | Menu table: the screen shows the tank, round-1 word, training kept, tiredness now | MOSTLY TRUE | \`ui/modals/FightWeek.gd\` \`_stop_card\` l.209-235 shows "tank N off · round 1 sharp/flat -x" and the BEST_WHEN line. **It does not show training kept (banked) on the card.** \`_right\` shows tank parts, round 1, the win band and fatigue after the bell |
| 1j | (S535 note) Tick over's "one line up" boost | NOT WIRED, now not shown | \`round_one\` still returns \`boost: true\` (l.134), the comment at l.58-59 says no screen promises it, and \`_stop_card\` l.211-212 no longer prints it. Correct as far as it goes |

Also found, not on the page: the assistant already plays this choice. \`scripts/rules/FightWeekPick.gd\` \`best_stop\` l.53-69
picks Rest up at 65+ tiredness or a weight gap, Train through when a move is near Usable or the opponent is 5+ below,
else Tick over. "Use the pick" (\`ui/modals/FightWeek.gd\` \`_footer\`) applies it with one press. Whatever price we pick, the
player's best play is to press the button unless the assistant is wrong (\`sureness\` 0.5-0.99).

### Section 2 - sponsorship or day job

| # | Claim on the page | Verdict | Evidence |
|---|---|---|---|
| 2a | $250 / $125 / $0 a week | TRUE | \`GameMoney.FIGHTER_STIPEND\` 250; \`GymSpend.set_half\` (l.139-151) \`roundi(full * 0.5)\`; \`set_stipend\` l.117-136. (Home juniors pay half of that again, \`HomeJuniors.HALF\`) |
| 2b | Half loses 1 coached morning, day job 2 | TRUE | \`DayJob.HALF_LOST\` 1 / \`LOST\` 2, \`count_of\` l.37-40; \`LOST_DAYS\` Tue, Thu. The mornings are lost twice over: as work days in the coach's deal (\`MorningWire.rows\` l.24-29) AND as a flat (6 - n)/6 multiplier on every stat gain (\`GymSpend\` l.100). I did not confirm whether these count twice in one gain; worth checking |
| 2c | A professional never works | TRUE | \`DayJob.count_of\` l.38; \`set_stipend\` / \`set_half\` refuse "a pro lives on purses" |
| 2d | An unhappy boxer may be approached by a rival club | TRUE | \`Approach.UNDER\` 35 loyalty (l.6, l.74); \`Approach.CAUSE_OFFER\` lists \`day_job\`, \`sponsor_pulled\`, \`wants_sponsor\` as causes of a "keep" offer |
| 2e | The owner keeps the boxer "with a promised club show or by matching the offer (the full sponsorship, held 12 weeks)" | INCOMPLETE | \`ApproachWire.answer\` l.157-200 has FIVE answers: MATCH IT (stipend locked to day + \`WINDOW_DAYS\` 84 = 12 weeks, only for a "keep" offer), HALF EACH (the stipend split with the most loyal team-mate, both train x0.925), MOVE THE STIPEND (a team-mate goes onto a day job, -12 loyalty, may hold a grievance), PROMISE: OUR SHOW, LET THEM GO (\`Approach.BUTTON_WORDS\`) |
| 2f | The new price: the job takes Monday and Wednesday pad evenings, the half deal Wednesday's | TRUE AS A PROBE RULE ONLY (not built, as the page says) | Default pad nights fill Mon / Wed / Fri (\`PadWeek.PAD_ORDER\` [0, 2, 4]). The probe zeroes \`DrillWeek.note\` minutes on dow [2, 0] (\`tools/depthprice1b_probe.gd\` l.213-216). Odd in plain terms: the job takes Tuesday and Thursday MORNINGS (\`DayJob.LOST_DAYS\`) but Monday and Wednesday EVENINGS |
| 2g | Menu table: the office desk and money page show the deal, the weekly cost and the mornings lost, "wired to \`DayJob.count_of\`" | PARTLY TRUE | \`OfficeDesk.gd\` l.334-336 reads \`weekly_salary\` / \`half_job\` / \`day_job\` directly ("half, one work morning" / "day job"); it does not call \`count_of\`. \`MoneyPanels.gd\` l.257-258 shows "half / off / on", and the mornings only in the hover card \`_stipend_card\` l.360-366 ("5 mornings, works Tue" / "4 mornings, works Tue and Thu") |
| 2h | Week plan shows "Work" on the lost mornings via \`DayJob.lost_days\` | TRUE | \`WeekBoard.gd\` l.200 and \`ClubWeek.gd\` l.67 call \`DayJob.lost_days_of\` |
| 2i | Section 5: "nothing feeds back into the deal itself (the player sets it)" | **FALSE** | The approach rewrites the deal. MATCH puts the boxer on the full stipend and LOCKS it for 12 weeks (\`f["stipend_lock"]\`, \`GymSpend.set_stipend\` refuses a change until then). MOVE puts a team-mate on a day job. And the deal feeds loyalty: \`Loyalty.MOVES\` sponsor_pulled -8, sponsor_half_down -4, **wants_sponsor -3 a week** (potential 80+ and no sponsorship for 8 weeks), which leads to an approach under 35. Deal -> loyalty -> approach -> the deal is a loop. It is capped by the 84-day lock and \`Approach.GAP_DAYS\` 84 |

---

## 2. The two probes, checked

### Row 21 - \`tools/depthprice1a_probe.gd\` \`_week_run\` (l.392-417) + \`tools/depthprice1a_report.gd\`

**Does it play what the page says?** Only in part. The bout itself is the game's (\`Bouts.fight_step\` via \`_fight\`), but
the two numbers this choice is about are the probe's own:

1. **The tank is the screen's, not the bout's.** l.400 writes \`keys["stale"] = FightWeek.tank(t, stop, [], false)["off"]\`.
   With \`stale\` already set, \`BoutNight._peak\` l.116 skips the game's own \`BoutRules.tank_parts_for\`. So the probe
   charges 1 a point over 50 (cap 25), with no recent-bout part. The game charges 2 a point (cap 20) plus 8 for a bout
   inside 7 days, capped at 25. **All four bouts in this probe are a week apart, so in the game every one of them carries
   that 8.** What Tick over loses against Rest up at the bell:

   | Start tiredness | Probe (Tick over - Rest up) | Game (Tick over - Rest up) |
   |---|---|---|
   | 48 (the "fresh" cells) | 6 | 6 (14 - 8) |
   | 55 | 11 | 16 (min(25, 10 x 2 + 8) + 6 - 8) |
   | 64 (the "tired" cells) | 20 | 23 |

   In the game the penalty for not resting
   saturates by about tiredness 59, not 75. The measured crossover, and so the size of "+3.1", are numbers about a tank
   the boxer never fights on.
2. **The tiredness carry is invented.** l.414: \`tired = toll * 0.87^7 + load + after\`, with \`load\` the same 20 or 35
   for every stop and \`after\` = the +6 (+14 in arm 1) for Train through. In the game the stop changes the week itself
   (\`WeekPhase.LOAD_WEEKS\`: a 3-rest-day taper / a light week / a normal week), and the +6 is not applied (claim 1g).
   l.411 also starts Rest up's toll from 30, which the game never does (claim 1c). The result page names the carry as a
   "probe estimate". The design page states it as a game rule.
3. **The mastery leg is four weeks long.** \`WEEK_GAIN\` 12 on the lowest line, four bouts. "The mastery a load keeps
   never changed which load was best" is true over a month. The bank's real value is a career of lines reaching Usable,
   and that was not measured.

**Could the bars pass by construction?** Yes, the cell bar. \`WEEK_CELLS\` (l.57-58) is 3 pairings x a training load of
20 or 35 x near/far mastery: **exactly 5 cells at load 20 (start tiredness about 48) and 5 at load 35 (about 64).**
Near/far never changed the answer (the result page says so), so the 10 cells are really 2 tiredness levels repeated
across 3 opponents. A choice whose answer flips anywhere between 48 and 64 will show "about 5 / 5" whatever its depth.
"Rest up 5, Tick over 4, card 1" is that: the five tired cells and the five fresh ones. There is no cell under 40, none
over 70, no weight cut and no fast-starting opponent, which are the states \`FightWeekPick\` actually reads.

**Noise.** The move bar is cross-checked (\`report\`: the best option is picked on one half of the bouts and scored on the
other), which is the right method. But +3.1 against a 3.0 bar, at 100 runs a cell, is on the line. The "coach" policy, a
rule a player can actually follow, gives 42.1 against Tick over's 38.9 (+3.2). So the move is real but small, and it sits
on the wrong tank.

### Row 15 - \`tools/depthprice1b_probe.gd\` (l.146-229, \`_deal\` l.262-280)

**Does it play what the page says?** The evening price yes (l.213-216 zero the noted pad minutes on Mon/Wed). The
approach no. l.171-182 answer every approach automatically, the cheapest way (PROMISE, else MATCH). That removes the one
mechanism that today makes a day job cost something: losing the boxer, or being forced onto the full stipend. The
result page's own first finding says the old "one answer" came entirely from the approach. The re-measure then cancelled
the approach out.

**Are the cells different?** No. **fresh, backed and short at the same seed set have identical records in every arm**
(result tables: fresh/4421, backed/4421 and short/4421 are all 68.6 % of 51 on FULL, 66.7 % of 51 on HALF, 71.2 % of 52
on JOB; the same holds at 9001). The club kind only moves the cash. So 6 of the 10 cells are 2 cells counted three
times. Counted once each, the second price's "FULL 3, HALF 3, JOB 4" becomes **FULL 3, JOB 2, HALF 1 out of 6 distinct
cells**.

**What "best" means.** The by-cell tables pick best by the RECORD alone: test/9001 is "FULL" at 57.6 % while JOB ends
$20,546 richer, and debt/9001 is "FULL" while JOB ends $4,017 richer. Money, the thing a day job is for, does not count
in the cell bar.

**Noise.** 4 careers a cell, about 51 bouts (fresh kinds) to 150 (test). One cell's record has a standard error of about
6.5 points at 51 bouts, so most "best" calls between 68.6 and 71.2 are coin flips. The pooled gap (2.9 in 100, noise
about 2) is the page's own warning, and I agree with it. Two cells moved far more than the price can explain (debt/4421
JOB 90.0 % -> 66.7 %, a 23-point fall from two pad nights): once one bout goes differently the careers diverge (other
bookings, other opponents), so the "paired" dice stop being paired. **"No option best in more than 6 of 10" passes by
noise and duplicated cells.** The result page also says the price is near its floor: lost pad nights did not lower
mastery (446 / 471 against 453), because the coach's drill plan absorbs one or two lost nights.

---

## 3. The verdict for each choice

### Fight-week load: CHANGE

Do not build \`REST_UP_EDGE = -3 flat\` / \`STOP_TANK.train_through = 8\` on this evidence. It was measured on the screen's
tank rule, with an invented tiredness carry. The probe's own reading stands even so: the choice is a lookup on one
number, and the game's assistant (\`FightWeekPick.best_stop\`) already does that lookup.

The change, tied to states the player can see and to code that exists:

1. **Fix the defects first (no design call needed):** make the screen's tank the bout's tank. Either \`FightWeek.tank\`
   calls \`BoutRules.tank_parts_for\`, or \`FightWeekPlan.read\` shows the bout's parts (tired 2/pt, last bout 8, cap 25).
   Then either wire \`FightWeek.tired_after\` into the post-bout fatigue (\`Aftermath\` / \`BoutNight._finish\`) or delete the
   "+6" line from \`ui/modals/FightWeek.gd\` l.268.
2. **Give Train through a value of its own: the bank lands before the bell.** If a Train-through week's bank pushes a
   plan line past \`FireLevel.USABLE_AT\`, that line fires at its new level IN THIS BOUT (Tick over: only if the half-bank
   gets there). The state is visible: the plan line's mastery bar and its distance to Usable. The assistant already
   names that state (\`FightWeekPick\` fact \`near_usable\`; \`BEST_WHEN.train_through\`). Today the bank changes nothing
   until weeks later, which is why the probe saw it "never change the answer".
3. **Give Rest up's flat round a value that reads the opponent:** the flat round costs its edge only against an opponent
   whose file says he starts fast (\`FightWeekPick\` fact \`opp_round1\`, the opponent file's habits, \`OppFile\`), and
   nothing against a slow starter. The state is the scouting file the player already builds.
4. Re-probe on the game's own tank (do not pre-set \`stale\`; let \`BoutNight._peak\` call \`tank_parts_for\`) and the game's
   own week (\`WeekPhase.LOAD_WEEKS\` fatigue through \`Sim.step_day\`), with cells along THREE axes: tiredness (35 / 50 /
   58 / 66), a line near Usable (yes / no), opponent fast or slow starter. If no option is then best in more than half
   the cells and the readable rule beats "always Tick over" by 3+, build it.

If step 4 fails: **CUT the choice** - the assistant picks the load. What is lost: one click and the feel of setting the
week. What is kept: the tank bar and the sparring nights, which are the screen's real decisions. Nothing a player would
notice over a season is lost, because today a player who presses "Use the pick" every week plays it correctly.

### Sponsorship or day job: CHANGE

Do not build the evening price. It is below noise, the result says it is near its floor, and it was measured with the
approach switched off. The real cost of a day job is in the code already: loyalty (\`Loyalty.MOVES\` wants_sponsor -3 a
week for a potential-80+ boxer without sponsorship, sponsor_pulled -8) leading to \`Approach\` (CAUSE_OFFER \`day_job\` ->
a "keep" offer) and a boxer who leaves or forces a 12-week locked stipend. That is a real club owner's dilemma: who gets
the money, and who you can afford to upset.

The change:

1. **Make it one allocation, not three deals a boxer.** The club has a sponsorship budget (start: one full stipend). The
   player gives full, half or nothing to each boxer from it. The decision becomes WHICH boxer, read from visible states:
   potential (the 80+ that \`wants_sponsor\` reads), loyalty (the mood number on the desk), the next bout's date. The
   probe's TOP1 arm is the first version of this, and it landed between FULL and JOB on money with the same record.
2. **Make the approach impossible to miss** (the result's own advice): the approach card stops the clock, as the modals
   do (pack 5.9). The probe must answer it with a player policy (keep the high-potential boxer, let the others go), not
   the cheapest automatic answer.
3. **Put the lost evenings on the job's days.** If evenings are priced at all, the job takes the evenings of its own work
   days (\`DayJob.LOST_DAYS\` Tue/Thu -> the sparring nights, \`PadWeek.SPAR_DAYS\` [1, 3]). Sparring nights ready plan lines
   for the bout (\`FightWeek.ready_lines\`), and the fight-week screen shows it. That puts the price where the player looks.
4. Re-probe with distinct cells (drop backed/short, or give them different rosters), 12+ careers a cell, and "best" scored
   on record AND cash AND boxers kept (a boxer lost to the approach counts).

If that fails: **CUT the three-way deal**: a stipend on/off only, priced by the approach. What is lost: the half deal,
which is today's "middle" option and best nowhere it counts.

---

## 4. Fight-week load - full critic answer

**What it changes today:** the tank at the bell (in the bout's rule, not the screen's), round 1's edge for Rest up, the
week's mastery bank, and the shape of the week (taper / light / normal).

**Missing options**
- Training kept is not on the stop card (\`_stop_card\` shows tank and round 1 only). The page's menu table says it is.
- The bout's real tank (last bout 8, 2 a point) is not on the screen. A boxer fighting every week sees one number and
  fights on another.
- No sign of what the bank buys THIS bout (see change 2).
- The opponent's start (fast or slow) is not beside the round-1 word, so "flat" cannot be judged.

**Useless options**
- "Fatigue after the bell +6": shown, not applied.
- Train through as it stands: worst in all 10 cells today and best in none at the price. Without change 2 it is a trap
  option.
- The \`boost\` key in \`round_one\`: dead data.

**To reach 10/10** (most important first)
1. One tank: the screen shows \`BoutRules.tank_parts_for\`'s parts (tiredness 2/pt, last bout, weight, cap), then the
   week's choices.
2. Train through's bank lands before the bell: a line crossing Usable fires at its new level in this bout, shown on the
   card as "1-2: Usable by Friday".
3. Rest up's flat round priced by the opponent's start, read from his file, shown as "flat -3 vs a fast starter /
   -0 vs a slow one".
4. Wire or delete the +6.
5. Re-probe on the game's tank and week, with three state axes. Build only if it passes there.
6. The stop card says in one line what each load costs and buys THIS week, in game words (owner S532: tooltips explain).

**My 10/10 page (fight-week load)**

\`\`\`html
<!doctype html><html><head><meta charset="utf-8"><title>Fight week 10/10</title><style>
body{margin:0;width:1920px;height:1080px;background:#14161a;color:#e8e6e1;font:20px/1.35 "Segoe UI",sans-serif}
.top{padding:28px 48px;border-bottom:1px solid #2c3038;display:flex;justify-content:space-between}
h1{margin:0;font-size:34px}.muted{color:#8c929c}.gold{color:#e2b85a}.red{color:#e06a5a}.green{color:#6cc28a}
.wrap{display:grid;grid-template-columns:1180px 1fr;gap:36px;padding:32px 48px}
.cards{display:grid;grid-template-columns:repeat(3,1fr);gap:18px}
.card{background:#1d2026;border:2px solid #2c3038;border-radius:10px;padding:20px}
.card.on{border-color:#e2b85a}.card h2{margin:0 0 10px;font-size:26px}
.row{display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid #262a31}
.tag{font-size:16px;padding:2px 8px;border-radius:4px;background:#262a31}
.why{margin-top:12px;font-size:17px;color:#b9bcc2}
.panel{background:#1d2026;border-radius:10px;padding:22px}
.bar{height:22px;background:#262a31;border-radius:4px;overflow:hidden;display:flex;margin:10px 0}
.bar span{display:block;height:100%}
.states{display:grid;grid-template-columns:repeat(3,1fr);gap:18px;margin-bottom:22px}
.state{background:#1d2026;border-radius:10px;padding:16px}
.state b{font-size:28px;display:block}
.btn{display:inline-block;padding:14px 30px;border-radius:8px;background:#e2b85a;color:#14161a;font-weight:700;margin-right:12px}
.btn.q{background:#262a31;color:#e8e6e1}
</style></head><body>
<div class="top"><div><h1>Fight week · Lucy Jackson</h1><div class="muted">Amateur bout Saturday vs Priya Nair · no camp</div></div>
<div class="muted">5 days to the bell</div></div>
<div class="wrap"><div>
<div class="states">
<div class="state"><span class="muted">Tiredness now</span><b class="red">58</b><span class="muted">over 50: 2 off the tank a point</span></div>
<div class="state"><span class="muted">Her 1-1-2</span><b class="gold">27 / 30</b><span class="muted">one full week from Usable</span></div>
<div class="state"><span class="muted">Priya's file</span><b>Slow starter</b><span class="muted">a flat round 1 costs little</span></div>
</div>
<div class="cards">
<div class="card"><h2>Rest up</h2>
<div class="row"><span>Tank at the bell</span><span class="green">84</span></div>
<div class="row"><span>Round 1</span><span>flat <span class="tag">-1 vs a slow starter</span></span></div>
<div class="row"><span>1-1-2 by Saturday</span><span class="muted">28 · still Raw</span></div>
<div class="why">Takes the tiredness off the tank. Best when she is tired and he starts slow.</div></div>
<div class="card"><h2>Tick over</h2>
<div class="row"><span>Tank at the bell</span><span class="red">69</span></div>
<div class="row"><span>Round 1</span><span>sharp</span></div>
<div class="row"><span>1-1-2 by Saturday</span><span class="muted">29 · still Raw</span></div>
<div class="why">The normal week. Sharp from the bell, but every point of tiredness counts.</div></div>
<div class="card on"><h2>Train through</h2>
<div class="row"><span>Tank at the bell</span><span class="red">61</span></div>
<div class="row"><span>Round 1</span><span>sharp</span></div>
<div class="row"><span>1-1-2 by Saturday</span><span class="gold">31 · USABLE this bout</span></div>
<div class="why">Finishes the 1-1-2 before the bell. She is tired for it. Worth it only if the combo wins the fight.</div></div>
</div></div>
<div class="panel"><div class="muted">ON FIGHT NIGHT</div>
<div class="row"><span>The tank at the first bell</span><b>61</b></div>
<div class="bar"><span style="width:61%;background:#6cc28a"></span><span style="width:16%;background:#6b7079"></span><span style="width:8%;background:#8a6d3b"></span><span style="width:12%;background:#e06a5a"></span></div>
<div class="row"><span>&nbsp; Tiredness (58)</span><span class="red">-16</span></div>
<div class="row"><span>&nbsp; Fought 7 days ago</span><span class="red">-8</span></div>
<div class="row"><span>&nbsp; Train through</span><span class="red">-12</span></div>
<div class="row"><span>Plan lines firing</span><span>1-2 Sharp · 3b-3 Usable · <span class="gold">1-1-2 Usable</span></span></div>
<div class="row"><span>Win chance on this plan</span><b>52% to 61%</b></div>
<div class="row"><span>Tiredness after the bout</span><span>about 66</span></div>
<p class="muted">The assistant would pick Rest up: "she is still tired from the last weeks".</p>
<span class="btn q">Use the pick</span><span class="btn">Lock the week</span></div>
</div></body></html>
\`\`\`

---

## 5. Sponsorship or day job - full critic answer

**What it changes today:** cash ($250 / $125 / $0 a week), coached mornings (and a flat stat-gain multiplier), loyalty
on every change, and through loyalty the rival club's approach.

**Missing options**
- Who gets the money. The real question, "which of my boxers do I fund?", has no screen. Each boxer is set alone.
- The loyalty cost is not shown at the moment of the choice (only "Stopping costs loyalty" in the hover card).
- The approach risk: no line says "potential 80+ without a sponsor: -3 loyalty a week, the rival club comes under 35".
- A fixed term: real club sponsorships run for a season or to a target. Here it can be flipped every week. Only the
  approach's 12-week lock gives it any weight.

**Useless options**
- The half deal: best nowhere once the cells are de-duplicated (1 of 6), and between the other two on every number.
- The evening price as measured: cancelled by the coach's drill plan (mastery 446-471 against 453).

**To reach 10/10** (most important first)
1. One sponsorship budget the player splits across the boxers, on one panel, each boxer's potential, loyalty and next
   bout beside the money.
2. The loyalty and approach consequence printed at the moment of choice ("-8 now; -3 a week after 8 weeks; Eastside comes
   under 35").
3. The approach stops the clock, so it cannot be missed.
4. Terms: a sponsorship set for 12 weeks (the approach's own window), so the choice lasts.
5. If a training cost stays, put it on the job's own days and on sparring nights, which the fight week shows.
6. Re-probe with distinct cells, a player policy for the approach, and "best" judged on record, cash and boxers kept.

**My 10/10 page (sponsorship)**

\`\`\`html
<!doctype html><html><head><meta charset="utf-8"><title>Sponsorship 10/10</title><style>
body{margin:0;width:1920px;height:1080px;background:#14161a;color:#e8e6e1;font:20px/1.35 "Segoe UI",sans-serif}
.top{padding:28px 48px;border-bottom:1px solid #2c3038;display:flex;justify-content:space-between;align-items:flex-end}
h1{margin:0;font-size:34px}.muted{color:#8c929c}.gold{color:#e2b85a}.red{color:#e06a5a}.green{color:#6cc28a}
.budget{font-size:26px}.budget b{font-size:36px}
table{width:calc(100% - 96px);margin:28px 48px;border-collapse:collapse}
th{text-align:left;color:#8c929c;font-weight:400;font-size:17px;padding:10px;border-bottom:1px solid #2c3038}
td{padding:16px 10px;border-bottom:1px solid #22262d;vertical-align:top}
.seg span{display:inline-block;padding:8px 16px;border:1px solid #3a3f48;margin-right:-1px}
.seg .on{background:#e2b85a;color:#14161a;font-weight:700;border-color:#e2b85a}
.warn{font-size:17px}.big{font-size:24px;font-weight:700}
.alert{margin:0 48px;background:#2a1d1d;border:1px solid #e06a5a;border-radius:10px;padding:18px 22px;display:flex;justify-content:space-between}
.btn{display:inline-block;padding:10px 22px;border-radius:8px;background:#262a31;margin-left:10px}
.btn.g{background:#e2b85a;color:#14161a;font-weight:700}
</style></head><body>
<div class="top"><div><h1>The club's sponsorship</h1><div class="muted">Set for 12 weeks · next review 14 Feb</div></div>
<div class="budget">Budget <b class="gold">$375</b> of $500 a week <span class="muted">· runway 9 weeks</span></div></div>
<table><tr><th>Boxer</th><th>Potential</th><th>Loyalty</th><th>Next bout</th><th>Deal</th><th>Trains</th><th>What it does to her</th></tr>
<tr><td class="big">Lucy Jackson</td><td class="gold big">84</td><td>41 <span class="muted">Settled</span></td><td>Sat · Priya Nair</td>
<td class="seg"><span class="on">Full $250</span><span>Half $125</span><span>Job</span></td><td>6 mornings · 3 pad nights · 1 spar</td>
<td class="warn green">Kept happy. Without it: -8 now, then -3 a week after 8 weeks. Eastside comes under 35.</td></tr>
<tr><td class="big">Jo Brennan</td><td class="big">71</td><td>62 <span class="muted">Loyal</span></td><td>in 3 weeks</td>
<td class="seg"><span>Full $250</span><span class="on">Half $125</span><span>Job</span></td><td>5 mornings (works Tue) · 3 pads · 1 spar</td>
<td class="warn">Loyal enough to wait. Half costs her 1 morning a week.</td></tr>
<tr><td class="big">Sam Okafor</td><td class="big">63</td><td class="red">33 <span class="muted">Restless</span></td><td>none booked</td>
<td class="seg"><span>Full $250</span><span>Half $125</span><span class="on">Job</span></td><td>4 mornings (works Tue, Thu) · 3 pads · <span class="red">no Tue/Thu spar</span></td>
<td class="warn red">Under 35: Eastside may come for him this week.</td></tr></table>
<div class="alert"><div><b class="red">Eastside ABC wants Sam Okafor.</b> <span class="muted">Their backers pay his keep. The clock is stopped.</span></div>
<div><span class="btn">Match it ($250, 12 weeks)</span><span class="btn">Move Jo's half</span><span class="btn">Promise our show</span><span class="btn g">Let him go</span></div></div>
</body></html>
\`\`\`

---

## Code files opened
- \`scripts/rules/FightWeek.gd\` (whole), \`scripts/rules/DayJob.gd\` (whole)
- \`scripts/ui/modals/FightWeek.gd\` l.175-286; \`scripts/ui/OfficeDesk.gd\` l.320-345; \`scripts/ui/MoneyPanels.gd\` l.245-280, 355-370
- \`scripts/state/GymSpend.gd\` l.100-160; \`scripts/state/FightWeekPlan.gd\` l.38-70, 230-340; \`scripts/state/ApproachWire.gd\` l.140-200
- \`scripts/rules/BoutRules.gd\` l.30-45, 160-260; \`scripts/state/BoutNight.gd\` l.100-125; \`scripts/rules/WeekPhase.gd\` l.55-80
- \`scripts/state/DrillWeek.gd\` l.125-150; \`scripts/rules/PadWeek.gd\` l.1-60; \`scripts/rules/WeekPlan.gd\` l.160-175
- \`scripts/rules/FightWeekPick.gd\` l.1-110; \`scripts/rules/Approach.gd\` l.1-70; \`scripts/rules/Loyalty.gd\` l.35-60
- \`scripts/state/MorningWire.gd\` l.1-45; \`scripts/state/ClubWeek.gd\` l.55-80; \`scripts/ui/WeekBoard.gd\` l.192-212
- git grep hits only: \`Aftermath.gd\` (REST_KEEP, toll), \`GameMoney.gd\` (FIGHTER_STIPEND), \`Bouts.gd\` l.321, \`Injuries.gd\` l.259
- Probes: \`tools/depthprice1a_probe.gd\` l.1-66, 339-455; \`tools/depthprice1a_report.gd\` (whole); \`tools/depthprice1b_probe.gd\` (grep windows l.1-60, 116-229, 262-292)
- Results: \`docs/DEPTHPRICE1A_RESULT.md\`, \`docs/DEPTHPRICE1B_RESULT.md\`

# KNOW_STAKES1_V4 — Fresh Critic (Arena)
Date: 2026-11-20 — Critic: Arena (sports management-sim designer, boxing)
Brief read: ops/research/DESIGN_KNOW_STAKES1_V4_CRITIC_DOLA.md (critic pack + map v4). No other *_CRITIC_* file was opened.

SCORE depth=4 general=5

## 1. DEPTH — 4 / 10

What the mechanic wants to be is right: in real boxing a habit changes what you do on the night. A coach who knows the other corner's fighter drops the right after the jab tells his boxer to time the lead hook over it; a fighter who freezes on the ropes tells you to cut the ring and stay long. Angelo Dundee shouting "you're blowing it, son" to Leonard against Hearns, or the Kronk habit of slipping the wild hook when hurt and firing back, are not flavour — they decide who wins a close round. The game already has the right cost for this: a punished habit costs 10.5 power before fixes (HabitFix 6.0 × 1.75 in Exchanges), against a best call worth 17 and a wrong call −10. In a six-exchange round that is roughly one exchange decided — enough to flip a 3-3 round.

The problem is that the player can barely act on that cost.

**Only two levers exist.** At signing you can pick "Fix the habit" and after four weeks that one habit disappears from your boxer's array (Recruit.FOCUS habit + Sim.end_week). In the bout you can tick one corner fix for the next round, and it saves a share of the cost equal to how much of the corner your boxer takes in (Exchanges.uptake × FighterProfile.trust, halved if the bout is flagged hot). That is it. There is no weekly pad drill for habits, no camp focus that trains a habit out gradually, no choice of which of two habits to work on — the signing focus always takes the first habit in the list.

**No trade-off before signing.** All six pre-signing reads — look closer ($120), test day ($60), trial ($500), recheck ($40), hard spar club ($0) and hard spar outside ($160) — explicitly do not reveal habits. They narrow attribute uncertainty (body, skills, under-fire) by adding exposure that shrinks the half-width toward a floor of 0.5. They never write to notes_seen. So a player who is choosing between two prospects on habit risk cannot buy habit information at any price. The recruitment card does show one suspected habit with its effect line, but that line is not written to the notebook and the map's promise that the button disables when "no decision changes" has no code behind it. You pick blind on habits, then fix blind for four weeks.

**No decision at offer.** The map describes a risk banner that appears when your known, punishable habit intersects the opponent's most likely mode (for example your boxer drops the right after the jab and the opponent is a counter-puncher who lives in counter 0.55). That banner does not exist in code. At the moment you must decide Accept / Pass you get record, style word, threat and weak as free, plus the win band whose width reflects scouting — but nothing tells you whether your own habit will be punished. The one place the design would pay — "do I take this opponent with this habit?" — is silent.

**Game plan is mostly dead space.** Only seven of twenty habits have a sit in PlanLines.HABIT_SITS: fades_late and slow_starter and admires work map to tiring, drops_right maps to range, lunges maps to press, digs body and loads up map to hurt. The other thirteen habits are visible in the notebook but the plan screen has no line that answers them. The map proposes to label that "Observed — no line yet," but no screen does so. A player who finds a habit often finds there is nothing to write.

**Clock and state triggers have no answer at all.** Slow starter costs exchanges 1–2 of round one and fades late costs from exchange three of the final round. Both are real and costly, yet neither has a plan sit that a coach would expect ("start busy, bank round one" and "make it busy late" exist as words in the map but the code's PlanLines does not contain a distinct fix for the clock; it reuses the same tiring sit as fades). Clinches when tired, loads up when hurt, covers up when hurt are state triggers that depend on your boxer's own fatigue or damage, not on the opponent — you cannot plan for them, only react.

**Dominant pick.** Because the only permanent fix is free except for the opportunity cost of the other two signing focuses (+10 mastery on the signature now, or +5 potential everywhere), and because habits never change over time, the correct play is always: if your starter has a bad habit, take the habit fix; otherwise take ceiling. There is no later moment where you wish you had taken signature instead. Inside the bout the dominant pick is to fix the one habit that has fired most often — the corner offers exactly the seen, fixable habits via HabitFix.offers, and the choice is obvious when one habit is costing every press exchange.

**Interaction is thin.** Habits interact with only three systems: the exchange settlement (the 10.5 point debit), the corner minute (one fix), and the four-week trait erase. They do not touch matchmaking (no duck/owe logic for habits), money (no purse change), morale except indirectly through losing exchanges, coaching (no coach rating changes reveal speed), or the world (rivals keep habits but never evolve). The habit that helps you — digs to the body when hurt — is the only positive one and it carries no cost, so you never need to build around it.

Real boxing evidence says habits should be the hinge of a close fight. Here they are a tax you cannot see coming, cannot shop for, and can only patch once a round or erase once at birth.

## 2. GENERAL DESIGN — 5 / 10

**What is clear.** The words are consistent where it counts: Raw / Usable (30) / Sharp (60) / Signature (85) for moves, Fired up / Steady / Flat / Low for morale, press / range / counter / loadup / tiring / hurt for opponent modes. A habit is a visible trigger with a beat and an effect, a coach note is a quoted line, a fix is a next-round instruction. The 10.5-point cost is shown consistently as −10.5 power per triggering exchange before fixes, which is what the engine uses. The six reads are priced exactly as coded (120, 60, 500, 40, 0 and 160) and their narrowing maths is transparent.

**What is not clear.** The map invents tiers, banners and labels that the code does not have, and it mislists which habits are free:

- It says seventeen habits have a punished situation and three have no penalty, then lists the three as digs_body_when_hurt, switches_stance_under_pressure and talks_when_ahead. In HabitFix.PUNISHED_BY the three absent are digs_body_when_hurt, slow_starter and fades_late. The latter two are not free — they are punished by the clock (EARLY 2, LATE 3). The two habits it calls free are both punished on press and counter respectively. A player who trusts that table will think a stance switch under pressure is safe; it is not.

- It says corner fix cost is HABIT_COST × (1 − uptake × trust). The engine does cost × (1 − hold) where hold is uptake × trust, but uptake itself is not just coachability — it is 0.7 + 0.3 × coachability/100, halved after the first two shouts in the round, and halved again if the bout is hot. The map hides the shout tax.

- It tags eighteen risk-banner rows as CODE when no banner code exists. In v3 the same banner was correctly tagged ESTIMATE. Promotion to CODE without implementation is the largest honesty failure.

- It tags roster, fighter overview, prospect card, fight-prep plan, week screen and post-bout recap as CODE showing notebook summaries, trigger words, penalty flags, plan-line availability and click-to-jump. The real screens show far less: RosterCards builds painted full-body cards with weight/mood/condition tiles and a single RosterFlag (camp / offer / weight / mood low) — no notebook count or highest-risk flag. FighterPage's overview shows Coach's Notes as up to N-of-M quoted lines from fight_habits.json with progress [seen, seeable] — no trigger description, no penalty column, no plan availability, no click target. The prospect card shows a habit line with its effect but not a "Coach suspects — not yet confirmed" separation, and it never disables reads when no decision changes. Fight prep's tale and camp cards show weight, camp line, towel and film rows, but not "Observed — no line yet" for thirteen habits.

**Buildable, but with dead weight.** Everything that is actually coded is buildable from what the game has: the twenty-row JSON, the two-element habit array on the fighter, notes_seen with habit: prefix, the deterministic reveal helpers, the 6.0 / 1.75 arithmetic, the clock constants, the six read prices. The dead weight is the six reads for habit purposes — if the goal is knowledge stakes, paying $120 to halve a body group when your question is "does my boxer freeze on the ropes?" is not a choice, it is noise. The green-labelled helpful habit is also dead weight as designed — it tells you to "build around it" but gives you no tool to build.

**Consistency with owner rules.** The game says every screen shows only what you can act on, has one art style, and says names only in headers. The notebook respects that (your boxer / the opponent in notes). The map respects it. The invented banner text also would, if built. No rule is broken, but the map's claim that unmapped habits are "clearly labelled" breaks the rule that nothing appears unless you can do something about it — showing a dead-end line is still showing something you cannot act on.

General design is halfway there: the core noun and verb are right, but the paper claims features that are not in the room, and it miscounts its own penalty table.

## 3. Missing options — and what each would change

If the head coach asks "did knowing this change what we did that night, and did it pay?", these are the places where the answer is still "we didn't know":

1. **A read that tests the habit itself.** No pre-signing read touches notes_seen. Change: add a $120 "ask around" or "call the old gym" read that reveals one suspected habit as "coach has heard this — not yet confirmed" before you sign. Trade-off: cash now versus living with a 10.5-point tax for a whole amateur run. Without it, signing is blind on the only permanent defect.

2. **A weekly pad lever.** The map correctly notes no code reduces habit cost gradually. Change: let a pad night slot take a known habit as its drill, adding about 6 mastery to a habit resistance that halves the cost at 30. Cost is the move or combination you did not drill that week, and fatigue. Gives the week a habit reason to exist.

3. **Priority reveal.** Today CoachNotes.reveal picks the first unseen in pool order (habits first, then traits). Change: let the player mark one unseen habit as "watch for this" and reveal it next time it fires. Costs nothing but attention; makes sparring feel directed.

4. **Thirteen plan answers.** Thirteen habits have no sit in PlanLines.HABIT_SITS. Change: map each to an existing situation (for example freezes_on_ropes → press with "pivot out," switches_stance → press with "step back," talks_when_ahead → counter with "draw the lead," wide_hook_tell → range with "throw short," etc.). Change: one new line per habit, no new system.

5. **Trigger text in the notebook.** The notebook shows the note line but not the trigger ("back touches the ropes," "after a jab at range," "last 60 seconds"). Change: show trigger under the quote and the punished situation as a tag (press / counter / loadup / she hurt …). No cost, just clarity.

6. **Habit develops.** Today a fighter is born with two random habits and never gains or loses one except via the four-week erase. Change: after a stoppage loss or a layoff, roll a small chance to add a habit from a short list (covers_up, clinches_when_tired). After a year without that trigger, roll to lose it. Makes habits a career arc.

7. **Opponent habit scouting distinct from weapon scouting.** Today tape study opens weapon, then top unfree mode, then all habits in creation order, then second mode, then weakness (OppFile + ModeTells). Habits are buried in the middle. Change: let the second tape session after weapon be "habit night" that opens one habit of your choice if you pay a coach night. Costs a sparring night.

8. **A number on the habit.** Today the Why line says "habit cost your boxer an edge, but still took the exchange" but not how much. Change: add to the round summary "habit fired 2 times, cost 21 power (about one exchange) — fix saved 60%." Makes the tax visible.

## 4. Useless options — and what each changes (or doesn't)

1. **Look closer, test day, trial, recheck for habit purposes.** They narrow body/skills/under-fire half-widths (8–16 exposure for test day, 24 for trial's body and skills, half stale for recheck) but never touch notes_seen. If your question is habits, they change nothing except cash (−$40 to −$500) and time. Keep them for attribute shopping; hide or grey them when the only open question is habits.

2. **Hard spar club and outside.** They add +7.25 and +10.875 under-fire exposure and multiply injury ×2 and fatigue +15. They open under-fire for attribute range purposes, but not habit discovery. As habit tools they are pure injury risk for no habit signal — useless.

3. **The helpful habit as a tile.** Digs to the body when hurt is flagged helpful with no penalty. It appears in the notebook and counts toward seen/seeable, but has no cost, no fix, no plan line. It changes the card count and nothing else. Either give it a positive edge when it fires (for example +3 power when she_hurt and it triggers) or remove it from the habit bank and make it a trait.

4. **Corner fix for slow starter.** Fixable in code is PUNISHED_BY ∪ {fades_late}. Slow starter is not fixable because it fires only before the first corner (round 1, exchanges 1–2). Offering it as a fix does nothing; showing it wastes a button. Remove it from offers — the code already does — but the map's table still lists it as fixable.

5. **Fades late fix when bout is 3×3.** Fades late fires from exchange 3 of the final round (LATE 3). In a 3-round amateur bout that is the last 90 seconds of the night. A next-round fix cannot happen because there is no next round. The corner option exists but never helps in the only bout length new players see. Limit its offer to bouts of 6+ rounds.

## 5. What every existing option actually changes

- **Signing focus "Sharpen the signature"** — +10 mastery on the fighter's best move now (Recruit signature = highest mastery 30+ else best). Changes early punch success about 1 win in 100 at usable vs raw, more if sharp later.
- **Signing focus "Fix the habit"** — writes habit_fix {id, until = day+28}. Sim.end_week erases that id from habits when day ≥ until. Permanent removal of one habit's 10.5-point tax. Costs the signature or ceiling you did not take.
- **Signing focus "Raise the ceiling"** — pot +5 (cap 99) and ceiling_of per ability rises accordingly. Changes training headroom for the first year.
- **Look closer ($120)** — if hyped, clears hype; else finds widest of body/skills/under-fire (if opened) and raises its exposure until its half-width is half its day-one width (8.0/12.0/15.0 → 4.0/6.0/7.5). Changes estimate range, not habit.
- **Test day ($60)** — adds 8 body exposure, 16 if bout_count <5. Changes body half-width toward floor 0.5.
- **Trial ($500)** — adds 24 body, 24 skills, 8 fire_spar if under-fire opened. Changes body and skills toward exact, for four weeks' stipend cost.
- **Recheck ($40, every 21 days)** — halves stale_fire and stale_body (stoppage +6.0, layoff +3.0, step_up +4.0, age +2.0). Re-sharpens a stale file.
- **Hard spar club ($0)** — +15 fatigue, ×2 injury this night, (15−0.5)×0.5 = 7.25 under-fire exposure, opens under-fire if shut.
- **Hard spar outside ($160)** — same but +10.875 exposure (×0.75).
- **Bout Accept / Pass** — books day, opens tape study schedule (one session every 2 camp days), starts WeekPhase taper logic. No habit signal today.
- **Plan line at a place (long, mid, inside, etc.)** — writes an arrow {move, when}. When the fight is at that place and the situation matches its when (or the opponent's main game if no when), that line is chosen; its edge is PlanFight.value − card_mean × rate, and Fit best/ok/wrong is rated. Changes exchange edge by roughly −10 to +17 adjusted by mastery.
- **Corner fix (one per round)** — if habit == fix, its cost that exchange is 0; else full 10.5 × (1 − hold). Hold is uptake×trust (0.7–1.0 × 1.05/1.0/0.85/0.7), with late-shout and hot modifiers. Changes at most ~6.3 to 10.5 power per exchange where habit fires.
- **Sparring session reveal** — 35% chance per session to reveal one unseen item (habits first). Changes notes_seen count by one.
- **Post-bout coach note** — one unseen item after every bout, deterministically first in pool. Changes notes_seen by one.
- **Tape study (opponent)** — one hidden tell per full session, two half-sessions equal one full via half_tape flag. Repeats across rematches via remember() union. Changes OppFile file_found and, for habits, opp notes_seen.

## 6. CODE CHECK — every line the map tags CODE, and what the code really does

Files opened for this check: assets/data/fight_habits.json, scripts/rules/HabitFix.gd, scripts/rules/Exchanges.gd, scripts/rules/PlanLines.gd, scripts/rules/ModeTells.gd, scripts/rules/CoachNotes.gd, scripts/rules/OppFile.gd, scripts/rules/KnowReads.gd, scripts/rules/Knowledge.gd, scripts/state/KnowWire.gd, scripts/rules/Recruit.gd, scripts/state/LiveRound.gd, scripts/state/BoutFinish.gd, scripts/state/Sim.gd, scripts/rules/FighterProfile.gd, scripts/state/Data.gd, scripts/ui/RosterCards.gd, scripts/ui/areas/FighterPage.gd, scripts/ui/FightAnalysisOwn.gd, scripts/rules/RosterFlag.gd, scripts/rules/CoachCheck.gd, scripts/ui/FightPrep.gd.

For each row below: ✓ = code does what the map says, ✗ = it does not, with reason.

**1. What the Game Already Does — Habit Storage & Discovery**

- ✓ Habit bank 20 entries with id, name, trigger, beat, effect, punish, three notes — fight_habits.json has exactly 20, each with those keys, matches.
- ✓ Fighter habits as f["habits"] array of ids, never added to at runtime except erasure — FighterProfile.make picks two random HABITS, Sim.end_week only erases via habit_fix, never adds. Correct.
- ✓ Coach's notebook as f["notes_seen"] "habit:id" / "trait:key", retained — CoachNotes.seeable/reveal and LiveRound close append exactly that format, never removed. Correct.
- ✓ Initial state empty at signing, recruitment habit not written until confirmed — KnowWire.start creates fresh know, no notes_seen; RecruitPanel shows habit line but no code writes notes_seen there; first write is sparring 35% or punished-in-bout or post-bout. Correct.
- ✓ Opponent habits stored in OppFile, tape()/open_all()/remember() persists — OppFile.tells builds habit tells, tape opens one, open_all loops tape, remember unions file_found and notes_seen into career rival record. Correct.

**1.2 Reveal Paths**

- ⚠ Punished in bout — one habit that cost added, deterministic on payment, LiveRound.gd ln 423-427 — Close to true but per round not per exchange: close() tallies paid dict counting each exchange where punished() != "" and !fix, then appends each key once to notes_seen. Map says "one habit that cost in that exchange added" implying per-exchange single write; code batches per round and can add up to two per round (two habits). Line range 423-429 indeed does paid loop. Tag ✓ with wording correction.
- ✓ Post-bout coach note — one unseen, habits first, after every bout via BoutFinish.coach_note → CoachNotes.reveal — BoutFinish.run calls coach_note with source fight which picks first unseen in pool (habits built first). Correct.
- ✓ Sparring session — 35% chance per session via SPAR_ODDS 0.35 — CoachNotes.reveal sparring does rng.randf() < 0.35 then pick. Correct.
- ✓ Full tape study — next hidden tell in fixed order weapon → non-free mode → habits → remaining modes, one per full session — OppFile.tells uses ModeTells.order which emits weapon, mode:top, habits, mode:second, weakness. Correct.
- ✓ Half-tape — two halves = one full via half_tape boolean — OppFile.half_tape sets/clears flag, second call calls tape. Correct.
- ✓ Complete bout — entire file unlocked — OppFile.open_all loops tape until hidden empty, BoutFinish calls it after every bout. Correct.

**1.3 Cost & Punishment**

- ✓ Base habit cost 6.0 — HabitFix.HABIT_COST 6.0 correct.
- ✓ Bout multiplier 1.75 → 10.5 — Exchanges.HABIT_BOUT 1.75 correct, LiveRound habit_pts multiplies by it.
- ⚠ Punishment mapping — 17 of 20 have PUNISHED_BY entry, 3 have no entry — HabitFix.PUNISHED_BY size is 17, missing three are digs_body_when_hurt, slow_starter, fades_late. Map counts this right but later mislabels which three are free.
- ⚠ Fix effectiveness — map says cost = HABIT_COST × (1 − uptake × trust), uptake = coachability factor — Code is cost × (1 − hold) where hold = uptake( coachability, shouts_before ) × trust × (0.5 if hot else 1.0). Uptake is not raw coachability but 0.7+0.3×coach/100 with late-shout halving. Missing hot and shout modifiers; trust table correct (1.05/1.0/0.85/0.7). Partially correct, incomplete.
- ✓ Clock habits EARLY 2, LATE 3 — HabitFix.EARLY 2 (slow starter i <2), LATE 3 (fades late i ≥3 on last round). Correct.
- ✗ No-penalty habits list — map lists digs_body_when_hurt, switches_stance_under_pressure, talks_when_ahead as free. Code shows only digs_body_when_hurt is outside PUNISHED_BY and clock; the other two are in PUNISHED_BY (press and counter). Correct free count is one, not three. Wrong claim.
- ✓ Resolution order — first in list order applies — HabitFix.punished iterates habits array in order, returns first match. Correct.

**1.4 Existing Fix Levers**

- ✓ Corner fix — reduces cost of one known habit, next round only, selected from seen punishable habits via HabitFix.offers / LiveRound fix param — Correct. Sub-note: slow_starter excluded via fixable() (PUNISHED_BY ∪ {fades_late}) — map omits that nuance.
- ⚠ Signing focus "Fix the habit" — removes first observed habit entirely, permanent 4-week cycle via FOCUS habit / HABIT_WEEKS 4 — Recruit.FOCUS habit and HABIT_WEEKS 4 exist, and Sim.end_week erases that id. But "first observed" is inaccurate: it erases first habit in array (hs[0]), not first revealed in notes_seen (which is empty at signing). Timing is day+28, not necessarily training out — just wall time. Functionally permanent removal; wording off.

**2.1 Pre-Signing Reads**

- ✓ Look closer $120 clears hype or halves widest group — KnowReads.PRICE_LOOK_CLOSER 120, _apply_look_closer clears hype or solves exposure to halve half-width via FLOOR+ (start−FLOOR)/(1+exp/HALF). Does NOT show habits. Correct.
- ✓ Test day $60 +8 / +16 — PRICE_TEST_DAY 60, _apply_test_day uses BOUT_FIRE_NARROW 4 ×2 if bouts<5 then expose 2×narrow → 8 or 16 on body. Does NOT show habits. Correct.
- ✓ Trial $500 4 weeks half stipend +24 body/skills — PRICE_TRIAL_WEEKS 4 × STIPEND 250/2 = 500, _apply_trial expose body 24 skills 24 (plus 8 fire_spar if opened). Does NOT show habits. Correct.
- ✓ Recheck $40 halves stale widening 21-day cooldown — PRICE_RECHECK 40, Knowledge.recheck halves stale_body/fire, recheck_ready 21 days via RECHECK_INTERVAL_DAYS. Does NOT show habits. Correct.
- ✓ Hard spar club $0 ×2 injury +15 fatigue +7.25 — RISK_INJURY_MULT 2.0 RISK_TIREDNESS 15 (KnowReads.risk), hard_spar club_frac 0.5 gives (15−0.5)×0.5=7.25 exposure via Knowledge.hard_spar. Does NOT show habits. Correct.
- ✓ Hard spar outside $160 +10.875 — PRICE_HARD_SPAR_OUTSIDE 160, outside_frac 0.75 → 10.875. Does NOT show habits. Correct.
- ✗ Decision rule "Reads with no actionable decision are hidden... disabled with reason 'No decision changes — save your money.'" — No code in KnowReads, FighterTile, RosterCards or RecruitPanel implements this disable. Tag should be CUT/ESTIMATE, not implied CODE. Wrong claim.

**2.2 Bout Offer — Risk Warning (all 18 rows tagged CODE)**

- ✗ The intersection logic HabitFix.PUNISHED_BY ∩ Exchanges.STYLE_MODES → banner — No code in BoutPage, Fights, FighterPage or FightPrep implements a risk banner, colour coded RED/AMBER/GREEN or wording. In v3 the same banner was tagged ESTIMATE. There is no banner text, no style-probability lookup, no clock/state phrasing. All eighteen habit-to-style rows (drops_right counter 0.55 etc.) correctly reflect the two tables individually, but the join and display do not exist. Wrong CODE claim — should be ESTIMATE/CUT.

**2.3 Game Plan — Available Responses**

- ✓ fades_late → tiring "Start busy — don't let her settle" — PlanLines.HABIT_SITS fades_late tiring exists. Correct.
- ✓ slow_starter → tiring "Push early — bank Round 1" — exists. Correct.
- ✓ admires_her_work → tiring "Stay busy — don't pause" — exists. Correct.
- ✓ drops_right_after_jab → range "Go to the body — under her jab" — exists. Correct.
- ✓ lunges_with_jab → press "Stay at range — make her miss" — exists. Correct.
- ✓ digs_body_when_hurt → hurt "Press up — don't let her settle on your body" — exists. Correct.
- ✓ loads_up_when_hurt → hurt "Stay calm — don't chase" — exists. Correct.
- ✗ All other 13 habits "No mapping in PlanLines.HABIT_SITS — Observed in notebook, label Not yet mapped — corner fix only" as CODE — The thirteen-way absence from HABIT_SITS is correct, but the label "Not yet mapped — corner fix only" has no implementation in any UI. No screen writes that line. Wrong CODE claim.

**2.4 What Each Menu Shows — Complete Wire Table**

- ✗ Roster — fighter card notebook summary count known/total; highest-risk habit flagged (S425 CODE) — RosterCards.build shows Art, plate, tiles (Condition/Mood/Weight), Next, flag from RosterFlag only. No notebook summary, no highest-risk flag. Wrong CODE claim.
- ✗ Fighter page — Overview Coach's Notebook with trigger description, penalty status, plan-line availability, fix eligibility, click to jump (S425 CODE) — FighterPage._overview shows Coach's Notes with progress "COACH'S NOTES, N OF M" and quoted lines from CoachNotes.card. No trigger tag, no penalty pill, no plan availability, no jump. Wrong CODE claim.
- ✗ Recruitment / Prospect card — one suspected habit "Coach suspects — unconfirmed", eligible reads only disabled when no decision changes (S425,S448 CODE) — RecruitPanel.build shows habit line with effect and "Can be trained out." No separate suspected label wording, no read-disable logic. Wrong CODE claim.
- ○ Bout offer page risk banner RED/AMBER/GREEN (ESTIMATE) — correctly not CODE, no claim to verify. UI has no banner, but tag admits ESTIMATE so not a CODE fault.
- ✗ Fight prep — Plan tab situations with plan lines where mapped, unmapped shown as "Observed — no line yet" (CODE) — FightPrep._prep shows WHAT YOUR PLAN SHOULD ANSWER via FilmNight.prep_rows and MatchupCards with Write it, but does not emit the "Observed — no line yet" string for unmapped habits. Wrong CODE claim.
- ⚠ Week screen — signing focus shown "Fixing [habit] — week X of 4", no weekly drill lever (NOT ADDED) (CODE) — The focus banner is shown in FightAnalysisOwn/Fix on pads path, but not on the Week screen's main WeekBoard; "X of 4" countdown has no widget code found. The "NOT ADDED" part is honest but the "shown" part has no verified widget. Partially wrong.
- ✗ Post-bout recap — newly revealed habit "Coach saw this during the fight — [habit + trigger]" (CODE) — BoutFinish adds news "Coach's notes on X: Y" with the quote, not the map's wording plus trigger. No trigger text appended. Wrong CODE claim.
- ✓ Opponent file — tape-study order weapon → mode → habits, each Revealed/Hidden with what unlocks it — OppFile.tells and opponent file card render correctly via OppFileCard; this is how the game does it.
- ✓ Corner card — fix options limited to seen punishable habits, one per round — HabitFix.offers and LivePreview.fixes filter to seen+fixable, UI shows one per round. Correct.
- ✓ Corner result — fix outcome "Came up N times — saved X% ... Did not appear" — HabitFix.result emits "it came up %d times — your boxer caught it, it cost %d% less." / "it never came up." Wording close enough, intent correct. Correct.

**Files read for this check:** assets/data/fight_habits.json, scripts/rules/HabitFix.gd, scripts/rules/Exchanges.gd, scripts/rules/PlanLines.gd, scripts/rules/ModeTells.gd, scripts/rules/CoachNotes.gd, scripts/rules/OppFile.gd, scripts/rules/KnowReads.gd, scripts/rules/Knowledge.gd, scripts/state/KnowWire.gd, scripts/rules/Recruit.gd, scripts/state/LiveRound.gd, scripts/state/BoutFinish.gd, scripts/state/Sim.gd, scripts/rules/FighterProfile.gd, scripts/state/Data.gd, scripts/ui/RosterCards.gd, scripts/ui/areas/FighterPage.gd, scripts/ui/FightAnalysisOwn.gd, scripts/rules/RosterFlag.gd, scripts/ui/FightPrep.gd, scripts/rules/PlanBoard.gd.

**Summary of wrong CODE claims:** (1) No-penalty habits list miscounts and misnames; (2) Fix effectiveness omits hot/shout modifiers; (3) Bout offer risk banner — 18 rows — no implementation; (4) Thirteen-unmapped-habits label has no code; (5) Roster notebook summary and highest-risk flag not built; (6) Fighter overview trigger/penalty/plan/fix columns not built; (7) Prospect card suspected label and read-disable not built; (8) Fight prep "no line yet" line not built; (9) Week screen X-of-4 countdown not verified; (10) Post-bout recap wording does not match. The habit bank, fighter storage, notebook retention, reveal paths, base cost, multiplier, clock constants, resolution order, corner offers, signing focus constant, and all six read prices/narrowings are correctly tagged CODE.

## 7. To reach 10/10

Most important first, each specific enough to build now from code already in the room. No new art needed beyond one chip and one line of text.

**1. Build the offer banner for real.** In Boutique page (BoutPage / Fights) add a function risk_of(f, opp) that returns {text, colour}. Logic: for each habit in f.habits where HabitFix.fixable(h) and f.notes_seen has habit:h, look up PUNISHED_BY[h] situations; intersect with Exchanges.STYLE_MODES[opp.style] keys whose share ≥0.45 plus include she_tired/she_hurt/hurt if FighterProfile fatigue or damage thresholds met, and clock habits if bout is round-one or last-round. If intersect non-empty, text = "Your boxer tends to %s. %s fights %s — expect this to cost exchanges." Colour RED if share ≥0.5 else AMBER; clock/state triggers get AMBER wording ("first two exchanges of Round 1" / "when hurt"). No banner when notebook empty — unknown = no warning. This is the single decision the mechanic promises and today has no UI.

**2. Make habits visible before you sign.** Add to RecruitPanel a second amber line under the habit: "Coach has heard this from the old gym — not yet confirmed." Store it as f.suspected_habit (the same id as habits[0]) at creation in FighterProfile.make. Do not write to notes_seen. This gives the pre-signing read a stakes object without revealing certainty. Keep attribute reads as they are; add the new $120 "Ask around" read that reveals whether suspected_habit is also in habits array (true/false) without revealing the second hidden habit.

**3. Finish the plan table.** Add the thirteen missing entries to PlanLines.HABIT_SITS so every habit has a sit: freezes_on_ropes→tiring, switches_stance→press, talks_when_ahead→counter, wide_hook_tell→range, retreats_straight_back→press, head_down_inside→press, clinches_when_tired→she_tired, bites_on_feints→counter, low_lead_hand→loadup, one_and_done→press, chases_stoppage→hurt, waits_too_long→range, covers_up_when_hurt→she_hurt. Add one StrikeMap step line each (reuse existing step_in/step_out/feint/tie_up). Now a discovered habit always has a "Write it" line. Remove the "Not yet mapped" dead state.

**4. Show the math on the habit row.** In FighterPage's Coach's Notes, change each habit line from quoted sentence alone to: name — trigger — tag (press / counter / etc.) — "−10.5 power when it fires, −X% with fix" plus a tiny "Came up N times last bout." Data comes from BoutFinish's paid dict and HabitFix.cost. Makes the tax tangible and the fix worth choosing.

**5. Give the week a habit drill that trades off.** In Training / WeekBoard, add a third evening choice "Drill habit" that appears only when notes_seen has a fixable habit. Picking it puts that habit id into f.week_habit_drill; Sim.step_day reduces that habit's next cost by 0.25 × up-to-4 weeks stacked (store f.habit_drill_weeks counter). Cost is the pad night you did not spend on a move or combo (mastery gain lost) and the fatigue. No new system — just a counter read in LiveRound habit_pts.

**6. Fix the free-habit lie.** In fight_habits.json change effect for digs_body_when_hurt to "No tax — can buy time" and in HabitBeats.gd keep its ring visual but in HabitFix.punished ensure it never returns; in notebook render it with a green chip "Helpful — no fix needed." Remove it from offers. Update the pack text to "1 of 20 has no penalty" to match PUNISHED_BY 17 + clock 2 + helpful 1.

**7. Repair the roster and overview claims in code so the map stops lying.** On RosterCards._card add a one-line footer: "Notes %d/%d" from CoachNotes.progress plus highest-cost habit name when one exists. On FighterPage._overview add under each note line the situation tag and a "Plan line: press → Pivot out (Works)" chip via PlanLines.tell_sit when mapping exists. These are ten-line patches — do not ship a map that claims them until they are in.

**8. Make clock habits fixable late.** Change HabitFix.fixable to include slow_starter only when future phase is not round one — i.e., gate its offer off after round one, not forever. And allow fades_late fix to carry two rounds so a corner can set it in round two for a six-rounder, with tooltip "Last round only — next round is the last."

**9. Log the fix result in numbers.** Keep HabitFix.result but change the line to "Fix %s came up %d times — saved %d%% of %d power that round" so the Why can quote it. Write that string to the next-round corner card verbatim.

**10. Tune one number with a bot.** Run the existing exchange_balance bot with 1,000 bouts × four habits vs no habits across press-heavy and counter-heavy opponents. Target: a known, unfixable habit loses ~4 wins in 100; with corner fix it loses ~2; with full plan answer + fix it loses ~0.5. Today 10.5 over a 66 spread may be high when it fires twice a round. Halve to 5.0 if bot shows >6. No new mechanic, just a value.

## 8. What 10/10 looks like as a 1920×1080 page

The page is the existing warm-wall Fighter page Overview at 1920×1080, no new screen. The portrait header stays. The Body card shrinks by one row to make room. In its place:

- Top: "COACH'S NOTEBOOK — 4 of 8" with a thin bar (seen vs seeable). Below, each habit is a row: amber name, grey trigger ("After a jab at range"), pill with punished situation ("counter"), and on the right either a green "Plan line: At range → Slip and go to body (Works)" button or a muted "On the pads — week 2 of 4" when drilling. The helpful habit has a green "Helpful" chip and no button.

- Below that, the "WHAT IT COSTS" line: "−10.5 power when it fires. Your corner saves ~60% next round. Last bout: fired 2 times, cost 21 power."

- On the right, the goal and next bout cards stay. When a bout is booked, a thin risk banner sits under the matchup: red for high share, amber for clock/state, green for helpful — same 14-word note the map promised, now real.

A static HTML mock of this at 1920×1080 lives in the designer's Figma today; the wall, wood frames, marker fonts and cream paper from WarmKit are unchanged. No new art — only text, chips and one amber button per habit. Anyone who can build a whiteboard card can build it.

---
*Critic's shelf: FighterProfile makes two random habits and never grows them; the only eraser is Sim.end_week on habit_fix. Real gyms lose old ticks and pick up new ones under pressure — the mechanic says habits are permanent defects, which is honest for this iteration. Evidence: Kronk's habit of loading up when hurt is coached out over months on pads, not in one pep talk; Mayweather's shoulder roll is a habit built over years that becomes a strength. The map's refusal to add weekly drills for v4 is consistent with "do not promise what isn't coded," but shipping v4 without them keeps depth at 4.*


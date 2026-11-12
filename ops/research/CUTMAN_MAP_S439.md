# Cutman map, round 3 (S439): R28 under "Stop, show damage"

Round 2 scored depth 5 and 5. Both critics found the same faults. The minute had one currency (tonight's win/draw/loss), so every
choice turned into "pick the biggest win number". Pace, the set-up, the plan line and Kerry's game mix were left off the
screen. Four of the prices were wrong.

Round 3 starts from the owner's ruling (DAMAGE_VERDICT_S438, his pick "Stop, show damage"): **no NEW damage or recovery
decisions; the cutman works with what exists.** So Part B of round 2 is withdrawn: the doctor's look, the second's paid
close, the doctor-stop layoff and the cutman hired at camp. Both critics' 10/10 drawings rest on the doctor. Under the
ruling it cannot be built, and this map says so plainly (section 9).

**Verdict on R28 (judged in the code, section 2):** inside the ruling the cut has no stake. Today's code reads the eye in
one place only, the after-bout injury roll. On a cut night the cut eye is already the worst place, so the roll comes out at
about 19% whatever the corner does. The cutman's close moves that by about 1 point, and only in the 3D view. **So the cutman
is shown, not decided.** His pick goes, because it was a lookup that changed only a shown number.

The decisions that remain are the corner minute's own jobs, which exist today. Round 3 prices them in the units the code
already keeps. The first is tonight's card (rounds won). The second is what each ending costs the gym and the fighter:
members, reputation, morale and the corner's word, rank, weeks out and days without sparring. Seen together, the jobs that
flip from one bell to the next are the PLAN FOR TWO ROUNDS (pace) and THE CALL against Kerry's real mix. The talk joins
them once Truth carries a price. That price is the one new rule in this map, and it is a talk rule, not a damage rule.

Sources read whole: CRITIC_PACK.md, R28_CUTMAN_DESIGN_MAP.md, R28_DIGEST.md (nothing on the cutman),
K_R28_CUTMAN_V3_BRIEF_KALLI.md, DAMAGE_VERDICT_S438.md, and this file's round 2.
Code read in round 3: rules/BodyMap.gd, CornerJobs.gd, PaceAim.gd, CornerTrust.gd, InjuryRoll.gd, Adaptation.gd and
StandDown.gd, all whole. Also: Exchanges.gd 10-135, 160-230 and 296-372; HabitFix.gd 16-58; Knockdowns.gd 1-75 and 115-137;
RoundScript.gd 33-53; Combos.gd 24-43 and 266-278; PlanFile.gd 136-146; FighterProfile.gd 19-61; Matchmaking.gd 30-48,
229-288; ProLadder.gd 336-364; Attrs.gd 35-40 and 133-135; BoutRules.gd 90-99. In state/: BoutNight.gd 120-215, 232-257,
301-380; Injuries.gd 1-60 and 150-265; LiveRound.gd 75-100, 185-260 and 386-420; RingDuel.gd 296-340; LiveRoundAfter.gd 40-73.
Also fight3d/BoutMarks.gd 1-60, ui/CornerJobsRow.gd 1-130 and PlanFight.gd 183-207.
Picture: docs/mockups/s439/cutman/screen_r3.png (the corner minute before round 5 of 6, with a cut and no cutman).
Forecast model: `minute_sim.py` in the session scratchpad. It models the CODE formulas named in section 6, with ESTIMATE
inputs; MinuteOdds (A6) replaces it.

## 1. The idea in five lines
1. The cut is SHOWN, truthfully: what it does tonight (nothing in the exchanges) and after (the worst place for the injury
   roll). A hired cutman closes it by himself. Nothing about the cut is picked.
2. The minute is ONE PLAN FOR THE ROUNDS LEFT: the pace for this round and the next, the call, one change, a set-up and the
   talk. Each is priced in energy across both rounds, against the 35 tired line.
3. Every plan shows TWO CURRENCIES. The first is tonight: win / draw / points loss / stopped, set against the coach's own
   minute. The second is what each ending costs: members, reputation, morale and the corner's word, rank, a suspension and
   weeks to the next fight, and days without sparring.
4. The call is a hedge. The coach's star reads the last three exchanges, but the code opens every round on a fresh roll of
   Kerry's style. Each call tile shows what it earns on Kerry's real mix, and a wrong call Dana follows and loses costs trust.
5. The second's three points follow a rule (they were a lookup). The cutman's pick and the enswell go (they changed only a
   shown number). One new talk rule gives Truth a price.

## 2. What is built today (read in the code)
| Piece | What the code does | File (CODE) |
|---|---|---|
| Eye and cut | Each eye hit takes 1.15 (x2 for a big punch). Every eye hit from an orthodox attacker lands on the defender's RIGHT eye, the cross included (opp_side), so Dana's left eye stays at 100 against an orthodox Kerry. A face place at 35 or under is flagged as a cut, and an open cut loses 1.5x. | BodyMap 13, 19, 23, 46-80, 102-112 |
| What reads the eye | The live map is BodyLive's (3D only). After the bout it is BodyLive's if the ring showed every round, else BoutMarks.build, which **does not replay corner work**. Injuries.after_bout feeds the eyes, nose and ribs into InjuryRoll, and the roll is the ONLY rule that reads them. No exchange, call, knockdown or result reads the eye. | BoutMarks 6, 17-20; Injuries 186-194 |
| Cutman pick | Pro corners only: close / enswell / nothing. Close keeps the cut at 1x for one round. Enswell and ice add a "relief" that raises only value(); end_round wipes it. The cutman body stands in every pro corner, hired or not. | BodyMap 177-205; CornerOverlay 316-382; CornerCrew 28-34 |
| Cutman staff | $150 a pro night, standing job (Club > People). After a pro bout a cut injury is cancelled on a seeded coin (half). | StaffRoles 14, 20; Injuries 197-200 |
| Injury roll | chance = 0.06 x rounds/3 x (0.4 + 1.2 x (100 - worst)/100), cap 0.4. Weights: cut 20 (x2 when a face place is at 35 or under), nose 15, head 37, hand 18, ribs 10 (x3 when a rib place is at 35 or under). Days out: cut 14-21, nose/head/ribs 21-35, hand 35-56. A stopped loss is not rolled: it is the suspension, 30 days (90 if a second stop inside 90 days, 365 for a third inside a year). | InjuryRoll 7-96 |
| Stand-down | No sparring for 5 / 10 / 21 days by head place (100 - head damage x 2.2): fine at 55 or more, hurt at 35 or more, else critical. None after a stopped loss (the suspension instead). | StandDown 7-34; Injuries 181-184 |
| Head damage and counts | A round's loser takes close 8 / clear 18 / dominant 32, the winner 2. Margin is the mean exchange margin: close under 6.75, dominant from 18. Count chance 0.05 x (0.3 / 1 / 2.2) x exp((power - chin)/12) x (1 + damage before/60). After a count: stop chance 0.2 x (1 + damage/60) x (1.4 - heart/100). 3 counts in a round or 4 in a bout stops it. | Knockdowns 13-75; RoundScript 35-53 |
| What each ending does | Win: +8 members, +5 reputation, morale +8; beating someone ranked above takes their place. Draw: records only, nobody moves. Loss: -1 member, -2 reputation, morale -12, and a loser ranked below the winner drops one place. Stopped loss: -2 members, -4 reputation, morale -12, durability cap -2 for good, rating -0.8 at once, +8 weeks to the next ladder fight, the suspension. | BoutNight 360-379; BoutRules 90-99; FighterProfile 19-21; Attrs 40, 133; Matchmaking 33, 48, 229-282 |
| Trust | A shouted call that fits "wrong" and loses its exchange: -2 morale. One that fits best/ok and wins: +1. At most 3 of each, settled once a bout, so it lands on the NEXT bout. Morale bands set the corner's word taken in: Fired up 1.05, Steady 1.0 (50+), Flat 0.85 (30+), Low 0.7, and a Low fighter ignores shouts. | CornerTrust 23-49; FighterProfile 31-61 |
| Energy across rounds | _energy precomputes the round: start a0 = last round's "next" (the bell plus the rest's refill of 52% of the fast debt, x0.8-1.2 by conditioning), and the bell a_end. What the round spends on calls, pace and talk carries into the next start. Body hits taken are a LEVEL that her_energy subtracts every exchange for the rest of the bout (body x body_cost_a). | BoutNight 301-323; Combos 266-277; LiveRound 386-397; RingDuel 299-302 |
| Water and ice | Water: +3 a point, or +6 when e.a is under 40, added to this round's start and bell only (not carried). e.a is a0, the energy AFTER the rest with the body level left out. Ice: 3 body hits a point taken off the bout's count, so +3 x body_cost_a on the energy line in every round left. **The menu reads a different number** (the bell, with the body level in): it can print "+6 each" when the rule pays +3. | CornerJobs 13-57; BoutNight 168-176; CornerJobsRow 26-41 |
| The second's default | Clear the head if hurt; 1 ice if the bout's body count is 6 or more; the rest water. | CornerJobsRow 47-57 |
| Pace | Push +6 an exchange, spend x1.35, fading under 55 energy to -6 at 25 (push_gassed). Save -4 an exchange, spend x0.6, and +6 energy back EVERY exchange. Pace persists, and the plan's round row (PlanFile.pace_for) sets the pace a round opens on. The corner minute has no pace control. | PaceAim 10-13, 182-190; RingDuel 334-336; LiveRound 93-97; PlanFile 136-146 |
| Aim | On the shout bar in the round. Naming a target costs 1.5 an exchange. A hurt rib side (4+ body shots on it, 60% to the liver side) gives +4 and 1.3x there. Body aims get +3 once the opponent's core or legs burn passes 50. | PaceAim 15-40, 144-176 |
| The call | 8 calls; each fits a game as best (+17) / ok (+5) / none / wrong (-10). A positive edge is x grade (Good 1.0, OK 0.6, Poor 0.3) x heard. A wrong one is x heard x commit (Good 1.5, OK 1.0, Poor 0.6). Dana under 35 makes the situation "Your fighter is tired" (Breathe best, Hands up ok, Let your hands go wrong), whatever Kerry plays. The star is MODES[last-3 read].best. | Exchanges 16-20, 46, 100-115, 165-170, 207-217, 354-372 |
| Kerry's games | Pressure fighter: press 0.55, loadup 0.2, counter 0.15, range 0.1. Kept 6 times in 10, at most 3 in a row. **Every round opens on a fresh roll** (prev ""), so the last-3 read does not carry over the bell. Under 45 energy, Kerry tires 3 times in 4. | Exchanges 127-133, 221-229; LiveRound 75 |
| ONE CHANGE (this round only) | Fix a habit: a punished habit costs 6 x 1.75 = 10.5 an exchange, and the fix clears it. Gloves high: 15% x hold more of Kerry's landed punches go to the body, -2.0 head damage each. Elbows in: half the body punches x hold go to the head, +2.0 head damage each. Moved body punches stay on the bout's body count (energy every round left). | HabitFix 12, 16-58; Adaptation 17-90; LiveRound 230-232 |
| Set-up | One learned combination x a gap (Kerry's top two games + tiring). Fired into its gap: 14 x (0.5 + mastery/200), x0.6 under 40 energy, and if the exchange is won, +30 head damage to Kerry. Fired into another game: -9. Armed and waiting, Dana skips her own read in the gap's exchanges. | CornerJobs 20-27, 60-90; LiveRound 236-249 |
| Talk | Calm: edge +1 only at temper 65+; energy +0.4 an exchange; hurt x0.6. Fire up: +2 (confidence under 50) or +1.5, -2 at temper 65+; energy -0.8 an exchange; hurt x1.3 (x1.6 at temper 65+). Truth: +1.2 at discipline 60+ (else +0.3), -2 at confidence under 45; free. "Say nothing" is the empty pick. | CornerJobs 95-111 |
| Plan line | One change to an arrow on a card Dana was fought on, under the coach's line limit. | PlanFight 183-207; BoutNight 187-191 |

### Findings that change the design (round 3)
- **F6. The eye costs nothing tonight, and almost nothing after.** No exchange reads it, and on a cut night it is the worst
  place. The roll then gives 0.12 x (0.4 + 1.2 x (100 - eye)/100), which is 17.8% at eye 10 and 19.2% at eye 0. The open cut
  takes the eye to about 4 by the final bell, the cutman's close to about 13 (model). That is **1 point of injury chance**,
  and only in the 3D view (BoutMarks drops corner work).
- **F7. The cut makes the expected layoff SHORTER, not longer.** The x2 cut weight moves injuries toward cuts (14-21 days).
  Expected days out, given an injury: 29.1 with no flags, 27.1 with the cut flag. The rib line (x3) gives 28.9, and with both
  flags 27.3. **Both critics' "Gloves high takes the ribs to the injury line, a lasting cost" is wrong in weeks.** It changes
  which injury it is, not how long it lasts. The ribs are priced in energy instead (the moved punches stay on the body count).
- **F8. Water is +3 here, not +6** (critic 2 was right). The rule reads e.a = 62.6 (after the rest, body level out), but the
  menu reads the bell's 39. A7 fixes the menu.
- **F9. The star does not carry over the bell.** Round 5 opens on a fresh roll of Kerry's style, so "loading up" is 20% of
  its first exchange, not the 60% that KEEP would give. On Kerry's mix, Jab and move earns about +9 an exchange, against +2
  for the starred Hands up (worked in section 5).
- **F10. Save is the biggest energy lever in the game.** +6 back every exchange is about +40 over a round, carried into the
  next round's start. That is more than the second's three points together (+9 at most).
- **F11. The rib line flags Kerry's ribs for Aim, and Aim is a bar control.** "Kerry's worst place" is already on the bar as
  Aim's offers. Aiming a hurt side nets +2.5 an exchange, so it is taken whenever it is offered. That makes it a lookup, and it
  stays on the bar.
- **F1 to F5 from round 2 stand.** The close does nothing to the roll when the head is the worst place. Ice lasts every round
  left, water this round only. Gloves high's real energy cost is body_cost_a. The cross lands on the wrong eye. Round 1's
  claims were wrong.

## 3. What is thin (each seen in the code)
1. **The cut has no stake under the ruling** (F6, F7), so it is shown and not decided.
2. **The second's points are a lookup.** With two or more rounds left, ice gives +3.1 x rounds left against water's +3 or +6
   once. With one round left, water at +6 (under 40) wins; at +3 the two tie. Clear the head is always taken when offered.
3. **The talk is a lookup for a disciplined fighter:** Truth is free and +1.2.
4. **The minute is in mixed units, and its biggest levers are missing.** Pace (F10) and Kerry's mix (F9) are not on it.
5. **The card shows no price per ending.** Nothing tells the player that a stop costs 4 weeks of suspension, 8 more weeks
   before the next ladder fight and 2 points of durability for good, while a draw costs nothing.
6. **False words and numbers:** "the doctor may stop it" (no rule reads DOCTOR); enswell and ice relief lift only the shown
   number; the amateur card prints "No cut" when there is a cut; the cutman stands in corners where nobody hired him; water's
   menu number (F8); Gloves high's flat "-energy" (round 2's F3).

## 4. The mechanics, each as a decision with its options and their prices
Rule: an option that costs nothing in the code is a lookup, so it is changed or cut. All prices below are CODE unless
marked. The one new rule is marked NEW (a talk rule, not a damage rule).

### Decision 1: THE PLAN FOR TWO ROUNDS (pace for this round and the next)
Where: the corner minute, a new row. It writes the bout's own round pace (the saved plan stays untouched) and is read by
LiveRound.open through pace0. Nothing new is ruled: pace and the plan's round row exist.
| Option (per round) | Price | Gain |
|---|---|---|
| Push | spend x1.35 (about +4.6 energy a round here); the edge fades from 55 energy and turns to -6 at 25 | +6 an exchange |
| Steady | none | none |
| Save | -4 an exchange; spend x0.6 | +6 energy back every exchange (about +40 by the bell, carried into the next round's start) |
Shown as one energy line across both rounds against the 35 line (Dana is "tired" under it: Breathe becomes best, Jab and move
earns nothing) and the 55 line (where Push starts to fade).
Why not a lookup (model, section 5): fresh at 48 after the rest, Push both or Steady then Push win (52 and 47, too close to
call), and Save then Push loses about 9 points. Tired at 33 after the rest, it reverses: Save then Push wins 40, Steady
then Push 27, Push both 18. Ahead 3-1, the order is the same as fresh but the gaps shrink to 4 points. Behind 1-3, Save then Push
loses the most (a lost round 5 is the fight).

### Decision 2: THE CALL for round 5 (and the call planned for round 6)
Where: the corner minute's call tiles (built). New on each tile: what it earns on Kerry's mix, and the trust risk.
| Call (Dana's grade) | On Kerry's mix (press 54 / loadup 25 / counter 17 / range 4) | Trust risk |
|---|---|---|
| Jab and move (Good) | best when pressing, ok when loading up, wrong at range: about +9 an exchange | wrong at range is -13 (Good commit x1.5); followed and lost = -2 morale |
| Hands up (OK), the coach's star | best when loading up (+9 there), ok when Dana is tired, never wrong: about +2 | none |
| Go to the body (OK) | ok when pressing, best at range, wrong when loading up: about 0 | wrong 1 time in 4 |
| Breathe (Good) | best when Dana is under 35: +15 there; nothing otherwise | wrong only when Kerry tires |
Why not a lookup: with Dana fresh, Jab and move wins (52 against 31 with Hands up), at about 0.8 wrong-and-lost calls a bout.
With Dana tired (under 35 for most of the round) the tiles flip. Jab and move earns nothing there, Breathe is best and Hands up
is ok, and in the model Hands up equals Jab and move (19 and 18). Against a balanced mix (a Boxer-puncher, 35/25/20/20) no call
leads by much, and "never wrong" is worth having for a fighter near the Flat line (morale 50: the corner's word drops to
0.85 next bout). The star stays the coach's read of the last three exchanges, labelled as such.

### Decision 3: ONE CHANGE for round 5 (habit fix / Gloves high / Elbows in / leave it)
Where: the corner minute (built), shown as four cards priced in the same three units: round 5, energy in rounds 5 and 6,
and head damage (which sets the counts and the days without sparring).
| Option | Round 5 | Energy | Head damage, after |
|---|---|---|---|
| Fix: low lead hand | each loading-up exchange -10.5 -> 0 (Kerry loaded up 6 of 24) | none | none |
| Gloves high | about 10 points lower than the fix (no fix, and Dana tires sooner) | -4.2 in round 5 AND round 6 (4 moved x 1.05, body count) | -8 (4 x 2.0): a no-sparring band of 5 days becomes possible (33% against 0) |
| Elbows in | as leave it | +2.1 in rounds 5 and 6 (2 fewer body hits) | +4: the 21-day band comes nearer |
| Leave it | none | none | none |
Honest note: while a fix is offered it wins tonight (48 against 39 for Gloves high), so the choice is fix against the days.
Gloves high trades about 10 win points for a 1 in 3 chance of 5 days without sparring instead of 10 or 21. With the next
ladder fight 8 weeks away, that is a soft price, so in this state the fix wins. When no habit was punished, the trade is
Gloves against Elbows against leave it: head damage against energy in every round left. The heavy-damage case at the end of
section 5 shows when the head matters.

### Decision 4: THE SET-UP (one combination x one gap)
Where: the corner minute (built, CornerJobsRow 92-120). New: its price line.
| Option | Price | Gain |
|---|---|---|
| 1-2-3b (Sharp 64) for "when Kerry loads up" (25%) | -9 if shouted into another game; in that gap's exchanges Dana waits for NOW instead of reading | +11.5 once, and +30 head damage to Kerry if the exchange is won (his count roll reads it) |
| the same for "when Kerry presses" (54%) | fires sooner, into the game Jab and move already answers | the same, but on top of a call that already fits |
| for "when Kerry tires" | Kerry is at 60 now and tires under 45: in round 6 at the earliest | the knockdown shot comes late |
| none | none | none |
Model: +3 win points armed for loading up. It is a real bet on Kerry's next game, and it is the only job that can drop him.

### Decision 5: THE TALK (calm / fire up / truth / say nothing)
| Option | Price (for Dana: temper 48, confidence 58, discipline 64) | Gain |
|---|---|---|
| Tell the truth | NEW: said before a round Dana then loses, it counts as one wrong call (-2 morale, inside CornerTrust's cap of 3) | +1.2 an exchange |
| Calm down | no edge (temper under 65) | +2.4 energy a round (+0.4 an exchange, carried); hurt x0.6 |
| Fire up | -4.8 energy a round; hurt x1.3 | +1.5 an exchange |
| Say nothing | none | none |
Why not a lookup with the NEW price: Truth when round 5 is likely won (here, Push both: 75-85%). Calm when the round is likely
lost and the energy line is near 35. Say nothing when morale sits near the Flat line and the round is a coin flip.
Without the price, Truth beats Say nothing every time for any fighter with confidence 45+, and the talk stays a lookup. The
price uses CornerTrust's existing morale event; it is a talk rule, outside the damage ruling, and A9 measures it.

### Not decisions any more (cut or turned into shown lines)
- **The second's 3 points:** the second spends them by the rule. Clear the head when hurt. With two or more rounds left, ice
  up to its maximum (ceil(body/3)). Otherwise water. The minute shows ONE line ("The second: ice 3: +3.1 energy in rounds 5
  and 6. Water would be +3 this round only."), with a Change button for a player who wants to override it.
- **The cutman's pick (close / enswell / nothing):** gone. A hired cutman closes an open cut by himself in every minute. With
  no hire, nobody closes it (no cutman body either). Enswell goes; it only lifted a shown number.
- **The doctor, stop-or-go, the coach closing a cut:** withdrawn (the ruling); see section 9.

## 5. Worked example: one week, played (a 6-round ranked pro bout)
Why 6 rounds: the decisions above live in every bout with a corner minute (amateur 3 rounds, the debut 4), but a cut
reaches a corner mostly in 6-rounders (S423 probe). The 4-round case closes the section. All state values are ESTIMATE, and
the formulas are CODE.
- **Dana Holt**, pro lightweight, orthodox, ranked 16. Morale 58 (Steady). Discipline 64, confidence 58, temper 48,
  coachability 60 (heard 0.88). Body stat 58 (body_cost_a 1.05), conditioning 55. Habit: low lead hand. Combination 1-2-3b
  at Sharp 64. No cutman on staff.
- **Kerry Moss**, ranked 14, orthodox Pressure fighter (CODE weights 55/20/15/10), power 64, head damage 30 so far.
- **Monday to Friday:** camp's last week. Nothing in this map changes it.
- **Saturday, rounds 1-4.** R1 Dana (close), R2 Kerry (close), R3 Dana (clear), R4 Kerry (close): 2-2. Dana's head damage is
  2+8+2+8 = 20 (CODE), so the head place is 56 (fine). The right eye is 33, flagged as a cut at the R4 bell (ESTIMATE value,
  CODE flag); the left eye is 100 (CODE: an orthodox Kerry never lands on it). Right ribs 58 (fine). In round 4 Kerry landed
  29 punches on Dana, 25 to the head and 4 to the body. Over 24 exchanges Kerry pressed 13, loaded up 6 (the last three of
  round 4), countered 4 and boxed at range 1.
- **The minute before round 5** (the picture). Energy at the bell is Dana 39, Kerry 51. The rest gives back about 9, so the
  starts are 48 and 60 (CODE refill; ESTIMATE debt). The coach's star is Hands up (CODE: the last three were loading up).
  - Kerry's mix and the calls (section 4). Jab and move is about +9 an exchange, Hands up about +2.
  - The second: 14 body hits taken, so ice can take 3 points. With two rounds left the rule says ice 3: +9.4 on the energy
    line in rounds 5 and 6. Water would give +3 a point (e.a 62.6 is not under 40), this round only.
  - ONE CHANGE: the fix is offered (low lead hand was punished by loading up in round 4). Gloves high moves 4
    (round(29 x 0.15 x 0.86)); Elbows in moves 2.
  - The player picks: Push in round 5 and in round 6; Jab and move; the fix; 1-2-3b for "when Kerry loads up"; Tell the
    truth; the second's ice 3.
  - The forecast (model of the CODE formulas, 12,000 runs a line, shown as about +-5 because the inputs are ESTIMATE):
    | Minute | Win | Draw | Points loss | Stopped | Round 5 won | No sparring 10 / 21 days |
    |---|---|---|---|---|---|---|
    | The coach's minute (Skip: 2 water + 1 ice, no talk, no set-up, no change, star call, pace carried) | 21 | 48 | 29 | 3 | 42 | 21 / 79 |
    | The player's: Push both, Jab and move, fix, set-up, Truth, ice 3 | 52 | 40 | 7 | 1 | 83 | 52 / 48 |
    | ...Steady in round 5 instead | 47 | 42 | 10 | 1 | 70 | 47 / 53 (too close to call against Push both) |
    | ...Save round 5, Push round 6 | 40 | 47 | 11 | 2 | 49 | 39 / 61 |
    | ...Hands up (the star) instead of Jab and move | 31 | 49 | 18 | 2 | 66 | 31 / 69 |
    | ...Gloves high instead of the fix | 39 | 46 | 14 | 1 | 70 | 29 / 38 (and 5 days: 33) |
    | ...water 3 instead of ice 3 | 37 | 47 | 14 | 2 | 70 | 38 / 62 |
    Energy (player's minute): round 5 runs 57 -> 36, round 6 runs 45 -> 23, so Dana is tired from about 1:30 of round 6, and the
    round 6 call is Hands up or Breathe, not Jab and move.
  - What each ending costs (CODE, on the card): win = Kerry's place 14, +8 members, +5 reputation, morale +8. Draw =
    nothing moves. Points loss = -1 member, -2 reputation, morale -12 (to 46, Flat: the corner's word x0.85 next bout), and
    Dana drops one place to 17. Stopped = -2 members, -4 reputation, morale -12, 30 days suspended, rating -0.8, the next
    ladder fight 8 weeks later than it would be, durability cap -2 for good.
  - After the bout (CODE): no sparring for 10 days if Dana wins both rounds (head damage 24), 21 days if Dana loses one
    (30 or more). Injury chance about 19% in every line (the cut eye is the worst place); a cut is the likeliest injury
    (2-3 weeks).
- **Round 5:** Dana wins 4-2 in exchanges (one 1-2-3b fired when Kerry loaded up, and won: Kerry's head damage +30). Card 3-2.
- **The minute before round 6 (the last).** Ahead 3-2, any won round is a win and a lost one is a draw. With one round
  left the second's rule says water: 3 points at +3 each (e.a 53 is not under 40), so Dana starts round 6 at about 54 instead
  of 45. Push holds (it fades from 55: +4 net at 54, +2 at 45), and the round 6 energy line runs 54 -> 33. The minute flips on
  the talk. The round is a coin flip, so Truth's trust risk is live, and Calm's +2.4 energy keeps Dana over the 35 line to the
  bell. The player moves the talk from Truth to Calm and keeps Jab and move.
- **Round 6:** Kerry takes it, close. Card 3-3: a DRAW (CODE scorecards). Nobody moves on the ladder; members and reputation
  hold; morale holds.
- **After:** head damage 20 + 2 + 8 = 30, head place 34, so no sparring for 21 days (StandDown, CODE). Injury roll at about
  19%: none this time. Trust: one wrong call followed and lost (Jab and move into Kerry boxing at range) and two right calls
  won, so morale 58 - 2 + 2 = 58.
- **Monday after:** Home shows "Dana: no sparring until <date>: the head took 30 damage" (StandDown.reason). A won round 6
  would have meant 24 damage and 10 days, so 11 days of sparring hung on that round. The next ladder offers come in 8 weeks (Matchmaking.NEXT_WEEKS).
- **The cases that flip it** (model, same night):
  - Dana tired (33 after the rest): Save then Push 40 / 47 / 11 / 2 against Push both 18 / 50 / 29 / 3.
  - Behind 1-3: Push both gives a 43% draw; Save then Push gives 34.
  - Heavy head damage (54) against a power-68 Kerry: stopped 3% with Push both, 5% with Save then Push, 7% with Push then
    Save. The stop's price (30 days, +8 weeks, durability) now weighs on pace.
- **The debut (4 rounds):** the same minute with one round planned ahead. A cut rarely reaches a corner there (2% of
  3-round losers in the S423 probe), so THE CUT block is usually absent.

## 6. Every number in this map
| Number | Value | Mark |
|---|---|---|
| Eye hit / big; cut line; open cut | 1.15 / x2; 35; x1.5 | CODE BodyMap 13, 19, 23, 111 |
| Eye side | all eye hits from an orthodox attacker go to the defender's right eye | CODE BodyMap 48, 57, 63, 66 |
| Injury chance | 0.06 x rounds/3 x (0.4 + 1.2 x (100 - worst)/100), cap 0.4 | CODE InjuryRoll 25-35 |
| Injury weights and days | cut 20 (x2) 14-21; nose 15 21-35; head 37 21-35; hand 18 35-56; ribs 10 (x3) 21-35 | CODE InjuryRoll 17-20, 65-95 |
| Expected days given an injury | 29.1 / 27.1 (cut flag) / 28.9 (rib flag) / 27.3 (both) | worked from CODE weights |
| Suspension | 30 / 90 / 365 days | CODE InjuryRoll 12-16, 38-52 |
| Stand-down | 5 / 10 / 21 days at head place 55+ / 35+ / under | CODE StandDown 7-10 |
| Head damage a round | close 8, clear 18, dominant 32; winner 2 | CODE Knockdowns 13-14 |
| Round margin | close under 6.75, dominant from 18 | CODE RoundScript 35-36 |
| Count and stop | 0.05 x (0.3/1/2.2) x exp((power-chin)/12) x (1+dmg/60); stop 0.2 x (1+dmg/60) x (1.4-heart/100) | CODE Knockdowns 9-12, 32-60 |
| Win / loss / stopped | +8 members +5 rep / -1 -2 / -2 -4 | CODE BoutRules 90-99 |
| Morale | win +8, loss -12, draw 0, wrong call -2, right call +1 (3 each at most) | CODE FighterProfile 19-32; CornerTrust 43-48 |
| Corner's word by mood | 1.05 / 1.0 / 0.85 / 0.7 (Steady from 50, Flat from 30) | CODE FighterProfile 39 |
| Stop on the ladder | rating -0.8, +8 weeks, durability cap -2 | CODE Matchmaking 33, 48, 280-282; Attrs 40 |
| Loss below a higher-ranked winner | drop one place | CODE Matchmaking 253-254 |
| Rest refill | 52% of the fast debt x (0.8 + 0.4 x conditioning/100); fast share 0.6 | CODE Combos 37-38, 266-277 |
| Water / ice | +3, or +6 when e.a is under 40, this round / 3 hits x body_cost_a, every round left | CODE CornerJobs 15-19; BoutNight 172-175 |
| body_cost_a | 1.2 x clamp(1 + (50 - body)/50 x 0.8, 0.4, 1.8) = 1.05 at 58 | CODE Exchanges 36-37 |
| Pace | Push +6 / x1.35, fading from 55 to -6 at 25; Save -4 / x0.6 / +6 an exchange | CODE PaceAim 10-13, 182-190 |
| Call edges | best 17, ok 5, wrong -10; Good 1.0 / OK 0.6 / Poor 0.3; commit 1.5 / 1.0 / 0.6 | CODE Exchanges 16-30, 207-217 |
| Heard | (0.7 + 0.3 x coachability/100) x trust = 0.88 | CODE Exchanges 201-203 |
| Tired line; Kerry tiring | 35; 45 (3 in 4) | CODE Exchanges 46, 50, 225 |
| Kerry's style; KEEP; run | 55/20/15/10; 0.6; 3 | CODE Exchanges 54-57, 127 |
| Habit | 6 x 1.75 = 10.5 an exchange, punished by loadup | CODE HabitFix 12, 30; Exchanges 21 |
| Gloves high / Elbows in | 15% x hold / 50% x hold; 2.0 head damage a punch | CODE Adaptation 21-24 |
| Set-up | 14 x (0.5 + m/200) = 11.5 at 64; x0.6 under 40; miss -9; +30 head damage | CODE CornerJobs 22-24, 87-90 |
| Talk | see Decision 5 | CODE CornerJobs 95-111 |
| Truth's price | a lost round after Truth = one wrong call | NEW (talk rule; A9 measures it) |
| Dana's and Kerry's state | energy 39/51 at the bell, 48/60 after the rest; eye 33; ribs 58; head damage 20/30; Kerry's 24 exchanges; hold 0.86; base edge -2; Kerry lands 5 an exchange won and 3 lost, 15% to the body | ESTIMATE |
| Forecast lines (section 5) | the table | ESTIMATE (a model of the CODE formulas; A6 MinuteOdds replaces it, and its test holds it within 6 points of 300 replays) |
| Call worth on the mix | Jab and move about +9, Hands up +2, body 0, Breathe 0 (+15 when Dana is tired) | ESTIMATE from CODE edges x the 24-exchange mix |

## 7. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to | Task |
|---|---|---|---|
| Corner minute, 3D (CornerOverlay) | YOUR CARD with WHAT EACH ENDING COSTS; Kerry's games so far against the star; the plan for two rounds (pace for R5 and R6, the energy line against 35 and 55); the call tiles with their worth on the mix and the trust risk; ONE CHANGE as four priced cards; SET-UP with its price; TALK, four tiles priced; the plan line (one arrow change, built, with the line's round 4 tally); the second's one line with Change; THE CUT (three lines); THIS MINUTE against THE COACH'S (two bars) and AFTER THE BOUT | m.rounds; BoutRules consts, FighterProfile, Matchmaking, InjuryRoll.ko_days, StandDown; Exchanges.mix (A11) + STYLE_MODES; PlanFile.set_pace on the bout (A8); Exchanges.call_edge x mix; Adaptation/HabitFix offers; CornerJobs.setup_edge/talk; PlanFight.corner_options + the round's arrow tally; CornerJobsRow.defaults (A7); MinuteOdds (A6) | A6-A12 |
| Corner minute, words (FightNight modal) | the same rows; the eye and the cut from BoutMarks.build on the closed rounds | the same modules; BoutMarks.build (with A5's replayed close) | A12 |
| Shout bar in the round | the pace the corner set, already lit; Aim offers as today | LiveRound pace0 (A8); PaceAim.offers | A8 |
| Live side panel (worst tag) | "Right eye 33, cut" | BodyMap.value + cuts | exists |
| Body tips and callouts | never "the doctor may stop it" (no rule) | BodyTip, CalloutLine | A1 |
| Result page (Aftermath) | "Corner: Push R5 and R6; the fix held; 1-2-3b landed once; Truth before R5 (won)"; the stand-down line; the cut: "closed by the cutman" or "left open, no cutman" | m.rounds corner jobs; StandDown.reason; m.rounds closed (A5) | A10 |
| The Why | "Wrong calls followed: 1 (morale -2)" from CornerTrust.settle | CornerTrust.settle | exists (one line, A10) |
| Club > People, STAFF JOBS | Cutman card, true words: "Closes a cut in every corner minute of a pro bout (it loses at 1x, not 1.5x); half the cut layoffs. $150 a pro night." | StaffRoles cutman | A2 |
| Club > Money, one-offs | "Cutman, Dana's night -$150" | GymSpend 316-319 | exists |
| Home and fighter page | "No sparring until ...: the head took N damage"; "Cut - out N weeks" | StandDown.reason; InjuryRoll.line | exists |
| Playbook > Game plan, round row | unchanged: the corner writes the bout's pace, never the saved plan | f.bout.round_pace (A8) | A8 |

## 8. Build tasks (each under 500 lines, one owner, its test red first)
Seats: Cursor is out of usage (S438) and the Grok CLI is off (S397). Pure code goes to Goose (cloud) or Qwen (PC); the
corner screens go to Claude. Every brief: Discipline boxing; GAME_ON; no Godot window; parse gate first.
| Id | Owner | Files (lines today) | Test, red first | Size |
|---|---|---|---|---|
| A1 TRUTHWORDS1 | Qwen | ui/BodyTip.gd, ui/CalloutLine.gd | tests/doctor_words_truth_test.gd: no shown string says "doctor" | ~60 |
| A2 CUTMANTRUTH1 | Qwen | fight3d/CornerCrew.gd 28-34, FightCast.gd 124-126, CornerOverlay.gd 316-382 (pick removed; a hired cutman closes by himself), rules/StaffRoles.gd text | tests/cutman_corner_truth_test.gd: no cutman body without a hire; an amateur card with a cut never says "No cut"; with a hire every open cut is closed at each minute; no enswell button | ~120 |
| A3 SHOWNTRUE1 | Goose | rules/BodyMap.gd value()/corner() (205) | tests/body_shown_true_test.gd: value() equals places after any corner work | ~60 |
| A4 PUNCHSIDE1 | Goose | rules/BodyMap.gd _punch_hits | tests/punch_side_test.gd: an orthodox cross reaches the left eye, a jab or lead hook the right; re-run tools/eye_band_probe.gd | ~80 |
| A5 CLOSEREPLAY1 | Qwen | state/BoutNight.gd (record "closed" on the round), fight3d/BoutMarks.gd build | tests/close_replay_test.gd: a seeded bout with a cutman gives the same eye at the final bell in words and in 3D | ~70 |
| A6 MINUTEODDS1 | Goose | NEW rules/MinuteOdds.gd | tests/minute_odds_test.gd (missing module = red): 2-2 with two even rounds gives 25/50/25; a bounded check against 300 replays within 6 points; "too close to call" under 6 | ~250 |
| A7 SECONDRULE1 | Qwen | ui/CornerJobsRow.gd menu()/defaults() | tests/second_rule_test.gd: the menu's water line equals what CornerJobs.recover pays (red today: 6 against 3); the defaults follow the rule (ice to max with 2+ rounds left) | ~60 |
| A8 CORNERPACE1 | Qwen | state/LiveRound.gd 93-97 (the bout's round pace before PlanFile.pace_for), state/BoutNight.gd corner_jobs "pace" | tests/corner_pace_test.gd: a pace set in the minute opens the next round; the saved plan's round row is unchanged | ~60 |
| A9 TRUTHPRICE1 (NEW talk rule) | Qwen | rules/CornerTrust.gd tally, state/LiveRound.gd close | tests/truth_price_test.gd: Truth before a lost round = calls_wrong +1, before a won round = nothing; then tools/exchange_balance.gd shows Truth still beats Say nothing for a disciplined fighter on average | ~50 |
| A10 CORNERLEDGER1 | Claude | NEW ui/CornerLedger.gd (YOUR CARD, what each ending costs, after the bout), rules/Aftermath.gd corner line | tests/corner_ledger_test.gd: each ending's line equals BoutRules / FighterProfile / Matchmaking / InjuryRoll.ko_days / StandDown for the state | ~200 |
| A11 MIXREAD1 | Qwen | rules/Exchanges.gd mix(); ui/CallButtons.gd tile lines | tests/mix_read_test.gd: the tile's worth equals the call_edge sum over the bout's modes; the star stays the last-3 read | ~90 |
| A12 CORNERSCREEN3 | Claude | NEW ui/CornerPlanRow.gd (pace R5/R6 + energy line), CornerOverlay.gd (401, stays under 500), ui/modals/FightNight.gd (392) | tests/corner_minute_truth_test.gd: every row's numbers come from its module; the words corner shows the same rows | ~300 |
| A13 CORNERPATH1 | Claude | NEW tests/corner_path_test.gd | golden path: a seeded 6-round pro bout to a cut; the minute sets pace, call, fix, set-up and Truth; the ledger and forecast are shown; the result lines and the stand-down line follow | ~180 |
Order: A3, A4 (then re-probe the eye), A1, A2, A7, A5, A11, A8, A6, A10, A9, A12, A13.

## 9. Rejected, and why
| Idea | From | Why |
|---|---|---|
| The doctor's look at a cut (round 2 Part B), the coach's paid close, the doctor-stop layoff | round 2, both critics' 10/10 | a new damage rule; the owner ruled "Stop, show damage". It stays the only route to a cut WITH a stake. If the owner reopens damage, it comes back as one question, not before |
| Stop-or-go on the stool | pack 4.8 (agreed card), v2 | a new damage decision, and dominated (a stop is the same loss as retiring) |
| The cutman hired night by night at camp | round 2 B4 | what he buys is about 1 point of injury chance and the coin, so the hire would be a lookup either way; the standing staff job stays as coded |
| Aim in the minute, Kerry's worst place to aim at | critic 1 | Aim is on the bar already; a hurt side nets +2.5 (taken whenever offered: a lookup); aiming at Kerry's cut would need a new rule |
| "Gloves high takes the ribs to the injury line" as a price | both critics | checked in the code: the rib flag changes which injury, not how long (expected 28.9 against 29.1 days). Gloves high is priced in energy instead |
| Head-clash cuts to the cards | critic 2 (optional) | a new damage rule |
| Cutman tiers, hidden cut depth, hunting the cut, scar tissue, surgery | Kalli v3 | new damage decisions |
| Enswell | today | it lifted only the shown number |
| The second's points as a decision | today | a lookup (section 3); kept as a shown rule with an override |
| Grades (Best/OK/Wrong) on the tiles | round 1 | hidden on purpose (Exchanges 31-34); the tiles show worth on the mix instead, which needs a read of Kerry, not a colour |
| Decimals and 0.1-point rows | critics | all forecasts show whole numbers, and "too close to call" within 6 |

## 10. Risks
1. **The depth ceiling under the ruling.** In today's code the after-bout prices of damage are small. A stand-down only
   locks sparring, and the injury chance is flat once a cut eye is the worst place. The second currency's real weight is
   members, morale, rank and the stop's 30 days plus 8 weeks. Pace and the call carry the depth; the cutman carries none. If
   two fresh critics still score under 7, R28 leaves the mechanics list: the cutman becomes DAMAGESHOW work (A1-A5), and the
   priced minute (A6-A13) goes on as the corner minute's own item.
2. **Push may be near-dominant when fresh.** S323 measured "Push all fight" at 0.88 before push_gassed. In the model, Push
   both and Steady then Push sit within 6 points. A6's replays and tools/exchange_balance.gd check that each pace is best in
   some states (bounded: each wins at least 15% of sampled minutes).
3. **Forecasts must not lie.** Every forecast is A6's, shown in whole numbers as ranges. A line that misses 300 replays by
   more than 6 points is cut, not shown.
4. **A4 changes the eye.** After the cross moves to the left eye, the right eye falls more slowly. THE CUT block reads the
   map either way, and no decision depends on it.
5. **YOUR CARD equals the judges' cards** in the code, and "scorecards after each round" is on the held-back list. It needs
   the owner's OK (question 2).
6. **The new talk rule.** Truth's price could make Say nothing the default for every fighter. A9's balance check keeps
   Truth ahead on average for a disciplined fighter.

## 11. Questions for the owner (scope)
1. Accept the verdict: under "Stop, show damage" the cutman is shown, not decided (his pick goes; a hired cutman closes cuts
   by himself), and R28's decisions become the priced corner minute.
2. Show "your card" (the rounds won so far) and what each ending costs in the corner? In the game the card is the same as the
   judges' cards.

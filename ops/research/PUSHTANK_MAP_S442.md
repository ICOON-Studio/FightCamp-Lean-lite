# PUSHTANK map (S442): the Push switch and the tank, beside each fighter

Status: DESIGN, not built, not scored by critics yet. Discipline: boxing (BJJ is a branch, later).
Written from the code (file:line quoted). Every number is CODE unless tagged NEW (with its reason) or ESTIMATE.
Drawing: `docs/mockups/s442/pushtank/fight_bars.png` (generator `build_pushtank.py` beside it).

## 1. What it is for

The owner, verbatim: "I am thinking of adding 2 bars next to the fighter in the fight, one bar is switched on or off
representing the pushing aggression against the cost shown on the tank (other bar) which drains or regens according to
the tactic."
The feel he named, verbatim: "I want to see bars feeling similar to the motor style race, where you control the tires and
the fuel, something like that inside our fight maybe." (the race screen of Motorsport Manager: structure and feel only.)

What the feel means here, as a pattern: a small panel per fighter; a control that burns a visible resource; the resource
shows not only its level but whether it LASTS to the finish; push now and pay later, or bank it for the end; the pit stop
(our corner minute) is the reset you plan around; the gain shows on the fight (exchanges, the opponent's bar), not on
your own bar.

### 1b. The race reference, mapped (decided, with the code's reasons)
| Race screen | Our fight | Why this and not another |
|---|---|---|
| Fuel, with a plus or minus against the laps left | The TANK's fuel, read as exchanges to spare or short at the final bell | The tank is the one resource the result reads (`RingDuel.her_energy` feeds the situation, the duels, the push fade); "lasts to R3" already exists (`SidePanel.gd:98-102`) |
| Engine mode (low ... high) burning fuel | PUSH on / off | `PACE_SPEND` already burns the tank x1.35 |
| Overtake burst | "Let your hands go", "Go for the finish" (3.0 an exchange), the set-up NOW | They exist as calls with their own price; they stay calls |
| Tyres: wear to a cliff, not reset by fuel | The tank's GREY END: what the minute cannot give back (body shots taken, the ceiling lost to punished wrong answers, the Push extra) | Legs and guard were weighed and rejected: both plate bars come from the 3D body layer (`BodyBurn`, `FightMeters.bars`) and the result never reads them; in the sim the legs and guard ARE the tank (`Duels.effective` lowers them from energy under 65). The grey end is real and permanent (`Exchanges.BODY_COST`, `PlanPressure.ceiling`) |
| Driving style burning the tyres | No second control on our resources. AIM moves onto the panel: Body aim wears the OPPONENT's grey end | The sim has no second resource of ours to burn; inventing one (guard spent for position) is a new rule and a second decision on a screen the UX audit wants lighter (section 11) |
| The pit stop | The corner minute: the refill drawn on the same bar, up to the grey end and never past it | `Combos.after_round` (52% of the fast debt x Recovery) + the second's water (`CornerJobs.recover`) |
| Tyre temperature, bad too cold and too hot | Only the fighter's work rate has a band in the code (`Duels.PACE_HOT` 72 above, `PACE_WORK` to the busier side below); used only if probe arm C wins, as a hover line | A fighter "going cold" while saving has no rule (only the opponent's slow start, `PlanFile.cold_edge`) |
| Steps per control | Two (on / off), not three or four | Section 4.1: Save's flat refill is the exploit; Steady is "off" |

## 2. What exists today

| Piece | What the code does | Where |
|---|---|---|
| Pace choice | Three paces, push / steady / save, in force "from the next exchange" until changed | `scripts/rules/PaceAim.gd:5`, `:100` |
| What Push buys | +6 power points an exchange (`PACE_EDGE`), landed punches x1.25 (`PACE_OUTPUT`) | `PaceAim.gd:10-12`; applied `scripts/state/LiveRound.gd:243`, `:304` |
| What Push costs | the round's drain x1.35 (`PACE_SPEND`) as an extra; the edge fades from 55 energy and is -6 at 25 (`push_gassed`: 12 x (55 - e) / 30) | `PaceAim.gd:11`, `:182-190`; `scripts/state/RingDuel.gd:340-341` |
| What Save does | -4 an exchange; drain x0.6 AND +6 energy back every exchange (`SAVE_RECOVER`) | `PaceAim.gd:10-13`, `:51-54`; `RingDuel.gd:341` |
| The tank | 100 at the first bell (`Combos.TANK`) less fighting hurt / staleness; a round spends 18 (moving) + punches, x the Stamina factor 1.2 - 0.4 x Stamina/100; aimed at "ends rounds ~68 / 46 / 29, starts rounds 2-3 at ~78 / 61" | `scripts/rules/Combos.gd:22-34`, `:241-263`; `scripts/state/BoutNight.gd:303-325` |
| The minute's refill (the pit stop) | 60% of a round's spend is fast; the minute gives back 52% of the fast debt x Recovery 0.8-1.2; plus the second's water: 3 points, +3 each (+6 under 40) shared with ice and clearing the head | `Combos.gd:35-38`, `:266-276`; `scripts/rules/CornerJobs.gd:13-17`, `:52-62` |
| What is gone for the fight | each body shot taken greys BODY_COST 1.2 off the tank (x0.4-1.8 by the body); a punished wrong plan answer lowers the tank's ceiling 1.5 a clean hit, floor 70 | `scripts/rules/Exchanges.gd:40-45`; `scripts/rules/PlanPressure.gd:10-13`, `:24-26`; `LiveRound.gd:408` |
| How tired changes an exchange | under 65 energy: guard, head movement, footwork lose up to 12, hands and power up to 6 (`Duels.effective`); heart halves the fade from round 3; under 35 the exchange is "Your fighter is tired" (Breathe becomes the best call); combinations shorten from 70 to 30; a round's base edge loses up to 6 by the bell's tank | `scripts/rules/Duels.gd:71-74`, `:127-151`; `Exchanges.gd:51-52`, `:171-177`; `Combos.gd:279-297` |
| The opponent's tank | spends by their combinations and conditioning; under 45 they turn "Tiring" 3 times in 4; our pace never touches it except through more body shots landed | `BoutNight.gd:320`; `Exchanges.gd:55-56`, `:236-237`; `LiveRound.gd:316-321` |
| The bursts | "Let your hands go" and "Go for the finish" cost 3.0 energy an exchange; the set-up NOW once a round (+14 x (0.5 + mastery/200), x0.6 when under 40) | `Exchanges.gd:80-91`; `CornerJobs.gd:18-22`, `:98-102` |
| The refilling calls | "Breathe, pick your shots" -3 (gives 3 back an exchange), "Tie up" -2, "Jab and move" / "Draw the lead" -0.5 | `Exchanges.gd:67-91`; `RingDuel.gd:335-336` |
| Round pace in the plan | the plan's ROUND row opens each round on a pace; a slow starter pays +3 for a push in round 1's first two exchanges | `scripts/rules/PlanFile.gd:9-28`, `:111-141`; UI `scripts/ui/GamePlanRows.gd:12-29`; read `LiveRound.gd:93-97` |
| Last round if ahead / if behind | `PlanPhase.pace(late, round, rounds, state)` is built and NOT WIRED: nothing in `scripts/` preloads PlanPhase | `scripts/rules/PlanPhase.gd:103-109` |
| The fighter's own work rate | a hidden style dial `work_rate` 40-80 (Attrs "pace"): a busy fighter takes close exchanges (+8 x gap/100), pays guard (6 x (p - 0.5)) and feeds counters (15 x (p - 0.5)); past 72 more work starts missing (accuracy -0.20 a point, guard -0.30) | `scripts/rules/FighterProfile.gd:88`; `scripts/rules/Attrs.gd:80`; `Duels.gd:45-49`, `:132-142`, `:270` |
| Cardio in training | roadwork and intervals train Stamina (sets the drain), a rest morning trains Recovery (sets the refill); Second wind perk (Conditioning 70): +10 at the round-3 bell | `Attrs.gd:271-274`, `:320`; `Combos.gd:262-268`; `scripts/rules/PerkFight.gd:14-15`, `:69-72` |
| Before the bell | fight week tiredness takes 2 a point over fresh off the first-bell tank (max 20); fighting hurt 10/15/20 | `scripts/rules/BoutRules.gd:33-36`, `:189-202`; `BoutNight.gd:306-308` |
| After the fight | tiredness = 45 + (100 - tank at the last bell) x 0.5 (+10 for a stoppage loss), max 95; read on the calls-and-pace tank | `scripts/rules/Aftermath.gd:18-33`; `scripts/state/AfterFight.gd:39-42` |
| Traits | Short fuse (temper 65+): Fire up turns wild (-2, hurt x1.6), Calm down +1; Disciplined (60+): the truth +1.2; heart resists the fade late | `scripts/rules/TraitLine.gd:20-40`; `CornerJobs.gd:105-121`; `Duels.gd:130-131` |
| Judges | today the cards come from rounds won only; the queued Judges module (R29) gives "work" (pace dial gap / 10) to pro judges only | `BoutRules.gd:371`; `ops/research/TASK_R29JUDGES1.md` |
| The HUD | name plates: energy / legs / guard bars with numbers, "lasts to R3", a worst-place tag; the energy bar marks the last CALL's cost; the opponent's energy is a range (16 wide, 6 once on film); bottom bar: PACE Push / Steady / Save, AIM, "FROM THE NEXT EXCHANGE" box | `scripts/fight3d/SidePanel.gd:21`, `:93-102`, `:290-319`, `:332-350`; `scripts/fight3d/CornerBar.gd:151-177`, `:278-298`; still `E:/FightCamp/tmp/bubbles/bubble_coach.png` |
| The plate's legs and guard bars | drawn from BodyLoad / BodyBurn, the 3D body layer that drives the animation; the result never reads them | `scripts/fight3d/BodyBurn.gd:1-9`; `scripts/rules/FightMeters.gd:38-51` |
| BJJ | a gas tank per athlete (drain by cardio) and a bout call hunt / steady / hold (+25 / 0 / -20 aggression) | `scripts/rules/BjjBody.gd:56-66`; `scripts/rules/BjjBeat.gd:18-25` |

### Already there, new, and done badly

ALREADY THERE: the pace choice (three paces), the energy bar, a "lasts to R3" line, the refill in the minute, a grey end
on the tank for body shots (in the hover rings, `scripts/fight3d/HudBars.gd:28-30`).

NEW in his words: the two bars stand BESIDE the fighter as one panel; the push is ONE switch, on or off; the tank visibly
drains or refills with the switch, and you see the cost before you press.

DONE BADLY TODAY (measured from the code; arithmetic for a Stamina 55 fighter, no drilled combinations: a round spends
(18 + 54 x 0.22 x 1.05) x 0.98 = about 30, so about 5 an exchange):
1. **Push costs little and is lost for good.** Push adds 0.35 x 5 = about 1.7 an exchange, 10.5 a round. That extra goes
   through the round's cost (`RingDuel.gd:341`) after the minute's refill was worked out from the planned spend
   (`BoutNight.gd:319`), so the minute never gives any of it back. In round 1 from a full tank Push never reaches the 55
   line (100 - 30 - 10.5 = 59.5): round 1 Push buys +6 an exchange (about 50% -> 59% an exchange on even dice:
   triangular spread of 66, `Exchanges.gd:14`) for nothing but 10.5 off later rounds.
2. **Save refills more than Push spends.** Save is -4 an exchange (about 50% -> 44%) for 0.4 x 5 + 6 = 8 back an
   exchange, 48 a round, carried into the next round (`LiveRound.gd:407-408`). One Save exchange pays for 4.6 Push
   exchanges. So "Push five, Save one" each round costs the tank about +0.7 a round over Steady and is worth +26 power
   points a round. Pace changes are free, unlimited and need no shout (`CornerBar.gd:108-130` writes the live round
   directly; `LiveRound.gd:186-192`). This is a lookup and an exploit; nobody measured it (the S323 check ran a pace per
   ROUND: steady 0.67, push all 0.71, save all 0.56, `ops/research/S323_DIGEST.md:23-25`, and those numbers predate the
   S398 duels and the S442 foundation, which moved one matchup by 17 points: `ops/research/FIRELEVEL2_ADAPT1_RESULT_S442.md:20-21`).
3. **Is there a reason to Save?** Only through the exploit above, or to climb back over 35 (tired) and 55 (Push
   fading). A Save round at Steady's cost of tank is never right: the three cards are round wins only (`BoutRules.gd:371`).
4. **The cost is not visible before choosing.** The bar's ghost mark shows the last CALL's cost, never the pace's
   (`SidePanel.gd:311-319`); the pace's price is a tooltip ("drains about a third faster", `PaceAim.gd:103-106`);
   "lasts to R3" is wrong for Save (it scales the drain by 0.6 and forgets the +6 back, `scripts/rules/EnergyForecast.gd:47-57`)
   and gives the minute only the second's water, not the 52% refill (`EnergyForecast.gd:40-43`).
5. **Push is the same against everyone.** +6 flat: it does not care whether the opponent counters, whether our fighter
   is already a busy one, or how the cards stand.
6. **Two of the plate's three bars are not the fight.** Legs and guard are the 3D body layer (BodyBurn); the result
   never reads them, while the tank that decides exchanges shares the plate with them as an equal.

## 3. The pitch (the one decision)

Every 30 seconds the head coach decides one thing: **is this the moment to spend?** One switch, PUSH, on or off. On, our
fighter wins more of the next exchanges and lands more (the gain is in the ring and on the OPPONENT's bar); the tank
drains faster and nothing the corner does gives that back. Off, the fighter boxes at the usual rate. The tank is not a
level to keep high: it is fuel that must reach the final bell. It reads like a race car's fuel: "to the bell, 4 spare"
or "tired 5 exchanges early", and a ghost shows what one more exchange of Push would leave, before you press.

Why it is not a lookup: the price is paid in OUR fuel, and fuel is worth nothing at the final bell but everything before
it; the gain is paid in exchanges NOW, worth most when the round is close and the cards are close. The fight's state
weighs the two differently: the score (ahead, behind), who is hurt, how much fuel is left against how many exchanges
remain, the opponent's fuel (under 45 they start tiring), and who the opponent is (a body puncher greys our tank end,
so fuel spent early is worth more than fuel saved for late). No single number on the screen gives the answer.

What the player sees: beside each fighter a compact panel: the switch, the tank with a grey end (what is gone for the
fight) and the "does it last" line. Ours has the switch; theirs is read-only and only as known from film.

## 4. The mechanic

### 4.1 The switch: on / off (decided), Save folded into "Breathe"
- TWO steps, PUSH ON / OFF, not three and not four. Reasons from the code: Save's flat +6 refill is the exploit in 2.2;
  Steady is just "off"; four steps would put four nearly equal prices on one control (the S323 check found rounds of
  each within 4 points). His first message asked for on / off.
- What happens to Save: the in-round refill moves to the call that already does it, "Breathe, pick your shots"
  (`Exchanges.gd:83-85`: -3 an exchange, best when our fighter is tired). A refill then costs something real: one of the
  two shouts a round that land in full (`Exchanges.gd:46-47`) and the tactical call it replaces. The refill and the
  tactics now compete for the same voice. NEW: `SAVE_RECOVER` and the "save" pace leave the live round; old plans with
  "save" read as OFF.
- The BURST (the race's overtake button): we already have three: "Let your hands go" (3.0 an exchange, best against a
  tiring opponent), "Go for the finish" (3.0, best against a hurt one) and the set-up NOW (once a round). They stay
  calls. Their price joins the ghost on the tank (today the ghost shows only the last call, `SidePanel.gd:311`).
- The plan's ROUND row becomes Push on / off per round (`PlanFile.PACES`, `GamePlanRows.gd:24-29`).

### 4.2 The tank: two layers, fuel and wear
- FUEL = what the minute can give back. Drains by the round's spend (CODE, about 5 an exchange at Stamina 55),
  x1.35 with PUSH ON (CODE `PACE_SPEND`), plus the calls' costs (CODE). Refills in the minute: 52% of the fast debt x
  Recovery (CODE), the second's water (CODE), Second wind (CODE), and in the round only through Breathe / Tie up / Jab
  and move (CODE costs).
- WEAR = the grey end, gone for the fight: body shots taken x body cost (CODE, already drawn as the grey end in
  `FightMeters.gd:39-41`), the ceiling lost to punished wrong plan answers (CODE `PlanPressure.ceiling`, NEW to show), and
  the Push extra (CODE behaviour: the minute never refills it; NEW only in being shown as wear). Wear is the race car's
  tyre and engine wear in one: the pit stop does not reset it. This is the honest mapping of the reference: in our
  fight the corner refills fuel and cannot refill wear.
- THE LINES on the tank (the "cliff" where lap time falls off): 55, where Push starts to backfire (CODE
  `PUSH_GAS_FROM`); 35, where our fighter is "tired" and the exchange changes (CODE `SHE_TIRED`). Shown as two ticks;
  only the 35 line is named ("tired"). 65 (`Duels.TIRED_AT`) stays in the hover: three lines on one bar is too many.
- THE LAST READOUT: exchanges of fuel above the 35 line at the current setting, against exchanges left in the bout, with
  the minute's refill in between: "to the bell, 4 spare" / "tired 5 exchanges early" (NEW words; NEW maths in
  EnergyForecast: the true refill, wear, and Breathe; Save's term removed).

### 4.3 What Push buys (on other axes than the tank)
- Exchanges now: +6 power points (CODE), fading under 55 (CODE). On even dice that is about 50% -> 59% an exchange.
- The opponent's bar: landed x1.25 (CODE) means more body shots landed (CODE share 0.2, 0.5 with Body aim), each one
  greying the OPPONENT's tank for the fight (CODE 1.2 each), and pushing them toward 45, where they start "Tiring" 3 times
  in 4 (CODE) and "Let your hands go" becomes the best call (CODE). The gain lands on THEIR panel, which is the race feel:
  you see your pace on the track, not on your own bar.
- PROBE ARM C (NEW, decided by the probe, not before): Push enters through the fighter's own work-rate dial instead of a
  flat +6: work rate +15 while ON (NEW size, ESTIMATE). Then the Duels rules price it by who is fighting: a patient
  fighter (40) gains the close exchanges (`PACE_WORK` 8 x gap/100), a busy one (70) pushed past 72 starts missing
  (`PACE_HOT`, accuracy -0.20 and guard -0.30 a point), and against a counter-puncher every push point feeds their
  counters (`PACE_COUNTER` 15). This is the only "too low and too high" band the code supports: work rate. If arm C wins,
  the switch's hover names the band ("Already busy: pushing past this misses more"); there is no temperature bar.
- LATER (NEW, needs the Judges module wired): pro judges score "work"; while ON the work part counts our fighter as busier.

### 4.4 What an empty tank costs (all CODE)
- Under 65: guard, head movement and footwork drop up to 12, hands and power up to 6 (heart halves it from round 3).
- Under 55 with Push on: the push edge fades; at 40 it is worth 0; at 25 it is -6.
- Under 40: the set-up NOW is x0.6; combinations get cut off (up to half when empty).
- Under 35: "Your fighter is tired" replaces the opponent's game for the corner: the calls on offer change and the
  opponent's game is hidden behind our own trouble.
- Lower guard means more hurt chances against power (`RingDuel.gd:349-350` reads chin and power; the fade lowers the
  guard the duels read) and so more counts; amateur referees stop at 3 in a round or 4 in a bout.
- After the fight: tiredness 45 + half the tank used, so a fight finished at 0 leaves 95 (four or more rest days)
  against 65 for one finished at 60 (`Aftermath.gd:18-33`).

## 5. Why it is not a lookup: the cases

| Case | Right choice | Why |
|---|---|---|
| 1. Ahead 2-0 into round 3 (amateur) | OFF, Breathe only if under 35 | Round 3 cannot change the result unless a count does; fuel left lowers the after-fight toll and keeps the guard up (counts and stoppage risk) |
| 2. Behind 0-2 or level 1-1 into round 3 | ON from the bell, all of it | Fuel has no value after the final bell; every exchange won now is the fight. The lines still matter: past 55 the push fades, so ON to the 40s, then the burst calls |
| 3. The opponent is hurt | ON now, plus "Go for the finish" | Hurt lasts until the next exchange's roll; the burst and Push stack (+6 and +17 best); the window closes whatever the tank says |
| 4. Our fighter is hurt | OFF, "Tie up" | Hurt costs guard already; Push adds guard cost (arm C) and walks into the hurt chance; Tie up refills 2 and is the best call when hurt (CODE) |
| 5. The opponent's tank is lower (under about 50, film shows it) | ON | Every body shot more brings them under 45 ("Tiring" 3 times in 4), where Let your hands go is best; our fuel is the cheaper resource tonight |
| 6. A body-punching opponent | ON early, OFF late | Their body share is 0.35 (CODE): each round greys our tank end, so fuel saved for round 3 shrinks before we can use it; spend it while it is there (the opposite of case 5's timing) |
| 7. A short-fuse fighter just hit hard | OFF and "Calm down" in the minute | Fire up with a short fuse is -2 and hurt x1.6 (CODE); a pushing hothead is the same risk; Calm down is +1 only for a short fuse |
| 8. A slow starter | ON for round 1's first two exchanges, then OFF | +3 more in the first minute (CODE `COLD_EDGE`), and round 1's push never reaches the 55 line |
| 9. A fader (weakness "fades") | OFF rounds 1-2, ON round 3 | They go "Tiring" half the time in round 3 (CODE `Exchanges.gd:239-240`); push into the fade |
| 10. A 6-round pro fight | ON in short bursts at close rounds | The tank must cover twice the exchanges; one Push round is 10.5 lost for the fight (CODE) |

The ten cases do not share an answer: ON in 2, 3, 5, 8 (early), 9 (late), 6 (early); OFF in 1, 4, 7. The same switch is
right early in 6 and late in 9.

**The probe before any screen (PUSHPROBE1, through the real bout, 400 paired bouts a cell, two different fighters each
side, never identical):** arms A (today: three paces, including "Push five, Save one" per round), B (on / off, Save
folded into Breathe), C (B with Push through the work-rate dial). Policies: always ON, always OFF, ON round 1 only,
ON round 3 only, "Push five, Save one" (arm A), and a state reader that follows the case table. Cells: the ten cases
above as starting states. PASS for an arm: no fixed policy is best in more than 6 cells of 10; the state reader beats
every fixed policy by at least 3 points overall; ON-all-fight is not best in more than 4 cells; "Push five, Save one"
is gone in B and C. Also log the tiredness toll per policy, so the after-fight branch has its numbers.

## 6. Branches into the rest of the game

| Branch | Today | The link | When |
|---|---|---|---|
| Training: Cardio | Stamina sets the drain (x1.2 at 0 to x0.8 at 100), Recovery the refill (x0.8-1.2); roadwork, intervals, rest; camp focus Conditioning; Second wind perk | The "lasts" line answers to Cardio: a fighter who trained Stamina shows more spare exchanges for the same pushing. The Week shows the effect on the switch in words: "Cardio +2: about 1 more exchange of Push a fight" (NEW, from the probe's numbers) | First build: the link is in the maths already; the words on the Week LATER |
| Training: a "hard rounds" drill | none | NEW evening card: sparring at Push lowers the Push cost for that fighter (x1.35 -> x1.30 at most). A real boxer learns to work tired | LATER, only if the probe shows Push is used |
| The plan before the fight | ROUND row push / steady / save; PlanPhase's if ahead / if behind built, not wired | ROUND row becomes ON / OFF; PlanPhase wired for the last round: "if ahead: off, if behind: on" (the case table's two most common answers, in the plan) | ROUND row: first build. PlanPhase: second step |
| The corner minute (the pit stop) | water +3/+6 a point; the 52% refill; no pace control | The refill animates on the same tank at the bell up to the grey end; a "Next round: Push on / off" row writes the round's switch (as in `ops/research/CUTMAN_MAP_S439.md` Decision 1) | First build: the refill on the bar. The row: second step |
| Traits: short fuse | Fire up turns wild | NEW: a short-fuse fighter who loses an exchange by a big margin goes to Push on the fighter's own for one exchange unless the corner said Calm down | LATER |
| Traits: heart | heart halves the fade from round 3 | Shown: a high-heart fighter's 35 line sits lower in the hover ("fights on when tired") | LATER (hover only) |
| Traits: discipline / coachability | Disciplined: the truth works; trust (morale) scales calls | NEW: a fighter whose trust is Low ignores the switch as he ignores shouts (CornerTrust.lands) | LATER |
| The opponent | no pace of their own; tank a range (16 wide, 6 on film); style sets body share and games | Their panel: fuel as the range, wear exact (we count our own landed body shots), no switch shown. NEW later: a style's corner that pushes (Swarmer, Volume puncher) so their fuel is a readable decision | First build: their panel read-only. Their switch: LATER |
| Body shots | 1.2 a shot off the tank for the fight; Body aim sends half the punches there; +3 once their core or legs burn passes 50 | The grey end grows on THEIR panel when our body work lands: our AIM row's effect becomes visible where it lands | First build (the grey exists; the panel shows it) |
| Judges | rounds won only; R29 Judges module queued: pro "work" from the dial | While ON, our work part counts busier for pro judges (NEW) | LATER, after Judges is wired |
| Crowd and the club | no excitement rule in the code | none: a crowd liking a pushing fighter would be a new system | Left out |
| After the fight | toll 45 + half the tank used (+10 stoppage loss) | The result's "Energy at the last bell" line and the Home card for tiredness name the cost: "Pushed 9 exchanges: 2 more rest days" (NEW words, CODE maths) | Second step |
| Ladder and pro | rounds 4 / 6 / 8 / 10; Combos tuned on 3 rounds | The "lasts" line matters most here; PlanPhase already splits 2-12 rounds | LATER: a pro probe for the long tank |
| BJJ | gas tank (cardio drain), hunt / steady / hold per bout | The same panel on the mat: HUNT on / off against the gas tank; GAS_W already makes the tank gap matter late | LATER (the open's fight screen) |

## 7. The screen

The panel (drawn): beside each fighter, at the top corners where today's name plates sit, never over the ring area where
heads, gloves and feet are (today's plates already sit there, `bubble_coach.png`).
- Ours: name; the switch (two steps, PUSH ON | OFF, words in caps, the lit one cream, the other dark: the house "chosen"
  style); the TANK, one wide bar: fuel in gold, the grey wear end, a thin tick at 55 and a named tick at 35 ("tired");
  the readout line under it in plain words ("To the bell: 4 spare"). AIM sits on the panel's second line, moved from the
  bottom bar (Own game / Body / Head), because its effect shows on the opponent's tank.
- Theirs: name, record or the game seen on film (today's line), the tank as a range (today's 16 / 6 widths), their grey
  end exact, the readout only once on film ("Tired by about round 3").
- The ghost (shown BEFORE pressing): while the pointer is over PUSH ON, the next exchange's drain at Push is cut out of
  the fuel's end as a hatched slice, and the readout says what it would become ("Push: tired 2 exchanges early"). While
  ON, the ghost stays as the next exchange's slice. Calls add their slice the same way on hover.
- Near empty: the fuel turns amber under 55 with Push on (the push is fading) and red under 35; the readout says
  "Tired now: Breathe gives 3 back". The ONE pulsing element: the 35 tick, only while the fuel is within one exchange of
  it. Nothing snaps: the fuel eases from exchange to exchange (the plates already tween).
- What it REPLACES: the plate's three bars (energy, legs, guard) become the one tank; legs and guard go to the hover and
  stay in the 3D body (they drive the animation, not the result). "lasts to R3" becomes the readout. The bottom bar loses
  the PACE row and the AIM row (both move to the panel) and the "FROM THE NEXT EXCHANGE" box's pace and aim lines. The
  holograms are not part of this map (the UX audit's proposal C moves them into the plates; this panel takes their
  space as well).
- Words: "Push", "Tank", "Tired", "Cardio" in hovers; never "Engine", never he / she / her / him (the opponent by name).

## 8. Every menu it appears on, and what each is wired to

| Menu | What it shows / does | Wired to |
|---|---|---|
| Fight night, 3D (name plates) | the panel: switch, tank (fuel, wear, ticks), readout, ghost; the opponent read-only | `scripts/fight3d/SidePanel.gd` (rebuilt as the panel), writes `lv["pace"]` like `CornerBar._write` (`CornerBar.gd:116-130`); reads `RingDuel.her_energy` / `opp_energy`, `FightMeters.bars` (grey end), `PlanPressure.ceiling`, a rewritten `EnergyForecast.rounds_left` |
| Fight night, 3D (bottom bar) | PACE and AIM rows removed | `scripts/fight3d/CornerBar.gd:151-177`, `:278-298` |
| Fight night, 2D (no picture) | the same switch on the shout bar | `scripts/fight3d/ShoutBar.gd:84-95` (PACE row -> PUSH on / off) |
| Corner minute, 3D | the refill animates on the tank at the bell; later the "next round: Push" row | `scripts/fight3d/CornerOverlay.gd`, `CornerRest.gd`; `CornerJobs.recover`; `Combos.after_round` |
| Corner minute, 2D | the same refill line | `scripts/ui/modals/FightNight.gd:185-206` (today `Broadcast.tank`) |
| Playbook > Game plan, ROUND row | Push on / off per round; later the last round's if ahead / if behind | `scripts/ui/GamePlanRows.gd:12-29`; `PlanFile.set_pace` / `pace_for`; later `PlanPhase.pace` read in `LiveRound.open` (`LiveRound.gd:93-97`) |
| Result page | "Energy at the last bell" (today's line) and, second step, exchanges pushed | `scripts/rules/FightStats.gd:34`, `:48` |
| Home, tiredness card (second step) | rest days the fight cost, with the push share | `scripts/rules/Aftermath.gd:32-37` |
| Fighter > Week (later) | Cardio's effect in words | `Attrs.SESSION_ATTRS`, `Combos.spend_factor` / `refill` |
| Golden-path test | walks round 1 ON, round 3 OFF, the ghost and the refill | NEW `tests/pushtank_path_test.gd` |

## 9. The logic of the moment

- When: any time the round is live; counts from the next exchange (today's rule, `PaceAim.WHEN`); stays until changed.
  Free: no shout, no heard pip. That is safe once Save is gone (nothing refunds a quick toggle).
- Not in the minute itself (the minute has its own row, second step); not during a count; not when the fight is simmed.
- A hurt fighter can still be switched ON (case 4 says it is wrong, the game lets the coach be wrong).
- The game allows today: pace any time, free, three steps (`CornerBar.gd:108-130`); the minute has no pace control
  (`CUTMAN_MAP_S439.md:63`).

## 10. The build, smallest playable step first

1. PUSHPROBE1 (no screen): arms A / B / C, the policies and cells of section 5, through the real bout; the tiredness
   toll per policy. Owner sees the table. If B and C both fail the pass line, the map goes back to design.
2. Rules, smallest: the switch (on / off) in `PaceAim` and `LiveRound`; Save removed (old "save" reads as off); arm C's
   dial path only if it won. EnergyForecast rewritten (true refill, wear, Breathe). Unit tests on both; the
   "Push five, Save one" cell red on main first.
3. The panel on the 3D plates (ours with the switch, theirs read-only), the ghost, the ticks, the readout; the bottom
   bar's PACE and AIM rows removed; the 2D shout bar switch. Stills on the game's camera, both fighters head to feet.
4. The refill on the tank at the bell (3D and 2D corner).
5. Plan ROUND row as on / off; then PlanPhase wired for the last round (if ahead / if behind).
6. Second step: the minute's "next round" row, the result and Home lines for the push's toll.
7. Later: traits (short fuse, trust), opponent's own switch, judges' work, the hard-rounds drill, pro probe, BJJ HUNT.
The golden-path test walks step 3-5 end to end before the build is called done.

## 11. Left out on purpose

- A second control that burns a second resource of OUR fighter (the race's tyres as legs or guard): the sim has one
  resource (the tank); legs and guard on today's plates are the 3D body layer and decide nothing. A guard resource
  spent for position would be a new rule and a second decision on a screen the UX audit wants lighter.
- Three or four pace steps: see 4.1.
- A temperature bar: only work rate is band-shaped in the code; it lives in arm C's hover if C wins.
- Crowd excitement and members from an exciting fight: no such rule exists.
- Numbers on the bars: words and ticks on the panel, numbers in the hover (the plates' style).

## Addendum (S442, after his next message): more meters fed by stamina
His words: "Need ideas to add more meters affected by like stamina to make it a bit more engaging for the player ?"
Claude's answer to him, to be folded into v2 with the critics' second pair: THREE meters, each with its own control and
its own cliff, stamina feeding all three (a low tank wears the legs faster; tired legs make composure harder to hold):
TANK (fuel; Push on/off; tired), LEGS (tyres; move or plant; "the legs went": dragged inside and onto the ropes), HEAT
(composure, bad at both ends like a tyre temperature; the corner's Calm down / Fire up; too cold = passive and marked down,
too hot = wild and countered; traits get a visible job). Moments, not meters: the guard dropping, a second wind, body
shots as an investment, stealing the last 30 seconds of a close round. Today's legs and guard bars follow the 3D
animation and the result never reads them: Legs and Heat need new rules and a probe through real bouts before any build.

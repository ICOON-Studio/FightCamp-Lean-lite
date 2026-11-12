Idea as written: depth 4/10, play 5/10
Map (PUSHTANK_MAP_S442): depth 4/10, play 5/10
One control or two: two controls, two resources, three steps each (Pace: Coast / Steady / Push, burning FUEL; Guard: High / Normal / Open, burning HEAD)
Drawing: docs/mockups/s442/pushtank_critic_a/ten.png

# PUSHTANK critic A (S442): a systems designer who knows the Motorsport Manager race screen

Read: CRITIC_PACK.md, CRITIC_ACCESS.md, PUSHTANK_MAP_S442.md, fight_bars.png, and the code (PaceAim.gd, Exchanges.gd,
LiveRound.gd, RingDuel.gd, BoutNight.gd `_energy`, Combos.gd tank section, CornerJobs.gd, Knockdowns.gd, PlanFile.gd
`cold_edge`, PlanPhase.gd `pace`, CornerBar.gd `_write`). No other reviews.

## 1. The idea as he wrote it: depth 4, play 5

What works: one resource you can see draining, and a switch that drains it faster in exchange for winning now. That is
the core of the race screen, and it fits the 30-second rhythm. Showing the cost before you press (the ghost) is the right
instinct, and "regens according to the tactic" ties the refill to the calls, which is good.

Why depth 4: one switch and one fuel bar solve themselves. In Motorsport Manager fuel alone is close to a lookup: run
the mode that finishes with zero spare. The race screen is deep because the same few decisions spend two resources that
recover in different ways (fuel only at the start, tyres at the stop), and because rivals are managing the same thing in
front of you. One switch on one bar gives "spend the spare", and after about ten fights the player has it worked out.

Why play 5: it is easy to read and nice to use for the first fights. Over a hundred fights it turns into a habit you run
without thinking (section 2). He asked for "the tires and the fuel", meaning two things to manage, and his first message
only describes one of them.

## 2. The map: depth 4, play 5

The map does careful work against the code. It finds the "Push five, Save one" exploit, sees that the Push extra is never
refilled, sees that the forecast is wrong for Save, and gates everything on a probe. The ghost slice, the "to the bell, 4
spare" readout and the refill drawn on the same bar are all right. It still loses depth for four reasons: it removes the
one decision that played like the race (coasting), its case table contradicts the code in four of ten rows, the gain it
promises on the opponent's bar is too small to see, and its first drawn line (55) tells the player what to do.

### 2a. Arithmetic checked against the code
- Round spend at Stamina 55, no combos: (18 + 54 x 0.22 x 1.05) x 0.98 = 29.9, about 5 an exchange. CORRECT (`Combos.round_spend`, `spend_factor`).
- Push extra: `RingDuel.settle` adds drop x (1.35 - 1) = 1.75 an exchange, 10.5 a round. CORRECT.
- It is never refilled. CORRECT, and worse than the map says: the planned spend gets 60% x 52% x Recovery back in the
  minute (about 31%), while the Push extra gets 0%. So Push fuel costs more than ordinary fuel. Showing it as grey wear is honest.
- Save: drop x (0.6 - 1) - 6 = -8 an exchange, applied to `cost`, so it goes up within the round and carries over through
  `fb.energy.a - spent` (clamped only at `PlanPressure.ceiling`). CORRECT. One Save pays for 8 / 1.75 = 4.6 Push. CORRECT.
- "Push five, Save one": 5 x 1.75 - 8 = +0.75 tank a round for 5 x 6 - 4 = +26 power points. CORRECT. The trick exists today,
  and pace changes are free (`CornerBar._write` sets `lv.pace` directly, with no shout and no pip). CORRECT.
- +6 on even dice: each side rolls +/-33, so the margin is triangular on [-66, 66]; P(win) = 1 - 60^2 / (2 x 66^2) = 0.587. CORRECT.
- Round 1 Push never reaches 55: entering exchange 6 at 100 - 5 x 5 - 5 x 1.75 = 66.25. CORRECT.

### 2b. Where the map's own conclusion is wrong
- **The exploit is the flat +6 (`SAVE_RECOVER`), not the third step.** Set SAVE_RECOVER to 0 and Save becomes drain
  x0.6 (saves 2 an exchange) at -4. Then "Push five, Save one" costs 8.75 - 2 = 6.75 a round, and the exploit is gone. Removing
  the step as well throws away the best decision this mechanic has (2d).
- **Push barely touches the opponent's bar.** Landed is 4 / 5 / 6 by margin band (`Exchanges.LANDED`). Push x1.25 adds about
  1 punch an exchange, and 0.2 of it goes to the body (0.5 with Body aim). That greys their tank by 0.24 (0.6 with Body aim)
  an exchange, against 1.75 of ours. Six pushed exchanges grey their bar by 1.5 to 3.6 points, too little to see. The claim
  that "the gain lands on THEIR panel, which is the race feel" is not true in these numbers. The gain shows on the round dots.
- **The 40 line is missing.** `push_gassed` puts Push's worth at +6 at 55, 0 at 40 and -6 at 25. The drawing marks 55 and 35.
  A player who reads 55 as "stop" leaves value unused, and one who reads 35 as "stop" pushes at a loss from 40 to 35. The line
  that matters is 40, where Push is worth nothing.

### 2c. The case table, row by row: what I pick, and whether one thing on the panel tells me
| Case | My pick | One read? | Against the code |
|---|---|---|---|
| 1 Ahead 2-0, R3 | Off (Coast, if it existed) | Yes: the round score, which is not on the panel | Pushing a won round raises its margin and so LOWERS our count risk (`Knockdowns.DAMAGE_PER_ROUND` follows the margin). The only reason for Off is the after-fight toll. Fine, but a lookup |
| 2 Behind or level, R3 | On while above 40, then Off with the burst calls | Yes: the fuel bar against the 40 line | Map says "ON from the bell, all of it". R3 starts at about 52-63, so from about exchange 3 Push is worth less than 0. Half wrong |
| 3 Opponent hurt | On + Go for the finish | Yes: the hurt flag | Right |
| 4 We are hurt | **On** + Tie up | Yes | **Wrong in the map.** `her_hurt` needs margin < -30, and Push raises our margin, so Push LOWERS the chance of being hurt again. The guard cost it cites belongs to arm C, which is not built |
| 5 Their tank lower | On (above 55) | Yes: our own bar | The stated reason (driving them under 45) is about 0.25 an exchange. On is right only because On above 55 is always right |
| 6 Body puncher | On early | Yes: our bar | Body greying is subtracted from the same number whatever the order, so the order does not matter for it. "Early" is right for every opponent because of the 55/40 fade. Not a case of its own |
| 7 Short fuse hit hard | Calm down in the minute; the switch does not matter | n/a | Nothing in the code links pace to temper. This row is about the talk, not the switch |
| 8 Slow starter | On all of R1 | Yes: the opponent's file | Map says "then OFF", but its own maths (R1 never reaches 55) says keep it on |
| 9 Fader | On R1, Let your hands go in R3 | Yes | Map says "OFF rounds 1-2". That throws away 12 exchanges at +6 to bank fuel that is worth less than 0 in R3 anyway |
| 10 Six-round pro | Unknown | No | Combos is tuned on 3 rounds. This is the only row where fuel is truly short, and it is not measured |

**The habit that wins:** "Push on while the bar is above about 45 (all of round 1, the start of round 2); off below it; the
burst calls by the clue." It wins or ties cases 2, 3, 4, 5, 6, 8 and 9, and the switch does not matter in 7. That is 7 to 8 of
10. The map's own probe pass line ("no fixed policy best in more than 6 cells") will most likely fail on this policy. Run
"On above X" as a named policy, for X = 45 and 55, beside the others.

**The tired cliff is soft.** Under 35 the situation becomes `she_tired`, whose best call is Breathe: +17 edge and +3 fuel,
read from one label. Running out of fuel turns the read into a lookup that pays the best edge in the game. In the race
game, falling off the tyre cliff hurts. Here it hands you an easy answer.

### 2d. The decision the map threw away
Cards come from rounds won, and a round is won on its exchanges (`won_n`). Once a round is 4-0 or 0-4, its last exchanges
cannot change who wins it. Coasting then is lifting and coasting in the race: free fuel. Coasting a LOST round has a price,
because a bigger losing margin moves the round's band from clear to dominant and adds head damage (18 to 32) and count
chance. That is a real trade between fuel and head, from code that already exists. The map's panel does not even show the
round's exchange count beside the switch.

## 3. The reference: one control or two

**Two.** In the race screen, both controls buy the same thing (pace) and spend different currencies (fuel, tyres). Those
currencies come back differently (fuel never, tyres at the stop) and are linked (a heavy car wears its tyres). The
question on every lap is "which currency is cheaper right now?", and that has no fixed answer. With one control the
question becomes "is there any spare?", which does have one.

The map says the sim has no second resource of ours. It does: **head damage** (`Knockdowns`: `m.damage`, DAMAGE_PER_ROUND
close 8 / clear 18 / dominant 32 to the loser; the count chance doubles at 60; KO possible from KO_DAMAGE 60; the
after-bout injury roll reads settled damage). It is permanent for the fight, it has a cliff, and it decides results through
counts and RSC. Those are the tyres. Legs and guard on today's plates are rightly rejected.

**The second pair, concretely:**
- Resource: HEAD, 0-100, the existing bout damage. NEW rule: settle it per exchange (the exchange's margin band / 6 to the
  loser, WINNER_DAMAGE / 6 to the winner) instead of once a round, so the bar moves while you watch. Cliff line at 60.
- Control: GUARD, High / Normal / Open (NEW):
  - High: edge -3, our landed x0.85, head damage taken x0.6, hurt chance x0.7, fuel +0.5 an exchange (arms up costs breath).
  - Normal: today.
  - Open (chin out, trading): edge +3, landed x1.1, head damage taken x1.5, hurt chance x1.4, fuel -0.3 an exchange.
- The link (NEW, using what `Duels.effective` already does to guard under 65): head damage taken x (1 + 0.5 x
  clamp((65 - fuel) / 65, 0, 1)). A fighter low on fuel wears the head faster, like a heavy car wearing its tyres.
- The pit stop allocates between them: today's 3 recover points (water / ice / clear the head) gain "head: -8 damage a point"
  (NEW; today clear-the-head only removes the hurt flag). The minute becomes a pit decision: fuel or tyres.
- The running trade: Push + Open is the all-in burst (both currencies). Push + High is pressure behind a high guard (fuel
  burns twice, head safe). Coast + Open is countering off the back foot (fuel banked, head at risk). Coast + High is
  surviving. Which one is right depends on our Stamina against our Chin, the opponent's power against our head damage,
  exchanges and rounds left, and the round's tally. No single number on the panel gives it.

**On/off or three or four steps:** three per control. Each end must have its own use: Push to win exchanges, Coast for a
settled round. The middle is the default you return to. On/off with free toggling already gives finer control over time
(push 3 of 6 exchanges), so a fourth step adds price rows without a new decision. On/off loses the coast, which is the step
that plays most like the race. Three times three is nine states. Show them as ONE "next exchange" line (edge, fuel, head),
never as a table.

## 4. "Next to the fighter"

Fixed panels at the top corners are better for play. The eye learns one place, and nothing moves while you read a number;
Motorsport Manager's driver panels are fixed too, not stuck to the cars. Bars that follow a 3D boxer around a moving camera
jitter, swap sides when the boxers circle, and fight the heads and gloves for space.

To have "next to the fighter" as well, draw it on the canvas: a ring on the floor under each boxer, outer gold arc for fuel and
inner red arc for head, drawn before the bodies so the body hides it and never the other way round. It sits on the canvas
plane in the corner's colour, about 0.9 m across, at 60% opacity, and is hidden in close-ups and knockdown shots. It only
shows whether that boxer is near empty. The numbers and controls stay in the fixed panels. Colour the panels by corner (blue
left, red right) so that when the boxers swap sides the colour still pairs each panel with its boxer.

## 5. The branches

Worth the first build:
- The plan's ROUND row as Pace (and Guard) per round. It already exists for pace.
- The corner minute refill drawn on the bar, plus the head point (the pit choice).
- The opponent's read-only panel: fuel as the film range, wear exact.
- Training: Stamina and Recovery already set the drain and refill, and Chin already sets head price. The link is free.
- The round's exchange tally on the clock ("2-1, 4 takes it"). Coasting needs it.

Missing:
- **The opponent's own dials.** Today they never push, never coast and never change guard (`BoutNight._energy`: their spend is
  fixed by combos and conditioning). The race feel needs rivals who manage too: a Swarmer pushes rounds 1-2, a counter-puncher
  goes Open when ahead, a fader coasts round 2. Shown once on film. Without it, their bar is a fixed clock.
- **The pro probe (6, 8, 10 rounds) before the panel ships.** Three rounds may never make fuel scarce enough to matter.
- **After the fight, both currencies:** rest days from fuel (Aftermath.toll exists) and the injury roll from head damage
  (exists). This gives Coast + High in a won round a value you can see afterwards.
- **Judges' work** (R29) for pros: Push counts as work. A good later link.

Noise:
- The short-fuse auto-push. Taking the switch away from the player is frustrating, not deep.
- "Low trust ignores the switch". Same reason; trust already scales the calls.
- The hard-rounds drill. A third place to tune the same number.
- A heart hover on the 35 line.
- Crowd (rightly left out). BJJ HUNT only once the boxing version passes its probe.

## 6. Options on the panel

Missing:
- **Coast** (the third pace step): free fuel in a settled round, head cost in a lost one.
- **Guard** (High / Normal / Open): the second pair (section 3).
- **Push's live worth on the switch** ("+6", "+3", "0", "-3"): it changes in the push decision itself, so put it there, not
  in a hover.
- **The 40 line** ("push 0") on the fuel bar.
- **The round's tally** next to the clock.
- **"Push until 40"**: an auto-off that is on by default. Over 100 fights this saves the micro-management of turning Push off
  as the bar crosses the line. The player can turn it off on purpose to push at a loss (the coach can still be wrong).
- **The opponent's dials** read from film.

Useless:
- **AIM "Head"**: -1.5 edge (`AIM_COST`) for a body share of 0.08 and nothing else. `PaceAim.damage` only boosts `head_hurt`.
  It is strictly worse than Own game. Cut it, or give it a job (for example head damage x1.2 to them, with the new head bar).
- **Numbers printed on the bar ends** (74, 48-54) on the map's drawing, against its own rule "numbers in the hover". Pick one.
- **The legs and guard bars** (the map is right to move them to the hover).

## 7. To reach 10/10 (most important first)

1. **Keep three pace steps, fix the price instead.** Set `SAVE_RECOVER` to 0. Rename the steps Coast / Steady / Push.
   Coast = drain x0.6, edge -4, landed x0.75. Unit test: "Push five, Coast one" costs at least 6 tank a round over Steady.
2. **Add the second pair: GUARD High / Normal / Open spending HEAD**, using the numbers in section 3. Settle head damage per
   exchange (the band's damage / 6) so the bar moves live. Cliff at 60 (KO_DAMAGE).
3. **Link the two:** head damage taken x (1 + 0.5 x (65 - fuel) / 65) under 65 fuel; High guard costs 0.5 fuel an exchange.
4. **Make the minute a pit stop:** a recover point can buy "head: -8 damage" beside water and ice. Plan: one test where the
   right split depends on which bar is closer to its cliff.
5. **Show the round's tally** ("2-1, 4 takes it") beside the clock, so coasting a settled round is a read.
6. **Give the opponent dials:** an AI corner per style that runs Pace and Guard by round and score. They show on film, and
   their changes are named in the clue line ("her corner has her pushing").
7. **Put the value on the switch:** Push shows its live worth; draw 40 as "push 0"; add "Push until 40" on by default.
8. **Make the tired cliff bite:** under 35, Breathe's best edge drops to the "ok" size (5), not 17, and the opponent's game
   keeps acting on the dice.
9. **Rewrite the case table against the code.** Case 4 (Push lowers the hurt chance), case 6 (the order of body greying does
   not matter), case 7 (it is the talk), case 9 (Off in R1-2 throws away 12 exchanges). Add the cases the second pair creates:
   a settled round, a heavy-handed opponent with our head at 45, a soft-hitting opponent with our fuel low, and a 6-round pro
   fight at round 4.
10. **Probe policies:** add "On above 45", "On above 55", "always Push + High", "always Coast + Open" and a state reader that
    uses both dials. PASS: no fixed policy best in more than 4 of 14 cells; the reader beats every fixed one by 3 points or more.
    Run at 3 AND 6 rounds.
11. **Cut AIM Head** (or give it head damage x1.2 to them now that head is a bar). Drop the claim that Push drains their tank;
    show Push's gain on the round dots.
12. **Floor rings under the boxers** (fuel and head arcs, under the feet, drawn before the bodies, hidden in close-ups). The
    controls stay in the fixed corner-coloured panels.
13. **The plan's ROUND row carries both dials per round**, and PlanPhase's "if ahead / if behind" sets them for the last round.
14. **After the fight, both bills:** "Pushed 9 exchanges: +2 rest days; head 52: injury risk up". This gives a won round's
    Coast + High a visible reason.

## 8. My 10/10 drawing
`docs/mockups/s442/pushtank_critic_a/ten.html`, rendered to `ten.png` (1920x1080). It shows our panel (Pace, Guard, Aim;
FUEL with the 55 / 40 / 35 lines, grey wear and a ghost; HEAD with the 60 line and a ghost), the clock with the corner's read
of the rounds and the round's exchange tally, a "next exchange" line with edge, fuel and head, the opponent's panel read from
film with their own dials, floor rings under the boxers, and the calls bar with each call's fuel price.

# BJJ live choices v2 (for critics)

# BJJ live choices, v2 (S428, Claude): three layers and a rival who shows his hand

A design for what the player decides DURING a BJJ bout. Today's live bout has one decision (3 move calls).

## 0. What stays from Kalli's page (real rules, kept)
The 5:00 white-belt match, the point table, 3 s to hold a position, PAID_ONCE, the 20 s stall count from "Lute" with every PIN (mount, back, side control, knee on belly,
north-south) exempt - BjjRef.gd says pins never stall, and v2 keeps the code (an earlier draft wrongly counted on a pin), the penalty ladder (marked, advantage, 2 points, out), advantages for a near miss
inside 0.10 (at most 2 a match, V6 F), the duplicate fix (one option per kind AND landing; plain moves name where they land),
and the camp links. All live numbers Kalli marked INVENTED stay INVENTED and go to the probe.

## 1. The rival has a mode (the missing piece; everything else hangs on it)
The opponent fights one way at a time, like the boxing opponent's mode. Six modes, each 20 to 40 s (INVENTED), shown as ONE clue
line under the mat ("Settling her weight, looking for the neck") plus her gas word and her habit chip. A tell marker shows on the
match timeline 5 s before a mode changes. The mode re-ranks the options, so no option is best everywhere:

| Mode | What she does | Makes better | Makes worse |
|---|---|---|---|
| Smashing the pass | pressure on top, passing | escapes, the stand-up, framing orders | sweeps from far guard, Finish order |
| Hunting the neck | sub attempts on the chokes | the escape or turn-in card, Survive | sweeps (she is high), a stalling hold |
| Wrestling up | shots, takedown chains | sprawl / stand answers, Points | guard pulls |
| Sitting on the lead | stalls ahead (the count runs on HER) | Finish, a sweep, a take-down | Hold and breathe |
| Gassed, fading | slower beats, longer settles | Push / Finish, the sub card | Survive |
| Fresh and loose | even | every plain move | nothing |

Source: BjjMatch has her game plan and the habit table (V6); the mode is read from the same state (position, initiative, gas, score,
her last two attempts), so it costs no new data: a function `RivalMode.of(state)`. The Boxing Manager lesson (Q-174, S427): information
first, the player reads and chooses.

## 2. Layer A - ORDERS (replaces D2 pace, D8 the 2:30 word, D9 the last minute)
One persistent dial: SURVIVE / POINTS / FINISH. It stays set until changed; changing it costs 1 EAR (section 3), and a changed order is
locked for 20 s so it cannot be flicked (visible). The "two a minute" cap and the half-strength third shout are gone.

| Order | Gives | Costs |
|---|---|---|
| Survive | lowest-LOSS moves only, +gas, no stall count in exempt spots | the rival gets more beats; Points score slows |
| Points | stay heavy: scoring moves weighted, take the 1st penalty free when ahead (it is correct play) | stalling count outside pins; a trailing Ana loses ground |
| Finish | sub and the near-miss advantage weighted, odds +0.04 | gas x1.4 and a miss gives up grips and the initiative; a real gas cliff: under 0.35 = tunnel vision, the card shows fewer, riskier arrows |

The clock gives each order its moment, not a new ask: at 2:30 and 1:00 the order bar shows the real arithmetic in plain words
("60 s is three 20 s counts: riding side control for 2 points can run mark, advantage, 2 points"). The player may change, nothing asks.

## 3. Layer B - the MOVE CARD (merges D1, D4, D6)
A heavy settle (or a stand-up chance from underneath, or a sub chance) opens ONE card: 2 or 3 arrows of DIFFERENT kinds (sweep,
sub, stand, take-down), each with odds, gas, what a miss costs, and how often she answers it in this mode. It never says which is
right. A 6 to 8 s timer; if it runs out the plan move runs. SKIP IS FREE and shown.
- ONE CURRENCY, THE CORNER'S EAR (replaces tokens, the shout cap and gas-as-ask-cost): a meter of 6 (INVENTED). A move pick
  costs 2, an order change or a shout costs 1; it refills 1 every 12 s of quiet (INVENTED) and 1 back when a READ lands (an order or
  answer that matched her mode). At 0 her STANDING ORDERS run (set in the Playbook before the bell, shown on the plate) and the card
  runs the plan move. Skip is free and shown. So holding ear for the last minute is a real, learnable play.
- Gas hurts the card, not the shouts: under 0.5 the card shows fewer and riskier arrows; under 0.35, tunnel vision (one arrow).
- NEW opening card at the bell: pull guard or wrestle for the take-down, priced by her mode ("Fresh and loose") and Ana's drilled stand-up.
- Options nobody takes are cut or bought: "Slow it down", "Let it come, win elsewhere", "Tie up and breathe" and "Set it up" go; "Hold
  and breathe" stays only where it has a stated price (the count outside pins).

## 4. Layer C - CRISIS cards (only when the thing really happens; no scheduler filler)
- THE COUNT (D3): when the 20 s count starts on Ana: Show work / Climb a rung / Take the penalty, no hints. Rare, 0 to 2 a match.
- HER BEST MOVE (D5): after she shows the same kind or named sub twice, one card: Name the answer (owned: her odds x0.8; felt only:
  x0.95), Beat it to the punch, or Let it come. It spends a token, so it competes with the move card.
- CAUGHT DEEP (D7): a corner cannot make an athlete tap (IBJJF: she taps, nobody stops it for her). So it is a SHOUT, "Tap!", that Ana
  obeys by trust, heart and composure, over a STANDING ORDER set in the Playbook ("choke: fight it, joint lock: tap"), 1 ear to override.
  A fought joint lock rolls an injury (weeks out). Real stakes only on an open day (an 8-person bracket = at most 3 matches, not 3 to 5):
  a tap saves her for the next round. In a single match she fights it, unasked. PREREQUISITE, built first: gas and injury carried across
  the open day, and the corner minute between matches (warm-up, ice, food, the next opponent's last match, one change to the plan).
THE SHOUT BAR IS PLAYER-STARTED AND ALWAYS LIVE (a real coach is proactive): positional cue words ("Frame", "Hips out", "Underhook",
"Hand fight", "Stay heavy"), each right in two or three positions and wrong in others, 1 ear each, stamped READ RIGHT / WRONG.
No scheduler: a quiet stretch is quiet and the screen says why and when the next moment is due (the tell marker; and a minimum of one
real moment per 40 s comes from the rival's own mode changes, which is not filler: it is the opponent acting).

## 5. Results stamped live, and the size of the effect
Every pick stamps LANDS / MISSED, and every order or answer stamps READ RIGHT / READ WRONG with a live trust meter (right +1, wrong -2,
as boxing). The combined effect of good live orders against none is tuned to 8 to 15 wins in 100 (the plan is worth 14 in boxing; today's
calls 3 to 10 spread over 9 to 11 asks, half a point each).

## 6. Where it appears (menus) and what each is wired to
| Screen | Shows | Wired to |
|---|---|---|
| Live bout: mat + clue line | rival mode, her gas, her habit chip, the tell marker | RivalMode.of(state), BjjMatch gas, habit table |
| Live bout: the move card | arrows of different kinds, odds, gas, miss cost, her answer rate, 6-8 s timer, skip | BjjMatch offers (de-duplicated), PAID_ONCE, KIND_BASE |
| Live bout: the orders bar | SURVIVE / POINTS / FINISH, cooldowns, the clock arithmetic | order lever in BjjMatch (new), BjjRef stall tally |
| Live bout: crisis cards | the count, her best move, caught deep | BjjRef count, match log, injury and gas carry-over |
| Score plate | points, advantages (NEW live), penalties, count ring drawn as the referee's raised hand, the EAR meter, standing orders, trust | BjjMatch.decide with advantages, tokens |
| Timeline strip | used cards, tell markers, red flags | the match log |
| Mat tree / Playbook | owned answers and the game-plan path | move mastery 30, the Playbook (Q-S419) |
| Open night / fight prep card | her file (scouted), Ana's carried-over gas | opponent file, gas carry-over |
| After-bout Why | each pick and order against her mode: right, ok, wrong | the match log, the grading rule |

## 7. The probe first (300 headless matches), then the order
Bars: no option is the best pick under 15% or over 60% of the times it is shown; no pick is dominated in every mode; a bot that
ignores every ask loses to a best-play bot by 8 or more wins in 100; the longest gap without a real moment is 40 s or less; an order
or card costs something visible each time.
Order: 0 settle the rules (below); 1 duplicate fix and advantages live; 2 RivalMode and the clue line; 3 the move card (merge, skip, coins); 4 the orders bar with
cooldowns; 5 the count crisis; 6 her-best-move; 7 open-day gas and injury carry-over, then caught deep; 8 the opening card; 9 camp links.
Art and effects Kalli did not list (the chip, the count ring, the Lute gesture, dots on the plate, a flash on a landed call, tweened
gas) are drawn once the design is agreed.

## 7b. Rules to settle before building (replaces
- Pins never stall (BjjRef.gd): v2 keeps it; the count only runs on a guard or neutral hold with no attempt. Kalli's text said the opposite.
- tick() calls level points a draw; a bracket needs a winner: advantages, then fewer penalties, then the referee (IBJJF 2.5 to 2.6).
  Advantages are not live in BjjMatch (decide passes [0, 0]): built first, as D3, the Finish order and the last-minute maths all pay in them.
- John to check: kneebar legality at white belt (a reviewer thinks straight ankle lock is the only leg lock; SUB_TAGS lists the kneebar);
  "Lutem" not "Lute"; whether PAID_ONCE is our rule (a design choice, stated as such).
- Probe gas first (S390 eased MISS_GAS 0.06 to 0.025): if gas rarely binds, Push and the Finish cliff are free. A bar: gas
  under 0.5 for one side by 3:30 in a fair match.

## 8. Kill list
- "It is still a lookup": the mode re-ranks every card; the probe bar says so and fails the build if not.
- "Orders are set once": changing is the choice, cooldowns and the clock arithmetic make staying put cost something at 2:30 and 1:00.
- "Ear does not matter": a pick costs 2 of 6 and refills slowly, so ear spent on 0:30 is not there at 1:00; a landed read pays one back.

INVENTED (to the probe): six modes of 20 to 40 s, a tell 5 s ahead, 6 to 8 s card timer, ear 6 / pick 2 / word 1 / refill 1 per 12 s quiet and 1 on a landed read, order lock 20 s, the
Finish gas cliff at 0.35, the 8 to 15 target.

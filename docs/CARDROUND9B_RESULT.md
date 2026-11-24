# CARDROUND9B - slice 1 of round 9b, built by Claude on main (S548)

Owner S548: "do 9b yourself too, dont wait for arena". Task `ops/research/TASK_CARDROUND9B.md` (+ its S548 addendum).
The paper came first: `ops/research/CARDREAL_AUDIT.md` section 9 (every changed row A-I, and the bout of section 7
re-walked), committed before any engine code (874e8fc81). Then red tests (one per row), then the build.

## NOT GREEN - read this first
1. **Round 9b is NOT finished. This is slice 1 of 3.** Built: H1, H1b, H2 (was already so), H3, I1, A1, A2, B1, B2, B3.
   NOT built: C (posture), D (a punch from the guard gives up an arm), E (standing in the guard: full punches, Hold the
   legs), F (the jiu-jitsu fighter punches from on top), G (the body-lock trip), I3-I5 (a pull never counts as timid;
   the idle clinch is broken; the pair-4 stand-up), the Sprawl and Up-kick CARDS' stronger versions (B1c), the walked
   bout of section 9c as a scripted test, the state words for posture, the three measures Kalli asked for.
2. **Two of the critics' changes are built and switched OFF, because measured they end the jiu-jitsu game:**
   - B1 Keep your base (2 wind, always available, stops a pull or a sweep): boxing wins **99.5%** of 400 bot bouts.
     At 3 wind 99.0%, at 4 wind 88.3%. With it off: 43.0%. No price fixes it - the boxer gets 3 wind back a turn and
     simply refuses every pull; the jiu-jitsu man never reaches the floor on his terms (holds laid: 0.00 a bout).
     The SHAPE is wrong, not the number. `N.baseOn = 0` in cards.mjs.
   - B2 the no-card escape from a hold as it is laid (2 wind): holds laid fall from 0.28 a bout to 0.00 and taps from
     25 to 0 in 400 - the bot stops laying holds it can see will be escaped. `N.escOn = 0`.
   Both keep their tests (the test switches the rule on). This is the owner's and the critics' call: Kalli's largest
   finding ("turning points decided by a missing card") is right on paper, and her fix breaks the pairing when played.
3. **The bot never lays the no-card Up-kick in its OWN turn** (0 of 400 bouts), only as an answer (651 times). By this
   task's own rule ("a move laid in under 2% of the bouts where it was legal is NOT DONE") the act half is not done.
4. Not played by hand on the page this time: the page's own calls are covered by ui.test.mjs (18 tests) and the gate's
   rows 1-2. The owner's play is still the gate.
5. Balance moved without any number being tuned: boxing 57.3% (round 9) -> 43.0%. Inside the gate's 40-60. The cause is
   the tie that must stand a turn (H1b) and the referee's "get up" (I1), which both favour the jiu-jitsu man.

## What is ON now, row by row (each test was committed red first: `git log -- proto/cardgame/r9b.test.mjs`)
| Row | What a player meets | Test name (r9b.test.mjs) |
|---|---|---|
| H1 Frame | answer a Tie up with no card for 1 wind: the tie fails, both stay where they are | 9b H1 |
| H1b | no tie-and-pull in one volley: the tie must stand through one of the other man's turns | 9b H1b |
| H3 | Recover guard: from mount to the half guard, from side control to the closed guard | 9b H3 |
| I1 | on the floor in front of a standing man: told "get up" after one empty turn, stood up after the second | 9b I1 |
| A1 the knockdown | a standing punch that lands for 6+ and leaves him at 10 health or under seats him; the puncher stands over him in leg range | 9b A1 |
| A2 the stoppage | punches landing on a man who is down for 2 turns with nothing laid back: the referee stops it ("tko", its own verdict line). An answer that fights back (the up-kick) clears the count; covering does not | 9b A2 |
| B3 Up-kick, no card | 2 wind, 2 damage, off your back at a standing man in leg range - laid in your turn, or as the answer when he follows you down, walks away or punches down | 9b B3 |
| B1, B2 | built, OFF (above) | 9b B1, 9b B2 |

Old tests changed BY MEANING (none deleted; 63 before, 72 now):
| Test | Old assertion | New assertion |
|---|---|---|
| real.test "the walked bout of audit section 7", turn 6 | one empty turn stands him up | one empty turn: told to get up, still seated; the second: stood up (I1) |
| same, turns 8-9 | tie up and pull in one volley | the pull behind a fresh tie throws "not legal"; a turn later it goes (H1b) |
| same, turn 15 | both at punching range after jab-cross-hook | if the combination leaves him at 10 or under it is a knockdown: he is seated (A1) |
| real.test "the timidity rule" | each sit is stood up at once | each stand-up is the second empty turn running; the count's order unchanged |
| real.test "every legal pair", pair 5 | a hand-made tie | the hand-made tie is marked as having stood |
| engine.test / real.test / ui.test winner lists | ko, lead, tap, pin, cards | + tko |

## The numbers (400 bot bouts, seats alternated, seed 500000000 + 7919 x i; nothing tuned)
| Arm | Boxing wins | How the bouts end |
|---|---|---|
| Round 9 as merged this morning | 57.3% (the gate) | - |
| Slice 1 as shipped (B1, B2 off) | **44.5%** (gate run: 43.0 / 57.0) | boxing: ko 83, cards 82, lead 13; jiu-jitsu: lead 179, tap 25, cards 18 |
| + Keep your base on (2 wind) | 99.5% | boxing cards 290, lead 60, ko 48 |
| Keep your base at 3 / 4 wind | 99.0% / 88.3% | - |
| + the no-card escape on (base off) | 43.0% | taps 0; jiu-jitsu wins 209 on the points lead |
| every 9b number off (H1b, H3, I1 stay) | 44.8% | taps 48, holds laid 0.77 a bout |
Knockdowns: 0.15 a bout. Stoppages: 0 in 400 once a kicked answer clears the count (102 before that fix: the seated
bot answered every punch with an up-kick and was still "stopped"). The boxer's Frame: 291 times. The no-card
Up-kick as an answer: 651 times. Pulls laid 737, ties 681.
PLAY GATE 6 of 6: 26.7 decisions a bout (22.5-45; 24.1 before), boxing 43.0 / jiu-jitsu 57.0, 1,000 bouts clean,
61 printed lines equal the engine. `node --test`: 72 of 72. engine.mjs 495 lines (limit 500): the new rules live in
the new `floor.mjs` (prices, the no-card answers, the knockdown test).

## Feedback loops (the brief's stops)
- Knockdown -> punches down -> stoppage: 0.15 knockdowns a bout, 0 stoppages; the boxer does not win over 70% by this
  route (STOP did not fire).
- Floor defences -> wind: with B1 on the loop DID run away (the boxer always pays, the pull always fails) - reported
  above and switched off, not tuned.
- Frame <-> Tie up: 291 frames against 681 ties in 400 bouts; no bout printed over 6 ties was looked for (not measured).
- Hold the legs <-> Stand up: not built.

## One thing worth the owner's eye
Jiu-jitsu now wins 179 of its 222 bouts on the POINTS LEAD and only 25 by tap. A jiu-jitsu man who wins on points
without finishing is not the fight the card game promises. The lead rule (a lead of N.lead ends the bout) was the
owner's open call in the audit (2d); it is the one number I would look at next - not moved here.

## Decided (no questions asked)
- B2 as "a hold as it is LAID" only: once a hold runs, Break free at its printed price stays the way out. A 2-wind
  escape from a running hold would make every submission free to leave.
- A tie "has stood" when the other man's turn ends with the tie still on (a flag on the tie), so the pull can also be
  the answer to his step out, as round 9 has it.
- The no-card answers are never laid in your own turn; only the Up-kick is.
- Slice order changed from the addendum (H, I1, A, B first) because Kalli's two largest findings are there.

## How to run it again
`cd proto/cardgame && node --test` ; `node probe.mjs gate=play` ; the 400-bout table: `node stats9b.mjs`, and with any
number changed for one run `node stats9b.mjs baseOn=1 baseW=4` (the rows of the table above).

## S548, later: the owner's call on Keep your base - "Weaker version, measured"
The weaker shape: Keep your base is there only for a man who threw NO punch in his last turn (he chooses between a
combination and his balance). Measured over the same 400 bouts, and the measurement split the answer in two:
| Arm | Boxing wins | Bases paid |
|---|---|---|
| off (as slice 1 shipped) | 44.5% | 0 |
| weaker, against a pull AND a sweep | 69.3% (outside the 40-60 gate) | 374 - every one against a SWEEP, none against a pull |
| weaker, against a pull only | 44.5% | 0 |
| always there, against a pull only | 44.5% | 0 |
So what broke the pairing (99.5% in the critics' shape) was never the pull: it was the SWEEP half. The sweep is the
jiu-jitsu man's one way up from his back, and a 2-wind answer to it that needs no card takes it away.
NOW IN THE GAME: the pull half is ON in the weaker shape (`N.baseOn 1`); the sweep half is OFF (`N.baseSweep 0`); the
no-card hold escape stays OFF (`N.escOn 0`). Test "9b B1w" (red first, 137bbe85e). 73 of 73; PLAY GATE 6 of 6
(26.8 decisions, boxing 43.0 / jiu-jitsu 57.0).
NOT DONE, said plainly: the bot never pays for Keep your base against a pull (0 of 400) - it has spent its wind on
punches, and a tie that stood makes the answer 3 wind. A player can use it; the bot cannot show whether it matters.
A second shape I tried and dropped (the base only stops the pull and he keeps his tie) could not be measured for the
same reason. The sweep keeps its card answer (Sprawl).

---

# SLICE 2 (S549, Claude on main): posture, the arm given by a punch, standing in the guard

Red tests first (cf7c65790, `proto/cardgame/r9b2.test.mjs`, 11 tests), then the build. `node --test`: 85 of 85.
PLAY GATE 6 of 6 (26.7 decisions, boxing 43.0 / jiu-jitsu 57.0). engine.mjs 484 lines (the deal moved to `deal.mjs`).

## NOT GREEN - read this first
1. **The bots almost never reach these rules, so their balance is NOT MEASURED.** In 400 bot bouts: 10 pulls into the
   closed guard, 6 turns bent over, 5 stand-ups in the guard, 1 Hold the legs, 1 arm taken off a punch, 0 Posture up.
   By the task's own rule (a move laid in under 2% of the bouts where it was legal) the rows are built and NOT DONE.
2. **Why: slice 1's Frame at 1 wind ends the pull.** 682 ties laid, 290 framed, and the tie must now stand a turn
   (H1b) - so 10 pulls reach the guard in 400 bouts. The jiu-jitsu bot's bout is: sit down (about 730 times), wait,
   up-kick (652). With Frame at 2 wind: 86 pulls, 76 stand-ups, taps 66 - and boxing falls to 36.8% (gate 40-60).
   With no Frame: 212 pulls, taps 112, boxing 28.0%. Not changed here: Frame stays 1 wind. The pairing as the bots
   play it is held inside the gate by a rule that keeps the fight off the floor - the owner's and the critics' call.
3. A boxer pulled into the closed guard is close to lost for the bot: every way out (Posture up, Stand up, a punch)
   gives an arm, and the jiu-jitsu bot takes it nearly every time (76 stand-ups left 3 turns standing in the guard).
4. Slice 3 (F jiu-jitsu punches from on top, G the body-lock trip, I3-I5) is NOT built. The Sprawl and Up-kick cards'
   stronger versions, the walked bout 9c as a test and posture in the place words on the page: NOT built.

## What is ON (each test red first)
| Row | What a player meets | Test (r9b2.test.mjs) |
|---|---|---|
| C1 | a pull leaves the man on top bent over (posture broken); following him down or a takedown leaves it up | 9b C1 |
| C2 | Posture up: 1 wind, no card, and a punch may go behind it; the Triangle or the Armbar may answer it | 9b C2 (two tests) |
| C3 | bent over in the guard he cannot punch | 9b C3 |
| C5 | breaking a hold leaves the same kind of guard (the half guard stays the half guard) | 9b C5 |
| D1 | a punch from inside the guard gives up an arm: the Armbar or the Triangle answers the punch itself | 9b D1 |
| E1 | a punch down from standing in the guard is the whole punch; the Sweep or the Armbar answers it | 9b E1 (two tests) |
| E2 | standing up in a closed guard opens it | 9b E2 |
| B4, E3 | Hold the legs: 2 wind, no card, answers Stand up or Back away; the guard stays locked, no backing away next turn; at most 2 turns running | 9b B4 (two tests) |

Old test changed BY MEANING: real.test "the walked bout", turn 9 - the pulled boxer postures up before his ground punch.
My own two B4 tests: the stuck man punches down (a turn with nothing laid by either man brings the referee).

## The bot (plan.mjs `placeFit`)
A place is now worth what he can do there NOW: bent over in the guard 0.25 of the place, a boxer's punches inside
the guard 0.6, under an open guard 0.35, the half guard 0.7. Before it the boxer's bot never stood up in the guard
(0 in 400). Balance with it: boxing 44.3% (was 44.5%).

## Two fixes from the owner's play (S549)
- "i have 2 wind, why can i play a card that costs 3 ?" - the card printed its own price while the button used the
  price paid now (a punch behind a punch is 1 less). A card in hand now reads "2 wind now (3 on the card)". Seen on the page.
- The page stayed on LOADING after an edit: the browser kept an old file beside a new one. `proto/cardgame/serve.py`
  serves with no-store; `.claude/launch.json` uses it.

---

# SLICE 3 (S549, Claude on main): F1, I3, I4, I5 - G is NOT built

Red tests first (`proto/cardgame/r9b3.test.mjs`, 5 tests). `node --test` 90 of 90; PLAY GATE 6 of 6.

| Row | What a player meets | State |
|---|---|---|
| F1 the jiu-jitsu fighter punches from on top (1 wind, 2 damage, no card; Cover or the Escape card answers) | - | BUILT, **OFF** (`N.topOn = 0`): measured below |
| I3 a failed pull leaves him seated; stood up by the referee, he is not charged with timidity. A sit with no tie still is | ON | 9b I3 |
| I4 a clinch held through both turns with nothing laid by either man is broken, apart at punching range | ON | 9b I4 |
| I5 nobody working with a man standing in the guard: the legs are opened, he stands over a man on his back | ON | 9b I5 |

F1 measured (400 bot bouts): on, the jiu-jitsu bot lays it 496 times and boxing wins **36.0%** (42 stoppages; the gate
is 40-60). Kept out of the referee's stoppage count: 39.0%. At 2 wind, or at 1 damage, the bot never lays it (0 of
400) - there is no price between "never" and "too strong", the same shape as Keep your base. Left off; the critics'
row K6 is right on paper and breaks the pairing when played.

NOT built: G1-G3 (the collar tie or the body lock as a choice, the trip off the body lock), the Sprawl and Up-kick
cards' stronger versions, the walked bout 9c as a test, posture in the page's place words, Kalli's three measures.

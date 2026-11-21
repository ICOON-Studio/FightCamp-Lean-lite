# GUARDDMG1 V6 — the guard-damage map, judged (Arena)

Judge: Arena. Date: 2026-11-21. Tree: `99e3070` (lite: f511ea16), clean.
Map judged: `ops/research/DESIGN_GUARDDMG1_V6_CRITIC_KALLI.md`. Brief: `ops/research/TASK_GUARD6CRIT.md`.
No Godot was run. Everything below is read off `scripts/rules`, `scripts/state`, `scripts/ui`, `scripts/fight3d`.
Line numbers are this tree's. The map numbers its claims against a working tree that has two extra lines at
`LiveRound.gd` 245-246 (another session's `StepWire.ride`), and it says so. From line 245 on, map line = this
tree's line + 2. I checked every line both ways. Its commit `48f290a26` is not in this mirror (`git show`:
unknown revision), so I judged the map against `99e3070` and used the +2 offset it declares.

Short verdict: **the method is right and the mechanic is not yet a decision.** The seam the map found is real — the
guard is counted after the exchange, and a Hands setting can be put in front of the count with one added line. But
the map's own feedback loop is broken by the way the game counts blocks: a boxer who covers makes *fewer* blocks,
not more, so the guard she is supposedly spending wears *slower*. High becomes the setting that is safe and cheap,
which is the one thing the map promises it is not. Add a worn penalty so small it cannot be felt (-2 / -4 against a
dice spread of 66) and the "worn guard costs rounds" leg of the design is decoration.

---

## The live defect, read this first

The game's own test of a tie-up is three-way. `ClinchRest.tied` (`ClinchRest.gd` 27-28) counts a tie-up when the
corner calls "tie", **or** the plan's arrow is a tie-up (`tie_up@...`), **or** the exchange is fought at
`at == "clinch"`. The guard's tie-up rule is one-way: `GuardState.after` (`GuardState.gd` 127) opens with
`if call == "tie"`, so the +10 guard back (`GuardWear.clinch` 228-236, under half guard, once a round) is granted
only when the corner shouted it.

What the player sees: she plans a tie-up arrow, or the fight is on the ropes in a clinch exchange, and the ring
writes the tie-up line and gives her the breather (`ClinchRest.refill`, 32-33) — but her guard does not come back,
which is the one thing the tie-up exists to do for the guard. Two modules disagree about what a tie-up is, and
the guard module is the one with the narrower reading.

Second half of the same wire: `GuardState.after` 128 calls `GuardWear.clinch(false, ...)`, so the `skilled` value
(+13 instead of +10) can never fire, even for a boxer whose tie-up is Sharp (60) or Signature (85) in
`MoveMastery` (18, 28). A trained move buys nothing at the moment it is used.

Third, in the same family but not a defect against a stated rule: `GuardWear.corner` (241-257) can pay
`CORNER_BACK_OFF` (+20) and `CORNER_CUTMAN` (+5) and no caller ever passes either flag — `GuardState.open` 45-46
calls it with `(["hands_up"], false, false)`. Those two numbers are stated in the header and unreachable in play.

None of these is the map's fault. They matter because the map's 3.4 and 3.5 build on top of the tie-up ("a
tie-up halves that exchange's leak") and on the corner (+5 for Hands up), and a rule that fires on one of three
tie-up routes will make the new mechanic look broken the first time a player plans a tie-up instead of shouting
it.

---

## Where the exchange is settled today, and whether Hands can come before it

**Settled in one place.** `LiveRound.exchange` builds one number `d` and calls `Exchanges.settle(d, roll_a, roll_b)`
at `LiveRound.gd` 285. `Exchanges.settle` (`Exchanges.gd` 356-361) is four lines: margin = `d + (roll_a - 0.5) *
EX_SPREAD - (roll_b - 0.5) * EX_SPREAD` with `EX_SPREAD = 66` (line 14); `won` is `margin >= 0`; the margin's band
picks the landed figures (`LANDED` 345: 4-3, 5-2, 6-1; `band` 349-351). Nothing else decides the exchange.

**Nothing from the guard is in that sum — TRUE.** I grepped the whole body of `exchange` (156-285): no reference
to `GuardState` or `GuardWear` at all. The guard enters at `GuardState.after` (`LiveRound.gd` 352), after the
count, and its `through` is added to `m["damage"]` at 353-357. The map's central finding is correct, and it is
correct for the reason it gives: the round is exchanges won (`Exchanges.round_of` 366-379), the cards are rounds
won (`BoutRules.cards_of` 402-412), and the three judges that count punches do not decide
(`JudgeNight.DECIDES = false`, line 16).

**Can a setting feed `d` before the count, as the map says? — YES, and almost exactly where it says.** The sum is
finished at `LiveRound.gd` 281 and settled at 285, so any line added at 222 (beside `PaceAim.edge`) is in the sum
with 60 lines to spare. The three things the map says a setting needs all exist and work:

- **The shout string carries settings.** `LiveRound.gd` 165-171 splits the shout on `|`, reads `pace=<p>` and
  `aim=<a>`, and refuses anything not in `PaceAim.PACES` / `PaceAim.AIMS`. A `hands=` branch is the same shape —
  but note it gates on the list membership, so a new `HANDS` list must be written, not assumed.
- **The setting persists.** `m["live"]` is rebuilt at 110 with `pace` and `aim` from the previous round; a third
  key rides along the same way.
- **A pure module beside `PaceAim`.** `PaceAim.edge` is a 15-line pure function with no preloads (26-41). A
  `HandsEdge.points` of the same shape drops in at 222 with no new wiring.

So: **the seam is TRUE and buildable in one line.** What is not true is the rest of the loop around it.

**What cannot be built as written.** Five things, and one of them is load-bearing:

1. `StepWire.levers` is cited at "158-190". `StepWire.gd` is 123 lines; `levers` is at 95-123, and its body is
   95-123. There is no line 158. The behaviour the map describes is real (deny cuts the opponent's landed at 107-112,
   a wrong step adds at 101-106, drain to `lv["opp_drain"]` at 113-115) but the citation is not, and the map's own
   file list repeats it ("StepWire.gd (150-190)").
2. `PaceAim.AIMS` "a sixth entry" for the pro "Through the guard" aim: `AIMS` (line 7) already has six entries
   including the empty one. A new aim is the seventh, and it would also be offered by the shout parser (167-171)
   the moment it joins that list — the map does not say how a pro-only aim is kept out of an amateur bout.
3. The block arithmetic reverses the wear loop (see below). As written, covering does not cost guard.
4. "`m["damage"]` is read only by the knockdown rule" is false: `Towel.gd` 27 reads it for a retirement on the
   stool, and `BoutNight.gd` passes it to `LiverFold.roll` (266) and `Knockdowns.puncher_chance` (270). The guard's
   leak can retire a boxer, which the map's "changes figures only" framing does not own.
5. The map's working tree does not exist here. Two claims besides the declared +2 offset are simply off:
   `LiveRound.close` "408" is 403, and `BoutNight._counts` "254" is 245.

---

## The arithmetic that undoes the design

The map's cost of covering is: High turns one punch in three into a block, blocks wear the guard, so a boxer who
covers wears out faster and cannot hold it all night (2.5, and probe bar 2 depends on it). In this code the
block count is not a count of punches at the guard:

`GuardState.blocked_of(landed)` (53-55) works out *thrown* from the punches that **landed**:
`thrown = ceil(landed / 0.33)`, then `blocks = round((thrown - landed) * BLOCK_SHARE)`.

| The opponent's landed | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| blocked, `BLOCK_SHARE` 0.60 | 2 | 3 | 4 | 5 | **7** | 8 |
| blocked, `BLOCK_SHARE` 0.75 (2.5's change) | 2 | 3 | 5 | **7** | 8 | 10 |

So High cutting the opponent's landed from 5 to 4 takes the blocks *down* from 7 to 5 — less wear, not a quarter
more. The map's "a quarter more blocks at 8% more wear each" only appears because 2.5 also raises `BLOCK_SHARE` to
0.75 in the same breath: 7 against 7, a wash. The two claims are counted as two gains and are one fudge, and the
fudge is an ESTIMATE.

The same arithmetic cuts the leak: fewer landed means fewer blocks means less damage through the guard. So High
quiets the knockdown roll and slows its own guard wear at once. Cover's only real price is the -7 on the exchange
at range (and -8 against a tiring opponent) — a flat edge, the same shape as a corner call. That is why probe
bar 2 ("no fixed setting is best everywhere") is likely to fail for HIGH in the three-round amateur cell: the two
rows that are supposed to punish covering cannot, because the game never counts the punches she takes on the gloves.

**And the worn penalty is too small to be the second leg.** With `EX_SPREAD = 66`, a `d` of ±3 is worth about 4
exchanges in 100, ±8 about 11, ±17 about 22 (I recomputed the map's derivation from `settle`; it is right). So:

| `HandsEdge.worn` | wins in 100 | per 6-exchange round |
|---|---|---|
| -2 (under half guard) | -3 | -0.18 exchanges |
| -4 (under a quarter) | -6 | -0.36 exchanges |

Under half an exchange a round is not a mechanic; it is a rounding error, and 200 bouts a cell cannot resolve it
(the noise on a win rate at that sample is about ±3.5 in 100). Either the worn term is -8 / -14, or it should be
dropped and its job given to the block share.

---

## Scores

**DEPTH — 6/10.** The method fix is the right one and it is the first time in this chain of maps that the guard
can change who wins a round. The situation table (2.2) has eight rows with signs that pull against each other, the
setting lives longer than a shout, and there is one genuine long-game switch: cover while a heavy-handed presser
is fresh, open up when the mouth opens. That is a real decision, and the map knows which rows force the switch.
It loses points for three reasons. The setting is a lookup table with the same shape as the corner call that
already exists — nine signed numbers keyed on the situation, which is a read, and the game already sells reads.
The cost that is supposed to stop a boxer holding High all night does not exist in the code's block model
(above), so one of the three states is likely dominant and the table collapses to "High unless the opponent is
tiring or at range". And every size in it is an ESTIMATE that has not been through the probe the map itself
demands; a depth claim that rests on unmeasured numbers six points wide against a 66-point dice spread is a
hope, not depth. With the block count fixed (or the block share made honest) and the probe passing bars 2, 3 and
6, this is a 8.

**GENERAL DESIGN — 7/10.** This is the best-built map in the family: it separates posture from hands and says so,
it splits amateur from pro where the game already splits, it keeps names out of the body, it puts one gauge where
there were three, it refuses to add a second energy model and reuses `opp_drain`, and every row it touches has a
wiring line and a status. The probe is specified with a mutant arm and bars that can fail — that is a designer
who expects to be wrong. Deductions: "High" already means head-against-body on the corner card and now means
hands-up, and the map notices the collision but only renames the tile; the setting and the plan's round row are
two owners of one dial with no stated precedence; the referee's look is a third bar beside guard and energy, and
two of its five feeds (-1 an exchange won, -2 a corner) churn against the two that matter, so it is a slow random
walk whose only real driver is the counts the game already punishes; and the pro-only "Through the guard" aim asks
for a cost (-1.5, one clean punch an exchange) to buy a benefit that only exists through a -2/-4 term that is
noise. Each is fixable in a line; together they are why it is not an 8.

**PLAY — 5/10.** Nothing here is built, so play is judged on what it would ask the player to do. It asks for a
third dial on the corner bar, with two of the three positions meaning "the thing you already do" and one meaning
"the thing the shout button already says", and it asks for it in the same eight situations the corner call is
already offered in. The moment-to-moment win — the mid-bout switch — is real, but the player meets it as a
bookkeeping change, not an event: the opponent's energy bar moves, the clue line reads, and the correct answer is
a button that has been sitting there. Nothing on the screen shows the exchange being decided by the guard at the
moment it happens; the count rule ("Lost 4-3 — 2 on the guard") is the best idea in the map for play and it is
buried in 2.5 as a formatting note. And the guard bar already tells the player her hands are coming down — the
new dial does not change what she can see, only what she must remember. Build the count rule on the line, the
caption that names the button, and the switch with a visible cost, and this is a 7.

---

## Options that are missing, and what each one would change

1. **No Hands for the opponent.** The opponent has no setting (true today), so the worn penalty and the puncher's
   drain only ever pay the player. A stand-in by style — the out-boxer covers, the slugger opens, the pressure
   fighter shells when hurt — would make 2.3 a two-way term instead of a one-way discount, and it is the only way
   "wearing a guard down wins rounds" becomes a contest rather than a bonus.
2. **No way to cover inside the exchange you are watching.** The setting counts from the next exchange, and the
   shout slots are the corner's best/ok/wrong for the situation, so the player who reads the clue mid-round can
   only change the dial and lose the 30 seconds she just understood. A "cover now" that costs this exchange's
   output would make reading pay in the exchange it is read in.
3. **No precedence between the plan's round row and the corner bar.** 3 point 6 gives the plan page a Hands per
   round; 2.1 gives the bar a standing setting. Whichever is written last wins, and the player cannot tell which.
   One line of rule ("the plan sets it at the bell, the bar overrides for the round, the shout overrides for one
   exchange") and one line on the hover fixes it.
4. **Nothing before the bell says which Hands their game punishes.** The opponent file names three guard habits
   (`OppFile.GUARD_NOTE` 66-67) but not one of them says "covers badly against", and fight prep's guard row is
   listed as to build without its text. The player arrives at the corner bar with a dial and no information; the
   file is already the place the game teaches.
5. **No cost to the arms.** In boxing, holding a high guard costs the shoulders — the game already computes
   shoulder endurance (`GuardWear.shoulder`, 181-186; `AttrBoard.shoulder_line` 283) and uses it only to slow
   wear. Spending a little energy while Hands is High would give the setting a price the player can feel on the
   tank, which is the one bar she watches all fight.
6. **No way down on the referee's look.** The look climbs on counts and heavy hands and only falls by -1/-2. A
   boxer who survives the round and comes out clean should get it back, or the gauge is a ratchet and the player
   learns to ignore it.

## Options that change nothing, and why

1. **`HandsEdge.worn` at -2 / -4.** Three and six exchanges in 100; under half an exchange a round (table above).
   It cannot change a round, it cannot be measured, and it is the map's whole second leg. Raise to -8 / -14 or
   fold it into the block share.
2. **The +8% high-posture wear** passed to `GuardWear.wear` (148-150). At the 0.40 pro scale that is 0.032 guard a
   block; a 60-block fight is two points of guard. It is a line of code pretending to be a rule.
3. **Loose's +2.0 head damage** on the extra clean punch. It reuses the ONE CHANGE's `HEAD_DAMAGE` (24), which is
   already the size of one moved punch; on the exchange's own damage scale it is invisible, and it makes Loose
   read as a second posture change in a map that spends a section proving it is not a posture.
4. **The pro "Through the guard" aim.** -1.5 edge and one fewer clean punch an exchange, to buy 1.5x wear on a
   guard whose worn state is worth -2/-4. Net negative as written; it only becomes a choice after 2.3 is sized
   properly.
5. **The referee's look as a five-feed gauge.** -1 for an exchange won and -2 at the corner nearly cancel the +1s;
   what actually fills it is the count, and three counts in a round already stop the fight (`Knockdowns` 7-8,
   `REF_STOP` 15). Either the look drives something the counts do not, or it is a second way to say the same
   thing.
6. **Cutting `GuardWear.blocked_strikes` (321).** The map deletes it with the rest of the unused functions, and it
   is the one function that turns blocks into judges' strikes ("blocked / 3. Never damage"). The judges do not
   decide today (`JudgeNight.DECIDES` false), so the cut is harmless — but if the cards ever move, that is the
   bridge, and the map's "one count rule" is exactly the moment to decide whether blocks belong on the cards.

---

## Code-claim table

Every claim the map tags CODE, plus the code claims inside its TO BUILD rows (a build order that cites a line
that is not there is a claim too). "TRUE" = file, function and line as cited, at `99e3070`, allowing the map's
declared +2 offset after `LiveRound.gd` 245. "Line off" = behaviour true, cited line wrong. "FALSE" = the code
does something else.

| # | The map's claim | Verdict | What the code does (this tree) |
|---|---|---|---|
| C1 | A round is six exchanges, `Exchanges.EXCHANGES` 10 | TRUE | `Exchanges.gd:10` `const EXCHANGES := 6` |
| C2 | `LiveRound.exchange` calls `settle` at LiveRound 287 | TRUE (+2) | `LiveRound.gd:285`; 287 is the map's working tree |
| C3 | `settle` 356-361, margin with two dice of ±33, `EX_SPREAD` 66 line 14 | TRUE | `Exchanges.gd:356-361`, `:14`; `(roll_a-0.5)*66 - (roll_b-0.5)*66` |
| C4 | Margin 0 or more wins; `LANDED` 345 gives 4-3 / 5-2 / 6-1, `band` 349-351 | TRUE | `Exchanges.gd:357-361`, `:345`, `:349-351` |
| C5 | Round = most exchanges; 3-3 to the bigger total margin (`round_of` 366-379) | TRUE | `Exchanges.gd:366-379`, `sum >= 0.0` at `:377` |
| C6 | `round_of` called by `LiveRound.close` 408 | Line off | `close` is `LiveRound.gd:403`, `round_of` at `:406` (map tree would be 405) |
| C7 | Cards 10-9 a round won, `BoutRules.cards_of` 402-412 | TRUE | `BoutRules.gd:402-412`: 10-9 per round, third judge flips the closest close round |
| C8 | Judges drawn but do not decide, `JudgeNight.DECIDES` false line 16 | TRUE | `JudgeNight.gd:16`, `:71` reads the cmdline override |
| C9 | DERIVED: +3 wins 4 more in 100, +5 → 7, +8 → 11, +17 → 22 | TRUE | Recomputed from the triangular dice: 4.4 / 7.0 / 11.4 / 22.4 |
| C10 | Everything that feeds `d` is LiveRound 212-283 | TRUE (+2 after 245) | `LiveRound.gd:212-281`, settle at 285 |
| C11 | 212: round base, corner call, stiff-jab perk, unfixed habit | TRUE | `LiveRound.gd:212` base + `PerkFight.call_edge` + `habit_pts` |
| C12 | Corner call `Exchanges.call_edge` 255-265 | TRUE | `Exchanges.gd:255-265` |
| C13 | "Hands up" = +17 when graded well, +5 as ok when tired/hurt, 0 elsewhere (`MODES` 126-133, `EDGE` 18) | TRUE | `EDGE` `:18` best 17 / ok 5; `MODES:129` loadup best "hands"; `:132-133` ok |
| C14 | Graded on Defence and head movement (`CALLS` 79; `Attrs` 264-266) | TRUE | `CALLS:79` needs `["guard","head_movement"]`; `Attrs.gd:264` guard=defence; `:266` head_movement |
| C15 | 214, 221: the corner's talk, a fired set-up | TRUE | `:214`, `:221` |
| C16 | 222: pace and aim, `PaceAim.edge` 26-41, Push +6, Save -4, a named aim -1.5 | TRUE | `:222`; `PaceAim.gd:11` push 6 / save -4; `:20` `AIM_COST := 1.5`; `:26-41` |
| C17 | 233: the read | TRUE | `:232-233` `TheRead.EDGE_LANDED` + `rd["edge"]` |
| C18 | 265: the plan's line, reads, pressure, pro read | TRUE (+2) | `:263` (map tree 265) |
| C19 | 267: camp weeks on the opponent's game | TRUE (+2) | `:265` `WeekOpp.edge` |
| C20 | 268: `CrackWire.guard_edge` 68-74 | TRUE (+2) | `:266`; `CrackWire.gd:68-74` (−10 through, −4 defend, /6 power stats) |
| C21 | 275: the clinch's price | TRUE (+2) | `:273` `d -= cl["edge"]` |
| C22 | 279-283: the place duel, style levers, the step's open and deny | TRUE (+2) | `:277-281` |
| C23 | **Nothing from `GuardState` or `GuardWear` is in the sum** | **TRUE** | No `Guard` reference anywhere in `exchange` 156-285 |
| C24 | "Hands up" earns +5 guard at the corner, a free cover (`CALLS` 79) | TRUE | `GuardState.gd:132-133` sets `hands_next`; `:45-46` spends it at the next bell |
| C25 | 288: `StepWire.levers` "158-190" | **FALSE (line)** | `StepWire.gd` is 123 lines; `levers` is `:95-123`. There is no line 158 |
| C26 | levers: a planned step denies landed, a wrong step lets more in, drain to `lv["opp_drain"]` (184) | TRUE (line off) | `StepWire.gd:107-112` deny, `:101-106` wrong, `:113-115` drain (`:184` does not exist) |
| C27 | `RingDuel.opp_energy` 332-335 subtracts `opp_drain` | TRUE | `RingDuel.gd:332-335` |
| C28 | 297: pace output Push x1.25, Save x0.75 (`PACE_OUTPUT` 13) | TRUE (+2) | `:295`; `PaceAim.gd:13` |
| C29 | 300-304: hurt ribs / a cracked side land less | TRUE (+2) | `:301-302` (rib count ≥ `RIB_HURT_AT`, or cracked) |
| C30 | 307-313: counter sense +1 landed, margin up, damage | TRUE (+2) | `:304-311` |
| C31 | 318: ONE CHANGE moves head/body for a round, `Adaptation.body_shots` 80-90, `HEAD_DAMAGE` 24 | TRUE (+2) | `:316`; `Adaptation.gd:80-93`, `:24` `HEAD_DAMAGE := 2.0` |
| C32 | Adaptation's header says "not who wins" | TRUE | `Adaptation.gd:5` "moves where punches land and what they cost, not who wins" |
| C33 | 325-334: punches taken in a tie-up (`ClinchRest`) | TRUE (+2) | `:323-332`; `ClinchRest.gd:50-55` |
| C34 | 354: `GuardState.after` 93-135 | TRUE (+2) | `:352`; `GuardState.gd:93-135` |
| C35 | 355-359: the leak, `GuardState.wear_through` 65-81 | TRUE (+2) | `:353-357` adds `through` to `m["damage"]`; `GuardState.gd:65-82` |
| C36 | 389: `RingDuel.settle` 356-397, who is hurt from the margin 383-386, the next game | TRUE (+2) | `:387`; `RingDuel.gd:356-397`, hurt at `:383-386` |
| C37 | `m["damage"]` is read only by the knockdown rule (`BoutNight._counts` 254 → `Knockdowns.round_counts` 20-74) | **FALSE** | `_counts` is `BoutNight.gd:245`; the damage is also read by `Towel.gd:27` (retire on the stool) and handed to `LiverFold.roll` (`BoutNight:266`) and `Knockdowns.puncher_chance` (`:270`) |
| C38 | `GuardState.open` 37-49 holds `{g, max, clinch, hands_next}` | TRUE | `GuardState.gd:37-49` (`hands_next` only appears once set, `:133`) |
| C39 | Full guard light 80, middle 100, heavy 120, amateur 70 (`max_guard` 268-275) | TRUE | `GuardWear.gd:68-71`, `:268-275` |
| C40 | thrown = landed / `LAND_RATE` 0.33 (BoutBurn 8), `BLOCK_SHARE` 16, `blocked_of` 53-55 | TRUE | `BoutBurn.gd:8`; `GuardState.gd:16`, `:53-55` |
| C41 | The same 60 for everyone: Defence is not in the block share | TRUE | `blocked_of(landed)` takes no attributes |
| C42 | A block costs 1 / 3 / 5 by kind (`wear` 127-160), mix `BoutBurn.MIX` 9, x0.40 pro / x0.28 amateur (17-18) | TRUE | `GuardWear.gd:26-28`, `:127-160`; `BoutBurn.gd:9`; `GuardState.gd:17-18` |
| C43 | Passed in today: ropes +12%, amateur +15%, shoulder, the slow-starter habit (`after` 100-111) | TRUE | `GuardWear.gd:135-137`, `:151-153`, `:154-156`, `:157-158`; `GuardState.gd:104-111` |
| C44 | In `wear`, passed by nobody: moving -5%, high posture +8%, condition, missed weight (138-150) | TRUE | `GuardWear.gd:138-150`; `GuardState.gd` builds only ropes / amateur / shoulder / trait |
| C45 | The leak: jab 25%, power 42.5%, heavy 55% at a full guard, doubling to an empty one (`transmission` 100-117) | TRUE | `GuardWear.gd:13-15`, `:100-117` (`mult = 1 + (100 - g)/100`) |
| C46 | The opponent's power is in neither the wear nor the leak | TRUE | Neither function takes power |
| C47 | In-round recovery +3 (amateur +4) only when the other side threw nothing (`in_round` 219-224) | TRUE | `GuardWear.gd:53-56`, `:219-224` |
| C48 | DERIVED: `settle` always gives the loser ≥1 landed = 4 thrown, so the "+1 for 1-2 thrown" branch cannot happen | TRUE | `LANDED` 345 has no 0; `ceil(1/0.33) = 4`; `RECOVER_LIGHT` (55) is unreachable |
| C49 | Corner +15, +5 more for "Hands up" (`corner` 241-257, `open` 45-46, `after` 132-133) | TRUE | `GuardWear.gd:63-64`, `:241-257`; `GuardState.gd:45-46`, `:133` |
| C50 | Tie-up +10 under half once a round, `skilled` +13 passed false at `after` 128 | TRUE | `GuardWear.gd:58-61`, `:228-236`; `GuardState.gd:128` `clinch(false, ...)` |
| C51 | §1.6 "throws less" is now "the opponent's big shots miss" (`CALLS` 80, S533 note) | TRUE | `Exchanges.gd:80` |
| C52 | §1.6 "a quiet exchange gives back 4" is now "only when the opponent lands nothing (+4, pro +3)" (`GuardNotes.amateur_note` 24-26) | TRUE | `GuardNotes.gd:24-26`, formats `RECOVER_QUIET_AMATEUR` 4 / `RECOVER_QUIET` 3 |
| C53 | §1.6 the guard hover now mentions blocks (`HudBars.WORDS` 38) | TRUE | `HudBars.gd:38` |
| C54 | §1.6 the caption still names no button, under 55% (`_guard_call` 300-307, `GUARD_LOW` 46) | TRUE | `HudBars.gd:300-307`, `:46`; text is exactly "The hands are coming down - over the top!" |
| C55 | §1.6 `blocked_strikes` 321, `parry_chance` 302, `posture_damage` 202, `word` 342 and the clinch's "stamina -10 / free exchange" (236) have no caller | TRUE | `GuardWear.gd:321`, `:302`, `:202`, `:342`, `:236`; grep finds no use outside the file, and `CLINCH_STAMINA` / `free_exchange` are never read |
| C56 | One of six games (`MODES` 124-134) by style (`MODE_V` 180-190) | TRUE (imprecise) | `MODES` has 8 situations (`:124-134`) across 6 styles (`MODE_V:180-190`) |
| C57 | Under 45 energy it turns "Tiring" 3 times in 4 (`next_mode` 273-274, `OPP_TIRED` 56) | TRUE | `Exchanges.gd:273-274` `energy < OPP_TIRED and rng.randf() < 0.75`; `:56` = 45.0 |
| C58 | Its energy runs bell to round-end (`BoutNight._energy` 319-341) less body shots and drain | TRUE | `BoutNight.gd:319-341`; `RingDuel.gd:332-335` |
| C59 | The opponent has no Pace or Hands setting | TRUE (note) | No such key exists for the opponent; the judges do read an opponent `pace` attribute (`JudgeNight.gd:38`, `:60`) |
| C60 | `PaceAim.WHEN` 101, "counts from the next exchange" | TRUE | `PaceAim.gd:101` |
| C61 | The setting carries in `m["live"]`, pace/aim at LiveRound 111 | TRUE | `:111` |
| C62 | A hands=high key read by the pace= / aim= parser at LiveRound 167-172 | TRUE | `:167-172`; only accepts members of `PaceAim.PACES` / `PaceAim.AIMS` |
| C63 | The round's plan call read at LiveRound 190 | TRUE | `:190` `call := shout if shouted else str(lv["plan"])` |
| C64 | ONE CHANGE shares the habit fix's slot (`Adaptation.gd` 2-5, `CallButtons` 73) | TRUE | `Adaptation.gd:2-5`; `CallButtons.gd:74` `fix_row(..., changes)` |
| C65 | The Tie up step at Sharp (60) is `MoveMastery` 26 | **FALSE (line)** | `MoveMastery.gd:26` is the word ladder comment; 60 is `:18` (`if m < 60.0`) and `:28` (SHARP). The value is real, the citation is not |
| C66 | `HabitFix.PUNISHED_BY` 17 | TRUE | `HabitFix.gd:17` |
| C67 | Defence/head movement grade High, Stamina/hand speed grade Loose | TRUE | `Exchanges.gd:79` needs `guard`+`head_movement`; `:82` needs `engine`+`hand_speed` |
| C68 | `Attrs` 264-266 build guard and head movement, 268 power, 273 neck → durability, 261 chin | TRUE | `Attrs.gd:264`, `:266 `0.65 defence + 0.35 flexibility`, `:268`, `:273`, `:261` |
| C69 | Three counts a round, four in a bout (`Knockdowns` 7-8); `REF_STOP` 15, stop rule at 55 | TRUE | `Knockdowns.gd:7-8`, `:15`, `:55` |
| C70 | `Exchanges.favourite` 312 | TRUE | `Exchanges.gd:312` |
| C71 | `CALLS` 69-94, `win_shift` 215 | TRUE | `Exchanges.gd:69-94`, `:215-223` |
| C72 | `situation` 194-199, `grade` 227-245, `COMMIT` 32 | TRUE | `Exchanges.gd:194-199`, `:227-245`, `:32` |
| C73 | `roles` 107 keeps names out of the body | TRUE | `Exchanges.gd:107-121` |
| C74 | `read` 410-431 reads the round's games | TRUE | `Exchanges.gd:410-431` |
| C75 | HUD guard arc: fill, hover number, "?" until scouted (`HudBars` 38, 252-253; `FightMeters.bars` 45-47) | TRUE | `HudBars.gd:38`, `:252-253`; `FightMeters.gd:33` def, `:46-47` `guard_v4`; `_known` at `:85` |
| C76 | Corner bar PACE and AIM with hover (`CornerBar` 156-186) | TRUE | `CornerBar.gd:155-186` |
| C77 | Shout bar PACE row and its cost line (`ShoutBar._draw_drive` 86-95) | TRUE | `ShoutBar.gd:86-95` |
| C78 | Corner line "Guard down to N% ..." (`CornerCard.guard_line` 107-110, `card` 76-77) | TRUE | `CornerCard.gd:107-110`, `:76-77` (`card` def `:62`) |
| C79 | Result figures: blocked, through, guard left (`FightStats.rows` 66-76) | TRUE | `FightStats.gd:66-76` (`rows` def `:60`), `PUNCH_WORTH` |
| C80 | The Why's three rows (`FightWhy` 96-110; `WhyCard` 21) | TRUE | `FightWhy.gd:96-110` (ropes line only when `ropes > 0`); `WhyCard.gd:21` |
| C81 | Plan page rows read `PlanFile.pace_for` (LiveRound 107) | TRUE | `LiveRound.gd:107`; `PlanFile.gd:139` |
| C82 | Fight prep `FilmNight.prep_rows` 87-90; `FightPrep` 9 | TRUE | `FilmNight.gd:89` (`prep_rows`), `:93` `rows_of`; `FightPrep.gd:9` |
| C83 | Opponent file's three guard habits `OppFile.GUARD_NOTE` 64-67 | TRUE | `OppFile.gd:66-67` |
| C84 | Training tab `GuardNotes.lines` 29-34 | TRUE | `GuardNotes.gd:29-34` |
| C85 | Boxer page shoulder line (`AttrBoard` 281-287) | TRUE | `AttrBoard.gd:283-289` |
| C86 | `Adaptation.offers` 31-47; `CornerOverlay` 344 | TRUE | `Adaptation.gd:31-47`; `CornerOverlay.gd:344` "ONE CHANGE (OPTIONAL)" |
| C87 | `GuardState.damage_on` 21 is the switch a probe can flip | TRUE | `GuardState.gd:21` `static var damage_on := true` |
| C88 | "Pass `posture: high` to `GuardWear.wear`" is in the code and unused | TRUE | `GuardWear.gd:148-150`; no caller passes it |
| C89 | Chance of being hurt when losing big is `RingDuel.settle` 385-386 | TRUE | `RingDuel.gd:385-386` |
| C90 | Loose's +1 clean punch is "rounded as Save is (LiveRound 297)" | TRUE (+2) | `:295` `round(landed * PaceAim.output(pace))` |
| C91 | `PaceAim.AIMS` takes "a sixth entry" for the pro aim | **FALSE** | `PaceAim.gd:7` already has six (empty, head, body, left_ribs, right_ribs, head_hurt): the new one is the seventh, and it would enter the shout parser (`LiveRound.gd:171`) with it |
| C92 | `AIM_COST` is 1.5 | TRUE | `PaceAim.gd:20` |
| C93 | `hands_next` (+5 at the next corner) is CODE | TRUE | `GuardState.gd:45-46`, `:133`; `GuardWear.gd:64` |
| C94 | Probes and their tools exist (`tools/guard_probe.gd`, `guard_onoff.gd` 3-8) | TRUE | Both exist; `guard_onoff.gd:2-8` reuses `guard_probe`'s population and `_play`, `damage_on` off/on |
| C95 | The named files in the map's file list exist | TRUE | `CornerJobs.gd`, `LineGrade.gd`, `Judges.gd`, `WhyCard.gd`, `FightPrep.gd` all present |
| C96 | A `HandsEdge` module | **NOT FOUND** | `scripts/rules/HandsEdge.gd` does not exist (correctly marked to build) |

**Tally, of 96 claims:** 90 true, 4 with a wrong citation (C6, C25, C26, C65), 2 false on content (C37, C91),
1 not found and correctly marked to build (C96). The two false
citations that block a build order are C25 (`StepWire.levers` 158-190) and C65 (the Tie up mastery at
`MoveMastery` 26); C91 changes what "a sixth entry" costs, and C37 changes what the leak can do to a boxer.

---

## What a 10/10 page looks like (1920x1080)

One page, the fight, no menus: the corner bar and the ring share it. The mechanic is judged on this page and no
other, because this is where the 30 seconds are decided.

- **Field.** 1920x1080. The action fills the middle 1920x780. A 48-pixel margin all round; nothing numeric outside
  a hover.
- **Top left, 300 x 96.** The round clock at 96 points, "ROUND 3 OF 6" under it, and six exchange pips in a row
  under that — filled when the exchange was won, a small shield glyph on a pip that was won on the guard. That row
  is the score of the round in the only place the player is already looking.
- **Top right, 380 x 180.** The opponent's card: energy bar 320 x 18 with a tick at 45 ("the mouth opens"), the
  guard arc at 56-pixel radius with three words that replace the percentage — WORN, ARMS DROPPING, BROKEN — and
  the one clue line the game already writes. The arc is scouted or it reads "?"; no number unless the tape room
  found it.
- **Bottom bar, 1920 x 132, one row.** Left: PACE, three buttons 92 x 44. Middle: AIM, six chips 84 x 44.
  Right: HANDS, three buttons 120 x 44 — COVER / NORMAL / OPEN — the chosen one gold, and under it one line of
  live text: "Cover: the big shots hit gloves. Against this game: +6." The buttons are one row and one rhythm,
  because they are one decision: how much of the 30 seconds your boxer spends covering.
- **Centre, under the ring, y 860, 34 point.** The exchange line, always in the same shape: "Lost the exchange
  4-3 — 2 on the guard". Never "blocked 6"; the guard's work is counted in punches the player can add up, and the
  word "guard" is on the line every exchange, not only when the guard is low.
- **Above that line, 200 x 10.** One referee gauge, with count pips under it (three a round), and one word:
  WATCHING / LOOKING / DONE. No second bar for the look, no warning prices.
- **Your boxer's guard arc, left of centre, 96-pixel radius.** Colour by the same three words, and the hover says
  "Blocks 62 in 100 of what misses. A block wears 1, 3 or 5. High covers more and punches less." Four lines of
  text that teach the mechanic without a tutorial.
- **At the bell, one card 760 x 520, centred.** The corner's minute: the read at the top in one sentence
  ("The opponent is tiring: open the hands"), then ONE row of choices — Pace, Aim, Hands, ONE CHANGE — because it
  is one choice and the game only gets one. Hands carries the reason, the opponent's game over the last three
  exchanges; the ONE CHANGE tiles are renamed Protect the head / Protect the body so "high" means one thing.
- **The result page reads the mechanic back.** Rows: "Punches blocked 34-21", "Got through the guard (in punches)
  6-11", "Guard left at the last bell 42% — 19%", and the Why's line: "Hands High won 9 exchanges, cost 4; 14
  points of guard, 4 punches through." The player can see the price she paid and the rounds it bought.
- **Nothing on the page is a number she has to hunt for, and nothing is named.** The body says your boxer and the
  opponent; the header carries the names. Every line that says what is wrong names the button that answers it.

## To reach 10/10

1. **Fix the block count so covering actually spends the guard.** `GuardState.blocked_of` (53-55) derives the
   opponent's thrown punches from the punches that landed, so cutting their landed cuts their blocks and slows
   your boxer's wear — High is self-protecting. Count blocks from a real thrown figure (or pass the exchange's
   block share from Hands) and add the test: three rounds of High must leave the guard at least 15 points lower
   than three rounds of Normal. Without this, one setting is dominant and the map's own table collapses.
2. **Size the worn penalty in the exchange's own unit.** -2 / -4 is worth 3 and 6 wins in 100, under half an
   exchange a round, below the probe's resolution. Either -8 under half and -14 under a quarter, or delete 2.3
   and let the block share carry it. Put the wins-in-100 column in the map, as the map already does for the call.
3. **Build the seam before any screen.** `HandsEdge.points` into `d` at `LiveRound.gd` 222, a `hands=` branch in
   the parser at 165-171 with its own list, `m["live"]["hands"]` at 110, and nothing else until GUARDPROBE6's
   bars 2, 3 and 6 pass. The seam is one line; the screens are twenty, and the numbers are not yet worth them.
4. **Make the opponent pay too.** Give the opponent a Hands stand-in by style (the out-boxer covers, the slugger
   opens, the pressure fighter shells when hurt) and run the worn term on both guards. Otherwise the worn penalty
   is a discount the player collects and never pays, and "wear a guard down to win the round" is not a contest.
5. **One word for one thing.** Rename the ONE CHANGE tiles to Protect the head / Protect the body
   (`Adaptation.offers`, `CallButtons.fix_row`), call the setting COVER / NORMAL / OPEN, and relabel the "hands"
   call to match. A player who reads "High" in three places for two different things will believe none of them.
6. **Settle the tie-up against the game's own rule.** `GuardState.after` 127 applies the +10 only when the corner
   shouted "tie", while `ClinchRest.tied` (27-28) counts the plan's tie-up arrow and a clinch exchange as
   tie-ups; those get the refill and none of the guard. Pass the tie-up test, not the call id, then 3.4's "a
   tie-up halves the leak" is a rule and not a wish.
7. **Cut what cannot be felt.** The +8% high-posture wear (0.032 guard a block), Loose's +2 head damage, the
   pro aim's 1.5x guard wear bought with -1.5 edge, and the referee look's -1/-2 churn. Four numbers, four
   lines, none of them inside the probe's error. A 10/10 map has fewer sizes, each one defended.
8. **Put the guard on the exchange line, always.** "4-3 — 2 on the guard" every exchange, and the caption rewritten
   to name the button ("hands are dropping: Open, Aim head"). The map already has both sentences; it files them as
   formatting. They are the only place the mechanic is learnable in round one.
9. **Give the dial one owner and say so.** The plan's round row sets Hands at the bell, the corner bar overrides it
   for the round, the shout overrides it for one exchange — write that order in the map, in the hover, and in one
   test. Today the map gives the plan page a Hands per round and the bar a standing Hands, and no rule for
   the bell.
10. **Keep the code's dead ends honest.** Wire `CORNER_BACK_OFF` / `CORNER_CUTMAN` / `RECOVER_LIGHT` or delete
    them; do not delete `GuardWear.blocked_strikes` (321) with the other unused functions — it is the only bridge
    from blocks to the judges' cards, and "blocks are never landed" is exactly the rule this map is writing.

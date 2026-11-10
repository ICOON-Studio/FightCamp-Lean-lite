# The week, one design (v3, S427) - after two critics scored v2 at depth 5

Pictures: docs/mockups/s427/week_v3_camp.png (Home on a camp Monday) and week_v3_quiet.png (Home on a quiet Monday).
v1 and v2 are untouched (WEEK_DESIGN_V1_S425.md, WEEK_DESIGN_V2_S425.md). Reviews of v2: docs/mockups/s425/week_v2_critic_coach.md
and week_v2_critic_simvet.md (both depth 5: "a good chain and a calendar around it"; "claim-picking with visible numbers").

## 0. What changed from v2, and why
1. THE FIGHT IS ON HOME ALL WEEK. A fight-night card sits on Home (win chance as a band, answers owned by taper, how well
   the boxer listens, three camp lights). Hovering any choice moves it in ghost. v2 asked him to trust a table; now he SEES
   the week change the fight (simvet 2, coach 4).
2. NO "REID'S PICK", NO EXACT PAYOFFS. Reid still fills a whole default week (one click plays it), but no option is marked
   best, and each shows a BAND ("+3 to +8 in 100") that narrows only with tape on that opponent. Options cost different
   things (an evening, the body, money, a boxer's mood), so they cannot be sorted by one number (simvet 1, coach 1).
3. PROBLEMS ARE RIVALS AND THEY COME BACK. Two scarce things run the week: Reid's hands (Monday and Friday evening) and the
   body (tiredness headroom to the overtired line at 80). Every problem costs one or both. What is not picked returns next
   Monday as a NAMED problem with its own clock, and a problem that ran out is written into the Why and the next camp's
   card (simvet 4 and 5, coach 1).
4. THE QUIET WEEK IS A DIFFERENT GAME: THE BLOCK AND THE SATURDAY. With no bout booked each boxer runs a 2 to 4 week block
   the player chose, priced before the click, tested on Fridays, and a met block OPENS a choice. Saturday is a standing
   weekly decision: the open spar (a tell each way) or the show (ringside, one of two bouts) (simvet 3 and 6; Kalli's page
   K_WEEK_DEPTH_S425_BRIEF_KALLI.md sections 2.3 and 4).
5. LINES FIRE BY HOW WELL THEY ARE DRILLED - MEASURED, IN (docs/FIRELEVEL1_RESULT.md). Usable fires 1 use in 2, sharp 3 in
   4, Signature always: sharp is worth 2.8 wins in 100 over usable and Signature 2.7 over sharp. Pad nights now have a job
   after "usable". The rule is on main, switched off (no key = today's game; S427 fixed its one bug).
6. PLAN-READING IS OUT OF THE WEEK. READBACK1 to 3 (400 bouts a cell): a corner that waits for your best line costs 7.0
   points and no answer wins back more than 3.7. A rule that only takes points away is not built. What stays is small and
   has an action (section 3.5); Kalli's "switch" is not built unless a new probe wins back 4 or more.
7. REWARDS ARE CHOICES YOU CAN SEE: a freed evening as an empty tile, a new plan place as an empty slot, the senior boxer
   as a face on a Friday tile (coach 5).
8. DEAD DAYS AND DEAD OPTIONS GONE: Sunday is off the board; Wednesday's sentence takes one tap; a boxer with nothing to
   decide has no row; newcomers are a quiet-week claim only; "the weaker free line" and "no change" each have a case where
   they are right, shown (coach 3, simvet 7 and 8).

## 1. The idea in five lines
1. The measured heart: the answers the plan needs, in the boxer's hands and DRILLED before taper (a missing answer costs 2
   to 14 wins in 100; a usable one fires half the time, a sharp one three times in four).
2. A camp week is a squeeze on two things, Reid's two evenings and the body, with more problems than both can carry.
3. What he leaves comes back named, with a clock; what runs out is in the Why. Mistakes are visible and learnable.
4. A quiet week is building: one block per boxer, and a Saturday that trades knowledge with a rival.
5. Everything he builds shows up on the fight-night card on Home before the fight, and opens a new choice after it.

## 2. The week as played
### Camp week (Lucy fights Kovacs in 19 days, taper in 12; Danny lost last Saturday and is Flat)
- MONDAY. Home: the fight-night card for Lucy v Kovacs (wins 38 to 52 in 100; answers 2 of 4 by taper; listens: Steady;
  lights: weight amber, tiredness green, answers amber). Below it the week's row of days and TWO evening tiles, Monday and
  Friday, filled by Reid. One question is open. A named problem is back from last week: "Step back: usable by taper only
  if it gets Friday. 5 days left to start." He hovers the claims on Friday's tile; the card's answers dots and band move in
  ghost. He picks, presses Start week.
- TUESDAY, tape lands. One new thing on Kovacs ("drops the right after the jab"). The band on the card narrows (38 to 52
  becomes 41 to 49: tape is what makes numbers exact). The answer it calls for is a line Lucy does not own: a new problem.
- WEDNESDAY, sparring, Reid's sentence: "Lucy's right hand drops after the jab. Four times." One tap: START ON IT (Friday
  goes to the habit, the card shows what Friday was going to buy, in ghost, lost) or NOTE IT (it joins the named problems).
- THURSDAY, the squeeze, only when two or more problems are open (else the day does not stop). Open now: the new answer
  (needs Friday AND next Monday), the habit (Friday), the scale 0.4 kg off its line (mornings: costs the body, 74 of 80).
  He can pay with Friday once and with the body once. Each option shows what it uses, a band, and its clock. There is no
  recommended one. What he leaves is listed under "comes back Monday".
- FRIDAY. The evening is spent. Danny's offer runs out today, on its own card (take, pass, ask for later).
- SATURDAY. A show at Eastside: ringside (pick ONE of two bouts: a name he may meet at the regionals, or the likely next
  opponent, each with what it would open) or stay and hold pads himself for whoever went without.
- NEXT MONDAY. Three lines at most: landed, late, the surprise and why. The named problems are back with shorter clocks.
  If the new answer's clock ran out, the card now says "answers 3 of 4" for good, and the Why will say which Thursday did it.
### Quiet week (no bout booked)
- MONDAY. Each boxer shows a BLOCK tile. "No block set" is the open question. He picks a block per boxer and sees its
  price first ("Sharpen the 1-2: about 7 of Reid's evenings; her mornings stay on engine"). He may ask for a fight.
- TUESDAY to THURSDAY. Reid's evenings go to the blocks. Wednesday's sentence can change a block's order with one tap.
- FRIDAY. Test day (in the game): each block's line against its deadline, ON TRACK or AT RISK, with the reason.
- SATURDAY, alternating. Open spar week: invite the boxer one place above (one of her tells found now, one of your lines
  seen by her corner), an unranked visitor (sparring only), or nobody (no injury roll). Show week: ringside, one of two.
- The Monday a block is met, it lands as the review's last line and opens its choice (section 3.3).
- A player who does nothing still gets Reid's week in one click: Reid sets "Sharpen the best line" and declines the spar.

## 3. The mechanics
### 3.1 The fight-night card (new; reads what the game already computes)
On Home whenever a bout is booked, and on every offer. Four things, as pictures:
- WIN CHANCE as a band from the forecast the game has. Wide with no tape on the opponent, narrower with each thing the
  tape opens (3 things = tight). Scouting therefore buys PRECISION for every later choice, not only an answer.
- ANSWERS: four dots, filled = owned and usable by taper at this week's lay; a ring round a dot = sharp.
- LISTENS: Fired up 105, Steady 100, Flat 85, Low 70 (the game's bands).
- THREE CAMP LIGHTS: weight, tiredness, answers (peak camp = all three green, which the game already pays on every stat).
Hover or focus any choice anywhere in the week and the card redraws in ghost beside itself. Nothing is confirmed by hover.
### 3.2 Two scarce things: Reid's hands and the body
HANDS. Reid works Monday and Friday evening; Wednesday is the club's sparring night (he watches, no choice). Each evening
goes to ONE claim:
- an answer the plan needs (right when it still lands before taper; a card that will be late says so and is greyed);
- drilling an owned line toward sharp (right when all four answers are owned: +2.8 in 100 per line taken to sharp);
- a habit of the boxer's own, named by Reid or by a Why (four evenings, gone for good; right when this opponent's file
  punishes it or no bell is near);
- the other boxer (right in his third week without Reid: "feels second" is shown a week ahead, costs his mood band).
More hands, each at a price: a SENIOR clubmate holds pads (half Reid's rate, and it costs the senior's own evening); the
PLAYER's Saturday (instead of ringside or the spar); a BAG night (a quarter rate, free). No second coach before a third boxer.
BODY. Extra mornings (roadwork for the scale, an added session) push tiredness toward 80; over it gains drop to 0.6 and
the injury chance triples (the game's rule). The body is the price of fixing weight or adding work, and it is the same
budget next week: a week spent at 78 starts the next one with no room.
THE SQUEEZE (Thursday, or folded into Monday: see the gate in section 5). Problems on the table each name what they use:
hands, body, or both. He can spend Friday once and the body once. Choices are of different kinds on purpose:
- the fight (an answer for this opponent: the band on the card);
- the career (the habit, the best line: nothing for this fight, permanent after);
- the body (the scale now, at the cost of next week's room);
- the club (the other boxer's mood, which decides how he listens in HIS next bout).
"Change one plan line to something already owned" is the right pick when the clock on a new answer cannot be met (and on a
short-notice offer, where no evening exists at all). "No change" on an all-green board shows its reward: peak camp held.
WHAT COMES BACK. Every unpicked problem returns on Monday's Home as a named row with a clock ("Habit: right hand drops.
Kovacs's file punishes it. 2 evenings to fix, 1 left before taper"). When a clock runs out the row closes with its cost
("late: answers 3 of 4") and that line is quoted in the bout's Why and on the next camp's first card.
### 3.3 The block (quiet weeks; Kalli 2.3, cut to four)
A goal the player sets for a boxer for 2 to 4 weeks, with a Friday test. Price shown before the click. Met = a new choice.
| Block | Price shown | Right when | Opens when met |
|---|---|---|---|
| Sharpen a line | about 7 evenings of hands | the plan's answers are owned; likely opponents are known | that line fires 3 in 4; at Signature it becomes a HOUSE LINE (stops fading: its upkeep evening is freed, shown as an empty tile) |
| Chase a perk | 3 weeks of mornings on one stat, the others idle | the perk's gate is about 3 points away | the perk (e.g. Ring general: one more PLAN PLACE, shown as an empty slot on the Playbook) |
| Fix a habit | 4 evenings | a rival's file or a Why lists it | it leaves every rival's file on you (their corner loses that tell) |
| Rest and heal | no gains for 2 weeks | after a stoppage, at 40+ on a scar, or Flat | mood up one band; a fresh boxer for the next offer (the card shows it) |
Blocks compete for the same two evenings, so two boxers cannot both sharpen at full speed: the squeeze exists in quiet
weeks too, at a slower clock. A block not met by its date lands as "missed, and why" and costs the mood a goal costs today.
### 3.4 Saturday (a standing decision every week)
- SHOW weeks (every other Saturday, in the game): ringside, ONE of two bouts. Each tile says who is in it, their place
  against his boxers, and what watching opens (a weakness on Tuesday, banked BEFORE any booking; a banked weakness lets him
  ask for that boxer BY NAME and starts that camp's answer on day one). Or stay: his own hands for one boxer.
- OPEN-SPAR weeks: invite a ranked rival (her tell now; one of your lines goes on her file), an unranked visitor (sparring,
  nothing traded), or decline (no injury roll; right in the fortnight before a test or a bell).
The trade "her tell for my line" is the one place the film on you is felt, and it is a choice the player makes.
### 3.5 The film on you, small, with an action (v2's SMALL, made to obey "only what he can act on")
A line shown in a public bout or an open spar is KNOWN to corners that study tape (an eye on it in the Playbook and on the
card). A known line is covered at the measured small cost (0.5 to 2.5 points). His action: on any CLUB SHOW bout, once a
bigger night is drawn (the regionals bracket, a title eliminator), a line can be RESTED for that bout (not thrown, so it
stays unknown) at the price of this fight's band, which the card shows in ghost. Until a bigger night exists the eye does
not appear at all. A house line cannot be covered. No waiting corner, no note, no swap.
### 3.6 Lines fire by how well they are drilled (measured; replaces "sharp pays 1 point")
Usable 1 in 2, sharp 3 in 4, Signature always (FIRELEVEL1 shares B). When a line should fire and does, a plate shows it
in the live fight ("PRESSED: STEP BACK"); when it should and does not, a grey plate. The corner minute and the Why count
both and name the cause ("raw: the evening went to Danny in week 2"). Opponents follow the same rule, so an opponent with
a raw plan is a softer fight than her record says: one more thing tape can tell him.
Own rules of the boxer (v2: "when tired, tie up", fired without the corner) stay in the design as a later step and are not
counted in this version's depth: nothing about them is measured yet.
### 3.7 What playing on opens (each a visible, usable thing on the day it opens)
House line (an empty evening tile he may give to anything); a plan place (an empty slot); the senior (a face he can drag
to a Friday tile, from that boxer's 5th bout); a banked weakness (a name on the ask); a habit gone (a line struck through
on rival files); the bracket (names to choose between at ringside).

## 4. Where it is shown and what it is wired to
| Menu | What appears | Wired to |
|---|---|---|
| Home | The fight-night card with its ghost; the row of days (no Sunday); the two evening tiles; the ONE open question; named problems with clocks; block tiles in quiet weeks; "Opens next" | forecast, pad and mastery forecast, tiredness, weight line, the lay, the problem list (new), blocks (new) |
| Fighters > Overview | Block and its Friday line; house line by name; "third week without Reid" a week ahead; senior badge | blocks, mastery, the lay record, bouts |
| Fighters > Training | Who holds each evening (Reid, senior, you, bag) on the same two tiles as Home (one editor, two doors); mornings with the tiredness bar to 80 | the lay, TrainingLoad |
| Fighters > Playbook | Each line: usable / sharp / Signature with "fires 1 in 2 / 3 in 4 / always" and evenings to the next level; the empty plan place; the eye and Rest toggle only when a bigger night is drawn | FireLevel (on main), mastery, places, the known record (new) |
| Fighters > History | Per bout: lines fired and failed, the problems that ran out and when | the bout record, the problem list |
| Fights | The same card on every offer and ask; ask by level or by name; show bill with the two bouts; the open-spar invite with its trade | forecast, banked files, rankings |
| Club > People | Reid's evenings (read-only rota); seniors; hires greyed with the reason | staff, bouts |
| World | Rival file: tells banked, YOUR lines she has seen, habits of yours she lists | files, the known record |
| Live fight | A plate when a line fires, a grey one when it fails | the firing roll (FireLevel in LiveRound) |
| Corner minute | Lines fired and failed this round, inside the rows the minute keeps | the bout record |
| Week review | Three lines at most behind one chip; a met or missed block; closed problems with their cost | the week record |
| The Why | Per line: fired n, failed n, why; each problem that ran out, with the week it was left | the records |

## 5. Numbers, and the gates
MEASURED IN THE GAME: a missing answer 2, 4, 9, 14 wins in 100 (40.0% with four, 18.7% with none); firing by level, shares
0.5 / 0.75 / 1.0: usable 37.0%, sharp 39.8%, Signature 42.5% against 41.3% today (so the opponent table is retuned to
keep a usable plan near today's 41: a tuning job, named, not hidden); a waited line costs 7.0, best answer +3.7 (out);
covering a line 0.5 to 2.5; Reid's hands land a card one week sooner; a single move usable in week 2, a combination in
week 4; overtired at 80 (gains x0.6, injury x3); mood bands 105 / 100 / 85 / 70; a show every other Saturday; nationals
at 5 bouts; the plan holds 4 to 6 lines.
INVENTED (to tune): the band's width and how much each tape find narrows it; senior hands at half, bag at a quarter; a
habit in 4 evenings; block lengths and the evening counts; a missed block's mood cost; the spar's injury chance (x1.5
that week); one tell each way per spar; the tape window for "known" (last 2 public bouts); the fifth place at Ring general.
| Gate | State | Kills or changes |
|---|---|---|
| THURSDAY2: on 40 camps that really differ, how many problems are open on Thursday, and is one kind best 7 in 10 | RUNNING (Qwen). THURSDAY1 was void: its 40 camps were one camp | Under 2 open in half the camp weeks, or a lookup: the Thursday stop goes; the squeeze is laid on Monday with the named problems and clocks (they do not depend on it) |
| Firing by level | DONE: sharp +2.8, Signature +2.7 | - |
| Plan-reading | DONE: out | - |
| The band: forecast against 300 played bouts, with 0, 1, 3 tape finds | to run | A band that does not hold 8 results in 10: the card lies, widen it |
| A weakness banked on day 0 against day 9 | to run | Under 3 points: ringside is a nicety; the name on the ask still stands |
| Senior and bag rates against Reid | to run | Senior within 10% of Reid: Reid's evenings stop being scarce |
| Flat against Steady in the same bout | to run | Under 2 points: "the other boxer" is a label |
| A habit on and off, 300 bouts | to run | Under 2 for all: the habit block is decoration |

## 6. Kill list
1. "The card's ghost makes every choice a slider you drag until the number is biggest." The band is wide until he scouts,
   three of the four kinds of choice do not move this fight's band at all (career, body, club), and the body spent this
   week is gone next week. Where a choice only moves the band, it IS a lookup; that is why exact numbers are not shown.
2. "Named problems are a to-do list that nags." They are at most three, each closes by itself with a visible cost, and
   they are the only way a bad Thursday is ever seen again. Not answered: a player who always picks the fight will see the
   habit row for ever; Reid's default week takes it in the first quiet week so it does end.
3. "Blocks are set once and forgotten." Each ends on a date with a test, opens a different choice, and shares two
   evenings with the other boxer's block. Weak with one boxer and no rival near: then the block is the whole quiet week,
   plus the Saturday. I let that stand.
4. "The open spar is always right: free knowledge." It shows one of your lines (which the film rule then prices on a big
   night), and it rolls for injury in a week the block may be testing. Before the first bigger night is drawn the price is
   near nothing, so early on it IS free; said plainly on the tile.
5. "The retune hides that firing-by-level makes new players weaker." It moves where the difficulty sits (from the
   opponent to the plan), which is the point: the plan becomes worth building. If the retune cannot hold a usable plan
   within 1 point of today, shares go to 0.6 / 0.8 / 1.0 (sharp +1.8) and the block's "sharpen" gets cheaper instead.

## 7. Build order (each step is playable alone)
1. The fight-night card on Home and on every offer, with the ghost for the choices that exist today (the lay, the camp
   settings, the plan). No new rule. Then the band measurement.
2. Firing by level switched on with the retune, the plates, the Why's "fired, failed, why", the Playbook's "fires 1 in 2".
3. The two evening tiles as claims (answer, drill, habit, other boxer), senior, bag and the player's Saturday; the same
   tiles on Training.
4. Named problems with clocks, their close line in the review and the Why. Then the squeeze on Thursday or Monday, as
   THURSDAY2 decides.
5. Blocks with test day as the Friday line, and what each opens (house line tile, plan place slot, habit off the files).
6. Saturdays: ringside one of two with the banked weakness and the ask by name; the open spar and the known record.
7. Rest a line for a bigger night (after the bracket is drawn). Later, measured first: own rules; the cut thread (R28 v3).

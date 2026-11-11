# The Playbook, strengthened (PLAYBOOK_MAP_S432)

The owner's ask (S432): "do the same for the most important aspects of the game that affect the loop like building the fighter and the coach, playbook,
training and how these 2 impact fight, need reviewed them all and properly strenghen and add mechanics".
This map covers THE PLAYBOOK: the fight plan (lines), the player's own combinations, and how both reach the ring. It answers two fresh critics who
scored it 6 (a head coach: pb_coach_review.md) and 5 (a tactics-systems designer: pb_tactics_review.md), both in docs/mockups/s432/critics.
Linked, not redesigned: CLUBWEEK_MAP_V41_S432 (the week; "the plan is a hand", pad places, Coach's evenings), RPG_LAYER_MAP_S432 (coach levels and
style, perk versions, traits, Known), HYPE_MAP_S432 (Entertain / Box smart / Safe). TRAINING_MAP_S432 did not exist when this was written: section 4.1
and 4.2 name the two hooks it should take.
Drawn: docs/mockups/s432/playbook_v2.html (and .png), the Fight plan tab for Tess against a counter-puncher.
Numbers: from the code (file named), measured (probe named), real basis [R], or ESTIMATE [E]. Scope: four fighters (three boxers share this Playbook;
Ana's mat book is its own and is not in this map), amateur to a first professional fight.

## 1. The idea in eight lines

- THE BODY DOES THE PLAN: every line shows how this boxer does it (Good / OK / Poor, from the two attributes the move is done with). A right answer the
  boxer does badly can be worth less than a lesser answer done well. Mornings move the grade.
- DRILLED LINES FIRE: a combination line fires 1 time in 2 at Usable, 3 in 4 at Sharp, always at Signature (built and measured, switched on). Pads move it.
- EVERY LINE HAS A PRICE: points, gas and risk. Safe lines win exchanges but score little; big lines score and cost. No answer is right everywhere.
- THE OPPONENT READS YOU: some opponents wait for your most-won line from round 2. Each line can carry one answer, IF READ: throw it behind another
  line, or switch to a second move. Waiting also opens the opponent to your other lines.
- ROUNDS ON LINES: a line can live in the early, middle or late rounds; the last round splits into "ahead" and "behind".
- YOUR OWN COMBINATIONS ARE LINES: a chain built in Combos goes on a place, and its fit comes from how it is built (feint first, step out last, body first).
- WHERE THE FIGHT GOES: each place shows how many of the 18 exchanges this opponent puts there; the boxer brings only so many lines a round.
- ONE NUMBER AND A RECEIPT: the plan page prints "your plan against Coach's"; after the bout every line gets a receipt with Keep, Change and a button that
  puts the fix on the week.

## 2. What is built and stays (read in the code, S432)

| Part | What it does today | File |
|---|---|---|
| Lines | a place (8) and, if wanted, a situation; one move from a map of ~30 | PlanLines, PlanBoard, StrikeMap |
| The read | Beats it +9 / Works +3 / Walks into it -7, minus what the boxer does there with no plan | PlanFight.EDGE, ANSWERS, card_mean |
| Reads and pressure | a right answer that wins: +3.5 for the rest of the round (2 at most); pressure cuts the opponent's landed punches for the bout; a punished wrong answer costs tank for good (floor 70) | PlanRead, PlanPressure |
| Leaning | a right answer used past 2 times in a round keeps 70% a use | PlanRead.adjust |
| Lines held | 4 to 9 from the coach's rating | PlanBoard.arrow_limit |
| Coach's plan | written when the player writes none: one card (rating 50+) or two (70+), never wrong; measured 45.0 none / 52.8 / 57.2 / 69.0 a read plan (600 bouts) | CoachPlan |
| Tape and plan | each found tell names its situation and its best answer; locked tells say what opens them | PlanFile, OppFile, FilmEdge |
| Round pace | Push / Steady / Save per round; a slow starter pays a round-1 push +3 | PlanFile |
| Go-to | one own combination thrown more (40% of combination exchanges) while the tank throws it whole | OwnCombos |
| Test it | a camp spar night: 20 quick bouts, a range, where it breaks | GamePlan |
| Camp tray | the plan's cards on the pad nights, stamped "not usable by fight night" | PlanCards |
| Corner minute | change one line (a dropdown); set-up NOW into a gap | CornerJobsRow, CornerJobs |
| The Why | the plan graded against no plan; per-line record across bouts ("7 of 11 won, works") | FightWhy, PlanRecord |
| In the ring | "Plan (Mid range): Step back - it worked." on the round screen; a step opens the 3D exchange | PlanFight.arrow_line, ExchangeBeats |
| Switched off | FireLevel (fire by mastery), ReadBack (waited line, set-up, wait cost) | FireLevel, ReadBack |

Measured effect of the whole: a good plan 59.0 of 100 close bouts, none 45.8, a bad one 42.8 (plan_effect_probe, S396); +2.96 mean edge = +14 in 100 (FightWhy).

## 3. What the critics showed is thin, and the answer

| Thin (critic) | The answer | Section |
|---|---|---|
| The boxer's body never changes which answer is right (both) | Line grade from attributes | 4.1 |
| Drilling past Usable buys about 1 win in 100 (both) | FireLevel on, shares B | 4.2 |
| Five answers are never wrong; a line costs nothing; plan_bots rule 4 OPEN (tactics) | The price, and the five answers rewritten | 4.3 |
| Opponents never read your plan (both) | IF READ, with ReadBack on for opponents who adapt | 4.4 |
| A line cannot carry a round; no ahead/behind (both) | Rounds on lines | 4.5 |
| Own combinations never become lines; SPEED and DAMAGE tiles unused (coach) | Own chains as lines; SPEED wired, DAMAGE cut | 4.6 |
| The player cannot see where the fight goes; line count only from the coach (both) | Where the fight goes; lines brought (link to the week map) | 4.7 |
| The set-up only in the corner minute (tactics) | Arm it before the bout | 4.8 |
| NEXT says "drill it" in words (both) | On the pads / On the mornings buttons | 4.9 |
| The corner's change is a bare dropdown (tactics) | The line that lost most + two rated replacements | 4.10 |
| The Why praises a plan without a receipt (tactics) | A receipt per line | 4.11 |
| Templates ignore the boxer; one flat list of 14 (both) | "Fits Tess: 3 of 6", two for this game on top | 4.12 |
| Doubled views, empty panels (both) | Cuts | 4.13 |

## 4. The mechanics

### 4.1 HOW THEY DO IT: the line grade (NEW rule LineGrade, the corner calls' rule applied to lines)
- WHAT THE PLAYER DECIDES: which move to put on a place, knowing this boxer's grade on each; whether to train the attribute that lifts a grade, or swap.
- SCREEN: Fight plan (a chip on each line, in the line picker on every option, the swap hint), corner minute (on each replacement), Combos (own chains).
- WHAT IT CHANGES: each move names the two attributes it is done with; their mean grades it with the corner calls' lines (Exchanges.GOOD_AT 62, OK_AT 50).
  A plus is multiplied by the grade, a minus by COMMIT (code, as the calls: a wrong move done well costs more).

| Move (StrikeMap) | Done with | Move | Done with |
|---|---|---|---|
| Double jab, One-two | Accuracy, Speed | Step in | Footwork, Explosiveness |
| Double jab, cross (from outside) | Footwork, Accuracy | Step out, Step back | Footwork, Speed |
| Cross, hook; One-two-hook | Timing, Speed | Cut off, Herd | Footwork, Fight IQ |
| One-two-hook-cross (4 punches) | Speed, Stamina | Feint and draw | Fight IQ, Timing |
| One-two body hook; Body hook, head hook | Strength, Inside fighting | Pivot off the ropes | Footwork, Composure |
| Jab, uppercut, hook | Inside fighting, Explosiveness | Roll under and out | Defence, Flexibility |
| Slip, cross, check hook | Defence, Timing | Tie up | Inside fighting, Strength |
| Own chain | the mean of its moves' pairs | Push off | Strength, Durability |

  Grade on a plus [E]: Good x1.2, OK x0.85, Poor x0.35. On a minus: COMMIT Good x1.5, OK x1.0, Poor x0.6 (code). The ratio Good/Poor (3.4) is the calls'
  (1.0/0.3), so the swap is real: a Works line done Good (3 x 1.2 = 3.6) beats a Beats it line done Poor (9 x 0.35 = 3.2). OK sits under 1.0 so the
  all-OK amateur loses a little; PLANTUNE1 (section 7) gives it back in PlanFight.EDGE.
- SHOWN: "Tess does it: Poor (Footwork 47, Speed 52)". Hover: "Footwork 48 makes it OK, 72 makes it Good; two shadow mornings a week". Before the boxer is
  KNOWN (RPG map section 8), the chip shows the range the player has: "OK or Good".
- THE SWAP HINT: when a line on the same place is worth more because of the grade, one amber line under it: "Slip, cross, check hook also beats Jo pressing
  and Tess does it OK: +1.8 against -2.1. Swap". One click.
- REAL BASIS [R]: corners build the plan on what the boxer does well; a boxer with slow feet is not told to box on the back foot.
- LINKS: the week (mornings raise the attributes: Attrs.SESSION_ATTRS, shadow = Footwork and Accuracy); the RPG map (Known shows the grade as a range;
  the Fast hands versions THE FLURRY and THE SNAP multiply graded lines); the fight (PlanFight.value takes the grade); the coach's plan writes only lines
  graded OK or better (CoachPlan, so Coach stays safe).
- SEEN AFTER THE BOUT: the receipt names the grade beside a lost line ("Step back, Poor: 1 of 5"); the week review names a grade that crossed a line
  ("Footwork 48: Step back is now OK").

### 4.2 DRILLED LINES FIRE (FireLevel, built, switched on with shares B)
- WHAT THE PLAYER DECIDES: whether a pad place goes to taking a line from Usable to Sharp, or to another fighter's line, or to a new punch.
- SCREEN: Fight plan (a "Fires" column), the pad tray (each plan card shows its fire share and the day it reaches the next tier), the week review.
- WHAT IT CHANGES: a combination line fires on 1 use in 2 at Usable (30), 3 in 4 at Sharp (60), always at Signature (85); a use that does not fire is
  improvised (FireLevel.fires, LiveRound line 299). Steps and defences always fire: their quality is the grade (4.1). So THE PADS FEED COMBINATION LINES
  AND THE MORNINGS FEED STEP LINES: two dials, two parts of the week. Measured (FIRELEVEL1, shares B, 400 bouts): Sharp +2.8 wins in 100 over Usable,
  Signature +2.7 over Sharp; an all-Usable plan -4.3 against today. PLANTUNE1 brings an all-Usable, all-OK plan back within 2 of today's 41.3.
- SHOWN: "Usable 41: fires 1 in 2" and, when the week can reach it, "2 pad places: Sharp by Thu, fires 3 in 4". The plan cards in the pad tray carry the
  same words (PlanCards.dress).
- REAL BASIS [R]: under pressure a boxer throws what is automatic; half-learned combinations stay in the gloves.
- LINKS: the week (pad places, CLUBWEEK v4.1 section 4 prices "walk two plan lines" at 1 pad place); training (mastery 2.1 a pad hour, MoveMastery);
  the RPG map (Craft first: pad places teach x1.15).
- SEEN AFTER THE BOUT: the receipt says "fired 4 of 8 (Usable)"; the week review says "The draw reached Sharp: now fires 3 in 4".

### 4.3 EVERY LINE HAS A PRICE: lines compete (NEW rule LinePrice; PlanFight.ANSWERS rewritten for five moves)
- WHAT THE PLAYER DECIDES: safe or scoring, cheap or dear, on each place; this is the trade the tactics critic missed.
- SCREEN: Fight plan (two word chips per line), line picker (on each option), the bout's bill (the plan's sum: "3 safe, 2 score, 1 risky").
- WHAT IT CHANGES: three numbers per move family, charged by the exchange itself [E]:

| Family | Points: a won exchange counts on the round as | Gas a throw | Risk: the opponent's landed punches on a lost exchange | Chips |
|---|---|---|---|---|
| Leaves (Step back, Step out, Pivot off, Roll out, Push off) | 0.5 of a win; margin x0.5 | -0.5 | x0.8 | Safe, few points |
| Tie up | 0.5 of a win; margin x0.3 | -2.0 | x0.7 | Rests, few points |
| Feint and draw | 0.75; margin x0.7 | 0 | x0.9 | Safe |
| Jabs (Double jab, One-two) | 1 | +0.2 | x1.0 | Scores, cheap |
| Three punches (incl. Slip, cross, hook; Double jab, cross) | 1; margin x1.15 | +0.6 | x1.15 | Scores, costs gas |
| Four punches; Step in, Cut off, Herd | 1; margin x1.3 | +1.0 | x1.3 | Scores big, risky |

  "Counts on the round": Exchanges.round_of counts won exchanges; a won exchange of a safe line counts half (a 3-3 round still goes to the bigger margin).
  Gas adds to the round's cost (LiveRound lv["cost"]); risk scales the opponent's landed punches, so it reaches damage, knockdowns and the body map.
  THE FIVE ANSWERS THAT ARE NEVER WRONG (PlanFight.ANSWERS), each given one wrong game with its boxing reason:
  Double jab: wrong against loading up (the right hand over the second jab), ok (not best) against pressing. One-two: wrong against waiting to counter
  (the cross comes back to a counter). Double jab, cross: wrong against pressing (the presser is inside before the cross). Pivot off the ropes and Roll
  under and out: wrong against a tiring or hurt opponent (it gives them rest, as Step back already is). Gate: no move "best" in more than three games (a game and its refined
  variant count as one: waiting to counter and its last exchange; hurt and hurt but hitting back).
- SHOWN: two chips on each line ("Safe, few points"), the sum on the bill. Hover: the three numbers.
- REAL BASIS [R]: amateur judges score clean punches and dominance; moving away and holding win no round; volume costs the legs.
- LINKS: hype (ENTERTAIN on the bill naturally leans on Scores lines; HYPE1 decides); the judges with taste of the small living world (later) read points.
- SEEN AFTER THE BOUT: the receipt per line says what it bought: "Step back: held 4 exchanges, 2 counted"; the Why's AGAINST YOU names a round lost on
  safe lines ("Round 2: 3 exchanges won, all safe: Jo took it on punches").

### 4.4 THE OPPONENT READS YOU: IF READ (ReadBack switched on for opponents who adapt; R25's note; NEW slot on each line)
- WHAT THE PLAYER DECIDES: for each line, before the bout, one IF READ answer: BEHIND <another line> (thrown only after that line won an exchange this round;
  never waited for) or SWITCH TO <a second move on the same place>. Or nothing. In the corner minute the player can change it.
- WHO ADAPTS: an opponent whose file carries the tell ADAPTS (Fight IQ 60 or more [E]; about 1 in 3 amateur opponents [E], more among professionals), or a
  corner that shared a show card with you (CLUBWEEK v4.1 section 4 owns that trigger; this map only says what the ring does with it). The tell is hidden
  until the tape opens it, like any other ("?" on the file; the Ex-pro head coach's tell at booking can be this one).
- WHAT IT CHANGES (ReadBack, built): from round 2 the opponent waits for your MOST-WON line of round 1 (covered -0.5: thrown into the wait it counts as
  Walks into it). BEHIND: the set_up rule, full edge after a different line won this round. SWITCH TO: the second move takes the place's slot from
  round 2. While the opponent waits, your OTHER lines earn x1.25 (wait_cost: the corner looking for one thing sees the others late). Measured: a wait costs
  7.0 wins in 100 and no answer won back more than 3.7 (READBACK1-3). This map turns it on only if ADAPT1 shows the IF READ answer with wait_cost tuned
  wins back 5 or more of the 7 (week design v3: a rule that only takes points away is not built).
- SHOWN: on the file "Adapts: from round 2 waits for your most-won line" (found / "?"); on the plan an amber line under the line most likely to be read;
  in the corner minute the adapted note (R25, 14 words at most, replacing the coach's line): "Jo is waiting for The draw. Behind the One-two it still lands.";
  on the round screen "Plan: The draw, behind the One-two - it worked."
- REAL BASIS [R]: corners take away what works between rounds (the right hand over a lazy jab); the answer is to throw it behind a feint or change it.
- LINKS: the tape (the tell); the week (film: 2 pad places, CLUBWEEK); the RPG map (Ring general THE EYES finds answers alone; the Ex-pro's tell).
- SEEN AFTER THE BOUT: the receipt: "The draw: read from round 2; behind the One-two it won 3 of 4"; with no IF READ: "read from round 2: 1 of 5".

### 4.5 ROUNDS ON LINES (NEW rule PlanPhase; PlanFile's round habits and the round pace kept)
- WHAT THE PLAYER DECIDES: when each line lives: EARLY (round 1), MIDDLE (the rounds between), LATE (the last round), or all. LATE splits in two:
  IF AHEAD and IF BEHIND, each with a pace and up to two lines. Three rounds: R1 / R2 / R3. The four-round debut: R1 / R2-3 / R4. Six rounds: R1-2 / R3-4 / R5-6.
- SCREEN: Fight plan (round pips on each line; the ROUND BY ROUND strip: pace, the lines live, what the tape says of that round, the Legs forecast);
  corner minute before the last round (ahead or behind is the corner's own read of the cards, shown as the coach's word, changeable).
- WHAT IT CHANGES: a line counts against the lines brought (4.7) only in its own rounds, so a boxer who brings 4 can plan 6. Body lines early show
  "pays in R3" from the fight's own body cost (Exchanges.BODY_COST 1.2 energy a body shot for the rest of the bout). Ahead or behind: the corner reads its
  round count (Exchanges.round_of of the rounds so far); level counts as behind [E].
- REAL BASIS [R]: real plans are phased: bank the early rounds, invest in the body, take over late; amateur corners score rounds themselves (no open
  scoring) and say "you need this round".
- LINKS: the tape's round habits (slow starter: round 1; fades: the last round, PlanFile.HABIT_SIT); the Legs (CLUBWEEK: the tank at the first bell);
  pace (PaceAim, built); the hype map's ENTERTAIN sets the early pace.
- SEEN AFTER THE BOUT: the receipt per round: "R3, behind: Push and One-two-hook-cross: 4 of 6, round won".

### 4.6 YOUR OWN COMBINATIONS ARE LINES (NEW rule OwnLine; OwnCombos, ComboFlow kept)
- WHAT THE PLAYER DECIDES: how to build a chain for a job (feint first against a counter-puncher, step out last against a presser), then where it goes in
  the plan. The go-to stays (the combination thrown most), shown only once one is drilled.
- SCREEN: Combos (the chain's fit rows: Beats it / Works / Walks into it against each game, the same table as book lines; its place; its exposure),
  the line picker (own chains listed on the place their first punch is thrown from: a jab at long range, a hook,
  uppercut, body hook or a slip first at mid range; a feint or step before it is a cue), Fight plan.
- WHAT IT CHANGES: an own chain answers as a book line does, its fit read from what it is [E]: opens with a feint: Beats it against waiting to counter;
  ends on a step, slip or roll: never Walks into it against waiting to counter, Works against pressing; body first: Beats it against boxing at range and
  tiring; four punches or more: Beats it against tiring and hurt, Walks into it when our boxer is tired; EXPOSURE (the lab's SPEED tile: seconds from
  first punch to last) over 1.2 s: Walks into it against waiting to counter. Its fire share is its own pad mastery (OwnCombos), its grade its moves'.
  Its price is its punches' family (4.3); a step, slip or roll at the end lowers the risk to x0.9 (the chip "Safe exit").
  The flat go-to bonus stays for the chain named go-to. The lab's DAMAGE tile is cut (the bout's damage comes from landed punches; a second damage
  number would lie).
- REAL BASIS [R]: coaches build combinations for an opponent ("feint, double jab, then out").
- LINKS: the week (own chains are pad cards like any other); the RPG map (signature moves on the signing card); the fight (PlanFight.fit reads OwnLine).
- SEEN AFTER THE BOUT: the chain's own line in the receipt; its record across bouts (PlanRecord) shows in the Combos lab ("in bouts: 6 of 9").

### 4.7 WHERE THE FIGHT GOES, and THE HAND (NEW rule PlanWhere; the number brought is the week map's)
- WHAT THE PLAYER DECIDES: where to spend the lines the boxer brings.
- SCREEN: Fight plan (each place: "10 of 18 exchanges", rows sorted by it; places under 1 in 18 folded into "more places").
- WHAT IT CHANGES: nothing in the fight; it is the price list of the line budget. Before any test it is the opponent's style read through the fight's
  own rules (Exchanges.STYLE_MODES x PlanFight.GAME_CARD and LOST_CARD), marked "about"; after Test it, the test's own counts; after a bout, the bout's.
- THE HAND: CLUBWEEK v4.1 section 4: a bout takes 4 lines, a line left at home is not thrown in round 1 and plays at 80% after. Proposed to the week map
  (its call): the number brought comes from Fight IQ and bouts fought (3 under 50, 4 at 50-64, 5 at 65 or more, +1 after 10 bouts), so the fighter's
  head shows on the plan. Kept only if CARRY1 measures 5 lines against 4 at 1.5 wins in 100 or more; else 4 for all.
- SEEN AFTER THE BOUT: the bout's real counts replace the estimate on the next plan.

### 4.8 THE SET-UP ARMED BEFORE THE BOUT (CornerJobs set-up, built; the arming moves earlier)
- WHAT THE PLAYER DECIDES: which drilled combination waits for which gap, from round 1. The corner minute can still change it.
- SCREEN: Fight plan (one row under the go-to: "Set-up: Body hook, head hook when Jo drops the right"); corner minute (as today).
- WHAT IT CHANGES: the set-up and its NOW shout exist from the first bell, not only from round 2 (CornerJobs.setup_edge, built). Kept only if SETUPARM1
  measures 1.5 wins in 100 over arming it in the first corner minute.
- SEEN AFTER THE BOUT: the receipt: "Set-up: fired twice, landed once (round 1)".

### 4.9 FROM THE PLAN TO THE WEEK: two buttons (PlanCards.drill_it, built; the week map's prices)
- ON THE PADS: on every combination line under Sharp, on the Why's NEXT, and on the receipt. It puts the card on the next pad night, priced in pad
  places as CLUBWEEK v4.1 prices them, and says what it buys: "2 pad places: Sharp by Thu, +2.0 a use".
- ON THE MORNINGS: on every line graded Poor or OK where an attribute decides it: it puts the session that trains it on two mornings ("Footwork: 2 shadow
  mornings; Footwork 48 in about 3 weeks"). The week owns the mornings; the button only places them.
- SEEN AFTER: the week review names what it moved.

### 4.10 THE CORNER MINUTE'S CHANGE, rebuilt (CornerJobsRow; PlanFight.corner_options kept as the source)
- SHOWN: the line that lost most this bout with its tally ("Step back 1 of 4"), the game the opponent showed that round, and the two best replacements
  on that place rated against it (read, grade, fires, one click each). The IF READ answer of a read line is already firing; the note says so. No dropdown.

### 4.11 THE RECEIPT: the Why per line, and the week review (FightWhy, PlanRecord)
- THE WHY gets one row per line thrown: won of thrown, exchanges gained over improvising (the plan_swing already counted per exchange), grade, fired of
  wanted, read or not, behind what; with KEEP, CHANGE (opens the Fight plan on that line) and ON THE PADS / ON THE MORNINGS. A loss with a good plan
  says in the same line what lost it (the tank, a cut, the opponent's stats: FightWhy's lost cause, built).
- THE WEEK REVIEW names a line that reached Sharp and a grade that crossed a line.

### 4.12 REAL PLANS THAT FIT, and saved plans (PlanTemplates)
- Real fight plans show "fits Tess: 3 of 6 lines OK or better"; the two made for this opponent's game sit on top, the rest folded. Loading writes only
  lines the boxer can throw (as today) and marks Poor ones.
- SAVE PLAN: a plan saved by name per fighter (three slots). Convenience, not a mechanic: it moves no number, so the cut rule does not apply.

### 4.13 CUTS AND TIDY
- "Open the map" and "See the flow" become one MAP (the Flow, with round phases and the IF READ arrows). Escapes fold into Moves (agreed).
- The empty "Hover an answer and it plays here" panel becomes THE LINE (the evidence: section 5). The body playing the move moves into the line picker.
- RATE AGAINST is hidden when a bout is booked (the plan is rated against the booked opponent only); kept for "no bout: try each kind of opponent".
- The GO-TO row is hidden until an own combination is drilled. The combo lab's DAMAGE tile is cut; SPEED becomes EXPOSURE.
- "Answer: <best>" stays, ranked by worth (read x grade x fires), not by the read alone, so it cannot play the page for the player.

### 4.14 THE COACH IN THE PLAYBOOK (the owner's ask names the coach; all of this is built or in the RPG map, gathered here)
- How many lines the plan holds: the coach's rating, 4 to 9 (PlanBoard.arrow_limit); Craft first, the RPG map's style, holds one more.
- The plan Coach writes when you write none: one or two cards, never wrong (CoachPlan), now only lines Tess does OK or better (4.1). The page prints
  YOUR PLAN AGAINST COACH'S as one number, so the player always sees what their own reading is worth.
- How fast lines reach Sharp: a pad hour teaches x(1 + 0.40 x the coach's skill / 100) (MoveMastery.gain): Reid (58) x1.23, Hale (74) x1.30, so a
  better coach moves the Fires column sooner.
- What the coach sees: the Ex-pro head coach opens one tell at booking (it can be ADAPTS); the RPG map's EYE FOR TAPE answers two film questions.
- In the ring: the corner minute's change and the adapted note are the coach's voice; a Low-mood fighter takes in less of it (FighterProfile.trust).

## 5. The key screen: Fighter page > Fight plan (drawn: playbook_v2.png)

Graphics first; every word on screen has an action or a number behind it. Drawn: Tess Reilly (Fight IQ 59, Footwork 47, Speed 52, Accuracy 58,
Timing 57, Defence 58, Stamina 64; drawn numbers) against Jo Marsh, a counter-puncher who adapts.
- HEAD: name, the four faces, "Sat 25 Apr, 5 days vs Jo Marsh, Hull ABC, counter-puncher, 7-2".
- THE PLAN FOR JO (left): "Tess brings 4 a round (Fight IQ 59) - Coach holds 6 - 5 written - 2 score, 2 safe, 1 risky". One row per line: where and
  when with "10 of 18" as a bar, the line (book or own) with its IF READ answer or its note under it, the round pips, the read chip, "Tess does it"
  with the two attributes, Fires with the tier, the two price chips, the worth a use (red when worse than improvising). Coloured lines between rows:
  Jo adapts (amber), the swap hint (red), the lines written but not brought, with "+ Write a line".
- The rows drawn: Jo waits to counter: THE DRAW (own chain: feint, double jab, cross, step out), R1-R2, Beats it, OK, Usable 41 fires 1 in 2, Scores +
  Safe exit, +4.0. At long range: One-two (if read: switch to Double jab), all rounds, Beats it against boxing at range, OK, Sharp 66 fires 3 in 4,
  Scores + Cheap, +2.7. At mid range: Step back, Poor (Footwork 47, Speed 52), always, Safe + Few points, -2.1, with the swap to Slip, cross, check hook
  (+1.8). Jo tires: One-two-hook-cross, R3 only, Sharp 62, Scores big + Risky, +3.3. Feint and draw from outside +0.7; Body hook, head hook left at home.
- ROUND BY ROUND (under the plan): R1 and R2 cells (pace, the lines live, what the tape says); R3 is the corner's call: IF AHEAD Save, IF BEHIND Push
  with the Legs forecast ("Legs 61 throw it whole").
- RIGHT COLUMN: JO'S GAME (the file: each found tell with the line that answers it, Adapts, "?" weakness with Book film); THE LINE (the evidence of
  the selected line: the read, the grade, the boxer with no plan there, the fire share, waited for or behind, the worth; then what moves it, with On
  the pads; the exposure); AFTER THE LAST BOUT (the receipt: three rows, Keep / On the mornings).
- BOTTOM: "Your plan against Coach's: +6 to +9 in 100" (the same number as CLUBWEEK's bill: BoutRead on the coach's plan against this one), and the
  buttons Real plans (2 fit Tess), Map, Save plan, TEST IT (Thu spar, 2 left).

Example numbers on the drawing: worth a use = fire share x (read x grade - the boxer with no plan there); the boxer with no plan is read from today's
table (PlanFight.card_mean). The draw against the counter game: (9 x 0.85 + 0.4) x 0.5 = +4.0, and +6.0 at Sharp (x0.75). One-two against boxing at
range: (9 x 0.85 - 4.0) x 0.75 = +2.7. Step back against pressing, Poor: 9 x 0.35 - 5.25 = -2.1 (Tess improvises better there). One-two-hook-cross
against tiring: (9 x 0.85 - 3.25) x 0.75 = +3.3. Feint at outside: 9 x 0.85 - 7.0 = +0.7 (Tess already does well there with no plan).

## 6. Every menu it appears on, and what each is wired to

| Menu | What it shows | Wired to |
|---|---|---|
| Fighter page > Fight plan | lines with where (x of 18), round pips, read, grade, fires, price, worth, IF READ; amber hints; round strip; Jo's game; THE LINE; receipt; plan against Coach's; Test it | GamePlan (split: GamePlan.gd is 499 lines, so new GamePlanTable, PlanEvidencePanel, PlanRoundStrip, OppGamePanel), PlanLines, PlanFight, new LineGrade, LinePrice, PlanPhase, PlanWhere, OwnLine, FireLevel, ReadBack, PlanFile, BoutRead |
| Line picker (popover) | every move and own chain on the place, each with read, grade, fires, price, worth; the body plays it | PlanLines.options, LineGrade, LinePrice, OwnLine, MoveTip |
| Playbook > Combos | own chain: fit rows against each game, its place, EXPOSURE, gas, Usable/Sharp and fire share, record in bouts; Put in the plan | ComboBuilder, ComboStrip, OwnCombos, ComboFlow, new OwnLine, PlanRecord |
| Playbook > Moves | Escapes folded in; each move's two attributes and the boxer's grade | MoveBook, LineGrade |
| Fight prep > What your plan should answer | each found tell with its answer, the boxer's grade on it, and the Adapts tell | PlanFile.rows, LineGrade, OppFile |
| Bout page: the bill | bring 4 (week map), the plan's price sum, "Adapts" chip on the file, plan against Coach's | CLUBWEEK FightWeek, PlanLines, LinePrice, BoutRead |
| Club week / Week: pad tray and mornings | each plan card: fire share and Sharp-by day; a morning placed by ON THE MORNINGS marked with its line | PlanCards.dress / drill_it, PadWeek, WeekPlan |
| Fight night: round screen and 3D caption | "Plan: The draw, behind the One-two - it worked"; "read" | PlanFight.arrow_line (extended), ExchangeBeats |
| Corner minute | adapted note (R25); the line that lost most, two rated replacements; ahead/behind call before the last round; set-up | CornerJobsRow, PlanFight.corner_options, ReadBack, PlanPhase |
| Result > the Why | the receipt per line with Keep / Change / On the pads / On the mornings | FightWhy, PlanRecord, PlanCards.drill_it |
| Week review | "reached Sharp: fires 3 in 4"; "Footwork 50: Step back is now OK" | WeekReview rows, FireLevel, LineGrade |
| Opponent file / rival file | Adapts tell (found or "?") | OppFile, TapeClips |

GOLDEN PATH (tests/playbook_path_test.gd, Grok Dev): write a plan; see a Poor grade and take the swap; press On the pads; the week takes a line to Sharp;
fight an opponent who adapts; read the adapted note in round 2; the IF READ answer fires; read the receipt in the Why; press Change.

## 7. Probes and the cut rule

The cut rule: a choice that moves less than 1.5 wins in 100 over a season (the three boxers' bouts in a year, about 24) is cut, not kept as decoration.
Every probe runs the played bout (LiveRound, as plan_effect_probe), 400 paired bouts a cell, at least three opponents of different styles, never two
identical fighters (the FIRELEVEL1 limit: one opponent, one plan).

| Probe | What it must show | If not |
|---|---|---|
| PLANTUNE1 | with grade and FireLevel on, a well-read plan stays 15 or more over none; an all-OK, all-Usable plan within 2 of today's 41.3 | retune PlanFight.EDGE before anything else ships |
| LINEGRADE1 | a Poor Beats it loses to a Good Works in 55 of 100 close bouts; a bot that swaps by grade beats one that ignores it by 1.5 a season | grade shown as a word only, no multiplier |
| FIRELEVEL2 | Sharp over Usable 2.5 or more and Signature over Sharp 1.5 or more on three opponents; a pad place to Sharp worth 1.5 a season | shares back to A, or off |
| LINEPRICE1 | plan_bots rule 4 PASS (+0.08); no move best in more than 3 games; each price family changes 1.5 in some matchup | price chips cut to the read alone |
| ADAPT1 (READBACK4) | adapters cost a plan with no IF READ 5 to 8; IF READ with wait_cost tuned wins back 5 or more of 7; over a season with 1 in 3 adapters the answering player +1.5 | ReadBack stays off; the tell is cut |
| PHASE1 | a phased plan (body early, finish late) beats the same lines all rounds by 1.5 against a fader; ahead/behind beats one last round by 1.5 in close bouts | phases kept for pace only |
| OWNLINE1 | a chain built to the rules beats the best book line on its place against its game by 1.5; a badly built chain loses | own chains stay go-to only |
| CARRY1 (week map) | 5 lines brought against 4 differ by 1.5 | 4 for everyone |
| SETUPARM1 | arming before the bout beats arming in the first minute by 1.5 | arming stays in the corner minute |
| PLANSEASON1 | a careful player against "Coach's plan" over a season: +5 or more | the plan is not the star; stop and rethink |

## 8. Rejected, and why

- The opponent's own plan drawn as lines (coach critic): the file's tells ARE the opponent's plan (PlanFile.rows maps each to a situation); drawing it
  again is a second view of the same thing. Kept as JO'S GAME with "answered" chips.
- A Plan B line AND a set-up line on every line (both critics, separately): one slot, IF READ, holds either. Two slots double the page for one decision.
- Scaling each line by every 10 points of an attribute (tactics critic): three grade bands with a line to cross (Good from 62) give the player a target
  ("Footwork 48 makes it OK") and match the corner calls; one word per concept.
- Every opponent adapting: a rule that only takes points away is not built; adapters are the ones with the tell (1 in 3), and the answer pays back.
- Copying a line to another fighter: the grade and the drill level are per boxer, so a copied line is a different line; the picker already lists it.
- Templates known by the coach's style (coach critic): hides real plans the player can learn from; left for later with the RPG layer.
- Score-state rows for every round: only the last round splits; in a 3-round bout a round-2 split comes too late to read and too early to matter.
- The combo lab's DAMAGE tile wired to the body map: a second damage model beside landed punches; cut.
- An aim (head or body) per line: the shout bar's Aim already does it for the round; a second aim would fight the first.
- A per-line Entertain dial: the hype map's bill choice is plan-wide; the price chips give it something to read.

## 9. THE PLAYBOOK FOR THIS VERSION

Kept as built: lines on places and situations, the read table (five answers rewritten), reads, pressure, the tank cost, the coach's plan, the tape's
tells, round pace, the go-to, Test it, the camp tray, the per-line record, the Why's grade, the corner's set-up.
Switched on: FireLevel (shares B), ReadBack for opponents who adapt (if ADAPT1 passes).
New: the line grade; the price; IF READ; rounds on lines with ahead/behind in the last; own chains as lines; where the fight goes; the set-up armed
before the bout; On the pads / On the mornings; the corner's rebuilt change; the receipt; real plans that fit; saved plans.
Cut: Open the map (one Map), Escapes as a tab, the empty hover panel, Rate against when booked, the empty go-to row, the DAMAGE tile.
Build order: PLANTUNE1 and LINEGRADE1 first (they move every other number); then LinePrice with LINEPRICE1; then FireLevel on with FIRELEVEL2; then IF
READ with ADAPT1; then PlanPhase, OwnLine, PlanWhere; then the Fight plan screen split and rebuilt from playbook_v2; then the corner minute, the Why and
the week review; the golden path last. Pure modules and probes go to Qwen and Goose; the screens to Cursor (Claude checks the stills); the golden path to
Grok Dev.

## 10. LEFT FOR LATER

- Ana's mat book (the game tree): the same price-per-move and the-opponent-adapts checks, with its own critic.
- Rival gyms that study your fighters across bouts (the small living world); judges with taste reading the price's points.
- Templates known by the coach's style (RPG layer); a plan library shared across the club.
- Opponents' own written plans in the professional ladder (a promoter's opponent with a known corner).

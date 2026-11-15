# FIGHTFILM1 - the fight analysis page, the live fight log, and film nights that unlock tells (S495, 2026-11-15)

Design only; nothing here is built. Owner's ask (S494, verbatim): "yes design the fight analysis page , it could be used for
the film to make the player try to unlock the tells of the opponent ? also do you think that a window that describe the
action like that would be a good addition ?"

His reference: a web app's breakdown of one fight. The video on the left; a list per fighter of every strike with its time,
hand, type, target and result (click a line, the video jumps there); a "Show me" filter; a report per fighter (stance and
strike-type pies, landed against thrown, plain summary sentences); a Combinations table with timestamps; a Vulnerabilities
table ("right hook -> dropped right hand, 6 times", each time clickable). For us: boxing only, no kicks.

**Answers to his two questions.** Yes to both, with one rule each:
- The page is how film works. A film night opens one of the opponent's past bouts on this page. The player reads the punch
  list, filters it, and names a pattern ("after her jab, her right hand drops"). The coach checks it against the tape. If
  it holds, it goes in her file as a tell. If the player reads wrong, it goes in her file wrong, and the bout shows it.
  Reading her is the player's skill; the coach can still watch for you (one tell, like today).
- The live log is worth adding as a window the player opens and closes, OFF by default (the fight screen is already
  full). It is the same list the page reads, line by line as the round plays: "0:44 Jab to the head - blocked".

Our own bouts get the same page after the fight. That fits his result-page ruling (S440, "Yes, fight only": the fight and
what it decided, at simulator depth).

Labels: **CODE** = in the game today (file named). **NEW** = this design. **P** = a proposed number, tuned in play.

---

## 1. Where the data comes from (traced in the code, S495)

| What the page needs | Where the game has it today | Gap |
|---|---|---|
| The round as six 30-second exchanges | CODE `scripts/state/LiveRound.gd` writes one record per exchange on the round (`exchanges`): her game that exchange (`mode`), the situation (`sit`), our call and whether it was heard, punches landed `[ours, hers]`, body shots, who won and by how much, place in the ring, the best move each side had (`a_best`/`b_best`), her habit and whether it was fixed, the read (`read`) | none |
| Every punch: clock, who, which punch, result, how it was stopped | CODE `scripts/fight3d/ExchangeBeats.gd` + `scripts/rules/RoundScript.gd` build beats `{t, who, move, result, def, big, read}` from each exchange record: about 9 punches or steps a side per exchange, the punch from her mastery (`PUNCHES`: jab, cross, lead hook, body hook, rear uppercut), how it was stopped from the other's defence (`def`: block, slip...), her habits rewritten into the beats (`scripts/rules/HabitBeats.gd`, fires `{who, habit, t}`) | **Built only in the 3D view, never stored.** A skipped or read-in-words round has no punch list. NEW: build the beats once when the exchange settles and store them on the record (`x["beats"]`, the habit fires in `x["fires"]`); the 3D ring plays the stored beats instead of building its own. One truth: a round watched, read or skipped logs the same (as `FightStats` already does for numbers). |
| The fight in numbers | CODE `scripts/rules/FightStats.gd` (landed, head, body, exchanges won, the tank, calls used and won, her games and how we did against each) | none: the report reuses it |
| Why it went that way | CODE `scripts/rules/FightWhy.gd` (plan grade, against, next) | none |
| The opponent's past bouts | CODE `scripts/rules/RivalPast.gd` keeps each bout as one row `{d, vs, vs_club, win, how}` | **No exchanges, no punches.** NEW `FilmBout.gd`: makes the whole bout again from her real profile, the same way every time (seed = her id + the bout's day): her games in her style's mix (`Exchanges.STYLE_MODES`), her habits fired on their real triggers, her best weapon thrown most, the result matching the row (won on points, stopped in 2...). Then the same beat builder. |
| How many films a coach can find | CODE `scripts/rules/ModeTells.gd` `films(bouts)`, capped at `MAX_FILMS`; a debutant has no tape (`FilmTruth.locked`, `OppFile.has_tape`) | none |
| Her tells and their answers | CODE `scripts/rules/OppFile.gd` `tells(opp)`: look and style free; then best weapon, two of her games (`mode:` with how often film shows them), each habit (7 habit words, `HABIT_WORDS`), weakness; each names its answer (a plan situation, a corner call or a drill) | none |
| How sure a seen tell is; the corner minute confirming or clearing it | CODE `scripts/rules/FilmTruth.gd`: states hidden / seen (sure 70%) / looked again (90%) / confirmed / false; `check_minute` confirms or clears a seen tell at the first corner minute where her game came up (a fade at round 2) | **Built, wired nowhere.** This design is its first use. |
| Film nights in the fight week | CODE `scripts/state/FightWeekPlan.gd` + `scripts/rules/FilmSeats.gd`: 2 coached film nights a week (+1 with a full-time coach), first come first served across boxers; over the count the boxer watches alone and finds nothing; a coached night opens the next tell in tape order | The night opens a tell with no player in it. NEW: the player may watch it himself (section 3). |
| What a found tell is worth | CODE `scripts/rules/FilmEdge.gd`: each found tell her plan answers adds `BoutRules.FILM_PER_ANSWER` on the night, up to `FILM_EDGE_MAX`; `scripts/rules/TheRead.gd`: with film, our boxer needs a fifth fewer looks to read her habit and her main habit starts part-read | none |
| The 3D film of a past bout | CODE `scripts/fight3d/TapeFilm.gd`: plays a beat list on our ring with the ringside camera, `tick(t)` to jump | Plays short clips today; NEW: plays a whole stored bout and jumps to a clicked line |

---

## 2. The page: FIGHT ANALYSIS

One scene, two uses: **her tape** (a film night, one of her past bouts) and **your bout** (after the fight, and from
History). Same layout, same words. Mockup: `docs/mockups/s495/fight_analysis/fight_analysis.png` (her tape, mid-night).

### 2.1 Layout (1920x1080, the wood frame and slate cards)
- **Header**: the bout in one line (names live here and only here, S448): "<her name> vs <the other> - club show, Mar 2026
  - won on points". Film night only: the night's state on the right: "Film night 1 of 2 - coach checks left: 2 of 3".
- **Left, the film** (TapeFilm on our ring, ringside camera): play / pause, 1x / 2x / 0.5x, the round and clock; a timeline
  under it with a tick for every line the filter shows, in the corner colour (blue = her, red = the other: on her tape she
  wears blue, as against us). Click a tick or a line: the film jumps there and plays from 2 seconds before.
- **Middle, THE PUNCHES**: one list for both corners, newest last, each line: clock, round, a corner dot, the hand, the
  punch, the target, the result and how it was stopped. "R2 0:44 - lead jab to the head - blocked". The situation of the
  exchange sits as a thin divider every 30 seconds ("She walks you down" / "She boxes at range"), from the record's `mode`.
  Her habit fires show as their own lines in the warning colour: "R2 0:45 - right hand drops". Above the list, **SHOW ME**:
  Corner (Her / The other / Both), Hand (Lead / Rear / Any), Punch (Jab / Cross / Hook / Body hook / Uppercut / Any),
  Result (Landed / Blocked / Missed / Any), Round (1 / 2 / 3 / All), Her game (any of the four). The count of shown lines
  and "landed x of y" update with the filter.
- **Right, THE REPORT** for the corner picked (tabs: Her / The other): punches thrown and landed by type (paired bars,
  never pies: a bar reads in one look), head against body, landed share by round (her fade shows here), her games by share
  of exchanges, her most thrown combinations with the times (click one, the film jumps), and three plain sentences made
  from the numbers ("Her most thrown punch is the jab.", "She lands more in round 1 than in round 3.", "She goes to the
  body only when she walks you down."). On her tape the sentences say only what the numbers show; they never name a tell
  (that is the player's job, section 3).
- **Bottom right, MARK A PATTERN** (her tape only): two pickers, WHEN and THEN, and the buttons **Check it with the coach**
  (spends one check) and **File it** (once checked). Below: the patterns marked tonight with their results.
- **Your bout** (after the fight) swaps the pattern box for **WHAT DECIDED IT** (the Why's three lines, CODE FightWhy) and
  **WHAT A SCOUT SEES ON THIS TAPE**: your boxer's own habit fires in this bout ("Drops the right after the jab: 4 times")
  with a button **Fix it on the pads** (CODE HabitFix / pads drill). This is display only in v1; rivals filming us is a
  small-living-world item, not this build.

### 2.1b Checked against a pro video-stats product (S495, operator's reference: Jabbr DeepStrike, design reference only)
A pro product counts per fighter per round: landed against HIGH IMPACT (clean, visible effect) against thrown; pressure
and aggression as a share of the round; the distance each punch came from; a landed-quality and a power-commit spread;
combinations (accuracy by length, singles against combos, combination trees); and a predicted chance each round goes to
each fighter on the judges' cards, with knockdowns. What our sim knows, and where each goes:
| Their stat | Our sim (CODE) | On the page |
|---|---|---|
| High impact against landed | Each exchange's decisive shot is a `big` beat (with `knockback` on a dominant one); a set-up that lands and a read that lands are damage (LiveRound, `damage`) | REPORT: a third bar per punch, "clean" inside "landed" inside "thrown". SHOW ME > Result gets "Clean". Supports the best-weapon tell: "her cross lands clean 4 times, her jab never" |
| Distance of each punch | The exchange's `place` (outside, long, mid, inside, clinch, ropes): each punch takes its exchange's place | SHOW ME > Range. REPORT: landed by range for both corners. Supports the game tells ("she lands at long range, never inside") |
| Pressure / aggression share | Her game per exchange (`mode`, walks you down = pressing), who steps in (`step_in` beats), PlanPressure on our side | REPORT: "Pressing: 6 of 18 exchanges" per corner (shares, not a new number) |
| Combinations, singles against combos, accuracy by length | Beats carry the combination (BurstShape / Combos) | REPORT: Her combinations gets singles against combos and landed share by length (1, 2, 3+) |
| Round-score chance on the judges' cards | NOT a prediction for us: the three judges score every round from the exchanges with no dice (`scripts/rules/Judges.gd`, one reason a card) | A ROUNDS STRIP above the report: each round's three cards with the reason on hover, knockdowns marked. Her film: "she lost round 3 on all three cards" backs a fade tell. Your bout: the same strip the result page has. Live: the corner minute may show "the cards so far" (P, later) |
| Landed-quality and power-commit spreads, stance and balance around each punch | Not in the sim: the 3D view never decides, so a per-punch quality or balance would be a made-up number | Left out on purpose |

### 2.2 Buttons and what each changes
| Button | Changes |
|---|---|
| A line / a tick / a combination's time | The film jumps there (no game state) |
| SHOW ME pickers | What the list, the ticks and the counts show (no game state) |
| Her / The other (report tabs) | Whose numbers the report shows |
| Check it with the coach | Spends one check of the night; shows "x of n" and the coach's word (section 3.3) |
| File it | Writes the pattern into her file as a seen tell, sure from the evidence; it shows on her file, the Fight prep tab and the Playbook as an answerable situation |
| Next film (when she has more than one and the night has checks left) | Loads her next past bout; checks carry over |
| Done for tonight | Closes the night; unused checks are lost |
| Your bout: Fix it on the pads | Puts the habit-fix drill on her next pad evening (CODE pads tray) |

---

## 3. The film game: unlocking her tells

### 3.1 The night (NEW, P)
A film night stays an evening card in the fight week (CODE FilmSeats, 2 coached nights a week, +1 with a full-time
coach). When the clock reaches it, it stops on it (a new stop, the way the clock stops on the weigh-in) and asks one thing:
- **Watch it with the coach** - the page opens on her newest film. The night holds **3 coach checks** (P; 20 of the
  coach's 60 minutes each). Filters and the film are free and unlimited.
- **Let the coach watch** - today's behaviour, unchanged: the next tell in tape order opens, seen at 70% (CODE).

So a player who skips the page never loses what he has today. A player who reads well can find up to three tells in one
night, against the coach's one, and choose which (a habit the plan can punish, not the weakness the coach would open last).
Over the coach's seats (CODE: she watches alone) the page still opens, but with **no checks**: the player may still File a
pattern from his own reading, at **50%** (P, "your own read, the coach has not seen it"). This changes the S485 rule
"alone opens no tell" from nothing to a weak, unchecked tell; it is the only rule this design changes.

### 3.2 What can be marked
WHEN (her side of it): her jab / her cross / her hook / her combination lands / she is hurt / the last 30 seconds of a
round / round 1 / the other walks her down / a body shot lands on her.
THEN (within 2 seconds, or for the time windows, over them): her right hand drops / she lunges in / she stands and admires
/ she goes to the body / she loads up wild / she throws less / she loses the exchange / the other's counter lands.
9 x 8 = 72 claims. Her file holds at most 7 or so real ones (weapon, two games, her habits, weakness). Each real one maps to
exactly one claim (table in 3.5). Guessing three of 72 finds nothing; reading the list tells you where to look.

### 3.3 The coach's check (NEW, P)
A check counts the claim over the film: **k** = times THEN followed WHEN; **n** = times WHEN happened; **rest** = how often
THEN followed anything else of hers. The coach's word, from the counts:
- **"That's her."** k >= 3 and the rate after WHEN is at least 3 times the rest's rate -> File it at **70%** (CODE
  `FilmTruth.SEEN_TRUE`).
- **"Maybe. Watch another."** k = 2, or the contrast is under 3 times -> File it at **50%**, or check it on the next film.
- **"Nothing there."** k <= 1 -> nothing to file; the check is spent.
The same claim checked "That's her" on a second film goes to **90%** (CODE `LOOKED_TRUE`, "look again").

### 3.4 False patterns, and how the truth comes out
The film is her real profile plus the fight's own chance (who blocks, who misses). So a short film can show a claim that is
not in her: three of her crosses miss after body shots, by luck. The coach's word follows the counts, not the truth, so a
false claim can be filed at 50% or even 70%. That is the risk the player carries, and it is real-world honest: one film is
one night of her, and a second film is the cure.
- In the bout the corner minute settles it (CODE `FilmTruth.check_minute`): at the first corner minute after the claim's
  situation came up (a fade or a slow start at round 2), the card says **CONFIRMED** ("Her right drops after the jab - you
  saw it right") or **CLEARED** ("She does not drop it - change that line"). The truth is the claim matching a real tell
  in her file, never a dice roll (`FilmTruth.truth`'s roll is not used for filed claims).
- What a false tell costs: the plan line written on it answers nothing, so it scores as no plan in those exchanges (CODE
  PlanFight neutral) and the corner minute spends one of its two instructions to change it, or the line keeps wasting
  exchanges. A wrong read is a lost line and a lost corner instruction, never a hidden penalty.
- What a true tell earns: everything a found tell earns today (CODE FilmEdge power on the night when the plan answers it;
  TheRead: fewer looks for our boxer to read the habit), plus the CONFIRMED line, and it stays in her file for a rematch
  (CODE `OppFile.remember`).

### 3.5 Which claim is which tell (the build's table)
| Her tell (OppFile) | The claim that finds it |
|---|---|
| Habit "Drops the right after the jab" | her jab -> her right hand drops |
| Habit "Lunges in behind the jab" | her jab -> she lunges in |
| Habit "Stands and admires after a combination" | her combination lands -> she stands and admires |
| Habit "Goes to the body when hurt" | she is hurt -> she goes to the body |
| Habit "Loads up wild when hurt" | she is hurt -> she loads up wild |
| Habit "Hands drop late in a round" / weakness "fades" | the last 30 seconds -> she throws less |
| Habit "Takes a round to get going" / weakness "slow to start" | round 1 -> she throws less |
| Her game "walks you down" / "boxes at range" (mode tells) | read from the report (her games by share): filed from the report with **File it** at 70%, no check needed, same as the coach's free style word today |
| Best weapon | read from the report (her most landed punch): filed the same way at 70% |
| Weakness "body" | a body shot lands on her -> she throws less |
| Weakness against pressure | the other walks her down -> she loses the exchange |

The rest of the 72 claims are noise. A claim the table does not hold is never true.

### 3.6 Why this is deep enough (the trade-offs)
- Three checks against 72 claims: where to spend them is the decision. The free filter is the clue; the coach's minutes
  are the cost.
- Watch yourself (up to three tells, your choice of which, the risk of a false one) against the coach (one tell, safe, in
  his order).
- File at 50% now, or spend tomorrow's film night on a second film to reach 90%. The fight week has seven evenings; a film
  night is a night not on the pads or sparring (CODE fight week).
- Two boxers fighting the same week share the coach's seats (CODE FilmSeats): a second boxer's film is watched alone.
- A confirmed read pays in the ring; a false one costs a line and a corner instruction, and the player sees which.

---

## 4. The live fight log (NEW)
- A **Log** button on the fight screen's bottom bar (and the key L) opens a narrow panel on the right edge, under the
  scores; closed by default, and the choice is remembered in Settings (Show the fight log: Off / On).
- One line a punch, newest at the bottom, the last 8 visible, older ones fade: a corner dot, the clock, the line. "0:44
  Lead jab to the head - blocked". Habit fires in the warning colour; the corner's shout and the call's verdict (CODE
  ExchangeBeats captions) as grey lines, so the log and the corner bubbles say the same thing.
- It reads the stored beats (section 1), so in a skipped round it fills at once, and in the words view it is the round's
  lines. It is the same list the analysis page reads: no second source.
- No names in the lines (S448): the dot and the corner colour say who.

## 5. Our own bouts
- **Result page**: a fourth tab **Punch by punch** beside the exchanges, the numbers and the plan (CODE ResultTabs). It
  opens the page in "your bout" mode on the whole fight.
- **Fighter page > History**: each bout row gets **Analysis** (bouts fought before this ships have no stored beats: the row
  says "no tape kept").
- **Corner minute**: **The round so far** opens the page on the rounds fought (read only, no pattern box), then back to
  the corner (P; the corner card already has the fight in numbers, CODE MatchStats compact).
- Keeping tape: the gym keeps the last 20 bouts' beats (P; about 160 lines a 3-round bout); older rows say "no tape kept".

---

## 6. Every menu the mechanic appears on, and what each is wired to (owner S425)

| Menu | What it shows | Wired to |
|---|---|---|
| Fighter page > Fight prep | "Watch the tape" (today opens the Tape Room) opens the page on her newest film outside a film night: free to watch and filter, no checks; WHAT YOUR PLAN SHOULD ANSWER lists each tell with its state (70% / 90% / CONFIRMED / CLEARED) and where it was seen ("film 2, R2 0:44", click opens the page there) | FightAnalysis (film mode, no checks); OppFile + FilmTruth state per tell |
| Fight week > the Film evening card | The card says Coached / Alone (CODE); on the night the clock stops: Watch it with the coach / Let the coach watch | FightWeekPlan film night -> FightAnalysis (3 checks) or the CODE auto tell |
| FIGHT ANALYSIS (new) | Section 2 | FightLog (lines), FilmBout (her past bouts), FilmPattern (checks, filing), FightStats (report), TapeFilm (film) |
| Rival file (World > Rankings, modal) and HER FILE card (bout offer, Camp, fight night) | Each tell's state and %; a filed claim carries its evidence on hover ("5 of 7 jabs, film 1") | OppFileCard reading FilmTruth states |
| Playbook > Game plan | A line written on a tell shows its % ("on a 70% read"); a CLEARED tell's line is marked "change this line" | PlanLines + FilmTruth state |
| Fight screen (3D and words) | The Log button and panel (section 4) | FightLog over the stored beats |
| Corner minute | CONFIRMED / CLEARED line for each filed tell whose situation came up; The round so far | FilmTruth.check_minute; FightAnalysis (read only) |
| Result page | Tab Punch by punch | FightAnalysis (your bout) |
| Fighter page > History | Analysis on each bout row | FightAnalysis (your bout) over the kept beats |
| Settings | Show the fight log: Off / On | the fight screen's Log default |
| Tape Room (CODE TapeRoom) | Retired when this ships: its films and SPOT become this page and its checks (one film screen, not two); its YOUR ANSWER pick moves to the File it step ("Write the answer" opens the Playbook line) | - |

Golden-path test (one, end to end): test club boxer, booked against an opponent with 4 bouts and the habit "Drops the right
after the jab" -> fight week with a coached Film evening -> the night stops, Watch it with the coach -> filter her jabs ->
check "her jab -> her right hand drops" (That's her) -> File it -> Playbook line on it -> the bout -> the corner minute says
CONFIRMED -> the result page's Punch by punch tab shows the habit lines. A second run files a noise claim and the corner
minute says CLEARED.

---

## 7. What gets built, by whom (once he approves)
| Piece | Kind | Seat | Test |
|---|---|---|---|
| `scripts/rules/FightLog.gd`: beats -> lines `{t, round, who, hand, punch, target, result, stop, sit, ex, habit}` and the words of a line | pure + test | Qwen | `tests/fight_log_test.gd` |
| `scripts/rules/FilmPattern.gd`: the WHEN/THEN lists, `count(lines, when, then)`, the coach's word, the % to file, `matches(opp, claim)` (table 3.5) | pure + test | Arena | `tests/film_pattern_test.gd` (incl. a noise claim that reaches "That's her" on a short film, and never on two) |
| `scripts/rules/FilmBout.gd`: a past bout from her profile and her RivalPast row | pure + test | Arena | `tests/film_bout_test.gd` (her habits fire only on their triggers; the result matches the row; same seed same bout) |
| Store beats on the exchange record; the 3D view plays the stored beats (through a helper module: LiveRound.gd is already over its 470-line limit, a queued item) | wiring | Claude | the focused 3D + LiveRound tests |
| The page (`scenes/FightAnalysis.tscn`, `scripts/ui/FightAnalysis*.gd`, split under 500 lines) from the mockup | screen | Grok Dev | layout snapshot at 1920x1080 and at text size Largest |
| Live log panel | screen | Grok Dev | layout snapshot in a fight |
| Film night stop, FilmTruth states on the cards, corner minute line, result tab, History button, retiring the Tape Room | wiring | Claude | the golden path above |
Discipline: boxing (the demo). New features ship ON (GameSwitches.GAME_ON).

## 8. Open points for the critics
1. Is 3 checks a night right, or should the number come from the coach's rating (a better coach, more checks)?
2. Should "Let the coach watch" also improve with the coach's rating (a better coach opens two)?
3. Is the 50% "own read" when watching alone a good change, or should alone stay at nothing?
4. Rivals filming our boxer (WHAT A SCOUT SEES) is display only here: should it wait for the small living world?

# FIGHTFILM1 v2 - the fight analysis page, film nights that unlock tells, and the live fight log (S495, 2026-11-15)

Design only; nothing is built. Owner's ask (S494, verbatim): "yes design the fight analysis page , it could be used for
the film to make the player try to unlock the tells of the opponent ? also do you think that a window that describe the
action like that would be a good addition ?" Reference he showed: a web app's per-strike breakdown of one fight (strike
lists per fighter with time, hand, type, target, result; a "Show me" filter; per-fighter report; combinations;
vulnerabilities with clickable times). A pro video-stats product (DeepStrike) was checked as a second reference.

v1 (`ops/research/FIGHTFILM1_MAP_S495.md`) scored Dola 8/8/8, John 5/6/7. John's main finding was right: v1 printed the
answer (habit lines in amber with a "Show habit lines" filter) and gave three tells free from the report. v2 fixes that
and every other point both critics raised, and measures the coach's check (section 3.4, `tools/film_check_probe.py`).

Words: the page and pickers say "the opponent" and "their" (never a fixed he or she); names only in the header (S448).
**CODE** = in the game today (file named). **NEW** = this design. **P** = a proposed number, tuned in play.

## 0. What changed from v1
| v1 | v2 | Why (who said it) |
|---|---|---|
| Habit fires were their own amber lines; a "Show habit lines" filter | Gone. Every one of the opponent's punches carries a plain AFTER fact (guard up, right low, left low, lunged in, stood still, threw on), true for every punch, with other causes (tiredness, a missed hook, being hit) making the same facts at a base rate (P, about 1 in 15) | The tell was printed in words; the rest's rate was always 0, so the contrast meant nothing (John) |
| Game and best weapon filed free from the report at 70%; filing allowed outside film nights | Each costs one check; outside a film night the page shows the film and the report but no punch list and no filing | Three free tells beat the coach's one (John) |
| 50 / 70 / 90% were labels | The figure pays: FilmEdge pays a filed tell at its figure until the corner minute CONFIRMS it (full) or CLEARS it (nothing); a plan line on an unconfirmed tell rates Works at best, Beats it once confirmed | The figures changed nothing (John) |
| Figures chosen | Figures measured: "That's her" on one film is right 68-91% of the time (guesser to reader) = **70%**; pooled over two films 79-95% = **90%**; a "Maybe" is right 18-30% = **30%** (v1 had 50%) | Measure it (John) |
| Watching yourself cost nothing in the week | Watching yourself takes the whole evening; letting the coach watch is a 20-minute job, so that evening's pads or sparring still run | No in-game cost for the better option (John) |
| 3 checks fixed | Checks by the film coach's rating: 2 under 60, 3 at 60-79, 4 at 80+ (Luke Reid 58 = 2, Marcus Hale 74 = 3); a coach rated 75+ left to watch opens two tells in tape order | Both critics |
| Best weapon counted two ways | One count everywhere: the punch that lands clean most (the `big` beats) | John |
| Rate claims ("throws less") counted as "followed by" | Their own rule: punches a minute inside the window against outside it (section 3.3) | John |
| "about 9 a side an exchange" / "about 160 a bout" | About 9 punches and steps an exchange for both corners together (CODE `RoundScript.BEATS` = 9) plus combination follow-ups: about 160-200 lines a 3 x 3 min bout, about 80 of them the opponent's; "0 of 58" fixed to "of 43" | John |
| The report's sentences offered "File it" | Sentences only state numbers; checks live in the pattern box and on two report rows | John |
| Live log: one line a punch, off by default | One line an exchange, ON by default (new features ship on, S221); a Punches switch inside it shows every punch; only FILED tells show in the warning colour | John (lines a round, ship-on, leaks), Dola (keep it) |
| A wrong read cost "one of the corner's two instructions" | It costs the corner minute's job "change one plan arrow" (CODE corner minute jobs) | John |
| Noise test "never on two films" | A rate: a noise claim reaches "That's her" under 5% of the time over two films (measured: 2.0% on average, the worst claim 4.8%) | John |
| - | Watch list: mark a claim to check on the next film without spending a check now; Next / Previous moment buttons; Marked tonight shows each claim's counts per film side by side | Dola |
| - | Pros: "Their corner will wait for your cross" on your own bout (CODE `ProRead`), with Fix it on the pads | John |
| Pressing share, accuracy by combination length (pro stats) | Cut: the first repeats the opponent's games, nothing acts on the second | John (Dola kept them; John's reason wins: no decision uses them) |
| - | NOT taken: Dola's "show only the patterns that can be real" switch (it hands over the answer, the thing John marked v1 down for); compound triggers and style-wide lessons wait for a later version | - |

---

## 1. Where the data comes from (traced in the code, S495)
| What the page needs | Where the game has it | Gap and the v2 answer |
|---|---|---|
| The round as six 30-second exchanges | CODE `scripts/state/LiveRound.gd` keeps one record an exchange: the opponent's game (`mode`), situation, our call and whether heard, punches landed per corner, body shots, winner and margin, place in the ring (`place`), the best move each side had, the habit and the read | none |
| Every punch | CODE `scripts/fight3d/ExchangeBeats.gd` + `scripts/rules/RoundScript.gd` build beats `{t, who, move, result, def, big, knockback, read}`; habits rewrite beats (`scripts/rules/HabitBeats.gd`, fires `{who, habit, t}`); the 3D pose of a tell exists (`scripts/fight3d/TellPose.gd`) | Built only in the 3D view and never stored: a skipped or word-view round has no punch list. NEW: build the beats once when the exchange settles, through a helper module (LiveRound.gd is 488 lines, over its 470 limit), store them on the record; the 3D view plays the stored beats. NEW: each beat gets its AFTER fact (section 2.1), written by the same pass, so the film's pose and the list agree |
| The numbers and the Why | CODE `FightStats.gd`, `FightWhy.gd`, `Judges.gd` (three cards a round, read from the exchanges with no dice, one reason a card) | none |
| The opponent's past bouts | CODE `RivalPast.gd` keeps each as one row `{d, vs, vs_club, win, how}` | NEW `FilmBout.gd`: rebuilds the whole bout from the opponent's real profile, the same every time (seed = their id + the bout's day): their games in their style's mix (`Exchanges.STYLE_MODES`), their habits fired on their real triggers, their best weapon landing clean most, the result matching the row, the AFTER facts with their base rates |
| How many films | CODE `ModeTells.films(bouts)`, at most `MAX_FILMS` = 4; a debutant has no tape (`FilmTruth.locked`) | none |
| Tells and answers | CODE `OppFile.tells(opp)`: look and style free; best weapon, two games, each habit (7 words), weakness, each with its answer | none |
| Seen / looked again / confirmed / cleared | CODE `FilmTruth.gd` (`SEEN_TRUE` 0.70, `LOOKED_TRUE` 0.90, `check_minute`), built and wired nowhere | First use; adds a 0.30 "maybe" figure |
| What a found tell is worth | CODE `FilmEdge.gd`: each found tell the plan answers adds `FILM_PER_ANSWER` = 0.4 power on the night, at most `FILM_EDGE_MAX` = 1.2 (three answered tells); `TheRead.gd`: with film, a fifth fewer looks to read a habit | NEW: pays at the tell's figure until confirmed. Three tells at 70% = 0.84, so confirming and second films still pay |
| Film nights | CODE `FightWeekPlan.gd` + `FilmSeats.gd`: 2 coached film nights a week (+1 with a full-time coach); over the count the boxer watches alone and finds nothing | NEW: the two ways to use a night (section 3.1) |
| Coach ratings | CODE `scripts/state/Data.gd`: Luke Reid 58, Marcus Hale 74 | Checks and the coach's own watch by rating (section 3.1) |
| Pros being read | CODE `ProRead.gd`: the other corner studies our last two pro bouts and waits for our most thrown punch | Shown on your own bout (section 5) |

---

## 2. The page: FIGHT ANALYSIS
One scene, two uses: **their tape** (a film night: one of the opponent's past bouts) and **your bout** (after the fight,
from History, and "the round so far" from the corner minute). Mockup v2: `docs/mockups/s495/fight_analysis/fight_analysis_v2.png`.

### 2.1 Layout (1920x1080, wood frame, slate cards)
- **Header**: the bout in one line, names here only: "<name> vs <name> - Bethnal Green club show, Feb 2026 - <name> won
  on points, 3 x 3 min". Film night: FILM 1 OF 3 with Next film; COACH CHECKS as pips ("2 of 3 left"); TONIGHT: "the whole
  evening" or "20 minutes, pads still run"; Done for tonight.
- **Left, THE FILM** (CODE TapeFilm on our ring, ringside camera): play, 0.5x/1x/2x, the round and clock; **Previous / Next
  moment** jump between the lines the filter shows. Under it the timeline: three rounds, a grey tick a shown line, and the
  **ROUNDS STRIP**: each round's three judges' cards (CODE Judges, the reason on hover, knockdowns marked).
- **Middle, THE PUNCHES** (film night and your bout; not on "Watch the tape" outside a night): one list for both corners in
  order. Each line: clock, a corner dot, hand + punch + target, the result (Landed / Clean / Blocked / Slipped / Missed),
  the RANGE (long, mid, inside, ropes; from the exchange's `place`) and for the opponent's punches the **AFTER** fact
  (guard up / right low / left low / lunged in / stood still / threw on). No colour marks a tell; a divider every 30
  seconds names the opponent's game in that exchange. SHOW ME: Corner, Hand, Punch, Result, Range, Round, Their game,
  After. A count line: "36 lines of 164 - landed 9 of 31, clean 2". With an After filter on, the count line shows the same
  fact after their other punches ("right low after their other punches: 3 of 43"): a careful player can see a pattern
  before spending a check. Finding is free; filing costs a check.
- **Right, THE REPORT** (tabs: Them / The other; your bout: You / The opponent): thrown, landed and clean bars per punch;
  head against body; landed by round; landed by range; their games by share of exchanges; combinations with clickable
  times; three sentences that only state numbers ("The jab is thrown most; the cross lands clean most, 4 times."). Two rows
  carry a **Check it (1)** button: Their game and Clean punches (files the game or the best weapon).
- **Bottom left, MARK A PATTERN** (film night only): WHEN and THEN pickers, **Check it with the coach**, **File it**,
  **Watch list** (save the claim for the next film, no check spent). MARKED TONIGHT lists each claim with its counts per
  film side by side ("film 1: 5 of 31 | film 2: 4 of 28") and its word.
- **Your bout** swaps the pattern box for WHAT DECIDED IT (CODE FightWhy, three lines) and WHAT THE OTHER CORNER WILL
  SEE: your boxer's own AFTER facts that stand out ("right low after the jab: 6 of 29, after other punches 2 of 40") with
  **Fix it on the pads** (CODE HabitFix drill on the next pad evening); for a pro, "Their corner will wait for your cross"
  (CODE ProRead) with Fix it on the pads (drills the second weapon) beside it.

### 2.2 Buttons and what each changes
| Button | Changes |
|---|---|
| A line, a tick, a combination time, Previous / Next moment | The film jumps there (no game state) |
| SHOW ME pickers, report tabs | What is shown (no game state) |
| Check it with the coach / Check it (1) | Spends one check; shows the counts and the coach's word |
| File it | Writes the claim into the opponent's file at the word's figure (section 3.4); opens the real tell if the claim matches one, else stores a claim the corner minute will clear |
| Watch list | Keeps the claim for the next film night (no check spent) |
| Next film | Loads the next past bout; checks and the watch list carry over |
| Done for tonight | Ends the night; unused checks are lost |
| Your bout: Fix it on the pads | Puts the habit-fix drill on the next pad evening |

---

## 3. The film game

### 3.1 The night (NEW, P)
A film night stays an evening card in the fight week (CODE FilmSeats). When the clock reaches it, it stops on it (a new
stop, like the weigh-in) and asks one thing:
- **Watch it yourself, with the coach** - takes the whole evening (no pads or sparring that night). The page opens on the
  newest film with the film coach's checks: **2** (rating under 60), **3** (60-79), **4** (80+). Luke Reid gives 2, Marcus
  Hale 3; the head coach (you) with no assistant gives 3.
- **Let the coach watch** - a 20-minute job: the evening's pads or sparring still run. Opens the next tell in tape order at
  70% (today's behaviour), two tells if the coach is rated 75 or more. Never more than two: the player's own reading can
  always find more, and choose which.
- **Over the coach's seats** (CODE: the boxer watches alone): the page opens with no checks. The player may file ONE claim
  of their own a night at **30%**, and only when the visible counts show it at least 3 times. (Changes the S485 rule "alone
  opens no tell" from nothing to one weak tell; both critics backed it.)
- Outside a film night, Fight prep's **Watch the tape** opens the film and the report only: no punch list, no filing.

### 3.2 What can be marked
WHEN: their jab / their cross / their hook / their combination lands / they are hurt / the last minute of a round /
round 1 / 10 seconds after a body shot lands on them / an exchange where the other walks them down.
THEN (read from the AFTER fact and the next lines): right hand low / lunged in / stood still (nothing thrown for 3 s) /
throws to the body / single wild right (rear hand, no combination) / throws fewer / loses the exchange / the other's
counter lands.
9 x 8 = 72 claims; an opponent's file holds about 7 real ones. Plus two report checks (their game, their best weapon).

### 3.3 The coach's check: the counting rules
- **Event claims** (WHEN is a punch or a moment): k = times THEN followed WHEN within 2 seconds; n = times WHEN happened;
  the rest = the same THEN after all their other punches and moments. **That's her / him** when k >= 3 and k/n is at least
  3 times the rest's rate (the rest's count taken as at least 1). **Maybe** when k >= 2 but short of that. **Nothing there**
  when k <= 1.
- **Window claims** (the last minute of a round, round 1, 10 s after a body shot): their punches a minute inside the
  window against outside it. Inside 1.5 times lower or more = That's her / him; 1.2 to 1.5 = Maybe; under 1.2 = Nothing.
- **Exchange claims** (an exchange where the other walks them down -> loses the exchange): exchanges lost of those, against
  exchanges lost of the rest; the same 3-times / k >= 3 rule.
- **Report checks**: their game = the game with the most exchanges, That's her / him when it holds at least 40% of them
  (CODE `ModeTells.ALL_FILMS_SHARE` 0.4); best weapon = the punch landing clean most, That's her / him when it has at
  least 3 clean and more than any other.
- Two films: the counts pool (k and n add up). **Looked again** = That's her / him on the pooled counts.

### 3.4 Measured, not chosen (`tools/film_check_probe.py`, 1,000 generated films a claim, on this map's numbers)
| | one film | two films pooled |
|---|---|---|
| A true punch habit (right low, lunges in) reaches That's her | 57-69% | 58-71% |
| A true habit after a combination lands | 62% | 92% |
| A true habit when hurt (rare: about 2 hurt moments a bout) | 23-24% | 61-64% |
| A noise claim reaches That's her (31 noise claims) | 2.5% each, worst 7.4% | 2.0% each, worst 4.8% |
| How often a That's her is right: a player who checks 1 true claim in 3 / a guesser, 1 in 10 | 91% / 68% | 95% / 79% |
| How often a Maybe is right (a reader) | 30% | 18% |
| Window claims (last minute, round 1): true fade at 60% output / noise | 66% / 3% | 74% / 0.5% |
So the filed figures are: **That's her / him on one film 70%**, **on two films 90%**, **Maybe 30%**, **alone 30%**.
The game: a hurt habit is rarely found on one film (it needs two films, or the coach), a fade is found on one; a guesser's
"That's her" is wrong a third of the time, a reader's one time in ten. The probe runs again on FilmBout's real output once
it is built, and the figures follow it.

### 3.5 False reads and the truth
- The corner minute settles each filed claim (CODE `FilmTruth.check_minute`): at the first corner minute after its
  situation came up (a fade or a slow start at round 2), CONFIRMED ("You read it right") or CLEARED ("Not there - change
  the line"). The truth is the claim matching a real tell in the file, never a dice roll.
- Pay: a filed tell pays FilmEdge at its figure (0.4 x 0.7 = 0.28 power on one film) until confirmed (0.4) or cleared (0).
  A plan line on an unconfirmed tell rates Works at best; once confirmed it can rate Beats it (CODE PlanLines ratings).
- A false read costs the plan line written on it (it answers nothing, CODE PlanFight neutral) and the corner minute's
  "change one plan arrow" job if the player fixes it there. A true read stays in the file for a rematch (CODE
  `OppFile.remember`).

### 3.6 Which claim finds which tell
| Tell (CODE OppFile) | Claim |
|---|---|
| Drops the right after the jab | their jab -> right hand low |
| Lunges in behind the jab | their jab -> lunged in |
| Stands and admires after a combination | their combination lands -> stood still |
| Goes to the body when hurt | they are hurt -> throws to the body |
| Loads up wild when hurt | they are hurt -> single wild right |
| Hands drop late in a round / weakness "fades" | the last minute of a round -> throws fewer |
| Takes a round to get going / weakness "slow to start" | round 1 -> throws fewer |
| Weakness "body" | 10 s after a body shot lands -> throws fewer |
| Weakness against pressure | an exchange where the other walks them down -> loses the exchange |
| Their game (mode tells) | report check: Their game |
| Best weapon | report check: Clean punches |
Every other claim is noise and is never true.

### 3.7 The trade-offs
- Checks against 72 claims; the free filters are the clue, the checks are the commitment.
- Watch yourself (2-4 tells of your choice, a lost evening of pads, a risk of a false read) against the coach (1-2 tells
  in his order, quick, safe).
- File at 70% now, or watch-list it for a second film at 90%; a hurt habit almost needs the second film.
- Two boxers with bouts the same week share the coach's seats (CODE FilmSeats).
- A better coach (hire or keep one rated 75+) gives more checks and a second tell when he watches.
- A confirmed read pays in full; a cleared one costs a line and the corner's arrow change.

---

## 4. The live fight log (NEW)
- A panel on the right of the fight screen under the scores, ON by default (new features ship on, S221), with a close
  button and the key L; Settings: Show the fight log On / Off.
- One line an exchange (six a round): clock, the opponent's game, who won it and punches landed ("1:30 They walked you
  down - you won it, 4 to 2"), your shout and whether it was heard. A **Punches** switch inside opens every punch of the
  exchange (the page's lines).
- A tell you FILED shows in the warning colour when it fires ("Right low after the jab - as filed"). An unfiled habit is
  never marked: it shows only as plain punch lines.
- Reads the stored beats, so a skipped round fills at once and the words view shows the same lines.

## 5. Your own bouts
- Result page: a fourth tab **Punch by punch** (CODE ResultTabs) opens the page on the whole fight, with the rounds strip
  and the judges' reasons.
- Fighter page > History: **Analysis** on each bout row; the gym keeps the last 20 bouts' beats (P, about 160-200 lines a
  bout); older rows say "no tape kept".
- Corner minute: **The round so far** opens the page read-only on the rounds fought.
- WHAT THE OTHER CORNER WILL SEE (2.1): your boxer's own AFTER patterns with Fix it on the pads; for a pro, ProRead's
  "Their corner will wait for your cross". Amateur rivals using our tape waits for the small living world.

---

## 6. Every menu the mechanic appears on, and what each is wired to (owner S425)
| Menu | What it shows | Wired to |
|---|---|---|
| Fight week > Film evening card | Coached / Alone (CODE); when the clock reaches it: Watch it yourself (whole evening) / Let the coach watch (20 min, pads still run) | FightWeekPlan film night -> FightAnalysis with checks by coach rating, or the coach's tell(s) |
| FIGHT ANALYSIS (new scene) | Section 2 | FightLog (lines), FilmBout (past bouts), FilmPattern (counts, words, filing), FightStats + Judges (report, rounds strip), TapeFilm (film) |
| Fighter page > Fight prep | Watch the tape (film + report, no filing); WHAT YOUR PLAN SHOULD ANSWER lists each tell with its figure (30 / 70 / 90%, CONFIRMED, CLEARED) and where it was seen (click opens the page there) | FightAnalysis (film only); OppFile + FilmTruth states |
| Rival file (World > Rankings) and the opponent's file card (bout offer, Camp, fight night) | Each tell's state and figure; the evidence counts on hover | OppFileCard reading FilmTruth states |
| Playbook > Game plan | A line on an unconfirmed tell shows its figure and rates Works at best; a CLEARED tell's line is marked "change this line" | PlanLines + FilmTruth state |
| Fight screen (3D and words) | The live log (section 4) | FightLog over the stored beats |
| Corner minute | CONFIRMED / CLEARED for each filed claim whose situation came up; "change one plan arrow" offered on a cleared line; The round so far | FilmTruth.check_minute; corner jobs; FightAnalysis read-only |
| Result page | Tab Punch by punch | FightAnalysis (your bout) |
| Fighter page > History | Analysis on each bout row | FightAnalysis over kept beats |
| Club > People (staff cards) | "Film: 3 checks a night" on each coach card | the checks-by-rating table |
| Settings | Show the fight log On / Off | the log's default |
| Tape Room (CODE TapeRoom.gd) | Retired: its films and SPOT become this page; its YOUR ANSWER becomes "Write the answer" after File it (opens the Playbook line) | - |

Golden-path test: test club boxer booked against an opponent with 4 bouts and "Drops the right after the jab" -> fight
week with a coached Film evening -> Watch it yourself -> filter their jabs, After = right low -> check (That's her) -> File
it (70%) -> write the Playbook line (rates Works) -> the bout -> the corner minute says CONFIRMED -> the line rates Beats it
-> the result page's Punch by punch tab shows the lines. A second run files a noise claim and the corner minute CLEARS it.
Rate test: `film_pattern_test.gd` runs 200 seeded films and asserts a noise claim reaches That's her under 5% over two films.

## 7. What gets built, by whom (once he approves)
| Piece | Kind | Seat | Test |
|---|---|---|---|
| `scripts/rules/FightLog.gd`: beats -> lines `{t, round, who, hand, punch, target, result, range, after, sit, ex}`, the words of a line, the exchange line for the live log | pure + test | Qwen | `tests/fight_log_test.gd` |
| `scripts/rules/FilmPattern.gd`: WHEN/THEN lists, the three counting rules, the words, the figures, `matches(opp, claim)` (3.6), checks by coach rating | pure + test | Arena | `tests/film_pattern_test.gd` (incl. the noise rate) |
| `scripts/rules/FilmBout.gd`: a past bout from the opponent's profile and RivalPast row, AFTER facts with base rates | pure + test | Arena | `tests/film_bout_test.gd` (habits fire only on triggers; result matches the row; same seed same bout) |
| Beats + AFTER facts stored on the exchange (helper module beside LiveRound) ; 3D plays stored beats | wiring | Claude | focused 3D + LiveRound tests |
| The page (`scenes/FightAnalysis.tscn`, `scripts/ui/FightAnalysis*.gd`, each under 500 lines) from the mockup | screen | Grok Dev | layout snapshot at 1920x1080 and text size Largest |
| Live log panel | screen | Grok Dev | layout snapshot in a fight |
| Film night stop, FilmEdge pay at the figure, FilmTruth states on the cards, corner minute line, result tab, History button, Tape Room retired, `tools/film_check_probe.py` rerun on FilmBout | wiring | Claude | the golden path |
Discipline: boxing (the demo). Ships ON (GameSwitches.GAME_ON).

## 8. Open points for the critics
1. Does the AFTER fact on every punch leave enough to find (a careful player can see a pattern before checking), or is it
   still too easy? The checks are the cost of filing, not of finding.
2. Is "Let the coach watch = 20 minutes, pads still run" a fair price against "the whole evening"?
3. Is the 30% for a Maybe and for an own read alone worth having, or should both file nothing?

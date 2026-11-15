# FIGHTFILM1 v3 - the fight analysis page, film nights that unlock tells, and the live fight log (S495, 2026-11-15)

Design only; nothing is built. Owner's ask (S494, verbatim): "yes design the fight analysis page , it could be used for
the film to make the player try to unlock the tells of the opponent ? also do you think that a window that describe the
action like that would be a good addition ?" References: the per-strike breakdown app he showed, and a pro video-stats
product (DeepStrike) for which stats matter.

Rounds so far: v1 Dola 8/8/8, John 5/6/7 (the list printed the tell; free tells). v2 Dola 9/9/9, John 6/7/7: the screen
worked out every check for free, a second film barely helped the common habits (the "3 times the rest" bar sat at a real
habit's own strength), checks were plentiful over a camp, and the evening trade was not in wins. v3 answers each with the
probe rerun on all 72 claims (`tools/film_check_probe.py`, 1,000 films a claim, two seeds) and the game's own power
numbers.

Words: the page and pickers say "the opponent" and "their"; the coach's word follows the opponent ("That's her" / "That's
him"); names only in the header (S448). **CODE** = in the game today (file named). **NEW** = this design. **P** = a
proposed number, tuned in play.

## 0. What changed from v2
| v2 | v3 | Why (who) |
|---|---|---|
| The count line showed exact counts, so the check only repeated them | The camera sees an AFTER fact on about 2 punches in 3 (P; a dash otherwise: a body in the way, the wrong angle). The count line counts what the camera saw ("seen: 5 of 21 jabs, 2 of 30 other punches"); the coach's check counts every punch ("all of them: 7 of 31 against 3 of 43"). Measured: the screen alone passes a punch habit on 48-57% of films, the check on 63-68%; a hurt habit 9-10% against 21-23% | John: make the check buy information |
| "3 times the rest's rate" | An evidence bar: z = (k - expected) / spread, the expected count from the rest's rate and the spread from both counts. That's her / him at z 2.33 (one in a hundred by chance) and k >= 3; Maybe at z 1.28. More film always strengthens it: a punch habit goes from 63-68% on one film to 86-91% on two | John: more film must always help |
| Only 31 noise claims probed | All 72 (9 true, 63 noise). Noise passes 2.0-2.5% of the time on average, worst claim 4.8-6.0%, on two seeds | John |
| "Throws fewer" compared inside the window with outside | Against the outside rate times the slowdown every boxer has late in a round (the game's own number), so a boxer who merely tires does not read as a fader | John: fade claims assumed flat output |
| "Loses the exchange" (6 exchange results a film) | "Gets out-landed": the other corner's landed punches a minute in that situation against the rest (more data). A pressure weakness passes on 37% of single films, 59% of two | Measured: exchange results were too few |
| Fewer than 3 trigger moments = Nothing there | "Not enough moments on this film (2)"; the claim goes on the watch list free | John |
| Checks per night only | Also capped per opponent: at most 2 a film the opponent has (P; 4 films = 8 checks) across the whole fight week or camp | John: checks outnumbered tells over a camp |
| No assistant = 3 checks | No assistant 2; under 60 = 2; 60-79 = 3; 80+ = 4. Luke Reid 2 (he grows to 82, CODE CoachMarket GROWTH, so 4 at his best), Rosa Mendez 3, Marcus Hale 3 | John: letting a coach go bought checks |
| Second coach tell at 75, which no coach had | At 70: Marcus Hale (74) has it on hire, Luke Reid grows into it | John |
| Figures 70 / 90 / 30% | Measured on all 72: one film That's her right 88% (a player who checks likely claims) to 62% (a guesser) -> **70%**; two films 94% to 78% -> **85%**; one-film Maybe -> **30%**; two-film Maybe (55% to 21%) -> **20%**; an own read alone -> 30% | John |
| A confirmed tell paid "on the night" | It pays its full 0.4 from the round after the corner minute that confirmed it; until then its figure (0.28 at 70%) | John |
| The evening trade was not in power or wins | Both sides in the game's units, on the stop: a filed tell at 70% = 0.28 power; one new weapon (a move reaching mastery 30) = 0.3 power (CODE BoutRules WEAPON_EDGE); one power point = about +5.5 points of win chance in an even 3-round bout (derived from CODE ROUND_SPREAD 27). The stop shows tonight's pads forecast ("one-two 27 -> 31: a new weapon") beside the film | John |
| - | Click an AFTER cell to filter to that fact; clean-rate sort on the report; a watch-list claim that drops on the next film shows "faded"; the coach's 20-minute watch also names the punch types worth filtering, never the fact | Dola #1, #3, #4; John #9 |
| - | "Let the coach watch" names what he looks for first ("best weapon, then their main game") | Dola #2 |
| NOT taken | Dola: easier hurt habits on one film (rare moments are the point: hurt habits are two-film tells); compound triggers; style-wide lessons (later versions) | - |

## 1. Where the data comes from (traced in the code, S495)
| What the page needs | Where the game has it | Gap and the v3 answer |
|---|---|---|
| The round as six 30-second exchanges | CODE `scripts/state/LiveRound.gd` keeps one record an exchange: the opponent's game (`mode`), situation, our call and whether heard, punches landed per corner, body shots, winner and margin, place in the ring (`place`), the best move each side had, the habit and the read | none |
| Every punch | CODE `scripts/fight3d/ExchangeBeats.gd` + `scripts/rules/RoundScript.gd` build beats `{t, who, move, result, def, big, knockback, read}`; habits rewrite beats (`scripts/rules/HabitBeats.gd`, fires `{who, habit, t}`); the 3D pose of a tell exists (`scripts/fight3d/TellPose.gd`) | Built only in the 3D view and never stored: a skipped or word-view round has no punch list. NEW: build the beats once when the exchange settles, through a helper module (LiveRound.gd is 488 lines, over its 470 limit), store them on the record; the 3D view plays the stored beats. NEW: each beat gets its AFTER fact (section 2.1), written by the same pass, so the film's pose and the list agree |
| The numbers and the Why | CODE `FightStats.gd`, `FightWhy.gd`, `Judges.gd` (three cards a round, read from the exchanges with no dice, one reason a card) | none |
| The opponent's past bouts | CODE `RivalPast.gd` keeps each as one row `{d, vs, vs_club, win, how}` | NEW `FilmBout.gd`: rebuilds the whole bout from the opponent's real profile, the same every time (seed = their id + the bout's day): their games in their style's mix (`Exchanges.STYLE_MODES`), their habits fired on their real triggers, their best weapon landing clean most, the result matching the row, the AFTER facts with their base rates |
| How many films | CODE `ModeTells.films(bouts)`, at most `MAX_FILMS` = 4; a debutant has no tape (`FilmTruth.locked`) | none |
| Tells and answers | CODE `OppFile.tells(opp)`: look and style free; best weapon, two games, each habit (7 words), weakness, each with its answer | none |
| Seen / looked again / confirmed / cleared | CODE `FilmTruth.gd` (`SEEN_TRUE` 0.70, `LOOKED_TRUE` 0.90, `check_minute`), built and wired nowhere | First use; LOOKED_TRUE becomes 0.85; adds MAYBE_ONE 0.30 and MAYBE_POOLED 0.20 |
| What a found tell is worth | CODE `FilmEdge.gd`: each found tell the plan answers adds `FILM_PER_ANSWER` = 0.4 power on the night, at most `FILM_EDGE_MAX` = 1.2 (three answered tells); `TheRead.gd`: with film, a fifth fewer looks to read a habit | NEW: pays at the tell's figure until confirmed. Three tells at 70% = 0.84, so confirming and second films still pay |
| Film nights | CODE `FightWeekPlan.gd` + `FilmSeats.gd`: 2 coached film nights a week (+1 with a full-time coach); over the count the boxer watches alone and finds nothing | NEW: the two ways to use a night (section 3.1) |
| Coach ratings | CODE `scripts/state/Data.gd`: Luke Reid 58, Marcus Hale 74; `CoachMarket.gd`: Jamie Price 53, Rosa Mendez 60; Reid grows to 82 (GROWTH) | Checks and the coach's own watch by rating (section 3.1) |
| Power into wins | CODE `BoutRules.gd`: a round = fight power + a uniform swing of ROUND_SPREAD 27 a side; WEAPON_EDGE 0.3 a weapon over 4 (mastery 30), cap 0.9; `MoveMastery.GAIN_PER_HOUR` pads 2.1 | Both sides of the evening in the same unit (section 3.1) |
| Pros being read | CODE `ProRead.gd`: the other corner studies our last two pro bouts and waits for our most thrown punch | Shown on your own bout (section 5) |

---

## 2. The page: FIGHT ANALYSIS
One scene, two uses: **their tape** (a film night: one of the opponent's past bouts) and **your bout** (after the fight,
from History, and "the round so far" from the corner minute). Mockup v3: `docs/mockups/s495/fight_analysis/fight_analysis_v3.png`.

### 2.1 Layout (1920x1080, wood frame, slate cards)
- **Header**: the bout in one line, names here only: "<name> vs <name> - Bethnal Green club show, Feb 2026 - <name> won
  on points, 3 x 3 min". Film night: FILM 1 OF 3 with Next film; CHECKS as pips ("2 of 3 left tonight", "this opponent: 6 left" on hover);
  TONIGHT COSTS: "pads: one-two 27 -> 31, a new weapon" (or "nothing: pads still run"); Done for tonight.
- **Left, THE FILM** (CODE TapeFilm on our ring, ringside camera): play, 0.5x/1x/2x, the round and clock; **Previous / Next
  moment** jump between the lines the filter shows. Under it the timeline: three rounds, a grey tick a shown line, and the
  **ROUNDS STRIP**: each round's three judges' cards (CODE Judges, the reason on hover, knockdowns marked).
- **Middle, THE PUNCHES** (film night and your bout; not on "Watch the tape" outside a night): one list for both corners in
  order. Each line: clock, a corner dot, hand + punch + target, the result (Landed / Clean / Blocked / Slipped / Missed),
  the RANGE (long, mid, inside, ropes; from the exchange's `place`) and for the opponent's punches the **AFTER** fact
  (guard up / right low / left low / lunged in / stood still / threw on) when the ringside camera saw it (about 2 in 3;
  a dash otherwise). Clicking an AFTER cell filters the list to that fact. No colour marks a tell; a divider every 30
  seconds names the opponent's game in that exchange. SHOW ME: Corner, Hand, Punch, Result, Range, Round, Their game,
  After. A count line: "36 lines of 164 - landed 9 of 31, clean 2". With an After filter on, the count line shows what the camera saw
  ("seen: right low after 5 of 21 jabs, after 2 of 30 other punches"): a careful player sees where to look; the coach's
  check is the coach going frame by frame for 20 minutes, so it counts every punch. The screen is what you see at full speed;
  finding is free and approximate, the frame-by-frame check is exact and files.
- **Right, THE REPORT** (tabs: Them / The other; your bout: You / The opponent): thrown, landed and clean bars per punch (sort by count or by clean rate);
  head against body; landed by round; landed by range; their games by share of exchanges; combinations with clickable
  times; three sentences that only state numbers ("The jab is thrown most; the cross lands clean most, 4 times."). Two rows
  carry a **Check it (1)** button: Their game and Clean punches (files the game or the best weapon).
- **Bottom left, MARK A PATTERN** (film night only): WHEN and THEN pickers, **Check it with the coach**, **File it**,
  **Watch list** (save the claim for the next film, no check spent). MARKED TONIGHT lists each claim with its counts per
  film side by side ("film 1: 7 of 31 | film 2: 4 of 28") and its word; a watch-list claim that drops on the next film
  shows "faded"; "Not enough moments (2)" claims sit there free.
- **Your bout** swaps the pattern box for WHAT DECIDED IT (CODE FightWhy, three lines) and WHAT THE OTHER CORNER WILL
  SEE: your boxer's own AFTER facts that stand out ("right low after the jab: 6 of 29, after other punches 2 of 40") with
  **Fix it on the pads** (CODE HabitFix drill on the next pad evening); for a pro, "Their corner will wait for your cross"
  (CODE ProRead) with Fix it on the pads (drills the second weapon) beside it.

### 2.2 Buttons and what each changes
| Button | Changes |
|---|---|
| A line, a tick, a combination time, Previous / Next moment | The film jumps there (no game state) |
| SHOW ME pickers, an AFTER cell, report tabs and sort | What is shown (no game state) |
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
stop, like the weigh-in) and shows both prices in the game's units:
- **Watch it yourself, with the coach** - the whole evening. Checks: no assistant 2; coach under 60 = 2; 60-79 = 3; 80+ =
  4. Also capped at 2 a film the opponent has, across the whole fight week or camp ("this opponent: 6 checks left").
- **Let the coach watch** - 20 minutes; the evening's pads or sparring still run. He says what he looks for ("best weapon,
  then their main game") and opens the next tell in tape order at 70%; a coach rated 70+ opens two. He also marks which
  punch types are worth filtering next time ("look at the jab and the hooks"), never the fact.
- The stop's two lines: "Tonight's pads: one-two 27 -> 31, a new weapon (+0.3 power)" (CODE PadWeek forecast; mastery 2.1
  an hour on the pads; a weapon at 30) against "Film: 3 checks; a tell filed at 70% = +0.28 power, confirmed +0.4" (CODE
  FilmEdge). One power point is about +5.5 points of win chance in an even 3-round bout (derived from CODE BoutRules
  ROUND_SPREAD 27: two uniform swings a round, density 1/27 at even, majority of three rounds). So when tonight's pads make
  a new weapon or reach a mastery tier, the coach should watch; when they do not, watching yourself is worth more. In a
  TAPER week the evening is a rest night, and the stop says "a rest night (tiredness)".
- **Over the coach's seats** (alone): no checks; one own read a night from the camera-seen counts, filed at 30%, only when
  the screen shows it at least 3 times.
- Outside a film night, Fight prep's **Watch the tape** shows the film and the report only.

### 3.2 What can be marked
WHEN: their jab / their cross / their hook / their combination lands / they are hurt / the last minute of a round / round
1 / the 30 seconds after a body shot lands on them / an exchange where the other walks them down.
THEN: right hand low / lunged in / stood still (nothing for 3 s) / throws to the body / single wild right / the other's
counter lands / throws fewer / gets out-landed. 9 x 8 = 72 claims; 9 can be true (3.6). Plus two report checks.

### 3.3 The coach's check: the counting rules (on every punch; the screen shows the camera-seen counts)
- **A fact after a moment** (WHEN a punch or a moment, THEN an AFTER fact or the next lines): k = times it followed within
  2 s; n = the moments; expected E = n x its rate after everything else; spread = sqrt(E + E x n / rest), with the rest's count taken as at least 1 (no division by zero when the fact never
  follows anything else). **That's her /
  him** when k >= 3 and (k - E) / spread >= 2.33; **Maybe** at 1.28 and k >= 2; **Not enough moments (n)** when n < 3;
  else **Nothing there**.
- **Throws fewer** (a window): E = their punches a minute outside the window x the window's length x the slowdown every
  boxer has in it (the game's own number, e.g. 0.9 in the last minute); spread = sqrt(E + E^2 / the outside count); the
  same bars, downwards.
- **Gets out-landed** (a situation): the other corner's landed punches a minute inside against outside; the same bars.
- **Report checks**: their game = the game with the most exchanges, That's her / him at 40%+ of them (CODE
  `ModeTells.ALL_FILMS_SHARE`); best weapon = the punch landing clean most, at least 3 and more than any other.
- Two films pool their counts.

### 3.4 Measured, not chosen (`tools/film_check_probe.py`, all 72 claims, 1,000 films a claim, seeds 495 and 7)
| | one film | two films pooled |
|---|---|---|
| Punch habits (right low, lunges in) pass: the coach's check / the screen alone | 63-68% / 48-57% | 86-91% / 71-79% |
| After a combination lands (stands still) | 58-60% / 37-38% | 93% / 75% |
| When hurt (about 2 hurt moments a film: mostly "not enough moments") | 21-23% / 9-10% | 60-65% / 34-41% |
| Fade, slow start, body weakness (throws fewer): pass / maybe | 18-22% / 49% | 50-55% / 36-41% |
| Pressure weakness (gets out-landed) | 37% | 59% |
| Noise: 63 claims, pass on average / worst claim | 2.5% / 6.0% | 2.0% / 5.1% |
| A pass is right: a player who checks 1 true claim in 3 / a guesser, 1 in 10 | 88% / 62% | 94% / 78% |
| A Maybe is right: reader / guesser | 63% / 28% | 55% / 21% |
Filed figures: **one film 70%**, **two films 85%**, **one-film Maybe 30%**, **two-film Maybe 20%**, **alone 30%**.
In play: punch habits are one- or two-film tells; hurt habits and the fades are two-film tells (a Maybe on the first); a
guesser files wrong a third of the time, a reader about one time in eight. The probe models this map's numbers (FilmBout
does not exist yet); it reruns on FilmBout's output and the figures follow it. `film_pattern_test.gd` asserts noise under
3% on average and under 8% for the worst claim on 1,000 fixed-seed films.

### 3.5 False reads and the truth
- The corner minute settles each filed claim (CODE `FilmTruth.check_minute`): CONFIRMED or CLEARED at the first corner
  minute after its situation came up (a fade or a slow start at round 2). The truth is the claim matching a real tell in
  the file, never a dice roll.
- Pay (CODE FilmEdge, FILM_PER_ANSWER 0.4, FILM_EDGE_MAX 1.2 = three answered tells): a filed tell pays at its figure (0.28
  at 70%, 0.34 at 85%) until confirmed; confirmed, the full 0.4 from the next round; cleared, nothing. A plan line on an
  unconfirmed tell rates Works at best; confirmed, it can rate Beats it.
- A false read costs its plan line (it answers nothing) and the corner minute's "change one plan arrow" job if fixed
  there. A true read stays in the file for a rematch (CODE `OppFile.remember`).

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
| Weakness "body" | the 30 s after a body shot lands -> throws fewer |
| Weakness against pressure | an exchange where the other walks them down -> gets out-landed |
| Their game (mode tells) | report check: Their game |
| Best weapon | report check: Clean punches |
Every other claim is noise and is never true.

### 3.7 The trade-offs
- Where to spend 2-4 checks (capped per opponent): the screen's camera-seen counts are the clue; the check sees every
  punch and finds a third more of the real habits, and twice as many of the hurt ones.
- Watch yourself (your pick of tells, a lost evening priced on the stop) or let the coach watch (one or two tells in his
  order, the pads run): the stop says which is worth more tonight.
- File at 70% now, or watch-list it and pool a second film for 85%; fades and hurt habits are two-film tells.
- A better coach: more checks, a second tell on his own watch; Luke Reid grows into both.
- Two boxers fighting the same week share the coach's seats (CODE FilmSeats).
- A confirmed read pays in full from the next round; a cleared one costs a line and the corner's arrow change.

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
| Fight week > Film evening card | Coached / Alone (CODE); when the clock reaches it: Watch it yourself (whole evening, the pads forecast it costs) / Let the coach watch (20 min, pads still run, what he looks for) | FightWeekPlan film night -> FightAnalysis with checks by coach rating, or the coach's tell(s) |
| FIGHT ANALYSIS (new scene) | Section 2 | FightLog (lines), FilmBout (past bouts), FilmPattern (counts, words, filing), FightStats + Judges (report, rounds strip), TapeFilm (film) |
| Fighter page > Fight prep | Watch the tape (film + report, no filing); WHAT YOUR PLAN SHOULD ANSWER lists each tell with its figure (30 / 70 / 85%, CONFIRMED, CLEARED) and where it was seen (click opens the page there) | FightAnalysis (film only); OppFile + FilmTruth states |
| Rival file (World > Rankings) and the opponent's file card (bout offer, Camp, fight night) | Each tell's state and figure; the evidence counts on hover | OppFileCard reading FilmTruth states |
| Playbook > Game plan | A line on an unconfirmed tell shows its figure and rates Works at best; a CLEARED tell's line is marked "change this line" | PlanLines + FilmTruth state |
| Fight screen (3D and words) | The live log (section 4) | FightLog over the stored beats |
| Corner minute | CONFIRMED / CLEARED for each filed claim whose situation came up; "change one plan arrow" offered on a cleared line; The round so far | FilmTruth.check_minute; corner jobs; FightAnalysis read-only |
| Result page | Tab Punch by punch | FightAnalysis (your bout) |
| Fighter page > History | Analysis on each bout row | FightAnalysis over kept beats |
| Club > People (staff cards) and the coach market | "Film: 3 checks a night, finds 2 tells on his own" on each coach card | the checks-by-rating table |
| Settings | Show the fight log On / Off | the log's default |
| Tape Room (CODE TapeRoom.gd) | Retired: its films and SPOT become this page; its YOUR ANSWER becomes "Write the answer" after File it (opens the Playbook line) | - |

Golden-path test: test club boxer booked against an opponent with 4 bouts and "Drops the right after the jab" -> fight
week with a coached Film evening -> Watch it yourself -> filter their jabs, After = right low -> check (That's her) -> File
it (70%) -> write the Playbook line (rates Works) -> the bout -> the corner minute says CONFIRMED -> the line rates Beats it
-> the result page's Punch by punch tab shows the lines. A second run files a noise claim and the corner minute CLEARS it.
Rate test: `film_pattern_test.gd` runs 1,000 fixed-seed films and asserts noise passes under 3% on average and under 8% for the worst claim.

## 7. What gets built, by whom (once he approves)
| Piece | Kind | Seat | Test |
|---|---|---|---|
| `scripts/rules/FightLog.gd`: beats -> lines `{t, round, who, hand, punch, target, result, range, after, sit, ex}`, the words of a line, the exchange line for the live log | pure + test | Qwen | `tests/fight_log_test.gd` |
| `scripts/rules/FilmPattern.gd`: WHEN/THEN lists, the three evidence bars, the words, the figures, `matches(opp, claim)` (3.6), checks by coach rating and the per-opponent cap, the camera-seen counts | pure + test | Arena | `tests/film_pattern_test.gd` (incl. the noise rate) |
| `scripts/rules/FilmBout.gd`: a past bout from the opponent's profile and RivalPast row, AFTER facts with base rates and the camera-seen flag, the late-round slowdown on both corners | pure + test | Arena | `tests/film_bout_test.gd` (habits fire only on triggers; result matches the row; same seed same bout) |
| Beats + AFTER facts stored on the exchange (helper module beside LiveRound) ; 3D plays stored beats | wiring | Claude | focused 3D + LiveRound tests |
| The page (`scenes/FightAnalysis.tscn`, `scripts/ui/FightAnalysis*.gd`, each under 500 lines) from the mockup | screen | Grok Dev | layout snapshot at 1920x1080 and text size Largest |
| Live log panel | screen | Grok Dev | layout snapshot in a fight |
| Film night stop, FilmEdge pay at the figure, FilmTruth states on the cards, corner minute line, result tab, History button, Tape Room retired, `tools/film_check_probe.py` rerun on FilmBout | wiring | Claude | the golden path |
Discipline: boxing (the demo). Ships ON (GameSwitches.GAME_ON).

## 7b. To settle while building (from the v3 critics; they change numbers on the stop, not the mechanic)
1. Measure power into wins in the game's own fight (1,000 even bouts at +0.28, +0.4, +0.9, +1.2): the +5.5 a power point
   is derived from BoutRules' round model, and the watched bout settles six exchanges a round (John).
2. Settle the weapon rule (`weapons_edge` pays from the fifth weapon on, BASE_WEAPONS 4): the stop shows the edge this boxer
   actually gains tonight, which may be 0.
3. Price the stop in wins with how long each lasts: a weapon "+x in 100, every bout from now on"; a tell "+y in 100 against
   this opponent, and the plan line it unlocks" (measure a confirmed line rated Beats it against none, 1,000 bouts).
4. Price the TAPER rest night (fight-night energy with and without it); if it is worth under 1 in 100, the TAPER film night
   costs the coach's sparring slot instead.
5. Show trust words (Sure 85%, Likely 70%, Maybe 30/20%) with the paid % on hover, so the figures are not read as odds.
6. A dash says why on hover ("missed at full speed: body in the way"); a hurt or fade claim on a film with fewer than 3
   moments says "rare: needs a second film or the corner minute" before the check is spent, and goes to the watch list free.
7. Cap checks at 2 a film and at 6 an opponent, so a full-time coach still has to choose.
8. Build FilmBout, rerun the probe on its real output (all 72 claims, 1,000 films, tiring boxers, a rest-rate-0 case).
Dola's smaller asks for later: clear a claim from the watch list, sort claims by strength, a coach priority on his own watch,
replay a film for the current opponent.

## 8. Open points for the critics
1. Is "the camera sees 2 punches in 3" a fair way to make the check buy information, or does it read as an arbitrary fog?
2. Is the evening trade (a new weapon +0.3 against a tell +0.28) shown clearly enough on the stop to make the choice real?
3. Fades and hurt habits are two-film tells by measurement: does that make them feel unfair, or is it the depth?

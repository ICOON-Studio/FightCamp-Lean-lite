# Knowledge stakes v6 - being wrong about people, and paying to be less wrong

S538, 2026-11-22. Board row KNOWLEDGE1. Map only: nothing is built by this page. Bar (owner S534): 8 on DEPTH and 8 on PLAY.
Every line tagged CODE was opened on 2026-11-22 at the file:line given. Lines tagged CODE-V5 are v5's habit facts: the
function was re-located today (line numbers below are today's), the body was last read by the S531 code check, not today.
ESTIMATE = proposed, not in the game. MEASURED = a probe result, with its file.

## 0. What changed since v5, in five lines
1. v5 was about habits only. The half that is now measured is the other one: how wrong the coach is about a person.
2. MEASURED (docs/KNOWMISREAD2_RESULT.md, 360 paired worlds): a signer who knows the truth ends with +12.1% more top-10
   boxers (95%: +5.3 to +19.6) and +3.7% more cash (+2.2 to +5.4) than one who trusts the shown number. Bout wins +1.0%
   (-0.9 to +3.0): not told from zero. Making the misread bigger is a weak lever (share 0.5 -> 0.8: +2.2 points), so
   SHARED_MISREAD stays 0.5.
3. FOUND TODAY IN THE CODE: that value exists in the rules and the probe only. No screen reads the knowledge record and no
   game code calls the paid reads (section 1, rows K4 and K5). The player cannot be wrong about a prospect today, because
   the signing card prints the exact numbers.
4. So v6 is three things in this order: SHOW the misread where a signing is decided (A), give the six unwired reads a job
   and cut them to three (B), and put the SAME misread on the opponent's file so the $250 scout has something to remove (C).
   The habit decisions of v5 stay, cut to the slices both critics could agree are buildable (D).
5. Nothing is built before its probe passes (section 5). Owner S534 order: probe on a greybox, two critics, then build.

## 1. What the game does today

### Knowing a person (the attribute side)
- **K1 CODE - `scripts/rules/Knowledge.gd:9-13`.** Three groups carry a range: body (6 attributes), skills (6), under fire
  (2). Mind (6) never has a range. Day-one half-widths 8 / 12 / 15 (`:17-19`).
- **K2 CODE - `Knowledge.gd:174-183 range_of`, `:372-376 _offset`, `:36-38`.** The shown centre is truth + offset x
  half-width; offset lies in -0.6..+0.6 and is half one per-person misread (`shared_k6`) and half the attribute's own
  (SHARED_MISREAD 0.5). Hype lifts it by up to 0.3 more, capped at 0.9 (`:39-40, :179`). The truth is always inside lo..hi.
- **K3 CODE - `scripts/state/KnowWire.gd:24-26 start`, `:38-47 day`, `:50-58 bout`, `:73-80 week_end`; callers
  `scripts/state/Roster.gd:143`, `Sim.gd:208`, `Sim.gd:296`, `BoutFinish.gd:183, :191`.** A new signing starts a fresh
  record; mornings (1/3 point), pad or sparring nights (1 point on skills), bouts (4 points under fire), a met goal (3) narrow
  it; a stoppage loss, a step up and 12 weeks without a bout widen under fire. A boxer with no record is fully seen
  (`KnowWire.gd:17-20`).
- **K4 CODE - no reader.** `grep -rlE "KnowWire|Knowledge\.gd|KnowReads" scripts/ui scripts/fight3d` returns 0 files. The
  record is kept every day and shown nowhere. The signing card prints exact values: `scripts/ui/RecruitPanel.gd:104`
  (`"%d  up to %d"` from the true stat and cap); the trial is exact by design (`scripts/ui/modals/Trial.gd:2`,
  `scripts/state/Roster.gd:124` "her stats are now known exactly").
- **K5 CODE - `scripts/rules/KnowReads.gd:24-37 price`, `:56-75 apply`, `:78-102`, `:105-119`.** Six reads exist as rules:
  look closer $120 (clears hype, else narrows the widest opened group to half its day-one width - the player does not
  choose the group), trial $500 (4 weeks x $250 / 2; body and skills +24 exposure, under fire +8 only if already opened),
  test day $60 (body, doubled under 5 bouts), recheck $40 (halves what went stale), hard spar club $0 / outside $160
  (under fire to 1/2 or 3/4; `:126-129` returns injury x2 and +15 tiredness as screen data only). No file under
  scripts/state or scripts/ui calls any of them (grep today: only `KnowReads.gd` itself preloads `Knowledge.gd` besides
  `KnowWire.gd`). They are tested (`tests/know_reads_test.gd`) and unreachable in play.
- **K6 MEASURED - `tools/knowmisread2_probe.gd:190`, `tools/knowbots4_pool.gd:30-39 shown_centre`.** The probe's "shown
  rating" is the mean of the 14 range centres. It is the probe's own aggregate; the game has no such number on a screen.

### Reading an opponent
- **O1 CODE - `scripts/rules/BoutRead.gd:31-33`, `:67-70 stage`, `:76-89 _nest`, `:93-95 rating_range`.** The opponent's
  rating is shown as a range 12 wide that nests down to 3 as tape tells are found. Its place around the truth is one dice
  roll per opponent (seeded by the name), the truth kept 20% in from either edge. There is no shared lean: the rating
  range, the stat rooms (`:117-135 stat_ranges`) and the record do not err together.
- **O2 CODE - `scripts/state/ProLadder.gd:287-309 scout`, `scripts/rules/Matchmaking.gd:40`.** One pro scout costs $250,
  opens EVERY hidden tell at once (`:302-303`), keeps the read it had (`read_before`) and marks the offer scouted. Offered
  on pro rows only (`scripts/ui/WorldCompare.gd:157-168`, `scripts/ui/ProFights.gd:236-237`). `Matchmaking.gd:126-136 scout`
  (range to 4 wide + the matchup edge) is the bots' version of the same purchase.
- **O3 MEASURED - DEPTH_AUDIT_S534 row 36.** Paying for the scout has not beaten not paying (KNOWBOTS1: -1 top-10 place;
  KNOWBOTS3: +6 places, no clear result). FAINT.

### Habits (v5's facts, with the S531 code check's three corrections applied)
- **H1 CODE-V5 - `rules/FighterProfile.gd:65`, `rules/CoachNotes.gd:26, :117, :131`, `:7 SPAR_ODDS 0.35`, `state/Sim.gd:293`.**
  Two habits a boxer; having one and having seen one are separate. A fight note takes the first unseen; film draws habits
  only; the weekly coached call rolls 35% and does not test that a spar happened.
- **H2 CODE-V5 - `rules/HabitFix.gd:42 punished, :55 cost, :62 fixable, :67 offers, :91 result`, `rules/Exchanges.gd:21
  HABIT_BOUT 1.75, :249 uptake`, `state/LiveRound.gd:58 open, :156 exchange, :406 close`.** An unfixed, matching habit takes
  6 x 1.75 = 10.5 exchange-margin points (not damage, not rounds) and blocks the normal live read (the separate NOW path can
  still add a read edge). A matching named corner fix sets it to zero. The mode-keyed habits fire on the mode, not on the
  event their text names (no jab, rope or "ahead" check).
- **H3 CODE-V5 - `rules/Recruit.gd:130 apply_focus`, `ui/FightAnalysisOwn.gd:161, :169`.** Signing focus or own film can put
  ONE habit on a four-week timer that erases it. Neither counts completed drills.
- **H4 CODE-V5 - `rules/OppFile.gd:71 tells, :125 hidden, :135 tape, :147 half_tape, :158 open, :174 remember`,
  `rules/PlanLines.gd:132 strength, :159 tell_sit`, `rules/FilmEdge.gd:40 answered`.** The opponent has its own file AND its
  own `notes_seen` (v5 said "not our notebook": true of ownership, wrong if read as "no field"). Opening a tell does not
  change line strength, but CAN change the night: tells already answered by the plan add a base edge (v5 said "no points":
  corrected).

## 2. The design

One rule, used twice: **a first look misreads the whole person the same way.** It is built for prospects (K2) and shown
nowhere (K4); it does not exist for opponents (O1). The coach's question in both places is the same: act on the number in
front of me, or pay (cash, weeks, a night, an injury risk) to find out which way I am wrong.

### A. Show it where the signing is decided (ESTIMATE; wires K2 to the screen)
- The walk-in card and the scouting list show each group as a range with its width word ("Body 58-70, rough"), never an
  exact number, until `Knowledge.known` is true for that group. One line under them: "Read so far: day one" or what has
  been done. No overall rating number is invented: the player sees three ranges and a Hyped tag, as a real coach does.
- The fighter page shows the same ranges for a signed boxer and they narrow as K3 already records; the Monday review prints
  the two lines `Knowledge.gd:313 monday_lines` already builds.
- The trial stays the strongest read but stops being exact: it applies the trial read (K5), so body and skills come out
  "good read" and under fire stays Unknown unless the trial included a hard spar. CHANGED from today (Trial.gd:2 exact).
- The stake, in the game's own money: a signing holds a roster place (`scripts/state/GymSpend.gd:218 place_blocked`; a full
  roster needs a second coach or bigger premises) and a $250 weekly stipend (`KnowReads.gd:10`). A flop found in week 10 has
  cost $2,500 and the place the better kid would have had. The signing card says exactly that: "A place and $250 a week."

### B. Three reads before signing, each answering a different question (ESTIMATE; wires K5, cuts three)
| Read | Cost | What it removes | When it is the wrong buy |
|---|---|---|---|
| Call the old gym | $120, same day | The Hyped lift only (K5 look-closer's first branch). Answers "is the talk true?" | No Hyped tag, or both answers lead to the same signing. |
| Test day | $60, next free morning | Body range (K5). Answers "is the engine real?" | The doubt is in skills or under fire; body is already a good read. |
| Trial week | $500 and 4 weeks, holds the place | Body and skills to a good read; under fire only with a hard spar (injury x2 that night, +15 tiredness - now CHARGED, today it is screen data only). | Cash under a month of bills, or a rival club's deadline is shorter than 4 weeks (prospect deadlines are held back, pack section 6: without them the trial's only cost is $500 and the place). |
- Always present: **Sign on the first look** (no cost, no penalty) and **Pass**.
- CUT: look closer's "narrow the widest group" (the player does not pick, so it is not a decision); a paid watch-spar before
  signing (same question as the trial). MOVED to the Week for signed boxers: Recheck $40 and the hard spar, as the answer to
  a range that went stale (K3) before a step-up bout.
- Each read button prints the range it will narrow and what the decision turns on, not a promise of value: "Body 58-70 now.
  A test day brings it to about 6 wide. Changes your mind only if he is under 62."

### C. The same misread on the opponent's file (ESTIMATE; the interconnect, KNOWMISREAD1 Next 3)
- New rule, same form as K2: each opponent carries ONE lean (seeded by the opponent, share 0.5) that moves the rating
  range's centre, the stat rooms and, per DESIGN_WEIGHT3, the shown walking weight THE SAME WAY. A padded record reads
  better than the man; a hard road reads worse. The truth stays inside every range (O1's promise is kept).
- What removes it: the $250 scout (O2) centres the range and names the lean in one line on the file ("Record flatters:
  five of seven wins came against boxers with losing records"). Free film nights narrow the range as today but do NOT
  remove the lean. That is the scout's job and its price.
- What it changes: take / pass / ask for another name on the Fights page; whether the light fight week or a full camp is
  bought; which line the plan trains. A scout bought when the answer could not flip any of those is $250 lost: the row says
  what it could flip before the purchase ("Chance reads 44-58%. A scout settles which side of level this is").
- Amateur bouts get the same lean with no paid scout: one coach night of film is the price there (amateurs have no camp).
- NOT added: a purse or morale bonus for knowing (both critics: unrelated reward).

### D. Habits: what stays from v5, cut to four buildable slices (ESTIMATE)
1. Truth first: ship only habits whose trigger the engine checks. Start with one mode habit, one ring-place habit, slow
   start and late fade; hold the rest back until a shared trigger resolver exists (settlement, film, forecast, corner all
   read the same function).
2. One scheduler: a habit fix is a coached pad night that displaces a move night; 25% of the open debit per completed
   night, four nights retire it; progress survives a pause or a switch to another habit; no credit on rest or injury. The
   signing focus and the own-film button both put the habit on THIS scheduler (the two free four-week timers of H3 go).
3. The ledger: store, per exchange, the debit without the fix and the debit paid. The bell and the Why print "Came up
   twice: 21 of 21 margin points kept, read open both times", "Did not come up" (never "100% saved"), or "Came up once,
   the call did not land: 10.5 lost".
4. Seen, not rolled: sparring reveals by count, not luck. A coached spar that watches one situation shows a matching unseen
   habit by the third such night at the latest; the 35% weekly roll goes. v5's "targeted film" on the opponent is CUT:
   the scout (C) and general tape already answer "what does he do", with fewer buttons.
- Booking warning: words, not thresholds ("His style puts your boxer on the ropes often. The rope habit is confirmed and
  unfixed"). The 45% / 50% colour lines of v5 are CUT as false precision until the ledger gives real frequencies.

## 3. Every menu it appears on, and what each is wired to

| Menu | CODE TODAY (read 2026-11-22) | TO BUILD (ESTIMATE) | Wired to |
|---|---|---|---|
| Walk-in / signing card | `ui/RecruitPanel.gd:104` exact "N up to M"; `:109 _who` first habit named | Three group ranges with width words, Hyped tag, "A place and $250 a week", the three reads + Sign on the first look + Pass | `Knowledge.shown` (:251), `KnowReads.apply` (:56), `GymSpend.place_blocked` (:218) |
| Trial | `ui/modals/Trial.gd:2, :18` exact stats, coach verdict | Ranges after the trial read; optional hard spar with its risk charged | `KnowReads._apply_trial` (:105), `Knowledge.hard_spar` (:124) |
| Roster | `ui/RosterCards.gd:100 _card` | One knowledge pip row (0-5) per card; no new badge | `Knowledge.pip_of` (:243) |
| Fighter overview | `ui/areas/FighterPage.gd:271 _overview` notes count and lines | Group ranges; stale causes as text; Recheck $40 where something went stale | `Knowledge.shown`, `stale_causes` (:210), `recheck_ready` (:219) |
| Week | `ui/WeekBoard.gd:229 _night_spec` pads / sparring / film / rest | Habit drill as a pad-night choice with the displaced gain; hard spar read with its risk | section D2 scheduler; `KnowWire.day` (:38) |
| Week review (Monday) | (not re-read today) | The two "narrowed by" lines per boxer | `Knowledge.monday_lines` (:313), `moment` (:302) |
| Fights page (pro offers, ask list) | `ui/ProFights.gd:236-237`, `ui/WorldCompare.gd:157-168` Scout $250 button, greyed when scouted or short of cash | The chance range leaning with the opponent's misread; the scout row says what it could flip; after: "Record flatters / hides" line and how the chance moved | `ProLadder.scout` (:287), `read` (:267), new opponent lean in `BoutRead._nest` (:76) |
| Bout offer (amateur) | `ui/areas/BoutPage.gd:23 build, :128 _answer_row` | Same range; "one film night removes the lean"; the habit warning in words | `BoutRead.rating_range` (:93), section D |
| Opponent file | `ui/OppFileCard.gd:23 build, :57 _tell_row` | The lean line once scouted; tells as today | `OppFile.tells` (:71), `open` (:158) |
| Fight prep | `ui/FightPrep.gd:41 make`, `ui/MatchupCards.gd:102 _row` | ONE matchup card: your boxer's confirmed habits + fix progress left, the opponent's tells + plan answer right, the largest open risk below | `HabitFix.offers` (:67), `PlanLines.tell_sit` (:159) |
| Corner minute and result | `state/LivePreview.gd:75 fixes`, `fight3d/FightCast.gd:59 corner` | The ledger line; "No fix" stays | `HabitFix.result` (:91), `LiveRound.close` (:406) |
| The Why / news | `state/BoutFinish.gd:227 coach_note` | Round, trigger, ledger; and after a debut: "You signed on a rough read: body came in 6 under" | section D3; `Knowledge.moment` |

## 4. Each critic item, answered

**Code check (S531), wrong or misleading v5 claims:** "not our notebook" - CHANGED (H4). "blocks the live read" - CHANGED
to "the normal live read" (H2). "opening a tell adds no points" - CHANGED (H4). "After the jab" and "21 power" - CHANGED to
mode triggers and margin points (H2, D3). Fade's text (last 60 s, round 3+) against its gate (final round) - goes to D1.

| # | Critic item | Answer |
|---|---|---|
| A1 | Every note true, every answer executable; shared trigger resolver; separate ledgers; drop the automatic film bonus | DONE in the map: D1 and D3. The film base edge is KEPT but shown on the matchup card as "already answered by your plan"; removing it changes fight balance and waits for the section 5 habit probe. |
| A2 | Charge one real resource once; one scheduler; migrate the signing timer; key half-film to opponent and purpose | DONE: D2. Half-film keying: CHANGED to "half-film progress belongs to one opponent" only; purpose-keyed film is REFUSED for now (targeted film is cut, see D4: the scout and the count-based spar cover it with fewer buttons). |
| A3 | Make the next decision comparable (booking estimate with source, next-round estimate, one choice row) | CHANGED: booking and scout rows state what the purchase could flip (B, C). The next-round exposure estimate is REFUSED until the ledger exists: it would be the false precision the same critic warns of. |
| A4 | Test for choices that reverse, with intervals | DONE: section 5; every bar is an interval and a "wins in one case, loses in another" check. |
| A5 | The finished page on Fight prep, three columns | DONE as the matchup card row of section 3; drawn by the next critics. |
| D1 | Frequency and expected value per habit | CHANGED: shown only from the ledger (observed, with the sample size); no invented percentage before that. |
| D2 | One unified matchup card | DONE: Fight prep row. |
| D3 | Reveal rates visible; guarantee by session 3 | DONE: D4 (count, not luck). |
| D4 | Every button shows its math | CHANGED: every button shows what it narrows and what decision it could flip (B, C); "could save ~X per bout" is REFUSED where X is not measured. |
| D5 | Result precision | DONE: D3. |
| D6 | Abandon a fix in progress | DONE: D2 (progress carries). |
| D- | "Knowledge is never harmful, only inefficient" | ANSWERED by A-C: with the misread shown and reads priced in weeks and places, buying knowledge can lose the prospect, the purse week or the month's cash; and acting on a first look can now be plainly wrong. |

## 5. Probes the build must pass (bars fixed here, before any run; all on the paired ruler)

Ruler: `tools/knowmisread2_probe.gd` worlds (seeds 7000 / 8000 / 9000 x 120), same world for every arm, 95% bootstrap
interval over worlds. Populations are the worlds' own prospects and opponents (all different; no identical fighters).

| Probe | Arms | Passes when | Control arm |
|---|---|---|---|
| P-A shown = measured | The game's signing card against the probe | Every group centre on the card equals `Knowledge.range_of`; 0 mismatches over the 6,113 prospects | Share 0.0 scratch copy must mismatch |
| P-B reads pay, none dominates | Blind signer / buys a read only when the top two prospects' ranges overlap / buys every read / knows the truth | The selective buyer recovers at least half of the +12.1% top-10 worth AND ends with more cash than the blind signer (interval low end > 0) AND the buy-everything signer ends with LESS cash than the selective one (low end > 0). In at least one seed set Sign on the first look must be the better call for a cash-tight club | Reads that narrow nothing must read no better than blind |
| P-C the opponent's lean makes the scout pay | Never scouts / scouts when the shown chance spans level or the bout is a step up / always scouts / knows the truth; opponent share 0.0 and 0.5 | At share 0.5: the selective scout wins more bouts than never-scout (bout wins, low end > 0; today's signing-side +1.0% is not) AND nets more cash after fees (low end > 0) AND always-scout nets less than selective AND 25 to 60% of bought scouts change take / pass / ask or the camp plan | Share 0.0 is today's game: it must read as FAINT as the audit found. If it already clears, the lean is not needed and is not built |
| P-D habits (v5 section 5, kept) | Blind / known unused / named fix / drilled / plan + fix, four habits, press- and counter-heavy opponents, different fighters | Blind = known-unused exactly; a drill beats a move night against one opponent style and loses against another; every interval reported | A never-matching fix must read zero saved |

If P-C fails at share 0.5 it is not rescued with a bigger share (KNOWMISREAD2: the share is a weak lever). The scout then
goes to the owner as "cut it or keep it" (S534).

## 6. Order of work
1. P-A greybox + the signing card ranges (A). 2. P-B, then the three reads (B). 3. P-C greybox on the opponent's lean,
then C. 4. D slices, D1 first. Each step: the menus of section 3 show it in the .exe and the golden path walks it.

## Sources read today
`scripts/rules/Knowledge.gd` (whole), `KnowReads.gd` (whole), `scripts/state/KnowWire.gd` (:14-80), `Matchmaking.gd`
(:36-62, :100-150), `BoutRead.gd` (:56-135), `scripts/state/ProLadder.gd` (:253-309), `GymSpend.gd` (:214-226), `Roster.gd`
(:86-128), `scripts/ui/RecruitPanel.gd` (:96-112), function locations for every CODE-V5 row; v5; both v5 critics;
docs/KNOWMISREAD1_RESULT.md and KNOWMISREAD2_RESULT.md. No Godot run, no probe run for this map.

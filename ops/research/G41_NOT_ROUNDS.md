# G41 — JUDO, WRESTLING AND BJJ ARE NOT ROUNDS

Grok, Expert, 2026-09-10. Driven in the in-app browser by Claude; 21 minutes,
86 sources. Research only — no schema, no tick, no module. Spliced verbatim by
Claude, who wrote this header and the HANDOFF block and changed nothing else.

**Cited editions.** IJF SOR refereeing rules as updated **21 January 2026**
(2025–2028 cycle; IJF stated the rule set locks after Ulaanbaatar GS June 2026
through LA 2028). UWW International Wrestling Rules, **January 2026** edition, in
force 1 January 2026. IBJJF Rule Book **Version 6.1, June 2024** (still the book
linked from ibjjf.com/rules).

**The engine today:** judo 1×240, freestyle 2×180 plus a full corner, BJJ 1×600.
The question is not "how long is the contest." It is what the corner is standing
in for, and where it is standing in for nothing.

---

## §1 — THE CONTEST CLOCK, PER SPORT, WITH THE ARTICLE

### Judo (IJF)

**Length.** One contest of **4 minutes real contest time** for Senior, Junior U21
and Cadet U18, men and women, individual and mixed team. IJF SOR **Art. 6**
(21 January 2026). Same figure recommended to national federations. The 10
minutes in Art. 6.2 is rest *between* contests, not inside one.

**Division.** None. There is no period 2. Golden score is not a second period.

**Clock stop — this is the gap.** Contest time is *effective* time. The clock
runs on Hajime / Yoshi and stops on Mate / Sono-mama. Older national translations
of the same article still say it in one sentence: the interval between Mate and
Hajime, and between Sono-mama and Yoshi, does not count as contest time. Current
**Art. 11 (Mate)** and **Art. 12 (Sono-mama)** are the stop commands. *Our
continuous tick has no word for this.*

- **Mate** is the ordinary halt: out of area without a live action, prohibited
  act, injury, judogi/hair, dead ne-waza, standing shime/kansetsu, the 2 m
  safety-zone limit in tachi-waza, or any other case the referee needs. After
  Mate the athletes usually return to the start marks and wait for Hajime.
- **Sono-mama** is a freeze in ne-waza only. Positions and grips stay. Yoshi
  restarts them in place. Clock is still stopped.

**Osaekomi has its own clock** (Art. 7: yuko 5–9 s, waza-ari 10–19 s, ippon 20 s
— yuko returned on 21 January 2026; the board itself is G40, not this paper). The
contest clock keeps running during osaekomi. If osaekomi starts in regular time
and the horn would fire first, **Art. 8** extends the contest until ippon /
equivalence, Toketa or Sore-made. Golden-score osaekomi is not an extension
problem; it ends the contest when it scores.

**Between divisions.** There are none inside the contest. Between contests: 10
minutes (Art. 6.2). Not a corner.

**Overtime.** Golden score. Referee calls Sore-made, athletes return to start
marks, clock is reset, Hajime. **No rest. No time limit.** Scores and shido
carry. First technical score (yuko / waza-ari / ippon) or hansoku-make ends it.
This is a *continuation of the same contest*, not a new period. Current since the
mid-2010s (unlimited GS, no hantei). **Superseded:** timed golden score (once 3
minutes) plus flag decision — dead.

**Belt / age / level.** IJF senior/junior/cadet World Tour: all 4 minutes real
time. National kids' times exist; they are not in the IJF SOR table and are not
this engine's problem.

### Freestyle wrestling (UWW)

**Length.** Seniors, U23, U20: **two periods of 3 minutes with a 30-second
break.** U15, U17, Veterans: two periods of 2 minutes with a 30-second break.
UWW **Art. 22** (January 2026). Boards count down 6:00→0:00 (4:00→0:00 for the
short categories). **Winner is the addition of points from both periods** at the
end of regular time. Fall or technical superiority (10 points FS/WW, 8 GR) ends
it whenever it happens.

**Division.** Two periods of one bout. Not two bouts. Not two scored rounds. The
2013 FILA "best of three periods" system is **superseded and must not be
rebuilt.**

**Clock stop.** Period time is running time inside the period. The referee's
whistle starts, interrupts and restarts (**Art. 18 / Art. 26 / Art. 28**). The
clock does not run during injury, bleeding treatment, out-of-bounds reset,
illegal-action stop, challenge consultation, or the 30-second period break.
**Blood has its own accumulated cap:** 4 minutes across the whole bout from the
moment the doctor starts treatment (**Art. 26.f**, 2026 text: the chronometer
starts when the doctor begins *treating*, not merely when he steps on the mat —
that start-line was restated in the 12 December 2025 update). Exceed it and the
bleeder loses by injury. After treatment the bout resumes **in the same
position.**

Out of bounds does not eat period time while they walk back. **Art. 28**: stop,
restart centre standing or parterre depending on who caused it and what position
they were in.

**Between divisions.** The **30-second break** in Art. 22. Coach may give water
and must wipe the wrestler dry (**Art. 30**). No other substance. Coach on the
mat only then. This is the only sanctioned intra-bout interval. Between bouts: 20
minutes (Art. 23).

**Overtime. None.** Art. 29 tie-break is criteria on the completed bout, in
order: highest-value hold, most such holds, fewest cautions, last technical point
— with the published 1–1 passivity exceptions for freestyle. The 2026 update
clarified those criteria; it did not add a period. **Refuse by name:**
NCAA/folkstyle sudden victory and 30-second tiebreakers; the circulating "first
to three points" overtime; any extra period.

**Belt / age / level.** Age-group period length only (2×3 vs 2×2). No belt.
Passivity procedure is slightly different for U15/U17/Veterans (shorter periods,
verbal warning dropped — Art. 46, restated 2026).

### BJJ (IBJJF)

**Length.** One continuous match. Adult (≥18), **Art. 1.3** table, Version 6.1
June 2024:

| Belt | Time |
|---|---|
| White | 5:00 |
| Blue | 6:00 |
| Purple | 7:00 |
| Brown | 8:00 |
| Black | 10:00 |

Master 1 (≥30): White/Blue 5:00, Purple/Brown/Black 6:00. Master 2–7: 5:00 all
belts. Juvenile I/II: 5:00 in the 6.1 table. Kids scale 2:00–4:00 by age year.
Age is (current year − birth year), not birthday.

**That is why `bjj — rounds 1, round_seconds 600` is only true for adult black
belt. White belt is 300 seconds. The engine has one number.**

**Division.** None. No periods. No break.

**Clock stop.** **PAROU** stops the stopwatch. **COMBATE** starts it. Art. 1.4.1
command table, 6.1: PAROU = "interruption of the fight, stopwatch and time out."
The clock is not a continuous tick. Stop reasons: **Art. 1.3.6–1.3.7** (out of
area, position reset, gi, medical, stalling procedure). Athletes must hold
position when stopped if they can.

**Between divisions.** There are none inside the match. **Art. 1.4** rest is
*between* matches: equal to that division's regulation time up to the semi;
double that time before a final. The column in the Art. 1 table that reads
"FINAL MATCHES / Double regulation match time" is **rest, not contest length.**
**Refuse by name:** doubled-finals-match-time as a fight clock. Not in the book.

**Overtime. None in the IBJJF book.** Tie order is points, then advantages, then
penalties, then referee decision (**Art. 2.6**). **Refuse by name:** IBJJF golden
score, IBJJF sudden death, "advantage overtime." Local promotions run those. The
federation does not.

**Belt / age / level.** This is the variation that actually moves the clock.
Adult black and adult white are different contests. Masters compress. Kids
compress further. Illegal-technique tables also move by belt and age; that is not
a clock fact and is out of scope here.

---

## §2 — WHAT REPLACES THE CORNER

A boxing corner is **rest plus work**: stool, minute, cuts, wind. Recovery credit
in our model is that object. **None of the three sports publish that object
inside the contest.**

### Judo — nothing. Stops only.

- **Mate is a STOP.** Athletes stand on the marks. No stool, no water as a right,
  no allocated seconds. Duration is whatever the referee needs to award shido,
  fix a judogi, or call a doctor. Then Hajime. Wear is not credited; the contest
  clock simply did not run.
- **Sono-mama** is a shorter STOP in place. Still not rest.
- **Golden-score reset** is Sore-made → walk to marks → Hajime. The book says
  there shall be **no rest period**. Inventing one would be a rule.
- The 10 minutes in Art. 6.2 is between contests on the same day. **Wrong
  layer.**
- **Medical Mate** is treatment under Art. 20, not recovery. Bleeding protocol
  exists; it is not a corner.

### Wrestling — a 30-second stop that is slightly more than a stop, and is not a corner.

Art. 22's 30-second break is the only sanctioned intra-bout interval. **Art. 30:**
water, dry towel, coach talk. Wrestlers go to their colour corner. Thirty
seconds. **No stool-work, no cutman minute, no "round over" scorecard.** Then
period 2, same bout, same cumulative card.

Injury / blood interruptions (Art. 26) send them to the corner and allow coach
talk, but the clock that matters there is the four-minute blood cap, not
recovery. Resume same position. That is a **STOP with medical work**, not rest.

Activity-time 30 seconds (Art. 46 FS) is the *opposite* of a corner: the period
clock keeps the contest live while a passivity sub-clock runs.

### BJJ — stops and resets. No rest.

**PAROU is a STOP.** If the position is stable and two-thirds out, Art. 1.3.7
restarts them in that same position at centre. If standing-out or unstable
ground-out, it stands them up at centre. If a submission is live in the safety
area, it does not stop. None of those intervals have a published duration. None
are rest. The athlete who was being passed is still being passed after the walk.

Medical PAROU: doctor to the mat (Art. 1.3.11). Cramp is a loss. Uncontrolled
bleeding after two treatments is a loss. **No recovery credit.**

20-second lack-of-combativeness / 50-50 counts (Art. 6.2.1, 7.3.1) are live
contest time with a sub-clock, then a possible stand-up restart. Not rest.

### Direct answer

**Judo:** no sanctioned recovery interval inside the contest. **Wrestling:** 30
seconds of water and a towel between two periods of the same bout — rest in the
thin sense, not a corner. **BJJ:** no sanctioned recovery interval inside the
match.

A stopped clock with two people standing still is not a minute on a stool. **The
model cannot say that yet, and the books do not give it a number to copy.**

---

## §3 — THE SCORING UNIT WHEN IT IS NOT A ROUND

### Judo

Already built (G40 / `JudoBoard`). Unit is the **technique and the penalty**, not
a period. Ippon, waza-ari-awasete-ippon, third shido end it whenever they happen.
There is no card at "end of round" because there is no round. Officials: one
referee on the mat, table / CARE supervisors. **Not three judges writing a
round.** "He won round 2" has no meaning. Golden score is still the same board.

### Wrestling

**Cumulative across the whole bout.** Art. 22: winner by addition of the points
in both periods. Art. 29: if the totals tie, criteria on the whole bout, not
"period 2 belongs to red."

No judge's card in the boxing sense. Officiating body is three: referee, judge,
mat chairman (**Art. 15**). They award points in real time onto **one running
total.** Classification points (Art. 41: 5:0 fall, 4:0 / 4:1 superiority, 3:0 /
3:1 decision) are tournament ranking, produced when the bout ends, not per
period.

"He won round 2" is leftover English from the pre-2013 best-of-three-periods
system. Under the current book it means nothing. **Period 2 existing does not
make period 2 a scoring unit.**

### BJJ

**Cumulative across the whole match.** Art. 3: points on 3-second stabilization.
Art. 5: advantages. Art. 7: penalties. One running total. If that total, the
advantages and the penalties are tied at the horn, the central referee (or
two-of-three in a three-ref crew, Art. 1.2) gives a decision. No round card. No
"won the first five minutes."

Officials: central referee is the scoring official. Corner referees, when used,
confirm. Table is administration. **Not boxing judges.**

### Plain

**Of the three, none have judges in the sense this engine means** — three people
scoring a closed unit of time. Judo is referee plus supervisors on a technique
board. Wrestling is a three-person body writing a running total. BJJ is a referee
writing a running total, with a decision only if the total is empty of
difference.

---

## §4 — THE REFUSALS

(More than three. None of them are polite.)

1. **A stopped contest clock.** Mate, Sono-mama, the wrestling whistle, PAROU.
   Wear, stamina and "time left" in these sports are functions of *live* seconds,
   not wall seconds. The engine ticks through them. **That is not a missing
   parameter. It is a missing kind of time.** *Candidate confirmed.*

2. **A referee-ordered position reset.** Wrestling Art. 28 (stand vs parterre,
   who caused the stop). IBJJF Art. 1.3.7 (same position at centre vs both
   standing). Judo Mate almost always returns them to the marks; Sono-mama does
   not. The corner cannot stand in for this. A reset is not rest and it is not
   "between rounds." *Confirmed.*

3. **Per-belt, per-age contest length.** IBJJF Art. 1.3. Adult white 5:00, adult
   black 10:00, Master 2 black 5:00. **One `round_seconds = 600` is a wrong
   sport.** *Confirmed.*

4. **Sub-clocks that are not the contest clock.** Judo osaekomi clock (Art. 7)
   and the Art. 8 extension around it. Wrestling 30-second activity period
   (Art. 46 FS) running inside a live period. IBJJF 20-second combativeness /
   50-50 counts (Art. 6.2.1) running inside a live match. **Passivity and shido
   are NOT "only while standing" as a single shared rule**: judo shido is standing
   and ground under current combativity language; wrestling activity time is a
   designated wrestler in a live period; BJJ stalling is positional. The
   candidate "passivity or shido clocks that run only while standing" is
   **half-true and must not be coded as a universal.** *Named and limited.*

5. **Golden score as a new round.** It is not. Carry-over, no rest, unlimited,
   same board. Treating GS as round 2 would invent a corner the SOR forbids.

6. **"End of the round" stoppage language.** Judo and BJJ have no such moment.
   Wrestling's gong ends a period, and points already on the board stay; it does
   not produce a card or a recovery credit. Several striking rulesets ask "at the
   end of the round." **These three do not.**

### Unsourced items refused BY NAME, G39-style

- WFMC-style clinch clocks, or any five-second grappling clock not in these three
  books.
- IBJJF overtime / golden score / sudden death.
- Doubled IBJJF finals match time (that column is **rest**).
- UWW overtime, sudden victory, "first to three."
- Pre-2013 FILA period-winners.
- Timed judo golden score plus hantei (superseded).
- **A published recovery-credit number for Mate, PAROU, or the wrestling blood
  stop. The books are silent. Circulating gym numbers are unsourced.**

---

## §5 — WHAT YOU WOULD NOT CHANGE

Three grappling rulesets sit on an engine shared with eight striking ones. The
corner is load-bearing for those eight. Collapsing genuine commission differences
into one authored corner was the right call there. **The same call applies here.**

### Worth building, if anything — and only as DATA, not as a new tick

1. **IBJJF duration as a table on belt × age division.** The book already
   publishes it. Players will notice a white-belt match that lasts ten minutes,
   and they will not notice a 20-second 50-50 count.
2. **Wrestling's two periods with a 30-second stop between them, points added, no
   card.** That is the one intra-bout interval that actually exists, and the
   current `2×180 plus a full corner` is the measured wrong number this task
   opened with.
3. **The fact of a stopped clock, as a flag** a future slice could honour,
   without rewriting the loop for eleven sports. Judo "4 minutes real time" is
   otherwise a lie on a continuous tick.

### Depth nobody will ever see. Leave it.

- Sono-mama versus Mate as two stop types. Real. Invisible to a management-game
  player.
- Osaekomi extending regular time (Art. 8). The board already ends the contest.
  The extension is refereeing furniture.
- Wrestling blood's four-minute accumulated cap and the 2026 "clock starts when
  treatment starts" clarification.
- Wrestling Art. 29 tie criteria and the 1–1 passivity exception.
- IBJJF same-position versus stand-up reset tree, three-ref confirmation,
  video-replay referees.
- Juvenile / Master 3–7 duration cells, kids' 2:00–4:00 ladder.
- Challenge procedures, CARE, mat-chairman soft-object-at-the-gong.
- **Any attempt to simulate "recovery during Mate" with an invented credit. The
  books do not give one. Building on an invented number is worse than the gap.**

### Do not touch

- The shared round/corner loop for the eight striking rulesets.
- `JudoBoard`. It already ends the contest on the right events. **This paper is
  the clock, not the board.**
- A per-ruleset tick rewrite so three sports can freeze wear while a referee ties
  a belt.

### The honest finding

The same shape as the corner-rules call: **the vocabulary is boxing's; three
sports do not speak it; most of the missing words are words no player reads.**

The one number that is simply wrong on the screen today is **wrestling's full
corner between two periods that only add**, and **BJJ's single 600 for every
belt.**

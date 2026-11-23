# Knowledge stakes v7 - a wrong first look, three ways to be less wrong, and a rival gym's clock

S539, 2026-11-23. Board row KNOWLEDGE1. Map only: nothing is built by this page. Bar (owner S534): 8 on DEPTH and 8 on PLAY.
Every line tagged CODE was opened on 2026-11-23 at the file:line given (main after 053597329). ESTIMATE = proposed, not in
the game. MEASURED = a probe result, with its file. Words: "the prospect", "your boxer", "they"; no fixed he or she.

## 0. What changed since v6, in seven lines
1. THE CLOCK (owner Q-S294-305, asked "Prospects: a rival gym signs them in 1-3 weeks unless you decide?": "Yes, add the
   deadline"). Every prospect has a rival gym and a last day, 7 to 21 days out. Every read spends days of it (section 2C).
2. ONE RANGE SYSTEM, MADE AT FIRST SIGHT. The prospect list printed the truth in the middle of its range (L1 below). That
   list formula and `Roster.scouted_range` go; every screen reads `Knowledge.shown`.
3. NOTHING JUMPS TO EXACT. Today a group turns into the true number at 60% read (L3). In v7 a range only narrows.
4. HYPE IS CUT (L2: it was never wired). So is "Call the old gym", whose only job was to clear it.
5. THE TRIAL IS ONE WEEK, not four: a four-week trial cannot fit a clock of three weeks.
6. THE CEILING AND THE HEART are now unknowns too (2A): potential is a range that leans with the rest, and the
   under-pressure trait is "not seen yet" until a hard spar or a first bout.
7. HABITS (v6 section D) leave this map for their own (HABITS1, next row). The opponent's record (v6 section C) stays as a
   gated slice (2E): nothing of it is built before its own probe and the owner's word on an older ruling.

## 1. What the game does today

### The three defects a code check found in v6, re-read today
- **L1 CODE - the answer leaks.** `scripts/ui/areas/Fighters.gd:216-223` draws each prospect group as the true value
  minus 5 to plus 5 (`Data.SCOUT_SPREAD`, `scripts/state/Data.gd:224`). `scripts/state/Roster.gd:103-105 scouted_range` is
  the same formula; grep today finds no caller. The middle of the printed range IS the truth. Same pattern in
  `scripts/state/HomeJuniors.gd:74-75` (news prints potential minus 5 to plus 5) and in `Roster.gd:117` (the trial verdict
  is "good" exactly when potential is 80 or more). `scripts/ui/RecruitPanel.gd:104` prints "N up to M" from the true stat
  and the true cap; `:113` prints both personality traits.
- **L2 CODE - hype is unwired.** `scripts/rules/Knowledge.gd:292-299 set_hyped / clear_hype / is_hyped` exist; grep today:
  only `KnowReads.gd:79-80` and two tests call them. `range_of` (`:174-183`) lifts the range only by a `hype` argument no
  caller passes, so clearing the flag changes nothing shown. `hyped_centre_offset` (`:285-290`) is a second, unused formula.
- **L3 CODE - the trial jumps to exact.** `scripts/rules/KnowReads.gd:105-111` adds 24 exposure to body and skills. With
  `Knowledge.gd:106` (half-width = 0.5 + (start - 0.5) / (1 + exposure / 12)) that is 67% of the range gone, past
  `KNOWN_SHARE 0.6` (`:43`), and `shown` (`:251-261`) then returns the truth itself. Every group does this at 60%.
  Beside it: the prospect trial in play is not this read at all. It is free, the next Monday (`Roster.gd:87-99`), and the
  card after it is exact (`scripts/ui/modals/Trial.gd:2, :18, :29`).

### What else the design stands on
- **K1 CODE - `Knowledge.gd:9-13, :17-19`.** Body (6 attributes), skills (6), under fire (2) carry a range; day-one
  half-widths 8 / 12 / 15. Mind (6) is always exact (`:253-256`). Under fire reads Unknown until opened (`:100-101`).
- **K2 CODE - `Knowledge.gd:174-183, :372-376`.** Shown middle = truth + offset x half-width; offset is -0.6..+0.6, half
  of it one per-person misread (SHARED_MISREAD 0.5, `:38`). The truth is always inside the range, in its middle 60%.
- **K3 CODE - no record before signing.** `scripts/state/KnowWire.gd:24-25 start` is called only inside
  `Roster.gd:143 sign_fighter`. A prospect has no record; a boxer with none is fully seen (`KnowWire.gd:17-20`).
- **K4 CODE - no screen reads it.** As v6 K4: grep for KnowWire / Knowledge / KnowReads under scripts/ui returns nothing
  today. `KnowReads.apply` (`:56-75`) returns a cost for the trial only; no code charges the other prices.
- **K5 MEASURED - docs/KNOWMISREAD2_RESULT.md (360 paired worlds).** A signer who knows the truth ends with +12.1% more
  top-10 boxers (95%: +5.3 to +19.6) and +3.7% more cash (+2.2 to +5.4). Bout wins +1.0% (-0.9 to +3.0): not told from
  zero. A bigger misread is a weak lever. So the stake must come from what a wrong signing costs and from more decisions
  resting on the read, which is what the clock adds.
- **D1 CODE - a deadline already exists for one kind of arrival.** A beaten opponent who asks to train here waits at
  reception 7 days (`scripts/rules/CardAsk.gd:23`), may be given one trial Monday, and "1 time in 4 the old club talks the
  boxer round first" (`:26 TRIAL_LOSS 0.25`, `scripts/state/VisitWire.gd:142-160`, said on the card at
  `scripts/ui/modals/Interview.gd:71`). The top bar already stops on that last day (`scripts/state/Clock.gd:63`). Scouted
  prospects have no clock: all five named ones are on the list from day one (`Career.gd:124`, `Data.gd:229-251`).
- **D2 CODE - a boxer who leaves already boxes on in the region.** `scripts/state/Leaving.gd:98, :108-112 rival_row`
  turns a boxer into a row of `c.rivals` at the new club; `scripts/state/Region.gd:140` puts every such row on the region's
  shows and `:189-192` moves its record and rating; `scripts/state/Newcomers.gd:53-80` already makes new region novices
  with a club and a seeded past. Letting a signed amateur go is free in cash and costs reputation (`Leaving.gd:59-61`;
  the size was not re-read today).
- **D3 CODE - the ceiling is half-hidden already.** `RecruitPanel.gd:41-47` shows potential as a star range, exact for the
  Amateur coach (`scripts/rules/HeadCoach.gd:36, :69 sees_potential`). Row `:104` then prints the exact cap anyway.

## 2. The design

One sentence: **a first look misreads the whole person the same way; a rival gym has had its own look and a date; you can
sign on the hunch, spend days and money to look again, or wait - and each is sometimes the right call.**

### A. What the card shows (wires K2; fixes L1 and L3)
- A record is made the day a prospect is first seen (list, reception, visit) and is carried into the signing instead of
  being started there. The list, the signing card, the trial card and the fighter page all draw `Knowledge.shown`.
- Per group one line: "Body 56-72, rough". One rule for numbers everywhere: **a single number is printed only when the
  range is 1 wide.** `shown` stops returning the truth at 60%; 60% only changes the word to "good read".
- CEILING (ESTIMATE): "up to 70-88", half-width 9, leaning with the same shared misread, so a prospect read high is read
  high on the ceiling too. It narrows by half after 8 signed weeks and again on the first bout; no pre-signing read
  moves it. The Amateur coach sees it exact (the edge that exists, D3): that edge now removes the biggest unknown.
- HEART (ESTIMATE): of the two traits the card prints today, the one about pressure ("Folds when hurt", "Big heart",
  "Short fuse") reads "Not seen yet" until a hard spar or a first bout. The other shows at first meeting.
- The stake line, unchanged from v6: "A place and $250 a week." Under it, new: the clock line (C).
- Each read's result is a before / after strip per group plus what is still unread ("Under fire: still unknown").

### B. Three reads, three different questions, three different prices in days
| Read | Cash | Days of the clock | What it answers | When it is the wrong buy |
|---|---|---|---|---|
| Test day | $60 | 1 (next morning) | "Is the engine real?" Body 16 wide to about 7 (CODE: exposure 16, `KnowReads.gd:114-119`) | The doubt is in skills or heart; body cannot change the answer |
| Trial week | $125 | 7, a place held, and 1 time in 4 the rival talks them round during it (the game's own rule, D1) | "Can they box, and what are they like when hit?" Skills 24 wide to about 9, body to about 8.5 (ESTIMATE: exposure 24 / 12). Optional hard spar on the last day: under fire opens (about 19 wide), the pressure trait shows; injury x2 that night and +15 tiredness, CHARGED (today screen data only, `KnowReads.gd:126-129`) | Fewer than 7 clear days; cash under a month of bills; the place is needed for a better name |
| Watch them box | $0, your evening (no coached night at the club that day) | Waits for the date | Only when the prospect boxes on a region show inside the clock: under fire opens rough (ESTIMATE: a quarter of the way, about 23 wide), the record moves | No bout inside the clock; a win there also makes the rival move 3 days sooner |
- Always present: **Sign now**, **Wait** (Continue), **Pass**.
- A trial never reads past "good read": after test day + trial the body is still about 5.5 wide.
- Every read button says what it could change, in the pattern Camp already uses for film (`scripts/rules/TellWorth.gd:1-8`,
  wired at `scripts/ui/modals/Camp.gd:199`): "Body 56-72 now, about 7 wide after. The region's level here is 60: about
  1 time in 4 this read puts them under it." The level is the mean rating of the division's sheet (the number
  `Newcomers.gd:65-70` already computes); the odds come from the shown range only, never from the truth.
- CUT from v6: Call the old gym (L2), Recheck $40 as a button (its halving of what went stale is folded into the hard
  spar on the Week), look closer, the 0-5 pip row.

### C. The rival gym's clock (owner Q-S294-305)
- **Who.** A named club from the prospect's own division sheet (the clubs `Newcomers.gd:62-68` collects).
- **How long (ESTIMATE).** 21 days, minus 7 when the record reads well (3 or more bouts, wins at least twice the losses),
  minus 7 when the rival's OWN first look rates them above the region's level. The rival's look is the same range rule with
  its own seed: the rival can be as wrong as you. Floor 7. A home junior: 21. The bout visitor keeps the 7 days it has (D1).
- **What the player sees.** One line on the card and on the list: "Lynn AC want this one: they sign on Mon 26 Jan (9 days)."
  or "Lynn AC are having a look: Mon 9 Feb (20 days)." Hover: "Another gym's coach has had one look, like yours, and can
  be as wrong as yours. A short clock means they liked what they saw. Every read below spends days of it."
  The top bar's Continue stops on the last day ("to Mon 26 Jan, Lynn AC sign the prospect"), as it does for the visitor.
- **What each choice costs on it.** Sign now 0. Test day 1. Trial 7 (the button is greyed with its reason when fewer than
  7 clear days are left). Watch them box: until the bout. Wait: a day a day.
- **So the short clock is itself a read, and a noisy one.** A 7-day clock says "someone else rates them" and leaves room
  for a test day or the hunch, never both a trial and a second thought.
- **When it runs out.** The rival signs them. They become a row in the region at that club (D2: the same `rival_row` a
  leaving boxer gets, with the rating taken from their true stats instead of the flat `LEFT_RATING`), box on the region's
  shows, climb or not, and can be offered as an opponent to your boxer in that division. Cheap: one append; Region does
  the rest today. Pass does the same, on the last day.
- **The ones that got away (the feedback v6 lacked).** Find a fighter keeps a short list: "Signed by Lynn AC, 26 Jan.
  3-0 since. Your last read: body 56-72. The region rates them 66." A news line on their first title or on the night
  they box your boxer.
- **Why prospects must now arrive in turn.** Five clocks starting on day one would empty the list by week 3. So names
  arrive one at a time (ESTIMATE: one every 4 to 6 weeks, the first in week 2, at most two open at once): the five named
  prospects in a seeded order, then region novices offered through the conversion the visit already uses
  (`CardAsk.gd:147-165 walkin`). The list says when the scout expects the next: "Next name: about 2 weeks." Two open at
  once, one place: the side-by-side strip shows both sets of ranges and both clocks.

### D. When each call is right (the claim the probe must prove)
- **Sign now** wins when the clock is short, the ranges sit clear of the region's level whichever way they lean, or cash
  is tight enough that $125 and a held place hurt more than a flop.
- **Look again** wins when one group straddles the level and that group is the one a read can reach in the days left.
- **Wait** wins when the next name is due inside this clock and there is one place; when Friday's dues pay for the read
  you cannot afford today; or when they box on Saturday and under fire is the doubt.
- **Pass** wins more often than v6 allowed: a pass is now seen (the got-away list), not silent.

### E. The opponent's record (gated; not part of this build)
v6 gave every opponent a rolled lean so the $250 scout had something to remove. Two true objections: a rolled lean that
only the scout sees past passes its probe by construction, and `scripts/rules/Matchmaking.gd:139-140` records "S416: the
read never leans" (a code comment; whose ruling it was has not been established). CODE correction to v6: the opponent's
stat ranges already move with the rating range (`scripts/rules/BoutRead.gd:117-134`); only the record is independent.
v7: the lean, if any, is COMPUTED from the opponent's kept record (`r["bouts"]`, seeded by `RivalPast`): the share of wins
against boxers with losing records. Real case: Peter McNeeley, 36-1 against a soft schedule before Tyson in 1995. First
probe P-C on a greybox; if it passes, the owner is asked whether to overturn S416; only then a map. If it fails, the
scout goes to the owner as "cut it or keep it" (S534).

## 3. Every menu it appears on, and what each is wired to

| Menu | CODE TODAY (read 2026-11-23) | TO BUILD (ESTIMATE) | Wired to |
|---|---|---|---|
| Top bar, Continue | `state/Clock.gd:60-63` stops for a trial day and the visitor's last day | Also stops on a prospect's last day, named | prospect `expires` (new), `Clock` candidates |
| Needs strip | `state/Needs.gd:63-66` "Trial today" | "Last day: Lynn AC sign <name> tomorrow"; "Trial week ends today" | same |
| Fighters > Find a fighter | `ui/areas/Fighters.gd:185-232` truth minus 5 to plus 5, Invite to a trial (free) | Group ranges with width words, ceiling range, the clock line, the three reads + Sign now + Pass, "Next name: about N weeks", the got-away list | `Knowledge.shown` (:251), `KnowReads.apply` (:56), new prospect record and clock |
| Roster, Scouted for you | `ui/RosterCards.gd:316-318, :353-354` up to four cards, a trial pill | Up to two open cards, each with its clock pill ("9 days") | prospect `expires` |
| Signing card (walk-in, visit, prospect) | `ui/RecruitPanel.gd:41-47` star range, `:104` exact "N up to M", `:113` both traits | Ranges, ceiling range (exact with the Amateur coach), the pressure trait "Not seen yet", "A place and $250 a week", clock line, read buttons with what each could change | `Knowledge.shown`, `HeadCoach.sees_potential` (:69), `GymSpend.place_blocked` |
| Two prospects side by side | none | Both range sets, both clocks, the one place | the two prospect records |
| Trial | `ui/modals/Trial.gd:2, :18` one free Monday, exact stats, verdict from potential 80+ (`Roster.gd:117`) | A week: before / after strip, the hard-spar choice on the last day with its risk, the verdict from the read not the truth, what is still unread | `KnowReads._apply_trial` (:105, new numbers), `Knowledge.hard_spar` (:124), `CardAsk.TRIAL_LOSS` (:26) |
| Fighter overview | `ui/areas/FighterPage.gd:271 _overview` | Group ranges with "last read: trial week, 3 weeks ago"; what went stale and that a hard spar or a bout answers it | `Knowledge.shown`, `stale_causes` (:210) |
| Week | (not re-read today) | Hard spar as a night choice with its risk; it also halves what went stale | `Knowledge.hard_spar`, `recheck` (:213) |
| Monday review | (not re-read today) | A line only when a group's middle moved 5 or more, or its word changed | `Knowledge.moment` (:302), `monday_lines` (:313) |
| The Why after the first bout | (not re-read today) | "Under fire opened: 49-57. Your first look had the middle at 63." and the pressure trait, if still unseen | `KnowWire.bout`, `Knowledge.moment` |
| News | `state/HomeJuniors.gd:74-75` potential minus 5 to plus 5 | The junior's ceiling as the range the card will show; "Lynn AC sign <name>"; got-away results | prospect record; `Leaving.rival_row` shape (:108) |
| Fights (amateur offers) | region rows offered by division (`state/Region.gd:140`) | The one who got away can be the name on the sheet, tagged "you passed" | `c.rivals` row with `passed_by` (new) |
| Head coach choice | `rules/HeadCoach.gd:36` "Exact potential, no range" | Same words; now true on every card | `sees_potential` |

## 4. Each critic item, answered

**The three code defects:** leak - FIXED (A, L1). Hype - CUT (L2, 0.4). Trial jumps to exact - FIXED (A, B, L3).

| # | Item (first critic's list) | Answer |
|---|---|---|
| 1 | No exact numbers on the signing card, trial result or opponent file | DONE for prospects and signed boxers (A). The opponent file is 2E, gated. |
| 2 | A 0-5 knowledge pip row on Roster cards; ranges with last-updated text on the fighter page | Pip row REFUSED (the other critic: a number with no action; owner S398, only what the player can act on). The fighter page line is DONE. |
| 3 | Wire the three reads; the range updates at once | DONE: before / after strip (A, B). |
| 4 | Run the scout probe first; cut the lean if it fails; show what the scout could flip, and before / after | DONE as the gate in 2E. |
| 5 | A stale warning and Recheck $40 as a regular small decision | CHANGED: the stale line with its cause is shown; the $40 button is CUT (it halves a small widening and never changes an answer); the hard spar does that job at a real price. |
| 6 | The ledger at corner, result and Why | MOVED to the habits map with all of v6 section D. |
| 7 | Say what the trial does not reveal | DONE: every read lists what is still unread. |
| 8 | Two prospects side by side | DONE (C: two open at once, one strip). |
| 9 | One free film night per opponent; a line on why amateurs read free and pros pay | MOVED with 2E. |
| 10 | Missing: "sign rough and fix later" | DONE: it is Sign now. |
| 11 | Missing: a cheaper partial scout | REFUSED: a second price on a purchase not yet shown to pay. |
| 12 | Useless: a free club spar | CHANGED: the hard spar's risk is charged, so it is no longer free. |
| 13 | Reads do not compete; no weekly hook; the reward comes late; the risk is hard to weigh | ANSWERED by C and D: the clock makes the reads compete for days, a name arrives every few weeks with its date in the top bar, each read ends in a reveal, and the got-away list shows what a pass cost. |

| # | Item (second critic's list, code-checked) | Answer |
|---|---|---|
| 1 | One range system, created at first sight; delete `Roster.scouted_range` | DONE (A). |
| 2 | The ceiling under a range, drawn against your best boxer; the Amateur coach sees it exact | DONE (A, D3). |
| 3 | Heart and head under a range, opened by a hard spar or a first bout | CHANGED: not three numeric ranges; the pressure trait is hidden until seen (A). Coachability and temper as numbers are not shown to the player today, so a range on them would be new numbers with no screen. |
| 4 | Make hype real | REFUSED, hype CUT. A tag with a known lift is no unknown; a hidden one is a second misread doing the first one's job, and KNOWMISREAD2 measured a bigger misread as a weak lever. The rival's short clock now carries "someone talks them up". |
| 5 | Drop the jump to exact at 60% | DONE (A). |
| 6 | A rival gym's deadline on every prospect | DONE (C), on the owner's yes. |
| 7 | Feedback both ways: a price to let a flop go; "you passed on" news | DONE for the pass (C). Letting go keeps the price the game charges today (reputation, D2); no second fee is added. |
| 8 | The reveal as a moment; Monday lines only when they matter | DONE (A strips, section 3 Why and Monday rows). The wording differs: the truth is always inside the range (K2), so the line is where in the range it fell, never "under your read". |
| 9 | The opponent's lean from the real record; say it overturns S416 | DONE as 2E, gated. |
| 10 | Every read button says what it could change, in the film-worth pattern | DONE (B). |
| 11 | Split the habits off | DONE (0.7). |
| 12 | Fix the probes: flips, overlap, visibly wrong, the computed lean | DONE (section 5). |
| 13 | Cut the pip row and Recheck; fix the fixed "he" lines | DONE. |
| c1 | No record before signing | TRUE (K3). Fixed in A. |
| c5 | Test day is about 7.4 wide, not 6 | TRUE. Corrected in B. |
| c6 | Only the trial returns a cost | TRUE (K4). The build charges each read through `c.pay`. |
| c7 | Opponent stat ranges already move with the rating range | TRUE (2E). |
| c9 | The four-week $500 trial was an unflagged change | TRUE. v7 flags its own: one paid week replaces one free Monday. |
| c10 | Two line numbers off by one in `Matchmaking.gd` | Not so on today's tree: `SCOUT_COST` is at :40 and `scout` at :126-136. The critic read a copy two days older. |
| c11 | The film-worth pattern exists and is wired | TRUE; reused (B). |

## 5. Probes the build must pass (bars fixed here, before any run)

Ruler: `tools/knowmisread2_probe.gd` worlds (seeds 7000 / 8000 / 9000 x 120), the same world for every arm, 95% bootstrap
interval over worlds, the worlds' own prospects (all different). Cash is the first measure (tightest interval, +/- 1.6
points); top-10 boxers the second. Every result prints its population and how many decisions each world held.

| Probe | Arms | Passes when | Control arm |
|---|---|---|---|
| P-A no leak, no jump | Every prospect and signed boxer, every screen line | 0 lines print a truth while the range is over 1 wide; a guesser who takes the middle of the shown range misses by at least 0.25 x the half-width on average; no group's width falls by more than half in one day outside a named read | Today's list formula (truth +/- 5) must FAIL: its guesser misses by 0 |
| P-B hunch, look, wait | Always sign now / always buy every read that fits the clock / always decide on the last day / selective (reads only when a group straddles the region's level; waits only for a due name, due cash or a bout) / knows the truth | (1) per decision, each of the three pure calls is the best of the three in at least 15% and none in more than 60%; (2) selective ends with more cash than each pure arm, interval low end above 0, and no fewer top-10 boxers than the best of them; (3) each read, when selective buys it, flips sign / pass 25 to 60% of the time (under 10% = dead, cut); (4) selective loses 10 to 30% of prospects to the rival, and buy-everything loses at least 1.5x that | Clock set to 999 days: buy-everything must be best in over 60% (the dominant trial the clock exists to break). Reads that narrow nothing must equal sign now |
| P-F how it feels | Selective arm, two game years | 8 to 12 prospects a year; two open at once whose ranges overlap in 30 to 60% of pairs; a signed boxer's group middle moves 5 or more by week 10 in 20 to 45% of signings; at least 1 got-away a year later boxes one of yours | One open at a time must read 0 overlap |
| P-C the record (gates 2E) | Never scouts / scouts when the chance spans level or it is a step up / always / knows the truth; lean computed from the record at share 0 and 0.5 | At 0.5: selective wins more bouts and nets more cash than never (low ends above 0), always nets less than selective, 25 to 60% of scouts change take / pass / camp; scouted fights per world reported | Share 0 is today's game and must read as faint as DEPTH_AUDIT_S534 row 36 |

Tuning order if P-B fails, one knob at a time, each rerun on the same worlds: the trial's 1 in 4 (down to 1 in 6), the
clock's floor (7 to 10 days), the arrival gap. Not the misread share (K5). If a pure call still wins over 60% after
three reruns, the map goes to the owner as "cut it or keep it".

## 6. Order of work
1. P-A greybox, then A (record at first sight, one range rule, no exact). 2. P-B and P-F on a greybox with the clock,
then B and C together (the reads are only a choice with the clock). 3. The got-away list and the region row. 4. P-C,
alone, later. Each step is done when the menus of section 3 show it in the .exe and the golden path walks one prospect
from first sight to each of the four endings (signed on the hunch, signed after a trial, lost during a trial, taken by
the rival and met again as an opponent).

## Sources read today
`scripts/rules/Knowledge.gd` (whole), `KnowReads.gd` (:1-135), `CardAsk.gd` (whole), `TellWorth.gd` (:1-40),
`Matchmaking.gd` (:36-42, :120-142), `BoutRead.gd` (:112-136), `HeadCoach.gd` (grep lines), `scripts/state/Roster.gd`
(:80-160), `KnowWire.gd` (:12-36), `VisitWire.gd` (:40-160), `Leaving.gd` (:40-70, :92-114), `Newcomers.gd` (:1-30, :44-82),
`Region.gd` (:134-146, :186-193), `HomeJuniors.gd` (:50-90), `Data.gd` (:215-262), `Clock.gd` (:58-63), `Needs.gd` (:61-66),
`scripts/ui/areas/Fighters.gd` (:184-232), `RecruitPanel.gd` (:36-50, :92-114), `RosterCards.gd` (:312-320, :350-356),
`modals/Trial.gd` (:1-40), `modals/Interview.gd` (:56-84); grep for every caller named above; v6; both v6 critics' lists;
docs/KNOWMISREAD2_RESULT.md. No Godot run, no probe run for this map.

# Knowledge stakes v8 - the scout brings maybes, the rival decides inside a window, and signing is a bond

S540, 2026-11-23. Board row KNOWLEDGE1. Map only: nothing is built by this page. Bar (owner S534): 8 on DEPTH and 8 on PLAY.
Lines tagged CODE were opened on 2026-11-23 at the file:line given (main after 37dce4f37). ESTIMATE = proposed, not in the
game. MEASURED = a probe result, with its file. Words: "the prospect", "your boxer", "they"; no fixed he or she.
v7 (`DESIGN_KNOW_STAKES1_V7.md`) stays the base: every v7 line not changed here holds (sections 1, 2A, 2E, 3 of v7).

## 0. What changed from v7, in nine lines
1. **SIGNING IS A BET (a bond).** The club stipend binds 12 weeks. Letting a boxer go before week 12 pays the weeks left
   (at most $3,000) on top of today's reputation cost. The stake line says so. (v7 kept today's price: $0 cash.)
2. **THE RIVAL DECIDES INSIDE A WINDOW, NOT ON A DATE.** "Lynn AC decide between Mon 19 and Mon 26 Jan." Any day of that
   week they may sign. Waiting is no longer free up to the last day, and the trial's 1-in-4 dice is gone: a trial is lost
   only when the rival's day falls inside the trial week, and the button shows those odds from the window.
3. **A LOST TRIAL IS REFUNDED.** The rival took them: the $125 comes back. You lose the days, not the money.
4. **THE RIVAL'S LOOK IS SHOWN, NOT DECODED.** "Lynn AC's look: body 58-70, skills 52-66." The clock no longer hides a
   second read: the player weighs two honest, noisy looks. The window's place keeps a random part (0-6 days).
5. **THE CEILING IS THE WIDEST UNKNOWN, AND THE TRIAL CAN READ IT.** First look "up to 70-98" (half-width 14, was 9). The
   trial week's pad test (one new move drilled) halves it. Nothing else before signing moves it. Amateur coach: exact.
6. **WAITING READS.** Each week waited the prospect trains at the open session: body and skills each narrow a little (about
   a third of a test day). The Wait button says what a week buys and what it risks.
7. **THE SCOUT BRINGS MAYBES.** A scouted name is one the scout cannot call: its first look sits within 3 of the region's
   level. The sure ones were signed at fourteen by the big clubs; the hopeless ones are not brought. Walk-ins and visitors
   stay unfiltered.
8. **NUMBERS COME BACK FOR SIGNED BOXERS.** A group prints single numbers once it reads "good read" AND the boxer has had
   12 weeks in training or 3 bouts. Before that the board shows the middle with the range on hover, and the weekly gain
   moves the middle. Prospects always show ranges.
9. **THE REVEAL IS A MOMENT.** Every read ends on a before / after strip and one line: "Body 56-72 -> 61-69. Your first
   look had the middle at 64." Cut: the 3-days-sooner rule.

## 1. What the game does today (only what v8 adds to v7 section 1)
- **B1 CODE - letting go is free in cash.** `scripts/state/Leaving.gd:59-61 let_go` ("free in cash, the smaller reputation
  cost"); `:29-30` REP_LET_GO -1, REP_LET_GO_RANKED -3. Nothing binds a stipend to a term today.
- **B2 CODE - the one trial dice the game has.** `scripts/rules/CardAsk.gd:26 TRIAL_LOSS 0.25`, rolled at `:137` for the
  bout visitor only. v8 does not touch the visitor (its 7-day wait, `:23`, stays).
- **B3 CODE - the trial read v7 described.** `scripts/rules/KnowReads.gd:105-111 _apply_trial` gives body 24 and skills 24
  exposure. v7's "body 12" was a change to that code it did not flag (Kalli's code check): **v8 flags it** - body 24 -> 12,
  so a trial reads mostly skills and heart and a test day stays the body read. Width after: body about 8.5, skills about 9.
- **B4 CODE - numbers.** `scripts/rules/Knowledge.gd:23 FLOOR 0.5` (a range never reaches 1 wide by narrowing alone, and
  stale adds on top). Under v7's "a number only at 1 wide" no signed boxer would ever print a number again. The pack's
  standing rule: "Real stats stay visible." v8 section 2F answers it.
- **B5 CODE - the five named prospects.** `scripts/state/Data.gd:229` PROSPECTS, all put on the list on day 0 by
  `scripts/state/Career.gd:123`.

## 2. The design (changes to v7 section 2 only)

### A. The card (v7 2A, plus)
- Ceiling: "up to 70-98", half-width 14 (ESTIMATE), leaning with the shared misread. The pad test halves it. Exact for the
  Amateur coach (`HeadCoach.gd sees_potential`), which now removes the single biggest unknown on the card.
- Under the player's own ranges, one muted line: **"Lynn AC's look: body 58-70, skills 52-66."** Same range rule, the
  rival's own seed (it can be as wrong as yours, and in its own direction).
- The stake line: **"A place, $250 a week, bound 12 weeks: letting go sooner pays the weeks left."**
- The bout date when the prospect has one inside the window: "Boxes Sat 24 Jan at the Lynn show (free to watch)."

### B. The reads (v7 2B, changed rows)
| Read | Cash | Days | What it answers | Odds on the button |
|---|---|---|---|---|
| Test day | $60 | 1 | Body 16 wide to about 7 (CODE exposure 16) | "Body only. About 1 time in N this puts them under the level." (TellWorth pattern, from the shown range) |
| Trial week | $125, refunded if the rival signs during it | 7, a place held | Skills to about 9 wide, body to about 8.5 (B3: body 24 -> 12), the ceiling halved by the pad test; optional hard spar on the last day opens under fire and the pressure trait, injury x2 that night, +15 tiredness | "Lynn AC may sign during the week: 2 in 7." (days of the window inside the week / window length) |
| Watch them box | $0, your evening | to the bout | Under fire rough, the record moves | Shown only when the bout is inside the window |
| **Wait a week (Continue)** | $0 | 7 | The open session: body and skills each narrow by about a third of a test day (ESTIMATE body +8, skills +8 exposure) | "A week: 0 in 7 they sign (window opens Mon 19)" or "3 in 7" |
- The hunch: **Sign now** (the bond on the button) and **Pass** stay. Pass now differs from letting the window run: it
  frees the slot on the list today, so the next name can arrive (v7 kept two open at once).
- Cut: the 3-days-sooner rule (Kalli: "a small knob nobody will notice").

### C. The rival (v7 2C, changed)
- **Window (ESTIMATE).** The date shown is the last day; the rival signs on one day of the 7 before it. Last day: 21 days,
  minus 7 when the record reads well, minus 7 when the rival's own look rates them above the level, minus 0-6 (random),
  floor 7. The player sees the window and the rival's look; the record is on the card. **MEASURED (docs/KNOWSTAKES8_RESULT.md,
  B4): beside the player's first look, the clock now adds 0.013 of R2 about the truth; the test day adds 0.035.** In v7
  the clock added 0.026 - the paid reads were not worth more than reading the timer.
- When it runs out: as v7 (a region row at that club, boxing on). **The one that got away comes back:** within 26 weeks,
  when the division matches, the region sheet offers that boxer against yours, tagged "you passed" (v7 only said "can be").

### D. Arrivals (v7 2C "names arrive in turn", changed)
- **First hour kept (Kalli 9):** two named prospects are on the list from day 0, as today, with their windows; the other
  three named ones arrive one every 4-6 weeks, then region novices.
- **The scout brings maybes (MEASURED to matter, section 5):** a scouted name's first look sits within 3 of the level.
  Without this filter the hunch is the best call in 78% of decisions; with it, 56%.

### E. Two prospects side by side (v7 item 8, plus Dola's compare)
- The strip shows both range sets on one axis with the level line, both windows, and one line where they overlap:
  "Body overlaps: either could be the stronger." (from the shown ranges only).

### F. Numbers for signed boxers (Kalli 3, B4)
- A group prints single numbers (attribute board, radar, weekly deltas, perk thresholds like "Chin 70") once it is a good
  read (60% of the range gone, the word v7 kept) AND the boxer has 12 weeks in training or 3 bouts. Before that: the middle,
  the range on hover, "+1 this week" moving the middle. No group ever jumps to the truth (v7's L3 fix holds): the number
  shown is the middle of a range under 3 wide.

### G. Feedback (Dola priority 1 and 3)
- Reveal line after every read and on the first bout: before / after, and where the first look put the middle.
- A Monday line on an open prospect only when something moved ("Body 56-72 -> 59-70 at the open session") or the window
  opens this week ("Lynn AC decide from Monday").
- The clock pill turns amber inside 14 days and red once the window is open; the top bar's Continue stops on the day
  the window opens and on its last day.
- Got-away list (v7): adds "Your first look: body 56-72. They box at 66 now."

## 3. Menus (v7 section 3 holds; rows that change)
| Menu | v8 adds | Wired to |
|---|---|---|
| Signing card | rival's look line, window line, bond in the stake line, ceiling range, Wait button with its read and risk, odds on every read | prospect record: `window_from`, `window_to`, `rival_seed` (new); `Knowledge.range_of` with the rival seed |
| Let go confirm (`Leaving.let_go_price`, CODE `:65`) | "Pays the 8 weeks left: $2,000" before week 12 | `signed_day` (new) + `GameMoney.FIGHTER_STIPEND` |
| Top bar Continue | stops on the window's first day and its last day | `Clock` candidates |
| Needs strip | "Lynn AC decide from today" | same |
| Fighter page overview / Week / attribute board | single numbers only per 2F; range on hover before | `Knowledge.share_gone`, weeks since signing, bout count |
| Monday review | a prospect line only when it moved or a window opens | `Knowledge.moment` |
| Fights (amateur offers) | the got-away boxer offered within 26 weeks, "you passed" | `c.rivals` row with `passed_by`, `passed_day` |
| Find a fighter | two names from day 0, then "Next name: about N weeks" | `Data.PROSPECTS` order + an arrival clock |

## 4. Every item on both "to reach 10/10" lists: taken or why not

**First critic (code-checked):**
| # | Item | Answer |
|---|---|---|
| 1 | Bind the stipend 12 weeks; pay the weeks left on an early let-go; add the sign-and-cut arm | TAKEN (0.1). MEASURED: sign-and-cut is the worst arm but one in every run (v8 $1,133 against selective $2,782 at V $5,000); it was already worse in v7, the bond widens the gap by $400. |
| 2 | A pre-signing read of the ceiling: a pad test in the trial week | TAKEN, stronger: halves the ceiling, not a third (run 5 of the result: with a third, selective's reads flipped 16.6%; with half, 18.0%). |
| 3 | Numbers for signed boxers | TAKEN (2F), with the critic's two gates. |
| 4 | Show the rival's look; cap the shortening with a random part | TAKEN (0.4, 2C). MEASURED B4 PASS. |
| 5 | Make the trial loss fair: refund; scale the risk with the clock; show the odds | TAKEN, as one rule: the window replaces the dice, so the risk scales by itself (none when the window opens after the trial, up to 1 in 1 when it is already open) and the button prints it. |
| 6 | A slow free read for waiting | TAKEN, larger than asked (body AND skills, about a third of a test day): at body +4 alone wait was best in 9% of decisions. |
| 7 | Fix the probes: sign-and-cut and clock-only arms, branch replay, drop the 1.5x loss bar, the clock-predicts-truth measure | ALL TAKEN (section 5). |
| 8 | The one that got away comes back within 26 weeks | TAKEN (2C). |
| 9 | Keep the first hour: two named prospects from day 0 | TAKEN (2D). |
| 10 | Bout date when the prospect arrives; cut 3-days-sooner | TAKEN (2A, 2B). |
| 11 | List the trial's exposure change as a code change | TAKEN (B3). |

**Second critic:**
| # | Item | Answer |
|---|---|---|
| 1 | Reveal pulse + one-line summary; "your guess last time" | TAKEN (2G). |
| 2 | A weekly update line on the prospect | TAKEN, only when something moved (owner S398: only actionable info; "No change since Monday" is not). |
| 3 | Trial loss: phone the rival ($150, 60% +4 days), full refund | REFUND TAKEN. The phone call REFUSED: a second dice to fix the first; the window removes the first dice instead. |
| 4 | The hard spar's cost on the button | TAKEN (2B row). |
| 5 | End a trial early: pay $60, keep part of the read | REFUSED: with odds printed from the window the player starts a trial knowing its risk; a half-trial is the test day under another name. |
| 6 | Under fire partly read by watching a bout | ALREADY IN v7 (Watch them box opens it rough). |
| 7 | Bout-watch reminder | TAKEN (2A bout date). |
| 8 | Compare overlay for two prospects | TAKEN (2E). |
| 9 | Got-away "you were right" line | TAKEN (2G), worded as where they box now; never "right/wrong" (the truth is always inside the range). |
| 10 | Clock colours: neutral / amber / red with a pulse | TAKEN without the pulse (owner: pulsing is for buttons that need a press - the top bar's stop already does that). |
| Missing | "Watch at the trial" in person, costs an evening | REFUSED: the player is always the head coach at the trial; an evening cost with no new information is a tax. |
| Useless | "Sign now: show the downside odds" | TAKEN: the Sign now button carries the same TellWorth line ("about 1 in 3 of first looks like this end under the level"). |

## 5. Probes (bars fixed in v7 section 5 and printed by the probe before every run)
Greybox: `tools/knowstakes8.gd` (Knowledge.gd's own widths, offsets and reads; the rest ESTIMATE). Result, every run:
**docs/KNOWSTAKES8_RESULT.md.** One line: **v8 PARTIAL - B2 and B4 PASS, the dominant trial of v7 is broken (look best in
97% of decisive v7 decisions -> 31%), B1 misses by wait at 12.8% against 15%, B3 by flips at 18% against 25%.**
| Bar | v7 (maybes) | v8 (maybes) |
|---|---|---|
| B1 best per decision: hunch / look / wait (each 15-60%) | 1.4 / 96.7 / 2.0 | 56.4 / 30.8 / 12.8 - FAIL on wait |
| B2 selective beats every arm but the truth, low end > 0 | (not a v8 bar) | PASS at V $3,000 / $5,000 / $8,000 |
| B3 selective's reads flip the first-look call 25-60% | 25.9 | 18.0 - FAIL |
| B4 clock adds less than the test day | 0.026 vs 0.088 | 0.013 vs 0.035 - PASS |
| Lost to the rival: selective / buy-everything | 10.2 / 21.8% | 1.4 / 23.4% |
Next (the build's own probe, before the menus): the same bars on the real game loop (KNOWBOTS worlds), plus P-F from v7.
If wait stays under 15% there: the open session's read is the knob, then the window length.

## 6. Order of work (v7 section 6 holds), with the bond and window built in step 2 beside the clock.

## Sources read today
v7 map; both v7 critics' lists; `Knowledge.gd` (:1-135, :160-262,
:360-380), `KnowReads.gd` (:95-135), `Leaving.gd` (:1-73), `CardAsk.gd` (grep), `Data.gd` (grep), `Career.gd:123`,
`StatBlock.gd:24`, `tools/knowmisread2_probe.gd` (:1-80), docs/KNOWMISREAD2_RESULT.md. Probe runs: 8 (section 5 file).

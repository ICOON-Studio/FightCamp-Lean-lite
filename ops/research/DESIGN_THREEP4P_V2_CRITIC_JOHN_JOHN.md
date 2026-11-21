# DESIGN_THREEP4P_V2_CRITIC_JOHN_JOHN - John answer (seat queue SQ265)

Brief: research/DESIGN_THREEP4P_V2_CRITIC_JOHN.md
Sent: 2026-11-21 02:40 | collected: 2026-11-21 03:10 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): threep4p_10.html
Verify the sources before using it.

---

On it. I'm reading the three coaching moments map against the pack now, and the scores, the options, To reach 10/10 and the 1920×1080 page will follow here.

I've started the critic. Beast is still offline, so I can't open `CRITIC_ACCESS.md`, the mockups or the code; this is a reading of the pack and the map only, and the critic will say so.

I re-did the critic's sums by hand and they hold. The visit roll comes out at 10%, 13% and 18% at Rep 20, 50 and 100. With two amateurs that means a 38–59% chance of at least one visit a year. A signed visitor is worth about $9,150 a year, against $13,000 for a year of stipend. One caveat: the yearly win counts behind those figures are my estimates, and nothing was run in the game.

# THREEP4P_V2 critic: three coaching moments, map v2

**DEPTH 5, GENERAL DESIGN 6, PLAY 6, so it isn't designed yet.** Beast is offline, so I couldn't open `CRITIC_ACCESS.md`, the mockups or the code; this is a reading of the pack and the map only. Tags: SOURCED means a source I opened, DERIVED means my own sums, ESTIMATE means my assumption, CHECK means unconfirmed, and NOT FOUND means no real number exists.

v2 is a good honesty spec. It removes real lies from the code, such as the streak shading that claims ground and the empty "for" line, and it never makes up evidence. But it fixes what the screens show more than it designs decisions. Of the three moments, the read tells you the answer, the visit is rare, and the corner's eye only displays calls that already exist.

**DEPTH 5**
- **The coach's read.** It only adds information to choices that already exist: Accept, Pass, or ask for a later show. It never prices those choices in the game's own terms: morale +5 for a booked bout, −6 for a month without one, the goal deadline, DUCK and OWED, and the 10-day rest. "Look for a later date" isn't an amateur option today. The confidence marks are almost always 2 for amateurs, because there's no scouting before accepting.
- **The visit.** If a place is free, Sign is always the right answer. "Trial first" beats "Sign now", because it's free and pauses the expiry. The 120-day cooldown almost never applies.
- **The corner's eye.** It's a display ("do not execute a call from a passive overlay"). Its real value would be to say *why* a line failed, because each cause has a different answer:
  - the line isn't ready yet (FireLevel), so train it;
  - it's worn after 2 uses in the round (PlanRead), so keep it until the bell or swap it;
  - it walked into the opponent's style, so rewrite it.
- **Links it misses:** step training (StepMastery), the pro opponent's corner reading your boxer's habits (ProRead), morale, goals, and OWED bouts with a rival you then sign.

**GENERAL DESIGN 6.** In its favour: it's truthful and buildable from what the game has, the order of work is right, it uses role-only words, and nothing opens by itself. Against it:
1. The +0.03 evidence bonus applies to every eligible bout, because evidence is now the gate. So the formula is really 0.08 + Rep × 0.001.
2. There are four signals of how sure the read is: the existing band, the marks, the "right N of the last 15" record and the brief/full toggle. That breaks one word per concept.
3. "Trial first" makes "Sign now" pointless.
4. The cooldown is a rule that almost never does anything.
5. During a live round the overlay shows five states, two rounds of faded old lines, a toggle and two tags, which fights "dark and tight" and the only-actionable rule.
6. The player line "Pressure is known; your usable exit covers the ropes. Estimate, not a guarantee" isn't in game words. PRESSURE already means something else, and "exit" isn't one of the plan's arrows.
7. The visit needs four code paths for a moment that comes less than once a year.
8. It doesn't say what happens to DUCK and OWED, or to the 3-month nationals clock, when you sign a rival.

**PLAY 6.** The visit is a lovely surprise, but it's mostly a rumour at about 0.4–0.8 a year. The read's record of right calls gives a reason to come back, and the clue in the Why works on every bout. The overlay only builds tension if it says what to do next.

## Numbers (DERIVED or ESTIMATE)

| Rep | Chance per eligible win | Visits a year, 1 / 2 / 3 amateurs | At least one visit a year, 2 amateurs |
|---|---|---|---|
| 20 | 10% | 0.23 / 0.45 / 0.68 | 38% |
| 50 | 13% | 0.29 / 0.59 / 0.88 | 47% |
| 100 | 18% (cap) | 0.41 / 0.81 / 1.22 | 59% |

- **Eligible wins:** about 2.25 per amateur per year (ESTIMATE). That assumes 7 bouts a year, 55% wins, 60% of wins with qualifying evidence, and 5% blocked.
- **The cap:** 0.18 is reached only at Rep 100. With a full Unit (3 places taken) the chance is 0.
- **A signed visitor's year:** 7 × $450 in ticket cuts = $3,150. Members change by about +29 and Rep by +14, or about $6,000 in dues for half a year. The stipend is $13,000. So the visitor is worth −$3,800 with the stipend and +$9,200 without. The real decision is the stipend, and the map buries it.
- **Cooldown:** a repeat visit roll inside 120 days comes out at about 0.5%.
- **Confidence marks:** amateur offers get 1–2 marks, never 3. A pro can reach 3 after a $250 scout. The record of 15 resolved calls takes about 13 months to fill with 2 amateurs.

## Options

| Moment | Option | Verdict | What it changes |
|---|---|---|---|
| Read | Accept | Keep | Booked +1, morale +5, shows the goal it meets |
| Read | Pass | Keep, add a price | Shows the day morale drops 6 and the goal at risk |
| Read | **Pass and ask for a later show** | Missing | One button: +14 days rest, the host's last answer, whether a No counts as a DUCK |
| Read | 1–3 marks | Useless | Repeats "how sure it is" |
| Read | Brief/full toggle | Useless | Changes nothing; hover already explains |
| Read | The read's record | Keep | Trust, no change to the odds |
| Read | **Pro: the opponent's corner waits for your most-thrown punch** | Missing | Links to the plan: add a second weapon or a feint |
| Visit | Sign with stipend | Keep | Place +1, $250 a week |
| Visit | **Sign, no stipend** | Missing | Place +1, $0, morale starts Flat |
| Visit | **Train here for one camp** | Missing | No place used; a free partner of a known style for your boxer's next camp, then sign or part |
| Visit | Trial first | Keep only with a cost | One of the coach's pad nights, or the visitor may go elsewhere |
| Visit | Pass | Keep | Nothing |
| Visit | 120-day cooldown | Useless as a choice | Keep it hidden in the background |
| Visit | **Compare with the best prospect** | Missing | Shows the visitor beside the best Find a fighter card and the places left |
| Corner | Shout / say nothing / swap at the bell | Keep | Existing costs |
| Corner | **"Keep it, it resets at the bell"** | Missing | The right answer for a worn line |
| Corner | **Study this step next** | Missing | On the Why: puts the step in the study slot, about 6 a week to Usable 30 |
| Corner | Faded old lines, 5-state key, view toggle | Useless during the round | Move them to the corner minute and the Why |

## Rule breaches
- "Meet her" is a fixed pronoun; it should be "Meet the visitor".
- The player line isn't plain words. Suggested: "The opponent presses (seen on the sheet). Your pivot out is Usable: your boxer can get off the ropes."
- "Marks" next to "how sure it is" uses two words for one concept.
- The overlay shows information the player can't act on within 30 seconds.
- No moment says which one button pulses.
- The ask-for-a-fight edge cases are open.

## Real boxing evidence
- **Club transfers (SOURCED):** England Boxing Rules 2026, rules 6.13–6.14. A move between clubs in the same region is unrestricted. A move across regions has to be done 1 month before championship entries open. Membership belongs to the boxer, not the club. So a London visitor can join at once, and their record and registration clock should carry over. Rule 12.2's "bouts at new club" condition is CHECK. ([rule book](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final-01-26.pdf))
- **Coaches recruiting boxers they beat:** NOT FOUND. Treat the visit as game fiction and keep it rare.
- **Real corners (SOURCED):** Halperin & Wulf (2016) recorded 445 statements from 12 coaches over 25 bouts, about 8 a round. Winning corners were more positive and less controlling (48% against 58% controlling statements). ([paper](https://gwulf.faculty.unlv.edu/wp-content/uploads/2014/05/Halperin_Wulf_coaching_cues_boxing_PSE_2016.pdf)) File (England Boxing, 2020) describes the minute as settle, health check, feedback, refocus. ([booklet](https://www.englandboxing.org/wp-content/uploads/2020/11/Coach-Communication-in-Boxing-Kieran-File-Warwick-University.pdf)) So the overlay should give one diagnosis and one refocus, not a legend.
- **How accurate coaches' reads before a bout are:** NOT FOUND.

## To reach 10/10
1. **Make the corner's eye a diagnosis with an answer.** Give each failed planned line a cause: not ready, worn, wrong answer or countered. Each cause comes with its legal answer: keep it until the bell, swap at the minute, or "Study this step next" on the Why. During the round show only one line of 14 words or fewer, next to the call it argues for. This can be built from PlanRead, FireLevel, StepMastery and PlanFight.
2. **Price every offer choice in the game's terms** (morale, goal, rest) and add **Pass and ask for a later show**. Pros also get the ProRead line.
3. **Cut the duplicate trust signals.** Drop the marks and the toggle, and show the read's record from 3 resolved calls.
4. **Fix the visit maths.** Either drop the +0.03, or let a plain win qualify at 0.05 + Rep × 0.001 (cap 0.15) with +0.03 for evidence. Aim for about 1 visit a year at Rep 50 with 2 amateurs. Hide the cooldown.
5. **Give the visit real choices:** sign with or without the stipend, train here for one camp, pass, or a trial that costs a pad night, shown beside the best prospect.
6. **Settle the ask edge cases.** Signing a rival cancels any OWED bout with them, takes them off the ask sheet and clears their DUCKs, and the Sign button says so. The nationals clock carries over.
7. **Plain words:** "Meet the visitor", "The opponent presses", the arrow names; no "exit", no disclaimer.
8. **One pulsing button per moment:** the read's pick on the offer, the suggested call in the corner, and none on the visit.
9. **Test in the game:** the read should be right in 60% or more of resolved calls over a month replay, and each corner cause's answer should beat the other two over 400 bouts. This needs the game's balance runs, so it waits for Beast.

## The 10/10 page (1920×1080, Look B)
It shows Fights > an offer, with the coach's read, because offers come every couple of weeks and visits about once a year.
- **Header:** the two names, once.
- **Left:** a sticky note for your boxer: weight on the day (+0.4 kg, made), rest 16 days, and the goal "Next bout inside a month: 9 days left" in amber.
- **Centre:** the read in marker. "Legal, even match." Gain: "The opponent presses (seen on the sheet). Your pivot out is Usable: your boxer can get off the ropes." Cost: "Rest is 16 days; 21 is comfortable." Then "How sure: wide band, no tape" and "Right 7 of 10".
- **Bottom:** three choice cards.
  - **Accept** is the one that pulses: morale +5, goal met, camp 4 weeks.
  - **Pass and ask for a later show:** +14 days of rest; this corner said Yes last time; a No while on a run is a DUCK; the goal slips to AT RISK.
  - **Pass:** no bout for about 4 weeks, morale −6 on day 30, and the goal MISSED in red.
- **Right:** the win band 48–62% with "how sure it is".

The rendered page and its HTML file are below.

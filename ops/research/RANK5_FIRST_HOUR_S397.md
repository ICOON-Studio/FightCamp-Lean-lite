# Rank 5: the first hour with the coach (S397, 2026-11-07)

The build plan for rank 5 of `docs/STRUCTURE_DESIGN_S395.md` section 8: the first hour to section 5.5, with the coach step
(P12, section 5.8). The operator approved the mock-ups and their mechanics (S396) and the coach cards (Q-S294-121, "Yes").
Bar: first fight by minute 25 and the Why screen by minute 35 on a timed run; a blind critic at 7/10 or better before the
operator sees anything.

## 1. What the first hour is today (measured, `tools/first_hour_probe.gd`)

- Title: Quick start or New career (country, city, gym name). No coach, no start choice. The player has no face.
- Day 0 (Mon 5 Jan): Home with a 4-step strip (sign, hire, set week 1, continue). Lucy waits at reception.
- First offer arrives **day 8, a Tuesday**, for **day 33 (Sat 7 Feb, week 5)**. Because it lands on a Tuesday the clock
  stops a second time that week on the offer's last day.
- Ana (no-gi) walks in at the end of week 1, before the player has finished learning boxing.
- After the first fight nothing is guided: the guide ended after week 1.
- Lucy is 61.4 kg for 60.0. The camp's cut forecasts 60.17 for a bout on day 19 (missed) and 59.84 for day 26 (made).

So the first fight is five game weeks in (about seven clock stops), and the second half of the hour (second boxer,
matchmaking, the club growing) is not shaped at all.

## 2. The first hour, minute by minute (target)

Times are targets until a stranger is timed. The test estimates them (section 6).

| Min | The player does | Screen | Rule behind it | Should feel |
| --- | --- | --- | --- | --- |
| 0-1 | Title: New career (or Quick start, which takes card 1 and the fresh start) | Title | - | - |
| 1-2 | **You**: type a name, pick one of four coaches on photo cards | Create step 1 | `HeadCoach` | That's me |
| 2-3 | **Your club**: city, gym name, one of three starts | Create step 2 | `ClubStart` | I chose my difficulty |
| 3-4 | Home opens. The first-hour card: the job (keep the doors open: 4 weeks below $0 closes it) and the date (a club show on Sat 31 Jan has a lightweight slot) | Home | `FirstHour.goal_card` | I know what I'm doing |
| 4-7 | The walk-in: read Lucy's card, pick a starting focus, sign | Interview | as today | She is interesting |
| 7-9 | Hire an assistant (two cards). You are the head coach; the assistant runs the sessions you cannot and writes a plan if you write none | Club > People | `Sim.hire` | People cost money |
| 9-11 | The coach's draft week: change one morning, see the goal line move; lock it | Fighter > Week | as today | That moved something |
| 11-12 | CONTINUE: week 1 runs. Monday page: whole points, each with a cause | Home | as today | Quick |
| 12-15 | Monday week 2: the show offer (Maria Ortega, Sat 31 Jan, 19 days). Bout page: tape, money, her weight forecast (59.8 on the morning: 0.2 kg to spare) | Bout page | `FirstHour` fixes the first offer | A real risk |
| 15-19 | Accept lands on Fight prep: set the camp (cost shown) | Fight prep | as today | I'm spending to win |
| 19-22 | Playbook: the coach's plan is already written; change or add one line against her style | Playbook | `CoachPlan` | I have an idea |
| 22-24 | CONTINUE twice (weeks 3, 4). Friday: weigh-in on one screen | Home, Weigh-in | as today | Close call |
| 24-32 | Fight night: three rounds, two corner minutes | Fight | as today | I'm in this |
| 32-36 | Result and Why: what your plan did, what went against you, what to train next, one button | Why | as today | **I made that happen** |
| 36-42 | Monday: a second walk-in at reception (Danny Osei, men's lightweight). Interview, sign or pass. The first month's bills land | Interview, Home | `FirstHour.second_walkin` | There's more |
| 42-50 | The next offers, for both boxers; the clocks overlap. A rival gym's coach is named in the news after the fight | Fights, World > News | `FirstHour.rival_line` | I can steer this |
| 50-60 | Ana, a no-gi grappler, asks to train: the mat opens. CONTINUE names the next date | Home | `FirstWeek.ana_joins`, moved | The club grows |

**Teaching rules (5.5, kept):** goal first; one line per verb; a short card the first time a system bites; nothing forced
(every step can be done out of order, CONTINUE always works once nothing red blocks it); the guide can be skipped on the
title and on the strip; a first loss ends nothing.

## 3. The coach cards (P12)

**Create step 1, "You".** A name field (prefilled "Sam Carter", any name works) and four photo cards. Photos are four real
corner MetaHumans already in the game (`mh_staff_coach`, `mh_staff_coach_2`, `mh_staff_trainer`, `mh_staff_cutman_1`),
baked as arms-folded studio headshots by `tools/bake_coach_faces.gd` on the hidden desktop. No cartoon art. Each card:
the background, one line of past, the one edge in plain words with its number.

| Card | Past (one line) | The edge | Where the rule lives | Size |
| --- | --- | --- | --- | --- |
| **Ex-pro** | Twelve years as a pro, never a champion | **Reads fighters:** every camp opens the opponent's file one tell further on its first day | `Bouts.tape_days` reads `HeadCoach.free_tells` | 1 tell a camp |
| **Amateur coach** | Twenty years at a club like this one | **Eye for talent:** a prospect's potential shows as its true value at first look, not a range | `Recruit.stars` via `HeadCoach.sees_potential` | exact, not a range |
| **Strength coach** | Ran conditioning for a national squad | **Builds engines:** conditioning, power and speed sessions gain 10% more | `WeekPlan` ctx `head_gain` | +10% on 3 stats |
| **Old hand** | Has worked corners since before you were born | **Knows the trade:** camps cost 25% less and the cut burns 150 kcal a day more | `BoutRules.camp_cost` caller, `WeekPlan` deficit | -25%, +150 kcal |

Every card has a bonus (Motorsport Manager's "no option without a bonus" lesson). Each is small enough not to decide a
career. The edge shows on Club > People under "You" for the rest of the career.

**Deviation from 5.8, said plainly:** the design gave the ex-pro "one extra corner call a fight". The corner's limits live in
`Exchanges.gd`, `LiveRound.gd` and `BoutNight.gd`, which a parallel session (Fighter profiles) is rebuilding now. So the
ex-pro's edge is the tape tell for now (it feeds the plan, which is the hook), and the extra corner call is a one-line hook
to add once that rebuild lands. Noted for that session in the shared notes folder.

**Create step 2, "Your club".** City (four countries' cities as today, compact), gym name, and three start cards. The start
doubles as difficulty, as reviewers liked in Motorsport Manager and Corner King:

| Start | Cash | Members | Extra rule | Walk-in | Difficulty |
| --- | --- | --- | --- | --- | --- |
| **Fresh doors** (default, Quick start) | 3 months of costs ($14,600) | 30 | - | Lucy as today | Normal |
| **In debt, one good boxer** | 1 month of costs | 24 | A loan: $180 a week for 26 weeks on the bills | Lucy, potential 90, +4 on every stat | Hard |
| **Backed, big expectations** | 6 months of costs | 40 | Rent x1.5 (bigger rooms); a loss costs twice the members and reputation; the backers' line on Home | Lucy as today | Money easy, losses hurt |

All numbers flow through rules that exist (`GymBills`, `Membership`, the loss rule in `Bouts`). The loan is a new bill line.

**You are the head coach.** The hired coach becomes "your assistant": Luke Reid (sessional) or Marcus Hale (full-time). The
mechanics stay (training share without one, the coach's plan by rating, evening classes). Only the words change, in the
guide, People and the hire toast.

## 4. Screens and rules that change

New pure rules (each with a unit test, each under 150 lines):
- `scripts/rules/HeadCoach.gd`: the four backgrounds, their edges as numbers, the read functions above.
- `scripts/rules/ClubStart.gd`: the three starts and what each changes in a new career.
- `scripts/rules/FirstHour.gd`: the show date (Sat of week 4), the first offer fixed to arrive on Monday of week 2 for
  that date, the goal card's words, the second walk-in after the first fight, the rival line, when Ana joins.

Changed:
- `Career.gd`: `head` (name, background), `start` id, `loan_weeks`; `quick_start` takes a start.
- `FirstWeek.gd`: the guide runs past week 1 to the first Why: steps `sign, coach, week, go, offer, prep, fight, why`.
  Each later step is a pin and a strip line, never a pop-up. Ana's arrival moves from week 1 to `FirstHour`.
- `FirstWeekStrip.gd`: shows the steps of the current stage only (week 1, then the first fight), with what and why.
- `CreateScreen.gd`: two steps (You, Your club) instead of three (country, city, name).
- `Bouts.gd`: the first offer from `FirstHour`; the old hand's camp price; the ex-pro's tell; the backers' loss rule.
- `Sim.gd`: the loan line in the weekly costs; `week_ctx` carries the head coach's edge.
- `WeekPlan.gd`: reads `head_gain` and `head_cut` from ctx (one place, so previews and the sim agree).
- `Recruit.gd` / `RecruitPanel.gd`: exact potential for the amateur coach.
- Home: the first-hour card (goal and clock) as the top pin until the first Why.
- Club > People: a "You" row with the photo and the edge.
- Words: "assistant coach" where the player hires one.

Not touched (other sessions own them): `Exchanges.gd`, `LiveRound.gd`, `BoutRules.gd` (read only: `camp_cost` is called,
not changed), `RoundStyle.gd`, `BoutNight.gd`, `Knockdowns.gd`, `scripts/world/*`, BJJ files, `scripts/fight3d/*` (read only:
the bake tool loads `MHRig` and the clips), `ProFights.gd`, `ProLadder.gd`.

## 5. What is cut, and why

- **Ask for a fight in the first hour (5.5, minute 45-55):** rank 4 built asks for pros only. Amateur asks are a new mechanic
  with their own bot test (rule 2); the first hour instead gets two overlapping offer clocks. Later, with rank 8.
- **The Road at minute 37-45:** it draws the pro ladder; an amateur's road is the nationals path, already on Fight prep.
  Later, with the amateur ask.
- **A full rival gym:** one named rival coach in a news line after the first fight (5.5 says the full gym comes later).
- **Four new corner bodies (5.8 art, M):** rank 14. The cards use the four staff MetaHumans we have.
- **The ex-pro's extra corner call:** see section 3.
- **A character generator:** rejected in 5.8.

## 6. Tests and the timed run

- New unit tests: `head_coach_test`, `club_start_test`, `first_hour_test` (rules: the show date, the first offer on Monday
  of week 2 for Sat 31 Jan, the forecast makes weight with the default week, every start's money, every edge's number).
- `first_hour_walk_test`: the whole hour through the real scenes (like the golden path): title, both create steps, sign, hire,
  week, offer, camp, plan, weigh-in, fight (simulated rounds with corner calls), Why, the second walk-in, Ana. It adds an
  estimated time per screen (reading words at 200 a minute, 6 s a decision, the clock's real ticks) and fails if the fight
  starts after minute 25 or the Why after minute 35. An estimate, not a stranger: Gate 1 times real people.
- Kept green, or updated with the reason written in the test: `first_week_test`, `golden_path_test`, `playtest_s375_test`,
  `coach_check_test`, `plan_bots_test`, the BJJ tests that expect Ana in week 1 (they call `FirstWeek.ana_joins` directly or
  move to the new day), `no_pronoun_test`.

## 7. Stills and critics

Every new screen through the hidden desktop (`tools/first_hour_still.gd`, the `cut_pages_still.gd` pattern): title, You,
Your club, Home with the first-hour card, People with You, the first offer's bout page, Fight prep, the second walk-in.
A fresh blind critic each round, up to about five rounds; stop if the score stalls and write the structural list.

## 8. Critics on this plan (three fresh reviewers, in parallel, plan text only)

Scores: new player **6**, onboarding designer **6**, Football Manager veteran **6**. Their main points, and my verdict on each.

| # | Point (who) | Verdict | Why / what changes |
| --- | --- | --- | --- |
| 1 | The goal card teaches "4 weeks below $0 closes it"; the code closes after **8** (onboarding) | **Yes** | A wrong number at minute 3 is the worst kind of lie. The card reads `GymBills.CLOSE_AFTER_WEEKS` |
| 2 | Edges are jargon at minute 1 ("tell", "range", "150 kcal"): write outcomes, say when you first feel it (all three) | **Yes** | Each card: the edge as a result, plus "First felt: ..." naming the moment in the first hour |
| 3 | Strength +10% is the solved pick: every boxer, every week, no cost (veteran, onboarding) | **Yes** | It gets a cost: technique and defence mornings gain 10% less. Engines, not craft |
| 4 | Old hand has two edges, and its cut erases the close call (onboarding, veteran) | **Yes** | One edge: the cut burns 120 kcal a day more. The close call is then the card's own payoff at the first weigh-in |
| 5 | Ex-pro's tell is invisible if the plan does not show it (veteran) | **Yes** | The tell opens on accept, shows on the bout page as "Your read", and the Playbook's file shows it |
| 6 | "Hard" start hands you a better boxer, so the hour gets easier; "Backed" is easy mode with a label (veteran, onboarding) | **Yes** | In debt: the good boxer walks in 2.2 kg over, plus the loan. Backed: the backers want the first show won, or they take back $5,000. Losses no longer cost double |
| 7 | The weight risk went soft: 0.2 kg spare reads as safe (new player); make the coach's default week miss and the player's change make it (onboarding) | **Yes** | Measured, not guessed: day 19 was not makeable at all (60.65 as planned, 60.20 cut early), so the show is **Sat 31 Jan (day 26, 19 days after the offer)**. As planned the walk-in weighs 60.21 on the morning (missed); starting the cut in week 1 lands 59.87; the old hand's cut 59.93 (`tests/first_hour_test.gd`) |
| 8 | The Why can praise a plan the coach wrote (new player, onboarding) | **Yes** | The Why says whose lines they were (yours or the assistant's) |
| 9 | No twist cards or non-guide red pins before the first fight (onboarding) | **Yes** | Twist cards and the boxer's own asks start after the first bout |
| 10 | Guidance stops at the Why just as the load rises; carry it to minute 60 with small objectives (onboarding) | **Yes, rewards later** | After the Why the strip shows three club tasks: sign a second boxer, book both, pay the first bills. Cash rewards wait: a reward must be a real-world thing, not a gift |
| 11 | Ana and the overlapping clocks pile five new things into 20 minutes (new player, onboarding) | **Yes** | Ana is a news-line teaser in the first hour and joins after the club's second bout. The overlapping clocks stay: they are the stable's lesson |
| 12 | Seed the first hour from small pools so a second run is a new puzzle (veteran) | **Yes, part** | The first opponent is drawn by the career's seed from the division's legal opponents. The second walk-in pool: later |
| 13 | Explain the assistant in one line (new player) | **Yes** | "You cannot run every session. Without an assistant, the ones you miss run at 60%" (the real rule) |
| 14 | Mark one card as good for a first career (new player) | **Yes** | Old hand: weight is the first hour's big risk, and it eases it |
| 15 | A no-stakes rehearsal before the corner; the first corner break pauses on one card that explains the calls (onboarding) | **Later** | The corner minute lives in `scripts/fight3d`, owned by the animation seats. Noted for them |
| 16 | A counterfactual line on the Why ("without your change: 38%, with it: 52%") (onboarding) | **Later** | The Why's plan line already replays the dice without the plan (S388); a percentage per change needs the fighter-model rebuild to settle first |
| 17 | Split Quick start from skipping the guide (veteran) | **No** | It is already split: New career plus the title's "Skip the first-week guide" picks coach and start and plays without the strip |
| 18 | Let the coach card be changed until the first fight; "pairs well with" hints on starts (onboarding) | **No** | A choice you can undo is not a choice, and a hint adds reading at minute 2. Card 1 is marked for a first career instead |
| 19 | A run-to-next-pin CONTINUE (veteran) | **Later** | Design 5.2 has it as a setting for a stable; the first hour has two quiet weeks at most now |
| 20 | Timing needs 1.5x slack for a stranger (onboarding) | **Yes** | The walk test reads at 180 words a minute, not 200, and the day-19 show saves one CONTINUE. Gate 1 times real people |

**The first hour after the critics** (changes to section 2): the show is **Sat 31 Jan (day 26)**; the offer comes on Monday of week 2 with 19 days to go; the
weight is the first real decision; the guide runs to the Why and then gives three club tasks to minute 60; Ana is a teaser.

## 9. Built screens: blind rounds (S398 method: critic -> a free designer seat writes the 8/10 version -> a new blind critic)

Stills: `tools/first_hour_still.gd` on the hidden desktop (title to the second walk-in, 12 screens). Coach photos: the four corner
MetaHumans baked by `tools/bake_promo.gd` (pose af_talk at 1.5 s: the arms-folded pose tore the shirts at the neck).

**Round 1, blind critic: 5.5.** Title 5, You 6.5, Your club 5.5, Home 6, walk-in 6, hire 5.5, People 6, week 2 Home 6, bout page 7,
Fight prep 4, Playbook 6, second walk-in 6. Top faults: too many signals for one task; no identity on title/setup; kg arithmetic in
the guide; Fight prep empty; walk-in density; contradictions ("60%%", "Staff" vs People, "Two bout offers" with one shown, a day-one
training quote, "at risk" after accepting); "4-56%"; the setup frame jumping between steps.

**Designer seat (agy, Gemini flash), the 8/10 version** (`E:/FightCamp/tmp/rank5/r1/DESIGNER_8.md`), and my verdicts:
| Proposal | Verdict | Why |
| --- | --- | --- |
| Title in two columns: name and a short stack left, a fight card of two of the game's own boxers right; no Resume/Load without a save; New career the one solid button | Yes | Real faces at second zero, nothing new to make |
| Guide switch moves from the title to the setup's last step; the build note becomes a tag | Yes | A first-timer never needs it on the title |
| One fixed setup frame with a labelled stepper; the name prefilled as text | Yes | The jump between steps was the critic's fault 8 |
| A rule-number chip on every coach card; a SELECTED badge; GOOD FIRST CAREER muted when another card is picked | Yes | Every edge now carries its number |
| Solid fill on the picked country and city; the city hint said "more fighters", which the rules do not do | Yes | A line the rules do not run is a lie |
| Start cards in the rules' own numbers (bank, members, dues, rent, loan) with the walk-in's photo and weight | Yes | The start is legible before the gym opens |
| Guide banner inside the workspace, right of the rail; its button hidden where the screen already holds the step's button; top-bar flags quiet while the guide runs | Yes | One signal per task |
| Home in the first hour: no unbooked matchup card, no empty roster table; the job card as labelled callouts with a blue bar | Yes | |
| Back/Fwd as chevrons; CONTINUE never red | No, not here | The top bar is every page's; the menus session owns it |
| Assistants as cards with photos and the rules' numbers (sessions at 91% / 102% against 60%, plan lines, classes +$350, net cost) | Yes | Numbers checked against Sim and PlanBoard |
| No member quotes about training before a week has run | Yes | |
| Walk-in, bout page, Fight prep, Playbook one-liners | Passed on | Owned by the menus and plan sessions; listed in the report |

**Rounds 2-5 (a new blind critic each round, no score history):** 5.5, 6.0, 6.0, 5.5. Stopped: the scores stalled and the critics
began to contradict each other (the title read 6.5, 7, 5 for nearly the same screen). Per screen, the first hour's own screens ended
at: You (coach cards) 7, Your club (starts) 7, People (hire) 7, Home in the first hour 6-6.5, title 5-7, Home after the show 6.5.
What changed between rounds: round 2 the designer's version above; round 3 the cut decided in week 1 (by week 2 the camp's cut alone
cannot make the show - measured), the ex-pro card matches its rule (best weapon, not "habit"), assistants as side-by-side tables;
round 4 the job card follows the show, a weight chip instead of a repeated sentence, assistants in men's photos, plain numbers;
round 5 the still plays the real fight in words (`-- no3d`), the first show's result leads Home in the club stage, the third club
task is a decision (the next goal) instead of a bill that pays itself.

**The structural list (what keeps the set under 7; none of it is a first-hour screen):**
1. **Fight prep is an empty page (4/10 in every round).** The first hour sends the player there right after accepting. Three critics
   drew the same 8/10: a countdown header, the camp as week blocks, the weight path, the opponent's file with what unlocks the next
   find, plan readiness, one primary button. Owner: the menus session (the S396 screen cut's Fight prep tab).
2. **The bout page's "Win chance 4-56%" and Accept below the fold (5.5-7).** One number with a confidence word that scouting
   narrows; a fixed footer for Accept/Pass; "Legal, even match" turns red when the weight forecast misses. Owner: matchmaking/menus.
3. **The Playbook shows a plan the fight does not use (round 5).** The plan tab reads "Answers written: 4, Sound plan" while
   `f["arrows"]` is empty, and at the bell the assistant's CoachPlan wrote nothing for Priya, so the Why said "NO PLAN, improvised
   all 18". Either the shown lines are saved, or the tab says they are suggestions. Owner: the plan session (rank 3, rule 1).
4. **The walk-in card is a template (05, 11).** The same perk road text, ceilings "/84" six times, and the same "Jab, mastery 51"
   signature for two boxers; codes like "def 65(57)". Owner: RecruitPanel/PerkRoad (menus).
5. **Fight night between the weigh-in and the result** reads as a toast then a card in the word path; the 3D path is the animation
   seats'. The result panels have no faces. Owner: fight view / animation.
6. **The top bar:** browser-style Back/Fwd; the red NEEDS YOU pill repeats what the guide says. Owner: menus (Shell top bar).
These are sent to the S398 main session to route.

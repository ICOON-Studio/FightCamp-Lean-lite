# FightCamp player path and structure (v3, S388, 2026-11-06)

Operator: "do it like pro studios do these things". Usual UX order: experience goals, the player, time scales, journey, tasks, screen map,
flows, then test. From a code audit of every screen, critics S386-S388 and the loop research. A UX lead scored v1 5/10 and v2 6/10: **approved for plain screens, Home and
the fight flow only. The arc is not approved.** v3 fixes v2's wording. Paper only: nothing is built. Times are estimates until strangers are timed.

## 1. Experience goals
**"I get it"** (10 minutes), **"I made that happen"** (first fight), **"she is mine"** (first month), **"just one more week"** (every session),
**"look what we built"** (the end of a career). Hook: you can see your plan mattered, and why. Just enough control to feel smart.

## 2. The player
"Sam", 35, plays Football Manager or Motorsport Manager, follows boxing, has an evening and a free weekend. Knows sport, not our terms. Hates
hunting through menus. Wants to find an unknown and make a champion.

## 3. Time scales
| Scale | What happens | Target | Ends with |
| --- | --- | --- | --- |
| Decision | One choice, one visible effect | Seconds | A number moving |
| Week | Read Monday, decide, CONTINUE | 1-2 min quiet, 5 busy | A tease |
| Fight cycle | Offer to the Why screen | 20-30 min | What it changed |
| Season | About 6 fights across the gym, a year review | 2-3 hours | Awards, new arrivals |
| One career | Unknown to area champion | 10-15 hours | A legacy in Records, then the next unknown |

## 4. Journey
| Stage | Player does | Should feel | Failure today | Fix |
| --- | --- | --- | --- | --- |
| 10 minutes | Name gym, find a fighter, interview, career goal, coach | "I get it" | Dense card | Three short steps |
| First hour | First weeks, offer, camp, fight, why | "I made that happen" | Booking lead is 2-4 weeks, and the plan's effect is a caption | A short-notice first bout about two weeks in; the Why screen |
| First evening | Second fighter, first rival | "She is mine" | One fighter, clocks never overlap | Second fighter by week 4; a named rival |
| First season | Nationals, a loss that hurts, money | "One more week" | Same two goals every talk; goals fixed | Goals fitted to the fighter |
| Long game | Pro bouts, area title, next unknown | "Look what we built" | After the debut no more fights exist | Section 9 |

## 5. Tasks by frequency
| Job | How often | Clicks today | One home | Target |
| --- | --- | --- | --- | --- |
| Advance time | Weekly | 1 | Top bar | 1 |
| Read what happened | Weekly | 3, skippable | Home on Monday | 0 |
| Answer a twist or decision | Weekly | 1-2 | Home | 1 |
| See condition, weight, goal | Most weeks | 0, but frozen | Fighter card | 0, true |
| Adjust the week | Often | 2 | Fighter > Week | 2 |
| Prepare a fight | Each fight | 5 places | Fighter > Fight prep | 2 |
| Plan, moves, combos | Often | 2-3 | Fighter > Playbook, one page (S381) | 2 |
| Ask for a fight | Each fight | **Impossible** | Fights | 2 |
| Money, bills, deals | Monthly | 1 | Club > Money | 2 |
| Find a fighter | Rare | 3 | Fighters > Find | 2 |
| Staff, facilities | Rare | 2-3 | Club | 2 |
| Rankings, news | Curiosity | 1-2 | World | 1-2 |
| History | Curiosity | 2 | Fighter > History, Club > Records | 2 |
| Save | Rare | 2, no autosave | Autosave weekly | 0 |

## 6. Screen map
Today: 7 rail buttons, 25 tabs, 8 fighter tabs, 10 modals. Proposed: **5 rail buttons, 8 tabs, 5 fighter tabs.**
- **Home**, no tabs: Monday's news with causes, decisions, fighters, clocks. Replaces the week review and Mail. In the first week of a
  year it shows the year review.
- **Fighters:** Roster | Find a fighter.
- **Fighter page:** Overview (stats, goal, perks, contract) | Week | Fight prep | Playbook | History. Body stays a panel on Overview.
- **Fights**, no tabs: Ask for a fight and offers on top, dated timeline, results below.
- **Club:** Staff, members and facilities | Money (bills, income, deals) | Records.
- **World:** Rankings | News | Championships.
Goes: Gym > Floor, Search, the rail's Playbook button, Fight camps tab, Calendar tab. BJJ's page depends on bible decision 1.
"Scouting" means opponents only; prospects are "Find a fighter".

## 7. What stops the clock
The rule: **time stops every Monday so the player can read. Between Mondays it stops only for something that cannot wait, in this order: fight night, weigh-in, injury choice, a big one-off offer on its last day.**
| Event | Stops time? | If ignored |
| --- | --- | --- |
| Monday | Always | Home shows it; nothing is lost |
| Twist card | No | Coach's pick on Tuesday; answer shows in Records |
| Bout offer | Stops on its last day | Lapses; Decline is free |
| Pro offer, championship entry deadline | Stops on its last day | Lapses, with a warning the week before |
| Weigh-in, fight night | Yes | Cannot be skipped; can be simulated |
| Injury choice before a bout | Yes | Must be answered |
| Bills, sponsor offer, goal talk | No | Waits on Home |
| Trial Monday, walk-in | No, shown on Monday | Prospect leaves after a week, by design |
Home lists the three most urgent decisions, then "and 2 more". Unanswered things resolve by the table above, and Records says how. Two fighters do not double the load: twists can be
answered in bulk by "coach decides", a setting per fighter.

## 8. The two flows
**Week:** CONTINUE lands on Monday's Home. Read what changed. Answer or skip the listed decisions. Adjust a plan if you want; last week's
carries over. CONTINUE names what's next: "Friday: Kira weighs in". A quiet week is one click, CONTINUE, with Monday's page to read. Twists, planned-against-actual and stripe calls
all live on Home, so no modal is needed.

**Fight, screen by screen:**
1. **Home:** "Offer: Maria Ortega, 7 Feb". Click.
2. **Bout page:** opponent, money, win band, rank effect. Accept or Decline.
3. **Accept lands on Fight prep** for that fighter, after the poster moment. No area hop.
4. **Fight prep:** set the camp, watch tape. A checklist shows what is unfinished. Button: Write the plan.
5. **Playbook:** the plan, with moves and combos on the same page. With no bout booked, it plans against a chosen style.
6. **Weeks pass:** Home shows the camp clock.
7. **Friday:** weigh-in, one screen.
8. **Saturday:** tale of the tape, rounds with corner calls, or Simulate.
9. **Result:** cards and the verdict.
10. **Why screen (new, and the hook):** three plain lines: what your plan did, what went against you, what to train next, with one button that sets it. It must report real causes. Built plainly in S388: plan_swing replays each exchange's dice without the plan's edge, so it reports true causes. Measured: good plan 59% of bouts, bad 41%, but only about one exchange flipped a fight.
11. **Home, Monday:** new goal, next offer due.

## 9. The arc for release
Not the full ladder: that was a trap. Ship: amateur, nationals, pro debut, 6-8 generated pro bouts, an area title, then sign the next unknown
and go again. About 10-15 hours a career, a guess. **Not approved yet; decide after the hook test.** Needs real work: generated pro opponents, offers for pros, age, a title bout. Retirement
and higher titles wait for proof that people play this far.

## 10. Overlapping clocks
At least two running: goal (4-8 weeks), camp (up to 6), move learned (2-4), bills (monthly), entry deadline, injury, rematch. Needs a
second fighter by week 4.

## 11. Fix first
Condition frozen at 92: fixed S388. Skipped review is lost. No way to ask for a fight. "Not now" on a walk-in blocks
time. With two boxers the checklist can open the wrong plan. "Plan the week" and Fit links land wrong. Contract text hard-coded. Same two
goals every talk. No autosave. No way to fire a coach. Offers expire in code but the red need stops the clock first: section 7 replaces this.
New work this design needs: Why screen and cause data; one-page boxer Playbook (still four tabs); first short-notice bout must allow for weight, since Lucy starts 1.4 kg over; Home must not become the old modal on a busier page: its layout is the first plain-screen test.

## 12. Test
Walk the flows on paper with a critic, then plain screens, then five strangers watched silently and timed against section 3. Ask each: what
would you do next, why did you win, would you carry on?

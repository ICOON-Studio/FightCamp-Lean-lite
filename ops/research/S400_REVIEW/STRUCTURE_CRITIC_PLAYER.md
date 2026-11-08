# Structure critic - the boxing-manager player (S400)

Lens: a Corner King / Football Manager / Punch Club player. Judged on the 46 real screens against YARDSTICK.md and PLAYER_PATH.md.

## Score: 5.5 / 10 as it plays from these screens. Gap to 8 = 2.5 points

What earns the 5.5: the fighter signing card, the opponent bout page (stats vs estimate, win chance, locked scouting file), the Playbook Combos lab and the Game plan lines are real and deep. Money books are clear. The whiteboard look is on Home.

What holds it back:
1. The payoff is not on screen. Screens 18-21 (tape, round 1, two corner calls, round 3, result) all show the dimmed bout page. No fight, no corner, no result, no Why screen. Either the capture failed or the flow is broken. As the review stands, the hook the plan names ("you can see your plan mattered, and why") is unproven.
2. Five screens (11, 12, 13, 13b, 14) read "That offer is gone." The accept-bout flow, the camp and the booked Home are not reviewable. Either a capture bug or a dead end a player would hit.
3. The week is many weeks of plain bookkeeping before a fight: week 1 (07) to the weigh-in (16) is a 4-month jump with 1.6 kg over and a missed-weight cancel. The first bout is a failure state, not a win.
4. Home between events is thin: one fighter row, a cork board, a ledger. Little "who is my rival, what is at stake".
5. Too many bars for the player's money-and-time: Fighters roster, Overview and Week all repeat condition/weight/goal.

## Per-screen table

| screen | fun / decision value 1-5 | verdict | reason (<= 15 words) |
| --- | --- | --- | --- |
| 01_title | 3 | KEEP | Lucy vs Maria poster sets the promise; menu is plain and fine |
| 02_create | 4 | KEEP | Coach edge with a clear first-felt moment is a real identity choice |
| 03_home_start | 3 | CHANGE | Guide strip, job, cork board, ledger: four voices; one clear next action needed |
| 04_interview | 5 | KEEP | Best screen: stats with ceiling, traits, habit, perk road, one starting focus |
| 05_gym_staff | 3 | CHANGE | Hire choice is real but dense; no comparison of what I lose without a coach |
| 06_training | 2 | CHANGE | Roster with one fighter; "needs you" chips repeat the top bar |
| 06b_guide_go | 4 | KEEP | Week plan with fatigue, pad learning, goal pace: the core mechanic, clear |
| 07_home_week1 | 3 | CHANGE | Offer and sponsor note good; most of Home is empty cork |
| 08_review | 3 | CHANGE | Bars with next-point maths are useful; the pads panel is greyed and thin |
| 09_fighter | 4 | KEEP | Attributes with potential tick, temper, at-a-glance note card: readable |
| 10_offers | 4 | KEEP | Two offers with win chance, gap, rank, "not safe" warning: a real pick |
| 11_bout_unsafe | 1 | CUT | Shows "That offer is gone"; dead end, nothing to judge |
| 12_bout | 1 | CUT | Same dead end, duplicate |
| 13_home_booked | 1 | CUT | Same dead end, duplicate |
| 13b_home_booked_settled | 1 | CUT | Same dead end, duplicate |
| 14_camp | 1 | CUT | Same dead end, duplicate; the camp mechanic is never shown |
| 15_fight_camps | 2 | CHANGE | Roster again with the offer chip; camp content is absent |
| 16_weighin | 3 | KEEP | Weigh-in drama is great; but it is fail state, and floats over Fights |
| 17_home_fightnight | 3 | CHANGE | Fight night Home reads like a normal week; no build-up, no stakes |
| 18_tape | 1 | CHANGE | Dimmed bout page; no tape-study screen visible |
| 19_round1 | 1 | CHANGE | Dimmed bout page; no round is visible |
| 19b_corner1 | 1 | CHANGE | Dimmed bout page; the corner minute (the USP) is not shown |
| 19c_corner2 | 1 | CHANGE | Same, duplicate |
| 20_round3 | 1 | CHANGE | Same, duplicate |
| 21_result | 1 | CHANGE | No result card and no Why screen visible; the hook is missing |
| 22_goaltalk | 3 | KEEP | Two goals with a quote is character; only two choices is thin |
| 23_record | 2 | CHANGE | Three rows pre-club; no post-fight record line, no Why link |
| 23b_coach_notes | 3 | KEEP | Attribute bars with +0.3 deltas show progress |
| 23c_combos | 3 | KEEP | Same overview, week-on-week deltas, good |
| 23e_training_tab | 4 | KEEP | Week board with fatigue and pad-learn plan; the owner's whiteboard hit |
| 23d_training_combo | 3 | CHANGE | Duplicate overview, adds nothing new |
| 23g_playbook_moves | 3 | CHANGE | 27 cards, little to decide; unlock path not shown as a goal |
| 23h_playbook_plans | 5 | KEEP | Rate against an opponent type; answer lines per range: the fun core |
| 23i_playbook_combos | 5 | KEEP | Build, play on a ghost, win-rate per opponent type: learn by trying |
| 23j_playbook_escapes | 2 | CHANGE | Reference list; fold into Moves |
| 23k_mail | 2 | CHANGE | Shows World news; mail is a flat feed with no action |
| 23l_gear_menu | 1 | KEEP | Save/Load menu; needed, no fun |
| 24_deals | 2 | CHANGE | Shows the Club Money page (duplicate); sponsor decision not visible |
| 25_facilities | 2 | CHANGE | Same Money page; facilities are not shown |
| 26_money | 4 | KEEP | Runway, break-even, in/out bars: a gym that can close, clear |
| 27_bills | 2 | CHANGE | Duplicate Money page |
| 28_members | 2 | CHANGE | Staff page, not members; member mood and retention are missing |
| 29_news | 3 | KEEP | Names, fights, local stories give the region a pulse |
| 30_rankings | 4 | KEEP | Ladder with style, last bout, where Lucy enters; chase a name |
| 30b_rival_file | 4 | KEEP | Locked opponent's file with tape-study lock: curiosity |
| 31_events | 4 | KEEP | Road to nationals with four gates; clear target, tension |

## The 5 moments that keep a player playing

1. Sign her (04). Delivered: strong stats, trait, habit, perk road, one focus choice.
2. The first win, and why (21, plus the missing Why screen). NOT delivered: no fight, corner or result in these screens, and the weigh-in path shows a cancelled bout instead.
3. Scouting an opponent and picking my plan (10, 23h, 23i, 30b). Mostly delivered: tape lock, win chance, answer lines. The link from tape to plan to result is untested here.
4. Seeing her improve (08, 23, 23e). Delivered: bars fill, deltas, "usable in 2 weeks" on pads.
5. The gym on the edge (26, 05). Partly delivered: runway and break-even exist, but nothing on Home says the gym is in danger.

## MISSING (a boxing-manager player expects it, does not find it)

- The fight and the corner on screen, the result card, and the "what decided it" screen.
- A working accept-bout flow: five screens say "That offer is gone."
- A rival: a named opponent who returns, with a rematch. Dana Whitfield is only a list row.
- Fighter personality in play: the temper and mood show as a number, but no moments (a talk, a row, a rumour) change a choice.
- A second fighter and overlapping clocks: Ana is shown on Fights and Home only, not played.
- Member and club life: no member mood, no retention story, no gym-night events, no reputation line on Home.
- A reason to care about the opponent before the bout: no face-to-face, no press line, no stakes beyond a number.
- Sparring partners and sparring choices: the roster of partners is not visible.
- Injuries, cuts, and medical choices before a bout: absent.
- Contracts, purse split, promoter: absent beyond a flat $450 cut.
- A season view: calendar of shows, year review, awards.

## Top 5 changes for fun, ranked

1. Make the fight night flow reviewable and strong: tape, rounds, corner minute, result, and a three-line Why with one button that sets the fix. This is the product.
2. Fix the accept-bout path (offer, camp, booked Home). Five dead screens mean the loop is not closed.
3. Give the first bout a safer start: weigh-in is the first drama, and failing it cancels the debut. Make the cut a real choice with a visible cost, not a wall.
4. Make Home answer "what matters this week": one rival, one clock, one risk; drop the repeated chips and half-empty cork.
5. Fold Escapes into Moves, merge Mail into Home, and dedupe the Money pages; keep Playbook Game plan and Combos as the lead feature and surface it from the offer page.

# S400 structure review - UX lead (flow and structure)

Judged against FightCamp's own plan (YARDSTICK, PLAYER_PATH v3, STRUCTURE_DESIGN S395, MENU_MAP), not a generic sim.

## Score: 5 / 10 as it is today

What works: the spine is right. Five rail areas, one top bar, a CONTINUE that names where it stops, a first-week guide, the Bout page (stats vs estimate, win chance, scouting, terms), the whiteboard Week tab, Money with runway, the Nationals road. The game is deeper than wider, as planned.

What holds it down:
- The first fight cannot be walked as a player. Accept, camp and booked-bout screens do not exist in the capture (04-14 end in "That offer is gone"), and the one weigh-in we see ends with "the bout is off" because the player was 1.6 kg over after the guide said "0.1 to spare".
- Fight night (rounds, corner, result) is not in the capture at all (19-21 are the dimmed Bout page). I cannot confirm that part of the structure; I judged it from the plan.
- Three things still open by themselves or live in modals the plan removed: Week review (08), Goal talk (22), weigh-in (16).
- Home is six panels (guide, job, noticeboard, since Monday, club this week, coming up) that repeat the top bar's NEEDS YOU and the World news.
- Fights has no "ask for a fight", no results, and repeats World's fixtures.
- Playbook is a page inside a page (4 sub-tabs inside a 4-tab fighter page).
- 12 of the 46 captures are duplicates of another screen (a capture problem, but it also means we cannot show the Facilities, Deals, Records, Camp and Mail screens exist).

To reach 8: (1) walk the whole first fight with no dead end, from Home flag to Result and back to Home; (2) Home on Monday absorbs Week review, Mail, Goal talk and the Why line; (3) Fights gets Ask for a fight plus Results; (4) Accept lands in Fight prep; (5) the Why screen after every bout; (6) one page for Playbook; (7) re-capture every screen from a real player path and strip repeated panels.

## Per screen

| screen | verdict | reason |
| --- | --- | --- |
| 01_title | KEEP | Clear; add Continue/Load at top for returning players. |
| 02_create | CHANGE | Good past-as-edge idea; step 2 not seen; four cards each need a decision hint. |
| 03_home_start | CHANGE | Six panels; noticeboard, guide and top bar repeat each other. |
| 04_interview | KEEP | Right modal: real stats, ceilings, one starting focus, sign or pass. |
| 05_gym_staff | CHANGE | First-hour hire buried in Club > People; staff list too long. |
| 06_training | CHANGE | Roster with one row; "Needs you" chips repeat the top bar. |
| 06b_guide_go | KEEP | The Week tab is the core mechanic; keep as the fighter's Week. |
| 07_home_week1 | CHANGE | Monday page should carry decisions with causes, not six boxes. |
| 08_review | MERGE (into Home) | Plan: Home replaces the review; it pops up by itself. |
| 09_fighter | KEEP | Real stats, hover, goal; move Body and Goal above the fold. |
| 10_offers | CHANGE | Offers fine; no Ask for a fight, no results, fixtures repeat World. |
| 11_bout_unsafe | CHANGE | Capture ends in "That offer is gone": a dead end with no way on. |
| 12_bout | CHANGE | Same dead end; an expired offer must close itself and clear the flag. |
| 13_home_booked | MERGE (into Home) | Booked state should be one Home card with countdown. Not rendered. |
| 13b_home_booked_settled | MERGE (into Home) | Duplicate of 13. |
| 14_camp | CHANGE | Camp screen not rendered; must live in Fighter > Fight prep. |
| 15_fight_camps | CUT | Shows the roster again; the Fight camps tab was cut from the plan. |
| 16_weighin | KEEP | One-screen forced stop is right; guide must not promise a made weight. |
| 17_home_fightnight | CHANGE | Shows "bout is off"; no fight-day flag or Go to fight night. |
| 18_tape | KEEP | Best screen: estimate bars, win band, locked scouting lines, terms. |
| 19_round1 | KEEP | Not rendered (dim Bout page); keep per plan, verify. |
| 19b_corner1 | KEEP | Not rendered; corner minute is a core mechanic, verify. |
| 19c_corner2 | KEEP | Not rendered; same. |
| 20_round3 | KEEP | Not rendered; same. |
| 21_result | CHANGE | Not rendered; must become the Why screen (plan, against, train next). |
| 22_goaltalk | MERGE (into Home) | Modal opens over a Bout page; make it a Home decision. |
| 23_record | CHANGE | History lacks the Anvil bouts and the "what decided it" note. |
| 23b_coach_notes | MERGE (into 09) | Duplicate of Overview. |
| 23c_combos | MERGE (into 09) | Duplicate of Overview. |
| 23e_training_tab | MERGE (into 06b) | Duplicate Week tab. |
| 23d_training_combo | MERGE (into 06) | Duplicate roster. |
| 23g_playbook_moves | CHANGE | Right pane empty until click; 27 moves in four ranges; fold Escapes in. |
| 23h_playbook_plans | KEEP | Plan by range and round, rated vs a style: the fun mechanic. |
| 23i_playbook_combos | KEEP | Build, see it flow, drill on pads: fun, keep as is. |
| 23j_playbook_escapes | MERGE (into Moves) | Escapes are moves grouped by situation, not a tab. |
| 23k_mail | MERGE (into Home) | Mail opens World News; plan says Home replaces Mail. |
| 23l_gear_menu | CHANGE | Menu drops from the top-left, far from the button at top right. |
| 24_deals | CHANGE | "Deals" button lands at the foot of Money; no sponsor page. |
| 25_facilities | MERGE (into Club) | Capture is Money; facilities belong in Club > Gym with staff. |
| 26_money | KEEP | Cash, runway, in and out: the club-can-close promise, visible. |
| 27_bills | MERGE (into 26) | Duplicate of Money; bills are a block on Money. |
| 28_members | CHANGE | People shows staff only; who stays and who leaves is nowhere. |
| 29_news | CHANGE | Twenty flavour lines; keep only bouts that touch your fighters or rivals. |
| 30_rankings | KEEP | Clickable rivals, "Lucy enters at 4 wins": actionable. |
| 30b_rival_file | KEEP | Right modal; locked lines tell the player what the tape study unlocks. |
| 31_events | KEEP | Road to the Nationals with four checks is clear and actionable. |

Counts: KEEP 16, CHANGE 17, MERGE 12, CUT 1.

## MISSING (the plan needs them; none exist in the captures)

- Ask for a fight (PLAYER_PATH s5: "Impossible" today). The manager's real job; without it Fights is a mailbox.
- Fight prep per fighter (camp, tape, "Write the plan", checklist). Accept must land here; today there is no camp screen and no prep checklist.
- Why screen after the result (hook of the whole design; plan_swing data exists).
- Fight-day flag on the top bar and a Go to fight night button on Home.
- Results list on Fights (every past bout, what decided it) and a Records page in Club (year review, legacy).
- Home Monday as the one reading page: decisions with causes, clocks, "and 2 more". Mail and review live there.
- Members page (dues, who stays, break-even 78) and Facilities with condition; today only a number.
- Find a fighter page contents (5 prospects scouted, hidden under a tab) and a Sponsor/Deals page.
- Save and Load screens, Settings, Handbook (Menu lists them; none captured) and autosave notice.
- Second-fighter onboarding by week 4 (the guide mentions it, no path).
- Info modal ("any number explains itself").

## Which map is right

Neither exactly. Today's five areas are right and should stay; the seven-area MENU_MAP is out of date (as YARDSTICK says) and its Playbook, Money and Gym buttons were folded on purpose. But the MENU_MAP is right about three things today's game lacks: Fights needs Offers, Calendar and Results as one page; Money needs Deals; and fight night is a flow of five screens, not one modal. PLAYER_PATH v3 (5 areas, 8 tabs, 5 fighter tabs) is the target; today's build is two steps short of it (Playbook still four sub-tabs; Fights has no results).

## Proposed structure

- Title: Continue | New career | Quick start | Load | Settings | Quit
- Top bar (all screens): Back/Fwd, gym, date, CONTINUE (says where it stops), cash, flags (Needs you, Fight day), Menu (Save, Load, Settings, Handbook, Quit)
- Home (no tabs): Monday page = decisions with causes, clocks, your fighters (one line each), next dated event, fight-day button, last result's Why line
- Fighters
  - Roster
  - Find a fighter
  - Fighter page: Overview | Week | Fight prep | Playbook (Moves incl. escapes, Game plan, Combos on one page) | History
- Fights (no tabs): Ask for a fight and offers on top, booked bout and camp clock, dated calendar, results below
  - Bout page (modal-like page): opponent, terms, Accept (goes to Fight prep) or Pass
- Club
  - Gym: staff, members, facilities
  - Money: cash, in and out, bills, deals
  - Records: year review, titles, legacy
- World
  - Rankings (rival file on click)
  - Championships
  - News (only what touches you)
- Fight night flow (from Go): Weigh-in, Tale of the tape, Rounds with Corner minute, Result, Why

## Top 5 structural changes, ranked by effect on the first five hours

1. Make the first fight walkable end to end: Home flag, Bout page, Accept lands on Fight prep, camp, weigh-in, fight night, Result, back to Home. Fix the dead ends ("offer is gone"), the weight promise the guide breaks, and the missing fight-day flag. Hours 1-2 depend on it.
2. Add the Why screen to Result: three plain lines (what your plan did, what went against you, what to train next) with one button. It is the hook, and it is what the plan and rival analysis say the game wins on.
3. Make Home Monday the one reading page and fold Week review, Mail, Goal talk and booked-bout state into it. Remove the six-panel layout; nothing pops up by itself except fight-night stops.
4. Give Fights its real job: Ask for a fight, offers, booked bout and camp clock, calendar, results. Drop its duplicate fixtures from World. Without this there is no second and third fight to want.
5. Cut the double nesting: Playbook as one page under the fighter, Escapes folded into Moves, Club as Gym | Money | Records, duplicate roster and overview captures gone. Then re-shoot every screen from a real player path so the structure can be checked.

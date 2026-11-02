# J54: HOW SPORTS-MANAGEMENT AND FIGHT GAMES ORGANISE THEIR MENUS

- **Task:** J54, menu architecture survey and a proposed information architecture (IA) for FightCamp
- **Date:** 2026-09-25 (every source read on this date; times are Asia/Nicosia, UTC+3)
- **Status:** RESEARCH ONLY. No code, no repo work, no HANDOFF edit.
- **Trigger:** Operator, 2026-09-25: "make this properly like you're presenting this to someone who wants to buy the game ... organize all the menus ... I don't understand what the fuck is the day. You have to reorganize everything ... You have to do a survey and decide how the main menu will be".
- **Builds on:** J52 (tooltips and an optional 18-step guided first career month ending in an England Boxing club bout), J53 (the amateur tutorial should use England Boxing terms), FLOW_PASS3 (hub golds, including ENTER FIGHT WEEK).
- **Claim tags:** SOURCED = a page I read on 2026-09-25 says this. PROXY = an estimate or a borrowed stand-in (for example a click count built from a manual's path, or a label taken from a community shortcut list rather than the game itself). JUDGEMENT = my recommendation. NOT FOUND = I looked and could not verify it.
- **Source types:** DEV, BROADCAST, TRADE, ACADEMIC, PRESS, COUNT, COMMUNITY, STANDARD. Sources are listed in section 5 with IDs S1 to S46.
- **Grok:** one Grok CLI pass was run (details in section 7). Everything Grok said was treated as a lead. Leads I confirmed on the real page are cited to that page. Leads I could not confirm are in Appendix A and are not used anywhere else.

---

## 0. Headline answer

1. **Rename THE DAY to HOME.** THE DAY is a unit of time, not a place or a job. It also competes with the CONTINUE button, which is the only other thing on screen about time. None of the 11 games surveyed names its hub after a unit of time. They use Inbox, Home, Portal, Manager's Office, Main Screen/Office or Career Hub (section 2). JUDGEMENT, built on SOURCED survey data.
2. **Title screen (exact labels):** `RESUME CAREER` (shown only when a save exists, with gym name and in-game date under it), `NEW CAREER`, `LOAD CAREER`, `SETTINGS`, `QUIT`. JUDGEMENT, following the OOTP and FM start-screen pattern (S11, S34).
3. **Five top-level areas on the left rail:** `HOME`, `FIGHTERS`, `FIGHTS`, `GYM`, `MONEY`. Save, load and settings move to a gear menu in the top bar. The number of areas falls inside the 5–7 target. The labels are plain nouns that name the player's jobs (NN/g S2 guideline 7). JUDGEMENT.
4. **HOME answers "what needs me today".** It shows, in this order: a `NEEDS YOU` list (blockers first, at most 5 rows), `NEXT UP` (the next bout, weigh-in or camp milestone, with a countdown), `YOUR FIGHTERS` (one line each: weight, condition, injury), `MONEY THIS WEEK` (cash and weekly net), and `NEWS & MAIL`. The model is OOTP's Manager Home Screen, which "works like a task organizer" (S32). Also taken from SI's finding that FM players lived in the Inbox, not on Home (S6, S8). JUDGEMENT on SOURCED patterns.
5. **One time control, bottom right, always in the same place:** `CONTINUE`. It runs day by day until the next thing that needs you: a decision, a weigh-in, a camp start, fight night or month-end bills. A sub-line says where it will stop (for example "to Thu 12 Mar · weigh-in"). If a decision is blocking, the label becomes `NEEDS YOU (n)`, and clicking it jumps to the first blocker. On fight day it becomes `GO TO FIGHT NIGHT`. FM24 already changes the Continue label when a reply is needed (S10). Motorsport Manager will not continue until a required email is answered (S26). OOTP lets Continue auto-advance until a game day (S33). The exact FightCamp wording is JUDGEMENT.
6. **Clicks from boot to the first bout:** about **21 clicks** on the quick path, and about **24** with the J52 guided month switched on (PROXY count, section 4f). For comparison, FM24's shortest documented path from the start screen to the in-career hub is 4 clicks (S11). None of the surveyed games publishes a boot-to-first-match click count (NOT FOUND).

---

## 1. What would a human do?

A UX lead on a management game would not start with screens. They would start with the jobs the player is hired to do, then build the navigation from those jobs. NN/g describes this as task analysis: first gather "goals and tasks", then analyse "the overall number of tasks and subtasks, their sequence, their hierarchy" (S3, STANDARD). SOURCED. They would check the result against the known limits on breadth and depth. They would also look at how the genre leader handled it, and at what went wrong when the leader changed it.

### 1a. Job map for a fight-gym owner (JUDGEMENT, grounded in J52 §1 and the current FightCamp rail)

| Player job (goal) | Recurring tasks | How often | What breaks if ignored | Area it belongs to |
|---|---|---|---|---|
| **Develop fighters** | Set training, plan and run a fight camp, manage weight, rest injuries, recruit or scout new fighters | Daily or weekly | Fighters miss weight or lose bouts | FIGHTERS |
| **Get them fights** | Read bout offers, accept or decline, check the opponent, weigh-in, fight night, see results and rankings | Weekly, spiky around events | No income, no progress, no ranking | FIGHTS |
| **Run the gym** | Facilities, members and classes, repairs, hire and fire staff (coaches, cutmen) | Weekly or monthly | Worse training, members leave | GYM |
| **Make money** | Cash, weekly net, purses, sponsors, bills, loans | Weekly, with month-end | Game over, or no expansion | MONEY |
| **Know what needs me now** | Decisions due, deadlines, next event, alerts | Every session, every day | Missed deadlines, confusion ("what is the day?") | HOME |

Scouting sits under "Develop fighters", because in a gym sim scouting means finding people to sign. Opponent reports belong on the bout page inside FIGHTS. JUDGEMENT. I did not open the game code (the task said no repo work), so I have not checked which of these two things today's SCOUTING screen does. It is flagged in section 7.

### 1b. IA principles derived from the job map and the UX sources

| # | Principle | Why | Tag |
|---|---|---|---|
| P1 | **One top-level area per player job, 5–7 in total.** | A flat structure makes content easier to find ("Content is more discoverable when it's not buried under multiple intervening layers"). But very broad menus create "conceptual overlap" and can overwhelm (S1). Hick's law says decision time "increases with the number and complexity of choices" (S4). Laws of UX also warns: "Don't use the 'magical number seven' to justify unnecessary design limitations" (S5). So 5–7 is a working range for a small game, not a law. | SOURCED (principles) / JUDGEMENT (the 5–7 range) |
| P2 | **Plain, specific, familiar labels. No invented words.** | NN/g: "Menus are not the place to get cute with made-up words, internal jargon, or abstract high-level categorization" (S2, guideline 7). THE DAY and "Portal" both fail this test (section 3). | SOURCED |
| P3 | **Primary navigation stays visible on the left, and the current location is always highlighted.** | NN/g: for applications, primary navigation is expected on the "Left side of the screen". "Failing to indicate the current location is probably the single most common mistake" (S2, guidelines 2 and 5). | SOURCED |
| P4 | **Second level is a visible tab row inside each area, not a hover dropdown, and never more than 2 levels.** | NN/g recommends local navigation for related pages. It advises click-activated rather than hover submenus, and warns against multi-level cascades (S2, guidelines 6, 13, 14). FM26 players complained that menus "disappear after you click an option" and that the navigation tree "must become deeper" (S23). | SOURCED |
| P5 | **A home screen that is a task list, not a wall of tiles.** | OOTP's Manager Home Screen "works like a task organizer" with notes on the left and "a list of manager tasks" on the right (S32). SI found FM's old Home was little used and that "most of your time [was] spent in the Inbox" (S6). A reviewer found FM26's Portal was "showing me more information than I could actually process, and surfacing the wrong information" (S17). | SOURCED |
| P6 | **One time-advance control, always in the same place, whose label says what will happen.** | FM: "The 'Continue' Button is central to Football Manager ... It can change state depending on the game's context" (S10). OOTP lets you configure what CONTINUE auto-handles (S33). An FM26 critic describes a tutorial "continue" button "darting around the screen like I'm playing Whac-A-Mole" (S20). | SOURCED |
| P7 | **Must-answer items are visually distinct and block time until answered.** | FM24 "messages with red highlights are always the more important ones" (TheGamer, see Appendix A; not relied on). Eurogamer on FM26's preview build: "Must-reply not-emails aren't highlighted in red in the queue anymore, making it harder to skip to them" (S15). In Motorsport Manager "you can't continue the game until you respond to that email" (S26). | SOURCED |
| P8 | **Keep a Back button that works, and do not trap the player in pop-ups.** | Eurogamer: "there's no 'back' button within the windows" (S15). A Reddit post says you "can't go back to your previous page by just clicking the back button" (S24). | SOURCED |

**GDC talk on Football Manager UI:** NOT FOUND. The closest developer sources are SI's own blogs (S6, S7, S8, S9) and a studio interview in Forbes (S19). Grok also found a Unite 2024 (Unity conference) talk titled "Tackling UI challenges in Football Manager 25". I saw it only as a search result and did not watch it (Appendix A).

---

## 2. Survey of 11 games

### 2a. Comparison table

"Hub" means the screen the player lands on inside a career. The click column counts **menu clicks from the start screen**. A first-launch profile or fighter creator is excluded unless stated. All click counts are PROXY, built from documented paths. None was timed by me in the game.

| Game | Title-screen labels (exact where confirmed) | Hub name | Top-level navigation (exact where confirmed) | Time-advance label | Boot → first match/bout (PROXY) |
|---|---|---|---|---|---|
| **Football Manager 2024** (PC) | `Start a New Game` → `Career` → team → `Quick Start` (or `Advanced Setup`). Import: `Load FM23 Saved Games`. SOURCED S11. Full start-screen list NOT FOUND. | **Inbox** in practice (SI: most time spent there, S6, S8). A separate **Home** also exists (F2, S13). | Left **Side Bar**, "the primary method to navigate all the different areas within your club" (S10). Item labels, PROXY from the shortcut list (S13): Home, Inbox, Squad, Dynamics, Tactics, Training, Medical Centre, Development Centre, Scouting, Transfers, Schedule, Club Vision, Finances, Staff, Club Information. Data Hub named in the SI manual (S12). A player puts the sidebar at "about 20 first-level options" (S23). | `Continue`. The label changes when "a message in your Inbox ... requires a response" (S10). Keyboard: Space (S13). | 4 clicks to the hub (S11). Then an unknown number of Continue presses to the first pre-season friendly (NOT FOUND). |
| **Football Manager 26** (PC) | Full PC list NOT FOUND. Grok lead: `Quick Start` / `Advanced Setup` (Appendix A). | **Portal**: "we've combined the two [Home and Inbox] together to create the Portal" (S6). | Six top-bar domains: `Portal`, `Squad`, `Recruitment`, `Match Day`, `Club`, `Career` (S14). SI: "six categories at the top of the screen that all have their own submenus" (S7). Plus Bookmarks (up to 12 on high resolution, 24 options), Search and FMPedia (S7). | `Continue`. Eurogamer: "before you can mash Continue once more" (S15). A Steam review: "wouldn't let me hit continue" (S25). | Similar setup to FM24. Players report more clicks per task after that (section 3). Count NOT FOUND. |
| **Motorsport Manager** (2016) | English title labels NOT FOUND. Team selection is ordered weakest to strongest (S26). A tutorial is offered at start (S27). | **Home**: "gives a quick overview of your team" with a Team Stats graph (S26). | Tabs "at the bottom of the screen" (S26). The guide names Home, Player, Team, Mail, Finances, Standings, Calendar, plus Car, HQ, Drivers, Staff, Scouting sections. Exact bar order NOT FOUND. | Continue (PROXY, from guide wording: "you can't continue the game until you respond to that email"; "You can continue the game and it will stop at the deadline", S26). | About 5–15 clicks to Home, then Continue to the first race weekend. PROXY. |
| **WWE 2K MyGM** (2K22–2K26) | Game-level main menu for 2K23/2K25/2K26 NOT FOUND. MyGM setup: choose GM → brand → settings → draft (S28, S30). | **Home screen**: Journal, Commissioner Goals, Promises, Free Agent Statuses, Show Notes, Career Progress, plus rank, revenue and fans (2K24 S29; 2K26 S30). | `Book Show`, `Show Logistics`, `Manage Roster` ("tab"), Power Cards, `Season` tab of the Main Menu (S28, S29, S30). 2K25 GM Assistant opens "from any screen" (S31). | No Continue button. The week advances by running the booked show: "Play, Simulate or Spectate", then reports (S30). Online: "Ready Up screens" (S31). | Draft needs "at least 9 rounds" in 2K26 (S30). Auto Draft and `Auto-Book Show` shorten this (S30). About 15–30 clicks to the first match. PROXY. |
| **Punch Club 2: Fast Forward** | NOT FOUND. | No named dashboard found. Location and map based (Steam store S45 describes the story setup only). | NOT FOUND. | NOT FOUND. Time is spent through activities (grok lead, Appendix A). | NOT FOUND. |
| **Boxing Champs** (2019) | NOT FOUND. Store lists "Create a Boxer" and "Career Mode" (S43). | Not a management game. The career is fight-by-fight: "with your trainer, move up the world rankings" (S43). | NOT FOUND. | NOT FOUND. | NOT FOUND. Probably few clicks (JUDGEMENT). Excluded from the pattern analysis. |
| **World Championship Boxing Manager 2** (2023) | "Story Mode" and a career. The first story is "An Underdog Story" (S41). Store: "Simpler interfaces and more straightforward decision-making" (S42). | NOT FOUND by name. There is a calendar with training and rest days (S41). | NOT FOUND. | NOT FOUND as a button label. Days are filled with training or rest (S41). | NOT FOUND. Story Mode is the onboarding (S41). |
| **EA UFC 5 Career Mode** (2023) | Modes: Career Mode, Online Career Mode, Fight Now, Alter Egos (S37). Exact main-menu strings NOT FOUND. | "main career mode hub", with G.O.A.T. Status (S38). | NOT FOUND as labels. Weekly time budget, sparring and social posts (S38). | No global Continue. "a set amount of time to chip away at each week during training camp" (S38). Training can be simulated (S37). | NOT FOUND. Onboarding with Coach Davis (S37). |
| **Undisputed Career** (2024) | NOT FOUND. | **Career Hub**: "open your Career Hub and navigate to the My Team tab" (S40). GINX: "the normal career mode hub" (S39). | `My Team` tab confirmed (S40). Others NOT FOUND. | NOT FOUND as a label. Weekly fight camps (grok lead). | An optional amateur tournament comes before the hub (S39). NOT FOUND. |
| **Pro Wrestling Sim** (2021) / **TEW2020** (extra) / **Promotion Tycoon** | PWS: NOT FOUND. TEW: NOT FOUND. Promotion Tycoon: game NOT FOUND. | PWS: NOT FOUND (grok says "office screen", Appendix A). TEW2020: "On most days you will only be using the main screen and the office" (S35). | TEW2020: a left "navigation menu" plus a bottom "utility bar" split into "quick office, quick workers, quick companies, and user controls" (S35). Office sub-screens include Roster, Events & TV, Titles, Creative, Medical, Promises (S36). | TEW2020: the navigation menu lets you "advance forward to the next day (either in single days or 'multi-advancing' through many at once)" (S35). The exact icon tooltip text is NOT FOUND. | NOT FOUND. |
| **Out of the Park Baseball** (series manual OOTP 18/21; 25/26 not checked page by page) | `OOTP Start Screen`: `Create New Game`, `Load Game`, `Quickstart Games`, `Settings`, `Exit OOTP` (S34). | **Manager's Office**: "the primary portal for all managers, and the default screen you see any time you load a saved game". Its Manager Home Screen "works like a task organizer" (S32). | Menus: File, Game, Manager, League, Team, Play (S34 table of contents). | `CONTINUE`, configured in **Game Flow**. With "Show & play today's game" on, "clicking CONTINUE will take you to the game". Auto-play advances "a set number of days unless it reaches a game to play" (S33). | About 5–10 clicks: new game → team → Manager's Office → CONTINUE to the first game. PROXY. |

### 2b. Per-game notes

**Football Manager 2024.** The SI manual describes three navigation layers:
- The Side Bar, which is "the primary method to navigate all the different areas within your club".
- A Navigation Bar for "the rest of the game (i.e. browsing the game world in general)", with Back and Forward.
- A Calendar reached by clicking the date on the Menu Bar (S10).

The Continue button is "the conduit from which the game progresses through time". If an Inbox message needs a response, "the text label on the button changes to reflect this" (S10). All SOURCED. The exact replacement wording is NOT FOUND on a page I read (Grok suggested "Must Respond"; Appendix A). The quick-start path is `Start a New Game` → `Career` → team → `Quick Start` (S11). The Console/Touch manual titles one chapter "Your Inbox, Your Home" (S12, manual index). SOURCED. Takeaway: FM24's real hub was the Inbox, and the button's label carried the must-respond state.

**Football Manager 26.** SI merged Home and Inbox into the **Portal**, "a one-stop shop for the key happenings in your FM universe". It has message filters "All, New, Tasks and Unread", an "Advice" dropdown, news, upcoming fixtures and "a two-week snapshot of the Calendar" (S6). SI's stated principles were "Efficiency, Familiarity, and Predictability", including "reducing the number of button clicks" (S6). The navigation bar moved to the top, with six domains (S7, S14). In 2024 SI explained the reasoning: "Historically the screen that people spend the most time on in FM has been the Inbox ... this has felt quite old school" (S8). On 11 May 2026 the studio director wrote that "many were frustrated by the changes to navigation" and that the platform-agnostic shift "was ultimately detrimental to some of your experiences" (S9). All SOURCED. Takeaway: FM26 is the clearest warning in the genre. It renamed a well-understood hub and hid second-level items behind menus, and players rejected it (section 3).

**Motorsport Manager.** "The main interface is divided up into tabs at the bottom of the screen." Home "gives a quick overview of your team", and clicking a stat bar "will link to the corresponding page" (S26). Mail items that need a decision "can't be skipped (you can't continue the game until you respond to that email)" (S26). SOURCED. Takeaway: Home as an overview that links out, and blocking decisions stop time. This is close to what FightCamp needs.

**WWE 2K MyGM.** The hub is the **Home screen**, which holds the Journal, Commissioner Goals, Promises, Free Agent Statuses, Show Notes and Career Progress (2K26, S30). The weekly loop is `Book Show` → Show Logistics → run the show ("Play, Simulate or Spectate") → Match Report, Drama Curve, End of Week Report (S28, S30). There is no Continue button. The show itself is the tick. 2K25 made the GM Assistant open "from any screen" (S31). SOURCED. Takeaway: a fight-night-driven loop can make the event the natural stopping point, which is what FightCamp's CONTINUE should do.

**Punch Club 2.** The store page describes a narrative game (S45). No menu labels were confirmed. NOT FOUND.

**Boxing Champs.** This is an arcade and simulation boxing game. Its career is fought bout by bout "with your trainer" (S43). It is not a management reference. NOT FOUND for hub and navigation.

**World Championship Boxing Manager 2.** Story Mode teaches the interface: "an introduction to the game mechanics and a turned down difficulty level" (S41). The reviewer found "the calendar system somewhat annoying due to specific dates being referenced but not labeled" (S41). SOURCED. Takeaway: dates and events must be labelled wherever they are mentioned. FightCamp's CONTINUE sub-line and NEXT UP card should do this.

**UFC 5.** There is a "main career mode hub", and time is a weekly budget of activities (S38). The official page stresses "a refined focus on onboarding" and simulated training "to get to the fights faster" (S37). SOURCED. Hub label NOT FOUND.

**Undisputed.** The **Career Hub** has a **My Team** tab for coach, cutman and manager (S40). The career loop is to "negotiate a new fight, manage your staff, and upgrade your fighter" (S39). SOURCED. Takeaway: a fight game's three verbs (fight, staff, upgrade) closely match FightCamp's FIGHTS, GYM (staff) and FIGHTERS.

**Pro Wrestling Sim / TEW2020 / Promotion Tycoon.** PWS store: a "text-based pro-wrestling booking simulator" (S44). TEW2020 handbook: the "navigation menu" on the left also advances time ("single days or 'multi-advancing'"). There is a "utility bar" whose "quick office" is "the one you'll use most often", giving "access to your mail and decisions" (S35). SOURCED. I could not find a released game called Promotion Tycoon (NOT FOUND).

**OOTP.** The start screen has `Create New Game`, `Load Game`, `Quickstart Games`, `Settings` and `Exit OOTP` (S34). The Manager's Office is the default screen. Its home view "works like a task organizer", with notes on the left and "a list of manager tasks" on the right that "could include things such as the need to place an injured player on the disabled list ... the need to respond to a trade offer" (S32). CONTINUE is configurable through Game Flow (S33). SOURCED. Takeaway: this is the strongest direct model for FightCamp's HOME and CONTINUE.

### 2c. Patterns across the survey (SOURCED from 2a/2b; synthesis JUDGEMENT)

- **Hub names used:** Inbox (FM24), Portal (FM26), Home (Motorsport Manager, WWE MyGM), Manager's Office (OOTP), Main Screen + Office (TEW2020), Career Hub (Undisputed, and UFC 5 as described by the press). **No game names its hub after a unit of time.**
- **Time-advance labels:** Continue (FM24, FM26, OOTP, and Motorsport Manager by guide wording). Advance / multi-advance (TEW2020). Running the event itself (WWE MyGM, UFC 5 and Undisputed camps).
- **Blocking decisions:** FM24 relabels Continue (S10). Motorsport Manager blocks it (S26). OOTP lists tasks and lets Game Flow decide what stops Continue (S32, S33).
- **Top-level breadth:** about 20 visible items (FM24, S23) against 6 domains with dropdowns (FM26, S7). Both drew complaints. FM24's complaint is from a later player looking back at FM24, not from launch. FM26's backlash was about depth and hidden sub-items more than about the number 6 (section 3).

---

## 3. Home-screen names and player confusion

### 3a. What the games call it and what players understand

| Name | Games | Evidence players understand it | Tag |
|---|---|---|---|
| **Inbox** | FM24 | SI's own data: "Historically the screen that people spend the most time on in FM has been the Inbox" (S8), and "use of the 'Home' screen ... was limited, with most of your time spent in the Inbox" (S6). Eurogamer on FM26: "As for the Portal, it's basically your Inbox. And that's good! The Inbox worked absolutely fine" (S15). | SOURCED |
| **Home** | FM24 (secondary), Motorsport Manager, WWE MyGM | Guides use it without explanation (S26, S30). In FM24 it existed but was little used (S6). No measured comprehension data. | SOURCED (usage) / NOT FOUND (comprehension data) |
| **Portal** | FM26 | Players said they did not understand its purpose (quotes below). | SOURCED (complaints) |
| **Manager's Office** | OOTP | Manual: "the primary portal for all managers" (S32). No complaint data found. | SOURCED / NOT FOUND |
| **Main Screen / Office** | TEW2020 | Handbook: "On most days you will only be using the main screen and the office" (S35). | SOURCED |
| **Career Hub** | Undisputed, UFC 5 | Press guides use it as a plain term (S38, S39, S40). | SOURCED |

**Which name works without a tutorial?** No study measured this (NOT FOUND). The evidence points to **Home**, or to a name that says what the screen holds (Inbox, Office). An abstract coinage like "Portal" did badly: players said they did not understand it, and Eurogamer had to explain it as "basically your Inbox". JUDGEMENT. For FightCamp, **HOME** is the plain choice. Its first panel is literally titled `NEEDS YOU`, so the screen explains itself.

### 3b. Verbatim player and press evidence (strongest first)

1. **Studio admission.** "Reflecting on FM26 overall, we understand the changes we made to the User Interface weren't well received by everyone. It's also clear many were frustrated by the changes to navigation and the loss of immersion compared to previous editions." Miles Jacobson, SI, **11 May 2026**, https://www.footballmanager.com/news/return-international-management-and-review-fm26 (S9, DEV). SOURCED.
2. **Portal purpose.** "I genuinely don't understand the purpose of the Portal. It's supposed to be a quick overview, but I'd much rather navigate directly to News, Fixtures, or Inbox. I never find myself actually using it." r/footballmanagergames, "My take on fm26", https://www.reddit.com/r/footballmanagergames/comments/1of0iyb/my_take_on_fm26/ (S21, COMMUNITY). I confirmed the quote text in a search-engine extract of the thread. Reddit blocked a direct page fetch. Date: **24 Oct 2025** is a PROXY. It comes from Grok and fits the post-ID order and the FM26 beta window, but I did not read it on the page.
3. **Breadth vs depth.** "On FM24, the sidebar holds about 20 first-level options ... FM26 has 6 top-level menus, which means you will need a second level ... But menus disappear after you click an option. If you select the wrong one, you have to repeat. And you can't see all of them at once." r/footballmanagergames, "RIP Left Tab", https://www.reddit.com/r/footballmanagergames/comments/1ogl91n/rip_left_tab/ (S23, COMMUNITY). Text confirmed in a search extract. Date NOT FOUND on page. PROXY late Oct 2025 by post-ID order.
4. **New players vs veterans (mixed).** "If you had a player that was completely new to any sort of management game and gave them FM24 and FM26, I guarantee they'd understand the FM24 UI much sooner." Another reply in the same thread says the opposite: "I think for new players, this UI will be far easier to navigate than the old one would have been." r/footballmanagergames, "The current UI is indefensible", https://www.reddit.com/r/footballmanagergames/comments/1oekgsv/the_current_ui_is_indefensible/ (S22, COMMUNITY). Date PROXY 24 Oct 2025 (Grok, ID order).
5. **More clicks.** "You have to click a lot more to get the info you need ... Everything is separated into smaller widgets, when everything could have been on one screen like before." Steam user Frifonz, quoted by PC Gamer, **5 Nov 2025**. The same article records FM26's Steam rating at "a mere 23% positive" within 24 hours of release. It also quotes a newcomer: "As a newbie FM player I like the new UI, tutorial + FMPedia. It's easy to get into, not confusing unlike the previous game." https://www.pcgamer.com/games/sim/football-manager-26-launches-straight-into-a-relegation-battle-as-steam-reviews-plummet-to-mostly-negative-been-playing-since-1993-and-this-is-the-worst-one/ (S18, PRESS). SOURCED.
6. **Steam reviews that mention the Portal** (S25, COMMUNITY; dates are the review creation dates in UTC from Steam's public review API):
   - "Ridiculous Portal page which is mostly irrelevant and sluggish to go through messages." **2025-11-23**, https://steamcommunity.com/profiles/76561198114993443/recommended/3551340/
   - "The portal - awful, unusable and even the most basic of elements like reading the messages in date order are not possible." **2025-11-13**, https://steamcommunity.com/profiles/76561198051938806/recommended/3551340/
   - "The new portal layout is awful. there's so much navigating to just do basic stuff like looking at a team or finding your staff etc.. the old layout was much more simpler and easier to use." **2025-11-15**, https://steamcommunity.com/profiles/76561198003128605/recommended/3551340/
   - "A home portal is a cool sounding concept, yet due to largely irrelevant things appearing on it, you either have a choice to massively slow down the game yourself ..." **2026-02-01**, https://steamcommunity.com/profiles/76561198303430874/recommended/3551340/
   - "There is no ability to customise what is on your portal to shape your story like we used to have." **2025-11-04**, https://steamcommunity.com/profiles/76561198002276739/recommended/3551340/
   - COUNT: of 7,113 English FM26 reviews I pulled from the API (last 365 days, "all" and "recent" orderings, de-duplicated), **25 mention "portal"**. This is a small share. The Portal complaints are real but a minority of review text. COUNT/PROXY (the sample is not every review).
7. **Hidden must-reply items.** "Must-reply not-emails aren't highlighted in red in the queue anymore, making it harder to skip to them directly to resolve whatever needs sorting before you can mash Continue once more." Eurogamer preview, **16 Oct 2025**, https://www.eurogamer.net/brace-yourselves-football-manager-fans-ive-played-a-day-of-fm26-and-its-going-to-take-a-lot-of-getting-used-to (S15, PRESS). SOURCED.
8. **Home screen overload.** "When I first loaded the game up, I felt like it was simultaneously showing me more information than I could actually process, and surfacing the wrong information while hiding the things I actually wanted to see." Rock Paper Shotgun, "227 hours later...", https://www.rockpapershotgun.com/227-hours-later-football-manager-26-is-both-broken-and-begrudgingly-brilliant (S17, PRESS). Date NOT FOUND on the extract.
9. **Moving Continue.** "Its tutorials made me chase a 'continue' button darting around the screen like I'm playing Whac-A-Mole." Image caption: "Do I press Continue or Next? Why are there so many arrows?" This Week in Video Games, Francisco Dominguez, https://thisweekinvideogames.com/feature/when-user-experience-ux-goes-wrong-football-manager-26-civilization-7/ (S20, PRESS). Date not shown on the fetched page. Grok gives 14 Nov 2025 (PROXY).
10. **Studio intent (context).** "We may now have too many ways to navigate!" and "We previously had one way to navigate in game and it didn't really work properly. Far, far, far too many button clicks, things far too hidden away." Miles Jacobson to Forbes, **16 Oct 2025**, https://www.forbes.com/sites/barrycollins/2025/10/16/football-manager-26-revamped-for-the-tiktok-generation/ (S19, PRESS). SOURCED.
11. **Old Inbox overload (FM24 and earlier).** An FM26 Steam review (2026-07-11, S25): "The most basic FM info displayer is probably the INBOX. It does not display the messages in a format that allows you to ..." (text cut in my extract). Grok's FM24 inbox-overload Reddit quotes ("60-150 messages a day", "bombed with 40 random, mostly unnecessary messages") could not be opened. They stay in Appendix A.

**What FightCamp should take from this (JUDGEMENT):**
- Do not rename a hub to something abstract.
- Keep must-answer items loud.
- Keep CONTINUE fixed in one place.
- Keep sub-screens one visible click away.
- Keep HOME short. It is a to-do list plus the next event, not a dashboard of everything.

---

## 4. Proposed FightCamp IA

### 4a. Title screen (exact labels, JUDGEMENT)

| Order | Label | Behaviour | Why |
|---|---|---|---|
| 1 | `RESUME CAREER` | Only shown when a save exists. A sub-line reads `<Gym name> · <in-game date>`. It loads the most recent save. | Returning players get a one-click path back in. I avoid the word "Continue" here so it never means two things (the in-game CONTINUE advances time). The OOTP and FM start screens separate new and load (S11, S34). |
| 2 | `NEW CAREER` | Opens the 3-step creation (country, city, gym). The last step has one toggle: `Guided first month (recommended)`, on by default (J52). | Keeps today's creation flow. The tutorial choice is made once, at the start (J52). |
| 3 | `LOAD CAREER` | Opens the list of saves. | Plain verb plus noun (S2, guideline 7). |
| 4 | `SETTINGS` | Audio, display, controls, text size. | Same label as today and as OOTP (S34). |
| 5 | `QUIT` | Exits the game. | Standard. |

This replaces today's `NEW CAREER / LOAD / SETTINGS`. `LOAD` becomes `LOAD CAREER`, and `RESUME CAREER` and `QUIT` are added.

### 4b. HOME (replaces THE DAY)

**Name:** `HOME`. The screen header reads `HOME · <Gym name> · <Day, date>`, so the date is shown as information, not as a place. JUDGEMENT.

| Panel (top to bottom / left to right) | Contents | Rule | Tag |
|---|---|---|---|
| `NEEDS YOU` | Up to 5 rows. Each row has a verb, what it is about and a deadline, for example "Answer bout offer · Jay Cole vs. R. Patel · expires Thu", "Set weight plan · Cole is 2.1 kg over", "Repair ring · $400". Blockers (items that stop CONTINUE) are red and at the top. Each row opens the exact screen it refers to. | Never more than 5 visible rows. The rest sit behind "+ n more". If empty, show "Nothing needs you. Press CONTINUE." | JUDGEMENT; model OOTP task list (S32), FM must-respond (S10, S15) |
| `NEXT UP` | The next dated event, with its countdown and one action button, for example "Weigh-in · Sat 14 Mar · 3 days" plus the existing gold `ENTER FIGHT WEEK` (FLOW_PASS3) when a fight week is present. | Always a date and a label. Never refer to a date without showing it (the WCBM2 complaint, S41). | JUDGEMENT |
| `YOUR FIGHTERS` | One line per active fighter: name, weight vs. target, condition, injury flag, next bout date. Click → the fighter's page in FIGHTERS. | Max 6 lines, then "View all". | JUDGEMENT |
| `MONEY THIS WEEK` | Cash, and money in / out this week, with the next bill due. Click → MONEY. | One line plus a small bar. | JUDGEMENT |
| `NEWS & MAIL` | Messages that do not need action, and results from other gyms. | Collapsed by default. Items that need action are promoted to `NEEDS YOU` and never live only here. | JUDGEMENT; avoids FM inbox overload (Appendix A leads) |

### 4c. Top-level areas (left rail, exact labels)

| Rail order | Label | Player job | Tab row inside (visible on entry, click not hover) | Tag |
|---|---|---|---|---|
| 1 | `HOME` | Know what needs me | (single screen) | JUDGEMENT |
| 2 | `FIGHTERS` | Develop fighters | `Roster` · `Training` · `Fight Camps` · `Scouting` | JUDGEMENT |
| 3 | `FIGHTS` | Get them fights | `Offers` · `Calendar` · `Results` · `Rankings` | JUDGEMENT |
| 4 | `GYM` | Run the gym | `Facilities` · `Members` · `Staff` | JUDGEMENT |
| 5 | `MONEY` | Make money | `Overview` · `Income` · `Bills` · `Sponsors` | JUDGEMENT |
| (top bar) | gear icon | System | `Save`, `Load`, `Settings`, `Quit to title` | JUDGEMENT |

The green `CONTINUE` sits bottom right on every screen and never moves (P6).

**Rules:**
- Five areas, each named for a job (P1, P2).
- Tabs are always visible, one level only (P4).
- Every area opens on its most-used tab. The FM26 complaint was that "Squad" opened an "overview screen first instead of defaulting to the 'First Team' menu" (S24).
- The rail keeps text labels next to icons (S2, guideline 10).

**Why MONEY and not OFFICE?** "Office" is a place, and it does not say what is inside it. In OOTP and TEW it holds almost everything (S32, S36). "Money" is the job. JUDGEMENT. If the operator prefers the gym-owner fantasy, `OFFICE` is the acceptable alternative, but only if it contains nothing except money and contracts.

### 4d. Fold table: today's 8 rail items → the new IA

| Today's rail item | Goes to | What changes | Tag |
|---|---|---|---|
| **THE DAY** | `HOME` | Renamed. The day feed becomes the `NEEDS YOU` list and the `NEXT UP` card. The date moves into the header. Action chips (`OPEN` / `ANSWER`, FLOW_PASS3) stay on the rows. | JUDGEMENT |
| **GYM** | `GYM` › `Facilities`, `Members` | Keeps its name. Fighter-related content (if any) moves to FIGHTERS. The repair and expand golds (FLOW_PASS3) stay here. | JUDGEMENT |
| **STAFF** | `GYM` › `Staff` | Becomes a tab. Staff are part of running the gym (Undisputed puts coach, cutman and manager under "My Team", S40). | JUDGEMENT |
| **TRAINING** | `FIGHTERS` › `Training`, `Fight Camps` | Becomes two tabs. The camp gold `OPEN THE CAMP` (FLOW_PASS3) stays on `Fight Camps`. | JUDGEMENT |
| **SCHEDULE** | `FIGHTS` › `Calendar` (+ `Offers`) | Renamed Calendar (FM24 "Schedule", OOTP "Scores and Schedule", S13, S34). Offers get their own tab because answering them is the main weekly job. Golds `BOOK SELECTED` / `CONFIRM THE MATCH` etc. (FLOW_PASS3) stay. | JUDGEMENT |
| **SCOUTING** | `FIGHTERS` › `Scouting` (talent). Opponent reports go on the bout page in `FIGHTS`. | Becomes a tab. I did not check the code to see which kind of scouting today's screen does (section 7). | JUDGEMENT |
| **RANKINGS** | `FIGHTS` › `Rankings` | Becomes a tab. Rankings answer "who can we fight / where do we stand". | JUDGEMENT |
| **OFFICE** | `MONEY` (finances, sponsors, bills). Mail → `HOME` › `NEWS & MAIL`. Save/settings → gear menu. | Split up by job. The word "Office" leaves the rail. | JUDGEMENT |

Result: 8 rail items become 5. Nothing is deleted. Every old screen is at most 2 clicks from anywhere (rail + tab). JUDGEMENT.

### 4e. Time control: label and behaviour

**Why THE DAY confuses (JUDGEMENT on SOURCED principles):**
1. **It names a unit of time, not a place or a job.** Every other rail item is a place or a job (GYM, STAFF, TRAINING). "The day" reads like a status or a heading, not somewhere to go. This breaks NN/g's rule to avoid "abstract high-level categorization" in menu labels (S2).
2. **It duplicates CONTINUE.** Two things on screen are about time: a rail item called THE DAY and a green button that advances one day. A new player cannot tell whether THE DAY is where you "do" the day, or whether CONTINUE "is" the day.
3. **There is no genre precedent.** None of the 11 surveyed games uses a time word for its hub (section 2c). Players bring expectations from FM, OOTP and WWE MyGM, which say Inbox, Home, Office or Portal. The rejected coinage (Portal) shows what happens when a hub name must be learned.
4. **It hides the real question.** What the player needs from that screen is "what needs me, and what happens next". HOME with `NEEDS YOU` and `NEXT UP` says that directly.

**The control (JUDGEMENT; patterns SOURCED as cited):**

| State | Label on the button | Sub-line | What a click does | Precedent |
|---|---|---|---|---|
| Normal | `CONTINUE` | "to <Day date> · <next stop reason>", for example "to Thu 12 Mar · weigh-in" | Advances day by day (the calendar visibly ticks) and stops automatically at the next stop reason (list below). One click can cover several quiet days. | OOTP auto-play "a set number of days unless it reaches a game to play" (S33); MM continue stops at a deadline (S26) |
| Blocked | `NEEDS YOU (n)` (red outline) | "Answer before time can move" | Opens the first blocker. Time does not move. | FM24 label change (S10); MM "can't continue ... until you respond" (S26) |
| Fight day | `GO TO FIGHT NIGHT` | "<Fighter> vs. <Opponent> · <venue>" | Opens fight night. | JUDGEMENT (WWE show-as-tick, S30; FM Mobile "Go To Match" is only a Grok lead, Appendix A) |
| Guided month (J52) | `CONTINUE` | Coach hint line, for example "Next: weigh-in in 2 days" | Same as normal. The tutorial never moves the button (TWIV Whac-A-Mole complaint, S20). | JUDGEMENT |

**Stop reasons (default):**
- a blocker appears (a bout offer about to expire, an injury decision, a contract, a failed-weight warning)
- a camp starts, reaches its mid-point check-in, or ends
- weigh-in day
- fight day
- first of the month (bills and membership income)
- a staff member quits
- "Stop every day" is switched on in SETTINGS (for players who want day-by-day control, like OOTP Game Flow, S33)

Keyboard: `Space` = CONTINUE (FM24 default, S13).

### 4f. Click path: boot → first bout, counted (PROXY; clicks are mouse clicks or key presses on buttons; typing a gym name counts as 1)

**Quick path (guided month off, first launch, no save):**

| # | Screen | Click | Running total |
|---|---|---|---|
| 1 | Title | `NEW CAREER` | 1 |
| 2–3 | Creation 1/3: Country | pick England · `NEXT` | 3 |
| 4–5 | Creation 2/3: City | pick city · `NEXT` | 5 |
| 6–8 | Creation 3/3: Gym | accept default name or type one (1) · leave `Guided first month` off (1) · `START CAREER` (1) | 8 |
| 9 | HOME | `NEEDS YOU` row "Answer bout offer" | 9 |
| 10–11 | FIGHTS › Offers | select offer · `CONFIRM THE MATCH` | 11 |
| 12 | HOME | `NEEDS YOU` row "Set up fight camp" | 12 |
| 13–14 | FIGHTERS › Fight Camps | pick camp template · `START CAMP` | 14 |
| 15–17 | any | `CONTINUE` × 3 (stops: camp mid-point check-in, camp end, weigh-in day) | 17 |
| 18–19 | Weigh-in | `WEIGH IN` · `CONFIRM` | 19 |
| 20 | any | `GO TO FIGHT NIGHT` | 20 |
| 21 | Fight night | `START BOUT` | **21** |

**Guided path (J52 month on):** add about 3 tutorial acknowledgement clicks (the J52 steps are mostly shown on the screens the player already visits). That gives about **24 clicks**. The in-game span is about 4 weeks, ending in the England Boxing club bout (J52, J53). PROXY.

**Comparison (PROXY):**
- FM24: 4 clicks from the start screen to the hub (S11), plus a first-launch manager profile and an unknown number of Continue presses and inductions before the first friendly (NOT FOUND). Eurogamer on FM26: "It took me a long time just to get through all my inductions ... before I could even set foot on the touchline for my first match" (S15).
- WWE MyGM: at least 9 draft rounds before booking (S30).
- OOTP: about 5–10 clicks with "Show & play today's game" on (S33).

FightCamp's ~21 is in line with the genre for a first competitive event. No surveyed game publishes an official count (NOT FOUND).

### 4g. Recommendation tags at a glance

| Recommendation | Tag |
|---|---|
| Rename THE DAY → HOME | JUDGEMENT (on SOURCED survey and S2) |
| 5 areas: HOME, FIGHTERS, FIGHTS, GYM, MONEY | JUDGEMENT (on S1, S3, S4, S5) |
| Tabs visible, click-activated, max 2 levels | SOURCED principle (S2) → JUDGEMENT application |
| HOME = NEEDS YOU task list + NEXT UP | JUDGEMENT (model SOURCED S32; S6, S8) |
| CONTINUE runs to next stop; relabels when blocked | SOURCED pattern (S10, S26, S33) → JUDGEMENT wording |
| GO TO FIGHT NIGHT on fight day | JUDGEMENT |
| Title: RESUME CAREER / NEW CAREER / LOAD CAREER / SETTINGS / QUIT | JUDGEMENT (pattern S11, S34) |
| Boot → first bout ≈ 21 clicks (≈ 24 guided) | PROXY |

---

## 5. Sources (all read 2026-09-25)

| ID | Title | Date | Type | URL |
|---|---|---|---|---|
| S1 | NN/g, "Flat vs. Deep Website Hierarchies" (K. Whitenton) | 2013-11-10 | STANDARD | https://www.nngroup.com/articles/flat-vs-deep-hierarchy/ |
| S2 | NN/g, "Menu-Design Checklist: 17 UX Guidelines" (P. Laubheimer) | 2024-06-07 | STANDARD | https://www.nngroup.com/articles/menu-design/ |
| S3 | NN/g, "Task Analysis: Support Users in Achieving Their Goals" (M. Rosala) | 2020-09-20 | STANDARD | https://www.nngroup.com/articles/task-analysis/ |
| S4 | Laws of UX, "Hick's Law" | undated | STANDARD | https://lawsofux.com/hicks-law/ |
| S5 | Laws of UX, "Miller's Law" | undated | STANDARD | https://lawsofux.com/millers-law/ |
| S6 | SI, "FM26's Reimagined User Interface" | NOT FOUND on page | DEV | https://www.footballmanager.com/fm26/features/fm26s-reimagined-user-interface |
| S7 | SI, "Mastering the FM26 UI" | NOT FOUND on page | DEV | https://www.footballmanager.com/the-dugout/mastering-fm26-ui |
| S8 | SI, "Development Update: Football Manager 25" (M. Jacobson) | 2024-06-27 | DEV | https://www.footballmanager.com/news/development-update-football-manager-25 |
| S9 | SI, "The return of International Management and a review of FM26" (M. Jacobson) | 2026-05-11 | DEV | https://www.footballmanager.com/news/return-international-management-and-review-fm26 |
| S10 | SI manual FM24, "The User Interface" (Wayback snapshot 2024-09-09; live page Cloudflare-blocked) | manual 2023 | DEV | http://web.archive.org/web/20240909222241/https://community.sports-interactive.com/sigames-manual/football-manager-2024/the-user-interface-r4951/ |
| S11 | SI manual FM24, "Quick Start Guide" (Wayback 2024-08-12) | manual 2023 | DEV | http://web.archive.org/web/20240812005921/https://community.sports-interactive.com/sigames-manual/football-manager-2024/quick-start-guide-r4950/ |
| S12 | SI manual FM24, chapter index incl. "Your Inbox, Your Home", "Data Hub" (from S10/S11 page navigation) and "Managerial Home and Profile" (Wayback 2024-08-10) | manual 2023 | DEV | http://web.archive.org/web/20240810142414/https://community.sports-interactive.com/sigames-manual/football-manager-2024/football-manager%E2%84%A2-2024-managerial-home-and-profile-r4955/ |
| S13 | Magic Game World, "Controls for Football Manager 2024" (shortcut list) | page shows "January 1, 2023" (implausible for FM24) | COMMUNITY | https://www.magicgameworld.com/controls-for-football-manager-2024/ |
| S14 | Operation Sports, "How to Better Navigate the New UI in Football Manager 26" (R. Preston) | 2025-11-06 | PRESS | https://www.operationsports.com/how-to-better-navigate-the-new-ui-in-football-manager-26/ |
| S15 | Eurogamer, "Brace yourselves, Football Manager fans..." (C. Tapsell) | 2025-10-16 | PRESS | https://www.eurogamer.net/brace-yourselves-football-manager-fans-ive-played-a-day-of-fm26-and-its-going-to-take-a-lot-of-getting-used-to |
| S16 | PC Gamer, "Football Manager 26 review" (P. Iwaniuk), search extract only | NOT FOUND | PRESS | https://www.pcgamer.com/games/sports/football-manager-26-review/ |
| S17 | Rock Paper Shotgun, "227 hours later, Football Manager 26 is both broken and, begrudgingly, brilliant", search extract | NOT FOUND | PRESS | https://www.rockpapershotgun.com/227-hours-later-football-manager-26-is-both-broken-and-begrudgingly-brilliant |
| S18 | PC Gamer, "Football Manager 26 launches straight into a relegation battle..." (R. Lane) | 2025-11-05 | PRESS | https://www.pcgamer.com/games/sim/football-manager-26-launches-straight-into-a-relegation-battle-as-steam-reviews-plummet-to-mostly-negative-been-playing-since-1993-and-this-is-the-worst-one/ |
| S19 | Forbes, "'Football Manager 26' Revamped For The TikTok Generation" (B. Collins) | 2025-10-16 | PRESS | https://www.forbes.com/sites/barrycollins/2025/10/16/football-manager-26-revamped-for-the-tiktok-generation/ |
| S20 | This Week in Video Games, "Football Manager 26 and When User Experience Goes Wrong" (F. Dominguez) | NOT FOUND on page (Grok: 2025-11-14) | PRESS | https://thisweekinvideogames.com/feature/when-user-experience-ux-goes-wrong-football-manager-26-civilization-7/ |
| S21 | Reddit r/footballmanagergames, "My take on fm26" (quote via search extract; direct fetch blocked) | PROXY 2025-10-24 | COMMUNITY | https://www.reddit.com/r/footballmanagergames/comments/1of0iyb/my_take_on_fm26/ |
| S22 | Reddit, "The current UI is indefensible" (search extract) | PROXY 2025-10-24 | COMMUNITY | https://www.reddit.com/r/footballmanagergames/comments/1oekgsv/the_current_ui_is_indefensible/ |
| S23 | Reddit, "RIP Left Tab" (search extract) | PROXY late Oct 2025 | COMMUNITY | https://www.reddit.com/r/footballmanagergames/comments/1ogl91n/rip_left_tab/ |
| S24 | Reddit, "Genuine question about UI to beta players" (search extract) | PROXY late Oct 2025 | COMMUNITY | https://www.reddit.com/r/footballmanagergames/comments/1oi4hcu/genuine_question_about_ui_to_beta_players/ |
| S25 | Steam user reviews, Football Manager 26 (app 3551340), via public review API; individual review URLs in §3b | 2025-11-04 to 2026-09-01 | COMMUNITY / COUNT | https://store.steampowered.com/appreviews/3551340?json=1 |
| S26 | Steam guide, "General guide on running a race team" (SonicsLV, Motorsport Manager) | 2016-11-18, upd. 2017-07-19 | COMMUNITY | https://steamcommunity.com/sharedfiles/filedetails/?id=801128239 |
| S27 | Steam guide, "A Beginners Guide" (professorchaos, Motorsport Manager) | 2017-02-10, upd. 2017-02-24 | COMMUNITY | https://steamcommunity.com/sharedfiles/filedetails/?id=860826888 |
| S28 | The SmackDown Hotel, "WWE 2K22 MyGM Mode Guide" | NOT FOUND | COMMUNITY | https://www.thesmackdownhotel.com/news/wwe2k22/wwe-2k22-mygm-mode-guide-complete-tutorial-tips-tricks |
| S29 | The SmackDown Hotel, "WWE 2K24 MyGM Mode Full Guide" | NOT FOUND on extract (Grok: 2024-03-01) | COMMUNITY | https://www.thesmackdownhotel.com/news/wwe2k24/wwe-2k24-mygm-mode-full-guide-all-features-tips-tricks |
| S30 | The SmackDown Hotel, "WWE 2K26 MyGM Mode Full Guide" | NOT FOUND on extract (Grok: 2026-02-17) | COMMUNITY | https://www.thesmackdownhotel.com/news/wwe2k26/wwe-2k26-mygm-mode-full-guide-all-features-tips-tricks |
| S31 | 2K, "WWE 2K25 Ringside Report - MyGM" | NOT FOUND on page | DEV | https://wwe.2k.com/2k25/ringside-report/mygm/ |
| S32 | OOTP 21 manual, "Manager's Office" | manual (OOTP 21) | DEV | https://manuals.ootpdevelopments.com/index.php?man=ootp21&page=help_manager_home_page.home |
| S33 | OOTP 21 manual, "Game Flow" | manual (OOTP 21) | DEV | https://manuals.ootpdevelopments.com/index.php?man=ootp21&page=game_flow |
| S34 | OOTP 18 and 21 manuals, "Screen Descriptions by Menu" (table of contents) | manuals | DEV | https://manuals.ootpdevelopments.com/index.php?man=ootp18&page=toc_00005 ; https://manuals.ootpdevelopments.com/index.php?man=ootp21&page=toc_00005 |
| S35 | TEW2020 Wiki, "Handbook" (the game's handbook reproduced "With permission from Adam Ryland") | NOT FOUND | DEV (hosted COMMUNITY) | https://tew2020.fandom.com/wiki/Handbook |
| S36 | TEW2020 Wiki, "Your Office" | NOT FOUND | COMMUNITY | https://tew2020.fandom.com/wiki/Your_Office |
| S37 | EA, "UFC 5 game modes" | NOT FOUND on extract | DEV | https://www.ea.com/games/ufc/ufc-5/news/ufc-5-game-modes |
| S38 | GINX, UFC 5 career mode guide | NOT FOUND | PRESS | https://www.ginx.tv/en/career-mode |
| S39 | GINX, "Undisputed Career Mode Guide" (Patches Chance) | 2024-10-07 (last updated) | PRESS | https://www.ginx.tv/en/career-guide |
| S40 | GameRant, "Undisputed: how to unlock best coaches, cutmen, managers" | NOT FOUND | PRESS | https://gamerant.com/undisputed-how-unlock-best-coaches-cutmen-managers/ |
| S41 | GameGrin, "World Championship Boxing Manager 2 review" | NOT FOUND on extract (Grok: 2023-01-27) | PRESS | https://www.gamegrin.com/reviews/world-championship-boxing-manager-2-review/ |
| S42 | Steam store, World Championship Boxing Manager 2 | release 2023-01-17 | DEV | https://store.steampowered.com/app/1903970/ |
| S43 | Steam store, Boxing Champs | release 2019-05-29 | DEV | https://store.steampowered.com/app/1073410/ |
| S44 | Steam store, Pro Wrestling Sim | release 2021-03-29 | DEV | https://store.steampowered.com/app/1157700/ |
| S45 | Steam store, Punch Club 2: Fast Forward | release 2023-07-20 | DEV | https://store.steampowered.com/app/1161590/ |
| S46 | My count of FM26 Steam reviews mentioning "portal" (25 of 7,113 English reviews retrieved) | 2026-09-25 | COUNT | derived from S25 |

---

## 6. NOT FOUND

- **Football Manager 26 PC title-screen labels.** Only Grok leads (Appendix A).
- **Football Manager 24 exact Continue replacement label** when a reply is required (the manual says the label "changes", but not to what). Also FM24 match-day button label.
- **FM24 official sidebar list** (labels are PROXY from a shortcut list, S13).
- **Motorsport Manager** English title-screen labels and the exact bottom-bar order. Continue label only from guide wording (PROXY).
- **WWE 2K23/2K25/2K26 game-level main-menu labels.**
- **Punch Club 2:** title labels, hub name, navigation, time control.
- **Boxing Champs:** all menu labels (the game is not a management sim).
- **WCBM2:** hub name, navigation labels, time-advance label.
- **UFC 5 / Undisputed:** exact main-menu labels, time-advance labels, full hub tab lists (only Undisputed's `My Team` confirmed).
- **Pro Wrestling Sim:** hub and navigation labels. **Promotion Tycoon:** no released game found by that name.
- **TEW2020:** exact tooltip text of the advance icon.
- **Any official boot-to-first-match click count** for any surveyed game.
- **Any study measuring which hub name players understand without a tutorial.**
- **A GDC talk on Football Manager UI.**
- **Publication dates** for S6, S7, S16, S17, S20, S28–S31, S35–S38, S40, S41 (not shown in the extracts I read).

---

## 7. Limits

- **No hands-on play.** I did not boot any surveyed game. All labels come from manuals, guides, press and store pages. All click counts are PROXY path counts, not timed tests.
- **Blocked sources.** Reddit refused direct fetches (login wall), so Reddit quotes rest on search-engine extracts of the threads, and their dates are PROXY. The SI community forum and manual are behind Cloudflare, so I used Wayback snapshots of the FM24 manual. fminside.net and the Grey Dog forum returned 403. Steam news posts are rendered by script and could not be read with curl. My Steam review sampling briefly triggered a Steam rate limit (HTTP 429) on one later request. It cleared, and no data was lost.
- **Version mixing.** OOTP evidence comes from the OOTP 18/21 manuals and is described as series-stable. I did not verify OOTP 25/26 screen by screen. WWE evidence spans 2K22 (S28), 2K24 (S29), 2K25 (S31) and 2K26 (S30).
- **FightCamp code not inspected.** The task forbade repo work. The fold table assumes today's SCOUTING, OFFICE and GYM screens hold what their names suggest. Before implementation, someone should check what each current screen actually contains, especially SCOUTING (talent or opponents) and OFFICE.
- **COUNT caveat.** "25 of 7,113" reviews mentioning "portal" comes from a de-duplicated API sample over 365 days in English only. It is not a full census.
- **Grok run.** One pass: `~/.grok/bin/grok --no-auto-update --reasoning-effort xhigh -m grok-4.6 --always-approve --prompt-file J54_GROK_PROMPT.txt`, with live web search on (not disabled). It started 18:26:20 and exited cleanly by 18:32:25 (UTC+3), about 6 minutes. It wrote 40,247 bytes to `grok_out.txt` and nothing to stderr. The prompt contained no unverified hints (it listed only the games and questions). Its output was used as leads only. The confirmed ones are cited to the real pages above. The rest are in Appendix A.
- **Prompt-injection check.** No fetched page or tool output tried to give me instructions. Grok's output described its own plan ("I'll research each game's menus..."), which is normal narration, not an instruction to me.

---

## Appendix A: Grok leads, unverified (not used as evidence anywhere above)

Each item is labelled **grok lead, unverified**. I could not open the cited page, or I did not attempt to within this pass.

1. FM26 PC start: `Quick Start` / `Advanced Setup` (SI Steam news 28 Oct 2025, https://store.steampowered.com/news/app/3551340/view/510721067535306045; page is script-rendered). YouTube and SI-forum mentions of "Start new career" / "Advanced setup career". grok lead, unverified.
2. FM26 Mobile Main Menu: `New Game`, `Load Other Game`, `Load Recent Game`, `Settings`, `About`, `View Match`, `Achievements`, `New World Cup Challenge` (SI manual r5243, Cloudflare-blocked, no Wayback copy). grok lead, unverified.
3. FM24 Mobile: "Continue Game" becomes "Go To Match". FM26 PC match-day state "Go To Match" (SI bug tracker, Nov 2025). grok lead, unverified.
4. FM24 Continue shows "Must Respond" when a reply is needed (search-engine synthesis only). grok lead, unverified.
5. FM26 "Continue button for legacy mode" under Accessibility (YouTube / SI bug tracker, Nov 2025). grok lead, unverified.
6. Reddit quotes, dates as Grok gave them:
   - "Too many instances of clicking 3 things to get to the one that you want." and "For some reason its under Portal." (1oee0sl, 23 Oct 2025)
   - "things that took a few clicks, now take 5-6 clicks or are simply gone." (1oh9o4e, 27 Oct 2025)
   - "Club site? What does that even mean? Wouldn't Club details work fine?" (1p0q8ov, 18 Nov 2025)
   - "I just cannot get used to the new UI..." (1qli8x7, 24 Jan 2026)
   
   All grok lead, unverified (Reddit blocked).
7. FM inbox overload quotes:
   - "60-150 messages a day" (1b1npeo, 27 Feb 2024)
   - "bombed with 40 random, mostly unnecessary messages" (1hyrbva, 11 Jan 2025)
   - "You can't enable scouting recommendations ... without being absolutely flooded" (1qllv8b, 24 Jan 2026)
   - "The inbox is genuinely terrible..." and "Since the first Football Manager, the inbox has been one of the weak points..." (1p6q543, 25 Nov 2025)
   
   All grok lead, unverified.
8. SI official feedback thread quote: "The portal doesn't actually show anything of use. It is just the FM24 home screen but nerfed..." (~30 Oct 2025, page 127). grok lead, unverified (Cloudflare).
9. Eurogamer interview quoted on the SI forum: the FM25-era top bar already had "portal, squad, recruitment, match day, club, and career", and playtesters "couldn't find things". grok lead, unverified.
10. Unite 2024 talk "Tackling UI challenges in Football Manager 25" (https://www.youtube.com/watch?v=im49swPfWIo). Seen as a search result, not watched. grok lead, unverified as to content.
11. Motorsport Manager: German handbook headings (Hauptmenü, Karriere und Einzelrennen, Herausforderungen, Workshop). YouTube lists of bottom tabs "home, player, mail, car, HQ, drivers, team, staff, scouting, finances, sponsors, standings, calendar, continue". grok lead, unverified.
12. WWE 2K24 game main menu (My Faction, Play, Universe, Showcase, My GM, Creation, Online, Options) from a YouTube walkthrough, and the 2K24 PS5 manual table of contents. grok lead, unverified.
13. Punch Club 2: patch 1.0.6 "Skip Beginning", "Ladders" main-menu button (GoNintendo, 25 Jul 2024). Dev blog, 24 May 2023: fight sign-up icon under the time display. Time is spent through activities, with no Continue. grok lead, unverified.
14. WCBM2: "Start My Own Gym" screenshot caption; Clinic and Lounge facilities; wiki daily routines "Rest Day" / "Fight Day". grok lead, unverified.
15. UFC 5: TrueAchievements "training camp hub". Exact label for weekly time advance not found by Grok either. grok lead, unverified.
16. Undisputed: official tutorial videos (18 Jun 2026); weekly camps "four weeks standard". grok lead, unverified.
17. Pro Wrestling Sim: YouTube "office screen ... home screen essentially"; `Start show`; booking tabs "Wrestlers, Teams, and stable" (Steam discussion 28 May 2025). grok lead, unverified.
18. TEW2020 AutoHotKey list: `Advance`, `Multi-Advance`, `Main Screen`, `Office`, `Companies`, `Workers`, `Training`, `Alliances`, `Broadcasters`, `Game World` (Grey Dog forum, 403 to me). TEW IX options "Fast Advance E-Mails", "Return To Office". grok lead, unverified.
19. OOTP 26: Nerd Reactor walkthrough, `New Game` → `New Standard Game`; `YOUR NAME` header → Manager's Office. OOTP 27 video: "three home buttons", "configure continue button". grok lead, unverified.
20. NN/g items: "No More Pogo Sticking" (2015); UX quiz definition of a navigation hub; Hick's-law long-menus video (article 404). grok lead, unverified.
21. TheGamer FM24 tip "the messages with red highlights are always the more important ones" was seen only in a search extract. grok-adjacent, unverified; mentioned in P7 as context only.

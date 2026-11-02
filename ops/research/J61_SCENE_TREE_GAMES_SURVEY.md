# J61 — How shipped management games lay out their scene trees (evidence for the FightCamp review)

Owner: John Research (Grok bot, web reading only). For: Koxar / Claude. Date: 2026-10-03 (Asia/Nicosia, UTC+3).
Research only. No code, no .gd/.tscn edits, HANDOFF.md untouched. The Grok CLI was not used (balance exhausted). Nothing was delivered to Beast.

**Tags.** SOURCED = I read the page today (URL given). PROXY = a search extract, an older edition, a neighbouring game or a mirror. UNKNOWN = no evidence found. JUDGEMENT = my design call.
**Source types.** [OFFICIAL] manual or dev blog · [WIKI] community wiki · [STORE] Steam store text · [NEWS] Steam patch notes · [REVIEW] Steam review · [GUIDE] Steam guide · [PRESS] press or fan site · [EXTRACT] search-result extract only · [INTERNAL] our own files. Source IDs (S1…) are in the Appendix.
**Counts.** Steam review counts are English-only, read from the Steam review API on 2026-10-03. A "ways to reach a screen" count comes from documentation, not from playing. I played no game and read no screenshot or video.

---

## 0. Answer first

1. **Many doors to one screen is normal in the games I read; the same screen under different names is what confuses.** Football Manager 24 documents at least 4 routes to the fixtures list (S1, S3, S4, S5). Two Point Hospital has 4 routes into one staff-training screen (S12). Both use one name and one destination for every route. FightCamp's Schedule has 3 doors under 3 names ("Fight calendar", "Fight-week board", "Schedule") and Staff has 5 doors from 3 places (FINANCE area, Mat room, Staff room). That is the real fault (JUDGEMENT, supported by S1, S3, S4, S5, S12, S30).
2. **Rule I propose:** a leaf screen gets at most ONE object in a room (its "place") plus ONE index tile in an area (a shortcut), both with the same name and icon. Other objects in the room must do a different job. This takes Schedule from 3 doors to 2 and Staff from 5 to 2 (counted by script over the 53-entry input map, section 3.4).
3. **Training: no surveyed game shows an animated preview of a move before you commit to training it** (section 4). The nearest real thing is WWE 2K25's move-set screen: highlight a move and wrestlers demonstrate it (S28). That is a gap and a chance. It is "not found", not "does not exist".
4. **Best model to copy:** Two Point Hospital's training room. Click the lectern (the object), get one course screen with qualification, trainer, trainees and an estimated duration (S11, S12). That is the shape of TRAIN1.
5. **Open problems for the operator or Claude** are in section 6.3 (Film room has no door; the Staff room and Physio are tier 4 but are needed at tier 1; the Mat room has no screen of its own; I could not find the "Schedule in the staff room" object the operator mentioned).

Prior research cited, not redone: `TRAINING_LOOP_DESIGN.md` (door rule, gain preview), `G112_TRAINING_LOOP.md` (13 sim games), `FLOW_PASS2_ROUTE_WORDS.md` (31 routes, dated 2026-09-22), `S148_SCHEDULE_TUTORIAL_DESIGN.md` (approved schedule, ladder, tutorial), `topics/gym_rooms_art.md` (six rooms), J59 (`/workspace/j59/J59_STEAM_SURVEY.md`: Corner King, AYW, Ludus, Boxing School, Boxing World Simulator). All [INTERNAL] (S30–S36).

---

## 1. Eleven games: hub, ways to one screen, how training is chosen

**How I chose.** The brief named Two Point Hospital, Football Manager, Motorsport Manager, Punch Club, Game Dev Tycoon, boxing/wrestling managers and Kairosoft. I took one game for each hub shape: top-bar or sidebar shell (FM), world with a control panel (Two Point Hospital), bottom tabs (Motorsport Manager), map of places (Punch Club), one office scene (Game Dev Tycoon), boxing/wrestling/gladiator managers (Corner King, AYW, Ludus, Boxing Gym Story), and two build-first sims with a training room or timetable (Prison Architect, Project Hospital). Not covered because I had no usable source: Rebound basketball manager, Gladihoppers, WWE MyRISE (only the move-set editor, section 4).

### Steam score lines (English reviews, 2026-10-03)

| Game | Steam app | Score | English reviews (positive / negative) |
|---|---|---|---|
| Football Manager 26 | 3551340 | Mostly Negative | 15,355 (5,827 / 9,528) |
| Two Point Hospital | 535930 | Very Positive | 16,579 (15,286 / 1,293) |
| Motorsport Manager | 415200 | Very Positive | 6,228 (5,652 / 576) |
| Punch Club | 394310 | Mostly Positive | 5,182 (3,665 / 1,517) |
| Punch Club 2: Fast Forward | 1161590 | Very Positive | 1,456 (1,180 / 276) |
| Game Dev Tycoon | 239820 | Very Positive | 25,283 (23,898 / 1,385) |
| Corner King: Boxing Tycoon | 4259990 | Positive | 28 (25 / 3). Small sample |
| All Your Wrestling Pro Manager | 4979160 | Positive | 26 (23 / 3). Small sample |
| Ludus Magnatus | 4088670 | Very Positive | 206 (165 / 41) |
| Boxing Gym Story (Kairosoft) | 1947950 | Mixed (English); Mostly Positive in all languages, 101 reviews per J59 | 23 (13 / 10). Small sample |
| Prison Architect | 233450 | Very Positive | 42,139 (36,422 / 5,717) |
| Project Hospital | 868360 | Very Positive | 3,789 (3,316 / 473) |

All from the Steam review API, [STORE] S37. Links to each store page: `https://store.steampowered.com/app/<app id>/`.

### 1.1 "Ways to reach one screen" — summary of what I could count

| Game | Screen | Ways documented | Names the same everywhere? | Tag |
|---|---|---|---|---|
| FM24 | Fixtures / schedule | **at least 4**: Home "Team Fixtures" panel; click the date (Calendar popup); F10 and Shift+C hotkeys; Competition > Fixtures and Results. A 5th, the sidebar, is implied | Yes, "Schedule / Fixtures / Calendar" | SOURCED S1, S3, S4; PROXY S5 |
| FM26 | Fixtures | **4**: top-bar Matches menu, Portal tile + calendar snapshot, Search, Bookmarks | Yes | SOURCED S6, S7; PROXY S8 |
| Two Point Hospital | Start a staff training course | **4**: click the lectern; drop a staff member in the room; Inspector; staff email | Yes, "Training" | SOURCED S11 |
| Motorsport Manager | Standings | **2** (bottom tab, top dropdown), plus Home stat bars that link to pages | Yes | SOURCED S13 |
| Punch Club 2 | Raise a stat | **3 kinds of place**: home gear, Silver's Gym machines, jobs | Yes, one stat list | SOURCED S17 |
| Corner King | Open a fighter's profile | Many (names in rankings, finances, event cards). Exact count UNKNOWN | Yes, "click the name" | SOURCED S19 (patch notes) |
| Game Dev Tycoon, Ludus, AYW, Boxing Gym Story, Prison Architect, Project Hospital | any | UNKNOWN (no source lists doors) | — | UNKNOWN |
| **FightCamp today** | Schedule | **3** (FIGHTS tile, Office "Fight calendar", Locker "Fight-week board") | **No: 3 names** | INTERNAL S30 |
| FightCamp today | Staff | **5** (FINANCE tile, Mat coach, 3 objects in Staff room) | **No: 5 names** | INTERNAL S30 |

I found no surveyed game that documents five different objects in one room all opening one screen (NOT FOUND, not proof none exists).

### 1.2 Football Manager 24 → 26 (Sports Interactive / SEGA)
- **Hub (FM24).** [OFFICIAL] The Side Bar is "the primary method to navigate all the different areas within your club"; it can be reordered, some entries removed; tabs sit inside each screen; clicking the date opens the Calendar; the Continue button turns into "Must Respond" when an inbox item needs an answer (S1). The Inbox is called the main hub (S2). SOURCED.
- **Hub (FM26).** [OFFICIAL] The sidebar is replaced by a top navigation bar of six categories with sub-menus. Home and Inbox are merged into a **Portal**; SI says Home use was limited, "most of your time spent in the Inbox". The Portal has filters (All / New / Tasks / Unread), an Advice dropdown, upcoming fixtures and a two-week Calendar snapshot. Bookmarks: 24 possible entries, 6 by default, up to 12 on a high-resolution screen. Search now finds screens and guides. Content blocks changed from tiles to cards. Design principles named: Efficiency, Familiarity, Predictability (S6, S7). SOURCED. (FM Scout lists eight sections, S8 [PRESS]; conflicts with the official "six"; I used the official count.)
- **Ways to fixtures.** FM24: at least 4 (table 1.1). FM26: 4. SOURCED/PROXY as tagged. Every route says Schedule/Fixtures/Calendar.
- **Training.** A team schedule with units, plus individual training chosen from a player's Development tab: groups Rehab, Set Pieces, Attributes (Quickness … Aerial), Goalkeeping; intensity Normal, Half or Double (S9 [EXTRACT] of the FM24 training manual, which Cloudflare blocked; S10 FM Mobile manual [OFFICIAL] says roles carry descriptions). PROXY. Preview: text lists and arrows, no animation (G112, INTERNAL S31).
- **Players say** (FM26 reviews, 2026-10-03):
  - "basic tasks take more clicks than they should" (up 70, not recommended) [REVIEW S38]
  - "Simple things take more clicks" (up 45) [REVIEW S39]
  - "very unpleasant and hard to navigate" (up 71) [REVIEW S40]
  - Mild: "navigation isn't always intuitive" (up 5, recommended) [REVIEW S41]
- **Copy:** Continue turns into a must-respond state (S1); Portal "Tasks" filter; Search for "where is X"; tutorials that can be re-run (S7).
- **Avoid:** moving the whole navigation model between editions. The official redesign drew the top complaint, "more clicks" (S38, S39).

### 1.3 Two Point Hospital (Two Point Studios / SEGA)
- **Hub.** [WIKI S11] County map of hospitals (locked and unlocked) leads to the Hospital View, which is the world. A persistent **Control Panel** has tabs: Menu (County Map, Options, Rooms, Items, Hire), Characters (Staff, Patients, Illnesses), Finance (Overview, Prices, Loans), Data View. An Information Panel shows Mail & Inbox, Money, Reputation, Hospital Level, Kudosh, Calendar. A Task Panel lists Objectives. The advisor is Albert Crank. SOURCED (S11 is the Interface page).
- **Ways to one screen.** The staff-training course screen starts **4 ways**: click the lectern, drop a staff member in the room, open it from the Inspector, or from a staff email (S12, S42 [WIKI]/[PRESS]). All say "Training". SOURCED.
- **Training.** Build a Training Room, then in the course screen pick the qualification, the trainer (own consultant or a paid guest trainer) and the trainees; an Estimated Duration is shown; trainees stop working meanwhile; trainee desks cap the class (S12, S42, S43 [PRESS] gives the guest cost, $10,000 plus $5,000 per student). SOURCED.
- **Players say:** "The gameplay is simple to pick up but has enough depth" (up 5, recommended) [REVIEW S44]. A navigation complaint in the English reviews I read: NOT FOUND (448 of 16,579 read).
- **Copy:** lectern → one course screen (what, who teaches, who learns, how long). Locked/unlocked map for tier-gated places. A persistent panel (our left rail).
- **Avoid:** training that silently takes the person off the job. In FightCamp a fighter in training must show what else is blocked (JUDGEMENT).

### 1.4 Motorsport Manager (Playsport Games)
- **Hub.** [GUIDE S13] Bottom tabs: Home, Player, Team, Mail, Finances, Standings, Calendar (plus Car and Staff screens). Home shows team stat bars against rivals; clicking a bar opens the matching page. Standings are also reachable from a dropdown at the top. Some mail items must be answered before Continue works. HQ is a set of buildings (Factory, Design Centre, Staff Centre, part buildings) that unlock capabilities. SOURCED.
- **Ways:** Standings 2 (tab, dropdown). SOURCED.
- **Training.** None is chosen. Drivers and staff grow automatically; hovering a stat bar shows the improvement rate; HQ buildings raise the rate; a stat point arrives at 100% progress (S13). The guide notes "no way to see which stat" has most potential left (S13). SOURCED.
- **Copy:** Home's rival-comparison bars that link to pages (a ladder card idea); buildings that visibly unlock a capability.
- **Avoid:** hidden growth with no way to see what to work on.

### 1.5 Punch Club and Punch Club 2: Fast Forward (Lazy Bear Games)
- **Hub.** [WIKI S14, S15] A city map is the hub: Home (sleep, eat, TV, exercise), Silver's Gym (pads, spar, fight league, machines), Mick's, Apu's and others; locked places are revealed by story. PC2: free walking takes time, the bus costs money [GUIDE S17]. A status screen with tabs holds stats, style and skill trees (S17). SOURCED.
- **Ways to raise a stat (PC2):** three kinds of place: home gear, gym machines, jobs (S17). PC1: home gear and gym machines train the same exercises and drain each other (S15 [WIKI]). SOURCED.
- **Training.** You pick the **machine at a place**. PC2's "modern" gym training shows duration and stamina/hunger cost before you start and cannot be interrupted; old-school gear is slower but reusable (S17). Skills: spend points in a skill tree; PC1's "Tactics Learner" adds numbers to skill text (S16 [WIKI]). The PC2 fight-prep screen shows the enemy's stats and skills (S17). SOURCED.
- **Players say:** PC1 "the compounding daily stat decay" (up 5, not recommended) [REVIEW S45]; PC2 describes a "grind loop" [REVIEW S46]. PC2 removed stat decay (S17).
- **Copy:** cost and time shown before the commit button (PC2 gym).
- **Avoid:** decay that undoes the last session (the G112 verdict, S31).

### 1.6 Game Dev Tycoon (Greenheart Games)
- **Hub.** One office scene. Beyond the store text, how the screens connect: UNKNOWN (S37).
- **Training.** [WIKI S18] Select an employee → Training menu → named course. Each course lists cost in research points and money, plus effect markers such as "+++ Design". Course tiers unlock with office size (caps 500 / 700 / 900 listed). Repeats give diminishing returns. SOURCED.
- **Players say:** "essentially just shifting a load of sliders repeatedly" (up 7, not recommended) [REVIEW S47].
- **Copy:** the course card shows cost and effect in one row; training tiers unlock when the building grows (our gym tiers).
- **Avoid:** a loop that feels like sliders. Give each choice a visible consequence.

### 1.7 Corner King: Boxing Tycoon (indie, early build, 2026)
- **Hub.** [NEWS S19] A sidebar with a Handbook entry (0.0.51, 2026-09-05). A gym page; **Facilities opens a 3D gym hall where each facility level adds visible equipment, and the camera glides to the upgrade** (0.0.50, 2026-08-28). The email centre is split into Inbox and News tabs; Space only reacts to Inbox (0.0.50). Organizations screen: ladder on the left, booked fights in a side column (0.0.45, via J59 INTERNAL S35). Fighter names open the fighter (0.0.45, 0.0.51). SOURCED.
- **Ways:** profile via linked names (many, count UNKNOWN).
- **Training.** Weekly plans by drag and drop; a one-focus-for-all button and a switch that sends fighters to recovery at a fatigue threshold (0.0.49, 2026-08-26); the coach's profile shows his training rating per block (power, speed, conditioning, defense, technique, recovery) before you hire (0.0.51); stat ceilings on the dashboard (0.0.50). SOURCED.
- **Players say:** "cluttered interface, unclear where is the hiring, firing, arranging, training" (up 11, not recommended) [REVIEW S48]; "a lot of poorly explained systems" (up 44, recommended) [REVIEW S49].
- **Copy:** the 3D facilities hall showing growth; fighter names as universal links; coach ratings per block; Handbook in the shell.
- **Avoid:** the problem its own players name: hiring, firing, arranging and training have no obvious home.

### 1.8 All Your Wrestling Pro Manager (indie, 2026)
- **Hub.** [STORE S50] Dashboard with an assistant (Maya) and an Inbox called "the hub of the game"; a Boardroom (board, fan and TV trust, fired after 3 warnings); a sidebar with an in-game editor. J59 INTERNAL S35 notes a skippable first-week guide and yellow hints. SOURCED.
- **Training.** [NEWS S58] Academy update 1.0.15 (2026-09-20): 14 trainees, 8 new each January, a training budget, tracked attribute changes, delegated shows to a head coach. So training is budget and staff, not picking a move. Whether you pick moves: UNKNOWN.
- **Players say:** "too much of the workload involves navigating menus" (up 23, not recommended) [REVIEW S51]; "FM24 UI style which means its easy to pick up" (up 4, recommended) [REVIEW S52].
- **Copy:** an advisor plus skippable first week; delegating a job to a staff member.
- **Avoid:** admin through menus when the job could happen in a place.

### 1.9 Ludus Magnatus (gladiator school manager)
- **Hub.** [NEWS S53] Hub screen, a Ludus upgrade panel, a roster training panel; World View in patch 0.95; Space is Next Day; a bug where read messages stayed unread "after returning to the hub" was fixed in 0.96.1. SOURCED.
- **Training.** Passive training by a Doctore: pick a stat to idly train. Heavy Training: pick 1 of 15 gladiators, with traits taken from the Doctore (0.94.3). A tooltip on "Retire as Doctore" lists the traits a gladiator could teach (0.94). Training matches exist. The tutorial can be reset in the main menu (0.93.2). SOURCED.
- **Players say:** "constantly switching between two tabs becomes a little frustrating" (up 5, recommended) [REVIEW S54]; "pick a stat to idly train" (up 6, not recommended) [REVIEW S55].
- **Copy:** a teacher's tooltip showing what he can teach (our coach card).
- **Avoid:** compare-by-switching-tabs.

### 1.10 Boxing Gym Story (Kairosoft)
- **Hub.** [STORE S37] A gym you fit out with facilities. The map and menus: UNKNOWN.
- **Training.** [WIKI S22, fandom mirror; the wiki.gg page was behind a Cloudflare challenge and not bypassed] Boxer profile → Training → 4 options (Indoor, Power, Speed, Outdoor), each up to 5 sessions, paid in Smile Points; a "HOT" marker flags the season of best gains; more sessions with a higher-Coaching trainer. Two weeks before a match, a special pre-weigh-in choice: Jog, Rest, Weight Loss or Eat Lots. Skills are learned by chance. SOURCED.
- **Copy:** the pre-weigh-in fork as a mandatory 4-button decision in fight camp; a marker on the best-value option ("HOT").
- **Avoid:** skills that arrive only by chance.

### 1.11 Prison Architect and Project Hospital (build-first sims with a timetable and a training room)
- **Prison Architect.** [WIKI S23] The Regime is an hourly timetable in Reports, needing a Warden, with 7 slot types: Lockup, Sleep, Eat, Shower, Yard, FreeTime, Work. SOURCED. A Programs tab for courses: PROXY (extract only). Nav complaints: UNKNOWN.
- **Project Hospital.** [WIKI S24] Study Room in the Administrative Department (Hospital Services DLC): limited slots, $800 per session, 8 hours, about +1% skill per hour, trainee unavailable meanwhile. SOURCED. How the skill is chosen: UNKNOWN. Players: "The UI for this game is not the best and not user friendly" (up 6, not recommended) [REVIEW S56]; "I had to restart the tutorials multiple times" (up 5) [REVIEW S57].
- **Copy:** typed slots in a timetable (Prison Architect) for the week planner; visible slot capacity (Project Hospital).
- **Avoid:** tutorials that can soft-lock; make ours re-openable from the Handbook (S148).

---

## 2. Patterns that recur, and what players complain about

**Patterns (JUDGEMENT, built on the sources shown)**
1. **A persistent shell plus a place layer.** FM sidebar/top bar (S1, S6), Two Point Hospital Control Panel (S11), Motorsport Manager bottom tabs (S13), Corner King sidebar (S19), AYW sidebar (S50). The shell never changes; the world changes underneath.
2. **Many doors are fine if every door has the same name and icon.** FM fixtures (4+ routes), Two Point Hospital training (4 routes) (table 1.1). The confusion in FightCamp comes from three names for one thing and several objects in one room opening one screen.
3. **One place for "what needs me" with a Continue that blocks.** FM Inbox and the FM26 Portal "Tasks" filter (S1, S6), Motorsport Manager Mail (S13), AYW Inbox (S50), Corner King inbox and Space (S19). FM26 merged Home into the Inbox because players barely used Home (S6). S148 already has "Continue stops on decisions" (INTERNAL S33).
4. **Training is chosen in five shapes.** (a) Per-person focus menu: FM, Game Dev Tycoon, Boxing Gym Story, Corner King. (b) Station at a place: Punch Club. (c) Room and course: Two Point Hospital, Project Hospital. (d) Automatic or building-driven: Motorsport Manager, AYW academy. (e) Timetable grid: Prison Architect regime, FM schedule.
5. **A building or room unlock IS the capability, and it is shown.** Motorsport Manager HQ, Two Point Hospital locked hospitals and rooms, Corner King's 3D hall, Game Dev Tycoon course tiers by office size.
6. **Cost, time and effect before the commit button.** Punch Club 2 gym, Two Point Hospital Estimated Duration, Game Dev Tycoon course card, FM intensity, Corner King coach ratings.
7. **Teaching lives in the shell.** Albert Crank (S11), FM26 Search, FMPedia and re-runnable tutorials (S7), AYW's Maya (S50), Corner King Handbook (S19), Ludus tutorial reset (S53).
8. **Delegation.** AYW head coach runs shows (S58), Ludus Doctore trains passively (S53), FM assistants.

**Complaints (short quotes, link = the review)**
| # | Complaint | Quote | Game | Link / ID |
|---|---|---|---|---|
| C1 | Too many clicks | "basic tasks take more clicks than they should" (up 70) | FM26 | S38 |
| C2 | Old info got harder to find after a redesign | "harder to find" (same review as "Simple things take more clicks", up 45) | FM26 | S39 |
| C3 | Where is hiring/training? | "unclear where is the hiring, firing, arranging, training" (up 11) | Corner King | S48 |
| C4 | Opaque numbers | "a lot of poorly explained systems" (up 44) | Corner King | S49 |
| C5 | Admin by menus | "too much of the workload involves navigating menus" (up 23) | AYW | S51 |
| C6 | Tab switching to compare | "constantly switching between two tabs becomes a little frustrating" (up 5) | Ludus | S54 |
| C7 | Slider grind / decay grind | "essentially just shifting a load of sliders repeatedly" (up 7); "the compounding daily stat decay" (up 5) | GDT; Punch Club | S47, S45 |
| C8 | Soft-locking tutorials | "I had to restart the tutorials multiple times" (up 5) | Project Hospital | S57 |

Reddit and forums: not searched (see 6.1).

---

## 3. Proposed FightCamp scene tree (JUDGEMENT, built on sections 1–2 and the input map S30)

### 3.1 Walk the map with one question per room: "what is this room FOR?"

| Room | Job only this room has | Objects that carry the job |
|---|---|---|
| HOME | See the gym today; jump to a room | 3 room pins (floor, office, staff room) |
| Training floor | **Train**: choose a station, a fighter, a move | stations, spar card, doors |
| Front desk | Leave for the world (fights) | street door |
| Office | Paperwork: money, contracts, dates, goals, calls, history | books, cabinet, wall calendar, desk, phone, photo wall |
| Locker room | Make weight, fight week | scale, this-week board |
| Mat room | Run classes and members (the income side) | classes board, class coach |
| Staff room | Hire and manage coaches | staff board, coach cards |
| Physio | Treat injuries | body charts |
| Film room | Prepare for the next opponent (fight camp) | camp screen |

### 3.2 Rules (the "delete every second door" step)
- **R0. Two layers.** Shortcut layer = left rail + HOME pins. It opens a room or an area, never a leaf. Place layer = rooms; room objects open leaves.
- **R1.** One object in a room per destination. Two objects must never open the same screen (the Staff room has three today).
- **R2.** A leaf gets at most **one room object (its place)** plus **one area index tile**. Both carry the same name and icon (Two Point Hospital and FM do this, table 1.1). An index tile that points into a room shows that room's icon: a shortcut label only. Leaves with no physical object (Fight offers, Rankings, Roster, Scouting, Training planner) are index-only.
- **R3.** A prop may show a summary but never opens a different screen under another name. A fighter's portrait or name opens Fighter profile everywhere. That is a universal link (Corner King S19; FM), not counted as a door. Body and Camp are tabs of the one profile; rooms jump straight to a tab.
- **R4.** Icons with tooltips (settled). Every tooltip uses the screen's one official name.
- **R5.** Teaching: a Handbook page "Where things live" (the room→job table above) and a first-visit hint dot on each leaf that has no area tile (Corner King Handbook S19; FM26 Search and re-runnable tutorials S7; S148 handbook S33).

### 3.3 The tree (every screen has ONE home; "place" = room object, "index" = area tile)

```
CHROME (always on, not in the map)
  Left rail: HOME | FIGHTERS | FIGHTS | FINANCE      (shortcuts to areas, never to leaves)
  Top bar: NEXT UP / Continue (stops on decisions) | date | Handbook | Objectives   (S148)

HOME  (painted still, 3 room pins; opens rooms only)
  pin: Gym floor    -> The training floor   (default focus)
  pin: Office       -> Office
  pin: Staff room   -> Staff room           (dim + lock tooltip until its tier)
  [ring pin removed: the ring is a floor station]

FIGHTERS area  (painted; index)
  Roster & floor    HOME of the fighter list and of FIGHTER PROFILE
     Fighter profile (one screen; tabs: Skills | Body | Camp | Record ...)
        Body tab  <- place: Physio body chart
        Camp tab  <- place: Film room camp screen
  Training          HOME of the WEEK PLANNER (grid; power-user overview)
  Scouting          HOME of Scouting (prospects)
  [The floor tile removed]

FIGHTS area  (painted; index)
  Schedule          index; place = Office wall calendar; opens on the NEXT UP card (S148)
  Rankings          HOME of Rankings; LADDER card on top (S148)
  Fight offers      HOME of Fight offers (index only)

FINANCE area  (painted; index only, four tiles)
  The books         index -> Finances (place: Office books)
  Office            index -> Office desk (place: Office desk object)
  Staff             index -> Staff (place: Staff room board)
  Contracts         index -> Contracts (place: Office cabinet)

THE TRAINING FLOOR  (room hub; TRAINING IS CHOSEN HERE)
  NEW stations: heavy bag | pads | speed bag | ring and rope  -> TRAIN1 flow (section 4.3)
  Spar card: watch  -> Spar night           (only home of Spar night)
  Doors: Front desk | Office | Locker (T2+) | Mat (T3+) | Staff room (T4) | Physio (T4) | Film room (NEW door)

  Front desk (lobby)
     Out to the city -> FIGHTS area
     Back to the floor

  Office
     The books           -> Finances (the books)
     The phone           -> Promotions (phone)
     Contracts cabinet   -> Contracts
     Wall calendar       -> Schedule     (renamed from "Fight calendar"; same name as the index tile)
     Photo wall          -> Former fighters
     NEW Desk            -> Office desk  (see 3.6: proposed job = GOALS)
     Back to the floor

  Locker room
     The scale           -> Weight class
     Fight-week board    -> inline panel: this week's weigh-ins and medicals (NO jump to Schedule)
     [fighter's locker removed]
     Back to the floor

  Mat room (classes)
     Classes board       -> NEW small panel: classes, members, dues (replaces the dues-board jump to FINANCE)
     The class coach     -> class-coach picker popup (NOT the Staff screen)
     Back to the floor

  Staff room
     Staff board         -> Staff        (tabs: My staff | Hire)
     A coach             -> coach card popup (training rating per block)
     [hiring noticeboard removed: it is the Hire tab]
     Back to the floor

  Physio
     A fighter's body chart -> Fighter profile - body
     Back to the floor

  Film room  (fight camp: opponent preparation)
     Camp screen         -> Fighter profile - camp (tabs: Tape | Tendencies | Game plan)
     [tendencies board, laptop, folders, other files removed: tabs and Scouting cover them]
     Back to the floor
```

### 3.4 Door counts, before and after (counted by script over the 53 entries of the input map, S30)
Counts exclude the universal portrait link and the "Back to the floor" arrows are counted as doors to the floor.

| Screen | Doors before | Doors after | What stays |
|---|---|---|---|
| Schedule | 3 | **2** | FIGHTS tile + Office wall calendar |
| Staff | 5 | **2** | FINANCE tile + Staff room board |
| Scouting | 3 | **1** | FIGHTERS tile |
| Fighter profile - camp | 3 | **1** | Film room camp screen |
| Training (planner) | 2 | **1** | FIGHTERS > Training |
| FINANCE area | 2 | **1** | rail |
| Training floor | 9 | **8** | HOME pin + 7 back arrows |
| Finances, Contracts, Office, Staff room, Front desk, FIGHTS area, Weight class, Fighter profile - body | unchanged | unchanged | — |

Totals over the 53 entries: 41 KEEP, 8 REMOVE, 4 RE-JOB, 0 RE-TARGET.

### 3.5 Screen → home → fate of its old doors (covers every screen in the input map)

| Screen | ONE home (place) | Index tile (shortcut) | Fate of old duplicate doors |
|---|---|---|---|
| HOME | rail | — | ring pin removed (ring is a floor station); 3 pins remain |
| FIGHTERS area | rail | — | "The floor" tile removed |
| FIGHTS area | rail; Front desk "Out to the city" | — | unchanged; gains the LADDER card on Rankings |
| FINANCE area | rail | — | Mat dues board no longer jumps here |
| The training floor | HOME gym-floor pin | — | FIGHTERS "The floor" tile removed |
| Front desk (lobby) | floor door | — | unchanged |
| Office | floor door; HOME pin | — | unchanged |
| Locker room (T2+) | floor door | — | unchanged |
| Mat room (T3+) | floor door | — | unchanged |
| Staff room (T4) | floor door; HOME pin (dim) | — | unchanged (see Q2) |
| Physio (T4) | floor door | — | unchanged (see Q2) |
| Film room | NEW floor door | — | none exists today (Q4) |
| Roster & floor | FIGHTERS > Roster | — | unchanged |
| Training (planner) | FIGHTERS > Training | — | HOME ring pin removed |
| Scouting | FIGHTERS > Scouting | — | Film room "folders" and "other files" removed |
| Schedule | Office wall calendar | FIGHTS > Schedule | Locker "Fight-week board" changed to a different job (inline panel) |
| Rankings | FIGHTS > Rankings | — | unchanged; gains LADDER card |
| Fight offers | FIGHTS > Offers | — | unchanged |
| Finances (the books) | Office books | FINANCE > The books | Mat dues board changed to Classes board |
| Office desk | NEW Office desk object | FINANCE > Office | none (new object) |
| Staff | Staff room board | FINANCE > Staff | Mat coach changed (picker popup); Staff-room hiring board removed; Staff-room coach changed (coach card) |
| Contracts | Office cabinet | FINANCE > Contracts | unchanged |
| Promotions (phone) | Office phone | — | unchanged |
| Former fighters | Office photo wall | — | unchanged |
| Weight class | Locker scale | — | unchanged |
| Fighter profile | FIGHTERS > Roster row (click) + portrait link | — | Locker "fighter's locker" removed |
| Fighter profile - body | Physio body chart (tab of the profile) | — | unchanged |
| Fighter profile - camp | Film room camp screen (tab of the profile) | — | Film tendencies board, laptop removed; footage screen becomes the camp pin |
| Spar night | Floor spar card | — | unchanged |
| NEW: station drawer (TRAIN1) | floor stations | — | new; answers operator comment 3 |
| NEW: Classes board | Mat room | — | new, size UNKNOWN (Q3) |

### 3.6 How this resolves the operator's four comments
1. **"Fight calendar → Schedule … exists also in the staff room."** Schedule keeps its place (Office wall calendar, renamed to the one name "Schedule") and one index tile. The two other Schedule doors are gone or changed. I could not find a Schedule object in the Staff room in the input map (Q1).
2. **"Fight-week board → Schedule … here it is again."** The Locker board becomes an inline list of this week's weigh-ins and medicals, with one action per row. It no longer opens a screen with another name. Row jump to "Schedule" is allowed as a link inside the panel (JUDGEMENT; same name).
3. **Operator comment 3 (select the move to train, preview it in animation, why a floor with no options to train).** The floor gets stations (section 4.3). Nobody surveyed does this, so it is original work (section 4).
4. **"Display in 2.5D the fighter training with the coach."** The floor still is a painted 2.5D still with a living loop of fighter plus coach at a station (S34, S31 "nobody shows the gym working"). Loop length and cost follow the Office v2 preview (10 s loop, done, S34).

The **Office desk screen** (proposed job GOALS: objectives and ladder gates) is an inference. FLOW_PASS2 (2026-09-22) lists the OfficeHubPanel with tabs contracts, finances, objectives, weight_class (S32), which may be outdated. Check before building (Q5).

**Ladder on screen (S148, S33; numbers are labelled invented there).** The Rankings LADDER card shows: REGIONAL → NATIONAL "5 net wins (n/5)"; NATIONAL → INTERNATIONAL "7 more net wins (n/7)"; a loss gives −1 progress. HOME dims rooms that need a higher gym tier and says what unlocks them (Two Point Hospital locked map, S11).

### 3.7 The complete 53-entry door table (generated from the input map; n = row)

| n | Room | Object | Opens today | Fate | Opens after | Note |
|---|---|---|---|---|---|---|
| 1 | Rail | HOME | HOME | KEEP | HOME | Always-on shortcut. |
| 2 | Rail | FIGHTERS | FIGHTERS area | KEEP | FIGHTERS area | People lists. |
| 3 | Rail | FIGHTS | FIGHTS area | KEEP | FIGHTS area | The world: dates, ladder, offers. |
| 4 | Rail | FINANCE | FINANCE area | KEEP | FINANCE area | Index of money/paper screens. |
| 5 | HOME | Office pin | Office | KEEP | Office | Room-level shortcut (opens a room, never a leaf). |
| 6 | HOME | Staff room pin | Staff room | KEEP | Staff room | Shown dim with a lock tooltip until its tier (TPH locked/unlocked pattern). FLAG: see Q2. |
| 7 | HOME | The ring pin | Training | REMOVE | - | HOME pins open rooms only. The ring is a floor station (spar card + TRAIN1). Training planner keeps FIGHTERS > Training. |
| 8 | HOME | Gym floor pin | Training floor | KEEP | Training floor | Default focus pin. |
| 9 | FIGHTERS area | Roster | Roster & floor | KEEP | Roster & floor | Home of the fighter list and of Fighter profile (click a row). |
| 10 | FIGHTERS area | Training | Training | KEEP | Training | Home of the WEEK PLANNER (grid). Tooltip: "move choice is on the floor". |
| 11 | FIGHTERS area | The floor | Training floor | REMOVE | - | Third door to the floor; HOME pin already opens it. |
| 12 | FIGHTERS area | Scouting | Scouting | KEEP | Scouting | Sole home of prospect scouting. |
| 13 | FIGHTS area | Schedule | Schedule | KEEP | Schedule | Index tile; its place is the Office wall calendar. |
| 14 | FIGHTS area | Rankings | Rankings | KEEP | Rankings | Gains the LADDER card on top (S148). |
| 15 | FIGHTS area | Offers | Fight offers | KEEP | Fight offers | Index only (no room object). |
| 16 | FINANCE area | The books | Finances (the books) | KEEP | Finances (the books) | Index tile; its place is the Office books. |
| 17 | FINANCE area | Office | Office desk | KEEP | Office desk | Index tile; place is the Office desk (new object). |
| 18 | FINANCE area | Staff | Staff | KEEP | Staff | Index tile; place is the Staff room board. |
| 19 | FINANCE area | Contracts | Contracts | KEEP | Contracts | Index tile; place is the Office cabinet. |
| 20 | Training floor | Door: front desk / street | Front desk (lobby) | KEEP | Front desk (lobby) | |
| 21 | Training floor | Door: office | Office | KEEP | Office | |
| 22 | Training floor | Door: locker room (tier 2+) | Locker room | KEEP | Locker room | |
| 23 | Training floor | Door: mat room (tier 3+) | Mat room (classes) | KEEP | Mat room (classes) | |
| 24 | Training floor | Door: staff room (tier 4) | Staff room | KEEP | Staff room | FLAG Q2: tier-4 gate vs hiring the first coach. |
| 25 | Training floor | Door: physio (tier 4) | Physio | KEEP | Physio | |
| 26 | Training floor | Spar card: watch | Spar night | KEEP | Spar night | Only home of Spar night. |
| 27 | Front desk | Out to the city | FIGHTS area | KEEP | FIGHTS area | The only in-world way "out" (job: leave the gym). |
| 28 | Front desk | Back to the floor | Training floor | KEEP | Training floor | Nav arrow, not a duplicate. |
| 29 | Office | The books | Finances (the books) | KEEP | Finances (the books) | Place of Finances. |
| 30 | Office | The phone | Promotions (phone) | KEEP | Promotions (phone) | Only home of Promotions. |
| 31 | Office | Contracts cabinet | Contracts | KEEP | Contracts | Place of Contracts. |
| 32 | Office | Fight calendar | Schedule | KEEP | Schedule | Place of Schedule; opens on the NEXT UP card. |
| 33 | Office | Photo wall | Former fighters | KEEP | Former fighters | Only home of Former fighters. |
| 34 | Office | Back to the floor | Training floor | KEEP | Training floor | Nav arrow. |
| 35 | Locker room | The scale | Weight class | KEEP | Weight class | Only home of Weight class. |
| 36 | Locker room | Fight-week board | Schedule | RE-JOB | Inline panel: this week's weigh-ins and medicals | No longer opens Schedule. Read-only list with one action button per row. Resolves operator comment 2. |
| 37 | Locker room | A fighter's locker | Fighter profile | REMOVE | - | Portrait click opens a profile everywhere; the locker adds nothing. (Option: re-job to kit/branding later.) |
| 38 | Locker room | Back to the floor | Training floor | KEEP | Training floor | Nav arrow. |
| 39 | Mat room | Dues board | FINANCE area | RE-JOB | Classes board (new small panel: classes, members, dues) | Stops jumping to the FINANCE area. NEW SCREEN, size UNKNOWN; cheap fallback in Q3. |
| 40 | Mat room | The coach | Staff | RE-JOB | Class-coach picker (popup) | Not the Staff screen. |
| 41 | Mat room | Back to the floor | Training floor | KEEP | Training floor | Nav arrow. |
| 42 | Staff room | Staff board | Staff | KEEP | Staff | Place of Staff (tabs: My staff | Hire). |
| 43 | Staff room | Hiring noticeboard | Staff | REMOVE | - | Becomes the Hire tab inside Staff; two objects must not open one screen. |
| 44 | Staff room | A coach | Staff | RE-JOB | Coach card (popup: training rating per block) | Corner King shows block ratings on the coach profile (S19). |
| 45 | Staff room | Back to the floor | Training floor | KEEP | Training floor | Nav arrow. |
| 46 | Physio | A fighter's body chart | Fighter profile - body | KEEP | Fighter profile - body | Place of the Body tab. |
| 47 | Physio | Back to the floor | Training floor | KEEP | Training floor | Nav arrow. |
| 48 | Film room | Footage screen | Fighter profile - camp | KEEP | Fighter profile - camp | Becomes the single "Camp screen" pin (tabs: Tape | Tendencies | Game plan). |
| 49 | Film room | Tendencies board | Fighter profile - camp | REMOVE | - | Merged into the Camp screen tabs. |
| 50 | Film room | His record (folders) | Scouting | REMOVE | - | Scouting stays in FIGHTERS (prospects). The opponent record is in the Camp screen. |
| 51 | Film room | Game plan (laptop) | Fighter profile - camp | REMOVE | - | Merged into the Camp screen tabs. |
| 52 | Film room | Other files | Scouting | REMOVE | - | Second door to Scouting from the same room. |
| 53 | Film room | Back to the floor | Training floor | KEEP | Training floor | Nav arrow. NOTE: no door to the Film room exists in the map today (orphan). |

---

## 4. Training a specific move: who lets you pick it and SEE it first

### 4.1 What I could verify

| Game | Pick a move or skill? | How is it shown before you commit? | Tag |
|---|---|---|---|
| **WWE 2K25 move-set editor** (not career training) | Yes, pick moves for a wrestler | **Highlight a move and the wrestlers demonstrate it on screen**; X/Square previews it; Y/Triangle opens Reversal Practice | SOURCED [PRESS] S28 |
| EA Sports UFC 5 career | Moves are learned in sparring or by inviting a fighter; using a move levels it; Evolution Points upgrade attributes, moves and perks; a G.O.A.T. checklist exists | No in-career preview found | SOURCED S25 for the mechanics; preview UNKNOWN |
| Undisputed career | Fight camp activities by week; coach, cutman and manager choices; coach XP goes into categories such as Strength | No move picker found | SOURCED [OFFICIAL/PRESS] S26 |
| Fight Night Champion | Training is mini-games chosen from a list (Open Sparring, Heavy Bag Combos, Double End Bag, Maize Bag and others) | The mini-game itself, no move choice | SOURCED [PRESS] S27 |
| Uma Musume | Pick a facility, not a move | Predicted gain on the button: PROXY from our G112 (S31). The guide I opened gives base gains per facility and a Training Simulator but not the on-screen wording | PROXY S29, S31 |
| Football Manager | Pick an attribute focus and intensity | Text list; weekly green/amber/red arrows; no animation | PROXY S9, S10; INTERNAL S31 |
| Game Dev Tycoon | Pick a named course | Card with cost and effect markers | SOURCED S18 |
| Punch Club 1/2 | Skills from a tree; machine at a place | Cost and duration before start (PC2); "Tactics Learner" numbers (PC1) | SOURCED S16, S17 |
| Boxing Gym Story | Pick 1 of 4 sessions types | Option list plus a "HOT" marker | SOURCED S22 |
| Ludus Magnatus | Pick a stat to idly train; pick 1 of 15 for heavy training | Doctore trait tooltip (on "Retire as Doctore") | SOURCED S53 |
| Corner King | Weekly plan blocks; coach chosen by block rating | Coach's rating per block, shown before hiring | SOURCED S19 |
| Yakuza 0, God of War, SF6 World Tour, Tony Hawk, Skate, Persona, Mount & Blade, WWE MyRISE training | — | **UNKNOWN: not verified.** SF6 World Tour (Masters/Style EXP) is a search extract only | UNKNOWN |

Correction recorded: a search summary claimed Yakuza 0 lets you "hold X to preview" an ability. The page I opened says holding X buys the ability. The claim is unsupported, so Yakuza 0 stays UNKNOWN. A "God of War has no preview" claim was an absence claim I could not verify, so it is not used.

**Finding.** The only verified animated preview is WWE 2K25's move-set screen (S28). No surveyed management game shows an animated move before you pay for it in training time. Most use text or numbers (FM, GDT, Punch Club, Boxing Gym Story). The closest to "see the work" is the G112 verdict that nobody in the genre shows the gym working (S31). That is a gap, tagged JUDGEMENT because it is "not found".

### 4.2 What the surveyed games teach us for a move picker
- Show **who teaches** it (Ludus tooltip, Corner King block rating, Two Point Hospital trainer slot) (S53, S19, S12).
- Show **cost and duration before the button** (Punch Club 2, Two Point Hospital Estimated Duration, Game Dev Tycoon card) (S17, S12, S18).
- Mark the **best-value option** (Boxing Gym Story "HOT") (S22).
- Show **a visible result**, not a bare slider (Game Dev Tycoon complaint, S47; Corner King "1.4 shown as 14" complaint, S49).
- Show **mastery as steps** (Game Dev Tycoon tiers S18; our own drill mastery I–V proposal, S31).

### 4.3 Recommendation: the TRAIN1 flow (JUDGEMENT)

1. **Click a station** on the painted floor (heavy bag, pads, speed bag, ring/rope). Each station has a one-line job (the "what is this FOR" answer) in its tooltip. The object→screen contract is the Two Point Hospital lectern (S12).
2. **Pick the fighter** from a short list. Each row shows his fatigue and injury state and whether a coach is free. A fighter already in a block shows the block and what else it blocks (the Two Point Hospital lesson, S12).
3. **Move cards** for the moves this station trains. Each card has: name; a one-line "fixes" ("keeps your hands up"); mastery pips I–V; progress; **a looping animated preview**; a gain / fatigue / injury preview from the same formula as `_apply_focus_stat_gains` (GameState.gd:4730, S31); the coach's rating for that block (Corner King, S19); a marker on the best-value card (S22).
4. **TRAIN THIS** commits via `GameState.assign_technique_training`. A "no coach: lower gain" line is visible before the button.
5. **On the floor** the 2.5D loop shows the fighter working the station beside his coach. The week planner stays in FIGHTERS > Training as the overview.

**Preview clips (cost UNKNOWN).** WWE 2K25's "highlight = demonstrate" is the model (S28). A possible source is the existing 3D fight rig played in a small viewport. The number of moves FightCamp has is not in the files I read, so the clip count and cost are UNKNOWN. Where a move has no clip yet, show the card with a freeze-frame and a "preview soon" mark rather than hiding the move (JUDGEMENT).

**Check with Claude before building:** whether `assign_technique_training` accepts a station context, and whether moves can be tagged per station (UNKNOWN; code not read).

---

## 5. Which shipped game's navigation to COPY, and the exact screen

| # | Game | Exact screen | What FightCamp takes it for |
|---|---|---|---|
| 1 | **Two Point Hospital** | Training Room: click the **lectern** → course screen (qualification, trainer, trainees, estimated duration) (S12) | The whole TRAIN1 contract: object → one screen → who, what, how long |
| 2 | Two Point Hospital | Hospital View's **Control Panel** with tabs Menu / Characters / Finance / Data View, and the **County Map** with locked and unlocked hospitals (S11) | The left rail pattern; dimmed, lock-tooltipped rooms for tiers |
| 3 | Football Manager 26 | **Portal** with the Tasks filter, the must-respond Continue, and **Search** for "where is X" (S1, S6, S7) | Our NEXT UP chrome and a search/handbook answer for lost players |
| 4 | Corner King | **Gym page → Facilities 3D hall** (equipment appears as levels rise, S19); **Organizations** screen with the ladder on the left and booked fights beside it (S35); **coach profile** with a rating per training block (S19) | Gym growth you can see; ladder card; coach card |
| 5 | Punch Club 2 | **Silver's Gym modern training** start: duration and stamina/hunger cost before you start (S17) | Cost-before-commit line on move cards |
| 6 | WWE 2K25 | **Move-set screen**: highlight a move → wrestlers demonstrate it (S28) | The animated preview on move cards |
| 7 | Boxing Gym Story | The **pre-weigh-in choice** (Jog, Rest, Weight Loss, Eat Lots) two weeks before a match (S22) | One mandatory decision in fight camp |
| 8 | Motorsport Manager | **Home** stat bars versus rivals; click a bar → page (S13) | A ladder/progress card that links to the detail |

---

## 6. NOT FOUND, limits and open questions

### 6.1 Limits (read these before trusting a number)
- **No game was played.** Counts of "ways to reach a screen" come from manuals, wikis, patch notes and reviews. I read no screenshot or video, so anything shown only in pictures is UNKNOWN.
- **Blocked or partial pages.** The FM24 training manual page was blocked by Cloudflare; I used a search extract (S9, PROXY). Magic Game World was blocked; extract only (S5, PROXY). The kairosoft.wiki.gg page was a Cloudflare challenge; I did not bypass it and used the fandom mirror (S22). The Two Point Hospital wiki pages were read with curl on fandom (public pages); fandom wikis are community-edited.
- **FM Scout vs official:** FM Scout lists eight FM26 navigation sections, the official blog says six categories. I used six.
- **Steam samples.** Reviews are English only and I read pages of the review API, not every review (for example 448 of 16,579 for Two Point Hospital, 752 of 15,355 for FM26). The quotes are what I read, with the "helpful" count at read time.
- **Small samples.** Corner King (28), AYW (26), Boxing Gym Story (23) are tiny English samples. Treat their scores as weak.
- **Reddit and forums were not searched.** Complaints are Steam reviews only.
- **UNKNOWN items:** Game Dev Tycoon hub; Project Hospital skill choice; Prison Architect Programs tab (extract only); screenshots of Corner King, AYW and Ludus screens; whether Punch Club and Uma Musume preview text matches what I wrote (Uma is PROXY).
- **Not claimed:** Yakuza 0, God of War, SF6 World Tour, Tony Hawk, Skate, Persona, Mount & Blade, WWE MyRISE training (section 4).
- I did not re-read the `scene_tree.html` page; I used the text map in the input (S30), which matched the file on Beast.
- The Grok CLI was not used. All files read from Beast were read-only. Files on Beast: all existed; none unreadable.

### 6.2 Where the evidence is thin on purpose
- "Delete every second door" is my rule (JUDGEMENT). The surveyed games show that many doors can work if names match; I found no game that documents 5 doors to one screen under different names, so FightCamp's Staff case is outside the evidence either way.
- "No game previews a move before training" is "not found", not "none".

### 6.3 Open questions for Claude and the operator
- **Q1.** The operator said the Office "Fight calendar" exists also in the staff room. The input map shows no Schedule object in the Staff room. Check the 3D scene for a prop or an unmapped link before closing comment 1.
- **Q2 (tier gating).** Staff room is tier 4 and Physio is tier 4, yet hiring a first coach and treating injuries are needed from tier 1. Options: FINANCE > Staff and the profile Body tab carry those jobs before the rooms unlock, or the rooms exist from tier 1 and tiers upgrade them. Weight class also sits in the tier-2 Locker room.
- **Q3.** The Mat room has no leaf screen of its own. The Classes board is new (size UNKNOWN). Cheap fallback: a deep link to the books.
- **Q4.** The Film room has no door in the map today (orphan). I propose a floor door.
- **Q5.** Office desk content. My proposal (GOALS) rests on an inference from FLOW_PASS2 (2026-09-22), which may be outdated.
- **Q6.** Two Continues (day vs week) from FLOW_PASS2 are outside this survey; the scene tree does not fix them.

---

## Appendix: sources (ID, type, URL, what it was used for)

**Football Manager**
- S1 [OFFICIAL] https://community.sports-interactive.com/sigames-manual/football-manager-2024/the-user-interface-r4951/ — Side Bar, tabs, date click, Continue "Must Respond". Read in full.
- S2 [OFFICIAL/EXTRACT] https://community.sports-interactive.com/sigames-manual/football-manager-2024/inbox-and-news-r4956/ — Inbox as hub.
- S3 [OFFICIAL/EXTRACT] https://community.sports-interactive.com/sigames-manual/football-manager-2024/competitions-and-fixtures-r4965/ — Schedule views.
- S4 [PRESS] https://fminside.net/guides/basic-guides/21-football-manager-home-screen — Home "Team Fixtures". Read.
- S5 [EXTRACT] https://www.magicgameworld.com/controls-for-football-manager-2024/ — F10, Shift+C. Page blocked; extract.
- S6 [OFFICIAL] https://www.footballmanager.com/fm26/features/fm26s-reimagined-user-interface — FM26 top bar, Portal. Read.
- S7 [OFFICIAL] https://www.footballmanager.com/the-dugout/mastering-fm26-ui — Bookmarks, Search, tutorials. Read.
- S8 [EXTRACT] https://www.fmscout.com/a-beginners-guide-to-football-manager-2026.html — eight sections claim.
- S9 [EXTRACT] https://community.sports-interactive.com/sigames-manual/football-manager-2024/training-r4961/ — training (blocked).
- S10 [OFFICIAL] https://community.sports-interactive.com/sigames-manual/football-manager-mobile-2024/development-hub-r5230/ — role descriptions.

**Two Point, Motorsport, Punch Club, GDT, build-first sims**
- S11 [WIKI] https://two-point-hospital.fandom.com/wiki/Interface — hub and panels. Read by curl.
- S12 [WIKI] https://two-point-hospital.fandom.com/wiki/Training_(Room) and https://two-point-hospital.fandom.com/wiki/Staff_Training — four ways, course screen.
- S13 [GUIDE] https://steamcommunity.com/sharedfiles/filedetails/?id=801128239 — Motorsport Manager. Read in full.
- S14 [WIKI] https://punchclub.wiki.gg/wiki/Locations
- S15 [WIKI] https://punch-club.fandom.com/wiki/Map_and_Locations ; https://punchclub.wiki.gg/wiki/Training ; https://punchclub.wiki.gg/wiki/Consumables_(Punch_Club_1)
- S16 [WIKI] https://punchclub.wiki.gg/wiki/Guides_and_Tips_(Punch_Club_1)/Getting_Started
- S17 [GUIDE] https://steamcommunity.com/sharedfiles/filedetails/?id=3011331996 — Punch Club 2 map, gym, skills. Read.
- S18 [WIKI] https://gamedevtycoon.fandom.com/wiki/Training
- S22 [WIKI] https://kairosoft.fandom.com/wiki/Training_(Boxing_Gym_Story)
- S23 [WIKI] https://prison-architect.fandom.com/wiki/Regime
- S24 [WIKI] https://projecthospital.fandom.com/wiki/Study_Room
- S42 [PRESS] https://gamerant.com/two-point-hospital-train-promote-staff/
- S43 [PRESS] https://www.gamerevolution.com/guides/425019-two-point-hospital-train-staff

**Boxing, wrestling and gladiator managers (patch notes, store text)**
- S19 [NEWS] Corner King: https://store.steampowered.com/news/app/4259990/view/1842212951303715 (0.0.50, 2026-08-28); https://store.steampowered.com/news/app/4259990/view/1842846814449640 (0.0.51, 2026-09-05). 0.0.49 (2026-08-26) and 0.0.45 and 0.0.53 are in the same news feed (J59 lists their ids 1841579228671608, 1844115010489540).
- S50 [STORE] https://store.steampowered.com/app/4979160/ — AYW Pro Manager.
- S58 [NEWS] https://store.steampowered.com/news/app/4979160/ — 1.0.15 Academy update, 2026-09-20.
- S53 [NEWS] Ludus Magnatus: https://store.steampowered.com/news/app/4088670/view/1840310314343529 (0.94); .../1840944183782834 (0.94.3); .../1844751498232442 (0.96.1); .../1842846814444465 (0.95).

**Move preview games**
- S25 [OFFICIAL] https://help.ea.com/en/articles/ufc/ufc-5/level-up-fighter/
- S26 [OFFICIAL/PRESS] https://playundisputed.com/news/career-mode-and-character-creator ; https://www.ginx.tv/en/career-guide
- S27 [PRESS] https://www.ign.com/wikis/fight-night-champion/Training_Games
- S28 [PRESS] https://gamerant.com/wwe-2k25-how-change-wrestler-moveset/ — read in full.
- S29 [PRESS] https://uma.guide/guides/career-mechanics

**Internal files (Beast, `research/`, all read)**
- S30 SCENE_TREE_REVIEW_INPUT.md
- S31 TRAINING_LOOP_DESIGN.md and G112_TRAINING_LOOP.md
- S32 FLOW_PASS2_ROUTE_WORDS.md (2026-09-22)
- S33 S148_SCHEDULE_TUTORIAL_DESIGN.md
- S34 topics/gym_rooms_art.md
- S35 /workspace/j59/J59_STEAM_SURVEY.md (box)
- S36 TASK_J61_SCENE_TREE_GAMES_SURVEY.md (the brief)

**Steam store and reviews**
- S37 [STORE] https://store.steampowered.com/app/<id>/ and https://store.steampowered.com/appreviews/<id>?json=1&language=english — counts, 2026-10-03.
- Reviews (link pattern https://steamcommunity.com/profiles/<steamid>/recommended/<appid>/):
  - S38 FM26, review 232669529, https://steamcommunity.com/profiles/76561197960577777/recommended/3551340/
  - S39 FM26, 234260621, https://steamcommunity.com/profiles/76561198075450779/recommended/3551340/
  - S40 FM26, 231624323, https://steamcommunity.com/profiles/76561199074215098/recommended/3551340/
  - S41 FM26, 233724409, https://steamcommunity.com/profiles/76561198000644992/recommended/3551340/
  - S44 TPH, 233178536, https://steamcommunity.com/profiles/76561198023243571/recommended/535930/
  - S45 Punch Club, 235561780, https://steamcommunity.com/profiles/76561198124562066/recommended/394310/
  - S46 Punch Club 2, 233574174, https://steamcommunity.com/profiles/76561198021643308/recommended/1161590/
  - S47 GDT, 232383261, https://steamcommunity.com/profiles/76561197964871612/recommended/239820/
  - S48 Corner King, 233820900, https://steamcommunity.com/profiles/76561198142347964/recommended/4259990/
  - S49 Corner King, 233141465, https://steamcommunity.com/profiles/76561198114345001/recommended/4259990/
  - S51 AYW, 233489359, https://steamcommunity.com/profiles/76561198033269817/recommended/4979160/
  - S52 AYW, 233120729, https://steamcommunity.com/profiles/76561198036403962/recommended/4979160/
  - S54 Ludus, 232263132, https://steamcommunity.com/profiles/76561198958738150/recommended/4088670/
  - S55 Ludus, 235023246, https://steamcommunity.com/profiles/76561197989817440/recommended/4088670/
  - S56 Project Hospital, 232771382, https://steamcommunity.com/profiles/76561198354132287/recommended/868360/
  - S57 Project Hospital, 233488766, https://steamcommunity.com/profiles/76561198047416976/recommended/868360/
  - A further FM26 quote ("There are too many menus, too many options", up 228, id 230865140, https://steamcommunity.com/profiles/76561198085886398/recommended/3551340/) was about FM in general and is not used in the tables above.

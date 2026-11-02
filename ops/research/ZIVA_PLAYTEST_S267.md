# ZIVA PLAYTEST S267 (task ZIVAPLAYTEST1) - a new player's pass over the boxing demo

Operator S267: "ask ziva to playtest the game and how it would rate it, what need improvements".
Discipline: BOXING. Read-only pass: no game file was changed. Deliverable = this report + stills in
`previews/s267_ziva_playtest/`.

Worktree E:/FightCamp/wt/ZIVA, branch `ziva/playtest`, at `95fbcbee` (merge of origin/master incl. S268 focus card,
S268 brow cut, S269 matte eyelashes). `Godot/scripts/MetaHumanRig.gd` was left untouched (operator S269).

## How this pass was played (and what it could NOT see)

Two instruments, both on the game the player gets (`-- as_game`):

1. **Live play, 1920x1080** - the editor's own player (Ziva `run_scene`) driven by the input harness: real mouse clicks and
   real keystrokes, one process per run. Everything in "the first five minutes" below was played this way: title -> New
   career -> country -> city. State does not survive a run, so each run replays the chain.
2. **The house's own live-playtest driver** `tools/s144_live_walk.gd` (S144, the S237 Ziva driver) run hidden
   (`Tools/godot_hidden.ps1`), `as_game`, its own save dir (`user://fightcamp_s144_live`), 1600x900, one command at a time
   from a file. This is what carried the pass past the gym step into the club, the day plan, the day, and the week review.

The operator's three slot saves were MOVED ASIDE for the pass (backup `E:/FightCamp/tmp/ziva_playtest_s269/saves_backup`,
hashes checked) and restored afterwards - no player save was read, rotated or written.

A second hidden walk then re-ran the same chain and watched the first day at **Play** speed (not Fast) for ~36 s of wall
clock, to answer "does the day ever show the floor" - stills `16_day_floor_modal_over_it.png`. Finally, three live fight
frames were saved through `record_room.gd` + `still_framing.save_if_framed` (`as_game bench=1 bench1=1 demo=1 guard_stills=1
seed=94301`): `13_fight_guard.png`, `14_fight_punch_midflight.png`, `15_fight_contact.png`.

**What this pass did NOT reach, and says so:** a career fight night was never PLAYED - the booking leg (find a fight ->
book it -> fight week -> weigh-in -> live bout -> corners -> result) did not happen in either walk, so no rating below is
drawn from a played bout. The fight leg is covered by instruments instead (section 6): live in-bout frames through
`record_room` + `still_framing`, the real corner card through the house's S159 corner tool, and the fight-night/result
screens through the house's set-piece renderer (which plants a payload from a real `FightSimulation` run). Each claim in
section 6 names its instrument. The station FOCUS CARD, the gain bubbles, the RING REPORT card and the `CHANGE THE PLAN`
nudge were likewise never reached by the player path: they are rated below from a fresh run of the house's own focus tool
(`tools/s267_focus_stills.gd`, as_game, `21-24_*.jpg`), and the fact that a first-week player does not meet them is
reported as a finding, not hidden as a gap. Where a feature is rated, the still that proves it is named in the row.

## 1. RATINGS (a Steam reviewer of a management sim, out of 10)

| Area | Rating | One line |
|---|---|---|
| First 5 minutes | **6/10** | The title screen and the country read-out are genuinely handsome and the creation flow is three clear steps, but the two things a new player actually has to do (find a country, then a city) both stall or hide behind small targets, and the biggest build hitch of the whole game happens exactly there. |
| Gym floor loop | **5.5/10 as played; 7/10 as the house tool shows it** | Played: the floor is live and the HUD reads (cash, meter rows, "TRAINING - THIS WEEK", DAYS LEFT / AT RISK and a conditioning objective appear once the day starts), but the middle of the floor - where the fighter walks - is covered by the coach modal for the whole day, and the week's gains stay +0.0 whatever the day does. In the focus-tool still (`21_focus_card_power_shots.jpg`) the same screen is a different game: coach tasks on the left, the week's meter with the gain split, the objective card, the focus card and a gain bubble - that is what the loop is supposed to look like, and a player cannot get there on day one. |
| Station focus (S268 FOCUS CARD) | **7.5/10 (from a fresh run of the house focus tool; my player pass never reached it)** | `21/24_focus_card_*.jpg`: at the heavy bag the bottom-centre card reads `HEAVY BAG · FOCUS` with `[1] POWER SHOTS + POWER - more fatigue`, `[2] COMBINATIONS + TECHNIQUE`, `[3] BAG ROUNDS + POWER, TECHNIQUE - more fatigue` and a gold ring on the active pick; the gain bubble names the attribute it grew (`IT CLICKED - POWER`, `last_tick=+1.39 TECHNIQUE +0.52 POWER`), and the week meter behind it reads `GAINS ▲ +80.0 pts / RATE: BUILDING / POWER +58.2 TECHNIQUE +21.8 / ATTRITION OPTIMAL`. The card is exactly what S268 promised - and **no player-path pass of mine ever showed it**, because the first day's default plan carries no focus and the coach modal covers the board where it would be set. |
| Fight watchability | **6/10 (in-bout camera/venue; the screen furniture around a bout is the best in the build)** | Three live room frames (`13-15_fight_*.png`): the broadcast HUD works (corner cards + live BPM waveforms, `1X/2X/4X`, three interventions + THROW TOWEL) but the camera sits high and steep looking down at the mat from behind the near ropes, the men are small in the middle, and this room had a bare black/grey venue. A career bout at a real venue was still not played. |
| Corner between rounds | **8/10** | The real corner card off a live bout (R2, `17_corner_card_between_rounds.png`): rest clock `10/45 s USED`, `TANK 96% (recovery)`, `CARDS DOWN 0-1`, a coach line, three advice rows (`HIM` / `YOU` / `GAS`) each with an ADOPT button, eight tactic buttons (PLAN, BOX AND MOVE, PRESSURE, THE BODY, BREATHER, FINISH, HOLD CENTRE, GET INSIDE), the cuts list (`1 CLOSE Left eye is closing`, `2 BLEED Cut on the right brow - blood is running into the eye`) with CALM HIM DOWN / FIRE HIM UP / THE TRUTH, then SEND HIM OUT and THROW THE TOWEL - a genuinely good management moment. |
| Post-fight result | **8/10** | Blocking and readable (`19_fight_result_screen.png`): `OFFICIAL RESULT`, `METHOD KO ROUND 2`, the KO sentence in words, the cards state, a settlement table (purse, win/performance bonuses, gate share, expenses, weight fine), "WHAT THE NIGHT CHANGED" chips, BACK HOME - except `TO THE GYM · NO MANAGER CONTRACT FILED · $0`, which tells the player their own gym gets nothing. |
| Menus / HUD | **7/10** | The club HUD is the best thing in the build: cash, runway, date, speed, tabs, the fighter strip and the one-line training read-out all read at a glance on the game camera; the blemishes are placeholders ("THE DAY'S NEWS LANDS HERE") and numbers that disagree with each other. |
| Overall (for a first-hour demo) | **5.5/10** | A beautiful shell around a loop I could not yet see working: as a player I wanted to be training a boxer within ten minutes and instead I was reading a week review that told me nobody trained. |

Compared against the references the repo already uses: Two Point Museum's FTUE puts you in front of a *thing you can click*
within a minute and never makes you wait on a board to finish building (see research/TWOPOINT_ALIGNMENT.md, section 1-2);
Game Dev Tycoon's first session always shows the work happening in front of you; Football Manager never advances a week
without a readable "what happened" the player can point at. FightCamp's creation is closer to FM's depth without FM's
patience, and its day is closer to a twitch-speed Two Point with far less feedback.

## 2. TOP 10 PROBLEMS, ranked by how much they hurt a new player

Every item below is something I did, saw, expected, and can point at a file for. Screenshot paths are relative to
`previews/s267_ziva_playtest/`.

### P1 - The creation flow freezes for ~4.5 s exactly when the player commits the country (CRITICAL, feel)
- **Did**: New career -> typed "cyprus" in SEARCH MARKET -> Enter -> clicked CHOOSE MARKET.
- **Saw**: the board stopped responding. Measured through the input harness's own delivery record: the click at
  `press_ms 8905` was still held at `release_ms 13313` with a 150 ms hold - i.e. **10 rendered frames in 4.4 s (~2.3 fps)**
  at the exact moment THE CITY was built. Every click scheduled in that window landed late and bunched into one frame
  (the following clicks fired 16 ms apart instead of 1.5 s apart), which is why two of my scripted clicks were swallowed.
- **Expected**: the market commits and the next step appears, as fast as every other board move (the title->creation
  handoff is instant).
- **Blame**: the step build happens on the main thread inside `scripts/CreationFlowPanel.gd:_build_city()` (the 3D
  `CreationBackdrop` + roster preview mount behind the city cards).
- **Still**: `07_city_step_arrival.png` (the board as it lands, cards and backdrop).
- **Why it hurts**: this is the FIRST transition of the game, and it is the one a reviewer will describe as "it froze".

### P2 - The country step's two ways in (globe marker / market list) both fight the player (HIGH, usability)
- **Did**: tried the intended path first - clicked a gold marker on the globe; then tried MARKET LIST; then found the
  SEARCH MARKET field.
- **Saw**: (a) the globe **sways**: `GlobePicker.gd:28-29` `IDLE_SWAY_RAD := 0.12` (~7 deg) on a 9 s `sin`, applied every
  frame at `GlobePicker.gd:407`, so every marker moves under the cursor; (b) marker hit radius is 14 px
  (`GlobePicker.gd:30 MARKER_HIT_PX`), and a miss falls through to a ray-pick that can land in the ocean and do nothing;
  (c) the MARKET LIST toggle sits at the left above the globe and my click on it did nothing (I mis-aimed; the click is
  real but the target is small); (d) the only reliable path in the end was typing a country name into a field whose
  placeholder is "SEARCH MARKET" - and the field's own tip says the globe turns to it.
- **Expected**: on a globe whose whole point is "pick your country", a new player should be able to click a country on
  the first or second attempt, and the list should be a visible alternative rather than a 160x36 px toggle.
- **Blame**: `scripts/creation/GlobePicker.gd:30` (hit radius), `:407` (idle sway), `scripts/CreationFlowPanel.gd:241`
  (`_use_globe_picker()` - the globe and the market list are two switch-arms of the same step, and the player sees only
  one of them).
- **Stills**: `02_country_globe_nothing_chosen.png` (markers are ~6 px dots at 1920 wide), `03_country_cyprus_read.png`
  (the state the working path lands in).

### P3 - The week review says "Nobody trained this week" after the player ran a full day (CRITICAL, trust)
- **Did**: in the club, dismissed the coach offer, pressed START DAY, pressed [Fast], waited.
- **Saw**: the club rolled to **Week 2, Mon 12 Jan** with the same morning board and the same "TRAINING - THIS WEEK / GAINS
  +0.0 pts", then the **Week 1 in review** screen: `NET +$1,152`, `Profit week`, `Your fighters: Nobody trained this week -
  set a programme in Training.` and `Next week: Nothing booked yet - find a fight in Fights.`
- **Expected**: a day that ran the plan the game itself drew (9 blocks, Ring Spar at 08:00, Coach Minutes 165/240) to show
  gains for the fighter, or at least "trained" - the whole pitch is lived-day growth.
- **Blame**: the line is drawn at `scripts/WeekReviewPanel.gd:970-976` when the review's read has no `fighters`; the read
  is assembled from the week's training tally (GameState week summary). The suspicion is that the club-speed day that runs
  itself (ClubSpeedControls, `morning_ticker` default ON in as_game, `scripts/ClubSpeedControls.gd:35-40`) completes the
  day and the week without the floor's training tally being written for it.
- **Stills**: `09_club_after_start_day.png`, `10_week2_morning_coach_offered_again.png`, `11_week_review_nobody_trained.png`.
- **Why it hurts**: it is the first promise the game makes to the player ("train him, watch him improve") and the first
  answer it gives back is "nobody trained".

### P4 - The player never gets an unobstructed view of the day (HIGH, loop visibility)
- **Did**: run 1 - pressed START DAY then [Fast] because the morning board was already up and nothing was moving; run 2 -
  pressed START DAY and left it on **Play**, then looked every ~12 s for 36 s.
- **Saw (run 1)**: within ~30 s of wall clock the whole day and the week had passed. **Saw (run 2)**: the floor is alive -
  Mara Solano in red trunks walks the TIMING BAGS / FOOTWORK side, the top-centre HUD grows a `DAYS LEFT 28 · AT RISK` chip,
  a `BOOKED FIGHT 0/1` and a `CONDITIONING 64/65` objective - and the coach interview modal covers the middle of the floor
  from before the day until the end of it, with `GAINS ▲ +0.0 pts` in the corner the whole time.
- **Expected**: a management sim whose first pitch is "watch him work" must hand the player that view for the first day; the
  plan board, the coach offer and the speed control all take turns covering it.
- **Blame**: the day plan board + coach interview stay mounted over the 3D floor while the day runs
  (`scripts/ClubSpeedControls.gd` speeds, `scripts/InterviewPanel.gd:171` modal, the morning board's visibility).
- **Stills**: `09_club_after_start_day.png`, `10_week2_morning_coach_offered_again.png`, `16_day_floor_modal_over_it.png`
  (this last one is the proof: the fighter walking, the meters ticking, the modal in the way).

### P5 - The coach interview modal sits ON TOP of the day plan, every morning (HIGH, flow)
- **Did**: arrived in the club (Week 1, Mon 5 Jan).
- **Saw**: a full-height modal - `HIRE A COACH / Constantine Andreou / TEACHING 9 (Fair) / PAY $740 a week for 33 weeks,
  $1,480 to sign / WHAT HE IS KNOWN FOR - PICK ONE` - over the middle of the `Schedule: Camp Heavy` board; dismiss it
  (NOT NOW) and the next morning (Week 2) it is back with a different name (Paraskevi Georgiou in the first club
  screenshot). The plan you are supposed to read and the START DAY you are supposed to press are behind it.
- **Expected**: the hire prompt is a decision, not a gate - a banner/queue chip that does not cover the plan, or a
  "hire later" state the player can act on when they choose.
- **Bug**: `NOT NOW` did not clear it. The still taken 1.5 s after the press (`08b_morning_plan_same_modal.png`) still
  shows the modal, the plan board after it still shows it, and the second walk shows the same offer still covering the
  floor 36 s into a day that was already running in Play (`16_day_floor_modal_over_it.png`). Either NOT NOW does nothing or
  it immediately queues the next candidate; either way the player cannot get it off the screen.
- **Blame**: `scripts/InterviewPanel.gd:171` (`HIRE A COACH` kicker) shown over the morning board; the club walk notes the
  same collision at `scripts/GymHallPanel.gd:704` ("a story card on screen comes first - one dialog at a time"). The modal
  covers exactly the right-hand third of the block rows, which is where S268's per-block FOCUS picker lives
  (`scripts/ui/DayPlanPanel.gd:368-383`) - so the one control this week's work added to the plan is the one the modal hides.
- **Stills**: `08_club_morning_plan_coach_modal.png`, `08b_morning_plan_same_modal.png`, `12_club_first_arrival.png`,
  `16_day_floor_modal_over_it.png`.

### P6 - The money numbers disagree with each other in front of the player (MEDIUM-HIGH, trust)
- **Did**: read the gym step's numbers, then the club HUD, then the week review.
- **Saw**: creation says `$25.0K STARTING CASH / $367 · WK WEEKLY UPKEEP / 13 WKS RUNWAY · BURN $1.9K / WK`
  (`scripts/creation/GymStepPanel.gd:249`); the club HUD header says `$25,000` and `+$881/wk · runway: not falling`
  (`scripts/ShellChrome.gd:812`); the week review says `NET +$1,152`, `Bills $0` with the note "Wages and upkeep add up;
  the bill lands when the month turns".
- **Expected**: one story about money: if the gym burns $1.9k a week, the HUD cannot read "+$881/wk, runway: not falling"
  next to a week review of +$1,152 with $0 bills.
- **Blame**: the three read-outs come from three places - `GymStepPanel.gd:243-249` (take preview), `ShellChrome.gd:800-812`
  (HUD runway), `WeekReviewPanel.gd` (week net). They are each defensible alone; side by side they read as a lying game.
- **Stills**: `12_club_first_arrival.png` (HUD), `11_week_review_nobody_trained.png` (review).
- **Note**: the player never sees the creation "13 WKS" again, and the HUD's "not falling" is exactly the opposite of the
  number they were shown at sign-up - the cheapest fix in this list.

### P7 - The gym step's 3D floor preview was a flat grey panel in the real flow (MEDIUM-HIGH, looks/trust)
- **Did**: walked the real flow (title -> country -> city -> THE GYM) and looked at the step after 14 s and again after
  ~26 s.
- **Saw**: the centre frame - the whole point of the step (choose the floor you inherit) - was an **empty grey rectangle**
  in both stills: `06_gym_step_blank_preview.png`.
- **Control**: the S238 probe (`tools/s238_gym_preview_probe.gd`, same build, as_game) mounts the same step directly and
  reports `preview size=(1412.0, 697.6) visible=true vp size=(1412, 697) update=2 cam=... cam_current=true club=true
  club_children=27 world_env=true`, and its window capture shows the floor rendered (kept here as
  `s238_probe_gym_step_t6.png`). So the preview mechanism works; **the routed flow does not show it**.
- **Expected**: the step shows the inherited Calder House floor, as the probe proves it can.
- **Blame**: `scripts/creation/GymStepPanel.gd:290-303` (`_build_centre()` builds `CentreFrame` + `GymPreview`) together
  with `scripts/creation/GymPreview.gd:44-48` (`_ready()` -> `_build_shell()`); the difference between the two paths is
  that one arrives by the router after the country and city boards, the other is instantiated directly.
- **Stills**: `06_gym_step_blank_preview.png` (routed), `s238_probe_gym_step_t6.png` (direct mount).

### P8 - The demo calls itself a boxing AND MMA game, and the world is full of MMA (MEDIUM, promise)
- **Did**: read the title, then the market read-out, then the city card.
- **Saw**: title board says `EST. 2026 · A BOXING & MMA MANAGEMENT GAME` (`scripts/TitleBoardPanel.gd:118`); the Cyprus
  market card lists `WRESTLING 23 / JUDO 14 / KICKBOXING 10 / BRAZILIAN JIU-JITSU 7 / MMA 7 / MUAY THAI 5` and the
  governing bodies "CYPRUS MIXED MARTIAL ARTS FEDERATION"; the city card names rivals "APEX TRAINING CENTRE, NICOSIA MMA".
  The brief for this demo is boxing only.
- **Expected**: the demo either says boxing only or makes clear the grappling trades are the *world* and not the game yet.
- **Blame**: `scripts/TitleBoardPanel.gd:118` (the eyebrow line) + the market/city read-outs
  (`scripts/creation/MarketCard.gd`, `CreationFlowPanel._country_readout_lines`).
- **Stills**: `01_title.png`, `03_country_cyprus_read.png`, `04_city_step_nicosia_unpicked.png`.

### P9 - The club HUD ships a placeholder the player can read (LOW-MEDIUM, polish)
- **Did**: arrived in the club and read the bottom strip.
- **Saw**: `THE DAY'S NEWS LANDS HERE` as the day-feed placeholder, next to the fighter strip and the "End last block with
  stamina 30+" chip.
- **Expected**: day one of a new career should carry a real first-day line (the gym name, the fighter's first session, the
  welcome), not a placeholder string.
- **Blame**: the day-feed default text in the club shell (`scripts/ShellChrome.gd` bottom strip).
- **Still**: `12_club_first_arrival.png`.

### P10 - The first morning's plan is drawn, readable, and completely disconnected from what the day does (MEDIUM)
- **Did**: read the 9 blocks (06:00 30m Guided / 06:30 60m Heavy Bag Hard / 07:30 30m Double End Bag / 08:00 45m Ring Spar
  TECHNICAL / 08:45 30m Recover / 09:15 60m Strength / 10:15 45m Cardio / 11:00 30m Stretch) and the projection row
  (`Proj. Stamina 95/100 · Proj. Strain 5/100 · Coach Minutes 165/240`).
- **Saw**: no feedback loop from that board to anything I could then look at - after START DAY the board is simply replaced
  by the next morning's identical board (and the week review then denies the training happened, P3).
- **Expected**: the plan's *projection* row to be the promise and the day to be the receipt (gains per block, attrition,
  the station focus card).
- **Blame**: the morning board (`scripts/ui/DayPlanPanel.gd`, its per-block FOCUS picker at :368-383) and the club day
  (`GymClub3D` day_state, the station FOCUS CARD at `GymHall3D.gd:3958-3970`) not meeting in a screen the player sees.
- **Still**: `08_club_morning_plan_coach_modal.png`.

### P11 - The route to a fight is named on a screen that does not have it (MEDIUM-HIGH, navigation)

(The list runs to eleven because "find a fight" is a task in the brief, and this is what a player meets trying it.)
- **Did**: finished a week, read the review's instruction, went hunting in the club; then pressed Home, Scouting and
  Training and dumped the visible controls at each stop (two hidden walks).
- **Saw**: the week review says "Nothing booked yet - **find a fight in Fights**." (`scripts/WeekReviewPanel.gd:1085`). The
  club's own tab row, measured in-game, is `Home | Fighters | Training | Scouting | Staff | Rankings | Finance` - there is
  no Fights entry; the shell's nav table does carry one (`scripts/ShellChrome.gd:26`, `["calendar", "swords", "Fights"]`),
  and the club HUD replaces that row while the club is up. The only in-club pointer to a bout is the HUD alert
  `NO BOUT BOOKED · OFFERS FIT THE DIVISION` (`scripts/GameState.gd:17459`). Pressing Scouting swapped the board to a real
  SCOUTING screen (3 Cypriot candidates with ask/fee/flags) - so the tabs work; there is simply no Fights one.
- **Expected**: the review's instruction lands on a control the player can press where they are reading it (or the review
  names the button that exists).
- **Stills**: `25_club_home_board.png` (the club Home board: day plan + coach modal + the tab row), `26_club_scouting_board.png`
  (the Scouting tab, which does swap the board).

## 3. BUGS (repro steps, separately from the ratings)

**B1 - Week review denies training that ran.**
1. New career -> Cyprus / Nicosia -> OPEN GYM. 2. On the morning board dismiss `NOT NOW`. 3. `START DAY`.
4. Speed `[Fast]`. 5. Wait for the week review.
Saw: `Week 1 in review`, `Your fighters: Nobody trained this week - set a programme in Training.`
Expected: the fighter's gains for the week (the plan ran with Coach Minutes 165/240).
Stills: `09_club_after_start_day.png`, `11_week_review_nobody_trained.png`.

**B2 - Three creation clicks lost while the board rebuilt.**
1. New career -> type "cyprus" -> Enter -> CHOOSE MARKET (the board's first freeze, P1).
2. Immediately click the city card, then ENTER CITY.
Saw (harness record): the city click and the ENTER CITY click fired in the SAME frame 16 ms apart (`press_ms 17567` and
`17568`) because both had been queued behind the stalled frames; the city selection then had not been applied when ENTER
CITY was pressed, so the step did not advance and the click was silently lost.
Expected: a click during a board transition is either queued and applied, or refused with something visible; it is not
silently eaten.

**B3 - The routed gym step draws no floor preview (see P7). Repro'd TWICE, two separate hidden walks.**
1. New career -> Cyprus -> Nicosia -> ENTER CITY. 2. Wait 14 s, 26 s (run 1) and again in the second day-watch walk.
Saw: flat grey centre frame both times (`06_gym_step_blank_preview.png`, `06b_gym_step_blank_preview_run2.png`); the
direct-mount probe on the same build renders it (`s238_probe_gym_step_t6.png`).

**B4 - The market-list arm of the country step has no search field and no globe.**
With `globe_picker` off (any `--script` run without `as_game`: `scripts/CreationFlowPanel.gd:241`), the country step is a
175-card list with a SORT strip - which is fine - but every tool/most tests run in that arm and the walk's `type market|`
command then finds no field at all (`LIVE NO-FIELD 'market'`). Not player-facing in the shipped game; recorded because it
makes every switchless capture of this step lie about what the player sees.

**B5 - `NOT NOW` does not clear the coach offer.** See P5: pressed, still on screen 1.5 s later
(`08b_morning_plan_same_modal.png`) and still covering the floor 36 s into a running day
(`16_day_floor_modal_over_it.png`). Either the button does nothing or the next candidate is queued instantly.

**B6 - The dev booking path finds no bookable fight with the game's switches ON.**
1. `Tools/godot_hidden.ps1 --path Godot --script tools/render_setpiece.gd -- as_game`
2. Saw: `ERROR: render_setpiece: no booked fight - NO DEVJUMP EVENT WEEK PRODUCED A BOOKABLE FIGHT` (render_setpiece.gd:42,
   DevJump's `_book_event_in_week` -> "NO BOOKABLE BOUT").
3. Control: the same command WITHOUT `as_game` renders all five set-piece views.
So `DevJump`'s booking replay works in the switchless arm and fails in the arm the game actually plays - which is exactly
the arm every player-fidelity capture uses. Nothing in the player path failed here; the instrument did.

## 4. TOP 5 IMPROVEMENTS (rating gained per unit of work)

1. **Make the country step's intended path work on the first try** (raise `MARKER_HIT_PX`, kill or slow the idle sway,
   and put the market list behind a bigger, labelled control). One afternoon; it is the first screen of the game and the
   only screen where I failed to act three times in a row. (`GlobePicker.gd:28-30,407`.)
2. **Make the money numbers agree before the first hour** - derive the club HUD's runway net from the same source as the
   creation take and the week review, or hide the HUD's "+$881/wk / runway: not falling" until a week has settled. Tiny
   change, removes the exact sentence a reviewer will quote. (`GymStepPanel.gd:249`, `ShellChrome.gd:812`,
   `WeekReviewPanel.gd`.)
3. **Get the coach offer off the day plan** (queue it as a chip on the club HUD, or show it after START DAY). One move of a
   modal; the plan and its START DAY become readable at a glance. (`InterviewPanel.gd:171`.)
4. **Show the day.** Default the club to Play (not Fast) for the first day, and make the day plan close when the day
   starts so the floor, the station focus card and the gain bubbles are what the player watches. (`ClubSpeedControls.gd`.)
5. **Fix the week summary's fighter tally** (B1): whatever the self-running day writes, the review must read it - and if
   the day genuinely trains nobody, say which block failed rather than "set a programme in Training" over a board the game
   itself filled in. (`WeekReviewPanel.gd:970-976` + the week tally it reads.)
6. **Make the review's "find a fight" line point at a control that exists** (P11): give the club's tab row a Fights entry
   (the shell already has the id and the `calendar` route) or turn the `NO BOUT BOOKED` alert into the button. Text-only
   change plus one tab, and it is the difference between a new player finding their first bout and giving up.

## 5. WHAT ALREADY FEELS GOOD (keep)

- The **title board**: warm gym still, brass type, one loud action, settings and saves in plain sight (`01_title.png`).
- The **country read-out** (`03_country_cyprus_read.png`): tier, combat popularity, talent depth, the disciplines with
  numbers, the governing bodies, the top four boxers, the hub dossier - more information per screenful than most
  management sims manage, and it reads.
- The **city card** (`04/05`): rivals, promotions, events, "sharing the city" with real gym names.
- The **club arrival** (`12_club_first_arrival.png`): the iso gym with the ring and the zone labels (TIMING BAGS,
  FOOTWORK, STRETCH, STRENGTH) behind a HUD that is legible over 3D.
- The **morning plan** (`08`): nine timed blocks, station, intensity, COACHED chips, the projection row
  (Stamina / Strain / Coach Minutes) - this is the right shape for a boxing gym week.
- The **coach offer** itself: TEACHING 9 (Fair), pay, the runway arithmetic, and "WHAT HE IS KNOWN FOR - PICK ONE"
  (Regional / Film coach / Pad man / Conditioner) - a real decision with a readable consequence.
- The **week review layout** (`11`): NET, profit-week flag, In / Bills columns, the bill countdown, "Next week" line and
  button. The screen is good; only its verdict (B1) is wrong.
- The **training read-out** in the club HUD (GAINS / RATE: BUILDING / ATTRITION / FATIGUE / WEAR) - the single best
  "management sim" line in the build - and in the focus-tool still the same block grown into the week's real meter
  (`POWER +58.2 TECHNIQUE +21.8`, `GAINS ▲ +80.0 pts`).
- The **station FOCUS CARD** (`21/24_focus_card_*.jpg`) with the gain bubble that names the attribute it just grew
  ("IT CLICKED - POWER"), the **RING REPORT** card (`23_ring_report_card.jpg`: `LANDED 64%`, `GUARD: 11 clean shots taken`,
  "He takes too many clean shots - double-end, SLIPS.", `[G] GOT IT`), and the **COACH task list** on the left with its bar.
- The **corner card** and the **result screen** (section 6) - the two best screens in the build.
- The **CHANGE THE PLAN nudge** (`22_morning_change_the_plan_nudge.jpg`): a COACH note, "CHANGE THE PLAN: 3 days of POWER
  SHOTS at the heavy bag - the gains are flattening.", with the day's multiplier down to 0.85 - repetition has a voice and
  a price. (It takes three deliberate same-focus days, so a first-week player will not meet it; that is the right order.)
- The **creation step chips** (1 THE COUNTRY / 2 THE CITY / 3 THE GYM with MARKET + CITY chips at the top right) - the
  player always knows where they are and what is committed.

## 6. The fight leg - what was actually captured (and with what)

No career fight night was PLAYED in this pass: booking a bout through the club UI never happened, so nothing below is a
played chain. What is below is three instruments on the real fight room and the real screens, and every claim says which.

**a. In-bout frames** - `record_room.gd` + `still_framing.save_if_framed` (`as_game bench=1 bench1=1 demo=1 guard_stills=1
seed=94301`): `13_fight_guard.png`, `14_fight_punch_midflight.png`, `15_fight_contact.png`.
Read off the frames, only what is visible:
- The **broadcast HUD is the strong half**: `VANCE` / `MILLER` corner cards with record, a heart-rate number (133 / 166 BPM)
  and a live waveform each, the round clock `ROUND 1 | 2:56` with `1X / 2X / 4X` pace buttons, the corner state word
  `SETTLED`, the player's three intervention icons with `3 left`, and `THROW TOWEL` bottom-right.
- The **camera is the weak half**: it looks down at the mat from behind/above the near ropes, so the men sit small in the
  middle of the frame and the near ring line cuts across the bottom-left; no crowd, no venue dressing, no ring post in
  frame. (This room was recorded without a venue spec, so it proves the CAMERA and the HUD, not the career venue art.)
- Both men read as **boxing**: gloves up in front of the face, feet staggered; the guard frame (13) and the contact frame
  (15) look like a real exchange rather than a pose swap.

**b. The corner between rounds** - `tools/corner2_still.gd` (windowed hidden, the house's own S159 tool) drove a real bout
to its first break and saved `17_corner_card_between_rounds.png` (and `17b_corner_card_jobs.png`): `BETWEEN ROUNDS · THE
CORNER · R2`. The card is the best-designed screen I saw in the whole build: a 45 s rest clock with `10 / 45 s USED`, `TANK
96% (recovery)`, `CARDS DOWN 0-1`, the coach's line ("Keep the jab in his face and stay long."), three advice rows keyed
`HIM` / `YOU` / `GAS` each carrying its own reasoning and an `ADOPT` button (BOX AND MOVE / BOX AND MOVE / PLAN), the eight
tactic buttons underneath, the S268 cut system showing as `1 CLOSE - Left eye is closing` and `2 BLEED - Cut on the right
brow - blood is running into the eye` with CALM HIM DOWN / FIRE HIM UP / THE TRUTH beside them, then the gold `SEND HIM
OUT`, `THROW THE TOWEL` and `VIEW JOBS`.
Note for the read: this still came from the tool's own bout (not the career fight night) - the round is R2, which at least
proves a bout survives into a second round and reaches a real break.

**c. Fight night + result screens** - `tools/render_setpiece.gd` (the house renderer; it plants a payload from a real
`FightSimulation` run the way the ring hands one over): `18_fight_night_screen.png`, `19_fight_result_screen.png`,
`20_fight_week_screen.png`.
- **Fight night**: `TALE OF THE TAPE` with both corners' portraits and 18 comparison rows (age, height, weight, reach, leg
  reach, stance, division, fighting style, born, record, fights, wins KO / submission / decision, finish rate, avg fight
  time, title fights, current streak, debut, last fight), the edge call-outs under it, and `FIGHT CARD` / `BEGIN FIGHT` /
  `SIM THE FIGHT`. Caveat: this render's fixture pairs a boxer with an MMA fighter and prints `DISCIPLINE CLASH: BOXING VS
  MMA` - it demonstrates the screen, not the demo's matching.
- **Result**: `COYLE def. VARGAS / KO · R2 3:00`, the KO sentence, `THE CARDS - NO SCORED ROUNDS - THE BOUT ENDED BY KO IN
  ROUND 2`, the settlement table (PURSE $42,000, WIN BONUS $12,000, PERFORMANCE BONUS $8,000, GATE SHARE $5,400, EXPENSES
  -$3,100, WEIGHT FINE $0, `TO BRUNO VARGAS $64,300`), `WHAT THE NIGHT CHANGED` chips (`+14` fame, `$8000`), `BACK HOME`.
  The one wrong note is `TO THE GYM · NO MANAGER CONTRACT FILED · $0` - in the boxing demo the player IS the gym, so the
  screen that should close the loop tells them their gym earned nothing.

Rating consequence: "fight watchability 6/10" is the HUD earning its marks and the camera/venue losing them; the corner
(8/10) and the result screen (8/10) are the two best screens in the build. A played career bout at a real venue remains
the next pass.

## Appendix - stills in this folder

| File | What it is |
|---|---|
| `01_title.png` | BootRoot title board (note: "A BOXING & MMA MANAGEMENT GAME"). |
| `02_country_globe_nothing_chosen.png` | The country step as the player gets it (globe, ~6 px markers, sway). |
| `03_country_cyprus_read.png` | Cyprus committed, read-out filled. |
| `04_city_step_nicosia_unpicked.png` | City step, nothing chosen, ENTER CITY disabled. |
| `05_city_selected.png` | Nicosia selected, ENTER CITY gold. |
| `06_gym_step_blank_preview.png` | THE GYM step in the routed flow - empty grey centre frame (P7/B3). |
| `06b_gym_step_blank_preview_run2.png` | The same step, second walk - same empty frame (B3 repro). |
| `07_city_step_arrival.png` | The frame the city board lands on (P1's backdrop). |
| `08_club_morning_plan_coach_modal.png` | Morning day plan with the coach interview over it (P5). |
| `08b_morning_plan_same_modal.png` | 1.5 s after pressing NOT NOW - the same modal is still there (P5). |
| `09_club_after_start_day.png` | After START DAY + [Fast]: nothing watched, P4. |
| `10_week2_morning_coach_offered_again.png` | Week 2 morning: same plan, coach offered again, GAINS +0.0. |
| `11_week_review_nobody_trained.png` | Week 1 review: "Nobody trained this week" (P3/B1). |
| `12_club_first_arrival.png` | First arrival in the club (HUD, placeholder news line, P6/P9). |
| `13_fight_guard.png` | Live fight, guard moment (record_room + still_framing, as_game, seed 94301). |
| `14_fight_punch_midflight.png` | Live fight, first punch mid-flight. |
| `15_fight_contact.png` | Live fight, first landed contact. |
| `16_day_floor_modal_over_it.png` | The day running at Play: fighter walking, meters ticking, coach modal over the floor (P4/P5). |
| `17_corner_card_between_rounds.png` | The real corner card at a live bout's first break (tools/corner2_still.gd). |
| `17b_corner_card_jobs.png` | The corner card's jobs state (same tool). |
| `18_fight_night_screen.png` | Fight-night screen, tale of the tape (render_setpiece.gd fixture). |
| `19_fight_result_screen.png` | Result screen: KO R2, settlement table, what-the-night-changed (fixture). |
| `20_fight_week_screen.png` | Fight-week screen (render_setpiece.gd fixture). |
| `21_focus_card_power_shots.jpg` | The station FOCUS CARD at the heavy bag + the week meter + a coach task list (house focus tool, fresh run). |
| `22_morning_change_the_plan_nudge.jpg` | The COACH "CHANGE THE PLAN" nudge after three same-focus days. |
| `23_ring_report_card.jpg` | The RING REPORT card after a spar. |
| `24_focus_card_combinations.jpg` | The FOCUS CARD on the COMBINATIONS pick (the other branch). |
| `25_club_home_board.png` | The club Home board: day plan + coach modal + the tab row (P5/P11). |
| `26_club_scouting_board.png` | The club's Scouting board (the tabs do work; there is no Fights one). |
| `s238_probe_gym_step_t6.png` | Control: the same gym step mounted directly - preview renders. |
| `fight_frames/` | Raw fight frames as saved by record_room before the curated copies above. |
---

# ROUND 1 (S270, task ZIVA9) - the coach offer stops covering the game

The operator's S270 brief (research/TASK_ZIVA9.md) asks for every row of section 1 to reach 9/10, one fix at a time, with
evidence after each, and nothing inflated. This is the first loop pass. Files I own only: the fight, the corner, the gym day
loop, the coach offer's placement, the HUD. Cursor #288 files, Claude's s270-b1 week-review files and MetaHumanRig.gd are
off-limits and are recorded as proposals instead.

## What was fixed

**P5 - the coach offer covered the day plan and the middle of the floor.** `08_club_morning_plan_coach_modal.png` showed the
interview card sitting dead centre over the plan rows' right-hand columns (the cue and the S268 FOCUS picker) and over the
fighter the player is supposed to be watching. Two edits, mine:
- `scripts/InterviewPanel.gd`: the coach-hire card now builds at its own narrower width (`const COACH_W := 360.0`, applied
  through `static var card_w`) instead of the interview's 520, so it no longer needs the middle of the screen.
- `scripts/GymHall3D.gd`: `show_coach_hire` now mounts through `_mount_hire(panel, true)`; the `dock_right` branch anchors
  the card to the canvas bottom-right (18 px margins), clear of the plan board (right edge 1510) and of the coach note card
  at top-right.
Evidence: `27_morning_plan_focus_pickers_visible.png` (all five plan columns readable - station, FOCUS, cue, COACHED,
intensity - with the offer docked at the right edge) and `28_day_running_floor_clear.png` (the day at Play with the whole
floor, the boxer and the objective card visible, the offer covering only the strength/cardio corner).
Tests after the change (all house runs, one at a time): `tests/interview_panel_test.gd` 28 checks / 0 fails,
`tests/gym_hall_mornings_wired_test.gd` 19/0, `tests/morning_ticker_test.gd` 12/0.

## ROUND 1 RATINGS (same reviewer, same scale as section 1; section 1 is kept as the pass-1 record)

| Area | S267 pass 1 | Round 1 | Evidence now | What still holds it back |
|---|---|---|---|---|
| First 5 minutes | 6/10 | **6/10** | unchanged (`01-07_*`) | P1 build freeze, P2 6 px globe markers, P7 blank gym preview - all Cursor #288 files, not mine to edit |
| Gym floor loop | 5.5/10 played | **7.5/10** | `28_day_running_floor_clear.png` (full floor + boxer + objective card, day at Play) | the day still shows `GAINS +0.0` and no per-day feedback inside the day; the news strip still reads THE DAY'S NEWS LANDS HERE |
| Station focus (S268 FOCUS CARD) | 7.5/10 | **8/10** | `27_morning_plan_focus_pickers_visible.png` - the FOCUS column is now visible on the plan a player actually gets | a player still has to know to open the station card; nothing on day one points at it |
| Fight watchability | 6/10 | 6/10 (Round 2) | - | - |
| Corner between rounds | 8/10 | 8/10 (Round 2) | - | - |
| Post-fight result | 8/10 | 8/10 | unchanged | not in this round's files |
| Menus / HUD | 7/10 | **7.5/10** | `27`/`28` (the HUD now reads without a modal on top of it) | P9 placeholder line, P6 money numbers that disagree |
| Overall | 5.5/10 | **6/10** | - | the two rows the operator asked about (fight, corner) are next |

Honest note: nothing else was touched, so the four rows left at their old grade are exactly that - the same grade, not a
re-graded pass. Round 2 takes the fight leg (recorded bout evidence) and the corner.

---

# ROUND 2 (S270) - the fight leg and the corner, measured

Round 2 takes the two rows the operator asked about. The fight leg needed a bout watched end to end, so it was recorded
rather than eyeballed, and the corner's own defect (the card merging into the ring it sits on) was fixed and A/B'd.

## What was recorded (and with what)

- **Bout A** - `tools/record_room.gd`, 6000 frames at 30 fps (`as_game demo=1 bench=1 bench1=1 seed=94301`), one full
  three-minute round live, then the between-rounds break. Sheets: `s270_bout1/01_bout_frames_sheet.png`,
  `s270_bout1/02_between_rounds_sheet.png`; full frames `31_bout_full_frame_t45.png`, `33_break_card_full_frame.png`.
  The bout ran the full round with no early stoppage (the S192 early-TKO did not recur), and the corner holds the clock at
  180.02 s exactly as the S267 clock contract says.
- **Bout B** - the same bout again (6150 frames) after this round's fix, for the A/B below.
- **A new instrument**: `cam_log=1` in `tools/record_room.gd` prints, every 30 drawn frames, where the camera actually is
  (world position, fov, the fit's own distance, the dolly, and the distance to each man's head). It is the instrument the
  framing question needed and it cost one 600-frame run.

## What the camera measurement says (the fight row's real blocker)

Measured (600-frame run, `cam_log=1`): camera at **y = 5.70-5.76 m** over a 1.27 m deck - about 4.4 m above the canvas -
with a constant fit distance of 6.75 m, the dolly at 1.76, and the men's heads 4.5-5.8 m away. On the movie frames the men
read at **24-37% of a 1080-line frame height** (`41_bout_full_frame_t45`/`32_bout_framing_probe`), with the ring mat filling
most of the picture. Cause, named in the code: `_camera_clear_pair_view` (`scripts/FightWorldLiveScreen.gd`) clamps the
camera INSIDE the contest floor (`RingSpace.clamp_to_floor(..., _contest_half_m - 0.35)`) and then lifts it 0.2 m per
iteration until both men fit inside 84% of the frame, capped by `CAMERA_MAX_PITCH_DOWN_DEG` (45 deg, S161's cap). A camera
confined to a 6.7 m ring looking at two men up to 2.6 m apart has nowhere to go but up - so the shot reads as an in-ring
crane, and the `standing` shot's authored 1.35 m ringside height never survives.

## What was fixed (mine)

**The corner card no longer merges into the ring it sits on.** The between-rounds card is a warm dark brown drawn over a
mid-grey floor (`33_break_card_full_frame.png` - the card and the mat read at almost the same luminance). Two edits, mine:
- `scripts/FightWorldLiveScreen.gd`: a `CornerDim` ColorRect (`Color(0.02, 0.03, 0.05, 0.55)`) added as the FIRST child of
  the corner layer, so both corner cards draw above it, its visibility bound once to the pit card's own
  (`visibility_changed` -> `_sync_corner_dim`), so nothing has to remember to hide it.
- Measured A/B (`30_corner_dim_ab.png`, two runs of the same bout, same seed, same frame):
  floor to the left of the card **73.7 -> 36.5** at t=181 s and **80.2 -> 39.7** at t=190 s (mean grey), while the card's
  own region is byte-for-byte unchanged (**56.9 -> 56.9**, **57.1 -> 57.1**). The card is untouched; the ring around it
  halves in brightness and the card reads as the only lit thing on screen.

## ROUND 2 RATINGS

| Area | Round 1 | Round 2 | Evidence now | What still holds it back |
|---|---|---|---|---|
| Fight watchability | 6/10 | **6/10** | `31`, `32`, `33`, sheets in `s270_bout1/`, `cam_log` numbers above | the camera crane and the bare venue; both are look changes, so they are proposals R1/R2 below, not edits. The fighters, stances, motion and the broadcast HUD are 8-9/10 as they are |
| Corner between rounds | 8/10 | **8.5/10** | `30_corner_dim_ab.png` (measured) + `33` (before) | the card's body diagram is a plain mannequin, the ring behind it is empty (no stools/corner shot), and THROW TOWEL appears twice |
| Menus / HUD | 7.5/10 | 7.5/10 | unchanged | the new defect below (a placeholder icon in the pace row) is small but visible |
| Gym floor loop | 7.5/10 | 7.5/10 | unchanged this round | Round 3 |
| Overall | 6/10 | **6.5/10** | - | the fight is the game's showcase and it is the row furthest from 9 |

## Defects found this round (evidence in this folder)

- **B7 - a placeholder icon in the fight HUD's top bar.** A blue-tinted square with a white cross (IconKit's own
  `_placeholder`, the fallback `line_icon` returns when an SVG will not load) sits between the pace buttons and the right
  corner card at about (1075, 37), and the same mark sits left of the THROW TOWEL button at the bottom
  (`07_xz_top.png`, `08_xz_bottom.png`). Not fixed: it needs the widget identified live, and it is an icon-resolution
  question, not a layout one.
- **B8 - arena props cross the fight's picture.** A large white diamond-plate slab (a ring step/apron piece) floats at the
  rope line and a truss column cuts across the ring in both runs (`31`, `32`, and the sheets). Visible in the player's own
  picture, not just in a tool's frame.

## Proposals (new looks/mechanics - the operator's call, not mine to land)

- **R1 - a broadcast camera outside the ropes.** Let the live camera sit beyond the rope line at the shot's authored
  ringside height (1.2-1.5 m above the canvas) and back off along the away vector instead of climbing inside the ring;
  keep the 45 deg cap as a guard, not as the working angle. Measured target: camera y 5.7 -> ~2.5-3.0 m, men 24-37% ->
  45-60% of frame height, mat below 50% of the picture. A/B cost: two 600-frame recordings plus `cam_log=1` (about four
  minutes of machine time).
- **R2 - the venue.** The recorded hall is empty grey: no crowd, no apron dressing, no lighting on the ring. This is an
  art pass, and it changes what the demo's showcase looks like.
- **R3 - the corner diagram.** The card's body figure is a plain silhouette; a damage map (regions lit by the round's
  landed work) would make the card's own story readable at a glance.
- **R4 - the break is an empty ring.** The two boxers are off the canvas during the break and the player watches a bare
  mat for 45-60 s behind the card (`30`, `33`). A corner/stool shot (or keeping the men on their stools in frame) would
  make the minute watchable without new mechanics.

---

# ROUND 3 (S270) - the day loop's bookkeeping, root-caused

Round 3 went after the lowest row (gym floor loop) by walking the player's own path four times instead of reading more code:
creation -> OPEN GYM -> NOT NOW -> START DAY -> the day at Play -> [Fast] -> week review, then opening the screens the
review points at. The row does not move this round, but the reason it sits at 7.5 is now named and reproducible.

## What the player's own path shows

1. **The day does run.** `37_day_running_with_plan.png`: the morning board's template ("Camp Heavy", eight blocks, five
   COACHED) is what the floor follows - the fighter walks, the wall clock moves 6:00 -> 6:37 in a minute of Play, the goal
   card reads `DAYS LEFT 28 / AT RISK / BOOKED FIGHT 0/1 / CONDITIONING 64/65`.
2. **The TRAINING page says none of it happened.** `35_training_page_nobody_programmed.png`, opened from the club right
   after that day started: the banner reads **"NOBODY IS PROGRAMMED - EVERY DAY IS REST UNTIL YOU SAY OTHERWISE"**, the
   week strip is REST for all seven days, the header reads **PLANNED 0/1**, and the row's LOAD is `WORK 0 - REC 0 - REST 7`.
3. **The week review agrees with the page, not with the floor.** `36_week_review_nobody_trained.png` (and `39_` from a
   separate run): **"Nobody trained this week - set a programme in Training."** So the review and the page are consistent
   with each other and both contradict the day the player just watched run.
4. **The review's own next step points at a screen that does not exist.** "Nothing booked yet - find a fight in Fights." -
   there is still no Fights tab in the club HUD (S267 P11; `ShellChrome.gd:26` has the tab, the row a player can click does
   not).
5. **The game's own [Fast] press is a hole in the day.** `38_after_fast_blank_screen.png`: from the live day in (1), the
   frame after [Fast] is a flat grey screen (no HUD, no scene), and the run continues into the week review from there.

## The root cause (named, with the two stores)

The player's morning plan and the game's bookkeeping are two different stores, and nothing in the player's path writes the
second one:

- **The day plan** - `scripts/GymHall3D.gd`: `day_plan`, `_dp_day_plans[day_key]`, built by the morning board and
  committed by `day_plan_start(plan)` when START DAY runs. This is what the floor follows, what the meters read per tick,
  and what `_end_visit()` files as `lived` (plan, gains, stamina, strain, minutes).
- **The week programme** - `scripts/GameState.gd`: `athlete["week_program"]`, seven entries, written only by
  `GameState.set_week_program_day()` (its callers are the Training page's drag grid and `clear_week_program()`). The
  Training page (`scripts/TrainingHubPanel.gd`, reading `GameState.get_training_hub()`), the "PLANNED x/y" header, and the
  week review are all built on this store.

A player who never opens the Training page's grid therefore trains every day, watches it on the floor, and is told by the
game that nobody trained - which is the S267 finding P3/P4 ("Nobody trained", "gains +0.0") reproduced end to end in the
player's own path, and the reason the gym-floor row cannot reach 9 yet.

## Proposed fix (NOT landed - a data change with a balance risk, so it is the owner's call)

Two candidate shapes, and I did not pick one unilaterally:

- **File the day into the programme.** `GymHall3D.day_plan_start(plan)` could call
  `GameState.set_week_program_day(athlete_id, weekday, focus)` with the day's dominant work focus (the day plan's station
  kinds map onto the programme's four work focuses: heavy_bag / speed_bag / double_end_bag -> `bags`, ring_spar -> `ring`,
  strength -> `strength`, cardio -> `cardio`, stretch / rest / physio -> `recovery`). **Risk:** a programmed week applies
  its own day slices to the sim (the comment at `GameState.gd:8490` says the remaining day slices ride along), so writing
  the programme while also running the day plan may double-count gains. That needs a balance measurement, not a quiet edit.
- **Or count filed days in the review.** `WeekReviewPanel` (Claude's file this round) could count the days the club filed
  through `GymHall3D._end_visit()`'s `lived` record instead of the programme. That is the smaller change and it matches
  what the player actually did, but it crosses into another agent's file.

Files involved: `scripts/GymHall3D.gd` (mine), `scripts/GameState.gd`, `scripts/TrainingHubPanel.gd`,
`scripts/WeekReviewPanel.gd` - three owners, which is why this round records it rather than landing it.

## ROUND 3 RATINGS

| Area | Round 2 | Round 3 | Evidence now | What still holds it back |
|---|---|---|---|---|
| Gym floor loop | 7.5/10 | **7.5/10** | `35`, `36`, `37`, `38`, `39` | the bookkeeping contradiction above: the floor trains, the game says nobody trained. Root cause named; the fix needs the programme/filed-day wiring settled by its owners |
| Day watchability | - | **6/10** | `37` (live, readable) vs `38` (flat grey after [Fast]) | [Fast] can leave the day as a grey frame; the day's own per-minute feedback is still only the meters' tick |
| Menus / HUD | 7.5/10 | 7.5/10 | unchanged | P9 placeholder (Cursor's `FloorHud2Widgets.gd` / `HudV3Widgets.gd`), P6 money numbers, P11 no Fights tab |
| Fight watchability | 6/10 | 6/10 | unchanged | proposals R1/R2 |
| Corner between rounds | 8.5/10 | 8.5/10 | unchanged | proposals R3/R4 |
| Overall | 6.5/10 | **6.5/10** | - | the loop reads well and books badly; that contradiction is now the single highest-value fix in the build |

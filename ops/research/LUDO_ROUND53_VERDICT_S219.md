# LUDO ROUND 53 VERDICT (S219, 2026-10-13) - New Career screen, one in-game menu system, sandbox promoter + debt numbers

Asked: `LUDO_ROUND53_ASK_S219.txt` (13.4k chars + the New Career gym.png), chat "Gym Management Screen".
Replies verbatim: `LUDO_ROUND53_REPLY_S219.txt` (29,337 chars, cut inside Part B) + `LUDO_ROUND53_REPLY2_S219.txt` (24,496, "continue").
Why: operator C58 on the New Career still - "Ask forludo approval , this doesnt look like finished , askludo for ideas on ingame
menu presentation"; STORYPARITY1 needs Ludo's numbers (roadmap next action 4).

## A. NEW CAREER, STEP 3 (THE GYM) - TAKE IT, with corrections
TAKEN:
- Layout: left = name fields + START chips, a 4-tile money strip, then FLOOR (780 px) beside ROSTER (584 px); RIGHT COLUMN (416 px) =
  live 3D preview of the club (top, 320 px) + the selected START's pitch card (320 px) + OPEN GYM (gold, 64 px) + save note. No empty
  right column any more.
- START pitch cards (title, badge, two pitch lines, what is on/off): The House That Holds (CANONICAL - Mara Solano, Calder House,
  story = tutorial), Guided Sandbox (ONBOARDING - no story, guidance on), Open Sandbox (SIM PURIST - no story, no guidance).
- Equipment tiles become "blueprint cards": icon + name + size, a 10-step condition bar (green 80-100 / amber 50-79 / red < 50 with
  the wear warning), weekly upkeep, what it trains; hover = teal border + tooltip. EMPTY floor is never a grey void: one hatched,
  dashed-teal "+ INSTALL EQUIPMENT: n m2 AVAILABLE" block.
- ROSTER per start: story = Mara Solano only (women's, her real stats and her certified moves); Guided = ONE procedural boxer
  (player picks men's/women's); Open = TWO procedural boxers (one raw young fast amateur, one older club fighter with chin/power).
  BOXING ONLY - no MMA/wrestling fighters anywhere in the boxing demo (the current Nasir/Rico MMA/Rafael WRES list is a defect).
- Motion: header + strip slide in (450 ms), tiles/roster stagger in (30 ms per tile), START switch 200 ms cross-fade, OPEN GYM press
  then a wipe into the live gym.
- Ludo's 10-item checklist -> the screen's test (boxing purity, story default + Mara present, no unstyled empty slots, every tile has
  a condition bar, cash/upkeep sums, preview renders, OPEN GYM saves).
CORRECTIONS (Claude):
1. RUNWAY: Ludo wrote 68.1 weeks = $25,000 / $367. The game's real weekly burn includes staff and running costs (~$1,971/wk in
   testing): runway comes from the game's own burn calculation, never cash / upkeep.
2. Mara's numbers and moves come from the cast data (first_hour.json / StoryCast), not Ludo's invented 38/44/42.
3. Weights in kg (the game's unit), not lbs.
4. ADVANCED keeps only the two switches that exist (Story, Guidance). Ludo's extra options (starting economy, promoter aggression,
   medical severity) go to the backlog - new scope, not this screen.
5. No dev text on a player screen (Ludo's footer "Ready to initialize Godot 4.7.2 Simulation Engine" is dropped).
6. PALETTE - OPERATOR'S CALL (taste): Ludo's whole system is NAVY (#0B101D base, #121A2B panels, gold primary, teal selected,
   crimson danger). Our creation screens are WARM DARK BROWN + yellow; the fighter profile and fight HUD are already navy. One palette
   for the whole game. Claude recommends Ludo's navy (it matches the screens the player sees most); the board question asks.

## B. ONE IN-GAME MENU SYSTEM - TAKE IT as the UISYS1 reference
- Layers: 3D gym (always live) / persistent shell (top bar 64 px + left dock 80 px) / workspace (full canvas with the 3D gym blurred,
  OR a 640 px right slide-over drawer with the gym live) / centred modal (decisions only: story cards, contracts, debt, towel) /
  toasts + tooltips.
- Type scale at 1080p: 24 / 16 / 13 (tabular numbers) / 11 / 10 px. Colour roles as above.
- Per-screen fixes (3 each: hub, profile + tree, fight week, live fight HUD, post-fight) and the 22-component MENU KIT (BtnPrimary,
  BtnSecondary, BtnDanger, CardSurface, MetricTile, AttributeBar, BodyWearMap, TechniqueNode, SegmentedControl, SlideDrawer,
  ModalDialog, DataTable, CalendarStrip, ScoutingRadar, BadgePill, CornerTimer, NotificationToast, ... see REPLY2) -> UISYS1:
  build the kit once, restyle one screen at a time; New Career is the first screen built on it.
- NOT taken: "9 player-facing attribute bars" stays what the profile really shows; Ludo's audio cue idea waits for the audio pass.

## C. SANDBOX PARITY (STORYPARITY1) - TAKE IT, with corrections
PREDATORY PROMOTER OFFERS (sandbox, procedural):
- Weekly roll from career week 4: P = 0.04 + distress (cash <= 0: 0.25; <= $2,500: 0.15; <= $5,000: 0.08; else 0) + streak (2+ win
  streak 0.15; won last 0.05; else 0), cap 0.40. Max 1 pending offer, max 1 active predatory contract; cooldown 6 weeks after a
  decline/expiry, 16 weeks after a finished contract.
- Tier 1 terms: advance $3,500-7,500, 3 bouts, promoter keeps 45% of each purse, 70% unsanctioned, opponent +8..+16 above the
  fighter (overall), 50% chance of one hidden clause, offer expires in 3 weeks. (Tier 2/3 rows kept in data for later.)
- Hidden clauses: weight trap, date pulled forward, rematch option at -25% purse, gym pays all medical. TELLS always visible: the
  split vs a normal cut, the stat gap, unsanctioned = higher cut/damage risk. Hidden clauses show only after "SEEK LEGAL REVIEW"
  (-$350).
- Outcomes: win = keep advance + purse share, +prestige/fame, rematch clause fires if present; decision loss = keep advance, morale
  -15; stoppage loss = -$1,200 medical, chin -2..-6 permanent, 60-day suspension; decline = +10 prestige, goodwill -1 with that
  promoter, cooldown.
DEBT EVENT:
- Trigger: cash < 0 at two consecutive weekly ticks -> a blocking decision before the next week.
- LOAN: principal = deficit + $5,000 (min $7,500, max $20,000 at tier 1), 16 weeks, payment = principal/16 + 6% of the remaining
  principal each week. Missed payment: 1st = notice, prestige -50; 2nd = the most valuable equipment is repossessed; 3rd = foreclosure.
- EMERGENCY FIGHT: a short-notice bout 5-9 days out, purse $3,500 + 50% of the deficit (80% paid on signing), opponent Power +6..12 /
  Technique +4..10, stamina -25% from the crash cut, 35% chance of a cut or soft-tissue injury.
- AUSTERITY: upkeep -50% for 8 weeks; meanwhile recovery -40%, equipment wear x2.5, member income -35%, composure -20 in camps.
- After any choice: 3 weeks of immunity; still negative 4 weeks after -> final receivership (no signing/buying; one forced auction
  of half the equipment at 30% of value); negative for 6 more weeks -> the career ends (insolvency screen).
CORRECTIONS (Claude):
1. Ludo's test 4 contradicts his own formula (a $1,650 deficit gives a $7,500 loan, not $10,000): the test uses $7,500 -> week-1
   payment $468.75 + $450.00 = $918.75.
2. Stat names: "overall delta" = the mean of the 9 profile stats; "Gym Integrity" does not exist -> it is gym prestige (+10).
3. Weight-trap clause in kg (+2 kg over the class limit), not lbs.
4. INSOLVENCY ENDS THE CAREER - new scope (round 52 only said a lost bout never ends a run). It is in the board question.
5. Everything sits behind the sandbox path only; the story start keeps its scripted Marcus Vance trap (promoter_trap.json) unchanged.
BUILD (after the operator's OK): STORYPARITY1A pure module (Arena: PredatoryOffers + DebtEvent, Ludo's 7 tests with correction 1,
blind contract tests) -> STORYPARITY1B wiring (cloud Cursor: inbox card, the debt modal, the ledger) -> NEWCAREER2 (Cursor: the
screen in section A on the UISYS1 kit).

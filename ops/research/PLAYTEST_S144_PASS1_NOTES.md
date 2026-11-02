# S144 playtest pass 1 - cold, exported .exe (pck 17:48), empty gym
S01 Title: strong - one obvious primary button (New career), atmosphere photo, tagline. CW 4/4. No issue.
S02 Country (step 1/3): 190 cards A-Z. ISSUES: P1 flag boxes EMPTY on every card (LOW, polish - reads unfinished); P2 no search for 190 countries (LOW); P3 most small countries show identical 46/~50/~54 bars - choice feels arbitrary, nothing says which suits a first boxing career (MEDIUM - first decision has no meaning). Good: step tracker 1-2-3, "nothing committed yet", sort chips.
S03 Country picked: select highlights + side summary, gold CHOOSE MARKET lights. P4 summary does not say what ECONOMY/TALENT/COMBAT do to MY game (LOW-MEDIUM).
S04 City (2/3): London/Manchester/Birmingham IDENTICAL numbers (2 rival gyms, 1 promotion, 0 events) - P5 second choice in a row with no difference to weigh (MEDIUM, approachability: 'meaningful choices'). '0 EVENTS BOOKED' reads as a dead city to a new player (LOW).
S05 Gym (3/3): name prefilled, cash/floor/upkeep tiles, starter floor grid = the "basic equipment" - good. ISSUES: P6 shows "STARTER ROSTER 3" (Dario Duarte, Eli Larkin, Cole Coyle) but the empty-gym start gives NONE - the screen promises fighters that will not exist (HIGH, my S144 switch made it inconsistent - fix with it). P7 4 unlabeled dark squares on the floor grid (LOW - empty slots? say so). P8 boxing gym's floor includes MMA mat + throwing/grappling (LOW, flavour).
S06 RESTART: run 0 had no as_game -> the driver's --script kept the test starters. Rerun with as_game (the player's game). Steps S01-S05 hold (same screens).
S07 HOME, week 1, empty gym (as_game): $25,000, 0 fighters, "No coaches hired". Strong art.
  P9 CRITICAL(FTUE): the primary CTA says "Nobody is booked - 3 fight offers... put a fighter on a card / Open offers" while the player HAS NO FIGHTERS. Nothing says "recruit your first boxer" or where. Task T2 has no signpost. (needed to progress: yes; needed outside knowledge: yes -> HIGH/CRITICAL)
  P10 HIGH: every ICON renders as an empty square in the exported .exe (date, Continue, hotspot markers, office badge, top-right). Reads broken. (Title screen arrow renders; in-game icons do not.)
  P11 MEDIUM: "Fights 3" badge + "3 offers waiting" pull a fighterless player toward offers he cannot take.
S08 Fighters hub: Roster 0 / Training 0 of 0 / The floor / Scouting 'Find and sign new talent' - the recruit path exists, 2 clicks, found by guessing (FUNNEL T2: 2 clicks to the door).
S09 SCOUTING: clear table (potential, ask/w, fee, CAN SIGN, star shortlist), 12 UK candidates, "pick a row" explains the side panel. Good.
  P12 LOW-MED: page title "SCOUTING" doubled/ghosted over the banner image, banner text bleeds ("overcommits to body shots / slow to adjust").
  P13 MEDIUM: a BOXING gym's list mixes judo, kickboxing, wrestling prospects; no discipline filter chip (ALL/SHORTLIST/CAN SIGN/DIVISION GAPS/AT THE TABLE only).
  P14 MEDIUM (economy/realism): 0-0-0 novices ask ~$1,300-1,650 per WEEK + ~$4-5k fee (~$84k/yr) against $25k start; real amateurs are not salaried. One signing + upkeep = ~10 weeks of runway with no income visible yet.
S10 CANDIDATE panel: rating 60 / potential 87 / record / slot fit ('nobody - this is a gap') - good. P15 LOW: 'WEEKS 66' unexplained. P16 LOW: 'WAGE EXCEEDS CURRENT PAYROLL' with payroll $0 is meaningless noise. P17 MEDIUM: no portrait/face of the person you are about to pay $1,614/w for - numbers only (management sims show a face here).
S11 CONTRACT OFFER: wage/weeks steppers, bar 'they want vs offered', SEND / WALK AWAY - clear negotiation. P18 MEDIUM: '$106,524 over 66 weeks' against $25,000 cash, no word on where income comes from (purses? sponsors?) - a new player cannot judge if he can afford ANY signing.
S12 Negotiated: 4x '-' ($25 steps) -> $1,514 ACCEPTED round 1, then SIGN CONTRACT appears. Good loop. P19 LOW-MED: summary keeps the ASK ($1,614 / $106,524) after agreeing $1,514 - stale money line on the screen that decides money.
S13 SIGNED Isabel Anders (\$1,514/w). FUNNEL T2 reached: 10 commands from home (2 to find Scouting by guessing, 8 in scouting/offer). Home now: \$20,458, 1 fighter. The home CTA still pushes "Open offers" (fine now).
  P20 LOW: Monday report shows a coach quote “Quiet week. Leave her.” with NO coach hired - unattributed voice.
  P21 MEDIUM: nothing tells the player that a fighter needs a coach / what a coach does; "Staff room - No coaches hired" is the only hint.
S14 STAFF ROOM: good explanation ('fighters still train but nobody teaches... SCOUTING SIGNS COACHES'). P22 LOW-MED: '0 OF 0 FIGHTERS HAVE A COACH' with 1 fighter signed - stale/wrong count. P23 MEDIUM: no 'Hire a coach' button here - the screen names the place (Scouting) but makes the player navigate there and find the STAFF tab himself.
S15 SCOUTING > STAFF: 6 coaches, boxing ones $1,592-1,934/w. P24 HIGH (economy, to verify over weeks): fighter $1,514 + coach ~$1,600 + upkeep $367 = ~$3,500/w burn vs $20,458 cash = ~6 weeks runway before any purse. Track in the loop table.
S16 COACH Tala Dubois signed (accepted at ask). Payroll $3,106/w, cash $17,274. FUNNEL T3: 8 commands (staff room dead-ends into Scouting>STAFF). P25 MEDIUM: the top money bar stays $20,458 after the signing (scouting header says $17,274) - the cash readout lags until you change screen.
S17 TRAINING: clear week grid + presets; BALANCED one click -> Ring/Bags/Str/Cardio/Ring/Rec/Off, WORK 5 REC 1 REST 1 - good (T4 plan: 2 commands). P26 LOW: flag 'EMPTY BOOK' unexplained. P27 LOW-MED: the hired coach is not shown anywhere on the training screen (who is teaching her?).
S18 FIGHTS > OFFERS (Schedule): "0 OFFERS ON THE DESK" + "NOTHING ON THE DESK - no amateur card in this division this week - the federations run to a calendar".
  P28 HIGH: Home ("3 offers waiting"), the Fights badge (3) and the Office (3) promise offers; the desk has 0 - the player is sent to an empty room.
  P29 HIGH: a developer counter line is visible to the player ("175 COUNTRIES · 423 ATHLETES · 128 SCHEDULED · 12 PROSPECTS · 5 COACHES · 1 ORGS · 24 ORG FIGHTERS · CASH 0 · ... NO OPEN SLOT · BELT LIGHTWEIGHT BOXING") - reads as a debug build.
  P30 LOW-MED: the only sponsor is the CYPRUS MIXED MARTIAL ARTS FEDERATION for a London boxing gym, "maintain 2 available athletes" with 1 on the books.
  P31 MEDIUM: an empty desk gives no next step (when is the next card? which tab?).
S19 THE CARDS: 128 world cards, 0 BOOKABLE. Elite shows only (UFC, RIZIN, ONE, Glory, World Taekwondo, IJF judo) for a 0-0 novice; many rows "SAME-SEX DIVISIONS ONLY - X fights in the men's division".
  P32 CRITICAL (core loop): after signing a boxer the player has NOTHING to book - offers desk 0, world cards 0 bookable. The first-hour goal (book a fight) stalls here.
  P33 MEDIUM: DISC column reads "HYBRID" for every event (taekwondo, judo, UFC, Glory) - wrong/meaningless discipline label.
  P34 MEDIUM: the world list is a wall of shows the player can never enter; no "fights for MY fighters" view up front (MY DIVISION flag exists but buried).
S20 PROMOTIONS: 23 orgs, '8 THE GAME IS GUESSING' (P35 MEDIUM: dev-facing wording on a player screen); elite world bodies, no local amateur boxing promotion visible. TOURNAMENTS: none ('hosts announce every ten weeks').
S21 WEEK REVIEW (end wk1): IN \$1,008 / OUT \$3,473 / NET -\$2,465. "Offer expires in 1 week - CARD" x3.
  P36 HIGH (layout): title "WEEK IN REVIEW" overlaps three empty header bars with square-icon boxes; huge blank grey area; reads unfinished.
  P37 HIGH (T4): no training result for Isabel ("TRAINING - PROGRAM" only) - the player cannot SEE a week of work did anything (no stat delta).
  P38 MEDIUM: "\$1,008 IN" unexplained (from what?). P39: the 3 offers are named here as expiring but were not on the offers desk (ties to P28).
  LOOP wk1: cash 25,000 -> 17,274 (signings) -> 14,809? (after -2,465), runway ~6-7 weeks at this burn.
S22 WEEK 2 home: cash \$18,282 = 17,274 + 1,008. P40 HIGH (economy): the review billed OUT \$3,473 (wages 1,514+1,592 + upkeep 367) and NET -\$2,465, but cash ROSE by the \$1,008 income - wages/upkeep never left the bank, or the review lies. Either way the money story is broken.
  P41 HIGH: "Staff room - 1 need a coach" after hiring a coach - hiring does not assign; nothing told the player to assign.
S23 WEEK 2 Monday report on HOME shows the gain: "DEFENSE +13% · FIGHT IQ +13%" + coach Tala's line - T4 "see him improve" IS met, on Home (not on the week review). P41 downgraded: coach does work her; the "1 need a coach" counter is wrong (MEDIUM). P42 MEDIUM (realism): +13% defense and fight IQ in ONE week for a 24-y-o. "On the wire": PFL short-notice middleweight slot vs Haruto Williams (a man) and a Cyprus MMA bantamweight GP - news the player cannot act on.
S24 Home CTA 'Open offers' opens the SCHEDULE/MY MONTH calendar, not the offers (P43 MEDIUM: button lands on the wrong tab). Calendar: world cards per day, Isabel's 'IA MED/IA CAMP/IA REC' chips - readable.
S25 WEEKS 2-6 (Continue + review each week):
  | wk | Monday cash | review IN/OUT/NET | desk | Monday report |
  | 2 | 18,282 | 1,008 / 3,473 / -2,465 | 0 | DEF +13% IQ +13% |
  | 3 | 19,362 | 1,080 / 3,473 / -2,393 | 0 | same text |
  | 4 | 20,514 | 1,152 / 3,473 / -2,321 | 0 | same text |
  | 5 |  7,846 | 1,224 / 17,365 / -16,141 | 0 | same text |
  | 6 |  9,142 | 1,296 / 3,473 / -2,177 | 0 | DEF +12% IQ +12% |
  P40 explained: payroll is BILLED MONTHLY (wk4 OUT 17,365) while the weekly review shows it weekly - cash rises 3 weeks then drops 13k+ at once. MEDIUM-HIGH: the money story still misleads (show "accrued / due on <date>").
  P44 HIGH: the Monday report repeats "DEFENSE +13% · FIGHT IQ +13%" every week - stale text or absurd compounding; progress stops meaning anything.
  P32 CONFIRMED CRITICAL: 5 weeks, 0 offers, nothing bookable - the loop does not start. Bankruptcy due ~week 8 (next monthly bill ~14k vs 9.1k).

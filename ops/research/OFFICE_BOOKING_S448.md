# Office computer, booking from the fighter, contracts and coaches (S448 draft)

His words (S448, verbatim): "check corner kings contract screen , how it differs from ours can you rate them both, check their
coaches how everything about how coaches work (progress,fighter pairing,trianing,relatiosnhips,roles etc) , use rea if you need
to find their contract offer negotiations and improve it for our game . also make sure we wire the right submenus to the main
gym , when i click the office i want to see an computer screen showing the dashboard with submenus in it (mail,finance,Media,
Schedule,fighter summary dashboard , coach summary dashboard etc), currently it has 3 tabs and it is lacking options i think .
Booking a fight i think is better to be an option within a fighters profile tab (automatically open his weightclass with
available events and bookable opponents or look for any fight whatver you think) . Tell me what you think of all this ?"

Corner King study: E:/FightCamp/tmp/ref_study/corner-king/notes_s395_*.md and notes_s448_coaches_contracts.md (read-only,
own words). Memory: reference_corner_king_study_s395.

## 1. Today in our game (read in code, S448)
- Hub click "Club office" (GymHub._go "office") opens area `money` tab 0; People (StaffCard) and Records are tabs beside it.
  Three tabs: Money, People, Records.
- Booking lives in FIGHTS (Fights.gd, one page: offers with each fighter's standing, calendar, results). An offer's Open goes
  to its bout page. Nothing on the fighter's page books a fight.
- Fighter page tabs (FighterPage.TABS): Overview, Attributes and moves, Body, Training, History, Fight prep (only with a
  bout), Contract and goals, Playbook. The Contract part is two rows: "Club stipend, $250 a week" / "until turning pro".
- Coaches: one rating = the average of five areas (pads, bag, conditioning, strength, sparring; CoachAreas). No level, no
  growth, no capacity, no personality, no relationship. StaffRoles: four sessional jobs beside the coach, each moving one
  number. The player is the head coach (HeadCoach, four backgrounds).
- Data the office could show already exists: news + unread (mail), cash/ledger/income history (finance), results, rivals,
  prospects (scouting), pro_offer, deals, facilities, staff_roles, show (hosted show date), the four fighters.
  Nothing for media/press yet.

## 2. Office computer: proposed submenus (each one tied to a real mechanic, no empty tab)
| Submenu | What the player does there | Built today? |
|---|---|---|
| Desktop (dashboard) | the week's must-dos: replies due, bills, a fighter in the red, next bouts | parts on Home |
| Mail | offers, staff and fighter messages, results; answer from the mail | news + unread exist; replies new |
| Schedule | calendar of bouts, fight weeks, camps, the hosted show; click a day | parts on Fights |
| Fighters | the four fighters on one board: CoachCheck row, next fight, rank, mood, contract end | CoachCheck exists |
| Staff | coaches + jobs: who trains whom, load, ratings, hire/let go | StaffCard exists |
| Finance | the Money page as it is | yes |
| Records | as it is | yes |
| Media | interviews, press before a show | NO: waits for the hosted club show (HOSTSHOW1); a tab with nothing to do breaks his S398 rule |

## 3. Booking from the fighter
A "Find a fight" tab on the fighter's page: opens on his weight class and his ladder rank, lists the events of the next 1-2
weeks (amateur: no camp, a light fight week, S428) with the bookable opponents, each showing the rank it would earn (S428
"every fight should display the rank earned"). This is where Ask for a fight (ASKFIGHT1) lives. Mail and Schedule still show
every incoming offer, and an offer opens on the same fighter tab.

## 4. Contracts and coaches: Corner King read from its code (S448, notes_s448_coaches_contracts.md) and what we take

Ratings (screen / what the code really does):
| | Corner King | Ours today |
|---|---|---|
| Fighter contract screen | 7 / logic 4: every term + "what he has been worth" ledger; but one-shot offer, answer by mail in 1-3 days, acceptance % only after, leverage shown is cosmetic (always 50% +- bond) | 2: two rows, nothing to decide |
| Coach page | 6 / logic 4: pairing score is real; Cutman, Matchup Analyst, personality training bonus and per-block coach assignment do NOTHING in code; growth ~75 sessions per hidden step (invisible) | 4: five area ratings, no growth, no load, no personality, no bond |
| Camp window | 7 (section 5) | ours is deeper day by day, no summary or hand-off |
| Booking | Organizations > Request fight + mail offers (the only haggle: rounds, patience, counters 30-60% of the way) | Fights page offers; nothing on the fighter |

Their best idea - the PAIRING score (0-100 from 50): coach specialty matches the session +18 / not -8; his skill there +14 at 75+,
+7 at 60+, -12 under 40; the session trains the fighter's weakest stat +8; an unhappy fighter +8 with a motivator, -10 with a
drill sergeant; load -5 when exactly full, -16 and -5 per extra when over. It scales gains x0.92-1.10 and fatigue x1.12-0.94;
labels top fit / good / mixed / risky. Capacity 2 fighters (+1 at levels 7 and 9, max 5).

What we take, every piece WIRED (theirs half decorative):
1. Pairing fit on our week board: each session shows its coach's fit with that fighter (area match, his rating there, her
   weakest stat, her mood x his personality, his load) and the fit moves her gain and tiredness - the number the player acts on.
2. Load: each coach takes 2 fighters; four fighters with one coach = the overload choice (hire, or accept "risky" sessions).
3. Growth you can SEE: a coach's area rises from the sessions he runs (about one point a season), so a cheap coach who works
   with your fighters becomes good - ties to PROGRESSION_MAP's coach market.
4. Personality, four kinds, each changing ONE thing (motivator: mood after a loss; drill sergeant: faster gains, mood cost;
   technician: move learning; old school: tiredness recovery).
5. A bond coach <-> fighter (theirs is only with the player): built by sessions together; it moves how well she hears the
   corner (our Heard / Half heard shout rule) and her mood. Deeper than theirs and visible in the fight.
6. Contracts: amateurs stay club members on the $250 stipend (England Boxing has no amateur contracts); the contract tab now
   shows the "what she has been worth" ledger (stipend paid vs ticket cuts and members brought). At TURNING PRO a real talk:
   purse share, term in fights, buyout; her ask from record and rank, raised by rival gyms' interest, lowered by her bond with
   you; the acceptance meter moves BEFORE you send (theirs only after), at most three rounds, her patience shown.
7. Booking from the fighter's page (section 3) - better than theirs (Organizations menu).

## 5. Corner King's camp plan window (his screenshot, S448) - 7/10
Three picks, each with its numbers and the trainer's suggestion + how sure he is ("shaky read"): sparring None / Light (~2%
injury a session) / Moderate (~8%) / Hard (15-20%); camp focus Technique / Power / Stamina (a fight-night bonus, up to +4);
weight cut Gradual / Late cut / Aggressive (lbs to go shown). "Use trainer's plan", "Update plan", and a box to let the head
trainer plan all future camps. Weak: set once and forget, flat bonus, risk per session never per camp, no tie to this
opponent, nothing during the camp asks for a change.
Take for us: (1) this shape for the AMATEURWEEK1 fight week (sparring none/light, sharpen what, make weight; numbers on each
pick; the coach suggests one); (2) the coach's certainty grows with his skill - coach quality made visible; (3) "let the coach
plan it" per fighter (four fighters = too many day boards), our day board stays for control; (4) total risk and the
fight-night result shown, not per-session numbers.

## 6. Proposed order (for his call)
1. AMATEURWEEK1 fight week (his "Yes, fight week first") with Find a fight on the fighter page and the camp-window shape.
2. Office computer: mockup first (Desktop, Mail, Schedule, Fighters, Staff, Finance, Records), his pick, then build.
3. Coach depth: pairing fit + load + growth + personality + bond (map, critics 7+, then build).
4. Contract ledger now (small); the pro negotiation with TURNPRO1.

## 7. Camp locations (his S448 interview answers, verbatim where quoted)
Mockups: docs/mockups/s448/camp_cards/camp_plan.png (v1, picture cards per option) and camp_plan_v2.png (v2, his direction:
"a location picture for each camp and showing icons with toolitips of that drills that camp involves ? and also meters to change
sparring weight cut ?"). Pictures made in Ludo in the game's own look (S448, 13 credits).
His answers: all four locations - home gym, hill cottage, city club sparring trip, seaside - and "the buffs need to be real and
reflect in the fight"; the amateur fight week can use them too ("Fight week too"); sliders for sparring, weight cut, training
load, and "add sliders also for technique/power/cardio with picture cards"; who pays: "how about who pays affect mood/morale,
relationship and not always available for the fighter to pay".
Design rules that follow: every location buff is a multiplier on a stat or rule the fight already reads (Cardio and Legs gains,
Fight IQ gains, plan tests per sparring night, recovery = FATIGUE_KEEP, injury chance) - never a label; the screen shows what it
changes ON FIGHT NIGHT (e.g. stamina lasts into round 3). Each location caps or opens sliders (hills/seaside: sparring max 1 a
week; city: new styles add a plan test a night, injury x1.3). Focus = three shares of drill time summing to 100%, the biggest is
the camp goal (PeakCamp). Who pays: club (mood +, bond +), half, or she pays (needs her own savings - NEW: fighters have no money
today; stipend and purses would fill it) - she cannot pay what she does not have. Costs are first estimates from UK prices x1.25
(cottage ~GBP 700 a week, house ~GBP 800, mat fees + travel ~GBP 320 a week): John checks them before the build. Next: design map
with the wired-menus table, two fresh critics to 7+, then his board.

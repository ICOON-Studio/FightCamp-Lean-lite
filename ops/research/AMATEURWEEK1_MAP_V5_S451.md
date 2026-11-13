# AMATEURWEEK1 v5: the amateur fight week (S451)

What changed from v4 (ops/research/AMATEURWEEK1_MAP_V4_S450.md), and why:
- Kalli scored v4 at Depth 5, Play 6 (SQ60, ops/research/AMATEURWEEK_CRITIC_S450_KALLI.md). Her main finding: v4 moved the weight of the
  week to the season but never measured the season or showed it, so every slider looked like it did nothing. v5 MEASURES the season
  (FIGHTWEEKPROBE3, section 4b) and puts it on the box, and gives every option a cost or a gain the player can see. All 18 logic points
  and all 14 "to reach 10" items are answered in the table in section 10.
- John's critic answer on v4 (SQ62) was not in when v5 was written; his points join v5 or v6 as they land.
- Code facts read in S451 (Claude, ops/research/AMATEURWEEK1_V5_CHECKS_S451.md):
  - TAPER DOES run for an amateur bout: WeekPhase.phase reads any booked bout (1 week out = taper). v4 was wrong.
  - A stoppage loss has two rests in code: the 30-day suspension (Injuries) and 8 more weeks to the next offer (Matchmaking).
  - There is no savings value on a boxer, and the stipend is optional ($250, Pay or Stop).
  - FireLevel has been ON since S450: a plan line fires 1 in 2 at Usable, 3 in 4 at Sharp, always at Signature.
  - The training-load ratio is real: a week over 1.3x the boxer's usual load is "high", 1.5x a "spike" (2-4x injury risk; TrainingLoad).

Sources (kept): his S428 scope change ("amateur fights do not require fight camp and can happen within a week"); Q-209, Q-210; his S448
camp interview ("the buffs need to be real and reflect in the fight", who pays: "affect mood/morale, relationship and not always
available for the fighter to pay"); S448 "Booking a fight ... an option within a fighters profile tab"; the look: camp plan v3.

Words: the map writes "the boxer" and roles ("your assistant", "the head coach"). On screen a name appears only in a header (S448).

## 1. The idea
- An amateur bout comes 1 to 3 weeks out and has no camp. Camps stay for pro fights, title fights and the nationals.
- The player finds the bout on THE BOXER'S OWN PAGE (Fights tab): up to three bouts that pull different ways. "Your assistant picks
  the bout" takes the card that fits the boxer's goal and says why (no assistant: the button is greyed with the reason).
- The last week before the bell is the fight week screen (camp plan look, one week). A bout 2 weeks out shows week 1 as a normal
  week on the week board and week 2 on the fight week screen; a bout 3 weeks out, weeks 1-2 normal (BUILD), week 3 the fight week.
- Every choice lands on ONE box the player reads before saying yes, ON FIGHT NIGHT, with two halves:
  - TONIGHT: the tank at the first bell (stacked: load + sparring + weight, with its price in wins), sharp or flat in round 1, plan
    lines ready, the scale margin, the win band.
  - BANKED: the stat points this week keeps, the move that crosses a line ("Uppercut Usable"), the tiredness carried, and the
    SEASON line: what this habit is worth over a season, measured (section 4b).
- The week is a TRADE between tonight and the season, and the box shows both, in numbers.

## 2. Find a fight (the boxer's page, Fights tab)
- When the boxer is READY, the tab shows up to three bouts from the region's shows (section 2b), as versus cards. Taking one closes
  the others. Each card shows:
  - WHEN: days to the bell, and the show's club.
  - HOME OR AWAY, and the favour count with that club (section 7).
  - RANK: what a win and a loss do to the boxer's place (section 3). Under 4 wins: "wins to the table: n".
  - WHAT YOU KNOW: the opponent's file, five habit groups (section 5). A debutant: "no bouts, no tape".
  - THE RISK: the chance of being stopped, and the rest if it happens: the 30-day suspension (longer for repeats).
  - THE WEEK IT BUYS: ON FIGHT NIGHT at your assistant's default week.
- READY / BUILDING (until a date) / RESTING (the suspension's end date) on the same tab.
- THE SHEET'S RHYTHM: the next sheet comes 21 days after a points bout, the day the suspension ends after a stoppage. At most 11 bouts
  a season ("bouts this season 7 of 11").
- The Fights rail page is a list: one row per boxer, the sheet's state and its best card; a click opens that boxer's Fights tab.
- REPLACES (code): AmateurBooking's one offer at a time and its 8-12 weeks' lead, for amateur bouts only; Matchmaking's extra 8 weeks
  after a stopped AMATEUR loss (the rule book's suspension is the rest). Pro offers keep theirs.

### 2b. The regional show calendar (new; Kalli point 3)
- The region holds 6 clubs (the boxer's club and five others). Each other club runs a show every 4 weeks on a Saturday, staggered, so
  the region has about 1.25 shows a week, and every fortnight 2 or 3 shows within reach.
- A show has 8-12 bouts across the weights. A sheet card needs a show 1 to 3 weeks out with an opponent inside the weight gap.
- When the fortnight has fewer than three fitting bouts the sheet shows the ones there are, and the empty slot says why: "no third
  card this fortnight: next show at <club> in 3 weeks".
- The boxer's own town has the regional board's show every 4 weeks: that is the HOME show (section 3).

## 3. The bout sheet's trades
"Home" is the regional board's show in your own town: no cost to the club. It is NOT the hosted club show (HOSTSHOW1, later).

| Choice | Gives | Costs |
|---|---|---|
| Home show | the club keeps the ticket cut (the boxer's own ticket sales; John to confirm the share); a win brings +8 members and +5 reputation | home cards draw names LEVEL with the boxer or up to 3 places below: a win over a level name takes no place but keeps it |
| Away show | the host's ranked names: a win over a name above takes that place and +2 reputation on top; free facts on two boxers seen that night; an away win brings +4 members, +3 reputation | no ticket cut; the van $40 |
| Novice (under 4 wins) | home: the ticket cut; away: free facts and +1 favour with the host | no place to climb yet |
| Pass | the boxer stays fresh; the next sheet comes in 7 days | no instant cost; the game's month-without-a-bout rule is the only mood cost; 6 weeks without a bout = FLAT in round 1 of the next (ring rust); two passes on one club's cards = it stops calling for 8 weeks |
| Loss to a name above | no place lost | the record |
| Loss to a name below | drops two places (new rule) | the record |

- THE CLIMB NEEDS AWAY WINS (Kalli point 4). The pro offer today: 7 wins and a top-3 place, or 9 wins at any rank (Roster.PRO_WINS,
  PRO_WINS_ANY_RANK). v5 proposes: the 9-wins road needs at least 3 of them over ranked names, which only away cards offer. A home-only
  boxer then never turns pro. THIS CHANGES A DECIDED NUMBER (Kalli K-PROLINE1): it goes to him on the board (section 13) and is not
  built without his yes. Without it, the home/away trade still holds through the place (only away climbs) and the top-3 road.
- The money line: four boxers at about 10 bouts a season is about 40 bouts; the year's ticket money runs from $0 (all away) to about
  $18,000 (all home). BudgetProbe re-runs the break-even on the new income before the build freezes.
- The card shows the season so far: "home 5, away 3: $2,250 earned, 2 places climbed, ranked wins 2 of 3".

## 4. The fight week screen (the camp plan, one week)
Opened from the bout card ("Plan the week") or filled by "Your assistant runs this week". The layout is camp plan v3, scaled down.

### WHERE TO TRAIN (each trip shows ONE number on the box)
Prices are for the boxer plus one coach for a week (John, in GBP x 1.25). Every effect acts on something the fight or the banked week
reads, never on "gains x1.25" of a week too small to see (Kalli point 5).

| Location | Cost | What it does (shown on the box) | Injury | When |
|---|---|---|---|---|
| Home gym | free | nothing extra; pad nights as usual | x1.0 | always |
| City club, commute | $150 | a partner in the opponent's style: the round-1 stance penalty against a southpaw is gone (the camp's $160 lefty-partner rule); +1 plan test a sparring night | x1.3 | always |
| Hill cottage | $575 off-season, $1,000 June-August | clears 6 tiredness, and the week banks in FULL at Tick over's tank cost | x1.1 | bout 2+ weeks out (the week away, then the fight week home) |
| Seaside house | $590 off-season, $1,150 June-August | tiredness to 30 at most, mood +5; the week banks half | x1.0 | bout 2+ weeks out |

- The city stay-over is CUT (it duplicated the commute at seven times the price).
- THE CAP: no location is worth more than 4 wins in 100 over a SEASON. CAMPPLACE1 measures each through the career harness before
  the numbers freeze (section 12).

### HOW HARD
Three sliders with picture stops. Under each stop, its tank and banked numbers. Under all three, ONE stacked tank bar with its price in
wins at the right (from 4b's curve: "22 off: about 9 in 100 at even"), turning red past 12 off.

THE WEEK'S LOAD (the load slider REPLACES the game's TAPER week by name; WeekPhase's taper is "Tick over"):

| Stop | Tank at the bell | Round 1 | Banked this week | Carried into next week |
|---|---|---|---|---|
| Rest up | full | FLAT (round-1 edge 2.0 against) | a fifth of a full week | nothing |
| Tick over (the taper, the default) | 6 off | sharp, +1 plan line ready (FireLevel: one more line at its level) | half | nothing |
| Train through | 12 off | sharp | a full week | +6 tiredness, and the week counts in the load ratio (a back-to-back Train through runs 1.3x-1.5x the boxer's usual: high or spike, 2-4x the injury risk; TrainingLoad's own rule) |

- Every point of tiredness over 50 costs 1 off the tank (no cap).
- John's taper evidence (Bosquet 2007; Buglioni 2016): 1 rest day, the same sessions, volume cut 40-60%: that is Tick over. Rest up is
  more rest than the evidence supports; the FLAT round 1 is its price.

SPARRING: 0, 1 or 2 nights. Each night is one plan test against a live partner, and tiredness rises.
- LATE SPARRING (inside 7 days of the bell): that week's training-injury roll is x1.5 per night, and the night costs 3 off the tank.
- On a 2-week bout, week-1 sparring is free of both. So 0, 1 and 2 are each right somewhere (Kalli point 5 of section 5).

THE WEIGHT: shown only when the boxer walks outside the gap (section 6). Stops: Hold; Eat less (1 off the tank per 0.1 kg, up to 10);
Train it off (tiredness).

### WHAT THE WEEK BUILDS
- Shares in the game's own words: Technique, Strength, Stamina, always 100% (Kalli point 14: no "Cardio", "Legs" or "Power" as shares).
  They apply only to the banked part of the week.
- THE SECOND WEEK'S PUNCH: a 2-week bout adds 2 pad nights; if a move would cross Usable (30) or Sharp (60) in that time, the card shows
  "two weeks: Uppercut Usable" (MoveMastery's pace). With FireLevel on, that line now has a fight-night value: the move fires 1 in 2.

### WHO PAYS (any trip)
John: club boxers get no stipend beyond the club's and have about $25-75 a week to spare.

| Payer | Cash | Mood (0-100; a win is +8, a loss -12) |
|---|---|---|
| The club | the club pays it all | +3 |
| Half each | half from the club, half from the boxer's savings | +2, and the club pays half |
| The boxer | all from savings | win +4, loss -5 |

- SAVINGS (new number on the boxer) fill ONLY while the club pays the stipend: $50 a week of the $250 (John's $25-75 middle). Stop the
  stipend and savings stop; the boxer options grey with "no savings: the stipend is stopped".
- A $575 cottage half-paid ($288) is about 6 weeks of savings: the boxer can pay a commute often and a cottage share now and then.
- Loyalty is DROPPED from this table until the leaving rule (AGREED, NOT BUILT) exists (Kalli point 12).

### YOUR ASSISTANT'S PICK
- The pinned note: your assistant's face, a one-line reason, and how sure (sureness = 0.5 + the assistant's rating / 200, the corner's
  own number). "Use the pick" fills every slider.
- No assistant: the default week (Tick over, 1 sparring night if 2+ weeks out, Hold), with no note and no sureness (Kalli point 13).

### ON FIGHT NIGHT (the one gold frame)
- TONIGHT: the stacked tank and its price in wins, sharp or flat, lines ready (each at its FireLevel per cent), the scale margin, the
  win band.
- BANKED: stat points this week, the move crossing a line, tiredness carried, and THE SEASON LINE for the chosen stop (4b): "Rest up
  every bout: about n wins in 100 behind your assistant's pick by the season's end".
- Each row shows its change from your assistant's default week.

## 4b. The price list (measured through the real bout)
FIGHTWEEKPROBE1 and 2 (S450; docs/FIGHTWEEKPROBE1_RESULT.md), one night, 400 bouts a cell, three calibrated pairs:
- THE TANK IS CURVED: 0 to 8 off costs 0 to 4 wins in 100 (inside the noise); 12 to 20 off about 0.7-1.0 a point; the full 25 costs 8
  (even), 16 (edge), 12 (under).
- A flat round 1 at 2.0 costs the bout 2-3 wins in 100 (round 1 itself 5-6).
- One night's best-to-worst load gap stays under 5 in 100: a single fight week sharpens, it does not build.

FIGHTWEEKPROBE3 (S451; a 52-week season, 150 careers an arm, the same careers in each, today's booking, docs/FIGHTWEEKPROBE3_RESULT.md):

| Habit | Win share | Paired against the coach's pick | Stat total at season end |
|---|---|---|---|
| always Rest up | 55.2 % | -6.1 +-1.7 in 100 | -1.7 |
| always Tick over | 61.1 % | -0.2 +-0.8 | -0.4 |
| always Train through | 62.5 % | +1.2 +-1.6 | +1.3 |
| the coach's pick | 61.3 % | - | - |

- THE SEASON LINE IS REAL FOR REST UP: always resting costs about 6 wins in 100 over a season, twice the one-night price. The cause is
  the flat round 1, not banked work.
- TRAIN THROUGH COSTS NOTHING YET: injuries are the same in every arm, so v5's two costs are REQUIRED before the build: the week's load
  ratio (a Train-through fight week counts toward TrainingLoad's spike, 2-4x injury risk) and x1.5 late sparring. The probe is re-run
  with them; the build target is always-Train-through 2-4 in 100 behind the pick, so no stop is always right.
- THE BANKED SHARE IS SMALL (a full week against a fifth: about 3 stat points a season). The BANKED row shows its true size ("+1 to +2
  stat points this week"); the season line carries the weight.
- Booking was today's (about 5.5 bouts a season); with v5's 9-11 bouts the season gaps roughly double. The probe is re-run on BoutSheet.

## 5. The film evening, and tells confirmed in the fight
- Film takes ONE of the boxer's own pad nights (PadWeek: 3 each). One evening answers ONE of five habit groups, mapped onto the
  opponent's file (OppFile): entries and preferred range -> weapon; reactions under pressure and defensive habits -> habits; starts slow
  or fades -> weakness.
- A debutant has no tape: film is greyed, with the reason. The file shows each group SEEN, CONFIRMED or UNKNOWN.
- A tell seen on tape is a guess until the fight shows it (FireLevel is on, so this is buildable now):
  - a plan line built on a SEEN tell runs at 90% of its level's fire share in round 1;
  - at the first corner minute your corner says whether it showed: CONFIRMED gives the full share from round 2; not seen drops the
    line one level;
  - a CONFIRMED tell is kept for a rematch at half value.
- Free facts come at AWAY shows only: up to two boxers at your weights, one group each, shown as portraits with class and record (the
  name only in the card header; Kalli point 18).

## 6. The weight, at walking weight (England Boxing Rules 2026, John)
- Matching is at actual weight plus a gap, never the class limit: the smaller boxer's category width (rule 2.7.8). John checks the
  2026 categories against the game's classes (Kalli point 16); a win counts in the class of the boxer's registered weight.
- Each bout card names the agreed weight. Inside the gap: no weight question. Just outside: Eat less or Train it off.
- THE WEIGH-IN IS ON BOUT DAY, one hour before (rule 7.1.3). A MISS: the bout is off, or re-matched on the night; the host takes 1
  favour; no fee.
- ASK FOR A KILO costs one favour and MOVES THE AGREED WEIGHT 1 kg: the boxer skips Eat less (up to 10 off the tank saved). The
  opponent gets nothing for it (Kalli point 9: v4's "+5 to their tank" sat on the flat part of the curve and bought nothing).
- The boxer's card: "can take a bout in 7 days: yes / no".

## 7. Favours
- A count of 0 to 3 per club, on each bout card and on the region's club list. Every club starts at 1.
- Earned: a late replacement on their show; yes to their kilo ask; an away novice bout on their show; (later) their boxer on your show.
- Spent: asking for a kilo; pulling out of their show late; missing weight on their show; refusing their late-replacement ask.
- AT 0: that club offers NO ranked names for 4 weeks, then comes back to 1 (Kalli point 10: the count now costs something, and the lock
  is bounded).
- A HOST CAN CALL IN A FAVOUR: when a club's own show loses a bout, it asks for your boxer as the late replacement; refuse = -1 favour.
- Favours never buy rank or wins.

## 8. Things that happen, and routine bouts
- A BOUT FALLS THROUGH: 25 in 100 in the week before a show (John: a quarter to a half). One late replacement is offered, 0-5 days
  out: less known, or up to a kilo heavier inside the gap, or three bouts more experienced (never across the novice line). Take it: +1
  favour. Go home: no bout, mood -6, the week spent. Continue stops for it.
- TWO SHOWS ON ONE NIGHT: the head coach takes one corner, your assistant the other (calls right 0.5 + rating/200); no assistant: a club
  member, calls right 1 in 2, and no ONE CHANGE. The corner line names the role, never a name.
- ROUTINE: "Your assistant runs this week" fills the default week in one click. The clock stops only for a fall-through, a weigh-in
  margin under 0.2 kg, or two shows on one night.

## 9. Code rules this map replaces or adds (by name)
| Code today | v5 |
|---|---|
| AmateurBooking: one offer at a time, 8-12 weeks' lead | BoutSheet: three cards, 1-3 weeks out, from the region's show calendar (2b); pro offers unchanged |
| Matchmaking.STOP_REST_WEEKS: 8 more weeks after a stopped loss | amateur: the 30-day suspension is the rest, the sheet comes the day it ends; pro: unchanged |
| A $450 ticket cut and +8 members / +5 rep on every bout | home only; an away win +4 / +3, and +2 rep over a name above; BudgetProbe re-run |
| Weigh-in the day before, $300 for a miss | bout day; a miss = bout off or re-matched, -1 favour, no fee |
| WeekPhase TAPER for any booked bout | the fight week's load slider replaces it by name (Tick over = today's taper, the default) |
| Pro offer: 7 wins + top-3, or 9 wins | ON HIS BOARD: 9 wins with 3 over ranked names (not built without his yes) |
| A loss moves no place | a loss to a name below drops two places |
| No regional show calendar | RegionShows: 6 clubs, a show each every 4 weeks, staggered |
| No savings | Savings: $50 a week while the stipend is paid |
| No favours | Favours, with the 4-week lock at 0 |
| The training-injury roll | x1.5 per late sparring night |

## 10. Critics' points, each answered
Kalli SQ60 (v4): logic points 1-18 and "to reach 10" items K1-K14.

| Point | v5 |
|---|---|
| 1 Stoppage rest, 8 weeks or 30 days | both in code; amateur: the 30-day suspension only, the 8 weeks dropped for amateurs (section 9) |
| 2 TAPER for amateur bouts (K9) | it runs (WeekPhase.phase); the load slider replaces it by name |
| 3 Not enough shows (K10) | the regional show calendar, 2b, and the empty-slot line |
| 4 Home nearly always right (K2) | home draws level or 3 below; places only away; +2 rep over a name above; the pro-road change on his board |
| 5 Trip buffs too small (K3) | each trip acts on the tank, the round-1 penalty, tiredness or the banked share; season cap by CAMPPLACE1 |
| 6 The box can't show the choice (K1, K4) | BANKED and SEASON rows; the stacked tank priced in wins |
| 7 Tick over's credit not built | FireLevel is on: one more line at its level |
| 8 Train through has no season cost (K6) | +6 tiredness carried and the load ratio's spike risk (code's own rule) |
| 9 The kilo buys nothing (K7) | the kilo moves the agreed weight; the boxer skips Eat less |
| 10 Favours do nothing (K7) | at 0, no ranked names for 4 weeks; hosts call favours in |
| 11 Pass double-counts | one rule: no instant cost; the month-without-a-bout rule and ring rust only |
| 12 Who pays, loyalty, savings (K8) | savings only while the stipend is paid; Loyalty dropped; Half each = mood +2 |
| 13 The wrong coach on the pick (K11) | your assistant, sureness from its rating; none = the default week, no note |
| 14 Words (K12) | Technique, Strength, Stamina |
| 15 Ticket cut at a board show | the boxer's own ticket sales; John to confirm the share |
| 16 Weight and class limits | John checks rule 2.7.8 against our classes; a win counts in the registered class |
| 17 Office not in the pack | OFFICE1 landed (his Q-213); the pack has it; the needs row stays on Home too |
| 18 Names | free facts as portraits with class and record; the corner names the role |
| K5 Late sparring | x1.5 injury a night inside 7 days, 3 off the tank; week-1 sparring free |
| K13 A 3-week bout | weeks 1-2 normal (BUILD), week 3 the fight week |
| K14 Probe order | section 12 |

## 11. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Boxer page, Fights tab | up to three bout cards, READY/BUILDING/RESTING, the season line, "Your assistant picks the bout" | BoutSheet, RegionShows, RankLine, OppFile, Favours |
| Fights rail page | one row per boxer: sheet state + best card | BoutSheet |
| Bout card | ON FIGHT NIGHT at the default week, the risk (the suspension), what you know, favours, "two weeks: <move> Usable" | FightWeek, BoutRules, OppFile, MoveMastery |
| Fight week screen | trips with cost and their one number; load / sparring / weight sliders and the stacked tank; shares; who pays with savings; your assistant's pick; ON FIGHT NIGHT (TONIGHT + BANKED + SEASON) | FightWeek, CampPlace, PadWeek, Money, Savings, TrainingLoad |
| Week board (Training) | the fight week's nights, film on the boxer's own pad night, trip days; the taper week named by the load stop | WeekPhase, PadWeek |
| Office desktop (OFFICE1, built) | bout and fight-week days on the calendar; "Needs you" for an open sheet | OfficeDesk |
| Home | "Needs you" for an open sheet (the same row) | HomeNeeds |
| Boxer card (Roster) | "can take a bout in 7 days"; the tank bar in fight week; savings | Fighters, weigh_forecast, Savings |
| Tape room | five groups SEEN / CONFIRMED / UNKNOWN; free facts from away shows | TapeRoom, OppFile |
| Playbook | each line at its FireLevel per cent; a SEEN line at 90% of it | GamePlan, PlanLines, FireLevel |
| Region / club list | each club's favours and next show | Favours, RegionShows |
| Continue | stops for a fall-through, a tight weigh-in, two shows, a host's favour call | Clock, Needs |
| Fight night | the bout-day weigh-in first; the corner chosen | BoutNight |
| Corner minute (round 1) | CONFIRMED / Not seen | the corner read, OppFile |
| Result page | the sizes ("14 off the tank, round 3 lost"), the rank earned, the season line | FightWhy, RankLine |
| Money | home ticket cuts, the van, trips by payer, savings paid | Money, GymBills |

## 12. Build order
1. Probes (all through the career harness, a season, never one night):
   - FIGHTWEEKPROBE3 (done S451, 4b)
   - CAMPPLACE1: each trip 1-4 wins in 100 over a season
   - BudgetProbe: home/away money, the break-even
   - the favour test: a new club reaches a ranked away name inside 8 weeks; the 0-lock costs 2-5 in 100 over a season
   - the bout count under the cap with the show calendar (9-11 a season)
2. Pure rules with tests: FightWeek, BoutSheet, RegionShows, CampPlace, Favours, TellConfirm, Savings.
3. Wire-ups: the bout-day weigh-in, the miss rule, the home-only ticket cut, the suspension feeding the sheet, the load slider over
   WeekPhase's taper, late sparring's injury roll.
4. Screens, one a task: the Fights tab with bout cards, the Fights rail list, the fight week screen, the week board's nights, the
   corner's confirm line, the result's sizes.
5. Golden path: find a fight, pick, plan the week (one trip, one film), weigh-in on the day, the fight, the result with sizes and the
   rank earned.

## 13. Open for him (taste and scope, on the board after the critics)
- The pro road: "9 wins with 3 over ranked names" (away wins needed), or keep "9 wins at any rank"?
- Savings on each boxer, filled only while the stipend is paid: yes or no.
- Hills and seaside only for bouts two weeks out: right, or too strict?

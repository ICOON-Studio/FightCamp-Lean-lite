# AMATEURWEEK1 v6: the amateur fight week (S455)

v6 is v5 (ops/research/AMATEURWEEK1_MAP_V5_S451.md) with every point from its two critics answered. Everything in v5 that this page
does not name stands as written. Critics on v5: Kalli SQ64 (ops/research/AMATEURWEEK_CRITIC_S451_KALLI.md), John SQ65
(ops/research/AMATEURWEEK_CRITIC_S451_JOHN.md). Their shared finding: the trips and sparring sit on the wrong week or buy nothing, so
the fight week has one real decision (Rest up or not), and the default stop is always right.

Code facts read in S455 (Claude):
- The sessions feed, in the game's words (Data.LABEL): Roadwork and Intervals -> Stamina; Heavy bag and Strength circuit -> Power;
  Speed bag -> Speed; Slip rope -> Defence; Shadow boxing and Pads -> Technique; Neck work -> Durability. Sparring -> Fight IQ.
- InjuryRoll: injury risk x1 below 72 tiredness, rising to x2 at 76 and x3 from 80 (WeekPlan.OVERREACHED, where gains run at x0.6).

Words: "the boxer" and roles ("your assistant", "the head coach"); a name only in a header (S448). "Under 4 wins", never "novice"
(the pack's novice is 0-10 bouts, the mismatch rule).

## 1. The idea (changed)
- An amateur bout comes 1 to 3 weeks out and has no camp. The FIGHT WEEK SCREEN covers the bout's last TWO weeks when the bout is 2+
  weeks out: a slim WEEK BEFORE strip (the trip and the last sparring day) above the fight week itself. A 1-week bout shows the fight
  week only. A 3-week bout: week 1 is a normal week on the week board (BUILD), weeks 2-3 on this screen. (John: v5 picked the trip on
  a screen that did not cover the trip's week.)
- Every choice still lands on ON FIGHT NIGHT (TONIGHT + BANKED + SEASON). v6 makes each load stop the right one in some state, and
  prints the season line only from the measured re-run (section 4b).

## 2. The bout sheet (changes)
- SLOTS BY CLASS (Kalli 8): a show offers its 8-12 bouts as slots by sex and class. A sheet card needs an open slot at the boxer's
  weight. Two of the club's boxers in one class: the card goes to the one longer since their last bout; the other's empty slot says
  why ("this slot went to your other welter"). The sheet shows UP TO three cards; the slot test (section 12) must average 2 or more.
- PASS (both): only the pressed PASS button counts - declining the whole sheet. Taking one card closes the others with no pass. Each
  card shows the club's count: "passed 1 of 2". Two pressed passes on one club = 8 weeks without its calls.
- RING RUST counts from the suspension's end, not from the stoppage (Kalli 9): 6 weeks READY without a bout = FLAT in round 1.
- The home ticket cut stays the game's $450, labelled a game number (John: no sourced share exists).
- THE NATIONALS (John): every card shows "bouts to entry n of 5" and the entry date. While a boxer is in the nationals the sheet is
  closed with the reason ("in the nationals until <date>") and the camp opens as the pack says.
- PRO PACE (John): at 9-11 bouts a season and 61% wins, 9 wins arrive in about 1.4 seasons. This goes to his board with the pro road
  (section 13); nothing changes before his answer.
- GOALS THE ASSISTANT CAN READ (John): three goal types join FighterGoal: "Climb to top 3 by <date>", "Earn $n for the club this
  season", "Three bouts before the nationals". "Your assistant picks the bout" reads the goal: a rank goal picks away, a money goal home.

## 3. The bout sheet's trades (one change)
- "A loss to a name below drops two places" changes the pack's rank rule (a loss moves no place). It goes to his board beside the pro
  road (Kalli 10) and is not built without his yes. Without it, an away loss costs only the record.

## 4. The fight week screen (rewritten parts)
### WHERE TO TRAIN: three trips, each a thing only a trip gives (Kalli 3, John 3)
Prices now include food for two ($120) and extras ($50) a week (John S449).

| Trip | Cost | What it does (shown on TONIGHT) | When |
|---|---|---|---|
| Home gym | free | nothing extra | always |
| City club, commute | $150 + $40 food | a partner in the opponent's STYLE (pressure, counter, mover, southpaw): round-1 edge 1.0 against that style. Shown only when the opponent's file names a style. Injury x1.0 (v5's x1.3 had no cause) | fight week or week before |
| Hill cottage | $745 off-season, $1,170 June-August | the WEEK BEFORE runs as Train through with no load-ratio cost, and the fight week starts at tiredness -6: Tick over then costs 3 off the tank, not 6 | week before only (bout 2+ weeks out) |
| Seaside house | CUT | a free home rest week already gives morale and tiredness (both critics) | - |

- THE COACH GOES TOO (John): a trip takes your assistant, or the head coach if there is no assistant. The screen prints the cost at
  home: assistant away = the other boxers train that week at 60% and the evening class stops (-$350); head coach away = no head-coach
  edge and no shouts for any other bout that week.
- CAMPPLACE1 measures each trip PER USE against a home REST week (John), target 1-4 wins in 100 for that bout.

### THE TANK (John)
- The tank is capped at 25 off. Its parts stack in this order and stop at 25: tiredness over 50 (1 a point), the load stop, sparring,
  the weight. The stacked bar shows the part that falls past 25 greyed: "3 more would be lost here".

### THE WEEK'S LOAD: each stop best in a state (Kalli 1, John 2)
| Stop | Tank at the bell | Round 1 | Banked | Carried | Best when |
|---|---|---|---|---|---|
| Rest up | full | FLAT (edge 2.0 against) ONLY when the week starts under 40 tiredness; otherwise sharp | a fifth | tiredness to 30 | the boxer starts the week at 65+ tiredness |
| Tick over (the taper, default) | 6 off | sharp, and ONE chosen plan line fires one level up in round 1 (Usable -> Sharp share) | half | nothing | most weeks |
| Train through | 12 off | sharp | full | +6 tiredness; the week counts in TrainingLoad's ratio (high 1.3x, spike 1.5x: 2-4x injury) | the opponent is rated 5+ below and the next sheet is 4+ weeks away |

- "+1 plan line ready" is now a rule (both): the player picks the line on the screen; it fires at the next level's share in round 1 only.
- BANKED shows its measured size (Kalli 2): about +0.5 stat points between a full week and a fifth; never "+1 to +2".

### SPARRING: the last sparring day, and what it buys (Kalli 4, John 4)
One choice replaces the count: LAST SPARRING 9, 7, 5 or 3 days out, or none.
| Last sparring | Price | Buys |
|---|---|---|
| none | nothing | nothing |
| 9 days out (week before; bout 2+ weeks out only) | free | confirms ONE plan line against a live partner: it fires at its full share from round 1 (as a CONFIRMED tell) |
| 7 days out | 3 off the tank | confirms one line |
| 5 or 3 days out | 3 off the tank and x1.5 training injury each | confirms TWO lines (the second night) |
- So a 2-week bout spars at 9 for free; a 1-week bout trades one confirmed line against the tank; a heavy weight cut picks none.
- Your assistant's default: 9 when it exists, else 7 when the tank stays under 12 off, else none.

### WHO PAYS (John 7)
- SAVINGS come from the boxer's own job: $25-75 a week by background, shown at signing, never club money. They stop while the boxer is
  on the club's stipend only if the background says so ("full-time on the stipend").
- FUNDRAISER: a club night in place of one evening class (-$350) that raises $300-600, the odds rising with reputation.
- Mood: club pays +3; boxer pays +6 on a win, -3 on a loss (a confident boxer wants to pay); half each +2 on a win, -1 on a loss.

### YOUR ASSISTANT'S PICK is fallible and readable (John 1)
- It reads three facts and says which drove it: start tiredness, the weight's tank cost, the opponent's round-1 style.
- It is wrong at (1 - sureness): then it picks the next-best stop and still gives its reason. Sureness = 0.5 + rating / 200.
- The SEASON line compares each stop with the best stop for this boxer this week, never with the pick.
- PROBE TARGET: a player who reads the box beats "always the pick" by 2+ wins in 100 over a season, or the load slider is cut.

## 4b. The price list (what must be re-measured)
- FIGHTWEEKPROBE3 stands for today's booking. v6 adds FIGHTWEEKPROBE4: the season on BoutSheet with 9-11 bouts, the load-ratio cost,
  the late-sparring injury, the new Rest up rule; it reports, FOR EACH STATE (start tiredness band, opponent gap, weeks to the next
  sheet), which stop wins. Build target: each stop is the best in at least 1 fight week in 5; always one stop costs 2-6 in 100. v5's
  "the gaps roughly double" is withdrawn (Kalli 3): the season line prints only from this run.

## 5. The film evening (changed rule, both)
- A tell is checked at the first corner minute where the opponent's MODE matched it (pressure, loading up, tiring). A fade or slow
  start is checked at the round-2 or round-3 minute.
- A tell whose moment never came stays SEEN: no drop. Only a tell whose mode came up and did not show drops a level.

## 6. The weight (restored, John 9; capped, Kalli 12)
- Walk-in boxers' walking weight sits 2-4 kg above their class, so the career's first-hour cut stays.
- ASK FOR A KILO stays inside the smaller boxer's category width (rule 2.7.8); when it would cross, it is greyed with the reason.
  CHECK (John): the 2026 widths against the game's classes.
- TRAIN IT OFF: 0.3 kg for +8 tiredness.
- A MISS: re-matched on the night when the host has a fitting spare (1 in 3), otherwise the bout is off; the host takes 1 favour.

## 7-8. Favours and things that happen (rationed, John 6)
- A host asks for a late replacement at most once per show, only if your boxer fits the gap and is READY: about 1 ask in 6 shows.
- All asks wait for Monday and stop the clock once, as one need.
- The pull-out rate for the player's own bout is 35 in 100 in the final week (John: the middle of 25-50).
- Favour test target: an average club sits at 1-2, not 3.

## 10. Critics' points, each answered
| Point | v6 |
|---|---|
| K1 Tick over always right | state rules per stop; FIGHTWEEKPROBE4 by state; target each stop best 1 in 5 (4, 4b) |
| K2 BANKED too big | +0.5, measured size (4) |
| K3 "Roughly double" a guess | withdrawn; season line only from FIGHTWEEKPROBE4 (4b) |
| K4 / J Trips on the wrong week | WEEK BEFORE strip on this screen; cottage acts on the fight week; seaside cut (1, 4) |
| K5 / J All fight-week sparring late, no benefit | last sparring day; each night confirms a line (4) |
| K6 / J "+1 plan line" undefined | one chosen line one level up in round 1 (4) |
| K7 / J Film punishes untriggered tells | checked when the mode came up; else SEEN (5) |
| K8 Too few slots | slots by class; longer-rested boxer gets it; slot test 2+ (2, 12) |
| K9 Ring rust after every stoppage | counts from the suspension's end (2) |
| K10 Second decided number | the loss-below rule on his board (3, 13) |
| K11 / J Pass undefined | pressed Pass only; per-club count (2) |
| K12 Kilo past the width | capped, greyed with reason (6) |
| K13 Novice | "under 4 wins" (words) |
| K14 Shares in old words | the game's own words: Stamina, Power, Speed, Technique, Defence, Durability (code facts) |
| K15 Commute too narrow | a style partner, shown only when the file names a style (4) |
| K16 Mockup not this screen | redraw as one week + WEEK BEFORE strip, in the camp plan's look (his S455 ruling: the art stays consistent) |
| J Tank past its max | capped at 25, overflow shown (4) |
| J Food, coach absence unpriced | food in every price; coach away priced on screen (4) |
| J Who pays fake third party | savings from the boxer's job; fundraiser; mood favours a confident boxer (4) |
| J Pro pace | to his board (2, 13) |
| J Nationals missing | entry count and date on cards; sheet closed during a run (2) |
| J Assistant can't read goals | three new goal types (2) |
| J Fall-through floods the clock | asks rationed, Monday need, 35 in 100 own bout (7-8) |
| J First-hour weight beat gone | walking weight 2-4 kg over (6) |
| J Ticket share blank | $450, a game number (2) |
| J Assistant's pick | fallible, reasoned, season line against the best stop; probe target or cut (4) |

## 11. Menus (additions to v5's table)
| Menu | What it shows | Wired to |
|---|---|---|
| Fight week screen | WEEK BEFORE strip (trip, last sparring day); the capped tank with its overflow; the chosen Tick-over line; coach-away cost | FightWeek, CampPlace, TrainingLoad |
| Bout card | "bouts to entry n of 5", entry date; "passed 1 of 2" | BoutSheet, Nationals |
| Boxer card | savings a week from the background | Savings, Recruit |
| Goals (boxer page) | the three new goal types | FighterGoal |
| Money | fundraiser nights | GymBills |

## 12. Build order (changed probes)
1. Probes: FIGHTWEEKPROBE4 (by state, on BoutSheet), CAMPPLACE1 (per use, against a home rest week), BudgetProbe (away at $0, the
   fundraiser), the favour test (average club at 1-2), the slot test (2+ cards a sheet).
2-5. As v5.

## 13. Open for him (on the board after the critics)
- The pro road: "9 wins with 3 over ranked names", or keep "9 wins at any rank"; and the pace (a pro offer in about 1.4 seasons).
- A loss to a name below drops two places: yes or no.
- Savings from the boxer's own job ($25-75 a week by background): yes or no.

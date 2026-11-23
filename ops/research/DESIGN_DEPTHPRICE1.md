# DESIGN DEPTHPRICE1 - two solved choices given a price: the fight week's load, and the sponsorship or a day job (S543)

> S543 CODE CHECK (`DESIGN_DEPTHPRICE1_CRITIC_OPUS.md`, commit 8db852cf2): do NOT build either price as measured. Wrong on
> this page: the screen's tank was not the bout's tank (fixed 6e60558e4: the bout takes 2 a point over 50, cap 20, +8 for a
> bout inside 7 days); Rest up only rests the TANK's reading to 30; Train through's "+6 after the bell" was shown and never
> applied (line removed); the rival's approach has five answers, and the deal does feed back (loyalty -> approach -> a
> locked stipend). Both probes passed by construction or noise (the fight-week cells were two tiredness levels; six of the
> ten club cells were two cells counted three times). Verdict for both: CHANGE, re-probe, else cut.

Two small choices that exist in the game today and that a measurement found solved (one option best almost everywhere).
Each gets a price. Both prices were measured on a greybox before this page (`docs/DEPTHPRICE1A_RESULT.md` row 21,
`docs/DEPTHPRICE1B_RESULT.md` row 15); nothing is built yet. Score each choice on its own.
Six other prices were measured in the same two probes and FAILED; they are not proposed (listed in section 3).

## 1. The fight week's load (amateur bouts; `scripts/rules/FightWeek.gd`, screen `scripts/ui/modals/FightWeek.gd`)

An amateur bout has no camp. In the week of the bout the player picks ONE load for the boxer:

| Load | Off the tank at the first bell | Round 1 | Training kept for mastery | After the bell |
|---|---|---|---|---|
| Rest up | 0 (and the boxer is rested down to 30 tiredness, so tiredness costs nothing) | flat: an edge taken off round 1 | a fifth of the week | - |
| Tick over (the screen opens on it) | 6 | sharp | half | - |
| Train through | 12 today | sharp | the whole week | +6 tiredness |

The tank is the energy ceiling at the first bell. Tiredness over 50 also comes off it, 1 a point, up to 25, unless the
boxer rests up. Sparring nights in the week cost the tank too (3 or 5 each); they are not part of this page.

- TODAY: Rest up's flat round costs 2 under 40 tiredness, 1 from 40 to 64, nothing from 65 (`REST_UP_EDGE`).
  Measured: "always Rest up" is the best habit in 7 of 10 cells; Train through is the worst load in all 10.
- THE PRICE: Rest up's round 1 costs a flat **3 at every tiredness** (ring sharpness is what a rested week gives up), and
  Train through costs **8** off the tank instead of 12.
- MEASURED with the price (four weekly amateur bouts in a row on one habit, one boxer with a three-line plan against
  three calibrated opponents, ten cells from fresh to tired, 100 runs a cell): best habit by cell - Rest up 5, Tick over
  4, reading the card 1. A fresh boxer does better ticking over (by 0.3 to 4.7 wins in 100); a tired boxer does better
  resting up (by 3 to 12). The informed pick beats "always Tick over" by 3.1 wins in 100.
- MEASURED LIMITS: Train through is still best in no cell (2.5 wins in 100 behind Tick over on average). The mastery a
  load keeps never changed which load was best. The choice reads one printed number (tiredness): fresh = Tick over,
  tired = Rest up.

## 2. The gym's sponsorship or a day job (amateur boxers; `scripts/rules/DayJob.gd`, shown on the office desk and the money page)

Each amateur boxer of the club is on one of three deals. A professional never works.

| Deal | The club pays a week | The boxer loses to work |
|---|---|---|
| Full sponsorship | $250 | nothing |
| Half | $125 | 1 coached morning |
| Day job | $0 | 2 coached mornings |

An unhappy boxer may be approached by a rival club; the owner keeps the boxer with a promised club show or by matching
the offer (the full sponsorship, held 12 weeks).

- TODAY, measured over 78 weeks, five kinds of club, 680 bouts an option: wins per 100 are level (65.6 full, 64.4 half,
  65.2 day job), professional offers arrive at the same time, and the day job leaves the club $9,800 richer. Best by
  cell: day job 6, half 3, full 1. The full sponsorship is the weak option.
- THE PRICE: the job also takes EVENINGS. A boxer on a day job misses two of the week's pad evenings (Monday and
  Wednesday); on the half deal, one (Wednesday). The full sponsorship is untouched.
- MEASURED with the price: best by cell - day job 4, half 3, full 3. The day job ends $8,700 richer for 2.9 fewer wins
  in 100 (62.7 against 65.6); half sits between ($5,550 richer, 2.5 fewer wins).
- MEASURED LIMITS: the record's gap (2.9 wins in 100) is about one and a half times the measurement's noise (2 in 100).
  Professional offers still arrive at the same time on every deal (56 of 56 in each arm).
- A first price was tried and FAILED: the sponsorship growing $50 a week per win made the weak option ruinous (7 of 40
  clubs on the full sponsorship closed).

## 3. Measured and NOT proposed (each failed its probe)

| Choice | Price tried | Why it failed |
|---|---|---|
| Round pace (Push / Steady / Save) | Push spends more wind, Save loses its refill | at every size it is "always push", "it does not matter" or "never push" |
| The corner minute | the talk and the habit fix each take one of the second's three points | recovery is too weak to be a currency (all three points = 1 win in 100) |
| The sparring partner | a closer partner is a harder night | the price flattens the choice (5.7 -> 1.4 wins in 100) |
| Class nights | the class takes the coach's whole evening | passed its probe, but the owner has since cut the class-or-pads choice (class nights fill the evenings no boxer needs) |
| The fit-out loan | a late fee; then members who do not follow the move | too small, then too big |
| Diet Hold or Cut | a cut day builds less | camps and fight weeks already cut for the player: the switch does almost nothing |

The probes' own conclusion: a flat price does not make a decision; a choice becomes real when its VALUE changes with a
state the player can see.

## 4. Menus and what each is wired to

| Menu | Shows | Wired to |
|---|---|---|
| Fight week (before an amateur bout) | the three loads, each with its tank cost, round 1 word (sharp / flat), training kept, and the tiredness now | `FightWeek.tank`, `round_one`, `banked`, `tired_after` |
| Office desk and money page | each amateur boxer's deal, the weekly cost, the mornings and (new) evenings lost | `DayJob.count_of`, the week plan's pad evenings |
| Week plan | "Work" on the lost mornings and (new) on the lost pad evenings | `DayJob.lost_days` |

## 5. Feedback loops
- Load -> tank -> the bout -> the bout's toll -> next week's tiredness -> the load. Bounded: tiredness is capped, a week's
  rest takes most of a bout's toll off, Rest up resets it to 30.
- Day job -> fewer pad evenings -> slower mastery -> fewer wins -> less ticket money and reputation; nothing feeds back
  into the deal itself (the player sets it). The rival's approach reads the boxer's happiness, not the record.

# GROWTH SCOPE S531 - a careful gym grows (owner Q-S294-277: "Careful gym should grow")

Owner, S531 in chat, asked "should a careful gym GROW (wins and a pro bring members), or is the slow bleed the pressure you
want?": **"Careful gym grows"**.

## What the game does today (measured, tools/gym_survive_probe.gd, 180 + pilot careers, S531)
- Members follow the gym's name: target = (48 + 0.6 x reputation) x the dues draw (Membership.natural_members), held to the
  room (GymSpend.member_cap = the least of premises cap, coaching cap and equipment room). A win is +5 reputation
  (BoutRules.WIN_REPUTATION) = about +3 members of demand.
- Quick start: equipment room 66, premises 70, coaching 70. Members reach the room by week 26 and stop there.
- After two years one boxer has taken reputation from 10 to ~50-61: demand ~78-85 members, against a room of 70.
- Every careful lever was tried (GROW arm, pilot): one class night, the pro offer, cheapest kit first, fitness kit + the
  assistant, the youth section, a second walk-in. Members end at 70-72, cash $13,977 -> ~$6,000. Fitness classes and the
  youth section do not change it.
- THE WALL: the next premises (140 members, rent $3,400 vs $1,800) costs $12,000 to move into (GymUpgrades.PREMISES) and a
  careful gym never has $12,000 spare - cash only falls. The move would pay: +$1,600 rent a month against the size sponsor
  it brings (Thamesgate, $400 a week = ~$1,730 a month, GymUpgrades.SPONSORS) and ~+14 members (~+$490). The lump sum,
  not the move, blocks growth.
- Second wall: the walk-in signing needs cash a careful gym loses by ~week 30, and the starting unit has 3 places.

## The design (Claude's decision; the owner approves it before it is built)
1. FIT-OUT LOAN on the move: the premises card offers "Move now: $3,000 down, then $750 a month for 12 months" beside the
   cash price. One loan at a time; a gym 8 weeks below $0 with a loan running closes as today (no new rescue).
   Wired: Money > Premises (the move button shows both prices and the monthly line), the cash forecast (CashForecast:
   the instalments as known future costs), the month bill (a ledger line "Fit-out loan").
2. THE ROOM SAYS WHY: when demand passes the room, the members line says so in numbers ("Your name draws 84; the unit holds
   70") - GymSpend.member_limit already returns "premises"; the line adds the two numbers.
3. Wins bring members as today (reputation); no new rule until the loan is measured.
Probe pass lines (GROWLOAN arm vs GROW, 60 careers each, same rules otherwise): by week 104 at least half the GROWLOAN gyms
moved, their median members >= 85, median cash >= the GROW arm's, and no more closures than GROW.

## Order
1. Measure the loan in the probe (GROWLOAN arm, running S531) - no game change before the pass lines hold.
2. The owner approves the design (board question with this page).
3. Build: GymUpgrades.move_loan + GymSpend.move(c, loan), the premises card, the forecast and ledger lines, one test that
   walks a move on the loan end to end (golden path stays green).

## Measured S531 (full runs, 60 careers an arm)
- GROW (every careful lever, cash move only): 0/60 moved; members 70 [70..73]; cash $5,557; reputation 55 [43..67].
- GROWLOAN run 1: 12/60 moved, members 70 [70..83], cash $5,206 [$933..$6,300] - FAILS the pass lines. Probe defect: the
  sponsor the move brings was left on offer (never signed), so movers paid the rent and the loan without the $400 a week
  the move is for. Fixed (the arm signs offered deals as GymActs "deal" does); rerun running.
- Probe limit for every arm: ONE boxer all career. After the first week, new boxers come only through the recruit route
  (scout -> invite -> trial -> Roster.sign_prospect), which the probe does not play. With one boxer, reputation reaches
  ~51-55 in two years (demand ~79-81) - barely past the room. The next GROW round plays recruiting (a second boxer once the
  money allows) before any number in the design is judged.
- Recruiting added to GROW/GROWLOAN (invite a scouted prospect when 8 weeks are banked, sign on a good trial, up to 3
  boxers). Pilot (4 careers, GROW): 3 boxers each, reputation 168 [140..181] = demand ~149, members 75 (room 70 + kit),
  cash $5,447 - the move is still out of reach. With a full roster the room and the move price are the ONLY wall.
  Full GROW + GROWLOAN with recruiting runs next.
- CORRECTION (S531, GROWLOAN run 2): signing offered deals also signed IRONCLAD (Data.DEALS, $250 a week, on offer from
  day 0, no cost). No earlier arm signed it - PASSIVE / SENSIBLE / LEAN / GROW all ran without the day-one sponsor, so the
  "careful gym loses ~$3.5k a year" line (and Q-277's framing) was OVERSTATED: $250 a week is ~$13k a year. Run 2
  (loan + deals, one boxer): cash $39,792 [$26,649..$53,319] at week 104, 53/60 moved, members 83 [71..92]. This mixes
  the loan with the sponsor; the clean comparison (GROW vs GROWLOAN, both signing deals and recruiting) runs next.
  Still true with money in: members stop at the room; the room grows only by moving.
  The game does tell the player (Needs.gd ~line 101: 'A sponsor is waiting', S327) - the probe arms skipped it, a player would not.

## RESULT S531 - the clean comparison (120 careers; both arms sign deals, recruit up to 3 boxers, buy kit, fitness, youth)
| arm | moved | members@104 | cash@104 | closed | reputation |
|---|---|---|---|---|---|
| GROW (cash move only) | 1/60 | 75 [72..79] | $4,605 [$3,519..$12,090] | 0/60 | 174 |
| GROWLOAN ($3,000 down, $750 x 12) | 36/60 | 140 [73..158] | $5,729 [$3,741..$25,299] | 0/60 | 176 |
All four pass lines hold: 60% moved, median members 140 (>= 85), cash above GROW's, no extra closures.
With three boxers the name draws ~150 members; the $12,000 lump sum is the only thing between a careful gym and that.
Next: the owner approves the design above (board question with this page), then the build in "Order" step 3.

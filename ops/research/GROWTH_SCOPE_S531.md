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

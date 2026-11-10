# R55 Two boxers, one coach: who gets the pads - design map v2 (S425)

One of the seven mechanics he chose (S402: "R55 Two fighters, one coach: who gets the pads", reshapes the Week). It also
answers Q-S294-172 on the staff wall: "you can make better personnel dashboard." Measured BEFORE it was written
(tools/pads_for_two_probe.gd: the week's own PadWeek.project, and 300 bouts a cell through the game's bout).
Picture: docs/mockups/s425/pads_rota_v2.png. v1 and its two critics (depth 4 each): pads_rota.png, pads_critic_*.md.
His bar (S425): "i expect all new mechanics to be wired and shown properly on the correct menus and be deep enough for
a critics +7/10".

## What the game does today
Every boxer gets the hired coach's full pad rating on every pad night, however many boxers there are and whatever
evenings he works. Luke Reid's card says "three evenings a week"; nothing reads it. Only one coach can be hired.

## What the measurements say
| Asked | Answer |
|---|---|
| A new move, 3 pad nights a week | usable in week 2 with Reid every night or on half his nights; week 3 with no coach |
| A combination (Jab-Jab) | week 4 with Reid every night; week 5 on half his nights or none |
| Hale (58) every night against Reid (74) every night | the same week on every card: being there matters, how good hardly |
| Fight night with all four plan answers in her hands | 40.0% won |
| One plan answer she cannot do yet | 38.0%, 36.0%, 31.0% or 26.3% won, by the answer (tie up, pivot out, Jab-Jab, step back) |
| No plan answers at all | 18.7% won |
| Her combinations sharp (60+) instead of usable | 41.0% won: 1 point |
So the coach's hands are worth ONE WEEK on a card, and that week is worth up to 14 wins in 100 when the card is an
answer her plan needs and her fight is that week. The stake is one question per boxer: **will the card her plan needs
be in her hands by the bell?** Past usable, pad time buys almost nothing today (see the build order, step 1).

## The rule
- A coach works his evenings: Reid Monday, Wednesday, Friday. Each evening he runs the club class and, inside it,
  holds pads for ONE boxer.
- The night can be split half and half between two boxers (each gets half the lift).
- He can take two boxers whole the same evening: the class is off that evening, $115 lost (a third of the $350 the
  classes bring a week).
- A pad night with no coach: a clubmate holds (today's no-coach night).
- The second club coach ($280, already hired for members today) holds pads Tuesday, Thursday, Saturday at 45.
- Hale ($1,090, full time) works every evening and takes two boxers whole without losing the class: the answer for
  three boxers, not for two.
- A boxer who is injured or resting gives his evenings back by himself.

## The decisions, in order, each with the case where it is right
1. **The plan picks the card (Playbook).** An answer she cannot do yet carries a star and its price ("needs 2 weeks of
   pads"). *Plan around what she already owns* when the coach is short this camp; *take the stronger answer* when his
   evenings are free. This is where the scarce evenings get their value.
2. **Booking (Fights, the offer card).** "Overlaps Danny's camp 3 weeks: both need Reid Monday and Wednesday."
   *Take it* when one of them already owns the starred card; *pass* when both are learning theirs and neither fight is
   worth $230 a week. Asking for a later date arrives with R37 (the amateur ask).
3. **Monday: the lay (Club > People and the Week).** Reid lays his evenings by one plain rule: the nearer fight first.
   He does not weigh whose card is worth more; the player can. Each lay shows its price before the click:
   - *The nearer fight first* (free): right when the other boxer's bell is weeks away.
   - *The other boxer first* (free): right when his starred card is worth more (step back: 14 in 100, against 9).
   - *Split the nights* (free): right for single moves, which land the same week on half his nights; wrong for a
     combination, which then lands a week late for both.
   - *Both whole, no class* ($115 an evening): right for a short overlap; two evenings a week for three weeks is $690.
   - *Move a pad night to his free evening*: right when it exists; it costs her the rest evening it lands on.
4. **Hiring (Club > People).** *Drop the class* for a short overlap ($230 a week while it lasts). *The second coach*
   ($280 every week) once two boxers are in camp most of the year: he also carries 40 more members and a roster place.
   *Hale* from the third boxer. *Reid alone* with one boxer.
5. **The boxer who goes without (Fighter page).** Third week running in camp with none of the coach's evenings: she
   "Feels second" (morale 5 down, shown on her card before it happens: "one more week without Reid"). The player
   answers: give her an evening now, or promise "next camp is yours". The promise is one of R58's three answers: kept,
   morale 5 up; broken, 10 down and the bigger gym's offer lands easier.
6. **After (the week review, the Why).** Not a decision: the lesson. "Reid held Monday and Wednesday: Jab-Jab 26 to
   31." After a loss: "Step back was not ready: Reid was with Lucy in weeks 2 and 3."

## Where it is shown and wired (one row per menu; each gets a test)
| Menu | What appears | Wired to |
|---|---|---|
| Fighters > Playbook | the star and "needs N weeks of pads" on an answer she cannot do yet | PadHands forecast per card |
| Fights > offer card | the overlap line with the evenings both need | camp dates of the roster |
| Home, Monday needs | "Lucy and Danny both need Reid Monday and Wednesday" opens Club > People | the clash list |
| Club > People | the rota (a face and the card in each evening), the class money under it, the bells timeline, the lays with their price, the hire rows | PadHands lay; GameMoney classes |
| Fighters > Training | a Coach row on the week (who holds each of her pad nights); the bell and the star on each drill card | the same lay |
| Club > Money | "Classes $350, two evenings off: $120" | the evenings taken |
| Fighter > Overview | "Feels second" and the promise | morale, R58 |
| Week review, the Why | who held; the cause line | the week's record |

## Numbers
| What | Number | Source |
|---|---|---|
| Hands per coach | one boxer an evening; two halves; or two whole and no class | real: a camp pad session is 6 to 12 three-minute rounds (J62), 25 to 45 minutes of one man's arms inside the club night; the coach critic: "I never give one boxer the whole night" |
| Reid's evenings | Mon, Wed, Fri | his card today; English clubs train three nights |
| Class money lost | $115 an evening | the game's $350 a week over three evenings |
| Second club coach on pads | 45, Tue Thu Sat | INVENTED; his $280 wage is in the game |
| Hale takes two whole, class kept | rule | INVENTED (his card: "every day") |
| Feels second | third week in camp with no evening: morale -5 | INVENTED; a win is +8, a loss -12 today |
| Promise kept / broken | +5 / -10 | INVENTED, shared with R58 |

## Build order (after his OK)
1. Sharp and signature pay on fight night (own small job, measured on 300 bouts): today sharp is 1 point over usable,
   so pad time dies once a card is usable. Target: sharp worth about what usable is (3 points), set by measurement.
2. Pure module PadHands.gd + tests (Qwen or Goose): evenings per coach, the lays, the per-night rating each boxer
   gets, the class money lost, the bell answer per card, the clash list, "feels second". Control arm: one boxer and
   one coach on his evenings.
3. PadWeek.run_week takes a rating per night (it is 464 lines: the rule lives in PadHands). GameMoney reads the
   evenings off. One balance change today: a boxer on four pad nights with Reid gets him on three.
4. Screens (Cursor, Ludo paint first): Club > People from the picture; the Coach row, bell and star on Training; the
   star on the Playbook; the offer's overlap line; the Home need; the Money line; review and Why lines.
5. One golden-path test walks it: two boxers in camp, the clash on Home, the lay changed on People, the week run, the
   review's row, the bout, the Why.

## Left out, and why
- "You" as a pair of hands (sim veteran's 10/10): nothing in the game costs the player's own evening yet, so free
  hands would end the sharing. Worth it only with a job that competes for the evening.
- One corner for two boxers on the same show (coach's 10/10): bouts on a card run one after another and the player
  corners both; no clash to decide today.
- Coaches with a lean per card type: a second number that the measurements say would not move the week.

## Questions for the operator
- The rule, the lays and the screen as drawn: build it?
- Step 1 first (sharp and signature combinations pay more on fight night)?

DEPTH: 5/10

# AMATEURWEEK1 judged from the ring apron

Seat: amateur referee and judge, fifteen years of club shows; also a player of management games. I read the critic pack, the access page and
the design (`docs/mockups/s430/amateurweek_map.md`), and checked its claims in the code. I opened no other opinion.
My drawing of the main screen: `docs/mockups/s430/amateurweek_10_referee.png` (source `amateurweek_10_referee.html`).

## A. The score: 5 out of 10

It has the right bones and I would play it for about five hours, not twenty. Three reasons fix it at 5.

1. **The big decision is which bout, and that one has an answer that is nearly always right.** A soft name at home, on the later Saturday,
   wins on every line the sheet shows (money, members, judges, time to prepare, risk). Rank is the only thing pulling the other way, and
   rank is worth two wins on the road to the pro offer (7 wins and top 3, or 9 wins at any rank). So the sheet is solved in the first month.
2. **The week itself is small and mostly a look-up.** The design's own target is 10 to 12 wins in 100 between the best week and the laziest.
   At 9 to 11 bouts a year that is ONE bout a year per boxer. "Reid runs this week" sits somewhere in the middle, so doing it by hand is
   worth about one bout every two years per boxer. And most picks read off the file: "Slow to start" means stay sharp, "Fades" means rest up,
   young means train through. A choice the file answers is a quiz, and the player learns the answers by the third bout.
3. **Too many of its prices are missing or cancel out.** Nobody knows what a point of tank is worth (the design says so itself, section 3).
   "Flat in round 1" has no size. "Favour" is used three times and never defined. "Hold and hope" has no chance. A kilo of weight changes
   nothing in a bout today. Until those have numbers on the screen the player is picking between labels.

What holds it up at 5 and not lower: the coach's evenings shared between four boxers and shown by name is a real, new pull that gets harder
as the club grows; the bill before the yes is the right screen; pull-outs, the fight-day scale and "one click when nothing is at stake" are true
to club boxing and good manners toward the player.

## What I checked in the code (the design's claims about today's game)

| Claim | True? | Where |
|---|---|---|
| A bout without a camp loses 1.5 points, and the Why says "No camp" | Yes | `scripts/rules/BoutRules.gd` line 56, used at 200; the line at 281-282 |
| Every bout pays the club $450 | Yes, anywhere: there is no home or away today | `BoutRules.gd` 89; `scripts/state/BoutNight.gd` 384-386 |
| Tired legs empty the tank at the bell | Yes, but today it costs 2 a point over 50, up to 20, and ONLY after a camp. The design halves it (1 a point, up to 12) and charges everyone | `BoutRules.gd` 34-36, 163-168 |
| A normal week leaves tiredness near 60, so "train through = about 12 off" | Fits | `BoutRules.gd` 163-164 |
| One stoppage ban of 30 days | The code has a ladder: 30 days, 90 if stopped again inside 90 days, 365 for a third in a year | `scripts/rules/InjuryRoll.gd` 12-16 |
| Bouts come 2 to 4 weeks out; next offer 10 days after a bout | Yes | `scripts/rules/AmateurBooking.gd` 10-11; `scripts/state/Bouts.gd` 44 |
| Novices (up to 10 bouts) meet only novices | Yes | `AmateurBooking.gd` 12, 30-34 |
| "RankLine shows the line; this is the rule behind it" | Not today. The table is net wins, then wins, then rating: any win climbs. "Take their place" is a new rule | `scripts/rules/RankLine.gd` 7-14 |
| The file has four facts; film asks best punch, habit or when | Today: record and game are free; best weapon, EACH habit (can be several) and a weakness are hidden. "When" is the weakness line. Say which four | `scripts/rules/OppFile.gd` 44-48, 66-80 |
| A film answer turned into a plan line is worth something | 0.4 a line, at most 1.2 | `BoutRules.gd` 54-55 |
| A miss at the scale | Today costs $300. The design says "a favour". Say whether the $300 goes | `BoutRules.gd` 88 |
| A replacement "up to a kilo heavier" | I found no rule in `scripts/rules` or `scripts/state` where a kilo changes a punch or a round | search for weight edge words: nothing |
| Home judges tilt close rounds | Today the three cards are worked out from rounds won; no judge sees a close round | `BoutRules.gd` 244-252 |

## B. The hunt

**The play that is always right**
- **The soft home name.** Home: +$450, +8 members, +5 reputation, close rounds your way. Away: -$40, +3 members, +2 reputation, close rounds
  against you. Away is worse on every line and has nothing of its own. A loss to a name above "costs nothing" in rank but costs mood
  (-12), a member, reputation and the risk of a stoppage; a win over a name below costs nothing at all. Nine soft home wins reach the
  pro offer with no rank. Rank's whole worth is "two wins sooner".
- **The later Saturday.** Fourteen days gives two film evenings (one a week), time to walk four lines, and time to lose the weight by
  training. Seven days gives one of each. The earlier date's only gain is that the next sheet comes a week sooner.
- **Train through for anyone with room to grow.** Tick over buys 4 points of tank for half a week of training. Half a week is kept for good;
  4 tank is one night. The design says it itself ("a young boxer should train through"). That is a setting per boxer, made once.

**The exploit**
- **The cap on tired legs.** Legs cost 1 a point over 50, "at most 12". Train through is already "about 12 off", so it sits on the cap.
  "Train it off" adds tiredness, which then costs nothing more. So: train through, train the weight off, make the scale, bank the whole
  week, stay sharp: 12 off in total. Rest up and eat a kilo off: 10 off, flat, a fifth of a week banked. The first wins by a mile, and the
  only brake (overreached at 80, injury risk up from 72: `InjuryRoll.gd` 107) is not on the bill.
- **Fishing the sheet.** A pass is free and the next sheet has "different names" in 7 days. Only passing the SAME club twice is punished, and
  a sheet has three clubs on it. Pass until the soft home name turns up; each pass costs a week.

**The free choice**
- Pass (above). "Go home" after a pull-out: mood -3, when a loss is -12. Taking the 14-day bout over the 7-day one.
- Staying "can take a bout in 7 days: yes". The design never says what walking light between fights costs, so everyone always walks light.

**The dead option**
- **Hold and hope.** The scale forecast is on screen. Hope for what? No chance is given.
- **Resting against Building.** No difference is stated. And since the next sheet only comes 21 days after a bout, the switch can only take
  bouts away: Ready is right for every healthy boxer.
- **Asking the film "when" in a 7-day week.** The film evening is inside the week it is meant to shape; by Wednesday the shape is half spent.
- **Tick over**, for most boxers (see above): dearer than it looks beside Train through, and not fresh enough beside Rest up.

**Decided once, never reopened**
- Week shape per boxer. Walk the lines or not. "Over by half a kilo or more: ask; under: eat" (ask costs the other corner +5, eating a
  kilo costs you 10: one threshold, learnt once). Film question order (best punch first, because it is the only one that buys a plan line).

**Numbers that make a choice not matter**
- **Home judges.** With the game's own spread (`BoutRules.gd` 61; `scripts/rules/Exchanges.gd` 12-14) a round lands within one point about 7
  times in 100. Six in ten instead of five in ten on those moves under 1 round in 100; home against away about 1.5. Since a turned round
  only turns a bout when the other two are shared, that is about 1 bout in 100. As a judge I can tell you the home lean is bigger than that.
- **A line at 80%.** A whole plan is worth about 14 wins in 100 (pack: 59 against 45). One line of five at four-fifths is about half a win
  in 100. Nobody will feel it, so nobody will spend a pad place on it.
- **Money.** The design's own sum: more bouts, less money ($8,000 a year against $12,600 today for four boxers). Nothing says what fills it.

**Untrue to club boxing in a way a player would feel**
1. **Nobody cuts to the class limit for a club show.** Club bouts are made at the weight the two boxers walk at, with an allowed gap; the
   class limit is for championships. The real question at every show is "mine is 60.8 with 8 bouts, yours is 59.4 with 6: do we box?" Giving
   or taking weight and experience is THE club-show decision and it is only in the late replacement here. Making a cut out of every
   Saturday (nine a year a boxer) will feel like a chore, not like boxing.
2. **Home is a coin on each bout.** A club runs its own show once to three times a season, and that night every one of its boxers is on.
   Here four boxers box "at home" about 18 times a year on separate nights. The best night in club boxing, the whole club on one bill with one
   coach and one cutman's bucket, is missing. (The hosted show is planned later; home bouts should live there.)
3. **The forced 21 days.** A boxer who won on points can box next Saturday; the rest is the coach's call. A fixed wait takes away the
   decision the Ready switch pretends to give.
4. **Pull-outs are too tidy and one-way.** They come on Friday night and at the scale ("ours is 0.9 over, do you still want it?"), and the
   call comes TO you as well ("our boxer lost an opponent, can yours box Saturday?"). The other corner also asks YOU for a kilo.
5. **Nobody spars in fight week for free.** A cut or a knock on Wednesday takes the boxer off the show. Train through has no such risk here.
6. **A stopped boxer stopped again is out for three months, not one.** The code already knows this; the design flattens it to 30.

## C. Every menu in the table

| Menu | Missing | Useless | What its options change |
|---|---|---|---|
| Home | The club's evenings as ONE board (the trade is between boxers; one boxer's row cannot show it). Days to the bell. A "Reid runs it" button on the row | Nothing, but "one open pick" hides that the picks have an order (film before shape before lines) | Opens the pick; nothing else |
| Fights: the bout sheet | Weight and bouts given or taken per name; the corner clash BEFORE the yes; novice bouts left; favours per club; how many passes each club has left; who you watch (it is in the text, not in the table); the stoppage ladder; all four boxers' sheets together | Resting against Building; the switch as a whole while the 21 days stand | The pick sets date, money, members, rank, what is known, and closes two bouts. The switch only stops sheets |
| Fights: the names at each weight | An action. By the owner's rule a list with no button goes: add "Ask for this name" (agreed, not built) and "Spend the film on this name". Stale date, rematch mark, home club | "Which answer your boxer owns" unless a click drills it | Nothing today: read only |
| Bout page: the bill | Reid's week beside yours; the other boxer's tank; what a point of tank does in rounds; the overreached line; whether picks can change after the yes | The three budgets if they are read-outs and not buttons | Each pick moves tank, sharp, lines ready, scale margin and the win band; the yes books it |
| Fighter page, Training | The third number (what the week banks) on each shape; the size of "flat"; the days that are too late to count, hatched | The film evening on each boxer's own board: it is one evening for the club, show it once | Shape sets tank, sharp and growth; film night moves two pad places |
| Fighter card | By how much ("0.6 over") and the button to hold weight between fights, WITH its price | "Yes / no" while walking light is free: it will always say yes | Nothing: a flag |
| Tape room | Picking the name (any on the sheet, before the yes); what the answer costs next (a line must be walked); the stale date | "When" inside a 7-day week | The question opens one fact; the fact allows a line, a corner read or a shape |
| Playbook, Game plan | A "walk it" button that books the pad place and names who loses it | "80%": too small to feel | Ready or not; which line to drop |
| The guide | Stops after three bouts | - | None, by design |
| Continue button | A stop for the short-notice call; a stop when the other corner asks for weight | Stopping for two shows on the night: ask at the yes, when it can still be avoided | - |
| Fight night | At the scale: both weights and the deal ("the other boxer is over: box anyway, or claim the bout off"); both tanks at the bell | - | The corner picked; the scale deal |
| Result and the Why | "Your week against Reid's: +3 in 100"; the close round and which way the home card gave it | - | "Train X next week" (exists) |
| Week review | An action ("Samira has first call next week"), else it is a ledger | The running account as plain information | None today |
| Money | The season's gate at this home and away mix; what replaces the lost $4,600 | Two lines with no button belong in the forecast, not as a feature | None |

## D. One boxer, three bouts

A 21-year-old lightweight, 4-1, walks 0.8 kg over, far from the ceiling.

**Bout 1, the easy one.** The sheet: a soft name at home in 14 days, a ranked name away in 7, an unknown at home in 7. I take the soft home
name in 14 days without thinking. Weight: train through and train it off (the cap makes it free). Shape: train through. Film: not worth
Samira's pads. Lines: leave them. Real decisions: none that hurt. One click by Reid would have cost me perhaps 4 tank and half a week.

**Bout 2, the hard one: number 2, away, 14 days.** Here the design works. Two film evenings: I ask the best punch first so the line can be
walked, then "when" to set the second week. Each evening puts a team-mate on the bag, and I can see whose uppercut waits a week. If the
file says the opponent fades I want the tank, but my boxer is 0.8 over, and now the cap trick fights the rest-up plan: eat it off (8 tank), ask (the opponent +5,
a favour I do not understand), or stay on the legs. Four linked choices, a good ten minutes. This is the 7 out of 10 the design is reaching
for, and it happens in perhaps one bout in four.

**Bout 3, the opponent pulls out on Wednesday.** One replacement: less known, a kilo heavier or three bouts more. A kilo does nothing in today's
rules, so I look at one number, the win band, wide because the file is empty. The week is already spent and going home is mood -3, so I
take it unless the band is ugly. The film line and the walked lines were for the first opponent and are wasted; the design does not say so, or
whether the 21 days start if I go home. The second and third pull-outs of the season (there will be five to seven across four boxers) ask
exactly the same thing.

**Does the third time ask anything new?** Only when two boxers collide: two fight weeks in one week, two shows on one night. That is the
part that stays alive, and the design gives it two sentences.

## E. To reach 10/10 (most important first)

1. **Price the tank, show it in rounds, and show Reid's week beside mine.** Run the tank-price probe first. On the bill print three win
   bands: the sheet, Reid's week, your week. If your picks cannot beat Reid's by 3 in 100, the bill opens pre-filled and one click takes it.
   If the best week against the laziest measures under 8 in 100, stop and redesign: it is paperwork. Screen: Bout page bill, and "your week
   against Reid's" in the Why.
2. **Make every bout spend something: the ten novice bouts.** Show ten pips on the sheet. After the tenth the sheet draws open-class names
   (about 4 points stronger, 11 to 30 bouts). A soft win now burns a pip. And kill the soft farm: a name 6 or more points weaker (the game
   already has this line, `Matchmaking.gd` 42) pays half the gate, +3 members not +8, and does not count toward the pro offer. Screen: bout
   sheet, fighter card.
3. **Give away its own prize, and define the favour.** Home gate = the seats your boxer sells (members / 15 + 4 a win, most 120) x $5,
   not a flat $450. Away = the van, plus ONE FAVOUR with the host (most 3 a club). The top three names take bouts only on their own show
   7 times in 10, so the climb is away. A favour buys: a kilo, first pick from that club's names, a late replacement for your boxer. Lost
   by: passing that club twice, pulling out, missing the scale. Screen: dots per club on the sheet and on the bill.
4. **Match by real weight, not the class limit.** A club bout is made at both boxers' weights with a 1.0 kg gap allowed. Each 0.5 kg
   heavier at the bell is worth +2 tank; each 3 bouts more is worth +1 point (probe both). The four scale answers appear only when over the
   gap. Legs and scale costs ADD, no shared cap (most 25), and the bill shows the overreached line. "Hold" shows its chance (the club
   scale reads 0.2 kg either way). Cuts to the limit stay for the nationals, with the camp. Screen: every name on the sheet says "you give
   2 bouts, 0.3 kg"; the Scale panel.
5. **Let the player choose the gap between bouts and put a price on fight-week sparring.** Remove the fixed 21 days: Ready means a sheet
   every Monday; a bout inside 14 days of the last starts 10 tank down with injury risk x1.5. Train through means sparring: 3 in 100 that a
   cut takes the boxer off the show (a favour lost). Now Ready, Building and the three shapes are real. Screen: the switch, the Legs panel.
6. **Pull-outs with three answers, both ways, and at the scale.** Replacement (with the weight and bouts price from change 4), a
   no-decision exhibition (keeps sharp, half the gate, no rank, no pip), or go home. Twice a season the call comes to you: "can yours box
   Saturday?", four days out, +2 favours, no week at all; only a Ready boxer inside the gap gets it. At the scale: "the other boxer is 0.9 over: box
   (their +4 tank) or claim it off (your favour +1, no bout)". And the other corner asks YOU for a kilo. Screen: Continue stops; fight night.
7. **One board for Reid's evenings, and let film be spent before the yes.** Six pad places as faces, drag to move, on Home and Fights. A
   film evening may be spent on any name on the sheet BEFORE picking: now film is "choose better" against "prepare better". The second
   coach the game already sells ($280 a week) adds two places and a second corner at 7 in 10: the money link. Screen: Home, the bill.
8. **An unwalked line does not come out in round 1** (not "80%"), and the Why says "the counter was not there until round 2". "Flat" gets
   its size on screen: round 1 at -1.0. Screen: Game plan, Legs panel, the Why.
9. **Keep the stoppage ladder and print it:** "stopped: 30 days; stopped again before 14 June: 90". After one stoppage the next hard bout
   is a different question. Screen: the risk tile on each bout.
10. **Home lean worth feeling:** close rounds (within 2 points, about 15 in 100) go home 7 times in 10, and the Why names the round. Until
    the hosted show is built, call home bouts "your town" and say the home show is coming. Screen: the sheet, the Why.
11. **Close the money hole in the open:** print the season's gate at the current home and away mix on Money, and tune seats so four boxers
    bring about what they bring today ($12,600).

## F. The drawing

`docs/mockups/s430/amateurweek_10_referee.png`, 1920x1080: the bout sheet on top, the week's bill for the picked bout underneath, the yes at
the bottom right. It shows changes 1 to 5, 7 and 9: novice pips and favours in the boxer's strip; weight and bouts given or taken on each
name; the corner clash before the yes; the scale against the real gap; Reid's six pad places as faces with the film night and who goes on the
bag; three shapes with tank, sharp and what the week banks; both tanks at the bell and three win bands (the sheet, Reid's week, your week).

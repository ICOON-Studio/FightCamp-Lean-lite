# CLUBWEEK v4: blind review by a gym owner-manager (members business plus an amateur squad)

Read: CRITIC_PACK, CRITIC_ACCESS, CLUBWEEK_MAP_V4_S432 (whole), clubweek_v4.png, fightweek_v3.png, road_v3.png, the Boxing Manager compare report,
SCOPE_FOUR_FIGHTERS_S428, and the code behind the claims (DuesLevers.CLASS_WEEKLY 350, ProDebut, Roster/Matchmaking GYM_SHARE 0.25, BjjSide.teach_saves,
BeltRoad.EARLY_DEBT 0.25, NoGi.CLASSES_PER_WEEK 3, StripeCall loyalty, ClubShow). The map's code claims check out.

## 1. Depth: 7 / 10
Coach time really is the scarce thing in a club, and v4 makes one Monday choice cost something in three places at once: cash (the class night), loyalty
(who goes short) and a bout (wins in 100). Home or away now reaches the professional debut through fans. That is real depth. It stops at 7 for four reasons:
- Loyalty is only a stick. Above 50 it buys nothing, so the best play is to keep everyone at 51.
- "Home" bouts exist without the club hosting a show. In real amateur boxing a home bout IS your own club show. The show is in this version's scope (S428 item 4)
  and the map pushes it to later, so the biggest money night of a club year, and the natural place to spend favours, is missing.
- Two answers beat the others outright: "Tell it straight" is free +3 at coachability 60+, and the sizes on the chips risk turning the board into a
  pick-the-biggest-number puzzle unless the three kinds of size (wins, weeks, dollars) stay apart.
- The members business, which pays the rent, only shows up as +$117 a class night. A beginners' class is where a gym finds its members, and the map does not say so.

## 2. Options
MISSING
- Book your own club show: date, filling the card (spending the favours other clubs owe you), which of your boxers go on it, and the ticket forecast against the
  $3,500 night (ClubShow.gd already exists).
- Away travel cost (a minibus or fuel, about $40 a trip). Today away costs nothing, so the only price of the climb is the gate you lose.
- A reason to raise loyalty: a loyal senior runs the members' hour or a kids' session, holds pads (this exists), or brings a friend in as a member.
- The terms when a boxer turns professional, as a real club choice: 25% (club pays the $1,105), trainer's 10% only (the boxer pays the licence, loyalty +8), or
  25% plus a seat until the debut. Today it is decided automatically by loyalty.
- What a class night does for members: a beginners' class should turn some of its people into monthly members, not only bring cash on the night.
- A boxer's own local sponsor, earned through fans: a small weekly sum toward the seat, lost if the boxer leaves.
- Who goes on which show for Ana: an open is drawn as a card, but there is no choice of which open to enter, or whether to skip one.

USELESS OR WEAK AS WRITTEN
- "Tell it straight" at coachability 60 or more: free +3, beats both paid answers. Give it a price: once every 8 weeks, or a mood cost.
- The "Sell tickets" pull costs a pad place. Selling tickets happens at the boxer's work and among family, not on the coach's pads. Make it the boxer's own evening
  or morning, or drop it once the club show sells through fans.
- The mood alone-rate 0.7 / 0.6 / 0.5: at 0.1 apart it will not show in a season (MOODRATE1 is right to doubt it). Widen it or tie mood to something visible,
  for example the Low fighter's pass, which is already in the map.
- "Two of yours on one home card: gate +$300": once the club show exists, this is part of the show's ticket draw (ClubShow.PER_HOME_BOXER). Do not keep two rules.
- Drawing mismatch: fightweek_v3.png still says "Pass: 7 days, mood -2"; the map says loyalty -2. Fix the picture.
- Bout cap "up to 9 a year" against J_MATCH1's "a senior can box about 18 a season" in the scope note: pick one and say where it comes from.

## 3. New mechanics (inside this scope only)
| Mechanic | What the player decides | What it changes | Real-world basis | Needed for this version |
|---|---|---|---|---|
| OUR CLUB SHOW (fold HOSTSHOW1 into this map) | Date (every 12 to 16 weeks), fill the card with owed favours or ask for bouts, which of yours box at home, risk the $3,500 | Home bouts come ONLY from your show or a shared local one; favours become a two-way ledger (they fill your card, you fill theirs); fans and members fill seats; one night can make or lose a month of rent | ABC clubs raise most of their money on 1 to 3 shows a year (permit, doctor, officials, raffle, tables); other clubs send opponents and you return the favour | YES: it is S428 item 4, and without it "home" has no source |
| HELPERS (loyalty's upside) | Let a loyal senior (70+) run the members' first hour, or a kids' session | +2 pad places for Coach, the helper's own evening gone; loyalty becomes worth earning, not just protecting | ABC clubs run on volunteers; senior boxers take the England Boxing Level 1 coaching award and help with classes | YES: without it loyalty is only a stick |
| THE TERMS AT TURNING PROFESSIONAL | 25% with the club paying the $1,105; 10% (trainer only) with loyalty +8; 25% plus a seat to the debut | The club's money from the professional for the rest of the career, against the boxer staying | UK pros sign with a licensed manager; the amateur coach often stays on as trainer for the trainer's share | YES: it is the version's last big decision and today it is automatic |
| CLASS CONVERSION | Nothing new to press: the class night's line shows "+1 member every 2 weeks" | Class nights feed members, members feed show tickets and the debut | Pay-as-you-go beginners' classes are how gyms recruit monthly members | YES, as a number on the existing switch |
| A BOXER'S OWN SPONSOR | Accept a local sponsor's offer when a boxer's fans pass a threshold (logo, a photo day costs an evening) | A small weekly sum toward that boxer's seat; lost if the boxer leaves | Local businesses sponsor UK amateurs' kit and travel and small-hall pros' shorts | No: worth it, can wait |
| AWAY TRAVEL | Fix the minibus, lifts from parents, or home only (as a twist and a cost line) | Away bouts cost $40 a trip; climbing has a price in money too | Every club pays fuel and minibus costs for away shows | YES as a cost line (small) |

## 4. To reach 10/10 (most important first)
1. Bring the club show into this map: a SHOW strip on Club week (date, card filled n of 14, closes on), a card-filling panel (spend owed favours, ask a club,
   put your boxers on it), the ticket range and the night's net from ClubShow.preview, members from tickets (ClubShow.TICKETS_PER_MEMBER). Make HOME on the bout
   sheet mean "on our show or a shared local show"; with no show booked, home cards come only from a shared show. Delete the separate "+$300 two on a card" rule.
2. Make favours a ledger both ways: "we hold" (dots, spent to bend terms as now) and "owed to us" (bouts other clubs will put on our card). Boxing on their
   show earns one; filling our card spends theirs.
3. Give loyalty an upside: at 70+ a fighter can run the members' hour (HELPERS: +2 pad places, that fighter's evening gone), takes a short week without the -3
   once a month, and at 85+ brings a friend in as a member. Show "Loyal: can run a class" beside the bar.
4. Turn the professional's terms into a choice on the Pro offer screen (25% club pays; 10% trainer only, loyalty +8, the boxer pays the licence; 25% plus a seat).
   Keep "under 50 signs with an outside manager" as what happens if you do not offer the 10% option to a Wavering boxer.
5. Price "Tell it straight": +3 at coachability 60+, then not again for 8 weeks with that fighter; under 60, -3. Probe that no talk answer wins more than 2 times in 3.
6. Show sizes in three separate colours and never add them: wins in 100 (green), weeks to the target (blue), dollars (gold), loyalty (purple). "Your deal against
   Coach's" prints all three side by side, never one sum. SEASON1 should fail if a bot that always takes the biggest green chip wins the season.
7. Class night line: "+$117, +1 member every 2 weeks" (a share of the class becomes members; measure in MONEYFOUR2 with the show included).
8. Away costs travel ($40 a trip, a twist card can change it), shown on the AWAY chip.
9. Move "Sell tickets" off the pad places: the boxer's own evening (alone), or it simply comes from fans and the club show.
10. Mood: widen the alone rates (0.8 / 0.6 / 0.4) or drop them and keep only the Low fighter's pass; let MOODRATE1 decide, but decide before the build.
11. Fix the drawings and numbers: "mood -2" on the fight week's Pass button; one bout cap per year with its source; Ana's open as a choice of which open to enter
    (or skip) on the sheet tab.
12. Write the new menus into section 6: the show strip and card panel (Club week, Fights, Club > Money, Home need "fill our show"), helpers (Club week counter,
    Club > People), terms (Pro offer, Club > Money), travel (bout sheet card, Money).

## 5. Is the mechanic set complete for this version?
NO as written, YES with items 1 to 4 above. The map closes the list without the hosted club show, which the owner put in this version's scope (S428 item 4) and
which is what "home" means in amateur boxing. Without it favours have only one direction and the money has no big night. With the show folded in, loyalty given
an upside (helpers), and the professional's terms made a real choice, the set covers everything a club owner decides from the first amateur bout to the first
professional fight. After that: cut by the probes, never add. The boxer's own sponsor can wait.

## 6. My 10/10
`docs/mockups/s432/critics/v4_owner_10.png` (from `v4_owner_10.html`): the Club week board in week 9. The season strip includes OUR CLUB SHOW. A HELPERS counter
shows Tess running Monday's class. Favours show both what we hold and what is owed to us. Pulls are coloured by kind of size. A show panel fills the card with
favours. Ana's talk has a priced "Tell it straight". The biggest levers are in three separate kinds of size, and the twist puts a price on away travel.

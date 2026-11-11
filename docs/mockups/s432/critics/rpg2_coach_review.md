# RPG layer v2 (RPGLAYER1), reviewed by a club head coach (fresh, blind)

Who is reviewing: the head coach of a busy amateur boxing club, 20 years of watching coaches and boxers fall out and make up.
What I read: CRITIC_PACK.md, CRITIC_ACCESS.md, RPG_LAYER_MAP_S432.md (whole), CLUBWEEK_MAP_V4_S432.md (whole), the two drawings
(`docs/mockups/s432/rpg_coach.png`, `rpg_fighter.png`). I checked the code the map leans on: Knowledge.gd (three groups,
FIRE_SPAR_CAP, stale), Exchanges.FULL_SHOUTS = 2 and uptake, Knockdowns (get up at 8 - heart / 25), CornerJobs.talk (calm, fire up,
the truth read off temper and confidence), PerkRoad, CornerTrust, FighterProfile.TRAITS, HeadCoach. The map's code numbers are right.

## Score: 7 / 10 for depth

One line: a real RPG layer: every pick is paid in the club week's own coin and lands on a counter or in the corner, but the fighters'
wants stand still, the moments are nearly all paid in one coin, and the coach's own picks have no probe to prove each side wins somewhere.

## What works, in a coach's eyes
- Your own growth reshapes your hours. Long evenings against Early starts, One on one against The room: that is the real choice every
  club coach makes about where their own time goes. It moves the Club week counters, so you feel it every Monday.
- The fighters' perks become picks (The drain or The drop). A coach really does shape how a gift is used. PERKPICK1 keeps them honest.
- One bond number. Loyalty, with bands that unlock things (holds pads, the free short week, TRUST ME in the minute), is how a gym works.
  Mood as the short one, loyalty as the long one: right, and it does not add a meter.
- Known is the best idea in the map. "You know their heart only when you have cornered them" is true. Built on Knowledge.gd, not new.
- Traits that say what they do in the fight's own numbers, drift with the weeks, and the knockout turn (Hardened or Shaken, with Rest and
  sitting with them moving the odds) is the most real thing here. That Monday after a stoppage is the hardest week in coaching.
- Moments that remember (You said May, The favour back, Your corner this time) and marks that stay. Partners and feuds on the pair picker.
- The menu table is complete and each line names the module behind it. Probes cut, they do not decorate.

## Missing options
1. A probe for YOUR picks. Fighter perk pairs have PERKPICK1; the coach's five level pairs and the background cards have none. Ringside voice
   against The minute, Long evenings against Early starts: nothing proves each side is best somewhere. The pick card shows "your last 6 bouts"
   but not what each side is worth.
2. An ambition that moves. Real boxers change what they want: three wins running and the pro debut becomes "a title first"; a bad stoppage
   and "a title" becomes "just a win at home". Here the ambition is fixed from signing, so What <name> wants is one decision a career.
3. The style choosing who walks in. The biggest effect of a gym's way is who comes through the door. The map shows the fit on the signing
   card but the style does not change who arrives.
4. A pecking order in the room. Every club has a senior the others train behind. Partners and feuds exist; a captain does not.
5. Two staple club moments: a fighter who wants to MOVE UP A WEIGHT (the scale, the class, new sparring pairs, a new ladder) and THE NIGHT OUT
   in fight week (the tank, the truth from the corner). Both happen every season in a real gym.
6. Ana's own picks. The boxers get eight perk pairs; Ana gets a direction and one card. The grappler's RPG is thin beside the boxers'.
7. How a mark fades or is lost. Hardened, Shaken and the rest show the effect but not the way out; and a title leaves no mark.
8. Known speed by group. In a real gym you know someone's strength and cardio in two or three weeks of your sessions; their skills in a
   couple of months; their heart only under fire. The drawing shows Strength 61 to 65 on your own boxer at week 14: that reads as fog.

## Useless or weak options
- "+1 experience when a fighter's perk is picked": a free click, no decision.
- The "+2 / +3 experience" chips on each slot at the deal: they bait the player toward experience instead of the right week (train a habit
  for +3 when the weapon is the better pull). Experience should come from outcomes and be read on Club > You and the Monday review.
- Moment 5, A NEW WEAPON: "Pads on it" beats "Later" almost always (+6 mastery and mood +5 against mood -5); a near-dominated card.
- Moment answers paid in "1 of your pad places" over and over (cards 1, 4, 12, 13, 14, 15, 16 and the feud talk): one coin for most of the deck
  makes the moments feel the same and empties your two pad places.
- COACH AND <NAME> as a full panel: its only actionable line is "if Coach goes, -6". It belongs in a hover on Coach's line.

## To reach 10/10 (most important first, each buildable)
1. COACHPICK1: a probe for each coach level pair and each background card, on the played season: each side best in at least one line-up by
   1.5 wins in 100 or one season effect (weeks to a target, a fighter kept, dollars); a pair that fails is redesigned. The pick card prints
   "best for" from it, as the perk pick does.
2. Known speed by group: set Knowledge.expose amounts so ordinary dealing makes Body known (pip 3 share) in about 3 weeks of your sessions,
   Skills in about 8, and Fire only from Hard sparring and cornered bouts. Show a range only where it is still open; a known number shows plain.
3. The ambition moves: after a milestone (three wins running, a stoppage loss, a title, turning 25 or 30) the Monday review names a new ambition
   ("was: a pro debut before 25"). The season target then matches or not, with the +5 / -5 price and a "-1 every 4 weeks while it does not match".
4. Vary the moment coin: no more than a third of the deck's answers cost "1 of your pad places"; the rest cost a coached morning, a favour, cash,
   the next sheet, a sparring evening, a trial place or Coach's evening. Each answer carries a coin tag on the card.
5. The style shapes the trial mat: Hard school brings Big heart or Disciplined prospects 2 in 3, Craft first Listens or Confident, Family club
   Loyal or Fragile; the trial card says "came for your Craft first". STYLE1 also checks it.
6. Club captain: one senior (6+ bouts, Loyal 70+) is named on Club week. While the captain trains with the room nobody skips (The room's rule
   without your morning); the captain's own alone mornings train at 0.9; a passed-over senior with more bouts takes -3 once. One mark, one chip.
7. Experience from outcomes: drop the "+2 / +3" chips on the deal and the +1 for a perk pick; add +1 for each stat point gained in your own
   sessions (read from the week review) and +2 when a fighter's perk opens under your hours. COACHXP1 re-checks the 3 to 4 steps a season.
8. Two real moments in place of the two weakest (A NEW WEAPON and THE OLD COACH AGAIN): UP A WEIGHT (stay and cut / move up: new class, new pair,
   no rank there yet / a trial bout at the new weight) and THE NIGHT OUT, fight week (the truth: tank -6, confidence +2 / bench them: the bout goes,
   loyalty -4 / say nothing: tank -10 and a note for the next one).
9. Marks print how they fade or are lost (Hardened gone after a second knockout in a year; Shaken gone after a stoppage win or 3 bouts; Broken
   promise gone after two kept); add CHAMPION (a title: confidence never drops under 60 that season) so the best moment leaves a mark too.
10. Ana's picks: at each new belt Ana picks one of two versions (blue: Guard retention, the opponent's pass worth 3 scores 1 in 4 less often /
    Scrambles, a sweep after a failed takedown 1 in 5), listed first by Guard player or Top game; and the Character tab drawing shows the waiting
    moment card and the squad rows the map promises, with Coach and <name> folded into a hover.

## Is the RPG layer complete for this version, with the list applied?
Yes. With these ten it covers the three things a coach-and-fighter RPG needs in a club: you grow and your growth changes your week; each fighter
is a person who wants things, changes, remembers and is shaped by you; and the squad has a pecking order, pairs and feuds. What the map leaves
for later (a rival club that poaches, scars, prime and decline, retirement, retired fighters as coaches) belongs to the small living world, and
saying so is right. Nothing more should be added before the probes run.

## My 10/10, drawn
`docs/mockups/s432/critics/rpg2_coach_10.png` (HTML beside it): Tess Reilly's Character tab with the moment waiting (Called out, three answers in
three different coins), the perk pick with "best against" and the next bout's value, an ambition that moved and the price of keeping the old
target, marks with how each fades, Known with Body known and Fire still open and the next session that narrows it, the squad with a captain and
a partner, and why Tess is here under your style.

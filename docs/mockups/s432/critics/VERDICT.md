# Verdict on the club week map (S432)

Judged from: the final map `ops/research/CLUBWEEK_MAP_V4_S432.md`, the four critic reviews in this folder, the critic pack, the S428 scope note,
and the code. These code claims were checked and hold: ProDebut (20 family tickets, half a ticket per member, 2 per amateur win, 60 to break even),
the club's 25% share (manager 15% + trainer 10%), ClubShow.gd (a $3,500 night the club can already book on Club > Money), and CoachNotes.

## The scores
| Round | Critic | Depth |
|---|---|---|
| v3 (first) | Head coach and secretary of an English amateur club | 7 |
| v3 (first) | Lead systems designer, Football Manager style | 6 |
| v4 (final) | Owner-manager of a UK gym with members and a squad | 7 |
| v4 (final) | Steam management-sim reviewer | 7 |

Both fresh critics on the final map scored 7. The map passes the rule of 7 or more from two fresh critics.

## MECHANICS COMPLETE: YES, for the club week. Building can start.
The set is closed. Three of the four critics said "complete once the list is applied". The fourth said no, only because the hosted club show is
missing. My call on that is below. Before the first task is briefed, the map gets the ten changes below (call it v4.1). They tighten what is already
there. None of them is a new system, so no new critic round is needed.

Two pieces the owner already asked for still need their own short maps: the RPG layer (RPGLAYER1, the owner's own ask) and our own club show
(HOSTSHOW1, item 4 of the S428 scope). Neither one changes the club week's rules. Each plugs into a hook this map already leaves (loyalty, and HOME
bouts). So the first build steps (the probes and the rule modules) do not wait for them. RPGLAYER1 is designed while the probes run, and it must be
done before the Club week screen is drawn.

## The ten changes to write into the map before the build
1. **Tell it straight.** Both final critics showed it beats the other two talk answers outright. New version: it is free, and the result is a roll
   on coachability, +4 or -4. The result is written in the Coach's notes, and the answer cannot be used on that fighter again for 8 weeks. The
   screen never shows the coachability threshold.
2. **Give loyalty an upside without adding a new counter.** Only a Loyal fighter (70 or more) can hold pads. A Loyal fighter also takes one short
   week in four without losing loyalty. The bar shows "Loyal: can hold pads".
3. **HOME on our own show.** When the club books its show (the button already in the game, ClubShow.gd), every READY boxer gets a HOME card on that
   Saturday's sheet. Each of your boxers on the card adds tickets, and their fans add to the ticket count. Delete the separate "+$300 for two on one card" rule. The
   ordinary HOME card means "a local show near the club".
4. **Cut "Sell tickets".** Both final critics cut it: it only matters for 4 weeks, and it spends a coach's pad place on something a boxer does at
   work. The fans and the HOME card already carry the debut.
5. **A class night also brings members later:** +$117 that night, and about one new member every 4 weeks. Ana's teaching works the same way.
   MONEYFOUR2 measures both.
6. **Away bouts cost about $40 in travel,** printed on the card. The climb up the ladder then costs money too. Drop the +1 fan for an away win
   (noise beside +4 at home).
7. **Mood rates further apart: 0.8 / 0.6 / 0.4** for training alone (0.1 apart would not show in a season). MOODRATE1 still decides whether they
   stay.
8. **Sizes are shown as a range, never as one exact number.** Each kind keeps its own colour and is never added to another: wins in 100,
   weeks to the target, dollars, loyalty. SEASON1 also fails if a bot that always takes the biggest win chip wins the season.
9. **The professional's row gets real choices.** The BUSY target means a 4-week Light camp that takes tune-ups. RANKED means a 6-week camp and the
   step-up. If the owner keeps the day job until the top 10 (his open taste question), add CAMP LEAVE: about $120 a week for the last 2 camp weeks
   gives the job's mornings back.
10. **Fix the small things.** One unit on every counter (fighter-sessions: asked, covered, short; covered never more than owned). Two fighters on
    the same session share a coached morning automatically. Show one bar called Legs, not tiredness and a tank as two numbers. Add a
    PROMISES OPEN list on Club week. Show the diet cell (Hold or Cut, already in the code) on each boxer's row. Ana's open gets Enter or Skip, and
    "who corners" shows only when a boxer of yours boxes that day. In the drawing, the fight week's Pass reads loyalty -2, not mood. The bout cap
    reads "about 18 a season allowed (England Boxing), about 9 expected".

## The build list (mechanics for this version, in build order)
0. Probes first, on the played bout: TANKPRICE1, SEASON1, SHORTWEEK1, LOYAL1, FOLLOW1, MONEYFOUR2, MOODRATE1, SPARSET1, then the rest. Any choice they
   show is too small to matter gets cut, and nothing new is added in its place.
1. The four: one professional of two, two amateurs of four, Ana; four places at the first unit.
2. The job rota: shifts, college, office, cafe.
3. Club week board: pad places, coached mornings (shared automatically), paid seats as 4-week blocks (renew, pass on, let it end); deal by hand,
   keep my changes, or Coach deals it.
4. Coach's evenings: each one pads or a second class (+$117 now, members later).
5. Pulls with sizes shown as ranges: weak spot, weapon, goal, ahead.
6. Mood with teeth: training alone at 0.8 / 0.6 / 0.4; a Low fighter passes a sheet.
7. Sparring: the pair by weight and the setting (Hard, Technical, Body only).
8. The club twist: one card a week from 12, each answer with a price.
9. Favours: 0 to 3 with each show club; earned helping, spent bending terms; one kilo rule both ways.
10. The bout sheet: home, a name above, the unknown; away travel $40; Ready, Building or Rest; the rank earned on every fight; home on our own show
    when one is booked.
11. The fight week: the scale at walking weight, the evenings before the bout, film, four lines, the Legs bar, the other corner's week, the corner,
    pull-outs, the 4-day call, one number against Coach's week.
12. Loyalty: moved by your deals; the talk (with the new Tell it straight); promises open; leaving under 25; Loyal fighters can hold pads and take one free short week in four; the club's share at
    turning professional.
13. The season target and strip (the nationals, the pro offer, a year to grow; ranked or busy; a medal or blue belt).
14. Fans: home wins build the crowd that sells the debut and every professional bout.
15. Ana's mat: 3 or 5 classes, the mat morning, the division at each open, enter or skip, teaching from blue, the stripe call.
16. The trial mat: a prospect every 4 weeks; watch on its card; sign or pass.
17. The road to professional: the offer and its answers, $1,105, the ticket-paid debut, the promoter's offers, the camp (camp leave if the job stays).
18. The guide: five steps in week 1 and the reveal order to week 5.
19. One golden-path test that walks all of it, including a talk, a home win adding fans and the debut forecast moving.

## Left for later
- **RPGLAYER1 (next, its own map, before the screens):** the coach grows, a bond with each fighter, a coaching style, and traits that change. The
  final reviewer's BUILD DIRECTION per fighter (Keep it long, Walk them down, Counter; Guard player or Top game) and THE READ (sizes narrow as your
  own sessions open Coach's notes) belong here.
- **HOSTSHOW1 (its own map):** filling our card with favours, favours owed to us (a two-way ledger), the show date on the season strip.
- The club's terms when a boxer turns professional, as a choice; promises and poaching at contract time.
- A rival club that poaches (Eastside ABC as an actor); a club season frame, three club goals and the year review.
- A boxer's own local sponsor; the small living world (national ladder, mandatory challenger, rivals who age, judges with taste); the full promotion;
  professional tables for featherweight and middleweight (owner's call).

## Critic asks I think are wrong
- **"Not complete without the hosted show" (gym owner).** Half right. The show is already in the game: ClubShow.gd and Book the show on Club > Money. The
  owner approved the full show to come after the first three changes. Change 3 links the show we already have to HOME bouts now. Card filling and owed favours are
  HOSTSHOW1. Blocking the build on them would hold back four fighters' worth of work for one menu.
- **The club's terms at turning professional as a three-way choice (gym owner).** Not now. StarDeal's contract talks already own the club's share,
  and loyalty already sets it at signing (25% or 10%). The "25% plus a seat until the debut" option breaks the map's rule that a professional holds
  no seat.
- **Helpers as a new counter (gym owner).** The idea is right, but the new counter is not needed. Holding pads already is the helper. Change 2 makes it
  loyalty's reward.
- **Build direction and The Read in this map (Steam reviewer).** Right ideas in the wrong map. They are the core of the RPG layer the owner asked for. Putting them here adds two more things to
  day one, which already carries ten.
- **Ana's season target repeats the division choice (Steam reviewer).** It works the same way as the boxers: the target sets the default, and each
  open can override it. Keep both.
- **Sell tickets on the boxer's own evening (gym owner).** Moving it is not enough. Cut it (change 4).
- **"Standing" as a new 0 to 100 number (first-round coach).** The map was right to use the loyalty trait already in the data. The owner ruled "no
  new meter", and "Standing" already means booked or free on Fights.

One warning that stands over all of it: not one price on the board is measured yet. If TANKPRICE1 or SEASON1 shows the week moves too little, the
board is cut down, not dressed up.

Seat: amateur club coach and matchmaker (a season of club shows, bouts at one or two weeks' notice). My 10/10 drawing: `docs/mockups/s429/amateurweek_10_matchmaker.html` (picture: `docs/mockups/s429/amateurweek_10_matchmaker.png`).

# AMATEURWEEK1 reviewed from the matchmaker's chair (S429)

What I read: the critic pack, the access page, the design page, the four-fighter start page it leans on, and the code it names
(AmateurBooking, Bouts, BoutRules, WeekPhase, WeekPlan, Sim, OppFile, PlanLines, FilmEdge, PadWeek, Data). I read the code, I ran
nothing. Where I give a weight or a day count I worked it out by hand from the numbers in those files. I did not open the Miro board.

## Scores

| What | Score |
|---|---|
| Depth of the whole design | 4 / 10 |
| The offer: take it or pass | 3 / 10 |
| Job 1, the weight | 3 / 10 |
| Job 2, the tape | 4 / 10 |
| Job 3, one line of the plan | 4 / 10 |
| Job 4, fresh or sharp | 3 / 10 |

The idea is right and it is how a club season really runs. The four jobs, as written, are a list everyone fills the same way.

## What works

- No camp for a club bout, one or two weeks' notice, box with what is already in the hands. That is true to the sport: nobody
  runs a camp for a three-rounder at a club show. The boxer trains the same all season and the phone rings.
- "The building happens in the weeks between fights; the fight week only chooses." This is the best sentence on the page. It
  turns the whole season into the preparation, which is what a real coach does.
- The 28 days out after a stoppage is the real rule (the code already has 30).
- Money: the page spots by itself that a ticket cut on every bout breaks the books, and that away shows pay nothing. Correct.
- The pad evening shared between three boxers is the one cost in the design that lands on somebody else. Keep it.
- The page names its own risk (a checklist). It is right to worry.

## Where the page and the game disagree (checked in the code)

1. **There is no choice of opponent.** The page says "the choice of opponent is the big decision". The game sends ONE name at a
   time (plus a silent unsafe one). A pass does not move the list on: `Bouts.decline` only sets the next offer five days later,
   the turn counter moves only after a fight. So a pass brings the same boxer back five days later. Each weight has three names
   (`Data.DIVISIONS`), met in turn.
2. **"Owns an answer: yes or no" on the offer gives away what the tape is for.** The opponent's best punch is hidden until tape
   (`OppFile`). If the offer already says whether Tess owns the answer to it, the film evening has nothing left to show: the
   tape always opens the best punch first, in a fixed order (best punch, habits, weakness).
3. **Heavy legs do not exist without a camp.** `BoutRules.stale_energy` returns zero when there is no camp ("a fight without a
   camp is not taxed for the club's usual training"). As coded today, job 4 changes nothing on the night.
4. **A cut costs no tiredness.** In `WeekPlan.day` the diet only moves kilos. Tiredness comes from the sessions alone. And the
   cut switches itself off once the boxer is at the limit (`Sim.week_ctx`). So "hold or cut" has one answer: cut if over.
5. **No camp is punished today.** `BoutRules.NO_CAMP_EDGE` takes 1.5 points off, and the Why says "No camp: looked a step slow
   from round 2". Both must go for amateurs or every club bout starts behind.
6. **Ten days out the coach writes the hardest week.** `WeekPhase.phase` counts weeks to the bout: two weeks out is "Peak week:
   the hardest week of the camp, sparring twice". An offer taken ten days out puts the boxer straight into it, with no camp.
7. **The tape only runs inside a camp.** `Bouts.tape_days` and the tape room both need a camp with film switched on.
8. **The fresh week is already the coach's week.** The fight-week phase already writes light mornings, three rest days and no
   sparring. The switch can only make things worse than the default.
9. **After the first meeting the tape job is dead.** A bout against a boxer opens the whole file (`OppFile.open_all`) and the
   career keeps it. Three names in turn means from the fourth bout on there is nothing to find. A boxer with no bouts has no tape.
10. **A boxer over the weight gets a later date.** `Bouts.makeable_day` pushes the bout up to four weeks out. That is the old
    camp thinking and it fights the one-to-two-week lead.
11. **The short-notice swap can hardly fire.** It needs 14 days to go (`SWAP_MIN_DAYS`). With bouts 6 to 19 days out it almost
    never will.
12. **An orthodox boxer always pays against a southpaw.** The round-one penalty is lifted only by a camp sparring partner or a
    lucky twist card. No camp means no way to fix it.
13. **Day-job boxers have no mornings** (the four-fighter start: three of four train evenings only). "Fresh or sharp" is a
    morning switch. For most of the roster it switches nothing.
14. **The pace.** Ten days after a fight the next offer comes; with a one-to-two-week lead that is a bout every three to four
    weeks, 13 to 17 a year if every offer is taken. The target is 8 to 10. The nationals want 5 bouts by week 10: about 3 fit.
15. **"Set camp" will nag.** `Bouts.camp_due` raises the flag for any bout seven or more days away with no camp.
16. **Tape or pads, which is it?** Job 2 says film "takes that fighter's pad evening". The links say "film for Tess means no
    pads for Samira". If only Tess gives up her place, Samira gets MORE pads that night, not fewer. It has to be the coach's
    whole evening or the link runs backwards.

## Where it is unlike a real amateur season

- **The weigh-in is on the day**, at the hall, with the doctor, a few hours before the first bell. The game weighs the day
  before. With a same-day scale a hard cut walks into the ring with the boxer. That is exactly the cost the page wants.
- **Club bouts are made at an agreed weight**, not at a class limit. Two coaches on the phone: "mine walks 76, can yours do
  76?" Class limits matter at championships. "Give me a kilo" is the most common sentence in matchmaking and it is missing.
- **A missed weight costs no fine.** The other coach may take the bout anyway or refuse; the cost is your name with that club.
- **Bouts fall through all the time.** The other boxer is ill, heavy, fails the medical, or does not turn up. About one made
  bout in five dies in the last week. Then the matchmaker offers whoever is in the hall. This is THE drama of a fight week
  and the design has none of it.
- **Home or away is the first question.** At home your boxer sells tickets and the close rounds tend to go your way. Away you
  pay petrol and you need to win clearly.
- **You know the other boxers because you have watched them**, on the same cards your own boxers box on. At this level film
  is a phone clip if you are lucky. Being at shows is the scouting.
- **Clubs travel as a team.** Two of yours on the same card is normal and wanted (one van, one evening). The page treats two
  fight weeks in one week only as a clash.
- **Three names a weight is too thin**, though meeting the same boxer three times in a season is true to life.

## A checklist, or an always-best play? Each one I found

1. **Always say yes** to any legal offer the scale allows. A pass is free, brings the same name back in five days, and a
   month without a bout costs mood. There is nothing to wait for.
2. **Always cut when over, hold when not.** The cut is free and stops itself. Nobody will ever pick the other one.
3. **Always watch the tape, first.** In fight week the boxer's own pad evening is worth nothing to that boxer (nothing learnt
   now arrives in time, the page says so itself). So the film is free for the one who watches it.
4. **Always take the top row of the plan list.** The Playbook already sorts the answers best first and marks each "Beats it,
   Works, Walks into it". Writing the one line is reading the first row. If the punch is not owned there is nothing to do
   at all: the screen says "weak" and the player moves on.
5. **Always fresh.** Light mornings give up a fraction of a point in one number. Normal mornings risk up to 20 off the tank.
   And fresh is already what the coach wrote. The guide's own line says it: "Keep the legs fresh."
6. **One order, every time:** yes, cut and fresh on day one, film on the first club evening, top row, weigh in. The plan
   line cannot come before the tape, so the order is forced, not chosen.

The links the page counts on: the shared pad evening is real but small (one place is about a tenth of a new punch for
another boxer); "the line needs an owned punch" is true but it is decided weeks earlier, not in the week; "a cut and normal
mornings both tire" is not in the code; "two fight weeks in one week" is a diary clash, not a decision.

There IS one live knot, and the page does not show it. Tess walks 76.1 for 75.0. By my sums the coach's light fight week
plus the diet takes off about 0.7 kg in the ten days: 75.4, a miss. Only training normally every day gets close to 75.0.
So Tess must train through to make the weight and box on heavy legs, or ask for a kilo. That is a real fight-week problem.
Build the design around problems like that one.

## Every menu in the table: what is missing, what is useless, what each option changes

**Home (fighter row: "Fight week: 2 of 4 done")**
- Useless: "2 of 4 done". It is a tick counter and tells the player the week is a chore.
- Missing: the one open pick that has a price ("Tess: Sat 14 Feb. Scale 75.4, over by 0.4" with its button); a mark when two
  boxers share a card or want the coach's evening the same night.
- What it changes: nothing by itself; it opens the bout.

**Fights (offers, compare card, rank, "owns an answer")**
- Missing: a second and third name to choose between; home or away; the agreed weight and "ask for a kilo"; what you have
  seen of each boxer; who else at this weight is free or suspended and when; what a pass costs.
- Useless: the bare "owns an answer: yes / no". For any boxer with a jab and a cross it will nearly always say yes (the plan
  counts a drilled combination as an answer even with no line written). Name the punch and how many pad evenings it is short.
- Options today: Accept (books the bout, mood +5, the coach rewrites the week) and Pass (the same name again in five days).

**Bout page (four boxes in place of the camp setup)**
- Missing: on every box its forecast and its price; a line drawn between boxes that pull on each other; ask for a kilo;
  pull out (and what it costs); the late-replacement choice when the opponent drops out.
- Useless: a done / not done state per box.
- What each changes today: the weight box moves about 0.07 kg a day and nothing else; the tape opens one fact (always the
  best punch first) and is worth 0.4 of a point only if the plan answers it; the line adds its own small edge; fresh or sharp
  changes nothing on the night until heavy legs count without a camp.

**Fighter page, Training (the week board)**
- Missing: which evening the film goes on (the night decides who loses pads); what the days BEFORE the fight week are (ten
  days' notice leaves three to five of them, and that is where a nearly-learnt punch can still be finished); the last
  sparring day; the evening version of the switch for a day-job boxer; the scale forecast day by day.
- Useless: a one-click "fresh or sharp" on top of a board where every morning can already be changed, when the coach's
  fight week is already the fresh one.

**Tape room (the one tell)**
- Missing: a choice of WHAT to look for. There are three kinds of fact (best punch, habit, weakness) and time for one film.
  Today the order is fixed, so the room shows what it shows.
- Useless: the whole room in a rematch (file open), and against a first-timer (no tape). In both cases do not show the box.

**Playbook, Game plan (the one line)**
- Missing: which standing line goes when the plan is full (a plan holds 4 to 6); "this punch is 9 short: two pad evenings,
  you have three before the bell"; "no line" as an honest choice with its number.
- Useless: nothing here is useless, but the list sorted best-first makes the pick a lookup.

**The guide ("Keep the legs fresh", then one line per open job)**
- Useless: a line that names the always-best play. If the guide can say it in five words every time, it is not a choice.
- Missing: the guide naming the trade: "Tess is 0.4 over on a light week. Train through, or ask for a kilo."

**Continue button (stops at weigh-in and fight night)**
- Missing: a stop when a pick's last chance is today ("tonight is the last club evening before the bout"); a stop when the
  opponent pulls out.
- Useless: a separate weigh-in stop once the scale is on fight day. With three boxers and nine bouts each that is 27 extra
  stops a year. Make the scale the first step of fight night.

**Fight night, result, the Why (rank earned, which jobs counted)**
- Missing: what the week cost the others, said once ("Samira's body hook came two days late"); the one pick that would have
  changed it; "you know Amy now: no film needed next time".
- Useless: a line for a job that moved nothing ("weight: made"). Show only the picks that moved a number.

**Week review (what the fight week cost the others)**
- Good as it is. Missing: the season count (bouts this season, bouts still needed for the nationals) and the next likely names.

## To reach 10/10 (most important first)

1. **Put two or three names on the table, and let a pass move the list on.**
   - Each weight gets 6 to 8 regional boxers (the data already has five per weight; three are used).
   - When a boxer is free, the Fights page shows up to three possible bouts from the coming shows. They differ in date
     (this Saturday week, or the one after), in home / away, in record and in style. Taking one closes the others.
   - Home: the $450 ticket cut, and a round closer than one point goes to your boxer 6 times in 10. Away: no ticket money,
     $40 petrol, and that close round goes the other way 6 times in 10. Show "close rounds lean to Amy" on the offer.
   - A pass costs nothing in cash; the next list comes in 7 days with different names. The same club remembers two passes in
     a row (one favour, when asking for fights is built).

2. **Agreed weight, a scale on the day, and "ask for a kilo".**
   - Every amateur offer carries an agreed weight (the class limit unless asked). The weigh-in moves to 4 pm on fight day and
     becomes the first step of fight night.
   - Weight lost by eating less in the last seven days costs 1 off the tank at the first bell for every 0.1 kg, up to 10.
     Weight lost by training costs through tiredness, as now.
   - "Ask for a kilo": the other coach says yes when their boxer walks over the limit too, or when you hold a favour. Both
     may then weigh a kilo more and the opponent starts with 5 more in the tank. No means the offer stands as it was.
   - A miss: the bout is off, no $300 fine, one favour lost with the host. Remove `makeable_day`'s later date for amateurs.
   - The weight box then has four real answers: hold, eat less, train it off, ask for a kilo.

3. **Make "fresh or sharp" a trade with both numbers on it, and rename it Ease off / Train through.**
   - Heavy legs must count without a camp, but softer: 1 off the tank for each point of tiredness over 50, at most 12 (today 2
     a point, at most 20, and only after a camp). At today's price nobody would ever train through.
   - Ease off = today's fight-week plan (about half a week's gains). Train through = the ordinary week (full gains).
   - On the switch, two numbers side by side: "At the bell: legs 100 / legs 91" and "Banked this week: Defence +0.3 / +0.9".
     For a young boxer far from the ceiling in a soft match, training through is right: nine tapered weeks a season cost
     about four points of growth across the numbers (my estimate from the training pace; measure it). For Tess, near the ceiling, easing off is right. That is a decision that changes by boxer.
   - For a day-job boxer the same switch acts on the three club evenings (three nights, or two with no sparring).
   - Stop the coach writing a Peak week for a bout with no camp: ordinary week until the Monday of fight week.

4. **The tape: choose what to look for, see boxers at shows, and charge the coach's evening.**
   - One film evening shows ONE of three things, the player's pick: the best punch (allows a plan line worth 0.4), a habit
     (the corner sees the right call from round one), or the weakness (names the round to push).
   - "Seen at a show": every card one of your boxers is on, you see up to two other boxers at your weights and get one fact
     on each for free. Going to shows becomes the scouting, and the choice of show in point 1 gains a second reason.
   - Film takes the coach's WHOLE evening: both pad places that night. The player picks the night; the board shows who is
     put on the bag.
   - Rematch with the file open: no box. Instead the other corner has seen your winning line and it is worth half this time.
   - Take "owns an answer" off the offer unless the best punch is already known; show "best punch: not seen yet" instead.
   - Let the tape run without a camp (it needs one today).

5. **Let a nearly-learnt punch be finished on short notice, paid for with the others' pad places.**
   - On the answer list show: "in the hands", or "21 of 30: two pad evenings short, three left before the bell".
   - Rule: pad work in the last three days before the bout does not count on the night. Ten days' notice then leaves two or
     three evenings that do. Those places come off the other two boxers, shown by name ("Lucy on the bag Friday").
   - This replaces the page's rule "nothing learnt after the offer arrives in time", which is only true from zero. It also
     gives the weeks between fights their real job: keep two or three punches close to ready for the names on the list.
   - With a full plan, writing the new line asks which line to drop and shows what the dropped one was worth.

6. **Pull-outs.**
   - Each amateur bout: 15 in 100 that the opponent drops out between Monday and Thursday of fight week.
   - The matchmaker then offers one late replacement: a boxer you know less about, up to a kilo heavier or three bouts more
     experienced (never across the novice line). Take it, or go home: no bout, mood -3, the eased-off week spent for nothing.
   - The Continue button stops for it. Drop the 14-day rule on the short-notice swap for amateurs.

7. **A list of the boxers at each weight, and the season count, on the Fights page.**
   - Per name: record, what you know (out of four), which answer your boxer owns, when next free or until when suspended.
   - Per own boxer: bouts this season, bouts still needed for the nationals.
   - Set the pace by rule: next offers 21 days after a points bout (one easy week, one building week), 28 after a stoppage.
     That gives 9 to 11 bouts a year. Move the nationals' closing date or the 5-bout rule so a new boxer can reach it.

8. **Clear the old camp rules out of the way for amateurs** (small, but each one breaks the design if left):
   no 1.5-point "no camp" loss and no "No camp" line in the Why; no "Set camp" flag; no peak bonus; and a "southpaw rounds"
   evening at another club (seven or more days out, $40, uses one pad evening, +5 tiredness) so the round-one southpaw
   penalty can still be answered without a camp.

9. **Money.** Ticket cut only at home ($450); away costs $40 and pays nothing. With about half the bouts at home, four
   boxers at nine bouts bring about $8,000 a year before petrol, not $14,400.

10. **Screens.** Home shows the one open pick with its number, never "2 of 4 done". The Why names the pick that moved the
    result and what it cost the others. The guide names the trade, never the answer. The offer screen shows the week the
    yes will buy before the yes is given (my drawing).

With points 1 to 6 built, every pick has at least two honest answers, each pick changes another one (the weight ties the
legs, the film and the punch both spend the coach's evenings, the show you take decides who you get to see), and no order
is forced. That is the 10.

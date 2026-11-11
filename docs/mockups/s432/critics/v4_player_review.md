# CLUBWEEK v4: depth review, the management-sim player (fresh, blind critic)

Read: CRITIC_PACK.md, CRITIC_ACCESS.md, CLUBWEEK_MAP_V4_S432.md (whole), clubweek_v4.png/.html, fightweek_v3.png, road_v3.png.
Checked in code: ProDebut (FAMILY 20, PER_MEMBER 0.5, PER_WIN 2, BREAK_EVEN 60), Roster.GYM_SHARE (manager 15% + trainer 10%),
NoGi.CLASSES_PER_WEEK 3, BjjSide (BLUE_MEMBERS 3, teach_saves, can_teach from blue), BeltRoad.EARLY_DEBT 0.25, DuesLevers.CLASS_WEEKLY 350,
CoachNotes (notes revealed from fights, film and sparring; traits only "notable" at 70+ or 40-). The map's code claims hold.
My own 10/10 drawing: `docs/mockups/s432/critics/v4_player_10.png` (HTML beside it).

## 1. Depth score: 7 / 10
The decisions link and pay off later: a pad place given away costs loyalty, loyalty sets the club's share when a boxer turns professional, home bouts
build fans, fans sell the debut, the class night trades cash against training. That is real depth. What holds it at 7: every chip prints its exact
size and a live "your deal against Coach's" number, so the board can be solved by arithmetic, and the player's own time (the head coach) buys only
training, never knowledge or the bond. Each fighter also has no long-term build: the pulls are week-to-week patches, not a career shape.

## 2. Options
### Missing
- A fighter's BUILD DIRECTION (the style the club is turning them into). Today nothing on the board commits a fighter to a shape; the perk road and the
  pulls just react week to week.
- Your own sessions buying knowledge and bond: one of YOUR coached mornings or pad places should also reveal a Coach's note (CoachNotes) and add
  loyalty. Today You and Coach differ only in rate.
- A PROMISES OPEN ledger on the board (who, what, by which date). Promises are priced (+5 / -12) but nowhere listed, so the player forgets them.
- The professional's own money-or-training call between bouts: under the top 10 the boxer keeps the job, so offer CAMP LEAVE (the club covers the last
  2 camp weeks' lost wages, about $120 a week, and the mornings come back). Today the professional's week has almost no decision outside the camp modal.
- Walking weight on the board: the bill punishes being over the 1.0 kg gap, but Club week has no weight cell (Hold / drift down 0.3 kg a week) to act
  two weeks before a sheet.
- The class night feeding the club: a beginners' class is how a real club recruits. Class nights should add members later, not only $117 now.
- Ana's mat morning shown as a target on the boxer's row (who gets it), not only on Ana's row.

### Useless (or dead as written)
- TELL IT STRAIGHT: the button prints the coachability threshold ("coachability 36: -3"), so it is dominant at 60+ and never chosen under 60. It also
  leaks a hidden trait that CoachNotes only reveals at 70+ or 40- after it is seen.
- SELL TICKETS pull: lives only between signing professional and the debut (4 weeks), +6 tickets; the start's professional is already 1-0, so it may never
  appear in the first season. Fans and home bouts already do the job.
- Two fighters on one coached morning at 0.8 each: 1.6 against 1.0, always taken when sessions match. It is a constraint, not a decision: pair automatically.
- Professional target RANKED vs BUSY: only reorders the promoter's offers the player picks anyway. Make Busy change the camp (4 weeks, Light default) or cut it.
- Ana's target MEDAL vs BLUE BELT duplicates the division choice at each open (white or blue first). One decision in two places.
- WHO CORNERS ANA'S OPEN when no boxer boxes that day: always You, free. Show it only on a clash.
- +1 fan for an away win: noise next to +4 at home; make away 0 fans and let favours be its currency.
- Counters in mixed units: the drawing shows "coached mornings asked 9, covered 7" with 6 owned (pairing counts double) and "pad places asked 8" while the
  map says a quiet week asks 10. One unit (fighter-sessions) everywhere.

## 3. New mechanics (inside this scope)
1. THE READ (Coach's read of each fighter). Decides: whose week gets YOUR sessions (each also opens one Coach's note on that fighter). Changes: every size
   on a chip and the "your deal against Coach's" number become BANDS whose width is set by notes seen (0-5) and the coach's rating; a better assistant and
   more of your time narrow them. Real basis: coaches learn a boxer over months; FM's staff judging ability sets how reliable reports are. Needed now: YES.
   It keeps the "true numbers" rule (bands are honest) while stopping the board from solving itself, and it ties straight into CoachNotes, already built.
2. BUILD DIRECTION. Decides: one style per fighter, set with the season target (boxer: Keep it long / Walk them down / Counter; Ana: Guard player / Top
   game). Changes: Coach's star pull aims at that style's perks; plan lines in the style walk 2 per pad place, others 1; matched to the fighter's own trait
   leaning +5 loyalty, against it -5; a change costs 2 weeks of progress on the weapon pull. Real basis: club coaches build a boxer around frame and nature.
   Needed now: YES, small. It is the minimum RPG layer the owner asked for and gives every Monday a direction beyond the next bout.
3. CAMP LEAVE for the professional. Decides: pay ~$120 a week to buy the job mornings back for the last 2 camp weeks. Changes: cash vs the camp's peak.
   Real basis: UK small-hall professionals keep jobs and take unpaid leave for camp. Needed now: YES (otherwise the professional's board row is passive).
4. CLASS NIGHTS GROW MEMBERS. Decides: nothing new (it deepens the existing switch). Changes: each beginners' class night adds about 0.25 members a week,
   joining 4 weeks later. Needed now: YES as a number, not a mechanic.
5. Rival club that poaches (Eastside ABC as an actor). Needed now: NO, the small living world.

## 4. To reach 10/10 (most important first)
1. Run the probes first (TANKPRICE1, SEASON1, SHORTWEEK1, LOYAL1, FOLLOW1, MONEYFOUR2) and apply the cut rule before any screen. Nothing is measured yet;
   depth on paper is not depth.
2. Build THE READ: sizes and the deal comparison as bands from CoachNotes (0-5 notes) and coach rating; YOUR sessions open one note each; no exact hidden
   trait printed anywhere (coachability shown only once noted).
3. Rebuild the talk card: Give the pad place back (costs 1 pad place next week, +4), Dated promise (+5 / -12, goes on the ledger), Tell it straight (free,
   a roll on coachability: +4 or -4, and the result reveals coachability as a note).
4. Add BUILD DIRECTION per fighter on the season strip, with the four effects in section 3.2; set once per target, change costs 2 weeks.
5. One unit on every counter (fighter-sessions: asked, covered, short); auto-pair two fighters on one session; fix the drawing (owned 6, covered never over owned).
6. Promises ledger as a counter on Club week and a Home need the week a promise falls due.
7. Merge the legs: show ONE bar per fighter (Legs 0-100) on the board and on the bill; tiredness is what drains it, the tank at the first bell is its forecast.
8. Professional row: camp leave choice; Busy target changes the camp (4 weeks, Light) or goes.
9. Class night: +$117 now and members later (MONEYFOUR2 sizes it); Ana's teaching likewise feeds the no-gi members.
10. Cut: Sell tickets pull, +1 away fan, Ana's corner choice outside a clash, Ana's Medal/Blue target (keep the division choice at the open and let the
    target be "a medal" or "a stripe by date").
11. A walking-weight cell on each boxer row (Hold / down 0.3 kg a week), visible from the week a sheet can come.
12. Golden-path test walks: a note opened by your session narrowing a band, a build direction set, a promise kept from the ledger, camp leave bought.

## 5. Complete for this version?
YES WITH THE LIST. With the read, the build direction, camp leave and the cuts, every person on the board has a short-term call (the week), a medium one
(the target and the bout), and a long one (the build and loyalty), and the head coach's time buys three different things. Anything beyond that (rival
club, coach growth with perks, year review) belongs to the small living world. Completion is conditional on the probes: anything that measures under
the cut rule is removed, not replaced.

## 6. My 10/10
`docs/mockups/s432/critics/v4_player_10.png`: the Club week board in week 5 with the season strip carrying each build direction, Your time as its own
counter, a Promises open counter, one unit on Short this week, every pull size as a band from the Coach's read (Read n of 5 under each name), one Legs
number, the professional's camp leave chip, a weight chip on Tess's row, the talk card rebuilt (Tell it straight as a free roll), and the levers in bands.

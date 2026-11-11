# RPG layer v2 (RPGLAYER1, S432): systems critic, fresh and blind

What I judged: whether every number the player sees on the RPG layer leads to a decision, and whether each decision costs something in the club week.
Read: CRITIC_PACK, CRITIC_ACCESS, RPG_LAYER_MAP_S432 (whole), CLUBWEEK_MAP_V4_S432 (whole), both drawings (rpg_coach.png, rpg_fighter.png). Checked in the
code: Knockdowns.gd, Exchanges.gd (FULL_SHOUTS, uptake), Knowledge.gd, CornerJobs.gd, CornerTrust.gd, PerkRoad.gd, and a search for weight-forecast ranges.

## Depth score: 6.5 / 10
One line: the coach's level picks are a real trade, read from your own bouts and paid in the club week's coin; but the knockout's main payoff does nothing
in the fight code, the trait numbers are mostly decoration, Known is information with no proven value, and nothing ever tells you what your picks won.

## What is good (keep it)
- The coach's level picks are the best part. Every pair moves the same coin both ways: pad places against mornings, shouts against fixes, Known against
  discipline. The pick card reads YOUR last six bouts ("9 shouts landed at half" against "4 minutes with a third fix waiting"). That is the standard
  every other number here should meet.
- Everything is paid in the club week's coin: pad places, coached mornings, cash, favours, loyalty. No second economy.
- One bond number (loyalty), with bands that unlock real things (holding pads, a free short week, TRUST ME). The bands are on the bar, where the choice is.
- Cards with memory (card 10 "You said <month>", card 11 "The favour back", card 18 "Your corner this time") turn one-off answers into a running story.
- The style fit on signing cards makes the gym's style matter at the moment it matters most: whom you sign.
- Every mechanic has a test with a cut rule (1.5 wins in 100, or a season effect). That keeps it honest.

## Defects found in the code (each one is a number on screen that changes nothing)
1. "GETS UP SOONER" IS ONLY THE PICTURE. In Knockdowns.gd, `up_at` (8 - heart / 25) is passed only to the 3D count (fight3d/BeatFire.gd,
   KnockdownCount.gd). Whether a boxer is stopped depends on damage, heart and `stop_mult`, never on `up_at`. So:
   - the HARDENED mark ("gets up one count sooner"), the main prize of the knockout turn, does nothing in the fight;
   - half of Iron chin's version B ("get up 2 sooner") does nothing (its referee x0.8 is real);
   - the Heart row's "gets up at 5 on a count" is a true number with no effect.
   The knockout turn (rest, sit with them, ready) is a good decision, but today it is a decision about nothing.
2. "EYE FOR THE SCALE: every weight forecast exact (no range)". I found no range on any weight forecast in the code: the forecasts are single numbers.
   Unless the club week adds a range, this level 5 card removes something that does not exist. Only its "a kilo with no favour" half works.
3. Coachability drift is too small to matter. The fight reads coachability as 0.7 + 0.3 x value, and only for the round's first 2 shouts. The map's
   own Monday line, "36 to 41: now takes in 82 in 100", is a change of 1 in 100 on two shouts a round. The player sees it move, and nothing they do with it pays.

## Missing options
- A READ-OUT OF WHAT THE PICKS WON. The Why and the week review show a trait opening or a mark earned, never "The drain: +2.1 in 100 over 14 rounds" or
  "Ringside voice: 11 shouts landed in full". Without it, perk versions, the coach's picks, the style and the direction are chosen once and never felt.
  This is the biggest gap.
- Perk versions judged against THIS fighter's coming opponents, not "best against: out-boxers who run late". Because the pick is for good and opponents
  change every sheet, the card needs the next 3 names and this season's opponents, each with a number.
- Known has no effect of its own. It only narrows ranges and opens traits. If KNOWN1 fails (likely, since real stats already stay visible), level 3's
  One on one, level 5's Eye for people and the Club night card lose their purpose. Known needs a direct game effect.
- The clash between build direction and the weak spot. Walk them down slows Timing and Footwork; if the weak spot is Timing, the board should say so on
  the weak-spot chip ("its fix 1 week longer").
- A loyalty forecast. The bar shows today's number and its last moves, not where this week's deal takes it ("68, Loyal in 5 weeks; short twice more: 57").
  Loyalty is the price of every deal, so the player needs to see it before Start week.
- What a trait line does when crossed. Thresholds (40, 60, 65, 70) are where traits change the game; the screen should show the next line, what crosses it,
  and the button that moves it ("Hear the ask").
- Who earns a mark and when it fades: SHAKEN fades after a stoppage win; the others never do. Four slots and no way to lose a mark makes the fourth slot
  a dead end.

## Useless options (or numbers with no decision)
- "A fighter's perk picked: +1 experience": free, for a click you must make anyway. Cut it.
- The Heart row's "gets up at 5 on a count" and HARDENED as written (picture only, see above).
- "Eye for the scale: forecasts exact" (no range to remove).
- Coach's area lines ("Pads 58, 59 in 3 sessions", "Conditioning 54, 55 in 7"): areas rise from sessions the week already sets for other reasons. Nobody
  routes a session to grow an area. Show it in the week review only; keep the raise (a real yes or no).
- "Pads with Coach: 22 sessions" on the Character tab: a count with no decision until the day you let Coach go. Hover only.
- The Settled band "nothing more", and "Not known: Ana: two traits ?" on the style card: no action.
- PARTNERS' +5% sparring gain: under any cut rule I would apply. Keep partners only for the -4 when one leaves (a real price on letting someone go), or make
  the bonus big enough to show up.

## To reach 10/10 (most important first, each buildable)
1. Make every "gets up sooner" effect real. Change HARDENED to "the referee's stop odds after a count x0.85" (the `stop_mult` that Finisher already uses on
   the other side), and Iron chin's GETS UP to "stop_mult x0.8 and the third count in a round does not stop the bout". Keep the count number as the picture.
   Test (KOTURN1): a season of Hardened against Shaken boxers changes stoppage losses by 1 or more.
2. Add WHAT YOUR PICKS WON: a ledger on the Character tab and Club > You, and one line each in the Why, for every perk version, coach pick, the direction
   and the style. Each line gives its measured share of the result ("The drain: +2.1 in 100, 14 rounds"; "Ringside voice: 11 shouts in full"). Data from
   the same replay the Why already uses (swing counts without the edge). A line under 0.5 in 100 for a season greys out: "a pick to rethink" (Second thoughts).
3. Price perk versions on THIS fighter's opponents: the pick card shows each version's wins in 100 against the next sheet's three names and the average
   over this season's opponents so far (from PERKPICK1's tables). Remove "best against: <style>".
4. Give Known one game effect per step, so it is not information alone: Known 3 = a habit fix trains out 1 week sooner (HabitFix); Known 4 = TRUST ME
   needs Known 4 as well as loyalty 85 (ties the two long numbers together); Known 5 = the knockout card's odds exact. Show "Known N: what it does" on
   the pips, not only what it reveals.
5. Make traits matter at lines, not per point: Coachability 40 = a corner fix lands in 1 round, not 2; 70 = the third shout lands in full (a fighter's
   version of Ringside voice). Confidence 75 = "Fire up" +2.0. Discipline 60 = "the truth" works. Print only the next line, what crosses it, and the
   button that moves it. Drop "81 in 100 of a shout" from the main view (hover).
6. Show a loyalty forecast on the bar and on Club week rows: "as dealt: 68 in 4 weeks, Loyal in 5; short twice more: 57". The same deal preview the
   board already computes for pad places.
7. Put the direction and weak-spot clash on the weak-spot chip: "Timing is slower under Walk them down: fix 1 week longer", and the direction's
   effect against the next opponent's style ("+0.9 in 100 against Saturday's out-boxer").
8. Fix or cut Eye for the scale: either the club week adds a weight forecast range (a real one, from the diet and the twist cards), or the card becomes
   "two kilos a season with no favour" alone.
9. Cut "+1 experience for a perk picked", Coach's area counts outside the week review, "Pads with Coach: N sessions" outside hover, and PARTNERS' +5%
   unless PARTNERS1 measures at least 1.5 wins in 100 for the pair.
10. Marks get a lifetime: each mark lists what would remove it (FIRST HOME WIN stays; HARDENED goes after two stoppage losses; BROKEN PROMISE goes after
   two promises kept), so the fourth slot can open again and a mark is a thing to protect.

## Is the RPG layer complete for this version, with the list applied?
YES. With these ten changes, every system the owner asked for (the coach grows, the fighters pick and change, the bond, the style, moments) is there,
priced in the club week's coin and on the right menus. What is missing is the feedback loop and three effects that do nothing in the code, not new
systems. Adding more (more levels, more cards, more marks) would widen it without deepening it. The probes in section 16 still decide what stays.

## Drawing
My 10/10: `docs/mockups/s432/critics/rpg2_systems_10.png` (HTML beside it). Tess's Character tab, where every number has its decision or its result
beside it: what the picks won this season, the perk pick priced on the next three names, traits as lines with the button that moves them, the knockout
card with odds per answer, Known steps with what each does, and the direction's clash with the weak spot.

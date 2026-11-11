# RPG layer (RPGLAYER1, S432): blind review by a character-progression designer (tactics RPGs: XCOM, Darkest Dungeon)

Read whole: CRITIC_PACK.md, CRITIC_ACCESS.md, RPG_LAYER_MAP_S432.md, CLUBWEEK_MAP_V4_S432.md, both drawings (HTML and PNG). Checked in the code:
PerkRoad.gd, Knowledge.gd, TheRead.gd, Exchanges.gd (uptake, FULL_SHOUTS), CornerTrust.gd, FighterProfile.gd, HeadCoach.gd.

## Score: depth 6 / 10
One line: the coach's either/or road and the knockout turn are real trades paid in the club week's own coin, but the fighters still never make a growth
pick of their own, one coach pick is a number shuffle, the tree ignores your background and stops in season 2, and "the read" rebuilds a range system the
code already has, under a word the code already uses for something else.

## What works (keep it)
- Every coach pick is paid in the club week's coin (pad places, coached mornings, shouts, fixes, favours, loyalty). Levels 2, 4, 5 and 6 are real trades:
  each one changes which decisions you make on Monday or on fight night, not just a number. This is the XCOM promotion done right.
- The pick card shows the trade in this squad's numbers ("Tess's 2 Cardio mornings with you, Stamina +0.5 a week, was +0.4"). That is the best
  readability idea in the map. Your road shows both sides of later levels ahead of time, so the player can plan a build.
- Experience only from what you do in person makes "you or Coach" a growth choice too. Good loop.
- One number for the bond (loyalty), mood kept as the short one. Bands that unlock things (hold pads, the free short week, the third answer) are clear.
- The knockout turn is the best Darkest Dungeon idea here: one roll, and the player's choices (rest, sit with them, back on the sheet) move the odds,
  shown before choosing at a deep enough read. Traits that drift by what the weeks ask, capped at 10 a season, keep people recognisable.
- Build direction gives each boxer a shape and a fight-side effect (the style dials), with a measured cut rule.
- The cut rule and the probes (COACHXP1 ... MOMENT1) are what keep this from being decoration.

## What is wrong or thin
1. THE FIGHTERS HAVE NO PROMOTION PICK. In the code, perks open by themselves when an attribute reaches its need (PerkRoad.gd: "open for good").
   The coach gets five either/or picks; a fighter gets none. Build direction is a slow setting, not a moment. In a squad RPG the soldiers' picks are the
   heart of attachment. This is the biggest missing piece.
2. LEVEL 3 IS A NUMBER SHUFFLE. One on one (1.15 / 0.7) against The room (0.95 / 1.0) is "+5% training" in disguise, which the map's own CUT line forbids.
   Which side wins is arithmetic on the squad's pairings, not a style of coaching.
3. YOUR BACKGROUND DOES NOT TOUCH THE TREE. Old hand, Ex-pro, Amateur coach and Strength coach meet the same five questions. Four backgrounds times the
   same 32 builds: no class identity, little replay.
4. THE ROAD ENDS IN SEASON 2. Level 6 is the cap, reached early in the second season; after that experience buys nothing. The career is open-ended
   in the code (pro ladder, ageing, belts). A progression that stops is a dead meter on screen.
5. "THE READ" DUPLICATES CODE AND CLASHES WITH A WORD. Knowledge.gd (KNOW1, S411) already narrows each ability's range by exposure from sessions,
   tests, sparring and bouts ("the range never lies"). The map invents CoachRead with steps 0 to 5 and never names Knowledge.gd. And TheRead.gd is
   already "the read": a fighter reading an opponent's habit in the fight. One word per concept is a standing rule.
6. TRAITS SAY WHAT MOVES THEM, NOT WHAT THEY DO. The Character tab tells me coachability is wearing down, but not that 36 means Tess takes in about
   81 in 100 of a shout (Exchanges.uptake: 0.7 + 0.3 x coachability). Heart scales mood losses (x0.8 at 84), confidence scales mood gains: none of it shown.
   A trait you cannot read the effect of is flavour, and the owner rules out flavour.
7. MOMENTS WILL REPEAT AND FORGET. Eleven cards, 4 to 8 a season, no memory between them (except the dated promise). By season 2 the player has seen the
   deck. Darkest Dungeon's events stay alive because they leave marks. There is also no card between two of your own fighters, though the club week is
   built on them competing for the same pad places.
8. BUILD DIRECTION IS A FREE LUNCH IN TRAINING. Three abilities faster, two slower, and "None" gets nothing: None is dominated unless the fight half bites.
9. MULTIPLIERS ON THE STYLE CARDS. The pick cards translate into this squad's weeks; the style cards still say "x1.4", "x0.9", "x1.15". Same page, two
   languages.
10. PERK 4 MISREADS THE CODE. FULL_SHOUTS is "the round's first 2" (Exchanges.gd), not a minute. "Three shouts a minute" against "two" is wrong by a
    factor of three rounds' worth; the card must say "a round".
11. SMALL: the Loyalty row in the Traits list repeats the bar ("the bond, on the left"); cornering now pays experience, loyalty, coachability and 3 read
    sessions at once, so on two-hall nights the choice of who corners is close to solved; TRUST ME needs to say it bypasses CornerTrust.lands (Low).

## Missing options
- A fighter's own either/or pick when a perk opens (two versions of each perk).
- A background-only option on one level of the road for each of the four head coaches.
- A way to keep growing after level 6 (take a closed side back, at a price).
- A squad moment between two of your fighters (pad-place jealousy, a sparring grudge), priced in pad places and the sparring pair.
- On each Club week slot that earns experience, the experience shown at the moment you deal it (so the trade is visible when made).
- "Sessions to the next step" per fighter on the read pips, so the read tells you whom to coach next.

## Useless or weak options
- Level 3 One on one / The room as written (a multiplier swap).
- The Loyalty row inside the Traits list (duplicate of the loyalty bar).
- Build direction "None" as written (dominated in training, nothing of its own).
- Moment 5, Mouth before the show (+3 fans against x0.9 uptake for one bout): too small to be a decision; give it a memory (a rival corner remembers) or cut it.

## To reach 10/10 (most important first; each buildable)
1. FIGHTER PERK PICKS: each of the 8 perks on PerkRoad opens as an either/or of two versions, picked on the Monday it opens (Character tab and Profile perk
   road; top bar flag PERK PICK). Example: Body snatcher = THE DRAIN (body shots drain 15% more energy) or THE DROP (a body shot after a count: knockdown 1 in
   10); Iron chin = TAKES IT (first count a stagger) or GETS UP (counts beat 2 seconds faster, heart roll at 8). Build direction decides which version is
   listed first. New probe PERKPICK1: each version beats the other against some style by 1.5 wins in 100 or more, else the pair collapses to one perk.
2. RENAME AND REUSE THE READ: call it KNOWING THEM (TheRead.gd keeps "the read"); build CoachRead on Knowledge.gd: your in-person sessions are the only
   exposure that counts; the five steps are bands of Knowledge.width. One range system, not two.
3. REPLACE LEVEL 3: ONE ON ONE: a morning alone with you counts twice toward knowing them and can train out a habit like a pad place. THE ROOM: any session you
   run with two or more fighters stops discipline skips for everyone in it, and each gets +1 discipline every 4 weeks. Both trades sit on the Club week counters.
4. YOUR BACKGROUND SHAPES THE ROAD: one level per background offers the background's own option in place of one side. Old hand: level 5 EYE FOR THE SCALE
   (every weight forecast exact; one kilo a season asked for no favour). Ex-pro: level 4 a third corner option (one set-up NOW! a bout lands as best).
   Amateur coach: level 5 EYE FOR PEOPLE at double speed. Strength coach: level 2 a body-morning option (your coached Cardio mornings cover two fighters at 1.0).
5. GROWTH AFTER LEVEL 6: SECOND THOUGHTS, once a season: spend 40 experience to take the side you closed at one level. A goal every season, no respec.
6. TRAITS SAY WHAT THEY DO, IN THE CODE'S NUMBERS: each row on the Character tab and on Profile hover: Coachability 36 "takes in 81 in 100 of a shout; at 40
   Listens"; Heart 84 "a loss hurts mood x0.8"; Confidence 70 "wins lift mood x1.15"; Discipline under 45 "skips 1 alone morning in 3". Each read trait also
   names the line it is moving toward and what crossing it changes.
7. MOMENTS WITH MEMORY AND SQUAD CARDS: every answer writes a mark a later card reads (sat with them: the next knockout card's Hardened +25; let them talk:
   a rival corner card two bouts later; a date given: a "you said by March" card on the date). Add two squad cards between two of your fighters (pad-place
   jealousy: swap one back / spar them Technical / say nothing, no sparring together for 4 weeks; a sparring grudge). No card twice for one fighter in a season.
8. MAKE DIRECTION A TRUE TRADE: two faster, two slower for each direction; NONE gets ADAPTABLE (one opponent tell fewer is known about this fighter, or the plan's
   "rate against" gives no penalty for a style mismatch). DIRECTION1 also shows None best in at least one line-up.
9. ONE LANGUAGE: translate the style cards and every multiplier on Club > You into this squad's weekly numbers, as the pick cards already do
   ("Lucy: Stamina +0.36 a week, was +0.40"; "Tess Stubborn: a band of loyalty by July").
10. SHOW EXPERIENCE AT THE DEAL: on Club week, a small "+2" on the corner pick, "+3" on a habit pad place, and a line on Club > You: "this week's board can earn
    you +9". Show "step 3 in 4 sessions" beside every read pip row.
11. FIX PERK 4 TO THE CODE: RINGSIDE VOICE = 3 shouts a round in full (Exchanges FULL_SHOUTS is per round); the card shows the last six bouts' shouts lost to the
    cap and the minutes with a fix left waiting, so the pick reads from your own record. TRUST ME bypasses CornerTrust.lands for one shout.
12. CUT the Loyalty row from the Traits list; cut or rework moment 5; cap what one bout cornered pays (experience and read, not also coachability) so who
    corners stays a choice on two-hall nights.

## Is the RPG layer complete for this version, with the list applied? YES
With the fighters' own perk picks, a background-shaped and open-ended coach road, traits that say what they do, moments with memory and squad cards,
and the read folded into Knowledge.gd, both halves of the bond grow by choices: you through five plus seasonal picks, each fighter through a direction,
eight perk picks and traits the weeks wear down. Everything is paid in the club week's coin and shown on the menus the map lists. What it leaves for later
(the hired Coach growing, the rival club that poaches, scars, prime and decline) belongs to the small living world and the career, not to the club week.
Without items 1 to 4 it is not complete: the fighters would only be grown, never built.

## My 10/10, drawn
`docs/mockups/s432/critics/rpg_designer_10.html` -> `rpg_designer_10.png` (1920x1080): Club > You with the road shaped by the Old hand background and Second
thoughts after 6, the level 4 pick read from your last six bouts, the style in this squad's weeks, a squad moment between Samira and Tess; Tess's perk pick
(The drain or The drop), traits that say what they do in a bout, and Knowing them with sessions to the next step.

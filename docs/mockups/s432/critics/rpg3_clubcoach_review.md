# RPG layer v3 review: a club coach of 30 years (blind, S432)

Read: CRITIC_PACK, CRITIC_ACCESS, RPG_LAYER_MAP_S432 (whole), CLUBWEEK_MAP_V41_S432 (sections 1 to 3.10 and the headings), both drawings, and the code
the hook table names (Exchanges, Knockdowns, CornerJobs, CornerTrust, Knowledge, PerkFight, PerkRoad, FighterProfile, Recruit). No other critic's file.

## Score: depth 7 / 10
One line: a coach and boxer who really do grow together, every pick paid in the week's own coin and most fight effects on real code; it stops short of 8
because the moments a coach remembers are decimals in a ledger, not calls on fight night, and almost half the hooks land on a club week that is not in the code yet.

## What is right (as a club coach)
- Your own hours are the experience. Cornering, habits trained out on your pads, promises kept. That is how a coach gets better. Coach's sessions give you nothing: right.
- The level picks are real either/or picks on one coin (evening pads against mornings; voice in the round against the plan in the minute). Real corners split that way.
- One bond number (loyalty) with a forecast before Start week. Going short is the commonest way a club loses a good amateur, and the map prices it.
- Traits at lines, each with the button that moves it. Coachability, heart, temper and discipline are what I read in a boxer in the first month.
- Known built on Knowledge.gd: "you know their heart when you have cornered them" is the truest line in the map.
- The knockout turn (Hardened or Shaken, moved by rest and by sitting with them) is exactly what happens after a stoppage.
- Moments with coin tags and memory cards (the favour back, the promise falling due, your corner this time). A gym remembers.

## What I checked in the code (it matters for the owner's bar: every effect real)
- Real today: Exchanges.FULL_SHOUTS = 2 and uptake; Knockdowns REF_STOP x (1.4 - heart/100), KO_ODDS, the 0.6 fall-off, stop_mult on the loser's side;
  CornerJobs.talk's 45 / 50 / 60 / 65 lines and RECOVER_POINTS 3; PerkFight's hooks (jab_edge, call_edge, combo_rate, setup_edge, round_line); Knowledge.expose / width / stale.
- Not real: Knockdowns.puncher_chance does not read stop_mult (the map says so). Knowledge.gd is called by nothing in scripts/. And the WEEK half of the hook
  table (ClubDeal, pad places, Loyalty bands, Favours, SparPair, SeasonTarget, BoutSheet, the discipline skip) has no module in scripts/ at all. About half of
  the effects therefore land on rules that do not exist yet. The order in section 19 is right; the risk is that the RPG layer gets briefed before its floor is laid.

## Missing options
1. THE TOWEL. The biggest call a club coach makes is pulling a boxer out between rounds, or sending them out for one more. The game has a cutman stop-or-go
   for an eye only. With loyalty, heart, Known (Fire) and Hardened/Shaken already in the map, this is the one fight-night choice that would use all of them at
   once: pull out (a loss, safe; a trusting fighter says "you looked after me", a wavering one "you quit on me"), one more round (stop odds shown exact when
   heart is known), or box safe (Jab and move only, lower stop odds, lower win chance).
2. The coach's level has no name in the world. Real coaches climb coaching awards (assistant, club coach, senior, elite) and each opens something real:
   cornering at a national final, taking more boxers, running a camp. Name the levels after that ladder and give each one a real door, beside the either/or pick.
3. Felt units in the ledger and on the perk card. "+0.9 in 100", "+1.2 in 100" are honest but no coach feels them. Say "about 1 round turned against J. Moss",
   "1 count waved on, won on points"; keep the in-100 number in hover.
4. Taking a fighter off a sheet because they are not right in the head (a stale or Shaken fighter) as a choice with a loyalty price, not only a card.
5. The grappler's picks and card 9 are written for Ana by name. The sandbox rule says no fighter is the story: write them for any grappler (Ana is the example).

## Useless or weak options
- Coach's raise: pay it or growth stops 8 weeks. One obvious answer every time; fold it into the staff bill or give the no a real upside.
- "Pip" (Known 2, Pip 3 in 4 on the same panel): two words for one thing, and "pip" is not a game word. Say "4 more sessions with you".
- Season pick DEEPEN for Early starts ("6 mornings, no evening pads"): nobody takes it; one side of that pair is dead at the season pick.
- Card 3 A WEDDING ON SATURDAY and card 7 THE OLD COACH CALLS: flavour with small coins; fine to keep in the deck, but they should not count toward the
  "4 to 8 moments a season" the probe asks for.
- Hold pads (+1 pad place at 0.7 for a Loyal boxer): real, but it duplicates the captain's role in the room. One of the two is enough for 4 fighters.

## To reach 10/10 (most important first)
1. Lay the floor first: build and test the club week modules the hook table calls WEEK (ClubDeal, Loyalty with bands, the pad places, SparPair, SeasonTarget,
   the discipline skip), wire Knowledge.gd into the week review and the trial, and make puncher_chance read stop_mult. Add one test that fails if any line
   of the hook table calls a function that does not exist.
2. Add THE TOWEL to the corner minute (drawn): three answers, pull out / one more round / box safe, the stop odds exact when Fire is known and a range when
   not, the loyalty answer set by the band (Settled and up: trust gained; Wavering: -6), a mark ("you pulled me out" or "you sent me out") that the next
   knockout card reads. Probe TOWEL1: across a season, a corner that uses it keeps more fighters and loses fewer to 60-day rests than one that never does,
   without making one more round always wrong.
3. Name the coach levels after the real coaching-award ladder (assistant, club, senior, elite) and give each a door: level 3 corners a national final and
   takes a fifth fighter without the second club coach; level 4 runs a professional camp at full rate. Keep the either/or pick on top.
4. Felt units first: the perk pick card and the ledger say rounds turned, counts survived, weeks sooner, fighters kept; the wins in 100 go to hover.
5. One word for Known: drop "pip", show "N more sessions with you" and what that step opens.
6. Write the grappler's picks and card 9 for any grappler, and check the eight other moment cards read the same for a man, a woman, a pro or an amateur.
7. A "not right this week" choice on the bout sheet for a Shaken or Flat fighter: take them off (no favour lost, loyalty +2 if Settled, -2 if Wavering).
8. Cut or merge the weak options above (Coach's raise as a real choice, Early starts' dead deepening, hold pads or captain).
9. Show each moment's memory on the card that reads it ("you let Tess go to the wedding in February"), so the player sees the gym remember.
10. Golden-path test walks the towel once and a level door once, beside the walk already listed in section 19.

## Complete?
Yes, with the list applied, for this version: coach growth, the bond, traits, Known, direction, moments, marks, the squad and the ledger cover what a club coach
and boxer build together in a season. The towel is the one missing piece of the relationship, and the club week floor is the one missing piece of the code.

Drawing: `docs/mockups/s432/critics/rpg3_clubcoach_10.png` (the Character tab with the towel in the corner minute, the story so far, the coach award, felt units).

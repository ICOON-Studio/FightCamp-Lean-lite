# DESIGN_COACHDEEP3 - deep coaches v3: amateur bouts pay by rank, then the coach map again (S540)

Task: ops/research/TASK_COACHDEEP3.md. Base: DESIGN_COACHDEEP2.md (every v2 rule stands unless this page changes it) and the
owner's 24 answers (ops/research/COACHDEEP_GRILL_S539.md, binding). Probe: tools/coachdeep3.gd + tools/coachdeep3_rules.gd.
Result: docs/COACHDEEP3_RESULT.md. Nothing under scripts/ changes until the critics pass it.

Why v3: COACHDEEP2 failed on money (docs/COACHDEEP2_RESULT.md s5). An amateur on the club's $250 stipend returned $112 a
week (13 bouts x $450 against 52 x $250), so every coaching rule that let boxers go won. Owner, board Q-S294-311 "An amateur
costs $250/week, earns the club $112. Which fixes it?" -> **"Bouts pay by rank"**.

## 1. M1 - an amateur's bout pays the club by her regional rank (the owner's pick)

The stipend stays $250 a week (decided number). Only the club's cut of an amateur bout changes: it is read from her place on
the regional table (Region.rankings / RankLine order: ladder points, then net wins; on the table from Region.RANK_MIN_WINS = 4
wins) at the moment the bout is made.

| Her place at the bout | Club's cut | Tickets it stands for (GBP 15 x 1.25 = $18.75 a seat) | A bout every 4 weeks v $1,000 of stipend |
|---|---|---|---|
| Unranked (under 4 wins) | $450 (today's BoutRules.TICKET_CUT, unchanged) | ~24: family and the club | 45% |
| Ranked 4th or lower | $700 | ~37 | 70% |
| Ranked 2nd-3rd | $950 | ~51 | 95% - roughly pays her stipend |
| Number 1 | $1,200 | ~64 | 120% |

Sources (real numbers, our words):
- How a show's money comes in: on UK small-hall cards the revenue is the boxers' own ticket sales, about 55-60 tickets a
  boxer (2022) - ops/research/CLAUDE_LAND_NOTE_J46.md (headline). The number-1 band (~64) sits just above that: the region's
  best amateur sells like a small-hall professional.
- Club-show crowds 200-500 and tickets GBP 12-20 - John's research in DESIGN_HOSTSHOW1_CRITIC_JOHN.md:543 ([R]). GBP 15 is
  its middle.
- GBP x 1.25 to the game's dollars: Update 27 (CLAUDE.md "Decided numbers", the England Boxing club numbers).
- The unranked band is today's $450 so a novice's money does not change: in the normal game (no boxer at the start, Q-246)
  a walk-in novice earns what she earns today.
- The bands themselves (how many more tickets a ranked name sells) are ESTIMATE, set so the owner's sentence holds: "a
  ranked amateur roughly pays her stipend, an unranked novice does not". The probe checks it in money (bar j).

What a player sees (to wire after the critics): the Ask card, the offer letter, the bout page, the fight poster and the
money page already print "Club ticket cut $450" (BoutRules.TICKET_CUT in AskBout.gd:257, OfferLetter.gd:273/358,
BoutPage.gd:110, FightPoster.gd:77, VersusPanel.gd:161, MoneyPanels.gd:285, CashForecast.gd:160, OfficeDesk.gd:233,
BoutFinish.gd:131/141). Each reads one new function, BoutRules.ticket_cut(rank), and the rank row (RankRow.gd) adds the
next band: "Number 4 - top 3 sells $950 a bout". The club show (HomeBout) keeps no cut, as today.

Interactions: the Ask card's choice of opponent now has a money side (a win that lifts her into the top 3 is worth $250 a
bout after it); letting a ranked boxer go costs her band, not $450; Leaving.REP_LEAVE_RANKED (-5) for a top-5 leaver stays.

## 2. M2 - class nights with falling returns (COACHDEEP2 s5 item 2)

A club runs a timetable. The members fill one class night per 12 members (v2), but the nth class night of a week pays and
pulls members at a share: 1st-3rd full, 4th half, 5th and later nothing new (CLASS_RETURN [1, 1, 1, 0.5]). ESTIMATE: a
small club's members come on two or three fixed nights; a 5th weekly class splits the same people. So a second coach's
evenings are only worth classes in a big club, and in a small one his evenings go to the boxers.

## 3. M3 - a coached evening worth more than a stat decimal (item 3)

What only a coach gives is on the evening: he holds the pads. Each boxer has her own combination for her style (the game's
PLAYBOOK > Combos book row, OwnCombos; probe chains: out-boxer jab-jab-cross, pressure fighter jab-lead hook-body hook,
boxer-puncher jab-cross-hook, and so on) named as the plan's go-to (f["plan_combo"]). A coached pad place is one pad night
(PadWeek.PAD_NIGHT_MINUTES 240) at his pads rating, times his learn multiplier (fit, chemistry, morale) and his specialty
share of the chain (Q9: a hook man teaches the hooks at full, the rest at 0.85): half on the combination
(OwnCombos.drill_week), half on its weakest punch (MoveMastery.gain, capped by technique). With no coach she cannot drill it
and the combination fades (MoveMastery.decay_week; it keeps "usable" once earned). The bout reads it where the game does:
BoutRead.chance -> _energy -> OwnCombos.ring_edge (usable at 30, signature at 85, the go-to's share 0.40).
The probe measures this in wins first (mode=evening: coached on every place v never coached, 104 weeks, with and without the
combination) before any size is touched.

## 4. M4 - area weights follow the boxer (item 4)

A pressure fighter's week is half conditioning; an out-boxer's is mostly pads. Stat pace by style (sums to 1.0 like v2's
0.4/0.3/0.3): out-boxer technique 0.45 / defence 0.35 / conditioning 0.20; counter-puncher 0.35/0.45/0.20; boxer-puncher
0.40/0.30/0.30; pressure fighter 0.25/0.25/0.50; slugger and volume puncher 0.30/0.20/0.50 (ESTIMATE). Coach area per stat:
technique = pads, defence = half pads half tactics (slips are drilled on the pads and read from the corner), conditioning =
conditioning. With the specialty share on the combination (M3), the pressure fighter's chain (hooks) is taught best by a hook
man (the local pressure coach, the engine-room coach), the out-boxers' (jab-cross) by Reid or the known name.
The SMART rule a player would use reads the same: her style's weights over his areas x fit x chemistry x his specialty share.

## 5. M5 - chemistry resized (item 5)

Unchanged rules; the size is swept again with M1-M4 in (bar g: 1.0 / 0.6 / 0.4 / 0.25, the largest with CHEM best in at
most 5 of 10 cells), and the full run is the verdict at that size.

## 6. Menus (after the critics; nothing is built before the probe and two critics pass)
| Menu | Shows | Wired to |
|---|---|---|
| Ask card / offer letter / bout page / poster | the club's cut by her band | BoutRules.ticket_cut(rank) (new) |
| Rank row under the name | the next band and what it pays | RankLine.before + ticket_cut |
| Money page / week review | each bout's cut with its band | BoutFinish club_cut |
| Week plan | class nights 1-4 with their share ("4th night: half full") | ClubDeal.class_cash x CLASS_RETURN |
| Boxer card (Playbook) | her combination, its mastery, which coach teaches it at full | OwnCombos + coach spec |
| Coach card | his specialties against each boxer's chain | spec_mult |

## Prior research
COACHDEEP1 (PASS 5/5), COACHDEEP2 (FAIL a, c, f2, h), Kalli and Dola on v1, GymBills.gd, BoutRules.gd, LadderPoints.gd,
LadderRep.gd, RankLine.gd, OwnCombos.gd, PadWeek.gd, CLAUDE_LAND_NOTE_J46.md, DESIGN_HOSTSHOW1_CRITIC_JOHN.md.

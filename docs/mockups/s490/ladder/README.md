# Season ladder (LADDER1 v3): show me more first (S490)

**What this answers.** The board asked: "Season ladder v3 (reputation is the currency, not fixed win counts) passed two
fresh critics: Dola 7/7, John 7/7 (play 6). Before code I close John's two holes ... Build it after the fight week?"
The owner answered: **"Show me more first"**. So these are three pictures of the ladder as it would play, with
John's two holes closed in the drawing. No game code was touched. Round 2 (below) applies a fresh reviewer's 7/10 notes.

Sources read: `ops/research/DESIGN_LADDER1_V3_REVISE_KALLI_KALLI.md` (the design), `..._CRITIC_JOHN_JOHN.md`,
`..._CRITIC_DOLA_DOLA.md`, `ops/research/CRITIC_PACK.md`, `scripts/rules/WorldLadderRules.gd`, `scripts/rules/RankLine.gd`,
and the code files cited below.

## The three pictures

| File | What it shows |
|---|---|
| `ladder_screen.html` / `.png` | **The ladder mid-season** (Wed 3 Jun 2026, Fights > Ladder). The header holds her name, rank (6th of 10) and a **reputation meter** with the five bands and the proposed **45 pro-offer line**. Under it are five tiles: the clock (**stopped: an ask is pending**, drawn as a green "1 free" tile and a hatched "ask pending" tile), the pro offer, the season, the pinned target and the nationals (2026: lost in the regional semi). The table holds every women's lightweight in the London region, sorted by reputation. Rows carry no names (S448). The table marks the top (*Pro talk 3 weeks*), the **MANDATORY**, the **ELIMINATOR** pair, the coach's star, the challenger, the **OPEN class** boxers under each record (NOT SAFE for her as a 9-bout novice), and the TUNE-UP rows. Three lines cut across it: *your boxer's reach*, the *lower line* and *not ranked yet*. The chance column reads in %. The card belongs to the starred boxer, whose name appears only in its header. On the card, "your boxer" always means ours and "the opponent" always means the starred boxer. It shows the result bars, then **CHANCE TO WIN** as three labelled rows on a 0 / 25 / 50 / 75 / 100% axis (coach's read 57% could be 13 off, 51-63% before tape, the ladder prices it at 45%). After that come the plan, the tape, the opponent's dates (booked to 1 Aug, free 15 Aug), the weight chip and the ask (the opponent said YES). The challenge strip has three answers. Each shows its cost now and its average by 1 Aug, and the answer is due by **Fri 5 Jun**, before the 20 Jun sheet goes final on Sat 6 Jun. |
| `ladder_ask.html` / `.png` | **Asking and answering.** On the left are two asks she could make on Tue 2 Jun. **A** asks up and gets YES; **B** is a TUNE-UP far down. Each has its result bars and **the clock week by week**, with dates. A shows *1 free*, a hatched **ask pending** week, a hatched **booked** week, the bout, then a restart. B keeps counting through its bout to week 10, which costs −1. Under them sits her reach bar. On the right is **the challenge**. On top is the live one, with the three answers and the rule each follows. Below it the **same three answers play out in three weeks**: (1) today, with her ask open, where **Not this show** wins; (2) the same challenge with no ask open, where **Accept** wins; (3) a challenger whose style beats hers, where **Pass** wins. Each cell shows her next four club shows as tiles and her average reputation by Sat 1 Aug on a −3..+3 bar. Rows 2 and 3 are tagged "for the owner: not a game screen". The bottom strip shows hole 1 and hole 2 as WAS/NOW, plus the paper-probe results. |
| `ladder_season.html` / `.png` | **One season in 12 panels** (Jan 2026 to Jan 2027), with her reputation line underneath. The panels: she signs; her first bout; her first ask up; **she enters the London regional** (6 bouts, 168 days registered); she loses the regional semi (a drawn opponent, no tape); a refused rematch; tape and plan win; **a challenge accepted** (no ask was open); **the challenge against her ask (Not this show)**; 2 bouts in 14 days; **her eliminator** on Sat 1 Aug, which brings the **pro offer at 45**; then she stays amateur, the offer comes back at 55, and the season ends 1st at 62. The chart marks today's code offer (9 wins, Sat 4 Jul, week 26), the probe-3 window (within a quarter of that), the ladder's offer at 45 (Sat 1 Aug, week 30, inside the window) and where v3's 55 line would have put it (Sat 29 Aug, week 34, outside). |
| `paper_probes.py` | The sums behind the averages and the three probes (`python -I docs/mockups/s490/ladder/paper_probes.py`). It works on paper only (see Paper probes). |

## John's two holes: the fix drawn

**Hole 1: "Not this show" beat the other answers.** In v3 it cost 0, the bout simply came later, and the ask stayed.
Now:
- it costs **−1 reputation at once**;
- the challenger picks the date: **the club show 14 days after her bout** (shows run every 14 days, `Data.gd:107-108`).
  That date is printed on the button before she presses it, and the bout lands 14 days after her last one, which
  leaves less in the tank (`BoutRules.gd:45` LAST_BOUT: a bout 14 days before = −4 on the tank at the first bell);
- if her own bout ends in a **stoppage to the head**, she is suspended 30 days (`InjuryRoll.gd:12` KO_DAYS, England
  Boxing rule 4.1.2), so she cannot make that date and it **counts as a pass: −2 more**.

The ask page now draws **each answer winning once** instead of claiming it, from the same sums
(`paper_probes.py drawn_cases`, averages by Sat 1 Aug):

| Week | Accept | Not this show | Pass | Best |
|---|---|---|---|---|
| 1 · today: her ask open, the boxer she asked busy until 15 Aug | +1.9 | **+2.3** | +1.1 | Not this show |
| 2 · the same challenge, no ask open | **+1.9** | +1.7 | +0.4 | Accept |
| 3 · ranked 7th, a southpaw she has never sparred, coach reads 40% | −1.9 | −1.9 | **+0.4** | Pass |

**Hole 2: asking far down reset the clock for free.** In v3 any booking stopped the free-week count, so a near
risk-free bout far below bought 8 more weeks. Now there is a **lower line, as wide as the reach above** (16 at 31). A
bout under it is a **TUNE-UP**: it is allowed (a real amateur needs one after a loss or a layoff), it pays by the same
sum (+2 / −14 in the drawing), and **the clock keeps running**. John's other option was to refuse those asks outright. I
did not draw that, because it would take away the tune-up a boxer needs coming back. Challenges come only from inside
the lower line, so an accepted challenge always stops the clock.

## Paper probes (the to-10 list asked for probes 11 and 16)

The game's probes need `RepRules`, `Clock` and `Challenge` built, and the fight engine to decide bouts. That code does not
exist, and this task may not touch game code or run Godot. So `paper_probes.py` runs the **v3 sums** with stand-in
chances. It is evidence on paper, **not** the game's probe. Its results:

- **Probe 11** (each answer best in 15%+ of 20,000 random challenges): **Accept 58% · Not this show 17% · Pass 25%:
  passes.** It depends on one number nobody has measured: how many points of chance a 14-day turnaround costs. The sweep:

  | Chance points lost to a 14-day double | Accept | Not this show | Pass | Probe 11 |
  |---|---|---|---|---|
  | 0 | 45% | 32% | 23% | pass |
  | 1 | 52% | 24% | 24% | pass |
  | **2 (drawn)** | **58%** | **17%** | **25%** | **pass** |
  | 3 | 63% | 11% | 26% | fail |
  | 4 | 68% | 5% | 27% | fail |

  If the real cost is 3 points or more, the −1 is too much. The fix is then to drop it to 0 and keep the
  challenger-picks-the-date rule. With 0 and 4 points lost, the split is 26 / 56 / 18. **This is the first thing to
  measure once the fight week's tank rule is live.**
- **Probe 16** (a boxer at 55 cannot hold the clock by booking far down; 200 seeds, 52 weeks, one bout every 4 weeks
  against the lowest boxer she can find): she ends the year at **34 under the new rule, against 53 under v3: passes.**
  Under v3 the clock never ran. Now it takes about 1 point every 2 weeks until her lower line comes down to meet the
  bottom of the ladder.
- **Probe 3** (the pro offer within ±25% of today's code): today's code (`Roster.gd:31-33`) offers on Sat 4 Jul (9 wins,
  week 26). With **v3's 55 line**, she passes it on Sat 29 Aug (week 34, 1.30×), which **fails** even with the
  eliminator on the first show it can take. With the **proposed 45 line**, she passes it on Sat 1 Aug (week 30, 1.15×),
  which **passes**. See new rule 5.

## New rules this page proposes (not in v3, not in code)

These need a critic round and Claude's go before anything is built:

1. **Not this show**: −1, the challenger names the show 14 days after her bout, and a stoppage to the head on her bout
   (30-day suspension) turns it into a pass (above).
2. **The lower line and TUNE-UP** (above).
3. **MANDATORY and ELIMINATOR on the amateur ladder.** v3 does not have them. The code has a mandatory challenger only for
   pro belts (`WorldRank.gd:171 mandatory_challenger`, shown by `WorldLadderRules.gd:146 marks`). Proposed for the amateur
   ladder:
   - the top's next bout must be the **mandatory** (at the start, ranked 2nd);
   - while that bout waits, the ladder books the next two free ranked boxers into an **eliminator**, and the winner is
     the next mandatory;
   - **the ladder books it for the first show the 14-day lead allows** (panel 11: booked Tue 14 Jul for Sat 1 Aug);
   - both bouts ignore the reach line and pay by the normal sum.
4. **A pending ask counts as booked for the clock**, from the day it is sent until the bout. Both pictures draw the same
   state: one free week (week of 25 May), then a hatched **ask pending** week (she asked Tue 2 Jun), then **booked**
   once the sheet is final (Sat 6 Jun). A tune-up ask never stops the count.
5. **The pro offer at 45, not 55** (probe 3 above). The offer comes when she enters the **Contender** band. If she stays
   amateur, it comes back at **55** (the start of **Pro-ready**) or after a regional stage win, which keeps v3's +10
   gap (v3 had 55 then 65). Knock-on effects, not yet checked: the rivals' drain line (v3: 55+ held 8 weeks) should move
   to 45 too, the seed cap must sit under it (44), and probe 8's "top 5 between 40 and 75" needs a re-read.

## Every number and where it comes from

**From the code**
| Number / word | Source |
|---|---|
| Day 0 = Mon 5 Jan 2026; all dates and week numbers (week = day ÷ 7 + 1) | `CRITIC_PACK.md:45` |
| Club shows every 14 days from day 12 (… 23 May, 6 Jun, 20 Jun, 4 Jul, 18 Jul, 1 Aug, 15 Aug, 29 Aug …) | `scripts/state/Data.gd:107-108` |
| An ask is for a show at least 14 days away | `scripts/rules/AskBout.gd:17` MIN_LEAD_DAYS |
| An ask opens 10 days after her last bout (so after Sat 23 May, Tue 2 Jun at the earliest) | `AskBout.gd:28-51` open(), with `Bouts.gd:48` AFTER_FIGHT 10 |
| A stoppage to the head = suspended 30 days (England Boxing 4.1.2) | `scripts/rules/InjuryRoll.gd:5, 12, 60` |
| A bout 14 days after her last = −4 on the tank at the first bell | `scripts/rules/BoutRules.gd:45` LAST_BOUT |
| "Never faced a southpaw" (case 3) | `BoutRules.gd:55` NEVER_FACED |
| Ranked at 4 wins | `scripts/state/Region.gd:16` RANK_MIN_WINS |
| Novice = 0-10 bouts and meets only novices; 11+ = open ("NOT SAFE", "OPEN · 12", "2 more bouts") | `scripts/rules/AmateurBooking.gd:12, 30-34` experience_match_ok |
| 18 bouts a season (amateur) | `scripts/world/WorldAge.gd:13` MAX_FIGHTS_AMATEUR (CHECK 3: per season?) |
| Today's pro offer: 7 wins + top 3, or 9 wins (9 wins on Sat 4 Jul on her path) | `scripts/state/Roster.gd:31-33, 178-188` |
| Registered = signing day − bouts × 7 × 4 (her 3-1 counts back 112 days, so 168 days on Mon 2 Mar) | `Roster.gd:161-165` registered_day, `AmateurBooking.gd:11` LEAD_WEEKS_MAX |
| Nationals: 5 bouts + 91 days registered; entries close day 70 (Mon 16 Mar), open 56 days before; regional semi 14 days after the close (Mon 30 Mar); next close Mon 15 Mar 2027 | `scripts/rules/SeasonPath.gd:9-14, 23-38`, `scripts/state/Champs.gd:22, 61-63` |
| "Lost in the regional semi-final"; no other offers or asks while she is in a run; "Already boxed this year's championships" | `SeasonPath.gd:110`, `Champs.gd:7, 73`, `AskBout.gd` open() |
| Chip words "Not safe", "Weight at risk" | `scripts/ui/areas/BoutPage.gd:56` |
| Plan words Beats it / Works / Walks into it | `scripts/rules/PlanLines.gd:23` |
| Chance band 12 wide before tape (51-63%) | `scripts/rules/Matchmaking.gd:40` RANGE_RAW (the pro band; the amateur width is a CHECK) |
| The boxers, clubs, records at the start, stances, styles, habit "Stands still after combinations" | `scripts/state/Data.gd:58-105` |
| Lucy: walk-in, 3-1, orthodox out-boxer, 21, 60.9 kg against a 60 kg limit (the 0.9 kg) | `scripts/state/Data.gd:58` |
| Faces | `scripts/rules/Faces.gd:25-30` CAST (the new entry uses mh_boxer_20, a spare face) |

**DERIVED or CHECK (moved here in round 2: the code does not mean them the way round 1 used them)**
- `Bouts.gd:48` AFTER_FIGHT 10 is the wait before the next **offer or ask** after a bout (`Bouts.gd:438` next_offer_day,
  `AskBout.open`), **not** a minimum gap between bouts. Round 2 uses it only to date the ask (Tue 2 Jun) and the bout
  cadence (an ask bout lands two shows after the last). The Not-this-show date now rests on the show calendar.
- `Matchmaking.gd:33` STOP_REST_WEEKS 8 is the **pro** matchmaking rest (with GAP_MONTHS and pro camps). Its use on the
  amateur ladder (v3 1.2 cites it) is unchecked. Round 2 uses the amateur rule instead: `InjuryRoll.gd:12` KO_DAYS 30.
- "Booked by the ladder Tue 14 Jul": 10 days after her 4 Jul bout, 18 days before Sat 1 Aug.

**From the v3 design (ESTIMATE or GAME VALUE there, untested)**
- Expected = 1 / (1 + 10^((opp − you)/25)), with 16 points a unanimous result; average = 16 × (real − expected).
- Win weights: stoppage 1.15 (+2), majority 0.65, split 0.5. A loss pays the same, so it is zero-sum.
- Reach = 10 + reputation ÷ 5 (on the screens only as numbers: "up to 16 above (47)", never the formula).
- Bands: 0-14, 15-29, 30-44, 45-54, 55+.
- Seed = 8 + 4 × net wins + bouts, capped at 65. Walk-ins start at 0. Pro talk: 55+ held 8 weeks (see rule 5).
- New entry on the first Monday of each quarter. Clock: −1 every 2 free weeks after 8.
- Challenges at most once every 4 weeks; Pass −2; a second pass means none for 8 weeks.
- Coach's error ±(25 − rating ÷ 5), so ±13 for a 58 coach. Season ends on the first Monday of January.

**DERIVED (worked from those formulas)**
- Every win / lose value on the pictures. At 31 against 33: +12 stopping her, +9 unanimous, +4 split, +1 draw, −7, −10.
- Ladder prices the starred bout at 45% (31 against 33).
- Her season: 0 → +14 → +11 → −6 → +7 (majority) → +5 → −1 (Not this show) → +9 → +3 → +9 → +4 (split) → +3 → +4 = 62.
  It passes 45 on Sat 1 Aug and 55 on Sat 29 Aug. Record 13-2, 11 bouts.
- The averages by 1 Aug on the ask page and the screen's strip (+1.9 / +2.3 / +1.1 and the two other weeks), from
  `paper_probes.py`.

**STAND-INS (drawn to show the layout; not real numbers)**
- Every rival's reputation and record on 3 Jun and through the season (rivals box each other at shows, `Region.gd:91-92`;
  that was not run).
- The coach's reads (57% for the starred boxer, 72% for the challenger, 40% for case 3) and the centres of the chance
  bands.
- In the averages: "an ask" filling a free date is worth +1.2 (v3's safe-road figure); a 14-day double costs 2 chance
  points (the tank's −4 is code, but turning it into chance is a CHECK); a 5% chance of being stopped.
- The starred boxer's bookings (4 Jul, 18 Jul, 1 Aug). The tape count and the plan word on the card.
- The probes' random ranges (paper_probes.py STANDINS).
- The club name "Anvil Street Gym" and its crest, from the kit mockups (the player names the gym). The cash was left
  off the top bar on purpose.

## Review round (round 2: fresh reviewer, 7/10)

**Must fix**
| Item | What I did |
|---|---|
| Panel 4 "NATIONALS: NOT YET / CLOSED" and the README finding were wrong (`Roster.gd:161` backdates registration) | Fixed. Panel 4 is now **ENTERS THE REGIONAL**, Mon 2 Mar: 6 bouts, 168 days registered. Panel 5 became the regional semi-final, lost on Mon 30 Mar. The spring was re-dated so every bout lands on a day the code allows: a semi on 28 Mar would have clashed under `Champs.gd:73`, and a loss in the final on 6 Apr could not reach a 25 Apr bout. The finding is deleted. The screen's NATIONALS tile now reads "2026: lost in the regional semi". |
| Answer by Sun 7 Jun came after the sheet went final on Sat 6 Jun | Fixed: **answer by Fri 5 Jun**, on the screen and the ask page, both stating the sheet goes final Sat 6 Jun. |
| The starred card switched what "her" means | Fixed. On the card, **"your boxer"** means ours throughout ("What each result moves for your boxer", "your boxer: 0.9 kg to go", "on Cut she makes the limit") and **"the opponent"** means the starred boxer ("the opponent's dates", "the opponent said YES"). The table's reach line and header also say "your boxer". |
| Panel 11 "week 37" | Panel 11 is now Sat 1 Aug, **week 30**. All twelve labels were rechecked (week = day ÷ 7 + 1); 12 Sep is no longer drawn. |
| Panel 10 title ran into the faces | Retitled "2 BOUTS, 14 DAYS", and the title box leaves room for both faces. |
| The clock contradicted itself | One state, drawn the same on both pictures: **stopped, ask pending**. The screen tile shows "1 free" plus a hatched **ask pending** tile. The ask page's A row shows 1 / ask pending / booked / bout / restart, with a date under each week. Today moved to **Wed 3 Jun**, because an ask on Mon 1 Jun was not allowed: it opens 10 days after the 23 May bout (`AskBout.open`). |
| CHANCE had no % and no scale; the card meter packed three ideas onto one axis | The column reads "CHANCE TO WIN" with % values. The card has **three labelled rows on one 0 / 25 / 50 / 75 / 100% axis**: "★ Your coach reads 57% · could be 13 off", "Before tape 51-63%", and "The ladder prices it 45% · sets the win / lose numbers". |
| Formulas and jargon on player screens | Cut "10 + her reputation / 5" (the ask page now says "both lines sit 16 from her today and move out as her reputation grows"). "Falls from week 8" became "8 weeks in a row with no bout: reputation starts to drop" and "after 8 weeks she loses 1 reputation every 2 weeks". |
| NOT SAFE marking incomplete | Every open-class record now carries a red **OPEN · n** under it (the top 12, the 2nd 14, the 9th 11). The top and 2nd answer **NOT SAFE · open class**. The MANDATORY chip still shows the 2nd's booking. |
| AFTER_FIGHT 10 and STOP_REST_WEEKS 8 presented as "From the code" | Moved to DERIVED/CHECK with what each really means. The Not-this-show rule now rests on the show calendar (`Data.gd:107-108`) and the amateur 30-day head-stoppage suspension (`InjuryRoll.gd:12`). |

**To reach 10**
| Item | What I did |
|---|---|
| Draw a case where Accept wins | Done, along with a case where Pass wins: the ask page shows three weeks and three winners (table above). Round 1's case still has Not this show best, now by +2.3 against +1.9, not by a mile. |
| Run probes 11 and 16, replace stand-in averages | Ran them **on paper** (`paper_probes.py`). The game's probes cannot run: the ladder is not built, and this task may not touch code or run Godot. Probe 11 passes at 58 / 17 / 25 when a 14-day double costs 2 chance points, and fails at 3 or more (sweep above). Probe 16 passes (34 against 53). The averages on both pictures now come from that script, though they still use the stand-in chances listed above. |
| Fix probe 3 (pro offer four months late) | Done: proposed **new rule 5, the offer at 45** (and back at 55), plus **the eliminator on the first show the lead allows** (new rule 3). The offer moves from 7 Nov to **Sat 1 Aug, week 30**, which sits inside the probe-3 window (19.5-32.5 weeks). The chart shows the window, today's code, the 45 offer and where 55 would land (29 Aug, outside). |

## Found while drawing (for Claude, not the owner)
- **The seed cap sits above the drain line.** The 14-2 boxer seeds at 72, capped to 65. Anyone at the drain line turns pro
  after 8 weeks, so the region's best leaves in week 8 of the first season (panel 3). With rule 5 the cap must be 44.
- **The v3 dates are off the code's calendar.** v3 cites `CAMP_WEEKS` 2; `AskBout.gd:22` has 3. v3's example dates
  (29 Mar, 12 Apr) are not show days; the shows are 28 Mar and 11 Apr.
- **The ask cadence is one bout every 4 weeks.** An ask opens 10 days after a bout, for a show 14+ days away, so it
  lands two shows later. Only challenges (Not this show) and the ladder's own bookings can be closer. Every bout in
  the storyboard was dated to that rule.
- **The ladder needs more rows than the code shows.** Today's regional table shows 8 rows (`Region.gd:17` RANK_ROWS) out
  of 11 rivals plus our boxers. The drawn ladder shows 12 (CHECK 1).
- **Do regional bouts pay ladder reputation?** I drew yes: the regional field is the region's rivals (`Champs.gd:92`),
  and v3 pays its +5 one-off on top for a win. National-draw opponents are not on this ladder, so they would pay only
  the one-offs.

## Open questions for the owner (taste only)
1. **The pro offer at 45 instead of 55.** At 55 it came about two months after today's game (29 Aug against 4 Jul); at 45 it comes
   four weeks after (1 Aug). Is the earlier offer right, or should the climb to pro feel longer?
2. **Names in the rows.** I drew none (your S448 rule): each row shows a face, club and record, and the name appears only on
   the card. Is that enough to find a boxer on the ladder?
3. **The reputation number on each row,** or the band word only? I drew both.
4. **Mandatory and eliminator on the amateur ladder.** Keep them (they give the top a reason to fight and a way past the
   reach line, as in panel 11), or keep them for the national/pro ladder later?
5. **Three answers to a challenge**, or only Accept and Pass if the real probe shows "Not this show" is not worth its click?

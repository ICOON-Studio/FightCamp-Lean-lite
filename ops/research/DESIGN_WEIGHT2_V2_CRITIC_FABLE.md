# WEIGHT2 v2 (round 4) - code-checked critic (Fable console, S536)

Kind: research. No game code changed, Godot not run. A fresh critic: I read the brief
(`ops/research/DESIGN_WEIGHT2_V2_CRITIC_KALLI.md`: the critic pack, then the round 3 map), the current map
(`ops/research/DESIGN_WEIGHT2_V2.md`, round 4), John's note (`JOHN_WEIGHT2_RESEARCH_JOHN.md`), the probe
(`tools/weight2_probe.gd`, all 500 lines) and its output (`docs/WEIGHT2_PROBE4.md`; `WEIGHT2_PROBE3.md` for the change).
Code read at commit cd9a84dbe on 2026-11-21. The map read the code at 31d42481e; three files it cites changed since
(`TapeRows.gd`, `FightPrep.gd`, `ProLadder.gd`). `MHRig.gd` and `Player2.gd` carry uncommitted edits and are not cited
by line; `LineGrade.gd`, `LiveRound.gd`, `StepWire.gd` are not cited by line either. Branch `s535/dmgfix` was read with
`git grep`, never checked out. I did not open John's sources.

## 0. The verdict in six lines

1. **Scores: DEPTH 6, GENERAL DESIGN 7, PLAY 6. The bar is 8 and 8: not met.** Another round, not the board.
2. **The code map is sound.** 46 rows of CODE claims, every cited line opened: 37 true, 3 loose by a word or a line, 2 stale
   (the file grew), 2 true with a catch, 1 half true, 1 false. Nothing false blocks the build.
3. **The numbers are John's.** Every row of section 2 is the same as his; five numbers are the map's own and tagged so; five
   are changed in use or tag (section 3).
4. **The probe does what section 3 says, with seven things it makes true by construction** (section 4). The largest: the one
   trade the design is about, the SAME kilo taken off by diet or by water, is never run. Every choice diets first.
5. **Round 4's PASS is real by the letter and thin underneath.** All five bars are met on the output. Six of the seven
   "clear" cells largely follow from how the model was sized, before a bout is boxed, and section 4.6 says most of that itself.
6. **The fix is one more probe round on the right question** (section 6, items 1 to 4), not new systems.

## 1. Scores

### DEPTH 6: the reasons

- **What the player gets, measured: the scale decides, the boxer does not.** On the same-day scale "cut harder" loses in
  five cells of five; on the day-before scale it wins in four of five and the fifth is the same boxer twice. The map says
  it in its own words ("never on a club scale, almost always as a pro", 4.6 point 4). The first release is amateur to the
  first pro bout, so for nearly the whole game the answer is known after one try: Hold, light water, stay.
- **Moving down is best in no cell and moving up is best for one boxer** (the one who has outgrown the class, clear; the
  big chin is level with staying, and by plain ladder place staying is ahead, 9.03 against 9.09). So the class card, the
  owner's actual ask, has one live use in the probe: the boxer the body is forcing up.
- **The real choice is in the design and not in the probe.** A boxer 4 % over can lose it by a Lean diet (slower
  learning for weeks), by water (Stamina, the tank, a chance to miss) or not at all (move up: a rung and a size gap). That
  three-way price is good design, it changes with the boxer (Stamina over or under the 60 line, Discipline, age) and with
  the season (growth). The probe never runs it: `_setup` always takes the diet first and gives water what is left
  (`tools/weight2_probe.gd:310-311`). Section 4 item 1.
- **Interaction with the rest of the game is designed wide and measured narrow.** Loyalty, promises, Knowledge, the coach's
  evenings, growth and the nutrition plan are on paper (the map's own risk 4). The plan, the game's star, has no part: every
  cell boxes one of two fixed plans (`PLANS`, probe `:54-57`), and the opponent's weight story changes nothing he does.
- **Why not lower:** size, drain, diet, rank and miss each move the result with the lever off; the costs are sourced; the
  diet has a price the week already understands. The pieces of a deep mechanic are here. They are not yet a decision.

### GENERAL DESIGN 7: the reasons

- **For:** it is built from what the game has. Almost every claim about today's code is true to the line (section 2). It
  removes dead things (the unwritten `eat_kg`, the automatic cut, the cage) before it adds. It bounds itself (three
  decisions, one screen, a clear NOT IN list). It keeps John's tags and says where it guessed. The refusal is shown before
  the player commits, with its reasons: that is the right way to do a boxer's say.
- **Against, four holes a build would hit** (section 5): the pro's body limit has no room in it (safe line 8 %, cap 8 %);
  the amateur scale in the probe is a mix of two scales the design keeps apart; "None / Light / Hard" is really two
  settings; the 3 wins in 100 comes from professionals weighed the day before and John's own amateur rows find no link.
- **Words:** screen lines in the map say "he" ("Lean: -18 % on what he learns", "I am the big man here", "asks to move up").
  The sandbox rule (S412) is no fixed he or she in text: write them for "your boxer". The map's body text also names Data
  boxers; that is a document, not a screen, but the tape row and the BODY card lines must not.

### PLAY 6: the reasons

- **Anticipation: yes, twice.** The scale becomes an event with a chance on it, and the class card with his answer is a
  moment. The growth arc ("a lightweight by 19") is the kind of thing a manager remembers.
- **Week to week: little.** The diet is "kept until changed" and hidden while he is on Hold; water is one click in fight
  week; the class card appears between bouts. In most weeks the mechanic asks nothing and shows nothing new.
- **The dice have no hands on them.** A miss is a roll (15 to 24 in 100 a bout for the amateur who cuts 4 %), and the price
  is a walkover loss with nothing to do about it on the day. The map removes "Train it off" and "Eat less", the two things a
  player can do today when the scale is wrong. A pro's regain is a second hidden roll "the player sees only at the bell".
  Two rolls, no answer to either: that reads as bad luck, not as a cut gone wrong.
- **The reward is words.** "Outweighed by 3 kg" in the Why is right and small. The late fade is where a cut should be felt,
  and for the amateur it is one round of three, and only for a boxer whose Stamina the cut takes under 60 (section 5.6).
- **Why not lower:** nothing here is a chore, nothing is a timer, and the forced class move at 19 is a real story beat.

## 2. Every CODE claim, checked (sections 1, 3 and 5 of the map; code at cd9a84dbe)

TRUE = file, function and line as the map says. STALE = true at the map's commit, the file has grown since. LOOSE = right in
substance, wrong by a line or a word. Rows are grouped by the map's own table; "all TRUE" rows list every line I opened.

| # | Claim in the map | Verdict | What the code says |
| :- | :--- | :--- | :--- |
| 1 | `Data.gd:60`, `:222-242`: two numbers a boxer; everyone 0.9 to 1.4 kg over (1.5 to 2.3 %) | TRUE, LOOSE on the share | Six boxers, 0.9 to 1.4 kg over. As a share it is 1.4 to 2.3 % (65.9 for 65 is 1.38 %, 76.1 for 75 is 1.47 %). |
| 2 | `Data.fighter_state`, `Data.gd:261`: limit copied from the class at signing | TRUE | `"limit": float(DIVISIONS[div]["limit"])`. |
| 3 | Written again only by `SaveGame.gd:82-86` and `FirstHour.gd:125`; `ClubStart.gd:78` writes weight | TRUE | A grep of `["limit"] =` in `scripts/` finds those two and `WeekData.gd:38` (a goal's copy). No boxer changes class. |
| 4 | `Data.DIVISIONS`, `Data.gd:136-153`: women 57, 60, 65, 70, 75; men 55, 60, 70, 75 | TRUE | The table ends at `:154`. |
| 5 | Men's 65 (`mlm`, six region boxers) on `s535/dmgfix`, `Data.gd:151`, `:205-210`, not merged | TRUE | `git grep` on the branch: `:151` and six rows `:205-210`. The branch is still not an ancestor of main. |
| 6 | `WeekBoard.gd:353-357`, `WeekCamp.gd:270`, `BoutActs.gd:48-51`: the player can set Hold or Cut | TRUE | Two pills on each; the `diet` act writes `f["diet"]`. |
| 7 | `Sim.week_ctx`, `Sim.gd:121-126`, rule `:123`: cuts by itself in a camp or with an amateur bout booked | TRUE, LOOSE on one word | True. "Never takes him under the limit": it cuts while he is above limit - 0.15, so it can leave him 0.15 kg under. |
| 8 | `WeekPlan.day`, `:265-290`; kg rule `:287-288`; deficit 500 `:75`; Old hand 120 (`HeadCoach.gd:30`) | TRUE | `:30` is the card's text; the number is `OLDHAND_CUT_KCAL`, `HeadCoach.gd:24`. 500 x 7 / 7,700 = 0.45 kg a week. |
| 9 | `WeekPlan.gd:71-73`, `:289-290`: `TAPER_KG` 0.05 a day, no water cut in the game | TRUE | |
| 10 | The cage: `Sim.gd:222-224`, `Sim.weigh_forecast :154-156`, `CampForecast.gd:82-84` | TRUE | Three copies. It stops a weight going further out; it does not pull back one already outside (`minf` / `maxf` with his own weight). |
| 11 | `Sim.weigh_forecast`, `:136-160`; `CampForecast.run :35`, result `:100`; weigh-in the day before, `Sim.gd:142`, `modals/WeighIn.gd:17` | TRUE | Note: the tank already treats an amateur as weighed the same day (`BoutRules.gd:235`, `same_day := not pro`) while the calendar weighs everyone the day before. The map's same-day scale would end that disagreement. |
| 12 | `Bouts.makeable_day`, `:163-170`; 4 weeks, `:51` | TRUE | |
| 13 | `WeighGap.gd:7-9`, `:33-39`; `AskFlow.gd:83-93`; `FightWeekPlan.weight :183-189` | TRUE, LOOSE by a line | The function starts at `:184`. Opponent weight is `opp["weight"]`, else the limit (`:188`, `AskFlow.gd:93`). |
| 14 | `WeighGap.ways :44`, `FightWeekPick.weight_way :84`, `FightWeek.gd:34`, `modals/FightWeek.gd:131-138`, `WeighGap.gd:13-14` | TRUE | Eat less 4, train off 0.3 kg for +8. |
| 15 | `Bouts.weigh`, `:361-391`; `BoutRules.made_weight :283-284`, tolerance `:111`; `PullOutWire.weigh_miss`, `:195-216`; 1 in 3, `WeighGap.gd:18`; $300, `BoutRules.gd:112`; 6 days, `Bouts.gd:48`; championship, `Bouts.gd:376-382`, `Champs.gd:179-184` | TRUE | Every line. No reputation, morale or record entry on a miss: true. |
| 16 | `BoutRules.tank_parts`, `:203`; constants `:41-45` | TRUE | |
| 17 | `BoutRules.gd:237`, `:243` read `bout["eat_kg"]`; nothing writes it | TRUE | A grep of `eat_kg` in `scripts/`: only `BoutRules.gd` (8 lines, all reads or parameters). The scale part of the tank is always 0. |
| 18 | The fight reads no weight (`Duels`, `Exchanges`, `Knockdowns`, `RingDuel`, `WorldBout`); only hit `Exchanges.gd:313` | TRUE | The other hits are comments, `KNEE`, `HURT_WEIGHT` (a hurt multiplier) and Gauss weights. No body weight, limit or class. |
| 19 | Reach and height are read: `Duels.facts`, `:416-425`; `:39`, `:40`; used `:196`, `:212`, `:233` | TRUE | |
| 20 | `AttrGen.body`, `AttrGen.gd:228-230`: height follows the class limit | TRUE | 172 + 1.0 a kg over 60, women 8 less, noise 4. |
| 21 | `TapeRows.opp_weight`, `TapeRows.gd:74-80`; the tape row `TapeRows.gd:64-68` | STALE | True at 31d42481e. The file grew: the weight row is now `:70-74` and `opp_weight` `:80-86`. `:64-68` is now the AGE row. |
| 22 | `ProLadder.division_for`, `:43-49`; `limit` not rewritten | TRUE | Still at those lines. |
| 23 | `ArmBuild.gd:2-12`, `k :29-30`, `BONES :18-24`, `apply :42-57`; 40 -> 1.00, 80 -> 1.24, 0.96 to 1.30; pec and lat at half share `:23` | TRUE | |
| 24 | "Never scaled: `spine_01` to `spine_05`, the neck, the clavicles, the limb bones (`ArmBuild.gd:8-12`)" | HALF TRUE | The file names the limb bones, the shoulder and the neck. It says nothing about the spine. The spine rule is the map's own (sound, but a build claim, not a measured one). |
| 25 | `FighterGoal.gd:5` (make-the-weight dropped), `:40` (-20) | TRUE | |
| 26 | `PushBack.gd:50`; `FighterProfile.gd:18-33` (heard +5, overruled -5 at `:30`, refused -4); `Loyalty.gd:45-62`; `Promises.gd:37` | TRUE | |
| 27 | `InjuryRoll.gd`, `FightWeek.gd:40`: no read of a weight or a diet | TRUE | `HURT_WEIGHT` is a rib multiplier; `SPAR_LATE_CUT_STOP` is a cut eyebrow. |
| 28 | `WorldAge.gd:29` is the only write to an age | TRUE | Grep of `["age"] =`, `+=`: that line only. The club's own boxers do not age. |
| 29 | `Knowledge.gd:13`, `:94-106`, `:174`, `:186`, `:199` | TRUE | Body group; width; `range_of`; `stale`; "Age 30+: body widened". |
| 30 | 3.6: "a layoff or age widens it (`:199`)" | **FALSE on the layoff** | A layoff widens "under_fire" (`Knowledge.gd:194-195`). Only ageing widens "body". |
| 31 | 3.6 and 5: his tolerance read "through `Knowledge.range_of`" | TRUE, with a catch | `range_of` gives a range only to an attribute that sits in a group (`_attr_width`, `:364-368`: no group -> width 0, exact). `BODY_ATTRS` (`:9`) is a list of the six body attributes. A tolerance must be added to it or to a group of its own, or it shows exact. |
| 32 | 1.2, fourteen places: `DarkOverview.gd:438-443`, `FighterTile.gd:57-60`, `HomeRows.gd:196-202` (`:16`), `RosterRow.gd:140-164`, `RosterTable.gd:56`, `CoachCheck.gd:54-63`, `Gauges.gd:47-49`, `:60-66`, `:35`, `AskPanel.gd:79-84`, `FirstWeekStrip.gd:189-192`, `modals/FightWeek.gd:60-62, 127-136`, `modals/WeighIn.gd:14-19`, `BoutActs.gd:259-260`, `WeekBoard.gd:353-357` | all TRUE | Each opened. |
| 33 | `FightPrep.gd:189-192` (CAMP AND WEIGHT) | STALE by two lines | Now `:191-192`. |
| 34 | 3.1: `WeekPlan.gd:268-269` (the burn follows body kg) | TRUE | |
| 35 | 3.2: `bout["stale"]` comes off at the first bell, `BoutNight._energy`, `BoutNight.gd:324` | TRUE | Points off a tank of 100 (`Combos.TANK`, `Combos.gd:24`). |
| 36 | 3.2: the fade reads Stamina: `BoutRules.own_fade :330`, the 60 line `:86-89`; `Combos.round_spend :241` | TRUE | The fade is 0 at Stamina 60 and over, 0.25 a point under, 2 at most. See section 5.6. |
| 37 | 3.3: Discipline at `Data.gd:229` (34) and `:242` (80) | TRUE | Discipline is a "mind" attribute: Knowledge always shows it exact (`Knowledge.gd:98`). |
| 38 | 3.4: `RingDuel.side`, `RingDuel.gd:138-139`; `WorldBout._side :324`; `REACH_PER_CM`, `Duels.gd:39`, `:196` | TRUE | |
| 39 | 3.5: `Region.rankings :200`, `our_rank :237`: the regional ladder is per class | TRUE | |
| 40 | 3.5: `FighterProfile.gd:30`; `target_against`, `Loyalty.gd:51`; Loyal at 70, `Loyalty.gd:22-24`; `decline_pro` -8, `:61`; leaves under 25, `:27`, `leaves :202` | TRUE | |
| 41 | 3.5: trust 0.85 / 0.7, `FighterProfile.gd:39`, `:60-61`; read at `BoutRead.gd:235`; `CornerTrust.gd:11-12` | TRUE | |
| 42 | 3.5: a promise is "kept +5, broken -12 (`Loyalty.gd:47`)"; kinds `Promises.gd:11-13`, `make :37` | TRUE, with a catch | `Loyalty.gd:47` says 5 and -12. `Promises.gd:14-15` says `KEPT := 10`, `BROKEN := -12`, and `Promises.resolve` returns the 10 (`:108`). The game holds two numbers for a kept promise; the build must say which. |
| 43 | 3.9: `RosterRow.gd:141-142` keeps the BJJ fighter's class word | TRUE | |
| 44 | 4: `BoutNight.play_out`, `BoutNight.gd:102` | TRUE | |
| 45 | 5: `WeekData.gd:38`, `WeekPlan.week :302`, `BoutRules.tank_words :266`, `FightWhy`, `OppFile`, `WorldLadder.gd`, `FightWeekPick.weight_way` | all TRUE | All exist where named. |
| 46 | Risk 5: `Knockdowns.gd:5` (four counts in the bout); `pro_rules` only on `s535/dmgfix` | TRUE | Main: `:7-8`, `:62`, no flag. Branch: `Knockdowns.gd:22`, `:63`. |

**Can it be built as written?** Yes. The one false line (row 30) and the two catches (rows 31, 42) are an hour of care each.
Refresh the stale lines (rows 21, 33) before the brief goes to a seat.

## 3. Every number, against John's own line

SAME = John's number and tag. MAP'S OWN = not in John, and the map tags it as its own. What changed is in bold.

| Where in the map | Number | Verdict |
| :--- | :--- | :--- |
| Section 2, all 28 rows | as listed | SAME, row by row. Left out: three of John's lines (below). |
| 2, John's game reading | free 2 %; amateur -4 / -1.5 / -1; pro -1.5 (-3 past 5 %), 0 (-1 past 5 %), -0.5; caps 5 and 8; regain +0.5, +1.9, +7; two misses; x 0.88 and x 1.5; nutritionist | SAME |
| 3.1 pace | 0.7 % a week keeps lean mass; 1 % does not | SAME (SOURCED) |
| 3.1 price of holding | 0.12 of the gain per 1 % held (0.084 a diet week) | MAP'S OWN (ESTIMATE). Sums check: 2.5 % = 3.6 weeks and 70 %; 5 % = 7.1 weeks and 40 %. |
| 3.2 cost table | the six cells | SAME |
| 3.2 same-day regain | +0.5 % (0.3 to 1), +1.9 % (men 2.1, women 1.5) | SAME. The 1.9 comes from boxers with 3 to 12 hours; the map uses it for "three hours or more". |
| 3.2 pro regain as a share | 0.9; 0.81 four in five; 1.25 one in five | MAP'S OWN, tagged honestly (7.2 / 8 and 10 / 8; the 8 is the guidance cap, not those boxers' cut). 0.8 x 0.8125 + 0.2 x 1.25 = 0.9. |
| **3.3 safe lines** | 3 % by water same day; 8 % with over 12 hours | SAME numbers. **CHANGED in use:** John's 8 % is the whole cut; the map and the probe use it as a line for WATER (`water_ok` 8.0). |
| **3.3 "under it he misses about 1 scale in 100 (SOURCED, Reale 2017)"** | 1 in 100 | **TAG CHANGED.** John: 1 miss in 101 elite amateurs is SOURCED; a 1 % base chance "rising with the size of the cut" is his ESTIMATE. Nothing ties the 1 in 101 to a cut under the safe line. |
| 3.3 miss slope | 20 points a 1 %, x 1.5 to x 0.5 by Discipline | MAP'S OWN (ESTIMATE), tagged. The amateur result stands on it. |
| **3.4 size** | 3 wins in 100 per 1 % heavier | SAME as John's section B. Odds x 1.13 at even = 53.05 %. **CHANGED in use, twice:** John's sourced line is per 1 % REGAINED by professionals weighed the day before; and for amateurs his rows say "no link to winning" (elite amateurs, 3 to 12 hours) and "Amateur boxing: NOT FOUND". The map and the probe use the 3 on both scales. |
| 3.4 John's count | x 0.77, x 3.2 | SAME (53 / 69, 6.5 / 2.0) |
| 3.4 walking weights | amateurs 3 to 5 % over (ESTIMATE), pros 7 % in the ring (SOURCED) | SAME |
| 3.6 a miss | walkover; 20 % of the purse; the belt | SAME |
| **3.6 "after two the matchmakers move him up (John's reading)"** | 2 | **SAME number, wider use.** John writes it in his line on professionals. The map and the probe apply it to amateurs, where it moves 63 to 83 % of the cutting runs up a class. |
| **3.6 the coach's slot "halves the diet's training price"** | half | **CHANGED.** John: a nutritionist "halves the camp's stamina penalty" (ESTIMATE). The map's section 2 quotes that correctly; 3.6 then halves a different price (the training gain). |
| 3.6 prices | $500 to $625; $875 to $1,250 | SAME |
| 3.7 growth | 3.6, 2.6, 1.9, 1.4; 1.2, 1.0, 1.1, 0.9; x 1.0 to 1.6; 0.5 to 1 from 21 to 23 | SAME. An 18-year-old woman: 1.1 to 1.8 kg, as the map says. |
| 3.7 tolerance with age | -0.2 a year from 28 | MAP'S OWN (John: NOT FOUND), tagged. |
| 3.5 the refusal | 30 / 50 %, +0.5, -0.6, 5 %, +25, 5 to 90 | MAP'S OWN (DESIGN), tagged. The probe's sum also lowers the no for Confidence under 60 and raises it for Loyalty under 50; the map's words say "over". |

John's lines the map leaves out, each of which bears on a decision here:
- "Combat athletes after regain: back to normal after 3 to 36 hours" (SOURCED, Brechney 2022). It supports the small pro
  cost and it questions any cost at all on the three-hour championship scale.
- "MMA height and reach do not predict wins" (SOURCED, Kirk 2016, 474 fighters) and "Amateur boxing: NOT FOUND" under size.
- IBF: at most 10 lb over on fight morning. A second scale that would stop the 1.25 night for a title bout.

## 4. The probe against the map

### 4.1 Does the model do what section 3 says?

| Section 3 says | The probe does | Verdict |
| :--- | :--- | :--- |
| The first 2 % of water is free | `free` 2.0 on both scales; costs on `water_pct - free` (`_setup`, `:320-324`) | YES |
| The per-scale costs (John's table), the knee at 5 % for a pro | `SCALES` `:29-36`; applied to conditioning, power, defence, fight IQ (`:335`) | YES. Hand speed and chin untouched, as 3.2 says. |
| The same share off the tank | `tank` = the Stamina % as POINTS of a 100 tank (`:354`; `BoutNight.gd:324`) | YES |
| CUT harder = 4 % of body by water after the Lean diet | `_walk`: limit / (1 - 0.025 - 0.04) (`:289`); 69.5 for a 65 | YES |
| Amateur regain = a share of body mass, never more than he took off | `min(water_kg, 0.5 % x limit)` (`:313`) | YES |
| Pro regain = a share of the water he took off, 0.81 four nights in five and 1.25 one in five | `:315`, the night's roll in `_run` `:425` | YES |
| The diet's weeks and the training kept | `weeks`, `keep` (`:352`); `grown += grow x keep` each bout (`:426`) | HALF. The training kept is applied. The WEEKS are printed and cost nothing: a boxer stripping for 7.1 weeks boxes the same twelve slots. |
| A missed amateur scale is a walkover; a pro boxes on and is fined | `:430-431`; no money anywhere in the probe | HALF. Walkover yes. The pro's miss costs nothing but a count toward two. |
| Two misses move him up | `:446-449` (any two in the run, not two in a row) | YES |
| The refusal and the wait | `p_refuse` `:344-350`; refused -> STAY for three bouts, then he goes (`:410-411`, `:419-420`) | HALF. "Wait" always works on bout four. No halving, no insist, no promise, no mood or loyalty price. |
| `cut_tolerance`: his own line, read with error | not in the probe; every boxer's line is the cap, the slope is Discipline's | NO (designed, not probed; the map's risk 4 lists the read, not the line itself) |
| The three-hour championship scale (+1.9 %) | not in `SCALES` | NO, and 4.6 says so |
| A club show keeps the gap rule (re-match 1 in 3, else off and $300) | not in the probe | NO: see 4.2 item 6 |

One check a critic owes the instrument: do the stat changes reach the bout? Yes. `Data.fighter_state` stores no attributes,
so `Attrs.of` builds them from the changed stats at the first read (`Attrs.gd:63-66`), and the lever table shows each
change moving wins.

### 4.2 What the probe makes true by construction

1. **Every choice diets first, so the design's central trade is never run.** `diet_kg = min(over, 2.5 % of body)`, water
   gets the rest (`:310-311`). A boxer 1.4 % over therefore diets all of it away and boxes with 0.0 % water, keeping
   76 to 84 % of his training, although the same section 3 says the first 2 % of water is free. The design's STAY (Hold,
   light water) costs nothing; the probe's STAY pays a fifth of its training, and on the day-before scale it also rings on
   the line where light water would put back 1.1 % of body. So STAY is handicapped in all ten cells and CUT's pro edge is
   overstated. Two pro cells are close enough for it to matter (big chin -0.49 +- 0.15, boxer-puncher -0.60 +- 0.17).
2. **The pro field rings 7.2 % over the line and pays nothing for it** (`opp_ring`, `:317`). At a share of 0.9 that
   regain is an 8 % cut: by the map's own table -13.5 % Stamina, -3 % power, -3 % reading. The field also never misses.
   The fit then eases the field by 10.9 rating points so that the small boxer wins half (`_fit`, `:258`). So "a pro must
   cut" is arithmetic: 3.6 % of ring weight at the fitted 3 wins in 100, against 3 % of Stamina. The bouts size it; they do
   not discover it.
3. **The cutter's CUT is her STAY**: 61.0 kg against 60.8 (`maxf` in `_walk`). Her amateur cell is counted in "5 of 5
   amateur cells where CUT is clearly worse" on +0.28 +- 0.13, which is the price of 0.2 kg more water on the miss slope.
   Her pro cell is the tie. Honest counts: 4 of 4 amateur boxers who had a choice; 9 cells, not 10.
4. **The amateur loss of CUT is fixed before a bout is boxed.** 4 % by water is one point past the 3 % line by the task's
   own choice, so the miss chance is 1 + 20 x (1.5 - Discipline / 100) = 15 to 24 in 100 a bout. Twelve bouts make two
   misses likely, each a rung, and the second moves him up for another rung: about +3 rungs. Measured: +2.0 to +3.2. And
   the cut buys nothing on that scale: he and the opponent both put back 0.5 %, so the size gap goes from -0.5 % to 0.0 %.
   The bar "an amateur cell where CUT is clearly worse than STAY" was written in the same round as the resize that meets it.
5. **The regain divisor of 8 %.** If those 399 professionals cut 6 % on average, the share is 1.2 and nobody boxes "short".
   The "0.4 % dry at the bell" is the divisor, not a finding. It is also only a size term: the costs read the size of the
   cut, never how dry he is (`:320-324`), as 3.2 says.
6. **The amateur cell is a scale the design does not have.** The probe weighs "an hour before" (a club show's timing, +0.5 %)
   and gives a miss a walkover (a championship's price). In 3.6 a club show keeps today's gap rule: matched on walking
   weights, re-matched one time in three, else off and $300, no loss on the record. So the cell that carries the amateur
   result is neither the club show nor the championship.
7. **Frame is deleted.** The opponent's height and reach are erased (`:385`) and every class has the same field (the pool
   is all opponents of that sex, `_pool`, with the rating overwritten, `:384`). In the game height and reach follow the
   class limit, 1 cm a kg (`AttrGen.gd:229`), and the long jab reads reach (`Duels.gd:196`). So the one thing the class
   below really offers, being the tall one with the long arms, and the one thing the class above really costs, are both
   zero. That is why DOWN can never beat CUT here: same ring-weight gap by construction (-3.1 % both), plus a rung, a
   refusal and a harder diet. The map asks "what does the class below offer that walking bigger does not?" The answer is in
   the code the probe switched off.

Smaller: the lever bar passes on any one of three tests over 3 seeds (`:186`), and "refuse" passes on the largest single
rung change of forty cell choices (1.17) with 0.6 points and no cell changed; a pro's miss chance is a flat 2 in 100 because
his safe line and cap are the same number; `_best` prefers the higher win share inside 0.1 of a rung, so big chin / amateur
is booked to UP although STAY's place is lower (by plain lowest place the counts are STAY 5, CUT 4, UP 1, DOWN 0); the fit
pools the two scales, and on the amateur scale 4 % smaller by stats cost nothing (40 % against 40 %).

### 4.3 The five PASS bars, checked against `docs/WEIGHT2_PROBE4.md`

| Bar | Output | Mine |
| :--- | :--- | :--- |
| Each lever moves the result | size 4.6 points (6 cells), diet 2.4 (2), drain 2.0 (4), rank 1.9 (4), miss 1.8 (0), refuse 0.6 (0) | MET by the letter. Refuse and miss change no cell's best. |
| No choice best in more than 6 of 10 | STAY 4, CUT 4, UP 2, DOWN 0 | MET (also met at STAY 5, CUT 4, UP 1). |
| 4 or more cells clear of the noise | 7: I count the seven rows with no tie | MET. Six of the seven largely follow from items 2 and 4 above; the seventh is the boxer who has outgrown her class. |
| CUT in the leading group of at most 6 | 5: the four pro bests and the cutter's pro tie | MET |
| An amateur cell where CUT is clearly worse | 5 listed | MET with 4 (item 3). By construction (item 4). |

The differences in the summary table agree with the cell tables to 0.01 (ten of ten). I could not rerun it (no Godot in this
task), so the standard errors are taken as printed.

### 4.4 Does section 4.6 report the tables honestly?

Mostly yes, and better than most maps. Ties are called ties. It says the amateur result "stands on the miss slope ... my
ESTIMATE", that part of the pro result "is built in", that DOWN is best in no cell and "a dominated option", that the
far end of the regain rule is not exercised, and that the three-hour scale is not run. Every figure I checked in its ten
points matches the output.

What it does not say: item 1 (STAY pays a diet the design makes free); item 7 as the reason DOWN loses (risk 6 mentions the
erased reach only as a double-count worry for moving up); "5 of 5" in the bar row (its own point 2 says four); "UP 100 %
training kept" (the cutter's UP keeps 70 %); and that bars 3 to 5 were set in the round they were first met. "Nothing was
resized after seeing a result" cannot be checked from one commit; I have no reason to doubt it.

## 5. The design problems the checks found

1. **Diet or water for the same kilo is the mechanic, and it is not on the screen as one choice.** The map gives the diet to
   Monday and the water to fight week, two screens weeks apart. The player never sees the three prices of the same
   kilos side by side: by diet, a share of the camp's learning; by water, Stamina and a chance to miss; by moving up, a rung
   and reach.
2. **A pro's body limit has no room.** Safe line 8 %, cap 8 % (3.3; probe `water_ok` 8.0, `cap` 8.0). `cut_tolerance`
   lives "between the safe line and the hard cap": for a pro that is nothing wide, so there is nothing for Knowledge to read
   and no miss slope. John's 8 % is the whole cut with over 12 hours; his knee for cost is 5 %.
3. **None / Light / Hard is two settings.** Light is free and None gains nothing over it. The choice is "inside the free 2 %"
   or "past it, and how far". Past it, three steps hide the number the miss chance turns on.
4. **On the one-hour scale a bigger walk buys no size.** Both men put back 0.5 %. So "walk bigger and cut harder" has no
   upside at a club show by rule, whatever the miss slope. It should not be offered there, or the club show should be what
   it is in the code today: matched on walking weights (`WeighGap`), where walking heavy means heavier opponents.
5. **The 3 in 100 is a professional, day-before number.** Used on amateurs it decides the class moves there (-4 to -5 % up).
   John's amateur rows find no link. A frame term (reach, height: in the code) is the better-grounded amateur size.
6. **The Stamina price has a cliff the player cannot see.** The fade is zero at 60 and over (`BoutRules.gd:86-89`). A
   boxer at Stamina 65 who cuts 4 % on the same day lands at 59.8: no fade to speak of. One at 60 lands at 55.2: 1.2 points
   from round 3. Above 68 no legal amateur cut reaches the line. That is a real "depends on the boxer", and it is free
   depth, but nothing in the map shows it, and in a three-round bout it is one round.
7. **"Wait" is free and "insist" is ruinous, so nobody insists.** Waiting three bouts costs nothing in the probe and the
   map's halving makes it cheaper still. Insist is -20 morale and -8 loyalty. The refusal then only delays.
8. **The removed ways were the player's hands.** "Train it off" and "Eat less" go; "Ask a kilo" stays. A miss becomes a roll
   with no answer on the day.
9. **Growth is the engine and the game cannot run it yet.** The club's boxers have no birthday (row 28). A career to the
   first pro bout is about a year of game time by my estimate (not measured): one growth step a boxer. If growth lands once a year the arc is one event.
10. **The opponent's weight story has no teeth.** "Walks 4 kg over: cuts hard" should mean he fades late. In the probe and
    in the design's code column the opponent pays nothing for his cut, so the row is flavour.

## 6. Options: missing, useless, and what each changes

### Missing

- **How the last kilos come off, as one control** (diet / water / carry them up), with the three prices side by side.
- **A hand on the scale.** When the roll goes wrong on the day: train it off (tiredness), ask a kilo (a favour), or take the
  walkover. Two of the three exist today.
- **A rehydration plan** for the day-before scale: the bought nutrition plan should raise the share he gets back (the
  1.25 night more often), which is what a pro pays a nutritionist for. Today it only halves a diet price.
- **Use the opponent's cut.** A tape row that changes the plan: he cut hard, so box him late.
- **The championship week.** World Boxing weighs every boxing day. A three-day championship where the water has to be held
  three mornings is the amateur game's own weight story and it is in John's sourced rules.
- **Which class has room.** The ladder gap and the field's frame in the class above and below, on the class card.

### Useless or harmful as written

- **Water: None** (Light is free and never worse).
- **Moving down, as sized** (best in no cell; the map says dominated). Keep it only with the frame edge switched on.
- **Cut harder on the one-hour scale** (no size to gain, problem 4).
- **Eat free for an amateur who is staying** (more to lose, nothing to gain on a one-hour scale).
- **Wait** (free) and so **Insist** (never chosen).
- **Hard water for a pro past his tolerance** (there is no band, problem 2).
- **The regain roll** as a hidden dice with no input.

### What each kept option changes

| Option | Changes |
| :--- | :--- |
| Diet: Hold | Nothing. Walking weight sits at natural. |
| Diet: Lean | Walking weight to 2.5 % under natural at 0.7 % a week; training gain x 0.70 while held. Less water needed. |
| Diet: Strip (a move down) | 5 % under at 1 % a week; training gain x 0.40. |
| Diet: Eat free | Up to 2 % over natural: more ring weight on a day-before scale, more to lose everywhere. |
| Water inside 2 % | Nothing on the night. A 1 in 100 scale. |
| Water past 2 % | Same day: -4 % Stamina and tank, -1.5 % power, -1 % reading per 1 %; a miss chance past 3 %; no size. Day before: -1.5 % Stamina, -0.5 % reading per 1 % to 5 %, and about nine tenths of it back as size. |
| Stay | No rung lost. |
| Walk bigger | Day before: closes the size gap to the field (3.6 % of ring weight in the probe). Same day: only costs. |
| Move up | A rung; no cut; 4 to 5 % lighter than the field (same day), 10 to 11 % (day before); in the code, shorter than the field. |
| Move down | A rung; the hardest diet; his frame over that field (not probed). |
| His no: wait / insist / promise | Three bouts' delay / -20 morale and -8 loyalty / a promise kept or broken. |

## 7. To reach 10/10 (most important first)

1. **Probe the real choice: the same kilos by diet, by water, or carried up.** In `_setup` take water first up to the free
   2 %, then make the split a policy: for a boxer 3, 4, 5 and 6 % over his line run DIET (Lean covers what it can), WATER
   (Hold, the rest by water), MIX and UP. Bars: inside ONE scale the best policy changes with how far over he is AND with
   the boxer (Stamina over and under 60, Discipline 34 and 80). If one policy wins every cell, the mechanic is a rule.
2. **Switch frame back on and give each class its own field.** Stop erasing height and reach; draw the opponent's from his
   class (`AttrGen.body`); use each division's own region sheet. Then DOWN = taller with longer arms, lighter in the ring;
   UP = shorter, no cut. Bar: DOWN best or tied for a boxer who works off the jab, UP for one with a chin and no reach.
3. **Give the field its own cut.** A pro opponent who rings 7.2 % over has cut 8 %: charge him John's table and let his
   Stamina fall late. Put his cut on the tape as a range (Knowledge) and let the plan read it. Refit the field after.
4. **Run the scales the design has.** Three cells per boxer: club show (one hour, gap rule, no walkover), championship
   (three hours, +1.9 %, a walkover, weighed each boxing day), pro. Drop the hybrid.
5. **Make room in a pro's body.** All lines by water: safe 5 % (John's knee), cap 8 %, tolerance between, miss slope
   between. Keep "8 % in all" as the diet-plus-water guidance shown on the card.
6. **Put the hands back on the scale.** A miss roll opens the weigh-in modal with: train it off (0.3 kg, +8 tiredness, as
   today), ask a kilo (a favour), take the walkover. The roll decides how far over he is, not the outcome.
7. **One control for the last kilos** on the BODY card and in Fight prep (section 8), replacing the three water pills and
   the three diet pills when a bout is booked. Monday keeps only the diet chip.
8. **A clock on "wait".** Each bout he waits past his ask or yours, his natural weight has moved and his no falls by half,
   but the scale's miss chance for the old class is shown rising: waiting has a visible price.
9. **The nutrition plan buys the regain.** On a day-before scale it lifts the share from 0.9 to 1.05 on average (ESTIMATE);
   on a same-day scale it halves the Stamina price, which is John's own line.
10. **Show the 60 line.** In the water control: "Stamina 65 -> 59.8: under the fade line from round 3". The cliff becomes a
    reason to train Stamina before a cut.
11. **A birthday and monthly growth** for the club's boxers, shown as natural weight with an arrow, so the arc moves inside
    one season.
12. **Size on the amateur scale from frame, not from the professional 3 in 100.** Keep the mass term for the day-before
    scale, where it was counted.
13. **Fix the three code catches** (rows 30, 31, 42) and the stale lines in the brief; write every screen line for "your boxer".
14. **Rerun with the bars set first**, 40 seeds, and count the boxer who has no choice as no cell.

## 8. My 10/10 as a 1920 x 1080 page: the weight card

A page described, not drawn (this task owns one file). The fighter page's BODY card, opened full, dark like the Overview.

- **Header, 80 px:** the boxer's name and class (the only name on the page), next bout and days to it, which scale it is
  ("Club show: weighed an hour before" / "Championship: weighed each morning" / "Pro: weighed the day before").
- **Left third, the body:** his figure at today's girth. Beside it one vertical ruler in kg with four marks: natural (with
  a small arrow and "+1.4 kg this year"), walking today, the class line, the class below and above as faint lines. Under it
  the tolerance as a band with soft edges ("makes 3 to 4 % by water, your read") that narrows after each hard cut.
- **Middle third, THE LAST 2.6 KG:** one horizontal bar the length of what he must lose, cut into three draggable blocks
  (the figures here show the wording, they are not sums). DIET (green): "3.6 weeks, learns 30 % less until the bout". WATER
  (blue; the first 2 % hatched "free"): "Stamina 65 -> 60 at the bell, tank -8, scale: misses 15 to 24 in 100". CARRY (grey): "box at 65: a rung down, 4 % lighter, 5 cm shorter than
  that field". Each block shows its price as the player drags; a thin line marks the fade at Stamina 60. Under the bar: the
  nutrition plan button with its price and what it changes for THIS scale.
- **Right third, THE CLASS:** two small ladders side by side, this class and the one the player is pointing at, with where
  he would stand, and three tape rows against each field: ring weight, height, reach. Under it his answer in a speech
  card with its two reasons ("No. Ranked third here. Not starving for it."), and the three ways to push with their prices:
  wait (what the next bout does to his answer and to the scale), a promise, insist.
- **Bottom strip, THE OPPONENT:** his walking weight and cut as a range, and one line the plan can use: "cuts about 6 %:
  expect him to slow from round 4".
- **Nothing else.** No calories, no food, no slider per day. Three blocks, one class, his answer.

## 9. Code files I opened

`scripts/state/Data.gd`, `SaveGame.gd`, `Sim.gd`, `CampForecast.gd`, `Bouts.gd`, `AskFlow.gd`, `FightWeekPlan.gd`,
`PullOutWire.gd`, `Champs.gd`, `BoutNight.gd`, `RingDuel.gd`, `Region.gd`, `ProLadder.gd`, `WeekData.gd`;
`scripts/rules/FirstHour.gd`, `ClubStart.gd`, `WeekPlan.gd`, `HeadCoach.gd`, `WeighGap.gd`, `FightWeekPick.gd`,
`FightWeek.gd`, `BoutRules.gd`, `Exchanges.gd`, `Duels.gd`, `AttrGen.gd`, `Attrs.gd`, `TapeRows.gd`, `FighterGoal.gd`,
`PushBack.gd`, `FighterProfile.gd`, `Loyalty.gd`, `Promises.gd`, `Knowledge.gd`, `Combos.gd`, `BoutRead.gd`,
`CornerTrust.gd`, `Gauges.gd`, `RosterRow.gd`, `CoachCheck.gd`, `Knockdowns.gd`, `InjuryRoll.gd` (grep);
`scripts/ui/WeekBoard.gd`, `WeekCamp.gd`, `BoutActs.gd`, `DarkOverview.gd`, `FighterTile.gd`, `HomeRows.gd`,
`RosterTable.gd`, `FightPrep.gd`, `AskPanel.gd`, `FirstWeekStrip.gd`, `modals/FightWeek.gd`, `modals/WeighIn.gd`;
`scripts/world/WorldAge.gd`, `WorldBout.gd`; `scripts/fight3d/v2/ArmBuild.gd`; `tools/weight2_probe.gd`.
On branch `s535/dmgfix` by `git grep` only: `scripts/state/Data.gd`, `scripts/rules/Knockdowns.gd`.
Existence only: `scripts/rules/FightWhy.gd`, `OppFile.gd`, `scripts/ui/WorldLadder.gd`.

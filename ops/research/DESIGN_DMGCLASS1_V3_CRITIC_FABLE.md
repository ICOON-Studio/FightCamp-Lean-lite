# DMGCLASS1 v3 - code-checked critic (Fable console, S534)

Kind: research. No game code changed, Godot not run. A fresh critic: I read the brief
(`ops/research/DESIGN_DMGCLASS1_V3_CRITIC_KALLI.md`: the critic pack, then the map) and opened every file below. I did not
read the v2 map or its critic. Code read at commit 1d61aa3fd on 2026-11-21 (none of the files the map cites changed since its
own commit 7e63b872a). `scripts/state/LiveRound.gd` carries another session's uncommitted edit (2 lines); its line numbers
are that working copy's, as in the map.

## 0. Live game findings first (none is a crash; none was fixed here)

- **L1. Pro bouts are stopped by the amateur count rule.** `Knockdowns.round_counts` ends a bout on three counts in a round or
  four in the bout (`scripts/rules/Knockdowns.gd:7-8, 61-62`; its own header at `:5` says "Amateur rule"). The file has no
  pro flag, and neither caller passes one (`BoutNight._counts`, `BoutNight.gd:254`; `WorldBout`, `WorldBout.gd:157, 226`).
  So a 10-round pro bout, the player's and the world's, ends on the fourth count. Professional rules have no standing count
  and, under the unified rules, no fixed knockdown limit. Size unknown: no probe prints how many pro stoppages come from the
  limit and how many from the referee. It matters for this mechanic more than for today's game (problem 1).
- **L2. A pro boxer's own limit and the table's limit disagree.** `ProLadder.division_for` (`ProLadder.gd:43-49`) puts a
  65 kg and a 70 kg woman and a 70 kg man on the welterweight table (row limit 66.7 kg) and a 55 kg man on the featherweight
  table (57.0 kg). Nothing rewrites `limit` at turning pro (every write to it is in the claim table). So your pro
  "welterweight" can make 70 kg on a table whose own row says 66.7. Harmless today (world boxers carry no weight); it becomes a
  wrong number the day anything reads a cell's kilos, which this map does (problem 2).
- **L3. The towel still counts as a stoppage in five places** (the map lists it, I confirm it is live):
  `BoutFinish.gd:103, 105, 110, 132, 178, 180`. Pulling your boxer out costs 2 members and 4 reputation, the "stopped"
  loyalty -3 on top of the towel's own loyalty move, the stopped lesson and the stopped ladder flag. The towel is the protect
  lever this mechanic leans on; while it is priced like the thing it prevents, "protect early" is a worse deal than it reads.

## 1. Scores

| | Score | Why |
| :--- | :--- | :--- |
| DEPTH | **6 / 10** | Honest and well connected, but it adds no new choice and the class itself is not one. |
| GENERAL DESIGN | **7 / 10** | 68 of 76 checked claims true, one knob, real evidence ranked by trust, a probe with a control and a mutant. Three holes must close before the build. |
| PLAY | **5 / 10** | Nothing new to do in a week. The numbers the player would read are close to the same in every amateur class. One good moment: the turn-pro call. |

**Can it be built as written?** Section 1 (what the game does today) can be trusted: every line I opened is where the map
says it is. Sections 3.1 and 3.4 can be built. Three things cannot be built as written: the "one cell per bout" rule of 3.3
(two limits for one table), the `12 x ln(count_mult)` shift of 3.5 (measurably wrong against the project's own table), and
the camp line of 4.2 item 3 (it multiplies a number that does not exist). The probe of section 5 would read the control cell
wrong if it took its women's lightweight pool from `Data.DIVISION_RIVALS`.

### DEPTH 6: the reasons

- What is good. The map follows its own evidence where the evidence is unwelcome: weight is the smallest step, sex is mostly
  round length, the ruleset is the big one. It then puts the number where a button already is: sign or pass, turn pro or stay,
  the towel line, the camp, the perk. Four existing levers answer a "protect early" read: a softer name on the ask card, the
  careful towel line, neck work (it trains durability, `Attrs.gd:273`), and Stay amateur. Iron chin and Finisher gain a worth
  that differs by cell. That is real interaction with the rest of the game.
- What holds it at 6.
  1. **The class is not a choice.** A class comes bundled with a person: one walk-in, five prospects, each in one class. The
     player never picks a class; the player picks a boxer and learns the class's number. The one place a class could be chosen
     (the turn-pro call, section 4.3) is deferred to another map. Without it this is a calibration plus reads, not a decision.
  2. **The number barely differs where the player chooses.** By the map's own section 3.2 the women's amateur cells are all
     1.00 with no slope: every woman prospect would show the same "N in 100". Men's amateur is one number for four classes
     plus a slope the evidence does not support yet. The signing row's first fact is the same on every card of a sex.
  3. **The big step hits everyone alike.** Turning pro multiplies the risk three to six times for every boxer. It makes Stay
     amateur dearer or cheaper for a thin chin, which is a real trade (three declines, loyalty -8 each), but it is one
     trade, once per boxer.
  4. **Only the downside is priced.** A thin chin is warned. A puncher is told "a puncher here" and gets nothing for it that
     differs by class. With one side of the trade missing there is a risk of one right answer: sign chins, train neck, pick
     Iron chin, in every cell where the number is high.

### GENERAL DESIGN 7: the reasons

- One knob, read in two lines, a missing key is 1.0, the control cell is the normal start: this is the smallest change that
  can do the job, and the old tests do not move.
- The words follow the game ("your boxer", "here", "in 100"), and the map refuses things (the week board row, damage scaling).
- Minus: the three unbuildable items above; the judges are missing from "what reaches everything else" (a count takes a point
  off on every card, `Judges.gd:134-136`), so the knob moves decisions as well as stoppages and no bound watches it; the pro
  cells are fitted on top of an amateur stopping rule (L1); two of the seven numbers rest on sources nobody has opened, and
  the map says so.

### PLAY 5: the reasons

- Anticipation: the turn-pro call with "as a pro here about M in 100 end early" next to Stay amateur is a moment the player
  will stop on. The towel card arriving more often in a hard cell is felt.
- Week to week nothing changes: no new action, no reward that the class brings, and five of the new lines are averages of a
  field ("bouts here end early about N in 100") that the player cannot act on after the first reading.
- The reward side is empty: nothing in the map makes a stoppage WIN feel different by class.

## 2. Every CODE claim, checked

76 claims checked: **68 TRUE, 5 PARTLY, 2 FALSE, 1 NOT FOUND**. Lines are today's files.

| Section | The map says | Verdict | Where, or what the code really does |
| :--- | :--- | :--- | :--- |
| 1.1 | Round head damage +8 / +18 / +32, winner +2 | **TRUE** | `Knockdowns.round_counts`, `scripts/rules/Knockdowns.gd:30-32`; constants `:13-14` |
| 1.1 | A count: 0.05 x margin x exp((power - chin) / 12) x (1 + damage / 60), cap 0.85, three rolls x0.6 | **TRUE** | `Knockdowns.gd:34-47` (cap `:35`, loop `:40-47`) |
| 1.1 | The referee only after a count; x stop_mult; cap 0.9; KO needs damage 60 and (1 - heart / 100) x 0.7 | **TRUE** | `Knockdowns.gd:53-59`. `stop_mult` is read from the COUNTED side (`:56`) |
| 1.1 | Three counts in a round or four in the bout = RSC | **TRUE** | `Knockdowns.gd:61-62`. No pro flag anywhere in the file: see live finding L1 |
| 1.1 | Puncher's chance 0.05 x 0.4 x ..., cap 0.5, same referee roll | **TRUE** | `Knockdowns.puncher_chance`, `:121-138` (cap `:128`, referee `:132-133`) |
| 1.1 | `BoutNight.count_sides` = `RingDuel.side` of each + the other side's Finisher, nothing else | **TRUE** | `scripts/state/BoutNight.gd:236-240`; `RingDuel.side` `RingDuel.gd:138-139`; `PerkFight.FINISHER` `:30`, `stop_mult` `:64-65`. Three call sites only: `:220`, `:248` and the definition |
| 1.1 | `BoutNight._counts`: Slugger `:249`, round_counts `:254`, Iron chin `:256-261`, liver `:266`, puncher `:270` | **TRUE** | `BoutNight.gd:245-290`, every line as cited |
| 1.1 | Live damage adders in `LiveRound.exchange` (counter sense +15, clinch, set-up +30, read +0, guard) | **TRUE** | Working copy `LiveRound.gd:312, 331-334, 340, 345, 355-359`. The function itself starts at `:156`; the cited range is the adders. `PerkFight.COUNTER_DAMAGE` 15 (`:24`), `CornerJobs.SETUP_DAMAGE` 30 (`:24`), `TheRead.DAMAGE` 0.0 (`TheRead.gd:44`). `Adaptation.gd:87-89` also true |
| 1.1 | The hurt roll: margin past 30 and clamp(0.3 + (power - chin) / 100, 0.1, 0.6); ours x talk x 1.6, clamp 0.8 | **TRUE** | `RingDuel.gd:383-386`; `Exchanges.HURT_AT` 30 at `Exchanges.gd:54` |
| 1.1 | `WorldBout.fast` builds sides from power, chin, heart only; calls round_counts and puncher_chance every round | **TRUE** | `scripts/world/WorldBout.gd:206-237`; `_side` `:324-325`; sides built at `:127` (in `fight`, `:116`), `:186` (`cached`), `:211` (`fast`); calls at `:226`, `:232` (and `:157`, `:163` in `fight`) |
| 1.1 | `WorldBout._hurt_edge` 0.18 + last / 90 + (power - chin) / 60, clamp 0 to 0.5 | **TRUE** | `WorldBout.gd:92-97`, constants `:27-30`. It is each side's chance times a hurt cost, then the difference |
| 1.1 | Three callers of `WorldBout.fast` | **TRUE** | `WorldSim.gd:141`, `Region.gd:170` (3 rounds), `Matchmaking.gd:206` (`ROUNDS := 6`, `:24`). A search of `scripts` finds no fourth |
| 1.1 | `WorldSim.rounds_for` 10 / 8 / 6, 3 for an `a_` id that no table has, never 4 | **TRUE** | `WorldSim.gd:161-165`; the eight ids in `assets/data/world/divisions.json` start `w_` or `m_` |
| 1.1 | A world stoppage: `ko` +1, `record_stoppage_loss`; `_roll_stoppage` has no caller | **TRUE** | `WorldSim.gd:180-189`, `WorldAge.gd:119-122`. `_roll_stoppage` (`:173-177`): a search of `scripts` and `tools` finds only its definition |
| 1.1 | `ClassDamage`, `punch_mult`, `class_stop` nowhere; `count_mult` only in `tests/deal_contract_test.gd` | **TRUE** | Searched `scripts`, `tools`, `tests`: one file, that one |
| 1.2 | `AttrGen.generate(rng, archetype)` takes no sex or division | **TRUE** | `scripts/rules/AttrGen.gd:103` |
| 1.2 | `WorldGen._roll_rating` 64-80 ranked, 55-68 unranked, by age only | **TRUE** | `scripts/world/WorldGen.gd:209-216` |
| 1.2 | `_make_boxer`: KO share clamp(0.3 + explosiveness / 30, 0.05, 0.75); sex and weight reach only height and reach | **TRUE** | `WorldGen.gd:140-185`, `:150`, `:152` |
| 1.2 | 35 boxers a division; entry `WorldGen.generate(seed)` | **TRUE** | `WorldGen.gd:20-21, 27, 87` |
| 1.2 | Amateur pools hand-written; men rated 53-62 (one 69 / 70), women 58-65 (one 70-72.5) | **TRUE** | `scripts/state/Data.gd:171-211`, read row by row |
| 1.3 | Nine amateur divisions: women 57 / 60 / 65 / 70 / 75, men 55 / 60 / 70 / 75 | **TRUE** | `Data.DIVISIONS`, `Data.gd:136-155` |
| 1.3 | Eight pro tables, limits 57.0 / 61.2 / 66.7 / 72.6; `pro_rounds` 10 (12 men's welter and middle), read by no bout code | **TRUE** | `assets/data/world/divisions.json`; `pro_rounds` appears in no script |
| 1.3 | A signed boxer gets `div`, `sex`, `limit` once | **TRUE** | `Data.fighter_state`, `Data.gd:254-270`, the write at `:260-261`; `pro: false` at `:264` |
| 1.3 | `ProLadder.division_for`: 57.5 feather, 62.0 light, 70.0 welter, else middle | **TRUE** | `scripts/state/ProLadder.gd:43-49`. Consequence the map does not draw: see live finding L2 and problem 2 |
| 1.3 | Player pro bouts 4 / 6 / 8 / 10; six exchanges a round for everyone | **TRUE** | `ProLadder.gd:33-36`; `Exchanges.gd:10` |
| 1.3 | No code moves a signed boxer to another class; the ONLY writes to `limit` are `FirstHour.gd:125`, `SaveGame.gd:85`, `WeekData.gd:38` | **PARTLY** | The conclusion is true. The list is short by three: `CardAsk.walkin` (`scripts/rules/CardAsk.gd:158-163`) builds a signable boxer with OUR boxer's limit, sex and div; `Data.fighter_state` itself (`:261`); the first walk-in's literal (`Data.gd:60`). None changes a class |
| 1.4 | `Towel.risk` plays the next round 200 times; sides passed in by `BoutNight._shout`; `TowelWire.state` adds Slugger | **TRUE** | `scripts/rules/Towel.gd:23-64`; `TowelWire.TRIALS` `:20`; `BoutNight.gd:220`; `TowelWire.gd:37` |
| 1.4 | Lines 0.12 / 0.20 / 0.33, set on `FightPrep.towel_row` | **TRUE** | `Towel.gd:11`; `scripts/ui/FightPrep.gd:78-99` |
| 1.4 | Four reasons for the card; only the coach's own pull is tied to the line alone | **TRUE** | `Towel.reasons` `:89-101`, `coach_pulls` `:110-112`; head = 100 - damage x 2.2 at `TowelWire.gd:22, 54` |
| 1.4 | Answers read Pull out / Box safe / One more round | **TRUE** | `scripts/ui/TowelStrip.gd:8-10` |
| 1.4 | A pull: 14 days, morale -4, loyalty +2 or -6, no injury roll | **TRUE** | `Towel.gd:13-14, 117-126`; `TowelWire.pull` `:97-109`; `Injuries.gd:181-182` |
| 1.4 | F13 fixed: no chin wear on a towel | **TRUE** | `scripts/state/BoutFinish.gd:101-102`; `tests/towel_wire_test.gd:74`; `Attrs.STOP_DROP` `:42`, `wear_stoppage` `:127-128` |
| 1.4 | An RTD loss is still a stopped loss in five other places of `BoutFinish.run` | **TRUE** | `:103`, `:105` (members 2, reputation 4: `BoutRules.gd:122-123`), `:110`, `:132`, `:178` (`Loyalty.gd:60` "stopped" -3), `:180`. The effect of `:110` inside `ProLadder.result` was not opened. Still live: finding L3 |
| 1.4 | A referee stoppage: 30 / 90 / 365 days, cap -2, no stand-down, +8 pro weeks, rating -0.8 | **TRUE** | `InjuryRoll.gd:12-16, 42-56`; `StandDown.gd:27-29`; `Matchmaking.gd:30-33, 48, 280-282` |
| 1.4 | A distance bout: 5 / 10 / 21 days by head = 100 - damage x 0.8; injury roll 0.06 x rounds / 3 x (0.4 + 1.2 x worst) x flexibility, cap 0.4 | **TRUE** | `StandDown.gd:7-10, 27-32`; `InjuryRoll.gd:7, 29-39` |
| 1.5 | Pro row "Stopped N of the M beaten", red 40%, amber 20% | **TRUE** | `scripts/ui/ProFights.gd:173-178` |
| 1.5 | Pro row "Stopped: N% chance; then out W weeks, and damage", red 15%, amber 7% | **TRUE** | `ProFights.gd:221-223` |
| 1.5 | The coach's read from 7% up | **TRUE** | `ProFights.gd:182-183`; `CoachRead.pro_read`, `scripts/rules/CoachRead.gd:166-181` (the 7% at `:180`) |
| 1.5 | `Matchmaking.stop_chance` = (1 - win chance) x max(0.1, ko / w), 0.25 with no wins; three call sites; decides no bout | **TRUE** | `Matchmaking.gd:272-275`; calls at `ProLadder.gd:228`, `ProFights.gd:183`, `:221` |
| 1.5 | Ask card and late-ask card print `StopWord.word(gap)` | **TRUE** | `AskFlow.gd:105-120` (call `:117`), `AskPanel.gd:112-114`; `LateAskWire.gd:119-126` (call `:125`), `LateAskCard.gd:28` |
| 1.5 | `StopWord.word`: under 0 unlikely, under 8 possible, else a real risk; pure, pinned by its test | **TRUE** | `scripts/rules/StopWord.gd:8-9, 15-16, 20-25`; the pin is `tests/stop_word_test.gd:105-106` (one line off) |
| 1.5 | The towel strip sentence | **TRUE** | `Towel.words`, `Towel.gd:139-143` |
| 1.5 | Perk road: Iron chin durability 70, Finisher explosiveness 70, no division word | **TRUE** | `FighterPage._tab` (`scripts/ui/areas/FighterPage.gd:97`, the rows at `:108-112`); `PerkRoad.gd:10, 16` |
| 1.5 | Signing card: `RecruitPanel.build`, used by the interview and the trial; class is one word on the trial | **TRUE** | `scripts/ui/RecruitPanel.gd:35-54`; `modals/Interview.gd:64`; `modals/Trial.gd:24, 29`. Useful extra: `build` runs `Data.fighter_state` first (`:36`), so `div`, `sex` and `limit` are already there for the new row |
| 1.5 | Prospect card line | **TRUE** | `Fighters._scouting`, `scripts/ui/areas/Fighters.gd:181`, the line at `:212`; `Data.SCOUT_SPREAD` 5 (`Data.gd:216`) |
| 1.5 | The turn-pro call shows nothing about stoppages | **TRUE** | `modals/ProOffer.gd:25-60`; the word "stop" is nowhere in the file |
| 1.5 | STOPWORD1: 960 bouts; level block 5.3 and 3.7 in 100 (n 300); 132 RSC, 15 KO; the per-boxer rows | **TRUE** | `docs/STOPWORD1_RESULT.md:3, 32-52, 82, 102` |
| 1.6 | F4 Second wind 10, round 3 | **TRUE** | `PerkFight.gd:14-15` |
| 1.6 | F5 turnaround 6 / 8 / 12, +8 | **TRUE** | `Matchmaking.gd:30-33` |
| 1.6 | F10 `STOP_CHIN 2.0` x stoppage losses, once per loss | **TRUE** | `AttrGen.gd:67, 172-181` |
| 1.6 | Walk-ins `FirstHour.walkin` `:103`, `refuse` `:114`; `Roster.trial_read` `:109`; `Data.PROSPECTS` `:221-243` | **TRUE** | All four as cited |
| 1.6 | `AskFlow.teach_after` floors the lesson at 0 | **TRUE** | `AskFlow.gd:180` |
| 1.6 | `tools/stop_word_probe.gd` is 479 lines and plays `Bouts.fight_step` to the end | **TRUE** | 479 lines; `_fight` at `:153`, the steps at `:167-174` |
| 2 | John's counts: 4.4 to 11.4 in 100 over 1,036 Worlds bouts; 4 of 278 at the Olympics; 29 and 47 pro; 0.83 per minute; 17.3 and 21.8 | **TRUE** | `ops/research/J_KDRATES1_JOHN.md:26-30, 39, 42, 53` (239 + 203 + 287 + 307 = 1,036) |
| 2 | Women's amateur BY WEIGHT comes from "the same championships" | **FALSE** | The three rows total 1,244 bouts (479 + 569 + 196), not 1,036. They are the 2018 to 2025 Worlds (`:57-60`): the four above PLUS the IBA Worlds 2025 (208 bouts, 45 stopped, 21.6 in 100), which the same file marks "(outlier)" at `:31`. The "no slope" reading still holds; the level (10.6 / 9.5 / 11.2) is lifted by the outlier year and should not be used as a target |
| 2 | The Dola study holds three bands, no division rows, men's pro 55 / 68, women's 24 / 30, "Verify the sources" | **TRUE** | `ops/research/RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md:6, 136-139, 163, 170-177` |
| 2 | The topic page says boxing about 47% KO/TKO | **TRUE** | `ops/research/topics/knockdowns_stoppage.md:12` |
| 2 | The count ratio 2 to 4 is "my assumption, not data"; the code is tuned to it | **TRUE** | `J_KDRATES1_JOHN.md:73`; `Knockdowns.gd:2-4` |
| 3.1 | `count_mult` can be read at `Knockdowns.gd:34` and `:128` before the caps; a missing key = 1.0 leaves `tests/knockdowns_test.gd` (band at `:49`) and `tests/stop_mult_test.gd` alone | **TRUE** | Both lines are the count chance; the caps follow at `:35` and inside `:128`; both tests exist and pass raw sides |
| 3.1 | Stoppages are gated behind counts (`:53`), so the stopped share follows the count chance "almost in proportion" | **PARTLY** | The gate is true. Proportion holds only while counts are rare: three counts in a round (`:40-47, :62`) grows with the cube of the chance, four in the bout (`:62`) with its fourth power over the rounds, and damage (`1 + damage / 60`) compounds across 6 to 10 rounds. In a pro cell fitted to 47 in 100 the count limits, not the referee, may do most of the stopping. The fit rule (three reruns) copes; the sentence should not be relied on |
| 3.3 | A signed boxer carries `sex` "f" / "m", `div`, `limit`, `pro`; the bout says `bout.pro` | **TRUE** | `Data.gd:260-264`; `BoutFinish.gd:61` |
| 3.3 | A world boxer carries `sex` "women" / "men", `div` "w_lw", no `limit` | **TRUE** | `WorldGen.gd:155-185`; the limit is read from the row (`_limit_of`, `:196-200`) and not stored |
| 3.3 | An amateur rival carries `div`, no sex, no limit (`Data.DIVISION_RIVALS`) | **PARTLY** | True for the eight classes in that table. The NINTH, women's lightweight (the normal start's class and the control cell), is three other constants: `Data.OPPONENTS`, `MISMATCH`, `RIVALS` (`Data.gd:71-100`), whose rows carry NO `div`. `Career.gd:113-114` merges `div: "wlw"` when a career is made. Inside a career every rival resolves; a probe or test that reads the Data constants directly gets no cell for the control class |
| 3.3 | `ProLadder.bout_opp` copies OUR amateur id into `div`, sets `pro: true`, no sex or limit; the ladder entry has none of the three | **TRUE** | `ProLadder.gd:253-261`; `Matchmaking.join`, `Matchmaking.gd:67-70` |
| 3.3 | "A bout has one cell, and both sides get it" | **PARTLY** | The code facts are true; the rule as written does not give one cell. The same pro table has two limits: the signed boxer's amateur `limit` (55 / 60 / 65 / 70 / 75) and the table row's `max_kg` (57.0 / 61.2 / 66.7 / 72.6). The watched bout takes ours (`count_sides(f, opp)`), the simulated bout of the SAME boxer takes the world opponent's (`Matchmaking.fight` through `cell_of_pair`). With any slope the two paths disagree: problem 2 |
| 3.3 | `WorldBout.cached` stores sides under a key of id, name, shape, age, rounds; `_cache` at `:33` | **TRUE** | `WorldBout.gd:177-190, 193-202, 33` |
| 3.4 | What reaches everything else for free: counts, the towel, the plan test, the fix lab, world records | **PARTLY** | All five true (`PlanTest.gd:93`, `FixLab.gd:201` play `BoutNight.play_out`, `BoutNight.gd:102`). The list misses two: the JUDGES take a point off for every count (`Judges.score_round`, `scripts/rules/Judges.gd:134-136`, fed by `JudgeNight.gd:40-42`), so the number also moves decisions; and a stoppage win is worth a fan on the pro table (`Matchmaking.apply_result`, `Matchmaking.gd:241`) |
| 3.5 | The count chance grows by e every 12 points of power over chin (`Knockdowns.gd:11`) | **TRUE** | `POWER_CHIN_SCALE := 12.0` |
| 3.5 | So a factor is worth `12 x ln(count_mult)` points on the ask card's gap | **FALSE** | Not a code line, but it is offered as following from one, and it does not. The card's gap is a RATING gap (`StopWord.gd:3-4`), which also moves who wins the rounds and by how much. The project's own table (`docs/STOPWORD1_RESULT.md:97-99`) has 5.3 in 100 at gap -0.7, 9.2 at +3.2, 41.7 at +11.3: the chance grows by e every 5 to 7 rating points, not 12. The formula over-shifts about twofold: problem 3 |
| 4.1 row 8 | `BoutFinish.run` already pushes lines to the front of `why`; `FightWhy._count_line` is silent on a stopped bout | **TRUE** | `BoutFinish.gd:75-82`; `scripts/rules/FightWhy.gd:259-263` |
| 4.1 row 9 | The week board has no chin row | **TRUE** | No "chin" or "durability" in `scripts/ui/WeekBoard.gd` (the only hits are inside the word "teaching") |
| 4.2 item 3 | `FightPrep._camp_card` at `FightPrep.gd:190` | **TRUE** | As cited; body not opened by the map or by me |
| 4.2 item 3 | "X = the ask card's chance for this gap in this cell times 0.28" | **NOT FOUND** | The 0.28 is right (1 - exp(-4 / 12) = 0.283). "The ask card's chance" does not exist: the card holds a word, no function returns a chance for a gap, and the camp card is a PRO screen (amateur bouts have no camp) while the ask card is amateur. The only stop number a pro bout has is `Matchmaking.stop_chance`. This line needs its own table from the probe |
| 4.3 | A boxer has a walking `weight` and a `limit`; prospects 58.3 against 57, 65.9 against 65 | **TRUE** | `Data.gd:222, 226` |
| 5 | `tools/dmg_class_probe.gd`, `tests/class_damage_test.gd`, `scripts/rules/ClassDamage.gd` do not exist | **TRUE** | None of the three is on disk |
| 5 | Liver share bound from `docs/LIVERPROBE1_RESULT.md` | **TRUE** | Design bar 10 to 20 in 100, best cell 0.160 (`:4, :37`) |

Not checked (marked CRITIC-CHECKED or "not opened" by the map, and not needed for a verdict): `Exchanges.situation` and
`next_mode`, `CounterCut`, the body of `BoutRules.why`, the effect of the stopped flag inside `ProLadder.result`, the
sizes of the amateur pools ("4 to 11 names"), the Dola men's and women's amateur rows.

## 3. The design problems the code check found

1. **The pro cells would be fitted on an amateur stopping rule (L1).** To reach 47 in 100 the men's pro anchor raises the count
   chance; every extra count walks toward "four in the bout", a rule pro boxing does not have. The fit would then be right on
   the total and wrong on how bouts end (too many referee stops on count totals, too few clean knockouts), and the KO share,
   which the map leaves as an output, would be pushed down by a rule and not by the dial.
2. **One table, two limits.** With the slope of 3.2, a 70 kg woman's watched pro bout would use (70 - 62) / 13 = 0.62 of the
   slope and the same boxer's simulated bout, or any world bout on her table, (66.7 - 62) / 13 = 0.36. The map's own test
   ("fails on two sides that resolve to different cells") would fail on the first pro bout, and "watched path against world
   path within 5 points" would be measuring this, not the live adders.
3. **The ask card's shift is about twice too big.** Take the men's amateur estimate 1.4. The map shifts the gap by
   12 x ln 1.4 = 4.0 points. The measured level block (gap -0.7) stops your boxer 5.3 in 100; times 1.4 is 7.4, still under
   the 8 line: the true word is "unlikely". The shifted gap is +3.3: the card would say "possible". At gap +5.6 the measured
   6.7 becomes 9.4 ("possible"); the shifted gap 9.6 says "a real risk". The card would cry wolf in every cell above 1.0.
4. **The camp line has no number to stand on** (claim table, 4.2 item 3).
5. **The judges move too.** More counts in a cell means more two-point rounds on the cards. In a men's pro cell at two or
   three times today's count chance, a boxer who wins rounds and takes one count loses decisions he wins today. Nobody decided
   that; it falls out of the knob.
6. **The towel becomes automatic where the number is high.** The card comes on any count in the round just gone
   (`Towel.reasons`, `Towel.gd:91-92`), and on a skipped bout the coach pulls at the line by himself (`TowelWire.coach_pull`,
   `TowelWire.gd:87-92`). In a high cell both happen far more often, and each pull is priced as a stoppage (L3). The map bounds
   the card's share (5 to 60 in 100) but not the share of bouts LOST to the coach's own pull.
7. **The level targets mix two things.** 47 and 29 in 100 are every pro bout on record, most of them mismatches. The amateur
   targets are "between level boxers". The pro anchors are fitted to "the world's season mix", so the fit depends on how
   lopsided the game's own matchmaking is. If the game matches closer than real boxing does (likely: offers come from near your rank, `Matchmaking.BAND_UP` 5;
   the world's own pairing was not opened), fitting the mix to 47 makes LEVEL pro bouts end early more often than real level bouts do.
8. **The by-weight evidence carries an outlier year** (claim table, section 2). Use it for "no slope", not for a level.

## 4. Options: missing, useless, and what each changes

### Missing

| # | Missing option | What it would change |
| :--- | :--- | :--- |
| 1 | **Pick the pro table at the turn-pro call** when the walking weight allows two (the map's own 4.3) | The only place the class becomes a decision: a harder cut and a smaller field against an easier cut and a heavier punch coming back. |
| 2 | **A reward for the puncher that differs by cell**: a stoppage win where stoppages are rare is worth more (reputation, members, the news line, a fan) | Gives the read "a puncher here" a reason to exist and an opposite pull: chins for the hard cells, punchers for the quiet ones. The only reward for a stoppage win I found is one fan on the pro table (`Matchmaking.gd:241`). |
| 3 | **The drill named on the read**: "protect early: neck work raises the chin" | Turns a warning into a week choice with a cost (a morning not spent elsewhere). The drill exists (`Attrs.gd:273`); the read does not name it. |
| 4 | **Your boxer's own number on the turn-pro call**, not the field's: "your boxer, the first four pro bouts: about X in 100 stopped" | The field's average is the same for every boxer of a sex; the decision is about THIS chin. The game already plays scratch bouts for the plan test (`PlanTest.gd:93`). |
| 5 | **A towel that is cheaper than what it prevents** (L3 decided, not listed) | Without it "careful" is close to a trap in a hard cell: the pull costs what the stoppage costs, minus the chin wear and the long rest. |

### Useless or harmful as written

| # | Line | Why |
| :--- | :--- | :--- |
| 1 | Signing row, "Stopped early here: about N in 100 amateur bouts" | The same N on every card of a sex (anchor 1.00, slope 0 for women). The owner's rule: only what the player can act on. Keep the pro number and the chin read. |
| 2 | Towel strip, "A usual round here: U in 100" | A fourth number inside a one-minute decision. "Your line: L" is already the yardstick. |
| 3 | The Why, "Bouts here end early about N in 100" | After the fact, about the field. Keep the second half ("tonight the punch was 12 points over the chin"): that names something to train or to avoid. |
| 4 | `gap_shift = 12 x ln(count_mult)` | Wrong by about twofold (problem 3). |
| 5 | The men's slope 0.15 and the women's pro slope 0.10 before the John brief | Two fitted numbers resting on sources the map itself marks UNVERIFIED. Start them at 0 and let the brief earn them. |

### What each kept option changes

| Option | Changes |
| :--- | :--- |
| `count_mult` per cell | How often counts come: stoppages, the towel card, the cards (a point a count), Iron chin's and Finisher's worth, world records. |
| The chin read at signing (protect early / can be moved fast / a puncher here) | Whom to sign and which starting focus to pick on the same card. |
| The pro line on the turn-pro call | When a thin chin turns pro: now (money, purse) or after neck work (a decline, loyalty -8). |
| "The card comes about 1 fight in N here" on the towel row | Which line to set before the bout. |
| The cell shift on the ask card | Which name to ask for. Only if the word is right (problem 3). |
| The tail on Iron chin and Finisher | Which perk the mornings train toward. |
| The camp line | Whether a pro camp spends weeks on the chin. Needs its number (problem 4). |
| Relative colours on the pro rows | Which offer reads as dangerous in THIS table; a red that means the same share of rows everywhere. |

## 5. To reach 10/10 (most important first)

1. **Make the class a choice: build the table pick into the turn-pro call.** When your boxer's walking weight is within 3 kg of
   two tables' limits, the call shows both: for each, the cut in kg, "about M in 100 end early", the chin read against that
   field, and the field's size. One pick, written to a new `pro_div` key that `ProLadder.division_for` reads first. No
   mid-career move yet. Needs: a John brief on how punch and chin carry over a 5 kg step, or the pick changes only the field
   and the cut and says so.
2. **Pay the puncher by cell.** In `BoutFinish.run`, a stoppage WIN adds reputation and members scaled by how rare a stoppage
   is in the cell: plus (1 - usual / 50) x 2 reputation, rounded, floor 0 (ESTIMATE; the probe sizes it so a stoppage win is
   worth between 1.2 and 2 ordinary wins in the quietest cell and about 1 in the loudest). Show it on the signing read: "a
   puncher here: a stoppage win is big news in this class".
3. **Give the pro cells pro rules before fitting them.** `round_counts` takes the cell's ruleset: amateur keeps three in a
   round and four in the bout; pro keeps three in a round and drops the bout total. Then fit. The probe prints, per cell, the
   share of stoppages by referee, by count limit and by knockout, and bounds the count-limit share in pro cells under 25 in 100.
4. **One limit per cell, from one place.** Amateur: `Data.DIVISIONS[div].limit`. Pro: the table row's `max_kg` through
   `ProLadder.division_for(f)`, never the boxer's own `limit`. `tests/class_damage_test.gd` plays the same pair through
   `BoutNight.count_sides` and through `Matchmaking.fight` and fails unless `count_mult` is identical.
5. **Measure the ask card's edges per cell; drop the formula.** `StopWord.word(gap, possible_gap = 0.0, risk_gap = 8.0)`; the
   probe writes the two edges for each amateur cell the way STOPWORD1 did (monotone blocks), and both callers pass the cell's
   pair. The control cell keeps 0 and 8, so today's test does not move.
6. **Put your boxer's own number on the turn-pro call.** Twenty scratch bouts (the plan test's loop) against four names from
   the bottom of the table your boxer would join: "about X in 100 stopped in the first four". Beside it the same for "after
   six weeks of neck work" (chin + the camp's gain). Two numbers, two buttons.
7. **Decide the towel's price (L3) inside this mechanic.** A pull: 1 member and 2 reputation (an ordinary loss), no "stopped"
   loyalty on top of the towel's own, the lesson of a loss, no stopped flag to the ladder. Add the probe bound: bouts lost to
   the coach's own pull on the normal line under 10 in 100 in every cell.
8. **Bound the cards.** The probe prints, per cell, the share of distance bouts where the count points changed the winner, and
   holds it within 3 points of the control. If it fails in the pro cells, pro judges take one point for the first count of a
   round and none for the rest.
9. **Fit pro on level pairs as well as the mix.** Print both. Target for level pro pairs: under the mix's number (a real
   level bout ends early less often than the average bout). If only the mix can reach 47, say that the gap is matchmaking.
10. **Cut the three field averages** (section 4, useless 1 to 3) and keep the chin read, the pro number and the night's
    punch-over-chin. Name the drill on every "protect early".
11. **Evidence before the fit.** The John brief the map already asks for, plus: the by-weight rows recounted without the
    2025 outlier; the men's amateur level from England Boxing championship results; both slopes start at 0.
12. **Probe repairs.** Read amateur pools from a made career's `rivals` (so women's lightweight has its `div`), not from the
    Data constants. Add per-cell worth of Iron chin and of Finisher (win share with and without) with a bound: each worth
    between 2 and 8 points in every cell, so neither is useless in a quiet cell nor a must in a loud one. Report the KO share
    and, in pro cells under 8, raise `KO_ODDS` for the pro ruleset only.
13. **One golden-path test** that walks: the signing read, an ask card in a men's cell, the towel row, a stopped bout's Why,
    the turn-pro call with its two tables, the first pro row's colours.

What the game cannot do yet: item 1 needs the carry-over numbers (research) and a ladder place in a second table (the map's
4.3 lists this honestly). Everything else is buildable from files that exist.

## 6. My 10/10 as a 1920 x 1080 page: the turn-pro call

Described, not rendered (this task owns one file).

- **Header, full width, 120 px:** "A CALL FROM <THE HOUSE>" small caps; under it "TURN <FIRST NAME> PRO?" in the display
  face. Right side: "Declines left: 2" and "The offer stands 9 more days".
- **Left column, 560 px, YOUR BOXER:** the portrait; one row "Chin 58" as a bar with a tick where the field's punch sits;
  the read in one coloured word: PROTECT EARLY (amber), CAN BE MOVED FAST (green) or A PUNCHER HERE (gold); under it one
  line, "Neck work raises the chin: about +4 in six weeks".
- **Centre, two cards side by side, 520 px each, THE TABLE:** one card per table your boxer can make. Each card: the class
  word and limit; "The cut: 1.1 kg" or "The cut: 4.3 kg, hard" with the weight bar; "Your boxer, the first four bouts: about
  14 in 100 stopped" as a row of 100 small squares, 14 filled; "Your punch against this field's chin: +5" and "Their punch
  against your chin: +9"; "A stoppage win here: big news" or "ordinary"; the field's size. The picked card has the solid
  border; the other is one click away. A boxer with one table sees one wide card.
- **Right column, 320 px, THE PRICE OF WAITING:** "Stay amateur: one decline used, loyalty -8"; "After six weeks of neck work
  the same four bouts: about 9 in 100"; the house's terms in two lines.
- **Footer, 96 px:** two buttons of equal weight: "Sign for <table>" (solid) and "Stay amateur" (outline). Hover on any
  number says what it is made of and what the player can do about it, never the label again.
- Nothing on the page is a field average on its own; every number is your boxer's, and each sits beside the button it informs.

## 7. Code files I opened

`scripts/rules`: Knockdowns.gd, Towel.gd, StopWord.gd, StandDown.gd (whole); Matchmaking.gd (22-50, 62-72, 198-210, 266-284 and a
search), PerkFight.gd (8-34, 58-68), PerkRoad.gd (6-18), AttrGen.gd (62-70, 100-106, 148-183), Attrs.gd (40-43, 124-130 and a
search for durability), InjuryRoll.gd (7, 10-58), BoutRules.gd (118-125), Loyalty.gd (56-62), FirstHour.gd (100-128),
CardAsk.gd (138-166), CoachRead.gd (160-183), FightWhy.gd (254-265), Adaptation.gd (83-91), Exchanges.gd (8-11, 52-55); by
search: Judges.gd, CornerJobs.gd, TheRead.gd, ScoreSheet.gd.
`scripts/state`: TowelWire.gd (whole); BoutNight.gd (95-110, 205-295), BoutFinish.gd (55-135, 170-184), RingDuel.gd (130-142,
374-390), LiveRound.gd (306-362, working copy), Data.gd (69-100, 134-156, 169-271), ProLadder.gd (30-50, 214-230, 248-263),
AskFlow.gd (103-121, 172-183), LateAskWire.gd (116-127), Injuries.gd (176-184), Region.gd (164-173), Roster.gd (107-111),
SaveGame.gd (82-87), WeekData.gd (35-40), Career.gd (108-120, 194-201); by search: JudgeNight.gd, PlanTest.gd, FixLab.gd.
`scripts/world`: WorldBout.gd (18-34, 88-98, 108-240, 320-328), WorldSim.gd (136-192), WorldGen.gd (18-30, 82-90, 138-201,
206-217), WorldAge.gd (116-123).
`scripts/ui`: ProFights.gd (168-226), FightPrep.gd (76-100, 186-193), RecruitPanel.gd (33-56), TowelStrip.gd (5-12),
AskPanel.gd (108-116), LateAskCard.gd (25-30), areas/FighterPage.gd (104-113 and its function list), areas/Fighters.gd
(181-183, 208-214), modals/Interview.gd (61-66), modals/Trial.gd (20-31), modals/ProOffer.gd (22-62 and a search); by search:
WeekBoard.gd.
Tests and tools: tests/knockdowns_test.gd (44-51), tests/towel_wire_test.gd (70-76), tests/stop_word_test.gd (102-108),
tests/stop_mult_test.gd (exists), tools/stop_word_probe.gd (length and a search).
Data and documents: assets/data/world/divisions.json (whole), docs/STOPWORD1_RESULT.md, docs/LIVERPROBE1_RESULT.md,
ops/research/J_KDRATES1_JOHN.md (8-36 and a search), ops/research/RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md (search),
ops/research/topics/knockdowns_stoppage.md (search). No real-world source was opened on the web.

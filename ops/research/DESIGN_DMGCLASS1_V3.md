# DESIGN DMGCLASS1 v3 - stoppages by weight class and sex, written from the code

Kind: design map, research only. No game code changed, Godot not run. Written by a Fable console in the checkout (S534).
Follows: `ops/research/DESIGN_DMGCLASS1_V2.md` and its code-checked critic `ops/research/DESIGN_DMGCLASS1_V2_CRITIC_FABLE.md` (5 / 6 / 4).
Code read at commit 7e63b872a on 2026-11-21. `scripts/state/LiveRound.gd` carries another session's uncommitted edits: its line
numbers are that working copy's. Every other line number is the committed file's.

Words used: CODE = I opened the file for this map and the line is true today. CRITIC-CHECKED = the v2 critic verified it, I did
not re-open it. COUNTED = a real-world number with a sample size and a named source. UNVERIFIED = a seat's number whose source
nobody has opened. ESTIMATE = my number, to be replaced by the probe. Nothing else is claimed.

## 0. What changed from v2, in six lines

1. The class is a decision in three places (signing, turning pro, the towel) and a read in three more (camp, perk road, the Why).
2. ONE fitted number per cell (`count_mult`), not three. Damage and the hurt roll are not touched.
3. Seven fitted numbers in all (four anchors and up to three weight slopes), not 51.
4. The table of real-world rates in v2 section 1 is withdrawn: it is not what the study said (section 2).
5. Women's amateur is the control cell (`count_mult` 1.00): the normal start keeps its towel card.
6. Every false CODE claim of v2 is corrected in section 1.6; F13 is already fixed on main.

## 1. What the game does today (CODE)

### 1.1 Where a bout ends early

| What | Code | Notes |
| :--- | :--- | :--- |
| Round head damage | `Knockdowns.round_counts`, `scripts/rules/Knockdowns.gd:30-32` | Loser +8 / +18 / +32 (close / clear / dominant, `:13`), winner +2 (`:14`). |
| A count | `Knockdowns.round_counts`, `:34-47` | `0.05 x margin factor x exp((power - chin) / 12) x (1 + damage / 60)`, capped 0.85, up to three rolls, each x0.6. |
| The referee | `Knockdowns.round_counts`, `:53-59` | Only after a count: `0.2 x (1 + damage / 60) x (1.4 - heart / 100) x stop_mult`, capped 0.9. A KO needs damage 60 and `(1 - heart / 100) x 0.7`. |
| The count limit | `Knockdowns.round_counts`, `:61-62` | Three counts in a round or four in the bout is an RSC even when the referee roll fails. |
| The puncher's chance | `Knockdowns.puncher_chance`, `:121-138` | The round's winner can be caught: `0.05 x 0.4 x exp(...) x (1 + damage / 60)`, capped 0.5 (`:128`); the same referee roll (`:132-133`). |
| Sides in a player bout | `BoutNight.count_sides`, `scripts/state/BoutNight.gd:236-240` | `RingDuel.side` of each boxer (power = 0.7 power + 0.3 accuracy, chin, heart: `RingDuel.gd:138-139`) plus `stop_mult` = the other side's Finisher (`PerkFight.stop_mult`, 1.5 or 1.0, `PerkFight.gd:30, 64-65`). Nothing else. |
| The round's counts | `BoutNight._counts`, `BoutNight.gd:245-290` | Slugger power added (`:249`), `round_counts` (`:254`), Iron chin (`:256-261`), the liver fold (`:266`), the puncher's chance (`:270`). |
| Damage added inside a watched round | `LiveRound.exchange`, `LiveRound.gd:311-359` (working copy) | Counter sense +15 to the opponent (`:312`, `PerkFight.COUNTER_DAMAGE`), a clinch hit to ours (`:331-334`), a landed set-up +30 to the opponent (`:340`, `CornerJobs.SETUP_DAMAGE`), a landed read +0 today (`:345`, `TheRead.DAMAGE := 0.0`), what gets through the guard to both (`:355-359`). Also `Adaptation.gd:87-89`. |
| The hurt roll in a round | `RingDuel.settle`, `RingDuel.gd:383-386` | Margin past 30 (`Exchanges.HURT_AT`, `Exchanges.gd:54`) and `clamp(0.3 + (power - chin) / 100, 0.1, 0.6)`; ours x talk x 1.6 on a missed set-up or read, clamp to 0.8. |
| World bouts | `WorldBout.fast`, `scripts/world/WorldBout.gd:206-237` | Sides from `_side(profile)` = power, chin, heart only (`:324-325`); built at `fight :127`, `cached :186`, `fast :211`. Calls `round_counts` (`:226`) and `puncher_chance` (`:232`) every round. No live adders. |
| The world's hurt edge | `WorldBout._hurt_edge`, `WorldBout.gd:92-97` | `0.18 + last / 90 + (power - chin) / 60`, clamped 0 to 0.5. |
| Who calls `WorldBout.fast` | `WorldSim.simulate_bout` (`WorldSim.gd:141`), `Region._rival_bout` (`Region.gd:170`, 3 rounds), `Matchmaking.fight` (`Matchmaking.gd:206`, `ROUNDS := 6` at `:24`) | Three callers. |
| World rounds | `WorldSim.rounds_for`, `WorldSim.gd:161-165` | 10 if either is top 10, 8 if ranked, else 6; 3 for a table whose id starts `a_`. No id in `assets/data/world/divisions.json` starts `a_`, so the generated world never takes the 3. It never returns 4. |
| A world stoppage on the record | `WorldSim._apply_bout_result`, `WorldSim.gd:180-189` | `ko` +1 for the winner (`:183`), `WorldAge.record_stoppage_loss` for the loser (`:189`; `WorldAge.gd:119-122`). `WorldSim._roll_stoppage` (`:173-177`) is defined and, per the critic, has no caller. |

None of these functions reads sex, a division or a weight. `ClassDamage`, `punch_mult` and `class_stop` appear nowhere in
`scripts`, `tools` or `tests`; `count_mult` appears only as an unrelated helper name in `tests/deal_contract_test.gd`.

### 1.2 The world is class-blind by construction

- `AttrGen.generate(rng, archetype)` (`scripts/rules/AttrGen.gd:103`) takes no sex and no division: a world boxer's power, chin
  and heart come from the same dice in every division.
- `WorldGen._roll_rating` (`scripts/world/WorldGen.gd:209-216`): 64 to 80 ranked, 55 to 68 unranked, by age only.
- `WorldGen._make_boxer` (`:140-185`): the starting record's KO share is `clamp(0.3 + explosiveness / 30, 0.05, 0.75)`
  (`:150`) in every division. Sex and weight reach only height and reach (`AttrGen.body`, `:152`).
- 35 boxers a division: `RANKED_PER_DIVISION 20 + UNRANKED_PER_DIVISION 15` (`:20-21, 87`); the entry point is
  `WorldGen.generate(seed)` (`:27`).

So today the eight pro tables can differ only through the number of rounds. The control arm of the probe needs one world
number per round count (6, 8, 10), not one per division. The amateur pools are different: `Data.DIVISION_RIVALS`
(`scripts/state/Data.gd:171-211`) are hand-written, and the men's rows are rated lower (53 to 62, one 69 or 70) than the
women's (58 to 65, one 70 to 72.5). An amateur division can read differently today because of WHO is in it, never because of
a rule. The probe must keep those two apart (section 5).

### 1.3 Classes

- Nine amateur divisions: women 57, 60, 65, 70, 75 kg; men 55, 60, 70, 75 kg (`Data.DIVISIONS`, `Data.gd:136-155`).
- Eight pro tables, featherweight to middleweight for each sex, upper limits 57.0 / 61.2 / 66.7 / 72.6 kg
  (`assets/data/world/divisions.json`). The file gives `pro_rounds` 10, and 12 for men's welter and middle; per the
  critic no bout code reads it.
- A signed boxer gets `div`, `sex` ("f" / "m") and `limit` once (`Data.fighter_state`, `Data.gd:254-270`, the write at
  `:260-261`). The pro table is worked out from sex and limit each time: at or under 57.5 feather, 62.0 light, 70.0 welter,
  else middle (`ProLadder.division_for`, `scripts/state/ProLadder.gd:43-49`).
- Player pro bouts are 4 / 6 / 8 / 10 rounds (`ProLadder.ROUNDS_*`, `ProLadder.gd:33-36`). Every round is six exchanges
  for everyone (`Exchanges.EXCHANGES := 6`, `Exchanges.gd:10`): a women's pro round is as long as a men's.
- No code moves a signed boxer to another class. The only writes to `limit` are `FirstHour.refuse`
  (`scripts/rules/FirstHour.gd:125`, the second walk-in), `SaveGame.gd:85` (old saves) and a goal's copy (`WeekData.gd:38`).

### 1.4 The towel and what a stoppage costs

- The towel's risk: `Towel.risk` (`scripts/rules/Towel.gd:23-64`) plays the next round 200 times
  (`TowelWire.TRIALS`, `TowelWire.gd:20`) through `round_counts` and `puncher_chance`. Its sides are passed in by
  `BoutNight._shout` (`BoutNight.gd:220`, `count_sides`); `TowelWire.state` adds the Slugger power itself (`TowelWire.gd:37`).
- The lines are fixed: careful 0.12, normal 0.20, brave 0.33 (`Towel.LINES`, `Towel.gd:11`), set on
  `FightPrep.towel_row` (`scripts/ui/FightPrep.gd:78-99`).
- The card does NOT come only at the line. `Towel.reasons` (`Towel.gd:89-101`) gives four reasons: a count in the round
  just gone, the head at or under 35 (`BodyMap.CRITICAL`; head = 100 - damage x 2.2, `TowelWire.gd:22, 54`), a closing eye,
  or the risk at the line. Only the coach's own pull is tied to the line alone (`Towel.coach_pulls`, `:110-112`). So v2's
  critic point "in a light class the card stops coming" is half right: the LINE stops mattering, the card still comes on a count.
- The three answers read Pull out / Box safe / One more round (`TowelStrip.ANSWERS`, `scripts/ui/TowelStrip.gd:8-10`).
- A pull: 14 days out, morale -4, loyalty +2 or -6 by band, no injury roll (`Towel.answer`, `Towel.gd:117-126`;
  `TowelWire.pull`, `TowelWire.gd:97-109`; `Injuries.after_bout` returns on "RTD", `scripts/state/Injuries.gd:181-182`).
- **F13 is fixed on main (S534).** `BoutFinish.run` wears the chin only when `stop != "" and stop != "RTD"`
  (`scripts/state/BoutFinish.gd:101-102`); `tests/towel_wire_test.gd:74` checks the cap does not move. A towel now keeps
  the 2.0 chin ceiling (`Attrs.STOP_DROP`, `Attrs.wear_stoppage`, `scripts/rules/Attrs.gd:42, 127-128`).
- Still true after the fix, and NOT decided here (for the main session): an "RTD" loss is treated as a stopped loss in five
  other places of `BoutFinish.run`: 2 members and 4 reputation (`:103, 105`; `BoutRules.gd:122-123`), the pro ladder is
  told it was stopped (`:110`, which adds the 8 rest weeks), the amateur lesson is cut as stopped (`:132`), loyalty takes
  "stopped" -3 on top of the towel's own loyalty move (`:178`; `Loyalty.gd:60`), and the knowledge read widens (`:180`).
- A referee stoppage loss: 30 / 90 / 365 days (`InjuryRoll.ko_days`, `scripts/rules/InjuryRoll.gd:12-16, 42-56`), chin ceiling
  -2, no stand-down (`StandDown.make` returns {} when stopped, `scripts/rules/StandDown.gd:27-29`), +8 pro weeks
  (`Matchmaking.next_weeks`, `scripts/rules/Matchmaking.gd:280-282`: base 6 / 8 / 12, `:30-33`), rating -0.8 (`STOP_COST`, `:48`).
- A distance bout: no sparring 5 / 10 / 21 days by head = 100 - damage x 0.8 (`StandDown.gd:7-10, 27-32`); an injury roll of
  `0.06 x rounds / 3 x (0.4 + 1.2 x worst place)` x a flexibility factor, capped 0.4 (`InjuryRoll.bout_chance`, `:29-39`).
- None of the rest, suspension, wear or injury functions reads sex or class.

### 1.5 Stoppage numbers the player sees today

| Screen | Code | What it shows |
| :--- | :--- | :--- |
| Pro row, the opponent | `ProFights._row`, `scripts/ui/ProFights.gd:173-178` | "Stopped N of the M beaten", red from 40%, amber from 20%: fixed lines. |
| Pro row, the loss column | `ProFights._row`, `:221-223` | "Stopped: N% chance; then out W weeks, and damage", red from 15%, amber from 7%: fixed lines. |
| Pro row, the coach's read | `ProFights._row :182-183` into `CoachRead.pro_read`, `scripts/rules/CoachRead.gd:166-181` | "a N% chance of being stopped" from 7% up: a fixed line. |
| The offer filter | `ProLadder.offer_axes`, `ProLadder.gd:220-228` | `stop` is one of the five numbers a row is judged on. |
| The number behind all three | `Matchmaking.stop_chance`, `Matchmaking.gd:272-275` | `(1 - win chance) x max(0.1, ko / w)`, 0.25 with no wins. Three call sites: `ProLadder.gd:228`, `ProFights.gd:183`, `ProFights.gd:221`. It decides no bout. |
| The ask card | `AskFlow.answers`, `scripts/state/AskFlow.gd:105-120` (the call at `:117`); printed by `AskPanel._answer`, `scripts/ui/AskPanel.gd:112-114` | "Getting stopped: unlikely / possible / a real risk." |
| The late-ask card | `LateAskWire.view`, `scripts/state/LateAskWire.gd:119-126` (the call at `:125`); printed at `scripts/ui/LateAskCard.gd:28` | The same word. |
| The word's rule | `StopWord.word(gap)`, `scripts/rules/StopWord.gd:20-25` | Under gap 0 unlikely, under 8 possible, else a real risk (`:15-16`), for chances of 8% and 20% (`:8-9`). One signature, two callers. Pure: no preload (pinned at `tests/stop_word_test.gd:106`). |
| The towel strip | `Towel.words`, `Towel.gd:139-143` | "Stopped next round: N in 100 (Box safe: M in 100). Your line: L." |
| The perk road | `FighterPage._tab`, `scripts/ui/areas/FighterPage.gd:108-111`, rows from `PerkRoad.status` | Iron chin needs durability 70, Finisher needs explosiveness 70 (`scripts/rules/PerkRoad.gd:10, 16`). No division word. |
| The signing card | `RecruitPanel.build`, `scripts/ui/RecruitPanel.gd:35-54`; used by the walk-in interview (`scripts/ui/modals/Interview.gd:64`) and the trial (`scripts/ui/modals/Trial.gd:29`) | The style's class word, potential stars, attributes, traits, perks. The weight class is one word in the trial's sub-line (`Trial.gd:24`). Nothing about stoppages. |
| The prospect card | `Fighters._scouting`, `scripts/ui/areas/Fighters.gd:181-232` (the line at `:212`) | Age, weight class word, style, the scout's note, scouted ranges (plus or minus 5, `Data.SCOUT_SPREAD`). |
| The turn-pro call | `scripts/ui/modals/ProOffer.gd` `build`, `:25-60` | Record, days left, declines left, tickets, the houses' terms. Nothing about stoppages. |

Measured today, from an existing probe (not run for this map): `docs/STOPWORD1_RESULT.md`, 960 real three-round bouts of the
test club's three boxers (seed 4421). Between level boxers (real gap -2.5 to 0, n 300) our boxer was stopped 5.3 in 100 and
the opponent 3.7 in 100: 9 in 100 bouts stopped, inside John's club band of 5 to 12. Stoppage kinds: 132 RSC, 15 KO (10% KO).
The chin moves it far more than the class does: the featherweight with chin 52 was stopped 10.0 and 11.7 in 100 against
level opponents, the lightweight with chin 66 was stopped 1.7 in 100 against one four points better. The men's welterweight
(chin 64) read like the women's lightweight at level gaps (1.7 to 8.3 in 100). Three boxers cannot show a class effect; the
code in 1.1 shows there is none in the rules.

### 1.6 v2's false claims, corrected

| # | v2 said | True today |
| :--- | :--- | :--- |
| F1 | `stop_chance` has two callers | Three: `ProLadder.offer_axes` (`ProLadder.gd:228`), `ProFights._row` twice (`:183` into the coach's read, `:221`). CODE. |
| F2 | The label is "Stoppage %d%%" | "Stopped: %d%% chance; then out %d weeks, and damage" (`ProFights.gd:222`), red 15 / amber 7. CODE. |
| F3 | `TowelWire.card` calls `count_sides` | The sides are passed in from `BoutNight._shout` (`BoutNight.gd:220`). CODE. |
| F4 | Second wind +18 | `SECOND_WIND := 10.0`, round 3 (`PerkFight.gd:14-15`). CODE. |
| F5 | Pro turnaround 6 / 8 / 10 weeks | 6 / 8 / 12 (`Matchmaking.gd:30-32`), +8 after a stopped loss (`:33`). CODE. |
| F6 | 45 boxers a division, `WorldGen.new().generate_world` | 35; `WorldGen.generate(seed)` (`WorldGen.gd:20-21, 27`). CODE. |
| F7 | A 4-round share "matching `rounds_for`" | `rounds_for` gives 10 / 8 / 6 (and 3 for an `a_` table that does not exist). Four rounds are the player's unranked bouts only. CODE. |
| F8 | Sides read `sex`, `div`, `limit` off any boxer | Four shapes, section 3.3. CODE. |
| F9 | The hurt state is entered at `Exchanges.gd:145-149` | CRITIC-CHECKED: `Exchanges.situation` and `Exchanges.next_mode`. v3 does not touch the hurt state, so the claim is cut. |
| F10 | An annual -2.0 chin drop for world boxers | `STOP_CHIN 2.0` x stoppage losses, once per loss (`AttrGen.age_wear`, `AttrGen.gd:67, 172-181`). CODE. |
| F11 | `CounterCut.cut` | CRITIC-CHECKED: `CounterCut.apply`, animation only. Cut from the map: it is not part of this mechanic. |
| F12 | Two signatures for `StopWord.word_for` | No such function exists. v3 gives one signature (section 3.5) and names both callers. |
| F13 | A towel skips the chin wear | It did not; it does since S534 (`BoutFinish.gd:101`). Fixed on main, tested. |
| - | Towel buttons "Throw the towel / Box safe / Send out" | Pull out / Box safe / One more round (`TowelStrip.gd:8-10`). CODE. |
| - | Only `WorldSim` and `Region` call `WorldBout.fast` | Also `Matchmaking.fight` (`Matchmaking.gd:206`). CODE. |
| - | Walk-ins at `FirstHour.gd:116-130`, prospects at `Roster.gd:113-125` | `FirstHour.walkin` (`:103`) and `refuse` (`:114`); `Roster.trial_read` (`:109`); the table is `Data.PROSPECTS` (`Data.gd:221-243`). CODE. |
| - | A stopped amateur loss teaches "0.0" | CRITIC-CHECKED: the base lesson minus 0.8, floored at 0 (`AskFlow.teach_after` floors it, `AskFlow.gd:180`, CODE). |
| - | `tools/stop_word_probe.gd` is 210 lines | CRITIC-CHECKED: 479 lines. |

Every line number of v2 is withdrawn. A build brief re-reads the function named here.

## 2. The real-world numbers, and what v2 got wrong about them

v2's section 1 gave sixteen ranges (women's amateur featherweight 1.0 to 2.5 in 100 up to men's pro middleweight 48 to 55) and
said they were "preserved from SQ257". They are not in that study. `ops/research/RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md`
holds three bands per sex and ruleset, no per-division row, and different numbers (men's pro light 55, middle 68; women's pro
light 24, middle 30; men's amateur light 7, middle 11; women's amateur light 5, middle 6). The sixteen ranges are withdrawn.
The study's own header says "Verify the sources before using it", and several of its sources cannot be opened as cited
("unpublished aggregated summaries", "Boxingweightclasses.org", "The Fight Algorithm").

What we have, ranked by how far it can be trusted:

| Fact | Number | Source | Status |
| :--- | :--- | :--- | :--- |
| Women's amateur, world championships 2018 to 2023 | 4.4 to 11.4 in 100 bouts stopped (1,036 bouts) | John, `ops/research/J_KDRATES1_JOHN.md`, counted from Olympedia and Wikipedia brackets | COUNTED (by a seat; not checked against the official results books) |
| Women's amateur, four Olympics | 4 of 278 = 1.4 in 100 | same | COUNTED |
| Women's amateur BY WEIGHT, the same championships | up to 54 kg 10.6 (51 of 479); 57 to 70 kg 9.5 (54 of 569); middleweight and up 11.2 (22 of 196) | same, his section 5: "There's no real difference" | COUNTED |
| Women's pro | 29 in 100 end by KO or TKO (5 KO, 24 TKO), 14,555 bouts, BoxRec 2014 to 2024 | AAN 2025 abstract, https://www.aan.com/msa/Public/Events/AbstractDetails/58398 (via John) | COUNTED |
| Men's pro | 47 in 100, same abstract; the project's own topic page says the same ("boxing ~47% KO/TKO in BoxRec's modern census", `ops/research/topics/knockdowns_stoppage.md`, study G108) | same | COUNTED |
| Women against men per minute fought | about 0.83; "nearly equal" | John, same file | COUNTED (rough) |
| Men's Olympic amateur, all early endings | 17.3 in 100 before headguards, 21.8 after 1984 | BJSM 2013, https://bjsm.bmj.com/content/47/7/452 (via John) | COUNTED, but an old era and elite brackets |
| Counted bouts per stopped bout | 2 to 4 | John: "my assumption, not data" | GUESS (the code is tuned to it, `Knockdowns.gd:2-4`) |
| Men's amateur by weight | light 6 to 9, middle 9 to 13, heavy 14 to 18 | Dola SQ257 | UNVERIFIED |
| Men's pro by weight | light 55, middle 68, heavy 75 | Dola SQ257 | UNVERIFIED, and its level contradicts the counted 47: it reads like ranked and title bouts |
| Women's pro by weight | light 22 to 28, middle 28 to 34 | Dola SQ257 | UNVERIFIED |

What the evidence supports, in plain words:

1. **The ruleset is the big step.** Amateur about 5 to 12 in 100, pro about 29 (women) and 47 (men). Turning pro multiplies the
   chance of an early ending by three to six.
2. **Sex is the second step, and in the pro game it is mostly round length.** Women's pro rounds are two minutes; per minute
   fought the sexes are nearly equal. The game gives everyone the same six exchanges a round (`Exchanges.gd:10`), so the
   women's pro cell has to carry that as a factor. Saying so is honest; a hidden "women hit softer" number would not be.
3. **Weight is the smallest step inside the game's range.** The game spans 55 to 75 kg. Counted women's amateur data shows no
   slope at all. The unverified men's rows suggest middle is 1.2 to 1.4 times light. v2's fiftyfold spread from the lightest
   cell to the heaviest was not in any source.

This changes the design. A division read that told the player "featherweights never get stopped" would be false. The honest
decision is: which sex and class you sign, how THIS boxer's chin sits in that field, and above all when you turn pro.

## 3. The dial

### 3.1 One number per cell

A new pure file `scripts/rules/ClassDamage.gd` (TO BUILD; no preload, no career). A cell is (sex, ruleset, limit in kg). It gives
one fitted number, `count_mult`: how often a clean shot puts a boxer on a count in this cell.

- Read in `Knockdowns.round_counts` at the count chance (`Knockdowns.gd:34`) and in `Knockdowns.puncher_chance` at its
  count chance (`:128`), from the PUNCHER's side: `float(winner_side.get("count_mult", 1.0))`. It multiplies before the
  0.85 and 0.5 caps, so the caps stay where they are.
- A missing key is 1.0: `tests/knockdowns_test.gd` (raw sides, band [0.03, 0.12] at `:49`) and `tests/stop_mult_test.gd` do not move.
- `stop_mult` stays the perk's alone (Finisher). The referee's roll, the KO rule, the count limits, the damage table and
  both hurt rolls are NOT touched.

Why one number and why there (the critic's problems 2, 3 and 4):
- Stoppages are gated behind counts (`Knockdowns.gd:53`), so the stopped share follows the count chance almost in
  proportion. One number per cell is fitted to one sourced target per cell. Nothing is under-determined.
- The count-to-stoppage ratio (John's 2 to 4, a guess the code is already tuned to) is kept without a second knob.
- The watched bout and the world bout get the same multiplier at the same line. The live damage adders (section 1.1) are
  not scaled, so they differ between the two paths exactly as they do today; the probe's control arm shows by how much.
- Not scaling the hurt roll removes the "inside or outside the clamp" question.
- Not scaling damage means the stand-down, the head place, the injury roll and the towel's head reason are untouched. "The
  same price in every division; it just happens more or less often" becomes true in effect, not only in the code.
- The price: the KO share of stoppages is an output, not a dial. The one counted number is women's pro, 5 KO in 29 stopped
  (17%). The probe reports the share per cell. If it sits far outside 8 to 30 in the pro cells, a later version argues for a
  second number with that evidence in hand.

### 3.2 Seven fitted numbers, each with its target

`count_mult = anchor[sex][ruleset] x (1 + slope[sex][ruleset] x (limit - 62) / 13)` (62 kg is the middle of the game's range,
13 kg the distance from there to the 75 kg top; ESTIMATE of the form, the probe may show a flat slope everywhere).

| Number | Target (per 100 bouts between level boxers unless said) | Evidence | Value today |
| :--- | :--- | :--- | :--- |
| Anchor, women's amateur | 5 to 12 stopped | John, COUNTED; the code is tuned to it and STOPWORD1 measured 9 | **1.00 by definition: the control cell** |
| Anchor, men's amateur | 6 to 16 stopped | UNVERIFIED (Dola's light and middle rows) plus the old Olympic 17 to 22; a John brief must check it before the fit | ESTIMATE 1.2 to 1.6 |
| Anchor, women's pro | 22 to 34 over the world's season mix | AAN 2025, COUNTED (29) | fitted: target middle / control measurement |
| Anchor, men's pro | 40 to 54 over the world's season mix | AAN 2025 and G108, COUNTED (47) | fitted the same way |
| Slope, women's amateur | none: the three weight rows within 3 points of each other | John, COUNTED (10.6 / 9.5 / 11.2) | **0** |
| Slope, men (amateur and pro share one) | middle 1.0 to 1.4 times feather | UNVERIFIED | ESTIMATE 0.15 |
| Slope, women's pro | middle 1.0 to 1.4 times feather | UNVERIFIED | ESTIMATE 0.10 |

Club against elite (the critic's problem 7): the amateur anchors follow the CLUB band, which is what the code is tuned to and
what the game's bouts are. No separate elite cell. The difference between a club show and the Olympics is who is matched, and
the count chance already reads that through power against chin. The probe prints championship bouts as their own row.

### 3.3 One lookup, four shapes

| Shape | What it carries today (CODE) | How the cell is found |
| :--- | :--- | :--- |
| A signed boxer | `sex` "f" / "m", `div` = the amateur id for life, `limit` in kg, `pro` (`Data.gd:260-264`); the bout says `bout.pro` (`BoutFinish.gd:61`) | sex, limit, `bout.pro` |
| A world boxer | `sex` "women" / "men", `div` "w_lw" and so on, no `limit` (`WorldGen.gd:155-185`) | the division id: sex from its row, limit = the row's `max_kg`, pro always |
| An amateur rival | `div` = the amateur id, no `sex`, no `limit` (`Data.DIVISION_RIVALS`, `Data.gd:171-211`) | the amateur id through `Data.DIVISIONS`: sex and limit; pro false |
| A bout opponent, and the player's ladder entry | `ProLadder.bout_opp` copies OUR boxer's amateur id into `div` and sets `pro: true`, no sex, no limit (`ProLadder.gd:253-261`); the ladder entry has no sex, div or limit at all (`Matchmaking.join`, `Matchmaking.gd:67-70`) | not from itself: see the rule below |

The rule that makes this safe: **a bout has one cell, taken once, and both sides get it.** The owner's rulings guarantee it:
females never fight males, and booking matches the weight class. So:
- `BoutNight.count_sides(f, opp)`: the cell comes from OUR boxer `f` (sex, limit, `f.bout.pro`). The opponent dict is never asked.
- `WorldBout` (`fight :127`, `cached :186`, `fast :211`): `ClassDamage.cell_of_pair(x, y)` takes the first of the two that
  resolves. That covers `Matchmaking.fight`, where `p` is the keyless ladder entry and `opp` is a world boxer.
- There is no silent 1.0. `cell_of_pair` returns an empty cell when neither side resolves, and `tests/class_damage_test.gd`
  (TO BUILD) feeds all four shapes through the three real call paths and fails on an empty cell or on two sides that resolve to
  different cells.
- `WorldBout.cached` stores the sides (`:185-186`) under a key of id, name, shape, age and rounds (`_key`, `:193-202`). A
  boxer's class never changes, so the cache stays right in the game. The probe changes factors between arms and must empty
  `WorldBout._cache` (`:33`) each time.

### 3.4 What reaches everything else for free

Once `count_sides` carries the number: the round's counts (`BoutNight._counts`), the towel's risk (`Towel.risk` through
`BoutNight._shout`), and, CRITIC-CHECKED, the plan test and the fix lab (they play `BoutNight.play_out`, `BoutNight.gd:102`).
Once `WorldBout` carries it: the world's records (`ko` over wins), rival bouts, the simulated pro bout.

### 3.5 Shown numbers that need a hand

- `StopWord.word(gap: float, shift: float = 0.0)`: ONE signature. The word is read at `gap + shift`. Both callers
  (`AskFlow.answers`, `LateAskWire.view`) pass `ClassDamage.gap_shift(cell)` = `12 x ln(count_mult)` rating points: the count
  chance grows by e every 12 points of power over chin (`Knockdowns.POWER_CHIN_SCALE`, `Knockdowns.gd:11`), so a factor is worth
  that many points. ESTIMATE: the probe checks that each word's measured chance sits in its band in every amateur cell.
  `StopWord.gd` stays pure; today's one-argument calls and its test do not change. Women's amateur shift is 0.
- `Matchmaking.stop_chance`: the 0.25 for an opponent with no wins and the 0.1 floor become the cell's own stoppage share of
  wins (`ClassDamage.ko_share(cell)`, measured by the probe on the world arm) and 0.4 of it.
- `WorldGen._make_boxer` (`:150`): the 0.3 centre of a starting record's KO share becomes the same `ko_share(cell)`, so a
  day-one record agrees with what the world then produces.
- The three fixed colour lines (`ProFights._row` 40 / 20 and 15 / 7, `CoachRead.pro_read` 7) become relative to the cell:
  amber from the cell's usual, red from twice it (the stopped chance) or one and a half times it (the opponent's stopped
  share). ESTIMATE; the probe bound is that 5 to 35 in 100 offer rows are red in every pro cell. A colour that never changes
  is noise.

## 4. The class as a decision: the critic's list, one by one

### 4.1 "To reach 10/10"

| # | The critic asked | Answer | How, and which number it moves |
| :--- | :--- | :--- | :--- |
| 1 | A THIS DIVISION row at signing | **Take** | One row in `RecruitPanel.build`, so the walk-in interview and the trial both get it, and one short line on the prospect card (`Fighters._scouting`). Three facts: "Stopped early here: about N in 100 amateur bouts, M in 100 as a pro" (the cell's two measured rates); "Chin 52 against this field's punch 61" (the boxer's `RingDuel.side` chin against the mean punch of the division's pool); the read: **protect early** (chin 6 or more under the field's punch), **can be moved fast** (6 or more over), **a puncher here** (own punch 6 or more over the field's chin). Six points is half of the 12-point scale: 1.65 times the count chance (ESTIMATE). For a scouted prospect the chin is a range of plus or minus 5, so the read can say "protect early, or fine: the trial tells". It moves whom the player signs, and which starting focus is picked on the same card. |
| 1b | (added) The same row on the turn-pro call | **Take** | `ProOffer.build` gets one line: "As a pro here about M in 100 end early; as an amateur N." plus the chin read against the PRO field. This is the largest real step in the evidence (section 2) and the buttons already exist: sign, or Stay amateur with declines left. It moves when a thin-chinned boxer turns pro. |
| 2 | Run the baseline probe before the next map | **Take, as the next task, not in this file** | This task may not run Godot. Section 5 is the probe. Three cells are already measured (section 1.5). v4 replaces every ESTIMATE here with the probe's number. |
| 3 | Decide club against elite | **Take: club** | Section 3.2. Women's amateur `count_mult` is 1.00, so the first walk-in's bouts keep their towel card and their 9 in 100. |
| 4 | Keep the towel a choice in every division | **Take the second form** | The lines stay 12 / 20 / 33: a corner judges absolute danger, and section 2 shows the amateur cells are close together, so the collapse the critic feared is an amateur-against-pro matter. `FightPrep.towel_row` adds to each button "the card comes about 1 fight in N here" (the probe's measured share for that cell and line). `Towel.words` adds "A usual round here: U in 100." Test: in every cell the three lines bring the card on shares at least 3 points apart; a cell that fails gets its own lines at 0.6 / 1.0 / 1.6 of its usual, and only that cell. |
| 5 | Two knobs, not three; state the clamp; scale the live adders or prove parity | **Take, further: one knob** | Section 3.1. No clamp is touched. Parity is a probe bound: the watched path and the world path within 5 points in the same cell. |
| 6 | One `cell_of` for three shapes, a test that fails on a fallback | **Take** | Section 3.3: four shapes, one cell per bout, no silent 1.0. The ladder entry carries no sex, div or limit (`Matchmaking.gd:67-70`); the pair rule covers it. |
| 7 | Fix every shown number; wire `LateAskWire`; one `word_for` | **Take** | Section 3.5. |
| 8 | Say it in the Why | **Take** | One sentence pushed into the bout's reasons in `BoutFinish.run` (it already pushes lines to the front of `why`, `BoutFinish.gd:75-82`) when the bout was stopped or a towel came in: "Stopped in round 4. Bouts here end early about N in 100; tonight the punch was 12 points over the chin." Roles, not names ("your boxer", "the opponent"). `FightWhy._count_line` already stays silent on a stopped bout (`scripts/rules/FightWhy.gd:259-263`), so nothing is said twice. Not added after a distance bout: nothing to act on. |
| 9 | Chin's worth on the week board and the perk road | **Take the perk road; refuse the week board** | Perk road (`FighterPage._tab`): Iron chin and Finisher get a tail from the cell, "a count comes about 1 bout in N here". It moves which perk the mornings train toward. The week board has no chin row today (no "chin" or "durability" in `scripts/ui/WeekBoard.gd`); adding one is a new screen element. The camp line of 4.2 item 3 does that job where the camp is chosen. |
| 10 | Name the follow-up: moving a class | **Take** | Section 4.3. |
| 11 | Correct F1 to F13, strip line numbers, F13 first | **Take** | Section 1.6. F13 is fixed on main. The members, loyalty, lesson and ladder treatment of a towel (section 1.4) is listed for the main session, not decided here. |

### 4.2 The five missing options

| # | Option | Answer |
| :--- | :--- | :--- |
| 1 | A division read at signing | Taken: 4.1 rows 1 and 1b. |
| 2 | A division line on the towel row | Taken: 4.1 row 4. |
| 3 | A style read that names the division | **Take**, on the camp card of fight prep (`FightPrep._camp_card`, `FightPrep.gd:190`; body not opened for this map): "Chin 58 against this opponent's punch 66. Four more chin this camp: about X fewer stoppages in 100 here." X = the ask card's chance for this gap in this cell times 0.28 (four points of chin cut the count chance by 28%: exp(-4 / 12), `Knockdowns.gd:11, 34`). It moves what the camp trains. |
| 4 | Moving up or down a class | Named as the follow-up: 4.3. |
| 5 | The Why after the fight | Taken: 4.1 row 8. |

### 4.3 The follow-up this mechanic exists to price: moving a class

Not built by this map; it gets its own (MOVECLASS1). What is already there: a boxer has a walking `weight` and a `limit`
(`Data.PROSPECTS`: 58.3 kg against 57, 65.9 against 65), each sex has a ladder of limits (`Data.DIVISIONS`), and the pro table
is picked from the limit at 57.5 / 62 / 70 (`ProLadder.division_for`). So the natural moment is the turn-pro call: a 60 kg
amateur is a pro lightweight by default and could be offered welterweight.
- Up a class: an easier weight week, a bigger field. The boxer's punch and chin are read against a heavier pool, and the cell's
  `count_mult` is the next one up. Good for a boxer who is "a puncher here" by a wide margin, bad for "protect early".
- Down a class: a hard cut before every bout, a smaller field. Punch reads better, the tank reads worse on the night.
- What the move would need that no code has: the ladder place and points in the new division, a new rival pool, what the record
  is worth there, and a real-world number for how punch and chin change with a 5 kg step (UNVERIFIED today; v2 named papers
  that are not in the study it cited).
- Where the button would live: the turn-pro call and the fighter page beside the weight line.

### 4.4 The critic's "useless or harmful as written"

- `class_stop` as a third number: gone, and `punch_mult` with it.
- The 4-round share "matching `rounds_for`": gone. The world arm uses 6 / 8 / 10 as `rounds_for` gives them; 4 rounds are
  measured on the player path only.
- Fixed colour lines: made relative (section 3.5).

## 5. The probe that sizes the numbers (before any board)

`tools/dmg_class_probe.gd` (TO BUILD; it does not exist). Base: the player-bout loop of `tools/stop_word_probe.gd`
(CRITIC-CHECKED: its `_fight` plays `Bouts.fight_step` to the end and restores the pool) plus direct `WorldBout.fast` calls.
It writes `docs/DMGCLASS1_BASELINE.md`. It runs headless through the Godot slot, never in a design session.

**Arms.**
1. CONTROL: today's rules (every `count_mult` 1.0). Same build, same seeds. It cannot share the new code's bugs because the
   new key is absent.
2. FIT: the seven numbers of section 3.2.
3. MUTANT: FIT with one cell's number doubled. That cell's bound must FAIL. A probe that cannot read worse proves nothing.
The control is expected to FAIL the sex separation in the pro cells (today nothing can separate them). If the control passes
every bound, the instrument is blind and the run is void.

**Populations**, each named with its catalogue in the output:
- P1, made pairs: two different `AttrGen.generate` profiles (different seeds, never the same archetype twice in a pair: no
  identical fighters), set at rating gaps -8, -4, 0, +4, +8. This separates the RULE from who happens to be in a pool.
- P2, the real pools: the amateur rivals of each division as the career holds them (4 to 11 names: the n is printed, a small
  pool is reported as small, never padded with repeats), and `WorldGen.generate(seed)`'s 35 boxers per pro table.
- Only legal bouts: one sex, one division per bout.

**Paths.** `WorldBout.fast` at 3 rounds (as `Region._rival_bout`), at 6 / 8 / 10 as `WorldSim.rounds_for` picks them, and at 6
(as `Matchmaking.fight`). The player bout at 3 rounds (amateur) and 4 / 6 / 8 / 10 (pro), once with the towel line normal and
once with the corner never pulling, so referee stoppages are not hidden behind towels. `WorldBout._cache` is emptied between arms.

**Printed per row:** population, catalogue, cell, path, rounds, n, bouts with a count, stopped, RSC / KO / RTD split, our boxer
stopped, mean head damage, liver share of counts, towel card share at careful / normal / brave, the bound, PASS or FAIL.

**Bounds** (ranges, never an exact count):

| Bound | Range | From |
| :--- | :--- | :--- |
| Women's amateur, level pairs, stopped | 5 to 12 in 100, in both arms | John, COUNTED; today's test band |
| Women's amateur, three weight rows | within 3 points of each other | John, COUNTED |
| Men's amateur, level pairs, stopped | 6 to 16 in 100; middle not under light | UNVERIFIED: a John brief first |
| Women's pro, the world's season mix | 22 to 34 in 100 | AAN 2025 |
| Men's pro, the same | 40 to 54 in 100; never under the women's row of the same class | AAN 2025, G108 |
| Women's over men's, pro | 0.50 to 0.75 | 29 / 47 = 0.62 |
| Middle over feather, per sex, pro | 1.0 to 1.4 | UNVERIFIED |
| KO share of stoppages, pro cells | reported; 8 to 30 expected | women's pro 5 of 29 |
| Counted bouts per stopped bout | reported, not a gate | John's own guess |
| Liver share of counts | 10 to 20 in 100, and within 3 points of the control | `docs/LIVERPROBE1_RESULT.md` |
| Watched path against world path, same cell | within 5 points | the critic's problem 3 |
| Towel card share, the three lines, each cell | pairwise at least 3 points apart; on normal between 5 and 60 in 100 bouts | section 4.1 row 4 |
| Ask-card word, each amateur cell | each word's measured chance inside its band (under 8, 8 to 20, over 20) | `StopWord.gd:8-9` |
| Red offer rows, each pro cell | 5 to 35 in 100 | section 3.5 |
| The same seed twice | the same table | the only seed reuse |

**The fit rule.** One number per anchor: target middle divided by the control's measurement, rerun, at most three rounds. A
slope is set only where the made pairs show the bound failing without it. No per-division hand numbers.

**What the control alone already decides.** If today's pro bouts sit near 29 to 47 through rounds alone, the pro anchors are near
1 and the mechanic is mostly the reads of section 4. If they sit far off, the anchors do real work. Either result is an answer.

**Before the fit, one research task:** a John brief to check the men's amateur rates and the by-weight slopes against sources
that can be opened (England Boxing championship results, BoxRec by division). Until then those three numbers stay UNVERIFIED
and their bounds stay wide.

## 6. Every menu the mechanic appears on

| Menu | CODE TODAY | TO BUILD | Wired to |
| :--- | :--- | :--- | :--- |
| Fight night: counts and the referee | `BoutNight.count_sides` sets only the perk's `stop_mult`; `Knockdowns` reads no class | `count_sides` adds `count_mult` from OUR boxer's cell to both sides; `Knockdowns` multiplies the two count chances | `ClassDamage.cell_of` |
| The world, rival bouts, the simulated pro bout | `WorldBout._side` = power, chin, heart | The three places that build sides add the pair's cell | `ClassDamage.cell_of_pair` |
| Reception: the walk-in interview | `Interview.build` shows `RecruitPanel`; no stoppage word | THIS DIVISION row: two rates, chin against the field, the read | `ClassDamage.usual(cell)`, the division pool's mean punch |
| Find a fighter: the prospect card | Age, class word, style, note, scouted ranges | One line: the read as a range | the same, with the scouted plus or minus 5 |
| The trial | `Trial.build` shows `RecruitPanel` | The same THIS DIVISION row, exact after the trial | the same |
| The turn-pro call | Record, days, declines, tickets, terms | "As a pro here about M in 100 end early; as an amateur N" and the chin read against the pro field | `usual` of the amateur and the pro cell |
| Amateur ask card and late-ask card | `StopWord.word(gap)`, the same in every division | Both callers pass the cell's shift | `ClassDamage.gap_shift` |
| Pro fights: the offer rows | Three fixed colour lines; `stop_chance` with 0.25 and 0.1 | Colours relative to the cell; the two fallbacks from the cell | `usual`, `ko_share` |
| A new world's records | KO share centred on 0.3 everywhere | Centred on the cell's `ko_share` | `ko_share` |
| Fight prep: the towel row | "Careful (12 in 100)" and so on, fixed | Each button adds "the card comes about 1 fight in N here" | the probe's per-cell table in `ClassDamage` |
| The corner: the towel strip | "Stopped next round: N in 100 (Box safe: M in 100). Your line: L." | Adds "A usual round here: U in 100." The risk itself moves by itself through the sides | `Towel.risk` (already wired), `usual` |
| Fight prep: the camp card | No stoppage line | "Chin against this opponent's punch; four more chin = about X fewer stoppages in 100 here" | the ask card's chance for the gap, the cell |
| The plan test and the fix lab | Play the real bout | Nothing: they read the new sides by themselves | `count_sides` |
| The fighter page: the perk road | Iron chin and Finisher with fixed words | A tail on those two rows: "a count comes about 1 bout in N here" | the probe's count share per cell |
| The result page: the Why | No sentence about the division | One sentence after a stoppage or a towel | the cell's `usual`, the night's punch over chin |
| Rest, stand-down, injuries, wear | No class anywhere | **Nothing.** Damage is not scaled, so nothing reaches them | - |
| The week board | No chin row | **Nothing** (refused, 4.1 row 9) | - |
| A weight-class switch | Does not exist | **Nothing here**: the follow-up map (4.3) | - |

Owner rulings kept: females never fight males and booking matches the weight class (the one-cell-per-bout rule depends on
both, and the probe books only legal bouts); names only in headers (every new line says "your boxer", "the opponent", "here");
only actionable information (each new line sits beside the button it informs: sign or pass, turn pro or stay, the towel line,
the camp, the perk; nothing is added after a distance bout or on the rest screens); a real-world source for every number, and
where the source has not been opened the number is marked UNVERIFIED and held behind a research task.

## 7. Order of work

1. DMGPROBE1: build the probe, run the control arm, commit `docs/DMGCLASS1_BASELINE.md`. In parallel, the John brief on the men's
   amateur rates and the weight slopes.
2. Map v4: this file with the ESTIMATEs replaced by the control's numbers, then two fresh critics. The board only at 7 or more.
3. DMGCLASS1: `ClassDamage.gd`, the two lines in `Knockdowns`, `count_sides`, `WorldBout`, the lookup test, the fit arm.
4. DMGREAD1: the shown numbers of section 3.5.
5. DMGSIGN1: the THIS DIVISION row (interview, prospect card, trial, turn-pro call), the towel row, the camp line, the perk
   road, the Why. One golden-path test walks them.

## 8. Files opened for this map

`scripts/rules`: Knockdowns.gd, Towel.gd, StopWord.gd, StandDown.gd (whole); Attrs.gd, AttrGen.gd, InjuryRoll.gd, Matchmaking.gd,
PerkFight.gd, PerkRoad.gd, CoachRead.gd, FightWhy.gd, FirstHour.gd, Exchanges.gd, Adaptation.gd, Loyalty.gd, BoutRules.gd (the
functions and constants cited).
`scripts/state`: TowelWire.gd (whole); BoutFinish.gd (30-239), BoutNight.gd (196-300), Data.gd (128-270), Injuries.gd (165-220),
RingDuel.gd, ProLadder.gd, AskFlow.gd, LateAskWire.gd, Region.gd, Roster.gd, LiveRound.gd (306-360, working copy).
`scripts/world`: WorldBout.gd (32-48, 85-100, 116-243, 322-328), WorldSim.gd (136-195), WorldGen.gd, WorldAge.gd (117-123).
`scripts/ui`: TowelStrip.gd (whole); ProFights.gd (168-228), FightPrep.gd (74-100), RecruitPanel.gd (33-56), modals/Trial.gd,
modals/ProOffer.gd (1-60); by search: modals/Interview.gd, areas/Fighters.gd, areas/FighterPage.gd, AskPanel.gd, LateAskCard.gd,
OfferCard.gd, WeekBoard.gd.
Other: assets/data/world/divisions.json, tests/knockdowns_test.gd (36-52), tests/bout_stoppage_test.gd, tests/towel_wire_test.gd
(by search), docs/STOPWORD1_RESULT.md, docs/LIVERPROBE1_RESULT.md, ops/research/J_KDRATES1_JOHN.md,
ops/research/RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md, ops/research/topics/knockdowns_stoppage.md.
Not opened (their claims above are marked CRITIC-CHECKED or left out): LiverFold.gd, CrackWire.gd, CounterCut.gd, FightLearn.gd,
PlanTest.gd, FixLab.gd, PullOutWire.gd, BoutCompare.gd, Duels.gd, the bodies of FightPrep._camp_card and BoutRules.why,
tools/stop_word_probe.gd beyond its header. No real-world source was opened on the web for this map: the COUNTED rows are a
seat's counts with their links, to be checked before a number ships.

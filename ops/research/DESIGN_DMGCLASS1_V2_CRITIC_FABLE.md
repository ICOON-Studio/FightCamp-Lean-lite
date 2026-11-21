# DMGCLASS1 v2 - critic review with a code check (Fable console, S534)

Critic: a fresh Fable session in the checkout. Brief: `ops/research/DESIGN_DMGCLASS1_V2_CRITIC_KALLI.md` (critic pack + the map),
task `ops/research/TASK_DMGCLASS1V2CRIT.md`. Research only: no game code changed, Godot not run. Every CODE line of the map was
checked against the working tree on 2026-11-21 (main at b471c59f4; `scripts/state/LiveRound.gd` carries another session's
uncommitted edits, so its line numbers are that working copy's).

## Scores

| | Score | One-line reason |
| :--- | :--- | :--- |
| DEPTH | **5 / 10** | It adds no choice. It re-prices five choices that exist, and at both ends of the table it removes one. |
| GENERAL DESIGN | **6 / 10** | Right dial, right files, honest "measure first". But about ten CODE facts are wrong, the key the new file is looked up by does not exist in one shape, and three shown numbers are missed. |
| PLAY | **4 / 10** | The player sees nothing new. In the normal start (a women's lightweight walk-in) it makes fight night quieter. |

Not at the bar (7+ depth, 7+ general design). Another round, not the board.

### DEPTH 5 - why
- The class is fixed at signing, and the map says so and touches nothing there. So the ONE moment where class is a real pick
  (whom to sign, and into which division) gets no read, no number, no word. Everything after is context, not choice.
- The "five real choices" are today's choices with different numbers behind them. That is worth having, but the proof that the
  numbers move is almost all `ESTIMATE` (16% vs 62% KO share, 5-10 vs 24-36 in 100 on the towel, 4-9% vs 20%+ on a
  replacement). Nothing in section 3.2 is measured; the probe that would measure it is slice 1 of the build.
- At the ends the choice flattens instead of deepening. The towel lines are fixed at 12 / 20 / 33 in 100
  (`Towel.gd:11`). If a women's featherweight amateur is stopped 1.0-2.5% of bouts, the next-round risk almost never reaches
  12: Careful, Normal and Brave become the same button and the towel card stops coming. In men's pro middleweight at 48-55%
  the card comes most rounds and Careful means "retire". The map calls this depth; it is one choice deleted at each end.
- Same for the no-sparring stand-down: with `punch_mult` under 1 a light women's bout nearly always lands in the 5-day band
  (`StandDown.gd:10`), so the 10 and 21 day bands stop happening for half the roster.
- Choice 5 (chin and heart vs engine and jab) is the strongest idea: the value of +4 chin really would differ by division.
  But the player never sees it; nothing on the week board or the perk road says "in this division chin is worth more".
- What each option changes (owner S403), as the map states it: offer / ask card = stoppage risk shown on the card; towel line =
  when the card comes; plan lines = hurt and finish odds; pull-out answer = risk on the replacement; camp targets and perks =
  value of chin. All five are indirect. None is a new button.

### GENERAL DESIGN 6 - why
- Good: v2 moved the dial from the label (`Matchmaking.stop_chance`) to where bouts end (`Knockdowns`, `BoutNight.count_sides`,
  `WorldBout`). That is correct, verified below. Keeping `stop_mult` for perks and adding separate keys that default to 1.0
  is correct and keeps `tests/stop_mult_test.gd` green (verified: the test asserts 1.0 without perks and "moves the referee,
  not the count").
- Good: rest, suspension and wear take no class number. Verified in code: none of those functions reads sex or class.
- Problem 1, the lookup key. The map keys `ClassDamage` by `(sex, div_id, pro)` and reads `boxer.get("sex")`,
  `boxer.get("div")`, `boxer.get("limit")`. The code has three different shapes:
  - a signed boxer: sex `"f"` / `"m"`, div = the AMATEUR id (`"wlw"`) for life, limit in kg (`Data.gd:260-261`). A pro
    still carries the amateur id; the pro table is worked out from the limit each time (`ProLadder.division_for`, `ProLadder.gd:43-49`).
  - a world boxer: sex `"women"` / `"men"` (from `divisions.json`, `WorldGen.gd:86, 160`), div = `"w_lw"`, and NO `limit` key
    (`WorldGen.gd:155-185`).
  - the opponent dict inside a bout, and the player's ladder entry that `Matchmaking.fight` passes to `WorldBout.fast`
    (`Matchmaking.gd:204-206`): not checked to carry sex or div at all.
  A missing key silently gives 1.0, so a wrong lookup is a class-blind bout that no test notices. The map needs one
  `ClassDamage.cell_of(dict, pro)` that accepts all three shapes, and a test that fails on a fallback to 1.0.
- Problem 2, three knobs per cell fitted to one hard number. 17 cells x (`punch_mult`, `count_mult`, `class_stop`) = 51
  fitted numbers. Per cell there is one sourced target (stop %), one sourced ratio (2-4 counted bouts per stoppage, itself
  "his guess" in `Knockdowns.gd:3-4`) and one `ESTIMATE` (clean-KO share). And `punch_mult` acts in three places at once
  (round damage, the in-round hurt roll, the world's hurt edge). The fit is under-determined: many triples hit the same band.
  The map needs a rule that picks one (for example: `count_mult` = `punch_mult`, fit two numbers, not three).
- Problem 3, damage the dial does not touch. In a watched bout a large share of head damage is added by live events, not by
  `Knockdowns.DAMAGE_PER_ROUND`: the free counter (15, `PerkFight.gd:24`), a landed set-up, clinch and guard bleed
  (`LiveRound.gd:313-359`). The map scales only the per-round table. So a watched bout and `WorldBout.fast` (which has none of
  those adders) will sit at different points of the same band, and the fit on one path will be off on the other.
- Problem 4, the clamp. The hurt roll is `clampf(0.3 + (power - chin) / 100, 0.1, 0.6)` (`RingDuel.gd:383-386`). The map says
  "multiply by `punch_mult`" but not inside or outside the clamp. Inside, a floor of 0.1 makes a light class's 0.5x do nothing
  for an even pair; outside, the floor and ceiling move. It must be stated.
- Problem 5, three shown numbers missed (section 2.4 says "every shown stoppage number reads the same factor"):
  - `"Stopped N of the M beaten"` on the pro row turns red at 40% and amber at 20% (`ProFights.gd:176-178`): fixed lines.
  - `"Stopped: N% chance; then out W weeks, and damage"` turns red at 15% and amber at 7% (`ProFights.gd:221-223`).
  - the coach's read on a pro row names "a N% chance of being stopped" from 7% up (`CoachRead.gd:168-181`, fed at `ProFights.gd:183`).
  With class rates of 16% to 52% these fixed lines mean every men's middleweight row is red and no women's featherweight row
  ever is. A colour that never changes is noise (owner S398: only what the player can act on).
  - the late-ask card also prints the stoppage word (`LateAskWire.gd:125`, `LateAskCard.gd:28`); the map wires only `AskFlow`.
- Problem 6, the map contradicts itself on `StopWord.word_for`: section 2.4 gives `(gap, stop_factor := 1.0)`, a multiplier,
  then describes a shift of the gap; section 6 gives `(gap, shift := 0.0)`. One of them.
- Problem 7, the sources mix populations. The amateur bands come from world championships and the Olympics (elite brackets).
  The game's amateur bouts are club shows, and the code is tuned to "women's club/national amateurs 5-12 bouts in 100 stopped"
  (`Knockdowns.gd:3`, John J-KDRATES1), pinned by `tests/knockdowns_test.gd:49` at [0.03, 0.12]. The map's women's lightweight
  target of 1.5-3.5% is the elite number and sits under John's club band. The two studies disagree and the map does not say
  which wins. (I did not re-check the SQ257 table number by number against `RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md`.)
- Useless as written: the "Pull-out card" row (show the word on the replacement) is fine but tiny; the "Fighters - scouting"
  row says "touch nothing", which is the one place the mechanic would be a decision.

### PLAY 4 - why
- Week to week the player gets nothing to look forward to. No new card, no new moment, no reward. The mechanic is a
  correction to the simulation.
- The normal game starts with a women's lightweight at reception. Today that boxer's bouts carry a real stoppage chance and
  a towel card. Under the map her division drops to 1.5-3.5%: the first ten hours of the game lose their most dramatic event.
- The pay-off (heavier and men's divisions are more dangerous) only arrives if the player signs such a boxer, and the game
  never tells the player that this is what they are signing.
- Real-world support for making it felt: trainers do pick fights differently by division. A featherweight prospect is
  moved fast because losses are mostly on points; a middleweight with a soft chin is protected. That is a managing choice the
  game could own, and the map stops one step short of it.

## Missing options (owner S403)
1. **A division read at signing.** On the walk-in card and the scout card: "Stoppages in this division: rare / common / the
   norm", plus what it means for this boxer's chin. Changes: whom the player signs.
2. **A division line on the towel row.** "In this division the card comes about 1 fight in N." And towel lines that are set
   per division (or shown as "x the division's usual risk") so the three buttons stay three different answers. Changes: the
   towel stays a choice at both ends.
3. **A style read that names the division.** On Fight prep: "Middleweight: one clean shot ends it. Chin 58 is below this
   division's punchers." Changes: what the player trains this camp.
4. **Moving up or down a class.** The map forbids it because the code has none. It is the natural player choice for this
   mechanic (cut harder to be the bigger puncher in a safer class, or go up for the purse). Out of scope for v2, but the map
   should name it as the follow-up that makes class a decision, not rule it out.
5. **The Why after the fight.** A line such as "Stopped in round 4: at middleweight a 12-point power edge ends it 1 time in 3."
   The pack's hook is that every swing has a readable reason; the map adds a hidden multiplier and no words.

## Useless or harmful as written
- `class_stop` as a third fitted number per cell (see Problem 2).
- The 4-round share in the pro probe mix "matching `WorldSim.rounds_for`": that function never returns 4.
- Fixed colour lines on stoppage numbers once the class factor exists (Problem 5).

## The CODE claims, checked

Verdict words: **TRUE** = the code does what the map says at that place. **TRUE, lines moved** = the code does it, the line
numbers are wrong (real place given). **FALSE** = the code does something else. **NOT FOUND** / **NOT CHECKED** as written.

Summary: about 75 claims. Substance TRUE in about 60. **Line numbers wrong in most of them** (often by 10-150 lines), so
no build brief may copy a line number from the map. **13 FALSE in substance**, listed first (F13 is also a live game defect).

### FALSE in substance (fix the map before a build brief quotes it)

| # | Map says | Code really does |
| :--- | :--- | :--- |
| F1 | `Matchmaking.stop_chance` "is called in only two places": `ProLadder.gd:229` and `ProFights.gd:213` | Three call sites: `ProLadder.gd:228` (offer_axes), `ProFights.gd:183` (into `CoachRead.pro_read`), `ProFights.gd:221`. Line 213 is a column add. |
| F2 | `ProFights._row` formats `"Stoppage %d%%"` | No such string in `scripts/`. The label is `"Stopped: %d%% chance; then out %d weeks, and damage"` (`ProFights.gd:222`), with colour lines at 15% / 7%. |
| F3 | `TowelWire.card` "already calls `BoutNight.count_sides(f, opp)` (`TowelWire.gd:51`)" | `TowelWire` never calls it. The sides are PASSED IN by `BoutNight._shout` (`BoutNight.gd:220`); `TowelWire.gd:9` says so. Outcome is the same (the towel reads count_sides' dict), the wiring claim is wrong. `TowelWire.state` also adds the Slugger power itself (`TowelWire.gd:37`). |
| F4 | `Second wind` gives "+18 round-3 energy" | `SECOND_WIND := 10.0` (`PerkFight.gd:14`), round 3 (`:15`). |
| F5 | `Matchmaking.next_weeks`: "6 / 8 / 10 weeks base"; "points bouts turn around in 6-10 weeks" | 6 / 8 / **12** (`QUICK_WEEKS 6, NEXT_WEEKS 8, HARD_WEEKS 12`, `Matchmaking.gd:30-32`). +8 on a stopped loss is right (`:33`). |
| F6 | `WorldGen` makes "45 boxers per division" | 35: `RANKED_PER_DIVISION 20 + UNRANKED_PER_DIVISION 15` (`WorldGen.gd:20-21, 87`). The entry point is `WorldGen.generate(seed)` (`:27`), not `WorldGen.new().generate_world` at `:36`. |
| F7 | Pro probe mix "4r 30% ... matching `WorldSim.rounds_for`" | `rounds_for` returns 10 / 8 / 6 for pros and 3 for a table whose id starts `a_` (`WorldSim.gd:161-165`). Never 4. Four rounds exist only on the player's side (`ProLadder.ROUNDS_UNRANKED`, `ProLadder.gd:33`). |
| F8 | World sides come from `boxer.get("sex")`, `boxer.get("div")`, `boxer.get("limit")` | World boxers have no `limit`; their sex is `"women"` / `"men"`, a signed boxer's is `"f"` / `"m"`; a signed pro's `div` is still the amateur id. See Problem 1. |
| F9 | The hurt situation is entered at `Exchanges.gd:145-149` | Those lines are clue sentences. The state is set in `Exchanges.situation` (`:194-196`) and `Exchanges.next_mode` (`:269-272`). `EXCHANGES := 6` is at `:10`, not `:5`; `HURT_AT := 30.0` at `:54`. |
| F10 | `AttrGen.age_wear`: "-2.0 annual durability drop (`AttrGen.gd:169-170`)" | Not annual: `STOP_CHIN (2.0) x stoppage losses`, once per loss, then re-centred (`AttrGen.gd:67, 180-183`). |
| F11 | `CounterCut.cut(b, cut_at)` at `CounterCut.gd:20-35`, `stopped` at line 33 | The function is `CounterCut.apply(beats, rng)` (`:19-32`), `moved["stopped"] = true` at `:29`. The point stands: it is animation only. |
| F12 | `StopWord.word_for(gap, stop_factor := 1.0)` (2.4) and `word_for(gap, shift := 0.0)` (6) | Two different signatures for a function that does not exist yet. `StopWord.word` is also called from `LateAskWire.gd:125`, which the map never lists. |
| F13 | A towel retirement (`RTD`) skips `Attrs.wear_stoppage`: "zero `STOP_DROP`", "saves 2.0 `durability_cap`" (sections 3.2 and 5, and the `towel_test` row of 2.5) | It does NOT skip it. `BoutFinish.run` wears the chin on every loss with `stop != ""` (`BoutFinish.gd:63, 99-102`), and `"RTD"` is such a loss (`:50`); nothing in the file excepts it (the only `RTD` in `BoutFinish.gd` is line 50). The same `stop != ""` also charges 2 members (`:103`) and tells the pro ladder it was a stopped loss (`:110`, so +8 weeks). Only the injury roll and the KO history are skipped (`Injuries.gd:181-182`). The towel's own rule says `"wear": false` (`Towel.gd:125`) and `tests/towel_wire_test.gd` does not check the cap, so **the game is wrong against its own rule**: a defect for the main session, and the map's second choice (the towel) is priced on a saving the player does not get today. |

### Fight-ending code (sections "Why v1 failed", 2.2, 2.3)

| Claim | Verdict | Real place |
| :--- | :--- | :--- |
| `Matchmaking.stop_chance` = (1 - win chance) x max(0.1, ko / w), 0.25 with no wins; decides no bout | TRUE | `Matchmaking.gd:272-275` |
| `RingDuel.side` = 0.7 power + 0.3 accuracy, chin, heart | TRUE, lines moved | `RingDuel.gd:138-139` (map: 204-206) |
| `RingDuel.settle` hurt rolls: margin over 30 and clamp(0.3 + (power - chin) / 100, 0.1, 0.6), or a landed set-up; ours x talk x 1.6 on a missed set-up or read, clamp to 0.8 | TRUE, lines moved | `RingDuel.gd:383-386` (map: 375-378); settle starts `:356` |
| Hurt strips `HURT_DEF 8.0 x (1.2 - composure / 100)` off guard, head movement, footwork | TRUE, lines moved | `Duels.gd:75, 145-148` (map: 88, 141-143) |
| `WorldBout._hurt_edge`: `HURT_BASE + last / 90 + (power - chin) / 60` | TRUE, lines moved | `WorldBout.gd:92-97`, constants `:27-31` |
| `BoutNight.count_sides` sets only `stop_mult` from the other side's Finisher | TRUE, lines moved | `BoutNight.gd:236-240` (map: 246-250) |
| `BoutNight._counts`: sides, Slugger power, round_counts, iron chin, liver fold, puncher's chance | TRUE, lines moved | `BoutNight.gd:245-290`; knock_power `:249`, iron chin `:256-261`, LiverFold `:266`, puncher_chance `:270` (map: 256-295, 258, 264-269, 272, 275) |
| `Knockdowns.round_counts`: damage 8 / 18 / 32 to the loser, 2 to the winner | TRUE | `Knockdowns.gd:13-14, 30-32` |
| Count chance `0.05 x margin x exp((power - chin) / 12) x (1 + damage / 60)`, cap 0.85, up to 3 rolls at x0.6 | TRUE | `Knockdowns.gd:34-47` |
| Referee: only after a count; `0.2 x (1 + damage / 60) x (1.4 - heart / 100) x stop_mult`, cap 0.9; KO needs damage 60 and `(1 - heart / 100) x 0.7` | TRUE | `Knockdowns.gd:53-59` |
| 3 counts in a round or 4 in the bout = RSC even when the referee roll fails | TRUE | `Knockdowns.gd:7-8, 61-62` |
| `puncher_chance`: base 0.05 x 0.4, same referee roll reading the target's `stop_mult` | TRUE | `Knockdowns.gd:118, 121-138` (its count chance is capped at 0.5, which the map omits) |
| `PerkFight.stop_mult` = Finisher 1.5, else 1.0 | TRUE, lines moved | `PerkFight.gd:30, 64-65` (map: 16, 48-49) |
| `PerkFight.iron_chin` turns the first count into a stagger | TRUE, lines moved | `PerkFight.gd:47` (map: 24-31) |
| Live exchanges add counter, clinch, set-up, read and guard damage to `m["damage"]` | TRUE, lines moved | `LiveRound.gd:313-359` in the working copy (map: 268-323); `COUNTER_DAMAGE 15` at `PerkFight.gd:24` |
| `LiverFold.roll`: a body count; stops the bout only as the 4th count | TRUE, lines moved | `LiverFold.gd:33-64`, stop at `:59`; the 10-20% bar is in the comment at `:15-17` (map: 14) |
| `Towel.risk`: 200 seeded next-round trials through `round_counts` and `puncher_chance` | TRUE | `Towel.gd:23-64`; `TRIALS := 200` at `TowelWire.gd:20` |
| `Towel.LINES` 0.12 / 0.20 / 0.33; `PULL_DAYS 14`; morale -4 | TRUE | `Towel.gd:11, 13, 14` |
| `TowelWire.pull` sets `"RTD"`; `coach_pull` pulls on unanswered rounds | TRUE, lines moved | `TowelWire.gd:97-109`, `87-92` (map: 96-114, 79-93); `card` at `58-67` (map: 46-66) |
| The towel strip offers "Throw the towel / Box safe / Send out" | FALSE (words) | The buttons read **Pull out / Box safe / One more round** (`TowelStrip.gd:8-10`) |
| `CrackWire.answer` / `bell` set `"RTD"` / `"RTD_B"` | TRUE | `CrackWire.gd:18, 54-63, 84-98` |
| `PlanTest.run` plays 20 bouts through `BoutNight.play_out` | TRUE, lines moved | `PlanTest.gd:26 (SIMS 20), 64-, play_out at :93` (map: 31-67, :47) |
| `FixLab.run` calls `play_out` at `FixLab.gd:45` | TRUE, lines moved | `FixLab.gd:201` |
| `WorldBout.fight` / `cached` / `fast` build sides with `_side` = power, chin, heart only, and call Knockdowns every round | TRUE, lines moved | fight `116-168`, cached `177-190`, fast `206-237`, `_side` `324-325` (map: 109-143, 160, 173-204) |
| ... and nothing else calls `WorldBout.fast` but `WorldSim` and `Region` | FALSE (one missed) | Also `Matchmaking.fight`, 6 rounds (`Matchmaking.gd:204-206`) |
| `WorldBout.cached` | TRUE, with a trap | It STORES the sides in a cache keyed by id, name, shape, age and rounds (`WorldBout.gd:180-190`). A class factor put on the sides is cached with them: fine while class never changes, but the probe's "fit" pass must clear the cache between factor sets. |
| `WorldSim.simulate_bout` runs `WorldBout.fast`, adds `ko` and `record_stoppage_loss` on a stoppage | TRUE, lines moved | `WorldSim.gd:140-157`, `183, 189` in `_apply_bout_result` (map: 142, 167-174) |
| `WorldSim._roll_stoppage` is dead code | TRUE | Defined `WorldSim.gd:173-177`, no caller in `scripts/` |
| `Region._rival_bout` runs `WorldBout.fast(a, b, 3, rng)` | TRUE, lines moved | `Region.gd:168-170` (map: 172) |
| `WorldGen._make_boxer`: `ko_share = clamp(0.3 + explosiveness / 30, 0.05, 0.75)`, blind to sex and class | TRUE, lines moved | `WorldGen.gd:150-151` (map: 153-154) |
| `BoutFinish.run` writes `m["stopped"]`, wears the chin on a stoppage loss, calls ProLadder, Injuries, AfterFight | TRUE, lines moved | run `:56`, stopped `:63-64`, `wear_stoppage :102`, `ProLadder.result :110`, `Injuries.after_bout :217`, `AfterFight.book :218` (map: 33-155, 67, 79, 146) |
| ... wear only on "non-RTD" stoppage losses | FALSE | See F13: an RTD loss is worn too (`BoutFinish.gd:99-102`). |

### Class, divisions and the "fixed class" claim (sections 1, 3.1)

| Claim | Verdict | Real place |
| :--- | :--- | :--- |
| 9 amateur divisions: women 57, 60, 65, 70, 75; men 55, 60, 70, 75 | TRUE | `Data.gd:136-155` (exact) |
| 8 pro divisions with limits 57.0 / 61.2 / 66.7 / 72.6 | TRUE | `assets/data/world/divisions.json` (the file is far longer than "1-12"). Note: men's welter and middle carry `pro_rounds 12` there, and nothing in the bout code reads it. |
| `Data.fighter_state` writes div, sex, limit once | TRUE, lines moved | `Data.gd:254-270`, the write at `:260-261` |
| `ProLadder.division_for`: 57.5 / 62.0 / 70.0 cut lines | TRUE, lines moved | `ProLadder.gd:43-49` (map: 46-52) |
| No code moves a signed boxer to another class | TRUE | Writes to div / limit: `FirstHour.gd:125` (the second walk-in), `SaveGame.gd:85, 145` (old saves), nothing else |
| Walk-ins at `FirstHour.gd:116-130`, scouted prospects at `Roster.gd:113-125` | FALSE (wrong places) | `FirstHour.gd:114-130` is `refuse()`; `Roster.gd:109-121` is `trial_read()`. The prospects table is `Data.gd:221-243` (TRUE). |
| `ProLadder.ROUNDS_*` at `ProLadder.gd:36-39` | TRUE, lines moved | `ProLadder.gd:33-36` (4 / 6 / 8 / 10) |
| `Exchanges` runs a fixed 6 exchanges a round for everyone | TRUE | `Exchanges.gd:10` |

### Shown numbers and choices (sections 2.4, 3.2, 6)

| Claim | Verdict | Real place |
| :--- | :--- | :--- |
| `ProLadder.offer_axes` trades chance, place, pay, weeks, stop | TRUE, lines moved | `ProLadder.gd:220-228` |
| Offers are tune / above / payday plus `ProLean.extra`; "above" is blocked at 2 ducks | TRUE, lines moved | `ProLadder.gd:204-214`; `DUCKS_BLOCK := 2` lives at `Matchmaking.gd:38` (map: `ProLadder.gd:212`) |
| `STOP_REST_WEEKS 8` at `Matchmaking.gd:15`; `STOP_COST 0.8` at `:25` | TRUE, lines moved | `Matchmaking.gd:33`, `:48` |
| `AskFlow.answers` calls `StopWord.word(gap)` | TRUE, lines moved | `AskFlow.gd:105-120`, the call at `:117` (map: 113) |
| `StopWord`: cut lines 0.0 and 8.0 for 8% and 20%; no preload | TRUE | `StopWord.gd:8-9, 15-16, 20-25` |
| `tests/stop_word_test.gd` fails if `StopWord.gd` contains `preload(` | TRUE, line moved | `:105` (map: 106) |
| `AskPanel` prints "Getting stopped: <word>." | TRUE, lines moved | `AskPanel.gd:112-116` (map: 109) |
| `FightLearn.teach_for` gives "0.0 growth if stopped" (`AskFlow.gd:185`) | FALSE (number) | A stopped loss loses the loss bonus and pays `STOP_COST` 0.8 (`FightLearn.gd:28-32`); `AskFlow.gd:180` then floors the result at 0. It is "at most the base growth minus 0.8, never below 0", not a flat zero. |
| `OfferCard.gd:26` shows `BoutRead.band` | TRUE, lines moved | `OfferCard.gd:85` |
| `BoutPage.gd:55` shows the win band | NOT CHECKED | The script is `scripts/ui/areas/BoutPage.gd`; not opened |
| `BoutCompare.offer_chips` "Strength gap" at `:103` | TRUE, lines moved | `BoutCompare.gd:178-190`, chip at `:183` |
| `FightPrep.towel_row` sets Careful 12 / Normal 20 / Brave 33 | TRUE | `FightPrep.gd:78-99` |
| `PullOutWire`: replacement at old rating + 5, twice the reputation; go home -6 morale; next month costs one favour, 28 days | TRUE | `PullOutWire.gd:37, 39, 87-110`; `FightWeekEvents.gd:10, 44-54`; reputation x2 at `BoutFinish.gd:98` |
| `STOPPED_LOSS_MEMBERS = 2` at `BoutRules.gd:88` | TRUE, lines moved | `BoutRules.gd:122` |
| Game plan: a "coach-capped rule budget" | TRUE | `BoutNight.arrow_limit` -> `PlanBoard.arrow_limit` (`BoutNight.gd:206-208`: 4 to 9 lines by coach) |
| Plan triggers named `losing`, `final_round` | NOT FOUND | No such strings in `scripts/rules`; not searched further. `GamePlan.gd` is a screen (`scripts/ui/GamePlan.gd`), not a rule file. |
| A missed set-up multiplies our hurt chance by 1.6 | TRUE | `RingDuel.gd:386` |
| "+4 chin cuts the count chance by 28%" | TRUE (arithmetic) | exp(-4 / 12) = 0.717, from `Knockdowns.gd:11, 34` |
| "+5 rating on a replacement multiplies count odds by about 1.5" | TRUE only if the +5 is all power | exp(5 / 12) = 1.52; a rating is not power alone |

### Rest, injuries, wear (section 5)

| Claim | Verdict | Real place |
| :--- | :--- | :--- |
| `InjuryRoll.ko_days` 30 / 90 / 365 | TRUE, lines moved | `InjuryRoll.gd:12-16, 42-56` (map: 34-48) |
| `Injuries.after_bout` skips an RTD; builds the head place from damage | TRUE, lines moved | `Injuries.gd:172-214`; RTD return `:181-182`; head place `:193` (map: 192-234, 195, 198) |
| `StandDown.make`: head = 100 - damage x 0.8; 5 / 10 / 21 days; nothing after a stoppage loss | TRUE | `StandDown.gd:7-10, 27-32`; called at `Injuries.gd:187` |
| `InjuryRoll.bout_chance` = 0.06 x rounds / 3 x (0.4 + 1.2 s) | TRUE, incomplete | `InjuryRoll.gd:7, 29-39`: also x a flexibility factor, capped at 0.4. Layoffs 14-56 days: TRUE (`:20`). |
| `Attrs.wear_stoppage`: -2.0 durability cap | TRUE, lines moved | `Attrs.gd:42, 127-129` |
| `WorldAge`: +0.5 years per stoppage loss | TRUE, lines moved | `WorldAge.gd:12, 119-122` |
| `Aftermath.toll`: +10 when stopped | TRUE, lines moved | `Aftermath.gd:26, 32`; `AfterFight.book` at `AfterFight.gd:38-45` |
| None of these reads sex or class | TRUE | none of the functions above takes or reads either |
| ... so "zero class multiplier on rest" | TRUE in the code, NOT in effect | `punch_mult` scales `m["damage"]`, which feeds the stand-down band, the head place (`Injuries.gd:193`), the injury roll and the towel's head read (`TowelWire.gd:54`). Class reaches rest through damage. The map says this on purpose; the row heading "None (1.0x)" hides it. |

### Tests and the probe (sections 2.5, 4)

| Claim | Verdict | Real place |
| :--- | :--- | :--- |
| `stop_mult_test`: 1.0 without perks, over 1.0 with Finisher, moves the referee not the count, 1.0 equals no key | TRUE | `tests/stop_mult_test.gd:21-23, 26-28, 35-37` |
| `knockdowns_test`: stop share [0.03, 0.12], count share [0.10, 0.25] | TRUE | `tests/knockdowns_test.gd:48-49` |
| `bout_stoppage_test`: 400 bouts, counts 3%-60%, stops from 1 bout to 20% | TRUE | `tests/bout_stoppage_test.gd:12, 55-56` |
| All ten listed test files exist; `class_damage_test.gd`, `ClassDamage.gd`, `dmg_class_probe.gd` do not yet | TRUE | `git ls-files` |
| `tools/stop_word_probe.gd` is lines 1-210, args parsed at 42-48 | FALSE (size) | 479 lines; args at `:46-50` |
| Its `_fight` loop (start, shouts, auto corner, end, restore the pool) | TRUE | `tools/stop_word_probe.gd:153-184` (the map's 154-184 is right) |
| `Bouts.fight_step`, `Bouts.stopped`, `Bouts.rounds_of`, `BoutRules.auto_corner`, `Career.quick_start` exist | TRUE | `Bouts.gd:399-411`, `BoutRules.gd:377`, `Career.gd:97` |
| Probe population: "`Career.quick_start()` seeded by base_seed" gives varied pairs | DOUBTFUL | quick_start builds one club with the fixed `Data.DIVISION_RIVALS` (`Data.gd:171`, loaded at `Career.gd:115`; each division names 3 opponents + a mismatch, `Data.gd:136-155`). 400 distinct legal pairs per amateur cell do not exist there; the probe will replay the same few pairs on new dice unless it generates boxers. The map must say which. |
| Runtime "25-45 s" for 13,600 bouts | NOT CHECKED | Godot not run (task rule) |

## Can it be built as written?
**No, not as written.** The core (sections 2.2 and 2.3: one pure file, three keys defaulting to 1.0, attached in
`count_sides`, `RingDuel.settle` and `WorldBout`) is sound and matches the code. These parts cannot be built from the text:
1. **The lookup** (F8): three dict shapes, no `limit` on world boxers, the amateur id kept by pros.
2. **Section 2.4, pro offer rows** (F1, F2): the callers and the label are wrong and three fixed colour lines are missed.
3. **Section 2.4, towel** (F3): harmless, but a brief that says "edit TowelWire.gd:51" edits the wrong line.
4. **Section 4.2, populations** (F6, F7, the quick_start row): 35 not 45, no 4-round world bouts, too few amateur pairs.
5. **`StopWord.word_for`** (F12): two signatures, one caller missed.
6. **The towel's price** (F13): the choice is described with a chin saving the code does not give.
7. **Every line number**: re-read at brief time.

## To reach 10/10 (most important first)
1. **Make class a decision at signing.** On the walk-in card and every scout card add one row, "THIS DIVISION", with three
   facts from the fitted table: how often bouts are stopped (a word, and N in 100), how this boxer's chin and power sit
   against the division's middle, and what that means ("protect early" / "can be moved fast"). This is the option the map
   lacks; it turns a hidden multiplier into the first choice the player makes about a boxer.
2. **Run the baseline probe before the next map version** and replace every `ESTIMATE` in section 3.2 with the measured
   number per cell. If the baseline already separates divisions (bigger boxers have more power minus chin), say how much is
   left for the factor to do. A v3 with measured numbers is a different document.
3. **Decide club vs elite.** State which study the amateur cells follow (John's club band 5-12 in 100 for women, in the code
   today, or SQ257's elite 1.5-3.5). Recommendation: club shows keep John's band scaled by class; the nationals use the
   elite band. Then the first walk-in's bouts keep their towel card.
4. **Keep the towel a choice in every division.** Either set the three lines per division (Careful / Normal / Brave =
   0.6x / 1.0x / 1.6x of the division's usual next-round risk) or keep 12 / 20 / 33 and show "the card comes about 1 fight
   in N here" on the towel row. Add a test: in every one of the 17 cells the three lines trip on different shares of rounds.
5. **Two knobs, not three.** Tie `count_mult` to `punch_mult` (or drop `class_stop`), state the rule that picks the fit, and
   say whether the hurt roll is scaled inside or outside its clamp. Scale the live damage adders (counter, set-up, clinch,
   guard) by `punch_mult` too, or prove with the probe that watched and world bouts land in the same band without it.
6. **One `ClassDamage.cell_of(dict, pro)`** that takes a signed boxer, a world boxer and a bout opponent, with a test that
   feeds all three and fails if any falls back to 1.0. Name what `Matchmaking.fight`'s ladder entry carries.
7. **Fix every shown number, not three of them.** Make the colour lines on `ProFights` (40 / 20, 15 / 7) and the coach read's
   7% relative to the division's own rate ("twice this division's usual" is red), and wire `LateAskWire` beside `AskFlow`.
   Pick one `word_for` signature.
8. **Say it in the Why.** After a stoppage, one line naming the division: "At middleweight a 12-point power edge ends it
   about 1 time in 3." After a distance loss in a light class: "At featherweight this goes to the cards 9 times in 10."
9. **Show chin's worth on the week board and the perk road.** Next to Iron chin and Finisher: "worth more in this division"
   / "rarely decides a fight here", from the same table.
10. **Name the follow-up: moving a class.** One paragraph: what it would cost (weight cut, power against chin in the new
    cell), where the button would live, and that it waits for its own map. It is the choice this mechanic exists to price.
11. **Correct F1-F13** and strip the line numbers down to function names; a build brief re-reads them. F13 first: fix `BoutFinish` so a towel retirement keeps the chin ceiling (and decide whether it costs 1 member or 2), with a red test in `towel_wire_test.gd`, before any towel number is fitted.

Needs something the game cannot do yet: item 10 (no code moves a class), and item 1's "division's middle" needs the
probe's per-cell table to exist first.

## My 10/10, as a 1920x1080 page
Not rendered (this task owns one file). Layout, in the game's serious-sim look, names only in the header:

- **Header (full width, 96 px):** boxer name, "MIDDLEWEIGHT, MEN'S AMATEUR, 75 kg", record. Nothing else carries a name.
- **Left column (560 px) - THIS DIVISION:** a vertical ladder of the boxer's sex's divisions, light at the top, heavy at the
  bottom. Each rung: a bar "stopped N in 100 bouts" (amateur, solid) with a thin second bar for pro. The boxer's own rung is
  lit. Under the ladder, three plain lines: "Bouts here end early about 1 in 7." "Your boxer's chin: 58, the punchers here:
  66." "Read: protect early."
- **Centre (800 px) - WHAT IT CHANGES FOR YOU**, four cards in a 2 x 2 grid, each with the live number and the button it
  belongs to:
  1. *The next fight* - the offer's stoppage word and N in 100, "2x this division's usual" in red only then. Button: Open the offer.
  2. *The towel* - Careful / Normal / Brave with "the card comes about 1 fight in 3 / 5 / 9 here". Button: the three lines.
  3. *The plan* - "When hurt: no line written. In this division that line is used 1 round in 6." Button: Open the plan.
  4. *This camp* - "+4 chin here = 11 fewer stoppages in 100. +4 jab = 3 more rounds won in 100." Button: Open the week.
- **Right column (560 px) - IF IT GOES WRONG:** a short timeline for a stoppage loss in this division: 30 days out (90 if
  the second in 90 days), chin ceiling -2, 2 members leave, 8 more weeks for a pro. Below it, the same for a towel: 14 days,
  no chin loss. One line under both: "Same price in every division. It just happens more often here."
- **Footer strip:** the last three bouts in this division from the world news, each "points" or "stopped, round N".

## Code files opened for this review
`scripts/rules`: Knockdowns.gd, Matchmaking.gd, Towel.gd, Exchanges.gd, Duels.gd, PerkFight.gd, InjuryRoll.gd, StandDown.gd,
Attrs.gd, AttrGen.gd, Aftermath.gd, StopWord.gd, FightLearn.gd, FirstHour.gd, BoutRules.gd, CounterCut.gd; by search only:
CoachRead.gd, FightWeekEvents.gd, StyleName.gd, AskDates.gd.
`scripts/state`: BoutNight.gd, RingDuel.gd, ProLadder.gd, LiverFold.gd, TowelWire.gd, CrackWire.gd, Injuries.gd,
AfterFight.gd, AskFlow.gd, PlanTest.gd, FixLab.gd, PullOutWire.gd, Region.gd, Data.gd, Roster.gd, BoutFinish.gd; by search
only: LiveRound.gd, LateAskWire.gd, Bouts.gd, Career.gd, SaveGame.gd.
`scripts/world`: WorldBout.gd, WorldSim.gd, WorldGen.gd, WorldAge.gd.
`scripts/ui`: ProFights.gd, AskPanel.gd, OfferCard.gd, BoutCompare.gd, FightPrep.gd, TowelStrip.gd; by search only: LateAskCard.gd.
Other: assets/data/world/divisions.json, tests/stop_mult_test.gd, tests/stop_word_test.gd, tests/knockdowns_test.gd and
tests/bout_stoppage_test.gd (by search), tools/stop_word_probe.gd.
Not opened: scripts/ui/areas/BoutPage.gd, scripts/ui/GamePlan.gd, scripts/rules/PlanFight.gd, PaceAim.gd, CornerJobs.gd,
ops/research/RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md (the SQ257 table was not re-checked).

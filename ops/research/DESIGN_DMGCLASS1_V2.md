# DESIGN DMGCLASS1 v2 — Stoppages and Punch Impact by Weight Class and Sex

Kind: design map (v2, rewritten from code after S532 review of `ops/research/DESIGN_DMGCLASS1_V1.md`)
Scope: research and architecture only — zero game code touched, Godot not run.

## Why v1 Failed and What v2 Changes

`ops/research/DESIGN_DMGCLASS1_V1.md` aimed a division multiplier at `Matchmaking.stop_chance` (`CODE`, `scripts/rules/Matchmaking.gd:272-275`), framed weight class as a player choice, proposed unmeasured multipliers on top of unmeasured base rates, and multiplied post-stoppage rest down to 0.5 weeks in lighter women's classes. All four moves break against the live codebase:

1. **Wrong dial fixed:** `Matchmaking.stop_chance` decides zero stoppages. It only formats the `"Stoppage %d%%"` label on professional offer rows (`CODE`, `scripts/ui/ProFights.gd:212-215`) and feeds the 5-axis dominance filter (`CODE`, `scripts/state/ProLadder.gd:229`). Actual hurt states, standing 8-counts, referee wave-offs (`RSC`), clean knockouts (`KO`), and corner towel retirements (`RTD`) are decided inside `RingDuel.settle` (`CODE`, `scripts/state/RingDuel.gd:375-378`), `Knockdowns.round_counts` and `Knockdowns.puncher_chance` (`CODE`, `scripts/rules/Knockdowns.gd:21-70, 122-139`), `BoutNight.count_sides` and `BoutNight._counts` (`CODE`, `scripts/state/BoutNight.gd:246-295`), `Towel.risk` (`CODE`, `scripts/rules/Towel.gd:25-65`), and `WorldBout.fight` / `WorldBout.fast` (`CODE`, `scripts/world/WorldBout.gd:109-143, 173-204`). The class-and-sex factor belongs in one pure rule file (`scripts/rules/ClassDamage.gd`) read by those fight-ending functions; every shown stoppage number then reads the **same** factor.
2. **Fake choice replaced with five real player choices:** Moving a signed boxer up or down a weight class **does not exist anywhere in code**. Weight class and sex are fixed to your boxer's body at signing (`CODE`, `scripts/state/Data.gd:256-270`) and mapped deterministically on turning pro (`CODE`, `scripts/state/ProLadder.gd:46-52`). What the factor actually changes are the numbers behind five live player decisions: which offer or Ask card to take, where to set and answer the corner towel, how to spend Game Plan defence versus finish slots and pace, how to answer a fight-week pull-out replacement or compromised bout, and how to weight chin/heart versus engine/jab in camp and perks. None of the five has a dominant pick.
3. **Measure first, then fit:** Round count (`3` amateur versus `4 / 6 / 8 / 10` professional) and cumulative head damage (`damage / 60.0`) inside `Knockdowns.round_counts` (`CODE`, `scripts/rules/Knockdowns.gd:10, 33`) already create steep endogenous stoppage growth over longer bouts, while code runs a fixed `6` exchanges per round (`CODE`, `scripts/rules/Exchanges.gd:5`) rather than shorter 2-minute rounds in women's professional bouts. Multiplying blind BoxRec ratios on top of `Knockdowns.gd` would double-count round length in men's 10-rounders and over-stop women's 8- and 10-rounders. Section 4 specifies `tools/dmg_class_probe.gd` (copied from `tools/stop_word_probe.gd`) to measure the unmodified baseline across all 17 `(sex x class x ruleset)` cells first and fit `ClassDamage` to the measured base.
4. **Medical rest and injuries stay on the damage ledger:** A featherweight stopped cold does not heal faster than a middleweight stopped cold. `Injuries.after_bout` (`CODE`, `scripts/state/Injuries.gd:192-234`), `InjuryRoll.ko_days` and `InjuryRoll.bout_chance` (`CODE`, `scripts/rules/InjuryRoll.gd:24-56`), `StandDown.make` (`CODE`, `scripts/rules/StandDown.gd:25-31`), `Matchmaking.next_weeks` (`CODE`, `scripts/rules/Matchmaking.gd:279-282`), `Attrs.wear_stoppage` (`CODE`, `scripts/rules/Attrs.gd:129-131`), and `WorldAge.record_stoppage_loss` (`CODE`, `scripts/world/WorldAge.gd:118-120`) take **zero** class or sex multipliers.

---

## 1. Empirical Stoppage Rates by Weight Class and Sex (Dola SQ257)

Preserved from `ops/research/RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md` (SQ257) and mapped directly onto the repository's 9 amateur divisions (`CODE`, `scripts/state/Data.gd:136-155`) and 8 `WORLD1` professional divisions (`CODE`, `assets/data/world/divisions.json:1-12`):

| Weight Band | Sex | Ruleset | Game Division ID (`limit`) (`CODE`) | Empirical Stoppage % (`KO + TKO/RSC + RTD`) (SQ257) | Real Bout Format & Equipment | Primary Stoppage Driver |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Featherweight** | Women | Amateur | `wfw` (`57.0 kg`) | **1.0% – 2.5%** | 3x3 min, 10 oz gloves, headguard | Safety RSC on unanswered flurries; clean KOs almost zero |
| **Featherweight** | Women | Pro | `w_fw` (`57.0 kg`) | **14% – 18%** | 4–10x2 min, 8 oz gloves, no headguard | Volume TKO and corner RTD; 2-min rounds cap finish windows |
| **Featherweight** | Men | Amateur | `mfw` (`55.0 kg`, note 3) | **4% – 6%** (`3% – 5%` at 55 kg `ESTIMATE`) | 3x3 min, 10 oz gloves, no headguard | High-pace accumulation RSC and standing-count limits |
| **Featherweight** | Men | Pro | `m_fw` (`57.0 kg`) | **33% – 38%** | 4–12x3 min, 8 oz gloves, no headguard | Late-round attrition TKO, body shots, counter KOs |
| **Lightweight** | Women | Amateur | `wlw` (`60.0 kg`) | **1.5% – 3.5%** | 3x3 min, 10 oz gloves, headguard | Referee RSC on mismatch combinations |
| **Lightweight** | Women | Pro | `w_lw` (`61.2 kg`) | **16% – 21%** | 4–10x2 min, 8 oz gloves, no headguard | Accumulation TKO; points decisions remain ~80% of bouts |
| **Lightweight** | Men | Amateur | `mlw` (`60.0 kg`) | **6% – 9%** | 3x3 min, 10 oz gloves, no headguard | Combination RSC, cuts, occasional clean counter |
| **Lightweight** | Men | Pro | `m_lw` (`61.2 kg`) | **38% – 44%** | 4–12x3 min, 8 oz gloves, no headguard | Sharp combination KOs, liver folds, late TKO waves |
| **Welterweight** | Women | Amateur | `www` (`65.0 kg`), `wlm` (`70.0 kg`, note 3) | **2.0% – 5.0%** (`3.5% – 6.5%` at 70 kg `ESTIMATE`) | 3x3 min, 10 oz gloves, headguard | Power mismatch RSC; multi-count referee stops |
| **Welterweight** | Women | Pro | `w_wr` (`66.7 kg`) | **18% – 24%** | 4–10x2 min, 8/10 oz gloves, no headguard | Corner RTD and referee TKO on ropes |
| **Welterweight** | Men | Amateur | `mww` (`70.0 kg`) | **8% – 12%** | 3x3 min, 12 oz (>67 kg), no headguard | Heavy single shots forcing standing 8-counts and RSC |
| **Welterweight** | Men | Pro | `m_wr` (`66.7 kg`) | **43% – 50%** | 4–12x3 min, 8/10 oz gloves, no headguard | True single-shot hurt, knockdowns, and attrition KOs |
| **Middleweight** | Women | Amateur | `wmw` (`75.0 kg`) | **5.0% – 9.0%** | 3x3 min, 12 oz gloves, headguard | Physical strength + shallow-pool skill gaps -> RSC |
| **Middleweight** | Women | Pro | `w_mw` (`72.6 kg`, note 1) | **20% – 26%** | 4–10x2 min, 10 oz gloves, no headguard | Undercard mismatch TKOs; competitive top-10 goes to points |
| **Middleweight** | Men | Amateur | `mmw` (`75.0 kg`) | **12% – 16%** | 3x3 min, 12 oz gloves, no headguard | True one-punch knockdowns and RSC / RSC-I |
| **Middleweight** | Men | Pro | `m_mw` (`72.6 kg`) | **48% – 55%** | 4–12x3 min, 10 oz gloves, no headguard | High clean-KO share alongside multi-knockdown TKOs |

### Sources and Thin-Data Notes (Preserved from SQ257)
- **Sources:** BoxRec and FightMatrix active divisional stoppage rates (4- to 12-round pro bouts); IBA Men's and Women's World Boxing Championships official results books (2018–2023); Paris 2024 Olympic Games official boxing results book; Bianco et al. (2013, *BJSM*) on women's Olympic RSC rates; Gavagan et al. (2017) and Krkeljas & Kovac (2021) on mass/sex punch-force scaling versus neck isometric strength; England Boxing Rule Book 2024–2025 (Rule 4.1.2 head-stoppage suspension); BBBofC medical suspension guidelines.
- **Thin-data note 1 — Women's pro middleweight (`w_mw`, 72.6 kg):** Fewer than 100 active professionals compete globally on BoxRec at 160 lb. Raw stoppage totals (~20–26%) are inflated by A-side prospects stopping novices on 4/6-round undercards; evenly matched ranked bouts finish inside the distance closer to ~15–20%. Fitting `ClassDamage` on competitive ranked pairs must stay near the bottom of `20% – 26%` so top-10 fights do not turn into coin-flip shootouts.
- **Thin-data note 2 — Amateur standing counts without RSC:** IBA and Olympic summary books publish final `RSC` / `KO` outcomes, not total standing 8-counts in bouts that still reach the final bell. Standing-count targets keep the `J_KDRATES1_JOHN.md` rule documented in `Knockdowns.gd` (`CODE`, `scripts/rules/Knockdowns.gd:2-5`): roughly **2 to 4 counted bouts per stopped bout** (`ESTIMATE`).
- **Thin-data note 3 — Amateur class alignment (`mfw` 55 kg, `wlm` 70 kg, `mww` 70 kg):** `Data.DIVISIONS` (`CODE`, `scripts/state/Data.gd:136-155`) carries 5 women's classes (`57, 60, 65, 70, 75 kg`) and 4 men's classes (`55, 60, 70, 75 kg`). On turning pro, `ProLadder.division_for` (`CODE`, `scripts/state/ProLadder.gd:46-52`) maps `<= 57.5 -> fw`, `<= 62.0 -> lw`, `<= 70.0 -> wr`, and `> 70.0 -> mw` (so both `www` 65 kg and `wlm` 70 kg enter `w_wr`, and `mww` 70 kg enters `m_wr`). Keying `ClassDamage` directly by division ID (with `sex` + `limit` fallback) lets `wlm` (70 kg) sit cleanly between `www` (65 kg) and `wmw` (75 kg) instead of collapsing them.
- **Ruleset note — Club novices vs elite brackets, and 2-minute rounds:** Regional club shows have wider skill gaps than Olympic brackets (handled naturally in code by `exp((power - chin) / 12.0)` in `Knockdowns.gd:33`), while women's pro bouts run 2-minute rounds in reality versus fixed `Exchanges.EXCHANGES = 6` (`CODE`, `scripts/rules/Exchanges.gd:5`) in code. The pro cells in `ClassDamage` therefore absorb the 2-minute-round finish-window compression for women's pro without changing exchange counts on the UI.

---

## 2. Where Stoppages, Knockdowns, and Hurt Actually Happen in Code

### 2.1 Why `Matchmaking.stop_chance` and `CounterCut` Are Not the Fight Dial
- **`Matchmaking.stop_chance(win_chance_now, opp)` (`CODE`, `scripts/rules/Matchmaking.gd:272-275`):** Computes `(1.0 - win_chance_now) * maxf(0.1, opp.ko / opp.w)` (using `0.25` when `wins == 0`). It is called in only two places in the entire repository: `ProLadder.offer_axes` (`CODE`, `scripts/state/ProLadder.gd:229`) for the 5-axis dominance filter and `ProFights._row` (`CODE`, `scripts/ui/ProFights.gd:213`) to format `"Stoppage %d%%"` on the promoter's card. No bout, round, or knockdown ever calls it.
- **`CounterCut.cut(b, cut_at)` (`CODE`, `scripts/rules/CounterCut.gd:20-35`):** Appears when grepping `stopped` (`moved["stopped"] = true` at `line 33`, pinned by `tests/counter_cut_test.gd`), **but it is a 3D punch-animation helper**, not a bout stoppage rule. When a counter-punch lands first in 3D, `CounterCut` trims the interrupted punch beat so `BeatFire` skips the interrupted shot's hit sound. Touching it has zero effect on bout outcomes.

### 2.2 Every Real Hurt, Knockdown, and Stoppage Roll in the Codebase

1. **In-round exchange hurt (watched and simulated player bouts):**
   - `RingDuel.side(a)` (`CODE`, `scripts/state/RingDuel.gd:204-206`) builds `{power: 0.7 * power + 0.3 * accuracy, chin, heart}`.
   - After each of the 6 exchanges in a round, `RingDuel.settle` (`CODE`, `scripts/state/RingDuel.gd:375-378`) checks whether the exchange margin beat `Exchanges.HURT_AT` (`30.0`, `CODE`, `scripts/rules/Exchanges.gd:55`):
     - The opponent hurt (`lv["opp_hurt"]`, `line 376`): `(margin > 30.0 and rng.randf() < clampf(0.3 + (ks.power - ko.chin) / 100.0, 0.1, 0.6))` or landed corner set-up.
     - Your boxer hurt (`line 377-378`): `margin < -30.0 and rng.randf() < clampf((0.3 + (ko.power - ks.chin) / 100.0) * talk_hurt * (1.6 if missed_setup_or_read else 1.0), 0.1, 0.8)`.
   - Being hurt enters the hurt situation on the next exchange (`CODE`, `scripts/rules/Exchanges.gd:145-149`) and strips `Duels.HURT_DEF * (1.2 - composure / 100.0)` (`8.0` base) off `guard`, `head_movement`, and `footwork` (`CODE`, `scripts/rules/Duels.gd:88, 141-143`), snowballing round margins toward `"clear"` and `"dominant"`.
   - On the unwatched world path, `WorldBout._hurt_edge` (`CODE`, `scripts/world/WorldBout.gd:88-93`) computes the expected hurt carry-over `pa` / `pb` from `HURT_BASE + last / 90.0 + (power - chin) / 60.0`.

2. **Round-end head damage, standing counts, referee `RSC`, and `KO`:**
   - At the bell of every round in a player bout (`Bouts.fight_step` and `BoutNight.play_out`, also called by `PlanTest.run` at `scripts/state/PlanTest.gd:47` and `FixLab.run` at `scripts/state/FixLab.gd:45`), `BoutNight._counts` (`CODE`, `scripts/state/BoutNight.gd:256-295`) builds `sides := count_sides(f, opp)` (`lines 246-250`):
     - `sides["a"]` = your boxer (`stop_mult = PerkFight.stop_mult(opp)` — the opponent's `Finisher` perk `1.5`, else `1.0`, `CODE`, `scripts/rules/PerkFight.gd:16, 48-49`), plus `StyleName.knock_power` for a Slugger (`line 258`).
     - `sides["b"]` = the opponent (`stop_mult = PerkFight.stop_mult(f)`).
   - `Knockdowns.round_counts(margin, loser, sides, damage, counts_so_far, rng)` (`CODE`, `scripts/rules/Knockdowns.gd:21-70`):
     - Adds round head damage (`lines 30-31`): `DAMAGE_PER_ROUND[margin]` (`close: 8.0, clear: 18.0, dominant: 32.0`) to `damage[loser]` and `WINNER_DAMAGE` (`2.0`) to `damage[winner]`. (Live exchange events in `LiveRound.gd:268-323` also add `PerkFight.COUNTER_DAMAGE`, dirty clinch, set-up, read, and guard bleed-through into `m["damage"]`.)
     - Standing-count roll (`lines 33-46`): `p = minf(0.85, BASE_COUNT * MARGIN_FACTOR[margin] * exp((power - chin) / POWER_CHIN_SCALE) * (1.0 + loser_dmg / DAMAGE_SCALE))` with `BASE_COUNT = 0.05`, `POWER_CHIN_SCALE = 12.0`, `DAMAGE_SCALE = 60.0`, rolled up to 3 times with `0.6x` decay.
     - Referee wave-off and `KO` (`lines 50-69`, gated by `counts > 0`): `stop_p = minf(0.9, REF_STOP * (1.0 + damage_out[loser] / DAMAGE_SCALE) * (1.4 - heart / 100.0) * loser_side.get("stop_mult", 1.0))` (`REF_STOP = 0.2`). If waved off and `damage_out[loser] >= KO_DAMAGE` (`60.0`), rolls `(1.0 - heart / 100.0) * KO_ODDS` (`0.7`) for `"KO"`, else `"RSC"`. Three counts in one round (`COUNTS_ROUND_STOP = 3`) or four in the bout (`COUNTS_BOUT_STOP = 4`) also force `"RSC"`.
   - `PerkFight.iron_chin` (`CODE`, `scripts/state/BoutNight.gd:264-269`, `scripts/rules/PerkFight.gd:24-31`) converts your boxer's first standing count of the bout into a stagger (unless already a `KO`).
   - `LiverFold.roll` (`CODE`, `scripts/state/LiverFold.gd:26-57`, called at `BoutNight.gd:272` when `counts == 0`): rolls a body 8-count from accumulated right-side liver shots; stops the bout (`"RSC"`) only if that body count is the boxer's 4th count of the bout (`COUNTS_BOUT_STOP`).
   - `Knockdowns.puncher_chance` (`CODE`, `scripts/rules/Knockdowns.gd:122-139`, called at `BoutNight.gd:275` when `counts == 0`): lets the round's **loser** catch the round's **winner** with `BASE_COUNT * COUNTER_SHARE` (`0.05 * 0.4 = 0.02` base), then rolls the exact same `stop_p` (reading `sides[target].get("stop_mult", 1.0)`) and `KO` / `RSC` check.

3. **Between-round corner retirements (`RTD` / `RTD_B`):**
   - `TowelWire.card` (`CODE`, `scripts/state/TowelWire.gd:46-66`, called from `BoutNight._shout` at `line 235`) passes `BoutNight.count_sides(f, opp)` into `Towel.risk` (`CODE`, `scripts/rules/Towel.gd:25-65`), which runs `200` seeded next-round simulations through `Knockdowns.round_counts` and `Knockdowns.puncher_chance`. When `risk["stop"]` meets `f["towel_line"]` (`0.12 / 0.20 / 0.33`), `TowelStrip` offers `"Throw the towel"` (`TowelWire.pull` sets `r["stopped"] = "RTD"`, `lines 96-114`), or `TowelWire.coach_pull` (`lines 79-93`) auto-pulls during simulated rounds.
   - `CrackWire.answer` and `CrackWire.bell` (`CODE`, `scripts/state/CrackWire.gd:52-87`) set `"RTD"` (your corner) or `"RTD_B"` (the opponent's corner) on a cracked rib.

4. **Unwatched world and rival bouts (`WorldBout`, `WorldSim`, `Region`, `WorldGen`):**
   - `WorldBout.fight` (`CODE`, `scripts/world/WorldBout.gd:109, 132-141`), `WorldBout.cached` (`line 160`), and `WorldBout.fast` (`lines 177, 192-201`) build `sides` via `_side(profile)` (`line 324`, **which today sets only `{power, chin, heart}` and no `stop_mult` or class keys**) and call `Knockdowns.round_counts` and `Knockdowns.puncher_chance` every round.
   - `WorldSim.simulate_bout` (`CODE`, `scripts/world/WorldSim.gd:142, 167-174`) runs `WorldBout.fast` for 6, 8, or 10 rounds (`rounds_for` at `lines 150-154`) and increments `winner["ko"]` and `WorldAge.record_stoppage_loss(loser)` whenever `r["stopped"]` is true. (`WorldSim._roll_stoppage` at `lines 160-164` is dead uncalled code left over from before S398.)
   - `Region._rival_bout` (`CODE`, `scripts/state/Region.gd:172`) runs `WorldBout.fast(a, b, 3, rng)` for 3-round amateur club-show bouts between division rivals.
   - `WorldGen._make_boxer` (`CODE`, `scripts/world/WorldGen.gd:153-154`) seeds initial world records with `ko_share = clampf(0.3 + explosiveness / 30.0, 0.05, 0.75)` — completely blind to `sex` and `div_id`, giving day-one women's featherweights and men's middleweights the same ~30% KO-to-win ratio.

5. **Where `stopped` is recorded after the bell:**
   - `BoutFinish.run` (`CODE`, `scripts/state/BoutFinish.gd:33-155`) reads `BoutNight.stopped(m)` (`""`, `"RSC"`, `"KO"`, `"RTD"`, `"RTD_B"`), writes `m["stopped"]`, updates records (`ko` on stoppage win), applies `Attrs.wear_stoppage` (`-2.0` `durability_cap`) on non-`RTD` stoppage losses (`line 67`), calls `ProLadder.result` -> `Matchmaking.apply_result` (`stop != ""`, `line 79`), calls `Injuries.after_bout` (`line 146`), and passes `stopped` to `AfterFight.book` (`CODE`, `scripts/state/AfterFight.gd:31-75`) for `Aftermath.toll` (`+10.0` tiredness on stopped bouts, `CODE`, `scripts/rules/Aftermath.gd:22, 28-30`).

### 2.3 Where the New Dial Goes: `scripts/rules/ClassDamage.gd`

Create **one pure static rule file**, `scripts/rules/ClassDamage.gd` (zero `preload` statements, no `Career` dependency), keyed by `(sex, div_id, pro)` with `(sex, limit_kg, pro)` fallback for raw dicts. Each cell provides three numbers fitted by `tools/dmg_class_probe.gd` (Section 4):

- **`punch_mult`** — **how hard punches land:**
  - Multiplies round head damage `DAMAGE_PER_ROUND[margin]` and `WINNER_DAMAGE` in `Knockdowns.round_counts` (`Knockdowns.gd:30-31`) via `float(winner_side.get("punch_mult", 1.0))`. Heavier and men's bouts cross `KO_DAMAGE = 60.0` earlier (raising clean `KO` share relative to `RSC` naturally) and leave higher `m["damage"]` after wars; lighter and women's bouts stay below `KO_DAMAGE` far more often (keeping almost all amateur stops as `RSC`).
  - Multiplies the exchange hurt probability in `RingDuel.settle` (`RingDuel.gd:376-378`) and expected hurt probability `pa` / `pb` in `WorldBout._hurt_edge` (`WorldBout.gd:88-93`).
- **`count_mult`** and **`class_stop`** — **how often counts and referee wave-offs fire:**
  - In `Knockdowns.round_counts` (`Knockdowns.gd:33, 52`) and `Knockdowns.puncher_chance` (`Knockdowns.gd:129, 134`):
    - Standing-count chance `p` multiplies by `float(winner_side.get("count_mult", 1.0))`.
    - Referee wave-off `stop_p` multiplies by `float(loser_side.get("stop_mult", 1.0)) * float(loser_side.get("class_stop", 1.0))`.
  - Why both `count_mult` and `class_stop` are needed: in `Knockdowns.gd`, wave-offs and KOs are gated behind `if counts > 0:` (`line 50`), while 3 counts in a round or 4 in a bout auto-stop even when `stop_p = 0` (`line 58`). Moving `class_stop` alone cannot drop women's featherweight amateur stops to `1.0% – 2.5%` without leaving excessive 8-counts, nor lift men's middleweight pro stops to `48% – 55%` across 4/6/8-round bouts if `BASE_COUNT = 0.05` never scales.
  - Why `class_stop` is a **separate key** from `stop_mult` on `sides`: `tests/stop_mult_test.gd` (`CODE`, `tests/stop_mult_test.gd:20-23, 35`) explicitly asserts that `BoutNight.count_sides(f, opp)` sets `plain["a"]["stop_mult"] == 1.0` and `plain["b"]["stop_mult"] == 1.0` when neither boxer has perks, and that `stop_mult` moves only the referee and not the count. Keeping `stop_mult` strictly for `PerkFight.stop_mult` while attaching `punch_mult`, `count_mult`, and `class_stop` (all defaulting to `1.0` when omitted!) keeps `tests/stop_mult_test.gd` and `tests/knockdowns_test.gd` 100% green.

Where `ClassDamage` is attached:
1. **`BoutNight.count_sides(f, opp)` (`BoutNight.gd:246-250`):** Attaches `punch_mult`, `count_mult`, and `class_stop` from `ClassDamage` to `sides["a"]` and `sides["b"]`. Covers live bouts, simulated bouts, `PlanTest.run`, `FixLab.run`, and `Towel.risk`.
2. **`RingDuel.settle` (`RingDuel.gd:375-378`):** Scales both corners' hurt roll odds by `ClassDamage.punch_mult`.
3. **`WorldBout.fight`, `WorldBout.cached`, `WorldBout.fast`, and `WorldBout._hurt_edge` (`WorldBout.gd:88-93, 109, 160, 177`):** Builds sides via `_side_for(boxer, profile)` attaching `ClassDamage` from `boxer.get("sex")`, `boxer.get("div")`, and `boxer.get("limit")`. Covers `WorldSim.simulate_bout` and `Region._rival_bout`.

### 2.4 How Every Shown Stoppage Number Reads the Same Factor

1. **Corner Towel (`TowelStrip.gd` via `TowelWire.card` -> `Towel.risk`):** Already calls `BoutNight.count_sides(f, opp)` (`TowelWire.gd:51`) and runs 200 trials of `Knockdowns.round_counts` and `Knockdowns.puncher_chance` (`Towel.gd:40-61`). Once `count_sides` carries `ClassDamage`, `"Stopped next round: X in 100"` automatically reflects the division's exact ring math with zero duplicate formula.
2. **Pro Offer Rows (`ProFights._row` & `ProLadder.offer_axes` -> `Matchmaking.stop_chance`):**
   - `WorldGen._make_boxer` (`WorldGen.gd:153-154`) replaces the flat `0.30` center with `ClassDamage.pro_ko_share(sex, div_id)` (derived from the probe's measured division KO share, `ESTIMATE` ~`0.16` in `w_fw` up to ~`0.52` in `m_mw`) plus the existing `explosiveness / 30.0` tilt.
   - `WorldSim.simulate_bout` then evolves `ko / w` through `WorldBout.fast` using the same `ClassDamage` ring factor.
   - `Matchmaking.stop_chance(win_chance_now, opp)` (`Matchmaking.gd:272-275`) reads `ClassDamage.pro_ko_share` when `opp["w"] == 0` (replacing hardcoded `0.25`) and scales the `0.10` floor proportionally by division, so a `0-0` or `12-2` opponent in `w_fw` vs `m_mw` shows a `"Stoppage %d%%"` that matches actual `BoutNight` outcomes.
3. **Amateur Ask Cards & Offer Comparison (`AskFlow.answers` -> `StopWord` -> `AskPanel` / `BoutCompare`):**
   - `tests/stop_word_test.gd` (`CODE`, `tests/stop_word_test.gd:106`) enforces that `StopWord.gd` stays pure with **zero `preload(` calls** and preserves `StopWord.word(gap)` on the `STOPWORD1` fixture.
   - Add `StopWord.word_for(gap: float, stop_factor: float = 1.0) -> String` (where `word(gap)` calls `word_for(gap, 1.0)`), shifting the effective rating gap by the division's probe-measured log-hazard offset `ClassDamage.amateur_gap_shift(sex, div_id)` (`AskFlow.answers` at `AskFlow.gd:113` passes the shift in). At the same `+3.0` rating gap, `wfw` reads `"unlikely"` (<8% stop risk) while `mmw` reads `"possible"` or `"a real risk"` (>20% stop risk).

### 2.5 Tests That Pin `stopped` and `stop_mult`

| Test File (`CODE`) | What It Pins Today | How v2 Keeps It Honest |
| :--- | :--- | :--- |
| `tests/stop_mult_test.gd` | `BoutNight.count_sides` sets `stop_mult == 1.0` without perks, `> 1.0` with `Finisher`; `stop_mult` moves referee wave-off in `puncher_chance`, not standing counts; `stop_mult == 1.0` equals omitted key. | Keep `stop_mult` exclusively for perks; `ClassDamage` uses separate `punch_mult`, `count_mult`, `class_stop` keys defaulting to `1.0` when omitted. |
| `tests/knockdowns_test.gd` | Raw `sides` 3-round stop share `[0.03, 0.12]`, count share `[0.10, 0.25]`, 3-in-round & 4-in-bout RSC, `KO_DAMAGE = 60.0` gate, `DAMAGE_PER_ROUND` accumulation, determinism. | Raw `sides` dicts in unit tests omit class keys -> default `1.0`, zero change to base `Knockdowns` unit math. |
| `tests/bout_stoppage_test.gd` | 400 `Bouts.fight_step(..., "sim")` bouts for `wlw` (60 kg women's amateur): counts in `[3%, 60%]`, stops in `[0.25%, 20%]`, early round termination, `"RSC|KO round n"`. | `wlw` SQ257 target (`1.5% – 3.5%`) sits squarely inside `[0.25%, 20%]`. |
| `tests/towel_test.gd`, `tests/towel_wire_test.gd` | `Towel.risk` matches `Knockdowns.round_counts` / `puncher_chance`; `RTD` gives `14` days out and skips `wear_stoppage`; `FightPrep.towel_row` buttons. | `Towel.risk` reads the same `sides` dict from `BoutNight.count_sides`; `RTD` rules stay untouched. |
| `tests/perk_fight_test.gd` | `Iron chin` turns count #1 into stagger; `Finisher` `1.5x` `stop_mult`. | Multiplicative with `class_stop`; perk invariants hold in every class. |
| `tests/stop_word_test.gd` | `StopWord.word(gap)` cutoffs (`0.0`, `8.0`), monotonicity, mutant kills, **no `preload(` in `StopWord.gd`**. | `StopWord.gd` keeps zero preloads and `word(gap)` unchanged; `AskFlow` passes `ClassDamage` offset into `word_for`. |
| `tests/rib_damage_test.gd` | `LiverFold` body 8-count -> 4th-count `RSC`; `CrackWire` `RTD` / `RTD_B`. | Body fold count limit (`COUNTS_BOUT_STOP = 4`) and rib `RTD` unchanged. |
| `tests/injuries_test.gd`, `tests/injury_roll_test.gd` | `ko_days` (`30 / 90 / 365`), `RTD` skipping `InjuryRoll`, `StandDown` days, `bout_chance`. | Zero class/sex multipliers in injury or stand-down code. |
| `tests/counter_cut_test.gd` | `CounterCut.cut` sets `moved["stopped"] = true` on interrupted 3D punch beat. | Untouched (animation helper, not bout stoppage). |
| **New:** `tests/class_damage_test.gd` | Monotonicity (`fw <= lw <= wr <= mw`; `f < m` at matched limit and ruleset; amateur < pro per division), default-`1.0` omission parity, `ProFights` / `Matchmaking.stop_chance` / `Towel.risk` / `WorldBout.fast` alignment. | Added in implementation slice to lock every division invariant. |

---

## 3. Weight Class Is Fixed; Five Real Player Choices Whose Numbers Move

### 3.1 Verification in Code: Weight Class Is Not a Player Choice
A grep across `scripts/` for writes to `["div"]`, `["limit"]`, and `["wc"]` confirms **moving up or down a weight class does not exist**:
- `Data.fighter_state` (`CODE`, `scripts/state/Data.gd:256-270`) writes `div`, `wc`, and `limit` once from `Data.DIVISIONS[div]` when a boxer joins the gym. Only `SaveGame.gd` save-migration helpers touch missing legacy keys.
- Walk-ins (`CODE`, `scripts/rules/FirstHour.gd:116-130`), scouted prospects (`CODE`, `scripts/state/Data.gd:221-244`, `scripts/state/Roster.gd:113-125`), and home juniors arrive with fixed `sex`, `div`, `limit`, and walking `weight`. Neither `FighterPage.gd` nor `FightPrep.gd` has a division switcher; weight management (`FightWeek.gd`, `Camp.gd`) is strictly making your boxer's fixed `f["limit"]` on weigh-in morning.
- Turning pro (`Roster.turn_pro` -> `ProLadder.division_for`, `CODE`, `scripts/state/ProLadder.gd:46-52`) maps `(sex, limit)` deterministically onto `w_fw / w_lw / w_wr / w_mw` or `m_fw / m_lw / m_wr / m_mw`.

Do **not** invent a weight-class selector for this task. Instead, `ClassDamage` changes the trade-off math of **five real choices the player already makes** (Depth target 7+: five genuine multi-axis choices, zero dominant picks):

### 3.2 Five Real Player Choices Moved by `ClassDamage`

1. **Which Promoter Offer or Amateur Ask Card to Accept (`ProLadder.offer_axes` / `ProFights._row` and `AskFlow.answers` / `AskPanel`):**
   - **Code hook:** Pro offers (`CODE`, `scripts/state/ProLadder.gd:195-229`) put `tune`, `above`, `payday`, and `ProLean.extra` rows on the table, trading `chance`, `place` (rank climb), `pay` (`purse + tickets`), `weeks`, and `stop` (`Matchmaking.stop_chance`). Amateur Ask cards (`CODE`, `scripts/state/AskFlow.gd:104-119`) trade `FightLearn.teach_for` (`0.0` growth if stopped, `AskFlow.gd:185`) and regional rank climb against `StopWord` (`"unlikely / possible / a real risk"`).
   - **How numbers move:** Consider a `35%` win-chance step-up (`payday` or `reach`, `+6` rating gap) against a heavy-handed opponent (`explosiveness +8`):
     - In `w_fw` / `wfw`, opponent KO share sits near ~`16%` (`ESTIMATE`), so pro `"Stoppage"` reads ~`10%` (`ESTIMATE`) and amateur `StopWord` stays `"unlikely"` / low `"possible"`. Losing mostly means a decision loss (`3–4` weeks rest, full `FightLearn` lesson, zero `durability_cap` wear).
     - In `m_mw` / `mmw`, opponent KO share against a puncher sits near ~`62%` (`ESTIMATE`), so pro `"Stoppage"` jumps to ~`40%` (`ESTIMATE`) and amateur `StopWord` flips to `"a real risk"`. A stoppage loss adds `+8` pro rest weeks (`STOP_REST_WEEKS`, `Matchmaking.gd:15`), `30 / 90 / 365` KO suspension days (`InjuryRoll.gd:13-17`), `-2.0` permanent `durability_cap` (`Attrs.STOP_DROP`, `Attrs.gd:41`), `0.0` `FightLearn` growth, `-0.8` extra rating loss (`STOP_COST`, `Matchmaking.gd:25`), and `+0.5` years career wear (`WorldAge.gd:11`).
   - **Why nothing dominates:** Ducking step-ups in `m_mw` hits `DUCKS_BLOCK = 2` (`ProLadder.gd:212`, locking out `"above"` offers) and starves gym cash; taking unscreened puncher paydays wrecks `durability_cap` and burns months on medical suspension. Conversely, playing timidly in `w_fw` wastes prime dates when tough step-ups rarely end in career-shortening KOs.

2. **Setting the Pre-Fight Towel Line and Answering the Live Towel Strip (`FightPrep.towel_row` + `TowelWire` / `TowelStrip`):**
   - **Code hook:** Before fight night, `FightPrep.towel_row` (`CODE`, `scripts/ui/FightPrep.gd:80-100`) sets `Careful (12 in 100)`, `Normal (20 in 100)`, or `Brave (33 in 100)` (`Towel.LINES`, `scripts/rules/Towel.gd:11`). Between rounds, `Towel.risk` (`Towel.gd:25-65`) simulates next-round `stop` vs `stop_safe` (`Box safe`) and triggers `TowelStrip` (`Throw the towel` = `RTD`, `14` days out, `-4` morale, zero `STOP_DROP`, zero `ko_history`; `Box safe` = softer round margins, higher `lose_safe`; `Send out` = full comeback/KO odds, full stop risk) or `coach_pull` on simmed rounds (`TowelWire.gd:79-114`).
   - **How numbers move:** After two lost rounds (`36–50` head damage):
     - In `w_fw` / `wlw`, next-round stop risk sits near ~`5–10%` (`ESTIMATE`) — below even `Careful (12%)` unless badly hurt, while setting `Careful` against a rare `Finisher` can forfeit a close 29-28 fight that would have gone the distance 90% of the time.
     - In `m_wr` / `m_mw`, one standing count + `40` head damage spikes `Towel.risk["stop"]` to ~`24–36%` (`ESTIMATE`), tripping `Careful (12%)` and `Normal (20%)` immediately while `Box safe` pulls it down to ~`13–19%` (`ESTIMATE`).
   - **Why nothing dominates:** In `m_mw`, `Careful` protects `durability_cap` and avoids a 90-day second-KO ban, **but** your boxer also carries `m_mw` `puncher_chance` power — throwing the towel in round 5 forfeits real one-shot comeback KOs when behind on the cards. `Brave` preserves two-way KO comebacks at steep chin cost; `Box safe` survives a bad round while conceding 10-9 on the cards.

3. **Allocating Game Plan Slots Between Defence Lines, Finish Lines, and Pace (`GamePlan.gd`, `PlanFight.gd`, `PaceAim.gd`, `PlanTest.gd`):**
   - **Code hook:** `GamePlan.gd` gives a finite coach-capped rule budget (`PlanBoard`) across conditional triggers (`hurt`, opponent hurt, `losing`, `ropes`, `final_round`, `any`), range (`long`, `pocket`, `inside`), tools (`guard`, `clinch`, `footwork`, `jab`, `hooks`, `uppercut`), `PaceAim`, and `CornerJobs` combo set-ups (which multiply your boxer's hurt chance by `1.6x` when a set-up or read misses in `RingDuel.settle`, `CODE`, `scripts/state/RingDuel.gd:378`). `PlanTest.run` (`CODE`, `scripts/state/PlanTest.gd:31-67`) tests the plan over 20 `BoutNight.play_out` bouts.
   - **How numbers move:** In `m_mw` / `m_wr` (`punch_mult > 1.0`), leaving `"when hurt"` without `long + guard/clinch` or running high `pace` with a risky combo set-up turns missed exchanges into hurt states (`1.6x * punch_mult`) and dominant-round `KO`s; conversely, spending a slot on `"when opponent hurt -> pocket + hooks"` converts hurt opponents into stoppages reliably. In `w_fw` / `w_lw` (`punch_mult < 1.0`), over-investing slots in `guard` / `clinch` / low `pace` gives away 3-3 exchange splits and drops 96-94 decisions where `jab`, `footwork`, and `final_round` flurry lines win fights.
   - **Why nothing dominates:** Defensive shell plans survive `m_mw` punchers on `PlanTest` yet lose points decisions to out-boxers; pocket press plans punish weak chins (`weak == "chin"`) yet bleed stoppages against counter-punchers.

4. **Answering a Fight-Week Pull-Out Replacement or Boxing Compromised (`PullOutWire.gd`, `StandDown.gd`, `CrackWire.gd`):**
   - **Code hook:** Five days before an away amateur bout, `PullOutWire` (`CODE`, `scripts/state/PullOutWire.gd:34-40, 88-106`) rolls opponent pull-outs with three answers: `Take the replacement` (unscouted rival raised to `>= old_rating + 5.0` for `2x` reputation), `Go home` (`-6` morale, `5` days wait), or `Next month's slot` (spends `1` scarce club favour to postpone `28` days).
   - **How numbers move:** Because `exp((power - chin) / 12.0)` (`Knockdowns.gd:33`) is exponential, an unscouted `+5.0` replacement multiplies raw count odds by ~`1.5x`. Combined with `ClassDamage`, `+5.0` in `mmw` / `mww` pushes stoppage loss risk past `20%` (`"a real risk"`, risking a 30-day KO ban + `STOPPED_LOSS_MEMBERS = 2` lost gym members, `BoutRules.gd:88`), making spending a club favour high-value; in `wfw` / `wlw`, the same `+5.0` jump stays near `4–9%` stop risk (`ESTIMATE`), making the `2x` reputation shot viable when chasing regional qualification.
   - **Why nothing dominates:** Club favours run out; `Go home` hurts morale and wastes fight-week prep; `Take the replacement` trades double reputation against division-scaled stoppage danger.

5. **Camp Attribute Targets and Career Perks (`WeekBoard.gd`, `Attrs.gd`, `PerkFight.gd`):**
   - **Code hook:** Weekly training and camps build `chin` (`durability`), `heart`, `guard` versus `engine`, `jab`, `footwork`, `power`, while `PerkFight` (`CODE`, `scripts/rules/PerkFight.gd:14-21`) offers `Iron chin` (negates count #1), `Finisher` (`1.5x` `stop_mult`), `Counter sense`, and `Second wind` (`+18` round-3 energy).
   - **How numbers move:** Adding `+4` `chin` cuts `exp((power - chin) / 12.0)` by `28%`. Cutting `28%` off a `40%` stoppage hazard in `m_mw` saves ~`11` points of KO risk per fight (and `Finisher` `1.5x` turns hurt rounds into finishes), whereas cutting `28%` off a `2%` hazard in `wfw` saves `0.5` points — where `Second wind`, `jab`, and `footwork` swing far more 29-28 decisions.
   - **Why nothing dominates:** Chin/power builds still lose wide decisions if `footwork` and `jab` cannot close `Duels` range (`Duels.gd`); speed/engine builds sweep scorecards until caught by `puncher_chance` in heavier classes if `chin` is neglected.

---

## 4. Headless Measurement Probe Spec: `tools/dmg_class_probe.gd`

**Status:** Specification only — **do not run Godot in this task**.

### 4.1 Closest Existing Probe to Copy
Copy **`tools/stop_word_probe.gd`** (`CODE`, `tools/stop_word_probe.gd:1-210`). It already:
- Extends `SceneTree` and parses `-- bouts=N seed=S` user CLI args (`lines 42-48`).
- Runs the **exact player bout loop** (`_fight` at `lines 154-184`): duplicates the boxer and named division opponent, sets a deterministic `c.day` seed, calls `Bouts.fight_step(c, g, m, "start")`, drains live exchanges with `Bouts.fight_step(c, g, m, "shout:")`, calls `BoutRules.auto_corner` between rounds, calls `Bouts.fight_step(c, g, m, "end")`, records `Bouts.stopped(m)` (`""`, `"RSC"`, `"KO"`, `"RTD"`), and restores `c.fighters`, `c.rivals`, `c.results`, `c.news`, and `c.day` so zero fatigue, injury, KO history, or rating drift leaks across trials.

Pair that player-bout loop with a second pass calling **`WorldBout.fast(a, b, rounds, rng)`** (`CODE`, `scripts/world/WorldBout.gd:173-204`) — the exact function `WorldSim.simulate_bout` (`WorldSim.gd:142`) and `Region._rival_bout` (`Region.gd:172`) execute — so player bouts and simulated world KO records are verified side by side.

### 4.2 Cells, Populations, and Functions Measured

Run `N = 400` bouts per cell (`ESTIMATE`, ~`6,800` player bouts + `6,800` `WorldBout.fast` bouts; runtime ~`25–45s` headless based on `stop_word_probe`'s ~`1,260` bouts in ~`6s`):

1. **9 Amateur Cells (`Bouts.rounds_of(g) == 3`, `pro = false`):**
   - Every key in `Data.DIVISIONS` (`CODE`, `scripts/state/Data.gd:136-155`): `wfw` (57), `wlw` (60), `www` (65), `wlm` (70), `wmw` (75), `mfw` (55), `mlw` (60), `mww` (70), `mmw` (75).
   - Population: build `Career.quick_start()` seeded by `base_seed` (which populates `Data.DIVISION_RIVALS` + `Newcomers` novices per division). Draw distinct legal pairs `(a, b)` (`a != b`, `abs(rating_a - rating_b) <= 8.0` matching `AmateurBooking` / club show matchmaking, plus a separate mismatch diagnostic bucket `abs(gap) > 8.0`). Convert `a` via `Data.fighter_state` (`f["towel_line"] = "normal"`) and run both:
     - `Bouts.fight_step` (with a flag logging whether `TowelWire.coach_pull` fired vs pure referee `RSC` / `KO`), and
     - `WorldBout.fast(a, b, 3, rng)` (matching `Region._rival_bout`).
2. **8 Pro Cells (`pro = true`, `4 / 6 / 8 / 10` rounds):**
   - Every division in `assets/data/world/divisions.json` (`CODE`): `w_fw` (57.0), `w_lw` (61.2), `w_wr` (66.7), `w_mw` (72.6), `m_fw` (57.0), `m_lw` (61.2), `m_wr` (66.7), `m_mw` (72.6).
   - Population: `WorldGen.new().generate_world(base_seed)` (`CODE`, `scripts/world/WorldGen.gd:36`, 45 boxers per division). Sample competitive pro pairings across the division's schedule mix (`4r` unranked/debut 30%, `6r` unranked/fringe 35%, `8r` ranked 11–20 20%, `10r` top-10/title 15% `ESTIMATE`, matching `ProLadder.ROUNDS_*` at `ProLadder.gd:36-39` and `WorldSim.rounds_for` at `WorldSim.gd:150-154`), and also print sub-tables per round count (`4r`, `6r`, `8r`, `10r`). Run both `Bouts.fight_step` (converting boxer `a` to a player pro fighter dict and `b` via `ProLadder.bout_opp`) and `WorldBout.fast(a, b, rounds, rng)`.

### 4.3 Printed Columns and Two-Pass Fitting Protocol

Per cell, `tools/dmg_class_probe.gd` prints:
```text
cell | sex | div | kg | rules | rds | path | n | count% | stop% | rsc% | ko% | rtd% | liver% | mean_dmg | sq257_lo..hi | pass
```

- **Pass 1 — Unmodified Baseline (`-- mode=base bouts=400 seed=5321`, writes `docs/DMGCLASS1_BASELINE.md`):**
  All `ClassDamage` factors equal `1.0`. Expected baseline shape (`ESTIMATE` from reading `Knockdowns.gd` and `tests/knockdowns_test.gd`): all 9 amateur 3-round cells cluster around the same class-blind ~`6% – 11%` stoppage rate, while all 8 pro cells jump together to ~`22% – 38%` across 6–10 rounds purely from round count and `damage / 60.0` compounding — with zero separation between `w_fw` and `m_mw`.
- **Pass 2 — Fitted `ClassDamage` (`-- mode=fit bouts=400 seed=5321`, writes `docs/DMGCLASS1_RESULT.md`):**
  Fit `(punch_mult, count_mult, class_stop)` per cell **against Pass 1's measured baseline**, never by multiplying SQ257 ratios blindly on top:
  1. Every cell's `stop%` on `Bouts.fight_step` and `WorldBout.fast` lands inside its Section 1 SQ257 band (with `w_mw` competitive pairs anchored in `18% – 24%` per thin-data note 1).
  2. Amateur `count% / stop%` stays within **2.0x – 4.0x** (`J_KDRATES1_JOHN.md` invariant).
  3. Clean `KO` share of stoppages (`ko% / stop%`) stays `< 15%` (`ESTIMATE`) in women's amateur (`punch_mult < 1.0` keeps 3-round head damage mostly under `KO_DAMAGE = 60.0`) and rises above `35%` (`ESTIMATE`) in men's pro welterweight/middleweight (`punch_mult > 1.0` crosses `KO_DAMAGE = 60.0` regularly).
  4. `liver%` of total counts stays inside `10% – 20%` (`LIVERPROBE1` bar in `scripts/state/LiverFold.gd:14`).
  5. Monotonicity holds strictly across every adjacent weight step (`fw <= lw <= wr <= mw`), across sex at matched weight (`f < m`), and from amateur to pro (`amateur < pro`).

Slot-runner command (for the implementation task that builds the probe — not executed here):
```bash
python ops/Tools/godot_slot.py run --who dmgclass1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --log-file tmp/dmgclass1.log --script res://tools/dmg_class_probe.gd -- mode=base bouts=400 seed=5321
```

---

## 5. Medical Rest, Stand-Downs, Injuries, and Wear Stay on the Damage Ledger

**Hard rule:** `ClassDamage` governs **only** how hard punches land (`punch_mult`) and how often counts and stoppages happen (`count_mult`, `class_stop`). Once a bout ends, healing, mandatory medical suspensions, no-sparring stand-downs, and permanent wear read **only** what happened in the bout and in the boxer's damage ledger — **never** a class or sex multiplier:

| Post-Bout Consequence | Live Code Today (`CODE`) | Class / Sex Multiplier in v2 | How Division Differences Emerge Naturally |
| :--- | :--- | :--- | :--- |
| **Head-stoppage suspension (`KO` / `RSC`)** | `Injuries.after_bout` (`scripts/state/Injuries.gd:205-225`) -> `InjuryRoll.ko_days` (`scripts/rules/InjuryRoll.gd:34-48`): **30 days** (1st), **90 days** (2nd within 90d), **365 days** (3rd within 365d), England Boxing Rule 4.1.2. | **None (`1.0x`).** | A 57 kg boxer stopped cold sits out the exact same 30 / 90 / 365 days as a 75 kg boxer stopped cold; 57 kg boxers simply suffer fewer head stoppages. |
| **Corner towel retirement (`RTD`)** | `TowelWire.pull` (`scripts/state/TowelWire.gd:105-108`) -> `Towel.PULL_DAYS = 14` days out (`scripts/rules/Towel.gd:13`); `Injuries.after_bout` (`Injuries.gd:195`) skips `InjuryRoll` and `Attrs.wear_stoppage`. | **None (`1.0x`).** | Throwing the towel saves `16+` rest days and `2.0` `durability_cap` in every division, making `FightPrep.towel_row` matter more where `Towel.risk` climbs faster. |
| **Post-bout no-sparring stand-down** | `StandDown.make(c.day, dmg, head_stop)` (`scripts/rules/StandDown.gd:25-31`): `head = 100 - dmg * 0.8` -> **5 days** (`>=55`), **10 days** (`35..55`), **21 days** (`<35`). | **None (`1.0x`).** | Because `punch_mult` scales round damage into `m["damage"]["a"]`, a brutal 75 kg war that lands `85` damage earns `21` no-sparring days while a clean `28`-damage 57 kg points bout earns `5` days — from **damage taken**, never faster healing. |
| **Distance-bout injury roll (cut, nose, head, hand, ribs)** | `InjuryRoll.bout_chance` & `bout_roll` (`scripts/rules/InjuryRoll.gd:24-60`): `0.06 * (rounds / 3.0) * (0.4 + 1.2 * s)` from worst `places` (`head`, eyes, nose, ribs) and `rounds`; layoffs `14–56` days (`BOUT_TYPES`, `line 19`). | **None (`1.0x`).** | Higher `m["damage"]["a"]` lowers `places["head"]` (`Injuries.gd:198`), nudging injury odds only when your boxer actually absorbed heavy punishment. |
| **Pro promoter turnaround weeks** | `Matchmaking.next_weeks(gap, stopped_loss)` (`scripts/rules/Matchmaking.gd:15, 279-282`): `6 / 8 / 10` weeks base + **`STOP_REST_WEEKS = 8`** (`56` days) on a stopped loss. | **None (`1.0x`).** | Stopped losses cost `+8` weeks on every pro ladder; points bouts turn around in `6–10` weeks by difficulty (`gap`). |
| **Permanent chin / career wear** | `Attrs.wear_stoppage` (`scripts/rules/Attrs.gd:41, 129-131`): `-2.0` `durability_cap` per non-`RTD` stoppage loss. `WorldAge.record_stoppage_loss` (`scripts/world/WorldAge.gd:11, 118-120`): `+0.5` years career wear and `-2.0` annual `AttrGen.age_wear` durability drop (`AttrGen.gd:169-170`). | **None (`1.0x`).** | Heavyweight/middleweight sluggers accumulate more `stoppage_losses` and `hard_fights` in `damage_ledger` over a career, aging chins faster without fake age/rest multipliers. |
| **Post-fight tiredness** | `AfterFight.book` (`scripts/state/AfterFight.gd:39`) -> `Aftermath.toll` (`scripts/rules/Aftermath.gd:22, 28-30`): energy spent in `m["energy"]` + `TOLL_STOPPED = 10.0` if stopped. | **None (`1.0x`).** | Follows actual tank spent and whether the bout was stopped. |

---

## 6. Menu and Systems Map (`Menu | CODE TODAY | TO BUILD`)

Preserved from v1's layout and corrected against every file read in the codebase:

| Menu / System | CODE TODAY (Verified `CODE`) | TO BUILD (Using `ClassDamage`) |
| :--- | :--- | :--- |
| **Fight Night — Ring, Counts & Referee** (`RingDuel.gd`, `BoutNight.gd`, `Knockdowns.gd`) | `RingDuel.settle` (`RingDuel.gd:375-378`) rolls hurt states with class-blind `(0.3 + (power - chin) / 100.0)`. `BoutNight.count_sides` (`BoutNight.gd:246-250`) sets only `PerkFight.stop_mult` (`1.0` or `1.5`). `Knockdowns.round_counts` (`Knockdowns.gd:21-70`) and `puncher_chance` (`lines 122-139`) run identical `DAMAGE_PER_ROUND`, `BASE_COUNT = 0.05`, and `REF_STOP = 0.2` across every sex and weight class. (`CounterCut.gd:20-35` is 3D punch-interrupt animation only.) | Create pure `scripts/rules/ClassDamage.gd` (`punch_mult`, `count_mult`, `class_stop`, all defaulting to `1.0` when omitted). Attach in `BoutNight.count_sides` (keeping `stop_mult` strictly for perks so `stop_mult_test.gd` stays green); read in `Knockdowns.round_counts`, `Knockdowns.puncher_chance`, and `RingDuel.settle`. |
| **World & Rival Simulation** (`WorldBout.gd`, `WorldSim.gd`, `Region.gd`, `WorldGen.gd`) | `WorldBout.fight`, `cached`, and `fast` (`WorldBout.gd:109, 160, 177`) build `_side` (`line 324`) with `{power, chin, heart}` only and call `Knockdowns`. `WorldSim.simulate_bout` (`WorldSim.gd:142`) and `Region._rival_bout` (`Region.gd:172`) call `WorldBout.fast`. `WorldGen._make_boxer` (`WorldGen.gd:153-154`) seeds `ko_share` around `0.30` regardless of `sex` or `div_id`. | Attach `ClassDamage` in `WorldBout` (`_side_for(boxer, profile)`) and `WorldBout._hurt_edge` (`lines 88-93`). Seed `WorldGen._make_boxer` initial `ko_share` around `ClassDamage.pro_ko_share(sex, div_id)` so day-one pro records match simulated world bouts. |
| **Pro Fights — Promoter Offers** (`ProFights.gd`, `ProLadder.gd`, `Matchmaking.gd`) | `ProFights._row` (`ProFights.gd:213`) displays `"Stoppage %d%%"` and `ProLadder.offer_axes` (`ProLadder.gd:229`) filters dominated offers via `Matchmaking.stop_chance(win_chance_now, opp)` (`Matchmaking.gd:272-275`), which computes `(1 - win_chance) * max(0.10, opp.ko / opp.w)` (`0.25` if `w == 0`). Decides no fights; reads flat ~30% `ko_share` in every division. | `opp.ko / opp.w` now comes from `WorldGen` + `WorldBout.fast` running `ClassDamage`; update `Matchmaking.stop_chance` to read `ClassDamage.pro_ko_share` when `w == 0` and scale the `0.10` floor by division so the shown % matches actual `BoutNight` risk. |
| **Amateur Fights — Ask for a Bout** (`AskFlow.gd`, `StopWord.gd`, `AskPanel.gd`) | `AskFlow.answers` (`AskFlow.gd:113`) calls `StopWord.word(gap)` (`StopWord.gd:20-25`) with static gap cutoffs `0.0` (8%) and `8.0` (20%); `AskPanel._answer` (`AskPanel.gd:109`) prints `"Getting stopped: <word>."` Blind to sex and weight class. | Add `StopWord.word_for(gap, shift := 0.0)` in `StopWord.gd` (**zero preloads**, `word(gap)` unchanged for `stop_word_test.gd`); `AskFlow.answers` passes `ClassDamage.amateur_gap_shift(sex, div)`. |
| **Amateur Fights — Club Offers & Bout Page** (`OfferCard.gd`, `BoutPage.gd`, `BoutCompare.gd`) | Shows `BoutRead.band` win % (`OfferCard.gd:26`, `BoutPage.gd:55`) and `BoutCompare.offer_chips` (`Strength gap`, `BoutCompare.gd:103`), with no stoppage read and fixed `f["wc"]` / `f["limit"]`. | Keep weight class fixed (no selector). Surface `StopWord.word_for` on `BoutCompare` / `OfferCard` when division + rating/power gap reaches `"possible"` or `"a real risk"`. |
| **Fight Prep & Corner Stool — The Towel** (`FightPrep.gd`, `TowelWire.gd`, `Towel.gd`, `TowelStrip.gd`) | `FightPrep.towel_row` (`FightPrep.gd:80-100`) sets `Careful (12)`, `Normal (20)`, or `Brave (33)`. Between rounds, `TowelWire.card` (`TowelWire.gd:46-66`) passes `BoutNight.count_sides` into `Towel.risk` (`Towel.gd:25-65`, 200 MC trials of `Knockdowns`). Blind to class and sex today. | Automatic once `BoutNight.count_sides` carries `ClassDamage`: `Towel.risk` runs `Knockdowns` with the division's numbers, tripping the towel earlier in heavy men's wars and keeping light women's scorecards alive. |
| **Game Plan & Sparring Plan Test** (`GamePlan.gd`, `PlanFight.gd`, `PlanTest.gd`) | Player writes conditional range/tool rules, pace, and set-ups (`GamePlan.gd`). `PlanTest.run` (`PlanTest.gd:31-67`) simulates 20 bouts via `BoutNight.play_out` (`line 47`). | Automatic once `BoutNight.count_sides` and `RingDuel.settle` read `ClassDamage`: `PlanTest` rewards `when hurt` defence in heavy divisions and volume/range scoring in lighter divisions. |
| **Fight Week — Pull-Out Card** (`PullOutWire.gd`, `FightWeekEvents.gd`) | `PullOutWire` (`PullOutWire.gd:34-40, 88-106`) offers `Take the replacement` (`rating >= old + 5.0`, `2x` rep), `Go home` (`-6` morale), or `Next month's slot` (`1` club favour) with no division stoppage read on the replacement. | Show `StopWord.word_for` on the replacement column so the player sees when `+5.0` short-notice power in `mww` / `mmw` crosses into `"a real risk"`. |
| **Fighters — Scouting & Signing** (`Fighters.gd`, `Roster.gd`, `Data.gd`, `ProLadder.gd`) | `sex`, `div`, `wc`, and `limit` are fixed on each boxer (`Data.fighter_state`, `Data.gd:261`; `ProLadder.division_for`, `ProLadder.gd:46-52`). Moving up or down a class does not exist. | Touch nothing on weight-class assignment; do **not** add a limit selector. |
| **Post-Bout Rest, Stand-Downs, Injuries & Wear** (`Injuries.gd`, `InjuryRoll.gd`, `StandDown.gd`, `AfterFight.gd`, `WorldAge.gd`) | `ko_days` (`30 / 90 / 365`), `Towel.PULL_DAYS` (`14`), `StandDown.make` (`5 / 10 / 21` from `m["damage"]["a"]`), `InjuryRoll.bout_chance` (from body places + rounds), `STOP_REST_WEEKS` (`8`), `STOP_DROP` (`2.0`), `DAMAGE_PER_STOPPAGE_LOSS` (`0.5`). | **Touch nothing.** Zero class or sex multipliers on rest, suspension, injury days, or per-stoppage wear. |

---

## 7. Ordered Follow-Up Build Slices (When Ready to Implement)

1. **`DMGPROBE1` (Measurement tool + baseline doc):** Build `tools/dmg_class_probe.gd` from `tools/stop_word_probe.gd` + `WorldBout.fast`, run `mode=base`, and commit `docs/DMGCLASS1_BASELINE.md`.
2. **`DMGCLASS1` (Core ring + world dial + fitted table):** Add `scripts/rules/ClassDamage.gd`, wire `BoutNight.count_sides`, `Knockdowns.round_counts` / `puncher_chance`, `RingDuel.settle`, and `WorldBout` (`_side_for` + `_hurt_edge`), fit the 17-cell table with `tools/dmg_class_probe.gd -- mode=fit`, commit `docs/DMGCLASS1_RESULT.md`, and pin with `tests/class_damage_test.gd` while keeping `stop_mult_test.gd`, `knockdowns_test.gd`, `bout_stoppage_test.gd`, and `towel_test.gd` green.
3. **`DMGREAD1` (Shown risk parity):** Wire `WorldGen._make_boxer` and `Matchmaking.stop_chance` to `ClassDamage.pro_ko_share`, and wire `StopWord.word_for` into `AskFlow.answers`, `BoutCompare`, and `PullOutWire` while keeping `tests/stop_word_test.gd` green.

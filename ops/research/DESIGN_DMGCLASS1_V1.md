# DESIGN DMGCLASS1 V1 - stoppages-by-weight-and-sex design map (from the code)

## 1. What the game decides today (CODE ONLY)

### Stoppage risk and the offer card (Matchmaking.gd)
- **CODE**: `scripts/rules/Matchmaking.gd` `stop_chance(win_chance_now: float, opp: Dictionary) -> float` (line 272)
  - Calculates the chance she is stopped in the fight: `(1.0 - win_chance_now) * ko_share` (floored at 0.1).
  - `ko_share` is the opponent's KO/TKO share (`opp["ko"] / opp["w"]` if `w > 0`, else `0.25`).
  - The offer card shows this via `scripts/state/ProLadder.gd` `offer_axes` (line 228) and `scripts/ui/ProFights.gd` `_row` (line 213) as `"stop": MM.stop_chance(...)`.
  - **TRUE TODAY**: The stoppage risk depends ONLY on the win chance and the opponent's historical KO share. No weight class, sex, or amateur/pro factor is in the code.

### Hurt state and the live exchange (RingDuel.gd)
- **CODE**: `scripts/state/RingDuel.gd` `settle(...)` (line 315)
  - The fighter becomes hurt (`lv["her_hurt"]` or `lv["opp_hurt"]`) based on the exchange margin (`s["margin"]`) and a random roll against the chin/power ratio.
  - `HURT_AT` (constant in `Exchanges.gd`, not opened but referenced) defines the margin threshold.
  - The hurt state is read in `scripts/state/RingDuel.gd` `state(lv, i)` (line 248) as `["hurt": [bool, bool]]`.
  - **TRUE TODAY**: Hurt is decided purely by the exchange margin, power, chin, and heart. No weight class, sex, or amateur/pro factor scales the hurt threshold or chance.

### The stopped loss and medical rest (Injuries.gd)
- **CODE**: `scripts/state/Injuries.gd` `after_bout(c, f, m)` (line 199)
  - A stoppage loss (`str(m["stopped"]) != ""` and `str(m["outcome"]) == "loss"`) triggers `WA.record_stoppage_loss(p)` in `Matchmaking.gd` (line 169) and sets `STOP_REST_WEEKS` (8 weeks) in `Matchmaking.gd` (line 34).
  - The injury roll is performed via `InjuryRoll.bout_roll(...)` (line 207).
  - **TRUE TODAY**: The rest is fixed at `STOP_REST_WEEKS = 8` weeks (Matchmaking.gd line 34) plus damage ledger updates. No weight class, sex, or amateur/pro factor modifies `STOP_REST_WEEKS` or the injury roll multiplier in the code.

### Knockdowns and the count (RingDuel.gd / BoutRules.gd)
- **CODE**: `scripts/state/RingDuel.gd` `step(...)` and `settle(...)` (lines 105, 315)
  - Knockdowns are part of the `settle` logic (margin, power, chin) and the `Exchanges.EXCHANGES` loop.
  - **TRUE TODAY**: The knockdown incidence and count are based on the power/chin/heart stats and exchange margin. No class/sex/amateur factor.

### Pro ladder offer rows (ProLadder.gd / ProFights.gd)
- **CODE**: `scripts/state/ProLadder.gd` `offer_rows(c, f)` (line 280) and `scripts/ui/ProFights.gd` `_table_card(...)` (line 101)
  - The stoppage risk (`stop`) is displayed per row.
  - The "chance" (`mid`) and "pay" (`purse`, `tickets`) are calculated via `Matchmaking.pay_of` (line 196) and `Matchmaking.shown_chance` (line 154).
  - **TRUE TODAY**: The rows show the same `stop_chance` for all classes/sexes/amateur-pro states. The `division_for` function in `ProLadder.gd` (line 77) maps sex and limit to a table ID (`w_fw`, `m_lw`, etc.), but the `stop_chance` calculation inside the offer row does NOT use the division ID or sex to scale the rate.

### Measured baseline (tools/ and tests/)
- **CODE PROBE**: `tests/stop_mult_test.gd` (line 1) and `tests/women_classes_test.gd` (line 1)
  - `tests/stop_mult_test.gd` tests `BoutNight.count_sides` and `Knockdowns.puncher_chance` for stop multipliers (perks), but does not print or test class/sex/amateur rates.
  - `tests/women_classes_test.gd` checks class limits (57/60/65/75 kg) and weight cuts, but does not print stoppage rates.
  - **MEASURE BEFORE PROPOSING**: To read today's stoppage rate per class and sex, we would use the existing `tests/bout_stoppage_test.gd` or `tests/stop_mult_test.gd` but add a probe that loops through `ProLadder.division_for` (sex/limit) and calls `Matchmaking.stop_chance` for a fixed win chance (e.g. 0.5) and opponent KO share (e.g. 0.5). The current code would output the SAME rate (0.25) for every class, sex, and amateur/pro state. The smallest new probe would be a script in `tools/` that runs `Matchmaking.stop_chance` across the `ProLadder.division_for` keys and prints the baseline (which is currently flat).

### Injuries after a stoppage (Injuries.gd)
- **CODE**: `scripts/state/Injuries.gd` `line(c, f)` (line 84) and `severity(days)` (line 124)
  - The severity is "minor" (≤14 days), "moderate" (≤28 days), or "serious" (>28 days).
  - **TRUE TODAY**: The code uses the `days_out` from `InjuryRoll` (line 207) without scaling by weight class, sex, or amateur/pro.

---

## 2. The proposal: applying class/sex/amateur factors

### ONE place in the code
- **LOCATION**: `scripts/rules/Matchmaking.gd` `stop_chance(win_chance_now: float, opp: Dictionary) -> float` (line 272)
  - **WHY**: This is the single function that returns the stoppage risk for the offer card, the bout result, and the medical rest calculation (`next_weeks` calls `stop_chance` implicitly via `apply_result` which sets `stopped_loss`). Modifying this function allows the multiplier to be applied consistently across the offer card, the coach's read, the result's "what decided it", and the medical rest.

### Table of factors (ESTIMATE, sourced to research)
| Band / Category | Men's Pro Rate | Women's Pro Rate (Ratio) | Amateur Rate (Ratio) | Source (RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md) |
|-----------------|----------------|--------------------------|----------------------|-----------------------------------------------------|
| **Light** (≤61kg / ≤57kg) | 55% (BASE) | 24% (0.44x) | Men 7% (0.13x) / Women 5% (0.09x) | Table "Final game-ready numbers" (SQ257) |
| **Middle** (64–76kg / 60–65kg) | 68% (BASE) | 30% (0.44x) | Men 11% (0.16x) / Women 6% (0.09x) | Table "Final game-ready numbers" (SQ257) |
| **Heavy** (>85kg / >75kg) | 75% (BASE) | 38% (0.51x) | Men 16% (0.21x) / Women 9% (0.12x) | Table "Final game-ready numbers" (SQ257) |
| **Early Pro (4-6 rounds)** | × 0.85 | × 0.85 | — | "Early-career pro adjustment" (SQ257) |

*Note: The "BASE" is the current code's flat `ko_share` logic scaled to the research's "Men's pro" baseline. The factors are ESTIMATE multipliers applied to `stop_chance`.*

### Menus that must SHOW it (CODE TODAY | TO BUILD)
| Menu | CODE TODAY | TO BUILD |
|------|------------|----------|
| **Offer card stoppage risk** (`scripts/ui/ProFights.gd` `_row`) | Shows `MM.stop_chance(...)` as a flat % bar (line 213). | Show the factor label (e.g. "Heavy Men 1.4x") and the scaled % bar. |
| **Coach's read** (`scripts/rules/BoutRead.gd` / `scripts/state/RingDuel.gd` `mean_edges`) | Shows win chance and edge; stoppage risk is implicit in `settle` margin (line 315). | Add the class/sex/amateur factor to the "what decided it" read line in `RingDuel.duel_line` (line 206). |
| **Result's "what decided it"** (`scripts/state/RingDuel.gd` `round_lines` / `scripts/rules/BoutRules.gd` `why`) | Shows duel lines and "The film study..." (line 417). | Append the factor (e.g. "Heavyweight factor 1.4x increased stoppage risk") to the `why` array (line 417). |
| **Medical rest after stopped loss** (`scripts/state/Injuries.gd` `after_bout` / `Matchmaking.next_weeks`) | Fixed `STOP_REST_WEEKS = 8` (Matchmaking.gd line 34). | Scale `STOP_REST_WEEKS` by the factor (e.g. Heavy Men: 8 × 1.4 ≈ 11 weeks; Women Light: 8 × 0.44 × 0.13 ≈ 0.5 weeks → min 1 week). |

---

## 3. Depth target 7+: what the PLAYER decides differently

1. **Booking a heavier class (Weight class factor)**
   - **Choice**: Player selects a fighter limit (57/60/65/75 kg for women; 57.5/60/70/75 kg for men) in `scripts/state/ProLadder.gd` `division_for` (line 77).
   - **Number change**: The stoppage risk multiplier increases from Light (0.44/0.13) to Heavy (0.51/0.21) for women, or 55% to 75% for men. A Heavyweight men's bout has ~1.36x the stoppage risk of a Lightweight men's bout (75/55).

2. **A heavy hitter in the other corner (Opponent KO share factor)**
   - **Choice**: Player scouts an opponent with a high KO share (`opp["ko"] / opp["w"]`) in `scripts/state/ProLadder.gd` `scout` (line 305).
   - **Number change**: The `stop_chance` multiplier (from the class/sex factor) multiplies the opponent's `ko_share`. A Heavyweight opponent with 79% KO share (Research SQ257) vs a Lightweight with 49% KO share changes the base risk by 1.61x (79/49) before the class factor.

3. **Women's division where decisions dominate (Sex factor)**
   - **Choice**: Player signs a woman fighter (sex "f") vs man ("m") in `scripts/state/ProLadder.gd` `division_for` (line 77).
   - **Number change**: The factor drops from ~1.0 (men) to ~0.44-0.51 (women) (Research SQ257). Decisions dominate because the stoppage risk is ~2x lower (e.g. 24% vs 55% for Light).

4. **The towel (Medical rest / Injury choice)**
   - **Choice**: Player chooses "Pull out" or "Fight hurt" in `scripts/state/Injuries.gd` `choice_modal` (line 157) or `fight_hurt` (line 181).
   - **Number change**: The medical rest `STOP_REST_WEEKS` (8 weeks base) is scaled by the factor (e.g. Amateur Light: 8 × 0.13 ≈ 1 week; Heavy Men: 8 × 1.4 ≈ 11 weeks). The "Pull out" cost ($300) remains flat, but the "Fight hurt" energy penalty (`HURT_ENERGY`) is applied to the tank (line 184).

5. **The medical rest (Injury recovery)**
   - **Choice**: The game auto-calculates `until_day` in `scripts/state/Injuries.gd` `_hurt` (line 237).
   - **Number change**: The `days_out` from `InjuryRoll` is multiplied by the class/sex/amateur factor (e.g. Amateur Light: 14 days × 0.13 ≈ 2 days; Heavy Men: 14 days × 1.4 ≈ 20 days).

6. **Booking a pro debut vs amateur (Amateur/Pro factor)**
   - **Choice**: Player turns pro in `scripts/state/ProLadder.gd` `join` (line 107) vs amateur bouts in `scripts/rules/BoutRules.gd`.
   - **Number change**: Amateur rates are ~1/6 to 1/5 of pro rates (Research SQ257). The factor changes from ~1.0 (pro) to ~0.13-0.21 (amateur) for the same class/sex.

7. **Early-career pro adjustment (4-6 rounds)**
   - **Choice**: The debut bout is 4 rounds (`scripts/state/ProLadder.gd` `ROUNDS_UNRANKED = 4`, line 94) vs ranked 6/8/10 rounds.
   - **Number change**: The factor is multiplied by 0.85 (Research SQ257) for the first 4-6 round bouts (estimated in `Matchmaking.stop_chance` proposal).

---

## 4. Plain words summary

**Section 1** documents that the code today treats every boxer (flyweight woman to heavyweight man, amateur to pro) identically: the stoppage risk (`stop_chance`) is a flat function of win chance and opponent KO share; the hurt state is a flat margin/power/chin check; the medical rest is a fixed 8 weeks; and the offer rows display these flat numbers. The baseline probe (adding a `tools/` script) would confirm the rate is identical (e.g. 25% for a 0.5 win chance / 0.5 KO share opponent) across all divisions.

**Section 2** proposes placing the multiplier in `Matchmaking.stop_chance`. The table of factors (ESTIMATE) scales the risk: Men's Pro (Light 55%, Middle 68%, Heavy 75%), Women's Pro (0.44x-0.51x of men), Amateur (0.13x-0.21x of pro), and Early Pro (0.85x). The menus to build are the offer card risk bar, the coach's read line, the result's "what decided it" line, and the medical rest weeks (scaled from 8 weeks).

**Section 3** lists 7 player decisions: booking a heavier class (changes factor from 0.44 to 0.51 or 55% to 75%), facing a heavy hitter (multiplies by opponent KO share), choosing women's division (drops factor to ~0.44-0.51), using the towel (scales rest weeks), medical rest duration (scales `days_out`), turning pro vs amateur (changes factor from ~1.0 to ~0.13-0.21), and early pro bouts (0.85x adjustment). Each choice changes a specific number in the `stop_chance` or `next_weeks` calculation.

FILE LIST OPENED:
- `ops/research/TASK_DMGCLASS1.md`
- `ops/research/RESEARCH_STOPS_BY_CLASS_SEX_BRIEF_DOLA.md`
- `ops/research/topics/knockdowns_stoppage.md`
- `ops/research/topics/body_damage.md`
- `ops/research/CRITIC_PACK.md`
- `scripts/rules/Matchmaking.gd`
- `scripts/state/RingDuel.gd`
- `scripts/rules/BoutRules.gd`
- `scripts/state/Injuries.gd`
- `scripts/state/ProLadder.gd`
- `scripts/ui/ProFights.gd`
- `tests/stop_mult_test.gd`
- `tests/women_classes_test.gd`

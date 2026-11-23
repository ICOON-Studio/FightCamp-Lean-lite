# CARDPROTO3_CRITIC_ARENA — Fresh Code-Checked Critique of the Boxing Card Prototype (Round 3)

## Scores

| Dimension | Score | Bar to Keep | Verdict |
|---|---:|---:|---|
| **DEPTH** | **5.5 / 10** | 8.0+ | **Below bar — do not ship as-is.** Clean 1-card rock-paper-scissors-with-range core, broken open by a 76–82% 3-punch combo exploit, 6 code bugs/inert mechanics, a net-negative `Predict` button, `<1 pp` film impact, and 5 unplayable style pairs. |
| **PLAY (Fun)** | **5.0 / 10** | 8.0+ | **Below bar — do not ship as-is.** 78.2% of transcripts repeat 4 generic clauses, 12.7% print dishonest punch-outcome lines when punches miss, 94.0% of decisions are 5-0 unanimous rubber stamps, and `ui.js` locks play to 2 female boxers who can never face a Counter-puncher. |
| **GENERAL** | **5.5 / 10** | — | Pure, deterministic, dependency-free JS architecture (`rules*.js`), undermined by harness blind spots (`balance.mjs` never tests combos, doubles card-share denominators to 200%, skips legal mirror pairs, and passes inert mechanics via synthetic unit-test fixtures). |

---

## 1. Methodology & Bouts Played

All 7 rule modules (`README.md`, `rules.js`, `rules-data.js`, `rules-exchange.js`, `rules-ai.js`, `rules-camp.js`, `rules-tell.js`, `rules-judge.js`), the browser UI (`index.html`, `ui.js`, `ui-helpers.js`), `balance.mjs`, and all 5 test suites (`rules*.test.mjs`) were audited line-by-line before running simulations through the real `createGame → pickCampCard (×4) → startFight → playExchange / pickCorner` loop in Node:

1. **30 inspected full bouts** across all 10 legal cross-club same-sex pairings (`ada`, `mara`, `lena`, `ines` for women; `tomas`, `rio`, `kwame`, `piotr` for men) and 6 policies (`AI-vs-AI`, `Random`, `Always-Cross`, `Largest-Damage 1-card`, `Public Reader 1-card`, `3-Punch Combo`), logging round-by-round scorecards, wind low-water marks, knockdowns, stoppages, and verbatim transcripts.
2. **Matched-seed Monte Carlo sweeps** (`N = 1,000` to `5,000` bouts per arm on identical seeds across all 8 boxers) isolating dominant strategies, smart-vs-random edges, tell wind thresholds, film scouting, `React` vs `Predict` confidence thresholds, every camp drill, every corner card, card domination swaps, transcript repetition, judge split rates, and all 16 style pairs (both shipped roster and stat-equalized at 70).

### Sample from the 30 Individual Inspected Bouts

| # | Seed | Policy | Matchup (Styles) | Film | Ex | Min Wind | Damage | Winner & Result |
|---:|---:|---|---|---:|---:|---:|---|---|
| 1 | 101 | `ai_vs_ai` | `ada (out) v mara (pressure)` | 2 | 18 | 0 | 41 : 98 | Opponent (`26-29` ×5) |
| 2 | 118 | `random` | `ada (out) v lena (out)` | 2 | 18 | 0 | 58 : 80 | Opponent (`27-29` ×5) |
| 3 | 135 | `same_cross` | `mara (pressure) v ada (out)` | 2 | 18 | 35 | 57 : 44 | Player (`29-28` ×5) |
| 4 | 152 | `max_dmg_1` | `mara (pressure) v ines (volume)` | 2 | 18 | 3 | 95 : 118 | Opponent (`27-29` ×5) |
| 5 | 169 | `reader_1` | `lena (out) v ines (volume)` | 2 | 18 | 0 | 58 : 67 | Opponent (`29-28`, `28-29` ×4) |
| 6 | 186 | `combo_3` | `ines (volume) v mara (pressure)` | 1 | 18 | 9 | 93 : 48 | Player (`29-27` ×5) |
| 7 | 203 | `ai_vs_ai` | `tomas (counter) v kwame (pressure)` | 1 | 18 | 0 | 77 : 72 | Player (`28-26` ×5) |
| 9 | 237 | `same_cross` | `rio (counter) v kwame (pressure)` | 0 | 18 | 0 | 72 : 100 | Opponent (`26-29` ×5) |
| 11 | 271 | `reader_1` | `kwame (pressure) v tomas (counter)` | 1 | 14 | 26 | 105 : 25 | Player (`STOP R3` — hurt & out of wind) |
| 14 | 322 | `random` | `piotr (volume) v rio (counter)` | 2 | 17 | 0 | 18 : 106 | Opponent (`STOP R3` — hurt & out of wind) |
| 17 | 373 | `reader_1` | `ada (out) v lena (out)` | 2 | 18 | 1 | 67 : 61 | Opponent (`27-29` ×5) |
| 21 | 441 | `same_cross` | `ines (volume) v mara (pressure)` | 1 | 18 | 31 | 54 : 57 | Opponent (`27-29` ×3, `29-28` ×2) |
| 22 | 458 | `max_dmg_1` | `tomas (counter) v kwame (pressure)` | 1 | 18 | 22 | 48 : 29 | Player (`29-27` ×5) |
| 24 | 492 | `combo_3` | `rio (counter) v kwame (pressure)` | 1 | 18 | 0 | 71 : 69 | Player (`28-26` ×5) |
| 28 | 560 | `max_dmg_1` | `piotr (volume) v tomas (counter)` | 2 | 18 | 16 | 106 : 58 | Player (`30-26` ×5) |
| 30 | 594 | `combo_3` | `lena (out) v ada (out)` | 1 | 18 | 0 | 97 : 68 | Player (`30-27` ×3, `29-28` ×2) |

*(Across all 30 inspected bouts: `max_dmg_1` 3/5, `combo_3` 3/5, `ai_vs_ai` 2/5, `reader_1` 2/5, `random` 2/5, `same_cross` 1/5; 23 of the 27 decisions had all 5 judges submit identical totals.)*

---

## 2. Core Findings & Measured Evidence

### A. Dominant Strategy — Yes: Blind 3-Punch Combo Mashing Wins 76.3% (81.5% with Basic Reads)

`balance.mjs` only tests single-card plays. In the actual rules (`rules-exchange.js:165-355`) and browser UI (`ui.js:244-292`), **selecting up to 3 distinct punch cards every exchange in `React` mode — completely ignoring tells, film, range, defence, and wind — is a game-breaking dominant strategy**:

| Policy vs Engine AI (Matched Seeds, All 8 Boxers) | Bouts | Win Rate | Player Stoppage % | Foe KD / Bout |
|---|---:|---:|---:|---:|
| Random legal 1-card (`React`) | 1,000 | **37.4%** | 4.1% | 0.31 |
| Style weights only (`chooseStyleCard`, 1-card) | 1,000 | **38.4%** | 4.5% | 0.34 |
| Always-same-card best (`Always Uppercut`, 1-card) | 1,000 | **38.4%** | — | — |
| Always-largest-damage (1-card, affordable) | 1,000 | **46.8%** | 6.1% | 0.33 |
| Predictor arm (`balance.mjs`, 31.2% `Predict`, 1-card) | 5,000 | **50.0%** | — | — |
| Engine AI (`chooseAiCard`, 1-card) | 2,000 | **50.0%** | 7.0% | 0.34 |
| Blind `expectedSwing` vs foe style (no tell, no film, 1-card) | 3,000 | **54.4%** | — | — |
| **Brainless 3-punch masher, affordable only (default camp)** | 1,000 | **50.8%** | 8.5% | 0.31 |
| **Brainless 3-punch masher, EVEN GASSED at 0 wind (default camp)** | 2,000 | **56.0%** | 10.9% | 0.33 |
| Public Reader (tell + film + wind, 1-card `React`) | 3,000 | **63.0%** | — | — |
| Matchup-ordered 3-punch combo (default camp) | 2,000 | **64.5%** | 11.3% | 0.35 |
| **Brainless 3-punch masher, UI-distinct cards (punch camp, ZERO reads)** | 2,000 | **76.3%** | **35.3%** | **0.52** |
| **Smart Reader + 3-punch combo, UI-distinct cards (punch camp)** | 2,000 | **81.0%** | **38.8%** | **0.56** |

**Four code mechanics combine to break combos wide open:**
1. **Player-only action economy (`rules-exchange.js:165,173`)**: The player can throw 3 cards per exchange (up to 18 per round); the opponent AI is hardcoded to a scalar `foeCardId` (max 6 per round).
2. **Free full-hand refill (`rules-exchange.js:354`)**: `refill(me, fight.shuffleRng, 5)` draws right back up to 5 cards after every exchange regardless of whether you spent 1 card or 3. Combos have **zero card-advantage cost**.
3. **Zero-stamina combos are legal and overpowered (`rules-exchange.js:70-79,184`)**: Being at `stamina === 0` (`meGassed = true`) never disables 2- or 3-card combos or 10-cost punches. It only applies `-0.08` accuracy and `0.6×` damage per punch — so **three gassed heavy punches at 0 wind deal `3 × 0.6 = 1.8×` a fresh heavy punch's damage every turn forever**, while banking `3×` landed punches and `3×` thrown punches on all five judges' cards (`rules-judge.js:23`).
4. **Unanswered follow-up swings & pooled knockdown roll (`rules-exchange.js:206,212,250,301`)**: The opponent strikes once against `combo[0]`; `combo[1]` and `combo[2]` take zero return fire even when they lose their cell (`'l'` still deals `0.3×` chip). Worse, `a.head` sums all 3 punches into a single `knockdownChance(a.head, foe)` check — except if `combo[0]` misses (`aList[0].hit === false`), `if (a.hit)` at line 301 is `false` even when `combo[1]` lands flush for 20 head damage!

**Why 1-card spam still wins 35–41.5% — Inverted Anti-Spam Bug (`rules-ai.js:201-207`):**
Under 1-card play (`N = 1,000`, `aiCamp`), single-card priority strategies sit between `29.6%` (`Always Block`) and `38.4%` (`Always Uppercut`; `Cross` hits `41.5%` on the 200-bout `balance.mjs` seed set). They only score that high because **the opponent AI's repeat-card counter-adaptation is coded backwards**:
```js
// rules-ai.js:201-206
var counter = CARD_ORDER.filter(function (candidate) {
  return ['W', 'w'].indexOf(RESOLUTION[candidate][id]) >= 0;
});
counter.forEach(function (candidate) {
  foeWeights[candidate] = (foeWeights[candidate] || 1) * (counts[id] >= 2 ? 4 : 1.25);
});
```
`foeWeights` is the AI's belief distribution over **what the player will throw next** (`expectedSwing(myCard, foeWeights)`). Instead of multiplying `foeWeights[id]` by `4` when the player repeats `id`, the code multiplies `foeWeights` on **the counters to `id`** — making the AI hallucinate that a player spamming `Cross` is throwing `Slip`, `Body hook`, and `Uppercut`! Verified over 500 seeds with Mara holding `['jab', 'cross', 'lead_hook', 'body_hook', 'slip']` at mid range:
- **After player throws 3 Jabs**: Mara's `Cross` (which beats `Jab`) drops from **104/500 to 0/500**, and `Slip` (`W` vs `Jab`) stays **0/500**; she throws `Lead hook` (a trade) **450/500** times.
- **After player throws 3 Crosses**: Mara holds both `Slip` (`W` vs `Cross`) and `Body hook` (`w` vs `Cross`), yet plays `Slip` **0/500** times and `Body hook` **6/500** times (`1.2%`), throwing `Lead hook` (a trade) **494/500** times (`98.8%`).

---

### B. How Much Does Smart Play Beat Random?

Restricting to fair 1-card `React` play (`N = 3,000` matched seeds):
- **Random legal 1-card**: **37.4%** (`36.9%` in `balance.mjs`).
- **`chooseStyleCard` ("best non-reader" in `balance.mjs`)**: **39.9%** — **misleading baseline**, because `chooseStyleCard` (`rules-ai.js:157-168`) never looks at the resolution matrix or opponent style at all!
- **True non-reader (`expectedSwing` vs opponent's public style weights, zero tell, zero film)**: **54.43%** (`+17.0 pp` over random just from knowing the card matrix).
- **Smart 1-card Reader (tell + film + wind)**: **63.00%** — beating random by **`+25.6 pp`**, but beating a matrix-aware non-reader by **`+8.57 pp`** (not the `+21.4 pp` advertised in `README.md`, and `balance.mjs`'s own `reading` arm at `61.3%` is only **`+6.9 pp`** above a matrix-aware non-reader, below the brief's `+10 pp` target).

---

### C. Mechanic-by-Mechanic Code & Numeric Audit (What Works vs What Is Inert)

| Mechanic | Claimed Effect | Code & Numeric Reality | Verdict |
|---|---|---|---|
| **Tell (free look R1–R3 E1)** | 60% shape read, never exact opposite | Works as written (`rules-tell.js:14-26`). Free opening look alone lifts 1-card win rate from `54.43%` → **`60.30%` (`+5.87 pp`)**. | **Works** |
| **Tell (paid looks, 4 wind)** | Scarce look; buying costs 4 wind | Charges 4 wind (`rules-tell.js:29-35`), **but wind is too cheap to make looks scarce**: buying a tell on *every* exchange (`wind > 4`, `12.0` paid looks = `48` wind/bout!) **raises** win rate monotonically (`60.30%` free-only → `62.87%` at `wind>75` → `63.80%` at `wind>50` → **`64.10%`** at `wind>4`). | **Under-costed / non-binding** |
| **Film reads & unseen odds** | Climbs as discard grows; guides reads | Hypergeometric math (`habitChanceInHand`) is honest and climbs until deck reshuffle. **However, opponent habits actually fire on only `9.4%` of exchanges** (`<5%` known; `cut_the_ring` active `0.7%`, `right_after_jab` active `5.2%` & held `21.3%`). Film alone adds **`+0.97 pp`** (`54.43%` → `55.40%`), and on top of tells adds **`+0.13 pp`** (`62.87%` → `63.00%`). *(Note: `balance.mjs` only saw `reading 61.3% > tell 59.0%` because `tellFollower` fell back to `chooseAiCard` when `!tellVisible`, whereas `reader` fell back to `swing`.)* | **Mathematically sound, nearly negligible (`<1 pp`)** |
| **React mode** | `-10%` damage taken; `Speed ≥ 65` adds accuracy | `-10%` `reactGuard` works (`rules-exchange.js:252`). `Speed ≥ 65` bonus (`(speed-65)/200`) works for 6 boxers, **0% (inert) for Mara (`58`) and Kwame (`48`)**. Opponent *always* gets `0.9` guard and `Speed ≥ 65` bonus (`rules-exchange.js:198,253`). | **Works (punishes Predict)** |
| **Predict mode** | Costs 2 wind; right read = `W` + effect (`Block +2`, `Slip/Roll` opening, `Step back` out, `Clinch -4` wind); wrong = exposed | **Severe trap button.** Guessing 1-of-17 cards from a 60% 1-of-10 shape tell succeeds only `35.7%` (`21.8%` without habit). Using `Predict` at the harness's required `20–35%` band **drops win rate by `-8.1` to `-12.8 pp`** (`predictor 50.0%` vs `tell-follower 59.0%`; threshold sweep `61.03%` at `0%` Predict vs `52.90%` at `22.5%` Predict). Only positive EV at `p ≥ 0.70` (`2.5%` of exchanges, `+1.40 pp`). **Bug:** `Predict` on `Clinch` drains **`1` wind, not `4`** (`rules-exchange.js:260`; test `1203` was fooled because `Jab` itself cost `4` wind: `4 + 1 = 5 ≥ 4`). **Bug:** `Pull counter` never sets `opening = true` (`rules-exchange.js:219`). | **Net-negative trap & partially bugged** |
| **Won Clinch `-15%` smother** | *"leaves his next punch 15% looser; losing Clinch vs Uppercut/Roll loses wind"* | **100% INERT BUG (`rules-exchange.js:259-270`).** Line 262 sets `foe.mods.nextPunchAcc = -0.15`, and **line 270 (`delete me.mods.nextPunchAcc; delete foe.mods.nextPunchAcc;`) deletes it in the exact same `playExchange` call!** Verified across `1,000` sequential pairs: opponent E1 Cross hit rate is **`72.20%` after a won Clinch vs `72.20%` without Clinch** (`0/1000` persisted). `rules.round3c.test.mjs:128` passed only because the test manually injected `mods.nextPunchAcc = -0.15` instead of earning it from a Clinch! Also, losing-Clinch wind loss does not exist anywhere in code. | **100% Dead Code** |
| **Accumulated Body Damage (`side.body`)** | UI Body meter (`sore` / `body badly hurt`), between-round `-6` heal, `Stool` `-6` body heal | **100% COSMETIC AFTER IMPACT.** Instant hit body damage drains `shot.body * 0.45` wind (`rules-exchange.js:257`), **but accumulated `side.body` is never read by `isHurt`, `knockdownChance`, `checkStoppage`, `cardCost`, `strike`, or `scoreRound`** (`totalDamage` in `rules-ai.js:15` is dead unused import). Setting `player.body = 999` vs `0` produces bit-for-bit identical dealt (`16.191`), taken (`1.539`), wind (`111`), KD (`0`), and stoppage (`null`). Its sole consumer is offering `Sit on the stool` (which heals `6` off that same unused number). | **100% Inert Meter** |
| **Pressure (`Cut off` → `trap` → `ropes`)** | 1 win = `trap` (+1 wind, `0.5×` escape hit); 2 wins in a row = `ropes` (`Step back` illegal) | **Unreachable & self-penalizing.** (1) `aiLegal` (`rules-ai.js:148`) exempted `clinch` from the non-punch repeat ban **but forgot `cut_off`**, so AI can never play two `cut_off`s in a row while holding any punch! Across `35,611` exchanges, `trap` occurred `1.29%` and **`ropes` was active at decision time on `0.008%` of exchanges (3 times in 2,000 bouts)**. (2) When `fight.range === 'ropes'` *does* happen, only `pivot_out` and `cut_off` list `'ropes'` in `CARDS[id].ranges` (`rules-data.js:15-69`) — **all 7 punches are penalized as "out of range" (`+1` wind, `-6%` accuracy) on the ropes!** | **Broken in AI & penalizes punches** |
| **Wind binding** | Binds 3–6% of exchanges; corner gives +8 | `>=1` legal card is unaffordable on `3.69%` of exchanges — **but on `2.73%` (`74%` of those), ALL legal cards in hand are unaffordable**, so wind rarely creates a tactical trade-off between a cheap card and a heavy card; and `gassed` (`0.6×` dmg, `-0.08` acc) never blocks 10-cost punches or 3-card combos. | **Weak / non-selective** |
| **Camp (`add` & `remove`, 16-cap)** | Informed camp beats random (`+8.5 pp`); converts cards | Informed beats random (`52.5%` vs `44.0%`). **Three defects:** (1) `removalsFor` (`rules-camp.js:25`: `Math.max(1, n)`) forces **0-card stat drills (`Weights`, `Roadwork`, `Speed ladder`, `Hard sparring`, `Film study`) to delete 1 card from your deck**, shrinking 12-card decks to 8 in camp UI. (2) `makeSide` (`rules.js:184-199`) silently forces 3 copies of both boxer habits at `startFight` — **undoing player camp removals of habit cards, and on 15-card decks (Ines/Mara/Tomas) overflowing 16 and silently deleting `val=0` cards (`feint`, `catch_breath`) the player just spent camp weeks adding!** Verified on Ines: Camp UI showed `cut_off=0, feint=2, catch_breath=2`; `startFight` rewrote it to `cut_off=3, feint=1, catch_breath=1`. (3) `DRILL_VALUE` (`rules-data.js:238`) wasn't updated after Round 3b's `+4` stat buff: `uppercut_pads` is printed as **`-0.4`** (avoided by `aiCampPick`!) while its actual measured gain is **`+6.6 pp`** (#2 best drill behind `counter_drill` at **`+10.6 pp`** and `check_hook_drill` at **`+5.3 pp`**). | **High impact, 3 structural bugs** |
| **Corner cards (6 cards)** | Honest trade-offs; AI uses 4+ | **Severe traps & a double-charge bug (`N = 1,200` marginal test):** `Sit on the stool` (`+1.6 pp`), `Ice the eye` (`+1.3 pp`), `Breathe` (`-0.2 pp` unconditional, strong when gassed). Meanwhile: **`Change the plan` (`-10.0 pp`, `42.2%` vs `52.2%`)** subtracts `-6` wind in `applyCorner` (`rules.js:244`) **AND `-6` wind AGAIN in `pickCorner` (`rules.js:322`) = `-12` wind cost** (verified: `50` stamina + `8` recovery → `46`, not `52`!), and `aiCornerPick` (`rules.js:234`) checks `side.hand.length <= 3` after `refill(..., 5)` already ran, so **AI picks `change_plan` `0 / 3,988` times (`0.0%`)** (`breathe` + `ice_eye` = `82.0%` of AI picks). **`Gloves high` is `-7.7 pp`** (`-15%` all punch damage for `-1` wind on `Block`), and **`Study` is `-4.3 pp`**. | **3 of 6 corner cards are traps; 1 is double-charged** |

---

### D. Transcript Variety, Ledger Honesty & Judges

Across `500` AI bouts (`8,910` exchanges) and a `1,000`-bout (`17,562`-exchange) ledger audit:
- **Repetitive templates**: While `416` unique full strings occurred (`16.6 / 18` distinct strings per bout because `17 × 17` card names permute), **`78.2%` of all exchange lines end in the exact same 4 generic clauses**: `"neither man gives ground"` (`27.4%` — ~5× per bout), `"the cleaner work lands"` (`22.6%`), `"the shorter answer lands first"` (`19.6%`), and `"neither man commits"` (`8.6%`).
- **Dishonest ledgers on missed punches (`12.7%` of all exchanges — ~2.3× per bout)**: `exchangeLine` (`rules-exchange.js:116`) builds text solely from the matrix `code`, ignoring `a.hit` and `b.hit` (`strike().verdict` at line 75 is completely unused dead code!).
  - On **`6.8%` of exchanges**, `ev.text` declares `"your boxer’s X beats the opponent’s Y; the cleaner work lands"` when **X missed its accuracy roll for `0.0` damage**.
  - On **`2.5%` of exchanges** (e.g. Seed 6: `player.hit=false, dealt=0.0`, `opponent.hit=true, dealt=4.6`, and Bout #6 R1E1 above), `ev.text` says *your card beat theirs* while **they dealt `4.6` damage to you and the UI banner says `"the opponent takes the exchange"`**!
  - On **`5.9%` of exchanges**, `ev.text` prints `"X and Y trade; neither man gives ground"` when at least one punch whiffed.
- **House-rule gender leaks in women's bouts**:
  - `LINE_WHY.X` (`rules-exchange.js:108`) is hardcoded to **`'he read it coming'`**. In `ada v mara` (two women), a wrong `Predict` against an unnamed `'w'` cell prints: **`"the opponent’s uppercut catches your boxer’s jab; he read it coming"`** (`178` occurrences in women's bouts).
  - Women's bouts print **`"man"`** (`"neither man gives ground"`, `"neither man commits"`, `"punishes a man..."`) **`~6.8` times per bout** (`3,409` times across ~500 women's bouts).
- **Rubber-stamp judges & R3-only stoppages**:
  - Out of `1,771` decisions (in 2,000 bouts), **`94.0%` (`1,665`) are `5-0` unanimous**, and **`80.7%` (`1,429`) have all five "taste-distinct" judges submit the exact same scorecard numbers**. Judges disagree with raw round damage in only `2.3%` of rounds because `damage * (1.00..1.75)` swamps `landed` (`0..6`) and `defencePoints`.
  - `94.5%` of stoppages happen in Round 3 (`r1: 1`, `r2: 11`, `r3: 205` in `balance.mjs`).

---

### E. Are All 16 Style Pairs Fair from Both Corners? — No

1. **5 of 16 ordered style pairs cannot be booked at all, and 1 legal pair fails `42–58%` (`balance.mjs` hid it):**
   - Women (`she`): `ada` (Out, North), `lena` (Out, South), `ines` (Volume, North), `mara` (Pressure, South) — **zero female Counter-punchers**.
   - Men (`he`): `tomas` (Counter, North), `rio` (Counter, North), `kwame` (Pressure, South), `piotr` (Volume, South) — **zero male Out-boxers**, and both Counter-punchers share `North` club.
   - Result: **`out v counter` (`0` pairs)**, **`counter v out` (`0` pairs)**, **`pressure v pressure` (`0` pairs)**, **`counter v counter` (`0` pairs)**, and **`volume v volume` (`0` pairs)** have **zero legal matchups** in `createGame`! And in `ui.js:15` (`PICKABLE = ['ada', 'mara']`), a browser player can **never play as or against a Counter-puncher at all**.
   - **`out v out` (`ada v lena` / `lena v ada`) IS legal**, yet `balance.mjs:176` skipped `styleA === styleB`. When actually run (`N = 500` per seat), **`ada v lena` wins only `41.4%` (`symPublic`) / `37.8%` (`shippedEngine`), and `lena v ada` wins `59.0%`** — outside the `42–58%` fairness gate! Individual pairs `rio v kwame` (`38.6%`) and `tomas v piotr` (`41.8%`) also sit below `42%` (masked in `balance.mjs` only by averaging two boxers together).

2. **Stat-equalized 16-pair matrix (`all stats = 70`, canonical style decks & weights, `N = 400` per cell) exposes massive intrinsic deck imbalance:**

| Left \ Right (Equal 70 Stats) | `out` | `pressure` | `counter` | `volume` |
|---|---:|---:|---:|---:|
| **`out`** | 49.0% | 52.8% | **34.5%** | **35.5%** |
| **`pressure`** | 46.3% | 50.0% | **26.8%** | **30.8%** |
| **`counter`** | **70.8%** | **66.5%** | 50.5% | 50.5% |
| **`volume`** | **68.3%** | **72.3%** | 49.5% | 48.8% |

At equal stats, `counter` and `volume` destroy `out` and `pressure` (`66.5%–72.3%`) because `counter`/`volume` carry 2× `Cross` + heavy punches while `out`/`pressure` carry zero-damage `cut_off`, `clinch` (broken smother), `step_back`, `pivot_out`, `feint`, and `catch_breath`. The roster only looked balanced in `balance.mjs` because Mara (`74` pow, `84` stam, `76` chin) and Kwame (`86` pow, `80` chin) were given raw stat crutches and `out v counter` (`34.5%`) could never be paired.

3. **Corner / Chair symmetry**: Same-boxer chair swaps sit at `51.4%` overall (`46.6%–53.4%` on individual pairs under `symPublic` because `opponentCamp` hashes `'foeCamp'` while player camp uses raw `seed`, giving the two chairs different camp offers on the same seed). Note also `expectedSwing` (`rules-ai.js:126`) uses static `RESOLUTION` instead of range-aware `resolutionAt(..., fight.range)`, misreading `Jab > Uppercut` at `out/mid` and `Slip > Lead hook` (`W`) at `inside`.

---

## 3. Useless, Dominated & Mismeasured Cards

*(Note: `balance.mjs:232-234,353` sums `player` + `opponent` plays and divides by `stats.exchanges`, inflating every card's reported `share` by **2×** so the column sums to `200%`! True per-turn play shares are half of `balance.mjs`'s table.)*

### Fight Cards
1. **`Pull counter` (Strictly Dominated by `Slip`)**: Costs **6 wind** (vs `Slip`'s **4**), restricted to `out, mid` (vs `Slip`'s `out, mid, inside`), deals **0 damage** (`kind: 'defence'`), loses `'l'` to inside `Lead hook` (where `Slip` gets `'W'`), has the exact same `W` cells (`jab`, `cross`, `cross_counter`), and **omits `opening = true`** (`rules-exchange.js:219,230` checks `['slip', 'roll']` only!). Paying +2 wind to lose inside range and lose `+30% dmg / +15% acc` on your next punch for `+1` counter tiebreak point (`~0.2` judge pts) is strictly worse.
2. **`Catch breath` (Trap Card — `0.63%` true turn share, `40.8%` bout win, `-14.2` true net pts/play)**: Loses to 8 cards, deals 0 damage, increases incoming body damage by `1.5×` (which drains extra wind right back via `b.body * 0.45`!), and replacing `catch_breath` with a plain `Jab` across 2,000 bouts **raises win rate by `+2.0 pp`** (`52.3%` → `54.3%`). Camp `Breath work` drops win rate by **`-3.8 pp`**.
3. **`Pivot out` (`0.74%` true turn share — below the 1% bar once the 2× bug is fixed)**: Costs **7 wind** (nearly a `Cross`), deals 0 damage, grants no `opening`, and its signature role (escaping `ropes`) triggers on `0.008%` of decisions.
4. **`Feint` (`0.76%` true turn share)**: Deals 0 damage, loses its `+15%` accuracy buff whenever the opponent wins the exchange (`rules-exchange.js:235`), has no AI follow-up rule (`chooseAiCard` never checks `me.feint` or `me.opening` on the next turn!), and gets silently deleted by `makeSide` (`val = 0`) when 15-card decks overflow 16.

### Corner & Camp Traps
5. **`Change the plan` (Corner — `-10.0 pp`, `0.0%` AI pick rate)**: Bugged `-12` wind double-charge for 2 extra cards in a game that refills to 5 every turn anyway.
6. **`Gloves high` (Corner — `-7.7 pp`)**: `-15%` damage on all punches all round to save 1 wind on `Block` (`4.1%` true play share).
7. **`Study the opponent’s corner` (Corner — `-4.3 pp`)** & **`Film study` (Camp — `-0.2 pp`)**: Spend wind or shrink your deck by 1 card to reveal a habit that fires `<5%` of exchanges.

---

## 4. Missing Cards & Options

1. **Missing Roster Coverage (4 style × sex gaps) & Full UI Picker**: Add/re-club boxers (or allow cross-club intra-squad bouts) so **both `'she'` and `'he'` have all 4 styles (`out`, `pressure`, `counter`, `volume`) across both clubs**, unlocking `out v counter`, `counter v out`, and all mirror matchups. Unlock all 8 boxers in `ui.js` (`PICKABLE = R.BOXERS.map(b => b.id)` instead of `['ada', 'mara']`).
2. **Body Jab / Straight to the Body (`cost: 4`, `shape: 'straight'`, `ranges: ['out', 'mid']`, `dmg: { head: 1, body: 4 }`)**: Currently **only one body-primary punch exists (`Body hook`, `inside` only)**. Out-boxers have zero way to invest in body work from range or punish `Block`/`Pull counter` to the body without walking inside.
3. **High Shell / Peek-a-Boo Guard or Inside Parry (`cost: 4`, `kind: 'defence'`, `ranges: ['inside', 'ropes']`)**: Currently `Block` loses to `Cut off`, `Clinch`, `Feint`, and `Uppercut` and trades with `Body hook`, leaving an inside fighter with no low-cost answer to `Uppercut` + `Clinch` mixups other than `Step back` (out of range inside!).
4. **Overhand (`cost: 9`, `shape: 'looping'`, `ranges: ['out', 'mid']`, `dmg: { head: 13, body: 1 }`)**: Pressure fighters have no power punch that reaches `'out'` range when an out-boxer steps back; an `Overhand` that reaches `'out'`/`'mid'` (beating `Jab`/`Slip`, countered `'X'` by `Roll`/`Block`) completes the range triangle.
5. **Shape-Level `Predict` (or "Call the Shape" vs "Call the Card")**: Since the tell chip is a *shape*, `Predict` should let the player call a **shape** (or 1 of 3 shapes: Straight / Looping+Uppercut / Non-punch) rather than auto-locking to `predictedCard(fight)`'s single hidden guess.

---

## 5. THE ORDERED LIST "TO REACH 10/10"

1. **Fix Combo Economy, Require Wind Upfront, and Let Opponent AI Throw 2-Card Combos (`rules-exchange.js`, `rules-ai.js`, `ui.js`)**
   - **Forbid combos when unaffordable**: In `legalNow` / `playExchange`, require `me.stamina >= totalComboCost` for any `combo.length > 1` (gassed fighters can only throw **1 single card**, never 2–3).
   - **Stop free full-hand refills on combos**: In `playExchange` (`line 354`), draw **at most `2` cards per exchange** (`Math.min(5, side.hand.length + 2)`), full-refilling to 5 only in `pickCorner`. Throwing a 3-card combo now genuinely costs hand cards on the next exchange.
   - **Require a setup lead card for combos**: Card 1 of a combo must have `cost <= 5` or `setsUp: true` / `shape === 'feint'` (e.g., `Jab-Cross`, `Feint-Lead hook`, `Jab-Jab-Cross`), forbidding raw `Uppercut-Cross counter-Cross` haymaker stacks; and fix `if (a.hit)` (`line 301`) to check each landed punch in `aList` individually for `knockdownChance(hit.head, foe)` instead of pooling `aHead` gated on `aList[0].hit`.
   - **Fix UI duplicate-card selection & reveal (`ui.js:226,246,266`)**: Track selected hand **indices** (`S.comboIdx = []`) instead of `S.combo.indexOf(id)` so `Double-jab` (`['jab', 'jab']`) is clickable, and render all played combo cards in `buildStage`.
   - **Give `chooseAiCard` 2-card `Jab → Power` combos** when `stamina >= cost + 8` and add a `3-card combo` arm to `balance.mjs` (gate: no combo arm `>68%` vs engine, brainless combo masher `<48%`).

2. **Fix the Six Confirmed Engine Bugs (`rules-exchange.js`, `rules-ai.js`, `rules.js`, `rules-camp.js`)**
   - **Un-break Clinch's `-15%` smother (`rules-exchange.js:199,259-270`)**: Capture `meAccPenalty = me.mods.nextPunchAcc || 0` and `foeAccPenalty = foe.mods.nextPunchAcc || 0`, **`delete me.mods.nextPunchAcc; delete foe.mods.nextPunchAcc;` BEFORE lines 259–269**, then set `foe.mods.nextPunchAcc = -0.15` on a won `Clinch` so it actually survives to the next exchange. Fix `rules.round3c.test.mjs` to test a real 2-exchange `Clinch → Cross` sequence without manual flag injection.
   - **Fix inverted anti-spam in `chooseAiCard` (`rules-ai.js:201-207`)**: Replace the `counter.forEach` loop with `foeWeights[id] = (foeWeights[id] || 1) * (counts[id] >= 2 ? 3.5 : 1.35);` so `expectedSwing` counters the **repeated card itself**, not its counters.
   - **Fix `change_plan` `-12` wind double-charge & 0% AI pick (`rules.js:234,322-323`)**: Remove lines 322–323 (or remove `stamina: -6` in `CORNER_CARDS` and apply `-6` after the `+8` refill so net change is always `+2` wind, costing `6`, not `12`), and change `aiCornerPick` (`line 234`) from impossible `side.hand.length <= 3` to `side.stamina >= side.maxStamina * 0.65 ? 2.4 : 0.4`.
   - **Fix `aiLegal` + `'ropes'` range bug (`rules-ai.js:148`, `rules-data.js:15-69`, `rules-exchange.js:132-154`)**: Exempt `id !== 'cut_off'` alongside `'clinch'` in `aiLegal` so AI can reach the ropes; add `'ropes'` to `ranges` on `cross`, `lead_hook`, `body_hook`, `uppercut`, `check_hook`, `cross_counter`, `slip`, `block`, `roll`, `clinch` (only `jab`, `step_back`, `pull_counter` should be cramped on the ropes); and apply `'inside'` overrides in `resolutionAt` when `range === 'ropes'` too.
   - **Stop `makeSide` from rewriting Camp decks (`rules.js:176-199`, `rules-camp.js:23-27`)**: Start all 8 boxers with **16-card base decks** that already include 3 copies of their two signature cards; make `removalsFor` return **`0` for pure stat drills** (`n` instead of `Math.max(1, n)` so `Roadwork`/`Weights`/`Film` don't eat cards); and remove the post-camp `while (count < 3)` re-injection for the human `player` side so Camp removals are respected 100%.
   - **Use range-aware `resolutionAt(cardId, oid, fight.range)` inside `expectedSwing` (`rules-ai.js:126`)** and reward follow-up power punches when `me.opening || me.feint || me.combo` is active on both seats.

3. **Make Accumulated `side.body` & Stamina Drain Actually Bind (`rules.js`, `rules-exchange.js`)**
   - **Wire `side.body` into max wind & stoppage**: Cap effective round stamina recovery or `effectiveMaxStamina = maxStamina - Math.floor(side.body * 0.35)` so body investment (`Body hook`, `Body work`, `Sit on the stool`'s `-6` body heal) visibly shrinks the opponent's gas tank in Rounds 2–3, and add a body-TKO check in `checkStoppage` (`side.body >= 72 && side.stamina <= 0` → `'folded to the body'`).
   - **Make `gassed` truly hurt (`rules-exchange.js:70-79`)**: Drop gassed punch multiplier from `0.6×` to **`0.42×`**, accuracy penalty from `-0.08` to **`-0.15`**, and increase defender knockdown vulnerability when `stamina === 0` by `+25%`. Now spending `4` wind on every tell (`48` wind/bout) punishes reckless buyers instead of lifting win rate to `64.1%`.

4. **Redesign `Predict` Around Calling a Shape (or Explicit Card Choice) & Fix `Clinch` Predict (`rules-exchange.js`, `ui.js`)**
   - Currently `Predict` auto-guesses `predictedCard(fight)` (`35.7%` hit rate) and costs `-9.0 pp`. Change `Predict` (`cost: 2` wind) to **let the player pick which Shape (or Top-3 habit/tell candidate card) they are calling**, OR convert `Predict` to **"Sit Down / Commit"**: if your chosen card already wins `'W'`/`'w'` against `foeCardId` **or** matches the active habit/tell shape (`~55%` hit rate), deal `+35%` damage / double defensive effect (`Block +3` wind, **`Clinch -4` foe wind** at `rules-exchange.js:260` when `correctRead`, `Step back` guaranteed range shift + `-2` foe wind); if wrong (`'l'`/`'X'`), take `1.25×` damage without also upgrading `'t' → 'w'` on neutral trades. Target: selective `Predict` (`15–25%` of exchanges) beats pure `React` by `+2` to `+4 pp`.

5. **Rebalance Dead/Dominated Cards, Corner Traps & `DRILL_VALUE` (`rules-data.js`, `rules-exchange.js`)**
   - **`Pull counter`**: Change `kind` from `'defence'` to **`'punch'`** with `dmg: { head: 9, body: 0 }`, `cost: 6`, `acc: 0.78`, `ranges: ['out', 'mid']` (or keep `'defence'`, lower `cost` to **4**, set `opening = true` with `+45%` next-punch damage so it has a high-reward range niche distinct from `Slip`).
   - **`Catch breath`**: Increase wind restore from `+6` to **`+10`** (net `+9` after 1 cost) and make it `n` (instead of `'l'`) against `Jab` at `'out'` range so backing out with `Step back → Catch breath` is a real tactical sequence instead of `-14.2` net pts/play.
   - **`Pivot out`**: Lower `cost` from `7` to **`5`**, grant `+10%` accuracy on your next punch (`angle = true`), and keep `'ropes'` escape.
   - **`Feint`**: Cost `2`, keep `feint = true` (`+15%` acc, **`+15%` dmg** on next punch) unless hit by `'W'` or `'w'` with **`b.hit === true`** (currently even a *missed* `'w'` punch cancels your feint at `line 235`!).
   - **Corner cards**: Buff `Gloves high` from `punch: -0.15` to `punch: -0.05` + `guardBonus: +0.10` all round; buff `Study` to `stamina: -2`, reveal 1 habit **and** give a free tell look on Exchanges 1 & 2 of the new round.
   - **Film habits**: Raise habit fire probability when active & held from `0.70` to **`0.82`**, and replace ultra-rare triggers (`cut_the_ring` `0.7%`) with live triggers (`inFightRange: 'out'` → `cut_off` or `jab`, `foeLowStamina: true` → `body_hook`) so film scouting is worth **`+4` to `+6 pp`** instead of `<1 pp`.
   - **Re-compute `DRILL_VALUE`** in `rules-data.js` after the fixes so `uppercut_pads` and `check_hook_drill` are accurately ranked.

6. **Fix Roster Style Coverage, Stat Gaps, Judges & Honest Dynamic Transcripts (`rules-data.js`, `rules-exchange.js`, `rules-judge.js`, `balance.mjs`)**
   - **Complete all 16 style pairs**: Add 2 boxers (1 female Counter-puncher in South, 1 male Out-boxer in South) or rebalance club tags across an 8–10 boxer roster so every non-mirror style pair (`out v counter` included!) has legal female and male bouts; tighten base stat totals (`405–425` instead of Kwame `388` vs Tomas `440`) and give `out` and `pressure` starter decks enough scoring punch density (`Body jab` / `Overhand` / 2nd `Cross` or `Check hook`) so the stat-equalized 16-pair matrix stays within **`44–56%`** across all 16 cells.
   - **Make exchange lines honest about misses & gender (`rules-exchange.js:106-130`)**: Check `a.hit` and `b.hit`! When the matrix winner misses (`!a.hit`), use `strike().verdict` (`"your boxer’s uppercut has the angle on the cross, but misses wide"` — and if `b.hit`, `"and the cross clips on the way out"`). Replace `'he read it coming'` (`line 108`) with `'read it coming'` and replace `'neither man...'` / `'a man...'` with `'neither fighter...'` / `'an opponent...'`. Add 3–4 deterministic seeded phrasings per outcome/range so transcripts don't repeat `"neither man gives ground"` 5 times a bout.
   - **Differentiate the 5 judges (`rules-judge.js:20-26`)**: Normalize `landed` (`×3.0` weight scale so 1 landed punch ≈ 3–4 damage pts) and `defencePoints` (`×1.5`) relative to `damage` (`0.8–1.5`) so volume/defence judges (`S. Boateng`, `K. Osei`) genuinely split close rounds against power judge `M. Petrov` (`15–25%` split decisions instead of `6.0%`).
   - **Fix `balance.mjs` gates**: Divide per-card `plays` by `stats.exchanges * 2` (so `share` sums to `100%`, not `200%`), fix `c.net` to track both seats or divide by `player` plays only, remove `if (styleA === styleB) continue;` where legal pairs exist, fail if any non-mirror style pair has `0` bouts, and add a multi-card combo exploit gate.

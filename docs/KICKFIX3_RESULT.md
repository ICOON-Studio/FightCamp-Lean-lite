# KICKFIX3 — E2 and E3 measured at N=12 and N=56; reflex check caps the limp loop, both hold 5 of 9 bars

2026-11-26 · ARENA cloud clone · kickboxing · no page, tool, or test changed.

Both prepared versions (**E2** and **E3**) survived their N=12 trials and completed full N=56 runs, committed and pushed one run at a time (`bc00318`, `31aa76c`, `37dd456`, `92d0528`). S563's structural fix worked on its target loop: making **Hold your ground** and **Back off** check low kicks by reflex kept stoppages-after-a-limp to **0/7 (0%)** and **0/2 (0%)** at N=12, and **0/31 (0%)** and **3/28 (10.7%)** at N=56. Because neither version triggered the >50% limp stoppage alarm, the second cap (`N.limp` 4 → 6, `kick_fix_e2c.json` / `kick_fix_e3c.json`) was not needed and not run.

At N=56, **E2 and E3 both pass 5 of 9 bars** — keeping all four kicks alive (unlike B's 6/9 with dead body and head kicks) and eliminating E1's limp spiral, but still failing four bars (razor-thin 3% dead-switch edge, low-kick/overhand landing >65%, knockdowns/stoppages >2.5 / >40%, and two-hand punch plans <15%). Neither clears B's 6/9 bar count or the 8/9 page bar yet.

## Measurements

Use and landing rates combine both corners (`use` = selections per fighter-beat; `lands` = hits / (hits + blocks + misses); bar percentages follow `balance.mjs` rounding, with exact fractions alongside). Limp counts follow KICKFIX2's definition (bouts where at least one fighter reached `legs >= N.limp` by the end of the bout, and the share of stoppages with a limp by the stopping beat).

| Version | N | Bars passed | Each red bar with its number | Low kick lands | Body / head kick used and lands | Limp bouts and stoppages after a limp | Knockdowns | Stoppages |
|---|---:|---|---|---|---|---|---|---|
| **E2** (`kick_fix_e2.json`) | 12 | **5/9** | **Dead switch:** Overhand 3% (2.7%), Rear uppercut 2% (2.2%). **Landing:** Jab 69% (short 0%), Body hook 72% (short 6%), Low kick 79% (short 0%). **Bout endings:** stops 58% (>40%), draws 0%, KD 3.3 (>2.5). **Plan mix:** two 9%, none 29%. | **79.3% (23/29)** | **Body:** used 13.0% (54/414), lands 40.8% (20/49). **Head:** used 4.3% (18/414), lands 44.4% (8/18). | **0/12 limp bouts (0%)**; **0/7 limp stops (0%)** | **3.3 / bout (40/12)** | **58.3% (7/12)** |
| **E3** (`kick_fix_e3.json`) | 12 | **4/9** | **Dead switch:** Push off 3% (2.8%), Rear uppercut 2% (2.4%), clinch 2% (2.1%). **Landing:** Body hook 74% (short 5%), Overhand 70% (short 30%), Low kick 87% (short 0%). **Bout endings:** stops 17%, draws 8%, KD 2.8 (>2.5). **Plan mix:** two 8%, none 29%. **Mirror:** 36% (4/11, <40%). | **86.9% (53/61)** | **Body:** used 13.0% (55/424), lands 44.2% (23/52). **Head:** used 5.4% (23/424), lands 34.8% (8/23). | **1/12 limp bouts (8.3%: 1 pts)**; **0/2 limp stops (0%)** | **2.8 / bout (34/12)** | **16.7% (2/12)** |
| **E2** (`kick_fix_e2.json`) | 56 | **5/9** | **Dead switch:** Rear uppercut 3% (2.9%, 55/1916). **Landing:** Low kick 85% (short 0%). **Bout endings:** stops 55% (>40%), draws 2%, KD 3.4 (>2.5). **Plan mix:** two 9% (8.9%), none 33% (32.9%). | **85.4% (123/144)** | **Body:** used 15.1% (289/1916), lands 40.7% (111/273). **Head:** used 6.2% (119/1916), lands 59.3% (70/118). | **1/56 limp bouts (1.8%: 1 pts)**; **0/31 limp stops (0%)** | **3.4 / bout (192/56)** | **55.4% (31/56)** |
| **E3** (`kick_fix_e3.json`) | 56 | **5/9** | **Dead switch:** clinch 2% (2.3%, 43/1868). **Landing:** Body jab 67% (short 0%), Overhand 73% (short 26%), Low kick 87% (short 0%). **Bout endings:** stops 50% (>40%), draws 4%, KD 3.1 (>2.5). **Plan mix:** two 8% (8.1%), none 30% (30.1%). | **87.2% (212/243)** | **Body:** used 13.9% (260/1868), lands 48.0% (119/248). **Head:** used 6.5% (121/1868), lands 45.4% (54/119). | **10/56 limp bouts (17.9%: 3 stops, 7 pts)**; **3/28 limp stops (10.7%)** | **3.1 / bout (176/56)** | **50.0% (28/56)** |

Reference baselines (`RED_TEST`): **B** at N=56 passed **6/9** with dead kicks (Body kick 1%, Head kick 0%), Low kick landing 70%, 2.7 knockdowns/bout, 32% stoppages; **E1** at N=12 (KICKFIX2) passed **4/9** with Low kick landing 93.4% (71/76), 5/9 limp stoppages (55.6%), 3.5 knockdowns/bout, 75% stoppages. `kick_fix_e2c.json` and `kick_fix_e3c.json` (`N.limp` 4 → 6) were not created or run because neither E2 nor E3 fired the limp alarm.

Green bars at N=56 for both E2 and E3 (5 of 9):
- **Range** (`15–55%` each): E2 Inside/Mid/Long **26% / 37% / 37%**; E3 **24% / 31% / 45%**.
- **No mandatory switch** (`<=40%`): E2 top Cross **30%**, step in **28%**; E3 top Cross **26%**, step in **25%**.
- **Clinch rescue** (`<=2.0/bout`): E2 **0.9**; E3 **0.5**.
- **Order is a choice** (`ordered >=40%`, `first <=60%`): E2 ordered **56%**, first feet **56%**; E3 ordered **62%**, first feet **54%**.
- **Mirror fairness** (`40–60%` of decided): E2 **58%** (32/55, 1 draw); E3 **44%** (24/54, 2 draws). (E3's N=12 36% was sample noise and settled inside 40–60% at N=56.)

## Feedback loops

- **Limp loop (`N.limp = 4`, reflex check on `hold` and `back`):** Capped by the reflex check alone.
  - **E2:** 0/12 limp bouts at N=12 (0/7 limp stoppages); 1/56 limp bouts at N=56, ending on points (0/31 limp stoppages).
  - **E3:** 1/12 limp bouts at N=12, ending on points (0/2 limp stoppages); 10/56 limp bouts at N=56, ending in **3 stoppages and 7 points decisions** (**3/28 = 10.7%** of stoppages, all 3 with prior-beat limp onset). Even when fighters reached four leg marks in E3, 7 of 10 survived to the final bell because a limping fighter who cannot `back off` still checks low kicks automatically whenever holding ground (`feet = 'hold'`).
- **Stamina loop (`N.capMin = 4`):** All bouts in all four runs reached at least one bell.
  - **E2:** mean stamina bar at most recent completed bell **6.50 of 8** at N=12 (mean current stamina 2.67; bout-end bar 6.08) and **6.30 of 8** at N=56 (353/56; mean current stamina 2.48; bout-end bar 6.03).
  - **E3:** mean stamina bar at most recent completed bell **5.83 of 8** at N=12 (mean current stamina 2.75; bout-end bar 5.67) and **6.12 of 8** at N=56 (342.5/56; mean current stamina 2.36; bout-end bar 5.91). Cheaper 2-stamina body kicks lowered the last-bell bar by only 0.19 vs E2 at N=56 and did not collapse stamina to `capMin = 4`.

## Which bars killed E2 and E3 at N=56, and what to try next (not run)

1. **Low-kick landing ceiling (`85.4%` in E2, `87.2%` in E3 vs `<=65%`):**
   - Reflex checks on `hold` and `back` cut low-kick volume vs E1 (from 19% down to 8% in E2 and 13% in E3) and stopped the limp spiral, **but** `hold + back` is only 33% of fighter-beats in E2 and 31% in E3 — and much of `hold` happens Inside where kicks do not reach. At Long and Mid, fighters either `step in` (25–28%) or throw a kick (35% in E2, 42% in E3), and **every kick leaves the kicker's own leg unchecked** (`c.leg` is set only on `hold` or `back`). Meanwhile `N.checkHurt = 1` against `low.d = 1` + `W.leg = 0.5` is too mild to deter firing low kicks into kick-heavy Mid/Long mixes.
   - **Try next:** On E3, raise **`N.checkHurt` 1 → 2** (checking a low kick hurts the kicker's shin for 2 health, forcing low kicks to wait for real reads and lifting `hold`/`back` share at Mid/Long) or let **`teep`** (lead-leg push kick, lead leg already chambered) also cover `c.leg = 1`.
2. **Bout endings (`3.4 KD / 55% stops` in E2, `3.1 KD / 50% stops` in E3 vs `<=2.5 KD / <=40% stops`) and Overhand landing (`73%` in E3; `90%` on 0.89/bout in E2):**
   - Lighter 2-damage body kicks moved E3 in the right direction (`3.7 KD` in A → `3.4` in E2 → `3.1` in E3; `55%` → `50%` stops), but every rear-leg kick (`low`, `bodyk`, `headk` = 29% of beats in E2, 34% in E3) sets `rearLeg: 1`, dropping the rear hand in that moment. That lets `Overhand` (`4` damage, `5` as a counter) and `Head kick` (`4` damage) land unblocked on kick beats, driving knockdowns over 2.5 against `N.hp = 18`.
   - **Try next:** Remove **`rearLeg: 1` from `low`** (keep `rearLeg: 1` on high-commitment `bodyk` and `headk` only: a low thigh chop can keep the rear glove by the chin). That directly blocks free Overhand counters on low kicks (bringing Overhand under 65% and trimming knockdowns/stoppages below 2.5 / 40%).
3. **Plan punch-count mix (`two` 8–9% vs `15–45%`, `none` 30–33% vs `5–25%`) and the 3% dead-switch edge (`Rear uppercut` 2.9% in E2, `clinch` 2.3% in E3):**
   - `balance.mjs` counts **hand punches only** (`lead + rear`) in `np`: a pure kick beat counts as `none`, and a kick + punch combination counts as `one`. Because kicks occupy 35–42% of beats, cost 1–4 stamina, and forfeit `+1` home-hand recovery (`N.hold = 1`) whenever a hand punches, throwing *both* hands on top of kick threats is rarely optimal (~8–9%).
   - **Try next:** First decide whether kickboxing's plan-mix bar in `balance.mjs` should count **offensive strikes** (`lead + rear + kick`, under which kick + punch is a two-strike combination) rather than hand punches alone; if keeping the hand-punch bar unchanged, pair `low` `st: 1` (with `rearLeg: 0` above) so fighters have the stamina and rear-hand cover to combine punches with kicks and fight slightly more Inside (lifting `clinch` from 2.3% back over 3%, where `Rear uppercut` is already 3.3% in E3).

## Rules and regression checks

- `node proto/twohands/tools/kick_test.mjs`: **12 passed** (`kick.html` untouched).
- `node proto/twohands/tools/page_parse.mjs kick.html order.html switch.html`: **all three ok**.
- `git diff` on all tracked pages, tools, and tests is empty; no `*.vt.json` table is committed.
- Evaluating `kick_test.mjs`'s 12 assertions in memory against `kick_fix_e2.json` and `kick_fix_e3.json` (without editing `kick_test.mjs`, as required): **9/12 pass** on both; the 3 expected differences come directly from E2/E3's intentional reflex-check rule changes:
  - Test 1 (*"a low kick lands on a planted leg and marks it"*): passes `{}` (`feet: 'hold'`) for the defender, which in E2/E3 checks by reflex instead of leaving the leg planted.
  - Test 2 (*"a check stops the low kick and the kicker takes the damage"*): supplies the removed `feet: 'check'` switch, which no longer exists in `FEET`.
  - Test 6 (*"a rear-leg kick drops the rear hand in its moment: his overhand lands"*): the defender's default `feet: 'hold'` checks the low kick first (kicker takes 1 check damage), so the defender's overhand lands on the dropped rear hand as a 5-damage counter (`hp` 18 → 12 total) rather than a 4-damage non-counter (`hp` 14).

## Execution and reproducibility

Node v22.22.3, 2 vCPUs (`jobs=2`), `iters=300`, `seed=1` (worker seeds 100, 101), one run at a time. E2 table took 5,807 s (play: 526 s at N=12, 2,434 s at N=56); E3 table took 6,465 s (play: 675 s at N=12, 2,865 s at N=56). Run with the same observational `tmp_kick/telemetry.mjs` loader documented in `docs/KICKFIX2_RESULT.md` (plus `limpPriorStops` tracking prior-beat limp onset, zero RNG or rule changes):

```sh
node proto/twohands/tools/balance.mjs table tweak=ops/research/s558_balance/kick_fix_e2.json out=tmp_kick/kick_fix_e2.vt.json iters=300 jobs=2
node --import ./tmp_kick/telemetry.mjs proto/twohands/tools/balance.mjs play who=mix opp=mirror n=12 tweak=ops/research/s558_balance/kick_fix_e2.json table=tmp_kick/kick_fix_e2.vt.json jobs=2 json=tmp_kick/kick_fix_e2_n12.json
node proto/twohands/tools/balance.mjs table tweak=ops/research/s558_balance/kick_fix_e3.json out=tmp_kick/kick_fix_e3.vt.json iters=300 jobs=2
node --import ./tmp_kick/telemetry.mjs proto/twohands/tools/balance.mjs play who=mix opp=mirror n=12 tweak=ops/research/s558_balance/kick_fix_e3.json table=tmp_kick/kick_fix_e3.vt.json jobs=2 json=tmp_kick/kick_fix_e3_n12.json
node --import ./tmp_kick/telemetry.mjs proto/twohands/tools/balance.mjs play who=mix opp=mirror n=56 tweak=ops/research/s558_balance/kick_fix_e2.json table=tmp_kick/kick_fix_e2.vt.json jobs=2 json=tmp_kick/kick_fix_e2_n56.json
node --import ./tmp_kick/telemetry.mjs proto/twohands/tools/balance.mjs play who=mix opp=mirror n=56 tweak=ops/research/s558_balance/kick_fix_e3.json table=tmp_kick/kick_fix_e3.vt.json jobs=2 json=tmp_kick/kick_fix_e3_n56.json
```

## Page decision — three plain lines

Keep `kick.html` unchanged tonight (both E2 and E3 hold 5 of 9 bars at N=56, under the 8 of 9 bar), and use E3 as the base for the next balance pass.

In E3, holding your ground or backing off checks low kicks automatically (the separate Check button is gone), so only stepping in or kicking leaves your lead leg open.

Feints no longer uncover kicks, the low kick does 1 damage, the body kick costs 2 stamina for 2 damage (still shrinking his stamina bar), and the head kick costs 4 stamina for 4 damage.

KICKFIX3 DONE

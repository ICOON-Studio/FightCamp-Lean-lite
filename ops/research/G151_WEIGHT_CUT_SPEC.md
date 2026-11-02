# G151 — Weight cut: the fight-week choice

Research and spec only. No code. Camp diet (none / moderate / aggressive) already lives in `weight_classes.json` `diet` and `WeightCut.apply_diet_week`. This choice is the fight-week water cut on the day-before weigh-in `WeightCut.gd` already models. Same-day amateur cards (J53) do not get it. J7 stands: do not retune the 20% fine, the 3% catchweight window, the family allowance, or add a second weigh-in.

**DOCUMENTED** = measured on people. **SECONDARY** = a review, position stand, or J7's reading of a rule. **NO STUDY** = no measurement, including a shipped game constant.

## 1. Numbers

| Fact | Figure | Label | Source |
| --- | --- | --- | --- |
| Walk-around | Often 12–15% over class. Game `walk_over_limit` is 5–10%. Keep it (U18). | SECONDARY | ISSN stand, Ricci et al., *JISSN* 2025 (PMC11894756) |
| Usual rapid loss | ~5% lost, ~4% regained, across pooled studies | SECONDARY | ISSN 2025; Brechney, Cannon, Goodman, *IJSPP* 2022 |
| Pro MMA men | 5.9% in the week, 3.7% in 24 h (amateurs 4.2% / 2.5%) | DOCUMENTED, self-report, n=314 | Hillier et al., *IJSNEM* 2019 |
| MMA, weighed | 8 ± 1.8% off in the week; 11.7 ± 4.7% back on over 32 ± 1 h. All 7 dehydrated at the scale (57% / 43% severe) | DOCUMENTED, n=7 | Matthews and Nicholas, *IJSNEM* 2017 |
| Day-before regain | 4.4% (3.40 ± 2.2 kg) over ~22 h. USG 1.028 at the scale, 1.020 ~2 h out. 39% still > 1.021 | DOCUMENTED, n=40 | Jetton et al., *JSCR* 2013 |
| Suitable acute loss | 6.7% / 72 h, 5.7% / 48 h, 4.4% / 24 h. Supervised water loss ~2–4% in 24 h | SECONDARY | ISSN 2025, points 7 and 10 |
| Regain target | Aim for ≥10% of body mass back (a target, not Jetton's or Matthews' mean) | SECONDARY | ISSN 2025, point 15 |
| ~5% dehydration, next day | 4.8 ± 0.8% off. Sled push still 14 ± 15% slower at 24 h. Throw shorter. Jump unchanged | DOCUMENTED, n=14 | Barley et al., *JSCR* 2018 |
| ~5%, then 4 h to eat | Up to 5% in 5 days: no significant change on the test | DOCUMENTED, n=18 | Mendes et al., *BJSM* 2013 |
| Boxers at the low weight | 5.16% in a week, tested there: circuit and mood worse | DOCUMENTED, n=16 | Hall and Lane, *BJSM* 2001 |
| After regain, pooled | Before vs after: g = 0.22, interval crosses zero. Right after the loss: strength −0.29, repeat effort −0.37 | SECONDARY | Brechney et al. 2022 |
| One extreme camp | 18.1% in 8 weeks. Last 24 h: 9.3%, sodium 148 mmol/L, creatinine 177 µmol/L, kidney injury | DOCUMENTED, n=1 | Kasper et al., *IJSNEM* 2019 |
| Deaths | 3 collegiate wrestlers, 1997, died cutting by heat and dehydration | DOCUMENTED | CDC, *MMWR* 1998; 47(6):105–108 |
| Punching bonus per kg regained | None. Regain is done to seek an edge (ISSN point 11). A 2018 *IJSNEM* commentary finds no link between regain and winning in boxing or taekwondo | NO STUDY | ISSN 2025; commentary cites Daniele 2016, Reale 2018 |
| Repeated cuts, years later | Unknown | NO STUDY | ISSN 2025, point 16 |
| Fine 20%; catchweight within 3%; MMA allowance 0.45 kg; boxing 0 | Shipped. Nevada's fine is 25% (`NAC 467.522`). Do not retune | SECONDARY | J7 P10 |
| Free 3%, safe 5%, max cut 11%; stamina 4 per % over free (cap 20); hurt 1 per % (cap 5) | Shipped, not physiology | NO STUDY | `weight_classes.json` `night`, `safe_water_cut_fraction`, `max_water_cut_fraction` |

## 2. The three choices

The pick is a ceiling. The cut taken is the need or the ceiling, whichever is smaller — the line `WeightCut.weigh_in` already uses. `night_penalty` is not rewritten.

**Light.** Ceiling `night.free_cut_fraction` (0.03), inside the ISSN 2–4% day. On the free band: stamina 0, hurt 0.

**Standard.** Ceiling `safe_water_cut_fraction` (0.05), near ISSN 4.4% / 24 h and the ~5% studies. A full 5% cut is stamina 8, hurt 2.

**Hard.** Ceiling 0.08, the Matthews mean, under the fail line of 0.11. A full 8% cut is on both caps: stamina 20, hurt 5. Past 8% toward 11%, or Kasper's 9.3% in a day, is not this button. That stays `emergency`, or a miss.

- **Stamina at the bell.** `WeightCut.night_penalty` writes `penalty.stamina` on `athlete.weigh_in`. `FightSimulation.gd` sets `stamina` to the lower of `bout_start_stamina` and `100` minus that penalty (clamped 0–30). A ceiling. Do not subtract it again.
- **Chin.** Do not write `athlete.chin`. `TaleOfTape.gd` rolls it once; trauma spends it. Softness is `weigh_in_penalty.hurt`, added in `FightSimulation._hurt_threshold` (clamped 0–10) onto `hurt_threshold_base`. Higher means hurt earlier. Do not write camp `head_damage_taken`.
- **Conditioning.** Do not write `stats.conditioning`. `FightSimulation.gd` reads it for stamina cost and for getting up. No study turns one night into conditioning points. The measured loss is the starting tank.
- **Weight.** Nothing turns a kilogram into punching power. `competition_weight_kg` (`TaleOfTape.gd`) is the class limit; `FightRealtime._build_fighter` copies it to `mass_kg`; `FightFootwork.top_speed` taxes that mass. `stats.power` does not read kilograms. Do not write either. The card may say ~4.4% back on (Jetton) or ~11.7% after a Matthews-depth week. Those are measurements, not a force multiplier.

`weight_cut_plan` stays the camp diet. `weight_cut_action` stays `standard` / `emergency` / `accept_miss` / `withdraw`. This choice only supplies the ceiling.

## 3. Fight-week screen, before he picks

`FightWeekPanel.gd` reads `get_fight_week_card` → `weight` (`get_weight_status`: `weight`, `limit`, `excess`). One line each:

1. He weighs [weight] kg today. The limit is [limit] kg, so [excess] kg is still to lose.
2. Light cut: a little water off, he starts fresh, and he misses the limit if that is not enough.
3. Standard cut: a normal water cut, a bit short of wind and easier to hurt, and a miss if he is still over.
4. Hard cut: dried out, drained and easier to hurt, heavier after he drinks back. Too far over and he still misses.
5. A small miss costs a fifth of the purse and the bout is a catchweight. A large miss and the bout is off.

## 4. Risks

Under the gap, `WeightCut.weigh_in` already misses. Within `miss.catchweight_max_fraction` (0.03), catchweight and `fine_fraction` 0.2 off the purse. Past that, `bout_off`. J7: 20% is customary, not Nevada's 25% and not ABC Unified.

A hard cut can still miss: he has dried out, then pays the fine or loses the bout. Say so before he picks.

Hard is not safe. Matthews' seven were dehydrated at the scale. Kasper's man lost 9.3% in a day and injured a kidney. Three wrestlers died cutting (CDC 1998). No death probability is published. `emergency.hospital_chance_per_percent` (0.06) is NO STUDY. Do not retune it, and do not hang a death check on Hard.

Standard is not free. Barley still saw slower repeat effort a day later. Mendes, over 5 days with 4 hours back, did not. Brechney's average after regain was unclear. The charge above 3% stays because a remainder was measured. Do not invent a career scar (ISSN point 16).

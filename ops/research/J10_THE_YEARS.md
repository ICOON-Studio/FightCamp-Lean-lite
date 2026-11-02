# J10 — The Years: Peak, Decline, and Why Careers Actually End

**Desk:** John (research)  
**Date:** 2026-09-07  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design.  
**Verification date for all live URLs in this file:** 2026-09-07 unless a source is dated otherwise.  
**Grade vocabulary (from J1):** `DIRECT` = a primary PDF, commission regulation, federation rulebook, or peer-reviewed dataset states the fact. `INHERITED` = copied from a parent standard or from general (non-combat) physiology and labelled as such, not claimed as that sport’s published number. `UNVERIFIED_SECONDARY` = media, blogs, commercial analytics, Wikipedia, books without a methods paper. `UNKNOWN` = no source. **A number without a source is UNKNOWN by definition.**

**What “peak” means here (do not collapse these):**  
(1) age at which the *same athlete* produces their best performance (almost never measured longitudinally in combat sports);  
(2) age at which *bout winners* cluster (cross-sectional);  
(3) age at which *ranked / titled* athletes sit (survivor-biased).  
This document reports (2) and (3) as what exists, and refuses to dress them as (1).

---

## Decisions page (operator calls)

| # | Call | Recommendation | Why (one line) |
|---|------|----------------|----------------|
| D1 | Peak is a **window**, not a birthday | Ship per-discipline `peak_lo`–`peak_hi` (and a sex split). Never a single “prime age = 30”. | Every sourced dataset is a distribution several years wide; a point would be an authored fiction. |
| D2 | Split **amateur/Olympic** from **professional striking** | Boxing, taekwondo, judo, wrestling, karate (WKF) use Olympic/senior-federation windows. Pro boxing, pro MMA, stadium Muay Thai, GLORY-like kickboxing use later, wider windows. | Olympic boxing medalists ~23–25; pro title populations sit late 20s–early 30s. Same `discipline: boxing` is two careers. |
| D3 | Do **not** ship per-attribute yearly game-stat deltas as facts | `Aging.gd` may apply **directional** bands (maturing / peak / declining). Integer points/year on `speed`/`power`/`conditioning`/`fight_iq` are **UNKNOWN**. | No combat-sport paper publishes a yearly change in a 0–100 game stat. Inventing −0.8 speed/year would be a dressed guess. |
| D4 | Retirement pressure is a **flag set**, not a sourced 0–100 formula | Inputs: age ≥35 (ARP high-risk), NSAC “comprehensive contestant” at 38 / 36 months inactive / 425 rounds, 3 consecutive KO/TKO, 1-year inactivity, active medical hold, consecutive losses. Aggregation weights = **UNKNOWN**. | Commissions and ARP publish criteria, not a scoring function. |
| D5 | Federation sports do not “retire” the way boxers do | BJJ / judo / wrestling / taekwondo / WKF karate / sport sambo: age-band move (Adult → Masters, Senior → leave the national team). Do not run a boxing-style hang-up-the-gloves event on those books. | IBJJF Adult is 18–29 by construction; Masters 1 starts at 30. That is a category, not a career death. |
| D6 | Do not average sexes | Female and male books stay separate even though they never share a bout. Weight-class books stay separate. | Women’s Olympic boxing is *older* than men’s; women’s Olympic taekwondo is *younger*; Kirk 2018 excluded all women’s MMA divisions. |
| D7 | Heavier divisions are **older populations**, not proven later biological peaks | MMA: apply a small `weight_class_age_offset` to the *window centre*, labelled INHERITED from Kirk 2018 population means, and refuse the slogan “heavyweights peak later” as a law. | Kirk 2018: HW mean 32.8 vs BW 29.0; age↔rank correlation only at middleweight. |
| D8 | Medical licence / hold outranks folklore “chin” | Wire retirement pressure to `BodyReadiness.medical_hold` + commission-like KO ladders. Do not add a declining `chin` stat. | KO risk after 35 is evidenced; an isolated “chin” attribute is not. |
| D9 | Live age-gen is **not** what TASK_J10 claims | Record the contradiction; do not “fix” generation ranges in this task. | TASK says world athletes `randi_range(18, 31)`. Live excerpt is starter roster `randi_range(19, 27)`. |
| D10 | If R51 already shipped a single curve / sex-average / yearly deltas as facts | Write the contradiction down. The fix is later, not this desk. | See §0.3. |

**Priority ruling:** P0 = peak *windows* by discipline (and sex), plus retirement-pressure *flags* taken from ARP/NSAC/ABC-family medical rules. P1 = directional attribute bands. P2 = nothing else. Do not block R51 on yearly deltas.

**One operator question:** Should female and male books use **separate** peak windows (this desk’s recommendation) even though they never fight each other, or one window per discipline to keep `Aging.gd` small?

---

## 0. File-level anchors (what the game has today)

| File | Role | Live? | Age / decline / retirement content |
|------|------|-------|-------------------------------------|
| `GameState.gd` ~3332 | `generate_starter_boxing_roster` | LIVE (excerpt in this workspace) | `"age": rng.randi_range(19, 27)` on the three starter athletes. Disciplines boxing / mma / wrestling. Stats: `power`, `technique`, `speed`, `defense`, `conditioning`, `fight_iq` (clamped 20–70). Also `potential`, `fatigue`, `morale`, `record`. |
| `GameState.gd` (world-athlete generator) | Claimed by TASK_J10.md | **Not in the excerpt.** | TASK_J10.md line 27: “world athletes are generated at `age = randi_range(18, 31)`.” **Not verified in this workspace.** |
| `BodyReadiness.gd` | Additive body-readiness; fight damage; medical hold | LIVE (excerpt) | `medical_hold_until_week`, `medical_hold_reason`. `apply_fight_damage` / `apply_real_fight_damage` set hold weeks from a damage profile. **No age. No decline. No retirement.** |
| `AthleteDevelopment.gd` | `migrate_athlete` called from roster gen | Not re-read here | TASK brief: nothing else about age/decline/retirement exists. **Not independently re-verified.** |
| `Aging.gd` | Does not exist in this research pass | — | This document is the input, not the module. |
| `weight_classes.json` | Families `boxing` / `mma` / `kg` | LIVE (J1) | Books by weight class. Females never fight males (design rule restated in TASK_J10). |

Playable athlete stats that an aging curve would touch (from the starter-roster excerpt): `power`, `technique`, `speed`, `defense`, `conditioning`, `fight_iq`. Adjacent: `potential`, `fatigue`, `morale`, `record`, `body_state.medical_hold_*`.

### 0.1 TASK brief vs live excerpt (record this contradiction)

| Claim | Source | Status |
|-------|--------|--------|
| World athletes generated at `randi_range(18, 31)` | TASK_J10.md (assigned 2026-09-07) | **Not in the local excerpt.** |
| Starter boxing roster generated at `rng.randi_range(19, 27)` | `GameState.gd` ~3332, `GameState_age_gen.excerpt.txt` | **LIVE, DIRECT to the excerpt.** |
| “Nothing else about age exists anywhere” | TASK_J10.md | **True of the two excerpts.** BodyReadiness is medical-hold only. |

These are different functions until someone re-reads world generation. Do not silently treat 18–31 as live. Do not silently treat 19–27 as the world-roster rule.

### 0.2 What the game already models vs what would be invented

| Career-end / aging mechanism | In the game today | Grade of that statement |
|------------------------------|-------------------|-------------------------|
| Chronological age on the athlete | Yes, an integer, generated once | DIRECT to excerpt |
| Birthday / yearly tick | **No** | DIRECT to excerpts |
| Stat decline / maturation by age | **No** | DIRECT to excerpts |
| Retirement / comeback flag | **No** | DIRECT to excerpts |
| Medical hold after fight damage | Yes (`medical_hold_until_week`, reason, profile hold weeks) | DIRECT to BodyReadiness excerpt |
| Licence refusal / commission MRI bar | **No** (hold is a week clock, not a licence) | DIRECT |
| Purses | TASK says the game has purses | **Not in these excerpts** — treat as assignment fact, not re-read |
| Records (W-L-D) | Yes, on the athlete | DIRECT |
| Rankings | TASK says yes | **Not in these excerpts** |
| Morale | Yes, 60–85 on starters | DIRECT |
| Contracts | TASK says yes | **Not in these excerpts** |
| Family / dependents | **No** | UNKNOWN in code (not present in excerpts) |
| Accumulated neurological damage as a career-ender | Fight damage exists; no CTE / processing-speed / “chin” stat | DIRECT to excerpts |

### 0.3 If R51 already shipped something (contradictions, not this desk’s fix)

Write these down plainly. **Fix is later.**

1. **Any single prime-age constant** (e.g. `PEAK_AGE = 30`) contradicts every sourced dataset in this file. Those datasets are windows.
2. **Any sex-averaged peak** contradicts Longo 2016 (women’s Olympic boxing *older* than men’s; women’s Olympic taekwondo *younger*), Franchini 2020 (female judoka younger), and Albuquerque et al. 2022 (female Olympic taekwondo younger). Females never fight males; averaging them is a data crime, not a simplification.
3. **Any table of yearly `speed`/`power`/`conditioning` integer deltas presented as researched** contradicts the UNKNOWN list in §2. Those numbers do not exist in the literature as game stats.
4. **A boxing-style retirement event applied to IBJJF / IJF / UWW / WT books** contradicts how those federations actually age athletes (category bands, not hang-up-the-gloves).
5. **World generation at 18–31**, if R51 shipped the TASK number, contradicts the live starter generator at 19–27. Which function is canonical is not this desk’s call.
6. **“Heavyweights peak later” as a biological law** contradicts Kirk 2018’s own conclusion: heavier *populations* are older; age↔rank was only supported at middleweight.

---

## 1. Table Claude can lift toward `Aging.gd`

**How to read grades on this table:** a window with a DIRECT grade is a *population observation*, not an individual peak curve. A yearly delta with grade UNKNOWN must not be authored as a citation. Suggested `weight_class_age_offset` is INHERITED from MMA ranking snapshots only.

### 1.1 Peak windows per discipline

Windows are **inclusive integer ages**. `peak_lo` / `peak_hi` = the band this desk will defend as “where elite competitive success actually sits,” with the width the evidence supports. `iqr_note` is the sourced spread, not a second window.

| discipline_id | sex | peak_lo | peak_hi | window_width_yr | what the number is | weight-class modifier | grade | evidence in one line |
|---------------|-----|---------|---------|-----------------|--------------------|----------------------|-------|----------------------|
| `boxing` (Olympic / amateur elite) | M | 22 | 27 | 6 | 2012 Olympic best-performers mean 24.8, IQR 22.6–26.7; 115-year Olympic+WC medalists mean 23.65, 84% aged 20–30 | Super-heavy older (medium effect in the 115-year set) | DIRECT | Longo 2016 Table 3; Chaabène et al. 2022 *Biomed Hum Kinet* |
| `boxing` (Olympic / amateur elite) | F | 23 | 29 | 7 | 2012 Olympic best-performers mean 26.3, IQR 23.3–29.3 — **older than men** | UNKNOWN per class | DIRECT | Longo 2016 Table 4 |
| `boxing` (professional) | M | 27 | 33 | 7 | Title-level populations sit late 20s; HW championship first contest mean 28.9, last 30.8; not an individual peak curve | Heavier divisions *can* remain titled later; oldest-champ lists are tails, not means | UNVERIFIED_SECONDARY on the 27–33 band as a “prime”; DIRECT on HW championship ages | Fares et al. 2020 *Int J Environ Res Public Health* (HW champs); oldest-champ lists are tails |
| `boxing` (professional) | F | — | — | — | **No sourced peak-window distribution** comparable to the men’s HW-champ paper or Longo | — | **UNKNOWN** | — |
| `mma` | M | 27 | 33 | 7 | UFC 2017–2021 winners 29.8±4.0 vs losers 30.7±4.2 (n=2,229 bouts); 2018 top-100 means 29.0 (BW) … 32.8 (HW); 2022 champs+top-15 mean 31.82±3.77, 80% in 26–35 | See §1.2. Heavier = older *population*. Age↔win supported BW–MW, not HW/LHW | DIRECT | Kirk 2024 *Res Q Exerc Sport*; Kirk 2018 *Facta Univ*; Sport Journal 2022 snapshot |
| `mma` | F | 26 | 35 | 10 | Women’s divisions were **excluded** from Kirk 2018 (<100 ranked each). Kirk 2024 sampled 13 divisions (includes women) but **did not publish a women’s-only winner-age table in the pages pulled**. 2022 elite snapshot mixed sexes. Do not reuse the men’s 29.8. | UNKNOWN per class | **UNKNOWN as a tight window**; the 26–35 band is INHERITED from the mixed elite snapshot, **not** a women’s result | Kirk 2018 methods (female exclusion); Kirk 2024 abstract |
| `muay_thai` | M/F | 22 | 30 | 9 | **No peer-reviewed peak-age paper.** Stadium culture: very young starts, high fight volume, many Thai stadium careers done by early 30s. International/ONE-style stars persist longer. | UNKNOWN | **UNKNOWN** as a number; the 22–30 band is a **proposal labelled UNKNOWN**, not a citation | See §2 |
| `kickboxing` | M/F | 24 | 32 | 9 | **No peer-reviewed peak-age paper** for GLORY/K-1/Kunlun. Inherit mixed/skill Olympic combat (mid-20s) plus pro striking lag, labelled UNKNOWN. | UNKNOWN | **UNKNOWN** | See §2 |
| `bjj` (IBJJF Adult black belt, male) | M | 23 | 29 | 7 | 360 adult male black-belt World medals 2011–2021, mean medalist age **26.9**; first world title among 38 champions averaged **23**; 23% of golds in the 30s were mostly *repeat* champions | No sourced weight-class peak shift (first titles from rooster at 21 through ultra-heavy at 20–22 in that editorial) | UNVERIFIED_SECONDARY | BJJ Heroes 2021 editorial (tournament records, not a journal) |
| `bjj` (IBJJF Adult, female) | F | — | — | — | Starting-age paper exists (more late starters among female world champs). **Peak-age distribution for female adult black belt Worlds: not sourced this pass.** | — | **UNKNOWN** | BJJ Heroes 2020 starting-age editorial is not a peak-age table |
| `judo` | M | 23 | 28 | 6 | 12,005 WC+OG athletes: males 25.4 at majors; 2012 Olympic best-performers 26.7 (IQR 23.6–28.2); Paris 2024 OG median 27; lighter younger than heavier | Lighter younger (DIRECT) | DIRECT | Franchini, Fukuda, Lopes-Silva 2020 *J Sports Sci*; Longo 2016; Paris 2024 OG/PG comparison 2025 |
| `judo` | F | 22 | 28 | 7 | Females **younger** than males at WC/OG (24.9 vs 25.4); 2012 Olympic best-performers 26.1 (IQR 22.9–28.8); Paris 2024 OG **no significant sex difference** in that one Games (median 27 both) | Lighter younger (DIRECT). Competitive-achievement effect: younger females eliminated earlier (DIRECT in Franchini) | DIRECT | Same three papers. Do not average 24.9 with 25.4. |
| `wrestling` (freestyle, senior elite) | M | 23 | 29 | 7 | Olympic champion means historically ~26.4 (Curby); 2012 Olympic best-performers 26.2±2.9; GR medal-winner first-medal age 25.55±3.10; 80% of Olympic champions 22–32 | Lightweight often younger; not a sourced yearly offset | DIRECT | Curby 2014 FILA/UWW science talk; Longo 2016; Karninčić, Baić, Sprem 2017 |
| `wrestling` (Greco-Roman) | M | 24 | 30 | 7 | GR Olympic champions historically older than FS (Curby GR 26.95–27.15; later “age characteristics” paper: GR mean of champions 27.7 vs FS 26.5). Range of Games-means 24.1–32.8 | Heavy GR can be much older (López-type tails are not the mean) | DIRECT | Curby; Latyshev et al. 2024 *Yedynoborstva* / ResearchGate “Age characteristics of Olympic champions” |
| `wrestling` (women’s freestyle) | F | 20 | 28 | 9 | Women’s Olympic champion mean historically **younger** (Curby 24.04; one later paper 22.8). **Conflict:** Longo 2012 best-performers (not just golds) women wrestling **28.7±4.4**. Report both; do not average with men. | Lighter younger is plausible; not isolated in the 2012 table | DIRECT on the conflict | Curby 2014; Latyshev 2024; Longo 2016 Table 4 |
| `taekwondo` | M | 22 | 28 | 7 | Olympic 2000–2016 males 25.1±3.9; 2012 best-performers 25.5±3.6; lighter younger (23.6 vs 26.7 for heavier, p=0.001) | Heavier have greater Olympic longevity (DIRECT) | DIRECT | Albuquerque et al. 2022 *J Sports Med Phys Fitness*; Longo 2016 |
| `taekwondo` | F | 21 | 27 | 7 | Females **younger**: 23.8±4.1 (2000–2016); 2012 best-performers 23.8±3.3 (IQR 21.5–25.6) | Lighter younger (22.7 vs 24.5, p=0.04) | DIRECT | Albuquerque 2022; Longo 2016 Table 4 |
| `karate` (WKF kumite) | M/F | 22 | 28 | 7 | **No dedicated peak-age paper retrieved.** Tokyo 2020 was the only Olympic karate. Inherit Olympic combat-sport young group, labelled INHERITED, not WKF’s own study. | UNKNOWN | INHERITED (Olympic combat cluster) / **UNKNOWN as karate-specific** | Longo combat grouping; no WKF age paper this pass |
| `karate` (Karate Combat pit) | M/F | — | — | — | Full-contact pit is a different sport from WKF. **No peak-age dataset.** | — | **UNKNOWN** | Do not reuse WKF or MMA windows as KC fact |
| `sambo` (sport or combat) | M/F | — | — | — | **No peak-age dataset retrieved** (FIAS Worlds ages not pulled). | — | **UNKNOWN** | See §2 |

**How wide does the evidence support?**  
For Olympic combat (boxing amateur, judo, wrestling, taekwondo) the central 50% of elite performers is typically **about 5–7 years** (Longo IQRs). For UFC-level MMA the winner SD is **±4 years** around ~30, so a 6–8 year “peak window” is the honest width; claiming a 2-year spike is not supported. For Muay Thai, kickboxing, sambo, Karate Combat, and women’s pro boxing / women’s MMA-as-a-separate-curve, the evidence does **not** support a numeric window at all.

### 1.2 MMA weight-class population ages (male, top-100, 15 Jan 2018)

Kirk 2018, Fightmatrix top 100 per division, females and flyweight excluded. These are **roster ages**, not proven individual peaks.

| division | mass limit kg | mean age (top 100) | age↔rank | grade |
|----------|---------------|--------------------|----------|-------|
| Bantamweight | 61.3 | 29.0 | anecdotal | DIRECT |
| Featherweight | 65.9 | 29.6 | anecdotal | DIRECT |
| Lightweight | 70.5 | 30.1 | anecdotal | DIRECT |
| Welterweight | 77.2 | 30.8 | anecdotal | DIRECT |
| Middleweight | 84 | 31.4 | small negative, decisive (T = −0.268, BF10 = 300.6) | DIRECT |
| Light heavyweight | 93.1 | 31.3 | anecdotal | DIRECT |
| Heavyweight | 120.5 | 32.8 | anecdotal | DIRECT |

**If `Aging.gd` wants a weight-class offset (male MMA only):** centre the window ~1 year later per two classes up from bantam, capped at HW. Label every use **INHERITED from a 2018 snapshot**, not a biological law. **Women’s MMA offset: UNKNOWN.**

Kirk 2024 winner/loser ages (UFC 2017–2021, men’s table as reported by AgentMMA citing the VoR PDF):

| men’s division | winner age | loser age | younger-winner signal | grade |
|----------------|------------|-----------|----------------------|-------|
| Heavyweight | 32.0 | 32.9 | inconclusive | DIRECT (via Kirk 2024 as summarised; VoR: https://shura.shu.ac.uk/32072/8/Kirk-5-YearAnalysisAge%28VoR%29.pdf ) |
| Light heavyweight | 30.7 | 30.9 | no effect | DIRECT |
| Middleweight | 29.9 | 31.4 | supported | DIRECT |
| Welterweight | 30.8 | 31.5 | supported | DIRECT |
| Lightweight | 29.8 | 30.5 | supported | DIRECT |
| Featherweight | 28.9 | 29.7 | supported | DIRECT |
| Bantamweight | 28.7 | 29.8 | supported | DIRECT |
| Flyweight | 28.2 | 28.8 | inconclusive | DIRECT |

Overall: winners 29.8±4.0, losers 30.7±4.2; paired gap 0.82 years younger, **small effect**. Women’s division rows: **not in the extracted table — UNKNOWN this pass.**

### 1.3 Per-attribute yearly deltas by band

Game stats on the live athlete: `speed`, `power`, `conditioning`, `technique`, `defense`, `fight_iq`. Bands: **maturing** (below `peak_lo`), **peak** (inside the window), **declining** (above `peak_hi`).

**Ruling:** there is **no** combat-sport source for “−X game points per year.” Cells that would be a number are **UNKNOWN**. What *can* be sourced is **direction**, and a few **physiology rates that are not game stats**.

| attr | band | direction | sourced physiology (not a game stat) | game points / year | grade of the *direction* | grade of the *number* |
|------|------|-----------|--------------------------------------|--------------------|--------------------------|------------------------|
| `speed` (reaction, RFD, type-II) | maturing | ↑ into early–mid 20s | Simple motor reaction in boxers shortest at 20–22, already worse at 27–30; RFD/speed peak early–mid 20s (Allen & Hopkins 2015, as cited by Kirk 2018) | UNKNOWN | DIRECT (boxer reaction study) + INHERITED (general peak-speed) | UNKNOWN |
| `speed` | peak | ~flat / slight ↓ | No combat longitudinal speed curve inside the peak window | UNKNOWN | UNKNOWN as a rate | UNKNOWN |
| `speed` | declining | ↓ first among physicals | Type II fibre area declines from ~30 in sprinters (Korhonen 2006: IIA 6.7%/decade, IIB 11.3%/decade); masters power ~1.25%/year from 30 (Gava 2015); boxers’ latent reaction longer at 27–30 than 20–22 | UNKNOWN | INHERITED (masters/sprinters) + DIRECT (boxer reaction, small n) | UNKNOWN |
| `power` | maturing | ↑ | Peak muscle mass commonly cited 20–30; not a combat dataset | UNKNOWN | INHERITED | UNKNOWN |
| `power` | peak | ~flat | — | UNKNOWN | UNKNOWN | UNKNOWN |
| `power` | declining | ↓ after ~30–35, slower than speed at first | SPAF 47-year Swedish cohort: fitness, strength, muscle endurance begin slipping ~35; Izquierdo 1999: isometric and explosive force down from 20s to 40s; ARP 2024: sarcopenia ~40, strength loss 2–5× mass loss | UNKNOWN | INHERITED / DIRECT (ARP cites the physiology) | UNKNOWN |
| `conditioning` (engine, VO2, between-round recovery) | maturing | ↑ with training years | UFC PI publishes VO2 benchmarks by class, **not** by age (2018 book; age curve not extracted) | UNKNOWN | UNKNOWN as age-maturation in fighters | UNKNOWN |
| `conditioning` | peak | maintained while training volume holds | Tanaka & Seals 2008: endurance performance maintained ~to 35, then modest decline | UNKNOWN | INHERITED (endurance, not combat) | UNKNOWN |
| `conditioning` | declining | ↓ ~5–10% of VO2max per decade after ~25–30 in general populations; **not measured in a fighter panel** | Wilson & Tanaka 2000 men: ~7–9%/decade relative; Tanaka & Seals 2008: ~10%/decade after 25–30 in sedentary; trained similar *relative* rate | UNKNOWN | INHERITED | UNKNOWN |
| `technique` | maturing | ↑ (this is the maturation story) | Skill-sport peak later than speed sports (Allen & Hopkins 2015); MMA years 1–3 win% vs quality opposition 41.6 → 58.8 (FightOpinion 2011) | UNKNOWN | INHERITED (skill sports) + UNVERIFIED_SECONDARY (9-year-rule table) | UNKNOWN |
| `technique` | peak | ↑ or hold | Older MMA winners more often by decision (Kirk 2016a, cited inside Kirk 2018) — **record, cause not isolated** | UNKNOWN | DIRECT as a bout-method pattern (via Kirk 2018 citing Kirk 2016a) | UNKNOWN |
| `technique` | declining | may hold while physicals fall | Same: veterans steer fights; not a measured technique rating | UNKNOWN | UNKNOWN as a rate | UNKNOWN |
| `defense` | maturing | ↑ | Inferred from falling amateur/pro mistake rates; **not isolated** | UNKNOWN | UNKNOWN | UNKNOWN |
| `defense` | peak | hold | — | UNKNOWN | UNKNOWN | UNKNOWN |
| `defense` | declining | ↓ as KO/TKO risk rises | Age ≥35: KO OR 1.94, TKO-from-strikes OR 1.96 vs younger reference, controlling for prior KO/TKO, round, match significance (Hutchison et al. 2014 AJSM). **Cause not isolated** (slower legs, slower hands, accumulated damage, worse recovery, or “chin”). | UNKNOWN | DIRECT on the KO outcome; UNKNOWN on “defense stat” | UNKNOWN |
| `fight_iq` | maturing | ↑ | Decision-making speed itself is relatively preserved (Ratcliff et al. 2001, cited by Kirk 2018); skill mastery continues into adulthood | UNKNOWN | INHERITED | UNKNOWN |
| `fight_iq` | peak | hold / ↑ | — | UNKNOWN | UNKNOWN | UNKNOWN |
| `fight_iq` | declining | processing speed can fall with **fight exposure**, not calendar age alone | PFBHS: processing speed −0.19% per fight; FES +1 → −2.1%; boxers worse than MMA at same age (Bernick / BJSM 2015). Transitioned (retired ≥2 years) fighters **improved** verbal memory, processing speed, psychomotor speed vs continued actives (Ritter et al. 2022 *Neurology*). | UNKNOWN as game points | DIRECT on cognition vs exposure | UNKNOWN |
| `chin` (not a live stat) | any | **do not add** | Folklore. KO risk is evidenced; an isolated punch-resistance tissue property is not. | n/a | — | — |
| recovery between camps | declining | slower | ARP 2024: older fighters may take longer to recover from MSK injury; clearance individualized. **No days-per-year number.** | UNKNOWN | DIRECT as a clinical statement | UNKNOWN |

**Do not lift a numeric delta column into `Aging.gd` and call it researched.** If engineering needs a placeholder slope, store it as `grade: UNKNOWN` in data, not in prose that looks like a citation.

### 1.4 Inputs to a 0–100 retirement pressure (flags, not a formula)

**There is no sourced 0–100 function.** What exists are **high-risk / extra-testing / medical-suspension triggers**. Use them as additive flags. Any mapping onto 0–100 is **UNKNOWN** and must be labelled authored.

| input_id | trigger | suggested use | already in game? | grade | source |
|----------|---------|---------------|------------------|-------|--------|
| `age_ge_35` | Age > 35 | High-risk combatant (ARP 2024/2026). Extra CV screening from 35; neuro from ~40 | Age integer exists; no flag | DIRECT | ARP *Care of the Older Fighter* 2024; ARP *Identifying High-Risk Combat Sport Athletes* 2026 (LOE V on the age cut) |
| `age_ge_38_nsac` | Age 38+ (or turns 38 this calendar year) | NSAC “Comprehensive Contestant” licence battery | No | DIRECT | NSAC Physical 2025, https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/PHYSICAL-2025_W-INSTR.pdf |
| `inactive_36_mo_nsac` | No pro fight in 36 months | Same NSAC comprehensive battery | No inactivity clock | DIRECT | same NSAC form |
| `rounds_gt_425_nsac` | >425 professional rounds | Same NSAC comprehensive battery (boxing-shaped) | No rounds-total | DIRECT | same NSAC form |
| `inactive_12_mo_arp` | Professional inactivity > 1 year | ARP high-risk (LOE V) | No | DIRECT | ARP 2026 high-risk statement |
| `ko_tko_streak_3` | 3 consecutive losses by KO/TKO (pro) or RSC (amateur) | ARP high-risk (LOE III); World Boxing / AIBA-family: 3 head-stoppages in 12 months → 1 year out | Partial: `record` exists, method of loss **not confirmed in excerpts** | DIRECT | ARP 2026; World Boxing Medical Handbook 2025 §8.4 |
| `loss_streak_3_any` | 3 consecutive losses, any method | ARP lists this *particularly* when KO/TKO; NYSAC high-risk uses **6** consecutive any-method | `record` exists; streak logic UNKNOWN in code | DIRECT as a medical-risk flag; **UNKNOWN as a career-end frequency** | ARP 2026; NYSAC high-risk list (secondary explainer) |
| `no_prior_wins` | Debut / winless | ARP high-risk (LOE V) | Starter records can be 0-0-0 | DIRECT | ARP 2026 |
| `medical_hold_active` | `medical_hold_until_week` ≥ current week | Already blocks fighting | **YES** | DIRECT to BodyReadiness | local excerpt |
| `licence_denied` | Abnormal MRI/MRA, neurocognitive drop, BP >160/100, failed eye exam | Ends or pauses the career in real commissions | **NO** (game has a week-hold, not a licence) | DIRECT as a real-world trigger | ARP 2024; NSAC NAC 467.027 / 467.562 |
| `head_ko_ladder` | KO no LOC ≥30d; LOC ≥90d; 2 in 3 months ≥90d; 3 in 12 months ≥1 year | Amateur/World Boxing. Pro commissions: typically KO 60d / TKO 30d floors (FL, MN, CO, APBC 28–90) | Game hold weeks exist but **not this ladder** | DIRECT | World Boxing 2025; Florida Stat. 548.041; Colorado 4 CCR 740-1.6; Minnesota pro boxing rules |
| `prior_ko_count` | Each prior KO/TKO raises subsequent KO odds | Hutchison 2014: OR 1.30 per prior KO/TKO | Not tracked as a career total in excerpts | DIRECT | Hutchison et al. 2014 *Am J Sports Med* |
| `money_pressure` | Purse vs cost of camp; “have to take the fight” | TASK says purses exist | Purses: assignment yes; **as a retirement trigger: UNKNOWN** | UNKNOWN | See §2 and Q4 |
| `family` | Dependants, partner, children | Not in game | No | UNKNOWN | See §2 and Q4 |
| `title_lost` | Dropped belt → exit | Rankings exist per TASK | UNKNOWN as an independent cause | UNKNOWN | See §2 and Q4 |
| `one_bad_night` | Single KO ending the career | Sometimes via licence (subdural, etc.), not via the loss itself | Medical hold can follow a stoppage | DIRECT when it becomes a medical suspension; UNKNOWN as a “quit after one loss” rate | NSAC Mesi-type cases are anecdote |
| `federation_age_band` | IBJJF Adult ends as a *category* at 30 (athlete may still enter Adult); IJF/UWW/WT seniors have no universal hard cap in the pages pulled | Would be a **category move**, not retirement | No | DIRECT for IBJJF bands | IBJJF rules / graduation PDF 2026 |

**Suggested authored (UNKNOWN) 0–100 sketch — not a citation, do not put in a researched-numbers table without the UNKNOWN label:**

- Base 0.  
- +25 if `age_ge_35`, +15 more if `age_ge_38_nsac`.  
- +20 if `ko_tko_streak_3`, +10 if `loss_streak_3_any` without KO.  
- +15 if `inactive_12_mo_arp`, +10 more if `inactive_36_mo_nsac`.  
- +30 if `licence_denied` / failed clearance.  
- +20 while `medical_hold_active` (this is a pause, not a retirement).  
- Money / family / title-lost / one-bad-night: **do not score**; no rates.

That sketch is **UNKNOWN**. It is here so Claude does not invent a different sketch and call *that* researched.

---

## 2. What this desk could NOT source

This list is as valuable as the lift table. Do not pad it away. Mark these `UNKNOWN` in data rather than filling them.

1. **Yearly game-stat deltas** for `speed`, `power`, `conditioning`, `technique`, `defense`, `fight_iq` in any combat sport.  
2. **A 0–100 retirement-pressure formula** with sourced weights.  
3. **Women’s MMA peak window** as a division-level winner-age table (Kirk 2018 excluded women; Kirk 2024’s women’s rows were not in the extracted table).  
4. **Women’s professional boxing peak-age distribution.**  
5. **Muay Thai peak-age distribution** (stadium or ONE) from a peer-reviewed or commission dataset.  
6. **Kickboxing / K-1 / GLORY / Kunlun peak-age distribution.**  
7. **Sambo (sport or combat) peak-age distribution.**  
8. **Karate Combat pit peak-age distribution.** WKF kumite also lacks a dedicated peak-age paper this pass.  
9. **Individual longitudinal peak curves** (the same fighter, year by year) for any of the ten disciplines. All “peak ages” above are cross-sectional.  
10. **Cause of the post-35 KO spike** isolated from slower defense, slower legs, accumulated RHI, worse recovery, or tissue “chin.” The record shows the spike; the mechanism is not isolated.  
11. **Chin / punch resistance** as a measurable aging attribute.  
12. **Frequency ranking of why careers end** (damage vs money vs family vs losing run vs title lost vs one bad night) as percentages of a defined population.  
13. **Retirement-age histogram** for MMA, Muay Thai, kickboxing, BJJ, judo, wrestling, taekwondo, karate, sambo. Boxing has career-*length* papers, not a clean modern retirement-age census.  
14. **How often a retirement is reversed** in any sport as a population rate (celebrity comeback lists are not a rate).  
15. **Comeback performance** as a peer-reviewed effect size. Commercial UFC layoff tables exist; they are not journal articles.  
16. **Sport-wide wage tables, purse-by-age, or “% of fighters who quit because of money.”** Out of scope and not sourced.  
17. **NSAC vs CSAC vs NYSAC vs UK vs Thai stadium** as a single medical-suspension ladder. They disagree on days.  
18. **Female vs male yearly decline rates inside combat sports** (masters track-and-field power declines were similar by sex in one athlete study; that is not fighters).  
19. **UFC Performance Institute age-stratified VO2 / force tables.** The 2018 book exists; this pass did not extract an age curve from it.  
20. **World-athlete `randi_range(18, 31)`** as live code. Only starter `19–27` is in the excerpt.  
21. **IBJJF female adult black-belt medalist age distribution.**  
22. **Whether R51 has already shipped `Aging.gd`.** Not in this workspace.

---

## 3. Answers to the six questions

### Q1 — Peak

**There is no single peak age.** The honest object is a window several years wide, different by (a) amateur/Olympic vs professional striking, (b) discipline, (c) sex, and (d) sometimes weight class as a *population* shift.

**Olympic / senior-federation combat (DIRECT, Longo 2016, London 2012 best-performers; plus sport-specific papers):**

| sport | men mean (spread) | women mean (spread) | sex note |
|-------|-------------------|---------------------|----------|
| Boxing | 24.8 ± 3.2 (IQR 22.6–26.7, max 32.3) | 26.3 ± 4.1 (IQR 23.3–29.3) | Women **older** |
| Judo | 26.7 ± 3.6 (IQR 23.6–28.2) | 26.1 ± 3.7 (IQR 22.9–28.8) | Women slightly younger; Franchini 2020 on 12,005 WC+OG athletes: F 24.9, M 25.4; lighter younger than heavier |
| Wrestling | 26.2 ± 2.9 | 28.7 ± 4.4 **in this 2012 best-performer cut** | **Conflicts** with champion-only histories (women golds younger: Curby 24.04). Do not average; do not pick a side without saying both exist. |
| Taekwondo | 25.5 ± 3.6 | 23.8 ± 3.3 (IQR 21.5–25.6) | Women **younger**. Albuquerque 2022 (Sydney 2000–Rio 2016, n=611): F 23.8±4.1, M 25.1±3.9; lighter younger; heavier more longevity |

Chaabène et al. 2022 (1,806 Olympic+World boxing medalists, 1904–2019): mean **23.65 ± 3.2**; 58% aged 21–25; 84% aged 20–30; super-heavy older. DIRECT, amateur boxing.

Franchini 2020: no male achievement-age gap at WC/OG; **younger females are eliminated earlier**. Lighter judoka younger than heavier. Paris 2024 OG judo median **27** both sexes (no sex difference *at that Games*).

Wrestling champions (DIRECT, mixed papers): first GR world/OG medal **25.55 ± 3.10** (Karninčić 2017); Olympic champion means FS ~26.4, GR ~27, women historically ~24 (Curby). 80% of champions 22–32 (Latyshev 2024).

**Professional MMA (DIRECT):**  
Kirk 2024, 2,229 UFC bouts, 1,079 fighters, 2017–2021: winners **29.8 ± 4.0**, losers **30.7 ± 4.2**, younger by 0.82 years, small effect, four of five years, **not** HW/LHW. Kirk 2018: heavier divisions older (BW 29.0 → HW 32.8); rank↔age only at middleweight. 2022 Sport Journal snapshot: 174 champs + top-15, mean **31.82 ± 3.77**, range 23–42, **80% between 26 and 35** (mixed-sex elite, survivor bias).

Estelami 2014 (book, not UFC-elite journal) claimed peak at **22** with higher injury in the 30s — **CONFLICTING** with Kirk and every UFC ranking snapshot. Treat as UNVERIFIED_SECONDARY / different sample, not as the UFC curve.

**Professional boxing:** HW world champions’ first title contest **28.9 ± 4.1**, last **30.8 ± 4.8** (Fares et al. 2020, n includes 211 retired). That is a *championship span*, not a prime. Oldest-champ lists (Foreman 46, Hopkins 49) are tails, DIRECT as records, useless as means. A 27–33 “pro prime” band is a reasonable **authored** window labelled UNVERIFIED_SECONDARY, not a paper’s finding.

**BJJ:** Male IBJJF Adult black-belt Worlds medalists 2011–2021 mean **26.9**; first title ~**23**; 23% of golds in the 30s were mostly athletes who had already arrived in their 20s (BJJ Heroes 2021). UNVERIFIED_SECONDARY (editorial on public brackets, methods are transparent enough to use with that grade). Female peak-age table: UNKNOWN. IBJJF Adult *category* is 18–29; Masters 1 starts at 30 — that is a rule, not a physiological cliff (DIRECT, IBJJF).

**Muay Thai, kickboxing, sambo, Karate Combat:** UNKNOWN. Do not invent sport-wide windows. Stadium Muay Thai’s young start + high volume is a career-shape story, not a peak-age mean.

**Weight class:** evidenced as **older populations at heavier classes** in male MMA (Kirk 2018 DIRECT) and as **younger lightweights** in judo and taekwondo (DIRECT). Not evidenced as “each fighter’s biological peak moves two years per class.”

### Q2 — Decline (EVIDENCED vs folklore)

**What the record shows, cause not isolated**

1. **Losing and getting finished more from the mid-30s (MMA, male-heavy samples).**  
   - Winners younger than losers by ~0.8 years (Kirk 2024, small effect). DIRECT.  
   - Age ≥35: KO OR **1.94** (95% CI 1.03–3.61), TKO-from-repetitive-strikes OR **1.96** (1.18–3.22), after controlling for prior KO/TKO, round, match significance (Hutchison, Lawrence, Cusimano 2014 *Am J Sports Med*, 844 UFC matches, **all male**, mean age 29.8). Each prior KO/TKO: KO OR **1.30**. DIRECT.  
   - Hutchison BJSM abstract (UFC numbered events to 2009): KO prevalence highest at **36–40 (20.6%)**. DIRECT as that sample.  
   - Fightnomics / Kuhn: fighters 36–38 more than twice as likely to be KO’d as early-20s — **UNVERIFIED_SECONDARY** (book / media; consistent in direction with Hutchison, not a substitute).  
   - UFC 40-year-olds (Fightnomics 2015 blog): 19–33 overall, 37% wins, 85% of their fights finished — UNVERIFIED_SECONDARY, tiny selected list.

2. **Processing speed and brain structure track fight exposure, not just birthday.**  
   PFBHS (Bernick et al., *Br J Sports Med* 2015): 224 pro fighters (131 MMA, 93 boxers) aged 18–44; processing speed **−0.19% per fight**, **−2.1% per FES step**; boxers worse than MMA at the same age. DIRECT.  
   Ritter et al. 2022 *Neurology*: fighters who *stopped* fighting for ≥2 years improved verbal memory, processing speed, psychomotor speed and dropped NfL; matched actives declined or stayed flat. DIRECT. So “decline” is partly **ongoing exposure**, reversible in group mean after stopping — which is not the folklore of a one-way chin.

3. **General physiology (INHERITED, not fighter-specific).**  
   - Speed / RFD / type II: peak early–mid 20s; type II area down from ~30 (Korhonen 2006, masters sprinters).  
   - Strength / power: measurable drop 20s→40s (Izquierdo 1999); SPAF 47-year cohort, decline from ~35 (Karolinska / Westerståhl 2026).  
   - VO2max: ~5–10% per decade after 25–30 (Tanaka & Seals 2008; Wilson & Tanaka 2000). Endurance *performance* often holds to ~35 then modest drop.  
   - Sarcopenia: ARP 2024 places onset ~40; females earlier, males greater total loss; strength falls faster than mass.

**Folklore (do not ship as mechanics)**

- “The chin goes.” The **outcome** (more KOs) is evidenced. A tissue chin stat is not. Hutchison’s OR survives some controls but does not isolate punch resistance from slower defense or accumulated RHI.  
- “Cardio falls off a cliff at 30.” VO2 declines gradually; fight-specific “engine” also includes weight-cut, camp quality, and damage. No fighter VO2-by-age panel sourced.  
- “Nothing measurable declines; it’s all mileage.” Mileage matters (9-year-rule; PFBHS per-fight slope; prior-KO OR), and **age still appears in KO models after prior KO is in the regression**. Both can be true.  
- Lystad 2015 / ARP citing studies where **weight class, not age**, predicted injury *rate*: that is injury epidemiology, not winning or KO. Do not use it to cancel Hutchison.

**What declines first, in order this desk will defend:**

1. **Speed / RFD / high-velocity defense** — physiology DIRECT/INHERITED; MMA KO pattern compatible.  
2. **Recovery between rounds and camps** — clinical (ARP) DIRECT as a statement, UNKNOWN as a rate.  
3. **Engine (VO2 / repeat high-intensity)** — INHERITED from endurance literature; UNKNOWN in fighters.  
4. **“Chin”** — not isolated.  
5. **Technique / fight IQ** — may still rise while physicals fall (Kirk’s decision-win pattern).  
6. **Nothing measurable** — false for KO risk and processing speed; true for a clean yearly `conditioning −1.2`.

### Q3 — Maturation

**What improves while young, until roughly when**

| quality | until roughly | grade | note |
|---------|---------------|-------|------|
| Fight experience / win% against quality opposition (MMA) | After ~2 years pro, through years 3–9 | UNVERIFIED_SECONDARY | FightOpinion 2011 “9-year rule”: year 1 win% vs quality 41.6%, year 3 58.8%, year 4 64.0%, then a drop after year 9 to 47.3%. n and era are dated; direction (need a couple of years) is plausible. |
| Skill / tactics / “when to wrestle” | Through the 20s into the peak window | INHERITED | Allen & Hopkins 2015: skill-sport peaks later than speed sports. Kirk 2018 frames MMA as the intersection. |
| Strength / muscle mass | Into the 20s, plateau ~25–30 | INHERITED | Not a fighter panel. |
| Amateur boxing success | ~21–25 | DIRECT | Chaabène 2022: 58% of medalists 21–25. |
| BJJ first world title (male adult black belt) | ~23; rarely a *first* title after 25 | UNVERIFIED_SECONDARY | BJJ Heroes 2021. |
| Judo | Lighter athletes arrive younger; females who are too young get eliminated earlier | DIRECT | Franchini 2020. |
| Wrestling | ~15 years of training before first OG/WCh medal; start ~10.5, medal ~25.5 (GR sample) | DIRECT | Karninčić 2017. |
| Brain “fully developed at 25” as a fight-IQ switch | — | Do not use as a game cliff | Popular neuroscience, not a combat finding. |

Maturation in the game should mostly be **`technique` and `fight_iq` up**, with **`speed` already near its ceiling** in the starter-age band (19–27). A 19-year-old starter is still in the speed peak and the skill trough. A 27-year-old starter is near MMA’s winner mean and past amateur boxing’s medalist mean.

### Q4 — Why careers end

**Rank of real triggers, as documented mechanisms — not as a % pie chart (that pie is UNKNOWN).**

| rank | trigger | what is evidenced | game today | invent? |
|------|---------|-------------------|------------|---------|
| 1 | **Medical hold / licence refusal / accumulated neurological risk** | Commissions suspend after KO (30–90+ days; 3 head-stoppages in a year → ~1 year amateur). ARP: age >35, 3 consecutive KO/TKO, inactivity >1 year, no wins, mismatches, concussion history, BP. NSAC comprehensive battery at 38 / 36 months off / 425 rounds. PFBHS: exposure damages processing speed; stopping fighting improves it. Licence denial (subdural, failed MRI) ends careers. | **Partial:** `medical_hold_*` after fight damage. **Missing:** licence, MRI, KO ladder, age-gated clearance. | Extend the hold into a licence/clearance object. Do not invent a “brain %” bar without PFBHS-like exposure. |
| 2 | **Losing run / unbookable** | ARP LOE III on 3 consecutive KO/TKO as high-risk. Promoters stop offering fights; this is industrial knowledge, not a census. | Records exist. Rankings per TASK. Streak-as-trigger: **not in excerpts**. | A booking/pressure flag from streaks is fair **if labelled authored**. A “72% of careers end this way” number would be invented. |
| 3 | **Money** | California boxer pension exists because boxers are left broke (LAT 2023–24 investigation). That proves money matters after careers; it does **not** quantify “quit because purse < camp cost.” Pro boxing career length collapsed to ~5 years (Clausen 2005) for many reasons at once. | Purses per TASK. | **Do not build a sport-wide wage table.** A personal “camp cost vs purse” check is game design, not research. |
| 4 | **Accumulated musculoskeletal damage / can’t make camp** | ARP: older fighters recover slower from MSK injury. UFC PI exists to cut injury and missed fights. Not a retirement census. | Body damage + fatigue exist. | Soft: longer recovery with age as UNKNOWN slope. |
| 5 | **Family** | Universally cited in interviews. **No dataset.** | Not modelled. | Invented if scored. Flavour/event, not a researched weight. |
| 6 | **Title lost** | Some champions retire on a loss; many do not. **No rate.** | Rankings/titles per TASK. | Invented as a primary trigger. |
| 7 | **One bad night** | A single KO can become a medical career-ender (imaging). A single decision loss ending a career is a choice, not a rule. | Stoppage → medical hold. | Distinguish medical-bad-night (real) from “I quit” (UNKNOWN rate). |

**Do not rank these by frequency.** Frequency is UNKNOWN. Rank them by *whether a regulator or a paper names them*.

### Q5 — Retirement age, and how often reversed

**Boxing (closest thing to data, still not a clean histogram):**

- Clausen, McCrory, Anderson 2005 *Br J Sports Med*: average professional career length **19 years** (1900–1955 samples) → **~5 years** (2000–present samples); mean bouts 336 → 13. DIRECT. That is duration, not age.  
- MSSE 2017 abstract (NY 1980s licence applicants, n=282 records): first pro bout mean **21.6** (16–30); career **8.1 years** (1–38); 22.1 bouts. DIRECT as that cohort. Implied typical exit ~30 if you add 21.6+8.1, **but** the distribution is wide and the cohort is 1980s NY, not 2026.  
- Fares 2020: among HW champions, last championship contest mean **30.8**; by 40, <4% still contesting world titles; median title reign 1.0 year. DIRECT for *championship* exit, not for the journeyman.  
- Celebrity-blog “average retirement 35–37, 70% return within 5 years” (Geezers Boxing, n=20 famous names): **UNVERIFIED_SECONDARY**, survivor bias. Do not lift.

**MMA:** no retirement-age census. Bloody Elbow 2013 (n=48 selected): decline often ~9.5 years after first fight, mean age at decline ~31.7. UNVERIFIED_SECONDARY. Kirk shows *active elite* still clustered 26–35; that is who remains, not when people leave.

**Muay Thai:** no census. High-volume childhood starts imply earlier exits for stadium regulars; famous internationals fight into the 40s. UNKNOWN as a distribution.

**Judo / wrestling / taekwondo / WKF karate / BJJ:** “retirement” is the wrong word. Athletes age out of a **category** or leave the national team. IBJJF Adult → Masters 1 at 30 is optional (masters may still enter Adult). IJF senior has no hard upper age in the SOR pages used in J1. UWW seniors similarly compete into the 30s; Olympic champions have been 18 to 41 (GR). UNKNOWN as a hang-up-the-gloves age.

**How often reversed:** UNKNOWN as a rate. Official “retirement” in MMA is often a social-media post. Boxing comebacks of famous names are selected. ARP treats >1 year inactivity as high-risk, which implies returns happen often enough to write a guideline, not how often they succeed.

### Q6 — Comebacks

**How common:** UNKNOWN as a population rate.

**Layoff length vs performance (UFC, commercial analytics — UNVERIFIED_SECONDARY, useful as a direction, not as a law):**

FightAlpha / AgentMMA 2026, UFC decided fights through May 2026 (methods: UFCStats-derived, not a journal):

| layoff | returning fighter win rate | n | grade |
|--------|----------------------------|---|-------|
| Any longer layoff vs opponent | 48.1% | 5,975 | UNVERIFIED_SECONDARY |
| 3–6 months | 51.1% | 1,659 | UNVERIFIED_SECONDARY |
| 6–12 months | 49.3% | 3,025 | UNVERIFIED_SECONDARY |
| 12–18 months | 41.7% | 741 | UNVERIFIED_SECONDARY |
| 18–24 months | 37.2% | 218 | UNVERIFIED_SECONDARY |
| 24+ months | 42.1% | 247 | UNVERIFIED_SECONDARY |
| ≥365 days vs opponent active within 180 days | 39.4% | 627 | UNVERIFIED_SECONDARY |

Direction: short layoffs ≈ coin flip; **≥12 months, especially vs an active opponent, looks worse.** Confounding (injury, age, matchmaking, who gets a comeback fight) is not removed. A Reddit/data-science write-up claimed ~4.5 percentage-point hit around 18–20 months — UNVERIFIED_SECONDARY.

**Medical, not betting:** ARP 2026 lists professional inactivity >1 year as high-risk (LOE V). NSAC treats 36 months off as a comprehensive contestant. Colorado: 45+ and not routinely fighting for 5 years → extra tests.

**Usual performance after:** not “usually win” and not “usually get KO’d.” The honest line: **expect a worse win rate after ≥12 months off against an active opponent; do not script a cinematic rust-off-the-first-fight unless the player earned it.** Peer-reviewed confirmation: UNKNOWN.

Boxing 70%-return-within-5-years (n=20 celebrities): do not use.

---

## 4. Sex (do not average)

Females never fight males. The game books by weight class. Where the evidence differs, keep two rows.

| topic | male | female | do not |
|-------|------|--------|--------|
| Olympic boxing peak (2012 best-performers) | 24.8 | **26.3 (older)** | Average to 25.5 |
| Olympic taekwondo | 25.1–25.5 | **23.8 (younger)** | Average |
| Judo WC+OG (1993–2018) | 25.4 | **24.9 (younger)**; younger females eliminated earlier | Average; ignore the achievement effect |
| Judo Paris 2024 OG | median 27 | median 27 (no sex difference *that Games*) | Pretend Franchini is obsolete; report both |
| Wrestling champions (historical golds) | FS ~26.4, GR ~27 | **~22.8–24.0 (younger)** | Average with Longo 2012 women’s *best-performer* 28.7; those are different samples |
| MMA peak papers | Kirk 2018 **excluded** women | Kirk 2024 mixed 13 divisions; women’s winner-age table **not extracted** | Reuse 29.8 as a women’s prime |
| KO / head-trauma ending fights | Higher (e.g. 32.2% of male MMA fights ended by head trauma vs 23.1% female in one 2022 IJERPH sample) | Lower KO/TKO share in several samples; PFBHS sex-moderation paper: women less often KO’d in Nevada 2015–2017 | Copy male Hutchison ORs onto women’s books without a label |
| BJJ starting age of world champs | Almost none started after 20 | ≥23% started after 20 | Same maturation curve |
| IBJJF Masters | Same age bands for both | Same bands | Invent a different Masters cut |
| Physiology | Type II / VO2 decline both sexes; females may start sarcopenia earlier, males greater total loss (ARP 2024) | Same | A single decline slope presented as sex-neutral *fact* — it is INHERITED |
| Pro boxing peak window | Weak, HW-champ based | **UNKNOWN** | Copy men’s 27–33 onto women |

---

## 5. Sources (verified 2026-09-07)

**Peer-reviewed / official (prefer these):**

1. Kirk C. (2018). The relationship between age and divisional rank in professional mixed martial arts. *Facta Universitatis, Series: Physical Education and Sport* 16(1). PDF: https://shura.shu.ac.uk/27929/1/3797-25364-1-PB.pdf  
2. Kirk C. (2024). A 5-year analysis of age, stature and armspan in mixed martial arts. *Res Q Exerc Sport*. VoR: https://shura.shu.ac.uk/32072/8/Kirk-5-YearAnalysisAge%28VoR%29.pdf — PubMed: https://pubmed.ncbi.nlm.nih.gov/37826856/  
3. Longo AF et al. (2016). Age of peak performance in Olympic sports. *J Hum Sport Exerc* 11(1):31–41. https://doi.org/10.14198/jhse.2016.111.03 — PDF: https://dialnet.unirioja.es/descarga/articulo/5802361.pdf  
4. Franchini E, Fukuda DH, Lopes-Silva JP. (2020). Tracking 25 years of judo results from the World Championships and Olympic Games: Age and competitive achievement. *J Sports Sci* 38(13):1531–1538. https://doi.org/10.1080/02640414.2020.1747265  
5. Albuquerque MR et al. (2022). Exploring the age of taekwondo athletes in the Olympic Games: Sydney 2000 to Rio 2016. *J Sports Med Phys Fitness*. https://pubmed.ncbi.nlm.nih.gov/34821491/  
6. Chaabène H et al. (2022). Characteristics of Olympic and World boxing medalists. *Biomedical Human Kinetics*. https://sciendo.com/pdf/10.2478/bhk-2022-0020  
7. Hutchison MG, Lawrence DW, Cusimano MD, Schweizer TA. (2014). Head trauma in mixed martial arts. *Am J Sports Med*. PubMed: https://pubmed.ncbi.nlm.nih.gov/24658345/ — study PDF copy: https://s3.amazonaws.com/s3.documentcloud.org/documents/1362429/study-of-head-trauma-in-mma.pdf  
8. Bianchi D, Sethi NK, et al. (2024). Care of the older fighter: Position statement of the Association of Ringside Physicians. *Phys Sportsmed* 52(6):585–591. https://pubmed.ncbi.nlm.nih.gov/38708547/ — summary PDF: https://ringsidearp.org/wp-content/uploads/2024/05/OlderFighters-Summary.pdf  
9. ARP (2014). Consensus statement on medical clearance of the older fighter. https://ringsidearp.org/wp-content/uploads/2020/01/Medical-Clearance-of-the-Older-Fighter.pdf  
10. Munshi J et al. (2026). Identifying high-risk combat sport athletes: Position statement of the ARP. *Clin J Sport Med* 36(3):218–223. https://journals.lww.com/cjsportsmed/fulltext/2026/05000/identifying_high-risk_combat_sport_athletes_.2.aspx  
11. Bernick C et al. (2015). Repeated head trauma associated with smaller brain volumes and slower processing. *Br J Sports Med* (PFBHS). ScienceDaily summary with numbers: https://www.sciencedaily.com/releases/2015/01/150129185147.htm  
12. Ritter A et al. (2022). Longitudinal changes in cognitive functioning and brain structure in professional boxers and mixed martial artists after they stop fighting. *Neurology*. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC9694836/  
13. Tanaka H, Seals DR. (2008). Endurance exercise performance in Masters athletes. *J Physiol* 586(1):55–63.  
14. Wilson TM, Tanaka H. (2000). Meta-analysis of the age-associated decline in maximal aerobic capacity in men. *J Appl Physiol*.  
15. Korhonen MT et al. (2006). Aging, muscle fiber type, and contractile function in sprint-trained athletes. *J Appl Physiol*. https://journals.physiology.org/doi/full/10.1152/japplphysiol.00299.2006  
16. Clausen H, McCrory P, Anderson V. (2005). The risk of chronic traumatic brain injury in professional boxing: change in exposure over time. *Br J Sports Med* 39:661–664.  
17. Fares MY et al. (2020). Life expectancy of white and non-white elite heavyweight boxers. *Medicina*. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC7064515/  
18. Karninčić H, Baić M, Sprem D. (2017). Optimal age to begin with Greco-Roman wrestling and reach peak performance.  
19. Curby D. (2014). When do wrestlers peak? FILA/UWW FS World Cup Science Conference, Los Angeles. http://inwr-wrestling.com/wp-content/uploads/2014/03/Sunrise-to-Sunset-%E2%80%93-LA.pdf  
20. Allen SV, Hopkins WG. (2015). Age of peak competitive performance of elite athletes: a systematic review. *Sports Med*. https://link.springer.com/article/10.1007/s40279-015-0354-3  
21. World Boxing. *Medical Handbook* 2025. https://worldboxing.org/wp-content/uploads/2025/08/WB-Medical-Handbook-2025.pdf  
22. Nevada Athletic Commission. Unarmed combatant physical 2025. https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/PHYSICAL-2025_W-INSTR.pdf  
23. NAC 467.027, 467.562 (Nevada). https://www.law.cornell.edu/regulations/nevada/NAC-467-027  
24. Florida Stat. §548.041 (KO 60 days / TKO 30 days floors). https://www.flsenate.gov/Laws/Statutes/2024/0548.041  
25. Colorado 4 CCR 740-1.6 (post-fight suspensions; age 45 extra tests). https://www.law.cornell.edu/regulations/colorado/4-CCR-740-1.6  
26. IBJJF graduation / age bands. https://ibjjf.com/ (Rules Book; 2026 graduation PDF via IBJJF).  
27. Age at peak competitive performance in judo, Paris 2024 OG vs PG. UNIGE record: https://unige.iris.cineca.it/handle/11567/1270736  

**UNVERIFIED_SECONDARY (use only with that grade):**

28. AgentMMA (2026-07-16). What age do UFC fighters peak? https://agentmma.com/mma-lab/ufc-fighter-peak-age — useful as a *reader* of Kirk, not as a primary.  
29. BJJ Heroes (2021). Prime age for success in BJJ. https://www.bjjheroes.com/editorial/study-prime-age-for-success-in-bjj-competition-performance  
30. FightOpinion (2011). The 9-year rule. https://www.fightopinion.com/2011/06/19/9-year-rule-mma-ufc/  
31. FightAlpha / AgentMMA (2026). UFC ring rust. https://fightalpha.com/articles/does-ring-rust-matter-ufc — https://agentmma.com/mma-lab/ufc-ring-rust-win-rate-study  
32. Bloody Elbow (2013). Fighter longevity. https://bloodyelbow.com/2013/07/18/ufc-going-deeper-into-mma-fighter-longevity-does-age-matter/  
33. Geezers Boxing celebrity comeback n=20. https://www.geezersboxing.co.uk/news/post/retirement-ages  
34. The Sport Journal (2022). Age, regional distribution and fighting styles of elite MMA athletes. https://thesportjournal.org/article/age-regional-distribution-and-fighting-styles-of-elite-mixed-martial-arts-athletes/  

**Local:**

35. `/workspace/j10/TASK_J10.md`  
36. `/workspace/j10/GameState_age_gen.excerpt.txt` (`GameState.gd` ~3332)  
37. `/workspace/j10/BodyReadiness_ageish.excerpt.txt`  
38. `/workspace/j10/J1_ORGANIZATION_RULES_AND_JUDGES.md` (grade vocabulary; live scoring/weight facts)

---

## 6. Do-not-build list

1. **No invented sport-wide wage tables, purse-by-age curves, or “% of careers that end because of money.”**  
2. **No yearly integer deltas on game stats presented as researched.** If engineering needs a slope, `grade: UNKNOWN`.  
3. **No single `PEAK_AGE` constant.**  
4. **No sex-averaged windows.**  
5. **No `chin` stat.**  
6. **No boxing-style retirement cinematic applied to IBJJF / IJF / UWW / WT / WKF / sport sambo books.** Those are category moves.  
7. **No catalog rows of named real athletes** (named people as *citations* in this document are allowed; they are not data rows).  
8. **No “heavyweights peak later” law** — only an older male-MMA population, 2018 snapshot.  
9. **No 0–100 retirement formula claimed as commission math.** Flags yes; scoring function no.  
10. **No copying Hutchison’s male UFC KO ORs onto women’s books without an INHERITED label.**  
11. **No filling Muay Thai / kickboxing / sambo / Karate Combat peak ages from forum lore.**  
12. **No silent “fix” of 18–31 vs 19–27 generation.** Record it; another task owns the code.  
13. **No R51 code edits from this desk.** If R51 already shipped a curve that contradicts this file, leave the contradiction in the HANDOFF for Claude — this file already wrote it in §0.3.

---

## 7. Implementation notes for Claude (still research, not a patch)

- Birthday tick: does not exist. Adding one is design. This desk only says the live age is a static integer on generate.  
- Starter ages 19–27 already sit inside MMA’s winner cloud and on the late edge of amateur boxing’s medalist cloud. A maturation band that still *adds* `speed` at 26 is the wrong sign.  
- `BodyReadiness.medical_hold` is the only existing hook for “this fighter cannot take a fight.” Retirement pressure should **read that hook**, not replace it.  
- Weight-class books: apply Kirk offsets only on **male MMA**. Other disciplines: judo/taekwondo lighter-younger is a window shift of ~1–3 years, not a per-year slope.  
- Potential (`62–88` on starters) is not an aging variable in the excerpt; do not silently decay it and call that research.

---

*End of J10. Research only. 2026-09-07.*

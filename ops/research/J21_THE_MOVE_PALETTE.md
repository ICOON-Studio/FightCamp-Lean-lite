# J21 — THE MOVE PALETTE

**Desk:** John (research). **Assigned:** 2026-09-10. **Verification date for every live URL:** 2026-09-10.  
**Status:** study only. No GDScript. No enum. No move table. No clip list.  
**Scope:** what already exists in fight simulators, combat-sports games (where a *developer* described choice, not marketing), academic fight models, FightMetric/UFC Stats, and peer-reviewed boxing/MMA notational work.  
**Out of scope:** J17/J18 clip purchase; camera; engine verdicts. Q39 is context only (the engine presently emits body region + force, not technique).

**Grade legend (used on every claim):**

| Grade | Meaning |
| --- | --- |
| **DIRECT** | Quoted or paraphrased from a primary: official glossary, commission text, peer-reviewed paper, or a named developer describing their own system. Fetched 2026-09-10. |
| **INHERITED** | Follows from DIRECT text without adding a new rule (arithmetic on published counts; a named technique is available only where a paper already showed it activating). |
| **UNVERIFIED_SECONDARY** | Journalism, Wikipedia, aggregator, marketing copy, or a handbook that restates without being the promulgating text. Not used as a model. |
| **UNKNOWN / NOT FOUND** | Searched, not found at usable quality. **A fabricated palette is worse than none.** |

Where a *game* is cited, the source class is named in the row: **developer talk**, **developer interview**, **community frame-data wiki**, **journalism**, or **marketing**. Marketing “over 60 punches” is **refused** as a model.

---

## Decisions page

These are research-desk decisions about **what the sources say**, not engine design.

| ID | Decision |
| --- | --- |
| **D1 — Unit** | The atomic choice in realistic fight models is a **named technique** (jab, rear cross, lead hook, rear uppercut, low kick, double-leg, sweep, pass, submission attempt), **gated by range and position**. It is not an unnamed property bag, and it is not a category-only token (“straight / hook / kick”) without a name. Public UFC Stats then *collapse* those named throws into position × target × power buckets. That collapse is a **logger**, not the choice. |
| **D2 — Size** | Distinct choices **at a given moment** sit in the **single digits to low teens** (about **5–15**), not 100. The **catalogue** can be larger; the **live set** shrinks with range, stance, and position. Academic boxing: six named punches, of which 0–6 are actually available as scaled distance changes. Grappling: a handful of phase actions (shoot / pass / advance / sweep / sub attempt), most of them zero in a typical UFC round. |
| **D3 — Properties** | Minimum set that makes a sim **not dice**: **(1) range/reach (availability gate), (2) startup / time-to-hit, (3) recovery / commitment, (4) reachable target, (5) damage or effect, (6) land probability, (7) stamina or other cost, (8) beat/lose-to (what it is vulnerable to while committed).** Damage + target alone, with no time or range, is still dice. |
| **D4 — Choice** | What shipped sports-sim AI and academic action-selection actually do: **situation gates the legal set, then weighted random (or utility) over preferred named techniques**. Style is **preference weights**, not a different algorithm. Score, fatigue, and attributes modulate those weights. Learned policies exist in arcade fighting-game *research*; they are **not** documented as the UFC/Fight Night production method. |
| **D5 — Significant strike** | UFC/FightMetric: **every strike at distance, plus power strikes in the clinch and on the ground.** Not a technique class. Not a measured-joule threshold at distance. Not a judge’s score. A distance jab **counts**. A short clinch/ground non-power strike **does not**. Close-range “power” is a **human coder call**. Judges score **damage/effect** (ABC), a different object. |
| **D6 — Grappling** | **Two palettes, one selector.** Striking and grappling are different legal sets. Position (distance / clinch / ground, plus ground sub-positions) **switches which set is live**. The choice mechanism can be the same (weighted preference). FightMetric already logs them as separate columns: takedowns, passes, reversals, submission attempts. |
| **D7 — Refuse** | Collapse **weapon type** (punch vs kick vs elbow vs knee) as a statistically independent class — FightMetric’s own regression grayed **type** out. Collapse rare named submissions (knee-bar frequency in a 304-round UFC sample: **zero**). Do not treat combinations as atoms (they are sequences of named techniques). Do not treat marketing move-counts as a palette. Do not treat CompuBox’s two buttons as the UFC unit. |

---

## Do-not-build list

Do **not** build any of the following. This is a research memo, not a spec.

1. A GDScript enum of techniques, a move Resource, or a palette class.
2. A “60-punch” or “over 60 punches” catalogue copied from boxing-game store copy.
3. Reopening J17/J18 clip counts or camera.
4. Treating UFC Stats `SIG STR` as a damage meter or as a technique label.
5. Treating CompuBox jab/power as interchangeable with FightMetric significant/total.
6. A 100-choice live menu.
7. An unnamed `{range, commitment, target, risk}` blob as the *choice* (those are **properties of** a named technique).
8. Arcade frame-perfect RPS as if it were UFC.
9. One palette that mixes standing jabs with heel-hooks as peers available at every instant.

---

## 0. How to read the three representations

Three objects get confused. They are not the same.

| Object | What it is | Who uses it | Grade |
| --- | --- | --- | --- |
| **Named technique (the choice)** | Jab, rear cross, lead hook, rear uppercut, calf kick, double-leg, guard pass, rear-naked-choke attempt. | Academic notational templates; boxing sims (Title Bout punch types); Olympic boxing AI (BoxMind atomic event); fighting-game movelists; Hristovski’s six punches. | DIRECT on each named source below |
| **Logger bucket (the statistic)** | FightMetric: position × target × power × success (36 internal cells). Public UFC Stats: significant vs total; head/body/leg; distance/clinch/ground. CompuBox: jab vs power. | Official stats. **Does not name jab vs hook vs kick on the public fight page.** | DIRECT |
| **Property bag (the physics)** | Range, startup, recovery, damage, accuracy, stamina, beat/lose-to. | Fighting-game frame data; sports-sim ratings. These are **fields on a named move**, not the move. | DIRECT on frame-data wikis and sim ratings |

A sim that only picks **body region + force** can match a *target mix*. It cannot emit UFC technique columns (those columns **do not exist** on ufcstats.com), cannot name a clip “jab,” and cannot be a palette. That is the Q39 gap. It is a fact about the logger and about named-technique models, not a design.

---

## 1. What is the unit?

### 1.1 Academic boxing: six named punches, range as the gate

Hristovski, Davids, Araújo & Button (*J Sports Sci Med* 2006) asked how boxers choose. The task was a hanging heavy bag. The **choice set they counted** was six classical named punches: **right jab, left jab, right hook, left hook, right uppercut, left uppercut**. Scaled distance `D = X / arm length` was the control parameter. Availability changed abruptly:

| Scaled D | What is available | Grade |
| --- | --- | --- |
| D > 1.2 | Guard only. No punch. | DIRECT |
| ~1.2 | Left and right **jab** appear (Pearson r = 1.00 between hands for first appearance). | DIRECT |
| ~0.9–1.05 | **Hooks** appear. | DIRECT |
| ~0.65–0.9 | **Uppercuts** appear (least tightly coupled to D). | DIRECT |
| 0.45 < D < 0.65 | Full set of six. Diversity, entropy, and efficiency-ratio **peak near D = 0.6**. | DIRECT |
| D = 0.45 | Jabs **disappear**. | DIRECT |
| D = 0 | Uppercuts disappear. **Hooks only.** | DIRECT |

Reasons for diversity, in the paper’s own words: (i) abrupt changes in the **number of possible punches**; (ii) fine modification of the **probabilities** of selecting specific patterns. Perceived efficiency of a punch type correlated with its probability. Source: https://www.jssm.org/jssm-05-CSSI1-60.xml-Fulltext — verified 2026-09-10. **Caveat (DIRECT):** eight **novice** boxers, static bag, parallel stance, no opponent. It is a decision-making model of named punches vs distance, not a UFC sim.

Thomson, Lamb & Nicholas (*J Sports Sci* 2013) built a **reliable amateur boxing notational template** whose offensive indicators are the same named set: jab, rear-hand cross, lead hook, rear hook, lead uppercut, rear uppercut, plus attack/defence/feint. Intra-observer agreement 80–100%; inter-observer exact agreement lower, but 100% within ±1. PMID 23121380. https://pubmed.ncbi.nlm.nih.gov/23121380/ — DIRECT.

Thomson & Lamb (2016, *Int J Perf Anal Sport*) applied that template to 92 English amateurs. Independent of outcome/weight/ability, a bout was typified by **183 punches** (95% CI 171–195). Type frequencies from the published model table:

| Named punch | Frequency (95% CI) | Share of 183 (INHERITED) |
| --- | --- | --- |
| Jab | 64 (60–68) | ~35% |
| Rear-hand cross | 39 (37–41) | ~21% |
| Lead hook | 49 (46–51) | ~27% |
| Rear hook | 23 (20–26) | ~13% |
| Lead uppercut | 5 (5–6) | ~3% |
| Rear uppercut | 8 (7–9) | ~4% |

https://www.tandfonline.com/doi/abs/10.1080/24748668.2016.11868881 — DIRECT on the counts as published in the ResearchGate full text; INHERITED on the percentages. Uppercuts are a **named** technique and a **tiny** share.

Davis, Wittekind & Beneke (2017 activity profile after the 2013 amateur rule change): ~**21 punches per minute**, ~1.55 actions/s; winners threw more **straight** punches (lead-hand straights in round 1) and landed more in round 3. Uppercuts ~1.7 ± 2.3 in round 1 (mean, i.e. often near zero). https://www.researchgate.net/publication/313672929_The_Activity_Profile_of_Elite_Male_Amateur_Boxing_Following_the_2013_Rule_Changes — DIRECT.

El Ashker (2011): 19 technical-tactical variables; winners higher in **straights, hooks and uppercuts** to head or body, lead and rear hands, and **2-punch / 3+ punch combinations**. Combinations are counted as **sequences of named punches**, not a seventh punch type. https://www.tandfonline.com/doi/abs/10.1080/24748668.2011.11868555 — DIRECT.

Stanley, Thomson, Smith & Lamb (2018, 3D kinetics of six maximal punches): the six named punches **differ** in delivery time and fist velocity. Jab shortest delivery (**405 ± 150 ms**); lead hook highest peak fist velocity (**11.95 ± 1.84 m/s**). https://www.tandfonline.com/doi/full/10.1080/24748668.2018.1525651 — DIRECT. Named techniques are not interchangeable physics.

BoxMind (Wang et al., arXiv:2601.11492v2, 08 Mar 2026; Tsinghua / Beijing Sport University / Chinese Boxing Federation): the **atomic punch event** is a tuple `(t_start, t_end, hand ∈ {Lead, Rear}, distance ∈ {Long, Mid, Close}, technique ∈ {Straight, Hook, Uppercut}, target ∈ {Head, Torso}, effect ∈ {Effective, Ineffective})`. Those atoms aggregate to **18** technical-tactical indicators (distance mix, hand mix, target mix, trajectory mix, proactive vs counter, combination class). Validated as a closed-loop coaching tool at the 2024 Olympics. This is **not** a live fight simulator; it is the strongest recent statement that the **unit of boxing analysis is a named trajectory × hand × range × target**. https://arxiv.org/html/2601.11492v2 — DIRECT.

### 1.2 Official loggers collapse the name

**FightMetric / UFC Stats — public columns do not name the technique.**

FightMetric glossary (MMA Fighting reprint, 2011-05-09):

> **Strikes** – These striking statistics refer to the number of significant strikes. This number includes all strikes at distance and power strikes in the clinch and on the ground. It does not include short strikes in the clinch and on the ground.

Takedowns, passes, submission attempts, reversals are **separate named grappling events**, not strike subtypes. https://www.mmafighting.com/2011/05/09/171293/fightmetric-stats-glossary — DIRECT.

Public ufcstats.com / scrapers (ufc.stats data dictionary; Kaggle UFC fight-stats README; UFCscraper docs): significant vs total; head / body / leg; distance / clinch / ground; KD; TD; SUB ATT; REV; CTRL. **No jab column. No hook column. No kick column.** https://tamaszilagyi.com/ufc.stats/articles/data-dictionary.html — DIRECT on the published schema.

Reed Kuhn, *Fightnomics* (FightMetric data, used with permission): strikes fall into **36 categories** = Position (distance / clinch / ground) × Target (head / body / leg) × Strength (power / non-power) × Success (land / miss). Position is recorded from the **targeted** fighter. Kuhn: “When I said that FightMetric doesn’t care what kind of strike (punch, kick, elbow, knee, etc.) is used I was only talking about round-by-round data. In fact, FightMetric does record the ‘finishing strike’ for fights ending by KO/TKO.” Non-power is called “jab” in the internal strength split: **not** “lead-hand straight.” “Jabs are not just strikes with the lead hand, and power strikes cover more than punches with the rear.” PDF extract http://eamm.mex.tl/uploads/s/w/3/c/w3cpq5bbb729/file/jYrvOJmz.pdf — DIRECT on Kuhn’s description of FightMetric’s hierarchy; the PDF is a book extract, not FightMetric’s own site.

Aaron Iba, 2012 MIT Sloan Sports Analytics Conference, “Fighting with Data” (FightMetric founder, **developer/analyst talk**): conventional wisdom ranked strike **type** (punch vs kick) high. Their logistic regression on victory put **result** first, **target** second, **strength** third, **position** fourth, and **type grayed out — did not meet significance**. They then regrouped into **significant strikes** = every strike at distance + all power strikes in clinch/ground, “every strike other than the little tiny ones that happen at short distance.” Distance is “something which you can measure”; close-range power “that’s difficult to measure but we try to distill it as best.” https://www.youtube.com/watch?v=HGh0j7tfjvw — DIRECT (talk transcript).

**CompuBox (boxing logger): two buttons, not six punches.**

Two ringside operators, four keys: jab connect, jab miss, power connect, power miss. Wikipedia methodology (verified 2026-09-10): does not evaluate damage. https://en.wikipedia.org/wiki/CompuBox — UNVERIFIED_SECONDARY as encyclopedia; the four-key method is corroborated by BoxingInsider quoting co-founder **Bob Canobbio**: “We call a non-jab a power punch for lack of a better description… we call it power punch because it sounds better than non-jab.” https://www.boxinginsider.com/columns/the-troubles-with-compubox/ — DIRECT on the Canobbio quote as printed; the rest of that column is opinion. A lead hook and a rear uppercut are the **same CompuBox class**. That is a **logger collapse**, not a choice model.

### 1.3 Sports sims that actually simulate: named punches, not bags

**Title Bout Championship Boxing** (digital descendant of Avalon Hill *Title Bout*, 1979). GameSpot review (2004): the game “tracks the percentage of punch types thrown, letting you know if your guy favors **jabs, hooks, crosses, uppercuts, or combinations**.” Fighters rated in 30+ categories (hitting power, chin, killer instinct, conditioning). **Source class: journalism quoting the product.** https://www.gamespot.com/reviews/title-bout-championship-boxing-review/1900-6105487/ — UNVERIFIED_SECONDARY as review; the punch-type list is the product’s own stat categories as described.

Title Bout OFS design notes (web conversion of the 1979 boardgame): search extract, 2026-09-10, quotes “**Punch types.** There is no need to designate left or right hand for punches. Jab and hook are always with the left hand; cross and uppercut with the right (reversed for southpaws). Combination punch involves both hands.” Live fetch of https://www.morssweb.com/sports/tb/tb_intro.php returned **bandwidth limit** — treat the extract as **UNVERIFIED_SECONDARY** until the page is readable. **UNKNOWN** whether the current commercial TBCB executable uses the identical five-type split internally; the published *stat* surface in the 2004 review names those types.

**Fight Night Champion** (EA Tiburon). Assistant producer Jazz Brousseau quoting lead designer Brian Hayes: analog stick 12-to-6 o’clock “move[s] through a variety of punch types. There are twice as many punches available with FPSC compared to TPC.” Stepping, lunging, power, and fatigue punches added vs Round 4. **Source class: journalism quoting the designer.** https://wegotthiscovered.com/gaming/interview-fn-champion/ — DIRECT on the quoted designer sentences; punch **count** is “twice TPC,” not a number, and is a control scheme, not a sim palette size.

**Undisputed** (Steel City Interactive). Steam store: “More than 60 individual punches.” **Source class: marketing. REFUSED as a model.** CEO Ash Habib (PC Gamer, 2023, **developer interview**): real reach in inches; a 70-inch fighter “struggle[s] to land hooks on the inside” and may “control distance with jabs and straights.” Named techniques + range as gate — that sentence is usable. The “60” is not. https://www.pcgamer.com/undisputed-boxing-game-interview-GDC/ — DIRECT on Habib’s reach/technique sentence; marketing count discarded.

**EA Sports MMA** (Tiburon, 2010). Gameplay engineer **Rob Williams**, four AI goals, **developer interview** on GameDev.net: “Mix it up. Within the constraints of behaving as the real-life fighter, unpredictability can be done by **collecting the preferred actions of the fighter and choosing one at random, with actions more greatly preferred by the particular fighter given greater likelihood of being selected.**” The objects being collected are **preferred actions** (named), not property bags. https://gamedev.net/tutorials/visual-arts/building-brawl-handling-interacting-characters-r2777/ — DIRECT.

**EA Sports UFC** GDC talks (Harrower / Dowsett 2015; Harrower / Mathiesen 2016) are **animation systems** (relative IK, two-player ground animations: UFC 1 had 602 two-player ground anims; UFC 2 “over 1957” two-player ground, “3153 two player animations” in the tug grappling system — talk transcript). **Source class: developer talk, animation, not AI choice.** They establish that the *content* is named two-man techniques and positions, not that the CPU picks from a documented palette size. https://www.youtube.com/watch?v=Xw47OUed9vE and https://www.youtube.com/watch?v=1nSshgQ3HM4 — DIRECT on animation counts as spoken; **NOT** a choice model.

### 1.4 Fighting games: named move + frame data

Competitive fighting games treat the atomic offensive object as a **named move** with numeric properties (startup, active, recovery, damage, on-block, on-hit, guard, invuln). Dustloop “Using Frame Data”: every attack passes **startup → active → recovery**; 60 fps convention; on-block/on-hit is who acts first. https://www.dustloop.com/w/Using_Frame_Data — DIRECT (community wiki; this is how the genre *documents* moves, not a sports-sim). SuperCombo “Frame Data”: startup, active, recovery, advantage on hit/block, invincibility. https://wiki.supercombo.gg/w/Frame_Data — DIRECT, same class.

Capcom CEDEC 2024 (Yasuhara Naohiro, **developer talk** on *Street Fighter 6* CPU): actions are **cards** (e.g. Shoryuken, heavy kick, jump light punch) grouped into **tactics** (ground deck, anti-air deck) grouped into **operations**, executed with an **execution-ability** that can fail commands under pressure. Character identity is **which cards are in which deck** (Ryu’s Hadoken, Zangief’s Screw Piledriver). https://gamemakers.jp/article/2024_09_25_78341/ — DIRECT.

This is the arcade cousin of “named technique + situation gate + preference.” It is **not** UFC. It is evidence that even the most move-dense combat videogames do not choose from an unnamed property bag.

### 1.5 Which representation do realistic ones use?

| Tradition | Atomic choice | Grade |
| --- | --- | --- |
| Academic boxing notational (Thomson, Davis, El Ashker, Hristovski, BoxMind) | **Named punch** (6, or Straight/Hook/Uppercut × hand) | DIRECT |
| Title Bout / OFS | **Named punch type** (jab, hook, cross, uppercut, combination) | DIRECT / UNVERIFIED_SECONDARY as noted |
| EA MMA AI (Williams) | **Preferred named actions**, weighted random | DIRECT |
| Undisputed (Habib on reach) | Named punches whose usefulness **depends on reach** | DIRECT |
| FightMetric **logger** | Position × target × power (name discarded for public tables; type not significant for win) | DIRECT |
| CompuBox **logger** | Jab vs non-jab | DIRECT |
| UFC Stats **public page** | No technique name | DIRECT |
| Unnamed `{range, commitment, target, risk}` as the choice itself | **NOT FOUND** as the atomic unit of any serious fight model | NOT FOUND |

**D1 restated:** realistic *choice* models use **named techniques**. Realistic *loggers* then collapse names. A sim that wants UFC-grade validation **and** a palette must emit the name (for clips and style) and **also** be able to roll it up into FightMetric buckets (for SLpM). Collapsing first, as the current engine does, blocks both.

---

## 2. How big is the palette?

Two sizes. Do not mix them.

**Catalogue size** = how many named techniques exist in the sport or in a game’s asset list.  
**Live size** = how many are legal *right now*, given range, stance, position, rules.

### 2.1 Live size is small and range-gated

Hristovski: live size **0, 2, 4, or 6** named punches as D changes. Peak flexibility at D ≈ 0.6. Boxers in a real ring spend time near the **jab-reach edge** (D ≈ 1.2), where the opponent’s diversity is *minimised* — that is a coordination result in the same paper, not a palette-size claim about UFC. DIRECT.

Shadow Fight 3 (Mikhail Dragovalovskiy, Banzai Games, **designer article** 2019): “The bot evaluates the **distance** between itself and the player and generates a **list of those attacks that could reach** its opponent. Then it chooses a **random** attack from this list.” Live set = reach-filtered list, then random. https://80.lv/articles/ai-in-fighting-games-dissecting-shadow-fight-3 — DIRECT.

*Street Fighter 6* CPU (CEDEC 2024, **developer talk**): a situation deck contains a **handful** of cards (example: start-of-round deck = heavy kick / backdash / Hadoken). Not the full movelist. DIRECT.

Title Bout: five punch types in the published type split. Live size ≤ 5 offensive types plus clinch/defence. DIRECT / as graded in §1.3.

CompuBox live “palette” for the logger: **2**. That is why it cannot validate a jab/cross/hook sim. DIRECT.

Thomson 2016: six named punches are **coded**; it does not claim all six are equally available at every distance. Combined with Hristovski, the live offensive striking set in boxing is **about six names, of which a subset is in range**. INHERITED.

### 2.2 Catalogue can be large; live set does not grow with it

| Catalogue claim | Number | Source class | Use? |
| --- | --- | --- | --- |
| Undisputed “more than 60 individual punches” | 60+ | **Marketing** (Steam, Xbox Wire) | **Refuse** |
| Fight Night Champion “twice as many punches as TPC” | relative, unnamed | Designer quote in journalism | Control scheme, not live AI size |
| EA UFC 2 two-player ground **animations** | 1957 / 3153 spoken | **Developer talk**, animation | Asset count ≠ choices at an instant |
| FightMetric internal strike cells | 36 | Kuhn / FightMetric hierarchy | Logger cells, not choices |
| BoxMind technique axis | 3 trajectories × 2 hands × 3 ranges × 2 targets = 36 attribute combos | Academic | Attribute space, not 36 equally likely choices |
| IBJJF scoring actions | 6 (takedown, sweep, knee-on-belly, pass, mount, back) | Official rules | Grappling catalogue of **scoring** actions, not every variation |
| Miarka UFC grappling codebook | Many named subs + advances | Peer-reviewed | Most are **0 per round** (see §6) |

**NOT FOUND:** a developer-published number for “how many distinct offensive choices the EA UFC CPU considers at striking range.” Searched GDC UFC talks, EA UFC 6 Q&A (striking *feel*, combination packages, Real-Time Contact — not a palette cardinality). https://www.ea.com/news/ufc-6-developer-qa — DIRECT that the Q&A does not state a live choice count.

### 2.3 Does the palette change with fatigue, stance, position?

| Gate | Evidence | Grade |
| --- | --- | --- |
| **Range** | Hristovski D-gates; Shadow Fight reach-filter; Habib on hooks vs jabs by reach; FightMetric position split | DIRECT |
| **Position (stand / clinch / ground)** | FightMetric 36-cell hierarchy; Miarka standing vs groundwork; IBJJF actions illegal until the position exists (cannot “pass” without a guard) | DIRECT |
| **Stance (orthodox / southpaw; lead/rear)** | BoxMind maps physical L/R to lead/rear from torso/feet; Title Bout reverses jab/hook vs cross/uppercut for southpaws; Thomson codes lead vs rear separately | DIRECT |
| **Fatigue** | Fight Night Champion: “fatigue punches” as a punch *class* in the designer quote; Undisputed Steam: stamina, flat-footed movement when stamina drops (**marketing/store** for the latter). Kuhn *Fightnomics* has a chapter “The Effect of Fatigue” on FightMetric striking — **book**; full numeric table **not recovered** from the extract fetched. | DIRECT on FN Champion named class; UNVERIFIED_SECONDARY on Undisputed store stamina; **NOT FOUND** as a published “palette shrinks by N when tired” law |
| **Score / round** | Undisputed AI developer Steven (official short, **developer talk**): if down on points, more aggressive, may “go all in for a KO”; if winning, disengage. https://www.youtube.com/shorts/nAT2XLIq2KM — DIRECT on behaviour change, **not** on palette cardinality |
| **Catalogue vs live** | SF6 decks vs full movelist | DIRECT |

**D2 restated:** design against a **live set of about 5–15 named techniques**, changing when range or position changes. A 100-choice menu is not what the serious models do. A 2-choice CompuBox menu is too small for UFC technique talk.

---

## 3. What properties does a move carry?

### 3.1 Fighting-game frame data (the most explicit property list)

Dustloop / SuperCombo standard fields on a **named** move:

| Property | Meaning | Why it is not dice |
| --- | --- | --- |
| **Startup** | Frames until first hitting frame | Faster moves beat slower ones; jab vs hook is a time difference (Stanley: jab 405 ms vs hooks ~586–657 ms) |
| **Active** | Frames the hit can occur | Meaty / late-hit changes advantage |
| **Recovery** | Frames until the attacker may act again | Commitment. Whiff = punish window |
| **On-block / on-hit** | Who acts first after contact | Beat/lose-to in time, not in a hand-waved RPS table |
| **Damage** | Life removed | Effect |
| **Guard** | High / low / mid / throw | What defences beat it |
| **Invuln / crush** | What it is immune to during startup | Counter relationship |
| **Reach** | Dustloop FAQ: frame data **does not** include positional reach; you still have to check spacing in game | Range is a separate property |

https://www.dustloop.com/w/Using_Frame_Data — DIRECT.

Gigazine write-up of a Tekken 7 “technique card” visualisation lists the same family: generation (startup) frames, reach, damage, follow-up (block/hit/CH) frames. https://gigazine.net/gsc_news/en/20231224-visualizing-fighting-game-mechanics/ — UNVERIFIED_SECONDARY as journalism; the property *list* matches Dustloop.

### 3.2 Sports-sim ratings (named punch + fighter stats)

Title Bout (manual extract on OOTP forums / GameSpot): hitting power, punching accuracy, control factor (separate vs boxer and vs slugger), chin/KD, killer instinct, conditioning, and **punch-type mix** (how many 2-point vs 3-point punches by type). Accuracy and power are **fighter** ratings that modify **punch** outcomes. https://forums.ootpdevelopments.com/attachment.php?attachmentid=695268 — UNVERIFIED_SECONDARY as forum-hosted manual scan; consistent with GameSpot’s 30+ categories.

Undisputed AI (Steven, **developer talk**): “each fighter’s unique statistics such as **speed, hand power and ringcraft** will fine-tune their second-to-second decisions, impacting … **punch selection**, defensive choices, **combo length**, and even when to go for the kill.” Attributes → **preference over named punches**, not a replacement for names.

Fight Night / EA MMA: designers can change “timing windows, damage or reaction severity” per added punch without engineering (Hyder, EA MMA). Properties live **on the action**. DIRECT.

### 3.3 Academic: distance, time-to-hit, efficiency, target

| Property | Source | Grade |
| --- | --- | --- |
| Scaled reach / strikeability | Hristovski D = X/L; different punches have different effective arm length (jab full extension; hook/uppercut flexed) | DIRECT |
| Delivery time (startup analogue) | Stanley 2018: jab 405 ms; hooks/uppercuts ~600 ms | DIRECT |
| Peak fist velocity (power analogue) | Stanley: lead hook 11.95 m/s highest | DIRECT |
| Perceived efficiency → selection probability | Hristovski partial correlations | DIRECT |
| Target (head / torso; BoxMind also no legs in Olympic boxing) | BoxMind; Thomson; El Ashker | DIRECT |
| Effect (landed clean / not) | BoxMind `a_eff`; CompuBox land/miss; FightMetric land/miss | DIRECT |
| Combination as **sequence**, not atom | BoxMind indicators 16–18 (straight-straight / hook combo / uppercut combo); El Ashker 2-punch vs 3+ | DIRECT |

### 3.4 Minimum set that is not dice

Dice: pick a number from a bag. Region+force with no time and no name is dice with a damage table.

A move that **behaves differently from dice** needs all of:

1. **Range / reach** — whether it is even in the live set (Hristovski; Shadow Fight; Habib).  
2. **Startup / time-to-hit** — whether it lands before the opponent’s counter (Stanley; frame data).  
3. **Recovery / commitment** — what you give up if it misses (frame data; “commitment” in every coaching text; **no** peer-reviewed UFC “recovery-ms by technique” table was found — see UNKNOWN).  
4. **Target** — head / body / leg (FightMetric; UFC Stats; BoxMind).  
5. **Damage or effect** — knockdown probability, damage, or “effective” vs not (FightMetric strength; ABC damage; BoxMind effect).  
6. **Land probability** — accuracy is mix-dependent (UFC.com 2025: distance-head ~**33%**, ground-body ~**93%** historical). A single global 45% is dice. https://www.ufc.com/news/does-striking-accuracy-accurately-measure-striking — DIRECT.  
7. **Cost** — stamina, or some budget that makes jab-spam and haymaker-spam different. Fight Night fatigue punches; Undisputed stamina (store). **NOT FOUND:** a published UFC joule or “gas” cost per named technique.  
8. **Beat/lose-to** — what beats it while it is committed. Shadow Fight **collision tables** (precomputed: which animation beats which at which distance and delay). SF6 decks (anti-air vs ground). Hristovski: entering D ≈ 0.6 raises **your** diversity and **the opponent’s**. Without this, style cannot be counter-style.

**D3 restated.** If any of 1–3 are missing, the engine cannot tell a jab from a hook except by damage. If 8 is missing, two fighters with different weights still look like dice with different faces.

---

## 4. How is a move chosen?

### 4.1 What sports-sim production AI actually says

**EA Sports MMA — weighted random over preferred named actions** (Rob Williams, **developer interview**, 2010):

1. Don’t be a sap (do not take the opponent’s action as a cue to do a *negatively* predictable thing).  
2. Be yourself (predictable enough to match the real fighter’s stand-up vs ground preference).  
3. Mix it up: **collect preferred actions, choose one at random, higher preference → higher likelihood**.  
4. Live and learn: observe which tactics yield positive/negative results in-match.

That is **style as a weight vector over named actions**, plus a light online update. It is not a behaviour tree in the text, not MCTS, not a neural policy. DIRECT.

**Undisputed — style archetype + stats + score state** (Steven, AI developer, official short, **developer talk**):

- Four fight styles: sluggers and swarmers more in the pocket; out-boxers off the back foot; boxer-punchers a blend.  
- Speed, hand power, ringcraft **fine-tune punch selection**, defence, combo length, when to go for the kill.  
- If losing on points → more aggressive, possible all-in KO; if winning → disengage, make the player work.

https://www.youtube.com/shorts/nAT2XLIq2KM — DIRECT. Operation Sports piece on upcoming AI changes: page fetched 2026-09-10 returned **author bio only**, no technical body — **NOT FOUND** as a second source.

**Title Bout — style matchup + punch-mix ratings.** Control factor vs **boxer** and vs **slugger** (two numbers). Punch-type percentages. Killer instinct as a temporary automatic-control state. Between-round style choice if the fighter is rated mixed. **Source class: product documentation / review.** This is the oldest explicit “styles make fights” sim. UNVERIFIED_SECONDARY on forum manual scans; the two-CF design is repeated in official FAQ material on OOTP forums.

**Fight Night 2004** (Kudo Tsunoda, *Game Developer* magazine, **developer article**): analog fist control; “styles really made the fight”; AI designed so players develop tactics. Not a documented weight table. DIRECT on the magazine PDF extract https://media.gdcvault.com/GD_Mag_Archives/Game.Developer.2004.06-07.pdf as cited in search; the AI algorithm itself is **NOT FOUND**.

### 4.2 Academic / analytics: probability landscape, not a live policy

Hristovski: choice **emerges** from scaled distance × perceived efficiency. Not a planner. Probabilities, not a utility scorecard. DIRECT.

BoxMind: **not a live chooser**. It predicts match outcome from 18 career-style indicators, then takes **gradients** of win probability w.r.t. those indicators to recommend training (e.g. raise close/mid-range volume). 69.8% outcome accuracy on an 80 kg graph test set; 87.5% on a small Olympic set. Useful as “style is a vector of named-technique rates.” Useless as “the fighter’s next punch.” DIRECT.

Fight-analytics literature (James et al. 2017 *J Sci Med Sport*; Miarka series; FightMetric/Kuhn) predicts **outcomes from counts**, not the next action. James 2017: winning associated with ground strikes landed and takedowns landed — **post-hoc**, not a policy. DIRECT on the abstract.

Markov models: Miarka’s **judo** combat model (*Int J Perf Anal Sport* 2015) uses multi-state Markov on **phases** (approach, gripping, attack orientation, groundwork), not named throws as the atom. https://www.tandfonline.com/doi/abs/10.1080/24748668.2015.11868795 — DIRECT. **NOT FOUND:** a published UFC named-technique Markov chain of comparable quality.

### 4.3 Arcade fighting-game AI (different sport, same structural lesson)

| Method | What it is | Source | Grade |
| --- | --- | --- | --- |
| Distance-filter + random | Live list = what reaches; then random | Shadow Fight 3 designer | DIRECT |
| Collision tables | Precompute who hits whom at distance D and delay N; use as counter oracle | Shadow Fight 3 designer | DIRECT |
| Situation decks + execution noise | Cards in tactic decks; command can **fail** under pressure; resolution of “advantage” coarsens at low CPU level | SF6 CEDEC 2024 | DIRECT |
| MCTS + persona | FightingICE; Puppet-Master MCTS; persona = action-set prior (fitness 3 if in-set, 1 else) | Ishii et al., CIG 2018 | DIRECT |
| DRL / PPO | Street Fighter research agents; action space of buttons, not named sports techniques | various 2018–2026 papers | DIRECT as research; **not** a shipped sports sim |

General game-AI textbooks (utility AI, behaviour trees, GOAP) are **genre-wide**, not fight-specific. Dave Mark IAUS: score every candidate action, pick high score. **NOT FOUND** as a documented UFC/Fight Night implementation. Do not smuggle it in as “what EA does.”

### 4.4 What makes choice look like style, not dice

From the sources that actually shipped or were measured:

1. **The objects have names** (jab vs hook vs shot vs pass). Dice over `{head, torso, leg}` cannot look like a boxer vs a kicker.  
2. **Range/position gates the set** (Hristovski; FightMetric; IBJJF). A wrestler at distance still has to **choose a shot**; a boxer on his back does not have a jab.  
3. **Preference weights** (Williams; Title Bout mix %; Undisputed styles; BoxMind 18-vector). Two fighters, same legal set, different probabilities.  
4. **Attributes modulate weights** (speed, power, ringcraft → punch selection). The engine already has attributes, fatigue, damage, range: those become **multipliers on named-technique utilities**, not a substitute for names.  
5. **State modulates weights** (score, damage, stamina) — Undisputed Steven; Williams “live and learn.”  
6. **Some anti-repeat / mix-up** — Williams “don’t be a sap”; Shadow Fight “resentment” if the player spams one attack. Without this, a high jab-weight fighter is a coin that always lands jab.

**NOT FOUND:** a public, numeric UFC “utility function” that maps (range, fatigue, damage, stance) → technique weights. The **shape** is documented; the **coefficients** are not.

**D4 restated.** Weighted random (or utility) over a situation-gated named set, with fighter-specific weights. That is what EA MMA’s engineer said, what Title Bout’s ratings encode, what Undisputed’s AI dev said, and what Hristovski measured as probabilities. Behaviour trees and RL exist in other genres; they are not the documented sports-sim default.

---

## 5. “Significant strike” definition

This is the validation unit. Wrong definition → wrong harness (see J20).

### 5.1 Primary wording

FightMetric glossary (2011), as reprinted by MMA Fighting:

> “This number includes **all strikes at distance** and **power strikes in the clinch and on the ground**. It does not include **short strikes** in the clinch and on the ground.”

https://www.mmafighting.com/2011/05/09/171293/fightmetric-stats-glossary — DIRECT.

Kuhn’s FightMetric table (book extract):

|  | Power | Non-power (“jab” in FM strength sense) |
| --- | --- | --- |
| Distance | Significant | Significant |
| Clinch / ground | Significant | **Not** significant |

“The only strikes that aren’t significant are jabs thrown in the clinch or on the ground at any target.” DIRECT on Kuhn’s restatement of FightMetric.

Iba, SSAC 2012 (**FightMetric founder talk**): significant = every strike at distance (because distance implies “a requisite amount of velocity”) + all power strikes in clinch/ground. Close-range power is the hard coding call. Type (punch/kick) was **not** the grouping they kept. DIRECT.

UFC.com, 2025-02-05, “Does Striking Accuracy Accurately Measure Striking?” (**UFC primary**):

- Raw accuracy is mostly **which kinds of strikes you choose**.  
- Historical land rates cited: **ground body strikes ~93%**; **distance head strikes ~33%**.  
- Expected Striking Accuracy is computed from the **mix** of kinds thrown × historical land rates; Weighted Striking Accuracy is actual minus expected.  
- Example: both fighters 49% raw; the distance-head thrower was **+4** vs expectation, the mixer **−4**.

https://www.ufc.com/news/does-striking-accuracy-accurately-measure-striking — DIRECT.

ufc.stats explainer (Szilagyi): “significant strikes are **not** synonymous with power strikes. In a standup fight, jabs and short leg kicks count. … all punches and kicks are significant strikes except short strikes in the clinch or on the ground.” https://tamaszilagyi.com/ufc.stats/articles/2020-04-15-striking.html — INHERITED restatement of the glossary.

### 5.2 What it is not

| Claim | Verdict | Grade |
| --- | --- | --- |
| Technique class (only hooks/power hands) | **False.** Distance jabs count. | DIRECT |
| Power threshold at distance | **False.** Distance non-power counts. | DIRECT |
| Judge’s “significant” | **False.** ABC judges score **damage/effect**, not the FightMetric column. | DIRECT (ABC 2025 clarification) |
| Equal damage per landed significant | **False.** UFC.com 2025: kinds differ in difficulty; ABC: damage is result, not count. | DIRECT |
| Automatic / sensor | **False.** Human coding; close-range power is subjective (Iba). | DIRECT |

ABC MMA Scoring Criteria Clarification (July 2025 PDF, abcboxing.com): **Successful striking** = “legal strikes that result in **damage**.” Damage = results that lessen capacity/will (knockdowns, concussive strikes, retreat-to-defence, visual injury, etc.). “There is **no scoring by the judges for defense**.” Positional control **without** damage is **not** a 10-8. https://www.abcboxing.com/wp-content/uploads/2025/08/ABC-MMA-Scoring-Criteira-Clarification-7.2025.pdf — DIRECT. (Filename spelling “Criteira” is the file’s.)

So: **FightMetric significant ≠ ABC effective striking.** A sim can match SLpM and still lose rounds on the cards, or the reverse.

### 5.3 Implication for a palette

To **claim** the UFC statistic, each emitted strike must carry at least:

- **Position:** distance / clinch / ground  
- **Strength:** power / non-power (only matters off distance)  
- **Target:** head / body / leg  
- **Success:** land / miss  

Technique **name** is not required for the significant-strike **count**. It **is** required for animation purchase and for style. FightMetric records finishing-strike **type** for KO/TKO only (Kuhn). Public round tables do not.

**D5 restated.** Significant strike = position × power filter. Every distance strike + close-range power. Coder judgement at close range. Not a technique class, not a judge.

---

## 6. Grappling half

### 6.1 Official MMA logger: a second event list

FightMetric glossary (DIRECT):

| Event | Definition |
| --- | --- |
| **Takedown** | “deliberately grapples his opponent to the ground and establishes an advantageous position for an **appreciable amount of time**.” |
| **Pass** | “each incremental positional advancement on the ground, e.g. side control to mount.” New position held an appreciable time. |
| **Submission attempt** | “actual submission **holds applied**.” Not a hip-swing that never locks. |
| **Reversal** | Bottom fighter actively moves to **top**, without the opponent standing in between. |

These are **not** strikes. They are a **second palette**. UFC Stats public columns: TD, SUB ATT, REV, CTRL. No “single-leg vs double-leg” column. **NOT FOUND** as a UFC-wide official takedown-type split.

### 6.2 IBJJF: positional ladder with six scoring actions

IBJJF Rule Book v6.1 (June 2024), Article 3 / 2.5.2, official PDF:

| Points | Actions |
| --- | --- |
| **4** | Mount, back mount, back control |
| **3** | Guard pass |
| **2** | Takedown, sweep, knee on belly |

Points require **3 seconds** of stabilisation. Cumulative: pass then mount = 7 (3+4) if the three-second count is on the **final** position of a continuous sequence. You cannot re-score the same position by giving it up and taking it again. Sweep must start from **guard/half-guard**; reversing bottom side control is **not** a sweep. https://cdn.shopify.com/s/files/1/0727/9715/9746/files/2024JUN_IBJJF_Rules_EN.pdf — DIRECT.

This is a **named-action palette gated by position**, same shape as Hristovski’s punches gated by D. MMA does **not** use these point values; ABC grappling is **damage from** takedown/reversal/sub/advantageous position, not IBJJF points. DIRECT.

### 6.3 UFC notational: many names, almost all zero

Dal Bello, Brito, Amtmann & Miarka, *J Hum Kinet* 2019 (PMC6714373): 304 UFC rounds (2012–2014), grappling codebook of **named** standing actions (takedown attempts/landed, shots, lower-body vs upper-body, slams, sweeps, stand-ups) and ground actions (advances to/from half, side, mount, back; named chokes and locks).

Frequencies **per round** (Table 1 of the paper):

| Action | % of rounds with 0 | Implication |
| --- | --- | --- |
| Takedowns attempted | 33.4% zero | Live, but sparse |
| Takedowns landed | 59.1% zero | |
| Offensive passes | 70.5% zero | |
| Submissions attempted | 85.7% zero | |
| Rear-naked choke attempted | 95.8% zero | |
| Guillotine attempted | 93.5% zero | |
| Triangle / arm-triangle / arm-bar / ankle / shoulder | 98.7–99.4% zero | |
| **Knee bar attempted** | **100% zero** | |
| Sweeps | 93.8% zero | |

https://pmc.ncbi.nlm.nih.gov/articles/PMC6714373/ — DIRECT.

So: the **catalogue** of named grappling techniques is large. The **live** grappling choice in a typical UFC round is “shoot or don’t,” occasionally “pass / advance / try a hold.” Naming every lock in the live menu buys almost no distributional realism.

Outcome coupling (same paper): decision rounds attempt **more** takedowns; submission-ending rounds attempt **more** submissions/chokes/locks; KO/TKO rounds attempt **fewer** shots and sweeps. The grappling palette is chosen with an **end-condition strategy**, not uniformly. DIRECT.

Miarka et al. *J Strength Cond Res* 2016 (outcomes): standing techniques = strikes to head/body + takedowns; ground = submissions (chokes, joint locks) + positional improvements (mount, half, side, back). Winners higher in total strikes, submissions, positional improvements. https://journals.lww.com/nsca-jscr/fulltext/2016/07000/comparisons__technical_tactical_and_time_motion.22.aspx — DIRECT on the abstract’s variable list.

### 6.4 Wrestling: named shots, no UFC-official type mix

Collegiate notational work treats **single-leg, double-leg, high crotch** as the core named shots. Amateur Wrestling News / Gettysburg recap of 2013 NCAA quarterfinals: of 76 takedowns, nearly half were head-inside singles; **one** traditional high crotch. https://gettysburgsports.com/news/2013/8/28/WREST_0828132711.aspx — UNVERIFIED_SECONDARY (coach’s hand count). 2023 NCAA championship technical analysis (DOAJ): single-leg most frequent in period 1 (50%). DIRECT on that small-sample paper’s abstract.

Fight Encyclopedia “~32% of successful UFC takedowns are double-legs” — **marketing/blog**, **REFUSED** (no method, no FightMetric column exists to support it). **NOT FOUND:** UFC-official takedown-type percentages.

### 6.5 Games

EA MMA Williams: fighters prefer stand-up **or** ground — two **domains**, one AI. EA UFC GDC: thousands of **two-player ground animations** tied to positions and transitions — content is positional, not a single flat list. DIRECT as graded above.

**D6 restated.** Two palettes (strike / grapple), switched by position, same selection mechanism (weighted preference). Grappling atoms that matter at UFC frequency: **takedown attempt, takedown land, pass/advance, reversal, submission attempt (hold actually applied), stand-up, sweep.** Named sub flavour is almost always zero. Do not build a 40-lock menu to chase realism.

---

## 7. What is not worth modelling

Serious models **already collapse**. Bigger catalogues stop buying realism where the data are zeros, where regressions gray the distinction out, or where the object is a sequence.

| Distinction | What serious models do | Why further splitting stops paying | Grade |
| --- | --- | --- | --- |
| Punch vs kick vs elbow vs knee as a **win predictor** | FightMetric/Iba: **type not significant**; public tables drop it | You cannot validate it on ufcstats.com; finishing-strike type exists only for KO/TKO | DIRECT |
| Lead hook vs rear uppercut in **broadcast boxing stats** | CompuBox: both = “power” | Logger has two buttons. A six-punch sim **cannot** be checked against CompuBox type mix except jab vs non-jab | DIRECT |
| FightMetric’s 36 cells vs public 9 | Public: 3 position × 3 target (significant), plus total | Kuhn: obscure cells (clinch power leg, ground power body) are a **tiny share** | DIRECT |
| Uppercut as a volume class | Thomson ~3–7% of punches; Davis means ~1.7/round with SD > mean | Keep the **name** (range gate, different kinematics); do not expect it to move league SLpM | DIRECT |
| Every wrestling finish (blast / snatch / run-the-pipe / low double) | UFC logger: takedown yes/no + appreciable control | No official type column; NCAA type mix is a different sport | DIRECT / NOT FOUND for UFC |
| Every named submission | Miarka 304 rounds: knee bar **0**; most named chokes 0 in 93–99% of rounds | Keep **choke vs joint** and “hold applied”; drop the encyclopedia | DIRECT |
| Combinations as atoms | El Ashker, BoxMind, Davis: combos are **sequences of named punches** | A “1-2-3” is jab then cross then hook, each with its own startup/recovery | DIRECT |
| Marketing move counts | Undisputed “60 punches”; similar store copy | Not a live set, not a logger, not a paper | Refuse |
| Arcade 50–100 move characters as UFC | SF6: **situation decks**, not the full list | Live size is the deck | DIRECT |
| Unnamed property-bag choice | **No serious model uses it as the atom** | Properties belong **on** a named technique | NOT FOUND |
| Significant strike as a damage meter | FightMetric is a filter; ABC damage is a **result** | Matching SLpM ≠ matching scorecards | DIRECT |
| IBJJF point values inside MMA | ABC: damage from grappling, not 4-for-mount | Wrong sport | DIRECT |
| Frame-perfect RPS as the UFC chooser | Collision tables exist in *Shadow Fight*; UFC striking is not 60 fps authored frames | Different game | DIRECT |

**Where bigger palettes still buy something:**  
- Named punch **class** at boxing granularity (6) because kinematics, range gates, and notational templates all use it.  
- Named **phase** on the ground (pass, mount, back, sub attempt) because FightMetric and IBJJF and Miarka all use it.  
- Fighter-specific **weights** over that small set, because that is style.

**D7 restated.** Collapse weapon type as a statistical class; collapse rare named subs and wrestling finish variants; treat combos as sequences; refuse marketing counts; do not replace names with a property bag.

---

## 8. How engine facts become technique preference (research mapping, not a spec)

The engine already has attributes, fatigue, damage, range. Sources say how those become **preference over named techniques** — not how to code it.

| Engine fact | What sources do with it | Grade |
| --- | --- | --- |
| **Range** | Gates the live set (Hristovski; Shadow Fight; FightMetric position). Multiplies land probability (UFC 2025: 33% distance-head vs 93% ground-body). | DIRECT |
| **Attributes (speed, power, …)** | Undisputed: fine-tune punch selection, combo length, kill timing. Title Bout: accuracy and HP modify punch outcomes; mix % is a **rating**. Williams: preferred-action weights. | DIRECT |
| **Fatigue / stamina** | Fight Night: fatigue **punches** as a class. Undisputed store: sloppier / flat-footed. Kuhn chapter on fatigue **exists**; numeric UFC “tired fighters throw N% fewer hooks” **NOT FOUND**. | DIRECT / NOT FOUND |
| **Damage taken / given** | ABC: damage is what judges score. Undisputed: hurt → retreat (Thrill of the Fight 2 patch notes are a **different game**, journalism). Williams: live-and-learn on what worked. | DIRECT on ABC; NOT FOUND as a UFC technique-weight formula |
| **Score / round** | Undisputed Steven: losing → aggression / KO hunt; winning → disengage. Miarka: decision-seeking fights shoot more; finish-seeking fights sub more. | DIRECT |
| **Stance** | BoxMind lead/rear from stance; Title Bout mirrors punch types for southpaw. | DIRECT |

That is the whole mapping the literature supports. Coefficients: **NOT FOUND**.

---

## 9. Sources (live, 2026-09-10)

### Official / primary loggers and rules

1. FightMetric stats glossary (MMA Fighting reprint, 2011-05-09) — https://www.mmafighting.com/2011/05/09/171293/fightmetric-stats-glossary  
2. UFC.com, “Does Striking Accuracy Accurately Measure Striking?”, 2025-02-05 — https://www.ufc.com/news/does-striking-accuracy-accurately-measure-striking  
3. ABC MMA Scoring Criteria Clarification, July 2025 — https://www.abcboxing.com/wp-content/uploads/2025/08/ABC-MMA-Scoring-Criteira-Clarification-7.2025.pdf  
4. ABC Unified Rules index — https://www.abcboxing.com/unified-rules/  
5. IBJJF Rule Book v6.1, June 2024 — https://cdn.shopify.com/s/files/1/0727/9715/9746/files/2024JUN_IBJJF_Rules_EN.pdf  
6. ufc.stats data dictionary (schema of public UFC Stats columns) — https://tamaszilagyi.com/ufc.stats/articles/data-dictionary.html  
7. Szilagyi, striking explainer, 2020-04-15 — https://tamaszilagyi.com/ufc.stats/articles/2020-04-15-striking.html  

### Peer-reviewed / academic

8. Hristovski, Davids, Araújo, Button, *J Sports Sci Med* 2006, “How boxers decide to punch a target” — https://www.jssm.org/jssm-05-CSSI1-60.xml-Fulltext  
9. Thomson, Lamb, Nicholas, *J Sports Sci* 2013, amateur boxing PA template — https://pubmed.ncbi.nlm.nih.gov/23121380/  
10. Thomson & Lamb, 2016, technical demands of amateur boxing — https://www.tandfonline.com/doi/abs/10.1080/24748668.2016.11868881  
11. Stanley, Thomson, Smith, Lamb, 2018, 3D kinetics of six punches — https://www.tandfonline.com/doi/full/10.1080/24748668.2018.1525651  
12. El Ashker, 2011, winning vs losing boxing — https://www.tandfonline.com/doi/abs/10.1080/24748668.2011.11868555  
13. Davis, Wittekind, Beneke, 2017, elite amateur boxing activity profile — ResearchGate 313672929  
14. Wang et al., BoxMind, arXiv:2601.11492v2 — https://arxiv.org/html/2601.11492v2  
15. Dal Bello, Brito, Amtmann, Miarka, *J Hum Kinet* 2019, UFC grappling by outcome — https://pmc.ncbi.nlm.nih.gov/articles/PMC6714373/  
16. Miarka et al., *J Strength Cond Res* 2016, MMA by outcomes — PubMed / LWW  
17. Miarka et al., judo Markov combat model, 2015 — https://www.tandfonline.com/doi/abs/10.1080/24748668.2015.11868795  
18. Ishii, Liu, Thawonmas, CIG 2018, MCTS fighting-game personas — https://www.ice.ci.ritsumei.ac.jp/~ruck/PAP/cig2018-ishii.pdf  

### Developer talks / interviews (games)

19. Aaron Iba, 2012 SSAC, “Fighting with Data” (FightMetric) — https://www.youtube.com/watch?v=HGh0j7tfjvw  
20. Rob Williams (EA Tiburon), EA Sports MMA AI goals, GameDev.net 2010-11-30 — https://gamedev.net/tutorials/visual-arts/building-brawl-handling-interacting-characters-r2777/  
21. Yasuhara Naohiro, CEDEC 2024, Street Fighter 6 CPU — https://gamemakers.jp/article/2024_09_25_78341/  
22. Geoff Harrower & Lee Dowsett, GDC 2015, UFC animation system — https://www.youtube.com/watch?v=Xw47OUed9vE  
23. Harrower & Mathiesen, GDC 2016, UFC 2 procedural animation — https://www.youtube.com/watch?v=1nSshgQ3HM4  
24. Steven, Undisputed AI developer, official short — https://www.youtube.com/shorts/nAT2XLIq2KM  
25. Ash Habib, Undisputed, PC Gamer 2023 (**developer interview**) — https://www.pcgamer.com/undisputed-boxing-game-interview-GDC/  
26. Mikhail Dragovalovskiy, Shadow Fight 3 AI, 80.lv 2019 (**designer article**) — https://80.lv/articles/ai-in-fighting-games-dissecting-shadow-fight-3  
27. Jazz Brousseau quoting Brian Hayes, Fight Night Champion (**designer quote in journalism**) — https://wegotthiscovered.com/gaming/interview-fn-champion/  
28. EA SPORTS UFC 6 developer Q&A — https://www.ea.com/news/ufc-6-developer-qa  

### Frame data / genre documentation

29. Dustloop, “Using Frame Data” — https://www.dustloop.com/w/Using_Frame_Data  
30. SuperCombo, Frame Data — https://wiki.supercombo.gg/w/Frame_Data  

### Boxing logger

31. CompuBox methodology — https://en.wikipedia.org/wiki/CompuBox (encyclopedia; four-key method corroborated by)  
32. BoxingInsider, Canobbio “power punch = non-jab” quote — https://www.boxinginsider.com/columns/the-troubles-with-compubox/  
33. GameSpot, Title Bout Championship Boxing review, 2004 — https://www.gamespot.com/reviews/title-bout-championship-boxing-review/1900-6105487/  
34. Title Bout OFS design notes — https://www.morssweb.com/sports/tb/tb_intro.php  

### FightMetric structure via Kuhn

35. *Fightnomics* extract (36 categories; significant-strike table) — http://eamm.mex.tl/uploads/s/w/3/c/w3cpq5bbb729/file/jYrvOJmz.pdf  

### Journalism used only as pointer (not as model)

36. Undisputed Steam store (“60 punches”) — https://store.steampowered.com/app/1451190/Undisputed/ — **marketing, refused**  
37. Forbes UFC 6 RTC (four-frame landing window) — https://www.forbes.com/sites/brianmazique/2026/05/18/ea-ufc-6-devs-explain-real-time-contact-flow-state-grappling-and-presentation-leaps/ — journalism quoting Bassi; **animation/contact**, not palette  

### Prior desk (context, not re-opened)

38. J20, FightMetric significant-strike wording and UFC Stats columns — `/workspace/j20/J20_THE_VALIDATION_CORPUS.md`

---

## 10. UNKNOWN / NOT FOUND

Searched 2026-09-10. Do not fill these with invented palettes.

| Missing object | Why it matters | What exists instead |
| --- | --- | --- |
| **UFC-official takedown-type mix** (single vs double vs trip vs throw) | Would size the grappling named set | FightMetric TD yes/no + appreciable control; Miarka lower-body vs upper-body vs “shots” in a 304-round sample |
| **UFC-official punch/kick/elbow/knee shares** on public tables | Would tell you whether weapon type is worth a column | Iba: type not significant for win; finishing-strike type for KO/TKO only (Kuhn) |
| **Developer-published EA UFC live choice cardinality** | Would pin D2 for that series | Animation counts; UFC 6 Q&A on combinations/feel; Williams (2010 MMA, not UFC) |
| **Numeric UFC utility: (range, fatigue, damage) → technique weights** | Would turn D4 into coefficients | Shape only (Williams weights; Undisputed styles; Hristovski probabilities on a bag) |
| **Peer-reviewed recovery-time table for MMA techniques** | Property 3 | Boxing delivery times (Stanley); fighting-game recovery frames (different sport) |
| **Stamina cost per named UFC technique** | Property 7 | Game systems (FN fatigue punches; Undisputed stamina store copy); no UFC joule table |
| **Modern UFC fight-time share** distance/clinch/ground | Live-palette occupancy | J20: **NOT FOUND** league-wide; 2013 FightMetric-era snapshot only |
| **CompuBox six-punch split** | Boxing validation at Thomson granularity | Four keys: jab land/miss, power land/miss |
| **FightMetric public “jab” = lead hand** | People will misread Kuhn | Kuhn: internal “jab” = **non-power**, any hand |
| **Title Bout 2026 executable’s exact punch-type list** | Sim comparison | 2004 review + OFS notes + forum manual scans |
| **Q39 write-up as a public document** | Prompt cites it | Treated as given context: engine emits region + force |
| **A serious model whose atomic choice is an unnamed property bag** | D1 negative | **NOT FOUND** |
| **Double-leg share of UFC takedowns as an official number** | Grappling mix | Fight Encyclopedia ~32% **refused** (no method) |

---

## 11. One-page recap for Claude (not a spec)

If a UFC-grade sim is going to **choose** and **validate**:

- **Choose** a **named technique** from a **live set of about 5–15**, gated by **range and position**, with **fighter-specific weights** (style), modulated by attributes / fatigue / score.  
- **Carry** on each technique at least: reach, startup, recovery, target, damage/effect, land probability (kind-dependent), cost, beat/lose-to.  
- **Log** every strike into FightMetric cells: position × target × power × success, so **significant** = all distance + close-range power.  
- **Grapple** from a **second** live set: shoot, pass/advance, reverse, apply a hold, stand up. Do not populate it with encyclopedia locks.  
- **Do not** use marketing move counts, CompuBox’s two buttons as the UFC unit, or weapon-type as a win model.

The engine’s present `{region, force}` object is a **logger fragment**. It is not a palette.

---

*End of J21. No engine prescription. The unit, the size, the properties, the chooser, the significant-strike filter, the grappling split, and the refusals are the product.*

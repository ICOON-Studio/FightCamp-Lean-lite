# K71_CAUSATION_CARD.md

**Job of the card:** After every bout, give the player one readable answer to “why did that end that way?”  
**Not the job:** Retune probabilities, justify bad luck, or design a layout. Unit = **sentences**.  
**Assumption (from K70):** The engine already decided the result from internal facts. Honesty is reporting those facts.

Grounding used below: FM post-match analyst/xG story shape; OOTP box + play narrative; broadcast Compubox-style punch splits; UFC/EA post-fight stat lines. Exact official field lists for UFC career mode cards: **NOT FOUND** as a published schema this pass — treat “stat line without a why sentence” as the failure mode those UIs share.

---

## 1. THE FIXED SKELETON

Always present, always in this order. Names are the UI labels (words only).

| # | Label | Always? | Contents |
|---|---|---|---|
| 1 | **RESULT** | Yes | Winner name — Method — Clock. Method vocabulary locked below. |
| 2 | **EXPECTATION** | Yes | One line: how this matched the pre-fight lean (favourite / slight favourite / pick’em / underdog). If no pre-fight strip shipped yet, still write the lean from the same differential the strip would have used. |
| 3 | **WHY** | Yes | 3–5 bullets. Ranking rule in §3. |
| 4 | **SCORECARD** | Only if method is Decision or Draw | Per-round or total judge line in plain words (see §2.4). |
| 5 | **RARE PATH** | Only if finish used a rare branch | One extra line naming the rare path (flash KO, doctor cut, etc.). Never replaces WHY; sits under it. |

### 1.1 RESULT — method vocabulary (locked)

Use exactly one of:

`KO` · `TKO` · `Submission` · `Decision` · `Draw` · `Doctor Stoppage` · `No Contest`

Clock format: `R{n} {m}:{ss}` (e.g. `R2 3:14`). For decisions/draws: `After 3` / `After 5` (scheduled rounds).

RESULT sentence template:

> **{Winner}** def. **{Loser}** — **{Method}** · {Clock}

Draw:

> **Draw** — {Method detail if any} · {Clock}

### 1.2 EXPECTATION — one line only

Templates (pick one):

- `As expected — {Winner} was the favourite.`
- `Slight upset — {Winner} was only a slight favourite.`
- `Upset — {Winner} came in as the underdog.`
- `Coin-flip card — this was listed pick’em.`
- `As expected — the favourite {Loser} still lost.` ← use when favourite loses (expectation names the *pre-fight* lean, not the result)

When the favourite loses, EXPECTATION must say the favourite lost. Do not hide the upset.

### 1.3 WHAT IS NOT IN THE SKELETON

No odds percentages, no “win chance,” no attribute dumps, no training grades, no purse, no fan reactions. Those are other screens.

---

## 2. THE BULLET GRAMMAR

### 2.1 Template (locked)

Every WHY bullet is **one sentence** in this shape:

> **{Actor}** {verb phrase naming the mechanism} — {evidence clause}.

Rules:
- **Actor** = fighter name or “Both.”
- **Mechanism** = what decided the path (volume to the head, failed takedown defence, accumulated leg damage, a single counter, control time, cut, fade).
- **Evidence** = one concrete count, comparison, or timed event the engine retained. Numbers preferred; “a lot” forbidden.
- No compound essays. If you need two mechanisms, that is two bullets.
- Second person (“you”) allowed only when the player’s fighter is named in RESULT already; prefer names for clarity in losses.

### 2.2 Mechanism verbs (allowed set)

Use these families so copy stays consistent:

| Family | Example verbs |
|---|---|
| Striking volume | outlanded, piled up, could not match |
| Power / finish | dropped, finished, ended it with |
| Accumulation | broke down, the damage added up, slowed |
| Grappling | controlled, stuffed, hunted the submission, escaped until |
| Defence failure | ate clean shots when, failed to stop, walked into |
| Conditioning | faded, emptied the tank, couldn't keep |
| Cut / medical | the cut forced, swelling closed |
| Gap | never solved, gap was too wide |

### 2.3 Twelve worked examples

Fighters: **Rios** (player) vs **Kane**. Swap names freely; grammar stays.

---

**(1) One-punch knockout**

RESULT: `Kane def. Rios — KO · R1 2:03`  
EXPECTATION: `Upset — Kane came in as the underdog.`  
WHY:
- `Kane ended it with a counter right hand — one clean shot while Rios was leaning in.`
- `Rios had been winning the exchange count — 11–4 significant strikes before the finish.`
- `Kane’s power showed once — no prior knockdown; the fight was not an accumulation.`
RARE PATH: `Flash finish — single shot, no long hurt sequence.`

---

**(2) Accumulation TKO**

RESULT: `Rios def. Kane — TKO · R3 1:20`  
EXPECTATION: `As expected — Rios was the favourite.`  
WHY:
- `Rios broke Kane down at range — 48–19 significant strikes, most to the head.`
- `Kane was hurt twice before the stoppage — rocks in R2 and early R3.`
- `The finish followed the second rock — referee stepped in after a flurry, not a single punch.`

---

**(3) Submission**

RESULT: `Rios def. Kane — Submission · R2 4:11`  
EXPECTATION: `As expected — Rios was the favourite.`  
WHY:
- `Rios hunted the submission off a takedown — locked a rear-naked choke at 4:11 of R2.`
- `Kane failed to stop the takedown — 1 for 4 against Rios’s attempts.`
- `Once on the back, Kane had no escape window — control through the finish.`

---

**(4) Decision the player won narrowly**

RESULT: `Rios def. Kane — Decision · After 3`  
EXPECTATION: `Coin-flip card — this was listed pick’em.`  
WHY:
- `Rios edged the strike count — 62–55 significant strikes.`
- `Kane won the wrestling minutes — 2:40 control to Rios’s 0:55.`
- `The difference was Rios’s cleaner R3 — judges gave Rios the last round on damage.`
SCORECARD: `29–28, 29–28, 28–29 — Rios by split.`

---

**(5) Decision the player lost narrowly**

RESULT: `Kane def. Rios — Decision · After 3`  
EXPECTATION: `Slight upset — Rios was only a slight favourite.`  
WHY:
- `Kane outlanded Rios over three rounds — 71–64 significant strikes.`
- `Rios’s takedowns did not stick — 0 for 3; no control time banked.`
- `R2 belonged to Kane — volume and a late rock the judges kept on the card.`
SCORECARD: `29–28, 29–28, 29–28 — Kane unanimously.`

---

**(6) Decision that was one-sided**

RESULT: `Rios def. Kane — Decision · After 3`  
EXPECTATION: `As expected — Rios was the favourite.`  
WHY:
- `Rios never let Kane into the fight — 94–31 significant strikes.`
- `Kane’s entries failed — 0 for 5 takedowns, stuffed each time.`
- `Every round scored the same way — clear on volume and damage, no swing round.`
SCORECARD: `30–27, 30–27, 30–27 — Rios.`

---

**(7) Doctor stoppage on a cut**

RESULT: `Kane def. Rios — Doctor Stoppage · R2 0:45`  
EXPECTATION: `Upset — Kane came in as the underdog.`  
WHY:
- `A cut over Rios’s eye forced the stoppage — doctor ended it between rounds / on inspection.`
- `Kane’s elbows opened the damage — cut event logged after an elbow exchange in R2.`
- `On strikes alone Rios was still ahead — 28–22 significant at the stop.`
RARE PATH: `Medical stoppage — cut, not accumulated knockdowns.`

---

**(8) Fight ended by leg damage**

RESULT: `Rios def. Kane — TKO · R3 0:50`  
EXPECTATION: `As expected — Rios was the favourite.`  
WHY:
- `Rios slowed Kane with leg kicks — 24 landed to the lead leg before the stop.`
- `Kane’s movement went first — check rate fell after R2; exits got shorter.`
- `The finish came when Kane could not stay off the fence — flurry after the leg was compromised.`

---

**(9) Loser was winning until a single exchange**

RESULT: `Kane def. Rios — KO · R3 4:02`  
EXPECTATION: `As expected — the favourite Rios still lost.`  
WHY:
- `Rios was ahead on volume into the final minute — 81–52 significant strikes.`
- `One exchange flipped the fight — Kane’s left hook dropped Rios at 4:02 of R3.`
- `Rios had not been rocked before that shot — the card turned on a single clean hit.`
RARE PATH: `Swing finish — winner was behind until the finishing exchange.`

---

**(10) Both men were fading**

RESULT: `Rios def. Kane — Decision · After 3`  
EXPECTATION: `Coin-flip card — this was listed pick’em.`  
WHY:
- `Both emptied the tank by R3 — output fell hard after the midpoint (R1–2 pace vs R3).`
- `Rios faded less — still outlanded Kane 18–11 in R3 when both were slow.`
- `Late control decided it — Rios held a short clinch against the fence in the last minute.`
SCORECARD: `29–28, 29–28, 29–28 — Rios.`

---

**(11) Squash — gap simply large**

RESULT: `Rios def. Kane — TKO · R1 1:15`  
EXPECTATION: `As expected — Rios was the favourite.`  
WHY:
- `The gap was simply large — Rios landed at will (22–3 significant) before the stop.`
- `Kane had no answer at range — zero successful entries, no clinch relief.`
- `Early rock ended the night — first big connection led straight into the stoppage.`

---

**(12) Draw**

RESULT: `Draw — Decision · After 3`  
EXPECTATION: `Coin-flip card — this was listed pick’em.`  
WHY:
- `The rounds split cleanly — each man took a round on a different weapon.`
- `Rios owned the striking minutes — 70–58 significant strikes.`
- `Kane owned the wrestling minutes — 3:10 control to 0:40.`
- `Neither built a swing round — no knockdowns; judges found a deadlock.`
SCORECARD: `28–28, 29–28 Rios, 29–28 Kane — draw.`

---

### 2.4 SCORECARD wording

When present:

> `{card1}, {card2}, {card3} — {Winner} by {unanimous|split|majority}.`

Draw cards as in example 12.  
If the engine only stores aggregate winner without per-judge triples: **NOT FOUND / cannot write full cards** — fall back to:

> `Decision — {Winner} on the cards (individual judge scores not retained).`

and put that limitation in §6 as a retention ask. Do not invent 29–28 lines.

---

## 3. THE RANKING RULE

A fight may generate dozens of facts. The card shows **3 bullets minimum, 5 maximum**. Pick with this **strict priority stack**. Walk top-down; take a fact only if it is true for this fight and not redundant with a bullet already chosen. Stop at 5.

### Priority stack (highest first)

| Priority | Slot name | What qualifies | Max bullets from this tier |
|---|---|---|---|
| **P0** | **Finishing action** | The event that ended the fight (the KO shot, the choke, the ref wave-off flurry, the doctor call, the decisive swing). Mandatory when method ≠ Decision/Draw. | 1 |
| **P1** | **State that made the finish legal** | Rock → follow-up; failed TD → back taken; leg compromised → fence trap; cut event → doctor. Only if a state flag/event exists. | 1 |
| **P2** | **Primary scoreboard edge** | Largest plain mismatch that matches the result story: significant-strike differential, control-time differential, or knockdown count. Pick the single biggest edge (see tie-break). | 1 |
| **P3** | **Counter-edge / tension** | The loser’s best true claim (they were ahead on strikes until…; they won wrestling but lost damage). Mandatory on **narrow decisions**, **swing finishes**, and **upsets**. Optional otherwise. | 1 |
| **P4** | **Shape / pacing** | Fade, squash gap, both-empty-tank, one-sided rounds. Use when it changes how to read P2. | 1 |
| **P5** | **Flavour only if under 3 bullets** | Secondary weapon (calf kicks as setup, clinch stalling). Never displaces P0–P3. | fill to 3 |

### Tie-breaks inside P2

Compare normalized edges; pick one:

1. If method is Decision/Draw → prefer the edge judges use in your ruleset (default: significant strikes if no knockdown; if knockdown differential ≥1, prefer knockdowns).  
2. If method is Submission / ground TKO → prefer grappling control / TD success over strike volume.  
3. If method is KO/TKO standing → prefer head significant strikes + rock count over control time.  
4. If differentials are within **10% relative** of each other → prefer the one that matches P0’s family (don’t lead with wrestling if the finish was a head kick).

Exact “10%” is a **copy ranking threshold**, not an engine probability. If implementers need a different cutoff, change the threshold — do not change sim math.

### Hard requirements

- **Upset** (underdog wins): must include P3 (what the favourite was winning on) OR a sentence that the favourite’s edge did not show — never an upset card that only praises the winner.
- **Swing finish** (loser ahead until one exchange): P3 mandatory (the “was ahead until…” bullet).
- **Decision margin ≤ 1 round equivalent / split or majority**: P3 mandatory.
- **Squash**: P4 “gap was simply large” allowed; still need P0 or P2, not three gap metaphors.
- **Never** two bullets that restate the same differential in different words.

### Count targets

| Fight type | Target bullets |
|---|---|
| Clean favourite finish | 3 |
| Upset, swing, narrow decision, draw | 4–5 |
| Doctor / rare path | 3–4 + RARE PATH line |

---

## 4. WHAT IS FORBIDDEN ON THE CARD

| Forbidden | Why |
|---|---|
| Raw probabilities (`12% flash chance`, `0.31 finish p`) | Reads as dice; trains the player to distrust the sim. K70: explicability ≠ showing RNG. |
| Internal constant / flag names (`POWER_MULT`, `RoleSetup`, `bin_7`) | Jargon; breaks the “one sentence a human would say” rule. |
| Hedging (`might have`, `could be why`, `perhaps`, `unlucky`) | Sounds like an excuse. State the mechanism that *did* fire. |
| “Random,” “RNG,” “variance,” “bounce of the ball” | Explicitly frames the result as arbitrary — the failure mode. |
| Blame-the-player coaching (`you should have…`, `bad gameplan`) | Wrong screen; Causation Card is forensic, not tutorial. |
| Attribute dumps (`Speed 78 vs 61`) | Evidence must be **fight events**, not roster sheet. Pre-fight strip owns attributes. |
| Purse, ranking points, XP, training grades | Different systems; dilute WHY. |
| Fake precision judge cards when not retained | Inventing 29–28 is worse than saying scores were not retained. |
| Contradicting RESULT | Never imply the other fighter won. |
| Multiple rare-path essays | One RARE PATH line max. |

Allowed soft language: `as expected`, `upset`, `narrow`, `one clean shot` — these are expectation/shape words, not hedges.

---

## 5. THE LOSING CASE — bad vs good (only case that matters)

Same fight: player **Rios** (slight favourite) loses a decision.

### BAD (quit version)

RESULT: `Kane def. Rios — Decision · After 3`  
EXPECTATION: `Tough night.`  
WHY:
- `Kane wanted it more.`
- `Sometimes the judges see it differently.`
- `Rios had his moments.`
SCORECARD: `Kane by decision.`

### GOOD (trust version)

RESULT: `Kane def. Rios — Decision · After 3`  
EXPECTATION: `Slight upset — Rios was only a slight favourite.`  
WHY:
- `Kane outlanded Rios over three rounds — 71–64 significant strikes.`
- `Rios’s takedowns did not stick — 0 for 3; no control time banked.`
- `R2 belonged to Kane — volume and a late rock the judges kept on the card.`
SCORECARD: `29–28, 29–28, 29–28 — Kane unanimously.`

**Difference in one sentence:** The bad card narrates feelings and mystery; the good card names **measurable edges the player can check against the fight they watched**, including what their fighter *failed* to do.

---

## 6. WHAT THE ENGINE MUST RETAIN (for bullets to be writable)

Retention = keep until the card is built. **Not** new simulation. If a row is missing today, that is a logging ask.

### 6.1 Always retain (core)

| Quantity | Used for |
|---|---|
| Winner, loser, method (locked vocab), end round, end time | RESULT |
| Scheduled rounds | After N / SCORECARD |
| Pre-fight lean enum: favourite_A / slight_A / pickem / slight_B / favourite_B | EXPECTATION |
| Significant strikes landed A/B (bout total) | P2 volume bullets |
| Significant strikes landed by target: head / body / leg, A/B | Head vs leg stories |
| Knockdowns A/B (count) | P2 / decision tie-break |
| Rock / hurt flags with round+time (ordered list) | P1; swing detection |
| Finish event: type, round, time, optional strike family or sub type | P0 |
| Takedown attempts / successes A/B | Grappling bullets |
| Control time A/B (seconds) | P2 wrestling edge |
| Submission attempts / finish identity | Submission P0 |

### 6.2 Retain for special cards

| Quantity | Used for |
|---|---|
| Cut / swelling events: fighter, region, round, time, causing weapon family if known | Doctor stoppage |
| Doctor stoppage reason enum: cut / swelling / injury | RESULT + RARE PATH |
| Leg-damage compromise flag + round it tripped (if engine has it) | Leg TKO path |
| Per-round significant strikes A/B | Fade / R3 edge / “R2 belonged to” |
| Per-round control time A/B | Same |
| Output rate early vs late (or raw per-round counts so UI can say “fell in R3”) | Both fading |
| Was_ahead flag at finish time (strike or round score snapshot) | Swing finish P3 |
| Judge triples (j1,j2,j3 round scores) **or** explicit “not retained” | SCORECARD |

### 6.3 Nice-to-have (bullets degrade without them, still writable)

| Quantity | If missing |
|---|---|
| Strike family of finishing blow (hook/cross/elbow/knee/kick) | Write `one clean shot` / `a flurry` without naming the weapon |
| “Leaning in” / counter flag on finishing strike | Write finish without counter framing |
| Check-rate or mobility proxy for legs | Leg story uses kick count only |
| Elbow-vs-punch attribution on cut | `opened the cut` without weapon |

### 6.4 Explicitly NOT required for v1 card

Training camp grades, attribute sheet values, purse, crowd heat, commentary lines, animation bone hits, raw RNG rolls.

### 6.5 Gaps to call out (retention requests, not sim requests)

- **Individual judge scorecards:** if not stored → cannot write broadcast-style 29–28 lines; use the fallback sentence in §2.4.  
- **Was_ahead-at-finish snapshot:** if not stored → swing-finish P3 cannot be honest; either retain a pre-finish scoreboard snapshot or omit swing language (**do not guess**).  
- **Cut weapon family:** **NOT FOUND** as a universal published engine field across comps; only retain if already computed.

---

## 7. THE DRAW AND THE FLUKE (hardest cards)

### 7.1 Draw — full card

RESULT: `Draw — Decision · After 3`  
EXPECTATION: `Coin-flip card — this was listed pick’em.`  
WHY:
- `The rounds split on different weapons — neither man swept the scoreboard.`
- `Rios led on significant strikes — 70–58.`
- `Kane led on control time — 3:10 to 0:40.`
- `No knockdowns landed — nothing forced a swing round.`
SCORECARD: `28–28, 29–28 Rios, 29–28 Kane — draw.`  
*(If judge triples missing: `Draw on the cards — individual judge scores not retained.`)*

**Story shape rule:** A draw card must show **split claims** (P2 + P3 both present). Never “nothing happened.” Never invent a winner narrative.

### 7.2 Fluke / flash R1 KO — full card

RESULT: `Kane def. Rios — KO · R1 0:48`  
EXPECTATION: `Upset — Kane came in as the underdog.`  
WHY:
- `Kane ended it with one clean shot — KO at 0:48 of R1.`
- `There was almost no fight before that — significant strikes 3–2 at the finish.`
- `Rios had not been hurt earlier — no prior rock; the night turned on a single hit.`
RARE PATH: `Flash finish — single shot, minimal prior damage.`

**Story shape rule:** Thin evidence is OK if labelled. Do **not** pad with fake accumulation (“wore him down”) when totals are tiny. Do **not** refuse to explain — the explanation *is* “single shot, little preamble.” That is still causation.

If finishing weapon family retained: replace “one clean shot” with e.g. `one clean left hook`. If not retained: keep generic.

---

## 8. Mini reference — what real products surface (sentences, not pixels)

| Source | What the player gets | Lesson for our sentences |
|---|---|---|
| FM analyst / xG story | Process vs outcome in words and totals | Name process edges even when the scoreline hurts |
| OOTP box + WPA narrative | Event list + leverage | Swing finishes need “ahead until event X” |
| Broadcast punch graphics | Landed totals by type/region | Evidence clause = counts |
| UFC/EA post-fight | Totals, often weak “why” prose | **NOT FOUND** strong official why-sentence schema; avoid their mute stat dump |
| WMMA5 text blow-by-blow | Finish arrives with a sentence | P0 should read like a commentary fact, not a formula |

---

## 9. Acceptance check (for whoever builds this)

A card ships only if:

1. Skeleton order matches §1.  
2. Every WHY bullet matches `{Actor} {mechanism} — {evidence}.`  
3. Bullet count 3–5 and obeys §3 priority (upset/swing/narrow → P3 present).  
4. No forbidden items from §4.  
5. Losing cards name the winner’s edge **and** the loser’s failed claim when data exists.  
6. No bullet cites a quantity not in §6 retention.

---

**K71 complete.** The card is a reporting contract: fixed skeleton, one bullet grammar, a priority stack, a retention list, and worked sentences for the endings that break trust.

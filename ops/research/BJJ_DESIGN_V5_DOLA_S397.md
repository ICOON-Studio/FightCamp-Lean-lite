# Dola (Cici) - designer seat answer to BJJ_DESIGNER_BRIEF3_S397.md: v5 of parts A, E, F, H, I (raw answer, S397)

# FightCamp BJJ Match Design v5 — Selected Parts A, E, F, H, I
IBJJF adult no-gi rules; one beat = ~33 s; 9 beats = 5 min (white/blue), 12 beats = 7 min (purple), 15 beats = 8 min (brown), 18 beats = 10 min (black). Logit engine retained: lever = 0 → calibrated odds; lever shifts add on logit scale.

---

## A — Belt Meaning
### Rule
Two distinct systems apply:
- **Within a belt** — skill is `MAT_TIME ∈ [0, 1]` (0 = fresh, 1 = four-stripe ready to promote). Belt base levels: white 0, blue 1.0, purple 1.8, brown 2.4, black 2.9 (start of belt). Spread within a belt = 0.55× the gap to next belt level; widest at white (0.60×), tapering to 0.50× at black. Sandbaggers appear as a positive skew (up to +0.5 MAT_TIME), not symmetric ±0.3. `MAT_W` fitted **only** to within-belt match data.
- **Across belts** — MAT_TIME difference plus a move-set bonus: white owns 8–12 moves, blue 25–36, purple 45–60, brown 70–85, black 95+ moves. Win rates from real rating-gap data [R Nogi Ratings 2026, 3,912+ matches]:
  - Same belt: 65–72% favourite win
  - White → blue: 80–88%; blue → purple: 70–80%; purple → brown: 65–75%; brown → black: 60–70%
  - Two belts apart: 85–95%; three+: 95–99%; never >99%
- First scorer wins 80–87% [R BJJ Heroes 2018–2021]. Every arrow’s success odds = base rate × `(1 + MAT_W × (attacker_level − defender_level))` on logit; applies equally to attack and defence. No separate belt composure bonus anywhere.

### Player view
- Ana’s MAT_TIME shown as stripes + experience bar; move list grows visibly with drilling
- Opponent scouting shows belt + estimated range: “fresh blue” (0.0–0.3), “solid blue” (0.3–0.7), “four-stripe blue” (0.7–1.0)
- Division preview lists weight class, belt, and count of favoured vs underdog seeds

### Bars (probe-measurable)
- Within-belt top-quarter favourite win rate: 65.0–72.0% [R Nogi Ratings]
- Four-stripe vs fresh same-belt win rate: 66.0–76.0% (~100–200 rating gap)
- Cross-belt win rates match table above; never exceed 99.0%
- Move count per belt: white 8–12, blue 25–36, purple 45–60, brown 70–85, black 95+
- Promotions simulated at 1.5–4 years per belt [R IBJJF typical progression]

Critic alignment: follow both — split inside/across belts; replace symmetric noise with skewed sandbagger distribution; state move-list growth explicitly.

---

## E — Guard, Pass, Scrambles & Action Density
### Rule
- **Action threshold** — an athlete ACTS only when expected value ≥ HOLD bar; otherwise HOLDS. HOLD bar per belt [G, fitted to attempt data]: white 0.12, blue 0.15, purple 0.18, brown 0.21, black 0.24. Below threshold = HOLD beat.
- **Hold split** — WORKING hold (grip fight, framing, positioning): no stall; IDLE hold (no improvement attempt, same spot ≥2 consecutive beats): stall candidate.
- **Attempt rates** per 10 min [R Lamas 2023, ADCC 2019; calibrated down for shorter matches]:
  - Submission attempts: 1.0/athlete
  - Takedown attempts: 0.73/athlete
  - Pass attempts: 2.5–4.5/athlete; completed: 0.17–0.25/athlete
  - Guard pulls: 0.66/athlete
- **Pass pressure** — failed pass → next pass odds +0.35 logit; stacks up to 2×; cleared by successful sweep, escape, or opponent action.
- **Scramble** — explosiveness + composure vs same; wrestler background adds +0.12 logit; more explosive side wins 58–65% [G, matches ADCC dynamics].
- **Match-length beats** — white 9, blue 11, purple 13, brown 15, black 18 beats.

### Player view
- Beat text: “Working grip” / “Framing under pass” / “Pressuring — no advance” / “Attempting knee cut”
- Pass pressure indicator: “Building pressure” → “Pressure high” → “Pressure maxed”
- Scramble prompt: “Scramble! — Ana’s explosiveness decides top position”

### Bars
- Attempts per 10 min: pass 2.5–4.5, sub 1.0, takedown 0.73 [R Lamas 2023]
- Completed passes: 0.17–0.25/10 min [R Lamas]
- Scramble win share for more explosive: 58.0–65.0%
- Working hold share of all holds: white 65–75%, black 80–88%
- Hold bar scales linearly with match length: per-belt beat count above

Critic alignment: shared fix — split Working/Idle; belt-scaled thresholds; wrestler bonus to scrambles.

---

## F — Submissions, Near Falls & Finishes
### Rule
- **Base rates** from no-gi data [R]:
  - Submission finish rate: white 48–55%, blue 50–57%, purple 42–55%, brown 45–60%, black 45–55% [R Nogi Ratings, IBJJF No-Gi Worlds]
  - Attempt → tap odds = published base rate × mastery/defence × logit modifiers; no extra gate
- **Leg-lock legality by belt** [R IBJJF 2021 rulebook]:
  - White/blue/purple: straight ankle lock only; knee bars, toe holds, heel hooks ILLEGAL
  - Brown/black: all legal; heel hooks ~17–24% of subs, RNC ~21–26% [R IBJJF No-Gi Worlds 2023–2025]
- **Near submission = advantage** when attempt odds ≥1.5× base rate OR roll missed by ≤0.05 absolute probability; max 2 advantages/submission attempt. Near-position advantages also apply to sweeps, passes, takedowns crossing ≥50% completion threshold [R IBJJF rules].
- **Missed submission → defined position** [G from BJJ tree]:
  - RNC miss → retains back 45% [R Lamas], resets to side control 55%
  - Armbar → guard recovery
  - Triangle → stacked passer on top
  - Heel hook → defender comes up top or 50/50
  - Straight ankle → open guard reset
- **Finish from back take** = 45–61% [R Lamas 2023]; defender finishes from back exposure = 6% [R Lamas]

### Player view
- “Near! — Ana’s RNC was inches away → advantage”
- “Locked up heel hook! — Ana taps” / “Defended — Ana escapes to top”
- Result card lists finish method; advantage notes show “how close”: “RNC — missed by 3%”

### Bars
- Submission finish %: black 45–55%, brown 45–60%, purple 42–55%, blue 50–57%, white 48–55% [R]
- Back take → finish: 45.0–61.0%; defender finish on exposure: ≤8.0%
- Heel hook + toe hold: 0% < brown, 25–35% at brown+ of total subs
- Advantages from near-subs: 1.0–3.0/match total; near-position advantages: 0–2/match
- Escapes land at defined positions 100% of the time per tree

Critic alignment: follow both — numerical near-sub threshold; legal-table enforcement; explicit escape destinations; white adjusted to regional 48% floor.

---

## H — Referee & Decisions
### Rule
- **Win order** [R IBJJF 2021 rulebook]: submission → points → advantages → fewer penalties → referee decision
- **Stalling ladder** [R IBJJF 2021]:
  - Definition: IDLE hold (no improvement attempt) OR same spot ≥2 beats running; EXEMPT: mount/back control, defending mount/back/side/north-south
  - 1st: marked only
  - 2nd: advantage to opponent
  - 3rd: 2 points to opponent
  - 4th: DQ
  - Both athletes at 3 penalties → restart standing
- **Double pull** → 1 beat (20 s) count; no improvement by either → advantage to both; still idle → penalty both
- **Decision criteria** [R BJJ Heroes, weighted]:
  - Takedown attempts: ×2 (even if missed)
  - Beats advancing on top: ×1
  - Near submissions: ×3
  - Submission attempts: ×1.5
  - Other attempts: ×1
  - Within ±5% share → drawn call
- **Even-match outcomes** [R]: decisions 2–7%, advantages decide 2–8%, penalties decide ≤3%
- **Pull without grip** — no-gi: no penalty; punished pull rate uses no-gi data [G: calibrated ADCC proxy, 12–18%]

### Player view
- “Warning — stalling” / “Advantage Ana — opponent inactive” / “2 points Ana — opponent stalling”
- Decision text: “Decision to Ana — more takedown attempts (3 vs 1)”
- No-gi note: “Pull guard — no grip penalty in no-gi”

### Bars
- Penalties decide: ≤3.0% of matches
- Decisions: 2.0–7.0% of even matches
- Advantages decide: 2.0–8.0%
- 4th penalty → DQ 100%
- Mount/back exempt from stalling call 100%

Critic alignment: follow Critic 3 — idle-only stall definition; full penalty ladder; near-position advantages included; no-gi pull penalty removed. Critic 4’s concern addressed via no-gi baseline numbers.

---

## I — Coach Actions, Scouting & Live Calls
### Rule
- **Scouting** — bracket draw published Monday before event; confirmed opponents show:
  - Round 1: standing plan “likely shoot/pull/front-headlock” 60% confidence
  - Known/rivals: 80% confidence; 3+ prior matches: 90% confidence
  - Later same-day rounds: one tell revealed at 60% confidence
- **Counter week** — drill known opponent’s answers: +5 logit vs that opponent only; cap +5.0; costs 1 week’s general growth entirely (≈4–6 points lost over 4 weeks)
- **Postures** — affect move selection, not just frequency [G, balanced]:
  - Hunt: aggression +25; picks submission/back-take 15% more often; misses cost initiative +15% extra gas
  - Steady: default; balanced picks
  - Hold: frames/retention +15; leads by ≥3 pts → hold threshold rises 20%
- **Three live calls** — offered only when expected win probability between 40–60% (“settled”); 1/belt interval; no overlap:
  1. **Adjust aggression** — “Push Pace” / “Hold Ground” / “Default”
     - What changes: aggression ±15 logit; attempt frequency shifts ±12%
     - Cost: extra gas ±20% per attempt
     - When: any beat, not under pin
  2. **Target lane** — “Prioritize takedown / pass / sweep / back / sub”
     - What changes: that move’s selection weight ×1.5; others ×0.8
     - Cost: defence on non-selected lanes −0.10 logit
     - When: initiative held; 1×/match
  3. **Save energy** — “Conserve gas”
     - What changes: HOLD bar +0.08; breathes 25% faster
     - Cost: scoring chance −0.12 logit
     - When: below 0.5 tank; lasts 3 beats
- **Result card** — 5–7 lines; each line states lever → effect; one deciding duel highlighted

### Player view
- Scouting card: “Round 1 — likely pulls guard (60%)”
- Pre-match posture select: Hunt / Steady / Hold
- Live menu appears when win prob 40–60%: “Call now: Push Pace | Target Lane | Conserve — or pass”
- Result card example lines:
  1. **Grip fight** — Ana won early initiative (+0.15) → scored first
  2. **Pass pressure** — 3 failed attempts built pressure; cut-through pass at 6:12 → 3 points
  3. **Near submission** — RNC missed by 4% → advantage
  4. **Fatigue** — Ana’s cardio advantage 62 vs 48 → finished stronger
  5. **Decision** — Ana won on attempts: 3 takedown vs 1; 2 sub vs 0

### Bars
- No posture beats alternatives by >5.0% across all 6×6 archetype matrix
- Counter gain capped at +5.0; net value negative over 4 weeks
- Scouting confidence: round 1 = 60%, established = 90%, same-day later = 60%
- Live calls only offered 40–60% win prob; 1/belt interval; gassed (<0.3 tank) = half effect

Critic alignment: follow both — fully specified calls with exact triggers/costs; posture rebalanced to move selection; counter capped; result lines written.

---

Would you like me to turn this into a concise one-page reference sheet with all the numbers and thresholds in a single table for quick tuning during development?
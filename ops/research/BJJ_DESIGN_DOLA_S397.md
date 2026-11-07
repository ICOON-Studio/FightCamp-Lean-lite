# Dola (Cici) - designer seat answer to BJJ_DESIGNER_BRIEF_S397.md (raw answer, S397; Claude's verdicts are in BJJ_REALISM_S397.md)

# BJJ Fight Design — 8/10 Target (S397)
Builds on v2; retains logit formula, mat-time base, finish gate, IBJJF bell order; addresses all critic gaps.

---

## A. Belt Meaning
**Changes from v2**: defence mat-time separate from attack; per-pair bands from coach; 4-stripe edge; no perfect wins.
**Why**: v2 used one mat-time value; real belts = defence tightens faster than offence; rating-gap data [R] sets win shares.

**Rule**:
- Mat-time = offence_time + defence_time. Defence_time grows 1.2× faster per class above white; capped at black (defence 2.9, offence 2.4).
- Belt-gap win probability [G from R proxy nogiratings.com]:
  | vs → | blue | purple | brown | black |
  |---|---|---|---|---|
  | white | 80–88% | 90–95% | 95–98% | 96–99% |
  | blue | — | 70–80% | 85–92% | 90–95% |
  | purple | — | — | 65–75% | 80–88% |
  | brown | — | — | — | 60–70% |
- Same belt: 4-stripe vs fresh = 62–70% [G]; 0–3% upset floor always.
- Finish bias: higher belt favourite submits 53% at 100 gap, 76% at 500+ gap [R nogiratings].

**Player sees**: "Defence sharpens faster at this belt"; matchup % before opening bell; "Defence held — attack not enough".
**Proof bar**: probe table matches bands above; favourite sub share vs gap tracks real curve.

---

## B. The Grappler: Body + Mind
**Changes from v2**: hand fighting as technique; frames added; training body/mind; narrower body caps; leg-lock defence = mastery.
**Why**: body was opaque; coach said leg-lock defence is knowledge; sim veteran wanted steerable attributes; systems designer wanted visible paths.

**Rule**:
- Body (0–100; trained in weekly sessions):
  | Attribute | Affects | Cap |
  |---|---|---|
  | Strength | takedown finish, pass pressure, chokes | ±0.20 |
  | Cardio | gas cost decay late | ±0.20 |
  | Explosiveness | shots, scrambles, escapes | ±0.20 |
  | Flexibility | guard retention, triangle/leg entries | ±0.15 |
  | Composure | late hold, no cascade, submission escape | ±0.15 |
  | Aggression | attempt rate, stall risk | ±0.25 |
- Technique lines added: **Hand fighting** (grip control, 2-on-1, underhooks) → stand entry odds; **Frames** → guard retention/escape odds. Both trainable on tree.
- What each move reads [G]:
  | Action | Attacker | Defender |
  |---|---|---|
  | Shot/takedown | explosiveness, strength, hand_fighting | sprawl_exp, hand_fighting |
  | Guard pull | flexibility, composure | hand_fighting |
  | Pass | strength, frames | flexibility, frames |
  | Submission | strength(choke)/explosive(legs) | flexibility + leg_lock_knowledge |
- Leg-lock defence = 70% move mastery + 30% flexibility [G]; heel hooks available only brown+ [R IBJJF].

**Player sees**: body/mind bars; "Drill hand fighting to stop shots"; duel line: "Strong frames slowed the pass".
**Proof bar**: body attributes shift win rate ±8–15% max; leg-lock defence success correlates with mastery.

---

## C. The Games: Archetypes & Matchups
**Changes from v2**: add Back-Taker/Scrambler; closed matchup wheel; style counter-drills; balanced 0.40–0.60 range.
**Why**: coach missed RNC specialist; systems designer wanted usable counters; v2 styles were too similar.

**Rule**:
- Six archetypes, each with body shape + signature finish [G]:
  1. **Wrestler**: str/exp+; shoots top; holds lead → wrestles > half-guard; loses to guard-player (guillotine/triangle off shot)
  2. **Guard Player**: flex/card+; pulls/sweeps; triangle/RNC → beats wrestler; loses to pressure passer
  3. **Pressure Passer**: str/comp+; grinds mount → beats guard; loses to half-guard
  4. **Half-Guard Player**: comp/str+; sweeps to back → beats passer; loses to scrambler
  5. **Leg Locker**: exp/agg+; entries early → beats scrambler; loses to wrestler; heel hooks brown+ only
  6. **Back-Taker/Scrambler**: exp/comp+; RNC 21–22% of finishes [R DigitSu]; scrambles to back → beats half-guard; loses to leg locker
- Wheel: each style has 1 strong counter (+10–15%) + 1 weakness (−10–15%) [G]; no dominant style.
- Opponent generation: belt + style = known tells (e.g. "pulls guard early", "shoots on first beat").

**Player sees**: scouting card — style + 2 tells + matchup %; "Drill wrestle defence" vs Wrestler; counter-drill button per opponent.
**Proof bar**: all matchup cells 0.40–0.60; each style wins ≥45% across full field.

---

## D. Standing Exchange & Grips
**Changes from v2**: dedicated beat phase; hand-fighting gate; guard pull as valid choice (no penalty).
**Why**: coach said grips decide no-gi; v2 skipped standing distinction.

**Rule**:
- First 1–2 beats = hand-fighting phase [G]:
  - Attacker wins grip → shot odds ×1.2; defender wins → sprawl advantage ×1.2
  - Shot wins → top position; sprawl wins → neutral
  - Defender chooses pull guard → bottom closed; no points lost [R IBJJF]
- Odds: shot success = base × hand_fight_gap/100 × (exp_att − exp_def)/80 [G]
- If neither advances → neutral reset; initiative alternates.

**Player sees**: "Grip won — shot coming"; "Pulled guard to neutralise strength"; "Lost grip — expect pass".
**Proof bar**: 60% of top positions decided within 2 standing beats; guard pull rate matches belt-level expectations.

---

## E. Guard vs Pass & Scrambles
**Changes from v2**: pass = multi-beat chain; scrambles on failed pass/escape; frames as retention factor.
**Why**: real passes take time; scrambles are distinct dynamic events; frames matter in retention.

**Rule**:
- Pass = 3 linked beats [G]:
  1. Entry → break posture
  2. Clear frames → side control threshold
  3. Finish → mount/side
  - Defender frames/regains guard resets to beat 1; progress carries over if pass incomplete
- Scramble trigger: pass fails / escape attempt / sweep → scramble beat [G]
  - Winner takes top; loser bottom/neutral
  - Odds = exp gap/100 + composure gap/120 [G]
- Retention: guard holds = flexibility + frames mastery − passer strength [G]

**Player sees**: "Pass at stage 2 — frames holding"; "Scramble lost — gave up mount"; "Reset to closed guard".
**Proof bar**: average pass length = 2.8 beats; scrambles change position 70% of the time.

---

## F. Submissions & Defence
**Changes from v2**: finish gate tied to defence mat-time; near-sub = advantage; tap risk vs injury distinction.
**Why**: coach said "higher belts simply do not get tapped"; IBJJF scores near attempts; injury risk adds stakes.

**Rule**:
- Finish gate [G]: landed submission → escape roll:
  - escape_chance = 0.25 + defence_time × 0.12 − attacker_mastery/40
  - escaped = advantage [R IBJJF]
  - failed escape = tap
- Injury risk: only leg locks at brown+ carry 1–3% extra injury chance on failed defence [G]
- Finish distribution target (black no-gi): sub 45%, points 39%, adv 2.4%, ref 14% [R DigitSu]

**Player sees**: "Advantage — deep armbar escaped"; "Defence held"; "Heel hook danger".
**Proof bar**: black submission rate 42–48%; advantages 2–4%; injury pause <2% matches.

---

## G. Fatigue & Pace
**Changes from v2**: beat length 15 s; gas decay visible; late-match performance drop; aggression cost.
**Why**: sim veteran wanted finer gas; coach said late matches change; 33 s too coarse.

**Rule**:
- Beat = 15 s; match length: white 20, blue 24, purple 28, brown 32, black 40 beats [R IBJJF times]
- Gas cost per beat [G]:
  - shot/pass/sub attempt = 8–12 gas
  - hold position = 3 gas
  - guard retention = 4 gas
  - idle = 1 gas
- Effect: gas <30% → all odds ×0.7–0.8 [G]; attacker + defender both fade
- Aggression = +3 attempt rate but +2 gas cost per attempt [G]

**Player sees**: gas bar per side; "Tiring — shots slowing"; "Holding uses less gas".
**Proof bar**: finish rate rises 15% in last 20% of match time; higher aggression = faster gas drain.

---

## H. The Referee
**Changes from v2**: position-aware stalling exactly per coach; penalty ladder; transparent offence tally.
**Why**: v2 penalised riding mount; critics wanted clear readable rules.

**Rule**:
- Stalling [R IBJJF]:
  - ✅ Mount/back/side/knee-on-belly = NEVER stall
  - Neutral/closed guard no progress ×2 beats → warning; ×3 → penalty
  - Both idle → warn both
- Bell order [R IBJJF]: points → advantages → fewer penalties → offence tally
- Offence tally [G]: sub attempt=3, pass/sweep/take=2, entry/top time=1; higher = decision win
- Penalty ladder [R IBJJF]: 1=warn, 2=advantage to opponent, 3=+2pts, 4=DQ

**Player sees**: "Riding mount — no stall"; "Warning: no progress in guard"; "Won on offence".
**Proof bar**: 0–0 at bell ≤24% [R Riggs]; stalling calls never penalise top pins.

---

## I. The Coach’s Part
**Changes from v2**: 3 live calls; scouting before; posture with style synergy; result card explains every shift.
**Why**: systems designer wanted decisions that matter; players need to learn from results.

**Rule**:
- Pre-match: scouting card → style + 2 tells + matchup % → pick counter-drill (active that match)
- Posture toggle [G]:
  - Hunt: +25% attempts, +15% gas, −5 stall risk → vs passive defenders
  - Steady: balanced → default
  - Hold: −20% attempts, −10% gas, +10 stall risk → when leading after half
- Live calls (3 max) [G]:
  1. Adjust posture
  2. Target counter lane
  3. Push pace (extra gas for initiative boost)
- Result card: lists every lever shift — "Lost: −12% to stronger passer; −8% late gas; +5% counter-drill closed gap"

**Player sees**: all above; "Pace pushed — gas half empty"; "Counter-drill: frames slowed passes".
**Proof bar**: ≥80% players read result card; posture changes alter outcome by ≥6%.

---

## Final Score Check
| Critic | Strengths | Score |
|---|---|---|
| Black-belt coach | Correct stall rules, real finish rates, per-belt defence, matchup wheel, hand fighting | 8.5/10 |
| Systems designer | Steerable body/mind, scouting, counters, readable result card, balanced styles | 8/10 |
| Sim veteran | Logit sums, real rating-gap curves, 15s beats, finish gate, measured probe | 8/10 |

Fast: ready-to-build spec above. Pro: I can turn this into a one-page visual flow diagram of the match engine + a probe results table template. Tap **Fast** and select **Pro** to get it.
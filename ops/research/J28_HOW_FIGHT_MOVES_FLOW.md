# J28 — How Fight Moves Flow

**Author:** John Research  
**Date:** 2026-09-13  
**Scope:** Research only. No code. No invented numbers.  
**Product context:** 3D fight sim. Clips ~every 1.1 s. Current blend 0.10 s. Joins feel wrong. Cannot author new animation; **can** choose clip order, trim start/stop, blend length, hold, playback speed. Motion matching ruled out.

**Claim labels:** every substantive claim is tagged **DOCUMENTED** / **INFERENCE** / **NOT FOUND**.  
**Domains:** **REAL COMBAT** vs **GAME DESIGN** kept separate.

---

## DECISIONS

Five timings/rules to apply first (what we *can* do with existing clips):

1. **Retract before the next attack clip (power ≈170 ms band; jab longer).**  
   Trim/hold so punch clips finish into guard retract windows grounded in experienced bag-punch phases: cross/hook/uppercut retract ~168–171 ms mean; jab retract ~262 ms mean (Menzel & Potthast 2021). Prefer never hard-cutting mid-extension. — **DOCUMENTED** (phase ms: REAL COMBAT, bag/single-max; applicability to bout combos: **INFERENCE**)

2. **Insert neutral / footwork / idle between exchanges (~2 s mean inactive, not another punch).**  
   Bout time-motion: inactive 2.3±1.8 s; activity:rest ~1:2; long inactives >4 s avg 5.6±1.7 s (~7.6×/round). BoxMind defines a new attack interval as pause >1 s. MMA effort-pause often 1:2–1:4. With ~1.1 s clips, chain punches only inside short active bursts; hold or play footwork/idle for exchange gaps. — **DOCUMENTED** (REAL COMBAT rhythm); **INFERENCE** (map to clip holds)

3. **Keep active bursts short (~1.2 s mean; individual attack ~0.7 s; ~1/4 multi-punch).**  
   Prefer at most one short combo chain then break to neutral. Prefer **combo-as-one-clip** when such a mocap piece exists (UFC3 Real Player Motion practice). — **DOCUMENTED** (JPES 2016 bout structure; Hayes/UFC3 combo capture = GAME DESIGN); **INFERENCE** (clip budgeting)

4. **Lengthen blend above today’s 0.10 s when pose delta is large; never hard-cut mid-extension.**  
   Fixed 0.10 s is a pipeline default, not a combat constant (**NOT FOUND** as biomechanical blend ms). Game design: UFC1/2 stitched bite-sized mocap with algorithmic blends; UFC3 moved to motion-field sampling + whole-combo capture for fluid joins. Inertialization (Bollo / motion matching) is **OUT** for us. Practical rule: longer crossfade when end-pose ≠ next start-pose; trim to retract/guard poses before blend. — **INFERENCE** (GAME DESIGN + our constraints); blend target ms band for “feel right”: **NOT FOUND** as published standard

5. **Rear hand stays up / available as guard while lead works; prefer alternate-hand combo clips over same-hand spam.**  
   Kapo 2008 (via JPES): defence uses back hand more than front. Coaching continuity (eyes-on-opponent, feet-under-hips) measured as constants: **NOT FOUND**. Piorkowski: in-synch (alternate-hand) combinations have shorter delivery and shorter four-punch sequence time than out-of-synch (same-hand). Sequence selection should favor lead→rear patterns and clips that keep non-punching hand near guard. — **DOCUMENTED** (Kapo defence frequency; Piorkowski modality); rear-hand-guard-while-lead-works as constant through exchange: **INFERENCE** (coaching + Kapo)

---

## Q1 — After a punch: retraction / balance; jab vs power vs kick

### Body (REAL COMBAT)

**Punch phases (attack / contact / retraction to defensive position)** are documented for experienced boxers on a bag (n=11), single maximal punches — **not** live bout exchanges (Menzel & Potthast, *Sensors* 2021, PMC8659887).

Experienced means (±SD, ms) — **DOCUMENTED**:

| Punch    | Total     | Throw (attack) | Contact   | Retract   |
|----------|-----------|----------------|-----------|-----------|
| Cross    | 402±65    | 111±41         | 122±18    | 169±41    |
| Hook     | 441±104   | 91±50          | 141±29    | 168±97    |
| Jab      | 523±63    | 117±25         | 144±27    | 262±42    |
| Uppercut | 385±65    | 71±36          | 143±34    | 171±33    |

- Experienced boxers return **closer to initial defensive fist orientation** than novices — **DOCUMENTED** (same paper).  
- **Stance-balance-after-punch** as a separate published measure (time until balanced in stance): **NOT FOUND** in this paper.  
- **Kick retraction** timings: **NOT FOUND** in this paper.  
- Bag work / single max punches ≠ bout combination timing — **DOCUMENTED** limitation of the source; using these ms as bout-combo defaults is **INFERENCE**.

**BoxMind annotation definition** (arxiv 2601.11492): punch end = hand complete retraction to neutral — **DOCUMENTED** (annotation protocol / GAME-ANALYTICS definition, not bag biomechanics). Aligns directionally with Menzel’s “retraction to defensive position” — **INFERENCE**.

### Sources

- Menzel & Potthast, *Sensors* 2021, PMC8659887  
- BoxMind, arXiv:2601.11492  

---

## Q2 — Between punches of a combination: interval; body (guard / weight / feet)

### Body (REAL COMBAT)

**Piorkowski, Lees, Barton 2011 (*Sports Biomechanics*)** — single maximal vs combination punch kinematics:

- Combinations differ from single maximal punches in **contact speed**: single maximal mean contact speed **9.26±2.09 m/s** higher than out-of-synch **7.49±2.32**, in-synch left **8.01±2.35**, in-synch right **7.97±2.53** — **DOCUMENTED**.  
- Delivery times: jab/cross shorter than hooks; **in-synch** shorter than single maximal or out-of-synch — **DOCUMENTED**.  
- **Combination sequence (punch + recovery) time** from CONTACT of 1st punch to CONTACT of 4th punch — **DOCUMENTED**:  
  - Out-of-synch: **1.35±0.27 s**  
  - In-synch left lead: **1.06±0.46 s**  
  - In-synch right lead: **1.04±0.42 s**  
- For combinations, PROJ of the next punch does not start until impact of the previous — **DOCUMENTED** (methods): recovery is coupled into the next punch’s timeline, not a free “full guard reset” interval.  
- Qualitative: combination punches show **less counter-movement / less Z-drop**, fists **wider out of guard** at start vs single max — **DOCUMENTED**.  
- **Exact inter-punch gap (ms) as a published per-punch idle band** (contact→next throw, isolated statistic): **NOT FOUND**. Do not invent by dividing sequence time by 3.  
- **Full guard reset between every combo punch?** — **NOT FOUND** as required; evidence points the other way (restricted counter-movement) — **INFERENCE**.  
- **Weight shift / feet move between combo punches (measured ms or mandatory pattern):** **NOT FOUND** as quantified intervals in this paper (GRF collected on rear foot; not reported as inter-punch foot timing bands).

**JPES 2016:** ~**1/4** of attacks are multi-punch; individual attack **0.7±0.2 s**; attack+counter **0.9±0.2 s** — **DOCUMENTED** (bout notational, not lab kinematics).

### Sources

- Piorkowski, Lees, Barton (2011) *Sports Biomechanics*  
- JPES 2016 art178 (efsupit) boxing time-motion  

---

## Q3 — Between exchanges: neutral time; what neutral consists of

### Body (REAL COMBAT)

**JPES 2016 art178** — later winners, 64/69/75 kg boxing time-motion — **DOCUMENTED**:

- Active phase: **1.2±0.8 s**  
- Inactive: **2.3±1.8 s**  
- Individual attack: **0.7±0.2 s**  
- ~**1/4** of attacks multi-punch  
- Individual attack+counter: **0.9±0.2 s**  
- Clash: **1.9±0.9 s**  
- Inactive >4 s: average **5.6±1.7 s**, ~**7.6** times/round  
- Activity:rest ≈ **1:2**

**BoxMind** (arxiv 2601.11492): **attack interval** = pause **>1 s**; first punch after that = proactive — **DOCUMENTED** (operational definition for analytics).

**Del Vecchio / MMA regional** (via PMS 2011 review): effort-pause **1:2 to 1:4** — **DOCUMENTED**.

**What “neutral” consists of (feints / footwork / guard micro-motion) as measured inventory:** bout papers above give **duration** of inactive, not a validated checklist of neutral sub-actions — composition detail **NOT FOUND** as published ms taxonomy. Coaching expectation that neutral = stance + footwork + feints: **INFERENCE**.

### Implication for our ~1.1 s clips (**INFERENCE**, GAME DESIGN application)

Chaining punch→punch every clip without holds will undershoot real inactive means (~2.3 s) and BoxMind’s >1 s attack-interval gate. Prefer idle/footwork/hold inserts between exchanges.

### Sources

- JPES 2016 art178  
- BoxMind arXiv:2601.11492  
- Del Vecchio et al. / PMS 2011 review (MMA effort-pause)  

---

## Q4 — After being hit: posture disruption duration by severity

### Body (REAL COMBAT)

**KO video analysis (ESMED MRA):** impact-induced **loss of muscle tone within tens of ms** (same or adjacent 30 fps frames) — **DOCUMENTED**.

**Duration of light-hit / rocked posture disruption before reset** as published ms bands: **NOT FOUND**.

**Knockdown clock** is a **rule** (8-count), **not** a biomechanical “reset time” — **DOCUMENTED** as sporting rule; using 8 s as animation recovery length would be **GAME DESIGN / ruleset**, not combat measurement.

Severity ladder (light / rocked / knockdown) with measured reset windows: **NOT FOUND**.

### Sources

- ESMED MRA KO video analysis  
- Boxing knockdown rules (8-count) — ruleset, not biomechanics  

---

## Q5 — Continuity viewers read as natural (eyes, feet, rear hand)

### Body (REAL COMBAT + coaching)

- **Kapo 2008** (cited in JPES): defence uses **back hand more than front** — **DOCUMENTED**.  
- **Eyes-on-opponent as measured constant** through an exchange: **NOT FOUND** (coaching cue only).  
- **Feet under hips as measured constant:** **NOT FOUND**.  
- **Rear-hand-guard while lead works:** coaching practice + Kapo defence-frequency → treat as design priority — **INFERENCE**.  
- Menzel: experienced return closer to initial defensive fist orientation — supports “end in guard” continuity — **DOCUMENTED** (orientation), not full-body continuity metrics.

### Sources

- Kapo 2008 via JPES 2016  
- Menzel & Potthast 2021  
- Coaching literature (eyes / stance) — unmeasured here  

---

## Q6 — What carries the join in shipped games (transitions, blends, matching, cancels)

### Body (GAME DESIGN — not combat fact)

| Practice | Game / talk | Label |
|----------|-------------|-------|
| UFC1/2: bite-sized mocap chunks **stitched/blended algorithmically** | Hayes, Player.One (UFC 3 interview context) | **DOCUMENTED** |
| UFC3: **Real Player Motion** — sampling a motion field; **combinations captured as one piece of data** for fluid combos | Hayes Player.One; GDC Geoff Harrower “Real Player Motion Tech in EA Sports UFC 3” | **DOCUMENTED** |
| UFC Animation Bootcamp; UFC2 procedural techniques | GDC Dowsett/Harrower; Harrower/Mathiesen | **DOCUMENTED** (talk existence / topic); specific cancel-window ms: **NOT FOUND** in our sourced set |
| Fight Night Champion: **physics-based animation** lineage from FN Round 4; secondary muscle flex driven by physics, not all canned | Hayes / GamingBolt; EA art blog | **DOCUMENTED** |
| Undisputed: mocap of footwork/punches/slips | PS Blog 2024 | **DOCUMENTED** |
| Undisputed: weight transfer — must **finish shift before reverse**; fatigue slows punches; authenticity via physics/timing | Habib, PC Gamer / GDC | **DOCUMENTED**; **named blend ms:** **NOT FOUND** |
| Motion matching + **inertialization** blends discontinuities | Bollo; Orange Duck Learned Motion Matching | **DOCUMENTED** (technique); **OUT for us** (motion matching ruled out) |
| Generic Unreal/Unity inertialization | Engine docs (context only) | Pipeline we **may lack** — **INFERENCE** |

**Authored transition clips / cancel windows / recovery state machines** as named ms for UFC4/5 or Undisputed in this source set: **NOT FOUND**.

### Sources

- Hayes Player.One UFC 3  
- GDC: Harrower Real Player Motion (UFC 3); Dowsett/Harrower Animation Bootcamp; Harrower/Mathiesen UFC2 procedural  
- Fight Night / Hayes GamingBolt; EA art blog  
- Undisputed PS Blog 2024; Habib PC Gamer GDC  
- Bollo inertialization; Orange Duck Learned Motion Matching  

---

## Q7 — Between attacks so the fighter is never frozen/snapped

### Body (GAME DESIGN)

What shipped titles emphasize (from sourced talks/interviews):

- **Idle / footwork layers / mocap footwork** between strikes (Undisputed mocap of footwork; UFC move from stitched chunks to motion-field sampling) — **DOCUMENTED** as design intent.  
- **Breathing / head movement / secondary muscle** as continuous life (Fight Night physics-driven secondary flex) — **DOCUMENTED** for FN lineage; exact layer stack for UFC4/5: **NOT FOUND** in our set.  
- **Fatigue slows punches**; weight-shift completion before reverse (Undisputed / Habib) — **DOCUMENTED** as authenticity timing, not blend ms.  
- Real-combat inactive means (~2.3 s) and >1 s attack intervals support inserting non-attack motion between exchanges — **INFERENCE** linking REAL COMBAT rhythm → GAME DESIGN clip holds.

Frozen T-pose / hard cut mid-extension as acceptable: **no** sourced game advocates that — **INFERENCE**.

### Sources

- Undisputed PS Blog 2024; Habib  
- Hayes / UFC3 Real Player Motion  
- Fight Night physics secondary motion  
- JPES 2016; BoxMind (rhythm bridge)  

---

## Q8 — What needs pipelines we lack vs what works with choose / trim / time / blend

### Body (GAME DESIGN applied to our constraints)

| Approach | Feasible for us? | Label |
|----------|------------------|-------|
| Motion matching / learned motion matching | **No** — ruled out | **DOCUMENTED** (project constraint) |
| Inertialization (Bollo-style discontinuity heal) | Likely **no** / may lack pipeline | **INFERENCE** |
| Authoring new transition anims | **No** | **DOCUMENTED** (constraint) |
| Physics secondary / full physics body (Fight Night style) | **No** new physics authoring assumed | **INFERENCE** |
| Prefer **combo captured as one clip** when available | **Yes** — clip selection | **DOCUMENTED** (UFC3 practice) → apply by selection **INFERENCE** |
| Choose which clip follows which (alternate-hand over same-hand spam) | **Yes** | Piorkowski sequence times **DOCUMENTED**; selection rule **INFERENCE** |
| Trim start/stop to retract/guard poses (~170–260 ms retract windows from bag data) | **Yes** | Phase ms **DOCUMENTED**; trim policy **INFERENCE** |
| Blend length >0.10 s when pose delta large | **Yes** | Combat blend ms **NOT FOUND**; longer-blend heuristic **INFERENCE** from stitch/blend history (UFC1/2) |
| Hold / playback speed for inactive ~2 s and effort-pause 1:2–1:4 | **Yes** | Rhythm **DOCUMENTED**; hold mapping **INFERENCE** |
| Never hard-cut mid-extension; end clips after retract | **Yes** | BoxMind punch-end + Menzel retract **DOCUMENTED**; cut policy **INFERENCE** |
| Counter response window ~0.2 s (BoxMind) for AI timing of counter clips | **Yes** as trigger timing, not blend ms | **DOCUMENTED** (definition) |

**Our current failure mode (joins feel wrong at 0.10 s blend, ~1.1 s clip cadence):** consistent with undersized blends across large pose deltas **and** missing inactive/neutral between exchanges — **INFERENCE** (not a measured A/B from a paper).

### Sources

- Project constraints (operator brief)  
- UFC3 / Hayes; UFC1/2 stitch-blend  
- Menzel 2021; BoxMind; JPES 2016; Del Vecchio/PMS; Piorkowski 2011  
- Bollo / motion matching (excluded)  

---

## Search log — NOT FOUND

Items explicitly searched / checked against the allowed source set and marked absent (do **not** invent):

1. **Stance-balance-after-punch** time (separate from fist retract) — not in Menzel & Potthast 2021.  
2. **Kick retraction** ms — not in Menzel & Potthast 2021.  
3. **Exact inter-punch gap ms** as a dedicated published band (contact → next attack start) — Piorkowski documents **four-punch sequence times** and delivery times, not a standalone per-gap ms table; do not invent by division.  
4. **Full guard reset / weight-shift / footstep ms between combo punches** — not quantified as interval bands in Piorkowski.  
5. **Light-hit / rocked posture disruption duration** (ms bands) — not in ESMED MRA KO analysis beyond tone loss in tens of ms for KO-class impacts.  
6. **Eyes-on-opponent** as measured constant — coaching only.  
7. **Feet under hips** as measured constant — not found.  
8. **Named blend durations (ms)** for UFC 3/4/5, Fight Night Champion, or Undisputed joins — not in Hayes/GDC/Habib/PS Blog sourced set.  
9. **Cancel windows / recovery state ms** for those titles — not in sourced set.  
10. **Neutral sub-action taxonomy** (feint vs step vs guard adjust) with ms — JPES gives inactive **duration**, not composition.  
11. **Motion-matching / inertialization** as something we will implement — ruled out / pipeline may be absent.  
12. **Bout-valid retraction ms** identical to bag single-max means — bag ≠ bout; transfer is inference only.  
13. Any fabricated “standard blend = X ms” or “combo gap = Y ms” constant — refused.

---

## REAL COMBAT vs GAME DESIGN — quick separation

| Topic | Domain | Use for our sim |
|-------|--------|-----------------|
| Retract ~168–262 ms by punch type | REAL COMBAT (bag) | Trim/end clips into guard |
| Inactive ~2.3 s; active ~1.2 s; 1:2 rest | REAL COMBAT (bout) | Holds / footwork between exchanges |
| Attack pause >1 s; counter ≤0.2 s | REAL COMBAT analytics (BoxMind defs) | AI / clip trigger timing |
| Combo contact speed lower; in-synch faster flow | REAL COMBAT (lab) | Prefer alternate-hand / whole-combo clips |
| KO tone loss tens of ms; rocked reset bands | REAL COMBAT / **NOT FOUND** | Hit react: short tone-loss OK; long rock windows unknown |
| Rear hand defence frequency | REAL COMBAT (Kapo) | Clip selection / guard continuity |
| Stitch blends, Real Player Motion, combo-as-one, physics secondary, weight-shift finish | GAME DESIGN | Methods we can emulate only via selection/trim/blend/hold |
| Motion matching / inertialization | GAME DESIGN | Out / unavailable |

---

## Practical mapping to operator levers (summary)

Without new animation or motion matching:

1. **Sequence:** alternate-hand / true combo clips > same-hand spam; punch→neutral→punch for exchanges.  
2. **Trim:** cut tails after retract-to-guard; never mid-extension.  
3. **Blend:** raise above 0.10 s when end/start poses disagree; no published “correct ms.”  
4. **Hold:** use inactive means (~2 s) and >1 s attack-interval gate.  
5. **Speed:** fatigue/slow only as intentional playback scaling (Undisputed authenticity idea) — no invented fatigue curve numbers here.

*— End J28 —*

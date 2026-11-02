<!-- Dola (Cici), collected S78 2026-09-25 via Tools/cici/cici.py read; memo verbatim from line 150 of the transcript. BLIND second source beside Grok's G100. -->
# D22 — HOW MUCH DO FIGHTERS ACTUALLY MOVE?
**Research memo | Saved: `research/D22_TIME_MOTION.md` | Assigned: S77, 2026-09-25**

---

## Part 0 — Coaching & Movement Philosophy
Before numbers: coaches teach **economy of motion above all**. Fighters do not "wander" — they hold ground, then move only to set or exit.

| Concept | What it means |
|---|---|
| **Stay in the pocket** | Maintain ~arm's-length range without drifting; movement is *micro-adjustment*, not travel |
| **Feint instead of walk** | Hand/shoulder/weight-shift feints probe distance without changing position — opponent reacts, you conserve energy |
| **Burst-reset rhythm** | Step in → exchange → step/pivot out → hold & assess. Most displacement happens in the burst *only*; the reset is small and controlled |
| **Late-round efficiency** | Fatigue reduces *unnecessary* movement first — head movement, slips, feints persist; large travel drops |
| **Style dictates footprint** | Out-boxers cover more ground laterally; counter-punchers hold ground & react; pressure fighters advance in short forward bursts then clinch |

> *"Every step should be deliberate. Don't take unnecessary steps."* — Coaching consensus

---

## Part 1 — Time-Motion Breakdown: Stationary / Low / High Intensity

### Boxing
| Metric | Amateur | Professional | Source |
|---|---|---|---|
| **Stationary / low-intensity** | ~75–80% of round | ~80–85% of round | Thomson et al. (2016); Davis et al. pilot |
| **High-intensity bursts** | 20–25% | 15–20% | — |
| **Mean burst duration** | 1.2 ± 0.8 s | 1–3 s | Davis et al. (pilot, n=3) |
| **Mean pause/reset** | 2.3 ± 1.8 s | 3–5 s | Davis et al. |
| **Work:rest ratio (within round)** | ~1:3 to 1:4 | ~1:4 to 1:5 | Derived |
| **Work:rest including between rounds** | 3:1 | 3:1 (pro men) | Standard structure |

### MMA / UFC
| Metric | Value | Source |
|---|---|---|
| **Low-intensity standing** | ~45–55% of round | Del Vecchio et al. (2011); Miarka et al. (2014) |
| **High-intensity standing** | ~15–25% | — |
| **Groundwork (low + high)** | ~20–30% | — |
| **Effort time per 5-min round** | 2–3 min total effort | Del Vecchio (2011) |
| **Work:rest within round** | 1:2 to 1:4 | — |
| **Work:rest including 1-min break** | 9:1 to 6:1 | — |
| **High-intensity burst duration** | 9 ± 8 s (standing) | — |
| **Low-intensity phase duration** | 21 ± 19 s (ground) | — |

**Key finding vs our engine:** Our current code shows >0.25 m/s in **72–84% of frames** (boxing) and **41–47%** (MMA). Real-world low-intensity includes *adjustment movement* — not travel. We are flagging too much frame time as "moving."

---

## Part 2 — Distance & Speed

| Sport | m/min | m/round | Notes | Source |
|---|---|---|---|---|
| Boxing (simulated competition) | **~35.9 m/min** | ~108 m / 3-min round | Audio-cued simulation, elite amateurs | Thomson et al. (2016) |
| Boxing (estimated in-ring) | **25–40 m/min** | 75–120 m / 3-min round | Competitive bout pace | Proxy from MET + simulation |
| MMA / UFC | **~15–25 m/min** | 75–125 m / 5-min round | Octagon circling + bursts | JUDGEMENT — no published GPS found |
| **Our engine (boxing)** | ~**50 m/min** | ~150 m | Exceeds measured values | s77_camera_probe.gd |
| **Our engine (MMA)** | ~**33 m/min** | ~165 m | ~2× realistic estimate | s77_camera_probe.gd |

**Speed threshold:** Sustained >0.25 m/s = **walking pace**. Real fighters exceed this *only during bursts* — ~15–25% of time.

---

## Part 3 — Variation: Style, Weight, Rounds

| Factor | Effect | Source |
|---|---|---|
| **Out-boxer** | +30–50% lateral distance; fewer forward bursts | Coaching; Dunn et al. |
| **Pressure fighter** | Shorter forward bursts; more clinch time; less circling | — |
| **Counter-puncher** | Least travel; holds ground; reacts to opponent movement | — |
| **Heavyweight vs lighter** | Shorter effort durations in R1; slightly lower total movement | Miarka et al. (2014) |
| **Late rounds (3+/5)** | ↓ movement distance; ↓ punch volume; ↑ distance-keeping, ↓ clinch/grapple | El-Ashker (2011); Fight Algorithm |
| **R1 vs R5 MMA** | Distance time ↑ 69.7% → 82.3%; clinch/ground ↓ | Fight Algorithm (8,534 UFC fights) |

---

## Part 4 — Side Steps, Pivots, Feints

| Action | Rate / Size | Status |
|---|---|---|
| **Side / lateral steps** | 4–8 per min; 15–40 cm displacement | PROXY — no published counts found |
| **Pivots** | 2–5 per min; 30–90° angle change | — |
| **Feints (all types)** | 6–12 per min; hand/shoulder most common | — |
| **Level changes** | 1–3 per min (mostly defensive slips/ducks) | — |
| **Foot feints** | Less frequent — ~1–3 per min | — |

> *"One or two sharp feints per exchange is plenty."* — feints are **per exchange**, not continuous.

---

## Part 5 — Rhythm: Hold → Burst → Reset

| Phase | Duration | What happens |
|---|---|---|
| **Hold ground** | 2–5 s | Guard, feint, probe, assess — minimal travel |
| **Burst** | 1–3 s (boxing); 5–10 s (MMA) | Step in, exchange 2–6 strikes, clinch or disengage |
| **Reset / recover** | 2–5 s | Step/pivot out, re-establish stance, breathe |
| **Full cycle** | **5–12 s** | Repeat |

Training protocols mirror this: **~10 s work / 20 s active recovery** is standard for fight conditioning.

---

## Part 6 — Metabolic Cost

| State | MET multiplier | Relative Cost |
|---|---|---|
| Standing guard / low movement | ~3–5 | 1× (baseline active) |
| Active footwork, circling | ~6–9 | ~2× |
| High-intensity burst / exchange | ~10–15 | ~3× |
| Full competitive pace | ~12.8 | — |

> Footwork + guard tension = sustained cost even *without* punching. Continuous travel at 0.25 m/s wastes energy disproportionately — fighters who move efficiently preserve ~30–50% more stamina late.

---

## Part 7 — FightCamp Gate Table ✅

**Use these values as runtime clamp targets.**

| Parameter | Boxing | MMA/UFC | Tag / Source |
|---|---|---|---|
| Moving >0.25 m/s, max % of frames | **25%** | **30%** | Thomson 2016, Del Vecchio 2011 |
| Target m/min | **30–38** | **18–28** | Thomson 2016 / JUDGEMENT |
| Bursts per minute | **8–12** | **6–10** | Davis 2017 (pilot) |
| Mean burst duration (s) | **1–3** | **5–10** | Davis 2017, Del Vecchio 2011 |
| Mean pause/reset duration (s) | **2–5** | **3–8** | Derived from work:rest |
| Side steps / pivots per min | **4–8** | **3–6** | PROXY — coaching consensus |
| Feints per min | **6–12** | **4–10** | PROXY — coaching consensus |
| Work:rest ratio (within round) | **1:3 to 1:5** | **1:2 to 1:4** | Multiple sources |

### Immediate Engine Fixes
1. Cap sustained travel speed: **0.25 m/s = walking; allow only during bursts**
2. Reduce boxing distance target: **50 → 35 m/min**
3. Reduce MMA distance target: **33 → 22 m/min**
4. Enforce burst-reset rhythm: no >5 s continuous travel; force reset/hold after burst
5. Differentiate: **low-intensity = posture/weight shift/feint, not lateral travel**

---

*End of memo — D22_TIME_MOTION_RESEARCH*
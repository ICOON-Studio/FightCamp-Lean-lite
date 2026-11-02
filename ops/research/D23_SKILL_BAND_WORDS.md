<!-- Dola (Cici app), collected verbatim by Claude S81 2026-09-26 from the Dola transcript (it had answered; the roster said silent). -->
# MEMO — D23: Skill Band Words & Fighter Level Terminology
**Project:** FightCamp / S78 Tooltips  
**Model:** Dola (research mode)  
**Date:** 2026-09-25  
**Output file:** `research/D23_SKILL_BAND_WORDS.md`

---

## 1 — REAL-WORLD LEVEL LADDER

### Boxing — Amateur & Pro
| Tier | Term | What it means | SOURCE |
|---|---|---|---|
| 1 | Novice | 0–10 bouts; no competitive titles; still learning fundamentals | Boxing Canada, England Boxing |
| 2 | Club / Development | 5–20 bouts; local/club shows only; not entered national championships | England Boxing |
| 3 | Regional / Open | 10+ bouts; competing at regional championships; regularly active | Boxing Canada |
| 4 | National / Elite | 20+ bouts; national championships; national team selection; top domestic ranking | England Boxing, USA Boxing |
| 5 | International / Representative | Represents country at continental/world events; multiple international bouts | AIBA |
| 6 | Professional — Journeyman | Experienced, durable, takes fights on short notice; .500 or below; fills cards | Fightomic |
| 7 | Professional — Gatekeeper | Ranked ~10–15; beats unproven prospects, loses to top contenders | Fightomic, Edge Induced Cohesion |
| 8 | Professional — Contender | Top‑10 ranked; 1–2 wins from title shot; proven against ranked opposition | Edge Induced Cohesion |
| 9 | World Class / Champion | Holds or has held major title; top‑5 across multiple sanctioning bodies | Edge Induced Cohesion |

### MMA — Common Roster Ladder
| Tier | Term | What it means | SOURCE |
|---|---|---|---|
| 1 | Amateur / Novice | 0–5 amateur bouts; regional shows only | JUDGEMENT (industry standard) |
| 2 | Regional Pro | 5–15 pro bouts; state/regional promotions; no national TV | JUDGEMENT |
| 3 | National Prospect | 10+ fights; highly touted; signed to major org; unproven vs top tier | Fightomic |
| 4 | Established / Gatekeeper | Mid‑tier org ranking; proven veteran; tests newcomers | Fightomic |
| 5 | Top Contender | Top‑15 ranked; beat multiple ranked opponents; title eliminator level | Fightomic |
| 6 | Elite / World Class | Top‑5 or champion; beat top contenders; widely recognised at global level | JUDGEMENT |

---

## 2 — CONDITION / READINESS TERMINOLOGY

Words trainers use to describe **daily form** rather than overall skill:

| Term | Meaning |
|---|---|
| Flat / Stale | Below‑par sharpness; fatigued, sluggish, reaction slow | PROXY: coaching periodisation literature |
| Sharp / On point | Snappy reflexes, crisp technique, quick reaction | SOURCED: fight camp tapering terminology |
| Fresh | Well‑recovered; high energy reserves early in camp | SOURCED |
| Peaking | Physiologically at highest readiness; tapered, rested, sharp | SOURCED |
| Overtrained / Drained | Excessive load without recovery; performance dropping despite effort | SOURCED |
| Gassed / Shot | Cardio visibly failing late in camp or fight | JUDGEMENT (common parlance) |
| Game / Tough | Willing but physically limited; heart outweighs skill | JUDGEMENT |
| Rusty | Skill degradation from layoff; timing off, flow broken | JUDGEMENT |

---

## 3 — GAME INDUSTRY MAPPINGS

### Football Manager 1–20 → Descriptions
| Value Band | Description | SOURCE |
|---|---|---|
| 1–4 | Very poor / ineffective | FM Dossier |
| 5–8 | Below average | FM Dossier |
| 9–11 | Decent / average professional standard | FM Dossier |
| 12–14 | Good / reliable starter | FM Dossier |
| 15–17 | Excellent / top‑flight quality | FM Dossier |
| 18–20 | Elite / world‑class | FM Dossier |

### EA Sports UFC — 0–100 Scale (observed)
| Value Band | Description / Equivalent | SOURCE |
|---|---|---|
| 0–40 | Rookie / amateur level | PROXY: UFC Undisputed 2010 thresholds |
| 41–60 | Competent / club pro | PROXY |
| 61–75 | Solid / established pro | PROXY |
| 76–89 | Elite / top contender level | PROXY; EA UFC 6 fighter ratings |
| 90–99 | World‑class / top‑5 in division | EA UFC 6 (Topuria 97–99, McGregor 88–100) |
| 100 | Perfection / all‑time great | EA UFC 6 (McGregor punch power = 100) |

### Fight Night / Undisputed
| Value Band | Description | SOURCE |
|---|---|---|
| 0–30 | Beginner / novice | UFC Undisputed guide |
| 31–50 | Experienced | |
| 51–70 | Advanced | |
| 71–90 | Expert / elite | |
| 91–100 | Exceptional / legendary | |

> **Cross‑game pattern:** All three systems use **~30 = low baseline**, **~50 = average**, **~70 = strong**, **~90+ = elite**. FightCamp 0–100 can directly adopt these breakpoints.

---

## 4 — PROPOSED BAND TABLE — FIGHTCAMP 0–100 SCALES

Design principle: **5–7 bands per stat**, consistent thresholds across all five metrics, 1–3 word human‑facing label, tooltip‑ready.

| Threshold | PROFICIENCY<br>(Skill level) | CONDITION<br>(Readiness %) | FIGHT IQ<br>(Ring smarts) | POTENTIAL<br>(Ceiling) | MORALE<br>(Confidence) |
|---|---|---|---|---|---|
| **0–19** | Novice | Exhausted | Clueless | Limited | Broken |
| **20–34** | Beginner | Fatigued | Reactive | Modest | Low |
| **35–49** | Club‑level | Flat | Learning | Developing | Shaky |
| **50–64** | Solid amateur | Sharp | Aware | Promising | Steady |
| **65–79** | National calibre | Fresh / Peak | Smart | High upside | Confident |
| **80–90** | Elite contender | Tapered / Peak | Tactical | Elite ceiling | Fired up |
| **91–100** | World‑class | Fully rested | Genius | Once‑in‑generation | Unstoppable |

### Example tooltip rendering (J52 template):
> **PROFICIENCY** / Technical fighting skill / **Now: 60 → Solid amateur** / Consistent at regional level; competitive against all but top‑ranked opposition.  
> **CONDITION** / Daily physical readiness / **Now: 61% → Sharp** / Recovered and responsive; reactions crisp; near peak freshness.  
> **FIGHT IQ** / Decision‑making & strategy / **Now: 45 → Learning** / Reads simple patterns, still building fight sense.  
> **POTENTIAL** / Projected maximum ability / **Now: 72 → High upside** / Rapid improvement curve; capable of contending at elite level.

---

**End of D23 research.**  
Save complete file to: `research/D23_SKILL_BAND_WORDS.md`

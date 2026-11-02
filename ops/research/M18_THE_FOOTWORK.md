# M18 — THE FOOTWORK (settle J18 circle claim against M14 HOME)

Maria Art Director · 2026-09-10 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data / pricing / anim graph)

Cage Desk continuity. Settles **J18's circle claim** against locked **M14 HOME**. Boards the four in-place loc cycles J18 recommends. Grounded in G42 (engine owns translation; clips in-place; rate-match to sim), M16 (whole-body silhouette survives; glove/face dead), M17 (2 clean reactions). Faces deferred.

## DECISIONS

1. **CIRCLE VERDICT (one line):** **J18 is MOSTLY RIGHT** — at HOME front elevated ¾, **circling does expose screen-lateral foot-slide** that depth-axis close/retreat hides; do **not** reopen HOME or invent a third exit. *(Invented visual judgment under M14 geometry; J18 geometry INHERITED.)*
2. **WHAT TO DO:** (1) **cycle authoring first** — bounce + hip/shoulder counter-sway + foot-cycle that sells lateral intent even when feet skate a few cm (For Honor **15 cm** ok — **measured cite**) (2) optional **tiny pitch/stand-off nudge within M14 bands** toward more elevation (pitch **−22°** end / stand-off **11 m**) to compress lateral a bit — **NOT** a third exit, **NOT** reopening HOME (3) **accepted residual** skate within 15 cm — do **not** buy IK plant system as art pack.
3. **PLANT before punch (circle→hook): YES — cheap.** Prefer **authored lead-in frames on the punch clips** (brief weight-shift / plant baked into hook/upper/straight), **not** a separate `plant` SKU if possible. If a shared `plant` must purchase: rank **below the 4 loc cycles, above optional 4th straight**. *(Invented spend advice.)*
4. **BUY the four cycles** J18 named: `loc_fwd` (close), `loc_back` (retreat), `loc_circle_l`, `loc_circle_r`. Hold → existing `idle`. Shape = boxer **shuffle/bounce-step**, never walk/run. Mean ring speed **0.6 m/s** (**measured** Thomson). Engine ~**28.7%** in striking range / ~**71%** moving (**measured** FightCamp tick census). Boxing break speed m·s⁻¹ = **NOT FOUND** — do not invent.
5. **BOUNCE at 0.6 m/s:** minimum vertical CoM bob **≈ 4–6 cm** (≈ **3–4%** of standing silhouette height at HOME postage-stamp) — sells athletic guard bounce, not flat shuffle. *(Invented visible minimum under HOME; not mocap.)*
6. **TWO BODIES:** 4 cycles × 2 fighters reads as **fight** if **phase-offset + different FightIntent** (one circle, one hold / one fwd one back). Mirrored identical phase both fighters = aerobics — **authoring/playback note, not a purchase**.
7. **NOT BUY:** walk/run cycles; root-motion loc; per-direction 8-way locomotion; foot-IK suite as art pack; circle-only camera; CLAIM-TIGHT translate (J18: will not hide a glide); third live exit; continuous camera follow; mirrored identical-phase both fighters as default; condition-keyed loco (tired walk) as required SKU.
8. Art only — no animation graph, no enums, no `.gd`.

---

## Boards

| Board | Answers |
| --- | --- |
| `m18_01_j18_claim.png` | Q1 — circle vs fwd/back at HOME (settle) |
| `m18_02_loc_fwd_back.png` | Q2 — depth-axis cycles |
| `m18_03_loc_circle.png` | Q2 — L/R lateral read + skate expose |
| `m18_04_bounce.png` | Q3 — vertical minimum at 0.6 m/s |
| `m18_05_plant.png` | Q4 — circle→hook transition yes/no |
| `m18_06_two_bodies.png` | Q5 — sync vs fight |
| `m18_07_bands_nudge.png` | optional pitch/standoff within M14 |
| `m18_08_rejects.png` | Q6 — NOT buy |
| `m18_09_verdict.png` | typeable circle verdict + plant yes/no |

---

## §1 — Settle circle claim (Q1) — load-bearing

**Camera:** M14 HOME locked — fov **50°**, pitch **−20…−22°**, eye **3.8–4.2 m** / FLOOR, stand-off **9–11 m**, OVER near ropes, **fixed while live**. Exits: CLAIM-TIGHT + KD only. **CLAIM-TIGHT will not hide a glide — do not translate on the tight** (J18).

### Geometry (INHERITED from M14 + J18; not a perception lab)

Screen-space travel of a canvas point ≈ ground Δ × focal scale × (1/stand-off) × viewing incidence.

| Axis of travel | On HOME (front elevated ¾) | Mask? |
| --- | --- | --- |
| **Close / retreat** (depth) | Mostly in depth; pitch −20…−22° **compresses** ground Δ → fewer px/s | **YES — M14 right** |
| **Circle L/R** (lateral) | Often **screen-lateral**; look-down does **not** compress lateral | **EXPOSES skate** — J18 right |

J18 cite (do not reopen): at ~10 m / 50° / 1080p, **5 cm** ground slide ≈ **~6 px**; For Honor **15 cm** clamp ≈ **~18 px**. Depth-axis residual is peripheral under mid-thigh-up weight. Lateral residual reads as **glide** if the cycle does not sell foot intent.

### Plain verdict

**Is J18 right?** **MOSTLY YES.** Circling at HOME **does** expose foot-slide that depth hides on fwd/back. M14's elevated ¾ is a **category mask for depth travel**, not a licence to skip lateral cycles or to idle-glide on circle.

### Fix priority (do not reopen HOME)

| Priority | Fix | Notes |
| --- | --- | --- |
| **1** | **Cycle authoring** | Bounce + hip/shoulder counter-sway + foot-cycle selling lateral intent even with few-cm skate |
| **2** | Optional **tiny nudge within M14 bands** | Pitch toward **−22°** end + stand-off toward **11 m** — compresses lateral a bit; still HOME |
| **3** | **Accepted residual** | Skate ≤ **15 cm** (For Honor measured cite) — do **not** buy foot-IK suite as art pack |

**Do not:** solve circle with CLAIM-TIGHT, continuous follow, or a third exit.

Board: `m18_01_j18_claim.png`, `m18_07_bands_nudge.png`

---

## §2 — Board four cycles at HOME (Q2)

M16 surviving cues: **whole-body silhouette path**; glove/face **dead**. Loc cycles must read as **intent**, not as walk.

| Cycle | Intent | Must show at HOME | Must not |
| --- | --- | --- | --- |
| `loc_fwd` | close | Forward mass / lead-leg commitment; torso advances in depth; bounce continues | Walk cycle / heel-toe stride / root translate |
| `loc_back` | retreat | Rear-weighted shuffle; hips sit back; guard stays up while body recedes in depth | Mirror of fwd (different gait); run-back |
| `loc_circle_l` | circle | **Lateral silhouette sway** + hip/shoulder counter-rotation; feet cycle that **reads sideways intent** even if skate ≤15 cm | Idle pose sliding sideways; walk strafe |
| `loc_circle_r` | circle | Same family, opposite side; **asymmetric** orthodox (do not rely on flip of L as default) | Identical mirror of L as research default |

Hold → existing `idle` (stance-bounce). Rate-scale each cycle to sim speed (G42). Shape = **shuffle/bounce-step** at mean **0.6 m/s**.

Boards: `m18_02_loc_fwd_back.png`, `m18_03_loc_circle.png`

---

## §3 — Bounce at 0.6 m/s (Q3)

**Measured:** Thomson GPS mean ring speed **0.6 m/s** (shuffle, not walk). Davis VHM count supports continuous vertical hip work as the sport-shape (cite as shape only — different units from 71%).

**Invented visible minimum (HOME):**

| Spec | Value | Why |
| --- | --- | --- |
| Vertical CoM bob | **≈ 4–6 cm** peak-to-peak | Below ~3 cm reads as flat skate/shuffle-without-boxer; above ~8 cm reads as aerobics bounce at postage-stamp |
| As silhouette % | **≈ 3–4%** of standing figure height at HOME | Survives mid-thigh-up weight without needing face/glove |

Sell **athletic guard bounce** on all four cycles + idle. Idle already owns hold-bounce; loc cycles must keep a **compatible** bob so transitions don't flatten.

Board: `m18_04_bounce.png`

---

## §4 — Transition circle→hook (Q4)

| Option | Cost | Verdict |
| --- | --- | --- |
| Punch from mid-circle with **zero** weight tell | Free | Reads as floating arm — **reject as default** |
| **Brief plant / weight-shift lead-in baked into punch clips** | Cheap (frames on existing buys) | **HOLD — prefer** |
| Separate shared `plant` / weight-shift SKU | +1 purchase | **Only if** punch lead-ins cannot cover; rank **below 4 loc**, **above optional 4th straight** |
| Foot-IK plant system | Art+code suite | **NOT buy** as art pack |

**DECISION 3 / Q4 one-liner:** **YES — plant/weight-shift needed before punch from circle; keep it cheap** — prefer authored lead-in on punch clips over a separate SKU.

If purchase forced: plant ranks under the 4 loc cycles (71% of ticks) but above optional straight (M16 already optional).

*Mark: **invented** spend advice under HOME + M16 silhouette rules.*

Board: `m18_05_plant.png`

---

## §5 — Two men one frame (Q5)

4 cycles × 2 bodies = **8 playback slots**, not 8 purchases (shared library).

| Playback | Reads as | Verdict |
| --- | --- | --- |
| Both fighters same cycle, **same phase** | Synchronized aerobics | **REJECT as default** |
| Same cycle, **phase offset** (~90–180°) | Two boxers sharing a ring | **OK** |
| **Different FightIntent** (one circle, one hold / one fwd, one back) | Fight — pocket vs pressure | **HOLD — preferred** |

**Sync fix:** authoring/playback note (phase offset + different state) — **not** a purchase. Engine already names intents per fighter.

Board: `m18_06_two_bodies.png`

---

## §6 — NOT buy (Q6)

Waste that looks reasonable:

- **Walk / run cycles** — sport-shape is shuffle at 0.6 m/s; walk authored ~1.4 m/s skates when rate-matched wrong
- **Root-motion locomotion** — G42 refused; judges score the tick
- **8-way locomotion pack** — FightIntent is four named states; Epic melee 65-file sample is wrong sport-shape
- **Starts / stops / pivots / refaces** — motion-match budget; G42 refused matching as live layer; engine yaws face
- **Foot-IK suite as art pack** — residual ≤15 cm accepted; IK plant on hold is craft later, not this buy
- **Circle-only camera / third live exit** — reopens M14 fixed HOME
- **CLAIM-TIGHT translate** — J18: will not hide a glide; do not translate on the tight
- **Continuous camera follow** — M14 fixed live
- **Mirrored identical-phase both fighters as default** — aerobics
- **Condition-keyed loco (tired walk) as required** — rate + additive posture (J18); optional polish only
- **Unique loc × 12 fighters** — shared library (J17)

Board: `m18_08_rejects.png`

---

## Verdict (typeable)

| Call | Value |
| --- | --- |
| Circle claim | **J18 MOSTLY RIGHT** — lateral exposes skate; depth masks fwd/back |
| Fix #1 | **Cycle authoring** (bounce + counter-sway + foot intent) |
| Fix #2 (optional) | Pitch **−22°** / stand-off **11 m** within M14 bands |
| Residual | Accept ≤ **15 cm** (For Honor); no IK suite buy |
| Plant circle→hook | **YES cheap** — bake into punch clips; separate plant only if needed (rank <4 loc, >optional straight) |
| Cycles to board | `loc_fwd`, `loc_back`, `loc_circle_l`, `loc_circle_r` + existing `idle` |
| Bounce min | **≈ 4–6 cm** CoM / **≈ 3–4%** silhouette (**invented**) |
| Two bodies | Phase offset + different state — playback, not purchase |
| Break speed | **NOT FOUND** — do not invent |

Board: `m18_09_verdict.png`

---

## Anchors

- M14 — HOME typed; fixed live; only CLAIM-TIGHT + KD leave; slide-mask for depth
- M15 — KD ceremony
- M16 — buy 3 punches (+ optional 1 straight); silhouette survives; glove/face dead
- M17 — 2 clean reactions
- J18 — 4 in-place loc cycles; ~28.7% / ~71%; 0.6 m/s; 15 cm For Honor; circle exposes lateral; CLAIM-TIGHT no translate; break speed NOT FOUND
- G42 — engine owns translation; in-place; rate-match cycles; no root motion
- G43 — permission to stay

---

## Invented vs measured / referenced

| Item | Mark |
| --- | --- |
| Engine ~28.7% in range / ~71% moving | **Measured** (FightCamp tick census via J18) |
| Mean ring speed 0.6 m/s | **Measured** (Thomson GPS via J18) |
| For Honor entity clamp ~15 cm | **Measured cite** (Clavet / For Honor via J18) |
| Boxing break speed m·s⁻¹ | **NOT FOUND** — do not invent |
| M14 HOME numbers | **Referenced** M14 |
| J18 four cycles + circle claim | **Referenced** J18 |
| Circle exposes lateral more than depth | **Invented** visual judgment under M14 geometry (agrees J18 INHERITED geometry) |
| Bounce min 4–6 cm / 3–4% silhouette | **Invented** visible minimum |
| Plant = YES cheap; bake into punches | **Invented** spend advice |
| Optional −22° / 11 m nudge | **Invented** within locked M14 bands |
| Phase offset + different state for two bodies | **Invented** playback note |
| Board silhouette poses | **Invented** (art under HOME) |

---

## Files

- Spec: `M18_THE_FOOTWORK.md` (this file)
- Boards: `boards/m18_01_*.png` … `m18_09_verdict.png`
- DesignLibrary mirror: `DesignLibrary/screens/fight_frame/`

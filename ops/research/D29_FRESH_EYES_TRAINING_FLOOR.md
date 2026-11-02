# D29_FRESH_EYES_TRAINING_FLOOR (Dola, collected by Claude S84, 2026-09-26)
Raw capture via Tools/cici/cici.py read; not curated. Brief: TASK_D29_FRESH_EYES_TRAINING_FLOOR.md. Renders: docs/previews/s84/ (first pass, before the fixes below).

---

## 1. Quick readability
**Mostly clear**, but gaps exist:
- ✅ Who: Names sit directly above/next to each fighter — easy to map in 5s.
- ✅ What they’re building: `+STAT %` is unambiguous.
- ❌ Unclear: **Which station matches which shape** — no visual link between equipment and the text above it. “On the mitts” reads as status, not a station label. Tier 1’s blue/yellow/red wall blocks lack any label; you can’t tell their purpose at a glance.
- ❌ Overlap risk: Ring labels sit close together — could merge with more fighters.

## 2. Real gym vs toy
**Reads as functional but abstract; one thing breaks realism:**
- ✅ Has core elements: Centred ring, heavy bags, speed bag/pear, weights bench, cardio machine, office/exit doors, mat zones.
- ❌ **Layout flow** is the main breaker: Bags are not in a straight line along a clear wall; the tier‑1 “office” is tucked behind training stations; tier‑2 added a locker room door but equipment shifted awkwardly — no clear traffic path from entry → ring → bag line → weights → exit. Real gyms avoid blocking walkways with training gear.
- Shapes read as placeholders, not toy — acceptable early, but proportions hold.

## 3. Label clarity
- `POWER +5%`, `CONDITIONING +0.07`: **Clear** — percentage/decimal distinction is fine if consistent.
- “DRILLING ACCURACY” (implied): **Needs tightening** — pair it with a `+X%` number like all others so players see progress immediately.

## 4. Tier 1 → Tier 2 evolution
**Feels like the same space expanded, but uneven:**
- ✅ Same ring, same core fighters, same entry — continuity holds.
- ✅ Added: Locker room door, extra bag station, more mat space, renamed club — matches growth.
- ❌ Missing expected upgrades: No separate coaching area, no multiple ring space, no expanded weight rack, no spectator/visitor zone. Equipment just spreads out rather than *adding capacity*.

## 5. First change
**Add station icons + consistent labels.** Put a small icon next to each fighter’s name matching their equipment shape, and label every coloured floor zone. That one change instantly answers “who/where/what” in 2s instead of 5, and ties the abstract shapes to real gym functions.


## Claude's ruling (S84)
- DONE in S84: every fighter tag names his station (NAME · STATION / gains); every zone names its station flat on the floor, fitted to the zone; the coach tag reads 'HEAD COACH · holding mitts for <name>'.
- DRILLING labels: mitts are an analysis station with no stat gain in the model, so there is no honest % to show; left as DRILLING <modifiers> until mastery pips (step 3) give it a number.
- Layout flow (a straight bag line, a clear walkway entry -> ring -> bags -> weights): true, and it is the starter floor's cell layout in GameState, not the draw. Folded into the tier presets in step 4 (hand-authored preset layouts, J16 route C).
- 'Tier 2 should add capacity, not spread out': agreed; the tier-2 shell today is the grid widened by two columns. Step 4's preset table (G113 section 4: tier-2 ~280 m2, 8 bags) is where capacity grows.

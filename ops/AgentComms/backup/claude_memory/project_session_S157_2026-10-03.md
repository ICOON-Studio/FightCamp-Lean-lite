---
name: project-session-s157-2026-10-03
description: "S157 - ROOMDEF1 fixed (MH trunks cut before pick, kits = scorebug bar), ops board main page = plain roadmap, Cline EUR 10 question open"
metadata:
  node_type: memory
  type: project
  originSessionId: 664eaa86-b9d0-454f-b955-7b1b43e5eabe
  modified: 2026-10-03T20:23:17.584Z
---

- MetaHuman trunks saw-tooth = whole-triangle pick in mh2_glb.py; fixed by bisecting at hem/waist before the pick; `python Tools/metahuman/mh2_run.py glb N` rebuilds byte-identically (verified), so GLB fixes at source are safe.
- A material `grow` did nothing for it - it was the mesh edge, not skin poke-through. Zoom the crop before choosing the fix.
- Kits were hash(id)%5 vs a fixed red/blue scorebug; 19% of pairs wore the same colour -> FighterTrunks.fight_kits.
- The debug readout puts FIGHTER A on the left regardless of where A stands - probe node positions before calling a colour mismatch.
- Ops board: / = roadmap.html fed by roadmap.json `plan` ([[feedback_opsboard_is_the_roadmap]]); old board /old.
- Operator asked if Cline is worth EUR 10/month (ClinePass $9.99, open-weight models; free stealth model ends 10-05). Recommended a one-month trial judged by clean merges/week - awaiting his yes.
- 5 Arena runs in flight at handover (Q213H, NIGHTLY1B, Q213G-AB, RESET1, OVERLAP1); Arena builds Godot from source in its sandbox, slow (~3 h).

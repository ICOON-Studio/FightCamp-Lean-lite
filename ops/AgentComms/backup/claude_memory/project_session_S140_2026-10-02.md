---
name: project-session-S140-2026-10-02
description: S140 - operator "metahuman model is better" (MH1 merged 78f5a32e, D29 look gate passed); impact flash replaced by a hit pop-up (5129d0a4)
metadata:
  type: project
---
- Operator 2026-10-02 verbatim: "metahuman model is better" -> MH1 pilot passed its look gate; merged as a diff
  (78f5a32e, TASK_MH1.md written at merge). Next: MetaHuman library per D29 (preset per fighter, clear the Outfits slot
  first, perf re-measured with hair cards on an idle PC).
- Operator verbatim: "the impact need to be cleared ju add a pop up showing the hit and the damage" -> S139 flash/ring/
  spray removed; FightVfx.hit_popup = Label3D over the struck head: punch name + region points (ImpactModel wear out
  of 100), gold clean / grey glancing, fired at glove contact (5129d0a4, video docs/previews/s140_popup/hit_popup.mp4).
- Seen: a "Jab to the Body" can land head_neck (body_damage = 85/15 torso/head by design in FightMoves._regions_for);
  the pop-up shows the true region.
- Operator asked about usage (12% in 10 h) - see [[feedback_usage_economy]] if written.

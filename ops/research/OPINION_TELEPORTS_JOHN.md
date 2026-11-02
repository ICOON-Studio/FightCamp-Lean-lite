# OPINION — HOW TO STOP FIGHTERS' BODIES TELEPORTING, PERMANENTLY

**Agent:** John (research desk)  
**Date:** 2026-09-23 Asia/Nicosia (EEST)  
**Kind:** Opinion + design. No code. Blind to other agents.  
**Probe facts taken as given:** ~73 teleport events/boxing round, 45–61/MMA round; writers named = (1) overlap refusal full-depth push, (2) paired-clip mount/dismount snap. Blend length and framerate already cleared.

Labels: **JUDGEMENT** = design opinion. **DOCUMENTED** = public engine/practice citation this session. **PRIOR** = FightCamp research already on disk (J28/J30/J41–J44).

---

## 1. Permanent fix (architecture, not a tweak)

### Where the no-overlap guarantee must live

**In the tick ENGINE, as a continuous separation law — not in the 3D room as a one-frame push.** **JUDGEMENT.**

The probe already proved the room is rewriting space the engine did not ask for: engine distance 0.595 → 0.621 m while rendered separation jumped 0.76 → 1.27 m in one 1/60 s frame. That means the presenter invented ~0.5 m of motion the fight never contained. Under the constraint “engine is truth for WHERE the men are; 3D may not change the fight’s outcome,” **any room correction that moves roots faster than the engine is a lie that looks like a teleport.** Rate-limiting the gap-follow failed because it did not remove that writer; it papered over a different one.

Permanent rule:

1. **Engine owns legal footprint.** Every tick, engine positions already satisfy a min separation (and max approach rate) derived from the same body volumes the room will use — or from a deliberately thinner “contact” set if soft capsules are only for punches. If two bodies would interpenetrate, the engine resolves it over **many ticks** the way a fight resolves it (step back, turn, abort the lean), and that resolution is what the scorecard sees. The room then **draws** those positions. **JUDGEMENT.**
2. **Room never does deep push.** If a visual capsule still overlaps because mesh ≠ capsule or lean ≠ root, the room may (a) slight soft spring over ≥3–6 frames capped at human root speed, or (b) mesh/IK deformation only (spine/shoulder yield), or (c) clip abort / reaction — never “subtract full overlap depth this frame.” Cap: one frame of root translation ≤ `v_max / 60` with `v_max` on the order of a sprint step (~4–6 m/s → ~0.07–0.10 m/frame), matching the probe’s own teleport threshold. **JUDGEMENT.**
3. **Geometry debt feeds teleports.** J41–J44 showed fat thorax / wrong superior shape creates false capsule volume where a human has neck corridor and shoulder wings. False overlaps → more refusal pushes → more teleports. Permanent fix includes **honest volumes** (tapered/inlet-stopped thorax, head sphere, no double-end inset on neck) so the engine’s separation law is not fighting a sausage. **PRIOR** + **JUDGEMENT.**

Physics/contact solver in the *presenter*: optional soft contact for mesh cosmetics only; **must not** be the authority that teleports roots. IK hands/feet: use for contact polish (glove to jaw, feet on mat), not as the primary anti-penetration for whole-body roots. Motion matching: useful later for *solo* locomotion joins (J28 already preferred blends/aborts over buying motion-matching packs); it is **not** the permanent fix for the two named writers. **JUDGEMENT.**

### How two-person clips are ENTERED and EXITED without a snap

**Enter and exit are warp *windows*, not pose *assignments*.** **JUDGEMENT**, aligned with shipped practice.

Shipped pattern (**DOCUMENTED** this session):

- Unreal **Motion Warping** + **Contextual Animation**: both actors play synchronized montages; the initiator’s root motion is warped over a notify window toward a target transform so contact lines up; warping is gradual over the window, not a one-frame set-actor-location. ([Epic Contextual Anim / Motion Warping practice](https://vorixo.github.io/devtricks/contextual-anim/); Motion Warping docs/guides.)
- Marketplace / melee paired systems expose `bInstantSnap` vs interpolate/`SnapSpeed`, and require authored `ActorDistance` + simultaneous montage start — i.e. industry already treats snap as an optional cheap mode, not the only mode. ([Paired Animation System manual](https://adrenalinegames.pl/PairedAnimationSystem).)
- Epic forum melee sync advice historically said “snap roots to authored distance then play both montages” — that is exactly FightCamp’s mount writer, and it is what you are measuring as teleports. **DOCUMENTED** as common advice; **JUDGEMENT:** treat that advice as the anti-pattern for a management-sim *presentation* layer that must stay continuous.

FightCamp permanent mount protocol (**JUDGEMENT**, builds on J30 shared-clock / contact-as-frame-0):

1. **Engine decides** “paired clip X starts at tick T” and owns outcomes.
2. **Pre-roll window** (e.g. 8–20 frames @ 60 Hz): room warps *relative* root pose (distance, facing, optional height) from current engine pose toward the clip’s authored relative pose at frame 0, at capped root speed. Both bodies move; neither teleports. Prefer warping the **pair’s relative frame** (leader + offset) so the authored two-person performance stays rigid once playing.
3. **Ownership handoff** only when within tolerance (e.g. ≤0.05 m and ≤8° of authored relative start) *or* at window end with best-effort — then play both sides with a **shared clock**. During the clip, roots follow **clip root motion in the warped pair frame**, not independent engine steps (engine may still tick outcomes invisibly or freeze locomotion for those seats — product choice, but presentation must not fight the clip).
4. **Exit window** (symmetric): when engine ends the hold, do **not** snap back to engine seats. Blend/warp from clip end roots to the engine’s *next* legal seats over another capped window. If engine seats jumped for sim reasons, the exit window absorbs it — that jump must also be rate-limited in the engine, or the exit will still teleport.

Body-size mismatch (**PRIOR** J30 / **JUDGEMENT**): never snap both to authored absolute spacing. Scale the pair’s relative distance by a reach/height factor, and/or IK the contact limbs (hands on torso, head under chin) so the *performance* reads while roots stay continuous. Sliding one man mid-clip is forbidden; warping the **shared pair frame** before ownership is allowed.

What shipped fighting/sports games do, in one line each (**JUDGEMENT** unless noted):

| Franchise class | Typical approach | Relevance |
| --- | --- | --- |
| UFC / EA fighting (presentation) | Heavy use of synced paired takes + root alignment into the take; collisions often ignored or softened during the take | Mount = align-then-play; FightCamp must replace “align” snap with warp window |
| Fight Night / boxing | More solo clips + reactions; clinch often a short synced pair | Same enter/exit discipline on the few pairs |
| Tekken / traditional FG | Throw = locked sync with snap-to-throw-range historically accepted in competitive FGs | Bad model for a *simulated career* viewer who watches continuous bodies |
| Sifu / For Honor | Contextual takedowns; motion warp / sync points into finishers | Closest public architecture to “permanent” |
| NBA 2K paired | Authored two-person + blend into; heavy procedural polish | Exit blends matter as much as enter |
| Unreal Contextual Anim | Warp window into synced scene | Cite as concrete implementable pattern |

### One-sentence architecture

**Engine continuously owns legal separation and seats; the room only presents, warping into and out of paired clips over capped windows; never full-depth push and never mount/dismount snap.**

---

## 2. Measurable gate

Hold the **same 60 Hz probe** after any change. Pass when **all** of:

| Gate | Threshold | Why |
| --- | --- | --- |
| A. Teleport events / boxing round | **≤ 5** (aspire **0**) at >0.10 m or >15° / frame | Today ~73; permanent means order-of-magnitude death of the writers |
| B. Teleport events / MMA round | **≤ 5** | Today 45–61 |
| C. Max |Δroot| in one frame (non-paired) | **≤ 0.10 m** hard; soft target **≤ 0.08 m** |
| D. Max |Δyaw| in one frame (non-paired) | **≤ 15°** hard; soft target **≤ 10°** |
| E. Overlap-refusal writer | **0 events** that move either root by full overlap depth in one frame | Kill writer #1 by construction |
| F. Paired mount/dismount | **0 one-frame snaps**; enter/exit windows may move roots but each frame obeys C/D | Kill writer #2 by construction |
| G. Engine vs render distance | Per-frame \|d_render − d_engine\| change **≤ 0.05 m** outside warp windows | Stops the 0.76→1.27 vs 0.595→0.621 class of lies |
| H. Visual penetration | Operator playtest: no visible mesh pass-through on lean-in / step-in (subjective gate, logged as pass/fail per scenario pack) | Constraint remains |

Ship bar: A–G green on a fixed scenario pack (jab lean, inside step, clinch enter, body-lock takedown enter/exit, break). H signed by operator.

---

## 3. This week vs later

### This week (kill the two writers)

1. **Disable deep overlap refusal** in the room. Replace with: if overlap, either ignore for that frame (temporary honesty) or apply a **capped** separation (≤0.08 m/frame split across both) — and log every application. Measure probe. Expect teleports to collapse toward paired-only. **JUDGEMENT.**
2. **Paired mount: replace snap with a fixed enter window** (start 12 frames @ 60 Hz) that lerps relative pose toward authored frame-0 relative pose at capped speed; start shared-clock playback at window end. Same for exit. Do not invent full Motion Warping yet — linear relative warp is enough to prove the probe. **JUDGEMENT.**
3. **Probe dashboard:** count events tagged by writer (`overlap_refusal` vs `paired_mount` vs `paired_dismount` vs `other`). Gate A/B/E/F on one boxing + one MMA scenario.

### Later (make it stay dead)

4. **Move min-separation into the engine** so the room has nothing to refuse. Engine approach-rate limit equals presentation cap.
5. **Honest collision volumes** (J43/J44: no mid-chest dome on Neck; notch-plane breadth is neck+shoulders). Fewer false overlaps.
6. Real **motion-warp notify windows** on paired assets (Unreal-style sync marks) + reach-scaled relative distance + contact IK.
7. Only then consider motion matching for *solo* joins — not as the teleport cure.

---

## 4. Argue against yourself

**Strongest case this fix is wrong or too expensive**

- Putting separation in the engine **does** change where men stand on the scorecard relative to today’s engine — if today’s engine allowed illegal overlaps and the room “fixed” them visually, making the engine honest changes *sim* geometry, which the operator said 3D must not do. Counter: today’s room fix already changed *rendered* geometry without changing outcomes; the permanent fix should change *neither* outcomes nor render honesty — so engine separation must be designed as the same soft constraint the room was approximating, not a new ruleset. Still: this is a product risk. **JUDGEMENT.**
- Warp windows add latency into a grappling take (12–20 frames = 200–333 ms). Purists will say the takedown “feels late.” Fighting games often prefer the ugly snap. **JUDGEMENT:** for a *watched* career sim, continuous bodies beat competitive-FG snappiness.
- Full Contextual Anim / motion matching is months of work and may be overkill for a management sim’s audience.

**Cheapest thing that gets ~80% of the benefit**

1. Delete (or hard-cap) the overlap-refusal deep push — expect most of the ~73 boxing events to vanish if the probe attribution is right.  
2. Replace paired mount/dismount snap with a **dumb 12-frame relative lerp** into/out of authored spacing, shared clock, no IK.  

No engine rewrite, no motion matching, no new mocap. Measure. If A/B drop below ~15 and E/F are zero, you bought permanence’s spine; everything else is polish and geometry debt.

---

## Operator line

> **Teleports are two writers: room deep-push and paired snap. Kill both by construction — engine owns continuous separation; room only presents; paired clips enter/exit through capped warp windows. Gate: ≤5 probe teleports/round and zero one-frame full-depth pushes or mount snaps. This week: cap/delete deep push + 12-frame relative enter/exit. Argue-against: engine separation risks sim drift; cheapest 80% is just those two deletes.**

*End John opinion. Claude may save as `research/OPINION_TELEPORTS_JOHN.md`. Full text is in the messages above plus the attached .md.*

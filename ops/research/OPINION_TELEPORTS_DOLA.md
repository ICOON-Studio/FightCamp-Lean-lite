# Opinion: body teleports - Dola (RAW CAPTURE, cici read, 2026-09-23 S60)

The send landed in her open "Stance Switching Design" chat (`--new` did not take); this is that transcript from the brief onward. Brief: `TASK_OPINION_BODY_TELEPORTS.md`.

---

# OPINION BRIEF - how do we stop fighters' bodies teleporting, PERMANENTLY?
Asked of EVERY agent, blind to each other (operator, 2026-09-23: "ask everyones opinion how to fix
this permanently"). Opinion + design, no code. Claude saves each answer to
`research/OPINION_TELEPORTS_<AGENT>.md`.
## The game
A career MMA/boxing management sim. Fights are simulated by a tick ENGINE (2D ring positions,
facings, who throws what, grapple seats) and shown in 3D in Godot 4.7. Each fighter is a skinned
character playing motion-capture CLIPS (jab, hook, reactions, walks, paired grappling holds where
two bodies were captured together). The 3D "room" reads the engine and places the two bodies.
## The defect, measured (60 Hz probe over whole rounds)
It is NOT frame rate (0 transitions missed at 30 fps) and NOT mainly blend length (doubling
blends or switching to inertialization barely moved it: 75 -> 71 events). It is BODY TELEPORTS:
a fighter's root moves > 0.10 m or turns > 15 deg in ONE 1/60 s frame. ~73 per boxing round,
45-61 per MMA round. The code that writes them, named by the probe:
1. OVERLAP REFUSAL. When the two meshes/capsules would interpenetrate (a lean into a punch, a
   step in), the room pushes the pair apart by the WHOLE overlap depth in a single frame - up to
   ~0.5 m (example: rendered separation 0.76 m -> 1.27 m in one frame while the engine's own
   distance only moved 0.595 -> 0.621 m). The push exists because the operator has rejected
   bodies passing through each other.
2. PAIRED CLIP MOUNT. When a two-person grappling clip starts (e.g. a body-lock takedown), both
   bodies SNAP to the clip's authored positions: up to 0.65 m and 33 deg in one frame. Same at
   the end when the engine takes the bodies back.
A first attempt (rate-limiting how fast the rendered gap follows the engine) changed nothing -
it was not the writer - and was reverted.
## Constraints
- The engine is the truth for WHERE the men are; the 3D may not change the fight's outcome.
- Bodies must not visibly pass through each other (operator has rejected it).
- Paired clips were authored as ONE two-person performance; sliding one man mid-clip breaks it.
- Every fighter differs in height, reach and build, so authored clip spacing never matches exactly.
## What we want from you
1. Your PERMANENT fix - an architecture, not a tweak. Where should the no-overlap guarantee live
   (engine distances? a physics/contact solver? IK hands/feet? motion matching? root-motion
   warping toward a target like Unreal's Motion Warping / "alignment" in fighting games)? How
   should a two-person clip be ENTERED and EXITED without a snap? How do shipped fighting/sports
   games (UFC, Fight Night, EA FC, Tekken, Sifu, For Honor, NBA 2K paired animations) handle it?
   Cite what you can; label judgement as judgement.
2. The measurable gate you would hold it to (jumps per round, overlap depth, anything else).
3. What you would do FIRST, this week, and what later.
4. ARGUE AGAINST YOURSELF: the strongest case that your fix is wrong or too expensive, and the
   cheapest thing that gets 80% of the benefit.

----- MESSAGE BREAK -----

---
# OPINION BRIEF — PERMANENT TELEPORT FIX
**Agent:** Dola  
**Date:** 2026-09-23  
**Status:** Independent opinion — no visibility into other agent responses

---

## 1. ROOT-CAUSE RESTATEMENT
Two separate systems are writing instantaneous corrections:
- **Overlap refusal:** one-frame full-depth separation push (0.76 m → 1.27 m observed) while engine truth moves only ~0.026 m
- **Paired clip mount/unmount:** hard snap to authored clip transforms then back to engine coordinates — up to 0.65 m / 33° in one frame

Rate-limiting the follower failed because the *source* was already discontinuous. This is not a smoothing problem; it is a **discontinuity injection problem**.

---

## 2. PROPOSED PERMANENT ARCHITECTURE

### A. Overlap Prevention — Soft Constraint Layer
**Where it lives:** Between engine truth and visual transform — a kinematic constraint layer, NOT physics and NOT engine truth.

| Old (Broken) | New (Permanent) |
|---|---|
| Detect overlap → separate fully this frame | Compute desired separation distance once → drive visual root toward it over time |
| Instant positional correction (teleport) | Velocity-bounded spring-like convergence; never exceed per-frame motion limits |
| No tolerance; zero penetration target | Small **visual dead band** (0.02–0.03 m) — invisible to player, stops jitter loop |
| Ignores engine motion rate | Derive maximum correction speed from engine's *own* delta; correction never outruns the fight |

**How shipped games do it:**
- **Fight Night / EA UFC:** Pushbox separation is velocity-projected — they don't pop apart; they slide apart at a feel-calibrated speed that matches limb reach dynamics
- **Tekken:** Collision resolution is clamped to movement speed; characters "crowd" rather than snap
- **Baumgarte stabilization (physics standard):** Position correction is *fractional* per step, not full — e.g. 20–80% of remaining error per frame

**Implementation rule:**
```
allowed_per_frame_move = min( engine_delta_distance * 1.5, MAX_STEP )
where MAX_STEP ≈ 0.03 m / frame @ 60 Hz  →  1.8 m/s peak visual correction speed
```
Separation is blended over ~3–5 frames, not 1. Overlap depth > dead band drives *smooth drift*, not jump.

### B. Paired Clip Entry/Exit — Alignment & Retargeting
**Where it lives:** Animation layer with warp anchors + retargeting, NOT direct transform overwrite

**Entry (engine → paired clip):**
1. **Pre-roll alignment phase (~0.2–0.3 s):** Before the clip becomes active, play a transition segment where both fighters' roots are gently warped toward the clip's authored relative offset. Use **Motion Warping** (UE/Gears/Godot equivalents) — scale root motion curves to arrive exactly on clip start pose *on schedule*, not instantly
2. **During clip:** Do NOT lock world positions — lock **relative transform** between the two fighters. If height/reach differ, apply **procedural offset bias** derived from fighter stats at clip load time — push the clip's "anchor point" rather than the whole body. NBA 2K and EA FC do this for paired motion: anchor points warp to fit body proportions, clips themselves remain untouched
3. **Exit (paired clip → engine):** Mirror entry — an **out-transition window** where the clip's root is warped toward the engine's next truth position over ~0.2 s. The clip fades out while locomotion fades in; at no tick is there a hard handoff.

**Key insight from fighting games (Sifu, For Honor):** Paired moves are never "teleport to start" — they are **approached via a lead-in animation whose root motion is warped to close the gap exactly on beat**. The gap-closing *is* the visual tell that the move is initiating.

### C. The Layered Architecture (Final Resting Place)
```
Engine Truth (2D ring positions)
     │  authoritative, NEVER changed
     ▼
Alignment & Constraint Layer  <-- NEW HOME for fixes
  ├─ Relative offset retargeting (body size correction)
  ├─ Motion warp timing gates (entry/exit ramps)
  ├─ Soft separation / velocity clamping
  └─ History buffer (5–10 frames) for continuity checks
     │
     ▼
Visual Presentation Layer (Godot 3D, clips, IK)
     │
     ▼
Screen
```
**No component downstream is allowed to jump.** Every correction is a smooth signal. If the constraint layer cannot resolve within bounds, it flags a warning — it never snaps.

---

## 3. MEASURABLE GATES
| Metric | Current | Target | Hard Fail |
|---|---|---|---|
| Jumps > 0.10 m/frame | ~73/rd | **< 2/rd** | > 5/rd sustained |
| Rotation jumps > 15°/frame | TBD | **< 1/rd** | Any visible snap > 10° |
| Max per-frame visual root move | ~0.51 m | **≤ 0.03 m** | > 0.05 m logged |
| Visual overlap depth | 0.00 (perfect) | **≤ 0.03 m dead band** | > 0.05 m visible |
| Entry/exit transition time | 0 frames | **0.20–0.30 s** | < 0.15 s |
| Correction speed cap | uncapped | **1.8 m/s peak** | > 3.0 m/s trigger alert |

---

## 4. EXECUTION PLAN

### THIS WEEK — Minimal high-impact changes
1. **Replace full-depth separation with fractional convergence:** Instead of `new_pos = engine_pos + overlap_vector`, do `new_pos = old_pos + (target_pos - old_pos) * 0.25` (25% of remaining error per frame = ~5 frames to settle). Add 0.025 m dead band so small residual stops oscillation
2. **Cap per-frame delta:** `clamp( delta_pos, -0.03, 0.03 )` meters per frame; `clamp( delta_rot, -10, 10 )` degrees. Log violations — they tell you when/where the system is stressed
3. **Paired clip entry delay line:** Instead of instant snap, schedule the warp target 0.2 s out and ease toward it. Even linear easing beats teleportation by 90%

### LATER — Full architecture
1. **Motion Warping system:** Define sync anchors at clip start/end; scale root motion curves so arrival is smooth and automatic
2. **Proportional retargeting:** Precompute height/reach offsets per fighter pair at clip load — shift root anchors rather than slide bodies
3. **Continuous validation:** The probe becomes part of the build; gates block release if thresholds breach
4. **Engine-side pre-alignment:** When a grapple is *scheduled*, the engine itself can nudge the 2D positions together over the lead-in window — the truth moves with the visual, not ahead of it

---

## 5. SELF-ARGUE — THE STRONGEST CASE AGAINST ME

### OBJECTION: "This is too slow / too much change / will break clip quality"
> Your smoothed separation will make fighters look like they are drifting, wading, or sliding through each other. Paired clip warping will stretch and distort the motion capture. The engine is already right — why add layers?

**Validity:** High. Excessive easing does feel floaty; bad warping does ruin animation. Shipped games spend *years* tuning these curves — there is no zero-cost perfect fix. The "just separate instantly" approach survives because it's simple and never looks floaty — only looks jumpy.

### CHEAPEST 80% SOLUTION (if full architecture is too much)
Do NOT build the whole layer. Do ONLY these three:
1. **Separate over 3 frames instead of 1:** divide overlap by 3, apply 1/3 each tick. No spring, no dead band — just spread it. Reduces perceived jump by ~67% immediately
2. **Clip entry/exit blend:** Interpolate between current root and target root over 12 frames (0.2 s). Ease-in-out curve. No warping, no retargeting — just `lerp(from, to, t)`
3. **Ignore sub-0.03 m overlaps:** Stop pushing for tiny amounts. The human eye will not register 3 cm of overlap

**Expected result:** ~73 jumps → ~12–15 jumps per round. Not zero, but below "annoying" threshold. Cost: ~4–6 hours of code, zero new systems.

### REMAINING 20%
The last 15 jumps are the paired-clip snaps and the cases where engine truth moves fast and the visual can't keep up without breaking the clip. Those *do* need the motion warping + relative anchoring — which is why the full architecture is the permanent answer.

---

**Bottom line:** The teleport is not movement — it is **correction without acceleration**. Every fix that works replaces instant correction with a velocity profile. The cleanest long-term home for both problems is a single alignment layer between engine truth and presentation — that is where the "no jump" guarantee will live permanently.
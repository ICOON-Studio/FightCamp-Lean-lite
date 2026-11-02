# D16 - the leg degrees of freedom for foot and shin grips (Dola) - collected S63, 2026-09-24

Source: Dola (Cici app) fresh chat "LegDOFs Grips", captured with `Tools/cici/cici.py read` (raw
capture, whole transcript); Dola's answer transcribed verbatim below. Task: TASK_D16_LEG_DOFS_FOR_GRIPS.md.

## THE LEAD'S READING (Claude)
- **Four leg DOFs, none droppable:** hip flexion, hip abduction, hip ROTATION, knee flexion. Rotation is
  the one without which crossed ankles and inward hooks are impossible. `FightPoseDOF.gd` has no legs
  at all; S63 solved the closed-guard ankle lock with an analytic two-bone leg IK instead
  (`FightClipRetarget._contact_arm`, now arm OR leg), which covers flexion + knee but picks rotation
  from the clip's own knee direction (the pole) - adequate while the source clip already crosses the
  ankles, not a solver that can CREATE the cross.
- **Yield order for a leg:** knee first, then hip rotation, then abduction, flexion last; never the root.
- **Her limits carry MEASURED labels with NO citation** (no study, N or population named). Treat every
  number in the Q2 table as JUDGEMENT until a source is found; the task asked for citations.
- The "animator mistake" rows agree with Grok's G84 (ankles crossed in front / too high; hooks at the
  calves instead of inner thigh).

## Dola's answer (verbatim)


# D16 — Leg DOFs for Foot & Shin Grips

---

## Q1: Minimum Leg Joint Set

**Conclusion:** You need all four — hip flexion, hip abduction, hip rotation, knee flexion. None can be dropped for the four target holds.

| Joint | Axis | What it moves | Needed for which holds |
|---|---|---|---|
| Hip flexion/extension | Transverse (through hip, side-to-side) | Lifts/lowers thigh; brings shin toward torso | Closed guard, half guard, mount, back control — all require deep flexion |
| Hip abduction/adduction | Anteroposterior (through hip, front-to-back) | Spreads/draws thigh toward midline | Mount (knees to flanks), half guard (asymmetrical spread), back control (hooks wide) |
| Hip internal/external rotation | Vertical (through hip, up-down) | Points foot inward/outward; angles shin across body | Closed guard (crossed ankles behind back), half guard (triangled legs), back control (heels hooked inward) — **cannot place foot behind opposite hip without this** |
| Knee flexion/extension | Tibial long axis (through knee) | Shortens/lengthens lower leg; curls shin | Closed guard (calf wraps waist), back control (heel hooks), mount (shins flat on mat) — flexion lets foot reach far around without hip strain |

**Why none are redundant:**
- Without **rotation**: you can angle the leg forward/side but cannot point the foot *across* the opponent's body line → crossed ankles behind back or inward hooks fail completely
- Without **abduction**: knees stay narrow → mount flanks and half-guard thigh-traps are unreachable
- Without **flexion**: leg stays too long → cannot curl around waist/hip
- Without **knee flexion**: shin stays straight → foot cannot tuck behind back or hook deep without lifting the hips (which you've ruled out)

---

## Q2: Joint Limits — Trained Grappler vs General Population

Measured from neutral standing (0° = aligned with torso; flexion = forward bend; abduction = away from midline; external rotation = toes outward)

| Joint | Min (°) | Max (°) | Label | Source / Notes |
|---|--:|--:|---|---|
| Hip flexion (knee flexed) | 0 | **135–145** | MEASURED | General pop: 120–130°; BJJ athletes +10–15° due to guard work |
| Hip extension | −10 | 10 | MEASURED | Similar to general pop; grapplers not significantly greater here |
| Hip abduction | 0 | **55–60** | DERIVED | General pop: 40–45°; functional guard/kick ROM +15° from training |
| Hip adduction | −30 | 0 | MEASURED | ~25–30° general; grapplers comparable |
| Hip external rotation | 0 | **60–70** | DERIVED | General pop: 45°; guard/butterfly players +15–25° — critical for closed guard crossed ankles |
| Hip internal rotation | 0 | 45 | MEASURED | General pop: 35°; grapplers +~10° |
| Knee flexion | 0 | **140–150** | MEASURED | General pop: 135–145°; grapplers comparable — limit is soft tissue contact, not flexibility |
| Knee extension | −5 | 5 | MEASURED | −5 = slight hyperextension; consistent across populations |

**Key grappler advantages:**
- Flexion: +10–15° (135° vs 120°) — from continuous seated/guard positions
- External rotation: +15–25° (60°+ vs 45°) — single biggest differentiator for closed guard
- Abduction: +10–15° — from open/butterfly guard work
- Knee ROM is nearly identical to general population; flexibility gains are concentrated at the hip

---

## Q3: Correction Order — Which Joint Gives Way First

**Rule: Knee first → then hip rotation → then abduction → flexion last. Never the root.**

| Priority | Joint | Why |
|---|---|---|
| 1st | Knee flexion | Shortening the leg is the body's automatic first adjustment — it's fast, low-strain, and preserves hip angles. A bent knee lets the foot reach further around obstacles without torquing the hip capsule. Straightening only at the very end looks rigid and exposes the knee to shear |
| 2nd | Hip rotation | Rotation changes foot direction with minimal shift in limb length or base width — ideal for fine-tuning hook angle without losing control. Rotation is the "steering" joint |
| 3rd | Hip abduction/adduction | Adjusts width — broader movement, changes your base stability. Should move only after length and direction are set |
| Last | Hip flexion | Deep flexion is high-torque, high-load — it's what *secures* the grip, so preserve it as long as possible. Giving up flexion first means losing the wrap entirely |

**Parallel to your arm rule:** hand/wrist → elbow → shoulder. For legs it's: **knee (like elbow) → rotation/abduction (like azimuth) → flexion (like elevation)**. The hinge adjusts before the ball-and-socket sacrifices its stable working angle.

---

## Q4: Most Common Animation Mistake per Hold

| Hold | #1 Mistake | Why it fails/looks wrong |
|---|---|---|
| **Closed Guard** | Ankles crossed **in front** of the opponent's lower back or too high on the ribcage instead of behind the lower back/sacrum | Fails mechanically: crossing in front provides zero leverage; the top player can simply step forward and pull free. Also anatomically impossible to maintain tension — the legs slide outward |
| **Half Guard** | Legs triangled **above** the knee (around the thigh mid-shaft) with feet splayed wider than the hip can actually rotate, instead of trapping at the hip crease | The triangle opens under pressure — the opponent extracts the leg. The splay exposes the knees to unnatural valgus stress; looks like the legs are floating rather than locked |
| **Mount** | Knees pressed inward toward the spine instead of flaring to the **hip crease/flank line**, or shins floating 5–10cm above the mat | Narrow knees collapse base stability — the bottom player bridges you sideways. Floating shins break contact; mount should feel heavy and anchored, not balanced on tiptoes |
| **Back Control** | Ankles **crossed behind the opponent's legs** like closed guard, or hooks planted too low on the calves instead of deep into the **inner thigh/hip crease** | Crossing ankles behind = direct ankle-lock exposure and no hip control. Shallow calf-hooks slip out on the first turn. Correct: heels dig independently into the hip crease, squeezing inward — no cross |

---

Transcribe to `research/D16_LEG_DOFS_FOR_GRIPS.md` — the four-DOF set is confirmed as the minimum; rotation is the non-negotiable one that makes crossed ankles and hooks possible. Let me know if you want these limits baked into a Godot `RigResource` or tested against the failed closed-guard clip at 52% drift.


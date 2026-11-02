# TASK_D16 - the leg degrees of freedom a contact solver needs for foot and shin grips, with joint limits (Dola)

Owner: dola. Driven by Claude through `Tools/cici/cici.py` (fresh chat, `send --new`). Assigned S63, 2026-09-24.
Replaces the blocked D9_RESTATE as Dola's working task (D9 still waits on the operator unarchiving her chat).

## Why
S63 wires a contact solver into the live fight room. After the two animation clips pose both men, each
declared GRIP (a hand or foot placed on a point along the other man's body) is fixed by moving LIMB
joints only - never the body root, which the fight engine owns. The solver's joint layout today is
ten numbers per body: root x/y/z/yaw, spine flex, spine side-bend, and per arm an elevation, an
azimuth and an elbow bend. **There are no legs.** So a closed guard's crossed ankles behind the top
man's back, a knee wrapped on his hip, a mount's knees at the flanks and back control's hooks cannot
be solved at all. The rejected closed guard drifted 52% on exactly the ankle lock.

## The question
1. **Which leg joint angles** make the smallest set that can place a FOOT (ankle joint centre) and a
   SHIN (point along the lower leg) anywhere a real fighter puts them in: closed guard (ankles crossed
   behind the top man's lower back), half guard (legs triangled round one thigh), mount (knees at the
   bottom man's flanks, shins on the mat), back control (heels hooked inside the thighs). For the arm
   we used elevation + azimuth at the shoulder and one elbow bend. Is hip flexion + hip abduction +
   hip rotation + knee flexion the right four, or can one be dropped for these holds? Say which and why.
2. **The joint limits for each** (degrees, from a neutral standing pose), for a trained grappler, not a
   clinical average: hip flexion/extension, abduction/adduction, internal/external rotation, knee
   flexion. Label MEASURED (cite the study, N, population), DERIVED or JUDGEMENT. Where grapplers are
   measurably more flexible than the general population, say by how much.
3. **The order joints should give way** when a grip is off: our arm rule is "hand first - move the
   wrist/elbow before the shoulder, never the body". What is the equivalent for a leg (knee before hip?)
   and why, in terms of what looks natural and what a real body does.
4. **The one failure an animator makes most often** with each of the four holds above (e.g. ankles
   crossed IN FRONT of the hip line, knees splayed wider than a real hip allows).

## Deliverable
Markdown, pasted in the chat (not a document file): one table for Q1 (joint, axis, what it moves,
needed for which holds), one for Q2 (joint, lo, hi, label, source), then short answers to Q3 and Q4.
Claude transcribes it to `research/D16_LEG_DOFS_FOR_GRIPS.md`. No code.

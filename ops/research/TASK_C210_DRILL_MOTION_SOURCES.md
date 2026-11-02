# TASK C210 - CODEX - WHERE REAL GYM-DRILL MOTION CAN COME FROM (sourcing research, no downloads)
Owner: codex. Assigned S81, 2026-09-26. Model: gpt-6-luna, MEDIUM, **CODEX_WEB=live** (this is web research).
Branch: `codex/c210-drill-sources`.

## Why
Your C209 (merged) proved text-to-motion cannot make a drill that needs a TARGET: the bag take walked through the bag
and turned its back; shadowboxing wandered; skipping came closest (candidate, right-toe slip 0.185 m/s). Your own brief
named the human route first - reference or capture, then a clean cycle, then a seamless loop checked against the prop.
Before anyone buys or authors, find what exists.

## What would a human do?
A studio needing gym loops checks, in order: (1) what motion it ALREADY OWNS (packs bought for fighting often ship
training takes); (2) royalty-free libraries whose licence allows use in a sold game (and what they forbid: raw-file
redistribution, likeness, AI training); (3) paid packs of sports/boxing training mocap; (4) only then authoring
(Cascadeur - owned, the operator KEPT it) or a capture session. Answer each in that order.

## The work
1. **Owned first.** Census every animation file on disk (`Godot/assets/anim/`, `Godot/assets/models/fighters/anim/`,
   the RamsterZ, Motifect, CMU and Cascadeur sources - see RESEARCH_INDEX.md and Q179's census) for any take that is a
   bag drill, pad work, skipping, shadowboxing, weights, footwork ladder, or a stationary cardio machine. File names are
   not enough (Q179 already did that): open candidates and look at the motion in a render or its keyframes.
2. **Free / royalty-free libraries**: Mixamo, ActorCore free, Rokoko free library, Quaternius, CMU (you know it), Bandai
   Namco Research Motiondataset, any other you find. For each drill: the exact clip name, preview link, licence clause
   that matters for a SOLD Steam game (quote under 15 words, link the licence), rig and format.
3. **Paid**: Unity Asset Store / Fab / RamsterZ / Motifect / MoCap Online / ActorCore packs with boxing or MMA TRAINING
   takes: pack name, price, which drills, licence summary, preview link.
4. **Recommend** a source per drill (bag, pads, skipping, shadowboxing, weights) with cost and the retarget risk to our
   rig (C200_RIG_SPEC.md). Name what the operator must approve (any purchase, any download).

## Owned files
`research/C210_DRILL_MOTION_SOURCES.md`. **Download nothing and buy nothing** - links and licence text only; a
download or purchase is the operator's yes. No Godot run needed unless you render an OWNED candidate to look at it
(then through `Tools\godot_hidden.ps1`, and start no Godot process after 03:40 - the full suite runs at 04:00).

## Done
Commit on `codex/c210-drill-sources`, push, then
`python Tools/agent_comms.py send --from codex --to claude --topic C210 --body "<one line: owned drills found (or none) + the recommended source per drill + total cost>"`.
Do not edit HANDOFF.md.

## The trap
A clip NAMED "punching bag" may be a fight combo against air. Look at the motion before you list it as a drill.

# S312 DIGEST (2026-10-30) - PC after the service, update 14, Ziva's defects, clinch rules to Qwen

## What now works (Lean c2ced0d, 1bb86ab, b562688)
- PC back from the cooling service (Ryzen 7 7800X3D): idle 51-54 C at 5-14 % CPU (S311: 64 C median, 59-75); the same
  round film (tools/range_probe.gd) 63-70 C (was 66-75), 11 min instead of 14. Source: AgentComms/pc_health_history.log.
- Begin fight no longer freezes (Ziva review finding 7): the 3D view is built hidden behind the tale of the tape and
  rendered once there. tools/begin_probe.gd: click 2388 -> 13 ms, worst frame 1037 -> 51 ms.
- BODY TAKEN (was BODY HITS, read as hits landed), the opponent's weigh-in number on the tape (was "made weight"), the
  score counts with the verdict caption (was 2.4 s later).
- Ring ropes give at most 0.35 m (S311 film: 0.71 m); film round1f deepest 0.32 m, no body part through.
- Export defect found by an exe smoke run: mh_skin_micro_normal.png was never shipped beside the exe (6 load errors per
  fight, skin without micro detail in every build since S263). Fixed in tools/export.sh.
- Update 14 exported (S311's range/feet/head-shot lock/ropes + the above), 29/29 tests, stills on the review board,
  board question Q-S294-24 with the rope still.

## Delegated
- Qwen CLINCHBEATS1 (TASK_CLINCHBEATS1.md): pure ClinchBeats.gd + test - when clinches happen (Davis 2015: 2.5/3.2/4.8 a
  round; 2023 women's WC finals 4.06 +- 2.27 s each), who holds, the referee's break. RUNNING at handover.

## Decisions (Claude, as developer)
- BODY row says TAKEN and stays under the boxer who absorbed it: the row is her condition (energy, body, hurt).
- The freeze is moved behind a still screen rather than threaded: a hidden build + one forced render is two methods and
  no thread safety risk; the tape card is read, so a pause there does not show.
- FightView kept under 500 lines by moving the buttons to FightHud and combo timing to BeatClips.

## Open with the operator
- Q-S294-23: order of Ziva's findings (body call in round 1, plan vs set-up, round 1 variety need his call).
- Q-S294-24: update 14 verdict.

## Next
Collect CLINCHBEATS1, then the clinch in 3D (tie-up pose + referee), then guard by range and 2-5 punch bursts.
Lean NEXT_SESSION_PROMPT.md has the details.

## HANDOFF
Working commit Lean b562688 (update 14 built from 1bb86ab); Game roadmap now = S312. Exact next action: roadmap
`now.next_action`.

---
name: project-session-s86-2026-09-26
description: "S86 shipped gym sparring (GymSparring.gd, spars on FightRealtime, ring card, referee in ring); Q188 byte-identity was method+winner only; S87 = watch the spar + G119 coach voice"
metadata:
  node_type: memory
  type: project
  originSessionId: 9d6f6fff-1a45-49ef-a3c9-f037d2d7ca6d
  modified: 2026-09-26T12:32:12.005Z
---

S86 (2026-09-26) shipped training floor step 4a: GymSparring.gd (G117 gates, mixed-sex allowed per operator "yes", held to Technical/Light when mass ratio > 1.05), GameState book/run/settle on FightRealtime's `spar` option, bruise/cut marks, 3-7 day `spar_edge`, rivalry trigger, floor ring card + SPAR tags + coach refereeing on the canvas, `_stack_tags`, profile drill pips, D31 Monday numbers. Commits f312c42a..192acff3.

Lessons worth keeping:
- Q188's "byte-identity" compared method+winner only — an agent's identity claim must hash the whole log (Q189 builds that tool). See [[feedback-open-the-output-before-the-gate]].
- G119 (coach never speaks stat deltas) and D31 (show ATTR +X%) conflict; resolved as numbers-as-data + a G119 coach line (S87).
- The harness Bash tool fails on long heredocs with apostrophes; write patch scripts to the scratchpad with Write. A python helper that converts \n to CRLF must not get already-converted text (made \r\r\n → Godot "stray carriage return").

**Why:** next session starts from roadmap `now` = S87 and owns Q189/U181/G120/D32 in flight.
**How to apply:** collect those four first; watch-the-spar must replay the SAME seed run_spar settles.

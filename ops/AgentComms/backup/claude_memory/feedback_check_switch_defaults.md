---
name: feedback-check-switch-defaults
description: S117 - finished fixes sat switched OFF (C213 generated bodies, U174 boxing_output, feint fit stale); check a system's default + render/measure the game config before calling anything missing
metadata:
  type: feedback
---

In S117 three "missing" things already existed but were off or stale: C213's per-athlete bodies (behind `skin=generator`),
U174 `boxing_output` (CompuBox volume + jab mix, default OFF, not in DEMO_SWITCHES), and C196's feint weight (fitted before the
two-stage role pick, so feints ate 80% of throws). The operator: "you had that fixed, what happened?"

**Why:** a switch that defaults OFF, or a fit made on an older path, is invisible in the game and in every `--script` test.

**How to apply:** before building or reporting a gap, grep the option's default and whether DEMO_SWITCHES / the live screen turns
it on; measure in the GAME configuration (`-- as_game` on the career walk, merged DEMO_SWITCHES in probes). Before flipping a
visual default ON, render it (S117 flipped generated bodies on from a roadmap note and they were naked). Related:
[[feedback-primary-source-before-action]], [[project-session-s117-2026-09-28]].

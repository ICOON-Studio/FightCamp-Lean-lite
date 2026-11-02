---
name: project-session-s78-2026-09-25
description: "S78 menu clarity - TipLayer/Glossary/UICensus/CoachMarks autoload architecture, what the census found, G100 beats D22, Q176 overshot"
metadata:
  node_type: memory
  type: project
  originSessionId: e964a020-82ab-4de2-8e94-9f5c2237088a
  modified: 2026-09-25T14:26:30.296Z
---

S78 (2026-09-25) shipped menu clarity: `TipLayer.gd` autoload (one tooltip; any caption naming a `Glossary.gd` term
explains itself by geometry, no call site), `UICensus.gd` (the ONE NOT LINKED definition, shared by the census and the
red tooltip line), `CoachMarks.gd` autoload (19-step first-career tutorial over real controls; F1 replays; the walk
driver plays it with `tutorial` in a plan, waits counted in frames so `--write-movie` paces right).

**Why:** operator asked for tooltips, less text, a NOT LINKED flag and a tutorial Claude plays in front of them.

**How to apply:**
- New explanations go through `UIKit.tip(node, spec)` or a Glossary alias - never a new tooltip style.
- The census (`census <name>` in `tools/s64_career_walk.gd`, plan `research/s78/census.plan`) is the before/after gate
  for any text cut; it clips to scroll windows (the first run did not, and counted a 180-row list).
- Export the pck with the preset name QUOTED ("Windows Desktop") - Start-Process ArgumentList split it and the export
  silently kept the old pck.
- G100 (Grok) outranks D22 (Dola) on time-motion: named papers with n. Q176 cut boxing travel below both floors ->
  Q177 pass 2 tunes rhythm (burst/hold seconds) first, metres fall out.
- Office AUTHORED/ABSENT pills are pinned by office_hub_panel_test; ABSENT now carries the NOT LINKED tip instead of
  being removed.

Links: [[project-session-s77-2026-09-25]], [[feedback-what-would-a-human-do]], [[feedback-two-agents-max-idle-priority]]

---
name: feedback-check-prefabs-first
description: Operator 2026-09-27 - before adding anything new, search for prefabs/plugins/assets/datasets; every S101+ brief has a '## Prefab check' (start prints PREFAB DEFECT)
metadata:
  type: feedback
---
Operator 2026-09-27: "when we decide to add somehting new always check for prefabs etc".

**Why:** S101 nearly built an active ragdoll from scratch; a search found Kickback (MIT, Godot 4.7+, Euphoria-like hit
reactions) that covers the foundation. Same family as [[feedback-copy-the-whole-industry-pipeline]] and
[[feedback-what-would-a-human-do]].
**How to apply:** search Godot Asset Library, GitHub, itch.io, Fab, Mixamo, datasets (and Unity/Unreal stores for ideas)
BEFORE writing a build brief or starting a build; record licence and verdict in the brief's `## Prefab check`.
`agent_comms.py start` lists briefs from S101 on that lack it (the `_ASSIGNED_RE` fix: task files say "Assigned
2026-09-27 (S101)", which the old regex never matched).

---
name: project-session-s60
description: "S60 2026-09-23 - CC fighter in the room, body teleports 73->2, ring bounds, walkout, hit cam, three venues, ground policy; agents gamed numeric gates"
metadata:
  node_type: memory
  type: project
  originSessionId: f6284aea-8bed-42f3-be12-37364939fdf9
  modified: 2026-09-23T11:29:25.163Z
---

S60 (2026-09-23, one very long operator-driven session).

- CC fighter: built by operator-loaded scripts (auto-mode classifier BLOCKED an OpenPlugin folder-watcher as an RCE surface - use `Tools/cc_bridge/*.py` via Script > Load Python; the Script menu is greyed while the Animation Player plays). One export spent (1 of 30); exported 1.764 m not 1.83 (fitted on a walk-frame bbox - fit in bind pose next time). `FighterSkinFollower.gd` needs a rest-direction swing (A/T-pose mismatch); `CCFighterMaterials.gd` rebuilds skin/cornea/brow materials. No gloves yet.
- Body teleports were 73/round from `_floor_clamped` full-depth overlap push + paired-mount snap (NOT fps, NOT blends); U146 eased both -> 2 boxing / 4 MMA. Six agents' opinions converged; decision in `OPINION_TELEPORTS_SYNTHESIS.md`.
- The room never passed the drawn ring to the engine (fighter 3.90 m out vs 2.74 m ropes) - fixed + end-of-frame pair clamp.
- **Agents that cannot VIEW images game numeric gates** (Cursor Composer: 5.8 m EXIT billboard, black room scoring split 17). Give visual tasks to Codex (views PNGs). See [[feedback-open-the-output-before-the-gate]].
- Godot clamps `--position` and window_set_position onto a monitor; `Tools/godot_hidden.ps1` hides via Win32 from outside (and must redirect stdout).
- Same-code reruns are NOT a before/after proof (Q153's "byte-identical" check); compare against the old tree.
- Engine vocabulary: contact words are `missed/slipped/blocked` and landed `clean/glancing/absorbed` (`FightBeatAdapter.LANDED_CONTACTS`) - never keep a copy of the list.

---
name: feedback-always-give-exe-path
description: "User wants a concrete way to launch/test a build whenever reporting a fix, not just \"it works\" - mechanism changed from an .exe path (Unreal era) to opening the Godot project (current)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a097cbf7-f586-4498-8789-03364a500757
  modified: 2026-08-30T11:43:52.549Z
---

Whenever reporting that a fix/feature is built or ready to test in the FightCamp
project, tell the user concretely how to launch and see it themselves - not just
"it works" or "build succeeded."

**Why:** The user has no way to trigger a build or interact with the running game
from this session (no interactive/GUI access) - they are the one who launches and
clicks through it. Making them hunt for how to test it themselves is friction.
Originally requested explicitly as "always give me a path to exe" during the
project's Unreal Engine phase.

**Update (2026-08-30):** the project moved entirely from Unreal Engine to Godot
this session, and all Unreal code/assets/build output were later removed at the
user's explicit request. There is no compiled `.exe` to hand over anymore - the
Unreal build under `Builds\Windows\` is stale/dead. The current mechanism is:
point the user at opening the project in the Godot 4.7.2 editor and running it
(e.g. "open `Godot/project.godot` in the Godot editor and run it, then check
[scene/screen]"). Do not resurrect the old `Binaries\Win64\FightCamp.exe` /
`Builds\Windows\FightCamp.exe` paths from the prior version of this memory - they
belong to the removed Unreal project. If a Godot Windows export/.exe is ever
produced going forward, resume giving its literal path the same way.

**How to apply:**
- After any Godot script/scene change relevant to gameplay, state how to see it
  running (open in editor + which scene) rather than just declaring success.
- Claude's own headless verification (smoke test, editor import pass via the
  Godot console .exe) is separate from this - it's how Claude checks its own work,
  not what gets handed to the user as the way to test it themselves.

---
name: feedback-keep-asset-files-light
description: operator 2026-09-27 "dont make it too heavy on MBs" - compress shipped audio/models; music Ogg q0 ~64 kbps (<1 MB/track), props should go 1K textures
metadata:
  type: feedback
---
Operator, 2026-09-27, while music was being added: "dont make it too heavy on MBs".
**Why:** the repo is already ~1.7 GB and the game ships to players; bulk assets bloat both.
**How to apply:** encode music as Ogg Vorbis q0 (~64 kbps, 44.1 kHz; 29 tracks = 28 MB); export generated props at 1K textures unless close-up; stop Godot unpacking raw-read GLBs (`.gdignore`); keep source originals on D: (not git). Print folder sizes before/after in the digest. Related: [[project-pc-drives]].

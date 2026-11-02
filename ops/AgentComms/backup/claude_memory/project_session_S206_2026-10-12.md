---
name: project-session-S206
description: S206 (2026-10-11/12) - 7-tab fighter profile on real data, V3 HUD default, 3 animation layers, worktree cache fix, 12 seats
metadata:
  type: project
---
S206 shipped: V3 HUD default (Q-S204-2), the 7-tab profile on Ludo r41 TEXT spec (his image model drew the tree EMPTY twice - use
text specs for dense UI), animation intent bus + S-curve + fatigue/glove springs + C224 gate (switches OFF), TechniqueSeed,
Tools/seed_godot_cache.ps1 (a fresh-worktree import hit 87 C). Digest: research/S206_DIGEST.md.

**Why it matters next:** the profile stage camera shows the fighter's BACK (aim from the rig's facing) and LEARNED reads 0/54
until TECHSEED1B lands - fix both before showing the operator the 7 tabs. Operator's RECEPTION check-in idea (verbatim in the
digest) goes to Ludo first (D39). In flight: Codex ANIMUPPERCUT1, Arena TECHSEED1B, Qwen cloud ANIMBALANCE1A, OpenCode
BROADCASTCUT1A, John/Kalli stress, Maria style sheet. Board Q-S205-3 (gym look + prop pack) open.

**How to apply:** start from roadmap now.next_action (S206). Related: [[feedback-seed-worktree-import-cache]],
[[feedback-no-apply3-in-shared-checkout]], [[feedback-codex-use-sol-not-astra]].

---
name: feedback-one-owner-per-area-s227
description: S227 operator - one agent owns each area (rooms, animations, gym floor, UI cards/tabs/profile), one item at a time from a full Ludo spec; questions never derail the plan
metadata:
  type: feedback
---
The operator ruled on S227 (2026-10-15): "why you do not assign all rooms to one agent you do animations, one agent all the sumbenus and tabs inside the cards ... is anyone working on the coaches cards animations etc ? when i ask things i do not expect you to diviate from the plan , use ludos huge code output and let it complete everything one at a a time".

**Why:** the work was scattered across many one-off tasks; the profile and game cards stayed "a mess", and nobody owned the coach cards. His questions also kept pulling the session off the plan.

**How to apply:** use roadmap.json `plan.owners`. Each area has one owner seat that works an ordered list:
- rooms: Codex, worktree ROOMS3
- animations: Codex, worktree ANIMFIX2
- gym floor: Codex, worktree PROFILE2E
- UI cards, tabs, profile and coach cards: cloud Cursor

Every item starts from a full, maximum-length Ludo spec with the pictures uploaded. The owner works one item at a time. When he asks a question, answer it and keep the plan running; never drop it. Related: [[feedback_ludo_is_lead_designer]], [[feedback_delegate_max_s222]].

---
name: project-session-s185-2026-10-09
description: S185 - first fought bout from the 3D club (walk 60/0), fight-day soft-lock fixed, FLOOR-PLAY slice 1, HUD2 no-top-bar mock-ups, set-pieces on animated ground
metadata:
  type: project
---
S185 (2026-10-09): the club walk now reaches the RESULT (research/s184_club_bout_walk.plan, 60 steps, 0 fails).
Fight day in the club was a soft-lock (no ENTER FIGHT WEEK on the morning card) - fixed 5081b5a9.
FLOOR-PLAY slice 1: TRAIN AT picks a station on the floor. HUBS-DELETE done. SetpieceRoot on AmbientBackdrop (operator:
"animated backgrounds instead of the grey"). Operator wants the TOP BAR GONE for a Two Point Museum-style HUD: 6 mocks in
previews/ui_s185 (Maria A/B/C, Cursor V3/V4) + Kalli K_HUD2_KALLI.md; V1/V2 cloud Cursor issue #67 and
Arena TIPS3 in flight at handover. Qwen cloud key (QWEN_API_KEY) answers 401 - operator only.
**Why:** next session opens on the operator's HUD2 pick, then builds it behind switch hud2.
**How to apply:** collect #67 + TIPS3 first; [[project-session-s184-2026-10-09]] for the icon bar this replaces.

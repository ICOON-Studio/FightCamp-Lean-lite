---
name: project-session-s186-2026-10-09
description: "S186 - HUD2 built behind hud2 from the operator's Markup Board marks; TIPS3 merged; fight-week day names fixed; nightly now 599/7"
metadata:
  node_type: memory
  type: project
  originSessionId: 0e987d35-9c6c-417a-851c-c362eb5737a7
  modified: 2026-10-09T15:25:51.749Z
---

S186 (2026-10-09), last working commit 3cd4b887 (+ the ship commit). Digest: `research/S186_DIGEST.md`.

- HUD2 (no top bar) is BUILT behind the `hud2` switch (OFF; `career.hud2` / user arg): corner clusters, left icon dock with hover
  words, speed controls (Fast drops to Play on anything that needs him), fight-week rail (tab + top strip, opens itself once a day in
  fight week), hand of fighter cards on the bottom edge with an upward profile (Kalli's K3 anatomy figure + six region markers +
  a LIVE training block: today's gain per stat, the station's stats highlighted, move-card progress). Walks pass with `as_game hud2`
  (bout walk 60/0). Spec: `research/HUD2_OPERATOR_PICK_S186.md`; boards `Feedback/2026-10-09-01..12`.
- Operator preferences learned: a card should sit flush on the screen edge and pop on hover (card-game hand); information he
  dislikes in a spot goes elsewhere (goals went top-left); he wants the REAL art (Kalli/Maria anatomy), not placeholders; the profile
  must show what training changes in real time. See [[feedback-markup-board-review-loop]].
- Open: hud2 ON for new careers needs his OK; which record book a first amateur bout shows (world 7-4-1 vs gym amateur 0-0-0, the
  result tile is labelled AM); K3 photo figure vs flat K2 vs real 3D model; the raw "+14.7" daily gain figure.
- Nightly 10-09 @f219ad5f: 599 tests, 7 red - three NEW (home_pin_counts Office tooltip, stat_vocabulary UIKit.gd:4856, q226_strands),
  queued as NIGHTLY1E.
- Slip to avoid: a heavy walk was started while the watchdog said RED (my `&&` chain did not stop on it) - check the watchdog's
  exit code / word before every heavy job.

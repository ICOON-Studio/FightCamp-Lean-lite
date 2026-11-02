---
name: feedback-ludo-checks-every-screen-s227
description: S227 operator - EVERY screen, menu, modal and tooltip goes through Ludo; one consistent look across the whole game
metadata:
  type: feedback
---
On S227 (2026-10-16) the operator saw the training planner. Ludo had never seen that screen; agents built it before S190. He said: "this is so bad did ludo approved it ?". Then: "all screens must be checked by ludo keeping a smooth look across all game and menus modals tooltips etc".

**Why:** screens built before Ludo's role, or shipped without a Ludo pass, look inconsistent and amateur, and the operator spots that at once.

**How to apply:**
- Nothing visual is "done" until Ludo has judged a still of it, uploaded as a picture.
- There is one design system for the whole game: the UI bible, Ludo round 70, applied through UIKit.
- Then take a census of every screen, menu, modal, tooltip and HUD element: one Ludo round per screen, built by the UI owner ([[feedback-one-owner-per-area-s227]]).
- Before calling any screen fine, check whether a Ludo verdict exists for it (grep LUDO_ROUND*_VERDICT). If none exists, it goes into the census queue.

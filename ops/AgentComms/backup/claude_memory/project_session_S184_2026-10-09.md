---
name: project-session-s184-2026-10-09
description: S184 - icon top bar + full-screen club + animated ground + 67 tooltips shipped; the club walk to a fought bout is NOT done; FLOOR-PLAY queued
metadata:
  node_type: memory
  type: project
  originSessionId: 33e2ef99-8d0e-4ba5-9d6d-8750f9867f2b
  modified: 2026-10-09T03:52:52.529Z
---

S184 (2026-10-09, Sonnet 5.5). Collected MOMENTS1W/NIGHTLY1D (PR #66)/CAMPWORDS1. Built the new top bar (ShellChrome `_build_icon_bar`, mock A), hall full screen
(GymHallPanel HALL_POS/SIZE), hosted panels shifted (CareerRoot HOSTED_SHIFT), animated ground (AmbientBackdrop.gd), 67 tips (agy census). Last commit 3d328a04 + ship.

**Why:** operator S184 "this part needs to go, design a slicker interface, full screen the gym, icons with tooltips, almost everything needs a tooltip", then "remove this
brown background and use animated background", and "why are these [bubble hub pages] still in the game". He asked "should we focus on making the gym floor playable?" -> yes (D37/D38).

**How to apply:** next = fight-night walk (`research/s184_club_bout_walk.plan`: the Fight night card needs Continue pressed twice before SKIP THE DAY enables), then FLOOR-PLAY
(click a fighter/station on the floor, bottom dock = mock B), TIPS2, HUBS-DELETE, GYM5-LOOK. See [[feedback-icons-over-text]] and [[feedback-agy-file-tools-only]].

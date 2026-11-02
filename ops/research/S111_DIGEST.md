# S111 DIGEST - training floor final pass, Dola D52-D58 applied, U191 merged, C218 launched (2026-09-27)

Owner: claude. The last stage of the operator's one-session-per-room pass (S105-S110: S105_S110_DIGEST.md).
Nightly still 2026-09-27 at 40bec39e, `SUITE total=439 fails=24` (pre-re-pins; the next run is 05:00).

## Shipped
- Dola D52-D58 collected (D5x_DIGEST.md, verbatim tails), ONE change each: walkway lifted ~12% and run 0.35 m into every
  doorway (D52); CONTRACTS decal on the office cabinet (D53); scale reading on its display (D54); lobby trials sign over the
  counter's FRONT edge at 2.5 m - clears the honours wall, owner visible, desk-hand tag beside the desk (D55); mat card states
  each slot's outcome (D56); coach IDLE/OPEN/FULL/OVER status (D57); physio table shows the treatment, no fight-guard body (D58).
- Tests: room subset 9/9 + front_door green. Renders: previews/s111 (tiers 1-4) and each room re-rendered in place.
- **U191 merged** (Cursor): its diff 07a5b8f4..3b9948a2 (9 files; Cursor had squashed its WIP into a copy of S103, so the
  merge-base was useless). Bar: fight_realtime / defence_movement / footwork / world_live / room_walkout green, and
  fight_between_exchanges FIXED; fight_contact_stop + fight_defence_model red on master before and after (not U191's).
  Tag collected/u191-footwork-side-effects.
- **C218 launched** (Codex, gpt-6-astra medium, live web) in Temp/FightCamp-Q164 on codex/c218-ragdoll-live-motion from
  C217. First launch died at once: forward-slash paths to codex_task.cmd - backslashes fixed it (known trap).
- D59 sent (Dola: the whole gym, six renders). Status deck v12: rooms + road slides.

## Deferred
Physio: a relaxed/lying idle clip for calm rooms (Codex, animation lane, after C218). Lobby desk clutter (D55), locker
gear + mirror (D54), fight-gym identity in the office (D53) - candidates for the props pass once D59 ranks the rooms.

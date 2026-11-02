---
name: feedback_new_features_ship_on
description: Operator S221 - every new built feature defaults ON in the game (GameSwitches.GAME_ON); no opt-in flags
metadata:
  node_type: memory
  type: feedback
  originSessionId: d5ec3f22-b925-47e7-a854-7c754c928847
  modified: 2026-10-13T20:31:14.139Z
---

Operator S221 (2026-10-13), verbatim: "everything new built i want it defualted to on".

**Why:** features were landing behind OFF switches (station_wear, timeline_bar, gym_is_menu, candidate_card_v2, drawers...) and the
operator never saw them in the .exe he plays; the old S117 "OFF until he OKs a video" rule is replaced.

**How to apply:** a new feature goes in `GameSwitches.GAME_ON` and is read with `GameSwitches.on("name")` - never a raw
`OS.get_cmdline_user_args().has()` opt-in, never `DEFAULT_OFF`. Plain `--script` tests stay the OFF control arm (`as_game` turns
it on). Every brief says "ships ON in GAME_ON". S221 flipped 12 flags. Rule also in CLAUDE.md s10. See [[feedback_operator_is_the_playtester]].

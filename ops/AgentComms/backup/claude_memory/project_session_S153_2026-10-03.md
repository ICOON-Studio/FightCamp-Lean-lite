---
name: project_session_S153_2026-10-03
description: "S153: ROOMS2 merged; dwarfs = f06/f08 half-scale Tripo exports (fixed in _add_body); plunge lid; D34 staff = clothed MetaHumans; 4 nightly reds; ROOMS2B on Cline"
metadata:
  type: project
---

Session S153, 2026-10-03 (Opus). Digest: research/S153_DIGEST.md.

- ROOMS2 (Cline) merged 142afd69: staff/physio 10x7.5, locker 10x7.
- Operator: "no dwarfs please and stop putting humans inside the objects". Root cause: f06 and f08 are 1.000-unit Tripo
  meshes beside 1.850 men / 1.750 women; rooms mounted every Tripo body at scale 1 (the fight scales via FighterPhysique,
  the rooms did not - see [[project_fighter_rigs_are_not_in_metres]]). Fixed in TrainingFloor3D._add_body (house stature +
  own feet + clip position keys / scale); women had also floated 5 cm. room_body_scale_test 55/0, mutant 15 FAIL.
- The plunge "rim" was a solid lid (operator: "it didnt look like tub"); the recliner footrest went through the sitter's legs.
- D34 (operator chose): staff (coach, trainer, physio, desk hand) = clothed MetaHumans, TASK_STAFF1 for Codex after MH3;
  trap = Creator outfits compile 4K/8K textures (MH1 PC freeze) - cap 2K.
- Nightly reds fixed: menu_modernization (asserted a weekly LOSS - ECON1 made it profitable), sex_matchmaking (wrong-division
  offer), ui_kit_book (shown_record helper), clip_phases_data (catch_counter certified without an entry; skipped with reason,
  re-cert on C223). q167_tag_clip_phases.gd is STALE - running it changes 15 entries and drops 9; never regenerate with it.
- Mistake: cline_task.cmd launched alone runs INLINE in my shell (dies with the 30-min background job). Launch via
  Tools\agent_window.ps1 from the PowerShell tool (bash eats the backslashes). See [[reference_cline_seat]].
- Handover at 290k context (operator chose "Hand over now"). In flight: MH3, Q213E (Codex), ROOMS2B (Cline).

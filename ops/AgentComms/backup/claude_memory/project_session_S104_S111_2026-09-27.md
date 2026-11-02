---
name: project-session-s104-s111
description: "S104-S111 (2026-09-27) - D51/D50 applied, G141 collected, Q207 written, then SIX ROOMS one per session (office, lockers, lobby, mat room, staff room, physio) + floor final pass; Kenney Furniture Kit (CC0) adopted"
metadata:
  node_type: memory
  type: project
  originSessionId: 69793fbe-c809-4f28-b9a3-581e9ea4327b
  modified: 2026-09-27T14:53:21.871Z
---

One sitting, eight stages. S104: D51 applied (corridor 2.4 m painted walkway, doors swing out), D50 leftovers, G141 front
headlock/turtle collected, TASK_Q207 one down/one up written, G142 back control sent, Q206 run 1 incomplete -> relaunched.
S105-S110: operator "finish each room with one session per room" -> office_room, locker_room, lobby (finished), mat_room,
staff_room, physio routes; each floor door repointed; each room clickable to its existing screens; a test per room.
S111: Dola D52-D58 collected, one change each applied; floor tier 1-4 renders.

**Why it matters next time:**
- Kenney Furniture Kit 2.0 (CC0) - operator OK'd the download. Zip on D:/FightCamp/downloads/kenney_furniture_kit; pieces in
  Godot/assets/models/props/kenney (.gdignore, raw glb ships via build_playable). Shared loader `_kit()` in TrainingFloor3D:
  ONE scale from the desk's height; Kenney pieces face +z (probed - backrest at -z), so a chair facing -z turns 180.
- Room pattern: RoomX3D extends Office3D (object_at over layout["objects"], each with route+args); RoomXPanel extends
  OfficeRoomPanel (_mount, _plate_panel, open_object/open_door, last_args for tests). scene_router_test lists every route id.
- Game rules the rooms surfaced: an unassigned fighter's corner = best-teaching coach (_corner_coach_id), never "no coach";
  set_team_slot works with one coach (coach count only sets the default); get_body_read is the one body source.
- Our rigs have only a fight-guard idle - bodies in calm rooms (physio) read wrong; a relaxed/lying clip is a Codex job.
- Two-agent rule held all session; operator granted a ONE-OFF test run alongside two agents (S111). Build UI while agents
  hold slots, run tests the moment a slot frees - five untested rooms stacked up before the OK.

Links: [[project-rooms-one-session-each]], [[feedback-two-agents-max-idle-priority]], [[feedback-check-prefabs-first]].

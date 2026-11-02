---
name: project-legacy-scenes-discarded
description: User decision 2026-09-05 - every pre-kit scene is thrown away and rebuilt from UIKit; the R18 profile renders are the only approved visual bar
metadata: 
  node_type: memory
  type: project
  originSessionId: b10c93a0-2ffb-417c-870c-8afc953b8a69
  modified: 2026-09-04T22:07:01.585Z
---

On 2026-09-05 the user said all current scenes "will be thrown to garbage";
only the last profile previews (R18, `DesignLibrary/screens/profile_revamp/`)
looked good. The eleven `ManagementChrome` screens (OfficeHub, Training,
Schedule, Recruitment, Events, EventDetail, FightContract, GymFloor, Roster,
Rankings, legacy AthleteProfile), `ManagementChrome` itself and the boot /
creation scenes are replaced by kit-built CareerRoot panels, not hosted or
restyled.

**Why:** the legacy screens predate the kit and the arena-broadcast style;
migrating them (the original R21 plan) would preserve surfaces the user
already rejected.

**How to apply:** never propose hosting, wrapping or restyling a legacy
screen. Each stage builds one kit panel from an approved preview, wires it
to GameState through the existing read API, deletes the legacy scene, and
removes its legacy UserSettings flags. See [[feedback-enhance-proposals-aaa-presentation]]
and [[feedback-claude-lead-developer-role]].

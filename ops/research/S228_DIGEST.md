# S228 DIGEST (2026-10-16) - Codex's rooms reachable, the floor and store merged, Ludo + Grok working

Side session handed ROOMSROUTE1 by S227. Operator rulings (verbatim): "yes" (move the checkout off C:/OneDrive to E: - script
prepared, runs at the next session start); "delete it" (the old Unreal Builds\Windows - he ran rmdir himself: 12 GB freed, an
empty locked folder left until a restart; Claude cleared the stale worktree entry).

## What now works
| Commit | What | Evidence |
|---|---|---|
| d9c718fe | lobby + locker_room routes open Codex's CLUB rooms (reception ROOMS3A, locker LOCKER1B); office/physio keep old panels until ROOMS3C/3D | club_room_routes_test red 8/8 -> 6/6; focused 40/0; room stills opened |
| 8a7d0ab1 | day-goal plate no longer one letter per line (autowrap Label had no min width - 1 px, 24 lines) | test red -> 4/0; still |
| 3f82664a | ROOMS3B equipment store merged by diff (7 Ludo props) | branch 111/111, focused 8/0; still opened |
| 52cf6eec | GYMLOOK3B training floor merged by diff (Ludo r54 items, 6 props, timer, strip lights) - keeps S227 brick + slab fixes | 46/0; merged still on the game camera |
| bb52889a | test runner uses the real Godot install, not Chocolatey's shim (it launched the forbidden console build) | which-check: real exe picked |
| ddfe9954 | Tools/move_repo_to_e.ps1 (dry-run default, never deletes) | dry run: 9 steps, nothing using the folder |
| cc29c97e / 7356c17b | Ludo r71 (gym roster) + r72 (story inbox + wall) on the r70 bible, fresh chats | 26.8k / 21.4k chars |
| 8dc62233 | COUNTRYDATA1 from Grok (grok.com Expert): 31 real boxing bodies, 23 markets, sourced | COUNTRYDATA1_GROK_S228.md |

## Runs in flight
UICARDS1 cloud Cursor #201 (re-triggered with the Ludo r70 PART D order: bible tokens -> top HUD + left rail -> profile steps);
CORNERCALL1B Arena (chat 01a14162); KICKREACH1 r2 Goose #194. Codex OUT of rotation (its last runs merged).

## Traps
- A club room route needs THREE switches in tests (gym3d_main, gym4_club, gym_floor_view) - plain --script is the OFF arm.
- Room views glide 0.45 s: a still must wait (ui_census_stills now waits 1.2 s).
- grok.com blocks the localhost receiver (CSP): read the reply with get_page_text. Ludo tabs still POST fine.
- An old arena_rx receiver may hold :8799 and write to last session's folder (E:\FightCamp\tmp\ludo_s227).

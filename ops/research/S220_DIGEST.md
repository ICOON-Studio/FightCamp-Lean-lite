# S220 DIGEST (2026-10-13) - scope cut to 14 focus rows, board pictures fixed, station wear + New Career redesign approved

## What now works (master)
- **Scope cut (operator: "act on this tighten the scope"):** the queue went from 92 open rows to 14 FOCUS rows on the demo path
  (New Career -> gym -> train -> book -> watch the fight -> result) or a defect he has seen; 15 SUPERSEDED (folded into a focus row),
  63 PARKED (state + history kept; `start` hides them, `start --full` shows them). `queue.focus_rule`, research/SCOPE_S220.md,
  CLAUDE.md s2 "FOCUS CAP". No branch deleted (339 unmerged stay - deleting is the operator's call).
- **Board attachments load (operator Q-S212-17 "attachment does not work"):** `agent_comms.py ask` copies any attachment outside the
  board's served roots (an E:/ review still) into AgentComms/board_attach/ and stores that path (26158d39).
- **Roof trusses see-through (operator: "can you make these beams transparent ?"):** GymLook2Shell trusses alpha 0.22 (data key
  truss.alpha), shadows kept, lamps opaque; gym_look2_shell_test checks it (red on the shipped file 4/114, green 114/114) (332d5b1e).
- **STATIONWEAR1D merged (Grok Dev PR #162, by diff, 7f7942d6):** a click pins the station card so SERVICE / REPLACE work (switch
  station_wear OFF). Merged on the operator's board yes Q-S219-2.
- **Defect fixed:** a club walker whose model had no "floor" animation library hit SCRIPT ERROR has_animation on null at
  advance_minutes; GymClub3D + GymHall3D now create the library (325078af; walk_ins 138/138).
- **Ludo rounds 56, 57, 57b:** r56 station wear "APPROVED WITH FIXES" (slower wear, 5 bands, SERVICE +50 capped 95, short boxing-only
  card) -> verdict LUDO_ROUND56_VERDICT_S220.md -> operator "Approve (recommended)". r57 New Career step 3 redesign (the real 3D club
  in the centre, drag/swap zones) -> r57b Ludo SAW the rejected screen (picture uploaded through Ask Ludo's own upload screen - method
  in memory reference_ludo_ai) -> verdict LUDO_ROUND57_VERDICT_S220.md -> operator "Approve, and add resize/rotate".

## Evidence
gym_look2_shell 114/114 (4 fails on the shipped file); station_card_pin 26/26; walk_ins 138/138; run_tests --jobs 2 --only
station,game_switches,gym_hall 15/0; stills opened by Claude: docs/previews/beams_s220/01, stationwear1d/01+02, walkers_s220/01.

## Delegated this session
Grok Dev STATIONWEAR1E (grok/stationwear1e, TASK_STATIONWEAR1E.md + item 8 ring overlap); cloud Cursor NEWCAREER3A (issue #163,
run 38455405674); Arena STORYPARITY1A relaunched in a NEW chat 01a136b7 (arena/1592cb88-fightcamp) - the S219 chat timed out twice
with nothing written. Still running from S219: Codex FLYFOOT1 (wt E:/FightCamp/wt/FLYFOOT1, 3 commits + WIP), Cursor PROFILE2E r11.

## Operator answers this session (verbatim)
Q-S212-16 "Approve all (recommended)"; Q-S212-17 "attachment does not work" (fixed); Q-S219-1 "Warm brown" (D47);
Q-S219-2 "Approve (recommended)"; Q-S220-1 "Approve, and add resize/rotate". Chat: "has ludo approved of this ?", "show me ther
picture here", "this screen is wrong ask ludo , it must represent the current gyms preview also ability to move zones etc",
"use the upload screen on ludo to check thispicture", "do you think the current workflow is correct ...", "act on this tighten the scope".

## Corrections made in chat
Claude first said the playable build was 6 weeks old (Builds/Windows/FightCamp.exe, 08-29); wrong file - the real export is
Builds/FightCamp_Godot/FightCamp.pck dated 10-11. Export the .pck at the end of the next stage that changes the game (GREEN only).

## HANDOFF
Next: collect FLYFOOT1 -> Codex seat TECHSTAGE1 FIX5 -> ANIMSOURCE1D -> KM3B -> PAIRLIVE1 -> SPLITFIGHT1; collect STATIONWEAR1E
(Grok Dev PR), NEWCAREER3A (cloud Cursor PR #163 - render stills at 1920x1080 story + open sandbox, Ludo upload review) then brief
NEWCAREER3B (drag/swap/resize/rotate/undo); collect STORYPARITY1A (Arena) -> 1B; PROFILE2E r11; GYMLOOK3A on the operator's OK.

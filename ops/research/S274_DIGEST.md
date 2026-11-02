# S274 DIGEST - 2026-10-20 - clips-only fight base, captured punches, footwork modules, gym day, attribute audit, playtest list

## Landed (master)
- bb2108dc Chrome fix: Chrome's main process had started on the hidden desktop (Ziva checkout link) - no_popups closes a
  browser whose window is on FightCampHidden.
- b82327f6 HOOKTIME1 (Cursor): rear hook 1.73 -> 1.00 s with game timing; as_game hang fixed. de7407cb JABRETRACT1 by Claude
  (Cursor's diff rejected: it switched mocap_pure off): retime asked of the PLANNED take; punch_retime_test arms by subject.
- Ailive hooks: cut, measured, REJECTED twice on the 20 s fight (kneeling lunge; then the arm loops) - c6723217; rokoko_clips
  hook + stance gates. Operator: motion from Rokoko + ActionForge; Ailive only footwork + duck/sway (Q-S273-3 "not bad").
- Q-S273-2 (operator on the same-seed A/B: "the right clip on the video is much better") -> clips_only_base fabfeef4 (fight
  session): bone-rewriting room layers off, captured punches play their full recovery, shuffle_from_bell kept.
- Footwork pure modules (Arena): StepPicker 295b4965, StepIntent dd77a3a7, FootContacts 4bb14365, StepRoot a8067d8b,
  GuardClock 3d9c7868; Ziva ZIVAGUARD1 f6e1a4fb (guard measured, step_library.json 11 entries - Rokoko takes ROOT-IN-PLACE).
  FOOTWORK_CONTRACT_S274.md. Wiring in progress in the fight session (captured_steps).
- Gym: station capture clips a5a2fe4f (defence drill = Ailive duck); GYMLOOP10 a23f78b7 + game-camera fixes b1f110e3 (drawer
  tucks, receipt rises, meters line wraps) - stills on the board, waiting for the operator's OK.
- fight_floating_text DEFAULT_OFF 57386723 ("no text on top of the fighters"); globe drag inverted 3430c954.
- Tools: open_agent_prs.py in the 30-min reconcile (Actions may not create PRs - operator setting offered), s274_gymday_stills,
  rokoko_path_probe af=/afcut=/trace af:. ANIM_TOOLKIT_S274.md (Godot 4.7 built-in IK modifiers; godot-motion-matching MIT).
- ActionForge: pose layers writable via URL hash (ACTIONFORGE_HOWTO_S247.md S274 section); Rokoko takes import fine there.
- Attribute audit: ko_leverage / damage_mitigation / trauma_threshold computed, never read -> Arena ATTRWIRE1.

## Operator playtest S274 (end of session) - NOT YET FIXED, verbatim, first work of S275
1. "i start a new game and i already see someone in the gym , this is not the loop i asked , i asked no fighters in the gym ,
   1 st fighter comes and then you prepare his training and watch him do it"
2. Roster card (MARA SOLANO) shows the OLD six stats (power/technique/speed/defence/stamina/ring IQ), not the 11 attributes.
3. Gym floor: "he is walking but not moving wtf ?"
4. "too many things overlap here" - Day Plan drawer + calendar drawer + "BOUT LOCKED" tag + news ticker on the right.
5. "how can i start a fight plan with out a fight wtf"
6. Camp setup "out of bounds" (screen shifted left, right side empty).
7. "the transition between the room is extremely bad , how 2point museum do it , why you stop ghidra the game until you have it
   fixed properly ?" -> study TPM's area transitions (memory reference_twopoint_museum_study: UnityPy, numbers only) and match.
8. Globe rotation inverted - DONE 3430c954.

## In flight
Cursor FOCUSPOP1 #300 (station focus icon pop-up); Arena FIGHTLINK2B (select_mult, sharpness A/B, windup trace) + ATTRWIRE1;
Ziva ROKOKOMOVES1 (guard takes + body cross/hooks from Rokoko, new chat); fight session local_e1f88114 (captured footwork
wiring + probe); John SQ8 (free studio-quality fight sounds, Q-S273-4 "free only but high quality"), SQ9 (body morph, PARKED).

## Operator playtest, last messages (diagnosed by Claude, NOT fixed) - items 9-10
9. "these icons are on the top at some other pictures i saw wtf happened" + the "1 NEW APPLICANT" chip over them.
   CAUSE (read in code): the S268 top bar (ui/GymTopBar.gd) only shows when a fighter is on the floor
   (GymHall3D._topbar_on needs `not _fighter_row.is_empty()`), and the S268 stills were taken on the club ALONE (no career shell).
   In the real game the shell's HUD V3 dock (ShellChrome BAR_ITEMS, a vertical column at x 16) is always drawn over the floor,
   and the hire chip sits at HIRE_CHIP_POS (18, 296) - right on that column.
   FIX: on the gym floor the top bar is ALWAYS on (no fighter = gym name + "no boxer yet"); the dock's pages (Home, Fighters,
   Scouting, Staff, Rankings, Finance, settings) become icon buttons in the top bar; the shell dock hides on the floor; the
   hire chip hides while the top bar's APPLICANT button carries the badge.
   Witness tool written: Godot/tools/s274_realfloor_stills.gd (REAL CareerRoot + training_floor route, as_game; seed=1 for
   one boxer) - run it red first.
10. "why the camera movement is not free and is locked behind the fighter".
   CAUSE: the floor camera has no pan at all - only 3 preset zooms (FLOOR_ZOOMS) and floor_close FOLLOWS the fighter
   (GymClub3D._follow_fighter); floor_view's target is fixed data. Q/E = 90-degree turns.
   FIX = Two Point Museum's camera (measured, E:\FightCamp\tmp\tpm_study\configs\Config_CameraLogic.asset.json):
   right-drag = grab pan (PanMouseButton 1; a right click without movement stays "train there"), middle-drag = rotate,
   pan keys 15 m/s scaled 0.5x-4x by zoom, CONTINUOUS wheel zoom (ZoomSpeed 0.55, smooth 0.10 s) toward the cursor,
   focal smooth 0.10 s (0.02 s while grabbing) + post-grab glide (damping 0.075 s), follow ONLY when the player asks
   (tracked object smooth 0.10 s; any pan breaks it), focal clamped to the building. Ours keeps FOV 17 + the 4 wall-cut yaws.
   Same answer for item 7 (room transitions): TPM has NO room mode - rooms are areas of one free camera; entering a room =
   the same camera glides there, front rooms always drawn (today floor_view hides the front block and _enter_room swaps
   camera mode, labels and HUD = the jump he sees). Put it in a new GAME_ON switch `free_camera`; plain tests = OFF arm.

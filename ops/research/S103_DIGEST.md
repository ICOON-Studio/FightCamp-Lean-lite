# S103 DIGEST - door corridor, THE PLANS on the left, Q205 held, fence pin assigned (2026-09-27, Claude)

Nightly cited: `AgentComms/nightly/latest.txt` - 2026-09-27 at 40bec39e, SUITE total=439 fails=24 (taken before S102's
re-pins; tonight's run is the first to include them). PC GREEN at start (C: 72.9 GB free, RAM 73%).

## Collected
- **Q205 (Qwen) NOT MERGED to the engine.** Census good (MMA clinch 2.5% of the clock vs G138 15-18%; the lever
  `MMA_CLINCH_ENGAGE_BASE` 0.0140 lifts it to 12.9%). Merge gate (`fight_realtime,grapple,fight_defence`, 14 tests):
  fails=4 = three nightly reds + NEW `fight_realtime_test` "MMA leg share in J20 band 12-18% (9.0%)". Control on master
  (FightRealtime.gd alone reverted): total=1 fails=0. Clinch time it adds throws no kicks. Census tools + digest (with the
  verdict) on master; the lever is carried into Q206, which branches from `qwen/q205-mma-state-share`.
- **C217 (Codex) held on its branch.** Kickback vendored (MIT, pinned), isolated Jolt project, OFF by default, engine
  hash identical ON/OFF, 200/200 controlled reactions on 3 rigs - but the LIVE-MOTION gate fails (1.15 m tracking error on
  a moving bout; MPFB knee short). Next: C218.
- **G140 (Grok)** one down / one up: 63.5% of KD fights end KO/TKO, KO stop 3.5 s mean (Hutchison), 55.5% same-round;
  7-row per-second machine + v1 acceptance lines. Saved condensed as `G140_ONE_DOWN_ONE_UP.md`.
- **D50 (Dola)** result screen: eye goes result -> cards -> THE READ; THE PLANS should be third. Applied (below).

## Built
- **Door corridor (operator bug: the tier-2 ring stood in front of the wing doors).** Decision: not re-seating stations
  (a tier-1/2 room is 5 cells deep and the 4x4 ring sits on the door wall - no seat exists), but a 1.5 m CORRIDOR along
  the door wall: `TrainingFloorLayout.DOOR_AISLE_M`, room_w = floor + corridor, stations start at `floor_x0`; saved
  cells never move. `door_walkways(doors)` = door width x 1.5 m (`DOOR_WALKWAY_M`, independent of the corridor so the
  control can fail). Back-wall decor and clock shift with the floor. Test `training_floor_3d_test` asserts no use zone
  enters a walkway on tiers 1-2 as drawn and on the tier 3-4 presets. **Control (corridor 0): 10 FAILs** - tier-1/2 ring
  in front of street/office/lockers, first aid, tier-3 cardio, tier-4 weights - i.e. exactly the operator's bug.
- **D50: THE PLANS in the left column** under THE CARDS, the two corners side by side, two lines each, when it ends
  above BACK HOME (a 3-round card); a long card grid keeps it in the right column. THE READ's "TIME AT BAND" -> "WHERE
  FOUGHT". `result_plan_card_test` covers both (3 rounds left, 12 rounds right).
- **reads_called 0 explained, not a game bug:** the game seats `limb_damage` (`FightNightScreen.gd:294`) and with it
  the corner minute that applies reads; S102's render tool did not. With it: the corner with reads called 4, landed 4.
- Tests here: training_floor, gym_wing, gym_floor, front_door, gym_decor, result_plan, result_screen, gym_hub - 9/9.

## Assigned / in flight
- Qwen **Q206** fence pin (`TASK_Q206_FENCE_PIN.md`) RUNNING, worktree `Temp/FightCamp-U171`, branch
  `qwen/q206-fence-pin`; bar: fight_realtime (leg share!), grapple, fight_defence, fight_ring_position no worse than master.
- Cursor **U191 rework** RUNNING, worktree `Temp/FightCamp-U158`, branch `cursor/u191-footwork-side-effects` (rebased);
  bar: fight_realtime, fight_defence_movement, fight_defence_model, fight_footwork - no red master lacks. Then C216, U192.
- Codex **C218** active ragdoll live motion - queued for the next free slot. Grok **G141** front headlock / turtle SENT
  (chat 6e3aa2b9-ca0b-4963-82bc-b4d8dda83979). Dola **D51** fresh eyes on the corridor SENT (fresh Cici chat).
- Launch note: `qwen_task.cmd`/`cursor_task.cmd` started the agents at NORMAL priority; set to Idle by hand. Launch via
  `Tools/agent_window.ps1` or set Idle after launch.

Renders: `previews/s103/` (tiers 1-4, result_plans_left.png); status deck tier slides updated (v11).

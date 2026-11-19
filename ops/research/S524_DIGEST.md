# S524 digest (2026-11-19, Opus)

## What now works
- Turning pro, the last menu (map M11): the week review says, for 4 weeks after signing, "Amateur cut lost $X; stipend
  saved $Y (N weeks since signing)", and the debut's week "Debut ledger - gym: share, costs, net" plus one NEXT lever.
- Guard damage v4 (his Q-275 yes), shown only: each side's guard (amateur 70, pro 80/100/120 by class) wears from the
  punches it blocks (GuardState from GuardWear's rules), the corner's minute gives 15 back; the HUD guard bar reads it;
  the result page shows "Punches blocked" and "Guard left at the last bell". Nothing changes a result yet.
- Knowledge v3 counts what the club sees of each new signing (mornings, nights, bouts, goals, stale causes); nothing
  shown - the screens wait for the K1 probe.

## Evidence
- Tests green: pro_week_lines (14), knowledge 17 / know_reads 15 / knowledge_keep 13, know_wire 10, guard_wear (135 checks,
  mutant cap 0.85 -> 4 red), guard_state 13, golden_path (checks the debut ledger), two_boxers_two_years, save_load,
  hud_shown, fight_meters, fight_stats, result_tabs, file_limits + 15 fight tests.
- Render: ops/previews/s524/result_numbers.png (review board) - WEAR_SCALE 0.45 emptied both guards in a normal amateur
  bout; 0.28 leaves 52% / 62% (yellow). Real screens ops/previews/s524/screens: GuideBubble fine (OFF FRAME is headless).
- knowbots_probe (KNOWBOTS3) on main: ORACLE 94, BLIND 90, READER 86 -> VOID; ORACLE was 101 on the same seeds in S463.

## Decided (Claude)
- Knowledge stops at step 2 until K1 passes (design s14); KNOWBOTS4 fixes the yardstick first.
- Guard ships shown-only; damage through it and its feedback wait for GUARDPROBE1 (control arms per step).
- The transmission multiplier is 1.0 + (100 - g)/100 (the design table; its text said 0.5 - Arena's catch).
- TURNPROBE1 moved from Qwen's queue to Goose (cloud); TREEVALUE2 run on the PC after Qwen's timeout.

## Delegated (live_runs.json)
Goose #379 KNOWBOTS4, #380 TURNPROBE1; Qwen GUARDPROBE1; Arena PROCONTRACT1 (blind contract test); FITPROBE1 queued;
Arena GUARDWEAR1 and Goose KNOWLEDGE1A collected; Ludo: four guard icons.

## Next
GUARDPROBE1 -> guard step 3; KNOWBOTS4 -> knowledge step 3 or back to design; TURNPROBE1 -> ProCall ESTIMATEs;
TREEVALUE2 -> StepEffect; PROCONTRACT1 -> merge / fix findings; FITPROBE1 to the next free seat.

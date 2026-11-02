# S160 DIGEST - 2026-10-04 - R16 behind a switch, NEAREST merged, READROUND built, gloves reopened

## Shipped
| What | Commit | Evidence |
|---|---|---|
| R16 (cut-off lead from gap/top_speed) behind switch `cut_off_derived`, now in `FightRealtime.DEMO_SWITCHES` (game ON, headless OFF) | a8616479 + READROUND commit | 10-04 nightly had 10 NEW reds; 8 (balance_state_wiring, contact_stop, defence_model, realtime, grapple_adapter, grapple_naming_contract, judge_panel, q226_strands) red at HEAD and green with d62f1e7f's hunk reverted (worktree E:/FightCamp/wt/R16REV). OFF hashes the pre-R16 strike_whole pins byte-identically; R16 pair kept as an ON arm; ring_position + corner_wired run with it ON. fight_plan_ai_corner back to its known pre-R16 MMA red. |
| PR #41 NEAREST merged (diff applied), PR closed | bb251a3c | technique_fidelity, strike_whole, footwork_route 3/3 on master; CI red was LFS-only |
| READROUND: scorebug stamina strips, this round's punches landed/thrown, a ticker line (clean/glancing/knockdown), knockdown pips (add_knockdown was never called before), SKIP TO THE BELL (4x until the break); dev readout + side panels hidden when it is on (`-- readout` keeps them); order chip text no longer cut in half | (this commit) | read_round_test PASS; real seed 16016 at 1:30 bug 4/14 10/19 == round_stats; mutant (no t_s cut) 4 FAIL; neighbours (read_round, fight_world_live, corner, menu_clarity, broadcast, strike_whole, ring_position, demo_slice) green except the known plan_ai_corner |
| Video to the operator | - | docs/previews/readround/readround_scorebug_40s.mp4 (trimmed before a 2 s crouch) |
| record_room `glove_log=1` | ccb9d260 | glove origin vs hand bone, cm per drawn frame |

## Operator (verbatim)
- "send me a video of the new scorebug"
- "fix the crouch too do you find the gloves on the picture normal ?"
- "is it really that hard to attach the gloves to the body? why you didnt pick this mistake ?"
- "you do not need to zoom, i didnt zoom either, its so obvious that the gloves look abnormal"
- "assign agents task and prepare next session"

## Measured, not fixed
- Gloves: origin == hand bone (0.0 cm, 50 s); the defect is orientation/size/no cuff + the bare hand left visible
  (seed 92012 t 43-45 s). TASK_GLOVES2 (Claude, next). The S155 stills tool now frames from inside the body.
- `FightBodyCapsules._fit_glove_parts` reads global transforms off-tree (8 errors per room) -> glove capsule from
  identity. TASK_GLOVEFIT on Arena (chat 01a1071a).
- Crouch: A folds to the floor 2 s at clock 2:17-2:14, no knockdown. TASK_CROUCH (Claude, next).
- PR #43 KM3 C223 A/B (Tools: E:/FightCamp/wt/km3_c223_ab.sh, worktree E:/FightCamp/wt/KM3PR) was STOPPED at 85 C RED
  to record the video - no report. Rerun detached when GREEN.

## Next
GLOVES2 first (operator-visible), then CROUCH, then the KM3 A/B, collect GLOVEFIT / NIGHTLY1B / NIGHTLY1C, rebuild
the .exe (READROUND + corner) and walk it as_game.

# S143 digest - status report, six agents on the operator's video asks, four send-backs fixed (Claude, 2026-10-02)

Request (operator, verbatim parts): "give me a status report ... are the animations fixed, what is missing for the boxing
palette ... where are we on the rooms ... why the animation in the video ... are broken ... make sure the Ops board is
updated. I want to see the new video working with everything on. With a new character models. The fix on the globes.
The fix on the footwork and sliding ... tell me if there are still mechanics that are not gated." Later: "check the
other videos yourself too before sending them", "fix them yourself", "option 3", "qwen and cursor are out of credits you
do the work", "control the pc load", and finally "the PC is going to crash. I have to restart."

## 1. What now works (each with its evidence)
| What | Evidence |
|---|---|
| Status report answered | `AgentComms/STATUS_S143.md` (sent): why the C240b video was broken (MPFB bodies - MetaHumans never wired; ball gloves; planted-foot slide p95 2.6 m/s; chest-to-chest overlap + 3 clipping moves), palette 26 certified / ~24 visible moves remaining, rooms done / film room unbuilt / 4 big venues uncommitted, 12 ungated switches |
| U208 tale of the tape: fixed + merged, **operator picked OPTION 3** | trunks repainted by CORNER (were by id hash: red corner in blue, blue in green); text ~1.5x; face-off names in their own band + head-to-waist camera; FightCamp bars inset clear of values. All three videos opened frame by frame, then sent. Merged as a diff `192e22bf` (tool, encoder, FighterPortrait skin fix, videos - NOT the 1,800 frame PNGs); portrait/tott tests 3/0. In-game build = TASK_U212 |
| C232 ring walkout: fixed + merged `4ad0e371` | The "folded/floating legs" bout was the Tripo control arm a `--script` run uses: `tools/s143_fold_probe.gd` - switches off: min hip-above-foot -0.55 m (fold); `as_game`: +0.6 m, no fold. Second defect found on the as_game re-record: walkout mounted the Tripo roster man, the ring the MPFB man - `WalkoutShot` now mounts `model_for_skin("generator")` + `apply_identity` when demo switches are on. walkout_venue_test 31/0; `E:/FightCamp/s143_c232b/northlight_as_game.mp4` opened: the same red-corner MPFB man walks out and fights. **Owed: `run_tests --only walkout,fight_night,venue` (interrupted).** |
| s119 live recorder derives the palette | was a hard-coded 5-id CERTIFIED list (palette is 25) -> read from certified_moves.json; `nocaption` for operator videos (the S140 pop-up video carried a debug strip) |
| Ops board current again | snapshot rebuild hung 45+ min: `subprocess.run(timeout=)` kills only the child on Windows, a git grandchild held the pipe. `run_cmd` now kills the process TREE (`taskkill /T`); board/triage timeouts 240 s |
| Sandboxed agents read real PC health | Codex's sandbox denies CIM -> watchdog read C_free=0GB RED -> Q213B run 1 stopped. Operator: "YOU DO THAT". `pc_watchdog -Once` falls back to the MAIN checkout's host reading when CIM is denied (<=10 min, GREEN/AMBER; stale/missing/RED = RED); tested both arms. Permission rules added to `.claude/settings.json` |
| PC load | `godot_hidden.ps1` now runs Godot at IDLE (it inherited AboveNormal from the Claude process); two known-hang tests C241 ran were stopped; at the operator's "PC is going to crash" every Godot/Codex/Grok process was stopped (CPU 10%) |
| D: activity explained | the ACTIVE pagefile is still `D:\pagefile.sys` (8 GB in use) - setting is "automatic" (C:) but the PC last booted 09-25; **the restart moves it** |

## 2. Agents - all STOPPED for the restart; every run's work is on a pushed branch (NOT reviewed, NOT merge-ready)
| Task | Branch @ checkpoint | State |
|---|---|---|
| C241 real glove mesh (Codex) | codex/c241-glove-asset @ bf8552af | 14 files incl. tools/c241_glove_capture*.gd; was running tests |
| MH2 MetaHuman boxers (Codex astra) | codex/mh2-metahuman-boxers-wip-s143 @ f5fed6c8 (remote branch has its run-1 lineage) | outfit guard strengthened, 4-boxer scripts; models/video/gates unfinished (MH2_DIGEST.md) |
| U211 slide by cause (Codex, moved off Cursor) | cursor/u211-footlock-by-cause @ 162b1bb1 | instrument + FightStepPlanner edits; was running 4 probes |
| Q213B last 3 clipping moves (Codex run 2) | codex/q213b-last-three @ 04151e0d | q213_clip_gate.gd edits; run 1 had stopped on the false sandbox RED |
| G158 tests for 12 ungated switches (Grok) | grok/g158-switch-gates @ 5923de78 | angle_guard + room tests written; switch_gate_room_test was running |
| G159 finish Q231 venues (Grok) | grok/g159-venues-finish @ bc32dcae | Qwen WIP committed, master merged in; the northlight capture HUNG 24 min (stopped) |
Qwen and Cursor: OUT OF CREDITS (operator) - out of rotation.

## 3. Send-backs that remain
- C231B inside uppercut: still chest to chest, glove arrives at the SIDE of the head at contact (0.45 s) - needs a Cascadeur re-author; withheld, not on the demo path.
- S140 hit-pop-up video: re-record from master with `nocaption` once Q213B/U211 land (crowding at 1:50/1:45).

## 4. Rules this stage earned
- **Check every video myself before it goes to the operator or is called "awaiting verdict"** (operator; memory feedback_check_videos_before_sending). 4 of 4 pending videos had visible defects.
- **A `--script` recording is the Tripo control arm, not the game** - pass `as_game` for anything the operator watches (C232's fold was this).
- **Chain the watchdog with `&&`, never `;`** - one render ran on a RED reading this session.
- **Never pkill by a command-line substring that your own shell also contains** - it killed this session's shell.
- **Another session can write route decisions while you work** - FOOTLOCK_U210 (14:17, idle session) contradicted U210; reconciled as SUPERSEDED. Check `git log` for foreign commits before handover.

## 5. Tests
walkout_venue_test 31/0 (headless, after both C232 edits); portrait/tale/tott 3/0; check_scripts on every touched .gd 0 fails;
opsboard `--selftest` only the pre-existing suite-data row fails (same before the change). Not run: the walkout/fight_night/venue
affected suite (interrupted).

## 6. Next (the decision)
After the restart: confirm the pagefile is on C: (`Get-CimInstance Win32_PageFileUsage`), watchdog GREEN, then
(1) run `python Godot/tools/run_tests.py --only walkout,fight_night,venue --jobs 2` for C232; (2) relaunch the six agents
ON THEIR CHECKPOINT BRANCHES in their worktrees (C241, MH2 from the -wip-s143 branch, U211, Q213B, G158, G159), at most
four at once, watchdog GREEN before each; (3) collect each as it lands, open its output, merge as a diff; (4) when C241 +
MH2 + U211 are merged, record the 20 s as_game live-room video (s119 recorder, `nocaption`), check it frame by frame, send it.

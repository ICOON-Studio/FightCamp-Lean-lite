# S142 digest - correcting stale measurements and a real ops-board bug (Claude, 2026-10-02)

Request (roadmap `now`, S141 handover): collect C241/U210/Q231, re-task freed seats, keep pushing the 10-06
demo. No code milestone shipped this session - this was a diagnosis-and-correction session: two stale
measurements that were blocking real progress with wrong numbers, one real recurring bug fixed, two in-flight
agent collections verified honest. Session ends here on the operator's request (model/effort switch to Opus
5.5 high next session).

## 1. What now works (each with its evidence)
| What | Evidence | Where |
|---|---|---|
| Ops board roster toggle actually sticks | Clicking a toggle wrote roster.json correctly (S120's fix), but the card grid renders from a SEPARATE `now[]` array baked in at the last full snapshot rebuild (17-32s later) - the page's own refresh() re-rendered from the stale copy right after the click, reverting it. Fixed in both places `now[]` goes stale: `save_roster()` and the cold-start disk-fallback path. Verified live: `curl -X POST .../api/roster` then `curl .../api/snapshot` shows the flip immediately, including right after a process restart. | Tools/opsboard/server.py `_patch_now_with_roster` |
| C223's "room adds 22deg extra tilt on the cross" (S136's next item) is already closed | `tools/s134_pose_probe.gd` on both anchor seeds (92012, 94301) reads boxing_cross p95=22/max=23 on both - matching the clip alone (22), not S136's measured 44. Apparently fixed as a side effect of S137-S141 work; not worth bisecting which commit, not on the critical path. | live probe output, this session |
| Clipping gate Q213 is at 23/26 (88%), not the roadmap's cached "FAIL 0%" | `godot --script tools/q213_clip_gate.gd -- mode=clips pin=1` on today's master: 23/26 moves PASS. Only boxing_one_two (8.84cm), boxing_rear_hook (11.25cm), boxing_shovel_hook (9.30cm) fail. The cached % predates the S125/S126/S130 clipping fixes. | live tool output, this session; TASK_Q213B written |
| CLINCH's (C240/C240b) halving-gate failure is diagnosed as a measurement bug | `Godot/tools/c240_overlap_census.gd`'s `run_bout` counts head/torso overlap over the WHOLE bout with no reference to `boxing_hold_active()` anywhere. C240's own single-bout excerpt already measured near-zero penetration (0.002m head, 0 torso) DURING the settled hold - the whole-bout failure (1,897->1,923 UP) likely mixes that with unrelated ordinary-exchange crowding after the two arms' RNG trajectories diverge at the first hold_engage event. | read of c240_overlap_census.gd, this session; TASK_C240C written, route_decisions.json C240 PARKED->RESUMED |
| A stale branch was correctly identified and NOT merged | `origin/qwen/q213-clipping-gate` looked like "the Q213 fix to merge" from the 64-unmerged-branches list, but master's `q213_clip_gate.gd` has since grown a `_pin` arm and `_where()` diagnostic the branch never got - merging it would have been a regression. Confirmed by diff before touching anything. | git diff master...origin/qwen/q213-clipping-gate |

## 2. What it looks like (taste - the operator judges)
Nothing visual shipped this session - this was measurement and infrastructure. The opsboard fix is only
visible as "the toggle now works without a page reload."

## 3. Rules this stage earned
- **A gate that counts a whole population when the feature only controls part of it will fail honestly for
  the wrong reason.** Found TWICE independently this session: CLINCH's overlap census (whole-bout, not
  windowed to hold-active frames) and FOOTLOCK's slide gate (Cursor's own finding: "s139 counts every low-foot
  frame in the bout... not footwork beats only" - a footwork-only fix cannot mathematically halve it). Worth a
  shared look next session: both gates need a windowed/bucketed re-measurement, not more tuning of the feature
  underneath them.
- **A roadmap assessment percentage is a snapshot, not a live value** - re-run the actual tool before trusting
  a cached "FAIL 0%"/"X%" line, especially one more than a few sessions old. Q213's cached figure was off by 88
  points.
- **Before merging "the obvious fix" off the unmerged-branches list, diff it against master first** - a branch
  can look like unfinished work that just needs landing when master has actually moved past it since the branch
  was cut.
- **A launch reporting a pid proves nothing** - confirmed twice this session (Codex's C241 first launch, this
  session's own exe-rebuild confusion with a stale python.exe already on the port): verify the actual child
  process exists (`Get-CimInstance Win32_Process`), not the launcher's own reported pid or exit code.
- **A scheduled task's "Status: Running" field is its LAST-RUN result, not its live Enabled/Disabled state** -
  use `schtasks /Query ... /V` and read "Scheduled Task State" specifically when verifying a disable/enable.
- **An empty .gd file in a worktree pops a native OS dialog on EVERY run** ("doesn't inherit SceneTree or
  MainLoop") - if an agent is mid-write on a new tool script and something re-runs it before it's finished, this
  recurs; kill the process by PID, do not edit a live agent's in-progress worktree file without asking first (a
  direct-write attempt there was correctly blocked by the permission classifier this session).

## 4. Collected this session
- **Codex C241** (real glove asset): still running at handover (codex.exe pid 27916, accumulating CPU, no
  output/commit yet beyond the task-file-only commit from its FIRST failed launch attempt).
- **Cursor U210** (FOOTLOCK planner-only): still running at handover (node pid 68604). Committed an honest WIP
  checkpoint (31217b12, fight_step_planner_test.gd 11/11 green) reporting the gate cannot be halved by a
  footwork-only fix alone - see section 3's shared-gate-flaw note.
- **Qwen Q231** (venues): DEAD, token-plan quota exhausted, reproduced directly. Operator ruling: continue
  without qwen. Marked OUT of rotation.

## 5. Tests
No engine code changed this session (opsboard fix is outside Godot; Q213/C240 work was measurement and task-
writing, not implementation). `python Godot/tools/check_scripts.py Tools/opsboard/server.py` N/A (Python, not
GDScript) - `python -c "import ast; ast.parse(...)"` used instead, and `python Tools/opsboard/server.py
--selftest` passed.

## 6. Next (the decision)
Collect C241 and U210 when they land (both still running). Launch TASK_Q213B (3 named clipping moves) and
TASK_C240C (windowed clinch overlap re-measurement) on whichever Codex seat frees first - both are fully
specified, ready to launch without further briefing. Consider a shared "windowed, not whole-bout" fix for
BOTH the CLINCH and FOOTLOCK gates once C240C's numbers are in, since the same flaw was found independently in
both this session. The .exe walk for the 10-06 demo remains blocked on FOOTLOCK/CLINCH landing - 4 days left
at session end.

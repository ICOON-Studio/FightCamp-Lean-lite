# S358 DIGEST (2026-11-02) - SMOOTH3 r4-r7: every jolt traced to its layer, no fix moved it, A/B film for the eye; E: disk; brief checks

Game commits: 3d7c8544 (worktree_retire covers Lean), 1237bc83 (brief checks, SMOOTH3 r4 verdict + round 5, disk list).
Lean: nothing new on main (332c069). No game code this session: every build item in `now` waits on an operator answer.

## Operator this session
- No board answers since S357. Open: Q-S294-78/80 (belt road), 84 (whiteboard tab), 85 (arts feed MMA), 86 (Miro top 5),
  87 (outside testers), NEW 88 (delete ~26 GB of our old folders on E:, list attached: DISK_E_S358.md).

## SMOOTH3 round 4 (Ziva, ziva/smooth3-r4 36f80cc) - NOT MERGED
Read from Ziva's arm logs myself (wt/ZIVA_LEAN docs/playtest/smooth3_r4/), not its marks. Main S356: plain 353/min, noreach 259.
r4: noreachin 332 (104 at a clip change), noreachout 359 (140), noreach 262 (88); plain VOID (no RAW line), nolean + nofade VOID
(rc=124 timeouts). hit_gap > 0.15 m 3 of 26 (main 1) - worse. New defect: PunchReach.gd:172 `Quaternion(g_hd.basis)` on a
SCALED bone basis -> "Basis must be normalized" every run (Ziva found the same and is fixing it with get_rotation_quaternion).
Key finding: with PunchReach fully OFF it is still 259-262 > 250, so no PunchReach-only fix can meet the bound. ROUND 5
(TASK_SMOOTH3.md): audit arm noreach+noglove first; stop if > 250 and name the next layer; Basis fix; VOID arms rerun.
inside_guard on r4: heads through each other 2 rest frames, 0 in the pocket.
Ziva 33de908 fixed the Basis bug, but its r4 result file re-quoted old numbers: smooth_probe prints the RAW line only after
replaying every clip post-fight, and its 300 s timeouts cut that off.

## SMOOTH3 round 5 (Ziva, same day) - NOT MERGED
Audit arm noreach+noglove **228/min (86)** - the bound is reachable with both layers off. plain 33de908 357 (140); Ziva's
GloveClear eased offset (cf3922e, dfe1790) 359 (141) = no gain, and glove deep in a head 7 of 657 vs main 1 (bound 4).
Five eased-fade rounds moved nothing -> the kinks are not at transitions. ROUND 6 = diagnosis only (queued 09:05): each kink
by layer + phase + the target's own jolt; hypothesis: the armed reach copies the moving head's hit-snap jolts into the glove.

## SMOOTH3 round 6 (diagnosis) - Claude, after Ziva stalled twice
Ziva reverted the r5 GloveClear commits, then ended two turns (09:11, 10:47) without a tool call at the probe edit. Claude wrote
the instrumentation (ziva/smooth3-r4 69ced03): every OURS kink by the layers on in its 3 frames, against the point-frames with
the same set. plain: OURS 341/min (631). Reach armed ~30 % of its frames kink (119), glove push ~13 % (~200), fade ~40 % (26),
HitSnap only 5 %, nothing on 1.5 % (238). The target's own jolt explains 32 of 119. docs/ziva/SMOOTH3_r6_diagnosis.md.

## SMOOTH3 round 7 - Claude, NO GAIN (reverted 35a4d7d)
Reach ramps 0.14/0.16 -> 0.24/0.26 s, the fade eases the reach's OFFSET over the live base (C1), GloveClear soft knee 0.04 ->
0.10 m: OURS 342/min (632) - nothing moved; the rates held while more frames carried each layer. Glove deep in a head 0 (main 1),
hit_gap > 0.15 m 3 of 26 (main 2). Why: the reach output base + w (target - base) carries -2 w' base' - a fast punch bent onto a
fixed point at any ramp length (a real glove stops on a face too).
Decided: no eighth round on the proxy. A/B film, same fight, game camera, 45 s: left = now, right = reach + glove push off
(smooth_probe `-- noraw secs=45`, 7ab8131) on /review S358 + Q-S294-89. "Same" closes SMOOTH3 and retires the 250 bound.

## Decided (Claude is the developer)
- worktree_retire.py now assesses the Lean repo's worktrees too (19 LEAN_* folders were invisible to the 30-min job) and
  retires MERGED clean worktrees after 1 h idle instead of 24 h; ZIVA_LEAN protected. First pass: 9 retired, 3.5 GB,
  E: 8.5 -> 12.1 GB. 8 held (dirty/unpushed): FIGHTCARD1, TRAINCLIPS1, GROUND3, BODYMAP1, BODYTRACK1, GYMBILLS1, PACEAIM1, BEFORE.
- agent_comms brief checks (human question, prefab, visual gate, prior research) skip briefs already answered (an
  `<ID>_<SEAT>.md` answer beside it) or `Status: CANCELLED|DONE|SUPERSEDED`; the visual gate skips `Kind: research|content`.
  The 4 defect lists `start` printed were all dead briefs - now empty. TASK_FLOORTPM1 marked CANCELLED (old Game repo).
- PC was RED at start (commit 2.1 GB free) from Ziva's own probes: no heavy job of mine beside them.

## Next (S359)
1. Q-S294-89 (SMOOTH3 A/B film): Same -> close SMOOTH3, merge only the r4 fade + Basis fix after a hit_gap check; Left worse ->
   round 8 retimes the clip to contact instead of blending its position; Right worse -> close, keep both layers.
2. Board answers: Q-S294-86 -> week-review reveal; Q-S294-78/80 -> belt road; Q-S294-87 -> outside testers; Q-S294-88 -> delete.
3. Kalli SQ25 (whiteboard review) when it lands.

## HANDOFF
Working commit: Game (this commit), Lean 332c069 (main), ziva/smooth3-r4 7ab8131 (pushed). In flight: Kalli SQ25. Ziva idle.

# S204 digest (2026-10-11) - collect day + Ludo takes on animation

## What now works (evidence opened by Claude)
- BOXER FOOTWORK (HUMAN2b, Codex sol da1a2d95, merged by diff 60fdbb11) behind switch `human_footwork` (default OFF): lead-first
  forward / rear-first back push-pull, 48 cm stride, 32 cm stance floor, ball-of-foot pivot. Benchmark STEP 2 PASS (hops 0, width
  0.45 m); OFF byte-identical (pose diff 0.0). On master: parse 6/0, human2_test fails=0, --only foot 9/0, bench1 1/0, anim_smooth 3/0.
  Stills docs/previews/human2 (game camera, both men framed) sent + on 8787/review. Evidence logs stay on codex/human2.
- PROFILELAYOUT1 (Qwen 4a9bdc26): profile screen geometry, profile_layout_test 9/0.
- PROFILETECH1 (Qwen 049844be): techniques tab data (7 branch groups, learned/next-to-learn, no invented fields), 22/0.

## Ludo round 38 - animation (operator S204: "If ludo can help in animation work use it (huge tasks)")
Prompt LUDO_ROUND38_ANIMATION_S204.md; replies reply1 24.2k + reply2 24.6k chars (sections 1-7 complete, 8 cut). Verdict
LUDO_ROUND38_VERDICT_S204.md on the board (Q-S203-2): intent bus -> punch S-curve + balance + fatigue/glove springs -> inside uppercut
+ new C224 gate. Nothing built before his OK.

## Decided (developer calls)
- Agent worktrees are REUSED per seat from now on (PROFILELAYOUT1 -> PROFILE2B, PROFILEFORM1 -> PROFILETECH1 via git worktree move +
  new branch) instead of a new 4.7 GB copy per task; E: is at 6.7 GB free. Removing the 37 finished ones asked on the board (Q-S203-1)
  because it deletes their scratch files.
- PROFILE2B moved from Codex to Cursor after Codex's sandbox got "Access is denied" on the Godot exe (queued CODEXSANDBOX1).
- Arena SCOUTFID1 asked to compile Godot from source; told no - write the files, CI and our PC run the test before merge.

## Sent back
- WEEKGRIDPANEL1 (Arena PR #116): 1430/1434 green but the panel lays out 7.6-8.4k px tall (must fit 1146x588) - new review chat
  01a12bcb, fix on the same branch.

## Traps this session
- codex_task.cmd takes prompt|out (2 args); qwen/cursor take prompt|workspace|out. A 3-arg Codex launch writes -o to the worktree dir.
- A new class_name from a PR needs `--headless --import` before its test compiles on master.
- Writing roadmap.json with indent=2 reformats 7.7k lines - it is indent=1, ensure_ascii=False.

## In flight at handover
Cursor PROFILE2B (pid 45608, wt PROFILE2B); Arena WEEKGRIDPANEL1 review (chat 01a12bcb); landed uncollected: NIGHTLY3 (8cc757e5),
SCOUTFID1 (PR #117). Delegated this session: Codex (HUMAN2b collect, PROFILE2B), Qwen (PROFILETECH1), Arena (SCOUTFID1 unblock,
WEEKGRIDPANEL1 + review), Cursor (PROFILE2B), Ludo (r38).

## HANDOFF
Next action = roadmap now.next_action (S204). Commit 60fdbb11 is the last working code commit.

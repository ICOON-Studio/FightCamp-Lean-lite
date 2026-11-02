---
name: feedback_worktree_per_agent
description: "Two agents editing the same file run in parallel only in separate git worktrees - and then measure the MERGE, because each branch's own table misses what the other moves"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e59fc87e-90ec-4fb6-9117-f1517e8e7314
  modified: 2026-09-21T15:12:46.609Z
---

**2026-09-13, S1f (2).** U80 (Cursor) and Q81 (Qwen) both edited `FightSimulation.gd` and both
swept a new constant by editing it in place. In the one shared checkout each would have measured
the other's half-finished edit. Given one worktree each, both delivered first pass in ~15 minutes.

**How to apply:**
- `git worktree add -b <agent>/<task> C:/Users/user/AppData/Local/Temp/FightCamp-<ID> master`
  (LFS smudges from the local store in ~9 s), then import once:
  `Godot_v4.7.2-stable_win64_console.exe --headless --import --path <worktree>/Godot` (~110 s).
  Skipping the import makes the first headless test hang like a parse error.
- Cursor: `--workspace <worktree>`. Qwen: launch from the worktree. **Codex cannot** -
  `Tools/codex_task.cmd` pins `-C` to the main checkout, so Codex gets the main checkout.
- Tell the agent its branch, to push the BRANCH, and never to checkout/merge/rebase. Tag
  `collected/<branch>` after merging; `git worktree remove --force` when spent.
- **Measure the merge, not only the branches.** Each passed alone; together MMA-thai finished 6
  where Q81 alone gave 2, and U80 alone had moved judo ippon 16 -> 29, which neither agent's table
  showed. `tools/measure_ground_seats.gd` takes 3 s - run base, each branch and the merge.
- Prove reds are pre-existing by running them against the base files checked out in a spare
  worktree (restore in `finally`), never by re-pinning.
- **Reuse a spent worktree for the next task** (2026-09-14: Q81 and U80 each ran two tasks): after
  the merge, `git -C <wt> checkout -b <agent>/<next> master` - no re-import unless assets changed
  (`git diff --name-only <old> master -- Godot/assets Godot/scenes`). But FIRST unstage the agent's
  last mail: `agent_comms.py send` stages it in that worktree's index and `checkout -b` carries it
  into the new branch (`git restore --staged -- AgentComms/messages/<file>`).

**2026-09-21, C150 — "in your worktree" is a BUG when the agent has no worktree.** A
blind-split task told Codex to write a scratch module to prove its mutants and never
commit it, phrased as "in your worktree". Codex is pinned to the MAIN checkout (above),
so the scratch landed at the module's REAL path — exactly where the blind implementation
was about to go — and the implementation author saw ten lines of it. It cleaned up and the
split still held, but **name the scratch path literally** (`/tmp/<name>.gd`, or a worktree
the agent actually has) in any task that asks an agent to fabricate a stand-in for the
thing it is testing blind.

**And an agent that branches leaves YOUR HEAD on its branch.** Codex committed C150 on top
of local master, branched there, pushed the branch and left the shared checkout on
`codex/c150-...`. `git diff --name-only master...origin/codex/...` then printed NOTHING,
which reads exactly like an agent that delivered nothing — it had delivered.
`git branch -a --contains <sha>` (the asterisk is the tell) and
`git rev-parse --abbrev-ref HEAD` are the two commands that untangle it.

Related: [[feedback_shared_checkout_head_moves]], [[feedback_shared_index_git_add_gotcha]],
[[feedback_run_the_instrument_on_the_old_tree_first]], [[feedback_ask_what_a_rule_is_for]],
[[feedback_prove_contract_tests_with_mutants]].

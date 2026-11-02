# TASK NIGHTLY1E - three nightly reds (2026-10-09 @f219ad5f, 599/7): home_pin_counts, stat_vocabulary, q226_strands

Model: Codex gpt-6-luna, medium (gpt-6.1-sol is refused on this ChatGPT account, S187). Worktree E:/FightCamp/wt/NIGHTLY1E, branch codex/nightly1e (from master). Commit + push the branch; do NOT merge to master.
Tier: scripts edited -> parse gate on each touched .gd, then each focused test, then `python Godot/tools/run_tests.py --jobs 2 --only home_pin --only stat_vocab --only q226 --only ui_kit`.
NEVER open a window, image viewer or browser (operator rule: nothing pops up on his screens). Headless Godot only via the NON-console exe:
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/<name>.gd` (never `_console.exe`).

## The three reds (read each test's own FAIL lines first - run it once on the unchanged branch and paste its output into your notes)
1. `Godot/tests/home_pin_counts_test.gd` (188 lines): the Office pin's Open button has no `tooltip_text`. The project rule (S164) is that
   tooltips go through `UIKit.tip(...)` because native tooltip_text is cleared by UserSettings. Decide from the code which is right: either
   UIKit.tip also sets a readable marker the test can check, or the test should read the UIKit.tip marker instead of tooltip_text.
   The fix must keep the test able to go RED when a button truly has no tip (prove it: remove the tip from that one button, test red, restore).
2. `Godot/tests/stat_vocabulary_test.gd` (260 lines): `Godot/scripts/UIKit.gd` ~line 4856 holds a stat-list literal that is not the canonical
   STAT_KEYS (came in with REC1 / offer_opponent_words). Fix the CODE to use the canonical keys (never widen the test's allow-list).
   UIKit.gd is huge: read it in `sed -n '4820,4900p'` windows, never whole.
3. `Godot/tests/q226_strands_test.gd` (95 lines): technique specialist share 29.5% vs a 29.9% floor. It was ALREADY red before PR #47 was
   reverted (S163), so it is an old drift, not a new bug. Find which commit moved it (`git log -S` on the threshold / run the test on a few
   older commits in a scratch worktree if cheap). Rule: NEVER loosen a band to go green without evidence. If the floor was set from one
   measured run with no margin, re-derive it from a census (>= 20 seeds, report mean + 95% CI) and set the floor below the CI with the
   derivation written in the test comment. If a real code change lowered technique's share, report the commit and stop - do not hide it.

## Prior research
S186_DIGEST.md names the three reds; S163 note in AgentComms/roadmap.json task NIGHTLY1 says q226_strands was red with #47 reverted too;
feedback rule: tooltips via UIKit.tip, not tooltip_text (S164).

## What would a human do?
Run each red test, read its exact message, fix the producer (code) not the gauge, and prove each gauge still reads worse.

## Prefab check
N/A - test and UI-kit maintenance.

## Owned files
- Godot/tests/home_pin_counts_test.gd
- Godot/tests/stat_vocabulary_test.gd
- Godot/tests/q226_strands_test.gd
- Godot/scripts/UIKit.gd (only the lines the fix needs)

## Trap
A `var x := <call>` that returns Variant is a parse error - type it. A parse error HANGS a headless test: always run
`python Godot/tools/check_scripts.py <file>` first.

## Done =
A pushed branch codex/nightly1e; the three tests green; the full output of each test and the mutant proof (red then green) in your last message.

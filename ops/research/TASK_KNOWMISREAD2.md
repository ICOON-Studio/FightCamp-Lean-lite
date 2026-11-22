# TASK KNOWMISREAD2 - size the shared misread on a sharper ruler (S538)

Model: claude-fable-5-2 (headless on the API credit, ops/Tools/sdk_run.py). Discipline: boxing (demo).
Measurement first; the only code change allowed is ONE constant (Knowledge.SHARED_MISREAD) + the bounds in its tests.

## Why (docs/KNOWMISREAD1_RESULT.md, Verdict + Next 1-2)
The shared misread is built (Knowledge.gd SHARED_MISREAD 0.5) and tested, but "knowing the truth" is worth +4.4 / +9.2 /
+7.9% (bound 9..14%) on three seed sets, and the ruler is coarse (4-8 boxers in ~90). KNOWLEDGE1 cannot go to critics on
that. DEPTH rule (owner S534): a choice stays only at 8 depth / 8 play; this is change 4 of DEPTH_SCOPE_S534.

## Do
1. Sharper ruler: the KNOWBOTS6 probe with the blind and the knowing signer on the SAME world (paired), 180+ worlds, the
   result with its own spread (mean and 95% interval of the paired difference). Keep its lever at 0 so the shown rating is
   what the game shows. Fix the bars BEFORE the run: worth in 9..14% with the interval's low end >= 7%.
2. On that ruler: SHARED_MISREAD at 0.5 (today), 0.65 and 0.8. Report mean |shown - true|, flop counts, worth and its
   interval for each.
3. If one value clears the bar with room: set it in scripts/rules/Knowledge.gd and move the bounds in tests/know_misread_test.gd
   (and any knowledge test that pins the old mean) - say each bound changed and why. If none clears: change nothing, report.
4. docs/KNOWMISREAD2_RESULT.md: the table, the verdict in one line, what KNOW_STAKES1 v6 should now say.
5. Tests: know_misread_test, knowledge_test, know_reads_test, know_wire_test, knowledge_keep_test, knowledge_shared_test,
   golden_path_test.

## Prior research
docs/KNOWMISREAD1_RESULT.md, docs/KNOWBOTS6_RESULT.md (if present, else git log --grep KNOWBOTS6), ops/research/DEPTH_SCOPE_S534.md.

## What would a human do?
A scout who has only seen a kid twice is wrong about him in a way the whole gym shares - everyone saw the same two sessions.

## Prefab check
None.

## Contract
OWNS: scripts/rules/Knowledge.gd (SHARED_MISREAD only), tests/know_misread_test.gd, tools/knowmisread2_probe.gd (new),
docs/KNOWMISREAD2_RESULT.md
RED_TEST: none (measurement; a constant change moves existing bounds)
REGRESSION: the seven tests in Do 5
VISUAL: no

## Rules
Work in main (no other job edits Knowledge.gd). Godot ONLY through `python ops/Tools/godot_slot.py run --who knowmisread2 --
<godot.exe> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://...`; long output to a file, one probe at a
time. No script over 500 lines. Commit only your paths (`git add -- <new>` then `git commit -m ... -- <paths>`), end with
`Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.

# C156 digest

Created `Godot/tests/ui_stat_row_contract_test.gd` as an implementation-blind contract witness for `UIKit.stat_row`.

The witness skips cleanly while `stat_row` is absent, and checks the live Control, exact height, three-column order, 55% bar width, right-aligned/tabular number, integer and float formatting, optional bar removal, clamping, and the UITokens spacing invariant.

The requested parse gate and one-test gate were run. The subject was absent, so the test reported `SKIP - UIKit.stat_row not present yet` and exited green. The four required scratch mutants were also exercised through the same test plumbing after an unmutated control; results: row height 28 caught by the exact-height check, 100% bar caught by the 55%-width check, left-aligned number caught by the alignment check, and `72.0` caught by the integer-format check. No `PATTERN-MISS` occurred.

The requested rebase could not run because the shared checkout already had unstaged changes; those changes were left untouched.

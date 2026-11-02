# U27 — CAREER PATH on the record tab

Owner: Cursor. Branch `cursor/career-path-row-cap-2363`.
`SUITE total=213 fails=1` (`grapple_contract_test.gd`, red by design).
`profile_revamp_test` 0 failures. `GRADE PROGRESSION checks=79 failures=0`.

## What shipped

R89's `career_path` now has a reader. `ProfileRevampPanel` calls
`get_career_path_read` once in `_read()`, draws a CAREER PATH frame on the
FIGHT RECORD tab, and does not touch `GameState.gd`.

- Empty path: no frame, layout unchanged.
- Newest first. Grade is a movement via `GradeLadder.words` (never `1st_dan`).
- The professional door is the heavy line and names the cause.
- Unknown `kind`: a quiet dated line, never a raw token.
- No champion / title / defence / reign word.

## The trap, measured

U16 sized a block from the data on this tab; at seven Grand Prix wins the
log and the numbers vanished because Godot clamps a negative size at zero.
Same input class, worse bound: a career path has no cap.

The frame is a budget (`CAREER_PATH_BLOCK_H := 132`). It sits on the **right**
under rivalries so the fight log keeps the height U17 left it. Rows derive
from the frame; the header carries the true count. It yields to a numbers
floor when Grand Prix has already pushed row 2 down.

Forty entries, measured:

```
rows_shown=2  true_count=40  log_h=224  numbers_h=84  path_h=132
```

Two entries still draw two rows. The boxing starter already carries a
career_path, which is why a left-column 132px block failed the existing
"the log lists the bouts" check on the first try.

# C141 held-position binding contract

The contract test treats each `PAIRED_BINDINGS` entry as a two-file binding. It
requires a positive playable `content_s`, requires `end_s - start_s` not to
exceed that content, and requires the attacker and victim filenames to use the
entry's `pair_key` stem with `_Att` and `_Vic` suffixes respectively. Entries
whose pair stem ends in `_Loop` declare a held position; those entries must
start at zero and have a window equal to the playable content so the window can
hand back to its first frame. Non-loop entries are not given that loop rule.

When either clip is absent, the test prints `SKIP <id> (no clip on disk)` and
does not fail the asset-dependent checks. When both are present, it loads the
FBX scenes and compares the longest animation duration in each scene.

## Verification

Parse gate:

```text
CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0 time=0s
```

The single Godot test ended with:

```text
skips=0
failures=0
```

All four required in-memory scratch mutants were caught:

- `window_exceeds_content`: reported the window exceeding `content_s` (and the
  deliberately inconsistent loop declaration).
- `att_vic_stems_differ`: reported the victim stem not matching `pair_key`.
- `zero_content`: reported non-positive content.
- `missing_content_field`: reported the missing `content_s` field.

The mutant diagnostics were isolated from the real result; the final test
result remained `failures=0`.

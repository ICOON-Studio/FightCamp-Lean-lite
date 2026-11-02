# C83 — FightClipSlice blind contract test

- Added `tests/fight_clip_slice_contract_test.gd`, written only from TASK_C83 and the named worked example.
- Module status: present. The asset yielded 3 windows with durations `0.640/0.400/0.640 s`.
- Equal-thirds trap: PASS; the windows are not arithmetic thirds of the 2.467 s clip.
- Boundary-rest: PASS; boundary/peak speed ratios were `0.305/0.399/0.571`, all below `0.60`.
- One-peak-each: PASS; every window held exactly one clear extension peak.
- Bones-move: PASS for every sliced animation.
- Slice contract: new animations, all 23 tracks retained, rebased lengths/keys, source unchanged.
- Binding compatibility: `jab`, `cross`, a hook role, and `strike_head` remain bound.
- Disagreement: each window adds `hand`, `peak_reach`, and `peak_t` beyond the contract's exact four keys.
- Disagreement: `jab` and `cross` metadata add `start_s` and `end_s` beyond the exact U39 shape.
- Parse gate: `CHECK total=1 fails=0`.
- Focused runtime gate: `TOTAL=59 fails=5`; all five failures are the two exact-shape disagreements above.
- No assertion was softened; no full suite or `--only fight` run.
- Fetch succeeded; rebase was blocked by shared unstaged WIP, but `HEAD...origin/master` was `0 0`.

# TASK Q99 — QWEN — WHERE DOES THE PLANTED FOOT'S SKATE COME FROM? R3's FRAMES SPLIT BY SOURCE

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`,
branch `qwen/q99-skate-sources` - Claude creates it from `master` before launch. Push the BRANCH.
Stage: S4a (the foot lock) - forecast measurement.

**Test tier: REPORT LINES ADDED TO ONE TEST, NO SCRIPT EDITED.** Parse gate on the test, then run it twice (before
your edit and after). No suite. `python research/Q99_check.py` must exit 0 before you commit. ONE Godot at a
time in your worktree.

## Owned files

- `Godot/tests/fight_stage_realism_test.gd` - ADD lines only. Never remove or change an existing line.
- `research/Q99_realism_baseline.txt` - NEW: the test's full output BEFORE your edit.
- `research/Q99_realism_run.txt` - NEW: the test's full output AFTER your edit.
- `research/Q99_R3_SOURCES.md` - NEW, 25 lines at most.

## Why this exists

The realism test's R3 (planted-foot skate) reads 0.172 m/s against a 0.10 bound. Claude is about to build a FOOT LOCK
and has to know which frames skate: during a JOIN between two takes (the 0.27 s inertialized blend), inside a STEADY
take (the clip's own feet sliding - dropped hip travel), during a WALK, or while the room SLIDES the whole body. Each
wants a different fix. Nobody has split it.

## What to read - ONLY these

`Godot/tests/fight_stage_realism_test.gd` (1,222 lines - never open it whole). Windows:
`sed -n '1,64p'` (constants), `sed -n '200,240p'` (`_sample`: `ctx["tl"]`, `ctx["tr"]`, `ctx["floor"]`, `ctx["root"]`,
`ctx["take"]`, `ctx["changed"]`), `sed -n '520,602p'` (`_rule_feet` - the R3 loop), `sed -n '1140,1175p'` (`_role_of`).

## Step 1 - the baseline, BEFORE any edit

From the worktree root:
`python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tests/fight_stage_realism_test.gd --timeout 900`
(about 1-2 minutes). Copy the log it names to `research/Q99_realism_baseline.txt`.

## Step 2 - the report lines (add to `_rule_feet`, printed right AFTER the R3b `_rule(...)` call)

For EXACTLY the frames `_rule_feet` appends to `skates` - same conditions, same foot, nothing added or dropped -
compute, with `f` the frame and `now_p` / `before_p` the positions R3 already uses:
- `total` = the value R3 appends to `skates`.
- `root` = `Vector2(root[f].x - root[f-1].x, root[f].z - root[f-1].z).length() * FPS`, `root` = `ctx["root"]`.
- `body` = the toe's speed RELATIVE to the root: `d = (now_p - root[f]) - (before_p - root[f-1])`,
  `Vector2(d.x, d.z).length() * FPS`.
- `bucket`, first match wins: `walk` if `take_list[f]` begins with `loc_`; `finished` if `take_list[f]` is empty;
  `join` if `ctx["changed"][k]` is true for ANY k in `[f - JOIN_FRAMES + 1, f]` (clamped at 0); else `take`.
  `JOIN_FRAMES = ceili(JOIN_S * FPS)` where `JOIN_S` is read from FightStagePlayer, NEVER typed:
  `(load("res://scripts/FightStagePlayer.gd") as GDScript).get_script_constant_map().get("INERTIA_INTO_STRIKE_S", -1.0)`.
- `role` = `_role_of(take_list[f])`, or `(finished clip)` when empty.

Print, exactly these formats (floats `%.3f`, share `%.3f`):
```
R3-SOURCE bucket | frames | share | mean_total_mps | mean_body_mps | mean_root_mps | max_root_mps
R3-SOURCE join | <n> | <share> | <t> | <b> | <r> | <max r>
R3-SOURCE take | ...
R3-SOURCE walk | ...
R3-SOURCE finished | ...
R3-SOURCE all | <N> | 1.000 | ...
R3-SOURCE-ROLE bucket | role | frames | mean_total_mps | mean_body_mps | sum_total_mps
```
then per bucket (join, take, walk, finished order) its top 6 roles by `sum_total` (sum of `total`), descending:
`R3-SOURCE-ROLE <bucket> | <role> | <frames> | <mean total> | <mean body> | <sum total>`. A bucket with no frames
prints its `R3-SOURCE` row with zeros and no role rows.

## Step 3 - the run AFTER the edit

Parse gate `python Godot/tools/check_scripts.py Godot/tests/fight_stage_realism_test.gd`, then the same godot_run.py
command; copy the log to `research/Q99_realism_run.txt`.

## The digest `Q99_R3_SOURCES.md`

Opens with `## DECISIONS`. The five `R3-SOURCE` rows as a table; one line naming the bucket that holds the most
`sum_total`; one line naming the three roles with the most `sum_total` overall. Population line: the realism test's
own (3 seeds, 3 rounds, out-boxer (A) v pressure puncher (B), the room's demo pair) - copy it from the run output.

## Commit

`git status -s` first. Commit ONLY the four owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin qwen/q99-skate-sources`;
`python Tools/agent_comms.py send --from qwen --to claude --topic "Q99 ready" --body "<hash>"`. Do not edit HANDOFF.md.
Never `git stash`, `reset`, `checkout .`, `clean`, `rebase` or `merge`.

## The trap

The buckets must add up to R3 EXACTLY: `all` frames equal R3's `over N planted frames` and `all` mean_total equals
R3's `mean` to three decimals. If they do not, you counted frames R3 does not count (or skipped some) - the check
tests exactly this, and that every RULE and `measured:` line is byte-identical between the two runs.

# TASK Q93 — QWEN — WHY THE ENGINE'S BOXERS NEVER CLINCH

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`,
branch `qwen/q93-clinch` - already created from `origin/master` for you. Push the BRANCH.
Stage: Stage A realism - forecast research for a finding.

**Test tier: RESEARCH, no `.gd` touched. NO Godot run at all** (another agent is using the CPU). Reading source and
writing two files is the whole job; `Q93_check.py` is the gate.

## Owned files

- `research/Q93_clinch_paths.json` - NEW, yours.
- `research/Q93_WHY_BOXERS_NEVER_CLINCH.md` - NEW, yours, 30 lines at most.

## Why this exists

Real elite boxers clinch 2.5-4.8 times a round for 12.6-28.7 s of it - about 10% of round time (our K38, Davis et al.
2015); UFC fighters about 13%. Our realtime engine, on legal differently-styled pairs, clinches **0.000** of the time in
boxing and kickboxing, 1.9% in muay thai and 1.8% in MMA (our Q90). Before anyone changes it we need the map: how a
bout gets INTO the clinch, and why a boxing bout never does.

## What to read - ONLY these

- `Godot/scripts/FightRealtime.gd` (~2,700 lines - NEVER open it whole). Start with
  `grep -n '_move_seat(\|"clinch"\|clinch_engage\|grapple_arsenal\|ruleset_id' Godot/scripts/FightRealtime.gd` and read a
  `sed -n 'A,Bp'` window of about 60 lines above and 10 below each clinch hit. `_move_seat` calls span several lines:
  the FIFTH argument is the stance it moves to.
- `Godot/scripts/FightMoves.gd`: `grapple_arsenal`, `grapple_moves_for`, `grapple_move_from_node` and `disciplines_for`
  only (grep each, read the function).
- `Godot/scripts/GrappleResolve.gd` / `GrappleSeat.gd`: only the functions the clinch site calls.
- `Godot/assets/data/combat_rulesets.json`: the boxing, kickboxing, muay_thai and mma entries.
- `Godot/assets/data/technique_catalog.json`: to find which nodes become clinch-phase grapple moves (search it with
  Python or grep; never open 700 KB by eye).

## What to write

`research/Q93_clinch_paths.json`:
- `sites`: one row per place the engine enters or attempts the clinch - `file`, `line` (where the call starts),
  `quote` (a short piece of that exact line), `gate` (`"none"` or a short piece of exact code within 25 lines ABOVE
  that allows or blocks it), `what` (one sentence).
- `rulesets`: for each of `boxing`, `kickboxing`, `muay_thai`, `mma` - `discipline_tags` (exactly as in
  combat_rulesets.json), `clinch_nodes` (the catalogue node ids that become clinch-phase grapple moves for that ruleset's
  disciplines), and `why` (one or two sentences: why this ruleset's fighters do or do not reach the clinch).

`research/Q93_WHY_BOXERS_NEVER_CLINCH.md` opens with `## DECISIONS`: a table of the sites; a table ruleset |
disciplines | clinch-phase moves (count and ids) | why; one paragraph on what a boxing clinch would need to exist at all
(which move, which site, which gate). No fix, no code.

## Gate

`python research/Q93_check.py` must exit 0 - it derives every clinch entry from the source, checks every quote,
gate and catalogue id against the files, and your discipline tags against combat_rulesets.json. Fix your JSON from the
SOURCE if it fails; never edit the check.

## Commit

`git status -s` first. Commit ONLY your two files, paths on the commit line; `git show --stat HEAD`;
`git push -u origin qwen/q93-clinch`; `python Tools/agent_comms.py send --from qwen --to claude --topic "Q93 ready" --body "<hash>"`.
Do not edit `HANDOFF.md`.

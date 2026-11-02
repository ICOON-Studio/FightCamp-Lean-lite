# TASK Q91 — QWEN — EVERY DOOR TO THE FLOOR: WHERE THE ENGINE PUTS A BOUT ON THE GROUND, AND WHAT RULESET IS ASKED

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`,
branch `qwen/q91-ground-paths` - already created from `origin/master` for you. Push the BRANCH.
Stage: Stage A correctness - forecast research for the fix Q90 and K36 call for.

**Test tier: RESEARCH, no `.gd` touched. NO Godot run at all** (another agent is using the CPU). Reading source and
writing two files is the whole job; `git status -s` before staging is the whole check besides `Q91_check.py`.

## Owned files

- `research/Q91_ground_paths.json` - NEW, yours.
- `research/Q91_GROUND_PATHS.md` - NEW, yours, 30 lines at most.

## Why this exists

Muay thai, kickboxing, boxing, karate and taekwondo have no ground fighting and no submissions (our K36, rule text
by rule text). Our realtime engine reaches the ground in 22 of 60 legal muay thai bouts and can finish one by
submission (our Q90). Before anyone writes the fix, we need the map: every place in the engine that sends a bout to
the ground, opens a submission or finishes one - and whether anything there asks which ruleset the bout is under.

## What to read - ONLY these

- `Godot/scripts/FightRealtime.gd` is ~2,540 lines - NEVER open it whole. Find the sites with
  `grep -n "_move_seat(\|sub_open\"\] = true\|_finish_submission(\|ruleset_id\|grapple_arsenal" Godot/scripts/FightRealtime.gd`
  and read a `sed -n 'A,Bp'` window of about 40 lines above and 10 below each hit. `_move_seat` calls span several
  lines: the FIFTH argument is the stance it moves to.
- `Godot/scripts/GrappleSeat.gd`, `Godot/scripts/GrappleResolve.gd`, `Godot/scripts/GrappleAdapter.gd` - grep them
  for `ground`, `ruleset`, `submission`, `takedown`, `throw`, `sweep`; read only the functions the engine's sites call.
- `Godot/scripts/FightMoves.gd` - only `grapple_arsenal` and whatever it calls to decide a ruleset's grapple palette.
- `Godot/assets/data/combat_rulesets.json` - the muay_thai, kickboxing and boxing entries.

## What to write

`research/Q91_ground_paths.json`: `{"rows": [ {...}, ... ]}`, one row per site, each with exactly:
- `kind`: `"ground_entry"` (a `_move_seat` whose to_stance is `"ground"`), `"submission_open"`,
  `"submission_finish"`, or `"palette"` (a place that decides which grapple techniques a ruleset may use);
- `file`: e.g. `"Godot/scripts/FightRealtime.gd"`; `line`: the line the call starts on;
- `quote`: a short piece of that exact line (it is checked against the file);
- `via`: for a ground entry, the via word (`takedown`, `throw`, `sweep`, `escape`, ...); else `""`;
- `gate`: `"none"`, or a short piece of the exact code within 25 lines ABOVE the site that stops or allows it by
  ruleset (e.g. a `ruleset_id` comparison) - checked against the file;
- `what`: one sentence - what happens at that site and what reaches it.

`research/Q91_GROUND_PATHS.md` opens with `## DECISIONS`: a table kind | file:line | via | gate | what; then
one paragraph on how a muay thai bout reaches the floor today (which palette technique, which site), and one
paragraph listing the sites a ruleset check would have to cover. No fix, no code.

## Gate

`python research/Q91_check.py` must exit 0. It DERIVES every ground entry and submission site from the source
itself and fails on any site with no row and on any quote or gate that is not really in the file. If it fails, fix
your JSON from the SOURCE - never edit the check.

## Commit

`git status -s` first. Commit ONLY your two files, with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin qwen/q91-ground-paths`; then
`python Tools/agent_comms.py send --from qwen --to claude --topic "Q91 ready" --body "<hash>"`. Do not edit `HANDOFF.md`.

## The trap

Line numbers: cite the line in YOUR checkout's file - the check reads the same file you did. And a `_move_seat`
whose stance argument is `"standing"` or `"clinch"` is not a ground entry.

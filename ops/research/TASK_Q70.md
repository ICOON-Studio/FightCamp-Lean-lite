# TASK Q70 - QWEN - WHERE EACH KICK LANDS: THE ADJUDICATED TARGET TABLE S2 WILL APPLY

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GATE AT ALL.** Not the parse gate,
not a test. **Do NOT start Godot, for any reason**: Claude is running S1d's test
subsets in this same checkout and only one Godot may run here at a time. Every
number in this task comes from reading JSON and code with Python and `grep`.

## Owned files

- `research/Q70_KICK_TARGETS.md` - **NEW, yours alone.**
- `research/Q70_kick_targets.json` - **NEW, yours alone.**

Nothing else. **Do NOT edit `technique_catalog.json`, any script, `HANDOFF.md`
or `AgentComms/roadmap.json`.** S2 applies your table one discipline per commit;
this task only produces the table.

## Why this exists

R137 (`research/R137_THE_KICKS_CANNOT_REACH_THE_LEGS.md` - read sections
"WHY", "HOW MANY KICKS THIS CATCHES", "WHAT IT WOULD TAKE TO FIX" and "WHAT STILL
STANDS"; skip the rest) found that **70 of 107 kicks carry no locational effect
key**, so the live resolver cannot send them to a leg. Its preferred fix is
**option 3: tag the kicks properly in the catalogue** - and that is a CONTENT
call made technique by technique, which is exactly what S2 must not have to stop
and research. You are doing that research now, before S2 starts.

## The two resolvers you must describe (read ONLY these windows)

- `Godot/scripts/FightSimulation.gd` is 3,292 lines - **never open it whole.**
  `sed -n '2153,2250p'`: `_technique_target_region` scores effect keys **by
  substring** (`head`, `leg`, `body`/`liver`/`torso`, `arm`/`shoulder`) and falls
  through to `_pick_target_region` (`:2223`), whose `damage`/`counter` draw is
  head 45 / torso 35 / arm 10 / arm 10 - **no leg branch.**
- `Godot/scripts/FightMoves.gd` - `sed -n '430,470p'` (where `region_weights`
  comes from), `sed -n '556,575p'` (`move_from_node`), `sed -n '611,700p'`
  (`_regions_for`: only EXPLICIT keys move a technique - `head_damage`,
  `body_damage`/`clinch_damage`/`ground_damage`, `leg_damage`/`lowline_damage`,
  and `kick_damage` gets the ruleset's spread WITH legs).

Two consumers, two different vocabularies for the same question. Say so in the
report, with the line numbers.

## Scope - four parts

**1. The kick census.** From `Godot/assets/data/technique_catalog.json` (696
nodes; nodes live under `disciplines[].nodes[]`, the discipline id is the parent's
`id`). **Write your kick criterion down in the report** and reconcile your count
against R137's 107. If you get a different number, list the nodes that differ
and say which classifier is right about each - two classifiers disagreeing
silently is the exact defect class this project keeps paying for.

**2. The adjudication - one row per kick with no locational key.** For each:
`id`, `discipline`, `effects` as authored, what `_technique_target_region`
does with it TODAY (`head` / `body` / `leg` / `arm` / `DRAW`), what
`FightMoves._regions_for` does TODAY (`head` / `body` / `leg` / `spread` /
`ruleset_default`), and then **your adjudication**: where this technique lands
in the sport it comes from - `head`, `body`, `leg`, or `spread` (a roundhouse
genuinely goes head, body or leg). Give `confidence` (high / medium / low) and a
one-line `reason` naming the technique as that sport defines it (a teep is a
push kick to the midsection; a WT taekwondo kick below the belt is a foul).
**Low confidence is a legitimate answer - write it rather than guessing high.**

**3. The blast radius.** Every reader of the keys a fix would add or change:
`grep -rn` for `kick_damage`, `leg_damage`, `head_damage`, `body_damage`,
`lowline_damage` across `Godot/scripts`, `Godot/tests`, `Godot/tools`. One line
per site: file:line, what it does with the key. S2 has to choose between adding
a key and renaming one, and this list is what decides it.

**4. The arm mystery - R137 left it open.** `_pick_target_region` has a 20% arm
branch, yet R137 measured **zero** strikes of any kind landing on an arm. From
code alone, trace what happens to `left_arm` / `right_arm` after it is returned
and find where it disappears (or show that the branch cannot be reached). Quote
the lines. **If you cannot find it from code, say so plainly** - do not run a
bout to find out.

## The JSON file

`Q70_kick_targets.json`: `{"catalogue_commit": "<git rev-parse --short HEAD>",
"kick_criterion": "...", "kicks_total": n, "unlocated": n, "rows": [ {id,
discipline, effects, sim_today, moves_today, target, confidence, reason} ]}`.
Rows sorted by discipline, then id. This is the file S2's apply tool will read,
so the field names above are a CONTRACT - exact spelling.

## THE TRAP

**The substring resolver already mis-files techniques that are not strikes at
all**: `leg_attack` (a BJJ or sambo LEGLOCK) contains `leg`, and
`front_headlock_open` contains `head`. A kick classifier built from id or effect
substrings inherits those errors. **Classify by what the technique is, and never
propose a substring rule as the fix** - R137 calls the substring matcher a
workaround for missing data, and S2 exists to replace it, not extend it.

And name your catalogue: the first line of the report states the commit hash of
the `technique_catalog.json` you read. A table without its data version is the
R137 fixture mistake over again.

## Done

- THIS CHECKOUT IS SHARED WITH A LIVE CLAUDE SESSION. Stay on `master`. **Never**
  run `git checkout`, `git switch`, `git branch`, `git stash`, `git reset`,
  `git clean` or `git add -A`.
- `git status -s` first. Commit ONLY your two paths, path-limited so nothing
  else staged can be swept in:
  `git add -- research/Q70_KICK_TARGETS.md research/Q70_kick_targets.json`
  then `git commit -m "Q70: ..." -- research/Q70_KICK_TARGETS.md research/Q70_kick_targets.json`
  ending the message with `Co-Authored-By: Qwen <noreply@qwen.ai>`.
- **Do NOT pull, rebase or push.** Claude has uncommitted work in this tree and a
  `pull --rebase` here can stash it away - that wiped a finished stage on
  2026-09-07. Leave your commit on local `master`; Claude pushes it.
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --topic Q70-done --body "<hash> kicks=<n> unlocated=<n> leg=<n> body=<n> head=<n> spread=<n> low_conf=<n> arm_mystery=<found|not_found>"`
- Do NOT edit `HANDOFF.md`.

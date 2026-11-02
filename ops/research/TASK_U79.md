# TASK U79 - CURSOR - ONLY A BLOW LANDS: FOOTWORK THE REALTIME ENGINE THROWS AS A STRIKE

Model: Composer, **medium effort**. Owner: cursor. Launched `-p --force --trust`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Claude is running S2's test
subsets in this checkout and only one Godot may run at a time. Your gate is a Python
script that MUST exit 0.

## Owned files

- `research/U79_admitted_strikes.json` - **NEW, yours alone.**
- `research/U79_ONLY_A_BLOW_LANDS.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, data file, `U79_check.py`, `HANDOFF.md` or
`AgentComms/roadmap.json`.

## Why this exists

S2 measured where strikes land in the realtime engine, technique by technique
(`tools/measure_ruleset_sweep.gd -- detail`, commit `acfa4a8`), and found strikes that are
not strikes. In 24 boxing bouts `boxing_distance_read` LANDED 877 times, `boxing_step_in_out`
369, `boxing_circle_rear` 365 and `boxing_circle_lead` 336 - on heads and bodies, like
punches. About a fifth of boxing's landed total is footwork; kickboxing has the same
(`kickboxing_switch_step_read` 404). That inflates pace, the target mix, scoring and every
landed-strike count, and it is invisible in a green suite.

The cause is the admission rule in `FightMoves.move_from_node`: any node whose role is in
`STRIKE_ROLES` and which carries none of `GRAPPLE_EFFECTS` becomes a throwable strike. The
comment above `GRAPPLE_EFFECTS` records the same defect caught once already for
duck-unders and sprawls. Footwork was never caught.

**The adjudication largely exists.** Qwen's `research/Q70_kick_targets.json`
(`census`, `is_kick`) and `research/Q77_strike_targets.json` (`rows`, `is_strike`)
judged 326 standing-strike candidates. This task covers EVERY node the rule admits for
the four realtime rulesets, reuses those verdicts, and adjudicates the rest.

## Where things are (windows only)

- `Godot/scripts/FightMoves.gd` (1,138 lines - never open it whole): `sed -n '80,130p'`
  (`STRIKE_ROLES`, `POWER_ROLES`, `GRAPPLE_EFFECTS` and why), `sed -n '205,235p'`
  (disciplines per ruleset), `sed -n '300,330p'` (`DEFAULT_ARSENAL_MAX_TIER`), `sed -n
  '537,615p'` (`moves_for`, `move_from_node`, `_stances_for`).
- The four realtime rulesets: `Godot/scripts/FightNightScreen.gd`, `grep -n
  REALTIME_RULESET_IDS`; their `discipline_tags` in `Godot/assets/data/combat_rulesets.json`.
- The catalogue: `Godot/assets/data/technique_catalog.json` (670 KB - Python only).

## Scope

**1. The JSON** `{"rows": [...]}` - one row per node the admission rule admits for boxing,
kickboxing, muay thai or MMA (the gate derives the same set: role in `STRIKE_ROLES`, no
`GRAPPLE_EFFECTS` key, at least one phase, not weapon-only): `id`, `discipline`, `tier`,
`role`, `effects` (from the catalogue), `delivers_blow` (true / false), `reason` (one
line), `source` - `Q70` or `Q77` when you took their verdict (`is_kick: true` or
`is_strike`), `U79` when you adjudicated it yourself. A read, a feint with no contact, a
step, a circle, a guard or a pivot delivers no blow; a counter that hits does.

**2. The report** `U79_ONLY_A_BLOW_LANDS.md`, with sections:

- **THE ADMISSION RULE** - quoted, with line numbers, and why `GRAPPLE_EFFECTS` cannot be
  stretched to cover footwork (which keys the non-blows carry, and which real strikes
  carry the same keys).
- **DEFAULT ARSENAL** - which non-blows are tier 1-2, so every generated opponent and
  every seeded test fighter throws them.
- **WHAT CHANGES** - for each realtime ruleset, the non-blows' share of its admitted
  nodes, and what removing them would move: landed counts, pace against J20's ~6-8
  landed per minute combined (`research/J20_THE_VALIDATION_CORPUS.md` - grep it),
  the target mix, scorecards. INFERENCE, labelled - you are not running bouts.
- **OPTIONS** - at least: (a) an authored `match` field that says a node delivers a
  blow, read by `move_from_node`; (b) a second refusal list beside `GRAPPLE_EFFECTS`
  for footwork keys; (c) change those nodes' roles. Consequences of each (what else reads
  the role; which seeded tests would move); recommend one. **Do NOT build it.**
- Name every row where you overrule Q70 or Q77, and why.

## THE TRAP

**An effect key is not a verdict.** `range_control` sits on `boxing_jab` (a punch) and on
`boxing_distance_read` (a read); `mobility` sits on `boxing_check_hook_pivot` (a hook) and on
`boxing_circle_lead` (a step). A key-based rule is exactly what let these through. Judge each node by
what it IS, then say in OPTIONS whether any key rule could reproduce your verdicts - and
count how many it would get wrong.

## The gate

    python research/U79_check.py

It parses `STRIKE_ROLES`, `GRAPPLE_EFFECTS` and the alias table from the code, derives the
admitted set, checks coverage, the catalogue columns, anchors and the sections. It fails
now because your files do not exist. **Fix YOUR FILES, never the checker.**

## Done

- Stay on `master`; no branch. **Never** `git checkout`, `switch`, `branch`, `stash`,
  `reset`, `clean`, `add -A`, `pull` or `push`.
- `git status -s` first. Commit exactly your two paths, ON the commit line:
  `git add -- research/U79_admitted_strikes.json research/U79_ONLY_A_BLOW_LANDS.md`
  then `git commit -m "U79: ..." -- research/U79_admitted_strikes.json research/U79_ONLY_A_BLOW_LANDS.md`
  ending `Co-Authored-By: Cursor <noreply@cursor.com>`.
  Then `git show --stat HEAD` must list exactly those two files. **Do not push.**
- Mail: `python Tools/agent_comms.py send --from cursor --to claude --topic U79-done --body "<hash> admitted=<n> blows=<n> not_blows=<n> tier12_not_blows=<n> overrules=<n> recommend=<a|b|c> check=exit0"`
- Do NOT edit `HANDOFF.md`.

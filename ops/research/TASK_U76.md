# TASK U76 - CURSOR - WHICH REGIONS EACH STRIKING DEFENCE ANSWERS

Model: Composer, **medium effort**. Owner: cursor. Launched `-p --force --trust`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Claude is running S2's test
subsets in this checkout and only one Godot may run at a time. Your gate is a Python
script that MUST exit 0.

## Owned files

- `research/U76_defence_regions.json` - **NEW, yours alone.**
- `research/U76_DEFENCE_BY_REGION.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, the catalogue, the vocabulary, `U76_check.py`,
`HANDOFF.md` or `AgentComms/roadmap.json`.

## Why this exists

S1e found that one `wrestling_sprawl` stopped jabs: every defence a man knew counted
against every incoming action. The fix was to author WHAT each defence answers
(`defense_answers` in `Godot/assets/data/technique_vocabulary.json`: strike, takedown,
control...). **S2 now gives every kick an explicit TARGET** - head, body or leg - and the
MMA leg share is about to rise from ~8% toward J20's 14-18%. The same defect waits one
level down: **a boxing slip currently answers a leg kick**, and a kick check answers a
jab, because a strike defence knows the class of what is coming and not where it is
going. You are adjudicating the answer before that stage is built.

## Where things are (read only these)

- The nodes: every node in `Godot/assets/data/technique_catalog.json` (670 KB - never
  open it whole; load it with Python; nodes under `disciplines[].nodes[]`) whose
  `match.role` is `defense` AND which carries at least one effect key whose
  `defense_answers` entry includes `strike`. The gate derives the same list.
- `Godot/scripts/FightSimulation.gd` (3,489 lines - never open it whole):
  `sed -n '1425,1480p'` (where the defence factor is taken and, AFTER it, where the
  target region is chosen) and `sed -n '2595,2630p'` (`_defender_defense_factor`,
  `_defense_answers`).
- `Godot/scripts/FightRealtime.gd` (2,535 lines): `sed -n '1540,1565p'` (the region is
  chosen) and `sed -n '1625,1650p'` (the defender's guards answer).
- `Godot/scripts/FightMoves.gd` (1,138 lines): `sed -n '860,1000p'` (`GUARD_KINDS`,
  `guard_arsenal`, `answering_guards`).

## Scope

**1. One row per striking defence node.** `id`, `discipline`, `phases`, `effects` (copied
from the catalogue as authored), `answers` - the target regions this defence genuinely
answers: a non-empty list from `head`, `body`, `leg` - `confidence` (high / medium / low)
and a one-line `reason` naming what the technique physically does. A slip moves the head
off the line of a straight punch: `["head"]`. A kick check lifts the shin into a low or
body kick: `["leg", "body"]`. A stance or distance read that makes every strike harder
to land answers all three - say so; it is a legitimate answer, not a dodge.
**Low confidence is a legitimate answer - write it rather than guessing high.**

**2. The report** `U76_DEFENCE_BY_REGION.md`, with:

- a per-discipline table (nodes, and how many answer head / body / leg / all three);
- **CONSUMERS** - the code that would read `answers` in each engine: FightSimulation's
  `_defender_defense_factor` and FightMoves' `guard_arsenal` / `answering_guards`, with
  line numbers, and what each would need passed in that it does not receive today;
- **ORDER OF OPERATIONS** - in FightSimulation the defence factor is taken BEFORE the
  target region is chosen (`_technique_target_region` is called after the landed roll).
  Quote both lines. A defence cannot answer a region that has not been chosen yet: say
  what would have to move, and whether the region can be chosen first without changing
  how many random draws a bout consumes. Do the same for FightRealtime.
- **OPTIONS** - at least: (a) a per-node `answers` list in the catalogue; (b) a per-key
  region list in `technique_vocabulary.json` beside `defense_answers`; (c) leave defence
  region-blind and say why that is defensible. Consequences of each; recommend one.
  **Do NOT build it.**

## The JSON

    {"rows": [{"id": "boxing_slip", "discipline": "boxing", "phases": ["standing"],
               "effects": {"evasion": 9, "counter_open": 6},
               "answers": ["head"], "confidence": "high",
               "reason": "moves the head off the line of a straight punch"}],
     "summary": {"nodes": 0, "head": 0, "body": 0, "leg": 0, "all_regions": 0},
     "recommend": "a"}

(`phases` and `effects` above are illustrative - copy the real ones.) `summary.head` is
the number of rows whose `answers` include `head`, and so on; `all_regions` is the number
answering all three.

## THE TRAP

**Never adjudicate from the effect key.** `block` sits on `boxing_parry` (a hand that
redirects a punch to the head) and on `kickboxing_kick_check` (a shin that meets a leg
kick). Same key, different regions. Read what each technique IS - the name, the
discipline, the phases - and answer for the node, never for the key.

## The gate

    python research/U76_check.py

It fails now because your files do not exist. **Fix YOUR FILES, never the checker.**

## Done

- Stay on `master`; no branch. **Never** `git checkout`, `switch`, `branch`, `stash`,
  `reset`, `clean`, `add -A`, `pull` or `push`.
- `git status -s` first. Commit exactly your two paths, ON the commit line:
  `git add -- research/U76_defence_regions.json research/U76_DEFENCE_BY_REGION.md`
  then `git commit -m "U76: ..." -- research/U76_defence_regions.json research/U76_DEFENCE_BY_REGION.md`
  ending `Co-Authored-By: Cursor <noreply@cursor.com>`.
  Then `git show --stat HEAD` must list exactly those two files. **Do not push.**
- Mail: `python Tools/agent_comms.py send --from cursor --to claude --topic U76-done --body "<hash> nodes=<n> head=<n> body=<n> leg=<n> all_regions=<n> recommend=<a|b|c> check=exit0"`
- Do NOT edit `HANDOFF.md`.

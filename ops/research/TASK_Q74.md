# TASK Q74 - QWEN - A REAR-NAKED CHOKE IS SHOWN TO THE PLAYER AS "LEFT ARM"

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Do NOT start Godot:
Claude is running seeded bouts in this checkout, and only one Godot may run at a
time. Your one gate is a Python script (below) that MUST exit 0.

## Owned files

- `research/Q74_submission_targets.json` - **NEW, yours alone.**
- `research/Q74_SUBMISSION_TARGETS.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, `technique_catalog.json`,
`Q74_check.py`, `HANDOFF.md` or `AgentComms/roadmap.json`.

## Why this exists

`FightSimulation._technique_target_region` (`Godot/scripts/FightSimulation.gd:2156-2186`,
read exactly `sed -n '2156,2186p'`; the file is 3,295 lines - never open it whole)
decides which body region an action attacked. It sums the absolute weights of the
technique's effect keys by SUBSTRING: a key containing `head` -> `head_neck`, else
`leg` -> a leg, else `body`/`liver`/`torso` -> `torso_core`, else `arm`/`shoulder`
-> an arm. If no key matches it falls back to `_pick_target_region(role)`
(`sed -n '2226,2260p'`), which for a `submission` is a pure random roll:
**40% left arm, 40% right arm, 10% left leg, 10% right leg.**

Most chokes carry only `submission` and `submission_setup`, so they fall through to
that roll. The region is written onto the event as `target_body_region`, and
`Godot/scripts/RingStagePanel.gd:465` prints it to the player upper-cased. So a
rear-naked choke is announced as an attack on an ARM four times in five.

S2 fixes where strikes land. This census is the submission half of the same
resolver, so S2 can fix both from one verified input.

## Scope

1. **The census.** Every node with `match.role == "submission"` under
   `disciplines[].nodes[]` of `Godot/assets/data/technique_catalog.json` (there are
   56 today; derive the list, do not trust this number). For each, one row:
   - `id`, `discipline`, `name` (verbatim from the catalogue),
   - `family` - what the technique REALLY attacks: `neck` (choke or strangle),
     `arm` (elbow, shoulder or wrist lock, arm compression), `leg` (ankle, knee,
     heel, calf), `body` (trunk compression), or `unspecified` (a generic node
     that names no particular lock),
   - `mechanism` - one of `choke`, `joint_lock`, `compression`, `generic`,
   - `engine_region_today` - what the resolver produces from its effect keys:
     `head_neck`, `torso_core`, `arm`, `leg`, or `random_role_roll` when no key
     matches. Apply the resolver's rule exactly as the code has it, including the
     `if/elif` order.
   - `matches` - `true` only when `engine_region_today` is the family's region
     (`neck`->`head_neck`, `arm`->`arm`, `leg`->`leg`, `body`->`torso_core`);
     `false` otherwise, including every `random_role_roll`.
   - `source` - the named rule set or nomenclature that tells you the family
     (Kodokan / IJF names for judo, IBJJF names for BJJ, FIAS for sambo).
   - `note` - REQUIRED (non-empty) when your `family` disagrees with what the
     node's own effect keys say (an `arm_isolation` key on a node you call `leg`,
     for instance). Say what the catalogue has and why you read it differently.
2. **The memo** `Q74_SUBMISSION_TARGETS.md`: counts per discipline and family; how
   many rows have `matches: false` (write that number as `mismatches=<n>`); what the
   player sees for the worst cases; every catalogue entry you believe is itself
   wrong (flag it, do not fix it); and the SMALLEST authored data change that would
   let the resolver place every submission correctly - for example a locational
   effect key per node, or an explicit target field - with what it would touch.
   Recommend one. Do not build it.

JSON shape: `{"rows": [ {...}, ... ]}` - one object per submission node.

## THE TRAP

**The id and the name are not the family.** `bjj_arm_triangle` is a CHOKE - it
contains "arm". `judo_udehishigisankakugatame` is an ARMLOCK - it contains
"sankaku", like the triangle choke. Q70 classified kicks by id substring and missed
72 real kicks. Adjudicate each technique from what it is, and cite it.

## The gate - run it, it must exit 0 before you commit

    python research/Q74_check.py

It recomputes the census and the resolver itself and compares; it checks a set of
unambiguous anchors; it fails on any missing, extra or duplicate row. **It fails
right now** because your files do not exist. If it fails, fix YOUR FILES - never
the checker.

## Done

- Shared checkout: stay on `master`. **Never** `git checkout`, `switch`, `branch`,
  `stash`, `reset`, `clean`, `add -A`, `pull` or `push`.
- `git status -s` first, then the paths go ON the commit line:
  `git add -- research/Q74_submission_targets.json research/Q74_SUBMISSION_TARGETS.md`
  then `git commit -m "Q74: ..." -- research/Q74_submission_targets.json research/Q74_SUBMISSION_TARGETS.md`,
  ending with `Co-Authored-By: Qwen <noreply@qwen.ai>`. **Do not push.**
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --topic Q74-done --body "<hash> submissions=<n> neck=<n> arm=<n> leg=<n> body=<n> unspecified=<n> mismatches=<n> check=exit0"`
- Do NOT edit `HANDOFF.md`.

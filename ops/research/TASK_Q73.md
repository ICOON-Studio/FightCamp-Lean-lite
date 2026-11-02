# TASK Q73 - QWEN - A SHRIMP ESCAPE BLOCKS A JAB: THE PHASE-BLIND DEFENCE BONUS

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GATE AT ALL.** **Do NOT start
Godot.** Claude is running the full suite in this checkout.

## Owned files

- `research/Q73_PHASE_BLIND_DEFENCE.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, `technique_catalog.json`,
`HANDOFF.md` or `AgentComms/roadmap.json`.

## Why this exists

S1d moved four BJJ ground escapes from role `defense` to role `escape` (`f160fe9`)
so they can finally be thrown. With the ground still invisible in that commit, a
seeded BJJ bout changed anyway: **standing takedowns landed went 95 -> 222** in 40
bouts. The cause is `_defender_defense_factor`
(`Godot/scripts/FightSimulation.gd:2426-2437`, read exactly that window; the file
is 3,292 lines - never open it whole): it sums the magnitude of EVERY
`defense`-role technique a fighter knows, whatever phase it belongs to, and that
factor is subtracted from the success chance of EVERY incoming action
(`:1398`, read `sed -n '1390,1410p'`). So a ground escape was defending punches
and takedowns on the feet.

## Scope

1. **The mechanism, exactly.** The formula, the cap (`/40`, clamp 0.35, total
   clamp 0.6), and what it is applied to at `:1398`. Does anything else read
   defense-role techniques phase-blind? `grep -n '"defense"' Godot/scripts/FightSimulation.gd`
   and read each hit's 3 lines of context only.
2. **The census.** From `Godot/assets/data/technique_catalog.json` (nodes under
   `disciplines[].nodes[]`), every node with role `defense`: id, discipline,
   phases, magnitude (sum of absolute effect values, as `_technique_magnitude`
   does at `sed -n '2649,2670p'`). Classify each by phase: STANDING-only,
   GROUND-only, or BOTH. Use `Godot/assets/data/technique_vocabulary.json`
   `phase_seats` - the authored map of which word grants which seat - NOT your own
   reading of the words. Count per discipline.
3. **Who is affected.** Which disciplines' fighters get a standing defence bonus
   from ground-only nodes, and how big can it get before the 0.35 cap? Give two
   worked examples with real ids: a BJJ specialist who knows the tree's ground
   defence nodes, and a wrestler.
4. **A phase-aware rule, proposed, not built.** At least two options - e.g. (a)
   count only defence nodes whose seats include the seat the DEFENDER is in when
   the action lands; (b) split the bonus into a standing and a ground pool. For
   each, which verdicts it moves and in which rulesets. Recommend one.

## THE TRAP

**Do not classify phases by substring** (`ground` in the word). `scramble` grants
BOTH ground seats and contains no `ground`; `ground_cage` contains `ground` and
grants NO seat. The vocabulary's `phase_seats` is the classifier.

## Done

- Shared checkout: stay on `master`. **Never** `git checkout`, `switch`, `branch`,
  `stash`, `reset`, `clean`, `add -A`, `pull` or `push`.
- `git status -s` first, then the path goes ON the commit line:
  `git add -- research/Q73_PHASE_BLIND_DEFENCE.md` then
  `git commit -m "Q73: ..." -- research/Q73_PHASE_BLIND_DEFENCE.md`,
  ending with `Co-Authored-By: Qwen <noreply@qwen.ai>`. **Do not push.**
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --topic Q73-done --body "<hash> defense_nodes=<n> ground_only=<n> standing_only=<n> both=<n> recommend=<a|b>"`
- Do NOT edit `HANDOFF.md`.

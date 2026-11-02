# TASK U65 — CURSOR — WHO READS `role` AND `kind`, AND WHAT DOES EACH DO WITH A WORD IT DOES NOT KNOW

Model: Composer, **medium effort**. Owner: cursor.

**Test tier: RESEARCH — no `.gd` file is touched.** NO parse gate, NO test, and
do **NOT** run the suite or launch Godot. `git status -s` before you stage is
the whole check. This is a census of the tree as it stands, not a change to it.

## Why this exists

S1's catalogue merge is done on branch `claude/s1-catalogue-merge` and its last
ten test failures are all one cause: **the catalogue moved to the contract's
five roles and everything that READS roles did not.** U60's fix-up remapped
judo `takedown` -> `damage`, but `assets/data/fight_plans.json` still asks for
`["setup", "takedown"]`, so the judo grip duel now counts zero techniques.

Before anyone remaps the remaining 145 nodes, we need the **blast radius**:
every consumer, and — the part that actually matters — **what each one does
when handed a role or kind it does not recognise.** C97 prices the remap as a
full fight rebaseline; this census is what makes that estimate real instead of
a guess.

**You are NOT changing any role or kind.** Do not edit the catalogue, the
plans, or any script. Measure and report.

## The two vocabularies in play

**Roles.** The contract (`research/TECHNIQUE_CATALOGUE_CONTRACT.md` §3)
says `match.role` is one of five: `damage`, `setup`, `defense`, `control`,
`finish`. The catalogue also still uses four more: `counter`, `takedown`,
`submission`, `transition`, `escape`, `adaptation`. Both sets are live.

**Kinds.** Contract §3 says `kind` is `move` or `skill`. §10's worked example
gives a *combination* `"kind": "move"`. But `FightSimulation` fires chains on
`kind == "sequence"`. **That contradiction is not yours to settle** — record
precisely who depends on which spelling so it CAN be settled.

## Owned files

- `research/U65_ROLE_KIND_CENSUS.md` — NEW, yours alone.
- `research/U65_role_kind_sites.csv` — NEW, yours alone. One row per site.

Touch nothing else. Do **not** edit `HANDOFF.md`.

## What to search

Search `Godot/scripts/`, `Godot/tools/`, `Godot/tests/` and
`Godot/assets/data/*.json`. Work on **master**, not the S1 branch — master is
the tree everything still runs against.

Find every site that:

1. reads a `role` off a technique/node/move (`match.role`, `get("role"`,
   `.role`, a `role` key in a dictionary literal);
2. compares against, or switches on, any of the ten role words as a **string
   literal** — `"damage"`, `"setup"`, `"defense"`, `"control"`, `"finish"`,
   `"counter"`, `"takedown"`, `"submission"`, `"transition"`, `"escape"`,
   `"adaptation"`;
3. reads a `kind` off a node, or compares against `"move"`, `"skill"`,
   `"sequence"`, `"combination"`;
4. is a **data** file naming a role or kind — `fight_plans.json`
   (`signature_battles.*.roles`, `role_priority`, `requires.roles`),
   `technique_catalog.json` (`match_roles`), and anything else you find.

Known starting points, not the whole list — find the rest yourself:
`FightMoves.gd` (`DEFENSE_ROLES`, `GUARD_*_EFFECTS`), `FightSimulation.gd`
(role→word map near :245, `kind == "sequence"` near :676/:1336/:2478),
`ComboMastery.gd`, `CompetitionData.gd`, `GameState.gd`, `FightPlans.gd`,
`PlanCompetency`/`learned_in_roles`, `RingStagePanel.gd`, `AthleteDevelopment.gd`.

## The column that matters most

For every code site, answer: **what happens when the role or kind is one this
site does not handle?** Classify each as exactly one of:

- `IGNORED` — falls out of a filter, the technique silently does not count
- `DEFAULTED` — mapped to some fallback value (say which)
- `CRASH` — index/lookup error or a hard failure
- `PASSTHROUGH` — carried along untouched, no branch on it

**`IGNORED` is the dangerous one** and is what this census is really hunting:
it is how 145 nodes can be present, valid and invisible at the same time.

## Output contract

`U65_role_kind_sites.csv`, with exactly this header:

```
file,line,symbol,vocabulary,words_handled,unknown_behaviour,notes
```

`vocabulary` is `role` or `kind`. `words_handled` is a `|`-separated list of
the literals that site accepts. `unknown_behaviour` is one of the four words
above.

`U65_ROLE_KIND_CENSUS.md` opens with these lines and nothing before them:

```
U65 role_sites=<int> kind_sites=<int> data_sites=<int>
U65 unknown_ignored=<int> unknown_defaulted=<int> unknown_crash=<int> unknown_passthrough=<int>
U65 sequence_dependents=<int> move_dependents=<int>
U65 roles_never_read=<comma list, or none>
```

Then, in prose:

1. **The remap blast radius.** If `takedown`, `submission`, `transition`,
   `escape`, `adaptation` and `counter` were folded into the contract five,
   which sites change behaviour and which do not. Name them.
2. **Roles nothing reads.** Any of the ten that NO code site branches on — a
   role nothing reads is dead vocabulary and the cheapest thing to delete.
3. **The `sequence` question.** Every site that requires `kind == "sequence"`
   against every site that requires `kind == "move"`, so the contradiction can
   be settled on evidence rather than preference. Do not settle it.
4. **The riskiest three sites**, with your reasoning.

## Rules

- **Report what you measure.** If a search finds nothing, say the count is
  zero — do not pad the census to look thorough.
- **Do not infer a consumer from a name.** `_role` in an unrelated context is
  not a technique role; check what is actually assigned to it.
- Line numbers must be real and current on master. If a file moved under you,
  re-grep rather than adjusting from memory.
- Where you are unsure how a site behaves on an unknown word, mark it
  `unknown_behaviour` as your best call and say in `notes` that it is
  UNVERIFIED. An honest uncertain row beats a confident wrong one.

## Done

Commit and push, then send exactly one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic U65-done --body "<hash> role_sites=<n> kind_sites=<n> unknown_ignored=<n> sequence_dependents=<n> riskiest=<file:line>"
```

Do **not** edit `HANDOFF.md` — Claude writes your block.

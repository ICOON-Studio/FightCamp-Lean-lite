# TASK_U139 — THE GROUND GRAPH'S CONTRACT TEST, WRITTEN BLIND

**Model: `composer-2.5`, medium effort.** Worktree `FightCamp-U114`, cut a FRESH
branch off `origin/master` named `cursor/u139-ground-graph-contract`. Your mail
rides your branch, so name the branch in the message you send.

**Owned files — create only this:**
- `Godot/tests/ground_graph_contract_test.gd`

---

## YOU ARE FORBIDDEN TO READ THE IMPLEMENTATION

**Do NOT open `Godot/scripts/GroundGraph.gd`.** Do not grep it, do not read it
in a diff, do not look at the commit that added it.

That is the entire point. A test written against an implementation only ever
agrees with it. This project has run this split six times and it has paid every
time — C142 wrote the `CASCY_TO_UE4` contract blind while Cursor built the map,
and when the two met they agreed with all four mutants still caught.

**Write the test from the DEFINITION below.** Where the definition is ambiguous,
pick the reading you think a careful engineer would pick, assert it, and say in
your digest which reading you took and why. **A disagreement between your test
and the module is a FINDING, not a failure** — it means the contract is
underspecified, and settling it is worth more than a green run.

---

## WHAT THE MODULE IS FOR

A fight sim's ground game had a hardcoded one-way ladder — guard/half → side →
mount → back, one destination per position, no choice anywhere. `GroundGraph.gd`
replaces the data half of that: a table of **edges** between seats, a **scorer**
that says what an edge is worth to a particular fighter right now, a **chooser**
that picks one, and a **decay** that makes holding a position worth less the
longer it goes on.

It is pure statics with zero preloads, so you can test it in isolation.

---

## THE CONTRACT

Seats are the engine's seven: `none`, `over_under`, `guard`, `half`, `side`,
`mount`, `back`.

### `edges_from(from_seat: String, actor: String, held_ticks: int) -> Array`

Returns the edges leaving `from_seat` that `actor` may take right now.

- `actor` is `"top"` or `"bottom"`. An edge belongs to exactly one of them.
- An edge is excluded when `held_ticks` is below that edge's own
  `min_hold_ticks`.
- An unknown seat returns an **empty array**, never an error.

### Edge fields

`id`, `from_seat`, `to_seat`, `actor`, `kind`, `technique_ids` (array),
`plan_tags` (array), `p_mod` (float), `fail_seat`, `reward` (int),
`min_hold_ticks` (int).

- `kind` is one of `advance`, `hold`, `scramble`.
- **A HOLD EDGE IS ONE WHERE `to_seat == from_seat`.** That is the definition,
  not a naming convention.
- `p_mod` is a **multiplier on an existing success probability computed
  elsewhere** — above 1.0 means an easier edge. The module does not roll dice.
- `fail_seat` is where a failed attempt lands.

### `control_units_decayed(flat_units: int, held_ticks: int, gate_ticks: int, arm: String) -> int`

How much one scoring tick of control is worth after holding a seat for
`held_ticks`, given the flat value the engine would otherwise pay.

- Arms are `current`, `decay`, `graph`, `both`. **Only `decay` and `both` apply
  any decay** — `current` and `graph` must return `flat_units` UNCHANGED. This
  is the control arm and it matters more than anything else you test.
- Decay is in **whole steps**, one step per some fixed number of multiples of
  `gate_ticks`. Work out the step boundary by probing the function rather than
  assuming a constant.
- The result never falls below a floor that is **greater than zero** — inactive
  control is discounted, not erased.
- `flat_units <= 0` returns unchanged. `gate_ticks <= 0` returns unchanged.
- **Returns an int.** A float here would silently change every scorecard.

### `score_edge(edge, skill_of: Dictionary, plan_tags: Array, held_ticks: int, gate_ticks: int) -> Dictionary`

What an edge is worth to this fighter. Returns a breakdown, not just a number,
so a bad choice on camera can be explained from one log line.

- `skill_of` maps a technique id to that fighter's trained progress in `0..1`.
- The skill term is the **mean** over the edge's `technique_ids`, so an edge
  naming two techniques is not automatically worth more than one naming one. A
  technique absent from `skill_of` contributes zero.
- The plan term is a **flat bonus per matching tag**, not a multiplier — a fight
  plan must not make an edge the fighter cannot execute look attractive.
- The reward term is normalised so it is commensurate with the others rather
  than swamping them.
- **A hold edge carries a term derived from the SAME decay arithmetic as
  `control_units_decayed`** — a hold that has stopped paying must stop being
  chosen. Assert that this term FALLS as `held_ticks` rises, and that it does
  not fall below the floor.
- The returned dictionary must carry the `id` and the named components, not just
  a total.

### `choose(candidates: Array, skill_of, plan_tags, held_ticks, gate_ticks, roll: float) -> Dictionary`

Picks one edge. `roll` is `0..1` and comes from the caller's seeded stream —
**the module must never touch RNG itself.** Replay determinism is the caller's
contract and nothing here may break it.

- Selection is **weighted by score, not argmax.** Argmax would make two fighters
  with the same stats behave identically for ever, which is the escalator with
  extra steps. Assert that sweeping `roll` across `0..1` can return **more than
  one distinct edge** from the same candidate set.
- The same `roll` and the same inputs must always return the same edge.
- An empty candidate list returns an **empty dictionary**, and the caller is
  expected to fall back to the shipped ladder rather than invent a move.
- If every candidate scores zero the function still returns one rather than
  dividing by zero, and it flags that this happened.
- `roll` at the extremes (`0.0`, and values approaching `1.0`) must still return
  a real edge — no index running off the end.

---

## PROVE IT WITH MUTANTS — this is required, not optional

A green contract test is worth nothing until you have watched it go red. Before
you believe your own test, break the contract **at least five ways** and confirm
each one is caught. Suggested, and add your own:

1. Make `control_units_decayed` apply decay under the `current` arm.
2. Remove the floor so decay can reach zero.
3. Make the skill term a SUM instead of a mean.
4. Make `choose` argmax instead of weighted.
5. Make `edges_from` ignore `min_hold_ticks`.
6. Make a hold edge's value constant instead of decaying.

You cannot edit the module, so run your mutants by **injecting a stub** — build
a small fake that satisfies the same signatures, break it each way, and point
your assertions at it. Report which mutants your test caught and which it
missed. **A mutant you cannot catch is a hole in the contract; name it.**

---

## GATE

- Parse gate: `python Godot/tools/check_scripts.py Godot/tests/ground_graph_contract_test.gd`
- Then that ONE test:
  `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ground_graph_contract_test.gd`
- **A NEW TEST FILE CANNOT BREAK ANOTHER TEST, so do NOT run the full suite.**
  It costs twenty minutes and buys nothing here.
- Your test must print a final `failures=N checks=M` line and exit non-zero on
  any failure, like every other test in `Godot/tests/`.

## WHAT TO SEND

Commit, push your branch, write `research/U139_DIGEST.md`, and send one
line with `python Tools/agent_comms.py send --from cursor --to claude --subject U139`
naming the branch. Do NOT edit `HANDOFF.md`.

Say in the digest: which ambiguous readings you chose, which mutants were
caught, and **anything in the contract above that you could not test because it
is underspecified.** That last list is the most valuable thing you can give me.

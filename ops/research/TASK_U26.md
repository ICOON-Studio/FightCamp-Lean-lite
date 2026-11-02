# TASK U26 — CURSOR — GrappleResolve.gd: WHAT A SHOT IS WORTH

Model: **Cursor Grok 4.6**, high effort. (Cursor Pro meters two pools
separately. Only *Other Models* - Claude/GPT/Gemini through Cursor - was spent,
on 2026-09-08, refilling at the plan reset 2026-10-07. The *Cursor Models* pool
was 6% used and carries Grok 4.6, a top-tier model. Full task difficulty; do
not simplify the spec.) Owner: Cursor. Base: `a491550`,
`SUITE total=210 fails=1` — and **the one failure is Codex's C67**, red by
design until BOTH grapple modules exist. Yours is one of the two. Rebased
2026-09-10.

---

## Why this exists

Grappling is the last thing blocking the retirement of `FightSimulation.gd`.
`G34_GRAPPLING_CONTRACT.md` (Grok, 17 sources) already decided the design and
typed most of this module's signatures. This is the arithmetic half.

**You are one of three agents building grappling from the same contract.** Qwen
owns `GrappleSeat.gd` (the seat vocabulary) and Codex is writing a contract
test BLIND. **None of you may read another's code** — that split has caught
four real disagreements now, and a test written against a delivered
implementation only ever agrees with it.

## What to build

**ONE new file, `Godot/scripts/GrappleResolve.gd`, plus its test.**

Pure statics. `extends RefCounted`, `class_name GrappleResolve`. The **caller
passes the roll** — `roll: float` in 0..1, never a draw of its own. That is
Q15's pattern and it is the entire reason a seeded fight stays seeded. One
preload only: `FatigueCurve.gd`, whose multipliers G34's arithmetic names by
hand. Nothing else — no fight core, no `GrappleSeat`, no autoloads.

### The contract — EXACT names, argument order and strings

Codex is writing a test against this text without seeing your file. A renamed
argument or a reordered one is a failure, not a preference.

```gdscript
## { "success": bool, "grade": int, "to_seat": String }
## grade is 4 on a throw / feet-to-back, 2 on a plain takedown, 0 on a failure.
static func takedown_resolve(
	attacker: Dictionary, defender: Dictionary, from_stance: String,
	fatigue_atk: float, fatigue_def: float, roll: float) -> Dictionary

## { "success": bool, "to_seat": String, "points": int }
static func position_resolve(
	attacker: Dictionary, defender: Dictionary, from_seat: String,
	fatigue_atk: float, fatigue_def: float, roll: float) -> Dictionary

## { "progress": int, "attempted": bool, "finished": bool }
## progress is 0..100. finished only ever true at progress >= 100.
static func submission_advance(
	progress: int, attacker: Dictionary, defender: Dictionary,
	fatigue_def: float, roll: float) -> Dictionary

## The engine-unit points table. Unknown kind or seat is 0, never an error.
static func position_points(kind: String, to_seat: String) -> int
```

`attacker` / `defender` are stat dictionaries — `grapple`, `power`, `technique`,
`speed`, `defense`, `fight_iq`, `conditioning`, each 0..100. **A missing stat
defaults to 50 rather than erroring**, the way `_run_impact` already reads
`actor_stats.get("technique", 50)`.

### The numbers, straight from G34 §3 and §5

```
off = 0.45*grapple + 0.20*power + 0.15*speed + 0.10*technique + 0.10*fight_iq
def = 0.40*grapple + 0.30*defense + 0.15*speed + 0.15*fight_iq
off *= FatigueCurve.technique_multiplier(fatigue_atk)
def *= FatigueCurve.defense_multiplier(fatigue_def)
p   = clamp(0.50 + 0.012*(off - def), 0.08, 0.88)
success = roll < p
```

Takedowns fail with sloppy feet first, which is why the attacker is scaled on
`technique_multiplier` and not on `power_multiplier`. A clinch entry
(`from_stance == "clinch"`) uses the same function with a **lower power weight
and a higher grapple weight** — pick the split, state it in a comment, and keep
the same roll contract.

**Grade:** `grade = 4` when the roll lands in the hardest third of the success
band or the attacker's power is clearly the higher; otherwise `grade = 2`.
`to_seat` is `guard` on a contested shot, `half` or `side` on a high-grade
throw.

**`position_points`** (engine units; adapters rescale):

| kind / to_seat | points |
| --- | --- |
| pass → `side` | 3 |
| sweep / reversal | 2 |
| → `mount` | 4 |
| → `back` | 4 |
| `knee_on_belly` | 2 |
| `exposure` | 2 |
| `step_out` (to the OTHER man) | 1 |

**Submissions.** Progress is an integer 0..100 advanced on the scoring cadence:

```
advance = (atk.grapple + atk.technique + atk.fight_iq)
        / (def.defense + def.grapple + def.fight_iq)
```
scaled by `FatigueCurve.defense_multiplier(fatigue_def)`. Finish requires
`progress >= 100 AND roll < finish_p`, and **`finish_p` must stay small even at
100**.

## The trap specific to this task

**RARITY LIVES IN `finish_p`, NOT IN A HIDDEN ROLL.** About one MMA fight in
five ends by submission (19.3% over 8,591 UFC bouts; three independent sources
in G34 §5 agree within half a point). That is the FIGHT-level ceiling, not the
attempt-level rate — a committed attempt should finish on the order of 1 in 6
to 1 in 8. Wiring "locked in long enough" straight to "he tapped" is the same
class of defect R84 caught when it nearly wired `shocked` straight to a
knockdown: it would have meant five knockdowns a bout. **A rule that fires far
too often is the same defect as one that cannot fire at all, and only measuring
says which you built.** So measure it: your test must run a sweep and report
the finish rate per attempt, not merely assert that a finish is possible.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/scripts/GrappleResolve.gd` | new | Yours. |
| `Godot/tests/grapple_resolve_test.gd` | new | Yours. |
| `research/U26_DIGEST.md` | new | Yours. Short. |

**Read only these:** `research/G34_GRAPPLING_CONTRACT.md` §3, §5 and §8
(lines 148–262 and 362–410), and `Godot/scripts/FatigueCurve.gd` (small, read
whole) for the four multipliers. Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md`, any digest, or Qwen's/Codex's work. `GameState.gd` is
**14,386 lines** — never open it. `FightRealtime.gd` is **1,282 lines** and is
NOT yours this task — do not edit it.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/GrappleResolve.gd Godot/tests/grapple_resolve_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_resolve_test.gd
python Godot/tools/run_tests.py
```

**CEILING, NOT AN EXACT COUNT, AND READ THIS BEFORE YOU JUDGE YOUR RUN.**
Master already carries **one failure that is not yours and that you cannot
fix**: Codex's `grapple_contract_test.gd` (C67), which was written blind
against G34 and fails loudly until **both** `GrappleSeat.gd` and
`GrappleResolve.gd` exist. Yours is one of the two.

So the gate is **`fails=1` or better**:

* `fails=1` with C67 the only failure — correct, expected, **push**.
* `fails=0` because Qwen's Q19 landed as well — better, **say so and push**.
* `fails=1` where the one failure is `grapple_resolve_test.gd` — that one is
  yours. Fix it.
* C67 failing on an assertion about **your** module rather than on a missing
  file — that is a genuine contract disagreement between your reading of G34
  and Codex's. **Report it, do not edit either side.** That is what the blind
  split is for and it has caught four already.

`total` should be at least 211. **The exit code alone is not a pass** — a
GDScript runtime error leaves rc=0, so read the runner's own `SUITE` line,
never the exit code.

## Done

Push your branch (Claude merges), write `U26_DIGEST.md` carrying the measured
finish-rate sweep, and send one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic "U26-done" --body "<branch> <commit> <suite line> <measured finish rate>"
```

**Your mail rides your branch, so say the branch name in the digest** — an
inbox read against `master` shows unread=0 and the work looks unsent.

Do NOT edit `HANDOFF.md` — Claude writes your block.

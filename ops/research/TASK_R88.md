# TASK R88 — CLAUDE — THE LAST INERT MODULE, AND THE BEAT A CUT NEVER LEFT

Model: Opus, high effort, Fast off. Owner: Claude. **Fresh session — R87
shipped at `57d7a5b`; do not start this inside that session.** Base: `57d7a5b`,
`SUITE total=209 fails=0`.

---

## Why this stage exists

R87 wired `FightTrauma` and `Cardio` and closed six of the seven pieces of
correct, tested, unreachable code in this area. **`CornerAdvice.gd` is the
seventh and it is still inert**: 147 lines, a 687-check blind contract test
(G33T) that passes, and not one caller anywhere in the game.

This stage ends the condition. It is deliberately the same shape as R87 —
**assert that the feature OCCURS, not that it is permitted** — because that is
the standing lesson and it is the gate here.

## What to do

1. **Wire `CornerAdvice` into `_close_round`.** The corner's minute already
   exists there: `FightRealtime.gd:_close_round` gives a man his wind back
   (`Stamina.rest_recovery`) and his body back (`Impact.corner_recovery`),
   guarded on there being another round to come. The advice belongs beside
   those, on the same guard, and it is the only place in the engine where a
   corner speaks. Store it on the fighter or on the round record — rule which
   and say why.

2. **Give a cut its beat in the log.** R87's own reported follow-up: a mark
   currently leaves `trauma_opened` (a counter) and the final face, and nothing
   else. A broadcast wants *"the cut opened over the left eye at 2:14 of round
   three"* and a replay cannot reconstruct that from a counter. Add the site
   and the kind to the impact record. `FightTrauma.words()` — NICK / CUT / BAD
   CUT / SEVERE — is the natural consumer and has none.

3. **Do NOT add the punch/kick tag, and this is a ruling, not an omission.**
   The forecast block names it as the next slice for TKD zones. It is
   deliberately deferred: **no TKD research exists and no TKD consumer exists**,
   so shipping the tag now would create an eighth piece of correct, tested,
   unreachable code — the exact condition R87 and this stage exist to close.
   The tag ships in the same stage as its consumer, after the research lands.
   Record the ruling in the digest.

## The two decisions that are yours to rule explicitly

* **Where the advice lives.** On the fighter (like `trauma`), on the round
  record (like a scorecard), or on `state` (like `stoppage`)? Each has a
  consumer implication: `FightHudRead.fold` reads the fighter, and the
  scorecards array is what a post-fight screen walks. Rule it and say why.
* **Whether the advice is recomputed or stored.** `Cardio` is *not* stored —
  R87 ruled that a heart rate is a pure projection of stamina, conditioning and
  age, and storing a derived per-tick float would be carrying state C62 ruled
  out. Corner advice is different: it is produced at ONE instant, the bell, off
  the state as it was at that instant, and it cannot be recovered afterwards
  because the corner has already given the man his stamina back. **That is an
  argument for storing it, and it is the opposite of the Cardio ruling.** Say
  so explicitly, and say why the two differ — otherwise the next person reads
  the two decisions as inconsistent.

## Owned files

| File | Lines | How to read it |
| --- | --- | --- |
| `Godot/scripts/FightRealtime.gd` | 1117 | Owned. **Never whole.** `_close_round` `:559`, `_close_round_at_bell` `:543`, `_build_fighter` `:306`, `_run_impact` `:829`, the trauma channel `:1062`, seed constants `:61`–`:78`. |
| `Godot/tests/fight_realtime_test.gd` | 1085 | Owned. Never whole. `_test_the_corner_actually_gives_condition_back`, `_test_the_face_is_actually_marked`, `_test_impacts_carry_u20s_record` `:224`. |
| `Godot/scripts/ImpactModel.gd` | 194 | Owned for this task only (C63's). Read whole — it is small. |
| `research/R88_DIGEST.md` | — | Yours. New. |

Read-only, both small, read whole: `Godot/scripts/CornerAdvice.gd` (147;
`advise` `:20`, `urgency_of` `:79`, `URGENCIES` `:12`) and
`Godot/scripts/FightTrauma.gd` (158; `words` `:88`, `worst` `:64`).
**`GameState.gd` is 12,900+ lines — never open it at all.**

**Not yours this cycle:** `GrappleSeat.gd` (Qwen, Q19), `GrappleResolve.gd`
(Cursor, U26), `grapple_contract_test.gd` (Codex, C67). Expect Codex's file to
be RED on master by design until the other two land — that is correct and is
not your failure to fix.

## Gates

1. **`CornerAdvice` is REACHED in a real fight**, asserted by occurrence: run a
   seeded bout and assert real advice with real content comes out at real
   bells, and that the urgency actually VARIES across a fight rather than
   sitting on one word. A test that only checks the call is permitted is the
   failure this stage exists to end.
2. **A cut leaves a beat**, asserted by occurrence: an impact that opened a
   mark carries the site and the kind, and one that did not carries neither (or
   carries them empty — rule which, and keep the log shape uniform).
3. **R82's replay gate is unmoved** — log, bodies, faces, scorecards, result
   and stoppage byte-identical across two runs of a seed.
4. **R85's nine pinned cards do not move.** `judge_panel_test.gd` T4/T8R. If
   they move, the wiring changed the fight, and that is a finding to report
   before it is a re-pin. Never "fix" a red card by re-pinning it.

## The trap specific to this task

**`CornerAdvice.advise()` needs numbers that `_close_round` has already
destroyed.** The corner gives stamina and body condition back *inside that same
function*, on the same guard. Advice computed after those two lines describes a
man who has already been treated — it would tell a fighter to breathe when he
has just got his wind back, and it would be wrong in exactly the way that never
goes red. **Read the state for the advice BEFORE the recovery is applied**, and
put a test on it: a man who ended the round gassed must be told to breathe,
even though by the time the next round starts he is not gassed any more.

Second, smaller: **it takes no RNG at all.** `advise` is a pure function of the
state. Do not give it a stream, and do not draw for it — R87 added
`_rng_trauma` because `aggravate` takes a roll; `advise` does not. A stream
nothing draws from is dead weight that the next reader will assume is load-
bearing.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/scripts/ImpactModel.gd Godot/tests/fight_realtime_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/corner_advice_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/judge_panel_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count.** Baseline is `total=209 fails=0`. Codex's C67
lands red by design, and Qwen's and Cursor's modules land green, so the honest
expectation while the grappling slate is in flight is `total=212, fails=0 or 1`
where the one is C67's until its two modules exist. **If it is better than
that, say so and push.** Never gate on an exact failure count.

**The exit code alone is NOT a pass** (R75): a GDScript runtime error leaves
rc=0, so a clobbered test prints twenty `SCRIPT ERROR` lines, then prints
`0 failure(s)`, and exits 0. Read the runner's own `SUITE` line.

## Done

Commit, push `master`, write `R88_DIGEST.md`, send one line with
`agent_comms.py send`, and write only your own `HANDOFF.md` block.

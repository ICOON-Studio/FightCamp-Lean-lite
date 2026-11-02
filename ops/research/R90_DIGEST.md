# R90 DIGEST — THE GRAPPLE ARC CONVERGES

Claude, 2026-09-10. Base `76fd876`. Engine integration explicitly NOT started.

---

## The merge

`cursor/u26-grapple-resolve-fb05` is merged. **Audited blob by blob, and the
audit was not ceremony.**

A plain `git diff origin/master origin/cursor/u26-grapple-resolve-fb05` reports
**twelve deletions** — `G35_REFEREE_AND_METHODS.md`, `GrappleSeat.gd`,
`grapple_seat_test.gd`, `grade_progression_test.gd`, `weight_read_test.gd`,
four task files and three digests. **None of them is a deletion.** They are
files master gained after the branch point, and that two-dot view is exactly
the ancestry read the task forbade. Against its merge base (`b805de2`, an
ancestor of master) the branch's single commit `e5f5f41` adds **three files
and touches nothing else**:

* `Godot/scripts/GrappleResolve.gd` (149 lines)
* `Godot/tests/grapple_resolve_test.gd` (125)
* `research/U26_DIGEST.md` (25)

`grapple_contract_test.gd` is blob `009a50e` on **both** master and the branch —
byte-identical — so nothing of C67's was at risk and nothing of C70's could
have been reverted.

### The near-miss, and it was a real one

**There are TWO u26 branches.** `cursor/u26-grapple-resolve-4018` is an earlier
attempt carrying a **different** `GrappleResolve.gd` (blob `ee0957c` against
fb05's `9e188cd`), and it also **deletes `grapple_contract_test.gd`** and
modifies `FightRealtime.gd` and `fight_realtime_test.gd`. Merging that branch
by ancestry would have deleted Codex's entire blind test and started the engine
integration this stage was told not to start. The task named `fb05` and `fb05`
is what landed.

### Also found, NOT merged, and needing a decision

`cursor/u25-fight-hud-panel-e353` is a **second, different U25**. Master carries
U25 from the other branch (`26c5`): `FightHudPanel.gd` and its test are on
master but at **different blobs** than e353's, and e353's `U25_DIGEST.md` is
**absent from master entirely** — so a shipped stage has no digest. This is the
**fifth** branch-only Cursor delivery (U15, U16, U25, U26 ×2). Not merged here:
picking between two variants of a shipped panel is not a merge, it is a
decision, and it is not R90's.

---

## The blind test ran, for the first time

```
GRAPPLE_CONTRACT_TEST SUMMARY witnesses=550 submission_rate=18/121 (0.149)
GRAPPLE_CONTRACT_TEST failures=1
```

**550 witnesses, and exactly one failing assertion.** Codex wrote 236 lines
from `G34` alone against two modules it had never read, by two agents who never
read each other; everything except one line agrees. The independent
convergence is worth recording on its own: Codex's blind test measures the
submission finish rate at **0.149** and Cursor's own test measures
**0.1430 (143/1000)** — two authors, one contract, no contact.

Focused runs: `grapple_seat_test` **PASS (99 checks)**,
`grapple_resolve_test` **PASS (23 checks)**.

Full suite: **`SUITE total=214 fails=1`** — 213 -> 214 because U26's test joined,
and the one failure is the line below. The gate was a ceiling with `fails=0` as
the target; it came back at 1, that 1 is a real contract disagreement, and the
finding is the deliverable rather than a reason to retune the assertion.

### The one failure

```
FAIL: clinch over_under has a defined dominance classification
```

`Godot/tests/grapple_contract_test.gd:92`. **Codex owns that file as C70 and is
repairing it in parallel — it was not edited here**, and C70's base line has
been updated to say the world changed under it.

---

## The disagreements, decided from G34

### 1. `hold_ticks("ground", "half")` — Qwen said 60, the Q19 table implied 20

**Qwen is right, and right for the G34 reason.** §2's transition table gives
`guard → half / half → side (pass)` **60 ticks — the IBJJF three-second rule**,
and says in as many words: "3.0 s = 60 ticks is the IBJJF number; use it as the
universal stability gate." The only 20-tick row in G34 is
`standing/clinch → ground` "for kept top", which is why `GrappleSeat` correctly
gives `guard` 20 — you arrive in guard from a takedown. The module matches the
contract row for row.

This matters beyond the number: Qwen reported its resolution as "aligned with
C67's blind test", which raised the worry that the blind separation had leaked.
**The leak, if there was one, changed nothing** — the answer is independently
forced by G34's own table.

### 2. Is `clinch/over_under` a dominant seat? — the modules and the blind test disagree head-on

The two tests on master **contradict each other**:

* `grapple_contract_test.gd:92` (Codex, blind) demands it **IS** dominant.
* `grapple_seat_test.gd:112` (Qwen) demands it is **NOT** dominant.

**The module's reading is the defensible one, and the contract decides it —
not the fact that the test is the easier file to change.** Two findings:

1. **The blind assertion is internally inconsistent with itself.** Line 92
   demands `clinch/over_under` be dominant while lines 94–96 demand `half` not
   be — and G34 §2's control table gives **both of them exactly 1 control unit**
   per scoring tick, against 2 for `side|mount|back`. No predicate can call one
   dominant and the other not without contradicting that table. `GrappleSeat`'s
   reading — dominant = the 2-unit tier — is at least consistent with it.
2. **`is_dominant` is not in `G34` at all.** It appears nowhere in the document,
   including §8's module shape, which asks `GrappleSeat.gd` for exactly "pure
   seat + legal edges + hold-threshold in ticks". The predicate is a module
   invention, and the blind test asserted a behaviour the contract never
   specified. The honest repair is to delete the assertion or re-aim it at
   `control_units()`, which **is** contract and which both sides already agree
   on — every `control_units` assertion in the blind test passes.

**Neither module was changed.** G34 does not prove `GrappleSeat` wrong, and
"correct only where G34 proves them wrong" is the standing rule.

Separately, the assertion is also **untestable as written**: `not X == false`
reduces to `X` under either binding, so the label "has a defined dominance
classification" — which a bool-returning function cannot fail — can never be
what it checks. That is the C70 defect Qwen found from failure output alone.

---

## What the contract test could NOT exercise

Recorded so nobody reads 550 witnesses as full coverage:

* **Nothing on the engine.** No seat advances per tick, no control unit reaches
  a judge, no stall clock, no `METHOD_SUBMISSION`. Both modules are pure and
  **inert** — nothing in `FightRealtime.gd` calls either one. This is the ninth
  time this area has shipped code with no consumer, and it is deliberate here:
  integration is the next stage.
* **No adapter fold.** G34 §8's five counters (`takedowns_round`,
  `throw_points_round`, `position_points_round`, `submission_attempts_round`,
  `control_score`) have writers specified and no writer.
* **The ruleset map (§6)** — judo osaekomi's 10s/20s gate, IBJJF advantages,
  UWW step-out — is entirely unexercised. C67 flagged BJJ advantage scoring and
  1-D UWW step-out semantics as open and they still are.
* **`is_dominant` has no contract**, so no test of it tests the contract.

---

## State of the arc

| piece | owner | where |
| --- | --- | --- |
| `G34_GRAPPLING_CONTRACT.md` | Grok | master |
| `G35_REFEREE_AND_METHODS.md` | Grok | master |
| `GrappleSeat.gd` + test | Qwen (Q19) | master, 99 checks |
| `GrappleResolve.gd` + test | Cursor (U26) | **master as of R90**, 23 checks |
| `grapple_contract_test.gd` | Codex (C67) | master, 550 witnesses, 1 red line |
| the blind spot in it | Codex (C70) | **open** |
| engine integration | unassigned | **next stage, big** |

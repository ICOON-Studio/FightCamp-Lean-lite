# TASK G40T — QWEN — THE BLIND TEST FOR `JudoBoard.gd`

Model: **Qwen default, `--yolo`, medium effort.** Owner: Qwen. Base: `master`
after Q25. Assigned 2026-09-10 by Claude.

Grok is writing `Godot/scripts/JudoBoard.gd` as G40 right now, from a contract.
**You are writing its test blind, from the SAME contract, without reading a
line of what Grok typed.** The two tasks run in parallel and this one never
waits for the module — a test written against an implementation only ever
agrees with it, and this arrangement has found four real defects on this arc.

**Do not open `Godot/scripts/JudoBoard.gd`**, not even to check whether it
exists yet. It probably does not, and that is fine — see "When the module is
absent" below.

---

## Your source, and your only source

**`research/TASK_G40.md`** — specifically its "THE CONTRACT" section,
which fixes every name, argument order and string literal. Read that file
whole; it is short. Everything you assert must trace to it.

You may also read `research/G39_THE_CLINCH.md` **§3 only**
(`sed -n '123,175p'`) for the IJF vocabulary. Do not read it whole.

Read nothing else. Not `HANDOFF.md`, not `CURRENT_STATUS.md`, not any digest.

## What the module is

`JudoBoard.gd` is the IJF contest board: statics only, zero preloads, no state.
It accumulates awards and says when a judo contest is over — on an ippon, on
two waza-ari combined, or on a third shido, with golden score when regulation
ends level. Nothing in the game does this today.

## The contract you test against

Copied from `TASK_G40.md`; it is binding on both of you.

```gdscript
const AWARDS := ["ippon", "waza_ari", "yuko", "shido", "hansoku_make"]

static func fresh() -> Dictionary
static func apply(board: Dictionary, side: String, award: String) -> Dictionary
static func decide(board: Dictionary) -> Dictionary
static func result(board: Dictionary) -> Dictionary
static func score_line(board: Dictionary, side: String) -> String
static func reasons() -> Array
```

`fresh()` — exactly these keys, spellings and nesting:

```gdscript
{
  "a": {"waza_ari": 0, "yuko": 0, "shido": 0},
  "b": {"waza_ari": 0, "yuko": 0, "shido": 0},
  "over": false, "winner": "", "reason": "", "golden_score": false,
}
```

`reasons()` — this exact list, this order:
`["ippon", "waza_ari_awasete_ippon", "hansoku_make_shido",
"hansoku_make_direct", "waza_ari", "yuko", "golden_score"]`

`score_line(board, side)` — W/Y/S plus count, in that order, one space between,
**zeros omitted**: `"W1 S2"`, `"Y3"`, `"-"` when everything is zero, `"-"` for
an unknown side.

## What to assert — a floor, not a ceiling

1. **`fresh()`'s shape**, key by key, including that `over` is `false`,
   `winner` and `reason` are `""` and `golden_score` is `false`.
2. **`apply()` NEVER MUTATES ITS ARGUMENT.** This is the defect the contract
   itself names as most likely, because `Dictionary` is a reference type and
   `duplicate()` is shallow. Assert it the only way that actually catches it:
   hold a board, call `apply` on it, and check **the nested `a` and `b`
   dictionaries of the ORIGINAL** are unchanged — not just the top level. A
   test that only reads the returned board will pass against the broken
   implementation.
3. **Rejected input returns the board unchanged**: an unknown `side`, an award
   not in `AWARDS`, and any award at all applied to a board whose `over` is
   already `true`.
4. **`"ippon"` ends the contest** to the side it was given, with `over` true,
   `winner` set and `reason` == `"ippon"`.
5. **Two waza-ari.** The contract tells Grok to look this up and cite the
   article. So assert the SHAPE, not the answer: after two waza-ari to one
   side, either the contest is over with `reason == "waza_ari_awasete_ippon"`,
   or it is not over and the count stands at 2. **Anything else — a silent
   reset, a third state, an `over` with a reason outside `reasons()` — is a
   failure.** Say in the test's own message that both branches are accepted
   and why.
6. **Shido.** Same treatment: shidos accumulate, and at whatever number the
   module implements hansoku-make, the reason is `"hansoku_make_shido"` and
   the winner is the OTHER side. Assert that a shido never sets the winner to
   the side that received it.
7. **`hansoku_make` applied directly** ends the contest to the other side with
   `reason == "hansoku_make_direct"`.
8. **`decide()`**: on a level board it returns `golden_score == true` with
   `over` still `false`; on an unlevel board it sets `over`, `winner` and a
   `reason` **that is in `reasons()`**; on a board already `over` it returns it
   unchanged.
9. **`result()` agrees with the board** it was given, every time, and has no
   side effects — call it twice and get the same answer.
10. **`score_line()`** for every case the contract spells out, plus one case it
    does not: a side with all three counts non-zero, which must be
    `"W<n> Y<n> S<n>"` with single spaces.
11. **`reasons()`** is exactly the list above, in that order, and the empty
    string is NOT in it.

## When the module is absent — and it will be

**Do not `preload()` `JudoBoard.gd` at the top of the file.** A top-level
preload of a missing script is a load error, and a load error HANGS a headless
test until the timeout instead of failing it. Use `load()` inside the test
body, check the result, and if it is null print one clear line naming the
missing path and exit 1. That is the house pattern — C67's blind test did
exactly this and reported `witnesses=0` rather than crashing.

**A red test is the expected result of this task.** Push it red.

## Owned files

* `Godot/tests/judo_board_test.gd` — **NEW, and the only file you create.**

You own nothing else. You do NOT create `JudoBoard.gd`, not even a stub — a
stub would make your own test green against nothing and destroy the blind
arrangement. If your reading of the contract and Grok's module later disagree,
that is a **finding you report**, exactly as Q19 did on C67.

## Gate — a CEILING

```
python Godot/tools/check_scripts.py Godot/tests/judo_board_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/judo_board_test.gd
python Godot/tools/run_tests.py            # once, in the background, before the commit
```

The gate is that **the test RUNS** — no `SCRIPT ERROR`, no rc=124 hang — and
that every assertion traces to the contract. Failures are expected and any
number of them is acceptable, including zero. **Never tune an assertion to
pass.** The suite will be red by one or more from this test and from Codex's
C73; name what failed and push.

## Commit, push, report

`git status -s` FIRST — shared checkout, other agents' work may be pre-staged.
Stage your explicit path only.

```
git add -- Godot/tests/judo_board_test.gd
git commit    # house style; check `git log --oneline -5`
git push origin master
python Tools/agent_comms.py send --from qwen --to claude --subject G40T-done --body "<commit> TOTAL=<n> fails=<m> — module present or absent, and any contract ambiguity you had to resolve"
```

Do **not** edit `HANDOFF.md`.

## The trap specific to this task

**Assertion 2 is the whole task and it is easy to write uselessly.** The
obvious version — apply an award, then check the returned board has the new
count — passes against an implementation that mutated the caller's board, and
that implementation is the one the contract predicts. You must keep a
reference to the ORIGINAL board's nested `a` and `b` dictionaries and prove
they still read what they read before the call.

**Second trap: do not encode judo rules the contract did not fix.** Whether two
waza-ari combine is Grok's to source and cite. Your job is to assert that
whatever it decided is internally consistent and stays inside the vocabulary —
not to have your own opinion about the 2025-28 cycle.

# TASK C73 — CODEX — THE BLIND TEST FOR G39's CLINCH FOLD

Model: **Codex, high effort, Fast mode OFF.** Owner: Codex. Base: `master`
after `9cf17de`. Assigned 2026-09-10 by Claude.

You earned high effort on C72 by taking unowned scope and landing 218/0. This
one needs it: it is a contract test with four rulebooks in it and no module to
crib from.

---

## Why this exists, and what "blind" means here

Claude is building **R93** right now, in a parallel session: G39's per-seat
judo bands and the clinch conversions typed into
`Godot/scripts/GrappleAdapter.gd`. **You are writing the test for that work
blind, from the research file, without reading a line of what Claude typed.**

**Do not open `Godot/scripts/GrappleAdapter.gd`. Do not open
`Godot/scripts/FightRealtime.gd`. Do not read `R92_DIGEST.md`.** The API you
need is reproduced in full below, so you never need the module. This
arrangement has paid four times on this arc — C67's blind test, U29's blind
test, Q19 finding a real double-negative defect in C67's own test from failure
output alone, and G22/R71 before them. A test written against an
implementation only ever agrees with it.

## Your source, and your only source

**`research/G39_THE_CLINCH.md`.** Read it whole — it is 414 lines and it
is the contract. Everything you assert must trace to a line in it, and your
digest must be able to say which.

The sections that carry the tables: **§0** (verdict table), **§3.3** (what a
seat and a hold can and cannot say in judo), **§5** (duration — the sourced
clocks), **§6** (the REFUSE list), **§7.2** (the adapter fold, per ruleset),
**§9** (the ready-to-paste const blocks). §8 carries two open questions and
**both are decided as their stated defaults** — see "Decisions already made"
below, and assert the decision, not the alternative.

`research/G34_GRAPPLING_CONTRACT.md` §1/§2 is available for the exact
seat and event vocabulary — `sed -n` those sections only, do not read it whole.

## Decisions already made — assert these, do not re-open them

**G39 Q1 (IJF nage-waza from a seat): the INV heuristic, as G39 defaults it.**
`side` → yuko, `mount`/`back` → waza-ari, `guard`/`half` → not scored, **ippon
never derived from seat+grade**, and the throw's **grade is ignored entirely**
under IJF (`use_grade_for_score: false`).

**G39 Q2 (the clinch break clock): per-ruleset, and only judo has a published
one.** IJF publishes 45 s (SOR 18.1.1.4, positive progression). ABC, IFMA/WMC
muay thai, UWW and IBJJF publish **no clinch clock at all** — UWW's 30 s is a
passivity procedure and IBJJF runs on the match clock, and neither is a clinch
timer. The adapter reports `-1` for those, meaning NONE PUBLISHED, and the
engine's own break is authored separately and is not this module's business.

## The contract — the API, so you never need the module

`GrappleAdapter` is `class_name`-less, statics only, **zero preloads**. Load it
with `preload("res://scripts/GrappleAdapter.gd")` and call statics on it.

```gdscript
static func rulesets() -> Array                        # ["ijf","uww","ibjjf","abc"]
static func scores_grappling(ruleset: String) -> bool
static func award(ruleset: String, event: Dictionary) -> Dictionary
static func hold_gates_seconds(ruleset: String) -> Dictionary
static func advantage(ruleset: String, situation: Dictionary) -> int
static func stall(ruleset: String) -> Dictionary
static func clinch_break_ticks(ruleset: String) -> int   # NEW in R93
static func submission_meaning(ruleset: String) -> String
```

`award()` returns `{"kind": String, "points": int, "counter": String}`.
**`points` is `-1` whenever the ruleset does not score that emission, never
`0`.** `kind` is `"not_scored"` when nothing is scored, and `"evidence"` for
every ABC award (ABC counts, it does not number).

`clinch_break_ticks()` returns ticks at **20 Hz**, or `-1` for NONE PUBLISHED.

### The event dictionary — the engine's own record, which is canonical

```gdscript
{
  "kind": "clinch_engage" | "clinch_break" | "takedown" | "throw"
        | "position_change" | "exposure" | "submission_attempt" | "step_out" | "control",
  "to_seat":   "over_under" | "guard" | "half" | "side" | "mount" | "back" | "none",
  "from_seat": same vocabulary, "" when unknown,
  "grade":     int, 2 or 4 for a throw, 0 otherwise,
  "held_ticks": int at 20 Hz, -1 when not applicable,
  "finished":  bool, submissions only,
  "via":       String, "" or "sweep",
}
```

`seat` is accepted as a fallback spelling of `to_seat`, and `hold_seconds`
(float) as a fallback for `held_ticks`. **Prefer the canonical keys** —
`to_seat` and `held_ticks` — in your assertions; use a fallback spelling in at
most one or two cases, deliberately, to prove it still works.

## What to assert

Every cell of **G39 §7.2's four tables**, plus §3.3's osaekomi table and §6's
refusals. Concretely, and this is a floor not a ceiling:

**ijf** — `clinch_engage` and control not scored; `throw` per landing seat
(side/mount/back/guard/half) at BOTH grades, proving grade does not move the
answer; ippon never returned for any throw at any grade or seat; osaekomi from
a kept `side` or `mount` at 4 s, 5 s, 9 s, 10 s, 19 s, 20 s and 30 s against
the 5 / 10 / 20 table; `guard` and `half` starting no osaekomi clock at any
duration; a finished submission; `clinch_break_ticks("ijf")` = 900.

**uww** — `clinch_engage` and control not scored; the whole grade × seat
throw table from §7.2 including **`grade 4` + `back`**, which G39 puts in the
danger branch; grade 4 into `guard`/`half` staying at 2 because the landing is
not danger; **no throw ever returning 5** — §6 item 1; the step-out refusal;
`clinch_break_ticks("uww")` = -1.

**ibjjf** — the 60-tick (3 s) gate on a throw, asserted at 59, 60 and 61
ticks; each of the five landing seats above the gate; below the gate not
scored; `clinch_break_ticks("ibjjf")` = -1.

**abc** — every grapple emission that is scored at all coming back as
`evidence` with `points == -1`; `clinch_engage`, `clinch_break` and control
not scored; **no ABC award ever carrying a positive point value** — G39 §6
item 5 and §7.2's abc table; `clinch_break_ticks("abc")` = -1.

**Cross-cutting** — an unknown ruleset id returns `not_scored` / `-1` / `0`
rather than throwing; `rulesets()` is exactly the four; a `clinch_engage`
scores nothing under any of the four (that is one loop, four assertions, and
it is the single most valuable test in the file).

## Owned files

* `Godot/tests/grapple_clinch_contract_test.gd` — **NEW, and the only file you
  create or edit.**

You own nothing else. You do not edit `GrappleAdapter.gd` even if you are
certain it is wrong — a disagreement is a **finding you report**, and Q19
proved that reporting one is worth more than fixing it.

## Test shape

Match `Godot/tests/grapple_adapter_contract_test.gd` — it is your own C67
work, it is the house form for a blind contract test, and reading it is
allowed and encouraged. Print a `TOTAL=<n> fails=<m>` line and `CHECK`/`FAIL`
lines, and **exit rc=1 while any assertion fails**, as that file does.

## Gate — a CEILING, and failures are expected

```
python Godot/tools/check_scripts.py Godot/tests/grapple_clinch_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_clinch_contract_test.gd
python Godot/tools/run_tests.py            # once, in the background, before the commit
```

**The gate is that the test RUNS and every assertion traces to G39.** It is
expected to be RED while R93 is in flight — any number of failures is
acceptable, including zero, and if it comes back green that is a good result,
not a suspicious one. **rc=124 (a hang) or a `SCRIPT ERROR` is the only real
failure**: that means a parse error, and the parse gate above catches it in
about a second.

**Never edit an assertion to make it pass.** If your reading of G39 and the
module disagree, the assertion stays and the disagreement goes in the mail.
Name every failing assertion in your report — Claude reconciles them in R93,
and that reconciliation is the entire value of this task.

## Commit, push, report

`git status -s` FIRST — this is a shared checkout and another agent's work may
be pre-staged. Stage your explicit path only.

```
git add -- Godot/tests/grapple_clinch_contract_test.gd
git commit    # house style; check `git log --oneline -5`
git push origin master
python Tools/agent_comms.py send --from codex --to claude --subject C73-done --body "<commit> TOTAL=<n> fails=<m> SUITE total=<n> fails=<m> — <failing assertions, named>"
```

Write `research/C73_DIGEST.md`, short. Do **not** edit `HANDOFF.md`.

## The trap specific to this task

**The grade is a trap under IJF and load-bearing under UWW.** G39 says IJF
ignores the grade entirely (`use_grade_for_score: false`) and that UWW's whole
throw table is grade × landing seat. The natural instinct is one shared helper
that reads grade for everybody. Assert the asymmetry directly: **the same
event dictionary, fed to `award("ijf", …)` and `award("uww", …)`, must produce
answers that disagree about whether the grade mattered.** If the module ever
lets IJF read the grade, that pair of assertions is what catches it.

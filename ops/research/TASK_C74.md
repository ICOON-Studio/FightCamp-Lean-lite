# TASK C74 — CODEX — THE MUAY THAI ADAPTER, WHERE EVERY CELL IS A REFUSAL

Model: **Codex, high effort, Fast mode OFF.** Owner: Codex. Base: `master`
after R93 (`fecf6fc`). Assigned 2026-09-10 by Claude.

---

## Why this exists

`R92_DIGEST.md` finding 3: **muay thai folds ENGINE UNITS.** There is no
`muay_thai` entry in `RealtimeRoundStats.gd`'s `ADAPTER_FOR` (`:29`), so a MT
bout falls to `_fold_grapple` and a throw adds its grade 2 or 4 into
`throw_points_round` while control seconds become `control_score`.

Q24 went and read the books. **The IFMA and WMC rulebooks score none of it**,
and a hip throw is a *foul*. So today a muay thai card in this game carries
plausible numbers that are wrong — the same defect R85 named for taekwondo,
one file over, and the reason that classification is machine-checked rather
than commented.

Q24 also established the fact that decides the size of this task: **muay thai
DOES grapple in this engine** (its scoring profile weights takedowns 1.5), so
this is not a "turn it off" change. The events happen; what they are worth is
what changes.

## Your source, and your only source

**`research/Q24_MUAY_THAI_ADAPTER.md`** — 309 lines, read it whole. It
is the contract, it carries the anchors, and §4 is a ready-to-paste `const`
block that leaves no decision in it. §5 names every line you edit.

Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`,
`R92_DIGEST.md` or `R93_DIGEST.md`.

`research/G39_THE_CLINCH.md` §2 (`sed -n '71,122p'`) is available if you
want the underlying muay thai reading; it is not required.

## What to build

1. **The `mt` adapter in `GrappleAdapter.gd`.** Follow the shape of
   `_award_abc` — it is the closest analogue, because ABC also refuses to put
   a number on a grapple event. **But `mt` is not `abc`**: ABC returns
   `evidence` because a 10-point-must judge counts grappling as evidence, and
   muay thai's books say the clinch grapple is not scored *at all*. Q24 §1's
   verdict table says which cells are `not_scored`, which are `foul` and which
   are `REFUSE`, and **`not_scored` and `foul` must not be merged** — they are
   different answers.
2. **`rulesets()` gains `"mt"`**, and `scores_grappling("mt")` answers what
   Q24 §5 says it should. Read that section before you decide; it is not
   obvious and Q24 argues it.
3. **`clinch_break_ticks("mt")`** — R93 added this. IFMA and WMC publish no
   clinch clock, so the answer is `-1`, NONE PUBLISHED. The "5 seconds" in
   circulation is a WFMC/amateur primer and is refused by name in G39 §6.
4. **`ADAPTER_FOR` gains `"muay_thai": "mt"`** in `RealtimeRoundStats.gd:29`,
   and its comment — which currently says muay thai has no sourced conversion
   *yet* — is updated, because now it does.
5. `stall("mt")` and `submission_meaning("mt")` and `hold_gates_seconds("mt")`
   need answers. Q24 covers the first; for the others, an empty dict and an
   honest word beat a borrowed one.

## Owned files

* `Godot/scripts/GrappleAdapter.gd`
* `Godot/scripts/RealtimeRoundStats.gd`
* `Godot/tests/grapple_adapter_test.gd` — extend it if you need a witness for
  your own work, but see the split below.

**You do NOT write the contract test for this.** Qwen holds `Q27`, the blind
test for the `mt` fold, written from Q24 alone in parallel with you and
without reading your file. Do not create `grapple_mt_contract_test.gd`.

`FightRealtime.gd`, `PostFightRead.gd` and `BroadcastRead.gd` are out of
bounds — Cursor is inside the last two right now (U33).

## The thing that will actually bite

**A muay thai bout must still produce a scorecard.** Muay thai is a STRIKING
sport with a full damage weight; R85 re-pinned it against the real-time engine
precisely because its `scoring_profile` weights `damage` at 1.0. Everything
you are doing here is about the GRAPPLE counters only. If your change moves a
muay thai bout's striking numbers, or its judges' cards, you have changed
something you were not asked to change.

**Prove it, do not assume it.** Run a seeded muay thai bout before and after
and compare the card. `Godot/tests/fight_realtime_test.gd` has the helpers —
`_ruleset("muay_thai")`, `_run_pair`, `_grappler`, `_fish` — and
`judge_panel_test.gd` is the pin file. **`judge_panel_test` must stay green
with the pin file UNEDITED.** If it goes red, that is a finding to report
before anything else, and a red card is NEVER fixed by re-pinning it.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/GrappleAdapter.gd Godot/scripts/RealtimeRoundStats.gd Godot/tests/grapple_adapter_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_adapter_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_adapter_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_clinch_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/realtime_round_stats_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/judge_panel_test.gd
python Godot/tools/run_tests.py            # once, in the background, before the commit
```

Parse gate first, always — a parse error hangs a headless test instead of
failing it.

**Suite ceiling: `fails=1` or better.** The tree is GREEN at
`SUITE total=220 fails=0` as of `fecf6fc`, and Qwen's Q27 blind test may land
red-by-design while you work. **If your run is lower than the ceiling, say so
and push** — a better result is never a reason to hold work. Name any failure
in a file you do not own; never fix one.

## Commit, push, report

`git status -s` FIRST — shared checkout. Stage explicit paths only.

```
git push origin master
python Tools/agent_comms.py send --from codex --to claude --topic C74-done --body "<commit> SUITE total=<n> fails=<m> — what mt refuses, and whether any muay thai card moved"
```

The mail flag is `--topic`, not `--subject`. Write
`research/C74_DIGEST.md`, short. Do **not** edit `HANDOFF.md`.

## The trap specific to this task

**`not_scored` is not the same as "the adapter does nothing".** Q24's whole
argument is that a muay thai throw is honestly worth NOTHING under IFMA 29.2.2
and WMC 14.3.5, and that a hip throw is a foul we cannot detect — so the
correct behaviour is a positive, documented refusal, not an absent adapter
key. An absent key falls through to `_fold_grapple` and the engine units come
straight back. **Assert that a muay thai bout's `throw_points_round` is zero
in a real seeded bout where a throw actually occurred** — that is the
difference between the fix and the appearance of one, and it is exactly the
"assert that a feature OCCURS" rule pointed the other way.

# TASK_C141 — CODEX — BINDING A HELD POSITION: THE CONTRACT TEST, WRITTEN BLIND

**Agent:** Codex · **Model:** gpt-5.6-luna · **Effort:** medium · **Fast:** off
**Launch:** `Tools\codex_task.cmd` with WINDOWS paths, from PowerShell, in the MAIN checkout.
**Read this file and only the files it names.** Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest, and do not explore to "get oriented".

**Test tier: ONE NEW TEST FILE ONLY, no script edited.** Parse gate plus that one test:

```
python Godot/tools/check_scripts.py Godot/tests/fight_hold_binding_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_hold_binding_test.gd
```

**NO FULL SUITE.** A new test file cannot break another test, so a suite run there buys nothing
and costs twenty minutes.

---

## THE SITUATION, AND WHY THIS IS A BLIND TEST

The operator ruled on 2026-09-21 that we author the five ground and clinch positions we own no
paired film for. The first is a clinch. A held position is **two single-actor clips plus one
binding entry** — it is the cheapest shape in the whole paired pipeline, and it is about to be
used five times in a row, so the contract wants a test before the content arrives.

**You are writing this test from the CONTRACT below, not from the implementation.** Read
`Godot/scripts/FightClipBinding.gd` only at the anchors named here, to learn the existing shape.
Do not read it whole (it is large), do not modify it, and do not write the test by reading what
the code happens to do — a test written against an implementation only ever agrees with it.

## THE CONTRACT

`Godot/scripts/FightClipBinding.gd:882` declares `const PAIRED_BINDINGS`. Every entry is keyed by
a GRAPPLE id and carries exactly six fields:

```gdscript
"grapple_sweep": {
    "pair_key": "Paired_FullMount_Reversal",
    "att": PAIRED_DIR + "Paired_FullMount_Reversal_Att.fbx",
    "vic": PAIRED_DIR + "Paired_FullMount_Reversal_Vic.fbx",
    "start_s": 0.000, "end_s": 1.833, "content_s": 1.833,
},
```

`FightClipBinding.gd:1054` and `:1176` are the two places that read it.

**A HELD POSITION is the degenerate case of this shape and the test is about the degenerate
case**, because that is where a rule written for strikes will quietly be wrong:

1. **The two clips are the same length.** `_Att` and `_Vic` are one performance cut in two; a
   binding whose two files disagree in duration is a defect, not a style.
2. **`content_s` is the playable content and `end_s - start_s` must not exceed it.** A hold that
   claims more content than it has will run off the end of the clip.
3. **A hold LOOPS and a strike does not.** The last frame must be able to hand back to the first
   without a jump. Express that as a contract on the binding's own numbers — you do not have the
   clips, so do not test the geometry, test the DECLARATION.
4. **Every `att` path ends `_Att` and every `vic` path ends `_Vic`, and they share the
   `pair_key` stem.** This is the rule that catches a copy-paste binding pointing both actors at
   the same file — `grapple_clinch_break` currently shares `Paired_FullMount_PushOff` with
   `grapple_escape`, which is legitimate REUSE of one pair by two ids and must NOT be flagged;
   what must be flagged is one ENTRY whose att and vic disagree in stem.
5. **A binding names a file that exists**, or the entry is dead.

## WHAT TO WRITE

`Godot/tests/fight_hold_binding_test.gd`, in the style of the existing tests in `Godot/tests/`.
It walks every entry of `PAIRED_BINDINGS` and asserts the five rules above. It prints one line
per check and a final `failures=N`.

**Rules 1 and 5 need the files. Where a file is genuinely absent, the test must say
`SKIP <id> (no clip on disk)` and NOT fail** — the repo does not carry every paired asset, and a
test that fails on a missing purchase is a test nobody can keep green. Count the skips and print
them. Rules 2, 3 and 4 are pure declaration checks and must run on every entry regardless.

## PROVE THE TEST BEFORE YOU HAND IT OVER

**A contract test that has never seen a failure is not evidence.** Break the contract four ways
in a scratch copy of the data — not in `FightClipBinding.gd` — and record in your digest that
each one was caught:

- an entry whose `end_s - start_s` exceeds `content_s`
- an entry whose `att` and `vic` stems differ
- an entry with `content_s` of 0.0
- an entry missing one of the six fields entirely

If any mutant survives, the test is too weak; fix the test, not the mutant.

## DELIVERABLES

- `Godot/tests/fight_hold_binding_test.gd`
- `research/C141_HOLD_BINDING_CONTRACT.md` — the contract as you understood it, the run
  output with its real `failures=` and skip count, and the four mutants with what each one
  produced.

Commit with explicit paths, push your branch, write the digest, and send one line with
`python Tools/agent_comms.py send --from codex --to claude --topic c141-ready --body "<one line>"`.
Do NOT edit `HANDOFF.md`. Do NOT edit `FightClipBinding.gd`.

## THE TRAP SPECIFIC TO THIS TASK

**`var x := <call>` fails when the call returns Variant** — and `PAIRED_BINDINGS[id]` is an
untyped `Dictionary` lookup, so every value you pull out of it is a Variant. Write the type:
`var content_s: float = entry["content_s"]`, never `var content_s := entry["content_s"]`. This
exact line has cost a fix cycle in this repo more than once, and a parse error does not fail a
headless test, it HANGS it until the timeout.

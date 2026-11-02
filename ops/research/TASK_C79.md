# TASK C79 — CODEX — THE BLIND TEST FOR THE REAL-TIME CORNER INSTRUCTION

Model: gpt-5-codex, high effort, Fast OFF.
Assigned by Claude, 2026-09-10. Owner: codex.

## What this is

Cursor is repairing U37 **right now**: master is red because a player's corner
instruction is a silent no-op on the real-time path
(`smoke_test.gd`, `instructions_applied: 0`, `uses_realtime: true`).

**You write the test for the repair, from the contract below and from nothing
else.** Do not read Cursor's changes to `FightNightScreen.gd`,
`FightBeatAdapter.gd` or `FightRealtime.gd`. Do not wait for U37 to land. If it
has not landed when you run, your test goes RED and that is the correct result —
C77 did exactly this today against a module that did not exist yet, and passed
3661 checks first run when it appeared.

The split has now paid eight times. It matters more than usual here, because
U37 is allowed to land an **honest refusal** instead of a feature, and a test
written after the fact would simply agree with whichever it chose.

## Owned files

- `Godot/tests/corner_instruction_contract_test.gd` — **NEW, yours, the only file
  you create or edit.**

You own nothing else. **Do not edit `smoke_test.gd`** — it is right, and it is the
test that caught this. Do not edit `HANDOFF.md`.

## THE CONTRACT — three permitted outcomes, and you assert all three

U37 may land any ONE of these. Your test must accept the correct behaviour of
whichever it is, and must FAIL a silent no-op in every case. Detect which world
you are in from observable state, not from reading the diff.

### Outcome A — the instruction is applied to FUTURE ticks

The real-time path accepts a corner instruction at the rest and it changes how
the NEXT round is fought.

Assert:
- after a corner instruction is applied on a real-time bout, the count of
  applied instructions is **> 0** — this is the assertion that is red today;
- the instruction changes **only ticks that have not happened**. Take a seeded
  bout, run to a rest, snapshot the log; apply an instruction; assert **every
  log entry that already existed is byte-identical afterwards.** This is G42's
  rule and the whole reason the atomic verb could not simply be reused;
- applying a **second** instruction in the same rest either replaces the first or
  is refused — never silently stacks. G44 §4 item 3 is explicit that a second
  instruction is a lie; assert whichever of replace-or-refuse holds and say which
  in your done-mail;
- an instruction offered for a side that is not coached is refused.

### Outcome B — an honest refusal

The real-time path does not take a corner instruction yet, and **says so**.

Assert:
- the dock/screen does **not** offer a corner instruction it will discard on a
  real-time bout — a refusal that is visible in state, not a silently dropped
  call;
- the refusal is **queryable**: something on the screen or the adapter reports
  that this path takes no instruction, so a test can tell the difference between
  "refused" and "ignored". **A no-op that reports nothing must fail your test.**

### Outcome C — neither, i.e. it is still a silent no-op

Your test **must fail**, with a message naming `instructions_applied` and the
ruleset. This is the guard: if U37 makes `smoke_test` green by making the dock
stop asking while leaving the call silently dropped, C79 is what catches it.

## The invariant that spans all three

**On the ATOMIC path nothing changes.** Judo, taekwondo and freestyle wrestling
stay on `FightSimulation` by R85's ruling, and their corner instruction already
works. Assert a freestyle-wrestling bout still pauses, applies and resumes
exactly as it does today. If U37 broke the atomic path to fix the real-time one,
that is the most expensive possible outcome and your test must say so.

## Anchors

| what | where |
|---|---|
| the refusal as it stands today | `FightNightScreen.gd:661` (`_on_instruction`) |
| which rulesets are real-time | `FightNightScreen.ruleset_uses_realtime()` `:166` |
| the flag on the published frame | `FightNightScreen.gd:868` (`uses_realtime`) |
| the failing assertion | `Godot/tests/smoke_test.gd`, "interactive corner-instruction flow" |
| the design | `research/G44_WHAT_A_MANAGER_DOES_MID_FIGHT.md` §4 item 3, and §3 |

`FightNightScreen.gd` is ~1,050 lines — read it whole if you need the harness
shape, but **read it as it is on master, before U37 lands**, and do not pull
Cursor's commit to look. `FightRealtime.gd` is 2,086 lines: never open it whole.

## THE GATE — tier: NEW TEST FILE ONLY

A new test file cannot break another test.

```bash
python Godot/tools/check_scripts.py Godot/tests/corner_instruction_contract_test.gd
```

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/corner_instruction_contract_test.gd
```

**Do NOT run the full suite** — it took 90 minutes today on a busy machine, and
Cursor is running Godot right now on the same checkout. **NEVER pass `--godot` to
`run_tests.py`.** `rc=1` because U37 has not landed is expected. `rc=124` is a
hang and is real — fix it.

## Deliver

1. `git rev-parse --abbrev-ref HEAD` — MUST say master.
2. `git add -- Godot/tests/corner_instruction_contract_test.gd research/C79_DIGEST.md`,
   commit, push. **Cursor is editing this shared checkout concurrently — stage
   explicit paths only and check `git status -s` first so you do not sweep its WIP
   into your commit.**
3. `research/C79_DIGEST.md`, short.
4. `python Tools/agent_comms.py send --from codex --to claude --topic C79-done --body "<commit> <test totals> <which outcome the tree was in when you ran> <replace-or-refuse reading you took>"`
   (`--topic`, not `--subject` — you hit that on C78 today.)

## The one trap specific to C79

**Do not write a test that only passes Outcome A.** U37 is explicitly permitted
to land an honest refusal, and a test that demands the feature would force a
worse fix or get weakened later to let the refusal through — and a weakened
assertion is how a live feature loses its last guard. Write it so that a truthful
refusal passes, a working instruction passes, and **silence fails**.

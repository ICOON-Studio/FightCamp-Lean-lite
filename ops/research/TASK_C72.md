# TASK C72 — CODEX — THE FIFTH METHOD REACHES THE RECORD

Model: **Codex, high effort, Fast mode off.** Owner: Codex. Base: `master`
after R91 (`0020568`). Assigned 2026-09-10.

---

## Why this exists

R91 added the fifth engine method: `FightRealtime.result()` now returns
`"SUBMISSION"` (G35 §3's exact string) when a hold finishes a fight. The
record layer was written before that string existed, and it spells the same
fact `"SUB"`:

| File | Line | What it says |
| --- | --- | --- |
| `FightRecordStats.gd` (172) | `:7-8` alias map, `:20`, `:77` `is_finish := method == "KO" or method == "TKO" or method == "SUB"` | a SUBMISSION bout is NOT a finish |
| `Mileage.gd` (80) | `:15-16` `FINISH_GIVEN := ["KO", "TKO", "SUB"]` | same |
| `CareerEpilogue.gd` (190) | `:8` `METHOD_FINISH := ["KO", "TKO", "SUB"]` | same |
| `FightContract.gd` (542) | `:69` `FINISH_METHODS := ["KO", "TKO", "SUBMISSION", "RETIREMENT", "DQ"]` | the ONE file that already agrees with the engine |
| `BodyReadiness.gd` (774) | `:277`, `:349`, `:592` `stoppage := method.contains("KO") ...` | a submission is not a KO and must NOT be treated as head trauma |
| `FightLog.gd` | `:119` | classifies stoppage words |
| `FightResultPanel.gd` | `:980-982` | words on the result screen |
| `TaleOfTape.gd` | `:304` | same |
| `ProfileRevampPanel.gd` | `:73` `METHOD_WORDS` has `"SUB": "SUBMISSION"` | the record chip |
| `UIKit.gd` (huge) | `:6765` method words table | `"DOCTOR"` has a word; SUBMISSION may not |

**This is the tenth piece of correct, tested, unreachable code in one area if
nobody joins the two spellings**: a real-time fight will end by submission and
the record will call it a decision.

## What to do

1. **One canonical string, one alias map.** The engine's `"SUBMISSION"` is
   canonical (G35). Where a consumer keys on `"SUB"`, accept both through ONE
   shared normaliser rather than eleven local `or`s - `FightRecordStats.gd:7`
   already has an alias map; make it the place, and have the others call it
   or copy its two-line rule with a comment saying where it came from.
2. **A submission is a FINISH but not a KO.** `FightRecordStats`, `Mileage`,
   `CareerEpilogue`, `FightContract` count it as a finish. `BodyReadiness`
   must NOT: a tap is not head trauma (G35 §1.4 - a joint finish MAY flag an
   injury, and that is a side write for a later task, not this one). Assert
   both directions.
3. **Words.** `ProfileRevampPanel.METHOD_WORDS`, `UIKit`'s table,
   `FightResultPanel`, `TaleOfTape`, `FightLog` print `SUBMISSION` for either
   spelling. Never "SUB" on a screen.
4. **Prove it flows.** `GameState._apply_fight_result` (`:12145`) is where a
   bout reaches the athlete; `"method"` is read at `:2246-2269` and `:2587-2605`.
   Find with `grep -n "func _apply_fight_result\|\"method\"" Godot/scripts/GameState.gd`
   and read `sed -n` windows only - **GameState.gd is 14,769 lines, never open
   it whole, and do NOT edit it**: if the flow needs a GameState change, report
   the exact line and stop there.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/scripts/FightRecordStats.gd` | 172 | Read whole. The alias map lives here. |
| `Godot/scripts/Mileage.gd` | 80 | Read whole. |
| `Godot/scripts/CareerEpilogue.gd` | 190 | Read whole. |
| `Godot/scripts/BodyReadiness.gd` | 774 | `sed -n` windows at `:270-285`, `:342-356`, `:585-600` only. |
| `Godot/scripts/FightLog.gd`, `FightResultPanel.gd`, `TaleOfTape.gd`, `ProfileRevampPanel.gd` | | The cited lines only; `ProfileRevampPanel.gd` is ~2,000 lines. |
| `Godot/scripts/UIKit.gd` | ~7,000 | `:6755-6775` only. |
| `Godot/tests/fifth_method_reaches_the_record_test.gd` | new | House shape: `_check`, `FIFTH_METHOD_TEST PASS (N checks)` / `failures=N`. |
| `research/C72_DIGEST.md` | new | Short; list every consumer touched and every one deliberately left. |

Do NOT touch `FightRealtime.gd`, `RealtimeRoundStats.gd`, `GrappleAdapter.gd`
(Claude, R92), `FightHudRead.gd` (Qwen), `FightHudPanel.gd` (Cursor),
`GameState.gd`. Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py <every .gd you touched>
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fifth_method_reaches_the_record_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_record_stats_test.gd
python Godot/tools/run_tests.py
```

(If `fight_record_stats_test.gd` does not exist under that name, run the
tests of every file you touched - `ls Godot/tests | grep -i "record\|mileage\|epilogue\|readiness"`.)
**Ceiling:** `fails=0`. Another agent may be running Godot; an all-failed
suite line is contention, re-run it.

## Done

Commit, push `master`, write `research/C72_DIGEST.md`, send:

```
python Tools/agent_comms.py send --from codex --to claude --topic "C72-done" --body "<commit> <suite line> <consumers touched / left>"
```

`git add` the mail file into your commit. Stage explicit paths only; the
checkout is shared. Do NOT edit `HANDOFF.md`.

## The trap specific to this task

**BodyReadiness.** The easy edit is to add `SUBMISSION` beside `KO` in three
`contains()` lines and call the audit done. That would send a man who tapped
to an armbar into the concussion protocol. A submission is a finish for the
record and NOT a stoppage for the head; the test must hold both.

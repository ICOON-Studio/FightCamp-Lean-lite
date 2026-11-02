# TASK C32 — THE CORNER, ONE RULE (Codex)

**Status: COMPLETE 2026-09-07.** Landed by Codex as `bc696fc`; verified and
recorded by Claude (14/14, parse 3/3, suite green). Engine only. Small.

Model: Sonnet, effort medium, Fast off.

## The user decision this task exists under

**The game gets ONE corner rule** (user decision, 2026-09-07). C31 found that
commissions differ — California permits a corner towel, New York MMA calls it
interference, New Jersey reserves the stop to the referee. **The game will
not model that.** No player picks a state athletic commission, so a
jurisdiction table would be depth nobody sees.

So the rule is the game's own, authored once, and labelled `invented` — the
same way R44's membership rate is the game's own because nothing published
says what a fight gym charges (J5 G24). C31 is the citation for *why* it is
authored rather than looked up. Nothing else about C31 carries into this task.

## The rule

| Key | Value |
| --- | --- |
| `seconds_allowed` | 3 |
| `chief_second_required` | true |
| `cutman_permitted` | true (counts against the three) |
| `stoppage_authority` | `referee` (a physician may also stop it; a corner signals, the referee ends it) |
| `corner_fee` | nothing recorded — **`absent`** |

That is the whole rule. **No jurisdiction key, no commission list, no
per-organization override.**

## What to build

1. **`Godot/assets/data/corner_rules.json`** — one flat block, the five keys
   above. Sits beside `championship_rules.json` and `membership.json` and is
   tuned the same way.
2. **`Godot/scripts/CornerRulesRead.gd`** — pure, `RefCounted`, copy-safe,
   `static func build(...)`. Reads the file, returns the rule. It does **not**
   consult the organization, the ruleset or `Sanctioning.gd`: one rule, every
   event.
3. **`GameState.get_corner_rules_read() -> Dictionary`** — no arguments, in
   the **read-API region only**, beside `get_gym_ledger_read()`
   (`GameState.gd:9692`). Thin wrapper, `.duplicate(true)`, nothing else.
4. **`Godot/tests/corner_rules_read_test.gd`** — new file, exits 0.

## The one grammar rule to hold

The read carries `source` and `why` per value, exactly as C27's
`GymLedgerRead` and C28's `AthletePurseRead` do — R46 draws both on screen, so
a player reads those words. Everything here is **`invented`** and its `why`
says so plainly: commissions differ and this is the game's own number, not a
claim about any real commission.

**`corner_fee` is a present entry wearing `absent`** — never a missing key,
never a guess. C31 found no published corner percentage; J6 A4/A6/A10 stands,
and C27's `corner_fees` is an honest zero on R46's desk because of it. **Do
not author a corner fee.**

## Out of scope

- No jurisdiction table, no commission list, no per-organization override.
- No UI, no `FightNightScreen.gd`, no `FightSimulation.gd`, no new or changed
  live corner command.
- No stoppage behaviour change: nothing consumes this read yet, deliberately.
- No `competition_rulesets_v2.json` edit.
- No `HANDOFF.md` edit — send the digest line through the mailbox and Claude
  writes the block, as with C31.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/CornerRulesRead.gd Godot/scripts/GameState.gd Godot/tests/corner_rules_read_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/corner_rules_read_test.gd
```

Then the full suite ONCE before the commit.

## Done

Commit and push `master`, write `research/C32_DIGEST.md` (short), send
`python Tools/agent_comms.py send --from codex --to claude --topic c32-landed --body "..."`
with the commit hash and the digest line, and mark the task done with
`python Tools/agent_comms.py done --task C32`.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/CornerRulesRead.gd
Godot/scripts/GameState.gd
Godot/tests/corner_rules_read_test.gd
research/C32_DIGEST.md
```

# TASK C43F — CODEX — THE SEVEN TESTS GRAPPLE LEFT RED

Model: **gpt-5.6-luna**, effort **high**, Fast off. One session.

This is the follow-up to your own C43. It is not a new system and it is not a
judgement call about grapple — grapple is correct and stays. It is seven tests
that were green before your commit and are red after it, and one of them is
probably a real bug in money.

## The evidence, so you do not have to rediscover it

Claude ran the eight failing tests against `37cde40` (G18, the commit
immediately before yours) and against `4e353eb` (`Add GRAPPLE as seventh
athlete stat`). Same machine, same Godot, only the commit differs:

| Test | at 37cde40 | at 4e353eb |
|---|---|---|
| `belt_scale_test` | PASS | FAIL |
| `booking_board_api_test` | PASS | FAIL |
| `featured_real_athletes_test` | PASS | FAIL |
| `fight_camp_test` | PASS | FAIL |
| `fight_contract_test` | PASS | FAIL |
| `retention_test` | PASS | FAIL |
| `rivalries_test` | PASS | FAIL |
| `profile_revamp_test` | FAIL (1 check) | FAIL (3 checks) |

C43 updated five test files — `aging_test`, `athlete_development_test`,
`development_screen_test`, `fight_opponent_generator_test`, `stat_help_test` —
and stopped. It edited `WorldPopulation.gd` (+24 lines), `Retention.gd`,
`FightCamp.gd`, `AthleteStatModel.gd`, `AthleteDevelopment.gd`, `GameState.gd`
and `ProfileRevampPanel.gd` without touching the tests that cover them.

## The one failure that is NOT yours — do not chase it

`profile_revamp_test` fails this check on BOTH sides of your commit:

```
FAIL: overview builds the hero, the action row, the tabs and the body
```

It predates grapple and belongs to another task. **Leave it failing.** Your two
in that file are the ones your commit added:

```
FAIL: six attribute rows                  # profile_revamp_test.gd:125
FAIL: the radar has six axes              # profile_revamp_test.gd:127
```

Both assert `== 6`. Grapple made it seven. These are stale assertions and you
update them.

## The judgement this task actually needs

**Not every red test is a stale number.** For each of the seven, decide which
of two things you are looking at, and say which in your digest:

- **A stale assertion** — the test hard-codes six attributes, or a stat list,
  or a dictionary size, and grapple legitimately changed it. Update the test.
- **A real regression** — your change altered behaviour that was correct
  before. Fix the CODE, not the test.

**Start with this one, because it is almost certainly the second kind:**

```
FAIL: R43: an uncontracted bout still pays the raw tier numbers plus any
      award, to the FIGHTER (2400, got 5600)
```

That is a payout of 2400 becoming 5600 — money, more than doubled, in a rule
about uncontracted bouts. Nothing about a seventh attribute should touch a
purse. Find why it moved before you touch anything else; if grapple threaded
into a fight-money path it had no business in, that is the actual bug and it
may explain several of the other six too. **Do not edit
`fight_contract_test.gd` to accept 5600** unless you can state, in the digest,
the rule that makes 5600 the right answer.

`belt_scale_test`'s `T9 he keeps the win itself - the scale takes the belt, not
the result` is the same shape of question: a rule about what a belt scale
takes, failing after a stat change. Treat it with the same suspicion.

## Owned files

The eight test files above, and — only where you have found a real regression —
the production files C43 already touched. Do not widen beyond them.

`GameState.gd` is **13,821 lines — never open it whole.** C43's own hunk is
9 lines; find it with `git show 4e353eb -- Godot/scripts/GameState.gd` rather
than reading the file. Same for `WorldPopulation.gd` and `FightCamp.gd`: read
your own diff first, `git show 4e353eb -- <path>`, and only open a window
around what it changed.

## Refusals

- **Do not revert grapple.** It is correct, it is landed, C43 is COMPLETE. This
  task makes the suite honest about it.
- **Do not make a test pass by weakening it.** Deleting a check, loosening an
  equality to a range, or asserting `>= 6` where the point was exactly six is a
  failed task.
- **Do not touch the pre-existing `overview builds the hero` failure.**
- **Do not edit `HANDOFF.md`.** Claude writes the blocks.
- **Do not touch** `RecoveryWords.gd`, `recovery_words_test.gd`, `MatRig.gd`,
  `mat_rig_test.gd`, `ProfileRevampPanel.gd`'s layout, or anything Cursor's U8
  is in — U8 is in flight in `ProfileRevampPanel.gd`, `Aging.gd`,
  `AthleteDevelopment.gd` and `WorldPopulation.gd`. If your fix needs one of
  those files, say so in your report and coordinate rather than racing it.

## Gate

Parse gate BEFORE any test — a parse error HANGS a headless test until the
timeout instead of failing it:

```
python Godot/tools/check_scripts.py <every .gd file you touched>
```

Then, from `Godot/`, the eight directly:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/fight_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/belt_scale_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/booking_board_api_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/featured_real_athletes_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/fight_camp_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/retention_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/rivalries_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/profile_revamp_test.gd
```

then `smoke_test.gd`, then the full suite ONCE in the background before the
commit. **The suite must end at exactly one failure** — the pre-existing
`overview builds the hero` check in `profile_revamp_test`. Report the number.

## The one trap

**C43 shipped reporting COMPLETE with eight tests red.** The suite is a
background command whose output is one summary line; it is cheap and it is the
only thing that would have caught this. Run it before you commit, read the
line, and if it is not `fails=1` do not push. A digest that says COMPLETE while
master is red costs the next agent a session working out whose failure it is —
this task exists because that already happened once.

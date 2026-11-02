# U34 DIGEST — JudoBoard gets a caller

## Feed chosen

**`GrappleAdapter.award("ijf", event)` at the `_log_grapple` door**, plus
`GrappleAdapter.stall("ijf").consequence` for shido on stall events.

Why not `RealtimeRoundStats.fold`: the fold runs at the bell, after the
contest should already have stopped on ippon / third shido. Feeding from the
same award the fold uses, on the event the log just kept, means one reading of
the rulebook — not two foldings of one log that can disagree.

Osaekomi that outlasts the hold-gate event is applied once more: at 20 s
(live ippon) and when leaving side/mount (yuko/waza-ari at full kept ticks) —
still through `award`, with the held duration the fold would reconstruct.

## Trap handled

`Board.apply` / `decide` never mutate; every call reassigns
`state["judo_board"]`. Tests assert endings **occur**, not that they are
permitted.

## Method

Sixth constant: `METHOD_CONTEST := "CONTEST"`. `_stop` stores that family name;
`result()` surfaces the board's `contest_reason` (`ippon`,
`waza_ari_awasete_ippon`, `hansoku_make_shido`, …) as `method`.

## Seeds (grappler vs fish, judo ruleset, rounds=1, round_seconds=240)

Search 94000..94199 on 2026-09-10:

| Ending | Seeds |
| --- | --- |
| `ippon` | 94004, 94009, 94017 |
| `hansoku_make_shido` | 94006, 94020, 94029 |

## Judo-only stall ladder (so the third shido can happen)

The shared 400-tick ground stall topped out at two warnings a bout (seat
changes reset the stage). Judo only:

- ground stall fire at **120** ticks (authored)
- stand-up at stage **3** (others stay at 2)
- `stall_stage` preserved across seat changes (contest-wide warning ladder)

Boxing/MMA untouched.

## Golden-score wall

`Board.decide` at the final bell settles a score lead. Equal scores set
`golden_score` and leave stoppage empty — this engine has no GS clock (G41).
Noted, not fixed.

## Proof boxing did not move

- `judo_board` is created only when `ruleset_id == "judo"`
- Boxing seed 91500 still replays byte-for-byte in the U34 test
- `judge_panel` subset: **1/0** (pin file unedited)
- `grapple` subset: **7/0**

## Gates

```
realtime 2/0
judo 1/0
judge_panel 1/0
grapple 7/0
```

R92 clinch window widened to 24 seeds and accepts `half` landings (Q28);
that was already red on master at 12 seeds / guard|side only before this
board landed.

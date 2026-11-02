# TASK_S14 — THE SUBSTITUTE COLUMN: STOP COUNTING A TRUE PICTURE AS A LIE, THEN SHOW THE DEFENCE

Owner: Claude. Model: Opus, HIGH effort, Fast OFF.
GREENLIT by the operator 2026-09-18: "Go B with A folded in then c".

## THE COLUMN

S13 emptied half the DEGRADE column and deliberately did not touch SUBSTITUTE:
66,543 beats, **19.8% of every action beat**, where the room shows a different
move than the engine scored. Numbers are `research/S13_PRESENTATION_SPLIT.md`.

| rank | engine threw -> room plays | beats | share |
|---:|---|---:|---:|
| 1 | `boxing_rear_hook -> hook_rear` | 14,368 | 4.28% |
| 2 | `boxing_catch_counter -> cross` | 10,369 | 3.09% |
| 3 | `boxing_one_two -> jab` | 10,155 | 3.03% |
| 4 | `boxing_cross_body -> strike_body` | 6,346 | 1.89% |
| 5 | `boxing_slip_counter -> cross` | 6,258 | 1.87% |
| 6 | `boxing_jab_body -> strike_body` | 6,240 | 1.86% |
| 7 | `boxing_one_two_hook -> hook_lead` | 6,140 | 1.83% |
| 8 | `boxing_rear_uppercut -> hook_rear` | 4,173 | 1.24% |
| 9 | `boxing_lead_uppercut -> hook_lead` | 2,494 | 0.74% |

## PART A — ONE LINE, AND IT CHANGES NO PIXEL

**`boxing_rear_hook` plays `hook_rear`, which IS a rear hook.** It is counted a
substitute only because the id sits in `FightStagePlayer.NEAREST_CLIP:1006` and
not in `FightBeatAdapter.TECHNIQUE_CLIP_ALIASES`. `boxing_lead_hook` WAS aliased
(`:162`) and its mirror was not; no reason is recorded anywhere for the
asymmetry. Move it to the alias table and delete the `NEAREST_CLIP` row.

**SAY WHAT THIS BUYS, IN THE DIGEST, IN THESE WORDS: the picture was already
right and the measurement was wrong about it.** 14,368 of the 66,543 beats we
have been publishing as "shows a move that was never thrown" are not lies. This
corrects a MISLABEL. It moves no pixel, and a digest that reports it as a
presentation win is the S6c accounting error with a new hat.

`tests/fight_clip_alias_test.gd` check 7 already forbids an id being in both
tables, so it will go red until the `NEAREST_CLIP` row is deleted. That is the
test doing its job — do not weaken it.

## PART B — THE DEFENCE THAT NEVER REACHES THE SCREEN

`boxing_catch_counter` ("Catch and Return", tier 2, branch `defense_counters`,
**no `technique_class` at all**) and `boxing_slip_counter` ("Slip-Cross
Counter", tier 2, same branch) are **16,627 beats** where the engine scored a
DEFENSIVE counter and the room shows a bare cross. The catch and the slip are
invisible. The operator's 2026-09-18 ruling names dodge and repositioning as
what footwork is FOR, which is why this row is the one worth the stage.

**ESTABLISH THE MECHANISM BEFORE YOU BIND ANYTHING.** A counter is TWO
movements and `_thrower_clip` returns ONE role. Do not assume this is a table
edit. The precedent for a two-clip beat is already in the player:
`FightStagePlayer.gd:366-373` blends and `queue()`s the get-up behind a
knockdown, and `_queue_stance` does the same for every other clip. So the
question to answer FIRST, with a grep and not a guess, is whether a counter beat
can queue slip -> cross the same way, and what that does to the beat's time
budget in `FightPresentationQueue`.

Three outcomes, and the task is honest under any of them:
1. It can queue → the counter shows its defensive half. That is the win.
2. It cannot without a wider change → say so, name the change, bind nothing,
   and it becomes its own stage. **A half-built sequencer is worse than the
   bare cross.**
3. The slip clip alone reads better than the cross → that is a product call,
   not yours; put it to the operator with both options named.

### FILMS WE OWN FOR IT, AND NONE HAS BEEN WATCHED

Render them before binding — S13, S6b and R127 all turned on somebody finally
looking. Extend `SOLOS` in `Godot/tools/audit_unbound_contact_sheets.gd` with an
`out` of a new `res://research/S14_SHEETS`, then:

```
xvfb-run -a -s "-screen 0 480x620x24" godot --path Godot \
  --script tools/audit_unbound_contact_sheets.gd \
  --resolution 480x620 --rendering-driver opengl3 -- Dodge SlipRight FadeBack
```

| film | bound? | for |
|---|---|---|
| `H2H_SlipLeft.FBX` | bound to `slip` | the CONTROL — what a slip already looks like here |
| `H2H_SlipRight.FBX` | **unbound** | the other side; `slip` plays one direction today |
| `H2H_Dodge_Back/Forward/Left/Right.FBX` | **unbound, x4** | catch / reposition / evade |
| `H2H_FadeBack.FBX` | **unbound** | pulling out of range |

Lengths come from `research/Q47_INVENTORY.csv`; dead air and a measured
`readable_s` come from `research/C92_STRIKING_CONTENT.md` — **read both,
never copy a window off a neighbouring clip** (S6b's rule).

## WHAT IS NOT THIS STAGE

- **Both uppercut rows (6,667 beats) stay as they are.** R127 refused the only
  uppercut film after watching it render as a knee lift. Not reopened here.
- **`boxing_one_two`, `boxing_one_two_hook`, and the two body rows** are the
  established PARTIAL doctrine — showing what a combination opens with is
  incomplete, not false. Re-label them in the report if the wording is wrong;
  do not re-bind them.
- **Do not touch the route row.** It is the operator's next stage (see `next`).
- **Do not reopen whether footwork should carry the man.** Ruled 2026-09-18.

## OWNED FILES

`Godot/scripts/FightBeatAdapter.gd` (`TECHNIQUE_CLIP_ALIASES:159`),
`Godot/scripts/FightStagePlayer.gd` (`NEAREST_CLIP:1001`, `play_role` queueing
at `:366`), `Godot/scripts/FightClipBinding.gd` (`BINDINGS:25`,
`technique_roles:1124` — a new key in one and not the other never plays),
`Godot/tools/audit_unbound_contact_sheets.gd` (`SOLOS`),
`Godot/tests/fight_clip_alias_test.gd`, new `research/S14_*`.

## GATE (tier: a script edited)

```
python Godot/tools/check_scripts.py <each touched .gd>
godot --headless --path Godot --script tests/fight_clip_alias_test.gd
python Godot/tools/run_tests.py --only clip
python Godot/tools/run_tests.py --only beat
python Godot/tools/run_tests.py --only stage
```
Then the FULL SUITE ONCE: `python Godot/tools/run_tests.py --timeout 2400 --jobs 3`.
**fails=6 or better as a CEILING**, failing FILENAMES matching
`AgentComms/last_suite.json` name for name. THREE jobs, not four (`nproc` is 4).

## THE NUMBER IT IS JUDGED ON

Re-run `tools/measure_presentation_split.gd -- res://research/S14_PRESENTATION_SPLIT.md`
(it takes an output path now, and **must not be pointed at S9's or S13's file**).
Report SUBSTITUTE before and after, split into *mislabelled* (Part A) and
*genuinely changed picture* (Part B). Reporting them as one number is the
failure mode this stage is most likely to produce.

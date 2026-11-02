# S15 — THE ROUTE: a walking man stops being counted as a failed puncher

S15's first half. **It moves no pixel, and saying so is the deliverable.**

## WHAT CHANGED, IN ONE SENTENCE

`FightStagePlayer` no longer hands a `technique_class: movement` beat to
`_thrower_clip`, which can only ever offer a STRIKE role; it reports
`thrower_footwork` where it used to report `thrower_idle`, and the room and the
split tool stop counting a step as a punch that failed to show.

## THE RULING THIS EXECUTES

Operator, 2026-09-18, verbatim:

> "Footwork is purely scoring and rhythm, and helps dodge, repositioning and in
> general is the catalyst in transitioning defined by speed, never needed to move
> anybody."

So the beat is not a strike, and it is not a man who is supposed to be carried by
one. **The walk was NOT biased toward the beat and must not be** — S10 measured
that the correlation does not exist (any action beat 63.6% walking, a
`boxing_circle_lead` beat 60.1%, 3.5 points apart) and the ruling says it is not
supposed to.

## THE ARITHMETIC, AND IT IS THE SIGNATURE OF A RELABEL

S14's test: a change that only moved a LABEL shows two figures moving by the
**same number** while the others do not move at all. Pooled over 335,443 action
beats, four rulesets, the same population both times
(`S14_PRESENTATION_SPLIT.md` -> `S15_PRESENTATION_SPLIT.md`):

| state | S14 | S15 | moved |
|---|---:|---:|---:|
| EXACT | 173,099 | 173,099 | **0** |
| SUBSTITUTE | 52,175 | 52,175 | **0** |
| GENERIC | 16,894 | 16,894 | **0** |
| SILENT | 0 | 0 | **0** |
| ROUTED (S6c) | 15,598 | 15,598 | **0** |
| DEGRADE | 77,677 | 47,078 | **−30,599** |
| FOOTWORK (new) | — | 30,599 | **+30,599** |

**−30,599 and +30,599.** Nothing else moved by one beat. That is the arithmetic
of a relabel and it is printed here so nobody has to take the claim on trust.

The row is the three ids S13 named, to the beat:

| id | beats | share of action beats |
|---|---:|---:|
| `boxing_circle_rear` | 10,295 | 3.07% |
| `boxing_step_in_out` | 10,170 | 3.03% |
| `boxing_circle_lead` | 10,134 | 3.02% |
| **total** | **30,599** | **9.12%** |

**DEGRADE 23.2% -> 14.0% IS NOT A PRESENTATION WIN.** Not one additional frame of
animation plays because of this stage. `NEAREST_CLIP` holds no movement id and
the category role is only reached by a beat naming no technique at all, so
`_thrower_clip` already returned `""` for every one of these beats: they played
nothing before and they play nothing after. If this stage is ever quoted as
"degrades down nine points", that is the S6c accounting error with a new subject.

## WHAT THE EYE ACTUALLY GETS — and the split tool CANNOT tell you

The footwork row is two pictures and the offline tool has no body to ask. The
ROOM splits them, at run time, and now has a counter for each:

- **`presentation_counts().carried`** — the walk overlay is carrying him. S10:
  **60.1%** of the row over 400 bouts.
- **`presentation_counts().stanced`** — below `walk_at`'s `WALK_MIN_RATE` the legs
  are dropped and the `idle` loop plays. S10: **39.8%**, about 12,000 beats.
  `S15_STILL_MAN.md` measures what that loop is, and the answer is that it moves:
  0.24 m of head travel and 0.27 m of hand travel over 4.67 s, in a 3-5 cm
  envelope, feet planted. **Nothing is owed there.**

They are deliberately not summed anywhere — not in `presentation_counts`, not on
the HUD line, not in the report. A caller that wants one number has to write the
addition and look at what it is adding.

## THE ONE THING THAT IS NOT FOOTWORK'S TO CLAIM

`movement` is not a standing-only class: `bjj_posture_break` is `ground_bottom`,
`judo_grip_break_counter` and `sambo_arm_drag_bodylock` are `clinch`. The
PRESENTER flags all of them, because none of them is a strike and none should be
asking for a strike role. The ROOM does not let all of them out of the degrade
column: `_carried_by_walk`'s `position == "distance"` test still sends a posture
break off his back to DEGRADE, because neither a walk nor a stance is a picture
of a posture break.

## WHAT IT COST TO FIND, AND THE THREE TESTS THAT WERE WRONG

**Three existing tests had floors that were being paid for by footwork**, and all
three went red the moment the presenter could tell a step from a punch:

1. `fight_stage_technique_fidelity_test` encoded "no clip played implies
   `thrower_idle`" and called 7 footwork beats substitutions. It now asserts the
   two flags are mutually exclusive and that `thrower_footwork` never appears on
   a non-`movement` beat — **stricter than what it had**. It also now counts the
   footwork row from the presenter's flag AND from the catalogue's `branch` field
   and asserts the two agree: **flag 7, branch 7.**
2. `fight_world_live_test` asserted *"M19's no-clip degrade ACTUALLY fired and was
   said so"* by grepping the readout, and it passed. **It was never firing.** That
   fixture's 834 beats are 748 played, 58 carried, **28 in the stance, and ZERO
   M19 degrades.** The floor was measuring footwork.
3. `fight_stage_presenter_contract_test` had the same floor (`_degrade >= 1`) and
   the same result: degrade 0, footwork 7.

M19's degrade is not rare in the game — the pooled split still puts DEGRADE at
**14.0% of 335,443 action beats**. It is rare in these fixtures, which are short
boxing bouts. So rather than invent a population to keep a floor alive, each
floor moved to what its fixture actually reaches, plus an invariant that survives
any population: **a body that played nothing always says which of the two reasons
it was.** `fight_stage_presenter_contract_test` now fails loudly if a clipless
beat claims neither.

**This is the lesson worth keeping: a by-occurrence floor can be satisfied by the
wrong thing for as long as nothing can tell the two apart.** Three of them were,
for months, and the only reason it surfaced is that S15 made the distinction
expressible. When a counter is split, re-read every floor that was counting the
old total.

## OWNED FILES

- `Godot/scripts/FightStagePlayer.gd` — `_is_footwork`, `_footwork_clip`, the
  `thrower_footwork` report key.
- `Godot/scripts/FightWorldLiveScreen.gd` — the `_stanced` counter, the three-way
  partition, the fourth column on every readout, `presentation_counts`.
- `Godot/tools/measure_presentation_split.gd` — the FOOTWORK row, the footwork id
  table, the emptied ROUTE fix row.
- `Godot/tests/fight_footwork_route_test.gd` — new, 10 checks.
- The three tests above.

## TEST

```
godot --headless --path Godot --script tests/fight_footwork_route_test.gd
```

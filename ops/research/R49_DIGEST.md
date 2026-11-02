# R49 — THE DECISION THAT SURVIVES THE RING, AND THE GRUDGE SHELF

Consolidation. Closes the two gaps R45 named on the record and builds the one
part of K17 that was still unbuilt. Two small `GameState.gd` regions, one read
module, one panel. No scoring change, no `FightSimulation.gd` or `JudgePanel.gd`
edit, no new UIKit factory, no new token, no save migration.

## Part 1 — a decision that reads the same outside the ring

The sim types every decision and names the style it was scored under. The
freeze at `GameState.gd:10280` kept `method`, `scorecards`, `final_health`,
`ruleset_id` and `duration_seconds` and dropped both, so a three-judge split
opened anywhere but the live ring typed as a flat **DECISION**.

1. **Frozen.** `pending_fight_result` now carries `decision_type` and
   `scoring_style`, taken verbatim off `sim_result` beside `ruleset_id`.
   Nothing rolls, estimates or defaults to a type the sim did not emit, so
   `get_fight_result_card()` — which is `pending` plus the payment — hands the
   result screen the real type for the first time.
2. **`ScorecardRead.build` asks its own panel.** It built
   `JudgePanel.decision(normalized)` for the totals and then took the type from
   `result["decision_type"]` alone. The panel is now built first and answers
   when the caller files nothing. Two guards are deliberately kept: the flat
   word still covers the one-card legacy shape (its synthetic single judge
   already returns `"decision"`), and the `method == "DECISION"` guard stays, so
   a knockout's part-scored rounds are never typed as a decision.
3. **Carried through settlement.** `_apply_fight_result` writes both onto the
   durable `fight_history` row and the `fight_log` entry — but only when the
   freeze actually carried one. A bout settled from a pending result filed
   before this stage keeps no key at all rather than gaining a verdict invented
   after the fact.

C30's own capture path was already correct: `record_watched_world_bout` builds
`BoutRead.capture(sim_result, ...)` straight off the live result, which always
carried the type. What was untyped was every settlement that did not go through
that capture, and every re-read of a card filed without one — both now answer.

## Part 2 — K17 C: the RIVALRIES shelf

Two thirds of K17 was already live and neither was re-opened: PHONE is gone
(`OfficeHubPanel.gd:18`, `SceneRouter.gd:94`) and D — "who is unhappy and why"
— is THE DAY's attention strip on C16's read. What was left is section C.

`Rivalries.gd` and `career["rivalries"]` have been live since R2 and no screen
read them. The heat list is now on the fighter profile's **FIGHT RECORD** tab,
beside the arc that made the feuds — not a new tab, not STAFF (coach work is
not a grudge), not the `get_rival_gyms` world list.

- The panel is card-only by R23's invariant and `CardSpy` declares exactly the
  four methods it may call, so a direct getter would fail the test by design.
  `get_fighter_card()` gains `"rivalries"` beside `titles` / `awards` and the
  panel spends the card. The list is career-wide, so a world opponent's profile
  answers as readily as a roster fighter's.
- CAREER ARC narrows from 1494 to 1010 and the shelf takes the 472 beside it,
  so the record tab is now a clean two-column grid: arc over log, shelf over
  the numbers. The log's seven visible rows are untouched — that column had
  four pixels of slack and none were spent.
- A row says the surname, the band word, the heat on the ramp, the head-to-head
  tally, and either **GRUDGE** in `LINK` when a grudge match is already on the
  board or how many weeks it has been quiet. Top three; the header carries the
  total. No booking button: a grudge is booked through the existing offer flow.
- **Honest empty**: no rivalry is one `DIM` line, never an alarm.

### Token rule held

`BAD` / `AMBER` / `GOOD` stay M6's medical family (R48) and `SODIUM` / `ICE`
stay the belt's (R47). Heat is neither, so it borrows from neither: the band
word and the bar read the existing `HEAT_RAMP`, interpolated at the rivalry's
own heat, and COLD falls off the ramp to `MUTED` rather than reading as a low
flame. `LINK` marks the bookable grudge. No token was added.

## Files

- `Godot/scripts/GameState.gd` — the freeze, the settlement carry, the card key.
- `Godot/scripts/ScorecardRead.gd` — the panel fallback.
- `Godot/scripts/ProfileRevampPanel.gd` — `_fill_rivalries`, `_heat_tone`, the
  record tab's two columns.
- `Godot/tests/scorecard_read_test.gd` — S9 / S10.
- `Godot/tests/profile_revamp_test.gd` — two seeded feuds and five claims.

## Verify

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/ScorecardRead.gd Godot/scripts/ProfileRevampPanel.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/scorecard_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/profile_revamp_test.gd
```

Parse gate 3/3. `scorecard_read_test` 11/11, `profile_revamp_test` 0 failures,
`bout_read_test` 11/11, `post_fight_read_test` 16/16, `setpiece_panels_test` and
`rivalries_test` clean, full suite green.

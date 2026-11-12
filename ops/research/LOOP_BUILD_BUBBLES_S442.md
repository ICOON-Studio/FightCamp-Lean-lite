# S442 build: reaction bubbles over the 3D fight

Built from the drawing the owner approved ("All three"): `docs/mockups/s442/loop/fight_bubbles.png`, spec in
`ops/research/LOOP_DRAWINGS_S442.md` section 2. Nothing is committed.

## Files touched

| File | Change |
|---|---|
| `scripts/fight3d/ReactionBubbles.gd` (new, 244 lines) | The overlay. `take(view, beat)` is called for every beat; `mark(beat, kind, x, ctx)` tags the shout, coach and plan beats with their words; `heard_word`, `letter`, `pick_slot`, `keep_rect`, `text_of` are pure static helpers. At most 2 on screen (a third replaces the oldest), 2.0 s life in real seconds with a strip along the bottom that runs down, 0.25 s tween fade in and out (it ignores time scale). Anchored to the red post's top (`camera.unproject_position`). Each time a bubble appears it is checked against keep-out rects: for each boxer, the span of the head, both gloves and both feet (projected bones, with a margin), plus the two side holos. It takes the first free slot from a fixed set near the post; if no slot is free it is not shown and the caption line keeps the words. ON by default; the `nobubbles` command-line argument turns it off. |
| `scripts/fight3d/ExchangeBeats.gd` (+5 lines) | The shout, the "Plan:" beat, the plan tally beat and the verdict beat go through `Bubbles.mark(...)`. Their captions are unchanged. A new beat with no caption is added for a shout the fighter did not take in, so "Not heard" can show. |
| `scripts/fight3d/FightView.gd` (498 -> 499 lines) | `_fire`: `if not ReactionBubbles.take(self, b) and caption != "": _say(caption)`. A beat shown as a bubble leaves the line under the ring. Set-up, read and habit captions are not tagged and stay there. |
| `scripts/state/LiveRound.gd` (+3 lines) | Two new fields on the exchange record: `said` (a call shouted when CornerTrust.lands was false: today nothing records it) and `shouts_before` (the round's shouts taken in before this one, which gives the heard mark). |
| `tests/reaction_bubbles_test.gd` (new) | The unit test. |
| `tools/bubbles_play.gd` (new) | A stills tool: the real game to fight night, round 1 at 1x, with the coach's call picked at every shout bar. It saves a still the moment each kind of bubble is up, and one with two up at once. It prints each bubble's rect and the keep-out rects, and fails if a bubble covers one. |
| `tools/fight3d_play.gd` | Its two caption checks ("Corner:" after the shout, "Plan:" after it) now also pass when the bubble is up. Without this change they would fail now that those words leave the caption line. |

## Wiring (what each bubble reads)

- **Shout**: the shout beat (`shout_call`), with the text from `Exchanges.CALLS[call].shout`. The heard mark is `heard_word(shouts_before, lands)`:
  - Heard while `shouts_before < Exchanges.FULL_SHOUTS` (2). This is the same rule as `Exchanges.uptake` and `ShoutBar.shout_note`.
  - Half heard from the 3rd shout of the round.
  - Not heard when the shout was said but `CornerTrust.lands` was false (`rec.said`).
- **Coach line**: `x.verdict` (`Exchanges.verdict`), at the beat `at + 30 - VERDICT_LEAD_S`. Under it: a round dot in the colour of the corner that won the exchange (ScoreBug RED / BLUE), then "Coach · exchange to <first name>".
- **Plan mark**:
  - When the line fires, the "Plan:" beat at `at + 1.6`, shown as "Plan A · Double jab". The letter is the line's place in the plan, `f.bout.arrows`.
  - When the exchange ends, the `plan_tally_caption` beat, shown as "Plan A · won it · 2 of 4". The pin's edge is green if the exchange was won, red if it was lost.

## What differs from the drawing, and why

1. **The red post is often off-screen.** The broadcast camera often frames the fight with the red post off the left edge. In those frames the bubbles stack top-left under the name plate: the same place as the drawing's coach bubble, with the tail pointing toward the post. When the post is on screen (still `bubble_coach.png`), they sit beside it with tails into it, as drawn. I added two extra "top-left" slots so two bubbles still fit when the post is off-screen.
2. **Keep-out covers whole fighters, not just points.** For each boxer the keep-out is the whole span from head to gloves to feet, not five separate points. This is stricter than the rule: the bubble never sits over a body either. The two side holos are also kept clear: their numbers are read during the round.
3. **Kit and fonts.** The fight's kit is `scripts/ui/TV.gd`: FightView already imports it as `UI`, the dark TV look. I used it instead of `scripts/ui/UI.gd`, and edited nothing under `scripts/ui`. The megaphone and message icons are Lucide SVG paths inside ReactionBubbles. `Icons.gd` (read-only) has no such icons; its `check` icon is used for "Heard". Text is 22 px everywhere; the pin letter is 26 px in Bebas.
4. **Not-heard shouts make no sound.** The not-heard shout beat has no voice and no caption. Today an ignored shout leaves no trace at all, so with bubbles off nothing changes.
5. **The pin's edge colour.** The drawing gave the fire mark of line C a red edge. That colour is a grade, and grades (R24GRADE1) are not wired yet. So the edge is plain ink when a line fires, and green or red by won or lost when it ends.
6. **No GameSwitches here.** `GameSwitches` does not exist in the Lean repo. The switch follows Lean's own pattern (`RkClips.enabled`): `static var enabled`, on unless `nobubbles` is on the command line. Headless tests have no 3D view, so they stay the control arm.
7. **Life is real seconds.** The 2.0 s life ignores both 2x speed and the slow ring under the shout bar.

## Tests (each through `ops/Tools/godot_slot.py`; logs read for FAIL / SCRIPT ERROR lines, none found)

- Red first: `reaction_bubbles_test` failed to parse before ReactionBubbles.gd existed.
- `reaction_bubbles_test`: `REACTION_BUBBLES failures=0` (rerun after the final layout changes)
- `round_board_test`: all PASS, rc 0
- `corner_card_test`: `CORNER_CARD PASS fails=0`
- `fight_words_contract_test`: all PASS, rc 0
- `ko_continues_test`: `KO_CONTINUES failures=0`
- `golden_path_test`: `GOLDEN_PATH failures=0`
- `no_pronoun_test`: `PASS no she/her in a script's text: 0 found`
- `file_limits_test`: all PASS (FightView 499, ReactionBubbles 244)
- Parse check (`--check-only`) clean on every touched script and tool.

## Stills (game camera, hidden desktop, 1920x1080, `tools/bubbles_play.gd`)

Every bubble passed the tool's keep-out check: no FAIL lines in `E:/FightCamp/tmp/bubbles/godot2.log`. I also opened each still and checked it.

- `E:/FightCamp/tmp/bubbles/bubble_plan.png`: 2:59, "Plan A · Double jab", top-left (the post is off-screen).
- `E:/FightCamp/tmp/bubbles/bubble_shout.png`: 2:30, the shout with its megaphone icon and "Heard" in green.
- `E:/FightCamp/tmp/bubbles/bubble_two.png`: 1:59, two at once (plan mark + shout "Heard"), stacked top-left, clear of both boxers and the holos.
- `E:/FightCamp/tmp/bubbles/bubble_coach.png`: 1:03, the red post on screen. The coach line ("It worked: ... won Lucy those 30 seconds.", red dot, "Coach · exchange to Lucy") and "Plan A · won it · 2 of 4" sit beside the post with their tails into it, as drawn.

The first run's stills showed two defects:
- The shout bubble covered the plate's guard row. Fixed by moving the safe top to 215 px.
- Bubbles sat over the left holo. Fixed by adding the holos to the keep-outs.

"Half heard" and "Not heard" are covered by the unit test, not by a still. The stills run picks only the coach's call, and the fighter's morale stays above Low.

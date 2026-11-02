# TASK CARD1 - THE CANDIDATE card on the FM logic (NAV1 slice 3, D37)
Model: top (operator picks in the menu; Opus for the design read, the build is medium)
Owner: claude, CLOUD session (operator 2026-10-05: "next session will be cloud session again" / "go 2").
Switch: career `candidate_card_v2` (user arg `candidate_card_v2`), OFF in the game until the operator's OK (S117 rule).

## Prior research
- `K86_SCREEN_GAP_AUDIT.md` s5 (lines 133-205): THE CANDIDATE wireframes, coach + fighter - THE SPEC. Bands Poor 1-5 /
  Fair 6-10 / Good 11-15 / Excellent 16-20; defects s4 rows 3, 4, 6, 10, 21 (lines 103-131).
- `J62_HUB_REFERENCE_LOGIC.md` (summary only; full memo on John's box): FM24 hire/sign density - 1-20 with colour bands,
  suitability stars, one recommendation line, contract as wage + length (never bare "weeks"), every term on a tooltip,
  ONE verb button.
- `M42_HUB_MOCKUPS.md` (summary only): component names `candidate_card`, `band_bar`, `guide_dock`.
- `python Tools/prior_research.py candidate card` -> topics/staff_coaches.md, PERSONALITY_RESEARCH.md (ambition = an
  evaluated sentence, P6).

## What would a human do?
An FM UI lead rebuilds the one card the player meets in minute 6 first: identity strip, numbers WITH scale + band word,
"vs our gym" sentence, the ask in plain money, one gold verb, the guide never over it. Reads only what
`get_candidate_card` already returns; adds a read only where the card needs a number it lacks.

## Prefab check
None: a drawn Control (UIKit). Reuse `UIKit.tip`, `UIKit.portrait_chip`, `TaleOfTape.generated_portrait`, the existing
Sign/negotiation calls in ScoutingHubPanel (do not re-implement signing).

## Owned files + anchors
- NEW `Godot/scripts/CandidateCard.gd` (pure builder: `static func build(card: Dictionary, row: Dictionary, on_sign: Callable, on_decline: Callable) -> Control`).
- `Godot/scripts/ScoutingHubPanel.gd` (1179 lines): `_build_candidate()` 367, `_build_candidate_actions()` 497, the card
  read at 169-170. With the switch on, `_build_candidate` mounts CandidateCard instead; OFF = byte-identical.
- `Godot/scripts/GameState.gd` (never read whole): `get_candidate_card()` 18224, `_scouting_row()` ~18366; add
  `is_candidate_card_v2_on()` beside `is_gym_is_menu_on()` (~17957).
- The tutorial guide card (`GuideCard.gd`) must not cover the Sign button (K86 row 10/guide) - test the rects.

## Acceptance (one test, `tests/candidate_card_test.gd`, red on the shipped tree first)
Populations: DevJump career + its real scouting board (coach candidate + boxer candidate; name them, their stats, sex,
weight class). OFF control arm keeps today's panel. ON: identity strip (portrait, name, age, country, role/division);
every attribute shows value + band word matching the band table, and a tooltip; "weeks" never appears bare (wage +
length + fee in one sentence); exactly ONE gold button (Sign coach / Sign fighter) and it signs through the existing
path; a verdict line and a "vs our gym" line are non-empty; the fighter card has an ambition sentence; with the guide
on, its rect does not intersect the Sign button. Mutant: switch forced off -> red.
Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`; neighbours:
`python Godot/tools/run_tests.py --only candidate,scouting,staff_hub,first_job,tutorial,gym_menu --jobs 3`.

## The one trap
`get_candidate_card` duplicates the whole career per call - build the card from ONE read per selection, never per
redraw. And the cloud has no window: the stills/video (and the operator's OK) are owed to a PC session.

Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/candidate_card_test.gd`

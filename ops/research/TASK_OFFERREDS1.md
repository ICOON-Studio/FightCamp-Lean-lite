# TASK OFFERREDS1 - five offer/event tests red on master after catalog v4 (cloud Qwen)

Model: qwen (cloud-agent.yml, label `qwen`). Tier: a script edited -> parse gate, each test below, then
`python Godot/tools/run_tests.py --jobs 2 --only offer,short_notice,weight_cut,event_night,events_revamp,fight_camp,amateur_offer`.
Branch `qwen/issue-<n>`, PR to master; never master. Plain `--script` tests stay the OFF control arm (CLAUDE.md s10).

## The defect (measured by Claude on master 518da372+, S232 - every line below is red NOW)
- `tests/event_night_backend_test.gd`: "card has no watchable bout to settle"
- `tests/events_revamp_backend_test.gd`: "every scheduled event has a real, non-empty discipline label"
- `tests/offer_desk_test.gd`: "short-notice cards belong to the eligible fighter, not the other two"
- `tests/short_notice_test.gd`: "the desk lists the slot with one eligible fighter", "the eligible fighter shows two camp weeks
  and a weight line", "the wrong class is refused by name", "PASS quietens the row and keeps the offer", "with the chance forced
  on a fighter pulls out of a card in the window (SHORT NOTICE: Jungle Fight 1 needs a Light Heavyweight for Daisuke Lee in 3 weeks)"
- `tests/weight_cut_test.gd`: "a booked fighter's status names the bout's limit ... (Heavyweight, limit 0.0, 8% over)" and 5 more -
  the seeded booked fighter is now a HEAVYWEIGHT (no upper limit = 0.0), so every cut check reads nothing.
Green controls on the same tree: amateur_offer_roundtrip, fight_camp, g156_weight_cut.

Suspects (read these first, by diff): `2dc88184` (card fill never double-books, keeps 4 free athletes per sport for recruiting),
`1922a0cc` (event cards hold only their organization's sports), `e190dd3b` (catalog v4: ten promoters). These change WHICH fighters
and WHICH cards a seeded world has - several tests pick "the first X the world lists" and break when the world changes.

## What to build
For EACH failing check decide, and say which in the PR body:
- (a) a REAL bug (e.g. a scheduled event with an empty discipline label, a short-notice card offered to an ineligible fighter,
  a card with no settle-able bout) -> fix the game code, the test stays as is;
- (b) a FIXTURE that depends on world order -> pin the fixture (book/sign named, explicitly built fighters of the right class:
  e.g. weight_cut needs a booked fighter in a class WITH an upper limit). Never two identical fighters (CLAUDE.md s5); females never
  fight males; booking matches weight class.
Never delete, skip or loosen a check to go green; bound values, never exact world counts.

## Owned files (read windows, never whole)
- the five test files above (each < 400 lines)
- `Godot/scripts/GameState.gd` is ~19,000 lines: NEVER read it whole - `grep -n "func get_short_notice\|func get_fight_offers\|func
  _fill_card\|short_notice\|func get_weight_status\|discipline_label"` and read +-60 line windows.
- `Godot/scripts/state/GameFightWeek.gd`, `Godot/scripts/AwayCircuit.gd` (if the offer list goes through them).

## Parse gate
`python Godot/tools/check_scripts.py <every .gd you touched>` before any test (a parse error hangs a headless test).

## Acceptance
1. Each of the five tests: `godot --headless --path Godot --script tests/<name>.gd` prints no FAIL line.
2. The focused run above: `SUITE ... fails=0`.
3. PR body: one line per failing check - (a) or (b), the cause, the file:line you changed.

## Prior research
searched: short notice offer desk weight cut catalog (`python Tools/prior_research.py`) - nothing on these reds; NIGHTLY1 rows in
AgentComms/roadmap.json record them as red since catalog v4 (10-16 nightly at 9d320fd5, 812/23).

## What would a human do?
Bisect: run each test at 1922a0cc^, 1922a0cc, 2dc88184, e190dd3b; the first red commit names the cause, then decide (a) or (b).

## Prefab check
None - project-internal test fixtures and offer logic.

## The one trap
A test that "signs the first UK boxer" will turn red again at the next catalog change: pin it to an explicit fixture fighter.

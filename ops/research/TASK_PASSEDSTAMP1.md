# TASK PASSEDSTAMP1 - QWEN - the test-day moment: a PASSED stamp card in the week review when a skills grade passes (Lean)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean. Launched unattended by
ops/Tools/seat_dispatch.py: your worktree E:\FightCamp\wt\LEAN_PASSEDSTAMP1, branch qwen/passedstamp1. Commit there; do
not push (the dispatcher pushes and opens the PR).

## Why
A boxer climbs six skills grades (scripts/rules/SkillAwards.gd: Preliminary, Standard, Bronze, Silver, Gold, Platinum).
On the Sunday a grade passes, the week review only adds one line of text ("PASSED the Standard award - a medal and a
certificate.", scripts/ui/modals/WeekReview.gd:108-109). The five design seats agreed the pass must be a MOMENT
(ops/research/GOALIDEAS_SUMMARY_S371.md, "TEST DAY AS A SHOW"), and since S373 a passed grade changes how she fights:
its moves are "graded" - their combo cards wear the grade's colour and cost less gas (SkillAwards.grade_of / ECONOMY /
GRADE_COLOR).

## The job
1. New file `scripts/ui/PassedStamp.gd` (`extends RefCounted`, static, like scripts/ui/AwardCard.gd): 
   `static func make(f: Dictionary, award_name: String) -> PanelContainer` named "PassedStamp": a card with
   - a big stamp word "PASSED" in the grade's colour (SkillAwards.GRADE_COLOR[id], id = the award's "id" whose "name" is
     award_name; Preliminary has no colour - use UI.GOLD),
   - the line "<Award name> award - a medal and a certificate",
   - one chip per move that grade assessed (SkillAwards.AWARDS row "moves" keys), each "Jab: 8% less gas" using
     roundi(100 * (1 - SkillAwards.ECONOMY[id])) (no chip line when the grade has no moves, e.g. Preliminary),
   - the line "Next: <next award name>" from SkillAwards.next_award(f) (or "Every award passed" when it is empty).
   Use only the helpers in scripts/ui/UI.gd (UI.card / UI.vbox / UI.hbox / UI.label / UI.display / UI.chip / UI.muted).
   No pronouns in any text (tests/no_pronoun_test.gd fails on she/her) - use the fighter's first name or none.
2. `scripts/ui/modals/WeekReview.gd`: where `passed_now` is true (line ~108), ALSO land the stamp card for that fighter
   (preload PassedStamp; build it with `PassedStamp.make(<the fighter dict>, str(fr["award"]))` - find the fighter with
   `main.career.fighter_by_id(str(fr["id"]))` as the file does elsewhere; land it with the file's own `_land(...)` helper the
   way the other blocks are landed). Keep the existing text line.
3. New test `tests/passed_stamp_test.gd` (`extends SceneTree`, the shape of tests/skill_awards_test.gd: `_check(cond, label)`
   printing `PASS <label>` / `FAIL <label>`, then `PASSED_STAMP failures=<n>` and `quit(1 if failures > 0 else 0)`). At least:
   a. `PassedStamp.make(f, "Standard")` with f = {"first": "Lucy", "awards": [{"id": "preliminary", "d": 0}, {"id": "standard", "d": 7}], "moves": {}}
      has a Label whose text is "PASSED", two chips containing "Jab" and "Cross" and "8% less gas", and a label containing "Next: Bronze".
   b. For "Preliminary" there is no "less gas" chip.
   c. With every grade passed, the next line reads "Every award passed".
   d. The stamp's "PASSED" label colour equals SkillAwards.GRADE_COLOR["standard"] (read it with
      `label.get_theme_color("font_color")`).
   Free every node you create.

## Acceptance (the dispatcher runs these on your branch, headless)
- `tests/passed_stamp_test.gd` prints `PASSED_STAMP failures=0`, exits 0, no SCRIPT ERROR.
- `review_reveal_test`, `golden_path_test`, `skill_awards_test`, `no_pronoun_test` still pass.
- Do NOT add the test to tools/run_tests.sh (a gate file - Claude adds it at the merge).
- Your tools cannot open the game: use only GDScript 4 methods that exist on that exact type, and check each call's argument
  count against the function you call.

## Contract
OWNS: scripts/ui/PassedStamp.gd, scripts/ui/modals/WeekReview.gd, tests/passed_stamp_test.gd
RED_TEST: tests/passed_stamp_test.gd -> PASSED_STAMP failures=0
REGRESSION: review_reveal_test, golden_path_test, skill_awards_test, no_pronoun_test
VISUAL: no

## Prior research
ops/research/GOALIDEAS_SUMMARY_S371.md (the five seats: test day as a show, a passed grade changes how she fights);
SkillAwards.gd S373 block (grade_of, ECONOMY, GRADE_COLOR); WeekReview.gd S370 block (the Sunday check-in lines).

## What would a human do?
Read SkillAwards.gd's AWARDS and the S373 block, copy AwardCard.gd's UI style, build the card, land it beside the text line,
test the card on its own.

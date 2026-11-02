# TASK RECEPTION1C_APPLY (S210) - apply a reception check-in result to the game (cloud Cursor)

Model: Cursor (cloud seat, GitHub issue label `cursor`). Repo ICOON-Studio/FightCamp, branch cursor/issue-<n>, PR into master; never merge.
RECEPTION1B (merged b2236321) built the data (`Godot/scripts/rules/ReceptionCheckIn.gd`: visitor_card / attend / ignore return DATA
only) and the dock panel (`Godot/scripts/ui/ReceptionCheckInPanel.gd`). This task makes the result REAL in the save. The banner, the
1.2 s camera glide and the in-world hook stay for RECEPTION1C (local, with stills) - do not build them.

## Prior research
TASK_RECEPTION1B.md (issue #132), LUDO_ROUND43_VERDICT_S208.md section 6 (approved by the operator), Godot/scripts/Membership.gd
(member count lives in career["membership"]["members"], schema_version gate - read lines 100-190), GameState.gd recruitment
(`get_recruitable_athletes` ~560, `_find_recruitment_candidate` ~4918, `sign_recruitment_candidate` ~645, `_push_news`).

## What would a human do?
The desk clerk signs the walk-in up: a member pays and starts coming in; a hopeful gets a trial and shows up on the recruit list
like any other prospect; a "no thanks" leaves a line in the news.

## Prefab check
None - our own save model.

## Decisions (taken, do not reopen)
1. MEMBER: `attend(card, "membership:<id>")` -> {kind:"member", archetype_id, monthly_dues}. Apply = `Membership.ensure_state(career)`,
   members += 1, and append {id (new unique), name, archetype_id, monthly_dues, joined_week} to career["membership"]["roster"]
   (new list; keep the newest 200). The weekly dues maths is NOT changed in this task (Membership.weekly_dues stays the economy);
   the roster is the record MEMBERS1 will price later.
2. TRIAL: {kind:"trial"} -> create ONE athlete in the simulation world's "athletes" list from the card the way the world creates
   prospects (find the generator the world uses - grep `func _make_athlete\|func generate_athlete\|func _new_prospect` in
   Godot/scripts; never hand-build a partial dict): name, age, weight/division, stance from the card, country/city = the gym's,
   attributes seeded so the card's quick_assessment {power, speed, stamina, chin} maps onto the generator's matching stats
   (same 1-100 scale, document the mapping), status "active", plus "trial_from_reception": true and "trial_until_week" =
   current week + 2. He then appears in `get_recruitable_athletes()` and is signed through the existing `sign_recruitment_candidate`.
3. NONE / WALKED_OUT: no state change except one news line ("<name> left without signing up" / "<name> walked out - nobody came to
   the desk").
4. One public entry point in GameState: `func apply_reception_result(card: Dictionary, result: Dictionary) -> Dictionary` returning
   {ok, kind, member_id | athlete_id | "", reason}. {kind:"invalid"} -> {ok:false, reason:"INVALID CHOICE"}. Idempotent per visitor:
   applying the same card's visitor_id twice returns {ok:false, reason:"ALREADY HANDLED"} (keep handled ids in career["reception"]["handled"], newest 200).

## Owned files
- `Godot/scripts/GameState.gd` (ONE new function block + its helpers placed together at the end of the file; no other edits)
- `Godot/tests/reception_apply_test.gd` (NEW)
Never read GameState.gd whole (19,500 lines) - grep and read windows.

## Test: `Godot/tests/reception_apply_test.gd` (SceneTree; PASS/FAIL lines + "RECEPTION_APPLY_TEST FAILS=<n>"; exit 1 on fail)
Use the real GameState autoload (`root.get_node("GameState")`) with a fresh career the way existing GameState tests start one
(grep tests/ for `new_career\|start_new_career`). Two DIFFERENT visitors (one fighter_candidate, one member/passer_by kind) built from
`WalkIns` rows -> cards via ReceptionCheckIn.visitor_card:
1. member choice -> members count +1, roster row with the archetype's monthly_dues equal to members.json.
2. trial on the fighter card -> the new athlete is found by `get_recruitable_athletes()` (or `_find_recruitment_candidate`) with
   trial_from_reception true and stats within the card's assessment +/- the documented mapping; then `sign_recruitment_candidate`
   signs him (roster +1).
3. decline -> no members/athletes change, one news line added.
4. same visitor twice -> ALREADY HANDLED; invalid -> INVALID CHOICE.
5. Save/load round trip (if GameState tests have a helper for it) keeps the roster row and the handled id.
Command: `godot --headless --path Godot --script tests/reception_apply_test.gd` (loads no LFS models - CI can run it).

## The one trap
GameState is an autoload: scene scripts use `get_node_or_null("/root/GameState")`; `var x := <call>` on Variant returns fails to
parse - type it. Never delete or weaken an existing test. A full test-suite run is not needed - run this test and
`tests/reception_checkin_test.gd`.

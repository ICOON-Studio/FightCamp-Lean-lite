# TASK_NEXTSTEP1 - her road: five steps from her first bout to her pro debut, one lit, and what the next one needs (Qwen)

Model: Qwen (qwen3-coder, qwen_task.cmd). Discipline: BOXING = demo work (operator Q-S294-59 "Yes, those two first": the
NEXT STEP card on her page, and a reason on every greyed button). Repo: **E:\FightCamp\Lean** (worktree
E:\FightCamp\wt\LEAN_NEXTSTEP1, branch `qwen/nextstep1`). Lean rules: its CLAUDE.md, no script over 500 lines, Godot headless only.

## Why
The player cannot see where his boxer is going. Dojo Legacy-style idea, boxing version, approved: a card on her page with her
road from now to the nationals and a pro debut, the step she is on lit, and one line saying what the next step needs and when.
This task is the RULE (pure); the card on the screen is a later Cursor task.

## Spec - NEW `scripts/rules/NextStep.gd` (extends RefCounted, static only; may preload SeasonPath.gd and Roster.gd for their constants and pro_ready, nothing else)
`const STEPS := ["First bout", "Nationals ready", "The nationals", "Pro offer", "Pro debut"]`

`static func road(f: Dictionary, day: int) -> Dictionary` where `f` holds (missing keys = 0 / false / ""):
`bouts` (amateur bouts fought), `w` (amateur wins), `reg_days` (days registered with England Boxing), `age`, `injured` (bool),
`rank` (regional rank, 0 = unranked), `pro_declines`, `nat_final` (bool), `nationals` ("" = not entered this season,
"entered" = in the draw, anything else = her result words), `pro` (bool, signed), `pro_bouts` (pro bouts fought).
Returns `{"steps": [{"name", "done": bool, "lit": bool}] x5, "lit": int (-1 when all done), "need": String}`.
A step is DONE when:
0 First bout: bouts >= 1.  1 Nationals ready: `SeasonPath.eligible(bouts, reg_days, age, false, pro).ok`, OR step 2 is done.
2 The nationals: `nationals` is a result (not "" and not "entered"), OR pro.  3 Pro offer: pro OR `Roster.pro_ready(f)`.
4 Pro debut: pro_bouts >= 1.
`lit` = the first step not done (steps after a done one can still be not done; the lit one is the FIRST). `need` for the lit step:
0 -> "Book her first amateur bout".
1 -> the `reason` from `SeasonPath.eligible(bouts, reg_days, age, injured, pro)` + " - entries close in N days"
   (N = `SeasonPath.entry_close(day) - day`). If eligible says ok (only injury blocked nothing) use "Ready - enter her".
2 -> "entered": "She is in the draw"; else "Enter her before entries close in N days" (or "Injured - she cannot enter" when injured).
3 -> if `pro_declines >= 3`: "No more offers - she stays amateur". If `pro_declines >= 2`: "Only a No. 1 ranking brings
   another offer". Else with need = Roster.PRO_WINS + pro_declines * Roster.PRO_RETURN_WINS and any = Roster.PRO_WINS_ANY_RANK +
   pro_declines * Roster.PRO_RETURN_WINS: ranked (1..Roster.PRO_RANK) -> "%d more wins" % (need - w) (1 -> "1 more win");
   unranked -> "%d more wins and a top-3 ranking, or %d more wins" % [max(need - w, 0), any - w].
4 -> pro and pro_bouts == 0: "Her debut is booked %d weeks after she signs" % Roster.PRO_DEBUT_WEEKS... if not pro: "Sign the offer".
All done -> need "".

## Contract
OWNS: Lean/scripts/rules/NextStep.gd, Lean/tests/next_step_test.gd
RED_TEST: tests/next_step_test.gd -> PASS next_step_test
REGRESSION: season_path_test, pro_debut_test
VISUAL: no (the card is a later task)

## The test (write it FIRST; it fails before NextStep.gd exists)
`tests/next_step_test.gd` (extends SceneTree, style of tests/season_path_test.gd, `_check(ok, what)`), day = 20 unless said:
1. New signing {} -> lit 0, need "Book her first amateur bout", 5 steps, only step 0 lit.
2. {bouts 3, reg_days 35, age 22} -> lit 1, need contains "Needs 5 bouts (has 3)" and "entries close in 50 days".
3. {bouts 6, reg_days 100, age 22} -> lit 2, need contains "Enter her"; with nationals "entered" -> "She is in the draw".
4. {bouts 8, w 6, rank 2, reg_days 120, age 22, nationals "Lost in the regional final"} -> lit 3, need "1 more win".
5. Same with rank 0 -> need exactly "1 more wins and a top-3 ranking, or 3 more wins" (no plural special case on this line).
6. pro_declines 2 -> "Only a No. 1 ranking brings another offer"; 3 -> "No more offers - she stays amateur".
7. Consistency with the game's own rule: for every w in 0..12, rank in 0..5, pro_declines in 0..3, nat_final in [false, true]
   (bouts 15, reg_days 200, age 24, nationals "Won it"): step 3 done == Roster.pro_ready(f). Print the number of cases.
8. {pro true, pro_bouts 0, ...} -> lit 4; {pro true, pro_bouts 1} -> lit -1, need "".
9. Steps 0..lit-1 are done in every case above that has no skipped step; never more than one step lit.
Ends `PASS next_step_test` / `FAIL <n>`, quit(0/1).
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/next_step_test.gd`
then the two REGRESSION tests the same way. The plain exe only.

## Final answer
`RESULT: tests/next_step_test.gd -> PASS next_step_test`, the consistency case count, last lines of the three runs.

## Prior research
SeasonPath.gd (S328, nationals entry: 5 bouts, 13 weeks registered, England Boxing Elite 19-40), Roster.gd pro offer
(Kalli K-PROLINE1: 7 wins + top-3 or 9; S328 national finalist; declines). Dojo Legacy ideas: operator Q-S294-59.

## What would a human do?
A club coach tells a young boxer her next target in one line ("two more wins and you're in the nationals") and keeps the
long road in view (club bouts, nationals, a pro offer). That is the card.

## Prefab check
None: it is our career rules turned into words. Licence: ours.

## The trap
Do not copy the pro rule's numbers into NextStep: read Roster's constants and call Roster.pro_ready, so the card can never
promise an offer the game will not make (test 7).

# TASK Q224 - fatigue you can read and a body that remembers the last fight (UI, Qwen)
Owner: Qwen (qwen3-coder --yolo). Worktree D:/FightCamp/wt/Q224, branch qwen/q224-fatigue-body (from master).
Operator 2026-10-01: "everything needs to have a meaning", AAA, icons over text with tooltips.
D66_STRICT_REVIEW.md #9: "Fatigue/recovery math is hidden - 'Fatigue +6/week' but no total fatigue cap, no recovery speed
formula ... overtraining is a mystery penalty." Fix: "Clear fatigue meter 0-100; recovery rate per day; warning: 'This
schedule will exceed safe fatigue limit - risk of injury'."
D66 #10: "Body regions are decorative - all 100/100 'sound'; no explanation of how damage carries between fights."
Fix: "Show durability -> repeated strikes risk injury; carryover: bruising/swelling visible -> next fight penalty."

## Census first (into the digest)
`grep -n "fatigue" Godot/scripts/GameState.gd | head -40` (FATIGUE_DELTA, the week tick ~7535), BodyReadiness.gd
(minimum_readiness, get_injuries, forecast_weeks_to_training), the Body Lab screen (`grep -rln "BODY LAB\|body_lab" Godot/scripts`),
the programme/training screen where a week is scheduled. Write down: the fatigue cap, the per-day recovery, what a fight's
`body_damage` does to regions and for how long (the S137 result screen already shows HURT when injured).

## Deliver
- A FATIGUE meter 0-100 (heart-pulse icon, colour bands, tooltip with this week's +/- breakdown by session and the recovery
  per day) on the fighter card and in the programme screen; a WARNING line before Continue when the set schedule crosses
  the injury-risk threshold that already exists in code (never invent a threshold - name the constant).
- Body Lab: regions show the last fight's damage and the weeks to clear it (icons + tooltips), and the next-fight penalty
  the code already applies (name it); a sound region reads "SOUND" with a tooltip saying what would change it.
- Owned: the fighter card / programme / Body Lab panels + thin GameState reads. NEW
  `Godot/tests/fatigue_body_read_test.gd` (a known schedule -> meter value = GameState's fatigue; a schedule over the limit
  shows the warning, a light one does not (control); a damaged region after a fight shows its weeks-to-clear). Stills ->
  `previews/q224/` (OPEN THEM). `research/Q224_DIGEST.md`. Never edit HANDOFF.md.

## Tests
Parse gate; the new test; `python Godot/tools/run_tests.py --jobs 2 --only fatigue,body,readiness,profile,program,smoke,ui_kit`.
Watchdog first. `var x := <call>` on a Variant return fails - type it.

## Finish
git add by explicit path, commit, git push -u origin qwen/q224-fatigue-body. Do not stop at "written".

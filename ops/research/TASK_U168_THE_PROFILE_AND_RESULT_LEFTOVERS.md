# TASK_U168 - the profile and result leftovers (Cursor, GUI build)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S70, 2026-09-24. Management lane; the other half of
the S64/S65/S66 walk leftovers (U167 did the schedule half, branch `cursor/u167-schedule-truth`, not yet on master).

## Why
The career walks (`tools/s64_career_walk.gd`, a walker that presses buttons by their visible label) saw three things a player
reads wrong (S64_DIGEST.md:30-45, S66's walk):
1. PROFILE shows **WEEKLY PAY $0** for a fighter while the market pays men like him more - day one all three starter
   fighters go STRAINED on loyalty because starter pay is $0. The profile must show his actual pay AND what the market pays
   (grep `market` / `wage` in the manager-contract code S67 shipped) so the player can see why he is unhappy.
2. The fighter's **record line clips at "- FI"** (a Label cut off by its container) - find it on the profile / card and let
   it fit or wrap (CLAUDE.md: a Label outside a Container does not autowrap reliably; break with `\n` or put it in one).
3. On the RESULT screen the **score digits sit low in their cells** - centre them vertically.

## Owned files
The profile panel that draws WEEKLY PAY and the record line (grep `WEEKLY PAY` and the record format in
`Godot/scripts/ProfileRevampPanel.gd` / its helpers), the result screen's score cells (grep the scorecard in
`Godot/scripts/` for the result screen), a NEW `Godot/tests/profile_result_leftovers_test.gd`, `research/U168_DIGEST.md`.
`GameState.gd` is ~15,000 lines - NEVER open it whole; `grep -n` then `sed -n 'A,Bp'` windows.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>` first. The new test asserts what the PLAYER SEES on a real career
(`begin_new_career` / `generate_starter_boxing_floor` / `finalize_new_career`): the profile's pay label names a non-empty
market figure beside the fighter's pay; the record label's full text fits its rect (text width <= size.x, or it wraps); the
result score labels are vertically centred in their cells. 3 mutants, each reverted. Then
`python Godot/tools/run_tests.py --only profile`, `--only result`, `--only career_loop` (ONE `--only` per run; read `total=`).
Ceiling: no new red vs master. One windowed walk screenshot of each fix via
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s64_career_walk.gd -- plan=<file> out=<dir>`,
paths in the digest. No full suite.
Branch `cursor/u168-profile-result` off `origin/master`, commit with explicit paths ON the commit line, push,
`python Tools/agent_comms.py send --from cursor --to claude --topic U168 --body "<the three items: fixed/how, test checks, mutants>"`.
Do NOT edit HANDOFF.md, and do not read HANDOFF.md, CURRENT_STATUS.md or any digest but S64/S66's.

## The one trap
"$0" may be TRUE - the starter really is unpaid. Do not print a fake wage; show the real one next to the market's, so the
loyalty strain has a visible cause.

# TASK U87 — CURSOR — THE GET-UP: A KNOCKED-DOWN MAN RISES INSTEAD OF POPPING UP

Model: Composer (`composer-2.5`), **medium**, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80` (imported), branch `cursor/u87-getup` - already created from
`origin/master` for you. Push the BRANCH. Stage: S4a (d) part 3, item (2).

**Test tier: SCRIPTS EDITED.** Parse gate on every touched `.gd`, your new test, then the subset below.
No full suite - that is Claude's at integration.

## Owned files

- `Godot/scripts/FightClipBinding.gd` - add ONE role entry, `"getup"`, directly after `"knockdown"` (~line 178).
  Never read the file whole (835 lines): `sed -n '160,200p'`.
- `Godot/scripts/FightStagePlayer.gd` - 741 lines, never read it whole. Read `sed -n '86,135p'` (bind),
  `sed -n '196,320p'` (blends, `play_role`), `sed -n '330,347p'` (`_queue_stance`), `sed -n '401,470p'`
  (`_graft_retargeted`). You edit ONLY inside `play_role`'s last block (the knockdown exception, ~line 305-313),
  `_graft_retargeted`'s tail, and new functions you add at the end of the file.
  **DO NOT touch `present_beat`, `_queue_decide`, `_mark_busy` or `walk_at`** - Claude is rewriting those in
  another worktree right now, and an edit there becomes a merge conflict.
- `Godot/tests/fight_stage_getup_test.gd` - NEW, yours.
- `research/U87_GETUP.md` - NEW, yours: the numbers, 15 lines at most.

## What Claude already looked at (do not redo)

`tools/capture_retarget_triptych.gd` rendered `H2H_GetUp01` on f01 with `rest=hips` (sheets on Claude's branch;
you do not need them). Front and side: **KnockDown01's last frame and GetUp01's first frame are the same pose** -
face down, head to one side, legs extended the other, one arm bent up - and GetUp01 ends standing in guard
facing the direction KnockDown01 started from. C92 measured GetUp01 at 1.000 s with no dead air. **KnockDown02
(the second knockdown take) was NOT looked at.**

## The change

1. **Binding.** `"getup": {"path": "res://assets/anim/audition/ramsterz_h2h/H2H_GetUp01.FBX", "retarget": true,
   "reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx", "length_s": 1.000, "start_s": 0.000,
   "end_s": 1.000}` with a `##` comment naming C92 and this task. No `readable_s` (it is not a reaction). The
   RamsterZ H2H pack is already approved in `assets/asset_manifest.json`; nothing to promote.
2. **Which knockdown takes the get-up may follow - DERIVED AT BIND, never a hand-written list.** At the end of
   binding (after every role is grafted), for each take of `"knockdown"` (the `_variants["knockdown"]` entries)
   compute `mean_join_deg`: the mean, over every bone that has a `TYPE_ROTATION_3D` track in BOTH animations, of
   the angle in degrees between the knockdown take's rotation at its LAST key time and the get-up's rotation at
   t = 0 (`Animation.rotation_track_interpolate`; angle = `rad_to_deg(a.angle_to(b))`). Store per take name.
   **The rule:** a take is followed by the get-up when its `mean_join_deg` is at most **2x the first take's
   (`knockdown`, i.e. KnockDown01) on the same body** - KnockDown01 is the take Claude verified by eye; the
   factor is INFERENCE and the code comment says so. The first take therefore always qualifies.
   Expose `func getup_follows(take_name: String) -> bool`, `func getup_length_s() -> float` (0.0 when unbound)
   and `func knockdown_join_deg() -> Dictionary` (take name -> mean_join_deg).
3. **Playback.** In `play_role`, where a knockdown today queues nothing: when `getup_follows(anim_name)`,
   `_ap.set_blend_time(anim_name, <getup anim name>, BLEND_INTO_GETUP_S)`, `_ap.queue(<getup anim name>)`, then
   `_queue_stance(<getup anim name>)` so the queue is knockdown -> get-up -> stance. A take that does NOT qualify
   keeps today's behaviour exactly (holds on the canvas). `const BLEND_INTO_GETUP_S := 0.10` with a comment: it
   joins two frames of the same pose, so the blend only has to hide sampling; 0.10 s is the file's own
   into-a-strike figure (INDUSTRY, G57), not a study.
   Add `const ROLE_GETUP := "getup"` in `FightStagePlayer.gd` - NOT in `FightStageDirector.gd`: the director
   says what the fight did; the get-up is how the room shows it.

`var x := <call>` fails on a Variant return - write the type. A reused variable name in one function is a parse
error even across separate blocks. `%` in a format string is `%%`.

## The test - `tests/fight_stage_getup_test.gd`

Copy the mounting pattern of `tests/fight_stage_playback_test.gd` (`sed -n '1,120p'`): the legal demo pair
**f01 (`f01_m_box_welter_rigged.glb`) and f09 (`f09_m_bare_welter_rigged.glb`)**, both mounted, both bound with
`FightStagePlayer.bind`. For EACH body and EACH knockdown take (force the take with the role's round-robin: call
`play_role("knockdown")` once per take, re-binding or stepping the AP back to stance between them):

- Step `ap.advance(1.0 / 30.0)` for (knockdown take length + get-up length + 0.6 s), recording
  `ap.current_animation` and `ap.is_playing()` each step.
- For a take where `getup_follows` is true: the recorded names go knockdown take -> `getup` -> the idle take, in
  that order, each seen for at least one step; **zero steps with `is_playing()` false**; and the get-up is seen
  for at least `getup_length_s() * 30 - 2` steps (it is not cut short).
- For a take where it is false: the old behaviour - the last recorded step is not playing and holds the knockdown.
- Print one line per body per take: `GETUP body=<f01|f09> take=<name> join_deg=<x.xx> follows=<true|false>`.
- Check that f01's KnockDown01 `mean_join_deg` is below 20 degrees (Claude saw the two poses match; a big
  number means the instrument compares the wrong frames - the bound is a tripwire, not a finding).

## Gate - in this order, from the worktree root

1. `python Godot/tools/check_scripts.py Godot/scripts/FightClipBinding.gd Godot/scripts/FightStagePlayer.gd Godot/tests/fight_stage_getup_test.gd`
2. `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tests/fight_stage_getup_test.gd --timeout 600`
   - prints `TOTAL=N fails=0`. **A GDScript runtime error HANGS a headless run until its timeout: read the log
   after the first minute; a `SCRIPT ERROR` line means kill and fix.**
3. `python Godot/tools/run_tests.py --only clip,retarget,stage,anim,fight_world,paired --jobs 4` - **fails=1 or
   better**: `fight_stage_realism_test` is red by design until S4a lands. If lower, say so and push. If any OTHER
   test fails, re-run it ALONE (`--only <its name>`, no `--jobs`); if it still fails, name it and its first FAIL
   line in the digest and push anyway - Claude checks it against master at integration. Never re-pin a number to
   make a test pass.
4. Write `research/U87_GETUP.md`: the four `GETUP` lines, the subset's `SUITE` line, and one sentence on
   whether KnockDown02 qualified.

## Commit

`git status -s` first. `git add -- <the four owned paths>`, then
`git commit -m "U87: ..." -- Godot/scripts/FightClipBinding.gd Godot/scripts/FightStagePlayer.gd Godot/tests/fight_stage_getup_test.gd research/U87_GETUP.md`,
`git show --stat HEAD` (exactly those four), `git push -u origin cursor/u87-getup`, then
`python Tools/agent_comms.py send --from cursor --to claude --topic "U87 ready" --body "cursor/u87-getup <hash>"`.
Do NOT edit `HANDOFF.md`.

## The trap

The get-up must follow the knockdown TAKE THAT PLAYED, not "the knockdown role". `play_role` round-robins two
takes, so `_next_take` has ALREADY moved on by the time `play_role` returns - use `anim_name` inside `play_role`,
never `_next_take("knockdown")`, or KnockDown02 gets KnockDown01's verdict.

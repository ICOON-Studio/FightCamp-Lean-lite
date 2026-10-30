# Next session: S316 (written S315, 2026-10-30, after updates 17 and 18)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then `cd /e/FightCamp/Lean && git pull`.
2. Board: Q-S294-24 (update 14), Q-S294-25 (15 clinch + referee), Q-S294-26 (16 inside fighting), Q-S294-27 (17 ways
   out of the inside, pivot sequence attached), Q-S294-28 (18 the guard up close) are open; quote and act on any answer. Review board: S315 stills.
3. SEAT ANSWERS: John SQ21 J-INSIDE3 (how often each exit happens in real bouts) -> Game Godot/research/J_INSIDE3_JOHN.md.
   Verify its sources, then set InsideExits.PIVOT / TIE from it (and the test's share bands) - today's are estimates.
4. Ziva: weekly allowance resets Monday (his money call). Brief wt/ZIVA_LEAN/docs/ziva/S314_PLAYTEST_BRIEF.md -> update
   it to 17 and merge main into ziva/lean first.

## Where S315 stopped (Lean f804417, update 18 exported, 33/33 tests, smoke 0 errors)
- Update 18: GuardTuck.inner (gloves at the cheeks, elbow bend down and in; `-- noinguard` = control) and GloveClear
  (after HitSnap: a glove centre stays 0.15 m from the other's head centre; `-- noglove` = control). Measured with
  tools/inside_guard_probe.gd (pose as shown): wrists 0.23 -> 0.14 m in front of the face, glove deep in a head 36 -> 8
  of 571 inside frames.
- scripts/rules/InsideExits.gd (after ClinchBeats in ExchangeBeats): exit pivot / tie / step + exit_who (the pressed one);
  tie = the exchange's own clinch near the spell end or moved there with its referee break; pivot = check hook (her last
  free single punch -> lead hook) + pivot_t = end_t + 0.9 s (shifted in ExchangeBeats).
- RangeBreath phase "pivot"; Footwork._pivot: one fast circle step to her lead side (scale 1.3, 70 deg arc) once she is
  back in guard. HitSnap.sway: +-6 deg trunk lean inside at 0.7-1.0 Hz (FightStage sets it from inside_w).
- Round 1 probe: pivots turn the pair 37-84 deg in 1.2 s (6), steps back 9-39 (7), 1 tie; inside 21 %, feet 54-56 %.
- Tools: range_probe "exits" lines; clinch_still `-- <dir> <n> inside` now also shoots each pivot at 0 / 0.5 / 1.1 s.

## Next (in order)
1. Board answers (Q-S294-24..27).
2. Head to head up close: still E:/FightCamp/tmp/s315/stills2/c01 shows Maria's head past Lucy's in a deep lean -
   add a head-centre distance line to inside_guard_probe and fix if they meet.
3. Short shovel hooks/uppercuts inside (item 3: 15-30 cm of fist travel, elbow sharply bent) - check PunchReach /
   the hook clips' reach at 0.55 m.
4. J-INSIDE3 shares into InsideExits; Ziva playtest when it runs.

## Traps
- A new beat key with an absolute time (end_t, break_t, pivot_t) must be shifted in ExchangeBeats.build.
- docs/WHAT_TO_TRY.txt is the source; tools/export.sh copies it over Builds/ - never write notes only into Builds/.
- The exe smoke always ends "timeout after 40 s" (rc 124): the pass is 0 ERROR lines in its log.

---- previous prompt (S315) below ----
# Next session: S315 (written S314, 2026-10-30, after update 16)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then `cd /e/FightCamp/Lean && git pull`.
2. Board: Q-S294-24 (update 14), Q-S294-25 (update 15 clinch + referee), Q-S294-26 (update 16 inside fighting, still
   attached) are open; quote and act on any answer. Review board: S314 stills (inside hook, inside on the ropes, stance).
3. Ziva: the editor runs on wt/ZIVA_LEAN (ziva/lean 303be40 = main + the brief). In S314 every Ziva run aborted at once
   with $0 spent and the operator opened Ziva's Upgrade page (weekly limits reset Monday) - his money call. If `start`
   says ZIVA DOWN, start it: `powershell -NoProfile -ExecutionPolicy Bypass -File E:\FightCamp\Game\Tools\godot_hidden.ps1
   -e --path E:/FightCamp/wt/ZIVA_LEAN --log-file E:/FightCamp/tmp/ziva_lean_editor.log`; chat at http://127.0.0.1:7012/
   (New chat button by ref, the composer sends on Return, not the arrow), brief docs/ziva/S314_PLAYTEST_BRIEF.md.
   The newest log: %APPDATA%/Godot/app_userdata/FightCamp/ziva/zivacode-chats/*.jsonl ("stopReason" tells why it ended).

## Where S314 stopped (Lean de55cac, update 16 exported, 32/32 tests, smoke 0 errors)
- Inside range: InsideBeats (Qwen, TURN 0.75) in ExchangeBeats before _clinches; RangeBreath "inside" phase 0.55 m;
  Footwork.offset (0.07 m each, heads 14 cm apart), inside_w eases FightStage's floor 0.62 -> 0.48 m.
- Gap 7: FootPlant STAGGER 1.32 (`-- nostagger` = control). Referee: ALONG_TRY - never the camera side.
- Round 1 probe: inside 20 % (real 17-31), long 55 %, swings 25/min, feet 54-56 %, stance 0.32 NA, 14 spells, 3
  clinches, referee in front of the boxers 0 s (was 12.4 s).
- Tools: range_probe (planned vs shown spells, stance stagger, referee-in-front frames), clinch_still `-- <dir> <n> inside`.

## Next (in order)
1. Board answers (Q-S294-24/25/26).
2. Getting out of the inside (John J_INSIDE2, Game Godot/research/J_INSIDE2_JOHN.md): today a spell ends by a straight
   step back; the coaching books' exits are a ~90 deg pivot on the lead foot behind a check hook, or tie up the arms
   until "Break". A pivot = Footwork circle steps at the spell's end (no new clip); measure turn angle at spell ends.
3. Small head sways inside (heads off the centre line, side to side).
4. Ziva playtest when it runs again.

## Traps
- A new beat key with an absolute time (end_t, break_t) must be shifted in ExchangeBeats.build (`at`): the probe's
  planned-vs-shown line catches it.
- PowerShell `-Encoding utf8NoBOM` does not exist in 5.1; write files with [IO.File]::WriteAllText (no BOM).
- Python inside a PowerShell double-quoted -c: `$` gets eaten - edit JSON text with the Edit tool instead.

---- previous prompt (S314) below ----
# Next session: S314 (written S313, 2026-10-30, after update 15)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then `cd /e/FightCamp/Lean && git pull`.
2. Board: Q-S294-24 (update 14) and Q-S294-25 (update 15: clinch + referee, contact sheet attached) are open; quote
   and act on any answer. Review board: S313 stills (clinch, break, guard low at range, guard up in the pocket).
3. John J-INSIDE1 is queued (seat_queue SQ19 -> Game Godot/research/J_INSIDE1_JOHN.md): inside range share, spell
   length, what is thrown and how they defend in there. `start` prints SEAT ANSWERS when it lands.

## Where S313 stopped (Lean main, update 15 exported, 31/31 tests, smoke 0 errors)
- ClinchBeats (Qwen + 3 review fixes) -> ExchangeBeats._clinches; RangeBreath "clinch" phase 0.38 m; Clinch.gd (tie-up
  pose, CornerIK arms, heads side by side, release eases the floor back over 0.5 s); Referee.gd (built in FightCast.crew;
  cutman body, white shirt; far side from the camera, 0.6 m along the line; 0.85 m while they hold; af_push square
  between them; other side when the ropes pin him; keeps 0.55 m / 0.42 m in the push).
- GuardTuck.low (gap 5): wrists 0.26/0.16 m down + 0.06 m forward at rest; Footwork.aim sets it; runs on step clips.
- BurstShape (Qwen + SIZE_W retuned) in ExchangeBeats after _setup/_body, before _show_game and _clinches (gap 6).
- Ziva's defects: Exchanges press ok = body, MAX_RUN 3 (next_mode run arg from LiveRound), CornerJobs.fits (hurt).
- Round 1 probe: long 62 %, swings 23.5/min, feet 58 % (real 53-56), travel 122 m (real ~155), 3 clinches, referee
  nearest 0.48 m, inside 5 % (real 17-31 %).
- Tools: tools/range_probe.gd (clinch + referee lines), tools/clinch_still.gd (tie, break, range, pocket stills).

## Next (in order)
1. Board answers (Q-S294-24/25).
2. Inside range from John's J-INSIDE1: who steps inside and when (pressure fighter, after a clinch break, on the
   ropes), how long, hooks/uppercuts/body inside, heads on shoulders / forearms. RangeBreath has INSIDE_M (hooks 0.12 m
   inside the jab gap) - real inside is < 0.65 m pelvis to pelvis. Measure with range_probe (inside share), stills.
3. Ziva on Lean: start says ZIVA DOWN; wt/ZIVA_LEAN merge main, start its editor through Tools/godot_hidden.ps1, then
   a playtest of update 15 (preview_start http://127.0.0.1:7012/).
4. Gap 7 (stance a little longer, minor).

## Traps
- Bash eats backslashes in agent_window.ps1 arguments: launch agents from the PowerShell tool.
- Qwen tunes weights to pass a bound: read its constants against the brief and measure the output yourself.
- GuardTuck only ran on guard clips; at rest they step most of the time, so a guard change must cover the step clips.

---- previous prompt (S313) below ----

# Next session: S313 (written S312, 2026-10-30, after update 14)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then `cd /e/FightCamp/Lean && git pull`.
2. Board: Q-S294-23 (order of Ziva's fight findings) and Q-S294-24 (update 14 verdict, still attached) are open.
   Q-S294-22 was "Build it free" (clinch) - Qwen is building the rules.
3. COLLECT FIRST: Qwen CLINCHBEATS1 (brief Game Godot/research/TASK_CLINCHBEATS1.md; worktree E:/FightCamp/wt/LEAN_CLINCHBEATS1,
   branch qwen/clinchbeats1, out E:/FightCamp/wt/CLINCHBEATS1_out.txt, launched 12:44 pid 31488). Read
   scripts/rules/ClinchBeats.gd against the brief (counts 2.5/3.2/4.8 a round, 4.1 +- 2.3 s, referee step_out pair at
   break_t, no punch inside a clinch window), run tests/clinch_beats_test.gd + round_script_test headless, copy both files
   into Lean, add clinch_beats_test to tools/run_tests.sh, then retire the worktree and move the run to live_runs_archive.

## PC (after the cooling service, 2026-10-30)
Idle 51-54 C at 5-14 % CPU (was a 64 C median, 59-75). The same round film (tools/range_probe.gd, 1280x720) ran at
63-70 C (was 66-75) and took 11 min instead of 14. Right after the PC came back it read 89-90 C at 12-19 % CPU for a few
minutes (10:25-10:42, Windows still setting up) - if that shows after a normal boot, tell him.

## Where S312 stopped (Lean 1bb86ab, update 14 exported, 29/29 tests)
- Begin-fight freeze (Ziva): FightView.sync builds the 3D view hidden while the tale of the tape shows (timer 0.3 s ->
  prebuild(): setup + one SubViewport UPDATE_ONCE render), reveal() on Begin. tools/begin_probe.gd: click 2388 -> 13 ms,
  worst frame 1037 -> 51 ms. Parts: ring + boxers 1.9 s, corner crew 0.55 s, first-frame shaders 1.0 s.
- FightHud: BODY TAKEN; FightHud.score counts an exchange from its verdict caption (ExchangeBeats.VERDICT_LEAD_S 2.4);
  FightHud.draw_buttons (moved from FightView). BeatClips.combo_skip + COMBO_LAND_S/COMBO_SAME_HAND_S/MIN_WIND_S (moved
  from FightView; tests/fight_feel_test uses BeatClips). FightView is 492 lines.
- TaleOfTape.opp_kg: opponent weigh-in 0.2-1.4 kg under the class limit, steady by name (was "made weight").
- RingRopes.MAX_BOW_M 0.35 + through_m/through_who; film round1f (E:/FightCamp/tmp/s312_film): deepest bow 0.32 m,
  nobody through the ropes, gap/feet/travel numbers unchanged from S311.
- tools/export.sh now ships mh_skin_micro_normal.png (MHRig.dress reads it raw; every build since S263 drew skin without it
  and logged 6 "buffer_size == 0" errors). Exe smoke: `python tools/hidden_desktop.py run --timeout=40 --log=<log>
  E:/FightCamp/Lean/Builds/FightCamp.exe --audio-driver Dummy -- jump=fight` from Builds/ -> 0 errors.

## Next (in order)
1. Collect CLINCHBEATS1 (above).
2. The clinch in the ring (gap 4): ExchangeBeats.build calls ClinchBeats.apply(plan beats, {n, sit, energy, habits}, rng)
   after _show_game (the "hurt" game's two "clinch" extras then come from ClinchBeats - drop them from _show_game).
   FightView._fire "clinch" (today it plays "slip"): both boxers to ~0.35 m (stage gap target while a clinch holds),
   chest to chest, heads past each other's shoulder; the holder's arms over the other's (PunchReach / CornerIK targets on
   the other's upper back) on the block-loop pose (mc_Box1_M3_Block_Loop) - no clinch clip exists anywhere we checked.
   A referee: a staff body (CornerCrew bodies) recoloured white shirt + dark trousers, standing off the boxers' line; at
   a clinch he walks in (af_walk), at break_t plays af_push between them, the two "ref" step_out beats part them.
   Measure with tools/range_probe.gd (add a clinch count + inside-range share; real inside 17-31 %), film, stills.
3. Ziva findings by his Q-S294-23 answer; gap 5 guard by range; gap 6 bursts of 2-5 punches.

## Traps
- rule_guard.py blocks any command TEXT containing the console build's name - write agent prompts with the Write tool.
- PowerShell 5.1 `Set-Content -Encoding utf8` puts a BOM in a commit message file: write it with the Write tool.
- FightView.sync: a hidden view exists during the "tape" step; anything that looks for layer.get_child(0) gets it.

---- previous prompt (S311) below ----

# Next session: S312 (written S311, 2026-10-30, in a hurry: the PC went for a cooling service mid-session)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then `cd /e/FightCamp/Lean && git pull`.
2. Board: Q-S294-22 (clinch: build free vs paid capture quote) is NEW and open. Q-S294-19/21 were answered "ask ziva
   for playtest and review" - Ziva was mid-review when the PC went (see Ziva below).
3. After the service: watchdog numbers (idle was 64-70 C at 8-16% CPU on the Ryzen 7 7800X3D; he asked if 15 C less is
   plausible - yes at idle, 5-10 C under load from a repaste, more with a cooler upgrade). Record the new idle/load temps.

## Where S311 stopped (Lean 536e743, WIP: NOT exported, run_tests.sh NOT run)
- Real-fight gaps 1-3 (Game Godot/research/S310_REAL_FIGHT_GAPS.md) built:
  - scripts/fight3d/RangeBreath.gd (pure, tests/range_breath_test.gd PASS): phase in/pocket/rest from the beats; rest
    1.35-1.65 m, lunge LEAD_S 0.38 before a burst's first punch, pocket while punches are < 1.4 s apart, exit 0.5 s after.
  - scripts/fight3d/Footwork.gd (steps/circles moved out of FightStage, which is 423 lines): aim_step (attacker lunges at
    1.15x, exit 0.8x), rhythm steps at rest, step_in = pressure (the other gives ground a beat later), stop on arrival.
  - HitStun light lock 0.28 s + head_cut (reaction cut 0.12 s after its peak) for plain head shots; HitSnap FOLD_HOLD_S 0.45.
  - Measured round 1 (tools/range_probe.gd on the hidden desktop, same fight every run): gap median 1.14 m (p10 0.82 -
    p90 1.55), sd 0.29 m, long 52 %, inside 0 %, 29 swings/min, feet moving 46 %, travel ~107 m. S310 control: 0.95 m,
    sd 0.06, long 1 %, 0 swings, feet 9 %, travel 10 m. Real: long 40-63 %, swings 18-35/min, feet 53-56 %, 155 m.
    Inside range (< 0.65 m, real 17-31 %) is still 0 %: that is the clinch work (fix 4).
- His asks this session, both built: "make the ropes transparent when they block in the view" -> RingCamera.clear_view
  fades any rope/post crossing the lens->boxer line to 18 % (film round1c: works). "add kinetics to the ropes" ->
  scripts/fight3d/RingRopes.gd: 12 rope chains x 10 segments, springs + tension (~3.8 Hz, damped), bowed outward by
  spheres on the boxers' bones. FIRST FILM: ropes never bowed (nobody reached them) -> FightStage MID_IN_M 0.55 (was
  0.9) + per-boxer ROPE_LEAN_M 0.06 + step_in pressure. That film (E:/FightCamp/tmp/s311_film/round1e.mp4, eyes id
  round1e-a7b5bf11) finished: ropes bowed > 3 cm in 296 frames (~10 s), gap median 1.07 m, long 49 %, 29 swings/min,
  feet 46 %, travel ~105 m. BUT the deepest bow is 0.71 m (round time 34.2 s, about video 0:42-0:50, where a faded near
  rope bends) - too deep for a ring rope (real ~0.1-0.4 m). Find which sphere did it (likely a reaction clip whose hips
  travel past the ropes, or a glove) and cap the bow (MAX_BOW ~0.35 m) or keep the body inside; then look again.
- Films: E:/FightCamp/tmp/s311_film/round1*.mp4 (eyes index). Command:
  `python tools/hidden_desktop.py run --timeout=900 --log=<log> <godot.exe> --path E:/FightCamp/Lean --windowed
  --resolution 1280x720 --audio-driver Dummy --fixed-fps 30 [--write-movie <x>.avi] --script res://tools/range_probe.gd`
  (hidden_desktop needs --log= or the output is lost).

## Ziva (his answer to Q-S294-19/21: "ask ziva for playtest and review")
- Ziva for Lean = worktree E:/FightCamp/wt/ZIVA_LEAN (branch ziva/lean, addon copied from wt/ZIVA, excluded in
  .git/info/exclude, override.cfg Dummy audio). Start: `powershell -NoProfile -ExecutionPolicy Bypass -File
  E:\FightCamp\Game\Tools\godot_hidden.ps1 -e --path E:/FightCamp/wt/ZIVA_LEAN --log-file E:/FightCamp/tmp/ziva_lean_editor.log`,
  chat at http://127.0.0.1:7012/ (built-in browser pane), Ziva Smart, effort slider max.
- scenes/dev/JumpFight.tscn / JumpFightNofilm.tscn / JumpCorner.tscn (Main.jump_override) open the build at a test part
  without command-line args - run_scene caps a run at ~27 s, so Ziva reached round 2 with the game's skip buttons.
- Brief: wt/ZIVA_LEAN/docs/ziva/S311_PLAYTEST_BRIEF.md; it had 9 checked shots in docs/ziva/shots and was writing
  docs/ziva/S311_PLAYTEST_REVIEW.md when the PC went. If the review is missing: a NEW Ziva chat, "finish the review from
  the shots in docs/ziva/shots and the brief" (approve its mv of its own shots one by one, not "always allow").
- Then: put Ziva's ranked findings to him on the board with the shots attached; fix defects first.

## Next
1. Re-run the rope film; tests (`sh tools/run_tests.sh`) + export; WHAT_TO_TRY update 14 (the range breathes, head
   shots let her fight on, feet keep moving, see-through + springy ropes) + a board question with a still.
2. Ziva's review -> board.
3. Gap 4 clinch + referee (his Q-S294-22 answer), 5 guard by range, 6 2-5 punch bursts.

## Traps
- FightStage is 423 lines, FightView 497: fight footwork goes in Footwork.gd, range rules in RangeBreath.gd.
- `free` is an Object method: a GDScript method named free() fails to parse ("signature doesn't match the parent").
- A bone read from outside the skeleton's modifiers gets the clip pose (RingRopes reads pre-modifier bones; fine for contact).
- PowerShell 5.1 mangles `git commit -m` with quotes: commit with `-F <file>`.


# S217 DIGEST (2026-10-13) - collect day, cloud seats, heat governor, Ludo r50-r52, Mixamo batch 2

## Merged to master (each verified by Claude's own run, numbers from the tests' own lines)
- MIXAMO1C (Arena PR #143, diff): HitReactionPick pure picker - hit_reaction_pick_test 96 checks, 0 failures.
- RECOVERY1A (cloud Cursor PR #144, diff): RecoveryRate 1433 checks PASS, CutResistance 1356 checks PASS (factor(50) == 1.0 exact).
- NIGHTLY5B FIX1 (qwen/nightly5b f320d69c, diff): face_drawn_foe ON 13.8 < OFF 23.8 PASS; hold_pair_geometry 0.461 < 1.119 PASS.
- MetaHuman cast fix (Claude): FightWorldStage.model_for_skin uses all 12 MH4 boxers - men 01-09, women 10-12 (sex from each
  mh_boxer_NN.json); women no longer get the MPFB body. mh2_bodies_test errors=0 with metahuman_bodies off AND on.
  NOT visually closed: cast stills on the game camera are in the detached queue (below).
- Tools: rule_guard.py (PreToolUse hook - live from the NEXT session), heat_governor.ps1 (suspend newest Godot on RED, resume 60 s
  after RED), proc_pause.ps1, gbot "dev" alias, Goose on the Qwen Token Plan key, cloud-agent grok diagnostics, record_room
  cast_sex/cast_ids.

## UNCOMMITTED in the shared checkout (tests queued - the next session commits or reverts them)
- RECOVERY1B (cloud Qwen qwen/issue-145) + RECOVERY1D (Goose goose/issue-146) applied by diff + Claude's swap
  FightRealtime.gd:2164 `"recovery_rate": RecoveryRate.for_athlete(athlete)`. Files: FightRealtime.gd, FightStamina.gd,
  GameSwitches.gd, RecoveryRate.gd, tests game_switches_test / recovery_rate_fight_test / recovery_rate_athlete_test. Parse PASS.
  Diff reviewed: switch-gated, factor 1.0 = byte-identical OFF.
- Mixamo batch 2 (operator "yes finish with the downloads and put the in the game"): 6 FBX (without skin, 30 fps) in
  assets/anim/mixamo_s215 - Sitting_Idle (corner_rest), Dizzy_Idle (count_stand), Kneeling (count_knee), Kneeling_Inspecting
  (cornerman), Entry x2 (walkout). MixamoMotion.gd: 5 categories + LOW_BY_DESIGN exempts seated/kneeling from the standing-hips
  gate; mixamo_s215_test expects 121 rows. Import + bake + test queued.
- DETACHED QUEUE E:/FightCamp/tmp/s217_queue.sh (pid 30336 at handover), results in E:/FightCamp/tmp/s217_queue.txt:
  cast stills female+male (res://docs/previews/cast_s217/<sex>/overlay_03s|10s|22s.png) -> 6 recovery tests -> Mixamo import,
  bake, test. Each step waits for GREEN. If the file has no "=== DONE", re-run `bash E:/FightCamp/tmp/s217_queue.sh`.

## Agents at handover (live_runs.json)
- Codex TECHSTAGE1 FIX3 (wt TECHSTAGE1): FIX2 accepted (contact carry ON 4 < OFF 6, scoped sign fix; OFF-arm change = mastery on
  in the game set). Left: Q226 conditioning 88.1 < 88.9; commit; 37-test list --jobs 1.
- Codex ANIMSOURCE1D FIX2 (wt ANIMSOURCE1): operator REJECTED FIX1 ("each boxer is looking at different directions ... wrists
  twisted", "wtf is that" - bodies inside each other). Builds 3 measured gates red-first, to Ludo r50 numbers.
- Cursor PROFILE2E r9b (resumed after a Cursor 'Service Unavailable').
- Arena SHAPEGATE1 (chat 01a13482) + RECOVERY1C_A (chat 01a13483) - PRs to collect by diff.
- Grok BODYPICK1 (issue #147): first run died on the guessed model id; re-run 38374613766 prints `opencode models xai` - set repo
  var GROK_MODEL from that list and re-run.
- Maria M_ICONS54 round 2 (Ludo r51's 11 fixes) -> delivers to _maria_delivery/M_ICONS54_R2.

## Ludo rounds (asks + replies + verdicts in research)
- r50 body hook spec (spacing 52 cm, gaze <= 8 deg, wrist <= 2.5 deg, vertical fist, one canonical guard); jab-range 145-165 cm REJECTED.
- r51 icons APPROVE WITH CHANGES (11 fixes sent to Maria; spark/number style -> board Q-S212-11); Kalli's "The House That Holds" APPROVED.
- r52 story skippable + story = tutorial: Ludo STRONGLY AGREES (two switches, 3 presets, one-way convert to sandbox, Mara replaces
  Leo). Verdict + 3 corrections -> board Q-S212-12 (build STORYMODE1 -> STORYTUT1 -> STORYPARITY1 on approval).

## Operator answers this session
Q-S212-8 "you have authorization to do it yourself" (GitHub token for the Grok box - Claude may not enter credentials; operator
added XAI_API_KEY himself, option A). Q-S212-9 "Use the Qwen key" (done). Q-S212-10 "i have no idea about this you judge and act".

## Found and fixed / mistakes
- Usage band mod removed (operator: ugly, covers half the screen).
- Two RED spikes (84-88 C): Claude's own check_workflow branch gate ran a full editor import; two agent Godot jobs at once ->
  heat governor + rule guard. The governor's pause made one Codex test time out (told Codex to re-run such tests alone).
- Claude "accepted in the lab" a hook the operator rejected at once -> memory feedback_s217_visual_and_heat.
- gbot broken by Grok Bot app 0.70.2 (descriptor v3); bots read through the app (computer-use). Collected Maria M_ICONS54 and
  Kalli STORY1_KALLI.md (both had never reached the PC).
- Renamed an old Downloads/Entry.fbx by mistake for a minute; restored.
- NIGHTLY 10-13: 5 NEW reds vs 10-12 (causation_real_path, corner_card_wired, creation_api, smoke_test, training_floor_3d), 4 fixed
  (q226_speed, q226_strands, result_clock, switch_gate_hands_smooth_in_whole). Not yet diagnosed - needs a PC seat (LFS).

## HANDOFF
Next session, in order: (0) PDF follow-ups (visual-gate skill, board reconcile, CLAUDE.md/MEMORY reorder - see roadmap now). (1) read E:/FightCamp/tmp/s217_queue.txt - open the cast stills yourself (gap, noses, wrists, feet, which
bodies), send + board; commit RECOVERY1B/1D+swap if all 6 tests PASS, commit Mixamo batch 2 if bake + test PASS. (2) collect Codex
TECHSTAGE1 FIX3 + ANIMSOURCE1D FIX2, Cursor PROFILE2E, Arena SHAPEGATE1 + RECOVERY1C_A, Grok BODYPICK1, Maria R2. (3) MIXAMO1B on
the next free Codex seat (now 121 clips). (4) the 5 new nightly reds. (5) board answers Q-S212-11 / Q-S212-12.

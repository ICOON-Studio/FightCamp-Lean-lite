# S377 digest (2026-11-03)

## Built and pushed (main)
- Argon's fight prompt 2b3e1562 (ops/Tools/gemini_judge.py FIGHT_PROMPT): it still described "women's amateur boxing ... and a
  referee" - Argon docked the absent referee every FIGHT9 round. Now: men bare-chested / women in a singlet, NO referee by
  design (S369 ruling), judge the knockdown flow. R6 BASE film rejudged 3.5 -> 3/10 (old verdict kept as
  previews/dispatch/FIGHT9R6/before.oldprompt.gemini_argon.md); its worst moment: the dead knockdown state.
- KNOCKCOUNT1 53e011ff: scripts/fight3d/KnockdownCount.gd - after a knockdown the round clock holds, the standing boxer goes to
  the far neutral corner (routed round the lying body), a big count 1-8 (KO: 10) under the banner; standing count: he rises at
  the sim's up_at (BoutNight now stores r["up_at"]; countdown clip seeked to its rise) -> BOX!; RSC -> STOPPED; KO -> he stays
  down (clip held), the winner celebrates, the bout ends at once (FightView._bell). Own lens (overhead close-up while the
  winner walks, wide once he is in his corner). Review workflow found 5 real defects, all fixed (BOX! never cleared; skip
  during a KO stood him up; a skip left the replay armed - it froze the corner minute; the walk crossed a lying body; the
  count could KO the round's winner - ExchangeBeats now gives the count to r["down"]). BeatFire runs the count a frame later
  (big shot + count share a t; unstable sort). judge_film keeps the round's later beats after its forced knockdown.
- STEPROOT1 d9c6180b: scripts/fight3d/StepRoot.gd - a body travels only as far as the clip's planted foot pushes it (forward
  kinematics on the clip's keys over the rest pose, cached per body + clip). The corner walk = the back-step loop at 0.6x moved
  by StepRoot, turning on the planted foot. Operator on the walks: af_walk "so bad" (limps - the clip: `nofeet noknee` look
  the same), the glide "legs dont really move they slide across", the step loop squats (hips 0.17 m low, knees cave in - the
  clip). The library has no walk that reads right -> TASK_LOCOWALK1.
- Probe tools/knockdown_film.gd (modes: default, stop=KO, stop=RSC, stop=KO skip, kneelog): clock drift 0.000 s, walker 0.00 m
  off the neutral mark, 1.1 m+ from the body, the count's picture 0/324 frames out, BOX! gone 4 s later, skip: no replay,
  KO stays down. S377 738c17ed: it reads the DRAWN bones (skeleton_updated) - outside the modifier pass get_bone_global_pose
  returns the CLIP's pose (its first slide number 0.017 m/s was the clip's). Drawn: the walk slides mean ~0.2 / p90 ~0.34 m/s
  -> that line is RED by design until LOCOWALK1's clips land; every other line PASS.
- Knee tremble (operator: "the knees seem to be trembling"), measured drawn, the fight after BOX!: jerk p95 11-15 deg/frame^2,
  4-7 direction flips/s with FootPlant; 1.6-3.2 / 0-1.7 with `nofeet`; `noknee` / `nojoin` no change. `kneelog`: a foot is
  mid-step 43 % of frames, each 0.2 s swing pumps the knee 152 -> 125 -> 160 deg; standing, the knee pins at CAP 163.8. Tried
  and REVERTED (not clean): step only past the clip's own reach; SWING_S 0.32 + LIFT_M 0.025 (fight 4-7, corner 15-20, a 69
  spike). Real fix = real step clips + StepRoot, FootPlant as ground contact only.
- CI: fight-stills artifacts kept 2 days (were 14) - GitHub Actions storage hit 100 % (0.52/0.5 GB, Guru-Meditation); the
  operator OK'd deleting the 237 old ones (318 MB) - done, 0 left. Cache 76 MB stays.
- 21 related tests green (bout_stoppage, knockdowns, round_script, exchanges, burst_shape, clinch_beats, fight_feel ...).

## Seats
- FIGHT9 R6 (agy): Argon 3 -> 3/10, dropped (PR #30). R7 QUEUED on agy from claude/fight9base, which Claude merged with main
  (3264b79e, no conflicts; knockdown_film all PASS but the known-red walk line). TASK_FIGHT9R7.md carries the S377 knee numbers.
  PR #28 (round 4, dropped) closed.
- LOCOWALK1 (cursor, LAUNCHED 16:53, runner 41164 / cursor 41468, wt LEAN_LOCOWALK1, branch cursor/locowalk1): Ludo CLI 0.2.2
  (logged in, Pro, 536 credits, cap 6) - walk_back_guard / walk_guard / walk_relaxed + step_in/out/left/right_guard; bars:
  hips <= 0.08 m low, knees in line, drawn slide p90 <= 0.05, drawn knee jerk p95 <= 4.5. Its BASE film judged 4/10 (main
  with the count). Operator S377: "Try Ludo first" (a bought mocap pack only if Ludo fails the bars - his money call).
- BJJ9 (Ziva, round 10, thread "BJJ9 Round 10" on 7012): restarted the editor (MCP was down); working the armbar finish pose;
  hit the 32k reply cap once - Continue clicked. Nothing pushed yet (ziva/bjj9 = cf5891cf).

## Not done
- Kalli's "plan line names the combination" share (0.40): plan lines are StrikeMap moves, own combos are not options - needs
  a plan option for an own combination (PlanLines.options + PlanFight.rate) before OwnCombos.use_share(named) can be wired.
- Roster boxer tiles have no face photo (Ana's card has one).
- The operator has not played update 73; no exe export this session.
- E:\FightCamp\wt\MERGE_F9BASE (temp merge checkout, ~0.5 GB) left for the operator to delete (the safety check refused).

## HANDOFF
- Commit: 7988a595 + this digest (main). Evidence: ops/previews/S377/knockdown_count.mp4 (count film), eyes bursts in
  ~/.cache/eyes/knockdown-count-502b31e7/looks/.
- Next: collect LOCOWALK1 when it lands (eyes burst + drawn bars; wire walk_back_guard as KnockdownCount.WALK_CLIP; then the
  step clips into Footwork with StepRoot - FIGHT9's files, brief it); collect FIGHT9 only at a real 9/10; BJJ9 at 9/10.

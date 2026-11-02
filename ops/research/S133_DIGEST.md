# S133 digest (2026-09-30, Claude) - the 22 ft ring, a man faces the man he can see, agents on Dola's review

Nightly cited: `AgentComms/nightly/latest.txt` 2026-09-30 at c2f2c955 - 464 tests, 18 fails (9 hangs under load).

## 1. RING1 - the boxing ring is 22 ft (operator 2026-09-30: "make it 22ft on the next session") - DONE 935ee895
- `ArenaSurface` boxing and `GameState.SPAR_ARENA_SPEC` boxing -> `boxing_ring_fl_max` (6.7056 m inside the ropes,
  Fla. 61K1-4.005(1)(a) 18-22 ft); ropes 18/30/42/54 in unchanged; kickboxing/savate keep the 18 ft floor (not ruled on).
- `tools/s132_ring_scale_probe.gd -- as_game`: contest 5.486 -> 6.706; engine half-width 2.443 -> 3.053 m (the
  calibrated bands run at the engine default 3.0 m, so the watched bout is now nearer them). The probe now READS the
  wanted size from the spec.
- Focused tests (ring/rope/walkout/footwork/arena/spar, --jobs 4): 26/28; the reds are the nightly's own
  (footwork_economy MMA 9.3 m/min; ring_position R16 cage half - operator-deferred S4n 2026-09-17).
- Stills: `docs/previews/s133_ring_22ft.png`, `s133_ring_before_after.png` (sent).

## 2. OR1 - a man faces the man he can SEE - DONE ace41b65 (p90 gate met; 3 marginal strikes residual)
- NEW `tools/s133_facing_split_probe.gd` split the S132 error three ways: the ENGINE faces its foe to p90 2 deg; the
  track carries it (p90 2.3); the ROOM's placement was wrong (drawn pair line vs engine line p90 94, max 180).
- Traced to the point of write (trace + `debug_stage_observer`): (a) bodies pointed along the engine facing, not at the
  drawn foe; (b) while a whole take held one man, the other walked to his ABSOLUTE engine spot, round the held man;
  (c) every take froze the yaw (77% of frames are whole takes); (d) strike lunges had a sideways part; (e) C191's posed
  contact push ratcheted two men round each other in a double exchange (~0.1 m/frame at stage `contact_stop`, the pair
  line spun ~270 deg while the engine's held within 11 deg).
- Five room switches, game ON / `--script` OFF: `face_drawn_foe`, `hold_pair_geometry`, `reface_in_takes`,
  `warp_on_line`, `contact_push_on_line`.
- Before -> after (seed 92012, as_game): s132 probe engine-facing-vs-foe p90 93 -> 25 (gate <= 30 MET), max 180 -> 55;
  body yaw vs foe p90 53 -> 19; strikes started > 45 deg off 6 -> 3 (45-49 deg; 2 blend out of a body-shot reaction).
  `s131_bullet_probe` (gains `off=` for control arms): glove >25 m/s 0, >15 m/s 3; whole-strike root p95 2.50 (control
  2.50) - a first cut of (e) divided by the normal's line share and lifted it to 3.04, fixed by keeping C191's magnitude.
- The engine orbit was NOT the problem: p90 76-88 deg/s sits inside U123's real hip-line yaw (p50 35 / p90 114); the
  S131 note compared the orbit with the real MEDIAN.
- The "chest" instrument lies at contact: a cross turns the shoulder line 50-80 deg by design; judge the ROOT there.
- Recording `docs/previews/anim/live_boxing_seed92012_s133.mp4` watched frame by frame (15 contact sheets) and sent:
  the men face each other; S132's jab into empty air is gone. Residual CLIP poses (not facing): slip-counter twist at
  pocket range (f 282-298), B's big lean-back hit reaction (f 490-496), a near-horizontal lunge (f 502-506), a deep
  crouch (f 804-810).
- Focused room tests: 14/17; reds = the nightly's own (body_overlap 2.1 mm hand>head; readable_onset and room_positions
  hangs); tests run the new switches OFF.

## 3. Defects fixed on the way
- The operator's "debug popup": `Tools/godot_hidden.ps1` hid a render window late (a CIM query every 50 ms pass) and
  only once. Now 15 ms checks on a cached pid list, re-hide if it comes back, focus handed back if taken;
  `FIGHTCAMP_HIDDEN_TRACE=1` logs each hide (measured: one hide at the first frame, took_focus False).
- The home card's fighter "Condition" auto-matched the Glossary's EQUIPMENT-wear term and coloured amber from 70 where
  the rules say 60: new `body_condition` term + `BodyReadiness.readiness_band` (0be47782).

## 4. Collected
- D65 (Dola): in `research/D65_IN_ROUND_RECOVERY_RAW.txt` lines 171-260 (she answered in the D66 chat). PCr fast
  half-time ~22 s, bursts 1.2 s / pauses 2.3 s, 75-85% low intensity (DOCUMENTED); output -15..20% late (SECONDARY).
- D66 (Dola, 5/10) on the roadmap at the operator's word: GF1 widened (first-week guide, stat scale + hovers, camp
  preview, offer difficulty, unlock rules); backlog D: FP1, PW1 (win % from real sims), CN1, SC1, CE1, WC1, TR1, FN1,
  ID1 (identity as emphasis - a lock would break "legal for his ruleset").
- Grappling datasets (operator paste, verified by a subagent): ViCoS BJJ positions EXISTS (120,279 stills, 6 sparring
  sequences ~30 fps, per-frame labels + 2D poses, CC BY-NC-SA) - usable for ground-seat TIME SHARES and transitions
  (annotations.json 209 MB, needs the operator's download OK); Open FSW (210 clips, 7 throws, no poses) and the HF
  "dataset" (one clip) are not useful. None has 3D paired motion.

## 5. Agents (operator: "why the other agents sitting?", "why all agents are fucking idle?" - my miss, now gated)
- MERGED as diffs (code, tests, digests, key stills only - never the 80-still walks): U201 Cursor (card/skills/home
  hovers), Q219 Qwen (offer record + difficulty, camp previews; dead vars cut), G149 Grok (one-click week presets) -
  3ccf0e36, 19/19 screen tests; C226 Codex (ST1 base, `in_round_recovery` DEMO switch; send-back 1 was fair: my brief
  missed the intent window, D65 was uncommitted, worktree git metadata unwritable -> CODEX_ADD_DIR) - 6cd66660, engine
  tests 6/6. C226 census ON: hold 47-51% (band 75-85), thrown 39.6/man/round (band 45-56; OFF ~40 in its population).
- IN FLIGHT at close: Cursor U202 (finance + floor hovers, D:/FightCamp/wt/U201), Qwen Q220 (KM3 neck capsule,
  D:/FightCamp/wt/Q219), Grok G150 (Body Lab + fatigue hovers, D:/FightCamp/wt/G148), Codex C226b (ST1 tune,
  D:/FightCamp/wt/C226). Outputs: AgentComms/prompts/<id>_out.txt.
- Onboarding: the CoachMarks tutorial already walks new career -> first result; the career walk turns it OFF, so D66's
  "no onboarding" was an artefact.
- GROK-SUB removed from the board (operator: "stop putting deadlines on my agents ... if they are available on the
  opsboard you use them"). NEW `Tools/idle_guard.py` Stop hook (.claude/settings.json): a turn cannot end mid-stage and
  every in-rotation shell agent without a running CLI is named; CLAUDE.md s2 NEVER IDLE.
- Ops board: NEW live Agents page http://127.0.0.1:8787/agents (`/api/agents`: process alive, worktree branch, last
  commit, files changing now, output tail; refresh 5 s) - operator could not use the VS Code workspace
  (AgentComms/agents.code-workspace, kept). A stale duplicate server (01:42, orphaned) was killed with the task one;
  the scheduled task restarted it.

## 6. More defects fixed (operator on the recording)
- "why he leans forward like that": a slipped BODY shot played the duck slip and buried the head in the foe's midsection
  -> body/leg slips play FadeBack (dir "fade"), head slips unchanged (f70b7e4b; re-recorded, 5/5 director tests).
- "the video is so choppy": NEW `tools/s133_chop_probe.gd` (hitches = one-frame jumps, pops = out-and-back; `off=`).
  OR1 was not the cause (on 57 / off 77 hitches). Found at the point of write: `contact_stop` pushed ~0.2 m in a frame
  and the hold pulled back (ratchet), and a whole take ending asked a 0.3 m jump that the root cap turned into
  standstill -> 2.5 m/s in one frame. Switches `contact_push_carry` (cap 0.06 m/frame + fold into the hold origin) and
  `root_accel_cap` (20 m/s^2 on speed-ups only): hitches 57 -> 35, pops 164 -> 103, root hitches 14 -> 5, root max
  7.8 -> 5.4 m/s; glove-to-target at contact unchanged (p50 0.26 m both arms); facing held (p90 25). Hands now carry
  most pops - next.
- Sounds: operator "keep them for now i need to hear the sounds again" -> sound board sent (38 samples); numbers flag
  a 0.05 s crowd murmur, three 0.05-0.07 s glove hits and fixed-length thuds/blocks/scuffs.
- Context: CLAUDE.md is 10.7 KB (not the cause, not undone); five never-used connectors turned OFF for new sessions
  (Magicweave, Figma, SurveyMonkey, Bannerbear, Mobbin; checked in past transcripts); MEMORY.md garbled line removed.
- Cascadeur is paid (ends 10-27) and unused in the clip pipeline; Blender builds props only.

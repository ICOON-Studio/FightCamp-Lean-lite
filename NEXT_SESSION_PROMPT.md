# S513 handover (written 2026-11-17 ~23:00, end of S512 - main line, Opus)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digests: `ops/research/S512_DIGEST.md`,
`ops/research/S510_DIGEST.md`, `ops/research/S510_ANIM_DIGEST.md`.

## BILLING FOR THIS SESSION: the $350 Console credits (owner S512: "prepare next session to use the bonus 350$")
Run it in the `claude` CLI logged in to the Anthropic Console account - the desktop Code tab cannot bill credits. Steps,
prices and a rough per-session cost: ops/research/API_CREDITS_FALLBACK_S474.md (section S512). In your first message say
which model you run and the rough cost; check `/cost` every ~100k tokens of context; stop at ~$300 spent or at the
subscription reset (2026-11-19 14:00 UTC = 16:00 his time) and go back to the desktop app. Sub-agents bill too (two at most).

## GOAL (owner, verbatim, still on): "i want animations fixed (at least 7/10)"
The animation is now REBUILT, not patched (METHOD below), by its OWN Fable session: "Fight animation rebuild, part 2
(Fable)" (local_9ee8e7a4) was running at the hand-over - it collects Goose's choreographer (issue 356) and builds the v2
player. Do not start another animation session while it runs; if it has stopped, the next one starts from the ANIMATION
LOOP STATE section (bottom) on Fable (check its model with get_session - start_session ignores the model field).
The main line (this session's seat) owns everything outside scripts/fight3d.

## MAIN LINE - DO FIRST
1. Collect what lands: Dola SQ211 (season ladder v6 -> ops/research/DESIGN_LADDER1_V6_DOLA.md) and SQ212 (coach spec r6 ->
   DESIGN_COACHSPEC1_R6_DOLA.md) - each then goes to two fresh critics (Goose + Dola; the Grok bots are out of quota);
   Qwen MORNINGSPROBE1 (coached mornings: solo vs shared, collect its PR by diff).
2. Guard damage (GUARDDMG1 v1): Dola 6/7/7, Goose 6/6/7 -> revise the map from both 10/10 lists, another critic round.
3. Ask for a bout leftovers: the Home DO NEXT line ("<name> has no bout: ask for one"); the three unwired fight-week
   rules ASKPROBE4 found (week-before pad night, late-night injury/cut, FightWeek.banked) -> INTEGRATE1.
4. The owner has a new .exe to play (Ask for a bout, WHAT IT TAUGHT, the palette on the Training tab).

## METHOD (operator S510, CLAUDE.md item 8 - quote this in your first message)
Fight animation: STOP PATCHING. 14 rounds of correction layers scored 4.5-5/10 while the Undisputed / Boxing Manager /
Blood & Canvas studies said the method is wrong (punches recorded per distance, captured reactions, motion matching /
inertial blending - no layers bending arms and heads). Next: FIGHTPLAYER2 - the baseline diagnosis
(ops/research/FIGHTPLAYER2_BASELINE_S510.md, part 3), the full scope (ops/research/FIGHTPLAYER2_SCOPE_S510.md), two fresh
critics judge the scope (owner: "have that judged"; 7+), then build it phase by phase. HIS APPROVAL IS STANDING: "i approve
anything that will fix animations do not post stupid questions that i do not understand" - never ask him about animation
work; report the critics' scores and what changed in plain words (money for a mocap pack is still his explicit yes).
No new correction layer in scripts/fight3d until v2 is built. No new animation purchase until the baseline says the clips
themselves are the limit (owner: "why should i buy more animations if the ones we have right now are so bad").

## First
- Q-267 answered "Only when I'm not playing": before any film, list windowed processes (Get-Process with a MainWindowTitle);
  a game window (ArcheAgeChronicles, FightCamp, Steam games) = no film. Q-268 "Yes, medium": effortLevel is medium.
- He sent a usage-cost video (Fable 5.2 cheap). Done: `.claude/agents/Explore.md` puts search helpers on Haiku. The video's
  other rule for us: do not split small jobs across helpers (briefing + re-reading costs more than doing it).

## Traps seen this session
- EVERY in-session Godot test takes `--fixed-fps 60` (tools/run_tests.sh passes it, S470). Without it hit_carry read 29-33
  and join_return 2-4 run to run, and older debt numbers (block_meet 3) were measured that way.
- A capped trunk cannot give back the body's own slide: a head that rides the root/hips needs the slide fixed, not PopCap.
- `cd` into E:/FightCamp/tmp moved the session folder: use absolute paths.
- watch-video skill: local faster-whisper fails on this PyAV (`metadata_errors`); feed it numpy from `wave` instead.

## MAIN LINE STATE (main-line side session, S511, 2026-11-17 ~21:30)
- FIGHTFILM1 slices 1-9 on main. S511 added (d3c340fbc..7e7a21e25): Game plan lines on filed film claims (GamePlanRows
  film_fit/film_tag: "Film 85%" = Works at best, "Film: confirmed", "Cleared - change this line"; FilmNight.sit_of /
  claim_on); own-bout mode scripts/ui/FightAnalysisOwn.gd (result page tab PUNCH BY PUNCH, History > Analysis, corner
  minute "The round so far"; WHAT DECIDED IT + WHAT THE OTHER CORNER WILL SEE with Fix it on the pads = f.habit_fix);
  AfterFight.keep_tape keeps the last 20 tapes on c.results; scripts/ui/FightAnalysisTape.gd = film night "Write the
  answer" (Game plan over the film) + Fight prep "Watch the tape" (no checks). TapeRoom.gd + tape_room_test REMOVED.
  tests/film_night_test.gd 51 ok (in run_tests list). Stills: tools/fight_analysis_still.gd (hidden desktop) - looked
  right; the film slot is still an empty box (no 3D film in the page yet).
  LEFT: the 3D film in the page's FilmSlot (TapeFilm), the 3D CornerOverlay line (fight3d = animation session), Settings
  fight-log On/Off, "walks the other down" divider words read oddly on your own bout.
- ASKFIGHT1 NOT built on purpose: map v4 critics 5/6 and the owner's 7+ rule. Round 4 queued S511 to Kalli/John/Dola
  (SQ206-208, brief ops/research/ASKFIGHT_CRITIC_S511_BRIEF.md: does the fight week make the date a real trade?). Read the
  answers in `start` (SEAT ANSWERS); build only at 7+ (AskBout/FightLearn are ready, map section 6 lists the menus).
- IN FLIGHT: Qwen ASKPROBE4 (branch qwen/askprobe4, near vs far show with the fight week; collect its PR by diff - it
  only adds tools/ask_probe4.gd + docs/ASKPROBE4_RESULT.md), then MORNINGSPROBE1 queued (dispatch_queue). Ask critics
  SQ206-208 land as ops/research/ASKFIGHT_CRITIC_S511_{KALLI,JOHN,DOLA}.md. With both: map v5, then wire AskBout +
  FightLearn only at 7+ (menus: map section 6; golden path: map 7 step 4).
- CLUB WEEK: S511 wired the WEAK SPOT line (Training > MORNINGS, CoachedMornings.weak_line, training_k_test). v1 (S485 build plan) is wired - day job, loyalty bar/leaving/pro share, film seats. Left and GATED: the second
  class night (ClubDeal.class_cash needs COACHFIT1's coach time; COACHFIT1 critics 6/5, 6/6) and coached mornings
  (CoachedMornings: CHECK 7 with COACHFIT1 + a drawn page). ClubDeal's pad dealer is superseded (Q-242/Q-260 never short).
- Unwired audit (S511): AskBout, FightLearn, ClubDeal, CoachFit, CoachMarket, CoachedMornings, MatPrice, BoutSheet,
  Knowledge, TapeClips (old Tape Room), TrainingWeek; the rest are rulers/tools (BalanceHarness, GroundRules, HeadEase,
  HeadSplit, HookPast, PunchSnap, StandOff). Script: python <scratch>/unwired.py logic = a module no other script names.
- SPLIT500B collected (Qwen PR 352, diff applied, PR closed). CI FIX: run_tests.sh used /e/FightCamp/tmp on the Linux
  runner - every CI test failed since 8d0e67650; now only where /e exists. grapple_fix_test fails 18 on main (pre-existing,
  not in the run list): look at it.
- C: TRAP: every Godot run takes --log-file E:/FightCamp/tmp/<run>.log; a `cd` in Bash moves the session folder.

## S512 SIDE SESSION (Opus, beside animation part 3, 2026-11-17 ~21:00) - main line only
- Committed Dola's Ask-for-a-fight round 4 (ops/research/ASKFIGHT_CRITIC_S511_DOLA.md): depth 7 / play 7. Its #1 for 10/10:
  show the next TWO club shows side by side (soonest = fight week only, next = full prep), each with its own cards; say
  why a card is absent; per-date prep checkmarks (film evening, spars, week-before). Kalli SQ206 / John SQ207 still queued:
  build AskBout + FightLearn at a second 7+.
- ASKPROBE4 (Qwen, E:/FightCamp/wt/LEAN_ASKPROBE4) was still writing at 21:00: a count=2 smoke run already says YES (far
  +7.5 win, +5.5 plan mastery, +6.3 injury). Its grep: NOT WIRED - FightWeek.spar_night.costs_pad_night (week-before pad
  night), SPAR_LATE_INJURY_X / SPAR_LATE_CUT_STOP, FightWeek.banked mastery units -> INTEGRATE1 work. Collect by diff.
- Palette (ONELOOK1, Q-251): tools/palette_sweep.py --training swept the Training tab, drill cards and scorecard; guard
  baseline 73 -> 29. Left on purpose: WeekCards TILE/SPARE (one colour per ability), fight3d (animation session).
- FightAnalysisList.GAME_WORDS now subject-free ("pressing forward"...). Settings "Show the fight log" waits for the live
  log panel (map card "Live fight log", Grok Dev) - the settings page offers only options that work.
- tests/grapple_fix_test.gd failing 18 is the S399 GRAPPLEFIX1 TARGET test (red on purpose, not in the run list, BJJ
  parked) - not a regression.
- Not exported: the .exe does not carry the S512 UI changes yet (the animation session's next export picks them up).
- FIGHTPLAYER2 HAND-OFF (the S510 supervisor, closing, to S512): part 3 (local_b19ae020) does ONLY the baseline ->
  ops/research/FIGHTPLAYER2_BASELINE_S510.md, then stops. Everything after it (scope critics, the build) is the main line's.
  S512 queued the scope critics on the free seats: SQ209 Dola, SQ210 John, brief
  ops/research/FIGHTPLAYER2_CRITIC_S512_BRIEF.md -> ..._S512_DOLA.md / _JOHN.md. Next: read the baseline against the
  scope's table 1d, read both critics (7+ = build phase 1, the clip census; under 7 = revise the scope, another round),
  build on Fable (the owner's "Keep Fable" for animation) in scripts/fight3d/v2/ behind `-- fightplayer2`.
- BASELINE LANDED (027098b04, part 3 stopped): raw 4.5/4.5 = placement-only 4.5/4.5 = full 4.5/4.5 (six blind critics).
  Table 1d verdict: the layers buy nothing -> the scope AS WRITTEN; retargeting keeps poses -> no phase 1b, except restore
  the jab's cut tail (bake 0.84 of 1.07 s) in phase 1; the travel lost to FightClips.hold_root_xz is phase 3's root motion;
  the feet stack squashes the bought upright stance (knees 146-151 -> 125-135) - the v2 foot lock must keep the clip's knee.
  The critic brief now carries the baseline (SQ209/210 not sent yet). Part 3's round-15 edits stay PARKED
  (E:/FightCamp/tmp/fightweek/s512/r15_parked.patch): they are new correction layers, which the METHOD forbids.
- GROK BOTS OUT OF QUOTA (owner S512: "use arena or ludo or goose grokbots are out of quota"): Kalli/John/Maria queue
  items PARKED in seat_queue.json (SQ202-207, SQ210). The second critics went to GOOSE instead: issue 353 FP2CRITIC1 ->
  ops/research/FIGHTPLAYER2_CRITIC_S512_GOOSE.md, issue 354 ASKCRITIC5 -> ops/research/ASKFIGHT_CRITIC_S511_GOOSE.md
  (each a PR adding one file; collect by diff). Dola (free) still answers: SQ209 FIGHTPLAYER2 critic sent 21:10.
  Owner "assign them to others": Kalli's revisions -> Dola SQ211 (ladder v6 -> DESIGN_LADDER1_V6_DOLA.md), SQ212 (coach
  spec r6 -> DESIGN_COACHSPEC1_R6_DOLA.md); John's guard damage critic -> Goose issue 355 (DESIGN_GUARDDMG1_V1_CRITIC_GOOSE.md).
- LEAN CI (owner "Yes, switch it", S512): November was at ~28,100 of 50,000 Actions minutes on the 17th (pace ~49,500).
  ci.yml now runs tools/ci_pick.py: ONLY changed files (owner: "i do not want checks on things that were not change") -
  changed tests (+ the brief's own RED_TEST on a PR) and a parse check of changed scripts; anything else passes at once; full suite = the PC's 05:00 run or `gh workflow run ci.yml
  -f full=true`. There is NO nightly suite on GitHub (no workflow has a schedule).
- ASK FOR A FIGHT BUILT (S512, d1fa334c3; owner "Yes, build it"): AskDates (Goose ASKDATES1, collected by diff), AskFlow,
  AskPanel, BoutFinish (host gate, every amateur bout teaches), ResultPage (WHAT IT TAUGHT), Main.nav keeps "ask";
  tests/ask_wire_test.gd + ask_dates_test in run_tests.sh. Exported. Left: Home DO NEXT, the stoppage-risk word.
- RAM: ~10 finished sessions sit idle with Remote Control on (~750 MB each, S491 note); watchdog AMBER on memory.

## ANIMATION LOOP STATE (the animation session's own section; rewritten 2026-11-18 ~01:30, S512 animation session part 2 on Fable, closed near the context cap)
Owner: "i want animations fixed (at least 7/10)" = two fresh blind critics (coach + animator) both 7.0+ on one film. You are
the ONLY animation session; you own `scripts/fight3d` (v2 in `scripts/fight3d/v2/`) and this section. Quote the METHOD line.
WHERE WE ARE: FIGHTPLAYER2 (the rebuild, `ops/research/FIGHTPLAYER2_SCOPE_S510.md`, section 8 = the critics' changes).
The v2 player EXISTS and plays the real bout behind `-- fightplayer2`. It has NOT been filmed or judged yet: the owner's
game (ArcheAge) was open the whole session and films run only when no game window is open (Q-267). r14 = 4.5 / 4.5 is the
control arm; the shipped player is untouched without the switch.
- PHASE 1 DONE (0b1a1d50d): the clip census, `assets/data/clip_db.json`, `ops/research/CLIP_CENSUS_S512.md`.
- PHASE 2 DONE: Goose's choreographer collected by diff (79b9dee65, issue 356 closed), then tightened here (2759011cb):
  `v2/Choreographer.gd` (plan(beats, db, opts): punches planned in the order they LAND, the Punch PRO takes first, a hit
  cuts what the hit man was doing, he gives ground only on a combination's last punch), `v2/ChoreoGap.gd` (the distance
  plan: rest 1.7 m, creep to 1.4, the step in ends 0.08 s before the glove lands, the pocket 1.2 m between a burst's
  punches, the leave), `v2/ChoreoReact.gd` (reaction / block / defence takes), `v2/ChoreoRules.gd` (the constants).
  `tests/choreographer_test.gd`: its sweep now FAILS on a plan fault - 40 seeds, 840 punches, 0 distance faults, 6
  punches off their take's distance, 24 cut by a stun. `tools/fp2_plan_dump.gd` prints one exchange's plan
  (`sh E:/FightCamp/tmp/fightweek/s512b/dump.sh seed=9 from=2 to=5`).
- PHASE 3 BUILT (e73a523a7), NOT JUDGED: `v2/Player2.gd` (414 lines) plays the timeline: a take starts when its event
  says, through the join smoother with the join time of its kind; the take's own hip travel moves the BODY (RootPath);
  the distance plan moves the pair (the man it names covers the ground); back to `pro_idle` when a take ends. Every
  shipped pose layer is OFF in the fight (kept: JoinSmoother, MetaHumanTwist, FootPlant with no stance stretch,
  FloorStand, TiredSag, PunchAim); a director's scene (walk-in, corner minute, the count) gets the old stack back.
  `v2/PunchAim.gd` = the ONE arm finish (scope 3a): a landed punch's glove front ends on the lower face / the ribs, at
  most 0.30 m, eased in over the last 0.22 s (two-bone IK solved for the glove front; not for a miss or a block).
  Hooks: FightStage (v2 node, `_process` / guard / `_on_finished` / scene_mode / `_shown_at`), FightView (`_queue` plans
  the exchange, `_process` hands the clock, `_ambient` off), BeatFire (`stage.v2.takes`), FightClips.untouched (pinned
  takes from the untouched bake: the census's contact times hold). FightStage is at 495 lines, FightView 491: no room.
- NUMBERS (headless; `tests/player2_test.gd` = two exchanges, two different bodies; `sh .../s512b/t.sh player2_test`,
  `TARGS="-- show" ` prints every contact): landed gloves median 4.4 cm off the target (26 cm with no finish), 11 of 14
  within 12 cm, counts kept, no head inside the other man, rest 1.36-1.66 m, no missed glove on him. DEBT lines (guards,
  not passes): 5 head jumps (the body shot's own dip plus the step in), foot slide 3-4 m an exchange by that ruler.
  The REAL bout headless (`sh .../s512b/bout.sh v2a 75 fightplayer2 fp2log` = human_fight_film with `show3d`, no GPU,
  allowed while he plays): 0 script errors, three exchanges planned and played; the film's own rulers
  (`s512b/v2a/rulers_motion.txt`, `rulers_raw.txt`): support-foot slip 9.5 / 6.5 m in 75 s (RAW 33-37, shipped
  0.2-0.4, bar 1), head jumps over 12 cm 13 (r14 14, bar 0; all inside a take: jab_a 26 cm, hook_ft 22 cm), heads
  inside 0, distance p50 1.5 m, knees p50 150 / 141 and 133 / 123 (the bought stance is back on boxer 0).
- NEXT, in order (each is v2 work, not a correction layer on the old player):
  1. FILM IT the moment no game window is open (`sh E:/FightCamp/tmp/fightweek/s511/film_only.sh <out> fightplayer2`
     - it refuses while a game is open; seed 7, 75 s, beside r14) and run the blind coach + animator round (briefs in
     `E:/FightCamp/tmp/fightweek/r14blind/`). Look at the stills yourself first: nothing of v2 has been SEEN yet - the
     guard hands, the block take, PunchAim's elbow and the joins are only numbers so far.
  2. FEET (the biggest number left): (a) a reaction played "upper" is pinned WHOLE-BODY today (its feet step while the
     hips are held = skating: gutshot 1.2 m, hit_by_hook 0.9 m of the slip) - build the upper-body mask (legs stay on
     the guard take) or play it with its travel; (b) steps: FootPlant only reacts once the body is 10 cm off a foot.
     The plan KNOWS every step (tracks' `step` events: start, end, metres): drive the feet from it - lift the lead
     foot as the ramp starts, land it where the ramp ends, then the rear - so a planted foot never moves. FootLock
     (`-- fp2lock`) was worse (a spring: 14 m).
  3. The film's rulers cannot see v2's hits (reactions read 0): fill `stage.hit_gaps` from Player2's contact callback
     (`Player2.contacts` holds t, who, move, result, take, gap) so reaction delay / size and "cut by his own punch" read.
  4. Head jumps: the step in overlaps the take's own dip (body shot, jab_a); end the step earlier for takes whose head
     travels over 15 cm before the contact (`head_max_m` in the table), or slow the step for them.
  5. Hooks on boxer 1 pass 14 cm beside the face point (the path, not the timing): aim hooks at the side of the jaw,
     not the face centre. Blocked punches get no finish yet (they stop 5-10 cm long by plan): look at the film first.
  6. Not built: pivots (the plan writes them, the player ignores them - the camera is fixed side-on), the clinch (no
     owned take; they stay at range), the knockdown falls through to the old code (untested in v2), the HUD body map
     gets `view.body.land` only. Light reactions for a jab fall back to hook reactions (no straight-back light take
     is owned: the buy list).
  THE GATE: v2 must beat 4.5 by a point with the blind critics; then phase 5 deletes the replaced layers.
- PHASE 4 (after the gate work): 4a stills of every reaction / block / defence take, fix the table's bars by eye; 4b
  wire the pools (size and direction), block flinch, whole-body stumbles, hurt idles.
- EXPECT (say it plainly when asked): Dola expects 6.5-7.0 on owned clips, Goose 5.5-6.5; with the end-of-November
  purchase 6.5-7.5. Buy order: stepping punches, hooks at head height, straight-back light reactions, longer uppercuts.
  Money is still his explicit yes, after he sees the motion.
- TOOLS (E:/FightCamp/tmp/fightweek/s512b/): t.sh <tests...> (60 fps through the slot; `TARGS="-- ..."`), dump.sh (a
  plan), tool.sh <tool> (a headless v2 tool, e.g. fp2_feet_probe), bout.sh <name> <secs> fightplayer2 (the real bout,
  no picture, both ruler reports), census.sh. Film: s511/film_only.sh.
- TRAPS: a test that prints `failures=0` may still have SCRIPT ERRORs (a parse error in a preloaded module): t.sh
  prints them, read the line. Write patch scripts with the Write tool (a heredoc with an apostrophe broke the shell
  again). A hook's glove front covers ~20 cm a frame: read its PATH between frames, never one frame. The glove
  follows the skeleton a frame late: call `gloves._follow()` after a seek before reading `glove_front`. `.uid` files
  under scripts/fight3d are untracked on purpose. Never `cd` out of E:/FightCamp/Lean. Goose: 5 used on 2026-11-17.
- r14's parked patch (`E:/FightCamp/tmp/fightweek/s512/r15_parked.patch`) stays parked: correction layers.

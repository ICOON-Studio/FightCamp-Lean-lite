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

---- previous prompt (S310) below ----

# Next session: S311 (written S310, 2026-10-30, after updates 11-12: shout bar without the free answer; fight display, body damage)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then work in `E:\FightCamp\Lean` (`git pull`).
2. Board: Q-S294-19 (update 12) and Q-S294-21 (update 13, corner minute) + review comments on the S310 stills.
   Q-S294-20 (corner plan) was "Yes, build it" - built (eca97b4). Q-S294-18: "needs more features/mechanics for the
   player during the fight but these need to be wired also with the other aspects (training,etc)".
3. Collect the real-fight study (side session local_e568234c: Game Godot/research/S310_REAL_FIGHT_GAPS.md); first finding:
   FightStage._compose holds the jab gap all the time (step_in moves both boxers; clinch beats only play a slip). His play notes S310:
   "playing it seems satisfying", "fight looks ok for now but can still be improved". Flat back: if he still sees it,
   the guard posture (upright spine) is next - cloth normals were the shading half.

## Where it stands (Lean 83e852d + c7dda85)
- LiveRound.preview returns `coach` (the best call for what the corner sees = the clue's answer; tests/tools use it as the
  "read the clue" policy) and `mark` (what the shout bar marks): "" without film study; with film study (depth 3) the best
  call for Exchanges.favourite(style) - her heaviest game in STYLE_MODES - or for our fighter's own tired/hurt state.
  The UI (ShoutBar, FightNight words) passes `mark`, never `coach`.
- Shout buttons: small line = the call's "when" ("Use when Maria presses") + the grade line; "expect" is the tooltip.
  The mark reads "coach's pick (from film)" (CallButtons.PICK_FILM). The corner minute grid still marks the coach's read
  of the last round (PICK) - that is the corner's job between rounds.
- ShoutBar.SHOW_S 10 s (was 8): clue + labels ~22 words at 238 wpm (Brysbaert 2019) ~5.5 s + a 4-way pick and the mouse.
- Measured (tools/exchange_balance.gd, policy "mark" new): film 3 edge 0: none 0.56 / follow the pick 0.66 / read the clue
  0.72; film 1: none 0.56 / read 0.67 / wrong 0.26. exchanges_test section 10 bounds read > pick + 0.03 > none + 0.02.
- Film study is ON by default in SET CAMP ($150), so most first fights show the film pick.
- Wording (c7dda85): the last bare her/she in fight lines name the boxer - CornerCard "Lucy's 1-2 landed whole",
  RoundScript.CALL_CAPTION {her} (round["names"], ExchangeBeats passes ctx names), BoutRules.why film line, FightWords
  fallback + fight_words.json "{her}'s round.". exchanges_test 1c scans 182 fight lines (no sentence-initial She/Her, every
  call caption names her); fight_words_contract_test CALL_TEXT carries {her}.

- Ops board "Run on this PC" (e341d68 + Game 0df4769b, his ask "a link on the board to launch the latest version, or the
  part I need to test only"): Play FightCamp (latest build) + Test buttons. A test button opens a .lnk in Builds/ carrying
  `-- jump=<id>` (Explorer drops plain arguments); TestJump.gd plays the real buttons to that part on its own save slot.
  EVERY UPDATE: add/replace the jump for what WHAT_TO_TRY asks him to test (TestJump.JUMPS, make_shortcuts.ps1, the
  rows in Game AgentComms/launch_targets.json), then export.

- Update 12 (42419f7, f39b33f): Exchanges.COMMIT (wrong call x1.5 Good / x0.6 Poor; always-green 0.55 = none 0.54, read
  0.68); body damage BODY_SHARE 0.2 / BODY_CALL_SHARE 0.5 / BODY_THREAT_SHARE 0.35, BODY_COST 1.2 energy per shot taken all
  fight (f.bout.body {a taken by her, b by the opponent}, lv.body); LiveRound.state -> rec "after" + round "start" feed
  FightHud.paint (energy bar, BODY HITS, HURT) so the display never runs ahead; ExchangeBeats._body makes the ring land the
  counted body shots; HitSnap.fold (FOLD_GAIN 2.6, hold 0.3 s) on a landed body shot; FighterKit.cloth_normals gives
  MH_Top/Trunks/Trim the skin normal map.

- Update 13 (eca97b4): CornerJobs (pure) recover / set-up / talk; Bouts.corner_jobs parses
  "corner:<call>|fix=|setup=<combo>@<gap>|talk=|rec=water:2,ice:1"; LiveRound.now_offer -> preview "now" -> gold
  CallButtons.now_button; CornerJobsRow builds the card rows (3D CornerOverlay + words FightNight); ExchangeBeats._setup
  plays the combination. TestJump jump=corner gives TestJump.DRILLED combos. Bouts.gd is 493 lines - split before adding.
- Tale of the tape: TaleOfTape (rules) + TapeCard (3D), FightIntro TAPE_S 5.5.
- Parse gate in Lean: `<godot> --headless --path . --check-only --script res://<file>` on every touched .gd before a
  windowed run (S310: a multi-line lambda and an untyped `:=` hung corner_film 450 s).

- 7b324d2: BeatClips.pick(pool, has, roll) - every Punch Pro take in REACT / BIG_REACT / DOWN / OUT / WIN / TIRED, the
  beat's roll picks (FightView passes _amb_rng.randf()). Blocks and fidget v4/v5 stay out on purpose.
- NEXT: Game Godot/research/S310_REAL_FIGHT_GAPS.md ranked fixes 1-3 (range that breathes, 0.2-0.3 s head-shot lock,
  feet moving), then the clinch (his choice: free build vs paid capture).

## Traps
- A bone read from outside the skeleton's modifiers gets the clip pose: anything a modifier moves (the look now moves the
  head) must be read from what the modifier recorded.
- PowerShell 5.1 mangles `git commit -m` with quotes: commit with `-F <file>`. Rewrite JSON files with their own indent
  (roadmap.json indent 1, media_comments.json indent 2) or the diff is the whole file.
- FightView.gd 497 lines: new fight code goes in ExchangeBeats / ShoutBar / FightHud / FightCast.

## Wrap-up duties
CLAUDE.md "Wrap-up": tests + export, ops board roadmap, rewrite this file, memorize the session, ask before handing over.

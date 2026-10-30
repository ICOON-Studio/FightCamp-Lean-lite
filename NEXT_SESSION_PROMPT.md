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

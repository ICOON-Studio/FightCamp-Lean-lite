# Next session: S311 (written S310, 2026-10-30, after update 11: the shout bar no longer gives the answer away)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then work in `E:\FightCamp\Lean` (`git pull`).
2. Board: Q-S294-18 (his verdict on update 11) and his review comments on the S310 still (8787/review, "Update 11").
   Quote each.
3. Then by his word. Standing answer: Q-S294-10 "Keep polishing the fight first".

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

## Traps
- A bone read from outside the skeleton's modifiers gets the clip pose: anything a modifier moves (the look now moves the
  head) must be read from what the modifier recorded.
- PowerShell 5.1 mangles `git commit -m` with quotes: commit with `-F <file>`. Rewrite JSON files with their own indent
  (roadmap.json indent 1, media_comments.json indent 2) or the diff is the whole file.
- FightView.gd 497 lines: new fight code goes in ExchangeBeats / ShoutBar / FightHud / FightCast.

## Wrap-up duties
CLAUDE.md "Wrap-up": tests + export, ops board roadmap, rewrite this file, memorize the session, ask before handing over.

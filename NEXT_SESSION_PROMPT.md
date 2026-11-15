# S488 handover (written 2026-11-15 at the end of S487; S487's digest: ops/research/S487_DIGEST.md)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S488`.

## USAGE RULES (kept)
- Run `get_usage` first. Start the wrap-up at ~310k, hand over by 420k. Miro P0 redraw once at start, once at the end
  (send only the changed widgets; then `where_we_are_svg.py learn` with the new ids and `trim` after a delete).
- Godot jobs through `python ops/Tools/godot_slot.py run --who s488 -- <cmd>`; `timeout` OUTSIDE godot_slot; single tests
  `--headless --audio-driver Dummy --fixed-fps 60`. A Godot command inside a heredoc trips rule_guard: write the script
  with the file tool. Several tests in one slot: a small sh runner with `xargs -P 2` (S487 used $TEMP/s487_tests.sh).
- Never `cd` into a worktree; use `git -C <wt>` (S487 slipped once at the start).
- Arena: pure modules / tests only, no Godot - run its test yourself. `python ops/Tools/lite_mirror.py --lean push` first.
  Prompt: built-in pane arena.ai/agent, wait ~12 s for the repo row, focus `[contenteditable]` by JS, execCommand
  insertText ONCE (check the zoom: a second insert doubles it), send at (661,377) with the box at normal size.
- seat_queue paths are relative to ops/ (`--brief research/<file>.md`).
- Goose: GOOSE_PER_DAY 3 (UTC day); 11-15 used all three.

## IN FLIGHT (collect, do not resend)
- Arena APPROACH2 (chat https://arena.ai/agent/01a1df16-850a-751c-9fb9-5f050bd336aa, a lite PR): run
  tests/approach_contract_test.gd; apply each of its five mutants to scripts/state/ApproachWire.gd one at a time (each must
  go red), restore, merge the test.
- Qwen STYLE4 (qwen/style4, wt E:/FightCamp/wt/LEAN_STYLE4, started 13:59): merge only on docs/STYLE3_RESULT.md's gates
  (each style 1.5-4 wins in 100, none best vs all). CLASH9 then WHYGRADE1 dispatch themselves after it.
- Seat queue: SQ176 Kalli TRAINGAME2 v2 -> two critics; SQ177 Dola + SQ178 John score ladder v3 -> his board only with
  depth 7+ from both.

## FIRST
1. Collect APPROACH2 and STYLE4; seat answers.
2. HOMEBOUT1 (Claude, map R58 section 8): the promised show's bout is really boxed - a legal novice on c.show.day
   (Bouts.legal_index; Region novice if none), no ticket cut, its result moves loyalty as any bout; ApproachWire.show_night
   then reads "boxed" from it (today: fit = boxed).
3. APPROACHUI2: the rest of map section 7 - Roster flag row APPROACHED, offer card "Pass: loyalty -3", Money stipend line
   "held to <date>", Records "leaves for Eastside ABC" + promises kept/broken, Rankings "(left us <month>)" tag, Week review
   loyalty row, Club > People PROMISES OPEN. One test reading each menu's data function.
4. STEPVALUE1: ropes count + StepEffect in LiveRound; the learn card reads StepValue.
5. FOURSTART1, re-scoped by his Q-246 answer ("The normal game will start with 0 fighters . The reason told you to make 4
   fighter start was to see the menus populated how they look and for the tests"): a TEST CLUB start - three boxers in
   different weight classes + one BJJ fighter - picked on the create screen as a test start and usable by the tests. The
   normal start stays as it is (no boxer signed, a walk-in at reception); no money balancing for four.

## Known reds (NIGHTLY1 S487 entry): fight_why (WHYGRADE1), plan_bots, block_meet B_A pro_left_hook control row.

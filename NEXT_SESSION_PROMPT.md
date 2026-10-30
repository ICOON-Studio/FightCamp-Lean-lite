# Next session: S310 (written S309, 2026-10-30, after update 10: clear fight words, the coach's neck, one fix for a habit)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then work in `E:\FightCamp\Lean` (`git pull`).
2. Board: Q-S294-17 (his verdict on update 10: wording, neck, habit fix) and his review comments on the S309 stills
   (8787/review, "Update 10"). Quote each. Q-S294-16 was superseded by 17.
3. Then by his word. Open: clue difficulty (the "coach's pick" mark gives the answer away - consider showing it only with
   film study); shout bar time (8 s). Standing answer: Q-S294-10 "Keep polishing the fight first".

## Where it stands (Lean 61fa5c6)
- Wording rule (his "fix the wording"): two women in the ring, so a line never says a bare her/she for a boxer - it names
  her. Exchanges.CALLS when/expect use {her}/{opp} (Exchanges.named); "tell" is the coach talking to his fighter ("you" =
  ours). CornerCard says "Lucy landed 3 clean jabs." Tests: exchanges_test 1b, corner_card_test.
- CornerIK: a look is shared from the head down to the chest (CHAIN_SHARE, head first) and runs BEFORE the arm reach; it
  records `head_world` (the head as shown). CornerShots.bone("Head") and CornerCrew.face read it.
- HabitFix.gd (pure): PUNISHED_BY (habit -> situations from Kalli's punish lines), HABIT_COST 6, slow_starter/fades_late by
  the clock; cost() with the fix held as far as Exchanges.uptake(coachability). LiveRound charges it per exchange
  (rec habit / habit_line), notes paid habits in f["notes_seen"] at close, fixes(f, r) offers seen ones. Bouts:
  "corner:<call>|<habit>". UI: CallButtons.fix_row in CornerOverlay (3D) and FightNight (words, m["fix_pick"]).
- Measured (tools/exchange_balance.gd): even fight none 0.56 / read 0.67 / oracle 0.72 / wrong 0.26; Lucy who drops the
  right vs Priya: none 0.43 / read 0.53 / read+fix 0.59. tests/habit_fix_test.gd bounds fix > read + 0.03.
- tools/corner_film.gd `habits=a,b` gives Lucy habits the opponent punishes and picks the first fix.

## Traps
- A bone read from outside the skeleton's modifiers gets the clip pose: anything a modifier moves (the look now moves the
  head) must be read from what the modifier recorded.
- PowerShell 5.1 mangles `git commit -m` with quotes: commit with `-F <file>`. Rewrite JSON files with their own indent
  (roadmap.json indent 1, media_comments.json indent 2) or the diff is the whole file.
- FightView.gd 497 lines: new fight code goes in ExchangeBeats / ShoutBar / FightHud / FightCast.

## Wrap-up duties
CLAUDE.md "Wrap-up": tests + export, ops board roadmap, rewrite this file, memorize the session, ask before handing over.

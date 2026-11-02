# S308 DIGEST (2026-10-30) - deeper fight: 3:00 rounds, a shout every 30 s, clues; update 9

Operator ask: clues for the best call, choices that change the fight, a round timer, 3-minute rounds, corner callouts
every 25-30 s. Mid-turn: "can you use miro to show your plans" -> plan drawn on Miro frames 6-11
(https://miro.com/app/board/uXjVEV03QWA=/), doc S308_FIGHT_TACTICS_PLAN.md, board Q-S294-14 -> "Build it, full 3:00".

Built in Lean (1e628ce, 75b1cc4): Exchanges (rules), LiveRound (round fought exchange by exchange), ShoutBar,
ExchangeBeats, FightHud, CallButtons; words screen got the same shout bar. Measured (tools/exchange_balance.gd, 400
bouts, even): none 0.60, coach's read 0.70, oracle 0.77, wrong 0.31; -10 with perfect calls 0.27. Fixed: skipped
intro/corner minute kept filming one frame. 23/23 tests, fight3d_play 0 failures. Update 9 exported.

## HANDOFF
- Next: Q-S294-15 verdict on update 9; then habit-fix call, clue tuning, or fight polish by his word.
- No agent runs in flight. Lean NEXT_SESSION_PROMPT.md is current.

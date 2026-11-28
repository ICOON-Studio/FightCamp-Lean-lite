# S573 digest (2026-11-28, Opus 5.5)

## Owner's words this session
- Board Q-S294-348 (answered before the session): "Yes, delete all three" -> the AMD usage log (2.4 GB) and both Ollama
  installers (2 x 1.95 GB) deleted; C: 8.6 -> 14.5 GB free (12.4 GB two hours later - watch it).
- "@Octagon_Tactics_v2_7_Directors_Cut_Print_And_Play.pdf consider these for v2.7 : Adding 1-2 Tell / Read mechanics
  (e.g., certain Feints or high-Reflex passives forcing the opponent to reveal whether their next card is Red/Blue or
  Yellow/Green) ..." -> v2.7 saved (ops/research/octagon/v27/, read whole), built as v6 with his Tell.
- "check if 2.7 ismissing anything from the version that rate 7/8 bby the bots and see if you can fix it" -> yes, see v6.1.
- "show me the standings" -> given (Maria 29 pts, John 20, Kalli 17, Claude 15 after r14).
- Q-S294-349 / Q-S294-350 closed from his S572 words (league after balance; his synchronized files agree).

## Done
- OCTAGON CUP r13 on v5.3: fun 7/8/8/7 = 7.5, depth 7.0 (Maria KO'd Claude R3, John-Kalli 28-28). All four seats: a
  pinned or spent man had no real choice -> v5.4 ON: Clinch & Hold also at cage 0 / under 3 stamina, once a round, 1
  stamina, the referee breaks to Mid (bots 41-58%). Two log lines fixed (liver cap names the right man; "no extra cost").
- OCTAGON v6 = his v2.7 Director's Cut, boxing (proto/octagon/cards_v6.mjs, `v6=1`, `pure=1` = as written): his 16
  boxing + Fight IQ cards, Signature Stance Guard, Desperation Surge, neutral resets, one speed bonus (capOne), Pocket
  Armor, Deep Breath only if unhit, and HIS TELL: a won Shoulder Twitch Feint = next exchange he seals first and you see
  RED/BLUE or YELLOW/GREEN (versus_oct WAIT + the driver asks the holder second; the bots use it).
- His question answered (docs/OCTAGON_V6_RESULT.md): v2.7 as written = Pressure 69-74%, out-fighters 32-35%. Missing
  from v5: Initiative +1, the cup's always-there cards and outs, and HALF THE POWER BONUS (his cheaper punches let POWER
  pay every exchange). v6.1 = 37-59%.
- Cup r14 on v6.1: fun 6.75 (both winners: Stance Guard 9 of 18). v6.2: Stance Guard free once a round then +1, Range
  Jab at Long and Mid (37-58%). Cup r15 on v6.2: fun 8/7/7/8 = 7.5, depth 7.0 (Claude beat John 29-27, Kalli-Maria
  28-28). v6.3: Range Jab after a Range Jab +1, Cut the Cage beating a Defend walks him to Close (39-57%).
- Cup r16 on v6.3: fun 7/7/7/7 = 7.0, depth 6.75 (Claude-Maria 28-28, Kalli beat John 29-27). v6.4: Read Tendencies shows ONE
  card (his v2.7 text; two cards + Lead set up a free power counter - John, Kalli). heavyTrade / stanceTax=2 measured, left OFF.
- Bugs found playing and fixed: Stance Guard locked, Counter v Defend paid a whiff, NOW speed of a step-in card, tell
  off a clinch, tell line said "you" to both men, always-there punches could not combo, D v D logged twice.

- His next message: "add statuses and debugs like staggered or stunned, keg injured, cut etc" + the 2.5D art pipeline
  ("We need these ?") -> not yet (his S542 order: mechanics first; bosses/arenas are the career layer that waits for balance;
  LAYERS1 is our own Spine-like route). v6.5 STATUSES ON: Staggered (legs), Rocked +1 to the judges, Cut (his Eye Cut, from
  sharp straights, the doctor at 5), Winded - bots 35-57%, doctor 4%. Cup r17: fun 7.25, depth 7.0 (Claude beat John
  30-27, Kalli beat Maria 29-28). v6.6: live judges' score + Stance Guard repeat costs 2 (37-59%).
- "when you will make a new cup for that version ?" -> a separate v6 table from r14: Kalli 10, Claude 10, Maria 5, John 0.

## Standings (r1-r14, 3 a win, 1 a draw)
Maria 9-2-3 29, John 6-2-6 20, Kalli 5-2-7 17, Claude 5-0-9 15. r15: Claude beat John, Kalli-Maria drew. r16: Claude-Maria drew, Kalli beat John.

## Not done / next
- LAYERS1 (worker tab of S572) still rendering, paused itself when he opened ArcheAge at 01:30; RULES569 chain_p2 and
  KICKFIX6 tables still running - nothing to collect yet.
- BUILD1 round 4, MMCPLAY1, LONG3 untouched.

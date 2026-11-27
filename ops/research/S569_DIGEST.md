# S569 digest (2026-11-27, Opus 5.5)

## His answers
Q-345 tells "Cut it"; head moves "Drop the Head row"; public push "Push now" (twice: v0.569.1, v0.569.7); counters
"Second round"; kicks "put a fable console for kicks i want it finished today"; distance: "Build the toy"; "Yes, measure
it" (the exchange that gets dearer); "Closing it now" (ArcheAge, for the kicks); "Yes, stop it" (RECOIL1's leftover renders).

## On the page (proto/twohands, all committed; public site at v0.569.7)
- 0.569.1 no Head row in the ?ui=body view; 0.569.2 Stay put is a card on the strip; 0.569.3 the cross from Long no
  longer moves him (blue_cross_short re-cut); 0.569.4 steps drawn from each man's own spot (ring_ui stepChain - both
  stepping in, the cut-off); 0.569.5 animated tooltip (replaced by .7); 0.569.6 the strip reads GUARD / FEINT / PUNCH;
  0.569.7 PICTURE CARDS: the hand is small looping cards of blue alone (canvas cut, card_crop.json), all fit, far ones
  dimmed; 0.569.8 the guard switches are picture cards; 0.569.9 the strip's moments show blue doing them.
- Tools: proto/twohands/tools/jump_rec.mjs + jump_ana.py (real bouts, every picture's box, jumps at run boundaries),
  edge_census.py, card_crop.py. CRITIC_PACK: critics also score speed and the first five minutes.

## Findings
- METHOD (NEXT_SESSION_PROMPT top): two men baked per picture + a sliding picture = every clip off by a few px is a jump;
  fighting games keep each fighter's spot in code. LAYERS_SCOPE_S569 (one man per picture) waits for his go; RECOIL1 and
  PUSH1 stopped. He said S569 "we can buy the animations and cascaduer now if needed".
- Mixed Martial Cards: distance is three card words, not a place (MMC_DISTANCE_S569); played by Claude on the hidden
  desktop (tutorial + 3 bouts), rated 7/10 (MMC_PLAYTEST_S569): take the exchange that gets dearer, one card + a mode,
  style decks with the plan written on them, the rest as a plan pick, status badges, call feint as take-it.
- MMCTOY1 (our boxer on their distance rules, mmc.html): less balanced (5 and 4 of 9 bars v 8 and 8); stopped for memory.
- KICKFIX4 from Arena: F1 and F3 5 of 9 (low kick 77-87%); Arena hit its daily limit before F4.

## Running at the handover (PC console workers)
KICKFIX5 (Fable, c10: F4 -> F5-F7 -> kick.html), COUNTERS2 (Opus, c7), RULES569 (Fable, c11: R5 the exchange that gets
dearer first, then guard one action, power mode, bar links incl. health caps stamina, combined moves).

## Briefs written
TASK_KICKFIX5, TASK_COUNTERS2, TASK_LONG3 (Arena), TASK_RECOIL1 (stopped), TASK_PUSH1 (stopped), TASK_MMCTOY1,
TASK_MMCPLAY1 (agents play MMC), TASK_RULES569 (5 ideas), TASK_BUILD1 (his Breachway body-as-ship idea), LAYERS_SCOPE_S569.

## Lessons
- Heredocs eat backslashes: a `\n` in JS written through a Python heredoc becomes a real line break (broke strip_ui once,
  the playtest script twice) - use the Edit tool or String.fromCharCode(10).
- My headless runs and a 2 GB game copy beside three table workers stopped two workers for memory: one heavy thing of
  mine at a time beside the workers.
- A worker's tab prompt line ("restart the chain", "keep it running") is Claude Code's suggestion, never his words.
- A page's own global function name can be clobbered by a window.* hook (cardTip): name hooks uniquely.

# S558 digest (2026-11-25, Fable)

Owner's order from S557, done: "have it playtested by all agents and also you" (brief `ops/research/TASK_ALLPLAY1.md`).

## What now works
- Five playtest reports of Ring Switches, each with scores, a TO REACH 10/10 list and a drawn screen:
  `ops/research/allplay1/<seat>/` - Claude 8, 8, 6, 6; Ziva 7, 8, 7, 7; Antigravity 7, 7, 6, 6; Dola 8, 7, 7, 8;
  Arena 7, 7, 7, 7 (fun, depth, clarity, variety). Mean 7.4, 7.4, 6.6, 6.8. Result page: `docs/RINGSWITCH_S558.md`.
- A seat with no shell can play: `ops/Tools/play_by_message.mjs` (Grok bots, Antigravity, Dola; `via=test`).
- The page: a round won by 5 points or more is 10-8; a man at 0 health throws nothing more that beat; the words say the
  rules the players lost to. 8 of 9 bars on both sets, `rules_test.mjs` 36, `page_play_test.mjs` 4, table rebuilt.
- `proto/twohands/tools/probe_clinch.mjs`: a rote feint-punch-clinch script, 60 bouts a man.

## Evidence
- Three claims of each report checked against its bout logs (Ziva 3 of 3; Antigravity 2 of 3; Arena's results exact,
  one small miss; Dola's results right, her clinch count wrong). Counts across 366 beats: 8 back offs, 37 clinches.
- Clinch probe on the page: the loop wins 43 / 53 / 43%, the same script without the clinch 3%.
- Low cover: played on the page in the browser (network log: the blocked body jab and body cross frames, 200);
  `fight_pictures_test` failures=0, `fight_pictures_gate_test` 58 + 58 pictures, failures=0.
- John's SQ336 source [S9] opened and matches (83.3% v 68.5%, boxing 0.52, p = 0.14); [S2] and [S18] would not open.

## Not done
- His three orders from the end of the session: the switches on the fighters' bodies (a toy), the guard picture
  ("why he protects his ears ?"), Rune Coliseum's step mechanic (a console worker was running: RUNESTEP1).
- The clinch fix (measured; the first version fails a bar). Kalli, John, Maria (out of quota), Cline (daily limit).
- A mistake: part of S557's measurement chain was killed as if it were dead; gave_30 was not replayed.

## Next
`NEXT_SESSION_PROMPT.md`.

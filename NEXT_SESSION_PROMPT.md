# S558 handover (written 2026-11-25, S557 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `docs/RINGSWITCH_S557.md` (NOT GREEN first).

## METHOD lines - quote all of them in your first message
- ## METHOD - RING SWITCHES IS THE MAIN LINE, AND THE ORDER VERSION IS THE PAGE (owner S553, S555).
  `proto/twohands/order.html` is the hand-edited source; `switch.html` is the old version: do not build on it.
- ## METHOD - THE SLICE IS BALANCED ON THE INSTRUMENT, NEVER BY HAND (owner S555). A change is first a tweak file
  (`tweak=<file.json>`, examples in ops/research/s555_balance, s556_balance, s557_balance; `tweak_check.mjs <file>`).
  AFTER ANY RULE OR NUMBER CHANGE ON THE PAGE: `node proto/twohands/tools/balance.mjs table` (5 to 6 minutes), then
  `balance.mjs play who=mix opp=mirror n=84` (the nine bars; `seed=2` for a second set), then `rules_test.mjs`,
  `page_parse.mjs order.html` AND `node proto/twohands/tools/page_play_test.mjs` (NEW S557: it plays the page itself
  to the last bell; run it after EVERY page edit, rule or not).
- ## METHOD - THE FIGHT MUST BE SEEN, SIDE VIEW, BOTH MEN CHEST TO THE CAMERA (owner S553). Every render takes `south=blue`.
- ## METHOD - THE SEATS' IDEAS ARE USED AND REPORTED (owner S554).
- HOW HE WORKS ON THIS GAME: he plays the page in Chrome while the session runs and writes what is wrong within minutes.
  The page needs its server in a terminal tab (`python proto/cardgame/serve.py 8797 twohands`; curl first).
- DO NOT EDIT order.html (or balance.mjs) WHILE A balance.mjs RUN IS GOING. A script with an apostrophe or a backslash
  goes in a FILE (the Write tool): a heredoc turns `\\n` into a real line break (S557: it broke a string on the page).
  Every Godot start goes through `python ops/Tools/godot_slot.py run --who <id> -- ...`. HIS GAME FIRST
  (`Get-Process ArcheAgeChronicles`). AGENTS ONLY IN THE CONSOLE.
- FIGHT ANIMATION: v2 only, no new correction layer in scripts/fight3d; an authored take baked by a tool is the route.

## FIRST: HIS ORDER, NOT DONE - "have it playtested by all agents and also you" (owner S557, mid-session)
The brief is written and committed: `ops/research/TASK_ALLPLAY1.md` (six bouts a shell seat, three a chat seat, judged
on FUN, scores, TO REACH 10/10, a drawn 10/10). NO SEAT WAS STARTED and Claude did not play: S557 hit its size limit.
Seat by seat (the ticked seats: kalli, john, maria, dola, cline, arena, antigravity, ziva, claude):
- **Claude**: play at least three bouts yourself with `play_cli.mjs` (one a man, a WHY before each beat), then on the
  page in the browser; write `E:/FightCamp/tmp/allplay1/claude/ALLPLAY1_CLAUDE.md`.
- **Ziva**: start its editor (`ops/Tools/godot_hidden.ps1 -e --path E:/FightCamp/wt/ZIVA_LEAN`; port 7012 was DOWN in
  S557), the built-in browser pane on http://127.0.0.1:7012/, New chat, point at the brief by absolute path.
- **Arena**: `git push`, `python ops/Tools/lite_mirror.py --lean push`, Chrome arena.ai/agent (repo FightCamp-Lean-lite),
  a prompt naming the brief; it runs node in its own clone. Check proto/twohands is in the mirror first.
- **Cline**: `ops\Tools\agent_window.ps1 -Title ALLPLAY1_CLINE -Command ops\Tools\cline_task.cmd ...` (it has a shell).
- **Kalli, John, Maria (chat, no shell)**: they play BY MESSAGE. The driver is NOT built: for each beat send the state
  (the tool's own lines) with `node ops/Tools/grokbot_direct.mjs send <bot> <file>`, read the reply with `tail`, parse
  the one line `lead=.. rear=.. feet=.. order=..`, run `play_cli.mjs beat`, send the result. Kalli and John each have a
  brief in flight in the same thread (SQ335, SQ336): collect those first or the answers interleave. Maria is free.
- **Antigravity**: its headless mode has file tools only (no shell): the same by-message driver, one `agy -p` run a
  beat, its folder under E:/FightCamp/wt (its allow rule). **Dola**: her app runs without its debug port; a relaunch
  may show her window on his screen - tell him she could not be reached, or ask.
- Freeze the game for the playtest: no rule change on order.html while seats play (they read the page live).
- Collect each report the session it lands, check three claims against the logs, tell him every seat's scores and what
  each said (METHOD: the seats' ideas are used and reported).

## SECOND: read what is still measuring (started in S557; only block_g1 read: 8 of 9 bars, the jab lands 81% - no gain)
UPDATE (after the handover, the runs finished and were read once, 84 bouts each, one set): NOTHING BEATS THE PAGE.
- A block costs the blocker guard: block_g1, block_g2, block_g2w all 8 of 9 bars (the page: 8 of 9), the jab lands
  79 to 81% (the page 73%), stoppages fall to 12-21%. The free chase: 8 of 9, the jab 78%. No gain: none goes on the page.
- The ground rule in the look-ahead: gave_15 8 of 9, gave_50 6 of 9 (the mirror unfair, 65%), ropes50 8 of 9;
  `gave_30.txt` came out EMPTY (rerun it if wanted: `N=84 sh proto/twohands/tools/balance_batch.sh <dir>
  ops/research/s557_balance/gave_30.json`).
- THE PROBE SAYS WHERE THE FREE ROUNDS COME FROM: the JABBER backs off in 40% of beats and EVERY level round against him
  goes to a player who never backs off (13 of 13); the solver's price on a back off moves that only to 31-37%. It is his
  STYLE (`like: [..., 'back']`, lean 0.4), not the look-ahead. The Slugger and the Body Snatcher back off in 6 to 12%.
  Next try, as a tweak: the Jabber's lean on `back` lower, or no lean on it in a level round's last two beats; measure
  with `probe_ground.mjs` and `balance.mjs play who=sensible opp=0`.
Tell him all of this in the first message (METHOD: the seats' ideas are used and reported).
- `E:/FightCamp/tmp/s557_ziva/`: Ziva's rule ideas, 84 bouts each: `block_g1.txt`, `block_g2.txt`, `block_g2w.txt` (a
  block costs the blocker guard: 1 / 2 by size, the punch's own health, and that with the look-ahead valuing guard
  more) and `chase.txt` (he backed off last beat: your step in is free). `done.log` says what finished.
  The guard idea is a THIRD answer to his open call on the guard bar (Kalli: cut it, John: rebuild it on stamina).
- `E:/FightCamp/tmp/s557_ground/`: the look-ahead learns the ground rule: `gave_15 / 30 / 50.txt` (a back off costs
  the man that much health in the solver's eyes), `ropes50.txt`, and `probe_page.txt` against `probe_<name>.txt`
  (`probe_ground.mjs`: a player who never backs off - how many level rounds he is handed).
- Take a change to the page only at 8 bars or more AND a better probe number; then table, play (two sets), the three tests.

## THIRD: the low-cover pictures - ON THE PAGE since the end of S557 (gate 6 of 6, anim_check 124 of 124); what is left:
`E:/FightCamp/tmp/s557_lowcover/final/` (six runs, both corners: body jab / hook / cross, blocked; check
`anim_web.py`, `anim_stills.py` and `anim_check.mjs` were run). LEFT: play a blocked body punch on the page in the
browser, send him a before/after strip (strips: `ops/previews/s557_lowcover/`; the before pictures:
`E:/FightCamp/tmp/s557_lowcover/before/`), put it on the map, and run the Godot tests the picture tools touch
(fight_pictures_test) through godot_slot. A MISSED body punch is still at chest height: the next animation item,
with the overhand's own take (it plays the rear hook's pictures; no overhand take exists in the clip table).

## What S557 did (docs/RINGSWITCH_S557.md)
- A DEFECT ON THE PAGE HE PLAYS: since S556 no round reached the cards (a comment swallowed the line) and a bout on
  points ended "A DRAW 0-0". Fixed; `page_play_test.mjs` now plays the page to the last bell.
- ZIVAFIX1: his last three beats on his card; points and the stamina bar said in words; "one more ends it"; a switch
  the stamina cannot pay is switched off in words. No rule changed.
- Kalli's cover table (SQ334): 4, 4 and 6 of 9 bars. NOT BUILT. Seven southpaw versions have failed.
- Repeated beats: rare (0 to 10% of bouts). Not a rule problem.
- LOWCOVER1: a blocked body punch meets the lead hand held low (0.09 to 0.19 m over the body, was 0.29 to 0.54).
- Seats: Kalli SQ335 (how the player READS the other man) and John SQ336 (what real boxers read before a punch) sent.

## Then
- The page is taller than 1080 (about 1416 px): move the long how-to text to hovers, tighten the board.
- The body hook is the least used punch (4%): watch it. The clinch when HE ties up. Both rear hooks that miss are wide.
- The guard bar: his call (cut, rebuild on stamina, or the block-costs-guard answer once measured).
- THE CLIP TABLE IS NOT WHAT ONE TOOL WRITES: add or refresh ONE row by hand (docs/BODYJAB1_RESULT.md).

## Not touched this session
MATCHBOTS2 hooks on disk, uncommitted (tests/matchmaking_bots_test.gd modified: not mine). The 05:00 run of 2026-11-25
was already checked in S556 (no new red). Dola's two queued briefs (SQ324, SQ327) cannot leave the queue. No export:
the game's scripts did not change.

## Waiting on the owner
His play on the page (the body jab, and now his last three beats and the fixed cards).
The guard bar: cut or rebuild. The rest of his Q-336 note ("thecoaches should have").

## Model for S558
Fable, medium effort, Fast off: the playtest is mostly waiting on seats and reading their reports against the logs.

# S495 handover (written 2026-11-15 at the end of S494)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S495`.

## FIRST - ANIMATION ITEM: BODYLOOK1 runs in its own Fable session
Session "BODYLOOK1 on Fable: body seams, shoulders, walk" (local_43234449-27fa-4767-ae29-8f567b15015c, branch
claude/confident-chaplygin-6b0d8f, PR 320 open). Collect from ITS PR; open every before/after still yourself (game camera).

## WAITING ON HIM
- Q-255 Training K v5 (his Q-252 mark 1 done: no opponent / win % on the Training screen): docs/mockups/s494/training_k/
  training_k_v5.png. On "Build it": build Training K (WeekCards.gd is the current week board, 552 lines: the build replaces or
  splits it). The win chance moves to the fighter's own page.
- Fight analysis page: he said yes (design it, use it for Film to unlock tells, a live action log window) - in its own
  session (below).

## SEAT ANSWERS TO COLLECT
- LADDER1 v4 scored: Dola 8/8/7, John 6/6/7 -> v5 to Kalli (SQ195). HE LIKED JOHN'S 10/10 LADDER SCREEN ("this is not bad
  that john made"): docs/mockups/s494/ladder/ladder_v4_john_10of10.png - v5 keeps that screen; two fresh critics at 7+ next.
  (Old line, done:) SQ188 Dola + SQ189 John: LADDER1 v4 critics. Both depth 7+ and general 7+ -> his board with the map (`ask --attach`); else
  v5 to Kalli with both critiques inlined (the seats cannot read the repo: inline everything, see DESIGN_COACHSPEC1_R5_REVISE_KALLI.md).
- SQ190 Kalli: COACHSPEC1 round 5 (John 7/6/6's four points) -> two fresh critics.

## USE THESE SEATS FIRST - THEIR TOKENS RUN OUT SOON (operator, end of S494, 2026-11-15)
"bots will soon be out of tokens , dola,arena,goose,kimi,qwen/ludo" then "use them". In the FIRST HOUR, before own work, give
each one a real task and keep it busy until its tokens end (re-task the moment one lands):
- Dola: every open critic round (FIGHTFILM1 v2 SQ193 is queued; COACHSPEC1 r5 critic once Kalli's SQ190 answer is read;
  LADDER1 v5 critic once Kalli's SQ195 lands) - one seat_queue brief each, everything inlined.
- Arena: a pure rule module + blind contract test each (e.g. the FIGHTFILM1 strike-log reader / pattern counter for the
  analysis page, the ladder's yes-chance and win-gives formulas from LADDER1 v4) - lite mirror, its PR, read the CI log.
- Goose: a long cloud job (a `goose` issue): the palette sweep of one HUD file with the palette guard as the gate, or the
  page-width check (any visible Control past x 1920 at text=3) for tools/layout_snapshot.gd.
- Kimi: design/research reviews (whatever seat_queue / its launcher supports - check reference_how_to_reach_each_agent).
- Qwen: CLASH10 is running; next small pure modules + tests (seat_dispatch).
- Ludo: batch every already-approved asset or still review now (his Ludo month ends ~12-11).
- Grok bots too (operator: "the gorkbots almost over, keep using them until they run out and use the other agents"): Kalli
  (design revisions SQ190/SQ195 follow-ups), John and Maria (critics, research) - keep them busy until they stop.
A seat that errors on quota is finished: do not relaunch it there. Move its task to a seat that still runs: Cline,
Antigravity, Ziva (3D only), or Claude's own sessions/subagents (critics: a fresh Claude subagent with the critic pack).

## SIDE SESSIONS STARTED IN S494 (they report to S494; check them first)
- "Design the fight analysis page + film tells + live log" (local_07f835cc-0a27-4edc-aaf6-01471d0439be): FIGHTFILM1 v2 map +
  mockup pushed (3fe980ab); v1 Dola 8/8/8, John 5; v2 queued to Dola SQ193 + John SQ194. His board only at 7+ from both.
- "Prototype an automatic boxing video analyzer" (local_2e2e5ceb-0b16-48b8-bdaa-af215813d368): pose tracking of 29 labelled
  Olympic bouts, numbers expected ~00:40 on 11-16; report ops/research/FIGHT_VIDEO_ANALYZER_S495.md + ops/Tools/fight_video/.
  Read its measured accuracy before telling him anything works.

## AGENTS
- Qwen CLASH10 (glove clipping, worktree E:/FightCamp/wt/LEAN_CLASH10, ETA 22:32 on 11-15): open every still before any merge.

## ONELOOK1 - THE PALETTE SWEEP (his "do it and i will judge")
palette_guard_test is in the suite: the raw-colour count may only fall (649 now). After each file: run it with `-- write`.
Worst first: HudRegroup 27 + HudBars 26 (fight HUD: stills via tools/fight3d_play.gd on the hidden desktop), RosterCards 22,
ReadPanel 18, MatMap 16, MatchupCards 15, WhiteboardKit 13 (~10 screens switch ink by WoodKit.on_dark - change + stills
together). WeekCards 33 waits for Training K. Before/after stills to him + review_add.py.
UI.gd 41 and WoodKit.gd 34 are the kits themselves - leave for last.

## KNOWN GAP
- His text size is Largest. TextScale.overflow checks words against boxes, not a page against 1920: the Overview ran to
  2111 px unseen. Add a page-width check (any visible Control ending past x 1920) to the layout_snapshot audit at text=3.

## USAGE RULES (kept)
- get_usage first; wrap up from ~310k, hand over by 420k. Godot through `python ops/Tools/godot_slot.py run --who s495 --`.
  Repo-root .tmp_s495_*.sh runners (Write tool), deleted after. Windowed renders: tools/hidden_desktop.py with --log=<file>.
- New tests go into tools/run_tests.sh's list.

## Known reds (NIGHTLY1): block_meet B_A pro_left_hook control row.

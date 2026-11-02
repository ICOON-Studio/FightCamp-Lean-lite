# S159 DIGEST - 2026-10-04 - the game on paper, the gap, and the corner

## What the operator ruled (verbatim)
- "act like an experienced game director and lead game designer ... are we on the right path ?" -> no, the order of
  work is wrong (no current build, gates driving instead of feel, scope leak).
- "think how the game should be in paper first ignoring what we have done so far" -> DESIGN_ON_PAPER_S159.md.
- "go with your picks, now compare it with what we built" -> **D35** (DECISION_LEDGER): the paper design is the design
  of record; head coach who owns the gym; corner = plan + cut man + words + the towel; camp vs one opponent; demo =
  first hour ending at the pro debut; every round watchable. Every task is judged by "does the first hour get better?".
- Nightly: "why you keep repeating this every session" -> CLAUDE.md s3 softened: report only a NEW red; each check
  written into roadmap NIGHTLY1.
- Ops board: nav bar on every page, tasks tagged with STAGE + PART (plan.areas / plan.parts), running/next/finished
  colours, per-stage part counts.

## What now works (evidence)
| Item | Commit | Evidence |
|---|---|---|
| Design on paper + gap | 238f3331, 74208852 | DESIGN_ON_PAPER_S159.md, DESIGN_GAP_S159.md (two code audits, key claims hand-checked) |
| Film Room charts real (were fixed arrays for every man) | d6874a20 | film_room_test: bars = his plan bar for bar; mutant (constant series) red; still q232/film_s159_board.png |
| CORNER2 engine: calls reach pace/targets/volume, towel, coach card (switch `corner_wired`) | c55d3946 | corner_wired_test: arms identical to the first bell; Push forward wired 38 vs unwired 28 throws, body share 0.45 vs 0.32, fire 39 vs calm 33; OFF words change nothing; 3 mutants red; 22 neighbours green |
| CORNER2 screen: reads, 8 calls, words, two-press towel, clock holds | 185eb01b | corner_card_wired_test 16/16; stills docs/previews/corner2/card_wired.png, card_towel_armed.png (opened; selection tint + row width fixed after the first still) |
| fight_strike_whole re-pin | 185eb01b | bisect: FightRealtime d62f1e7f^ = old hash, R16 and later = new; CORNER2 byte-identical |
| C223 production gate no longer idles to the cap | 185eb01b | the S158 + S159 "2 h cap" runs were a SCRIPT ERROR (`matched.entry_s` on {} for qm_rear_hook_b); now a finding |
| Merged Arena | d62f1e7f (#39 R16), 1b2b57c4 (#42 SCHED1-BADGE) | local tests green |
| .exe rebuilt | - | Builds/FightCamp_Godot, pck 542 MB, 03:35 (before CORNER2 - rebuild owed) |

## Not done / held (read before acting)
- **fight_strike_whole_test went red (rc=1) once AFTER the re-pin**, in the run cut short by the RED watchdog. Its log
  was not kept, so the failing check is unknown. The 05:00 nightly (2026-10-04) runs it on the same tree: read
  AgentComms/nightly/latest.txt first. If it is red, run it alone and read the FAIL lines before touching anything.
- **Neighbour runs for the CORNER2 screen** (`--only corner`, `--only fight_world_live`, `--only fight_strike_whole`)
  were STOPPED by a RED watchdog (84 C sustained, the 05:00 nightly running beside them). Run them first, GREEN only.
- **Walk the corner in the .exe** (as_game): rebuild, play to the first break, check the clock holds and the towel ends
  the bout. Send the operator the two corner stills + a short clip for his OK.
- **C223 A/B (Q213G-AB)**: never produced a row (gate crash, now fixed). Rerun `Tools/c223_ab_run.cmd` detached when
  GREEN and NOT beside the nightly.
- **PR #43 KM3** (thorax capsule cut at the shoulder line): held - changes the collision geometry every certified move
  was measured on; needs a C223 production run on its branch first. Its PR also deletes 118 lines of Q220_DIGEST.md -
  apply the FighterCapsules.gd diff only.
- **PR #41 NEAREST**: fixes the technique-fidelity nightly red, but with it applied fight_strike_whole adds 2 FAILs
  ("live strike never cut before recover"). Send back in a NEW Arena chat with that output.
- **PR #40 Cursor Q213I**: lunge cut to 0 m, but 3/8 C223 rows fail G147 HEAD (welter_b both, heavy_d body hook) and it
  rewrites run5_candidates.json (-5664). Parked: punch polish sits behind the corner (D35).
- Arena in flight: NIGHTLY1B (01a10320), NIGHTLY1C (01a1044c), RESULT2 (01a104c1-0317), DEMOSWITCH (01a104c1-bf59).
  The last two share the id prefix `01a104c1` - check they did not push to the same branch.

## Next (decision)
Finish CORNER2 (neighbour runs, exe walk, operator OK), then READROUND (stamina bars + punches landed on the scorebug,
one-line commentary from the engine beats, knockdown count, skip to the bell) - DESIGN_GAP_S159.md item 3. Collect
RESULT2 / DEMOSWITCH / NIGHTLY1B / NIGHTLY1C as they land.

## S159b (same day, second part) - what changed after the ship above
- **Neighbour runs DONE, GREEN**: `--only corner` 12/12, `--only fight_world_live` 0 fails. corner_wired_test is green at HEAD (the 10-04 nightly red was the pre-fix tree).
- **fight_strike_whole RESOLVED (14741939)**: bisected in an E: worktree - green at 538c5bd6 (3678 checks), red at R16 d62f1e7f.
  R16 only moves the walk; seed 92012 then reaches `boxing_one_two` (t=25.0, jab clip then cross clip) and `boxing_catch_counter`,
  whose parts `_advance_sequence` hands off at the plan's own cut. The test read that as "cut before recover". It now exempts only the
  ACTIVE sequence advancing to its next part; every other take change with time left still fails. Runner: SUITE total=1 fails=0.
  **PR #41's "adds 2 FAILs" was this same artefact** - re-test #41 against the fixed test before sending it back.
- **PR #44 RESULT2 + DEMOSWITCH MERGED (25507186)**: diff applied, 12 neighbour groups green, result still opened (docs/previews/result2, MMA bout - boxing bout not yet seen).
- **Antigravity seat (2c528a2a)**: IDE 2.5.5 + desktop 2.19.1 + CLI agy 1.2.16 installed (signed Google LLC), operator signed in. Trial: agy wrote
  ratio_cell_test (7/7) in 125 s. NOT a cloud seat - runs commands on the PC. Launch: one-line -p prompt pointing at a task file + --add-dir,
  `--mode accept-edits --sandbox`, never --dangerously-skip-permissions (the auto-mode classifier refused it). On roster, live_runs (AGY1), ops board pages.
- **no_popups guard stopped** (PID 5376) at the operator's request so Photos stays open; it restarts with the next agent_window.ps1 launch.
- Kilo Code and herdr looked at, not installed (Kilo = Cline-style seat if Antigravity quota fails; herdr = terminal multiplexer, no cloud compute).
- Still owed: PR #43 (C223 production on its branch, then FighterCapsules.gd only), PR #41 (retest, then merge or send back), exe rebuild + corner walk + stills to the operator, READROUND, C223 A/B detached.

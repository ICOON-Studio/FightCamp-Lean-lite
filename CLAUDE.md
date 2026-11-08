# FightCamp (lean restart) - working rules

A boxing gym management game in Godot 4.7.2 for Windows. Restarted small on 2026-10-28 after the first project was
cancelled by the operator: months of work, no version he enjoyed playing. Its code is archived on GitHub
(ICOON-Studio/FightCamp, read-only reference).

ONE REPO (S366, operator: "why have 2 repos for 1 project?", "fix this make the workflow properly"): this repo holds the game
(the root) AND the workflow in `ops/` - `ops/Tools` (ops board, watchdog, agent tools), `ops/AgentComms` (roadmap, questions,
runs), `ops/research` (the research memory). `ops/.gdignore` keeps Godot out of it. The workflow gates (PC, screens, visual,
git, agents, operator, board) are `ops/WORKFLOW.md`, imported here; where it and this page disagree, THIS page wins:
@ops/WORKFLOW.md

## Read first
- `docs/RESTART_PLAN.md` - the decision, the weekly builds, week 1 in detail.
- `docs/menu_prototype.html` - the clickable prototype the operator approved ("Yes, restart small"). Its structure, words, look
  and behaviour are the spec. Also published: https://claude.ai/artifact/XBvFSh3qyyQrc8HaW2HR1X
- Miro board with the full structure: https://miro.com/app/board/uXjVEV03QWA=/

## The operator
The CEO and playtester (40 years of games, no development background). Claude is the developer: decide code questions yourself
and say what you decided. Ask him only about taste, scope or money. Be concise, plain words, no jargon.

## How we work
1. One playable .exe a week. His playing is the gate; a green test closes nothing on its own.
2. The old workflow is back (operator 2026-10-28: "bring back workflow before i told you the project is cancelled"). The ops
   board (http://127.0.0.1:8787, `ops/Tools/opsboard`) shows the lean roadmap from
   `ops/AgentComms/roadmap.json` `plan` (objects `{id, who, title, after}`, plain words). Agents, cloud jobs and
   scheduled tasks run only once he has switched them back on (see "Wrap-up" and roadmap `now`).
3. 2D menus and the simulation first. The 3D fight and 3D gym come later as views on the same data.
4. Scope: boxing only, one gym, a small roster, amateur to first pro fight. New systems enter only when the last build feels right.
5. Small files: no script over 500 lines; one `Career` data resource, a `Clock`, pure rule modules, one scene per screen.
6. Tests: pure rule modules have unit tests; one golden-path test plays the build's path. FULL TESTS ONCE A DAY (operator S402: "full test should go once a day around 5 am and then you review and act on it"): the scheduled task runs them at 05:00, results in `ops/AgentComms/nightly/latest.txt`, a Claude task reviews them after. In a session, and before an export, run only the tests the change touches.
7. Rule modules may be copied from the archived old repo's `Godot/scripts` (GitHub ICOON-Studio/FightCamp; TrainingPreview, rules/FighterGoal, Membership,
   state/GameMoney, FightCamp, AmateurBooking, rules/MoveMastery, FightPlans, Retention) with their tests. Re-read each and strip
   what is not needed. Never read GameState.gd or FightRealtime.gd whole (huge).

## Agent roles (S299, from each seat's record in the old project's run archive)
Claude decides design and integrates; the operator approves (D49: Ludo makes assets only). Each seat gets ONE kind of work:
- Qwen - small pure rule modules + unit tests (most reliable: 0 failed of 52). Arena - bigger pure modules + tests in the
  cloud, e.g. the balancing harness (public mirror only; check it did not delete tests). Cursor - one 2D screen per task
  from the prototype (it cannot see images: Claude checks the stills). Grok Dev - tests: golden path, save/load, blind
  contract tests. Ziva - 3D fight motion + a playtest of each weekly build inside the editor.
- Chat bots: Kalli - content and numbers tables; John - real-world research behind numbers; Maria - art review of each
  build's stills. Dola parked. Codex: none (operator S228). Ludo: assets only.
- At most 3 PC agents at once (watchdog), cloud seats unlimited. Every brief names its owned files, the one test command,
  and stays under the 500-line rule.

## PC rules (his machine)
- Nothing opens on his monitors: run Godot headless (`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless`),
  never the `_console.exe` (it opens a terminal window). Open images with the file tool, never with an app.
- CPU must stay under 84 C: tests run 4 at a time on a GREEN PC (`sh tools/run_tests.sh`, JOBS=4; JOBS=2 beside agents; S336
  operator "the heat fixed"); a headless test or two may run beside a film or windowed render while the watchdog reads
  GREEN (operator S355: "you can change the rule"); two windowed renders never at once.
- No audio in tests (`--audio-driver Dummy`).
- DISK (S366: E: is a 480 GB DRAM-less SATA SSD; at 96% full one git repack stalled every write ~1 s and froze the PC): E:
  stays under 85% full - the watchdog reads E: free space and write latency (AMBER < 15% free, RED < 5% free or writes
  > 250 ms) and names any git packer running. Git auto-gc stays ON here (this repo is small, so loose objects never pile
  up); the old repo's had been blocked since 9/10 by a stale lock, 9.5 GB piled up, and one fetch repacked it all at once.
  Never delete a `.git/*.lock` / `gc.pid` / `gc.log` by hand mid-session, and never start a manual `git gc` / `git repack`
  in a session.
- To see real screens, render on the never-shown desktop: `python tools/hidden_desktop.py run --timeout=180 <godot.exe>
  --path . --windowed --resolution 1920x1080 --script res://tools/layout_snapshot.gd -- <out_dir>` writes `*_real.png`.
  Off-screen window positions are NOT hidden (they land on his second monitor).

## Decided numbers (keep)
Training pace 1.0 per focused week, headroom clamp((potential - stat) / 25, 0.10, 1.25); goals clearable ~70% (e.g. technique
+2.5 in 21 days); first coach sessional $450/week; quick start opens with 30 members; evening classes
+$350/week with a coach; amateur fighter on a $250 stipend; amateur bout pays the club a $450 ticket cut.
Update 27 (S324, GymBills, real England Boxing club numbers GBP x 1.25): dues $35/member/MONTH (kept by the week); rent
$1,800/month (replaced the $500 upkeep); England Boxing fees $315 club + $18 a boxer + $35 a coach a year; start cash = 3
months of costs ($14,600); 4 weeks in a row below $0 = the gym closes; a loss costs 3 members + 2 reputation (stoppage 5 + 4).
Week 4 (Kalli K-PROLINE1): pro offer at 7 wins + top-3 ranking or 9 wins; debut purse $1,500 (+$500 a win, top $3,000),
gym share 35%, stipend stops, 4-round debut; a new move is a weapon (mastery 30) in 2-3 weeks of pad time.
Week 5 (Kalli K-FIGHT3D1): the 3D fight never decides - it shows the settled round. 40 s a watched round (full), highlights
default; landed punches close 4-3 / clear 5-2 / dominant 6-1 (power gap < 1.5 / >= 4.0); the winner lands last and presses;
round 2+ opens on the corner call; one broadcast camera + a 1.5 s close-up on the big shot. 3D runs only with a picture
(headless tests stay in words). Stills: `tools/fight3d_play.gd` (real flow) / `tools/fight3d_still.gd` (poses) on the hidden desktop.

## Session start
Open the session in `E:\FightCamp\Lean`. `git pull && python ops/Tools/agent_comms.py start`, then read `NEXT_SESSION_PROMPT.md`.
ANIMATION PROGRESSES EVERY SESSION (operator S401: "keep the animation work progressing on every session"): name the animation item and its seat in the first message; if none is running, launch the next one first.
Questions for the operator go on the board (`python ops/Tools/agent_comms.py ask "<text>" --options "a|b"`).

## Wrap-up (every session, before the handover)
1. The tests the session's changes touch are green (never the full suite: it runs at 05:00), `sh tools/export.sh`, WHAT_TO_TRY.txt current.
2. Ops board: in `ops/AgentComms/roadmap.json` update `now`, `next`, `plan` (working_now / next / done_recently /
   titles) and append the session to `sessions`; run `python ops/Tools/render_roadmap.py`; commit them with the session's work.
3. Rewrite `NEXT_SESSION_PROMPT.md` here for the next session.
3b. The Miro production map (operator S323: "so i can always know what we work on and next"): move the cards between
   DONE / NOW / NEXT in P0 and the part frames P1-P9 (https://miro.com/app/board/uXjVEV03QWA=/, right of frame 11) and keep
   their scores honest; the ops board links them from roadmap.json `plan.maps`.
   S385 operator ("a map similar to this ... updated on every session end or start"): the P0 "Where we are" frame
   (DONE earlier / this session, NOW, NEXT) is drawn from `ops/Tools/where_we_are.py`. At START: `roll S<n>` + `now`;
   at END: `done` / `drop` / `next`; both times redraw it with `where_we_are.py svg` and one canvas_update_from_svg.
4. Memorize the session (memory) and say so in the handover.
5. Ask the operator whether to hand over or keep going; the handover is ONE copy/paste block.

## Git
Commit to `main` with clear messages; stage explicit paths. End commit messages with the Co-Authored-By line the harness gives.
Builds go to `Builds/` (ignored) with a WHAT_TO_TRY.txt. Session numbers continue the old project's (S294 = week 1).

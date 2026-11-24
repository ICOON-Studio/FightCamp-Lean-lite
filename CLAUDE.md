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
- THE MAP (operator S499: "miro subscription has been stop ... can you create something like miro for our project"): our own
  page on the ops board, http://127.0.0.1:8787/map (`ops/Tools/opsboard/map_board.py`, data in `ops/AgentComms/map/`): where we
  are, who works on what, every real screen, the approved menus, and his sticky notes. Miro is no longer used (the old board
  https://miro.com/app/board/uXjVEV03QWA=/ is a view-only archive); no session calls a Miro tool.

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
   CHANGED (operator S428: "we sshould force the player to have 4 fighters,different weight classes and bjj", "make it so amateur fights do not require fight camp and can happen within a week", "every fight should display the rank earned", then "ok p[roceed with this plan and adjust miro opsboard and everything else"): the start is FOUR fighters in four weight classes (three boxers and one BJJ fighter), amateur bouts need no camp (a light fight week, 1 to 2 weeks out; camps stay for pro, title and nationals), every fight shows the rank earned (a regional ladder first), and a small HOSTED CLUB SHOW comes after those three. The full promotion (pro cards, belts, TV) waits until after the small living world. Details, risks and task ids: `ops/research/SCOPE_FOUR_FIGHTERS_S428.md`. Where this line and item 4's first sentence disagree, this change wins.
   CLARIFIED (operator S487, Q-246: "The normal game will start with 0 fighters . The reason told you to make 4 fighter start was to see the menus populated how they look and for the tests"): the normal game starts with no boxer signed (a walk-in at reception, as today). The four fighters (three boxers in different classes + one BJJ) are a TEST CLUB, for seeing every menu populated and for the tests - never the normal start, so their money needs no balancing.
   WIDENED (operator S425, asked "After the week is built, widen the scope to a small living world with a belt ladder?": "Yes, after the week"): once the week design is built and he has played it, the next system is a SMALL living world: one national ladder with a mandatory challenger and an eliminator, rivals who age and move, judges with taste. Not breadth (no four world bodies, no 17 divisions). Design may be prepared before; nothing of it is built before the week.
5. Small files: no script over 500 lines; one `Career` data resource, a `Clock`, pure rule modules, one scene per screen.
6. Tests: pure rule modules have unit tests; one golden-path test plays the build's path. FULL TESTS ONCE A DAY (operator S402: "full test should go once a day around 5 am and then you review and act on it"): the scheduled task runs them at 05:00, results in `ops/AgentComms/nightly/latest.txt`, a Claude task reviews them after. In a session, and before an export, run only the tests the change touches.
7. Rule modules may be copied from the archived old repo's `Godot/scripts` (GitHub ICOON-Studio/FightCamp; TrainingPreview, rules/FighterGoal, Membership,
   state/GameMoney, FightCamp, AmateurBooking, rules/MoveMastery, FightPlans, Retention) with their tests. Re-read each and strip
   what is not needed. Never read GameState.gd or FightRealtime.gd whole (huge).
8. FINDINGS DRIVE THE QUEUE (operator S510, after 14 animation rounds patched while the Undisputed studies said the method was
   wrong: "change this , get the full scope of fixing"). A study, reference-game read or critic round that says the METHOD is
   wrong (not just one defect) becomes, the same session: (a) a `## METHOD` line at the top of NEXT_SESSION_PROMPT.md and roadmap
   `now`, quoted by every later session in its first message, and (b) a scoped plan (`ops/research/<AREA>_SCOPE_S<n>.md`) put on
   the board as the next item. Until that plan is approved and built, no session adds a new correction layer in that area; it
   finishes the scope, the plan's phases or a measurement. Before patching any area, run `python ops/Tools/prior_research.py
   <area words>` and say which study's verdict the work follows. Fight animation now: FIGHTPLAYER2 (see the METHOD line); no new
   fix layer in scripts/fight3d until it is built.

## Agent roles (S299, from each seat's record in the old project's run archive)
Claude decides design and integrates; the operator approves (D49: Ludo makes assets only). Each seat gets ONE kind of work:
- Qwen - small pure rule modules + unit tests (most reliable: 0 failed of 52). Arena - bigger pure modules + tests in the
  cloud, e.g. the balancing harness (public mirror only; check it did not delete tests). CURSOR REPLACED (operator S446: "replace cursor with grokbots,arena,goose"): Grok Dev
  (gbot / issue label `grok`, own Linux box with Godot 4.7.2, pushes grok/* PRs) takes Cursor's work - one 2D screen per task from
  the prototype and 3D look fixes (Claude renders and checks the stills on the PC); Goose takes long cloud jobs (rope entry, pads
  view); Arena takes pure modules + tests. Cursor gets no new tasks; the Grok chat bots (Kalli, John, Maria) stay as below. Grok Dev - tests: golden path, save/load, blind
  contract tests. Ziva - 3D fight motion + a playtest of each weekly build inside the editor.
- Chat bots: Kalli - content and numbers tables; John - real-world research behind numbers; Maria - art review of each
  build's stills. Dola parked. Codex: none (operator S228). Ludo: assets only.
- CRITICS KNOW THE WHOLE GAME (operator S403: "i want every screen you design to have the right options so every critic needs to know the whole game design and mechanics to guide you"): every critic brief opens with `ops/research/CRITIC_PACK.md` and `ops/research/CRITIC_ACCESS.md` (the Miro board, real screens, mockups) and asks which options a screen is missing, which are useless and what each changes. The pack gives the game, never our proposal or an earlier score. Update it when a mechanic or screen lands.
- CRITICS SAY HOW TO REACH 10 (operator S405: "i want the critics everytime to state what to change to reach 10/10"): every critic, on every score of anything, ends with the concrete list of changes that would take it to 10/10. Most important first, specific enough to build. A score without that list is not finished. S411 operator ("have them draw what would be their 10/10 on each occasion"): every critic also draws its 10/10, a 1920x1080 HTML page rendered with tools/render_mockup.py, and the review links the picture.
- MECHANICS NEED 8 TO STAY (owner S534: "mechanics need an 8 critic's to stay in the game for depth and fun"): the bar is
  now 8+ on DEPTH and 8+ on PLAY (fun) from critics, replacing the 7+ below. Order (S534 DEPTH_AUDIT: five maps passed at 7+
  and failed when measured): probe the lever on a greybox FIRST, then two fresh critics (one code-checked), then build. A
  built mechanic that cannot reach 8 goes to him as "cut it or keep it" - never removed silently. ops/research/DEPTH_SCOPE_S534.md.
  FREE HAND (owner S534: "you can remove,add from scratch or interconnect current and current with needed mechanics"): to reach 8, Claude may remove a mechanic, add one from scratch, or interconnect existing ones
  (with each other or with a new one) - decided and done, then reported with the probe and critic evidence.
- FEEDBACK LOOPS BEFORE THE PROBE (owner S541 "Yes, add it", after COACHDEEP4's class nights followed members that followed
  class nights, uncapped): every design/probe brief has `## Feedback loops` - what the change feeds, whether that feeds back,
  the cap on each loop, a one-rep trial run before the full probe. `ops/Tools/claude_cm.ps1` refuses the launch without it.
- EVERY NEW MECHANIC: WIRED, SHOWN, 7+ (operator S425: "i expect all new mechanics to be wired and shown properly on the correct menus and be deep enough for a critics +7/10"): a design map reaches his board only once two fresh critics score its depth 7 or more (a lower score = another round, never the board); the map carries a table of every menu the mechanic appears on and what each is wired to; the build is done only when each of those menus shows it in the .exe and one golden-path test walks it end to end.
- A DECISION SCREEN IS A SCENE, AND A CLICK SHOWS WHAT CHANGED (owner S544, on the turning pro pop-up a worker built to the
  rule above: "this is still confusing and looks like spreadheet you need to use art you are an experienced AAA game
  designer"; then "i click turn pro now , i expect to see what changed , bring up the players profile show me what is new";
  then "why half the screen isout of bounds"). A decision screen is a picture of the moment with the choices as cards (a
  painting, a name, at most four plain facts, its own button; details on hover) - never rows of key/value as its main
  content. After the click the player lands where the change lives, sees before -> after with NEW marked and one pulsing
  next action. No card is cut by the bottom of a 1080 screen: `tools/jump_snapshot.gd` on the hidden desktop prints BOUNDS.
  A worker's stills are checked for all three before a merge. Pattern: `scripts/ui/ProScene.gd`, `WhatsNew.card`.
  NO POP-UP AND NO ICON TILES FOR "WHAT CHANGED" (owner S545, on the four-tile pop-up S544 put over the profile: "this
  looks like AI slop"; its button left it open over the next page: "the window doesnt go away"): the page the player
  lands on says it itself - its top card, plain "was -> now" words, the one pulsing next action, NEW on what is new.
  Little text (S545: "you do not need to spell everything out for the player"; "A simple You pay : 123456$ is enough ,
  if more things are needed use the fucking tooltip"). Plain menu words (S545: "what happened to normal words like
  staff"; "i do not understand whatis club and what is gym": the player's place is the gym). Office-like pages (Mail,
  Fights, and next Staff / Money / Records) are windows of the office computer (`Office.host`).
- At most 3 PC agents at once (watchdog; S419 operator: "i think thepc can handle more, change the rule ?" - seat_dispatch MAX_PC_AGENTS 2 -> 3; Godot jobs in godot_slot: GREEN 6 (owner S536 "can you get more going in parallel ?"; 4 since S534), all on the same 8 threads (S536 "Yes, use 8"), AMBER 2, RED 0), cloud seats unlimited. Every brief names its owned files, the one test command,
  and stays under the 500-line rule.

## PC rules (his machine)
- Nothing opens on his monitors: run Godot headless (`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless`),
  never the `_console.exe` (it opens a terminal window). Open images with the file tool, never with an app.
- CPU must stay under 84 C: tests run 4 at a time on a GREEN PC (`sh tools/run_tests.sh`, JOBS=4; JOBS=2 beside agents; S336
  operator "the heat fixed"); a headless test or two may run beside a film or windowed render while the watchdog reads
  GREEN (operator S355: "you can change the rule"); two windowed renders never at once.
- No audio in tests (`--audio-driver Dummy`).
- DISK (S366: E: is a 480 GB DRAM-less SATA SSD; at 96% full one git repack stalled every write ~1 s and froze the PC): E:
  keeps 20 GB free - the watchdog reads E: free space and write latency (AMBER < 20 GB free, RED < 10 GB free or writes
  > 250 ms; operator S469: "make amber for disk at 20gb left red at 10gb") and names any git packer running. Git auto-gc stays ON here (this repo is small, so loose objects never pile
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
months of costs ($14,600); 4 weeks in a row below $0 = the gym closes; a loss costs 3 members + 2 reputation (stoppage 5 + 4). (Code since the S397 money work: 8 weeks below $0; a loss costs 1 member, a stoppage 2: read the code, GymBills and BoutRules, before quoting these.)
Week 4 (Kalli K-PROLINE1): pro offer at 7 wins + top-3 ranking or 9 wins; debut purse $1,500 (+$500 a win, top $3,000),
gym share 35% (the code has 25%: read it before quoting), stipend stops, 4-round debut; a new move is a weapon (mastery 30) in 2-3 weeks of pad time.
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
3b. The map (operator S323: "so i can always know what we work on and next"; S385: "updated on every session end or start";
   S499: Miro replaced by our own page, http://127.0.0.1:8787/map). At START: `python ops/Tools/where_we_are.py roll S<n>` +
   `now`; at END: `done` / `drop` / `next`. The page reads them live: nothing to redraw. A design map, a mockup round or new
   stills he should see go on the map as a frame (`python ops/Tools/opsboard/map_board.py gallery <id> "<title>" --row "<row>"
   <globs>`; `cards` for a DONE/NOW/NEXT frame). His notes on the map are printed by `start`: quote each, act, then
   `map_board.py reply <id> "<what was done>"`. Commit `ops/AgentComms/map/frames.json` and `notes.json` with the session.
4. Memorize the session (memory) and say so in the handover.
5. Ask the operator whether to hand over or keep going; the handover is ONE copy/paste block.

## Git
Commit to `main` with clear messages; stage explicit paths. End commit messages with the Co-Authored-By line the harness gives.
Builds go to `Builds/` (ignored) with a WHAT_TO_TRY.txt. Session numbers continue the old project's (S294 = week 1).

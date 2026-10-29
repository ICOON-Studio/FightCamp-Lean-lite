# FightCamp restart: small, playable every week (2026-10-28)

Operator, after playing the menu prototype (https://claude.ai/artifact/XBvFSh3qyyQrc8HaW2HR1X): "Yes, restart small".
The structure to build is the Miro board "FightCamp - game structure and menus" (https://miro.com/app/board/uXjVEV03QWA=/)
and the prototype that plays it.

## The decision (developer call)
A NEW lean Godot 4.7.2 project, `E:\FightCamp\Lean` (own git repo), not more work inside this one.
- Why: this repo's core is GameState.gd 21,747 lines + FightRealtime.gd 10,316 + GymHall3D.gd 5,874, 791 scripts, 1,070 tests,
  and a tool/agent/board layer around them. Every change paid that tax, and months went in without the game feeling good.
- What comes over: only pure rule modules that already passed their tests, copied with their tests, each re-read before it lands:
  TrainingPreview (pace, S293), rules/FighterGoal (goals, S293), Membership + state/GameMoney (money, S293), FightCamp (camp),
  AmateurBooking, rules/MoveMastery, FightPlans, Retention. FightSimulation (3,709 lines, 11 preloads) and the 3D fight wait.
- This repo stays as it is: the reference library and the archive. Nothing is deleted.

## How we work (lessons from the first run)
1. One playable .exe every week. The operator plays it; his verdict is the gate. Tests support the build, they never close it.
2. Claude builds directly. No agent swarm, no nightly suite, no ops board, no background jobs. One golden-path test plus tests
   for the rule modules, run before each build.
3. Menus and the simulation first, in 2D. The 3D fight and the 3D gym come back later as views on the same data.
4. Scope: boxing only, one gym, a small roster, amateur to first pro fight. A new system enters only when the last build
   feels right.
5. The numbers already decided stay (S293: pace 1.0 per focused week, reachable goals, first coach $450, dues $22, 30 opening
   members, classes $350, ticket cut $450).

## Weekly builds
| Week | The build he plays | Done when |
| --- | --- | --- |
| 1 | Title, quick start, the shell (top bar, six areas, tabs), HOME, sign a walk-in, hire a coach, CONTINUE that stops on its own, week review with bars to the next point | He can run four weeks and see her improve |
| 2 | Offers, bout page, camp, weigh-in, fight night in words with corner calls, the result and why, the next goal | One full bout from offer to next goal feels like a story |
| 3 | MONEY and GYM tabs live, WORLD news and rankings, save and load | A 12-week career holds together and saves |
| 4 | Depth: scouting trials and a second fighter, move mastery, rankings that move, turning pro | He wants to play one more month |
| 5+ | Watch the fight in 3D (old fight engine as a view), then the gym floor | Only after weeks 1-4 feel right |

## Week 1 in detail
- New project: Godot 4.7.2, 1920x1080 UI scaled, the prototype's warm brown and gold, Bebas Neue / Barlow / Plex Mono.
- Scenes: Title, Create (3 steps), Shell (TopBar, Rail, Content), one scene per area with its tabs, Modal layer.
- State: one `Career` resource (plain data) + a `Clock` (days, stops) + the copied rule modules. No autoload over 500 lines.
- Tests: rule-module tests copied as they were; one golden path: quick start -> sign -> coach -> 4 weeks -> week review shows a
  whole-point gain.
- Build: `Builds/Lean/FightCamp.exe`, with a WHAT_TO_TRY.txt.

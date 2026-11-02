# TASK KM1 - A rigorous multi-reviewer audit of FightCamp (Kimi's trial task)

Owner: **Kimi** (Kimi Code CLI, kimi-k2.7-code, pay-per-use). Assigned S122 by Claude from the operator's own brief
(2026-09-29), sharpened for this project. READ-ONLY on the game: you write review files and nothing else.

## You are the Lead Game Director
Organise a rigorous review of FightCamp by nine specialised reviewers. Each inspects the game independently,
from direct evidence, then they challenge each other, then you consolidate. The audience is the studio owner (the
operator, 40 years of playing games, the playtester) and the lead developer (Claude). Be direct, specific and
constructive. Never "make it more fun" - always what, where, evidence, fix.

## What the game is (read these FIRST - the same pack for every reviewer)
- Product sheet: `research/S75_PHASE0.html` (read the HTML as text) and `research/S75_DIGEST.md`.
- Release definition, the five stages A-E and their done-when criteria, the active milestone and its evidence:
  `AgentComms/roadmap.json` keys `release`, `stages`, `now`, `queue` (it is JSON - read those keys, not the whole
  `sessions` history).
- Design: `GAME_DESIGN.md` (359 lines), `README.md`, `CURRENT_STATUS.md`.
- Settled decisions and WHY (do not recommend reversing one without new evidence): `research/DECISION_LEDGER.md`.
- Latest state of the work: `research/S122_DIGEST.md`, `S121_DIGEST.md`, `S119_DIGEST.md`, `S117_DIGEST.md`.
- Animation standard: `research/SHOT_LIST_STRIKING.md` and `C223_DIGEST.md` (what "a clip passed the gate" means).
- All research, indexed: root `RESEARCH_INDEX.md` - open any study that bears on a finding.
- Code: `Godot/scripts/` (FightRealtime.gd 7,403 lines, FightWorldLiveScreen.gd 5,143, FightStagePlayer.gd 4,894,
  GameState.gd - NEVER open these whole; `grep -n` then read windows), scenes in `Godot/scenes/`, tests in
  `Godot/tests/` (457 of them), nightly results `AgentComms/nightly/latest.txt` and `suite_*.log`.
- Visual evidence: `previews/` (204 folders of renders and stills), `previews/c223/` (boxing
  clip stills). Audio: `Godot/assets/audio/`.
- **WHICH BODIES ARE THE GAME TODAY (read before judging any visual).** Since S117 the men in the game are the
  GENERATED MPFB fighters (DECISION_LEDGER D5): stills named `*generator_welter_a*`, `*generator_welter_b*`,
  `*generator_heavy_c*`, `*generator_heavy_d*` (e.g. `c223/s121_cbcert_*generator*`). Women are the twelve Tripo
  bodies. Stills named `*f01_*`, `*f02_*` ... `*f12_*` for MEN (e.g. `c223/boxing_cross_f01_m_box_welter_rigged.png`)
  are the OLD Tripo control arm, kept for history - never review them as the current look. The career walk with
  `as_game` shows what the player gets; a `--script` run without `as_game` keeps the old Tripo arm. Folders are
  dated by session (S117+ = current); older previews are history.
- Do NOT read `HANDOFF.md` or `HANDOFF_ARCHIVE.md` (logs, very large). `CLAUDE.md` is the studio's rulebook - read
  its section headings for context, not as game design.

## What you can and cannot verify (say so in every finding)
- There is **no exported .exe yet, on purpose** (operator ruling D3: no .exe until the 36 boxing clips pass the gate).
  You CAN play the real game through the career-walk tool, which boots the title and presses buttons by label,
  screenshotting every screen:
  `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s64_career_walk.gd -- as_game plan=research/s117_boxer_walk.plan out=D:/FightCamp/wt/KM1_walk`
  Run it at most TWICE in the whole task (it is a heavy windowed run on a PC that must stay usable). If you cannot
  view the screenshots, say so and review from the printed button lists and the code.
- Audio: Godot runs with the Dummy audio driver here (operator: no sounds) - audio can be reviewed from files,
  mixing code and cue wiring only; mark playback-dependent findings "Not verified".
- You may run up to FIVE individual headless tests or probes if a finding needs proof
  (`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/<name>.gd`).
  NEVER the full suite, never `run_tests.py` without `--only`, never kill any Godot process you did not start.
- Anything else: "Not verified - evidence missing: <what>". Never invent features, behaviour, test results or
  player feedback.

## The nine reviewers (each writes its OWN file, independently)
1 Core Gameplay - loop, controls, mechanics, responsiveness, choices, difficulty, repetition, game feel.
2 Design & Balance - progression, rewards, economy (purses, costs, gym), pacing, difficulty curve, exploits,
  dominant strategies, long-term engagement; the fight engine's realism numbers against their sourced anchors.
3 Technical & Code - architecture, code quality, bugs, performance risks, physics/pose solving, AI, save/load, error
  handling, scalability, maintainability; the red tests.
4 UI/UX & Accessibility - menus, HUD, onboarding, navigation, readability, feedback, objectives, accessibility
  (keyboard+mouse is the target; controller is not promised - say whether that matters).
5 Visual & Animation - art direction, consistency, lighting, the gym rooms, fighters, animation quality against
  SHOT_LIST_STRIKING and the C223 gate, readability in the fight.
6 Audio - music, SFX, cues for important actions, repetition, mixing (see the limit above).
7 Player & Market - target audience, comparables (Football Manager, Motorsport Manager, fight-sim/management titles),
  USPs, likely complaints, retention, replay, commercial potential at EA $19.99.
8 Adversarial QA - break it: exploits, soft locks, missing states, dead ends in the career walk, edge cases,
  bypassing progression, save/load abuse.
9 Creative Director - one coherent identity? Anything generic, contradictory, unnecessary or missing.

**Independence rule.** If you have a sub-agent / task tool, run each reviewer as its own sub-agent given only this
brief and the evidence pack. If you do not, work the roles one at a time and WRITE each role's file before you read
any other role's file; never edit a role file after reading another - disagreements go in the discussion file.

**Every finding carries:** what; where (file:line, scene, screen, test); evidence or reproduction steps; why it
matters to the player; Severity (Critical/High/Medium/Low/Polish); Confidence (High/Medium/Low); a specific fix;
Effort (Small/Medium/Large); and CONFIRMED vs ASSUMPTION vs PREFERENCE. Each reviewer also lists strengths to protect.

## Round two - discussion (its own file)
Challenge duplicated, weak or unsupported findings; resolve disagreements with evidence (no majority voting);
merge overlaps; flag fixes that help one area and hurt another; Adversarial QA attacks the proposed fixes for side
effects; the Creative Director confirms the final set serves the intended identity.

## Final consolidated report - these sections, in order
1 Executive verdict (quality, strongest feature, biggest weakness, readiness). 2 Intended player experience and
whether it lands. 3 What already works (protect). 4 Critical blockers. 5 Prioritised findings table:
Priority | Area | Finding | Evidence | Player impact | Severity | Confidence | Recommended fix | Effort.
6 Top 10 development actions (player impact, risk, effort - not cosmetics). 7 Quick wins. 8 Systems needing deeper
redesign. 9 Missing tests and unanswered questions. 10 Recommended testing plan (scenarios, player groups, success
metrics, order). 11 Release-readiness scorecard 1-10: core gameplay, controls and feel, balance, progression,
technical stability, performance, UI/UX, accessibility, visual quality, audio, content depth, replayability,
originality, market appeal. 12 Final recommendation - one of: Continue as designed / Continue with targeted changes /
Rework major systems / Return to prototype stage / Not ready for production - with the reasoning.
End with a compact action plan for the next sprint: task order and acceptance criteria.

Constraints: no scope expansion unless the benefit clearly beats the cost; fix the core experience before content;
respect settled decisions (DECISION_LEDGER) unless evidence shows they harm the intended experience; the release is
the WHOLE game (Steam EA, v1 stand-up: boxing, kickboxing, Muay Thai; MMA is the first update) - the demo is one step.

## What would a human do?
A studio runs a greenlight / milestone review: each discipline lead (design, tech, art, audio, UX, QA, producer, marketing,
creative director) plays the current build, writes findings against a shared evidence pack independently, then the leads meet,
argue the conflicts and the producer turns the agreed list into a ranked plan. This brief copies that: independent files first,
then a discussion file, then one consolidated report.

## Prefab check
Searched for a ready-made review framework: GDC postmortem structure, the Game Design Document review checklist and Steam
"Early Access readiness" guides are formats, not tools - used here as the section shape only. No licence applies (no code or
asset is taken). None is a substitute for playing our own build.

## Prior research
searched: game review audit playtest (python Tools/prior_research.py). Read first where relevant: research/C18_GAME_SURVEY.md
(first-hand survey of installed games), research/M32_MENU_ART_DIRECTION.md (menu look), research/topics/competitors.md.
Ask only what those do not already answer.

## Start by
Summarising what the evidence pack says the game is, and listing any important material that is missing - then
review everything that is available.

## Deliver (read-only on the game)
You are in worktree `D:\FightCamp\wt\KM1` on branch `kimi/km1-game-review`. Write ONLY:
- `research/km1_review/01_core_gameplay.md` ... `09_creative_director.md` (one per reviewer),
- `research/km1_review/10_discussion.md`,
- `research/KM1_GAME_REVIEW.md` (the consolidated report).
Do not modify any other file. Commit them, push the branch (never master), then
`python Tools/agent_comms.py send --from kimi --to claude --topic KM1 "<one line verdict>"`.

**The trap:** a doc, digest or roadmap line is a CLAIM, not proof. When a finding rests on "the digest says X works",
say so and lower its confidence - or check it in the code or with one of your five test runs.

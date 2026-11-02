# S323 digest - the body is the track, part 2: see it, drive it (Lean update 26, 2026-10-31)

Working commits: Lean 2ad365f (update 26), 9250e24 (playtest fixes), c55a8f3 (jump=round3), fde28b1 (pace balance),
comparison doc after; ZIVA_LEAN 75a9a29. Update 26 exported from main after fde28b1 (41/41 tests).

## Operator input (board, verbatim)
- Q-S294-39 (update 24 close punches): "Yes".
- Q-S294-40 (what the pages need): "Layout looks cheap / like a spreadsheet".
- Q-S294-41 (update 25 tired guard): "Too little / can't see it".
- Chat: "search github and anthorpic for the best skills you can have to create/design a game" -> "go ahead";
  "do i have to do anyhthing to invoke those skills every session or on other projects ?" (no: user scope);
  "combine all your skills to deliver the best game you can then , you and ziva playtest and compare your results".

## What shipped
1. Tired SHOWS (Q-41): TiredSag.gd (SkeletonModifier, before GuardTuck): trunk fold 12 deg, neck 8, shoulders heave with a
   slow deep breath; GuardTuck TIRED_DROP lead 0.14 -> 0.30, rear 0.12 -> 0.20; BodyBurn takes the HUD's energy (the exchange's
   "after" state) - from energy 60 down to 15 both gloves and the fold come in. burn_probe: lead glove under the face round 1
   0.02 -> round 3 0.23 m (update 25: 0.11); Maria (energy 22) sag 0.83.
2. Body view: BodyTrack.gd (Qwen BODYTRACK1: tyre colours, body_place by stance, pulse, words) + BodyFigure._draw_track
   (strokes baked per portrait by bake_body_portraits: shoulders, arms, core, legs). On the side panels (with a FRESH-WARM-
   HOT-BURNING key), the corner card and the round/result pages. Hurt places ring over it.
3. Pace + Aim: PaceAim.gd (Qwen PACEAIM1) wired in LiveRound.exchange ("<call>|pace=..|aim=.."), ShoutBar row PACE/AIM with
   the pace's cost line, BodyLoad ctx.pace. Balance-check (exchange_balance.gd, 400 bouts a plan): Push all fight 0.88 vs
   Steady 0.67 = dominant -> Push fades on an empty tank (LiveRound.push_gassed: -12 edge by energy 25), Save -4 / +6 breath.
   Now steady 0.67 | push all 0.71 | push-push-save 0.69 | save-steady-push 0.68 | save all 0.56.
4. Pages (Q-40): Broadcast.gd - CompuBox-style round page and an announcer's result page (corner-coloured fighters, huge
   numbers, thin bars, the coach as a quote).
5. Referee: picks his spot ON SCREEN (_pick_along: off the gap between their heads, keeps his end, hurries out of the gap).
   ref_probe screen count: 42.8 % (update 25) -> 12.7 %; the rest is mostly walking.
6. jump=round3 + scenes/dev/JumpRound3.tscn (rounds 1-2 skipped, round 3 live).
7. Skills (user scope, read and adapted before install): balance-check, playtest-report, design-review (Game Studios, MIT,
   their `!bash` load line and Bash permissions stripped) + godot-animation-tree-mastery, godot-ui-theming,
   godot-economy-system, godot-genre-simulation (gd-agentic-skills, LGPL-3.0). Memory reference_game_skills_s323.

## Claude vs Ziva playtest (Lean docs/playtest/S323_COMPARISON.md)
Claude: the real flow twice (failures=0), 27 stills, 3 findings fixed the same day (body track missing at the pit stop
and on the round page; no key / no visible pace cost; Push dominant). Ziva ("Ziva Baby" model): round 1 never started
the fight and blamed the game; round 2 reached round 3 via JumpRound3 but every "screenshot" was image-generator output
(men, ROUND 4/8, "CARTER vs DAVIS") and its review described things neither picture nor game shows. Its "warnings" were
the hidden editor's startup NaNs (0 in 7 game runs). Its stronger model (S311-S317) was usable: the model is his money call.

## Decisions (Claude, developer)
- Tired reads from the tank as well as per-part Burn: the HUD's ENERGY and the body must agree.
- No dominant pace: balance-check every new choice through the real bout before shipping it.
- Ziva on the free model is not evidence; never trust an agent's screenshot list - open the files.

## Traps
- A var initialised from a function reading a LATER-declared var gets null (BodyBurn _shown/_tank).
- Restoring .import files under a running editor puts it in a reimport progress dialog that blocks run_scene.
- An agent can list "screenshots" made by its image tool; check the pictures before quoting them.

## Left / next (roadmap now)
Board verdict on update 26; corner card cut to the pit stop; management screens get the broadcast look (godot-ui-theming:
one Theme + type variations); Aim visible in the 3D; the residual referee walks (13 %).

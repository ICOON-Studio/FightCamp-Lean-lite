# S324 - next session (written S323, 2026-10-31)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 26 exported (main after fde28b1, 41/41 tests). The body is the track, part 2 is in: tired shows
(TiredSag + tank), the body view (BodyTrack) on the side panels / corner card / round+result pages with a key, Pace + Aim
on the shout bar (PaceAim, balance-checked: no dominant plan), broadcast round/result pages (Broadcast.gd), referee off the
gap between their heads on screen (13 %, was 43 %), `-- jump=round3`. Digest: Game Godot/research/S323_DIGEST.md;
playtest + Ziva comparison: docs/playtest/S323_*.md.

1. Board: Q-S294-42 (update 26 verdict), Q-S294-43 (Ziva's model - his money).
2. The corner card cut to the pit stop (docs/playtest/S323_CLAUDE_PLAYTEST.md: ~16 things in 60 s): body track big, the
   three calls the corner sees, the second's part (he may move it - Q-S294-36 ruling), the rest behind "More".
3. The management screens get the broadcast look (HOME, FIGHTS, FIGHTERS: lists in brown boxes, 60 % empty). Load the
   `godot-ui-theming` skill first: one Theme with type variations instead of per-node overrides.
4. Aim visible in the 3D: an aimed exchange's landed punches go to that place (BodyMap + the beats' targets).
5. Referee residual 13 % (mostly walking past behind them): route him round the far side.

Skills now installed (user scope): balance-check (run it on any new number), playtest-report (fill it after each build),
design-review, godot-ui-theming, godot-animation-tree-mastery, godot-economy-system, godot-genre-simulation.
Tools: tools/exchange_balance.gd (pace line), tools/ref_probe.gd (screen count), tools/burn_probe.gd, tools/pages_still.gd,
tools/fight3d_play.gd. Traps: a var initialised from a function that reads a later-declared var gets null; restoring .import
files under a running editor blocks run_scene; open an agent's screenshots before quoting them (Ziva generated its own).

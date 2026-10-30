# S319 - next session (written S318, 2026-10-30)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 21 exported (Lean 6b51aa5, 36/36 tests): the body map live in the scorebug (BodyLive +
BodyFigure), the corner card's figure + cutman job + the number behind each call + SEEN line (CallEvidence), skipped
rounds still mark the body, a clean clinch (Clinch.gd overhook + free-elbow grip, stance-aware), punch tail hold 0.3 s.
Digest: Game Godot/research/S318_DIGEST.md.

1. Board: Q-S294-32 (update 21), Q-S294-31 (update 20).
2. Smoothness: smooth_probe now reads ours 444/min, 160 clip changes/min; steps (advance/retreat ~100 starts per
   1.8 min) lead the changes, and 559 of 815 of our kinks are INSIDE clips - run the control arms
   (`-- noguard`, `noreach`, `nosnap`, `noglove`, `nojoin`, `nofeet`) to find the layer, fix, measure. A step starting
   inside the step grace was tried and READ WORSE (212 changes/min) - do not retry it.
3. FightView.gd is at 500 lines (the cap): move _fire (the beat switch) into its own file before adding anything there.
4. SHOVEL1 short hooks/uppercuts up close; recheck the Begin-fight stall in the exe.
5. Qwen is free: give it the next pure piece the moment one appears (worktree E:\FightCamp\wt\LEAN_BODYMAP1).

Traps: parse-check Lean files with `godot --headless --path . --check-only --script <file>` (the Game repo's
check_scripts.py resolves res:// against the Game project); hidden_desktop.py prints the game's output only with
`--log=<file>`; a pure module tuned on one RoundScript is 6x off the live game (a 3:00 round = six exchanges).

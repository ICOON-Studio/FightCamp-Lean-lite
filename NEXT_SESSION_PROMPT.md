# S350 - next session (written S349, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S349 shipped update 50: FIGHTERS > Training is his MMA home-training picture - her week as 8 real gym sessions round her
own body (scripts/ui/TrainingBoard.gd + rules/TrainingWeek.gd), each line on the part it trains; PLAYBOOK > Combos
(scripts/ui/ComboBuilder.gd): moves to try, her book's combos, the chain rated by ComboFlow (rule 6: move the head after
punching), her body throws it, Save / Drill it; the plan flow has Try combos. Digest: Game\Godot\research\S349_DIGEST.md.
OPERATOR RULE S338: agents do animations, Claude does mechanics + UI. Hidden desktop: Godot `--log-file <path>`.

1. Board: Q-S294-73 (the training board: keep it / change it, stills docs/playtest/S349/training) + comments on the S349
   stills (training, combos).
2. Collect, each on OUR GPU with the visual gate (S349 found two agent greens that measured themselves):
   - GROUND3 r2 (Qwen, wt E:\FightCamp\wt\LEAN_GROUND3): G144 skill-gap table in chance(); ground ~20 %, sub finishes 8-25 %.
   - TRAINCLIPS1 (Cursor, wt E:\FightCamp\wt\LEAN_TRAINCLIPS1): 8 session pictures on the training cards - open each one.
   - SMOOTH3 (Goose, Lean issue 18): quote smooth_probe lines.
   - PADWORK1 r4 (Goose #13): probe gaps must DIFFER per punch (0.035 constant = mitt follows the glove = FAIL); stills.
   - CLINCH2 r3 (Goose #14): `tools/clinch_check.gd` must read CLINCH OK 6/6 on main's tree, windowed on the hidden desktop.
3. On his yes to Q-S294-73: the Pad rounds plan off the pads card (each round a named combo from her book, numbered moves,
   three focus points from ComboBuilder's cues); then C197 corner card under the new lens; the Playbook map in the
   martial-arts-tree look (glowing paths, picture cards).

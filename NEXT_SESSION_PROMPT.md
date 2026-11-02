# S360 - next session (written S359, 2026-11-02, after update 61 + the operator's notes)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean (branch `main`).
S359 (Lean 450482d..0f8a2f4): Kalli's whiteboard clarity, then every note the operator gave while playing, each fixed and
measured - the intro glove raise, the referee unseen until a clinch break, readable index-card tooltips (Tips.gd, J90
research), MORNING / EVENING / TIRED BY NIGHT rows, the Playbook (no overflow, smaller player, combos chain like the
fight, forced moves play, steps as the fight's glide, counters at the measured deepest frame, Escapes = MoveBook).
Digest: Game/Godot/research/S359_DIGEST.md (with its addendum). Film + stills on /review S359.
He LIKES the Combos tab ("really fun to try and also learn from the book"). He finds Moves and Plans confusing.
OPERATOR RULES: no his/her in game text; agents do animations, Claude mechanics + UI; probes at `--fixed-fps 30`; tests may
run beside ONE windowed render on GREEN; check Miro (https://miro.com/app/board/uXjVETf7la4=/) at start.

In order:
1. Q-S294-91 (Playbook): Yes -> Moves as a move book (scripts/ui/MoveBook.gd, the Escapes pattern, grouped by ring
   position) and Plans as a game plan written as lines ("At long range -> One-two"), the same fighter.arrows data, the
   map behind See the flow (Game/Godot/research/PLAYBOOK_CLARITY_S359.md).
2. Q-S294-90 -> the amber opponent goal line and/or the evening-magnet cut (+ Kalli's "More" row).
3. Q-S294-89 SMOOTH3 film (Same / Left worse / Right worse - see roadmap).
4. Brief Ziva on boxing footwork + pivot clips and the Playbook moves' smoothing ("animations need work", "slip and roll
   ... need a lot of smoothing and better timing blending"). Instruments: tools/move_player_probe.gd (clips in order,
   travel, foot height), tools/defence_peak_probe.gd, tools/ref_probe.gd.
5. Tips index cards onto the top bar / gym and the T3 keyword sticky notes (J90 6c, 6g).
Lesson: every note he gave came from looking at one screen; a hidden-desktop still or probe of THAT screen found each cause
in minutes (the film tool even predated the intro). Shoot the screen before touching the code.

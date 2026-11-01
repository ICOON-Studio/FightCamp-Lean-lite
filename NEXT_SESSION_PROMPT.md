# S353 - next session (written S352, 2026-11-02)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S352 shipped update 53 (Lean afa91b6+): board-review defects (Lucy's goal, week money, toasts, snapshot corner shots) and
CORNERFIG1 (her own kit on the corner card; BodyFigure._ready reset every hurt spot to fine - fixed, test 8).
Digest: Game\Godot\research\S352_DIGEST.md. OPERATOR RULE S338: agents do animations, Claude mechanics + UI.
EVERY PROBE AT `--fixed-fps 30`.

IN FLIGHT (collect first):
- TRAINCLIPS1 r5 - ZIVA, editor on E:\FightCamp\wt\ZIVA_LEAN (branch ziva/trainclips1, brief docs/ziva/TRAINCLIPS1_r5.md),
  chat at http://127.0.0.1:7012/ (thread "Round 5 Task Progress"). Collect: open its 8 pictures + the Training screen still
  (tools/training_still.gd) yourself; its result file docs/ziva/TRAINCLIPS1_r5_result.md. If the editor is not up:
  `powershell -File Tools\godot_hidden.ps1 --audio-driver Dummy -e --path E:/FightCamp/wt/ZIVA_LEAN` from Game.
- SMOOTH3 r3 - GOOSE, issue 18 (run 41359780831): one smooth_probe per layer switched off, then the fix. Red on main:
  OURS 305/min (122 at a change); hit_gap `> 0.15 m: 1`. Reject anything that lands punches short (r2 did: 15 of 25).

1. Board: Q-S294-75 (his Fighter Training Blueprint as the training game, Godot/research/TRAINPLAN2_DESIGN.md) and Q-S294-74
   (what "not that good for training" meant) - unanswered at S352's end. On "Yes, build it": TRAINPLAN2 step 1, the week as
   days (HARD / SKILL / ENGINE / REST, red on two hard days) feeding TrainingPlan's rounds. PADROUNDS1 waits on the same answer.
2. CLINCH2 -> Ziva after TRAINCLIPS1 lands (one Ziva chat at a time). Goose r4 (fee5307) read 3/6, the same as r3 to the cm:
   overlap 0.08 m, glove above her own head -0.06..0.31, digs 0/5. Its probe sees 0 holds on main (a vacuous 4/6) - the
   probe must FAIL with 0 holds and be able to read main. Brief from Game TASK_CLINCH2.md + this.
3. PLAYBOOKTREE1 (Playbook map in the martial-arts-tree look: glowing paths between picture cards, dark board) - his
   S348 chat pictures were not saved: build a mockup still first and put it on the board for his OK.
4. MENUS_SCALE mockups (Godot/research/MENUS_SCALE_S351.md): the Training fighter strip (the training board shows one
   fighter even with two signed), one board, Squad week, the Interview as a fighter card.
5. The Miro loop board (https://miro.com/app/board/uXjVETf7la4=/): re-upload the corrected pictures from
   Lean docs/playtest/S352/layout (corner 1, corner 2, round 3, training without the toast, review money) and fix captions
   ("New career" = the Country step; "Mail" opens World > News; "Record" comes after the first win).

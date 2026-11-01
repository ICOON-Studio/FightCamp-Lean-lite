# S335 - next session (written S334, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S334 shipped update 36 (Lean 8ddc745): HOME polaroid = her ring photo (tools/bake_headshots.gd), the fight body view bigger
and slowly turning (tools/bake_body_turn.gd + scripts/ui/BodyTurn.gd), Kira and Samira Khan as 18-year-old prospects with
new faces. Digest: E:\FightCamp\Game\Godot\research\S334_DIGEST.md.

1. Board answers: Q-S294-58 (GrappleMap ground prototype now / park for MMA - BJJ_SOURCES_S334.md), Q-S294-59 (Dojo
   Legacy ideas: next-step card + reasons on greyed buttons first - DOJO_LEGACY_IDEAS_S334.md), Q-S294-60 (shape the
   18-year-olds younger by hand / keep). Faces: preset blends cannot look younger; hand-shaping means editing face-model
   coefficients in Tools/metahuman/mh2_build.py beyond face_blend (research first). A new face = mh4_run.py build, then a
   sidecar copied from her base preset's boxer (mh4_audit needs age 19-34 + garment fields), --import, bake_body_portraits,
   bake_body_masks, bake_body_turn, bake_headshots (all `stems=`), faces/body_figure/body_turn tests, a lineup.
2. The cloud fight-animation pipeline (another S334 session, local_c7e7549f): .github/workflows/fight-stills.yml on
   ICOON-Studio/FightCamp-Lean. Runs 41267920481 and 41267894530 were still "in progress" ~50 min after dispatch - check
   whether they hung (gh run view), fix, then send measurable animation briefs to Goose/Arena as planned.
3. Q-S294-53 inside punches: wait for his marks, then a fresh close-exchange still.
4. Look B polish: GYM, MONEY, FIGHTS, WORLD stills (tools/pages_now_still.gd), fix what reads dark-theme.
5. Defect seen: the vest tears open at the armpit when an arm is raised high (mc_win past ~0.9 s) - kit mesh/skin weights.
6. THE READ: film a READ IT beat on camera (fight3d_play with a high Ring IQ fighter) and check the close-up.

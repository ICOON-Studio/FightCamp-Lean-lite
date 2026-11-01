# S334 - next session (written S333, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S333 shipped update 35 (Lean effa1fe): look B whiteboard on every menu, THE READ in the fight, Erin/Dana/Sophie blended
faces. Digest: E:\FightCamp\Game\Godotesearch\S333_DIGEST.md.

1. Board answers: Q-S294-55 (faces hotter?), 56 (look B right?), 57 (THE READ look). Act on each. Faces tool:
   Tools/metahuman mh_boxer_NN_mh4.json "face_blend" [[preset, w], ...]; young base presets only (Grace = old skin);
   move .mh4/project/Content/MH/MH4_<name>.uasset aside before a preset change; then sidecar, --import,
   bake_body_portraits stems=..., bake_body_masks, faces_test + body_figure_test.
2. HIS ASK (S333): "how can we have an agent(s) working on improving the fight animations on the cloud or wherever while
   we do other things". Plan: (a) .github/workflows/fight-stills.yml on ICOON-Studio/FightCamp-Lean: ubuntu + xvfb +
   Mesa (lavapipe), run the fixed fight still set (tools/fight3d_play.gd / contact_stills.gd) + the motion probes
   (hit_gap_probe, inside_guard_probe, clip_contact, glove_height_check), upload PNGs + numbers as PR artifacts and a PR
   comment; (b) measurable animation briefs (one red probe each) to Goose (label `goose`) and Arena; (c) stills of each
   landed PR to the review board - the visual gate and his OK close them.
3. Q-S294-53 inside punches: wait for his marks, then a fresh close-exchange still.
4. Look B polish: GYM, MONEY, FIGHTS, WORLD stills (tools/pages_now_still.gd), fix what reads dark-theme.
5. THE READ: film a READ IT beat on camera (fight3d_play with a high Ring IQ fighter) and check the close-up.

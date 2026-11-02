# GYMLOOK3B implementation plan

Spec: `TASK_GYMLOOK3B.md`, Ludo round 54 TAKEN 1-10; round 65 section 0 for generated props.
Goal: bring the training floor to the approved room asset standard while preserving training routes and game cameras.
Architecture: retain existing GameSwitches.GAME_ON look/pack flags; extend the current look helpers and scene geometry. New hall dressing is a focused helper. Room code changes only hide hall labels while a room is open.
Tech: Godot 4.7.2, Ludo CLI, Blender 5.2, Python.

Constraints: hidden Godot launcher, watchdog before each launch, RED waits; test jobs 1 unless GREEN, maximum 2. No full suite. No import-cache deletion or import churn. Six approved Ludo image/model pairs, maximum 28 credits. Explicit owned-path commits and a push after every commit.

- [ ] Baseline: red runtime contracts and four stills with shipped look enabled, at origin/master before production edits.
- [ ] Labels: hide ClubZones/Signs on room entry, restore on exit; test both states.
- [ ] Lighting: narrow shadowless steel roof trusses, linear fixtures and distributed light, 5000 K four-corner ring key; inspect all game cameras.
- [ ] Materials: loaded rubber roughness .88-.90, canvas .94, SSAO radius 1.2/intensity 2; assert actual scene materials and environment.
- [ ] Geometry: replace pack stairs with two compact treads, .45/.40 ladder, .075 steel speed-bag posts/.60 drum; inspect shipped meshes.
- [ ] Floor detail: .08 boundary trims, soft wall/foot contact, faded 2.5 m drill squares, four to six .9x1.2 posters.
- [ ] Life: two actual hanging bags rotate .75 degrees about suspension; 3:00 round /1:00 rest countdown. Assert time boundaries and transformed bag position.
- [ ] Props: inspect six image refs and generated meshes, normalize/validate/provenance, reuse locker bench. Dress floor with clear walking routes and no office furniture.
- [ ] Delivery: parse, focused tests, bounded gym/club/look/zone/room suite; four after stills and per-still ten-item observations; S226 review board, digest, Claude message, final branch push.

Review focus: loaded pack meshes versus greyboxes; room entry/exit and hall light spill; actual bag transform versus inert node; timer cycle boundaries; generated-prop floor contact and route clearance. Visual acceptance remains with the operator.

General rules set aside: explicit new branch replaces generic rebase of the old branch; user/task jobs 1 unless GREEN replaces CLAUDE section 6 always-parallel rule; bounded suite replaces skills' generic full-suite step; assigned visual design and generation approval replace redundant brainstorming/asset-write approvals. Existing untracked PROFILE2E outputs are preserved and excluded.

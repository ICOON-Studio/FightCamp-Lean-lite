# S95 DIGEST - tiers you can see, wear you can see, lighter prop files (Claude, 2026-09-27)
Commits: b757a979 (Q195 merge), 9d2ccf72 (Q196 task), 45ab3d65, 5a508040, bed85286 (+ ship). Suite: nightly
2026-09-26 at 9847dd13 total=416 fails=13 (AgentComms/nightly/latest.txt); this session ran subsets only:
training_floor+gym_ 15/15 (x3), judge_panel+grapple_adapter 2/2, gym_prop_models PASS, asset_manifest red as in the
nightly, then FIXED (below): 0 failures.

## Built
- **1K prop textures**: `Tools/glb_texture_downsize.py` re-packs a GLB with its images shrunk (JPEG q88 / PNG optimised),
  every other buffer view byte-for-byte. 10 props 29.65 -> 12.67 MB; 2K originals on `D:/FightCamp/originals/props_gym_2k`.
  New Tripo exports pick 1k in the Export dialog (it is remembered). Folder now 15 models, 17 MB.
- **Wear you can see** (`TrainingFloor3D._apply_wear`, same 80->20 condition rule as `TrainingFloorLayout.tint`): each worn
  prop gets its OWN material copy - albedo toward grime, metallic dulled (Tripo's roughness factor is already 1.0, so a
  roughness term could never move - caught before it shipped as a hollow check) - plus a `next_pass` dust/scuff coat
  (value noise in world metres, alpha by wear). Darkening alone was INVISIBLE on black kit (render); first coat was
  camouflage; the shipped one is a faint film plus sparse scuffs. Mutant (wear skipped) turns the test red.
- **Tiers you can see**: `TrainingFloor3D.prop_model_path(catalog_id, quality_tier)` -> `<model>_t3.glb` at tier >= 3 when on
  disk, else the base (aliases first). Shipped: `heavy_bag_t3` (cowhide cylinder, four-chain swivel - reads as an upgrade),
  `compact_weights_t3` (3-tier rack - reads DIFFERENT but smaller: fitted to the 0.9 m height it is narrower than tier 1).
- **The two missing props**: `cold_water_tub` (tub, 1.11 x 0.61 x 0.80) and `first_aid` (wall cabinet at 1 m).
- `gym_prop_models_test` now fits every `_t3` file through the game's own tier lookup; wear + tier checks added.
- `tools/s95_render_wear.gd` renders kept|worn and tier1|tier3 pairs to `docs/previews/s95/` (sent to the operator).

## Verdict on the look (D42, Dola, fresh eyes on the S95 renders)
- Tier-3 bag: 'different, not better' (brown reads unfinished); tier-3 rack: 'barely' (same dark finish). Worn bag: reads as
  CAMOUFLAGE / dirty paint; worn cabinet: dull paint. 'All variants too similar in silhouette.' -> S96 makes wear SHAPE
  (worn model variants) and re-prompts tier 3 with high-contrast premium cues. The coat stays only as a faint film.

## Rejected
- `focus_mitts_locker_t3`: take 1 a two-door bank 1.46 m wide, free retry 1.23 m wide (gloves + deep body), zone is 1.0 m.
  Shrinking to fit gives a 1.3 m-tall locker - worse than tier 1. Both on D:/FightCamp/originals/props_gym_tripo.

## Collected
- **asset_manifest_test GREEN** (operator: "get rid of this"): Mixamo training pack candidate -> approved; its bar (bound only after prop contact review) was met by C212/U180/U181. failures 4 -> 0.
- **Q195** (Qwen) MERGED: bisected the pin drift to 4f789137 (Q183 footwork_economy default ON) = intended; judge_panel
  (12 bouts + T11 re-found: KB 561 split, boxing 446 majority) and grapple_adapter re-pinned, both pass on master.
- **fight_realtime_test is RED on master** (FAILS=6). Control arm (line 1032 default false) -> PASS 378. Economy ON: R91 subs
  2/40 -> 0/40, takedowns ~same; R92/R93 judo throws 4 kept both arms but seats side->half so yuko 3 -> 0, seed 94018
  ippon -> hansoku. Noise or mechanism unknown -> **Q196** (Qwen, running).
- **G130** (Grok): tier looks per station, worn-vs-kept reads, room upgrades - "don't recolor T1; room floor + mirrors beat
  a fancy logo". **D41** (Dola): ring too dominant, block-colour zones too clean, rack too close to the bag, bags hang from
  nothing; ONE missing thing = mirrors + a worn, taped floor.
- Sent: G131 (Grok, real judo throw-scoring rates for Q196), D43 held for Dola (S96 renders).
- C213 (Codex) had stopped idle at S94 end (its task said HELD until a slot freed and it waited for that literally) ->
  relaunched with an explicit go. U188 (Cursor) held: both slots taken.

## Traps earned
- A task file line "HELD until X" is read by an agent as "do nothing until told X" - lift it in the launch prompt.
- Chrome saves a second download of the same name as `name (1).glb` - copy by newest, not by name.
- A wear/tint that only multiplies cannot show on black kit; judge wear on the darkest prop.

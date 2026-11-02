# TASK_C179 - THE FIGHTER GENERATOR: an athlete's numbers become a Character Creator body, by script (Codex, full branch)

Model: gpt-5.6-luna, medium (this is scripting and data, not 3D animation design; astra is NOT
used). Owner: codex. Assigned S62, 2026-09-24, on the operator's ask: "the creator studio
character is fine, can we add more models like that or a generator, i want height, muscles etc
being visible according to the numbers".

## What exists (read these, and only these)
- `Tools/cc_bridge/build_a.py` and `build_b.py` - S60's two hand-built passes: `build_a` lists the
  body sliders (opaque `embed_*` ids, display names, ranges) and fits HEIGHT with "Character Scale A"
  (measured slope 93 cm per unit, bounding-box measured at the SAME frame before/after so the pose
  cancels); `build_b` shapes HD Aaron into a lean 77.1 kg welterweight with eight sliders (Male
  Muscular Shoulder 0.5, Neck Scale 0.25, Pectoral Scale 0.2, Abdomen Scale -0.25, Upper Arm Scale
  0.2, Forearm Scale 0.2, Lower Leg Scale 0.15, Shoulder Width A 0.1) then refits height.
- `Tools/cc_bridge/out/build_a.txt` (13.9K) - the slider list with ranges: the ONLY vocabulary you
  may set. `probe2.txt` (69K) - grep it, never read it whole.
- `Tools/cc_bridge/export_once.py` - the ONE export path (UNREAL bone names, bind pose, SubD 0).
  It REFUSES to run twice via a marker file. The trial has 29 exports left; every export is spent
  by the OPERATOR loading the script in CC (Script > Load Python), never by you.
- `Godot/scripts/FighterPhysique.gd` (small, read whole): `reference_height_m`, `girth(weight, height)`
  (BMI against LEAN_BMI 23, clamped 0.85-1.30), `describe(...)`. This is the game's own answer to
  "how big is this man" and your generator must agree with it.
- `Godot/scripts/CCFighterSkin.gd` header only (`sed -n '1,60p'`): how the ONE export is mounted
  today (scaled to the Tripo body's mounted height; one hard-coded path).
- `research/G81_PHYSIQUE_FROM_NUMBERS.md` IF it exists when you start (Grok's slider-value
  study, in flight). If it does, its Section 2 formulas replace your first-cut mapping below; if not,
  ship the first cut and leave a `# G81:` marker at every formula so the swap is one edit.

## Deliver, on branch `codex/c179-cc-generator`
1. `Tools/cc_bridge/build_from_athlete.py` - loaded in CC by the operator. Reads
   `Tools/cc_bridge/in/athlete.json` ({"id","name","sex","height_cm","weight_kg","reach_cm",
   "class_limit_kg"}), computes the slider table from the numbers, applies it, refits height to
   `height_cm` by the build_a method, writes `Tools/cc_bridge/out/<id>_build.txt` (every slider set,
   value, the formula's inputs, height before/after). NO EXPORT in this script.
2. `Tools/cc_bridge/export_athlete.py` - the export step, separate on purpose: reads the same
   athlete.json, refuses if `out/<id>.fbx` exists, refuses if `out/EXPORTS_SPENT.txt` says 29 have
   gone, exports with export_once.py's exact settings to `Godot/assets/models/fighters/cc/<id>.fbx`,
   appends to `EXPORTS_SPENT.txt`. Print the count remaining every run.
3. `Tools/cc_bridge/physique_table.py` - runs OUTSIDE CC (plain Python, no RLPy): given N athlete
   JSONs (or the featured athletes from `Godot/assets/data/` - find the file with `height_cm` and
   `reach_cm` by grep, do not read GameState.gd) prints the slider table for all of them as CSV,
   so the mapping can be judged for 30 men BEFORE a single export is spent. This is your test: run
   it on the featured roster, and the digest carries the CSV.
4. First-cut mapping (until G81): Character Scale A from height (build_a slope); the eight build_b
   sliders scaled linearly by `FighterPhysique.girth(weight, height)` with build_b's values pinned
   at girth 1.0 and zero at girth 0.85 (lean flyweight) - a heavyweight at girth 1.30 gets 2x
   build_b; Male Skinny pack rises as girth falls below 1.0; Shoulder Width A from reach/height
   ratio (reach > height means broad). Every formula in ONE function with a docstring naming its
   inputs. Clamp to the slider's own range from build_a.txt.
5. Godot side: `CCFighterSkin.gd` gains a `cc_export_for(athlete_id) -> String` that returns
   `res://assets/models/fighters/cc/<id>.fbx` when it exists, else the current single export, so a
   generated body is picked up by id with no other change. Parse gate + `run_tests.py --only fight_cc_skin`.
6. `research/C179_DIGEST.md`: the CSV for the roster, the formulas, what you could NOT
   calibrate without an export, and the exact operator steps (which script to load, in which
   order, for one athlete) - written for someone who has never opened CC.

## Gate
Tier: Python + one small .gd edit. `python -m py_compile` on the three scripts;
`python Tools/cc_bridge/physique_table.py --roster` runs and prints the CSV; parse gate on
`CCFighterSkin.gd`; `run_tests.py --only fight_cc_skin`. NO full suite. NO export is run by you.
Commit with explicit paths, push, one `agent_comms.py send --from codex --to claude --topic C179`.
Do NOT edit HANDOFF.md.
Trap: this checkout is a WORKTREE - `git fetch origin && git checkout -B codex/c179-cc-generator
origin/master` first. Trap: the shell's writes OUTSIDE the repo are sandboxed; keep everything
under the repo.

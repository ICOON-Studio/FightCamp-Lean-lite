# TASK R144 - CLAUDE - THE GROUND FILM: FIND THE SKU, AND COST HARMONY4D BESIDE IT

Model: Opus, medium effort, Fast OFF. Owner: claude. **Status: OPEN.**
**MUST RUN ON THE PC** - `assetstore.unity.com`, `huggingface.co`, `jyuntins.github.io` and
`api.github.com` are all `connect_rejected` by the cloud container's egress policy (measured
2026-09-18). Only `raw.githubusercontent.com` answers from the cloud.

**Test tier: RESEARCH, no `.gd` touched. NO GATE AT ALL** - not the parse gate, not a test.
`git status -s` before staging is the whole check. If you add a costing script it goes in
`Godot/tools/` and takes the parse gate only if it is `.gd` (a `.py` takes none).

## Why this exists, and it is a process failure being repaired

S12 measured the ground and ranked what to buy: **side control first, then guard.** The roadmap
turned that into `now`'s OPTION 1, "buy the side control film", and a session relayed it to the
operator as a decision. The operator asked the right question - **"buy what exactly for what
exactly?"** - and there was no answer, because **no product was ever identified.**

Checked 2026-09-18: the sale list (`roadmap.json` -> `sale_list`, all six groups) contains **no
ground or grappling pack at all.** Its only paired-clip pack is RamsterZ *Martial Arts Master*
(Unity 311647, EUR 45.99), which is plum knees and a wall pin - standing clinch, not ground.

So OPTION 1 is not a decision the operator can make. It is this task, undone. Per the standing
rule, a question put to the operator is a research task that was not assigned in time.

## What we own, and what the hole is

- The sixteen `Paired_FullMount_*` films are RamsterZ **Full Mount Attacks**, Unity Asset Store
  **227372**, bought 2026-09-11 for **EUR 10.11** (`Godot/assets/asset_manifest.json`, id
  `ramsterz_full_mount_attacks`). We also own RamsterZ **Hand to Hand Set** (227377, EUR 36.79) -
  so this publisher's rig is already known-good in our retarget.
- `S12_GROUND_HOLD.md:41`: "There is no side-control film, no guard film, no back film."
- Occupancy (S12, seed 77321, 300 s): side control **63.0%** of ground time, guard 19.6%, mount
  **15.2%**, half 2.2%; ground is **7.7%** of the bout. So side control is ~4.9% of bout
  wall-clock with no film, against mount's ~1.2% which has sixteen (derived, not S12's own line -
  say so if you quote it).

## The deliverable

`research/R144_THE_GROUND_FILM.md`, opening with `## DECISIONS`, and a machine-readable
`research/R144_ground_film.json` in `R142_asset_shortlist.json`'s shape so the ops board can
render it. **Four lines, costed, ranked, with a recommendation.** A line with no price and no file
list is not costed - say "unpriced" rather than guessing.

### LINE 1 - RamsterZ's own catalogue, FIRST because the rig is already proven
Full Mount Attacks was EUR 10.11 and retargets cleanly. Read the publisher's full store page and
list EVERY grappling pack: name, store id, EUR, clip count, and whether any clip is **side
control, guard, back control or half guard**. This is the cheapest possible outcome and it may
already exist. Do this before anything else.

### LINE 2 - the rest of the Unity Asset Store
Search paired/two-person ground work generally (BJJ, wrestling, ground-and-pound, submissions).
For each candidate: store id, EUR, clip count, **rig/skeleton** (ours is 22-bone
`SkeletonProfileHumanoid`; RamsterZ maps already, Sidekick needs a new bone map - Reallusion), and
the licence (**standard Unity EULA only** - never a publisher-direct EULA; the RamsterZ direct
EULA has an AI clause the Unity copy does not).

### LINE 3 - author it in Blender, priced in TIME not money
`HIGGSFIELD_MMA_PIPELINE_STUDY.md`'s second real option: two-man exchanges scripted with contact
keys. We already own `author_pair.py` v1 (retime, aim swing, contact on the opponent) and it works
for striking. Estimate hours per held ground position, from the striking pair work actually done.
Zero cash, real calendar. Say honestly whether a HELD position is easier than a strike (no
follow-through to solve) or harder (persistent contact on many joints at once).

### LINE 4 - HARMONY4D, and this is the one nobody has costed
CMU, NeurIPS 2024, `arXiv:2410.20294`. **A multi-view video dataset of in-the-wild close human
interaction that names wrestling and MMA explicitly** - 1.66M images, 3.32M human instances, 20+
synchronised cameras, 208 sequences, 24 subjects. Sequence folders are named by interaction
(`01_hugging`, `02_grappling`, ...) across `train` and `test`. It is the only source of the four
built for exactly our problem: two bodies in sustained contact.

**ALREADY ESTABLISHED FROM THE CLOUD 2026-09-18, do not re-fetch these:**
- Repo `github.com/jyuntins/harmony4d` **LICENSE is MIT** - but that is the **CODE**, and the code
  licence is NOT the data licence. Do not conflate them; that is the trap on this line.
- The README states **no dataset licence at all**. The data lives on Hugging Face
  (`datasets/Jyun-Ting/Harmony4D`).
- Annotations (`assets/VISUALIZE.md`): **3D pose in COCO-WholeBody format**; SMPL joints via the
  SMPL_45 regressor, first 24 matching standard SMPL; 2D pose in SMPL_45; bboxes projected from
  SMPL meshes.
- The visualisation scripts need **SMPL 1.1.0**, which requires registering at
  `smpl.is.tue.mpg.de` and setting `_C.SMPL_MODEL_DIR` in `config/default.py`.

**THE THREE QUESTIONS THIS LINE LIVES OR DIES ON, in order:**
1. **The DATASET licence on the Hugging Face card.** If it is non-commercial (CC-BY-NC or a
   research-only term), line 4 is DEAD for shipping and the study's "research-grade" caveat was
   the real answer. Settle this FIRST - everything below is wasted if it fails. If the card is
   silent, say so and treat it as unresolved, not as permissive.
2. **Is SMPL actually on our path?** The 3D poses are delivered as COCO-WholeBody
   **joint annotations**. If those files can be read without instantiating the SMPL body model,
   the SMPL registration and its own non-commercial terms never bind us. If a mesh is required,
   SMPL's licence becomes a second gate as hard as the first. **Open one `02_grappling`
   annotation file and look** - do not infer this from the docs.
3. **Does it contain SIDE CONTROL, and is the man legal for the ruleset?** "Grappling" and "MMA"
   in a dataset abstract are not a side-control film. Name the sequences that show it, with
   timestamps. And per the standing rule, a fixture is unreal if both men are interchangeable:
   say which two subjects, and that they are not the same body twice.

**If all three pass, cost the PIPELINE, because the dataset is not a clip:**
COCO-WholeBody joints -> our 22-bone humanoid is a retarget we have never done from this source.
We have the machinery (`glb_clip_to_bridge.py`, the Blender retarget addon, C100-C104's by-frame
retarget measurements), but the joint set differs. Estimate the hours and name the one thing most
likely to break. Download size matters too: 1.66M images is not a small pull - report the bytes
for just the `02_grappling` annotations, not the whole set.

## The recommendation

Rank the four on **cost x risk x how much of the 4.9% each actually covers**, and name ONE. If the
answer is "line 1 has it for ten euros", say that in the first paragraph and keep the rest short -
the operator does not need four essays to spend EUR 10.

## Owned files

- `research/R144_THE_GROUND_FILM.md` - new, yours.
- `research/R144_ground_film.json` - new, yours.
- `AgentComms/roadmap.json` -> `sale_list` only, IF a SKU is found: add it in the existing item
  shape (`id`, `name`, `publisher`, `eur`, `verdict`, `why`, `url`). Touch nothing else in that file.

**DO NOT TOUCH** any `.gd`, `asset_manifest.json` (a pack is added there only after it is BOUGHT
and audited, R143's guard), or `HANDOFF.md` beyond your own block.

## Anchors

- `research/S12_GROUND_HOLD.md` - `:41` the missing films, `:82-85` the purchase ranking,
  and the occupancy table. **The whole argument for this task.**
- `research/HIGGSFIELD_MMA_PIPELINE_STUDY.md` - `:131-132` the three real options, and the
  measured reason generation is not a fourth.
- `Godot/assets/asset_manifest.json` - `ramsterz_full_mount_attacks` and `ramsterz_hand_to_hand_set`:
  the price, the source, and the licence wording to copy.
- `research/R142_ASSET_STORE_SHORTLIST.md` + `R142_asset_shortlist.json` - the shape to match.
- `AgentComms/roadmap.json` -> `sale_list` - the six groups that do NOT contain a ground pack.

## The traps

1. **The code licence is not the data licence.** Harmony4D's repo is MIT and its dataset terms are
   unstated in the repo. Reporting "MIT, we're fine" is the single most likely way to get this
   wrong, and it would put an unlicensed dataset into a commercial game.
2. **Do not pay a generator to re-answer this.** Higgsfield was already measured on exactly this:
   8 two-fighter generations all came back as ONE BODY, none of the 4 armbar prompts reached the
   ground, and composing two halves scored **0 of 36** (`compose_takedown.py`). Generation is not
   a fifth line. R104's blocker records the same.
3. **Never pass a clip we own to any generator** as reference, seed or input (operator standing
   rule, in the manifest's `restrictions`). It applies to Harmony4D footage too.
4. **A film says where a body is, never how big the man is** (S6c). Whatever the source, the
   fighter's own scale stays his - this is why a bought clip is a placement, not a body.
5. Buy RamsterZ on Unity, **never direct** - the direct EULA has an AI clause the Unity copy lacks.

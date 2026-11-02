# R77 — Regeneration log: f06 and f08

Ordered by R76 (`research/R76_FIGHTER_REVIEW.md`), which cleared nine of
the twelve fighters and sent two back for a prompt-level fix.

R76 found the twelve original prompts had never been written down. This file
exists so that does not happen again: **every prompt, parameter, job id and
failure below is the record.** Nothing here is reconstructed from memory.

---

## Pipeline and account state at start

- Higgsfield MCP balance: **50 credits**, plan `plus`.
- Ludo Rig & Animate credits: **8** (needs 2). Both verified before spending.
- Mesh model: `tripo_3d` via `generate_3d`.
  `models_explore(action:'get', model_id:'tripo_3d')` returns **"Text to 3D"**
  with `medias: []` — text-only, takes a `prompt`. The generic `generate_3d`
  tool description claiming only `sam_3_3d` accepts a prompt is **wrong for
  this model**; confirmed again this session by four successful submissions.

### Preflight prices (`get_cost:true`, free, never submitted)

| Configuration | Credits |
|---|---|
| `texture_quality: standard` (baseline) | **5** |
| `texture_quality: standard` + `face_limit: 20000` | **5** |
| `geometry_quality: detailed` | **10** |

`geometry_quality: detailed` doubles the price and was **not** used: the two
defects are prompt-level, and matching the v1 pipeline keeps the Ludo rig path
known-good and the A/B fair.

---

## The critical parameter R76 could not have known: `face_limit`

The twelve v1 t-pose meshes measure **~11.3k verts / ~19.5k tris, ~1.1 MB**
(`f06` 11,288 v / 19,318 t; `f08` 11,309 v / 19,604 t). Both sit just under
20,000 triangles, so **v1 was generated with `face_limit: 20000`**.

Submitting without it returns Tripo's native density: **~740k verts / ~1.45M
tris, ~40 MB** — 63x denser. That is unusable here for three separate reasons:

1. it exceeds the 10 MB browser file-upload cap used to feed Ludo;
2. a 740k-vert fighter cannot ship beside nine cleared fighters at 11k;
3. it would make the A/B unfair — surface differences would come from mesh
   density rather than from the prompt.

**`face_limit: 20000` is therefore a required parameter of this pipeline, not
an optional one.** It is recorded here because it is exactly the kind of fact
whose absence forced R76 to write prose instead of a diff.

### Attempt 1 — no `face_limit` (superseded, 10 credits)

| Fighter | Job id | Result |
|---|---|---|
| f06 | `34609684-1b51-4b1a-9328-261dc3aa42ca` | 739,974 v / 1,450,335 t, 41.6 MB — too dense to rig or ship |
| f08 | `1a1f590f-8e26-45be-af2b-8a8ab02d2bde` | 717,173 v / 1,406,856 t, 40.3 MB — too dense to rig or ship |

Prompts and negative prompts were identical to attempt 2 below.

These two were **not wasted**: before spending again, their embedded base-colour
textures and mesh geometry were inspected directly, which established that the
prompts fix the named defects independently of the seed. Evidence:

**Colour (from the embedded base-colour atlas, no render needed)**
- f06: warm mid-tone tanned skin, short dark hair, **black** open-finger
  gloves, solid dark shorts with no gradient.
- f08: warm tan skin with genuine colour variation — not chalk-white — dark
  hair, and **black** gloves and kit. No red anywhere.

**Build (mesh cross-sections, normalised by height; f05 is the fighter R76
kept as a correctly-built lightweight)**

| | chest area | waist area | upper-arm area | chest/waist |
|---|---|---|---|---|
| f05 v1 (kept, lightweight) | 0.02802 | 0.01574 | 0.00309 | 1.78 |
| f06 v1 (the defect) | 0.02779 | 0.01758 | 0.00343 | 1.58 |
| f06 attempt 1 | 0.03335 | 0.02010 | 0.00479 | 1.66 |

f06 v1 has **the same chest as the lightweight** — this is R76's "built like a
lean lightweight at light-heavyweight stature", measured rather than asserted.
The regenerated prompt adds **+20% chest and +40% upper arm against only +14%
waist**: a differential physique change, not the uniform scale that
`FighterPhysique.apply_girth` would have produced. This confirms R76's ruling
that girth could not have rescued f06.

Geometry axes for anyone repeating this: **Y is height, Z is arm span, X is
front-to-back depth.**

### Attempt 2 — with `face_limit: 20000`

| Fighter | Job id |
|---|---|
| f06 | `31366e13-30e1-4f52-8557-1666d940e7e4` |
| f08 | `61ad8f46-df75-4e3d-9748-44e5529f1386` |

Local decimation of the attempt-1 meshes was considered and rejected: no
Blender, `trimesh`, `pymeshlab` or `open3d` on this machine, and a 37:1
reduction would tear the UV seams — degrading the very textures under review.
A regeneration rolls a new seed, but the prompt (not the seed) is what fixes
the defects, as measured above.

---

## The exact prompts

Both are R76's verdict prompts, sent verbatim. The T-pose comes from the
prompt alone; the closing clause must not be deleted.

### f06 — m mma lhw

```
Athletic male mixed martial artist, light heavyweight, 1.90 m, 93 kg, heavily
muscled with broad shoulders and a thick chest and back, visible abdominal
definition, powerful thighs. Tanned mediterranean skin with warm mid-tone
colour, not pale. Short dark hair. Black open-finger MMA gloves, plain dark
fight shorts with a solid colour and no gradient. T-pose, arms horizontal,
fingers held together, barefoot.
```

`negative_prompt`: `pale waxy skin, slim build, thin arms, gradient shorts`

### f08 — f mma bantam

```
Athletic female mixed martial artist, bantamweight, 1.65 m, 61 kg, lean and
muscular with defined shoulders, arms and abdominals. Warm olive or light-brown
skin with natural colour variation, not pale or chalk-white. Dark hair pulled
back into a tight ponytail, not a solid helmet shape. Black open-finger MMA
gloves, dark fight shorts and a fitted top. T-pose, arms horizontal, fingers
held together, barefoot.
```

`negative_prompt`: `chalk white skin, plastic mannequin skin, helmet hair, red gloves`

### Full parameter set (both)

```
model:            tripo_3d
texture:          true
pbr:              true
texture_quality:  standard      # 'detailed' is 12.5 credits, not 5
face_limit:       20000         # REQUIRED — matches the v1 twelve
geometry_quality: (unset)       # 'detailed' doubles the cost to 10
auto_size:        (unset)       # does not give metres; normalises to a 1.0 box
```

---

## Rigging — Ludo Rig & Animate, web UI

Settings for both: **Rig type `Humanoid`, Joint naming `Godot (humanoid
profile)`**. 1 credit each. Ludo balance **8 -> 7 -> 6**.

| Fighter | Source mesh | Rigged result | Match | Ludo asset |
|---|---|---|---|---|
| f06 | 11,142 v / 19,412 t | **11,142 v / 19,412 t** | exact | `...-0e4038fb7b7c73174aabac7b9879303e.bin` |
| f08 | 11,175 v / 19,140 t | **11,175 v / 19,140 t** | exact | `...-1478fa355989e20a3645bf5ed41ddb60.bin` |

Both counts are unique across the roster (f06 v1 is 11,288/19,318, f08 v1 is
11,309/19,604), so the match proves each pull is the **new** mesh and not a
re-rig of the staged old one. That is the check the task demanded.

### Gate — `Godot/tools/probe_rig.gd`

Both **PASS**: 22 skeleton bones, **22 matched to `SkeletonProfileHumanoid` by
name**, **0 bones outside the profile**, `walk_relaxed` present, no BoneMap
required. The trailing `RID allocations ... were leaked at exit` lines are
teardown chatter on any scene-touching run, not failures.

### The Ludo traps, confirmed and handled

- **The staged Reference Model survives a full page reload.** After f06 rigged,
  the slot still read "Uploaded 3D Model". It was cleared and verified as
  "Choose Model" *before* f08 was staged. Dropping onto a filled slot silently
  re-rigs the old mesh — this is the expensive mistake, and it was avoided.
- **The UI does not refresh when a rig finishes** — reload `/3d-generator`
  before reading a result or you fetch the previous fighter.

### How to feed Ludo a mesh (new, worth keeping)

The Rig & Animate dropzone is a MUI `div`, **not** an `<input type=file>`, and
a synthetic `drop` event with a `DataTransfer` does nothing. What works:

1. Click `.initial-image-button` — this opens the "Upload 3D Model" modal,
   which is what actually mounts an `input[type=file]` into the DOM.
2. Set `input.files` from a `DataTransfer` and dispatch a bubbling `change`.

The mesh was **fetched in-page from its CloudFront URL** (`storage` CORS allows
a cross-origin GET), so nothing had to be read off local disk and the 10 MB
browser upload cap never applied.

Retrieving the result: `api.ludo.ai` cannot be called from the automation
context ("Failed to fetch" — isolated world). Use the UI instead: click the
newest grid video to open the model viewer, then read the fresh
`storage.googleapis.com/ludo-assets/*.bin` out of
`performance.getEntriesByType("resource")`. It is **gzipped glTF** — gunzip and
it is a plain `.glb`.

---

## Verdict

**Both fighters beat v1 on their named defects. Both promoted.**

### f06 — m mma lhw: **PASS**

| Defect (R76) | Outcome |
|---|---|
| Built like a lean lightweight | **Fixed.** chest +48%, upper arm +66% against waist +14%; chest/waist taper 1.87 vs 1.58 (kept lightweight f05 is 1.78) |
| Thin arms | **Fixed.** upper-arm cross-section 0.00570 vs 0.00343 |
| Soft undefined torso | **Fixed.** visible six-pack and pec separation in the front and 3q renders |
| Waxiest face, pale skin | **Fixed.** skin saturation 0.485 vs 0.381, warmth (R-B) +77.4 vs +65.6 |
| Dark bake gradient on the shorts hem | **Fixed.** solid charcoal shorts, no gradient |

Beside f05 the lightweight, f06 now reads as the heavier man its 1.890 m
stature always claimed. R76's ruling that girth could not fix this is
confirmed: the change is differential, not a uniform scale.

### f08 — f mma bantam: **PASS**

| Defect (R76) | Outcome |
|---|---|
| Chalk-white plastic skin, no subsurface warmth | **Fixed.** saturation 0.403 vs 0.296, warmth (R-B) +73.8 vs +56.5 |
| Doll-like face under a hard helmet of hair | **Fixed.** a real ponytail, clearly separated from the skull in the side and back renders |
| Red gloves breaking the MMA group's black kit | **Fixed.** strong-red texture pixels fall from **14,676/65,536 (22.4%) to 976 (1.5%)**; gloves, top and shorts are all black/charcoal |

Shape moved only slightly, as R76 predicted ("the shape is close"): waist -10%,
chest/waist taper 1.60 vs 1.41.

### No new defect introduced

Neither v2 brings a regression. One observation for the operator, **out of
scope for R77**: R76 justified f08 by "the MMA group's black kit", but the
group is not actually uniform — **f05 wears red shorts and f07 a blue top**,
and both are cleared fighters. f08 v2 now matches f07's black shorts rather
than breaking anything, so the remaining inconsistency belongs to f05 and f07.
Worth a follow-up decision; nothing here touches them.

### Cost

| | Spent | Balance |
|---|---|---|
| Higgsfield MCP | 20 credits (4 x `tripo_3d` at 5) | 50 -> 30 |
| Ludo rigging | 2 credits | 8 -> 6 |

10 of the 20 went on the attempt-1 pair generated without `face_limit`. That
was my miss — the v1 mesh density should have been checked before the first
submission. It was not a dead loss: those meshes established, before any
further spending, that the prompts fix the defects, and they are the reason
`face_limit` is now documented as a required parameter.

### Files

- `Downloads/fighters_rigged/` — f06 and f08 **promoted** to canonical.
- `Downloads/fighters_rigged_v1_superseded/` — the two v1 rigs, kept intact.
- `Downloads/fighters_rigged_v2/`, `Downloads/fighters_tpose_v2/` — v2 working
  set, including the two dense attempt-1 meshes.
- `previews/fighters/` — f06 and f08 `front/3q/side/back/posed`
  re-rendered from v2; contact sheets recomposited (no fighter re-rendered).
  **`_face` and `_hand` for f06/f08 are still v1**: those modes ignore `--only`
  and would have re-rendered all twelve, which this task forbids. Re-rendering
  them is a follow-up that needs an `--only` on those modes, i.e. a change to
  the render tool — deliberately not made here.

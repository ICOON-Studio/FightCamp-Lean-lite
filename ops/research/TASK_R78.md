# TASK R78 — CLAUDE — FIX f10's FACE BY RETEXTURING, KEEP THE BODY

**Owner:** claude
**Model:** Opus, effort **medium**, Fast **off**.
Reason: same shape as R77 — judgement plus a paid external pipeline. The
spending decision is a looking-and-deciding problem, and this task's first
gate is a free call on whether to spend at all.

**This is a browser + MCP session, not a build session.** Ludo's rigger is a
web UI. It gets its own session per the standing rule.

## Why this exists

R76 cleared nine of the twelve fighters, sent f06 and f08 back (done in R77,
both passed, commit `2cc9bc4`), and left f10 as a separate decision:

> **f10 | m bare heavy | needs work (face only)** — The best back in the roster
> on a genuinely heavy body, but the roughest face of the twelve — heavy folds
> and a mushy mouth. Reroll the head, keep the body.

R77's task file assumed "reroll a head while keeping a body" might be
impossible on this pipeline. **It is possible**, just not as a head swap.

### What the defect actually is

Looking at `previews/fighters/f10_m_bare_heavy_face.png`:

- a **pale vertical band of corrupted texture** running down the temple in
  front of the ear — this reads as a UV/atlas seam artefact, not geometry;
- a **blurred, mushy mouth**;
- heavy fold shading around the nose and brow.

The first is unambiguously a texture defect. That is what makes a retexture
the right instrument: it keeps the geometry — the heavy body and the best back
in the roster — **byte-for-byte**, and only re-bakes the surface.

**Operator decision (2026-09-09): go with the retexture route.** A full reroll
was considered and rejected, because it rolls a new body and throws away the
one thing R76 praised.

## The first gate is FREE — do it before spending anything

**Decide whether the mushy mouth is texture or geometry.** A retexture cannot
fix geometry. This costs nothing:

1. Extract the three embedded images from
   `C:/Users/user/Downloads/fighters_tpose/f10_m_bare_heavy.glb` (walk the
   glTF JSON chunk, read `images[].bufferView` out of the BIN chunk — the
   method is written out in `R77_REGENERATION.md`) and look at the head
   region of the base-colour atlas. If the pale temple band and the mouth
   blur are visible **in the atlas**, they are texture.
2. Check the head's vertex density — count vertices above ~0.88 of model
   height. Note the axes: **Y is height, Z is arm span, X is depth.**

- **Texture** → proceed, spend.
- **Geometry** → **STOP. Do not spend.** Report it and say a full reroll
  (`tripo_3d`, the R77 recipe, 5 credits) is the only remaining route and that
  it costs the good back. That is the operator's call, **not** an automatic
  fallback. Both outcomes are a complete result.

## Budget — checked and preflighted

| | Balance | This task |
|---|---|---|
| Higgsfield MCP | **30 credits** | retexture **9.5** |
| Ludo rigging | **6 credits** | re-rig **1** |

`meshy_v5_retexture` was preflighted at assignment: **9.5 credits, identical
with `enable_pbr` true or false.** Take `enable_pbr: true` — the other eleven
fighters carry three images (base colour + PBR maps) and dropping them would
make f10 read flat beside them.

`get_cost:true` preflight is **FREE — always price first.** Failed jobs are not
charged. Two retexture attempts (19) still fit inside 30; **stop at two.**

## The pipeline

### 1. Host the mesh — `media_upload`, free

`meshy_v5_retexture` needs `model_url` to be a **public URL**, not a media_id.
`.glb` is accepted: `media_upload(filename:'f10_m_bare_heavy.glb')` returns a
presigned S3 `upload_url` with `content_type: model/gltf-binary`, plus the
permanent CloudFront `url` to pass on. PUT the bytes yourself, then call
`media_confirm` with `type:"file"` and the returned `media_id`.

```bash
curl -X PUT -H "Content-Type: model/gltf-binary" \
     --data-binary @f10_m_bare_heavy.glb '<upload_url>'
```

The presigned URL expires in 24h. Upload the **unrigged t-pose** mesh
(`Downloads/fighters_tpose/f10_m_bare_heavy.glb`), not the rigged one — the
rig is re-applied afterwards, exactly as the twelve were built.

### 2. Retexture — `meshy_v5_retexture` via `generate_3d`

Parameters: `model_url` (required), `text_style_prompt`, `image_style_url`,
`enable_original_uv` (**leave true** — it reuses the source UVs, which is what
keeps this a surface-only change), `enable_pbr`, `enable_safety_checker`.

Write the prompt to target the named defect: a clean, well-defined mouth,
clean skin across the temple and jaw with no seam or banding, and moderated
fold shading around the nose and brow — while keeping a heavyweight
bare-knuckle fighter's weathered look. Do **not** ask for a different person;
this is the same fighter with a clean bake. **Record the exact prompt.**

### 3. Verify geometry survived — the identity gate

f10 is **11,411 verts / 19,806 tris** (identical in the t-pose and the rigged
file — Ludo preserves geometry exactly).

**The retextured mesh must come back at 11,411 / 19,806.** If it does not, the
retexture has remeshed and the whole premise is void: stop and report. This is
the R78 equivalent of R77's count check, and it is stronger — here the counts
must be *identical*, not merely traceable.

### 4. Re-rig — Ludo Rig & Animate, web UI, 1 credit

`3d_rigging` and `meshy_rigging` both refuse a non-Meshy mesh; settled dead
end, do not retry them. Settings: **Rig type `Humanoid`, Joint naming `Godot
(humanoid profile)`**.

**The full working mechanism is in `research/R77_REGENERATION.md` under
"How to feed Ludo a mesh" — read that section, it will save you an hour.** In
short: the dropzone is a MUI div with no `input[type=file]`; a synthetic drop
does nothing. Click `.initial-image-button` to open the "Upload 3D Model"
modal, which mounts the input, then set `input.files` from a `DataTransfer`
and dispatch a bubbling `change`. Fetch the mesh in-page from its CloudFront
URL — CORS allows it, so nothing is read off local disk.

**Two Ludo traps, both confirmed in R77:**
- The staged Reference Model **survives a full page reload**. Clear it and
  confirm the slot reads **"Choose Model"** before dropping, or you silently
  re-rig the previous mesh.
- The UI does not refresh when a rig finishes — reload `/3d-generator` before
  reading the result.

Retrieve the result through the UI: `api.ludo.ai` cannot be called from the
automation context. Click the newest grid video to open the model viewer, then
read the fresh `storage.googleapis.com/ludo-assets/*.bin` out of
`performance.getEntriesByType("resource")`. It is **gzipped glTF** — gunzip it.

### 5. Gate — `Godot/tools/probe_rig.gd`

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot \
    --script tools/probe_rig.gd -- "C:/Users/user/Downloads/fighters_rigged_v2/f10_m_bare_heavy_rigged.glb"
```

Hard pass/fail: 22 bones, 22 matched to `SkeletonProfileHumanoid` by name,
**zero** bones outside the profile, `walk_relaxed` present. No BoneMap is ever
written. `RID allocations ... were leaked at exit` is teardown chatter, not a
failure.

### 6. Render the A/B — and the trick that makes the face shot possible

**Back up the v1 renders first.** `OUT_DIR` is a hard-coded const
(`CaptureFighterRoster.gd:20`) with no `--out` flag, so a render overwrites in
place. Copy `f10_*.png` to the scratchpad before rendering or you lose the
comparison.

`--only` is honoured **only** by `roster` mode (`:269`, matched with
`begins_with`). `_do_face` (`:293`) and `_do_hands` (`:306`) loop the whole
ROSTER and would re-render all twelve — which this task forbids.

**The way round it, no tool change needed:** `_mount` builds its path as
`"%s/%s_rigged.glb" % [_src, id]` (`:136`) with **no fallback** — a missing
file prints `GLB FAILED` and the fighter is skipped. So point `--src` at a
directory containing **only f10** and `--mode face` renders f10 alone.

```bash
Godot_v4.7.2-stable_win64_console.exe --path Godot \
    --script tools/CaptureFighterRoster.gd \
    --rendering-method gl_compatibility --windowed \
    -- --mode face --src C:/Users/user/Downloads/fighters_rigged_v2
```

Run **without** `--headless` — the dummy rasterizer writes black frames; every
capture prints its mean luma so a black frame cannot pass silently. Also run
`--mode roster --only f10` from the same `--src` to confirm the body is
unchanged. Modes: `roster`, `face`, `hands`, `girth`, `lineup`, `sheet`,
`proof`. `sheet` only recomposites existing PNGs — it re-renders nobody, so
refresh the contact sheets at the end.

## The judgement — a ceiling, not a quota

Compare v2 against v1 **on f10's named defect only**: the temple seam, the
mouth, the fold shading. The body must be unchanged — that is the point.

- **Beats v1 on the face** → promote to `Downloads/fighters_rigged/`, keeping
  v1 in `Downloads/fighters_rigged_v1_superseded/` as R77 did. Say what it cost.
- **Does not beat v1** → **keep v1 and say so.** A lateral move is not a pass.
- **Fixes the face but degrades the body texture** → say that plainly and
  leave the decision to the operator. This is the realistic failure mode here:
  a retexture re-bakes the *whole* surface, so the body's appearance can shift
  even though its geometry cannot. **Check the back explicitly** — it is the
  thing R76 praised.

A second attempt is fine if the first misses narrowly. **Stop at two and
report.** Both failing, one failing, or both passing are all complete results.

## Record the prompt with the file

Write the exact prompt, every parameter, the job ids and the Ludo asset hashes
into `research/R78_RETEXTURE.md` **as you go, failures included.** R76
found the twelve original prompts had never been written down anywhere; R77
fixed that for f06/f08 and discovered `face_limit: 20000` is a required
`tripo_3d` parameter. Do not restart the rot.

## Owned files

- `research/R78_RETEXTURE.md` — the log and the verdict (new).
- `previews/fighters/` — **f10 only**, plus the recomposited
  contact sheets. Do NOT re-render the other eleven.
- `Downloads/fighters_rigged_v2/`, `Downloads/fighters_tpose_v2/` — outside
  the repo, not committed.

Do NOT edit `research/R76_FIGHTER_REVIEW.md`,
`research/R77_REGENERATION.md`, `CaptureFighterRoster.gd`,
`probe_rig.gd` or `FighterPhysique.gd`. If the pipeline needs a code change,
that is scope creep: name it as a follow-up and stop.

### File sizes, so you do not open the wrong thing

- `Godot/tools/CaptureFighterRoster.gd` — **485 lines.** Do not read it whole;
  the anchors above (`:20`, `:136`, `:269`, `:293`, `:306`) are all you need.
- `Godot/tools/probe_rig.gd` — 103 lines, small enough to read whole.
- `research/R77_REGENERATION.md` — 266 lines, read the **Rigging**
  section.
- `GameState.gd` is ~13k lines and is **not** part of this task. Do not open it.

## Gate

No suite run — this ships a mesh, images and a document. If you touch any `.gd`
file at all, parse-gate it: `python Godot/tools/check_scripts.py <file>`.

## The trap

**Spending is irreversible and preflight is free.** The first gate is free and
decides whether to spend at all — do not skip it because the answer feels
obvious. Then: price every call with `get_cost:true`, confirm the Ludo slot
reads "Choose Model" before the drop, and verify the retextured mesh is
**exactly 11,411 / 19,806** before paying to rig it. The most expensive mistake
available is rigging a mesh that was quietly remeshed, then judging the face on
a body that is no longer the one R76 praised.

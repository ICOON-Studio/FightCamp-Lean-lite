# TASK R77 — CLAUDE — REGENERATE f06 AND f08

**Owner:** claude
**Model:** Opus, effort **medium**, Fast **off**.
Reason: judgement plus a paid external pipeline. The generation is two API
calls; the risk is spending credits on a lateral move, and that is a
looking-and-deciding problem.

**This is a browser + MCP session, not a build session.** Ludo's rigger is a
web UI. Give it its own session per the standing rule.

## Why this exists

R76 looked at the twelve fighters and cleared nine. Two failed on grounds that
a prompt can fix, and this task spends 12 credits fixing them.

- **f06 (m mma lhw)** — built like a lean lightweight at light-heavyweight
  stature. 93 kg on paper, thin arms, soft undefined torso. Also the waxiest
  face of the twelve and a dark bake gradient on the shorts hem.
- **f08 (f mma bantam)** — chalk-white plastic skin with no subsurface warmth,
  a doll-like face under a hard helmet of hair, and **red gloves that break the
  MMA group's black kit**.

`FighterPhysique.apply_girth` cannot rescue either. R76 established that girth
is a fine-tuning effect (±12% trunk), not a body-type system — f06 needs a
different mesh, not a bigger number.

**f10 is NOT in this task.** It needs a head reroll only and its body is the
best back in the roster; it is a separate decision because "reroll a head while
keeping a body" may not be possible on this pipeline. Do not touch it here.

## Budget — checked, it is funded

MCP balance at assignment: **50 credits**, plan `plus`. Two fighters cost
**10** (2 x `tripo_3d` at 5). Ludo rigging is **1 credit each** on a separate
Ludo account that held ~20 before the twelve were rigged — verify it has at
least 2 before starting.

`get_cost:true` preflight is **FREE — always price first.** Failed jobs are not
charged. Do NOT set `texture_quality: detailed`; that is 12.5, not 5.

## The pipeline (this is the only chain that works)

1. **Mesh — `tripo_3d` via `generate_3d`.** Confirmed still live at assignment:
   `models_explore(action:'get', model_id:'tripo_3d')` returns **"Text to 3D"**
   with `medias: []`, so it is text-only and takes a `prompt`. **The generic
   `generate_3d` tool description claims only `sam_3_3d` accepts a prompt —
   that is wrong for this model. Do not let it derail you.** Useful parameters:
   `negative_prompt`, `texture`, `pbr`, `texture_quality` (leave `standard`),
   `geometry_quality`, `face_limit`, `auto_size`.
   `auto_size:true` does NOT give metres — it normalises to a 1.0 box. Real
   scale comes from the rig and from `FighterPhysique` at import. Leave it off,
   as the twelve did.
   The T-pose comes **from the prompt alone**. Both prompts below say so
   explicitly; do not delete that clause.
2. **Rig — Ludo Rig & Animate, web UI, 1 credit.** `3d_rigging` and
   `meshy_rigging` BOTH refuse a Tripo mesh (they will not take another
   vendor's mesh, and they fail in seconds with no error text). Do not retry
   them; that is a settled dead end.
   **Two Ludo traps that have already cost a credit each:**
   - Ludo **reuses the staged Reference Model**. Dropping a new file onto a
     filled slot silently re-rigs the OLD one. Click the trash icon first and
     confirm the slot reads "Choose Model", then drop.
   - Ludo's UI **does not refresh when a rig finishes** — the job counter
     sticks at 1. Reload `/3d-generator` before reading the result or you fetch
     the previous fighter. **Verify every pull by vert/tri count against the
     mesh it came from.** That is what caught a duplicate f01.
   The rigged GLB comes from the model viewer: the page loads it as a gzipped
   `.bin` from `storage.googleapis.com/ludo-assets/`, findable with
   `performance.getEntriesByType("resource")`. Gunzip it and it is plain glTF.
3. **Gate — `Godot/tools/probe_rig.gd <path.glb>`.** Hard pass/fail: 22 bones,
   22 matched to `SkeletonProfileHumanoid` BY NAME, ZERO bones outside the
   profile, and the `walk_relaxed` clip present. No BoneMap is ever written.

## The prompts

Send these as written. They are the R76 verdict's prompts and each one targets
the named defect.

**f06 — m mma lhw**
```
Athletic male mixed martial artist, light heavyweight, 1.90 m, 93 kg, heavily
muscled with broad shoulders and a thick chest and back, visible abdominal
definition, powerful thighs. Tanned mediterranean skin with warm mid-tone
colour, not pale. Short dark hair. Black open-finger MMA gloves, plain dark
fight shorts with a solid colour and no gradient. T-pose, arms horizontal,
fingers held together, barefoot.
```
`negative_prompt`: `pale waxy skin, slim build, thin arms, gradient shorts`

**f08 — f mma bantam**
```
Athletic female mixed martial artist, bantamweight, 1.65 m, 61 kg, lean and
muscular with defined shoulders, arms and abdominals. Warm olive or light-brown
skin with natural colour variation, not pale or chalk-white. Dark hair pulled
back into a tight ponytail, not a solid helmet shape. Black open-finger MMA
gloves, dark fight shorts and a fitted top. T-pose, arms horizontal, fingers
held together, barefoot.
```
`negative_prompt`: `chalk white skin, plastic mannequin skin, helmet hair, red gloves`

## Do not overwrite v1

Keep both originals. Write the new meshes to **`Downloads/fighters_rigged_v2/`**
under the SAME canonical ids (`f06_m_mma_lhw_rigged.glb`,
`f08_f_mma_bantam_rigged.glb`) so the render tool can point at them with
`--src` and produce a directly comparable A/B:

```
Godot_v4.7.2-stable_win64_console.exe --path Godot \
    --script tools/CaptureFighterRoster.gd \
    --rendering-method gl_compatibility --windowed \
    -- --mode roster --only f06 --src C:/Users/user/Downloads/fighters_rigged_v2
```

Run WITHOUT `--headless` — the dummy rasterizer writes black frames, and every
capture prints its mean luma so a black frame cannot pass silently. Modes:
`roster`, `face`, `hands`, `girth`, `lineup`, `sheet`, `proof`.

Promote a v2 to the canonical `Downloads/fighters_rigged/` **only after** it has
beaten v1 on its named defect.

## The judgement — a ceiling, not a quota

For each fighter, compare v2 against v1 on **its own named defect**:
f06 on build-for-division and skin warmth; f08 on skin, hair silhouette and
glove colour.

- **Beats v1 on the defect** → promote it, and say what it cost.
- **Does not beat v1** → **keep v1 and say so.** Do not ship a lateral move to
  make the task look finished. A second attempt on one fighter is fine if the
  first missed narrowly; stop at two attempts per fighter and report.
- **Beats v1 on the defect but introduces a new one** → say that plainly and
  leave the decision to the operator.

Both may fail, one may fail, both may pass. Any of those is a complete result.

## Record the prompt with the file

R76 found the twelve original prompts were **never written down anywhere** —
not in `HANDOFF.md`, not in `research/`. That is why its regenerate list
had to be self-contained prose instead of a diff. **Do not repeat it.** Write
the exact prompt, `negative_prompt`, every parameter and the job id into
`research/R77_REGENERATION.md` as you go, for both attempts and failures.

## Owned files

- `research/R77_REGENERATION.md` — the log and the verdict.
- `previews/fighters/` — v2 renders only; do not re-render or
  overwrite the nine cleared fighters.
- `Downloads/fighters_rigged_v2/` and `Downloads/fighters_tpose_v2/` — outside
  the repo, not committed.

Do NOT edit `research/R76_FIGHTER_REVIEW.md`, the render tool, or
`FighterPhysique.gd`. If the pipeline needs a code change, that is scope creep:
name it as a follow-up and stop.

## Gate

No suite run — this ships meshes, images and a document. If you touch any `.gd`
file at all, parse-gate it: `python Godot/tools/check_scripts.py <file>`.

## The trap

**Spending is irreversible and preflight is free.** Price every call with
`get_cost:true` before submitting, and confirm the Ludo slot is empty before
every drop. The single most expensive mistake available here is re-rigging the
old mesh because the slot was still full, then judging v2 by looking at v1.
Verify the vert/tri count of every pull against the mesh it came from.

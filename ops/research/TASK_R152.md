# TASK_R152 — MINE "MANIQUÍ STUDIO 3D": BODY VARIETY, AND WHOEVER ELSE SOLVED OUR PROBLEMS

**Owner:** Claude (BROWSER-ONLY — see the access note; a shell agent cannot do this today)
**Effort:** a session · **Model:** Opus 5, high · **Fast:** off
**Origin:** the operator sent `https://perchance.org/hpawvvak4e` on 2026-09-21 with the words
**"the body variety, and maybe copy the grip consistency or whatever else we struggle"**.

**Test tier: RESEARCH, no `.gd` touched. NO parse gate, NO test.** `git status -s` before staging
is the whole check. If it turns into code, that is a different task.

---

## WHAT IT IS, ALREADY ESTABLISHED — DO NOT RE-DERIVE THIS

A browser mannequin studio built on three.js, hosted as a Perchance generator. Read off the live
page on 2026-09-21:

- **8,548 vertices · 13,743 triangles · a 65-bone skeleton · 143 animations.** The `$meta`
  description says 53; the UI says 143. **That discrepancy is itself worth resolving** — it
  probably means the built-in set was extended, and by what is the provenance question.
- The base model is named **`ual.glb`** (from the source header: "visor, editor y exportador del
  maniquí ual.glb").
- **Body morph sliders:** Grosor (thickness), Músculo, Pecho, Cintura, Caderas, Hombros, plus
  TAMAÑO for Cabeza and Cuello. All default "Normal".
- **Exports `.glb`**, saves/loads `.json` presets, and has a WASD "modo juego".
- Animation categories seen: REPOSO (including **Pose en T**), AGACHADO, SIGILO, COMBATE,
  locomotion, flying. **COMBATE is four boxing entries** — Cruzado de boxeo, Gancho de boxeo,
  Puñetazo cruzado, Puñetazo recto.

## WHY IT IS WORTH A SESSION, AND IT IS NOT THE ANIMATIONS

**The animations are thin for us** — four boxing strikes against a catalogue we already exceed,
and it is single-actor, so it cannot touch the paired holds that S31 and S32 exist to build. Do
not propose it as a content source.

**The SOURCE is the prize.** The generator's `src/` is public ("these files are viewable by
visitors · 23.1MB / 2GB") and the file list is:

| file | size | why we care |
|---|---:|---|
| `rigfit.js` | **65.6 KB** | fitting a rig — the biggest file after `app.js` |
| `player.js` | 35.2 KB | playback |
| `retarget.js` | **22.7 KB** | **retargeting, which our own record calls the bottleneck** |
| `isotipo.js` | 19.1 KB | the logo/decal projection onto a body |
| `config.js` | 13.1 KB | |
| `body.js` | **12.5 KB** | **the body morphs — what the operator asked for** |
| `clipgen.js` | 11 KB | clip generation |
| `skeleton-rest.js` | **10 KB** | **rest-pose handling — exactly what U114 had to reason out** |
| `library.js` | 6.6 KB | |
| `bone-names.js` | **6 KB** | **a bone name map — what U114 just hand-wrote as `CASCY_TO_UE4`** |
| `app.js` | 168 KB | the shell |
| `README.md` | **142 KB** | a README that size is documentation, not a note |
| `animations/`, `image/`, `models/`, `tools/`, `vendor/` | | `vendor/` is three.js, held locally |

## THE THREE QUESTIONS, IN PRIORITY ORDER

**1. BODY VARIETY — how does `body.js` do it?** Morph targets baked into the GLB, or runtime
bone scaling, or mesh deformation? **The answer decides whether it is reachable for us at all**,
because our fighters are Tripo-generated rigged GLBs and almost certainly carry no blend shapes.
Report the mechanism, then say plainly what it would take to get the same axis on OUR fighters —
and if the honest answer is "re-generate the fighters with morphs", say that.

**2. "GRIP CONSISTENCY" — what the operator actually pointed at.** The clue is the rest animation
**"Reposo: con antorcha"** (rest, holding a torch): something keeps a hand on a prop across
animations. Find the mechanism in `player.js` / `rigfit.js`. **Then answer the question we
actually have:** does it generalise from a hand-on-a-prop to **a hand that stays on the other
fighter's body through a hold**? That is the S31 clinch's whole problem and the defect C140
retracted a wrong diagnosis for — the paired join is a POSE MISMATCH, and a live contact
constraint is one of the few things that could fix it.

**3. `retarget.js` + `bone-names.js` + `skeleton-rest.js` versus ours.** We spent 2026-09-21
discovering by hand that a skinned glTF puts its bones on a `Skeleton3D`, that a source rig needs
its own name map, and that the reference must be the source's own rest. **Someone else solved all
three in 38 KB.** Read what they do differently — especially anything about rest-pose mismatch
between source and target, which is where our quality actually leaks.

## ACCESS — READ THIS BEFORE YOU PLAN THE SESSION

**The files are browser-readable and NOT shell-fetchable from here.** Measured 2026-09-21:
`https://1c4a1aee2f720abc02b69d31b6f048a0.perchance.org/hpawvvak4e/src/<file>` returns 404
("Cannot GET"), with and without a Referer and a browser User-Agent; other path guesses 403.
The route that works is the Perchance editor UI: open `https://perchance.org/hpawvvak4e`, click
**edit** (top right), then the **files** button at the bottom left, then a file — it renders in
the editor pane and can be read out of the DOM, which is same-origin.

**So this is Claude's with the in-app browser, or Grok's — and Grok is OUT OF CREDITS.** Do not
assign it to Cursor, Codex or Qwen expecting a `curl` to work. **If you find a fetchable URL,
record it in the digest and the task becomes assignable** — that is worth ten minutes up front.

## THE LICENCE QUESTION, WHICH GATES USING ANYTHING

The page names no licence, no author and no source. A 65-bone rig with 143 animations and a
`ual.glb` came from somewhere. **We may read it for technique regardless** — reading how someone
solved a problem is not taking their asset — **but nothing is copied into the repo without a
licence**, and our manifest requires a source and a licence per pack. Keep the two apart in the
digest: TECHNIQUE (free to learn) and ASSETS (not without provenance).

## DELIVERABLE

`research/R152_MANIQUI_STUDIO.md` — the three answers, each with the file and the mechanism
named, and a closing section that says for each of the three whether it is **worth copying, worth
adapting, or not applicable to us**, with the reason. No code changes in this task.

## THE TRAP

**Do not come back with a description of the app.** We know what it does; the screenshots are in
the session record. The deliverable is the MECHANISMS and whether they transfer. A digest that
says "it has body sliders and exports GLB" has spent a session confirming the first five minutes.

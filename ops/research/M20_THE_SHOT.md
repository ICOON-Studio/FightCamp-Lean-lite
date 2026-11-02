# M20 — THE SHOT

**Maria Art Director · 2026-09-11 · art only** (no `.gd` / `.tscn` / assets/data / prices / anim graph)

> **Provenance.** Collected 2026-09-20 by Claude from the Grok Bot group chat with
> `Tools/grokbots/grokbots.py read --to "Maria Art Director" --out`. Maria delivered this as an
> attachment named `M20_THE_SHOT.md` plus five boards; the attachment was never reachable from a
> cloud session, which blocked S7 for nine days. **The text below is the attachment's content as
> Maria posted it in the room** — tables re-formed as markdown where the chat transcript flattened
> them, wording otherwise verbatim. **The five boards `m20_01…m20_05` are IMAGES and are NOT here**
> — they live in the Maria 1:1 chat (rooms cannot attach images) and are still to be collected when
> S7 needs them. Nothing in this file is measured by this repo except where the label says so.

Standing fight, first operator watch, one static camera. Q55 numbers were for a ground pair; this
pack frames two men standing. Boards: `m20_01…m20_05` (also in Maria 1:1 — rooms can't attach images).

## DECISIONS

- **Establishing does NOT survive.** Q55 `(0, 1.80, 2.60)` / `look_at` 0.35 / fov 42 is ground-fight
  scale — too close, `look_at` too low, too much floor, heads wrong for uprights. Replace with
  **M14 HOME** (INHERITED): eye 3.8–4.2 m / FLOOR, stand-off 9–11 m, pitch −20…−22°, fov 50°,
  `look_at` pair mid-torso (deck + ~1.0 m). Camera must be told **RING deck 1.2700 m vs CAGE
  0.1300 m** (MEASURED) — eye is above FLOOR, not "above canvas alone."
- **Always in frame:** both fighters' full silhouettes (H2T preferred; mid-thigh-up OK if headroom
  holds), headroom above the taller, stance bases readable, pocket between them. **Never:** crop the
  HW head; lose the 66.7 kg man in eclipse; dead-on depth stack; face/glove inserts as the shot.
- **Depth axis (load-bearing):** elevated front three-quarter with slight lateral offset so two
  postage-stamp silhouettes stay separable. Dead-front or dead-side stacks them into one blob —
  worse than no camera. (INVENTED VISUAL JUDGMENT under M14 + M16.)
- **Locked off static for this week.** No drift, no re-frame, no follow. One camera, held.
  Continuous follow and circle-only already refused (M18 INHERITED). Footwork later does not reopen
  this.
- **Lighting for silhouette:** Decal blob shadow = most (grounds feet, separates pair from deck).
  SSAO = second only while HOME is elevated (contact visible); skip as primary from low mat cams.
  Height fog = least for the silhouette problem — atmosphere only, not worth GPU for Q3. Key+fill
  stay; Decal is the add.
- **First wrong in ~10 s:** Q55-scale crop / toy close-up or depth eclipse of the small fighter into
  the big one. Cheapest hide: type M14 HOME numbers + slight lateral offset + Decal — not a third
  exit, not CLAIM-TIGHT.

Also **refuse for live standing**: Q55 tight and low mat-level as the week's camera (mat-level =
M15 KD territory only, not live HOME).

## Boards

| Board | Answers |
|---|---|
| `m20_01_establishing` | Q1 — Q55 ground REJECT vs M14 HOME HOLD |
| `m20_02_always_never` | Q2 — mismatched 66.7 vs 120 kg |
| `m20_03_depth_axis` | Q3 — separable vs blob |
| `m20_04_typeable_home` | typeable numbers + RING/CAGE |
| `m20_05_light_first_wrong` | Q5–Q6 |

## §1 — Does establishing survive? (Q1)

**No.** (INFERENCE on Q55 table + INVENTED judgment for standing.)

Q55 establishing was derived for two bodies lying down, ~1.6 m long (task: INFERENCE, broadcast MMA
specs NOT FOUND). Eye at 1.80 m, `look_at` 0.35 m, stand-off 2.60 m, fov 42 points a near camera at
the mat. Standing boxers: heads ~deck + 1.7–1.9 m → on RING ~3.0–3.2 m abs. That shot either crops
heads, fills with floor, or flattens them into a diorama.

**What it becomes — typeable HOME** (INHERITED M14, confirmed M18):

| Param | Value | Label |
|---|---|---|
| Eye | 3.8–4.2 m above FLOOR | INHERITED M14 |
| Stand-off | 9–11 m front, outside apron | INHERITED M14 |
| Pitch | −20…−22° | INHERITED M14 |
| fov | 50° (same dial family as preview 38) | INHERITED M14 |
| `look_at` | Pair center, mid-torso ≈ deck + 1.0 m | INVENTED aim under HOME |
| Deck | RING 1.2700 m / CAGE 0.1300 m | MEASURED (task) |
| Motion | Locked off | INHERITED M18 |

Changed from Q55: position (pull back + raise), `look_at` (lift off mat), fov 42→50, pitch made
explicit. Why: upright silhouettes + M16 postage-stamp read + OVER ropes.

## §2 — Always / never (Q2)

Test pair 66.7 kg vs 120 kg (task). Frame must hold welter + heavy without the small one
disappearing.

**Always:** both silhouettes; headroom above taller; stance bases; pocket air between bodies.

**Never:** HW head crop; welter lost in eclipse; stacked blob; face/glove insert as the establishing
shot. (INVENTED under M14 framing + M16 "face dead at 10 m.")

## §3 — Depth axis (Q3) — most important

M16: whole-body silhouette survives; glove/face dead (INHERITED).

If silhouette carries the fight, the camera must keep **two shapes, not one merge**.

- Dead-front along the line of the pair → depth stack → blob.
- Dead-side → same when they face in.
- **Elevated front-¾ + slight lateral offset → two readable stamps + pocket.**

A shot where the near man eclipses the far man every exchange is **worse than no camera**.
(INVENTED VISUAL JUDGMENT.)

| | Camera | Result |
|---|---|---|
| **Separable** | Front 3/4 + offset | Two silhouettes |
| **Blob** | Dead-front | One silhouette |
| **Blob** | Dead-side | One silhouette |

## §4 — Static or not (Q4)

Locked off is correct for now. Engineer has one week, no shot-switcher. Beats ~1.1 s, clips
0.7–1.2 s, no cutting (task). M18 refused continuous follow and circle-only (INHERITED). Slow drift
not required this week. When footwork lands, revisit re-frame — not this slice.

## §5 — Lighting (Q5)

Exist: key + fill. Available tools: Decal blob, SSAO, height fog (prior study DOCUMENTED; not on).

| Tool | For Q3 silhouette | Verdict |
|---|---|---|
| Decal blob | Grounds feet, separates pair from deck | **MOST — turn on** |
| SSAO | Contact crease if elevated HOME sees floor meet | Second; known fail on very low cams |
| Height fog | Softens horizon, not pair separation | Least for Q3 — skip for silhouette |

(INFERENCE on tool roles + INVENTED priority for this shot.)

## §6 — First wrong (Q6)

**Predict:** within ten seconds the operator sees either heads cropped / toy close Q55 framing, or
the small fighter eclipsed into the heavyweight.

**Why:** Q55 scale + depth stack on mismatched pair.

**Cheapest hide:** M14 HOME numbers + lateral offset + Decal. Not a purchase, not a third exit.
(INVENTED prediction — same discipline as M18 foot-slide.)

## Label index

| Claim | Label |
|---|---|
| Deck 1.2700 / 0.1300 m | MEASURED (task) |
| Q55 table | INFERENCE (Q55); broadcast specs NOT FOUND |
| M14 HOME numbers | INHERITED |
| M16 silhouette / face dead | INHERITED |
| M18 no follow / no circle cam / ≤15 cm skate | INHERITED |
| ¾ + offset separable | INVENTED VISUAL JUDGMENT |
| Decal > SSAO > fog for Q3 | INFERENCE + invent priority |
| First-wrong prediction | INVENTED |
| Live use of Q55 tight / mat-level | REJECT (art) |

## Art only — engineer takeaway

Type M14 HOME against FLOOR, switch `look_at` to standing mid-torso, offset for two silhouettes,
lock off, add Decal, do not ship Q55 establishing/tight/mat as the standing live camera.

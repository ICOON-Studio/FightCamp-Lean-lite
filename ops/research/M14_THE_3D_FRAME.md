# M14 — THE 3D FRAME (REAL CAMERA IN A REAL RING)

Maria Art Director · 2026-09-10 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

Cage Desk continuity. Extends M13 (wide+HUD carry the fight; HUD = second camera; tight = CLAIM only). Grounded in G43 (broadcast Cam-1 grammar), R94 (deck 1.27 m, in-place clips), arena_specs rope heights. Faces/skin of the 12 are a known defect — **frame only; no face fixes.**

## DECISIONS

1. **HOME:** elevated front-of-ring Cam-1 — **NOT** isometric diorama. `Camera3D.fov=50°`, pitch **−20…−22°**, eye **3.8–4.2 m** above FLOOR (~2.5–2.9 m above canvas), stand-off **9–11 m** front axis outside apron, aim ring center.
2. **ROPES:** shoot **OVER** near ropes (eye above top-rope plane ≈2.64 m abs). Near ropes kiss bottom / soft vignette; mid/far stay true. Refuse hide; refuse chest-cut through torsos as default.
3. **MOTION:** **fixed home** for live beat. Only **KD frame** + **CLAIM-TIGHT** may leave. No punch-truck, stun-zoom, or continuous follow.
4. **SECOND ANGLE (exactly one):** CLAIM-TIGHT — eye **1.6–1.8 m** above canvas, FOV **35–40°**, trigger = engine contact quality worth claiming; labelled/brief; return wide.
5. **KD:** on engine KD, cut (or ≤0.35 s push) to **ref+count subject**; fallen = consequence; hold count shape; return wide on stand/stoppage plate. No multi-angle mid-count. Duration → J15 later.
6. **SLIDE MASK:** elevated ¾ compresses ground travel; mid-thigh-up torso weight; FOV 50° + 9–11 m stand-off; avoid side-on / worm’s-eye; do not cut on every slide.
7. **LIGHTS:** overhead **key cluster** (hard, center) + **two corner fills** + **canvas bounce** + dim arena ambient — retire 1key+1fill.
8. **TOKENS:** M13 map stands — GYM_DEFAULT / LINK / BAD / AMBER / GOOD / TRACK / PANEL / TEXT. No SELECT. GOLD verdict-only. SODIUM off HUD.
9. **FOV WARNING:** ~19° (½ of 38°) and ~76° (2×) both break — telephoto dolls / fisheye+slide. Leave preview 38°.
10. **OPEN:** (a) brief said “horizontal” FOV — Godot default `keep_aspect=KEEP_HEIGHT` makes `fov` **vertical**; type **50 on the dial** matching preview’s 38. (b) G43 density-tighten absorbed into CLAIM-TIGHT, not a third live push. (c) K19 iso replaced for real 3D bodies.

---

## Boards

| Board | Answers |
| --- | --- |
| `m14_01_wide_as_camera.png` | Q1 — home lens + typed numbers |
| `m14_02_fov_protects.png` | Q1 — 19 / 38 / 50 / 76 protect/break |
| `m14_03_ropes.png` | Q2 — over / through / hide / accept; HOLD=over |
| `m14_04_fixed_home.png` | Q3 — fixed vs exits; HUD saving |
| `m14_05_claim_tight.png` | Q4 — the one second angle + trigger |
| `m14_06_knockdown.png` | Q5 — KD frame shape |
| `m14_07_slide_mask.png` | Q6 — hide the glide |
| `m14_08_lighting.png` | Q7 — light plot vs 1+1 |
| `m14_09_rejects.png` | MOST IMPORTANT — what not to try |
| `m14_10_composed.png` | Quiet live with number callouts |

---

## §1 — Wide as a lens (Q1)

**Call:** home is broadcast **Camera-1** (G43 / Tugman): elevated, front of ring, both fighters head-to-toe. The preview’s single fixed **isometric 38°** is a placeholder that flattens stature into a diorama and must not ship.

### Typeable numbers (HOME)

| Parameter | Value | Protects |
| --- | --- | --- |
| `Camera3D.fov` | **50°** | Stature + slide compression vs 38° |
| Pitch (look-down) | **−20° to −22°** | OVER ropes; ¾ compression of ground plane |
| Eye height | **3.8–4.2 m above FLOOR** | Clears top-rope plane; not “above canvas” alone |
| Above canvas | **~2.53–2.93 m** | canvas = FLOOR + **1.27 m** (R94 / brief) |
| Stand-off | **9–11 m** from ring center | Front axis, **outside apron** |
| Aim | Ring-center XY on contest square | Both fighters framed |
| Framing weight | Both H2T; mid-thigh-up OK | Torso read; foot skate peripheral |

**Godot note (open disagreement with brief wording):** the brief said “horizontal Godot Camera3D fov.” Under default `keep_aspect=KEEP_HEIGHT`, `Camera3D.fov` is the **vertical** FOV. Preview “38°” is that dial. **Type 50 on the same dial.** Do not silently convert to a 50° horizontal unless keep_aspect is changed — that would reopen the compare set.

### Half FOV / 2× FOV

| Dial | vs 38° | Breaks / protects |
| --- | --- | --- |
| **~19°** | half | Telephoto squash; slide magnified; ropes dominate; toy dolls |
| **38°** | preview | Still flattens; leave |
| **50°** | HOLD | Stature recovers; slide compresses; ropes manageable |
| **~76°** | ~2× | Fisheye bow; edge stretch magnifies slide; apron/HUD collision |

**Do not** compensate a wrong FOV with punch-truck or continuous follow — fix dial + stand-off first.

**vs K19:** K19 picked iso spectacle for sprite stage. Real rigged bodies + true deck want G43 Cam-1. Argue in the open: iso is replaced, not refined.

---

## §2 — Headroom vs ropes (Q2)

**HOLD: shoot OVER near ropes.**

Geometry (Florida rope set in `arena_specs.json`, deck from R94/brief):

- Deck / canvas height: **1.27 m** above FLOOR (built preview). Florida admin “platform ≤ 4 ft” ceiling in specs is **1.2192 m** — design to the **built 1.27**.
- Four ropes at 18 / 30 / 42 / **54 in** above canvas → top rope **1.3716 m** above canvas → **≈ 2.64 m** above FLOOR with deck 1.27.
- HOME eye **3.8–4.2 m** clears top-rope plane by **~1.2–1.6 m**.

| Option | Verdict |
| --- | --- |
| **OVER** | **HOLD** — near ropes kiss bottom frame / soft vignette; mid/far stay as true ring; broadcast-true |
| THROUGH | REJECT as default — chest-cut torsos; silhouette broken |
| HIDE | REJECT — deletes ring truth; platform not fight |
| ACCEPT | NOT DEFAULT — ropes mid-frame always; rare forced cue only |

**Cage note (G43):** mesh is a different optical problem (FenceCam). Do not import cage-delete as ring-hide. Boxing home = over ropes.

---

## §3 — When the camera moves (Q3)

**HOLD: fixed home for the live beat.**

M13 already ruled the HUD is the second camera. That is the large saving: Cam-1 does not need to truck, follow, or chop on every impact. G43 §5: permission to stay — first-time directors chop; we will look like one if we cut every undrawn impact.

**May leave home (exactly two exits):**

1. **CLAIM-TIGHT** — see §4  
2. **KD frame** — see §5  

**Never move for:** punch impact / glove follow; stun without engine stun; continuous fighter track; density push without scored claim; apron-to-apron / jib walk (no referee geometry yet — G43 §4).

**Open vs G43:** “tighten because exchange density went up” is usable as a distance fact. We **absorb** that into CLAIM-TIGHT when quality is scored, rather than inventing a third live push. Pocket without claim stays on the HUD chip + wide body language.

---

## §4 — The one second angle (Q4)

**Name: CLAIM-TIGHT.** Exactly one. Not a set. Not a replay package.

| Parameter | Value |
| --- | --- |
| Height | **1.6–1.8 m above canvas** (~2.87–3.07 m above FLOOR) |
| FOV | **35–40°** on same dial family as HOME |
| Framing | Mid-thigh → head; **both** still visible; no face insert |
| Trigger | Engine writes **contact quality worth claiming** (ledger already scored) |
| Presentation | **Labelled** (LINK candour chip); brief; ease/cut back to HOME |
| Off | Glance / miss / wrong region / density alone |

G43 one-sentence line stands: *Wide, corner, labelled replay, and the HUD are summaries. Tight contact is a CLAIM. We may only make the claims the engine already made.*

Between-round LABELLED HIGHLIGHT remains M13 crescendo 3 — not this live angle.

---

## §5 — Knockdown frame (Q5)

**Shape now; fit duration to J15 clock later.**

1. Do **not** smash-zoom the punch. Leave home only after **engine KD**.
2. Transition: prefer **hard cut**; allow **≤0.35 s push** if a hard cut reads as a bug.
3. **Subject = referee body + count numeral.** Fallen fighter is the **consequence** in-frame — not a mat-cam fantasy.
4. Hold through the **count shape**; no multi-angle mid-count.
5. Return to wide on stand, or exit to stoppage plate (M13) then labelled replay later.
6. HUD already carries KD mark (`BAD`) + accumulation — picture does not invent the punch.

G43 §4 honesty: we may lack full referee state/position nouns. Still frame the **procedure** as subject when KD exists; do not invent ref geometry beyond the count beat.

---

## §6 — Slide masking (Q6)

Sim owns position; clips are in-place (R94: `In place: Auto` proven for one stationary combo). Closing distance **glides**. The frame must make that least visible.

**Mechanism:** screen-space velocity scales with ground Δ × focal scale × (1/stand-off) × sin(incidence). Elevate + stand off + widen FOV a notch → fewer px/s for the same sim slide. Weight the frame on torsos so foot skate is peripheral.

| Do | Don't |
| --- | --- |
| Elevated ¾ (HOME pitch) | Flat side-on (Δ ground ≈ Δ screen) |
| FOV 50° + 9–11 m stand-off | Telephoto 19° or fisheye 76° |
| Mid-thigh-up torso weight | Worm’s-eye (feet scream; ropes chest-cut) |
| Hold the cut | Cut on every slide (makes glide the edit) |
| HUD pocket/distance as honest meter | Punch-truck / authored motion-blur contact |

Art direction buys a category of locomotion animation we otherwise have to purchase.

---

## §7 — Lighting (Q7)

**Retire preview 1 key + 1 fill.**

| Source | Spec | Gives viewer |
| --- | --- | --- |
| **Overhead key cluster** | Hard; above ring center; 3–4 spots or 1 area with control | Volume on bodies; rope/post shadow = ring truth |
| **Two corner fills** | Soft; opposite corners | Separates fighters; kills card-flat sides |
| **Canvas bounce** | Soft up-light from canvas albedo | Chin/glove fill; alive canvas |
| **Dim arena ambient** | Low Environment / Omni | Blacks don’t crush; arena exists; desk stays dark |

**What 1+1 does not give:** volume, pocket depth between torsos, rope shadow, canvas life. Target those four reads.

No SODIUM / GOLD specials on live chrome. Cage Desk remains dark instrument chrome + graphic plates.

---

## Rejects (spend instead)

See board `m14_09_rejects.png`. Headline rejects:

- Iso 38° diorama as ship → Cam-1 @ 50° + 9–11 m  
- Hide/delete near ropes → OVER  
- Chest-cut through torsos → OVER default  
- Punch-truck / stun-zoom / continuous follow → fixed home + claim rule  
- Multi-cam truck live / multi-angle mid-count → one HOME + one CLAIM-TIGHT + KD exit  
- Flat side-on / worm’s-eye → elevated ¾ slide mask  
- 1key+1fill forever → cluster + 2 fills + bounce + ambient  
- Face/skin workarounds → silhouette language; defect queued elsewhere  
- SELECT / GOLD on live / SODIUM on HUD → M13 token map  
- FOV 19° or 76° “creative” → 50° HOLD  

---

## Anchors

- M13 — fight screen; HUD second camera; claim≠summary; tokens  
- G43 — Cam-1 home; tight=claim; permission to stay; no truck fantasy  
- G42 / G45 — 20 Hz authority; most punches not drawn  
- R94 — deck 1.27 m; in-place clips; sim owns position  
- `arena_specs.json` — rope heights; contest sizes (jurisdiction presets)  
- K19 — iso sprite-stage (replaced here for real 3D)  
- J15 — KD duration research (shape only in M14)  

## Files

- Spec: `M14_THE_3D_FRAME.md` (this file)  
- Boards: `boards/m14_01_*.png` … `m14_10_composed.png`  
- DesignLibrary mirror: `DesignLibrary/screens/fight_frame/`  

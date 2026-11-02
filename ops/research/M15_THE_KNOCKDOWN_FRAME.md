# M15 — THE KNOCKDOWN FRAME

Maria Art Director · 2026-09-10 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

Cage Desk continuity. Extends M14 (HOME Cam-1 typed; only CLAIM-TIGHT + KD leave home) and M13 (HUD = second camera; tokens; KD mark = BAD; stoppage plate → GOLD verdict-only). Grounded in **J15** knockdown clock (10–25 s ordinary continue; eight = count number not wall-clock; MMA = no timed KD) and **J14** (ref = scenery; no ref object modelled). Faces deferred.

## DECISIONS

1. **CUT (HOLD):** on engine KD → **hard cut** to KD CAM. Allow **≤0.35 s push** only if hard cut reads as a bug. **Do not hold HOME** two-shot through the fall (reads as missed exit). Move duration: cut = **0 frames**; push ≤ **0.35 s**.
2. **KD CAM (typeable):** `Camera3D.fov` **43°** (band **42–45°**); pitch **−30°** (band **−28…−32°**); eye **3.0 m** / FLOOR (band **2.8–3.2 m**); stand-off **6 m** (band **5–7 m**) toward **downed fighter’s half**, aim between downed body and count graphic plate. Same Godot dial family as M14 (vertical under KEEP_HEIGHT).
3. **SUBJECT:** primary = **count graphic + downed body**; standing fighter = secondary / soft / may be HUD chip; ref body = **optional scenery** (prefer graphic count so boards work without modelled ref).
4. **BEAT SHEET — boxing continue (fight-time cues; engine drives):**
   - **0.0** fall confirmed / **cut** to KD CAM
   - **0.0–1.5** settle on downed + BAD KD mark (HUD already wrote it)
   - **1.5→** large count numeral **1…8** (or to **10** if still down) — advances on **count ticks**, not wall-clock canvas elapsed
   - **mid-count** optional HUD glance chip: standing → farthest neutral corner (no camera spam)
   - **rise path** vs **fail path** diverge **before** KO / resume text (see §4–5)
5. **COUNT GRAPHIC:** Bebas/display **huge numeral**; BAD or GYM edge; **not** a circular countdown / progress ring; optional soft tick on advance; LINK candour chip OK (“COUNT” / “OFFICIAL”); **never GOLD mid-count**.
6. **RISE:** hold KD CAM until vertical / gloves wiped → **return HOME** (cut or ≤0.35 s). Audience knows continue from **rise + wipe gesture** before “BOX” / resume chrome.
7. **FAIL / stay-down:** hold on **still body + count complete (10)** → stoppage plate path (M13). Audience knows from **stillness + unfinished rise** before KO text / GOLD.
8. **MMA:** **no KD CAM linger · no count numeral.** Brief claim of ground seat **or** immediate finish/stoppage frame → HOME or M13 stoppage plate. Finish may be **~2 s**. Ground continue = stay wide or brief ground claim then HOME — not boxing count ceremony.
9. **ONE CLIP:** ship **generic fall-to-canvas**. Clip **#2 buy** = rise attempt. Clip **#3 buy** = stay-down / fail hold. Do not buy twelve J15 filmable states.
10. **REF:** mark boards that need a ref body as **DEPENDS ON REF**. Prefer graphic count so boxing boards are **ref-optional**. Faces / crowd **not required** for any M15 board.

---

## Boards

| Board | Answers |
| --- | --- |
| `m15_01_the_cut.png` | Q1 — HOME vs KD CAM numbers · cut ≤0.35 s |
| `m15_02_beat_sheet.png` | Q2 — 0–25 s timeline (boxing) |
| `m15_03_count_graphic.png` | Q3 — count number ≠ timer |
| `m15_04_rise.png` | Q4 — get-up ending before text |
| `m15_05_stay_down.png` | Q4 — fail ending before text |
| `m15_06_mma.png` | Q5 — no count shape |
| `m15_07_one_clip.png` | Q6 — one clip + #2/#3 buys |
| `m15_08_rejects.png` | What not to try |
| `m15_09_ref_optional.png` | Which boards need ref body |

---

## §1 — The cut (Q1)

**HOLD: hard cut on engine KD.** Prefer cut over push. Do not hold HOME.

| | HOME (M14 locked) | KD CAM (M15) |
| --- | --- | --- |
| `Camera3D.fov` | **50°** | **43°** (42–45) |
| Pitch | **−20…−22°** | **−28…−32°** (more down) |
| Eye / FLOOR | **3.8–4.2 m** | **2.8–3.2 m** (closer to canvas plane) |
| Stand-off | **9–11 m** outside apron | **5–7 m** toward downed half |
| Aim | Ring center | Downed body + count plate |
| Motion while live | Fixed | Fixed for count shape |
| Move duration | — | Cut = **0 f**; push ≤ **0.35 s** |

**Why cut:** holding the two-shot through a confirmed KD reads as a missed exit / bug (M14 already named KD as a legal leave). A soft push is allowed only as anti-bug glue — not as style.

**Why these numbers (art invent, geometry from M14/R94):** lower eye + steeper pitch + shorter stand-off + tighter FOV put **canvas + body** in the frame weight and make the **numeral** readable without a mat-cam fantasy. Eye still clears canvas (deck **1.27 m** / FLOOR → eye ~1.5–1.9 m above canvas at 2.8–3.2). Not worm’s-eye (M14 reject). **Invented band refined from held lean + J15 duration need** — not a broadcast statute.

**Open vs M14 §5 wording:** M14 said subject = “ref+count.” M15 **refines**: subject = **count graphic + downed body**; ref optional. Argue in open: we have no modelled ref (J14 scenery); graphic count preserves procedure without inventing ref geometry. Compatible with M14 intent (procedure as subject).

Board: `m15_01_the_cut.png`

---

## §2 — Beat sheet in seconds (Q2)

Engine drives off **fight-time**. Count advances are **engine/ref count ticks**, not `Time.get_ticks` from canvas. Wall-clock canvas→eight is **not** guaranteed 8.00 s (J15 DIRECT/INHERITED).

### Boxing — ordinary continue (~10–25 s) · cues

| t (s) | Picture | HUD / graphic | Source |
| --- | --- | --- | --- |
| **0.0** | Fall confirmed → **cut** KD CAM | BAD KD mark already / lands | Engine KD · M13 |
| **0.0–1.5** | Settle: downed body + canvas weight | Soft settle; no numeral yet or pre-roll hush | **Invented** settle window for eye |
| **~1.5** | Count **1** lands huge | Numeral on tick; optional LINK “COUNT” | Cadence = 1 s intervals after pick-up (J15); pick-up delay UNKNOWN |
| **2…8** | Numeral advances **2…8**; body may rise mid-count | Standing fighter = **chip** “NEUTRAL” if useful — **no** mid-count camera cuts | J15: mandatory 8 even if up early |
| **~8–12** | Rise path: vertical / one-step / wipe gesture | Numeral holds or clears; wipe = scenery | Shortest continue ~**10–12 s** (J15 INHERITED) |
| **12–25** | Slow rise / gait stretch still on KD CAM | Same graphic rules; no GOLD | Longest ordinary ~**20–25 s** (J15) |
| **resume** | **Return HOME** | Clear count plate; live HUD resumes | After wipe / “box” |

### Boxing — fail path overlay

| t | Picture | Knows before text |
| --- | --- | --- |
| Mid–late count | Body **still**; no rise attempt, or rise fails back down | Stillness |
| **10** (or abort) | Count complete / wave-off shape | Numeral **10** or stop cue · still body |
| After | Hold → **M13 stoppage plate** (not GOLD on live) | Then labelled replay; GOLD on verdict exit only |

**Neutral corner / standing fighter:** do **not** cut the camera to them mid-count (M14 reject: multi-angle mid-count). Optional **HUD chip** only.

**Invented vs J15:** settle **0–1.5**, glance-chip mid-count, and exact return-HOME timing are **art invent**. Duration band **10–25**, mandatory eight, wipe floor, count≠wall-clock, neutral-corner send are **J15**.

Board: `m15_02_beat_sheet.png`

---

## §3 — Count as graphic (Q3)

**Eight is a count number** — the referee’s official count — **not** a countdown timer from canvas (J15 Decision 2; false-premise table).

| Do | Don't |
| --- | --- |
| Huge display numeral **1…10** | Circular countdown / pie / progress ring |
| Advance on **count tick** | Bind numeral to wall-clock from canvas |
| BAD or GYM edge · TEXT numeral | GOLD mid-count (verdict-only, M13/M5) |
| Optional soft tick / pulse on advance | Timer chrome (“0:08”, mm:ss) |
| LINK candour chip (“COUNT” / “OFFICIAL”) | SODIUM / SELECT |
| Hold one frame composition | Multi-angle mid-count |

**How it reads:** the audience follows **which number the procedure is on**, same as a broadcast graphic over a held wide. The hole in the fight (J15: long quiet 10–25 s) is filled by **numeral authority + still consequence body**, not by cutting around the ring.

Board: `m15_03_count_graphic.png`

---

## §4 — Rise ending before text (Q4a)

**Audience knows continue before resume chrome.**

Picture sequence on KD CAM:

1. Body leaves canvas plane (soles / vertical silhouette) — may still be “taking count standing” (J15).
2. Count reaches **8** (mandatory) — numeral completes procedure.
3. **Wipe gesture** (hands out / towel contact as silhouette beat — ref optional; can be implied off-frame).
4. **Cut/push return HOME** — both fighters standing, fight live.

**Before text:** unfinished stillness is gone; body is vertical; count plate clears; HOME two-shot returns. Do **not** wait for a “BOX” string to teach the ending — the frame already did.

Board: `m15_04_rise.png` · **ref optional** (wipe can be off-frame)

---

## §5 — Stay-down ending before text (Q4b)

**Audience knows stoppage before KO / GOLD.**

Picture sequence:

1. Count advances; body **does not** complete a rise (or rises and collapses without fresh-blow reset — scenery still = fail).
2. At **10** (or safety abort earlier): numeral complete / wave-off shape; body still on canvas.
3. Hold **stillness** beat (art invent ~0.5–1.0 s) so the eye accepts finality.
4. Exit to **M13 stoppage plate** (typed reason) → labelled replay → M5 **GOLD ×1** on verdict exit only.

**Before text:** stillness + finished count + no vertical recovery. GOLD never appears mid-count or as the teach.

Board: `m15_05_stay_down.png` · **ref optional** (wave-off arms would be DEPENDS ON REF if shown; prefer still body + numeral 10)

---

## §6 — MMA case (Q5)

**No timed knockdown. No count. No mandatory eight. No glove-wipe clock** (J15 §5; J14 R7; NAC boxing count does not apply).

| Boxing KD | MMA “went down” |
| --- | --- |
| Cut to KD CAM · linger 10–25 s | **No linger ceremony** |
| Huge count numeral | **No numeral** |
| Neutral corner send | May follow to ground · legal punches |
| Rise/wipe → HOME or fail → plate | **Continue ground** (HOME or brief ground claim) **or** immediate stoppage plate |

**Frame rule:** either (a) brief claim of the grounded seat (CLAIM-family, labelled if needed) then **HOME**, or (b) immediate **stoppage plate** if engine/stop already fired. Finish may land in **~2 s** — do not invent an MMA “knockdown window” timer (J15 refused).

Board: `m15_06_mma.png` · **no ref body required**

---

## §7 — What we do NOT have (Q6)

### Cannot render today (do not depend)

| Missing | Design response |
| --- | --- |
| Modelled referee body / hand-count | Prefer **graphic count**; mark DEPENDS ON REF only where hand/wave shown |
| Faces / skin of the 12 | Silhouette language (M13/M14); no face inserts |
| Crowd / colour-man | Not required; Cage Desk stays instrument |
| Twelve J15 filmable downed states | **One** fall-to-canvas clip |

### One clip + purchase priority

| Priority | Clip | Buys |
| --- | --- | --- |
| **SHIP** | Generic fall-to-canvas (land-on any) | Confirms engine KD; pairs with count graphic for full ceremony |
| **#2** | Rise attempt (act-of-rising → soles) | Teaches continue ending **before** text; without it, rise is a teleport |
| **#3** | Stay-down / fail hold (still on canvas through 10) | Teaches stoppage ending **before** text; without it, fail is freeze+plate only |

**Do not buy next:** land-on variant pack (glove/knee/seat/back/face/all-fours as separate) — legally one state (J15); art variants are luxury. Gait-test walk, rope-hang, out-of-ring 20-count — out of ordinary M15 scope.

Board: `m15_07_one_clip.png`

---

## Rejects (spend instead)

See `m15_08_rejects.png`.

- Hold HOME through KD → **cut** to KD CAM  
- Punch-truck / stun-zoom into fall → engine KD then cut  
- Circular countdown / mm:ss timer as “the eight” → **count numeral** on ticks  
- GOLD mid-count → BAD/GYM numeral; GOLD verdict-only  
- Multi-angle mid-count / truck to neutral corner → single KD CAM + HUD chip  
- Mat-cam / worm’s-eye as KD home → eye 2.8–3.2 / FLOOR elevated-down, not floor cam  
- MMA ten-count / 2 s “KD window” graphic → no count; brief claim or stoppage  
- Twelve downed state clips as ship gate → **one** fall; #2 rise; #3 stay-down  
- Face gash / crowd roar as teach → silhouette + numeral  
- Invented zipdo / “41.5% of bouts” as art premise → **J15: frequency not found**; do not calibrate drama rate from refused listicles (open disagreement with TASK_M15 frequency aside)

---

## Ref optional map

| Board | Needs ref body? |
| --- | --- |
| `m15_01_the_cut` | **No** |
| `m15_02_beat_sheet` | **No** (graphic count) |
| `m15_03_count_graphic` | **No** |
| `m15_04_rise` | **Optional** — wipe may be off-frame |
| `m15_05_stay_down` | **Optional** — wave-off arms = DEPENDS ON REF if shown; prefer numeral+still |
| `m15_06_mma` | **No** |
| `m15_07_one_clip` | **No** |
| `m15_08_rejects` | **No** |
| `m15_09_ref_optional` | Legend board |

Board: `m15_09_ref_optional.png`

---

## Anchors

- **M14** — HOME typed; only CLAIM-TIGHT + KD leave; KD shape deferred here  
- **M13** — HUD second camera; BAD KD mark; stoppage plate; GOLD ×1 verdict-only; tokens  
- **J15** — 10–25 s ordinary; eight = count number; mandatory 8 + wipe floor; MMA no timed KD; body-state inventory (research, not clip list)  
- **J14** — ref scenery; no ref object; no standing eight pro default; no MMA ten-count  
- **G43** — procedure as subject; permission to stay; no truck fantasy  
- **R94** — deck 1.27 m; in-place clips  

## Files

- Spec: `M15_THE_KNOCKDOWN_FRAME.md` (this file)  
- Boards: `boards/m15_01_*.png` … `m15_09_ref_optional.png`  
- DesignLibrary mirror: `DesignLibrary/screens/fight_frame/`  

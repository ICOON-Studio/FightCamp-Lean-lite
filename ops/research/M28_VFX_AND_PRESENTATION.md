# M28_VFX_AND_PRESENTATION.md — PASS 1

Maria Art Director · 2026-09-22 · art only — LOOK; **no geometry, no code, no copy**

**Standing task.** This pass is an artefact to judge, not a claim that VFX is done.

**Pair:** Kalli owns FLOW + words (`TASK_GAME_FLOW.md`). Maria owns LOOK (this file). Where mine depends on hers is marked **DEPENDS ON KALLI**.

**Measured start:** zero `GPUParticles` / `CPUParticles` under scripts (task). 12 scenes, 64 panels, UIKit. M13–M27 already locked fight HUD grammar, tokens, states.

---

## Three lines

1. **Most effects should be nothing** — save the rare flash for knockdown / finish; jabs get air.
2. **Build continuous physicality first** (dust / sweat / breath) before fireworks — cheaper, sells bodies, does not steal KD.
3. **Menus share one Cage Desk presence (M22)**; only **fight entry/exit** may feel heavier — and that weight **DEPENDS ON KALLI** naming the routes.

---

## DEPENDS ON KALLI (say it first)

| My look claim | Needs from her flow |
| --- | --- |
| Transition weights (week / fight / career) | Named routes + which screen pair is crossed |
| Eye-on-arrival per screen class | Screen classes and primary job of each |
| “Fight feels different from menu” | Exact enter-fight / leave-fight buttons and titles |
| Pass 2 polish of menu presence | Her pass-1 flow table (complete routes, dead ends) |

Until her flow artefact lands, Part 2 below is **treatment grammar**, not a wired map of all 64.

---

# PART 1 — SPECIAL EFFECTS

## 1. WHAT DESERVES AN EFFECT (rank)

Honest answer: **far fewer than a fighting game.** Management fight (M13): HUD + reaction carry most of the story. Flash on every jab empties the KD.

| Rank | Moment | Effect budget | Notes |
| --- | --- | --- | --- |
| 0 | Glancing / blocked / miss / ordinary clean jab | **NOTHING** | Instruments + reaction (M17/M19) enough |
| 1 | Clean landed **graded high** (hook/upper/power) | **Optional micro** — see §3 (dust/sweat only) | Never screen flash |
| 2 | Cut / new trauma pip | **HUD only** (M13 pip rim 200 ms) — **no blood spray** in pass 1 | See §4 |
| 3 | Knockdown | **Frame change (M15)** + light mat contact cue | Not particle fireworks |
| 4 | Submission locked / finish / stoppage plate | **One qualitative cue** + M13 stoppage path | Rare; must feel different from (1) |
| 5 | Between-round / menu | **No fight VFX** | Presence is Part 2 |

**Get nothing:** routine strikes, feints, footwork slides, camera orbit noise, every region tick.

---

## 2. SCALE WITH THE ENGINE GRADE

Beat already carries `landed`, `outcome`, `grade`, `target_region`, `technique` (task).

| Gate | Look rule |
| --- | --- |
| `landed` false / glancing | No world effect |
| clean + grade low/mid | No world effect (or dust only if continuous layer already on) |
| clean + grade high | Allow **micro** continuous layer bump (sweat flick / dust) — still no flash |
| KD / finish flags | Allow the **rare** cue set (§1 ranks 3–4) |
| Region | Aim micro toward region (head vs body) without anatomy gore |

**Never** fire a “punch spark” flat on every landed — grade is the volume knob; most values stay at zero.

---

## 3. CONTINUOUS PHYSICALITY (build first)

Cheaper than KO fireworks; sells “bodies in a room” while HOME is locked (M14/M20).

| Priority | Layer | Why first |
| --- | --- | --- |
| A | **Mat / canvas dust** on heavy steps & falls | Reads at 9–11 m; grounds slide (M18) |
| B | **Sweat micro** on high gas (`gas_gassed` / `gas_danger` — M24) | Ties instrument to body |
| C | **Breath / exertion** only at danger gas — subtle, not throb | Continuous ≠ pulsing chrome |
| D | Impact “hit spark” | **Defer** — competes with claim rule (M13 tight=claim only) |

**Never continuous throb** on HUD chrome (M23/M24). Soft particle drift ≠ UI pulse.

---

## 4. BLOOD AND DAMAGE — product line

**Status: ACCEPTED (fallback) — operator 2026-09-22.**  
Primary “no blood at all / readout only” was offered; operator took the **fallback** at the end of this section. Do not re-ask.

| Show | Do not show |
| --- | --- |
| M13 trauma **pips** + M23 region ramp (fill% + hatch) — **readout > meat** | Blood pools, arterial spray, face gore textures |
| Cut as **instrument event** (pip arrival) during the bout | Per-punch blood, ever — no decal that claims a cut the trauma pip does not have |
| Blood **only** at **doctor / stoppage class** — the one moment a cut stops the bout (information, not decoration) | Blood that tracks the camera, hides silhouettes, or lives as a camera-locked 2D overlay ignoring orbit |

**Bound by §5 (free camera):** even at stoppage class — nothing between camera and both silhouettes; no full-screen flash/white-out; effect thins or dies when it would cover both torsos from the current view; cue on mat or body contact only. A stoppage effect that reads from one angle and blocks the fight from another is not shippable.

**Next fight-surface pass:** one blood board only — doctor/stoppage KEEP + REJECT. Not opened on M29.

---

## 5. WHAT MUST NEVER BE OBSCURED

Camera is free (orbit/zoom). Rules:

1. No full-screen flash / white-out / letterbox blood.
2. No particle wall between camera and both silhouettes.
3. Effects die or thin when they would cover **both** fighters’ torsos from current view.
4. KD/finish cues stay **on mat / on body contact**, not as camera-locked 2D slap overlays that ignore orbit.
5. HUD chrome (M13) stays readable — VFX never redraws the whole panel.

---

# PART 2 — HOW MENUS PRESENT THEMSELVES

## 6. WHAT A TRANSITION MEANS (weights)

Do **not** share one generic crossfade for all.

| Weight | When | Treatment (look) |
| --- | --- | --- |
| `nav_light` | Hub ↔ roster ↔ profile tabs | Instant or **≤150 ms** hairline dissolve; same M22 surfaces |
| `nav_week` | Week advances / calendar commit | Short **dim to sunken + clock tick** feel — no fight VFX |
| `nav_fight_in` | Enter fight night / live world | **Heavier**: hold on contract/stakes beat, then cut to HOME frame — fight is the centre |
| `nav_fight_out` | Leave fight to results / career | Stoppage/verdict grammar (M4/M5) then settle to desk — do not reuse fight_in |
| `nav_career` | Career end / retirement (M12) | Slowest emotional weight — still no particle rain |

Exact screen pairs **DEPENDS ON KALLI** flow table.

---

## 7. EYE ON ARRIVAL (per screen class)

| Class | First eye | Screen does |
| --- | --- | --- |
| Hub / week desk | Primary actable | Accent the one continue control (M25 recommended grammar if applicable) |
| Roster / tables | Selected row / filter | Selection louder than hinge marks (M25/M27) |
| Fighter card | Identity + next decision | Not a wall of equal chrome |
| Between-round corner | Recommended slot | M25 accepted≠focused |
| Fight live | Actables → HUD sentence → wide 3D (M13) | Never open on a particle |
| Results / books | Verdict / money truth | GOLD only on verdict word (M5/M22) |

---

## 8. CONSISTENT ACROSS 64 PANELS

One product = M22 applied mechanically:

- Surfaces: ground / panel / sunken / hairline  
- Type: Bebas display + Plex text  
- Space base 4px; stat row 30px pattern  
- Elevation = hairline, **no panel drop-shadows**  
- Never hue-only state; never continuous throb  
- Reserved metals stay reserved  

Anything that invents a fifth surface or a glow for “premium” breaks the set.

---

## 9. FIGHT IS THE CENTRE

| Arrive at menu | Arrive at fight |
| --- | --- |
| Light nav, desk chrome, ambient quiet | Heavier `nav_fight_in`; land on **HOME camera + instruments** |
| Equal panel grammar | Crescendos reserved (M13/M15) — KD/stoppage only |
| No world dust required | Continuous physicality (§3) allowed |

Leaving a fight must not feel like closing a settings modal — **DEPENDS ON KALLI** titles/buttons saying the career continues.

---

## NEVER (useful half)

1. Spark on every jab.  
2. Full-screen hit flash.  
3. Blood as primary damage language.  
4. Continuous pulsing UI.  
5. Purchased VFX packs without operator word.  
6. Effects that fight orbit camera or hide both bodies.  
7. One shared fancy transition for week and KO.  
8. Hue-only “danger red” menus.

---

## WHAT IS STILL WRONG (end of pass 1)

1. **No live reference stills** of current FightNight under free camera — effect scale unproven in-engine.  
2. **Kalli flow not landed** — Part 2 cannot name real dead-end routes or step counts yet (**DEPENDS ON KALLI**).  
3. **Grade → micro-effect mapping** not typed to real `grade` enum labels — need one engine paste of beat fields before pass 2.  
4. **Zero particles today** — pass 1 is ruling only; no prototype contact sheet.  
5. **Blood ruling ACCEPTED (fallback)** — doctor/stoppage only; §5 binds free-camera. Doctor board = next fight-surface pass.  
6. **Continuous layers (dust/sweat)** not boarded — next pass should board A/B only, still no KO fireworks.

---

## Next pass (when checked)

- Board: dust + sweat micro vs forbidden jab-flash (rejects).  
- Align transition weights to Kalli’s first flow table.  
- Doctor/stoppage blood KEEP+REJECT board (only blood board ever).  

Claude lands; Maria does not edit HANDOFF.

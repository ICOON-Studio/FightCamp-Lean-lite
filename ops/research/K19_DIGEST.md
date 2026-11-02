# K19 DIGEST — THE LIVE FIGHT SCENE (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent.
No HANDOFF.md edits from this study.

## A) Pick + rejects

**PICK: Iso spectacle on `ring_stage` + frame-pinned instruments (R31 survives).** Live isometric camera and sprite motion live on the stage canvas. Condition rails, move strips, and the corner dock stay **screen-space** as R31 ships them. Operator verbs stay on the one morphing corner dock; listen-roll feedback lands on the pressed chip.

- **REJECT 1: World-space HP / condition billboards over heads.** Clinch overlaps collide the two bars; the sim has **no spatial state**, so billboard placement would be invented choreography. Durable condition read stays frame-pinned (ours top-left, theirs top-right). World-space may carry **ephemeral FX only** (impact flash, hurt stagger on the sprite).
- **REJECT 2: Floating / camera-tracking arcade hotbar** (“Press Forward / Takedown / Protect Cut”). That is a second grammar. Keep R31’s **ONE morphing corner dock** (pace / 8s combo / between-rounds / watch-dim). Map operator verbs onto existing dock calls (pace / emphasis / plan).

Lost if billboards win: glance read dies in clinch; invented positions. Lost if floating hotbar wins: two call grammars + stage covered. Lost if iso never lands: operator’s live-camera desire unmet — stage presentation is the REPLACE.

## B) Priority order (while fighting)

1. **Who’s hurt / gassing** — frame-pinned condition rails (always visible; 1–2s glance)
2. **Sprite action on iso stage** — silhouette language; camera frames both; never crops both off
3. **Move strips** — under stage
4. **Dock calls / 8s window** — same corner dock morph

Facing-away still readable via silhouette + rail heat (not face). Do not design boards that need real grappling positions — choreography invented from discrete ~14 fight-second exchanges.

## C) Gold ×1 per board

| Board | Gold |
|---|---|
| **CAMERA** | Primary live pace press (**PRESS**) |
| **WORLD vs SCREEN** | PICK chip **FRAME PINNED** |
| **THE CALL** | Command being issued (**PRESS**); listen states use GOOD / AMBER / BAD — not a second gold |
| **STATES** | **LET THE CHAIN GO** in the 8s cell only |

Green = CONTINUE only on result way-out. Doctor = semantic BAD. IPPON / TECHNICAL ≠ KO.

## D) KEEP vs REPLACE from R31

**KEEP unchanged**
- `condition_rail` frame-pinned (ours TL / theirs TR)
- `move_strip` under stage
- `corner_dock` position / size / four dresses
- `combo_alert_8s` in dock
- `verdict_stamp_ring` (doctor BAD; IPPON/TECH ≠ KO)
- `watch_mode_chip` / LAB foot chips
- K7 frame ownership of names / clock / stakes / way out

**REPLACE / EXTEND**
- `ring_stage` presentation → isometric floor + animated silhouettes (spectacle)
- Add **listen_ack** states on dock chips (HEARD / HALF-HEARD / WAVED OFF)

## E) Kit gaps

Reuse first: K7 set-piece frame, R31 ring family (`condition_rail`, `move_strip`, `corner_dock`, `combo_alert_8s`, `verdict_stamp_ring`, `watch_mode_chip`).

| Instrument | Need |
|---|---|
| `iso_ring_stage` | Isometric floor + two animated silhouettes inside 1920×912 body; ephemeral impact/stagger FX; no durable HUD in world space |
| `listen_ack_chip` | Chip dress: HEARD (GOOD edge / check; if gold already on press, ack is GOOD not second gold) · HALF-HEARD (amber wash) · WAVED OFF (BAD pulse, call unapplied) |

## F) Reads relied on

| Read / fact | Use |
|---|---|
| R31 ships frame-pinned rails + one dock | KEEP baseline |
| Sim has **no spatial state** (TASK) | Forbids world billboards / real clinch positions |
| Exchanges ~every 14 fight-seconds → 1.4s wall | Choreography invented; glance budget |
| Hard real-time beat = **8s combo window** | Dock morph unchanged |
| K16 priority + gold / BAD / IPPON rules | Still bind |

**Missing / name for build:** listen-roll result enum for dock chip ack; iso stage asset path / silhouette animation set (boxing moves only in sample). Do not invent spatial coords from FightSimulation.

## G) Boards (1920×1080, K7 set-piece chrome — not ShellChrome)

1. **CAMERA** — live iso round; instruments in place; gold PRESS
2. **WORLD vs SCREEN** — clinch moment split; reject billboards / pick frame-pinned; gold FRAME PINNED
3. **THE CALL** — dock command + HEARD / HALF / WAVED OFF; reject floating hotbar; gold on issued PRESS
4. **STATES** — ground/iso · hurt · 8s combo · LAB · AI CORNER · doctor stamp; gold LET THE CHAIN GO in 8s cell

Sample: Kian Sterling (ours) vs Marco Vega. Silhouettes, never portraits.

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = CONTINUE only (result way-out); doctor BAD; IPPON/TECH ≠ KO; pair = slate; facility is GYM; ♀ ≠ ♂; silhouettes; invent no spatial data; K7 set-piece frame (not ShellChrome); body 1920×912.

## Files

- `FIGHT_SCENE_K19.html`
- `FIGHT_SCENE_K19_camera.png` / `_world_vs_screen.png` / `_call.png` / `_states.png`
- `K19_DIGEST.md` (this file)

## Blockers

Study unblocked. Build needs: `iso_ring_stage` presentation swap on existing `ring_stage`; `listen_ack_chip` dresses on dock; confirm listen-roll enum from intervention / C17 half. Parent owns HANDOFF. This study did not open `FightSimulation.gd`.

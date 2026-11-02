# K7 DIGEST — Set-piece frame (Kalli study)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.

## What it is

Visual language for the five R20 set-pieces (`fight_week`, `weigh_in`, `fight_night`, `fight_result`, `crowning`) so they no longer look like office widgets. Persistent shell (rail + top bar + Continue) leaves; a reusable set-piece chrome takes the whole 1920×1080 viewport.

## Boards

1. **Handoff** — 6 frames, ms labeled (router contract).
2. **Empty frame** — way out strip, stakes, clock/round, name; no rail/top/breadcrumb/Continue.
3. **The five dressed** — contact sheet + five full PNGs; body + phase change only.
4. **Interrupt** — stoppage / decision read / **belt change (hero)**.

## Router timings (play exactly)

**Enter (940 ms sequential):**
| Step | ms | What |
|------|-----|------|
| Idle | 0 | Shell on screen |
| Rail out | 180 | 196→48→gone, labels off |
| Top fold | 160 | 64→28→out; Continue exits with shell |
| Seam | 220 | Vertical shutter; “changing gear, not a load” |
| Frame lock | 240 | Way-out + stakes + clock + names |
| Settle | 140 | Body fades in |

**Exit (480 ms):** chrome fold 280 + shell restore 200.

**Hero hold:** belt-change interrupt holds **1600 ms** before way-out / Continue arms.

Decision cards flip **120 ms** each (supporting treatment).

## Hero interrupt

**Belt changing hands** — gold on the belt only; name stays white; one silhouette; no particle stack competing with gold. Stoppage uses semantic BAD red (not gold). Decision uses gym blue on winning cards; gold saved if crowning follows.

## Kit rulings obeyed

- Bebas Neue display / IBM Plex Mono else; SIZE_MIN 12; 1920×1080
- Gold ×1 per frame; green = Continue only (returns on Result exit)
- Pair blocks = slate/control, never gym header colour
- GYM not “camp” except Fight Week phase label (“FIGHT CAMP PREP”)
- Silhouette placeholders only; one figure per screen

## Files

- `SETPIECE_FRAME_K7.html` — full study
- `SETPIECE_K7_handoff.png` / `_frame.png` / `_dressed.png` / `_interrupt.png`
- `SETPIECE_K7_fight_week.png` / `_weigh_in.png` / `_fight_night.png` / `_result.png` / `_crowning.png`
- `K7_DIGEST.md` (this file)

## Blockers

None for the study. Scenes for `fight_week` / `weigh_in` remain unbuilt in the router (R20); this supplies the chrome contract those scenes should mount.

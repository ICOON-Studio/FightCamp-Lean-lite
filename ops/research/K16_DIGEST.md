# K16 DIGEST — THE RING (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent.

## A) Shape

**PICK: HYBRID kit body.** Rebuild the ring as a native kit body that fills the K7 **1920×912** stage. Keep a dedicated **ring stage canvas** for the fight picture; build the instrument layer (condition, move strips, corner dock, combo alert) as kit overlays.

- Rejected **keep-and-scale** the old full-canvas scene (current seam: 1920×1080 authored canvas scaled into the slot) — loses readability + kit coherence.
- Rejected **pure re-dress** of `RingNightView` arcade layout — keeps the wrong instrument grammar.
- Lost if pure scale: readability + kit coherence. Lost if throw away stage: fight spectacle. Hybrid keeps both.

## B) Round priority (while fighting)

1. Two fighters + condition (compact region bars / heat — **ONE large silhouette** on stage; opponent = smaller sil or name+condition only)
2. Action / impact on the ring stage
3. Move strips (secondary, under stage)
4. Region damage detail (on the **condition rail**, not a second body map)

**DROP:** arcade FIGHT! / ROUND N wordart (K7 clock+phase own that); duplicate names (K7 head owns names); huge floating damage popcorn as primary UI.

## C) Corner — ONE dock

Bottom of stage; morphs in place:

| Mode | Dock shows |
|---|---|
| Live idle | Pace call chips (plan pace) |
| Combo alert | Same dock → 8s wall-clock decision bar + **LET THE CHAIN GO** (gold ×1) |
| Between rounds | Contingency menu with plan’s own call **STARRED** |

Never a modal that covers the ring during live action for pace. A missed call because the player was reading = design failure.

## D) Moment layer

**SURVIVE:** finish / verdict stamp (method-specific); round bell (subtle); belt only via **K7 crowning** path elsewhere.

**Stoppage / doctor** = semantic **BAD** red, **NEVER** gold.

**IPPON** and **TECHNICAL** superiority are **NOT** knockouts — distinct stamps, not KO wordart.

**DROP:** FIGHT!, ROUND N wordart, arcade damage number rain as the main read.

Gold ×1 per board on the primary coaching action only (pace / let-chain / starred plan).

## E) Modes — one board, differently dressed

| Mode | Dress |
|---|---|
| **LIVE** | Full corner dock; stakes in K7 head; career real |
| **TEST (lab)** | LAB chip in foot; no purse / career stakes; corner still works for practice |
| **WATCH** | Dock dimmed / **AI CORNER**; no player pace calls |

Never show career stakes in lab; never hide the corner dock in a live coaching bout.

## F) States (contact sheet)

Shown on `board-states`: no bout; doctor stoppage (BAD); IPPON; TECHNICAL superiority; decision on cards; AI-coached watch; fighter came in hurt / missed weight chip on condition; LAB mode.

## G) Kit gaps (name only what’s missing)

Reuse first: K7 set-piece frame, scale readout, verdict block, scorecards, belt hero.

| Instrument | Need |
|---|---|
| `ring_stage` | Native fight-picture canvas inside 1920×912 body (not scaled 1080 scene) |
| `condition_rail` | Compact region % / heat for ours (+ opp rail or mark) |
| `move_strip` | Live + ghosted incoming combo links under stage |
| `corner_dock` | One morphing surface: pace / contingency / watch-dim |
| `combo_alert_8s` | Same dock → 8s wall-clock bar + LET THE CHAIN GO |
| `verdict_stamp_ring` | IPPON / TECHNICAL / doctor distinct from KO |
| `watch_mode_chip` | AI CORNER / LAB foot chips |

**No drag primitive.** Legacy `RingNightView.gd` discarded and rebuilt, not migrated.

## Boards (1920×1080, K7 set-piece chrome — not ShellChrome)

1. **ROUND** — live coaching; gold ×1 PRESS pace
2. **CORNER** — between rounds; gold ×1 starred plan call
3. **COMBO** — 8s alert; gold ×1 LET THE CHAIN GO
4. **MOMENT** — stamp set; doctor BAD; IPPON/TECH ≠ KO; Continue green on result card
5. **STATES** — contact sheet modes + edges; gold ×1 lab pace chip

Sample: Kian Sterling (ours) vs Marco Vega. Boxing moves only (jab / cross / hook).

## GameState / API gaps for Codex

Fight tick, corner bar, finish, `setup(bout_id, mode)` live|test already exist per TASK. Confirm / expose before build:

- **watch mode** flag (event-night, AI corner — not only live/test)
- **region condition %** feeds for condition_rail (head/body/legs/gas) if not already on a stable read
- **incoming combo chain** + **8s wall-clock** remaining for combo_alert_8s
- **plan contingency list** + **starred default** for between-rounds dock
- **method stamp enum** distinguishing IPPON / TECHNICAL / doctor / decision / KO
- **missed weight / came-in-hurt** chips for condition rail
- **purse / stakes line** suppressible for LAB (head eye must not show career purse)

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = CONTINUE only (result way-out); pair = slate; facility is GYM; ♀≠♂; silhouettes; invent nothing; K7 set-piece frame (not ShellChrome).

## Files

- `RING_K16.html`
- `RING_K16_round.png` / `_corner.png` / `_combo.png` / `_moment.png` / `_states.png`
- `K16_DIGEST.md` (this file)

## Blockers

Study unblocked. Build needs hybrid body + kit-gap instruments above; confirm watch mode + method-stamp + lab stakes suppress reads. Claude owns build; this study did not open `RingNightView.gd` / `FightNightScreen.gd` wholesale.

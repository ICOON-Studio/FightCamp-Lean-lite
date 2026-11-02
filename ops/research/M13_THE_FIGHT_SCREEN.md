# M13 — THE FIGHT SCREEN THAT MUST NOT PICK A PUNCH

Maria Art Director · 2026-09-10 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

Cage Desk continuity. Extends M5 (verdict GOLD), M6 (BAD / six regions), M7 (SODIUM stays off this surface), LINK candour. Designed inside G42/G43/G45: the 20 Hz sim is the fight; the view is a summary.

## Call: HUD is the second camera; wide is home; tight is a claim

Our fight is authoritative at twenty ticks a second. A bought punch clip runs ~0.82 s; the engine can land ~0.35 s apart. **Most punches will not be drawn.** A trunks-up close-up of a "clean" hook the ledger scored as a glance is a lie. So is a face insert for a cut we have no pip for, and a stun cam when no stun was applied.

**Rule:** wide, corner, labelled replay, and the HUD are **summaries**. Tight contact is a **CLAIM** — and we may only claim what the engine already scored.

**So this is not a fighting-game fight screen.** It is a management fight screen whose picture confirms a sentence the instruments already wrote — the Football Manager / Madden grammar G43 named: the player looks at what they can still act on.

### One-line treatments

| Surface | Treatment |
| --- | --- |
| Default live | Elevated wide head-to-toe · both fighters · distance/pocket true · **no punch pick** |
| HUD | Permanent HR + trauma pips + 6-region glance + clock/round + pocket chip |
| Knockdown | Ref + count become subject · KD only if engine KD · teach accumulation first |
| Stoppage | Typed reason plate · then labelled replay · then M5 verdict path (GOLD ×1) |
| Between round | Labelled HIGHLIGHT/REPLAY · volume board · J1–J3 · corner actables |

---

## Token map (verified against `UITokens.gd` — no SELECT)

| Role | UITokens | Hex / notes |
| --- | --- | --- |
| Shell / round chip / primary dock | `GYM_DEFAULT` | `#2f6fb0` — **SELECT does not exist**; never invent it |
| Candour / pocket / highlight label / on-change rim | `LINK` | `#7fb6ee` |
| Heart-rate bands | `GOOD` / `AMBER` / `BAD` | ring colour by BPM band; numeral `TEXT` |
| Trauma pips — cuts | `BAD` | filled pip; empty = `TRACK` |
| Trauma pips — swelling | `AMBER` | filled pip; empty = `TRACK` |
| Region attrition | `LIFE_RAMP` / `AMBER` / `BAD` | glance chips HN/TC/LA/RA/LL/RL — not anatomy |
| Knockdown mark / doctor stoppage | `BAD` (+ `BAD_EDGE` plate) | danger family; M6 second home for doctor |
| Corner towel reason | `AMBER` | distinct from doctor |
| Referee wave-off chip | `GYM_DEFAULT` | protective stop |
| Verdict word (post-stoppage exit) | `GOLD` | **×1 only** — M5 rule; never on live HUD chrome |
| Championship metal | `SODIUM` / `ICE` | **unused on fight HUD** — M7 desk only |
| CONTINUE | `GO` | **unused here** — way-out elsewhere, not fight night |
| Surfaces | `GROUND` `PANEL` `TRACK` `CHIP` `LINE` / `LINE_SOFT` | Cage Desk |
| Type | Bebas display / Plex mono values | `SIZE_MIN` 12 floor |
| Age ink | n/a on this surface | M11 ladder unused mid-fight |

**Finding held (do not quietly redesign):** cardio reads as **heart rate**, not a stamina bar; trauma reads as **discrete pips**; attrition reads as **continuous region values**. If this is wrong, argue in the open — board `m13_02` and §2 are the held call.

---

## §1 — The frame

### Composition when the default is a wide that does not pick a punch

**Home shot:** elevated, front-of-ring, both fighters head-to-toe (broadcast Camera-1 grammar without the truck). Ropes/cage stay readable. Pocket is a soft ellipse or chip, not a cinematic push-in.

**Eye order (management grammar — design for it, do not fight it):**

1. **ACTABLES** — corner dock verbs that can still change the result (`SHOUT` / `PACE` / `ASK STOPPAGE` / watch). G44: build ASK FOR THE STOPPAGE as the mid-fight verb that costs the fight.
2. **HUD SENTENCE** — HR, pips, regions, pocket, clock, KD marks. Truth written before the picture.
3. **WIDE 3D** — stance, distance, seat, fall. **Confirms** the sentence. Never authors a fact the ledger did not write.

Twelve rigged fighters + one proven clip are enough for posture and distance confirmation. They are not a license for per-punch theatre.

### Where the eye must not go first

Glove impact. Face blood inserts. Stun zooms. Anything that asserts contact quality the engine did not score.

### 3D confirms the HUD — examples

| HUD already wrote | 3D may show | 3D must not show |
| --- | --- | --- |
| `POCKET` | both inside mid-ring | trunks-up "clean" hook |
| `HR 152` | high guard, short steps | gasping face cam |
| cut pip ×1 | nothing extra, or wide swelling only if data exists | invented brow gash |
| no KD | both standing | mat-cam fall fantasy |

Board: `m13_01_the_frame.png`

---

## §2 — The HUD as the second camera

This is the load-bearing half. Instruments are unusual on purpose.

### Heart rate (permanent)

- Numeral + pulse **ring** (not a bar, not a resource tank).
- Bands: settled `GOOD` → working `AMBER` → redzone `BAD` (illustrative thresholds on boards: ~&lt;140 / &lt;170 / ≥170 — engine binds exact cuts).
- Ours and theirs both permanent when both are standing.
- Under pressure the ring colour moves before the player "feels" the clip density — that is the point.

### Trauma pips (permanent when present; on-change arrival)

- Two discrete rows: **CUTS** (`BAD` fills) and **SWELL** (`AMBER` fills).
- Empty slots stay `TRACK` — honest zeros.
- On new pip: brief `LINK` rim pulse (~0.6 s), then settle. No floating "CUT!" toast that claims a punch.

### Six body regions (permanent glance)

- Same family as M6: `head_neck` `torso_core` `left_arm` `right_arm` `left_leg` `right_leg`.
- Fight-night dress = **letter chips** HN/TC/LA/RA/LL/RL + heat fill (`LIFE_RAMP` → `AMBER` → `BAD`).
- Readable in ≤0.2 s. **Not** a medical diagram, muscle map, or PunchZone 3D body toy.
- Desk clearance (M6) and fight attrition share names; they do not share chrome weight.

### Permanent vs on-change

| Permanent | On-change (appear / pulse / clear) |
| --- | --- |
| Heart rate (both) | New trauma pip arrival |
| Trauma pip rows (once lit, stay) | Knockdown mark + count |
| Six-region glance | Ground seat chip |
| Round + clock | Judge tick at bell (J1–J3 pair) |
| Distance / pocket chip | Stoppage reason plate |
| Names / records strip | Pocket enter/exit rim pulse |
| Actable dock | — |

### What stays off the live beat

- Drop-count / "12 more that minute" audit (G45 pick).
- Stamina bar.
- Twin fighting-game HP bars.
- `SELECT` accent.
- `GOLD` / `SODIUM` chrome.
- Judge **names** (ordinal J1–J3 only — M5 / T17).

Board: `m13_02_hud_second_camera.png`

---

## §3 — The three moments that are allowed to be big

The screen is quiet by rule. These three crescendos carry the emotional load.

### 3.1 Knockdown — crescendo 1

1. Do not smash-zoom a punch. Tighten on the **fall** only after the engine writes KD.
2. **Subject = referee + count numeral.** Fighter is the consequence.
3. HUD locks: KD mark (`BAD` edge), regions/HR already told accumulation.
4. No instant multi-angle package mid-count. Replay waits for between-round or stoppage, and is **labelled**.
5. Teach accumulation all round (live volume nearby, region heat, HR) so a KD after a thin sample is not read as a cutscene (G45).

Token: KD mark uses danger/`BAD` edge — **not** `GOLD` (verdict only), not `SODIUM`.

Board: `m13_03_knockdown.png`

### 3.2 Stoppage — crescendo 2

Typed reasons, distinct chrome:

| Reason | Dress |
| --- | --- |
| Doctor | `BAD` plate · medical/hold path opens post-fight · no gore insert |
| Corner | `AMBER` towel chip · ASK STOPPAGE resolved · `LINK` candour line |
| Referee | `GYM` wave-off · protective · clock stop · engine reason string |

Sequence: wave-off → reason plate → corner cut → **labelled** stoppage replay → exit to M5 verdict path (`GOLD` ×1 on the verdict word only).

Refuse: IPPON/TECH as KO; `GO` celebrate; belt `SODIUM` on the stoppage plate; stamina-drain animation.

Board: `m13_04_stoppage.png`

### 3.3 Between round — crescendo 3

The sport's own minute. Honest place for replay.

- **Label once:** `ROUND N · HIGHLIGHT` / `REPLAY · NOT LIVE` in `LINK`. After that the punch is just the punch — no "REPRESENTATIVE" stamp on the glove (G45).
- **Round board:** thrown / landed / % — volume barometer, not quality, never posing as the judge (CompuBox lesson).
- Complete totals from the **full ledger** (the 896, not the 66). Picture and card are one object.
- **J1–J3** this-round pairs; disagree pip `AMBER`; ordinal only.
- **Corner actables** reclaim the eye: `GYM` primary shout/plan · `BAD` only on ASK STOPPAGE · never `GO`/`GOLD`.

Density sentence lives on the board + corner notes — not as a live audit meter on the beat.

Board: `m13_05_between_round.png`

---

## §4 — Reading the fight without seeing every punch

Not a damage number — a **read**. Six-channel vocabulary:

| Channel | What it tells | How it shows on a quiet wide |
| --- | --- | --- |
| **Posture** | upright vs folded, chin, weight | silhouette language — no face cam required |
| **Position** | centre / ropes / corner trap; who owns pocket | ring geometry stays true when punches are sampled |
| **Corner** | stool urgency, cutman, board tone | between-round mirrors the live HUD story |
| **Instruments** | HR climb, pip count, region heat migration | second camera tallies what the eye cannot |
| **Pacing** | clock vs how often the stage bothers to move | quiet stage + rising HR = losing without highlights |
| **Colour** | GOOD→AMBER→BAD washes; LINK candour notes | semantic skim layer — never decorative |

**Losing-right-now sentence (HUD writes it; 3D only confirms):**  
*"Ours: HR 176 · HN 54 · cuts×2 · pocket lost · folded on ropes."*  
Wide 3D needs folded + ropes. The glove is optional.

Do not reward good reading with punch theatre.

Board: `m13_06_reading_without_punches.png`

---

## §5 — What not to attempt

Hold the commercial bar — then name what is unreachable here.

| Reject | Why unreachable | Spend instead |
| --- | --- | --- |
| **Cinematic fight camera** | Truck grammar asserts contact we may not claim | One honest wide + rare claim-tight only when engine wrote contact quality |
| **Per-punch impact language** | 0.82 s clips vs 0.35 s landings; sparks author false density | Sample clip + complete volume board + region/HR accumulation |
| **Broadcast package** | EVS multi-angle budget refused on evidence | Labelled single replay in the between-round minute |
| **Stamina bar** | First-hand competitor finding — cardio is HR | Heart-rate instrument permanent with GOOD/AMBER/BAD bands |
| **Health-bar FG layout** | Wrong twice: wrong for management; asserts per-punch HP | Trauma pips + 6-region glance + manager actable dock |

### Also refuse

- Live drop-count / "12 more" audit on the beat  
- `SELECT` token (does not exist — use `GYM_DEFAULT` or `LINK`)  
- `GOLD` on anything but the verdict word  
- `SODIUM` on fight HUD  
- Quiet redesign back to stamina  
- World-space HP billboards (K19 reject still holds)  
- Judge names; invented spatial clinch poses  

Board: `m13_07_rejects.png`

---

## Optional compose

Full quiet live frame: way-out rail · stakes/clock header · dual instrument rails · wide stage with pocket · corner dock with actables + pocket/KD + judge strip. Compose rule: if the HUD were muted, the wide must not pretend to be a complete fight; if the stage froze, the HUD alone must still narrate the bout.

Board: `m13_08_composed.png`

---

## Boards → `DesignLibrary/screens/fight_screen/`

| File | Section | Content |
| --- | --- | --- |
| `m13_01_the_frame.png` | §1 | Default wide · eye hierarchy · 3D confirms · forbidden claims |
| `m13_02_hud_second_camera.png` | §2 | HR + pips + 6 regions · permanent vs on-change · token calls |
| `m13_03_knockdown.png` | §3.1 | Crescendo 1 · ref/count subject · accumulation teach |
| `m13_04_stoppage.png` | §3.2 | Crescendo 2 · doctor/corner/ref reasons · M5 exit |
| `m13_05_between_round.png` | §3.3 | Crescendo 3 · labelled replay · volume board · actables |
| `m13_06_reading_without_punches.png` | §4 | Posture/position/corner/instruments/pacing/colour |
| `m13_07_rejects.png` | §5 | Five rejects + spend · also-refuse list |
| `m13_08_composed.png` | optional | Full quiet live frame |

Sample bout on boards: **Kian Sterling vs Marco Vega** (continuity with K19 sample names). Silhouettes, not portraits.

---

## UIKit / factory intent (art guidance — no new code in this pack)

Reuse Cage Desk / ring family where it already exists: frame header, chips, buttons, blocks, corner dock morph. New *dresses*, not new tokens:

- `heart_rate` instrument (ring + BPM)  
- `trauma_pips` (cuts/swell)  
- `region_glance` (six letter chips)  
- `pocket_chip` / distance band  
- `stoppage_reason_plate`  
- labelled `highlight_replay` mode chip  

Forbidden factories/patterns on this surface: fighting-game lifebars, stamina bar, `UIKit.celebration` as stoppage pay-off, world-space billboards.

---

## Anchors

- G42 — 20 Hz authority; view is summary; do not slow the core  
- G43 — camera when punches are not drawn; tight = claim; player looks at actables  
- G45 — ~7% shown; complete count from full ledger; no live drop-count; label the mode  
- G44 — ASK STOPPAGE first mid-fight verb that changes the result  
- M5 — GOLD ×1 verdict; J1–J3 ordinal; median/consensus post-fight  
- M6 — BAD doctor/hold; six regions named  
- M7 — SODIUM/ICE off this HUD  
- K19 — frame-pinned instruments; reject world HP billboards (keep); replace punch-first fantasy with this pack's quiet wide  
- R97 / adapter — sample selection is consequence-first; art must teach accumulation  

---

## Refusals (pack checklist)

1. Fighting-game health-bar layout  
2. Stamina bar (quiet or loud)  
3. Per-punch impact authorship  
4. Cinematic truck camera as default  
5. Unlabelled replay posing as the full fight  
6. Tight claim without engine contact quality  
7. `SELECT` token  
8. `GOLD` on live chrome / `SODIUM` on HUD  
9. Live drop-count audit  
10. Judge names  
11. Medical anatomy diagram as the region glance  
12. `.gd` / `.tscn` / `HANDOFF.md` edits from Maria  

---

## Delivery

- Spec: `research/M13_THE_FIGHT_SCREEN.md`
- Boards: `DesignLibrary/screens/fight_screen/m13_*` (**new folder**, 8 PNGs)
- Staging: `_maria_delivery/M13_THE_FIGHT_SCREEN.zip`
- Land note: `_maria_delivery/CLAUDE_LAND_NOTE_M13.md` + `research/CLAUDE_LAND_NOTE_M13.md`

Operator relay. Claude writes the HANDOFF block when the pack lands.

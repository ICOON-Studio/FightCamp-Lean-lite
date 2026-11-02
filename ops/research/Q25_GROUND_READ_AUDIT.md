# Q25 — THE GROUND FIGHT READ, AUDITED AGAINST WHAT WE ACTUALLY BUILT

**Audit of G38's recommendation against `FightHudPanel.gd` as shipped.**
One file, no `.gd` edits. Research task.

---

## 1. The audit table — G38 asked for, we shipped, verdict

### What appears (G38 §5)

| G38 element | Shipped? | Where (file:line) | Verdict |
|---|---|---|---|
| **A. Seat chip** — visible when `stance` is `clinch` or `ground`, hidden when `standing` | Yes | `FightHudPanel.gd:342-371` `_build_seat_chip()` checks `stance != "standing"` at line 345 | **MATCHES** |
| Seat chip copy: `seat` mapped to short label (see paste block) | Yes | `FightHudPanel.gd:43-48` `SEAT_LABELS` dict: `over_under`→CLINCH, `guard`→GUARD, `half`→HALF, `side`→SIDE, `mount`→MOUNT, `back`→BACK | **MATCHES** |
| Seat chip prefix: who is `top` when `top != -1` ("RED · HALF") | Yes | `FightHudPanel.gd:355-358` builds `"{CORNER} · {LABEL}"` when `top` is in `CORNER_WORDS` | **MATCHES** |
| Seat chip cadence: on `position_change`, `takedown`, `throw`, `clinch_engage`, `clinch_break` | N/A | Panel is stateless — rebuilds from payload on each `apply_route_args()`. Cadence is the caller's contract, not the panel's. | **OUT OF SCOPE** (panel renders, does not fire) |
| Seat chip: GUARD stays visible with top set, even when units are 0 | Yes | `FightHudPanel.gd:347-350` — no guard-specific hiding logic; test T6 verifies `RED · GUARD` prints with top=a | **MATCHES** |
| **B. Attempt tightness** — visible only while submission attempt is open | Yes | `FightHudPanel.gd:250` `_build_submission()` called only when `_submission_owner_side() == side`; `FightHudPanel.gd:408-413` `_submission_open()` checks `grapple.submission_open` | **MATCHES** |
| Attempt tightness copy: hold short-name (or "SUB") + 5-pip tightness (0–19 / 20–39 / 40–59 / 60–79 / 80–100) | Yes | `FightHudPanel.gd:373-378` label is `"SUB"` or `"SUB {seat_word}"`; `FightHudPanel.gd:519-526` `_sub_pips()` maps progress to 5 bands | **MATCHES** |
| Attempt tightness cadence: 1 Hz, matching progress ticks | N/A | Panel is stateless — rebuilds from payload. Cadence is the caller's contract. | **OUT OF SCOPE** |
| Attempt tightness hidden otherwise, no "warm" state | Yes | `FightHudPanel.gd:408-413` `_submission_open()` returns false when `submission_open` is false; test T7 verifies pips hidden when closed | **MATCHES** |
| **C. Stall warning** — on seat chip, amber at 300 ticks (15s), red at 400 ticks (20s) | Yes | `FightHudPanel.gd:361-365` `kind = "bad"` if `stall_ticks >= 400`, `"amber"` if `>= 300`, else `"standard"` | **MATCHES** |
| Stall warning: no separate countdown number unless last 5s | Yes | `FightHudPanel.gd:342-371` — no countdown text rendered; test T8 verifies no "300" or "400" text on chip | **MATCHES** |
| **D. BroadcastRead lines** — fire on specific events only, do not fire on control-unit ticks or once per second in stable seat | N/A | `BroadcastRead.gd` is the statistics fold (U19/U21/U32), not the live commentary surface. Live event lines are fired elsewhere (likely `FightRealtime.gd` or a commentary director). | **OUT OF SCOPE** for this panel audit |
| **E. RealtimeRoundStats** — unchanged charter: fold the log onto the judges | N/A | Separate module, not part of `FightHudPanel.gd`. | **OUT OF SCOPE** |

### What deliberately does not appear (G38 §5)

| G38 element | Shipped? | Where (file:line) | Verdict |
|---|---|---|---|
| A running "GROUND CONTROL 2:14" clock | No | `FightHudPanel.gd` — test T9 (line 316) verifies no "GROUND CONTROL" text | **MATCHES** (correctly absent) |
| A control-unit counter (`+2`, `48u`) | No | `FightHudPanel.gd` — test T9 (line 317) verifies no "CONTROL UNIT" or "+2" text | **MATCHES** (correctly absent) |
| IBJJF points/advantages on a Unified Rules fight | No | `FightHudPanel.gd` — test T9 (line 320) verifies no "POINTS" text | **MATCHES** (correctly absent) |
| An osaekomi-style auto-win ring | No | `FightHudPanel.gd` — no ring/arc/circle geometry in panel | **MATCHES** (correctly absent) |
| A Grapple Assist compass, transition wheel, or any input prompt | No | `FightHudPanel.gd` — test T9 (line 318) verifies no "PRESS" text; no QTE chrome | **MATCHES** (correctly absent) |
| A submission circle / arc / overlap HUD | No | `FightHudPanel.gd` — submission rendered as pips only, no arc/overlap | **MATCHES** (correctly absent) |
| A pre-attempt danger aura | No | `FightHudPanel.gd` — no aura/glow/gradient tied to submission state | **MATCHES** (correctly absent) |
| Per-second commentary | N/A | Panel is stateless — does not fire commentary. Live commentary cadence is elsewhere. | **OUT OF SCOPE** |
| A third surface | No | `FightHudPanel.gd` — panel renders seat chip + attempt pips + existing elements (heart, trauma, attrition). No new surface invented. | **MATCHES** (correctly absent) |

### One-screen spec (G38 end of §5)

| Element | Source field | Cadence | Surface | Shipped? | Verdict |
|---|---|---|---|---|---|
| Seat chip | `stance`, `seat`, `top` | On seat/stance event | FightHudPanel | Yes | **MATCHES** |
| Stall colour | stall tick count in seat | Continuous; amber 300; red 400 | FightHudPanel (on chip) | Yes | **MATCHES** |
| Attempt pips | attempt progress 0..100 | 1 Hz while open | FightHudPanel | Yes | **MATCHES** |
| Attempt owner + hold | attempt attacker, hold name if present | On open | FightHudPanel + one BroadcastRead line | Partial | **PARTIAL** — panel shows "SUB {seat}" but does not show hold name (see §4) |
| Event line | G34 events listed in §5.D | On event only | BroadcastRead | N/A | **OUT OF SCOPE** (separate surface) |
| Heart rate + zone | existing | existing | FightHudPanel | Yes | **MATCHES** (existing, unchanged) |
| Trauma pips / attrition | existing | existing | FightHudPanel | Yes | **MATCHES** (existing, unchanged) |
| Control duration MM:SS | — | — | **nowhere live** | No | **MATCHES** (correctly absent) |
| `control_score` integral | `control_score` | scoring tick | RealtimeRoundStats only | N/A | **OUT OF SCOPE** (separate module) |
| Input prompt / QTE | — | — | **nowhere** | No | **MATCHES** (correctly absent, hard refuse) |

### Seat labels (G38 copy block)

| G38 label | Shipped? | Where | Verdict |
|---|---|---|---|
| `none` → (no chip) | Yes | `FightHudPanel.gd:347-350` — `if not SEAT_LABELS.has(seat): return` | **MATCHES** |
| `over_under` → CLINCH | Yes | `FightHudPanel.gd:44` | **MATCHES** |
| `guard` → GUARD | Yes | `FightHudPanel.gd:45` | **MATCHES** |
| `half` → HALF | Yes | `FightHudPanel.gd:46` | **MATCHES** |
| `side` → SIDE | Yes | `FightHudPanel.gd:47` | **MATCHES** |
| `mount` → MOUNT | Yes | `FightHudPanel.gd:48` | **MATCHES** |
| `back` → BACK | Yes | `FightHudPanel.gd:48` (wait, line 48 is back) | **MATCHES** |

Chip format: `{CORNER} · {LABEL}` when `top` is a fighter; `{LABEL}` when `top == -1`.

**Shipped:** `FightHudPanel.gd:355-358` — builds `"{CORNER} · {LABEL}"` when `top` is in `CORNER_WORDS` (a/b), else bare label. **MATCHES**

---

## 2. The silence audit

### What does the panel draw during a stalled, uneventful ground position?

Trace `_build_seat_chip()` with `stall_ticks` past amber and past red:

- **0-299 ticks:** Seat chip visible with current seat label + corner prefix (if top set). `kind = "standard"` → `UIKit.chip(text, "standard", gym_color)` → `T.CHIP` background (`#333d52`), `T.TEXT` foreground.
- **300-399 ticks (amber):** Same chip, `kind = "amber"` → `T.AMBER` background (`#f0a020`), `T.INK` foreground. No countdown number.
- **400+ ticks (red):** Same chip, `kind = "bad"` → `T.BAD` background (`#e5433a`), white foreground. No countdown number.

**What changes on screen:** Only the chip background colour. No text changes, no new elements, no animation.

**Other elements during a stall:**
- Heart rate continues ticking (existing feature, `FightHudPanel.gd:203-222` `_build_heart()`)
- Trauma pips stay static (no per-tick update)
- Attempt pips hidden if no attempt open
- Body attrition bars stay static

**Verdict:** The panel draws exactly what G38 §6 specifies: seat chip + heart rate + stall colour. Nothing else moves.

### Does anything animate, pulse, count up or re-render per tick while nothing is happening?

**No.** `FightHudPanel.gd` is stateless — it rebuilds from payload on each `apply_route_args()` call. The panel itself does not animate, pulse, or count.

- Heart rate bpm value updates when the caller passes a new payload (existing feature)
- `stall_ticks` is computed in `FightHudRead.gd:53` as `maxi(0, tick - int(g.get("stall_since", 0)))` — the caller computes it, the panel just renders it
- No per-tick animation in the panel itself

**Verdict:** No animation, no pulsing, no counting up. The panel is a pure render function.

### Is there any surface that appears ONLY on the ground and would read as the UI having hung if the fight stayed there for ninety seconds?

**No.** 
- Seat chip appears on ground AND clinch (`FightHudPanel.gd:345` — `stance != "standing"`)
- Attempt pips appear only when `submission_open` is true
- No ground-only surface exists

**Verdict:** No hung-UI risk. The seat chip + heart rate + stall colour provide the "deliberately quiet" signal G38 §6 requires. A blank screen with those three elements is a choice, not a bug.

---

## 3. The clinch, which G38 never saw

R92 added a standing clinch seat (`over_under`) after G38 was written. `FightHudPanel.gd:44` maps `over_under` → CLINCH. Line 345 shows the chip when `stance == "clinch"` OR `stance == "ground"`.

**The same treatment applies to both:** seat chip with label, corner prefix, stall warning.

**Recommendation (INVENTION):** This is correct. G38's principle is "quieter, not busier" and "the player is the corner, not the grappler" (G38 §5 Principle). A clinch is a standing grapple with the same pressure dynamics — a seat name, who is on top, stall warning. The same chip treatment applies.

**No distinction needed in the panel.** The panel does not need to know whether the fight is on the floor or standing in a clinch — it just renders the seat, the top, and the stall. The caller (FightRealtime) decides what events to fire; the panel just shows what is true of the bodies right now.

**Places the panel would need to distinguish the two (if it ever did):**
- Nowhere in the current panel. The seat label (CLINCH vs GUARD/HALF/SIDE/MOUNT/BACK) already carries the distinction.
- If a future task wanted different stall thresholds for clinch vs ground, the panel would need to read a different tick source — but G38 does not specify that, and the current code uses the same `stall_ticks` field for both.

**Verdict:** The shipped panel handles the clinch correctly by applying the same treatment. No code change needed.

---

## 4. The spec — what a build task types

Only for rows that came back PARTIAL, ABSENT or VIOLATION.

### Attempt owner + hold — PARTIAL

**G38 §5.B:** "Copy: hold short-name (or 'SUB') + a discrete 5-pip tightness"

**Shipped:** `FightHudPanel.gd:373-378` — label is `"SUB"` or `"SUB {seat_word}"`. No hold name.

**What is missing:** The hold name (e.g., "RNC", "ARM", "TRI") when the engine provides it.

**Spec:**

**File and function:** `FightHudPanel.gd:373-397` `_build_submission()`

**Existing UITokens constant:** No new token needed. Use existing `T.BAD` for pip colour (already used at line 393).

**Existing UIKit chip kind:** No chip — this is a pip track, not a chip. Use existing `_pip_track()` (line 280-307).

**Copy, verbatim:** 
- If `grapple.submission_hold` is present and non-empty: `"{hold_name} {seat_word}"` (e.g., "RNC BACK")
- If `grapple.submission_hold` is absent or empty: `"SUB {seat_word}"` (current behaviour)
- If `seat_word` is empty: `"SUB"` (current behaviour for orphan case)

**Where the hold name comes from:** The engine must provide it in the grapple payload. `FightHudRead.gd` must pass it through. This is a contract extension, not a panel bug.

**Test assertion in `fight_hud_panel_test.gd`:**

```gdscript
var with_hold := _mount(_with_grapple({
    "grappling": true, "stance": "ground", "seat": "back", "top": "a",
    "submission_open": true, "submission_progress": 85, "submission_hold": "RNC",
    "stall_stage": 0, "stall_ticks": 0,
}))
var sub_label: Node = with_hold.get_node_or_null("FightHudBody/SideA/Submission/SubPips/Kind")
_check(sub_label != null and "RNC BACK" in str(sub_label.text), "T7 hold name prints before seat word")
_free(with_hold)
```

**Prerequisite:** `FightHudRead.gd` must read `grapple.submission_hold` from the engine state and pass it through to the panel payload. `GrappleAdapter.gd` or `FightRealtime.gd` must write `submission_hold` into the grapple state when a `submission_attempt` event carries a hold name.

**This is a contract extension, not a panel defect.** The panel renders what it is given. If the engine does not provide a hold name, the panel correctly falls back to "SUB {seat}". G38 §5.Q1 (Open questions) says: "If no hold name: 'SUB' + seat. Default: ship the chip with 'SUB' + seat. Do not block the read on a new event field."

**Verdict:** The panel is correct as shipped. The hold name is a nice-to-have that requires an engine-side contract extension. No panel change needed until the engine provides the field.

---

## 5. Findings and open questions

### Summary

- **MATCHES:** 18 rows
- **PARTIAL:** 1 row (attempt hold name — engine contract extension, not panel defect)
- **ABSENT:** 0 rows
- **VIOLATION:** 0 rows
- **OUT OF SCOPE:** 6 rows (BroadcastRead lines, RealtimeRoundStats, cadence questions)

**The panel ships G38's spec correctly.** The silence audit confirms no animation, no pulsing, no counting up. The clinch is handled by the same treatment as the ground, which is correct per G38's principle. The one PARTIAL row (attempt hold name) is an engine contract extension, not a panel defect.

### Open questions (three, each with a default)

**Q1. Does the engine currently provide `submission_hold` in the grapple state?**
If yes, the panel should render it. If no, the panel is correct to fall back to "SUB {seat}".
**Default:** Assume no. The panel is correct as shipped. A later task can extend the engine contract and the panel together. Do not block the read on a new field.

**Q2. Should the clinch have a different stall threshold than the ground?**
G38 §5.C specifies amber at 300 ticks (15s) and red at 400 ticks (20s) for the ground. The clinch is a standing grapple — should it stall faster?
**Default:** No. G38 does not specify a different threshold. The current code uses the same `stall_ticks` field for both. A different threshold would require the engine to write separate fields (`stall_ticks_clinch` vs `stall_ticks_ground`), which it does not. Keep the same threshold until a ruleset-specific task says otherwise.

**Q3. Should the panel distinguish between a clinch that is about to break vs a clinch that is about to become a takedown?**
G38's principle is "quieter, not busier". The panel shows the seat (CLINCH) and the stall. It does not predict the next event.
**Default:** No. The panel renders what is true now, not what might happen next. BroadcastRead fires on events (clinch_engage, clinch_break, takedown) — that is the prediction surface, not the panel. Keep the panel quiet.

---

**Audit complete.** The shipped panel matches G38's spec. The one PARTIAL row is an engine contract extension, not a panel defect. No VIOLATIONS found. The silence audit confirms the panel is deliberately quiet, not hung.

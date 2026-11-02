# G37 — THE ADAPTER FOLD: HOW EACH RULESET SCORES A GRAPPLE

Owner: Grok (Expert / deep research, 101 sources). Research only. 2026-09-10.
Delivered inline in chat and committed by Claude — Grok has no checkout.

Engine numbers from `G34`/`G35` are **SETTLED** and are not reopened here.

**Rulebooks used:**

* **IJF** Sport and Organisation Rules / refereeing cycle 2025–2028 (yuko
  restored; osaekomi 5 / 10 / 20). Cross-checked against the IJF Technical
  Seminar Dec 2025 (Istanbul) and national translations of the 21 Jan 2026 SOR.
* **UWW** International Wrestling Rules, January 2026 (English official text,
  1 Jan 2026 implementation). Step-out grounded clarification: UWW circular
  12 Dec 2025, Art. 38.
* **IBJJF** Rules Book v6.1, June 2024 (still the live book as of Sep 2026).
* **ABC** Unified Rules of MMA, Aug 2025 scoring clarification and the Unified
  Rules revision dated Aug 2026.

**Engine contract (do not change):**

* Events: `clinch_engage`, `clinch_break`, `takedown`, `throw`,
  `position_change`, `exposure`, `step_out`, `submission_attempt`.
* Seats: `none`, `over_under`, `guard`, `half`, `side`, `mount`, `back`.
* Control units per scoring tick (G34, already ruled): standing / guard / none
  = **0**; clinch-with-a-top (`over_under`) and `half` = **1**;
  `side` / `mount` / `back` = **2**.
* Engine stability gate: **60 ticks = 3.0 s**. The adapter owns every other
  hold length.
* Five counters: `takedowns_round`, `throw_points_round`,
  `position_points_round`, `submission_attempts_round`, `control_score`.

---

## 0. Verdict table

| Question | Judo (IJF 2025–28) | Freestyle (UWW 2026) | BJJ (IBJJF v6.1 2024) | MMA (ABC 2025/26) |
| --- | --- | --- | --- | --- |
| Discrete event points? | Yes (ippon / waza-ari / yuko) | Yes (1 / 2 / 4 / 5) | Yes (2 / 3 / 4) + advantages | **No.** 10-point must. Events are evidence, not points. |
| Scores engine `throw`? | Yes — nage-waza ladder | Yes — 2 / 4 / 5 by amplitude + danger | No separate throw table. If it produces a 3 s top it is a takedown (2). | Evidence of effective grappling only if impact follows. |
| Scores engine `takedown`? | **Not scored.** A wrestling shot is not nage-waza. | 2 (control + 3 points of contact). 4 if feet-to-danger. | 2 after 3 s top. | Evidence only. |
| Scores seats as positions? | Only osaekomi-legal pins (side/mount/back, back on tatami). Guard / half / standing / clinch: not scored as holds. | Not IBJJF-style position points. Control on the mat is the takedown; turns are exposure. | Yes. Pass 3, mount 4, back 4. Side after a pass does not score again. Guard / standing / clinch: 0. | Advantageous position is Plan A evidence, not a number. Mere holding is explicitly not enough. |
| Hold gate the adapter applies | 5 s yuko / 10 s waza-ari / 20 s ippon. Engine still emits 3 s ticks; adapter counts seconds. | **NONE PUBLISHED** for a pin clock. Exposure is an event (2). Fall is referee-confirmed shoulders. | 3 s (already the engine gate). | **NONE PUBLISHED.** |
| Advantages | None | None | **Yes** — near-position and near-submission (§3) | None as a counter |
| `step_out` | Not a score. Intentional exit = shido. | 1 pt. 2-D fact — **cannot map from 1-D** (§4). | Not a score. Restart; possible penalty if fleeing a sub. | Not a score. Cage/ring is Plan C at most. |
| Stall clock | Shido for non-combativity. 45 s from conventional kumi-kata if progress is positive (SOR 18.1.1). 3rd shido = hansoku-make. Shido is **not** a point to the opponent. | Verbal, then 30 s activity period; no score → opponent +1. | 20 s countdown, then penalty ladder (mark / opp advantage / opp +2 / DQ). | Referee stand-up when no real, significant, sustained effort. **No published seconds.** Timidity is a foul. |
| Submission finish | Ippon if tap / maitta / unconsciousness from legal shime-waza or elbow kansetsu-waza. | **Cannot happen.** Do not map a finish. A fall is not a tap. | Ends the bout. | Ends the bout (tap / verbal / technical submission). |

**Do not average the four columns.**

---

## 1. Conversion tables

How to read: the left column is what the engine emits, the right is what that
ruleset awards. **"Not scored" means the adapter writes nothing to the five
counters for that emission.** Control ticks still accrue per G34 in every
ruleset; what the adapter *does* with `control_score` is ruleset-specific and
is stated under each table.

### 1.A Judo — IJF 2025–2028

Source: IJF SOR refereeing articles on Ippon / Waza-ari / Yuko / Osaekomi-waza;
Istanbul Dec 2025 seminar; 21 Jan 2026 SOR translations. **Yuko is live for the
2026–28 cycle.**

| Engine emission | Award | When |
| --- | --- | --- |
| `throw` meeting ippon criteria (back, control, speed, force — four elements) | **Ippon. Bout ends.** | Instant. Adapter may stamp `throw_points_round` as the federation display value, but the method is ippon, not a running total. |
| `throw` missing one criterion; landing >90° toward the back, not fully on it | **Waza-ari.** Two = ippon. | Instant |
| `throw` side landing ~90°, buttocks, or upper back / scapula | **Yuko.** Never adds to waza-ari. In golden score a yuko ends the contest. | Instant |
| `takedown` | Not scored | A shot that is not nage-waza is not a judo score. |
| `clinch_engage` / `clinch_break` / seat `over_under` | Not scored | Kumi-kata is a precondition, not a score. |
| `position_change` → `guard` or `half` | Not scored | Not osaekomi. |
| `position_change` → `side`/`mount`/`back` **and** uke's back or upper back on the tatami, tori controlling from side/rear/top, uke's legs not controlling tori | **Start adapter osaekomi clock**: 5–9 s = yuko; 10–19 s = waza-ari; 20 s = ippon. | Adapter seconds, not a new engine gate. If legs wrap and control tori → toketa, the clock dies. |
| `exposure` | Not a judo score by that name | A throw already covered the landing. |
| `step_out` | Not scored | Intentional exit without a valid attack = **shido** (Art. 18.1.1). Accidental edge is not a point. |
| `submission_attempt` | Not a point | If the hold is legal shime-waza or **elbow** kansetsu-waza and produces tap / maitta / unconsciousness → **ippon**. Otherwise invisible to the board. |

* `control_score`: **do not** convert the integral into judo points. Judo does
  not pay for accumulated control. The adapter uses only elapsed osaekomi seconds.
* `takedowns_round`: leave at 0 for judo. The published score is nage +
  osaekomi + penalties, not a takedown count.
* `position_points_round`: write the **osaekomi band** (yuko / waza-ari /
  ippon), not IBJJF 2/3/4.

### 1.B Freestyle wrestling — UWW January 2026

Source: UWW International Wrestling Rules Jan 2026 (USA Wrestling 2026
companion; the UWW text prevails).

| Engine emission | Award | When |
| --- | --- | --- |
| `takedown` to stomach/side, control, three points of contact, not danger | **2**; `takedowns_round += 1` | On control. **No 3 s IBJJF gate.** |
| `takedown` or `throw` feet-to-danger (standing → back <90° in one action, not grand amplitude) | **4** | Continuous. A pause on the mat then a turn is 2 + 2, not 4. |
| `throw` grand amplitude, lands in danger | **5** | Instant |
| `throw` grand amplitude, no danger | **4** | Instant |
| `throw` correct/complete to prone or lateral, opponent loses control, no danger | **2** | Instant |
| `exposure` (back <90°: bridge, elbows, one shoulder down + acute other, instantaneous both shoulders, roll) | **2 per turn** | Event, not a hold clock. A new turn can score again. |
| `position_change` → guard/half/side/mount/back | Not scored as positions | The takedown already paid. Further points need a new exposure or a reversal. |
| Reversal (bottom becomes top / passes behind from par terre) — arrives as `position_change` with a top flip and no exposure | **1** | On passing behind |
| `clinch_engage` / `clinch_break` / `over_under` | Not scored | — |
| `step_out` | 1 to the opponent — **but see §4; do not fire this from the 1-D engine** | Standing: entire foot in the protection zone, no completed hold. 2026: a defensive wrestler stepping out on the knees also = 1 to the attacker. |
| `submission_attempt` | Not scored; **illegal** if a strangle or joint attack | UWW 2026 points of emphasis: prevent strangulation and force against the joint. |

A **fall** (both shoulders confirmed in the orange zone, head out of the
protection area) ends the bout — a referee method from G35, not a counter.

* `control_score`: UWW publishes no control-unit tariff. Do not convert.
* **The "+1 for 5 s of held exposure"** repeated in primers and older summaries
  is **not** in the Jan 2026 official scoring bands. **NONE PUBLISHED — do not
  award it.**

### 1.C BJJ — IBJJF v6.1 June 2024

Source: IBJJF Rules Book v6.1, Arts. 2.5, 2.7, 3.1, 4.1–4.5, 5, 6.2.1, 7.3.1.

| Engine emission | Award | When |
| --- | --- | --- |
| `takedown` from both standing, opponent to back/side/seated, attacker keeps top 3 s | **2**; `takedowns_round += 1`, `position_points_round += 2` | After the engine 60-tick gate. Top lost before 3 s → **advantage only** (§3). |
| `throw` reaching the same end-state | **2** — IBJJF has no separate throw ladder | 3 s top |
| `position_change` guard/half → `side` (clear of the legs, side or north-south, 3 s) | **3** (guard pass) | 3 s. Passing straight to mount pays the pass *and* the mount if both stabilise. |
| `position_change` → `mount` (clear of half, seated on torso, facing head, ≤1 arm trapped, 3 s) | **4** | 3 s. Mount over both arms = advantage only. |
| `position_change` → `back` (heels between thighs, uncrossed, ≤1 arm trapped above the shoulder line, 3 s) | **4** | 3 s. Crossed feet, body triangle, or both arms trapped = advantage only. |
| seat `half` as a destination | Not scored | Half is not a point position; a near-pass through half can be an advantage. |
| seat `guard` / `standing` / `none`, `clinch_*`, `over_under` | Not scored | — |
| `exposure` | Not scored | IBJJF does not pay "back toward the mat". |
| `step_out` | Not scored | Restart. Fleeing a submission out of bounds can give the attacker +2 (Art. 1.3) — a referee method, not the 1-D `step_out` event. |
| `submission_attempt` | 0 points; **advantage** if real danger and no finish (§3). Finish ends the bout. | — |
| Knee-on-belly (2 pts, 3 s) | **UNMAPPED** — the engine has no `knee_on_belly` seat | See REFUSE |

* **Sweep**: the engine has no sweep event. A bottom-to-top `position_change`
  from guard/half that then holds top 3 s **is** the sweep (2). The adapter
  detects it from seat + top flip, not from a new event.
* `control_score`: IBJJF does not pay the integral. Keep it running for
  G34/R91 but do not add it to the IBJJF board.

### 1.D MMA — ABC Unified Rules Aug 2025 / Aug 2026

10-point must. Plan A = effective striking / grappling; Plan B = effective
aggressiveness; Plan C = fighting-area control. **B and C are dead unless A is
even.** There is **no legal conversion from one event to N points** — the
adapter's job is to hand the five counters to the judges as *evidence*.

| Engine emission | Award | Note |
| --- | --- | --- |
| `takedown` | Evidence of effective grappling **if** it produces impact, damage, a submission threat, or an advantageous position that is then used | A takedown that hits guard and dies is weak evidence. Increment `takedowns_round` as a **count**, not points. |
| `throw` | Same, weighted by impact | `throw_points_round` may store engine amplitude; ABC publishes no 2/4/5. |
| `position_change` → side / mount / back | Evidence of advantageous position | ABC: *"Merely holding a dominant position shall not be a primary factor."* What is **done** from the seat counts. |
| `half` / `over_under` / clinch | Weak evidence unless used to advance or damage | — |
| `guard` (top in guard) | Not advantageous under ABC language | — |
| `exposure` | Ignore as a discrete award | Not a wrestling danger-point |
| `step_out` | Not scored | Cage control is Plan C only |
| `submission_attempt` | Evidence; increment `submission_attempts_round` | A threatening attempt that forces a scramble outranks empty lock-hunting. Finish ends the bout. |
| `clinch_engage` / `clinch_break` | Not scored by themselves | — |

`control_score`: pass through as a **duration signal** for the 10-8 duration
limb. **Do not auto-write a 10-8 from control units** — ABC requires damage +
dominance + duration together; control alone is not enough.

```
mma_evidence = {
  takedowns_round,
  throw_points_round,          # amplitude proxy only
  position_points_round,       # unused as points; optional seat-time breakdown
  submission_attempts_round,
  control_score,               # duration only
}
```

---

## 2. Hold gates (adapter seconds)

The engine gate stays **60 ticks / 3.0 s**. These are adapter-side only.

| Ruleset | Gate | Source | What it awards |
| --- | --- | --- | --- |
| Judo IJF 2025–28 | **5 s / 10 s / 20 s** | SOR osaekomi table; Istanbul 2025; 21 Jan 2026 translations | 5–9 = yuko; 10–19 = waza-ari; 20 = ippon. Golden score: 5 s yuko ends it. |
| UWW FS 2026 | **NONE PUBLISHED** | Jan 2026 bands are event-based (2/4/5) plus referee-confirmed fall | Do not invent a 5 s extra. A fall is not a clock. |
| IBJJF 2024 | **3 s** | Art. 3.1 | Already the engine gate; the adapter adds nothing. |
| ABC MMA 2025/26 | **NONE PUBLISHED** | Unified Rules: no hold-duration tariff | Control ticks inform duration; they do not pay. |

```
HOLD_GATES_S = {
  "ijf":   {"yuko": 5, "waza_ari": 10, "ippon": 20},
  "uww":   {},          # none published
  "ibjjf": {"score": 3},
  "abc":   {},          # none published
}
```

**Osaekomi split (does not touch G34 §2):** the engine reports "held in
side/mount/back with `top=X` for N ticks"; the judo adapter converts N/20 into
seconds and trips 5 / 10 / 20. Only `side`, `mount` and `back` may start that
clock, and only while uke's back or scapular region is on the tatami and uke's
legs are not controlling tori. **`half` and `guard` do not start it.**

---

## 3. BJJ advantages — hole 1

IBJJF Art. 5 (v6.1 2024): **5.1** a point-scoring position reached but not held
3 s; **5.2** near-completion, opponent in real danger of being scored on;
**5.3** a submission attempt putting the opponent in real danger of tapping;
**5.5** an advantage is signalled only when there is no further chance to
complete the points.

**Two classes, two answers.**

**Near-position advantages ARE derivable. No new event.** Trigger, all three
must hold:

1. The engine emits `takedown`, `throw`, or a `position_change` whose
   destination is an IBJJF scoring seat (`side` as a completed pass, `mount`,
   `back`) or a takedown/sweep top.
2. The 60-tick gate does **not** complete.
3. The sequence is over (seat lost, stand-up, or out of bounds). **Art. 5.5:
   do not fire while the athlete can still finish the 3 s.**

That is Art. 5.1 verbatim. A sweep that unbalances and loses top before 3 s is
the same test on a bottom-to-top flip.

**Near-submission advantages are derivable only if `submission_attempt` already
means "real danger".** If the event is gated to a locked, threatening hold (the
G35 fifth-method path), map 1:1. If it can fire on any hand-on-neck, Art. 5.3
is violated.

**Recommendation (default): add no event. Constrain the adapter.**

```
# IBJJF advantage setters — adapter only
if scoring_seat_reached and hold_ticks < 60 and sequence_over:
    advantages += 1
if event == "submission_attempt" and method_did_not_fire:
    advantages += 1
```

Keep advantages **adapter-local** — do not add a counter to the engine.

If a later build needs a graded threat, the only honest new event is
`submission_threat`, payload `{attacker, defender, danger: 0|1}`, triggered by
a locked hold forcing a defensive reaction (posture break, frantic hand-fight,
verbal distress) without a tap; IBJJF reads `danger == 1` as an advantage, MMA
as an evidence bump, judo and UWW ignore it. **That event is optional and the
default is to live without it.**

---

## 4. UWW step-out — hole 2

A UWW step-out is a **2-D boundary fact**: an entire foot (standing) or a
grounded body (2026 Art. 38, knees in the protection area) crossing from the
orange/passivity zone into the protection zone, ordered by **who left first**,
and cancelled if a hold begun in the centre is completed.

The engine tracks a **scalar separation**. There is no mat, no centre circle,
no protection ring, and no "who crossed first".

### A 1-D model cannot produce an honest step-out.

Any test of the form `separation > RING_RADIUS` is a **wall-walk, not a
step-out**. It fires when two men separate — the opposite of a wrestler being
driven off the circle — and it cannot distinguish attacker-steps-out-during-a-
throw (action continues, score the throw, possibly no penalty) from
defender-flees (1 point, sometimes a caution). Those branches are 2-D and
role-tagged.

**Honest fallback (default):**

* The adapter writes `step_out` → **not scored**, for every ruleset driven by
  this engine.
* UWW live scoring from this engine covers takedown / throw / exposure /
  reversal / activity-period only.
* **Do not ship UWW boundary points from the real-time engine until the world
  is 2-D.** This is the same structural refuse already used for taekwondo.

If R91 wants a placeholder anyway, the only non-lying option is a **referee
method** (G35), never an automatic conversion.

---

## 5. Stall clock, per ruleset

G35 defined one engine clock. Who actually penalises, after how long, with what.

| Ruleset | Who | After how long | What | Source |
| --- | --- | --- | --- | --- |
| **IJF** | Referee, shido for lack of combativity | **45 s** from conventional kumi-kata when progress is positive. No single published "always 30 s" in the current SOR; older cycles used ~25–30 s with no attack. Referees penalise sooner absent positive progress. | Shido. 1st and 2nd are board warnings; **3rd = hansoku-make**. **Shido is not a point to the opponent.** Intentional exit is also shido, not a step-out point. | SOR Art. 18.1 / 18.1.1; 21 Jan 2026 translations |
| **UWW FS** | Referee + judge; verbal first, then activity period | **30 s** mandatory-score window after the passivity designation. 0–0 at 2:00 also starts it. | Designated wrestler scores in the 30 s → period ends with that score. If not, **opponent +1**, restart standing. Greco is a different procedure. | UWW Rules Jan 2026, FS activity / Art. 46 notes |
| **IBJJF** | Main referee | **20 s** countdown with no positional progression, submission attempt, or scoring move | Ladder: 1st = mark; 2nd = opponent advantage + mark; 3rd = opponent +2 + mark; 4th = DQ. Both idle → both marked. | Arts. 6.2.1, 7.3.1 |
| **ABC MMA** | Referee | **NONE PUBLISHED** in seconds | Stand-up or break when neither shows "real, significant and/or sustained effort to advance towards finishing". **Holding a superior seat is explicitly not effort.** Timidity is a foul: warn / point / DQ. | Unified Rules 8.2026; foul 21, Timidity |

Keep G35's single clock as the **detector** and map the trip to the row above.
**Do not collapse 45 / 30 / 20 / "referee feel" into one number.** UWW
amateur-MMA (20 s, then "Action!", then stand-up) is a different book — do not
import it into ABC Unified or UWW freestyle.

---

## 6. What a submission finish means

| Ruleset | Legal submissions | Finish meaning | If `submission_attempt` fires where a finish cannot happen |
| --- | --- | --- | --- |
| **IJF** | Shime-waza (neck; not belt-as-noose, not fingers-only, not do-jime). Kansetsu-waza = **elbow only**. Standing kansetsu with a throw: shido if uke can escape, hansoku-make if he cannot. | Tap (≥2), maitta, or unconsciousness = **ippon**. | A knee-bar, heel-hook, shoulder-lock or wrist-lock is **illegal, not a score**. The adapter must not call ippon — treat it as a foul path (G35), not a method. |
| **UWW FS** | **None.** Strangles and joint attacks are prevented, not scored. | A tap is not a victory method. A **fall** is the only "held there" ending. | Ignore, or treat as a referee interruption for illegal pressure. **Never write a submission win. Never increment a UWW point for the attempt.** |
| **IBJJF** | Age/belt-legal catalogue. Tap, verbal, scream, unconsciousness. | Bout ends; points and advantages are discarded. | Advantage if real danger (§3). |
| **ABC MMA** | Legal submissions under Unified fouls (no small-joint, etc.) | Tap, verbal tap, or technical submission (unconsciousness / broken or dislocated joint from a legal hold). | Plan A evidence only. |

---

## Ready-to-paste conversion blocks

Awards are **ruleset units**, not a shared "grappling score". Control units
remain G34's 0 / 1 / 2 per tick and are not reopened.

```
IJF = {
  "throw.ippon":        "ippon",
  "throw.waza_ari":     "waza_ari",          # 2 -> ippon
  "throw.yuko":         "yuko",
  "takedown":           "not_scored",
  "clinch_engage":      "not_scored",
  "clinch_break":       "not_scored",
  "over_under":         "not_scored",
  "guard":              "not_scored",
  "half":               "not_scored",
  "side|mount|back + back_on_tatami + osaekomi_legal": {
      "5s": "yuko", "10s": "waza_ari", "20s": "ippon"
  },
  "exposure":           "not_scored",
  "step_out":           "not_scored",        # intentional exit -> shido, G35
  "submission_attempt": "ippon_iff_legal_finish_else_not_scored",
  "control_score":      "ignore_as_points",
}

UWW_FS = {
  "takedown.control":                 2,
  "takedown_or_throw.feet_to_danger": 4,
  "throw.grand_amplitude_danger":     5,
  "throw.grand_amplitude_no_danger":  4,
  "throw.correct_no_danger":          2,
  "exposure":                         2,
  "reversal":                         1,
  "position_change.seats":            "not_scored",
  "clinch_*":                         "not_scored",
  "step_out":                         "REFUSE",   # see section 4
  "submission_attempt":               "not_scored_or_illegal",
  "control_score":                    "ignore_as_points",
  "activity_miss_30s":                1,          # to opponent
}

IBJJF = {
  "takedown_or_throw + top_3s":       2,
  "sweep = bottom_to_top from guard|half + top_3s": 2,
  "position_change.to_side_pass_3s":  3,
  "position_change.to_mount_3s":      4,
  "position_change.to_back_3s":       4,
  "half|guard|standing|clinch":       "not_scored",
  "exposure":                         "not_scored",
  "step_out":                         "not_scored",
  "submission_attempt":               "advantage_if_no_finish",
  "scoring_seat_lost_before_3s":      "advantage",
  "knee_on_belly":                    "UNMAPPED",
  "control_score":                    "ignore_as_points",
}

ABC = {
  "any_event":                   "evidence_only",
  "takedowns_round":             "count",
  "throw_points_round":          "amplitude_proxy",
  "submission_attempts_round":   "count",
  "control_score":               "duration_signal_not_points",
  "step_out":                    "not_scored",
  "10_point_must":               "judges",
}
```

---

## REFUSE list

1. **UWW step-out from the 1-D engine.** A 2-D boundary fact with no honest
   test. Fallback: do not auto-score; wrestling boundary points wait for a 2-D
   world. Same class of refuse as taekwondo.
2. **IBJJF knee-on-belly.** Published 2 pts / 3 s, but the engine has no seat.
   **Do not alias it to `half` or `side`.**
3. **UWW +1 for 5 s of held exposure.** Repeated in primers and older
   summaries; **not** in the Jan 2026 official bands. NONE PUBLISHED → do not
   award.
4. **Any shared "grappling score" averaging the four federations.**
5. **Judo points for `takedown` as distinct from `throw`.** IJF scores
   nage-waza, not control-on-the-hip.
6. **An MMA event→point table.** ABC publishes none; inventing 2-for-takedown
   or 4-for-mount would be an authored rule wearing a sourced one's clothes.
7. **A UWW submission win.** Freestyle has no such method.
8. **Osaekomi from guard or a wrapped half.** IJF toketa / not osaekomi.
9. **ADCC, JJIF Ne-Waza, UWW amateur MMA, folkstyle, sambo.** Out of scope;
   their numbers stay out of these tables.
10. **Population claims.** "Most matches see about two takedowns" is not a rule
    and is not used.

---

## Open questions for the operator (two)

1. **Does `submission_attempt` already mean IBJJF "real danger"?**
   *Default:* **yes** — the adapter awards one advantage when the event fires
   and the bout continues. Add `submission_threat` only if live traces show the
   event firing on non-dangerous grips.

2. **Keep the G34 engine/adapter split on judo osaekomi (engine 3 s tick,
   adapter 5/10/20)?**
   *Default:* **yes.** The passing test already assumes it. Do not move 10 s or
   20 s into the engine. If R91 cannot count adapter seconds from emitted
   ticks, **that is an R91 wiring bug, not a G34 reopen.**

# G70 - PLAN AND CORNER; COACH LINES THAT LIE

**Agent:** Grok (`TASK_FIGHTPLAN_DESIGN`, Q3 + Q5). Design only. 2026-09-24.
Depends on G68 (catalogue shape) and G69 (what the engines read).
*Collected S66 from Grok's sandbox file, verbatim. Brief: `G70_BRIEF.md`.*

---

## Q3 — PLAN AND CORNER

Today they are two dictionaries. The plan's `pace_curve` is three words fixed before the bell. `FightPlans.pace_for_round` is the reader that turns that curve into one word per round. The Stage B comment in `FightPlans.gd` already says that word is set on the corner at every bell unless a stool call overrides. The six realtime stool calls write `pace` and optionally `range` / `emphasis` for the **next round only**. There is no listen roll on the realtime path.

### Rule: the stool BENDS one round. It does not rewrite the plan. It is not refused for taste.

| Kind | What happens | Why |
|---|---|---|
| Compatible | Call's `pace` / `range` / `emphasis` is the round's word. | Same as today: stool wins its round. |
| Adjacent pace (cautious↔balanced, balanced↔aggressive) | Call wins the round. | One step is a corner adjustment, not a new fight. |
| Contradicts pace (cautious↔aggressive) or contradicts implied range | Call still writes. Engine reads a **bent** word: plan word pulled one step toward the call, not the call itself. | Full override makes the plan decoration between stools. Hard refuse makes the stool a lie — the player picked it and nothing moves. |
| Illegal | Already gated: `excludes_emphasis` (grappling off a boxing plan). Menu hides it. | Schema already has this reader: `FightPlans.excluded_emphasis`. |

Implied range is **not** a new plan field. G69 declined `preferred_range` on the plan. Derive the implication from fields that already exist:

- `stay_long` is native when opening `pace_curve` is `cautious` **or** `role_priority.setup` is PRIMARY and `damage` is not PRIMARY (out-boxer, deai, cut-kick controller).
- `get_inside` is native when opening pace is `aggressive` **or** `damage` is PRIMARY and `setup` is not (pressure, Dutch, Mat, clinch boxer).
- Everyone else has no implied range. Either stool range call is compatible.

"Go for the finish" (`aggressive` + emphasis finish) is compatible with any plan. It is a last-round overlay, not a style change. It does not rewrite `role_priority` or `target_bias`.

### What the engine reads, and when

At the bell of round N, one function owns the slot. The reader is the same place that already writes pace onto the corner at the bell:

1. If the stool wrote a call for N, take its `pace`. If the call contradicts (two-step pace, or range against the implication above), replace the written pace with the **one-step bend** toward the call. If the call wrote `stay_long` / `get_inside`, that range is the only `preferred_range` the realtime path reads this round. If it wrote `finish`, the existing emphasis slot for that round is set; it expires at the next stool.
2. Else `FightPlans.pace_for_round(plan, N, total)`. No range. No finish.

`target_bias`, `role_priority`, `phase` are never written by a stool pace/range call. `CornerAdvice.focus` (`breathe` / `defence` / `body` / `output`) stays speech. K72 already marked that path as utterance-only. Do not pretend "Go to the body" moves `target_bias` until that wire exists and has a reader.

Bend magnitude: the same converter that already turns a pace word into urgency and move cost (`FightBeatAdapter` / move costs, K72 Layer B). A contradicting call uses one step of that converter, not two. Do not author a new constant. Measure the existing step first; that measurement sets the number.

Expire at the next stool. The plan dictionary is never mutated.

### What the player sees when they disagree

- **Picker (before the bell):** unchanged. One `coach_line`. Pace summary already printed by `FightPlans.explain`. No second line about the corner.
- **Stool menu:** all six calls stay listed when legal for the ruleset. A contradicting call stays selectable and is tagged `AGAINST PLAN` plus one reason word from a field (`cautious`, `setup`, `aggressive`). No listen-roll chrome.
- **SAY on the card (K72 slot 6):** the call's own sentence. If bent, one clause after it: `He'll try — it's not the plan.` If compatible, the sentence alone.
- After the round the overlay is gone. Next stool the plan writes again unless a new call is picked.

### What I would not add

- A listen roll / obedience / personality check. Realtime has none. A roll nobody reads is how G68's clone lived.
- Plan-level `preferred_range`. G69 declined it. Range lives on the stool for one round.
- Per-plan `excludes_pace`. It would empty the stool for every cautious plan.
- Permanent plan mutation from a stool call.
- Mapping `CornerAdvice.focus` onto pace in this pass. That is a K72 wire, not a plan-schema change.

---

## Q5 — COACH LINES THAT LIE

A line lies when it names a thing the plan's own fields do not hold. G69's unread-engine problem is separate: even an honest line can be dead on realtime because `ROLE_PRIORITY_FROM_PLAN` is false. That is not fixed by rewriting copy.

Replacement only where the new sentence is tied to a field a reader already has (`pace_curve`, `target_bias`, `role_priority`, `phase`). No named technique, no seat, no scoring-rule number.

### Lines that promise what the fields do not do

| id | Line names | Fields actually hold | Replacement (only if a field backs it) |
|---|---|---|---|
| `boxing_out_boxer` | footwork | no footwork field. Has setup PRIMARY, cautious open, head 1.0 > body 0.7, standing | `Jab and move. Head shots. Make them come to you.` |
| `boxing_pressure` | cut the ring | no ring-cut field. Body-first is true (body 1.3 > head 0.9) | `Close distance, high output. Body first.` |
| `kickboxing_dutch_pressure` | hands-then-low-kick as a sequence | no sequence field. legs 1.4, aggressive x3 | `Volume to the legs. Head last.` |
| `kickboxing_thai_kicker` | teep | no technique id. body 1.4 / legs 1.4, setup+damage PRIMARY | `Body and legs. Measure, then break them down.` |
| `kickboxing_counter_striker` | check the kick | no check field. counter PRIMARY, head 1.2 | `Let them commit. Answer to the head.` |
| `muay_thai_khao` | walk them down; plum; knees; sweeps | opening pace is **cautious**, not a walk-down. No plum field. control+takedown PRIMARY, body 1.4 | `Slow start, then clinch. Body work.` |
| `muay_thai_tae` | teep | same as Thai kicker. legs 1.4 / body 1.3 | `Chop the legs and the body until they fold.` |
| `muay_thai_mat` | elbows; hunt the finish | no elbow field; finish is a stool call, not a plan field. head 1.4, damage PRIMARY, late aggressive | `Hands first. Head shots. Push late.` |
| `wrestling_attack_rate` | hand-fight | no hand-fight field. takedown+setup PRIMARY, aggressive x3 | `Shoot and re-shoot. Aggressive throughout.` |
| `wrestling_positional` | tie-up | no tie-up field. counter+control PRIMARY | `Let them come. Score the counter.` |
| `wrestling_scrambler` | funk | no funk/seat field. escape+transition PRIMARY | `Escape and change position. Don't hold.` |
| `bjj_guard_player` | pull; guard; from the bottom | no seat field (G69). takedown AVOID + ground + transition/submission PRIMARY is all it has | `No takedowns. Sweep or submit on the ground.` |
| `bjj_passer` | pass; hold the top | no seat field. takedown+transition+control PRIMARY, ground | `Take it down. Advance and hold.` |
| `judo_grip_thrower` | kumi-kata / grip | no grip field. setup+takedown PRIMARY, standing | `Set up the throw, then launch.` |
| `judo_newaza` | "any throw is a door" | throw is not PRIMARY (control/submission/transition are). phase ground is the honest part | `Get it down. Pin, turn, submit.` |
| `karate_blitz` | senshu; gyaku-zuki | no scoring-first field, no technique id. curve is aggressive/balanced/cautious | `Attack early. Then manage the pace.` |
| `karate_kicker` | three-pointer; jodan; sweeps to a downed man | no point-value field, no grounded-follow-up field. head 1.3, late aggressive | `Head first. Kick late.` |
| `karate_deai` | "timing beats speed" | flavor. counter PRIMARY, cautious/cautious/balanced | `Meet them on the way in.` |
| `tkd_cut_kick_controller` | cut kick is your jab; own the distance | no range field, no named kick. body 1.4, setup PRIMARY | `Body first. Set the exchange.` |
| `tkd_counter_kicker` | bounce | no bounce field. counter PRIMARY | `Read the first kick. Answer with a better one.` |
| `sambo_thrower_leglock` | stay standing for four; dive on the leg | no stand-timer field; submission PRIMARY is not "leglock". takedown+submission PRIMARY, phase any | `Throw, then hunt the submission.` |
| `sambo_hold_player` | hold for twenty seconds | no hold-clock field. control PRIMARY, late cautious | `Score, then hold. Slow down late.` |
| `mma_clinch_boxer` | cage; knees | no cage/knee field. control+damage PRIMARY, body 1.3, phase any | `Hold them close. Body shots. Wear them down.` |
| `mma_wrestle_gnp` | from the top | no seat field. takedown+control PRIMARY, phase ground | `Take them down. Hold. Damage from there.` |

### Lines that are honest to their fields

Leave these. They name only pace, bias, role or phase:

- `boxing_boxer_puncher` — setup+damage PRIMARY, late aggressive.
- `boxing_counter_puncher` — counter PRIMARY, cautious early, damage OPPORTUNISTIC.
- `muay_thai_femur` — counter+setup PRIMARY, cautious open. (Flat 1/1/1 is not claimed.)
- `bjj_submission_hunter` — submission PRIMARY, control OPPORTUNISTIC.
- `bjj_points_player` — control+transition PRIMARY, late cautious. ("Score early" is soft; opening pace is balanced, not aggressive. Close enough to keep.)
- `judo_counter_thrower` — counter PRIMARY.
- `sambo_counter_thrower` — counter PRIMARY.
- `tkd_head_hunter` — head 1.6, late aggressive. Best line-to-field match in the file.
- `mma_sprawl_and_brawl` — standing, takedown AVOID, damage+counter PRIMARY.
- `mma_submission_grappler` — ground, damage AVOID, takedown+submission+transition PRIMARY.

### Pairs whose lines differ and whose fields are indistinguishable

G68: 33 unique mechanical tuples of (`pace_curve`, `target_bias`, `role_priority`, `phase`) out of 34.

**Exact clone (only one):**

`bjj_points_player` ↔ `sambo_hold_player`

Same pace `balanced/balanced/cautious`, same flat `{1,1,1}`, same roles (control P, transition P, takedown S, submission O), same phase `ground`. Lines sell two sports ("advance the ladder" vs "hold for twenty seconds"). Different rulesets, so one picker never offers both — the player is not choosing between twins. The file still has two names for one fight.

No same-ruleset field twins exist. G68's "player could not tell apart" list (`out_boxer`/`counter_puncher`, `karate_blitz`/`kicker`, `bjj_passer`/`points_player`, `wrestling_positional`/`scrambler`) are **near** on feel and **not** identical in the file. They are a picker problem, not a clone problem. Do not merge them. Their lines should keep tracking the field that actually differs (pace or the PRIMARY role), which the replacements above do where a lie was named.

### What I would not add

- A second sentence per plan. The rule is one line.
- Technique names, seat names, commission clocks, or point values in the line. No reader.
- Rewriting honest lines to sound more different. Difference belongs in the fields (G68), then in a reader (G69), then in the line.

---

## STILL WRONG

The stool can now share one round of pace with the plan, but realtime still does not apply `role_priority`, and most ground lines still name seats no field holds.

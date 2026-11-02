# U59 — The unread effects

**MEASURED** first: `python Godot/tools/audit_technique_effects.py` against
`Godot/assets/data/technique_catalog.json` and every `Godot/scripts/**/*.gd`.
A key counts as **named** only when a script quotes it as a string literal
(`"balance_break"`). Bare identifiers are ignored — `balance`, `tempo`,
`risk` are ordinary GDScript words and inflate the count if matched as words.

```
140 distinct effect keys across 554 authored match.effects entries
 85 keys /  370 entries  are named somewhere in code (string literal)
 55 keys /  184 entries  are named NOWHERE
```

These three counts match the task-file snapshot. Reproduced, not trusted.

**Generic consumers (still true):** every effect, read or unread, feeds
`FightSimulation._technique_magnitude` (`:2639`) via `sum(abs(value))`.
Unread ≠ inert for magnitude. **Do not delete a NOISE key** without an
operator ruling — removing it would shrink that technique's magnitude and
can move a seeded fight.

---

## Counts (triage of the 55)

| Bucket | Keys |
| --- | ---: |
| **MECHANIC** | 22 |
| **DUPLICATE** | 23 |
| **NOISE** | 7 |
| **NOT FOUND** | 3 |
| **Total** | **55** |

---

## 1. Triage table (55 rows)

| Key | Techs | Values | Verdict | One-line reason |
| --- | ---: | --- | --- | --- |
| `angle_read` | 1 | 7 | **DUPLICATE** | Same job as named `angle_attack` / `distance_read`; rename data. |
| `angle_reset` | 1 | 11 | **DUPLICATE** | Same job as named `angle_exit`; one-off synonym. |
| `balance` | 1 | 5 | **NOISE** | Only on `boxing_stance_guard` beside `guard`; no modelled balance reader. Removing costs a magnitude change on that one node. |
| `balance_break` | 16 | 5..15 | **MECHANIC** | Off-balance authored across teeps, dumps, trips, sweeps; wiring changes takedown/sweep outcomes. |
| `body_score` | 1 | 5 | **DUPLICATE** | Point-fight score, not damage; nearest named twin is `control_score`. |
| `boundary_score` | 1 | 8 | **DUPLICATE** | Score twin of named `boundary_control` / `control_score`. |
| `close_damage` | 1 | 12 | **DUPLICATE** | Rename to named `damage` or `clinch_damage`. |
| `close_range` | 1 | 7 | **DUPLICATE** | Rename to named `range` / `range_control`. |
| `combo_accuracy` | 5 | 9..15 | **DUPLICATE** | Accuracy under another name; named `accuracy` already exists. |
| `combo_speed` | 14 | 5..17 | **MECHANIC** | Combination pace across 14 chains; not the same as `entry_speed`. |
| `counter_accuracy` | 5 | 5..13 | **DUPLICATE** | Accuracy on counters; rename to `accuracy`. |
| `counter_chain` | 3 | 15..18 | **MECHANIC** | Linking counters; high values, clear combo-of-counters intent. |
| `counter_damage` | 12 | 6..13 | **MECHANIC** | Counter-strike damage layer; 12 techniques, would change fire-back. |
| `counter_ready` | 4 | 5..7 | **MECHANIC** | Preparedness to fire a counter; broader than named `counter_open`. |
| `counter_risk` | 1 | 6 | **DUPLICATE** | Twin of named `risk`. |
| `counter_score` | 1 | 9 | **DUPLICATE** | Twin of named `control_score`. |
| `counter_timing` | 1 | 8 | **NOISE** | One-off; no second authoring. Removing costs magnitude on that node only. |
| `cut_chance` | 6 | 6..13 | **MECHANIC** | Cut probability on elbows/GNP; wires to existing cut/wear path. |
| `decision_quality` | 2 | 10..17 | **NOT FOUND** | Name suggests Fight IQ on a move; no clear named twin and no consumer shape found. |
| `distance_mastery` | 2 | 9..17 | **DUPLICATE** | Twin of named `distance_read`. |
| `distance_reset` | 1 | 8 | **DUPLICATE** | Twin of named `range_control` / `distance_read`. |
| `energy_efficiency` | 1 | 7 | **NOISE** | One-off; no stamina-efficiency reader. Removing = magnitude only. |
| `feint` | 7 | 4..9 | **MECHANIC** | Deception / level-change feint; changes setup success if wired. |
| `finish_chance` | 10 | 6..12 | **MECHANIC** | Finish bias on damage/submission/adaptation nodes. |
| `followup_open` | 1 | 8 | **DUPLICATE** | Twin of named `combo_open` / `chain_open`. |
| `guard_break` | 1 | 12 | **MECHANIC** | Opening the guard is a real behaviour; n=1 but unambiguous. |
| `guard_bypass` | 1 | 8 | **NOISE** | One-off near `guard`; no distinct consumer intent found. |
| `guard_split` | 1 | 8 | **NOISE** | One-off near `guard`; same. |
| `head_route` | 4 | 5..12 | **MECHANIC** | Preferred path to the head, not head damage (see §2). |
| `intercept` | 2 | 7..10 | **MECHANIC** | Stopping an incoming attack; counter-layer sibling of `stop_hit`. |
| `kick_accuracy` | 1 | 9 | **DUPLICATE** | Twin of named `accuracy`. |
| `kick_balance` | 1 | 5 | **NOISE** | Stance twin of unread `balance` on kickboxing guard; neither is read. Removing = magnitude on that node. |
| `kick_counter` | 2 | 9..11 | **MECHANIC** | Kick-specific counter; counter layer. |
| `kick_ready` | 1 | 5 | **DUPLICATE** | Twin of named `check_readiness` / `takedown_ready`. |
| `kick_speed` | 2 | 8..11 | **DUPLICATE** | Twin of named `entry_speed`. |
| `knee_setup` | 2 | 5..9 | **MECHANIC** | Setup into knees; clinch offense intent. |
| `momentum_shift` | 2 | 6..9 | **NOT FOUND** | Vague name; no named twin and no engine "momentum" grain found here. |
| `opponent_stamina` | 6 | −10..−5 | **MECHANIC** | Only negative unread family; drains the other man's gas if wired. |
| `precision` | 3 | 6..11 | **DUPLICATE** | Twin of named `accuracy`. |
| `pushback` | 6 | 5..10 | **MECHANIC** | Force separation; would touch range/separation. |
| `reaction_punish` | 1 | 15 | **MECHANIC** | n=1 but value 15 and name is a clear punish-the-reaction beat. |
| `return_angle` | 2 | 6..8 | **DUPLICATE** | Twin of named `angle_exit` / `angle_entry`. |
| `return_damage` | 1 | 4 | **DUPLICATE** | Twin of named `damage`. |
| `rhythm_control` | 4 | 6..18 | **MECHANIC** | Pace ownership; stronger and wider than the single named `rhythm` entry. |
| `rhythm_setup` | 1 | 6 | **DUPLICATE** | Twin of named `rhythm`. |
| `rotation_power` | 3 | 6..10 | **MECHANIC** | Spin/rotation power on turning kicks; not plain `damage`. |
| `score_or_damage` | 11 | 5..15 | **MECHANIC** | Point-fight dual outcome across throws and chains. |
| `stop_hit` | 10 | 6..11 | **MECHANIC** | Operator's knee-on-the-shot; intercepting strike on an entry. |
| `straight_damage` | 1 | 9 | **DUPLICATE** | Twin of named `damage`. |
| `style_switch` | 2 | 7..9 | **NOT FOUND** | Could mean stance or discipline switch; no consumer or twin found. |
| `submission_safety` | 1 | 7 | **NOISE** | On GNP; deliberately omitted from `FightMoves.GRAPPLE_EFFECTS` so the strike palette keeps it — the key itself is never modelled. Removing still changes magnitude. |
| `surprise` | 7 | 6..10 | **MECHANIC** | Deception / unexpected attack bias across 7 techniques. |
| `target_switch` | 2 | 9 | **MECHANIC** | Changing target mid-combo; distinct from a single region tag. |
| `tempo` | 3 | 5..8 | **DUPLICATE** | Twin of named `rhythm`. |
| `turning_bonus` | 1 | 7 | **DUPLICATE** | Twin of named `turn`. |

---

## 2. Substring bucketer — **CONFIRMED** defect (partial)

**Code read:** `FightSimulation._technique_target_region` at `:2143-2159`.

```2143:2159:Godot/scripts/FightSimulation.gd
static func _technique_target_region(technique: Dictionary, role: String, rng: RandomNumberGenerator, plan_bundle: Dictionary = {}) -> String:
	var effects: Dictionary = technique.get("match", {}).get("effects", {})
	var head := 0.0
	var body := 0.0
	var leg := 0.0
	var arm := 0.0
	for key_value in effects:
		var key := str(key_value)
		var weight := absf(float(effects[key_value]))
		if key.find("head") != -1:
			head += weight
		elif key.find("leg") != -1:
			leg += weight
		elif key.find("body") != -1 or key.find("liver") != -1 or key.find("torso") != -1:
			body += weight
		elif key.find("arm") != -1 or key.find("shoulder") != -1:
			arm += weight
```

**Comment at `:2137-2142` (INFERENCE from comment):** the author intended
locational keys (`head_damage`, `body_damage`/`liver`, `leg_damage`/
`leg_attack`). The implementation matches those **substrings anywhere** in
the key name.

**MEASURED — every key among the 140 that trips those five substrings:**

| Key | Status | Techs | Substring hit | Bucket intent? |
| --- | --- | ---: | --- | --- |
| `head_damage` | named | 13 | `head` | Yes — intended |
| `body_damage` | named | 18 | `body` | Yes — intended |
| `leg_damage` | named | 4 | `leg` | Yes — intended |
| `leg_attack` | named | 5 | `leg` | Yes — comment lists it |
| `head_route` | **unread** | 4 | `head` | **No** — route ≠ damage |
| `body_score` | **unread** | 1 | `body` | **No** — score ≠ damage |
| `front_headlock_open` | named | 2 | `head` | **No** — grapple open, not head damage |

**MEASURED:** no catalog key contains `liver` or `torso`. The comment
anticipates them; the data does not.

**Verdict: CONFIRMED** for `head_route` and `body_score` on the
`FightSimulation` path — they add weight to head/body as if they were
damage tags. **Also CONFIRMED** for `front_headlock_open` (named, but
still wrong under the substring rule).

**Contrast (MEASURED by reading `FightMoves._regions_for` `:540-562`):**
the realtime strike palette uses an **exact** `match` on
`head_damage` / `body_damage` / `clinch_damage` / `ground_damage` /
`leg_damage` / `lowline_damage` / `kick_damage`. That path does **not**
mis-bucket `head_route` or `body_score`. The defect is in the simulation
helper, not in the move builder. A comment in `_regions_for` even records
that reading bare `damage` as head was tried and rejected.

---

## 3. Design questions — rank and price, no winner

### (a) Balance: eighth ATTRIBUTE vs per-tick STATE

**MEASURED spread of `balance_break` (16 techs, values 5..15):**
- Soft / setup: teep `5`, catch-sweep `6`, front trip `5`, several counters `5..6`
- Medium dumps/trips: `8..11`
- Heavy: clinch dump `14`, silat off-balance chain `15`

**INFERENCE:** that spread reads as authored for a **temporary off-balance
state** (a teep softens; a dump wrecks), not for a permanent attribute
point. An attribute could still exist on top; the authored numbers do not
require it.

| Rank | Option | What it buys | What it costs | Seeded-fight impact |
| ---: | --- | --- | --- | --- |
| 1 (cheaper) | **Per-tick STATE** | Teep/dump/sweep writes a short-lived balance deficit; `takedown_resolve` / sprawl reads it. Nothing in the save. Matches the 5-vs-14 authoring. | Fight-local float + decay on `FightRealtime` / fighter dict; one reader in `GrappleResolve` (or caller). No `STAT_KEYS` change. | **Behaviour change** once wired — not silent. |
| 2 (expensive) | **Eighth ATTRIBUTE** | Some fighters are permanently harder to dump/sweep. Shows on every profile/dev screen. | Save-format bump; `STAT_KEYS` is identical in `GameState.gd:182`, `Aging.gd:67`, `AthleteDevelopment.gd:34`, `DevelopmentPanel.gd:28` (also `ProfileRevampPanel`, `WorldPopulation`, `FightOpponentGenerator`). `FightSimulation.STAT_KEYS` is still the **six**-stat pre-grapple list — another sync hazard. Aging curves, development budgets, generators, every stat strip. | Same: behaviour change; plus every new save and every UI that lists seven stats. |

**Ship cheaper first without blocking the other (INFERENCE):** land STATE
only. Keep the attribute door open by reading
`state_balance + f(attribute_balance)` later, with attribute defaulting to
a neutral 50 so old saves need no migration until the attribute ships.
STATE does not write the save; ATTRIBUTE can layer on without rewriting
the state machine.

---

### (b) Counter layer: can a shot be met with a strike?

**Today (MEASURED):** `FightRealtime._grapple_standing` `:2052-2097` —
gate picks shoot vs clinch vs neither; on shoot it calls
`Grapple.takedown_resolve` with standing weights (attacker
grapple/power/speed/technique/fight_iq vs defender
grapple/defense/speed/fight_iq). Failure → stamina drain on both +
`takedown_attempt` / stuffed log. **No technique effects are read.**
`stop_hit` / `intercept` / `counter_damage` never enter.

| Rank | Option | Insert point | Reads | On success | Cost |
| ---: | --- | --- | --- | --- | --- |
| 1 | **Stuff-only counter** (fail the shot, no blow) | After shoot is chosen (`:2075`), **before** `takedown_resolve` (`:2076`), roll defender's best learned technique that carries `stop_hit` or `intercept`. If it wins, skip resolve and log stuffed-with-counter. | Defender technique `stop_hit` / `intercept` (+ maybe `pushback`). | Takedown fails; optional extra sprawl/counter stamina cost. No impact path. | Small. Outcomes change (more stuffs when defender owns those techniques). |
| 2 | **Counter blow through impact** | Same insert; on success call the normal strike impact path with that technique (shock/KD eligible). | `stop_hit` / `intercept` / `counter_damage` for magnitude; then existing impact pipeline. | Shot fails **and** defender can hurt/shock/drop the shooter. | Larger. New RNG stream or a carefully sliced existing one (R83/R84 stream discipline). Touches stamina, wear, knockdown rules. |
| 3 | **Fold into `takedown_resolve` weights** | Inside `GrappleResolve.takedown_resolve` — add defender technique terms. | Same keys, but as weight modifiers on the existing success probability. | Still binary success/fail; no separate counter event. | Medium module change; harder to present "knee on the shot" as its own beat. |

**Safety rule (plain):** adding any of these **changes fight outcomes**.
Seeded verdicts, scorecards and stoppages will **not** stay byte-identical.
This cannot ship as a silent refactor. It needs an operator ruling that
behaviour change is accepted (and tests re-pinned).

**Where the branch is, in one sentence:** the whole standing-shot window is
`:2070-2097`; the counter resolves in the gap between "gate says shoot"
and `takedown_resolve`, or on the failure path before `continue` — never
after `_move_seat` has already put someone on the ground.

---

## Method note

- Catalog walk: each discipline node’s `match.effects` dict.
- Code walk: string-literal match only, all `Godot/scripts/**/*.gd`.
- Script kept at `Godot/tools/audit_technique_effects.py` so the counts can
  be re-run when the catalogue grows.

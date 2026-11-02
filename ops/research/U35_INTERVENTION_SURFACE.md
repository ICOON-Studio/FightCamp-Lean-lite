# U35 — What RingStagePanel lets the player do to a live fight

Survey only. No replacement design. Ownership first, because the trap
named in the task is real: **`FightNightScreen` is the host** — it owns
`_fight_state`, the `Timer`, and every call into `FightSimulation`.
**`RingStagePanel` is its child view** — it presents, arms the 8-second
combo alert, and on timeout is the one place the panel itself mutates
fight state. R96's "second caller" means both files *name*
`FightSimulation`; it does not mean two independent loops.

Anchors below are `file:line` on the tree this was written against.

---

## 1. The full verb list (player *changes* the fight)

### Host — `FightNightScreen.gd`

| Method | Signature | Who calls it | What it does to `_fight_state` |
| --- | --- | --- | --- |
| `_on_instruction` | `(side: String, option: Dictionary) -> void` | `_on_dock_press` after a corner button | **Mutates.** Calls `FightSimulation.apply_corner_instruction(_fight_state, side, option)` at `:527`. May write `fighter.corner` pace/emphasis, `range_call` / `range_intent`, `called_chain`, or route into `react_to_combo` when `option` has `reaction`. Records `last_corner_outcome`. |
| `_on_dock_press` | `(side: String, index: int) -> void` | Dock `on_press` from `show_dock` / idle dock | Routes `"resume"` → `_resume`; else looks up `_dock_options[side][index]` and calls `_on_instruction`. No direct state write. |
| `_resume` | `() -> void` | Dock resume; `_on_combo_resolved`; live/combo after an instruction | **Does not mutate fight state.** Hides interrupt dock, restores idle dock, restarts `_timer` (`:538-545`). Unanswered pauses are resolved by the *next* `advance_exchange` (see §2). |
| `_on_combo_resolved` | `(_side: String, _outcome: Dictionary) -> void` | `RingStagePanel.combo_resolved` (`:312`, `:548`) | Calls `_resume` only. The mutation already happened in the panel. |
| `_idle_dock` / `_dock_sides` | build standing options | `setup`, `_resume`, after open | Presentation of options; the press path is still `_on_instruction`. Idle filters to pace-ish calls (`pace_only`, `:487-490`). |
| `_on_begin` | `() -> void` | `RingStagePanel.begin_pressed` | Starts the host clock. Re-binds the view to the same `_fight_state`. No engine write. |
| `_on_speed` | `(speed: float) -> void` | `RingStagePanel.speed_changed` | Presentation only — retimes `_timer`, mirrors speed into the view. |
| `_show_command_bar` | `(pending: Dictionary) -> void` | `_on_tick` when `is_decision_point` is active | Stops the clock (caller already did), opens interrupt dock. No engine write. |
| `_finish` / `_record_live` | post-bout | after `is_fight_over` | Finalize / persist result — end of fight, not a mid-bout intervention. |

Standing pace presses use the same `_on_instruction` path with
`_dock_applies_live = true` (`:464-468`, `:528-529`): they **do** write
corner state via `apply_corner_instruction`, and they **never** stop the
clock.

### View — `RingStagePanel.gd`

| Method | Signature | Who calls it | What it does to `_fight_state` |
| --- | --- | --- | --- |
| `_on_combo_timer_lapsed` | `() -> void` | Combo timer timeout | **Mutates.** `FightSimulation.react_to_combo(_fight_state, side, "instinct")` at `:1200`, then emits `combo_resolved`. This is the intervention verb R96 named. |
| `show_dock` / `set_idle_sides` / `hide_dock` | dock chrome | Host | Display + callback wiring. The press callback is the host's. |
| `present_event` / `refresh` / `bind_fight` | presentation | Host tick loop | Read / mirror references. `refresh` may arm the combo alert from `_pending_decision` but does not answer it. |
| `set_speed` / tape begin / close / return | signals | Player chrome | Emit to host; no fight-state write. |

**Not a player verb (engine/test only):** `FightSimulation.force_chain`
(`FightSimulation.gd:2002-2020`) can refuse with `chain_refused` while a
decision is pending (`:2005-2006`). The live dock never calls it; a heard
`"call_chain"` instruction only queues `fighter["called_chain"]`
(`:764-766`) for a later exchange.

**Verb count for the mail line:** two mutating entry points the player
can reach — `apply_corner_instruction` (host dock, including reactions
and pace) and `react_to_combo` (panel timeout, also reached via dock
`reaction` options through `apply_corner_instruction` at
`FightSimulation.gd:730-731`).

---

## 2. Every pause point

All of them share one flag: `fight_state["_pending_decision"]` with
`active: true`. The host is the only thing that *stops the clock* for
them (`FightNightScreen.gd:417-424`).

| Type | Opens | Closes | If the player answers nothing |
| --- | --- | --- | --- |
| `combo_incoming` | Mid-chain in `_continue_chain` when the defender is coached and the interrupt link is due (`FightSimulation.gd:1687-1694`, prompt built at `:1852`). Host sees `is_decision_point` (`:597-601`) after the paused event. Panel `_refresh_combo_state` arms the 8s alert (`RingStagePanel.gd:1112-1122`, `:1128`). | `react_to_combo` clears `_pending_decision` (`:1988`); next `advance_exchange` resumes the chain. | **Two fail-safes.** (1) Panel timer → `react_to_combo(..., "instinct")` (`:1195-1203`). (2) Host RESUME without answering → next `advance_exchange` hits `_continue_chain` with `prompted` already true and applies instinct (`:1695-1701`, and the resume comment at `:524-526`). |
| `between_rounds` | `_close_round` after scoring / plan pace / coach suggestions (`FightSimulation.gd:2828-2833`). | Cleared when a non-paused exchange completes (`advance_exchange` `:573`), or on fight finish (`:2858`). | RESUME alone does not clear it. The next tick runs an exchange, which **wipes** `_pending_decision` at `:573`. Prior corner pace/emphasis stand; the window is discarded. |
| `hurt_reaction` | After a completed exchange, if `_newly_hurt_side` is set (`:582-589`). | Same clear at `:573` on the next completed exchange, or finish. | Same as between-rounds: RESUME then advance drops the prompt; no automatic "survive/finish" is applied. |

`is_decision_point` (`:597-601`) is a **read** of `_pending_decision`, not
a fourth pause type. There is no other pause model in the atomic engine:
the host only stops when that dict is active *and*
`_coached_sides` is non-empty (`FightNightScreen.gd:419-424`).

**Finding (not fixed):** for `between_rounds` / `hurt_reaction` there is
no timeout equivalent to the combo's 8 seconds. Silence + RESUME means
"keep previous corner settings and continue."

---

## 3. What each intervention actually costs the fight

### `react_to_combo` (`FightSimulation.gd:1965-1996`)

Writes **chain state and clears the decision**, not a one-off display
flag:

1. Validates `_pending_decision.type == "combo_incoming"` and side.
2. Listen roll (rapport / fight IQ / hurt / gassed) unless reaction is
   `"instinct"` (`:1979-1986`).
3. `_set_chain_reaction` (`:1930-1958`) sets on `_active_chain`:
   - `reaction` (concrete: cover / fire_back / counter / angle_out /
     shoot / …)
   - `reaction_set = true`
   - `mods` — e.g. cover → `defense_bonus` + `damage_scale`; angle_out →
     `break_chance`; counter/shoot/fire_back → technique ids used when
     the chain continues.
4. Clears `_pending_decision` (`:1988`).

The **next** `advance_exchange` continues the chain under those mods
(break chance, defense, counter technique). So this changes rolls and
outcomes of subsequent links, not merely chrome.

### `apply_corner_instruction` (`:724-771`)

- With `reaction` → delegates to `react_to_combo` (`:730-731`).
- Otherwise listen roll; on success mutates `fighter["corner"]`
  pace/emphasis, or `range_call` + `range_intent`, or queues
  `called_chain`. On failure, previous corner instruction stands
  (`:719-721`, `:768-769`). Always stores `last_corner_outcome`.

### Standing pace (idle dock)

Same `apply_corner_instruction` path while the fight is running. Costs
future exchange behaviour (pace / emphasis / range intent / called
chain), not the current exchange already in flight.

---

## 4. Real-time engine buckets (`FightRealtime.gd`)

Read at `begin` `:325`, `advance_tick` `:550`, `result` `:648`. Rest
minutes record AI `corner` advice (`:738-739`, `_corner_minute` /
`Advice.advise`) — narrative content, not a player prompt. Grep finds
**no** `coached_sides`, `_pending_decision`, `react_to_combo`,
`apply_corner_instruction`, or player pause in this file.

| Intervention | Bucket | Why |
| --- | --- | --- |
| Body / strip / rails / callout / broadcast / range chrome | **Has an equivalent** (display) | Adapter can emit action-shaped events + body/stamina reads the panel already consumes. Rest is continuous; no exchange lump required for *drawing*. |
| Playback speed / begin / leave | **Has an equivalent** | Host-owned presentation; independent of engine. |
| Between-rounds contingency dock | **Could have one cheaply** | RT already stops combat during rest (`advance_tick` `:584-587`) and already builds a corner minute. A host-level pause over that minute could offer pace/emphasis without a new mid-tick protocol. |
| Standing pace / range / emphasis calls | **Could have one cheaply** | If `FightIntent` (or a corner bag on the fighter) grew the same flags the atomic corner writes, presses could be live again with no combo model. |
| `hurt_reaction` finish/survive prompts | **Could have one cheaply** | Hurt/trauma already exist; a host pause after a shock event is a policy choice, not a new physics subsystem. |
| `react_to_combo` / `combo_incoming` / 8s instinct | **Has nothing — needs new engine surface** | No chains, no mid-action pause, no interrupt link, no reaction mods. The 20 Hz loop never asks the player a question. |
| `call_chain` / `force_chain` / `chain_refused` | **Has nothing — needs new engine surface** | No sequence technique window in RT. |
| Coach listen / rapport roll on instructions | **Has nothing** (as a player verb) | RT corner advice is authored text at the bell, not a listen roll on a player call. |

`react_to_combo` lands in **has nothing and would need new engine surface**.

---

## 5. The coached-sides contract

Stored on the fight as `fight_state["coached_sides"]` at
`FightSimulation.begin_fight` (`:445`), copied from
`options["coached_sides"]`. The host keeps a parallel
`_coached_sides` used to decide whether to open the dock
(`FightNightScreen.gd:419`) and which sides get options (`:480`).

| Entry path | How `_coached_sides` / options are set |
| --- | --- |
| **Lab / test** (`_open_test`, `:152-198`) | Always `_coached_sides = ["a", "b"]` and `options["coached_sides"] = ["a", "b"]` (`:177-185`). Both corners pause on incoming combos. |
| **Live player bout** (`_open_live`, `:202+`) | Resolves `_player_side` from booked athlete (`:227-235`). If `_player_side` non-empty **and** `mode != "watch"`: `_coached_sides = [_player_side]` and same in options (`:239-241`). |
| **Spectator watch** | `mode == "watch"` skips the coached assignment (`:239`). If no player side, `_coached_sides` stays `[]` from `setup` (`:122`) and observation flips to `"watch"` (`:244-245`). Empty coached → `_on_tick` never opens a corner window (`:419-420`). |

Panel combo arming also requires the defender in
`fight_state.coached_sides` (`RingStagePanel.gd:1116-1118`) — host list
and engine list must agree.

**What a real-time fight must preserve:** the same three-way policy
(lab both / live one / watch none). Without it, either every bout pauses
for nobody's corner or a spectator is trapped in interrupt chrome.

---

## 6. Display-only surface (adapter emit list)

These paths **read**; they do not call `apply_corner_instruction` /
`react_to_combo`.

### Callout — `_say_event` (`RingStagePanel.gd:440-477`)

Event keys: `type`, `actor_side`, `technique_name` / `chain_name`,
`landed`, `range_band`, `target_side`, `target_region` /
`target_body_region`, `entered_range`, `range_from`, `range_to`.
Also fight_state: `phase`, `round`.

### Strip — `_record_strip_event` / `_strip_entry_from` (`:1058-1107`)

Event keys: `type`, `actor_side`, `target_side`, `technique_id`,
`technique_name`, `role`, `landed`, `reaction`, `chain_id`,
`chain_name`, `link_ids`, `paused`, `links` (each link: same move keys
plus `reaction`).

### Body regions — `_apply_body_event` / `_sync_body` (`:1026-1055`)

Event: `body_changes[]` with `side` / `target_side`, `region` /
`target_body_region`, `after` / `value_after`; fallbacks from event
`target_side` / `target_region`.
Fighter refresh: `body_regions` / `body_condition` / `body_readiness`
for `LIVE_BODY_REGIONS` (`:59`).

### Rails — `_refresh_rails` (`:770-799`)

From fight_state / contract fold: per-side `condition_rail`
head/body/legs/gas, `chips`, and live `hurt`.

### Range rail — `_refresh_range` (`:805-815`)

Fight_state: `phase` (STANDING gate); `RangeRail.update` reads the live
range band / owner from the state the atomic engine already carries.

### Broadcast readout — `_refresh_broadcast_readout` (`:1308-1319`)

Feeds `BroadcastRead.build` with presented `action` events (or
`fight_state.log`): whatever U19/U21 already require on actions
(thrown/landed/burst/span/stance — consumed inside `BroadcastRead`, not
re-parsed here).

### Stage animation — `_animate` (`:888-966`)

Action events only: `actor_side`, `target_side`, `landed`,
`animation_family` (or `role` via `_family`), `damage`, `outcome`.

### Combo alert chrome (display half)

Reads `_pending_decision` fields when arming (`:1128-1154`):
`defender_side`, `attacker_side`, `revealed`, `links_total`,
`links_landed`, `chain_name`, `default_reaction`. The timeout half is
the intervention in §1, not display-only.

---

## 7. Findings (bugs / seams — not fixed)

1. **Idle-dock filter key mismatch** (`FightNightScreen.gd:487`): pace
   filter checks `option.has("chain_id")`, but corner chain offers are
   keyed `call_chain` (`FightSimulation.gd:672-675`). "Let the X go" can
   leak into the standing pace strip (capped by `IDLE_PACE_LIMIT`).
2. **Between-rounds / hurt have no timeout**; RESUME + advance silently
   drops the prompt (`:573`). Combo is the only pause with an automatic
   answer.
3. **Dual combo closers** (dock reaction via host, instinct via panel
   timer) are intentional; RESUME-without-answer relies on the engine's
   instinct path in `_continue_chain`, not on clearing pending in
   `_resume`.

---

## 8. Recommendation (one paragraph)

Treat the **display surface as a port**: the adapter should emit the
event and state keys in §6 and leave `RingStagePanel`'s present/refresh
path alone. Treat **standing pace and the between-rounds contingency as
a cheap host-level port** onto the real-time rest minute that already
exists — same coached-sides contract, no mid-tick pause protocol.
Treat **`react_to_combo` / the 8-second chain interrupt as a cut for the
first real-time cut**, not a port: the 20 Hz engine has no combo window,
no pause point, and nothing that asks the player a question, and
building that is new engine surface rather than a beat adapter. If the
product later insists on mid-combination corner answers, that is a
**rebuild** of the interrupt model on tick time, not a splice of the
atomic chain. Shipping real-time while still promising the current
combo verb without that rebuild would be the expensive mid-build
discovery R96 warned about.

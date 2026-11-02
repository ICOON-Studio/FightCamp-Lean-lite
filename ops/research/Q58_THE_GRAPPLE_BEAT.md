# Q58 — WHAT A GRAPPLE BEAT WOULD HAVE TO CARRY

## Q1 — What `_log_grapple` writes, per kind

### Base fields (every event)

`_log_grapple` at `FightRealtime.gd:2014` stamps four keys before merging the
caller's `fields` dict:

| Key | Type | Example | Source |
|-----|------|---------|--------|
| `type` | String | `"grapple"` | DOCUMENTED `:2015` |
| `tick` | int | `412` | DOCUMENTED `:2016` |
| `t_s` | float | `20.6` | DOCUMENTED `:2017` |
| `round` | int | `2` | DOCUMENTED `:2018` |

### Per-kind fields

**takedown_attempt** — `FightRealtime.gd:2088` (failed shot from standing)

| Key | Type | Example |
|-----|------|---------|
| `kind` | String | `"takedown_attempt"` |
| `actor` | String | `"a"` |
| `target` | String | `"b"` |
| `success` | bool | `false` |
| `grade` | int | `0` |
| `to_seat` | String | `"none"` |

**throw_attempt** — `FightRealtime.gd:2175` (failed shot from clinch)

Identical shape to `takedown_attempt`. Same six keys.

**stall** — `FightRealtime.gd:2134` (clinch), `FightRealtime.gd:2319` (ground)

| Key | Type | Example | Notes |
|-----|------|---------|-------|
| `kind` | String | `"stall"` | |
| `stage` | int | `1` | Increments per fire |
| `actor` | String | `"a"` | Top side (clinch: `:2136`; ground: `:2321`) |
| `target` | String | `"b"` | `""` if top is `""` (clinch only) |
| `seat` | String | `"over_under"` / `"side"` | Clinch seat or ground seat |

**seat** — `FightRealtime.gd:2243` (from `_move_seat`, every transition)

| Key | Type | Example |
|-----|------|---------|
| `kind` | String | `"seat"` |
| `actor` | String | `"a"` |
| `target` | String | `"b"` or `""` |
| `from_stance` | String | `"standing"` |
| `from_seat` | String | `"none"` |
| `to_stance` | String | `"clinch"` |
| `to_seat` | String | `"over_under"` |
| `top` | String | `"a"` |
| `via` | String | see below |
| `gate_ticks` | int | `10` |

`via` values observed: `clinch_engage`, `clinch_break`, `takedown`, `throw`,
`stall`, `stand_up`, `sweep`, `escape`, `pass`, `mount`, `back`.
DOCUMENTED `:2114`, `:2186`, `:2148`, `:2101`, `:2185`, `:2381`, `:2383`,
`:2386`, `:2349-2365`.

**Hold-gate score** (dynamic kind) — `FightRealtime.gd:2285`

Fires when a pending seat is kept long enough. `kind` comes from
`pending["kind"]` — one of `"takedown"`, `"throw"`, `"position_change"`.

| Key | Type | Example |
|-----|------|---------|
| `kind` | String | `"takedown"` / `"throw"` / `"position_change"` |
| `actor` | String | `"a"` |
| `target` | String | `"b"` |
| `seat` | String | `"guard"` |
| `from_seat` | String | `"none"` |
| `to_seat` | String | `"guard"` |
| `grade` | int | `2` |
| `points` | int | `0` |
| `via` | String | `"takedown"` |
| `held_ticks` | int | `20` |

DOCUMENTED `:2285-2295`.

**submission_attempt** — `FightRealtime.gd:2352`

| Key | Type | Example |
|-----|------|---------|
| `kind` | String | `"submission_attempt"` |
| `actor` | String | `"a"` (top) |
| `target` | String | `"b"` (bottom) |
| `seat` | String | `"mount"` |

**submission_finish** — `FightRealtime.gd:2417`

Built from a `record` dict (`:2395-2411`) then augmented with `kind`, `actor`,
`target` at `:2413-2415`. Carries BOTH spelling conventions:

| Key | Type | Example | Notes |
|-----|------|---------|-------|
| `kind` | String | `"submission_finish"` | Added `:2413` |
| `actor` | String | `"a"` | Side letter, added `:2414` |
| `target` | String | `"b"` | Side letter, added `:2415` |
| `attacker` | String | `"fighter_03"` | **Fighter ID**, not side letter `:2397` |
| `defender` | String | `"fighter_07"` | **Fighter ID**, not side letter `:2398` |
| `attacker_side` | String | `"a"` | Side letter `:2399` |
| `seat` | String | `"mount"` | `:2400` |
| `hold_family` | String | `"OTHER"` | `:2401` |
| `hold_id` | String | `""` | `:2402` |
| `finish_mode` | String | `"TAP"` | `:2403` |
| `attempt_start` | int | `390` | Tick `:2404` |
| `method` | String | `"submission"` | `:2405` |
| `tick` | int | `412` | **Redundant** with base `:2396` |

**control** — `FightRealtime.gd:2449`

| Key | Type | Example |
|-----|------|---------|
| `kind` | String | `"control"` |
| `actor` | String | `"a"` (top) |
| `target` | String | `"b"` (bottom) |
| `seat` | String | `"side"` |
| `units` | int | `2` |

### Kind count correction

Q56 listed twelve kinds including `clinch_engage` and `clinch_break` as
separate kinds. DOCUMENTED: they are **`via` values on a `"seat"` kind event**,
not independent kinds. `_move_seat` at `:2114` passes `via="clinch_engage"`
with an empty scoring dict; `_log_grapple` at `:2243` writes `kind: "seat"`.
The actual distinct `kind` values in the log are **ten**: `takedown_attempt`,
`throw_attempt`, `stall`, `seat`, `takedown`, `throw`, `position_change`,
`submission_attempt`, `submission_finish`, `control`.

## Common keys / payload keys split

**Common** (present on every grapple event):

| Key | On all 10 kinds? |
|-----|------------------|
| `type`, `tick`, `t_s`, `round` | Yes — base stamp |
| `kind` | Yes |
| `actor` | Yes — side letter `"a"` / `"b"` |
| `target` | Yes — side letter or `""` |

**Payload** (kind-specific):

| Key | Kinds that carry it |
|-----|---------------------|
| `success`, `grade`, `to_seat` | `takedown_attempt`, `throw_attempt` |
| `stage`, `seat` | `stall` |
| `from_stance`, `from_seat`, `to_stance`, `to_seat`, `top`, `via`, `gate_ticks` | `seat` |
| `seat`, `from_seat`, `to_seat`, `grade`, `points`, `via`, `held_ticks` | hold-gate (`takedown`, `throw`, `position_change`) |
| `seat` | `submission_attempt`, `control` |
| `attacker`, `defender`, `attacker_side`, `hold_family`, `hold_id`, `finish_mode`, `attempt_start`, `method` | `submission_finish` only |
| `units` | `control` only |

## Q2 — What a presented beat carries today

`FightBeatAdapter._present` at `:484-560` sets these keys on a beat:

| Beat key | Source | Grapple can fill? |
|----------|--------|-------------------|
| `type` | Hardcoded `"action"` | Yes — would need `"grapple"` or same |
| `actor_side` | `impact["actor"]` | Yes — grapple has `actor` |
| `target_side` | `impact["target"]` | Yes — grapple has `target` |
| `target_region` | `impact["region"]` | **GAP** — no region on grapple |
| `target_body_region` | Same as `target_region` | **GAP** — same |
| `landed` | `contact in LANDED_CONTACTS` | **GAP** — no `contact` on grapple |
| `outcome` | `"landed"` / `"missed"` | **GAP** — needs new meaning |
| `technique` | `impact["technique"]` | **GAP** — no technique id on grapple |
| `technique_name` | `impact["technique_name"]` or `REGION_WORDS` fallback | **GAP** — same |
| `role` | `impact["role"]` | **GAP** — no role on grapple |
| `animation_family` | Hardcoded `"strike"` at `:510` | **GAP** — must not be `"strike"` |
| `range_band` | `impact["band"]` | **GAP** — no band for floor |
| `position` | `impact["position"]` | **GAP** — no position on grapple |
| `significant` | `impact["significant"]` | **GAP** — no significance on grapple |
| `clip_role` | Derived from `technique` | **GAP** — depends on technique |
| `has_clip` | Derived from `clip_role` | **GAP** — depends on technique |
| `clip_missing` | Derived | **GAP** — depends on technique |
| `fallback_thrower` | `"idle"` or `""` | Derivable |
| `fallback_receiver` | From `_react_role_for` | **GAP** — depends on region |

Contract test `REQUIRED_BEAT_KEYS` at
`fight_beat_adapter_contract_test.gd:15-18`:

```
const REQUIRED_BEAT_KEYS := [
    "type", "beat", "tick_from", "tick_to", "span", "round",
    "candidates", "dropped",
]
```

These are structural (beat numbering, timing) — a grapple beat can fill them
from the base `tick`/`t_s`/`round` fields.

Passthrough keys at `fight_beat_adapter_contract_test.gd:10-13`:

```
const PASSTHROUGH_KEYS := [
    "tick", "t_s", "force", "contact", "distance", "wear", "shock",
    "shocked", "knockdown", "flash_knockdown", "trauma_site",
    "trauma_kind", "trauma_pips",
]
```

All strike-specific. A grapple beat would pass through `tick` and `t_s` only.

## Q3 — What already reads a grapple event

### GrappleAdapter._norm — the canonical consumer

`GrappleAdapter.gd:62-99` (`_norm`) is the single function that normalises a
grapple log event for ruleset scoring. Fields it reads:

| Field read | Fallback |
|------------|----------|
| `kind` | `type` |
| `finished` | `false` |
| `held_ticks` | `-1` |
| `hold_seconds` | derived from `held_ticks` at 20 Hz |
| `to_seat` | `seat` |
| `from_seat` | `""` |
| `via` | `""` |
| `grade` | `0` |
| `band` | `amplitude` |
| `grand_amplitude` | `false` |
| `danger` / `feet_to_danger` | derived from grade + seat |
| `is_reversal` / `reversal` / `top_flip` | also `via == "sweep"` |
| `is_sweep` | also `via == "sweep"` |
| `back_on_tatami` | `false` |

DOCUMENTED `GrappleAdapter.gd:62-99`.

### FightHudRead — reads live state, NOT the log

`FightHudRead.gd:37-59` reads `state["grapple"]` (the live grapple state
dict), not log events. Fields: `stance`, `sub_open`, `top` (index), `seat`,
`stall_since`, `since_tick`. Outputs a snapshot for the HUD.

### PostFightRead — reads via BroadcastRead

`PostFightRead.gd:102-145` reads from `BroadcastRead.build(log)` output, not
raw log events. Consumes aggregated per-side counts: `takedowns`, `throws`,
`submission_attempts`, `submissions_finished`, `clinches`, `control_units`,
plus `grapple_measured` and `on_floor`.

### Vocabulary verdict

**A vocabulary exists and it lives in `GrappleAdapter._norm`**
(`GrappleAdapter.gd:62-99`). It reads `kind`, `actor`/`target` (implicitly),
`to_seat`/`from_seat`, `via`, `grade`, `held_ticks`, `seat`. The grapple beat
must reuse these field names. A second spelling is how `target_region` and
`target_body_region` both came to exist.

## Gap list — what a presented beat needs that a grapple event does NOT carry

| Gap | Resolution |
|-----|------------|
| `target_region` / `target_body_region` | Must be empty or derived from `seat` — a takedown has no struck region. Adapter derivation. |
| `landed` / `outcome` | `success` exists on attempts only. Seat changes and control have no success/failure. Adapter must derive from `kind` (a `seat` with `via="takedown"` that reached hold gate = landed). |
| `animation_family` | Hardcoded `"strike"` at `FightBeatAdapter.gd:510`. Must become per-kind or a new `"grapple"` family. Adapter change. |
| `range_band` | No floor band exists. Could be `"clinch"` / `"ground"` from `seat`/`to_stance`. Adapter derivation. |
| `technique` / `technique_name` | No technique id on any grapple event. Could be derived from `kind` + `via` + `seat` (e.g. `"sweep"` from `via="sweep"`). Adapter derivation or `_log_grapple` change. |
| `role` | No role on grapple events. Could be derived from `kind`. Adapter derivation. |
| `significant` | No significance concept. Could default `false` or derive from `kind` (a `submission_finish` is always significant). Adapter derivation. |
| `clip_role` / `has_clip` / `clip_missing` | Depend on `technique`. Resolved once technique derivation exists. |
| `force`, `contact`, `distance`, `wear`, `shock`, `knockdown`, `trauma_*` | Strike-specific passthrough. Grapple beat passes none. Not a gap — a deliberate absence. |
| `position` | No position on grapple events. Could be derived from `seat`. Adapter derivation. |

## Who names the man on top

The `"seat"` kind event carries a `top` field (`FightRealtime.gd:2248`,
`"top": top_side`) with the side letter of the man on top after the
transition. `submission_finish` carries `attacker_side` (`:2399`) — the top
man at the moment of finish. No other kind names the top man explicitly;
`control` implies it through `actor` (always the top man, DOCUMENTED
`:2441-2449`).

**One sentence:** The man on top is named by the `top` field on `"seat"`
events at `FightRealtime.gd:2248`, by `actor` on `"control"` events at
`:2449`, and by `attacker_side` on `"submission_finish"` at `:2399` — three
different field names for the same fact.

# C132 - the three jabs in the engine

## ANSWERS

Q1. The real-time picker is `FightRealtime._run_impact`: only when the gap is at or inside `STRIKE_RANGE` and the attempt gate passes does it stamp a throw, compute the thrower's band/stance, and call `Moves.select`. The live arsenal is restricted by trained/default moves, legal ruleset targets, strike role (`setup`, `damage`, `counter`), stance, and band. A matching-band move has fit 1.0; a one-adjacent-band mismatch is admitted only according to `fight_iq`, with fit 0.45. `select` then weights role by the fighter's plan and region by the plan. Thus the three IDs are ordinary catalogue candidates, not separately commanded actions. Previous action matters only to *who throws next*: volume (conditioning/speed/pace) is multiplied by a 3-second combo boost after that fighter's own previous throw. [E1][E2][E3][E4][E5]

Q2. All three are resolved as the same real-time strike: the attempt gate can reject the throw; otherwise the picker chooses the technique/region, then the contact ladder can produce `clean`, `glancing`, or `missed`. A chosen jab-like technique therefore can miss, or can deliver a force-priced blow subject to the defender's guard roll. `boxing_jab` is a `setup` candidate, as are the other two if their catalogue role is setup; role—not the effect labels—determines the live strike category. `distance_read` and `range_control` are read as defensive *guard* effects when they occur on a defense node, producing an evade answer; they do not make an attacking range-finder change range. `entry_open` is excluded from the strike palette as a grapple effect. `combo_open` is not read by the live realtime resolver; the only `combo_open` consumer is the legacy `FightSimulation._open_improvised_window`, where a landed setup opens 1 follow-up, up to 3 with speed/IQ, capped at 3. [E6][E7][E8][E9][E10]

Q3. There is no opponent reaction keyed to an attacking `boxing_feint` or `boxing_distance_read`. The opponent's guard is selected independently from the defender's own live guard palette and can answer an incoming landed contact with `absorbed`, `blocked`, or `slipped`; a miss remains a miss. The shared effect names can cause an evade only when attached to a *defensive* node consumed by `guard_from_node`; that is not a reaction to either attacking technique. No code here changes the opponent's next-action chance or timing because one of those attack IDs was thrown. [E8][E11][E12]

Q4. The realtime engine models a thrower's cadence, not post-jab vulnerability. It stamps `last_throw_tick` as soon as the attempt gate passes—landed, defended, or missed—and uses the elapsed time only for the next throw-share boost. There is no state that makes the thrower more open after a jab and no branch that fires `boxing_slip_counter` or `boxing_catch_counter` because a jab just happened. Those counter IDs are merely strike-role catalogue candidates; the presentation table gives both the nearest `cross` clip. The legacy simulation has a separate one-shot `chain_exposure`/combo-break concept, but it is not an attacking-jab commitment mechanic in the realtime path. [E1][E13][E14]

Q5. Today the room maps `boxing_distance_read` and `boxing_feint` to the nearest owned `jab` clip. `boxing_jab` is not listed in `NEAREST_CLIP`: if its beat has an owned clip binding, `_thrower_clip` returns that binding; if the named technique is missing and has no nearest entry, the thrower gets no clip and the room reports a held guard. A pair is even narrower: `FightMoveScript.EXCHANGES` contains only `BOX_JAB_HEAD_LAND` for `boxing_jab`, with contacts clean/glancing/absorbed and region head_neck. `exchange_for` requires an action with both sides, the exact technique/contact/region, and no knockdown. Therefore no authored pair can currently be selected for a feint or distance read. [E14][E15][E16]

Q6. At the point the realtime presenter reads an action, the engine event supplies: `type`, `tick`, `t_s`, `span`, `round`, `actor`, `target`, `region`, `force`, `contact`, `distance`, `technique`, `technique_name`, `role`, `band`, `position`, `significant`, `place`, `wear`, `shock`, `shocked`, `knockdown`, `flash_knockdown`, `trauma_site`, `trauma_kind`, and `trauma_pips`. The stage additionally reads `actor_side`, `target_side`, `target_region`, `contact`, `knockdown`, `has_clip`, `clip_role`, and `clip_missing` on its adapter beat; the live screen reads `technique_name`, `technique`, `presented_actor_clip`, and the idle/held presentation flags. `technique` and `technique_name` are the fields that distinguish the three; `role` only gives the broad family, and `ANIMATION_FAMILY_BY_ROLE[setup] = feint_setup` is a role label, not proof that the move is a feint. [E17][E18][E19]

## Evidence

- `Godot/scripts/FightRealtime.gd:1561` "var gap: float = separation(state)" - realtime impact starts from the live separation.
- `Godot/scripts/FightRealtime.gd:1621` "last_throw_tick" - every passed attempt stamps the throw before contact outcome.
- `Godot/scripts/FightRealtime.gd:1645` "var band: String = Moves.band_for" - range and stance are computed before picking.
- `Godot/scripts/FightRealtime.gd:1665` "var chosen: Dictionary = Moves.select(" - the realtime technique choice is delegated to `Moves.select`.
- `Godot/scripts/FightRealtime.gd:1691` "var contact: String = CONTACT_MISSED" - a chosen attempt begins as miss-capable.
- `Godot/scripts/FightMoves.gd:87` "const STRIKE_ROLES :=" - only these roles enter the striking picker.
- `Godot/scripts/FightMoves.gd:375` "static func throw_share(a: Dictionary, b: Dictionary) -> float:" - previous-throw cadence affects who throws next.
- `Godot/scripts/FightMoves.gd:384` "static func combo_boost(since_s: float) -> float:" - the cadence boost is a timing/share function.
- `Godot/scripts/FightMoves.gd:944` "const GUARD_EVADE_EFFECTS :=" - those effects classify defensive evade nodes.
- `Godot/scripts/FightMoves.gd:1089` "static func guard_outcome(kind: String, contact: String) -> String:" - defender outcomes are resolved separately from the attacker.
- `Godot/scripts/FightMoves.gd:1147` "static func mismatch_weight(stats: Dictionary) -> float:" - fight IQ controls wrong-band reach.
- `Godot/scripts/FightSimulation.gd:1623` "effects.has" - the named combo effect is read in legacy simulation's follow-up window.
- `Godot/scripts/FightStagePlayer.gd:836` "boxing_distance_read" - range-finder nearest clip.
- `Godot/scripts/FightStagePlayer.gd:837` "boxing_feint" - feint nearest clip.
- `Godot/scripts/FightMoveScript.gd:34` "const EXCHANGES := {" - authored exchange vocabulary is explicit and finite.
- `Godot/scripts/FightMoveScript.gd:35` "BOX_JAB_HEAD_LAND" - only the jab head-land exchange is authored.
- `Godot/scripts/FightWorldLiveScreen.gd:534` "var technique_id: String =" - the screen reads the scored technique ID.
- `Godot/scripts/FightSimulation.gd:341` "const ANIMATION_FAMILY_BY_ROLE :=" - animation family begins from role, not technique identity.
- `Godot/scripts/FightLiveSchedule.gd:70` "static func add_action" - ordinary action beats are scheduled as actor and target entries.

## What the room shows

| technique | chosen clip or pair | cited line |
|---|---|---|
| `boxing_jab` | owned `clip_role` if bound; otherwise no nearest fallback; authored pair only for qualifying head-land outcomes | `FightStagePlayer.gd:841-858`; `FightMoveScript.gd:35` |
| `boxing_distance_read` | nearest `jab` clip; no pair | `FightStagePlayer.gd:836` |
| `boxing_feint` | nearest `jab` clip; no pair | `FightStagePlayer.gd:837` |

## Open

The named catalogue setup values do not themselves define a distinct realtime feint, range-read, or committed-jab mechanic. The code does not specify a unique animation for either fake, nor a counter trigger caused by one. The pair library shown here only declares the jab-head-land exchange; whether a matching mesh-pair document exists is a content question outside these engine files.

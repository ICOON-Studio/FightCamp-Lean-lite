# U43 DIGEST — the beat learns the technique

`FightBeatAdapter._present` now reads R101's optional impact fields with
`.get`: `technique`, `technique_name`, `role`, `band` → `range_band`,
`position`, `significant`. Empty `technique` keeps the old `REGION_WORDS`
fallback. The range-band apology is gone; empty still means "engine did not
say", never a metres-derived guess.

M19 clip decision on every action beat: `clip_role`, `has_clip`,
`clip_missing`, and when missing `fallback_thrower=idle` /
`fallback_receiver=react_*` for the region. Aliases only for same-punch ids
(`boxing_jab`→`jab`, `boxing_cross`→`cross`, `boxing_lead_hook`→`hook_lead`).
Never substitutes a neighbour's clip.

`fight_beat_technique_test.gd` asserts occurrence floors (named≥8,
distinct≥3, LONG/MID/POCKET/CLINCH all seen) plus M19 degrade shape. Red
until R101 writes the fields — floors not weakened.

Owned only: adapter, test, this digest. `FightRealtime.gd` untouched.

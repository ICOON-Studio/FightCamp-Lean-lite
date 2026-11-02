# U20 — Damage in real time, on a body that already exists

**Desk:** Cursor  
**Date:** 2026-09-09  
**Status:** research only. No `.gd`. No `.tscn`. No `HANDOFF.md` (Claude writes the block).  
**Consumers:** Claude (splice), C62 (clock/determinism — do not price), Q13 (space), G28 (clock), whoever next writes the impact applicator.  
**Held:** U18 granularity (flow, not an eighth attribute) as shipped by R80/U19. Operator 2026-09-09: the fight is real time, so those burst lands become real impacts. XY combat was overturned; this file still does not need metres — a region is enough. Healing is a ruled future stage; this file does not design it.

Cite **D-numbers**. Every rate is **per second of fight time**, never per tick. C62 may keep the 14 s exchange, drop to 1 Hz, or kill real time; a model priced in ticks dies with the tick.

---

## What is true today (checked, not assumed)

| Surface | What it actually does |
|---|---|
| `BodyReadiness.gd` | Six regions: `head_neck`, `torso_core`, `left_arm`, `right_arm`, `left_leg`, `right_leg`. Integers 0–100. Training green ≥ 80; competition is stricter per region. `apply_real_fight_damage()` persists the sim's live end-of-fight dict; `apply_fight_damage()` is the old generic reroll. Injury naming from method + hotspots. Recovery/ceilings exist and are **out of scope**. |
| `GameState.get_body_read` | Hands those six values plus G13 history and R59 injuries to screens. Out-of-fight. |
| U3 | BODY tab is a spatial lab sheet, not a wound map. M6 bands on NOW; M11 ticks on EVER. Fight card / bout sheet / weigh-in stay clean of region chrome. |
| `_apply_landed_effect` | One lump per landed named technique: `damage = magnitude * 0.55 * execution_quality * power_scale`, subtracted from `health`. Head camp shield can cut that. `striking_score` and `lands_round` increment once. |
| `_apply_body_condition_deterioration` | Same lump, once: `round(damage * 0.6)` off the aimed region's live `body_condition`. Morale `BODY COMPROMISED` only on a green→amber / amber→red worsening. |
| Live feedback already on those six | Legs → mobility (`MOBILITY_FLOOR` 0.65). Torso → stamina cost (up to +40%). Head → knockdown chance (up to +0.20). |
| Hurt | `health <= ~35` (composure / weigh-in / rivalry) **or** this exchange's lump `>= 18`. |
| Knockdown (boxing) | Gate: lump `>= 20` **or** health already `<= 30`. Then a roll. Recovered vs KO vs three-knockdown TKO. Extra health/stamina tax on a recovered count. |
| `_check_stoppage` | The only mid-resolve `_finish_fight`: health ≤ 0, submission, ippon, `ko`, three-KD, referee flag. Doctor stoppage is **between rounds**, `head_neck <= 15`. |
| Ten-point-must | Round close. Panel reads the round's counters (`striking_score`, knockdowns, control). Boxing knockdown penalty lives on the scoring profile, not in this file. |
| R80 burst | Texture **after** the outcome. Pocket, n=4,662: `thrown=6.50 landed=1.83` per 14 fight-seconds (Davis baseline 4.7 thrown / 0.233 min, ×1.35 in the pocket). `_burst_rng` so it cannot move a seeded fight. `options.burst = false` is the proof switch. |

One exchange is `AVG_SECONDS_PER_EXCHANGE = 14.0` fight-seconds. Damage, hurt, knockdown and region wear all fire **once** on that named land. The 1.83 burst lands do not.

---

## D1 — What is an impact?

**Question.** Define the record a single strike produces.

**Options considered**

- A) Keep the action event; split its `damage` float across `burst.landed` in presentation only.
- B) A new record, one per attempt, that damage / animation / broadcast all consume.
- C) Animation-only hits; sim stays on the lump.

**Ruling: B.** A is R80, which the operator just overturned for damage. C keeps the slideshow.

An **impact** is one attempt that existed in fight time. Damage, the clip, and the broadcast line all read the same dictionary. It is **not** a tick, and it is **not** the named technique (the technique is the call of a window; several impacts may sit under it).

```
# contract — names, types, strings. A later module implements this; this file owns it.
{
  "t_s":            float,   # fight-seconds from this round's bell. NEVER a tick index.
  "actor_side":     String,  # "a" | "b"
  "target_side":    String,
  "technique_id":   String,
  "technique_name": String,
  "animation_family": String,  # existing ANIMATION_FAMILY_BY_ROLE values
  "role":           String,    # damage | counter | setup | …
  "range_band":     String,    # FightRange band already on the action
  "target_region":  String,    # exactly one of BodyReadiness.DEFAULT_REGIONS
  "force":          float,     # 0..1 impulse. See D2. Derived from the seven stats, not a new one.
  "contact":        String,    # "clean" | "glancing" | "absorbed" | "blocked" | "slipped" | "missed"
  "guard_region":   String,    # absorbing/blocking arm id, or ""
  "headline":       bool,      # true iff this is the named technique of the window
}
```

`contact` is the grain U18 said defense was missing as an event:

| `contact` | Thrown? | Broadcast land? | Wear | Shock eligible |
|---|---|---|---|---|
| `clean` | yes | yes | full, on `target_region` | yes (head; liver-class torso) |
| `glancing` | yes | yes | ~0.4× on `target_region` | only if force is still high |
| `absorbed` | yes | no | mostly `guard_region`; small bleed-through | no |
| `blocked` | yes | no | `guard_region` only, less than absorbed | no |
| `slipped` | yes | no | none | no |
| `missed` | yes | no | none | no |

Slipped vs missed is animation and broadcast, not damage — U18: winners make the other man miss without looking busy. CompuBox "landed" is `clean` + `glancing` only. `defense_used` is `slipped` + `blocked` + `absorbed`.

Optional later (Q13): a spatial origin. Damage does not wait on it. The region is enough.

**If C62 keeps the 14 s window:** generate this list inside the window, stamp `t_s` across those 14 fight-seconds, apply in `t_s` order. The named technique remains the log's headline; `headline: true` marks it. R80's `thrown` / `landed` / `defense_used` become **counts of this list**, not a parallel payload.

**If C62 goes continuous:** emit the same record when the strike happens. Same function of the record. No `dt` in the damage formula.

---

## D2 — How damage accumulates (two channels, not one HP)

**Question.** A landed technique is a lump today. Real time gives many small impacts. What curve keeps a fight from turning into a war of attrition with no drama, or a one-punch coin flip?

**Options considered**

- A) Linear HP. Every land subtracts `k`. 18 lands/round × 12 rounds ends everyone in the mid rounds, or `k` is so small nobody ever drops.
- B) Concave (each punch does less). Even flatter.
- C) Convex / last-hit-wins. The coin flip.
- D) **Two channels:** slow wear on the six regions, plus a rare **shock** on a single impact. Health is the CNS / "can he continue" meter, fed mostly by the head, not by every glove-touch.

**Ruling: D.**

### Rates (fight-seconds, Davis / CompuBox / UFC Stats — same sources as U18 D1)

| | Per second | Per 3-min round |
|---|---|---|
| Boxing thrown | ~0.33 / s (20 / min) | ~60 |
| Boxing landed (26–37% connect) | ~0.10–0.13 / s | ~18–22 |
| MMA significant landed | ~0.05–0.08 / s (3–5 / min) | ~9–15 |
| R80 pocket, measured | 0.46 thrown / s, 0.13 landed / s | — |
| R80 at MID (÷1.35) | 0.35 thrown / s | matches Davis |

Those are the magnitudes the stream must emit. They are not tick counts.

### Channel 1 — Wear (the six clocks, already live)

Each impact subtracts from **region condition**, 0–100, the thing `_apply_body_condition_deterioration` already writes and `apply_real_fight_damage` already persists.

```
wear = force * contact_coeff * region_coeff * WEAR_SCALE
```

`contact_coeff`: clean 1.0, glancing 0.4, absorbed 0.25 bleed + 0.6 on `guard_region`, blocked 0 on target / 0.4 on guard, slipped/missed 0.

`region_coeff` is a small authored table, not a new stat: head and torso take more of a striking impact than an arm; a checked kick loads the catching leg. Do not invent per-region heal rates (J12 D1 already refused those).

**Conservation (D5).** The integral of wear over 180 fight-seconds of a competitive boxing round, at Davis output, MUST match what today's round of named lumps already does to `body_condition` and `health`. Turning 1.83 burst lands into real impacts must **split** today's lump, not multiply it. If the headline landed and two supporting punches landed, the headline takes the power share and the others take the jab share (`jab_share` already on the burst). Sum ≈ today's `event["damage"]`.

Legs → mobility, torso → gas, head → knockdown bonus: **unchanged**. They already read the live dict. More frequent small writes do not change the rule, only the smoothness.

Band transitions (green / amber / red) still fire **once per worsening**, still the only `BODY COMPROMISED` morale. A stream of jabs does not ping morale every punch.

No mid-round healing. Between-rounds `ROUND_HEALTH_REGEN = 6` is corner work, already in fight time (the minute's rest), not a tick. Leave it.

### Channel 2 — Shock (drama)

Knockout in the literature is **not** "HP reached 0 after N equal punches." It is a brief disruption of the reticular activating system from **rotational** acceleration of the head (Meaney & Smith 2011; Viano / Walilko punch series). A single well-timed punch can drop a fresh fighter. Accumulated sub-concussive blows raise vulnerability without each punch being a highlight (Stojsih 2010; McCrory et al. 2017 — concussion is a functional injury; RHI is the career word, usable here as in-bout sensitization).

Body stoppages are a different animal. A liver shot collapses on a **delay** (diaphragmatic spasm / vagal, typically several to ~30 s of fight time after a single right-upper-quadrant hook) — one placement, not a sum of equal jabs. Everything else to the torso is attrition: oxygen, dropped hands, slower output. Limb wear almost never stops a fight by itself.

So shock is a **per-impact** probability, not a bar:

```
# only clean (or a still-heavy glancing) to head_neck,
# plus liver-class: clean, high force, torso_core, hook/uppercut family.
P_shock = clamp( P_BASE * force^2 * (1 + head_wear) * unseen,  0,  P_MAX )
```

- `force^2` so jabs (~0.2–0.3) almost never fire and a clean rear hook (~0.8–1.0) can.
- `head_wear` is `1 - head_neck/100` — the bonus `_head_knockdown_bonus` already is, just fed by many small writes instead of one lump.
- `unseen` > 1 when `contact == clean` and the punch is the one he did not pick up (counter, open-stance rear hand). This is the flash knockdown that is **not** the hardest punch of the night.
- `P_BASE` / `P_MAX` are authored so that at Davis landed-rate, a fresh head in round one is rarely dropped, and a battered head in round eleven is in real danger from a punch that would not have dropped him in round one.

Most impacts: `P_shock ≈ 0`. They still write wear. That is the opposite of a coin flip **and** the opposite of a 200-jab war.

**Flash knockdown** = shock that **recovers**. Already in `_maybe_trigger_knockdown` (`recovered`, `count_reached` 3–9 vs 10). Keep the recovery roll (conditioning, effective IQ, remaining health). Express the count as **fight-seconds the man is on the floor**, not exchanges. G28 owns whether the spectator clock shows it.

**KO** = shock that does not recover, or health driven through 0 by a heavy clean head series.

**Liver delay** = the one body exception. A liver-class impact may set `delayed_shock_at_s = t_s + 5..25` (fight-seconds). When fight time reaches that stamp, if he is still up, fire hurt or a delayed stoppage. It is a timestamp, not a tick.

### `force` (no eighth attribute)

```
force = clamp( (0.5 + power/100) * execution_quality * family_weight * contact_through,  0,  1 )
```

`family_weight` is marker-matched the way R80 already matches jabs/kicks: jab/probe ~0.25, rear straight ~0.55, hook/overhand/uppercut ~0.85. `execution_quality` and `power` already exist. Headline impacts use the named technique's quality; supporting impacts in the same window inherit a lower family_weight from `jab_share`.

### What this refuses to be

- Every punch a knockdown roll (coin flip; also wrong — Walilko's peak punches are rare, and most CompuBox lands are jabs).
- Health as the sum of all six regions equally (a blocked shot on the gloves would drop a man).
- Damage proportional to `dt` or to tick count.

---

## D3 — What survives from the current model

| System | Against a stream of impacts |
|---|---|
| `_check_stoppage` as the only mid-resolve `_finish_fight` | **Keep.** Flags (`ko`, `three_knockdown_tko`, `referee_stoppage`, `submission_finish`, `ippon`) are still set by the impact that caused them. Health ≤ 0 still ends it. |
| Three-knockdown TKO | **Keep.** It already counts **events** in the round, not ticks. |
| Doctor stoppage, between rounds, `head_neck <= 15` | **Keep.** Already fight-time-scoped (the rest minute). A stream just makes `head_neck` a smoother walk toward 15. |
| Referee stoppage at health ≤ 12 | **Keep the gate; retune the unit.** Today it also demands this exchange's lump `> 0` and mutual exclusion with a knockdown **on the same punch**. Same exclusion, per impact. |
| Live six-region dict + band-transition morale | **Keep.** Write smaller numbers more often. Bands and U3's NOW read do not care about the write rate. |
| Legs / torso / head feedback | **Keep.** They read current condition. |
| `apply_real_fight_damage` + hotspot injury naming | **Keep.** End-of-bout regions are still the input. Hotspots still from deltas. |
| Ten-point-must / `JudgePanel` at round close | **Keep the panel.** It already sums the round. Change the **counters**: `striking_score` and `lands_round` add per **clean/glancing impact**, not per named technique, or volume rounds will under-count once the lump is split. Knockdown penalties already count events. A round of eighteen jabs still loses to a round with a knockdown — that lives on the boxing profile (`knockdown_round_penalty`), not here. |
| U3 BODY tab, `LOWEST`, one M6 badge, NOW vs EVER | **Keep, out of fight.** The ring does not grow a six-cell lab (U3 clean surfaces: fight card, bout sheet, weigh-in). |
| Between-rounds health/stamina regen | **Keep.** Corner, one rest minute. Not in-bout healing. |
| Hurt as a fighter flag + morale `HURT` + `hurt_reaction` corner beat | **Keep the flag. Replace the trigger.** |
| Burst as a non-causal payload | **Dies.** The list in D1 **is** the burst. U19's `measured × 14 / 60` must become `count / fight_seconds * 60` whenever G28/C62 stop promising 14. Do not rewrite U19 in this task; name the conversion. |
| `KNOCKDOWN_DAMAGE_THRESHOLD = 20` and `HEAVY_EXCHANGE_DAMAGE_THRESHOLD = 18` | **Die as exchange lumps.** They are calibrated to one named land. After the split, 18 never fires (or, if someone forgets to split, always does). Replace with shock (D2) and a **force** floor on the impact, e.g. hurt if `force` is heavy **or** health crossed composure, **or** a recovered knockdown. Hurt duration is fight-seconds (about 3–8 s of compromised defense), not "until the next exchange." |
| R80 `_burst_rng` isolation | **C62's problem.** Once impacts move the fight, they belong on the outcome RNG (or a declared sibling). Texture-only isolation is what we are leaving. |

**Hurt, rewritten (the one rule that cannot ride the lump):**

A fighter is hurt when any of: (1) `health` crosses `_hurt_threshold` (composure camp still applies), (2) this impact's shock fired and he beat the count, (3) a clean impact with `force` above a heavy floor while `head_neck` is already amber. He stays hurt for a few fight-seconds, then the flag clears if health is back above the threshold. The current `or damage >= 18` branch is the exchange-lump fossil.

---

## D4 — What the player sees

Not a wound chart, not six bars on the ring, not a health integer ticking 100 → 99. Each impact is legible as **contact** (clean / on the gloves / slipped) and **where** in broadcast language — HEAD or BODY, the way a call names them — not as U3's lab sheet. Accumulation is the man changing: hands drop as the arms take the guard, feet slow as the legs go, the head that has been hunted looks it; the existing HURT reaction is the spike, not a new chrome. A flash knockdown is a count he can beat; a KO is the same impact when he cannot; a liver shot can drop him a few seconds after the punch, which is the one time the cause and the fall are allowed to separate. Between rounds the doctor can still pull a man whose `head_neck` is wrecked while he still has "health." After the bell, U3's BODY tab is the six NOW clocks and the EVER ticks; booking still sees one badge and `LOWEST · NN`. The stream feeds that persistence. It does not paint it onto the canvas.

---

## D5 — Conservation (so real time does not 4× the bout)

Today one landed named technique deals lump `D` health and `round(D * 0.6)` region wear. R80 says that window also contained ~1.8 lands in the pocket (~1.3 at MID).

**Rule:** `sum(health_delta of impacts in the window) ≈ D` when the headline landed; `≈ 0` when it missed (supporting lands may still exist — a missed cross can sit on two landed jabs — but they use jab `force`, not `D`). Headline `force` takes the power share; the rest follow `jab_share`.

Worked MID boxing, Davis-shaped: 0.33 thrown / s × 180 s ≈ 60 thrown, ~18 landed / round. If a competitive round should move the loser ~15–25 health (hurt at 35, regen 6 between rounds, KD risk under 30 — today's shape), mean land is ~1 health if uniform, which is why shock is a **separate** channel: the jab's job is wear and the hook's job is the roll. Do not flatten them into one `k`.

MMA uses the same record and the same two channels at the lower landed-rate (0.05–0.08 / s). Takedowns, control and submissions are **not** impacts; they keep their role lumps until a ground-strike stream exists. Do not pretend a pass is a punch.

---

## Standing constraints (held)

- Six regions, U3 chrome, M6 bands, M11 EVER ticks — not reopened.
- No eighth attribute. `force` is power × execution × family × contact.
- No in-bout healing. Per-region recovery remains a future stage.
- No anatomy / scar-red / six stacked bars on the ring or the bout sheet.
- Females never fight males; gym, not camp; no ripped art.
- Do not price C62's tick. Do not author Q13's metres. Do not author G28's spectator clock.
- U18 D1's **granularity numbers** stand (Davis 20 / min, R80 4.7 under one name). The operator overturned only "those lands are texture."

---

## Refusals (stops re-proposal)

1. **Damage per tick / per `dt`.** Per impact, stamped in fight-seconds.
2. **One HP bar as the only body.** Wear is the six clocks; shock is the drop; health is "can he continue," head-weighted.
3. **Every impact rolls knockdown.** Shock is rare; wear is common.
4. **Un-split burst lands** (each of 1.83 getting a full today's lump). Conservation D5.
5. **Healing clocks, mid-round region regen, or a second medical timer.**
6. **Wound map / six-cell lab on the live canvas.** U3.
7. **An eighth stat** (chin, punch resistance, KO power as its own 0–100). Chin is composure camp + remaining `head_neck` + the recovery roll we already have.
8. **XY required for damage.** Region is enough; Q13 may fill space later.
9. **Scoring the punch instead of the round.** Ten-point-must stays a round panel.
10. **Doctor stoppage mid-punch.** It stays the rest-minute look at `head_neck`.

---

## Owned by others (do not author here)

- **C62** — whether the engine is 14 s atomic, 1 Hz, or continuous; which RNG the now-causal impacts draw from.
- **G28** — the spectator clock, the count as displayed time, playback rate.
- **Q13** — space. This record has a region; it can grow a point later.

---

## Citations

| Source | What it is used for here |
|---|---|
| Davis P, Benson PR, Pitty JD, Connorton AJ, Waldock R. *The activity profile of elite male amateur boxing.* Int J Sports Physiol Perform. 2015. | 20 punches / min, 2.5 defenses / min — the stream's rate. Already U18 D1. |
| CompuBox career tables (U18). | 26–37% connect; jab vs power. Broadcast land = clean+glancing. |
| UFC Stats / FightMetric (U18). | 3–5 SLpM, ~40–50% accuracy — MMA rate, same record. |
| Walilko TJ, Viano DC, Bir CA. *Biomechanics of the head for Olympic boxer punches to the face.* Br J Sports Med. 2005;39:710–719. | Punch force ~2–4.7 kN; heavier weights hit harder; rotational acceleration, not linear g, is the KO correlate. |
| Viano DC et al. *Concussion in professional football: comparison with boxing head impacts.* Neurosurgery. 2005. | Boxing punches produce high rotational acceleration relative to linear. |
| Meaney DF, Smith DH. *Biomechanics of concussion.* Clin Sports Med. 2011;30:19–31. | KO / concussion as rotational disruption of the RAS, not an HP total. |
| McCrory P et al. *Consensus statement on concussion in sport — Berlin 2016.* Br J Sports Med. 2017. | Concussion is a functional injury; repeated head impact sensitizes. |
| Stojsih S, Boitano M, Wilhelm M, Bir C. *A prospective study of punch biomechanics and cognitive function for amateur boxers.* Br J Sports Med. 2010. | Sub-concussive accumulation without a single dramatic punch. |
| Ringside / clinical (liver). | Delayed collapse after a single RUQ hook is observed practice, typically seconds later, not a sum of body jabs. No single paper is being treated as a damage formula. |

Authored (not cited): `P_BASE`, family_weight table, hurt duration in seconds, liver delay window, WEAR_SCALE. Those are knobs for the build that implements D1–D5. They must be tuned against D5's conservation, not against a tick rate.

# U72 — Which incoming action each defence answers

Research delivery for S1e. The engine today (`FightSimulation._defender_defense_factor`, lines 2426–2437) sums every `defense`-role node a fighter knows, divides by 40, caps at +0.35, and subtracts that from the success chance of **every** incoming action (`:1398`). One `wrestling_sprawl` (magnitude 19 → full +0.35) therefore defends jabs, teeps, guard passes and armbars alike. The realtime presenter already excludes `takedown_defense` from strike guards (`FightMoves.gd:882–889`); this memo maps all 30 defence effect keys and 111 defence nodes to the incoming classes they actually answer.

## Effect-key table (30 keys)

| Key | Answers | Reason (short) |
|-----|---------|----------------|
| `angle_exit` | strike | Slip/pivot evasion — GUARD_EVADE |
| `block` | strike | Hard/soft blocks — GUARD_BLOCK |
| `body_damage` | strike | Cross-arm absorbs body shots |
| `boundary_control` | strike | Rope/platform footwork — GUARD_FOOTWORK |
| `check_readiness` | strike | Checked guard for blocks/checks |
| `clinch_control` | control | Forearm frame / pivot out of clinch |
| `control_escape` | escape | Turtle escapes bottom control |
| `counter_open` | strike | Opens after parry/uke |
| `counter_ready` | strike | Guard read for counters |
| `coverage` | strike | High guard / uke coverage |
| `distance_read` | strike | Maai / stance range — GUARD_EVADE |
| `entry_open` | strike | Bob-weave under strikes |
| `entry_speed` | takedown | Wrestling stance level-change read |
| `evasion` | strike | Slips, rolls, pulls — GUARD_EVADE |
| `front_headlock_open` | *(none)* | **Trap:** sprawl opens the headlock; does not stop incoming actions |
| `guard` | strike | Stance/long guard — GUARD_BLOCK |
| `guard_control` | control | **Trap:** bottom guard vs passes, not punches |
| `guard_recovery` | control | **Trap:** guard retention vs passes |
| `kick_ready` | strike | TKD bounce/check readiness |
| `low_kick_defense` | strike | Shin check / lowline read |
| `mobility` | strike | Footwork — GUARD_FOOTWORK |
| `opponent_mobility` | strike | Teep stops / push-kick manage |
| `range_control` | strike | Long guard / teep distance — GUARD_EVADE |
| `rhythm` | strike | Breathing/ginga cadence read |
| `scramble` | takedown, control, escape | Whizzer (shot), turtle (bottom), ukemi (throw) |
| `sweep` | strike | Catch-kick vs incoming leg |
| `sweep_threat` | control | Knee shield / harimau vs passes |
| `takedown_defense` | takedown | Sprawl, stance, whizzer — excluded from strike palette |
| `throw_damage_reduction` | takedown | Judo ukemi vs throws |
| `timing` | strike | Breathing rhythm vs strike cadence |

Full JSON with per-key `reason` strings and engine citations lives in `U72_defence_answers.json`.

## Node overrides (3)

| Node | Union would say | Override | Why |
|------|-----------------|----------|-----|
| `wrestling_whizzer_defense` | takedown + scramble classes | **takedown** | Whizzer scrambles off shots only |
| `judo_ukemi` | takedown + scramble classes | **takedown** | Breakfall answers throws, not bottom escape |
| `bjj_turtle` | escape + scramble classes incl. takedown | **escape, control** | Already taken down; blocks passes |

## `wrestling_sprawl` — the measured defect

S1e baseline (40 seeded MMA bouts, grappler vs striker): the striker knows only `wrestling_sprawl` (mag 19, seats standing + both ground seats). Under today's blind pool it contributes +0.35 against **all** roles. The grappler knows no defence nodes. Measured: grappler lands 43/209 standing strikes (20.6%); striker lands 395/645 (61.2%); grappler wins 0/40.

Correct adjudication: keys `takedown_defense` → takedown; `front_headlock_open` → nothing (offensive transition after the sprawl lands). Node answers: **takedown only**. Under seat + answers (option b), standing strike defence from technique drops from 0.35 to **0.0** for this striker; takedown defence stays 0.35. Precedent: `_camp_defense_bonus` (`FightSimulation.gd:1052–1062`) already gates `anti_wrestler` to `role == "takedown"` only.

101 of 111 nodes answer strike only. Four nodes carry takedown in their answers (`wrestling_stance`, `wrestling_sprawl`, `wrestling_whizzer_defense`, `judo_ukemi`). Three BJJ/silat nodes answer control on the ground; one (`bjj_turtle`) also answers escape.

## Disciplines that saturate the +0.35 cap today

Every discipline except **judo** (total mag 13 → bonus 0.325) hits the hard cap on `bonus_all` when all defence nodes count phase-blind: arnis, boxing, BJJ, capoeira, karate, kickboxing, muay thai, pencak_silat (tier≤2 at 0.30), sanda, savate (tier≤2 at 0.30), taekwondo, wrestling. Karate is the extreme case: 67 nodes, total magnitude 785 — one karate stylist would carry +0.35 against every action from technique alone.

Under option (b), saturated strike bonuses collapse for disciplines whose defence is mostly standing (karate standing/strike drops from 0.35 to 0.35 still — all karate defence nodes are strike-only in standing). Wrestling standing/takedown stays 0.35; wrestling standing/strike becomes 0.0. BJJ `seat_answer_all[ground_bottom][control]` stays 0.35 (guard retention + knee shield + turtle).

## Options — what each does to grappler vs striker

**(a) Q73 seat filter alone.** Count a defence node only when its `phase_seats` include the defender's current seat. `wrestling_sprawl` still counts in standing — and still applies to every incoming role. **Does not fix the sprawl-vs-jab bug.** Striker strike defence stays +0.35; grappler still lands ~21% standing strikes; outcome unchanged.

**(b) Seat + answers (one pool per incoming class).** Filter by seat (a), then sum only nodes whose `answers` include the incoming action's class; same `/40` cap per class pool. Striker vs grappler standing strikes: striker technique bonus vs strikes → 0.0 (sprawl excluded); defence factor falls from ~0.45 to ~0.10 (stat only). Grappler standing strike accuracy should rise materially from 20.6%. Takedown entries still face +0.35 from sprawl. **Fixes the measured defect; aligns simulation with presenter intent.**

**(c) (b) with diminishing returns instead of hard `/40` cap.** Same class pools as (b) but e.g. `bonus = 0.35 * (1 - exp(-total/40))`. Early nodes matter; stacking 67 karate uke nodes no longer flat-lines at 0.35. For the S1e striker (one node) behaviour matches (b). Karate-heavy builds soften. More tuning surface; recommend after (b) is landed and re-measured.

## Recommendation

**Option (b)** — seat filter plus per-class answer pools. It is the smallest change that stops `wrestling_sprawl` blocking jabs while preserving full anti-shot value, matches `_camp_defense_bonus` precedent and `FightMoves.gd:882–889`, and does not require curve fitting. Option (a) alone is insufficient; option (c) is a follow-up once (b)'s numbers are re-run through `measure_ground_seats.gd`.

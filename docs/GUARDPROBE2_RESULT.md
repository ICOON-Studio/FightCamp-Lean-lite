# GUARDPROBE2 - where do the punches go, by opponent? (S526)

Run: `godot --headless --audio-driver Dummy --path . --script res://tools/guard_probe2.gd`.
Seeds 6000-6001, 2 bouts a cell, 12 cells (6 styles x 2 configs). Measures the body/head split per opponent style,
then applies GuardWear.posture_damage what-if to the through-guard leak and prints which posture (HIGH/NEUTRAL/LOW)
leaves our boxer with least total damage per cell.

## The rule (read from LiveRound / BoutBurn.MIX / BodyMap)

A settled bout splits damage between head and body as follows: LiveRound.open initializes f["bout"]["body"] = {a: 0, b: 0}
(body shots taken all fight, a = by her on us, b = by us on her). Each exchange, Exchanges.body_shots(landed, share, roll)
takes a share of landed punches to the body (BODY_SHARE 0.20, BODY_THREAT_SHARE 0.35 if opponent threatens body, BODY_CALL_SHARE
if corner calls 'Go to the body'). Body shots are tracked in f["bout"]["body"] and cost energy via Exchanges.body_cost(body).
The body map (BodyMap) tracks damage to specific places (head, eyes, nose, ribs) from ExchangeBeats, with RIB_HIT 2.9 per body hook
and HEAD_HIT 0.59 / FACE_HIT 1.18 for head punches. The damage in m["damage"] is a separate pool (guard through, counters, setups,
reads) not split by body part. The stoppage reads m["damage"] for knockdowns; the result page shows m["body_map"] for the figure.
For this probe, 'body damage' = body shots taken (f["bout"]["body"]) as a share of total landed punches; 'head damage' = the rest.

## 1. Body/head split per cell (baseline, no habit forced)

| cell | style | bouts | our body shots taken | our landed body shots | her body share | our body share | her body share (habit) | our body share (habit) |
|---|---|---|---|---|---|---|---|---|
| am3_pressure | Pressure fighter | 2 | 56 | 40 | 0.376 | 0.412 | 0.376 | 0.412 |
| am3_slugger | Slugger | 2 | 31 | 48 | 0.240 | 0.429 | 0.382 | 0.400 |
| am3_outboxer | Out-boxer | 2 | 29 | 48 | 0.240 | 0.414 | 0.376 | 0.422 |
| am3_counter | Counter-puncher | 2 | 28 | 46 | 0.231 | 0.414 | 0.353 | 0.394 |
| am3_volume | Volume puncher | 2 | 31 | 49 | 0.254 | 0.426 | 0.367 | 0.413 |
| am3_boxpunch | Boxer-puncher | 2 | 31 | 43 | 0.231 | 0.406 | 0.374 | 0.415 |
| pro6_pressure | Pressure fighter | 2 | 103 | 43 | 0.401 | 0.194 | 0.401 | 0.194 |
| pro6_slugger | Slugger | 2 | 56 | 52 | 0.249 | 0.208 | 0.391 | 0.212 |
| pro6_outboxer | Out-boxer | 2 | 53 | 39 | 0.213 | 0.183 | 0.377 | 0.187 |
| pro6_counter | Counter-puncher | 2 | 58 | 40 | 0.218 | 0.201 | 0.366 | 0.194 |
| pro6_volume | Volume puncher | 2 | 62 | 43 | 0.237 | 0.203 | 0.386 | 0.212 |
| pro6_boxpunch | Boxer-puncher | 2 | 56 | 40 | 0.220 | 0.189 | 0.379 | 0.188 |

## 2. Posture what-if (probe-side only, scripts/ not edited)

Applies GuardWear.posture_damage to the through-the-guard leak (GuardState.wear_through's result split head/body by the
measured share) and the +8%% wear for HIGH. Prints per cell which posture (HIGH/NEUTRAL/LOW) leaves our boxer with least
total damage, and by how much in %%.

| cell | style | baseline through | HIGH through | NEUTRAL through | LOW through | best | saving %% |
|---|---|---|---|---|---|---|---|
| am3_pressure | Pressure fighter | 7 | 7 | 7 | 8 | HIGH | 6.8% |
| am3_slugger | Slugger | 6 | 5 | 6 | 6 | HIGH | 11.6% |
| am3_outboxer | Out-boxer | 5 | 5 | 5 | 6 | HIGH | 11.6% |
| am3_counter | Counter-puncher | 6 | 5 | 6 | 6 | HIGH | 11.9% |
| am3_volume | Volume puncher | 6 | 5 | 6 | 6 | HIGH | 11.1% |
| am3_boxpunch | Boxer-puncher | 6 | 6 | 6 | 7 | HIGH | 11.9% |
| pro6_pressure | Pressure fighter | 17 | 16 | 17 | 17 | HIGH | 6.0% |
| pro6_slugger | Slugger | 15 | 13 | 15 | 16 | HIGH | 11.3% |
| pro6_outboxer | Out-boxer | 16 | 14 | 16 | 17 | HIGH | 12.6% |
| pro6_counter | Counter-puncher | 17 | 15 | 17 | 19 | HIGH | 12.4% |
| pro6_volume | Volume puncher | 17 | 15 | 17 | 18 | HIGH | 11.7% |
| pro6_boxpunch | Boxer-puncher | 17 | 15 | 17 | 18 | HIGH | 12.3% |

## 3. Summary

`RESULT: tools/guard_probe2.gd -> body_share=0.213..0.401 best_posture=HIGH 12 / NEUTRAL 0 / LOW 0`

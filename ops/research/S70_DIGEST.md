# S70 DIGEST - FEINTS slice one; traps, kicking foot, blind market test collected (2026-09-24)

## Built: FEINTS slice one (`4b142de1`), G86 section 6, behind `feint` (default OFF)
`FightFeint.gd` (pure, zero preloads) + five hooks in `FightRealtime.gd` (`_feint_react`, `_feint_after_strike`, a queued
follow-up in `_run_impact`, a lifted contact ladder, `SEED_FEINT` stream). S4e(5) already made a feint a catalogue move
that cannot land; this is what it BUYS:
- REACTION: chance = discipline band x feinter skill ((fight_iq + technique)/200 - the two `boxing_feint` requires).
  Live threat (the hands have LANDED for real this fight): boxing/kickboxing/muay thai 0.25-0.45, MMA 0.30-0.50; cold
  0.10-0.20. Own RNG stream, so ON moves no `_rng_impact` draw.
- FOLLOW-UP: a reaction queues the feinter's next throw at 0.3-0.7 s (G86's window) and it climbs the contact ladder x1.225
  (+22.5% relative, the middle of G86's +15-30%; INVENTED placement). Queued because the throw gate (0.06 per 0.1 s impact
  tick) would put an unforced follow-up in the window only ~12% of the time.
- DECAY: every feint of a family counts as unanswered; past two, each halves the chance (G86 gives WHEN, 2-4; the halving
  is INVENTED). A LANDED real shot of that family resets it; a miss or the other family's shot does not.
- Family = catalogue `limb`, else `technique_class` (kick/knee/sweep = leg). Every feint node fakes the hands.

## Gate
- OFF byte-identical: `tools/s70_feint_off_hash.gd` md5 of whole log + result, 9 bouts (boxing, kickboxing, MMA x 3 seeds),
  pre-S70 `FightRealtime.gd` vs S70 - IDENTICAL; ON differs in 9/9. Re-run after merging Q169 + U166: still IDENTICAL.
- `tests/fight_feint_test.gd` 38/38. Mutants (each reverted): decay never bites 5 FAIL; landed shot never resets 1; live
  threat ignored 1; feints not counted 4; family ignored 1; follow-up never queued 1.
- Population (`tools/s70_feint_probe.gd -- bouts 20`; counter-puncher vs pressure fighter in boxing, outside kicker vs
  puncher in kickboxing, both legal, different stats/frames/plans; no technique_progress -> tier 1-2 palettes):
  | | feints/min (both men) | reaction share | follow-ups | land: follow-up vs ordinary | decay k=0/1/2 |
  |---|---|---|---|---|---|
  | BOXING | 1.01 (G86 6-14 per man) | 0.371 (0.25-0.45 live) | 131/182 | 0.527 vs 0.507 = +3.9% | 0.38/0.39/0.20 (n=10 at k=2) |
  | KICKBOXING | 1.11 (G86 4-10) | 0.315 | 53/73 | 0.623 vs 0.517 = +20.5% | 0.34/0.25/0.00 (n=7) |
  The land lift is NOISY at this n (boxing n=131: +/- ~9 pp). The ladder lift is diluted by the defender's slip/guard
  rolls, which still apply to a follow-up - so the delivered lift sits below the +22.5% the ladder is given.
- **FEINT RATE IS THE GAP: ~0.5 per man per minute against G86's 6-14.** Feints are a thin slice of `Moves.select`'s
  palette (boxing_feint + boxing_distance_read). That is slice two: a feint usage weight behind the same switch.

## Collected
- C194 (Codex): blind gym-market contract test, 43/43 on master (`68ab5bf5`); 5 mutants caught. Its first-run failures were
  fixture errors, as C193's were.
- G88 THE CROWDED FLOOR (Grok, verbatim `G88_THE_CROWDED_FLOOR.md`): combat-gym peak share 0.10-0.33, typical evening class
  0.15-0.22 of the roster; yield slope/floor NOT FOUND anywhere. `crowd_peak_fraction` 0.15 kept and relabelled SOURCED;
  slope/floor stay INVENTED. G88 also finds pros usually train OFF the member evening peak - slice two should gate crowding
  on a shared slot (then 0.20 is the mean).
- G89 FIGHT HYPE and G90 OFFICIALS AS PEOPLE (Grok, verbatim) - feed S73 / S74. J46 YOUR OWN PROMOTION (John, verbatim,
  96 SOURCED tags) - feeds S80.
- Q169 r4 (Qwen) merged: `isolated_arm` trap from mount behind `trap_arm` (default OFF), OFF byte-identical (re-proven here
  on MMA ground bouts), `ground_trap_test` 10/10. INFORMATIVE FAILURE: mount finishes drop 8->1 / 4->1 but attempts/fight
  fall to 0.17 / 0.13 against J20's 0.5-1.0 - the trap fires in ~20% of bouts and the gate blocks every other mount sub.
- U166 (Cursor) merged: 28 kick/knee effectors re-tagged by hips-relative peak speed; tempo floor 0.5.

## Found in passing
`tools/measure_commitment.gd` and `probe_between_off.gd` name plans `out_boxer` / `pressure` / `kickboxer` / `grappler`;
the real ids are `boxing_out_boxer` etc., so those probes' fighters fight with NO plan.

## Suite
SUITE total=394 fails=11 (`--jobs 4`, after merging Q169 + U166): athlete_development, capsule_coverage_contract,
fight_body_overlap, fight_metres (hang, a known contention flake), fight_pace_anchor, fight_pair_live (PARKED), fight_scoring,
fight_stage_realism, fighter_reachability_contract, judge_panel (T11), weight_cut - the SAME eleven as S69. No new red; the
three new tests (fight_feint, gym_market_blind, ground_trap) green.

## Assigned at handover
Codex C195 blind feint contract test; Cursor U167 the schedule tells the truth; Qwen Q170 the trap you can reach (+ pace
anchor, T11); Grok G91 fighter -> coach (S72); John J47 the title bump / kit as a draw / gyms that invest (S71).

# TASK GUARDPROBE1 - guard damage v4: size the guard's wear and the damage through it before anything changes a result

Status: OPEN (S524, Claude main). Discipline: boxing. Model: any seat that runs Godot headless (Qwen or Goose).
Approved mechanic: guard damage v4 (Q-S294-275). Wiring scope: `ops/research/GUARDWEAR_WIRE_S524.md` (read it whole).
Built so far: `scripts/rules/GuardWear.gd` (the rules), `scripts/state/GuardState.gd` (each side's guard through the bout,
called from LiveRound.open / LiveRound.exchange; every exchange record carries rec["guard"] = {g, blocked, share}).
Today the guard is SHOWN only (the HUD bar). Step 3 (damage through the guard, and a low guard letting more land) waits
for this probe's numbers.

## Contract
OWNS: tools/guard_probe.gd, docs/GUARDPROBE1_RESULT.md
RED_TEST: tools/guard_probe.gd -> GUARDPROBE1 done
REGRESSION: guard_state_test, guard_wear_test, exchanges_test, golden_path_test (read-only: run, never edit)
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only). Each file under 500 lines. The result page is written BY THE
PROBE from the run's numbers, never by hand.

## The job - tools/guard_probe.gd (extends SceneTree)
Play whole bouts through the game's own round code, the way tools/exchange_balance.gd and tools/adapt_probe.gd do
(LiveRound.open -> LiveRound.exchange x6 -> LiveRound.close a round). Seeds 5000-5199 (200 bouts) per cell, two fighters
who differ (never identical: different stats, styles, plans - the rule in CLAUDE.md s5; print each cell's population).
Cells: amateur 3 rounds (limit 60 kg), pro 4 rounds middleweight (75 kg), pro 6 rounds heavyweight (90 kg); in each cell an
even match and a mismatch (rating gap 8+).
Print per cell:
1. Guard per side at the end of each round (mean, 10th / 90th percentile) as a share of max, and the share of bouts where
   a side reaches each colour (GuardWear.colour: yellow / orange / red) and in which round first.
2. Blocks a round per side (mean) and the guard points a round they cost.
3. OFFLINE damage through the guard: for every block, GuardWear.transmission(kind, guard at that moment, max, class,
   combo) x a punch base (jab 1.0, power 2.5, heavy 4.0 - design s1.1) - summed per bout and divided by the bout's real
   m["damage"] total for that side: the % damage the guard would add. Nothing is fed back into the bout.
4. Then a SWEEP (probe-only, by passing your own numbers to GuardWear / re-computing with the recorded blocks; never
   by editing scripts/): WEAR_SCALE in 0.2 / 0.28 / 0.35 / 0.45 (today 0.28) and BLOCK_SHARE in 0.5 / 0.6 / 0.7, and a TRANSMISSION
   SCALE k (the offline damage x k). Report the pair and k that hit ALL the design targets:
   - total damage +7% to +11% over today (design s4),
   - amateur: the average guard at the end of round 3 yellow (50-75%), red in under 10% of bouts,
   - pro 6 rounds: orange (25-50%) in the last round on average, red mostly for the side losing the mismatch,
   - a 10-punch flurry / a rope-trapped side / a dry fighter (condition under 70) each visibly worse (print the three).
   If no setting hits them all, print the closest two and which target each misses - that is a finding.

## Prior research
`python ops/Tools/prior_research.py guard damage wear arms` -> DESIGN_GUARDDMG1_V4.md (s1, s4 targets), its critics;
tools/exchange_balance.gd (how a probe plays rounds); scripts/rules/BoutBurn.gd (thrown = landed / 0.33, MIX).

## What would a human do?
A cutman watching a fight: by the last round the busy fighter's arms are heavy, the one who ate a flurry on the ropes
is covering up badly; a quiet, even fight leaves both guards up. The numbers should read like that.

## Prefab check
None: the probe plays the game's own rounds.

## The one trap
Feeding the probe's damage back into the bout (that is step 3, not this task) or tuning by editing GuardState.gd - all
sweeps are probe-side re-computations from recorded blocks. PR body: `RESULT: tools/guard_probe.gd -> wear_scale=<x>
block_share=<x> k=<x> damage_plus=<a/b/c %> amateur_r3=<share> pro_last=<share> red_amateur=<%> all_targets=<yes|no>`.
Run: `python ops/Tools/godot_slot.py run --who guardprobe1 -- <godot> --headless --audio-driver Dummy --path . --script
res://tools/guard_probe.gd`. Pilot 10 bouts first, print the projected time, stop at 60 minutes.

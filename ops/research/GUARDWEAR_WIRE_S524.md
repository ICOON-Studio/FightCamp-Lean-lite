# GUARDWEAR wiring scope (S524) - guard damage v4 into the fight that is settled today

Approved: Q-S294-275 "Yes, build it after turning pro" (critics Dola 8/8/7, Goose 8/7/7). Design: DESIGN_GUARDDMG1_V4.md.
Rules: scripts/rules/GuardWear.gd (Arena, collected S524; transmission multiplier is 1.0 + (100 - g)/100 - the design text said 0.5, its own table says 1.0). This page = where it plugs in, in build order.
Not animation: the 3D shows the settled exchange (FIGHTPLAYER2 METHOD stands; no fight3d edits here).

## How the fight is settled today (read S524)
- LiveRound.exchange (scripts/state/LiveRound.gd ~L240-335): six 30 s exchanges a round. An edge `d` (plan, read, ring duel,
  style levers, clinch...) goes to Exchanges.settle(d, roll_a, roll_b) -> {won, margin, landed: [a, b]} from a band table
  (4-3 / 5-2 / 6-1). Pace scales `landed[0]` (PaceAim.output). Damage lands in m["damage"] {a, b} and the body map.
- Thrown is never counted: BoutBurn derives it, thrown = ceil(landed / LAND_RATE 0.33), split by MIX (jab .50, cross .25,
  lead hook .13, body hook .06, rear uppercut .06).
- The guard bar (FightMeters.bars) = 1 - max(shoulder Burn x 0.6, the 3D's glove drop). No rule reads it back.

## Build order
1. GuardState (scripts/state/GuardState.gd, new): per side in lv: guard, max (GuardWear.max_guard by class/amateur),
   combo count, clinch used this round. Start of bout = max. Saved in the bout's lv like "sides".
2. Per exchange, after Exchanges.settle: blocked[k] = round((thrown[k] - landed[k]) x BLOCK_SHARE by the defender's style)
   with thrown from BoutBurn's rule (one helper both read). Each blocked punch, by MIX kind (jab / power = cross+hooks /
   heavy = uppercut): the defender's guard -= GuardWear.wear(kind, combo, ctx) (ctx: ropes from StepWire's lv["at"],
   moving from RingDuel's place, condition/missed weight from the weigh-in, amateur, shoulder from stamina+strength, trait);
   damage through = GuardWear.transmission(...) x the punch's base -> added to m["damage"] for that side (head/body share
   as the exchange's body shots). In-round recovery from the opponent's thrown (GuardWear.in_round).
3. DECIDED S525 - NOT BUILT (GUARD_EDGE = 0): the leak through the guard (step 2, live since S525) already takes the design's
   whole budget (tools/guard_onoff.gd: damage +7.3..10.5%, stoppages up to +3.5 points in the 6-round mismatch, the design's
   limit +-3); an edge or a +1 landed on top would break the stoppage line. The leak IS the feedback. Was:
   The guard feeds back: guard under 50% -> landed[opp] +1 on a won exchange at "Leaking heavily", the edge d -= a small
   GUARD_EDGE x (1 - g/max) (ESTIMATE, sized by the probe below) - arms dropping let more in, the design's core.
4. Corner minute (CornerRest / corner calls): GuardWear.corner(calls, cutman, cut) between rounds; the clinch call uses
   GuardWear.clinch. "Protect the lead" and posture switch = the design's s2 calls, after the probe.
5. Shown: FightMeters "guard" bar reads GuardState (green/yellow/orange/red = GuardWear.colour, the four Ludo icons in
   assets/ui/art/guard/), hover = transmission %. Result page: thrown / landed / blocked / got through, guard per round.
   Judges: GuardWear.blocked_strikes -> the card's effective strikes (scoring only).
6. Menus from the design's s3 table one by one (fight plan defence tab, camp note, training shoulder line, opponent file
   reads) - each a separate commit with its test.

## The probe before step 3's numbers (GUARDPROBE1, Qwen or Goose)
200 seeded bouts per class, amateur and pro, guard v4 OFF vs ON (GameSwitches control arm): total damage change (design
target +7 to +11%), stoppage rate (+-3% of baseline), amateur round-3 finish rate unchanged, a 10-punch flurry, a rope-trapped
fighter, a dry fighter. Size GUARD_EDGE and BLOCK_SHARE from it; nothing ships ON until it passes.

## Tests (each step its own)
guard_state_test (step 1-2: wear by kind, combo x1.5, ropes, recovery), guard_feedback_test (step 3, a control arm with the
feedback off), golden_path (a bout still finishes; the guard bar draws from GuardState), fight_meters_test.

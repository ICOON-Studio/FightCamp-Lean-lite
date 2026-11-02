# TASK SPARBLOCK1 - one sparring block: partner + flash moments + gameplan readiness in one pure module (S236)

Seat: Arena (pure module + test, cloud). Branch `arena/<chat-id>-fightcamp`, PR to master; Claude reviews and merges by diff - never the Merge
button. Model: Arena default. Discipline: BOXING (the demo's gym floor - sparring in the ring).
New features ship ON - this round is a pure module only (no switch); Grok Dev wires it on the floor in the next round.

## What is on master already (read these files - do not edit them)
- `Godot/scripts/rules/PartnerPool.gd` (Arena S235): candidates(boxer, pool, opponent) -> ranked rows {id, name, kind, style, mirror,
  level_gap, safe, why, fee}; pick(rows, prefer "mirror"|"level"|"cheapest"); session_mods(row) -> {readiness_mult, gain_mult,
  cut_risk_mult, fee, member_mood}. Test tests/partner_pool_test.gd.
- `Godot/scripts/rules/SparringFlash.gd` (Ludo): moments_for(block {minutes, card, booked_opponent_style}, boxer {stamina}, partner {style},
  readiness) -> [{minute, trigger}]; moment(trigger, ctx, pick 0..1) -> {id, title, text, trigger, calls:[{id,label,why,auto}]};
  resolve(moment, call_id, ctx {technique, partner_level, ...}, pick) -> {card_progress, readiness_delta, strain, cut_risk, knockdown_risk,
  morale, toast, ...}; auto_call(moment, ctx). Test tests/sparring_flash_test.gd.
- `Godot/scripts/rules/GameplanReadiness.gd` (Arena S235): plan_for(opponent {style, stance}) -> {stations, cards, ...};
  block_credit(plan, station_kind, minutes, card_id, clean_reps 0..1); decay; fight_mods(readiness) (small, banded - THE ONE TRAP there:
  readiness never decides a fight). Test tests/gameplan_readiness_test.gd.

## Do - new `Godot/scripts/rules/SparringBlock.gd`
extends RefCounted, static funcs only, no class_name, no autoload; `preload` of exactly those three rules scripts is allowed. NO randomness:
every "pick" comes from `float(absi(hash("%s|%d" % [seed, i])) % 10000) / 10000.0`. Never modify an argument.
1. `plan_block(block: Dictionary, boxer: Dictionary, pool: Array, opponent: Dictionary, readiness: float, prefer: String, seed: String)
   -> Dictionary` = {"partner": the PartnerPool row picked (empty if none - then "moments" is empty and "reason" says why),
   "mods": session_mods(partner), "moments": [{minute, trigger, moment (SparringFlash.moment with the seeded pick)}], "seed": seed}.
   block.booked_opponent_style = opponent.style when the block does not carry one.
2. `resolve_moment(planned: Dictionary, index: int, call_id: String, ctx: Dictionary) -> Dictionary` = SparringFlash.resolve(...) with the
   seeded pick, then readiness_delta x mods.readiness_mult and cut_risk x mods.cut_risk_mult. call_id "" = SparringFlash.auto_call.
   An index out of range -> {"ok": false, "reason": ...}; otherwise "ok": true.
3. `finish_block(planned: Dictionary, results: Array, gameplan: Dictionary, minutes: int, card_id: String, clean_reps: float) -> Dictionary`
   = {"readiness_add": GameplanReadiness.block_credit(gameplan, "ring_spar", minutes, card_id, clean_reps) + sum of results' readiness_delta,
   "gain_mult": mods.gain_mult, "card_progress": sum, "strain": sum, "cut_risk": 1 - product(1 - each cut_risk), same for "knockdown_risk",
   "fee": mods.fee, "member_mood": mods.member_mood, "lines": one short plain-English line per moment (its toast)}.

## Test - new `Godot/tests/sparring_block_test.gd` (red first: the module does not exist on master)
Population named in the output: a welterweight male orthodox boxer level 50 vs a booked southpaw swarmer; pool of 5 partners (a mirror hired
at fee 80, a stablemate, a female, a middleweight, one 30 levels above). Assert: the partner is the safe mirror; the female / two-divisions-
away / unsafe ones are never picked; a 60-min block plans 2 moments, a 90-min 3; same seed -> identical plan, different seed -> the same
partner (picks only change moment text/variant, never safety); resolve_moment with "" uses the auto call; readiness_delta is scaled by the
partner's readiness_mult (control: the same moment with a level-match stablemate gives a smaller delta); finish_block's readiness_add equals
block_credit + the deltas; cut_risk stays in 0..1; an empty pool -> no moments, a reason, no crash; arguments unchanged after every call.
Bound values, never exact float extremes. Print "SPARRING_BLOCK failures=N", quit(0/1).
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/rules/SparringBlock.gd Godot/tests/sparring_block_test.gd`.
One test: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/sparring_block_test.gd` (no LFS needed).
Do NOT delete or weaken any existing test.

## Prior research
PARTNERPOOL1 PR #217, TASK_L4READY1.md (GameplanReadiness), Ludo's SparringFlash (L2, r97 matrix), K86 (Kalli: sparring moments - no QTE, max
2 a block, every call costs something), K87_DECISION_PACING_REPLY.md (Sparring Flash is priority 2; a moment never waits).

## What would a human do?
The coach picks a sparring partner who fights like Saturday's opponent, watches the rounds, shouts one instruction at the key moment, and
writes down after the session what the fighter learnt and whether he took too much.

## Prefab check
None - three existing pure modules, one combinator.

## The one trap
Safety first: no seed, preference or fee may ever put an unsafe partner (PartnerPool `safe` false) in the ring when a safe one exists.

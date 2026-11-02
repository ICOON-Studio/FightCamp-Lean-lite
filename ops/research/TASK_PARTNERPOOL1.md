# TASK PARTNERPOOL1 - who spars with your boxer: a pure sparring-partner picker + test (S235)

Seat: ARENA (pure module + test; CI has no LFS - load no assets). Own `arena/<chat>` branch + PR; never master, never the Merge button.
Claude wires it on the floor (ring_spar block) afterwards.

## Why
Ludo kept L2 Sparring Flash Moments (fun 8) and L4 Gameplan Readiness (fun 9, collected f6fc7574: `Godot/scripts/rules/GameplanReadiness.gd`).
Both need a PARTNER in the ring: Ludo's SparringFlash takes `partner = {"style", "level"}`, and Kalli's K86 design
(research/K86_SPARRING_FLASH_REPLY.md) fires a moment when "the partner's style matches the booked opponent". Today the floor has
no partner choice at all. Real gyms pick sparring partners to mimic the next opponent ("bring in a tall southpaw").

## FILE 1: `Godot/scripts/rules/PartnerPool.gd`
`extends RefCounted`, STATIC only, ZERO preloads, NO class_name, NO autoload, NO randomness inside (rolls come in as `pick: float`), deterministic.
Use the SAME style ids as GameplanReadiness.STYLES: swarmer, out_boxer, counter_puncher, brawler, southpaw, pressure_fighter (copy the list as a
const; do not preload that file).
- `static func candidates(boxer: Dictionary, pool: Array, opponent: Dictionary) -> Array`
  boxer {"id", "weight_class", "sex", "level" 0-100}; pool = gym people [{"id", "name", "kind": "stablemate"|"member"|"hired", "style",
  "stance": "orthodox"|"southpaw", "weight_class", "sex", "level", "available": bool, "fee": int (hired only)}]; opponent {"style", "stance"} or {}.
  Returns ranked rows {"id", "name", "kind", "style", "mirror": float 0..1 (how well he imitates the opponent: same style 0.7, same stance +0.3,
  a near style 0.35 - write a NEAR table with a boxing reason per pair), "level_gap": int, "safe": bool, "why": short line}.
  Rules: never the boxer himself; never a different sex (operator rule: females never fight males - sparring follows it); weight class within
  ONE division either side (a table of division order); not available -> left out; "safe" false when the partner is 25+ levels above (a beating,
  cut risk) or 30+ below (no work). Rank: safe first, then mirror (when an opponent is booked) or level closeness (when not), then id for ties.
- `static func pick(rows: Array, prefer: String) -> Dictionary` - prefer "mirror" | "level" | "cheapest"; returns the top row or {}.
- `static func session_mods(row: Dictionary) -> Dictionary` - {"readiness_mult": 1.0 + 0.5 * mirror (sparring the right style builds readiness
  faster), "cut_risk_mult": 1.0 + max(0, level_gap)/50, "gain_mult": 0.9..1.15 by level_gap (best near 0..+10), "member_mood": +2 for a member
  partner, "fee": hired fee}. Justify numbers in comments.

## FILE 2: `Godot/tests/partner_pool_test.gd`
`extends SceneTree`, `func _initialize() -> void:`, `load("res://scripts/rules/PartnerPool.gd")`, count failures, print `PARTNER_POOL failures=N`,
`quit(0 if failures == 0 else 1)`. Fixture: a male welterweight boxer and a pool of at least 9 people with DIFFERENT styles, stances, sexes,
classes, levels and availability (never two identical people). Assert: self excluded; other sex excluded; two divisions away excluded;
unavailable excluded; a same-style same-stance partner has mirror 1.0 and ranks first when an opponent is booked; with no opponent the closest
level ranks first; an unsafe partner ranks below every safe one; pick("cheapest") returns the lowest fee; session_mods readiness_mult grows with
mirror; deterministic (same input twice -> same order). Add one comment naming which assertion catches "sex filter removed".

## Gate
CI "Parse gate + changed tests" green; paste the `PARTNER_POOL failures=0` line in the PR body.

## Rules
Typed reads (`var x: float = float(d.get("k", 0.0))`; never `var x := d.get(...)`; never `%%` - research/GDSCRIPT_TRAPS.md). Touch ONLY
these two files. Never delete or weaken a test. New features ship ON: the floor wiring (Claude) goes behind GameSwitches.GAME_ON.

## Prior research
GameplanReadiness.gd (styles), K86_SPARRING_FLASH_REPLY.md (Kalli), J62_TRAINING_DAY_REPLY.md section 2 (sparring rounds by camp week, John).

## What would a human do?
A trainer with a southpaw fight coming phones around for a tall southpaw at the right weight, and never puts his kid in with a heavyweight.

## Prefab check
None - pure rules.

## The one trap
Mirror must not override safety: a perfect-style partner 30 levels above is still ranked below a safe one.

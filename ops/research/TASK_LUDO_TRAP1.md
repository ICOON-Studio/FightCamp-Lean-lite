# TASK LUDO-TRAP1 - V11 the promoter's trap as a pure module + data (approved D40)

Model: Qwen (qwen3-coder). Worktree E:/FightCamp/wt/LUDOTRAP1, branch qwen/ludo-trap1 from master. Push the branch; never master.
Never open a window, image viewer or browser.

## Owned files
- `Godot/assets/data/promoter_trap.json` (NEW)
- `Godot/scripts/PromoterTrap.gd` (NEW, pure)
- `Godot/tests/promoter_trap_test.gd` (NEW)
- `research/TASK_LUDO_TRAP1.md`

## Prior research
- Design (Ludo, lead designer, approved): `research/LUDO_FIRST_HOUR_S190.md` minutes 59-60 and `research/LUDO_CAST_S190.md`
  section 4 "The Meatgrinder": promoter Marcus Vance, after fight 2, offers $5,000 purse advance for an unsanctioned televised debut vs
  Hector "El Carnicero" Bravo (23, 6-0-0, 6 KOs; Super Welter; 180 cm / 186 cm reach; orthodox; slugger; power 88, speed 61, defense 45,
  conditioning 54, fight_iq 55, technique 52, chin 80; traits Executioner (+25% power vs rocked), Heavy Collar Bone, Crowd Pleaser).
  On a win: +250 gym prestige. On a KO loss: -40 chin (permanent). The alternative: reject and grind low-purse amateur circuits.
- House style for a pure data module: `Godot/scripts/CareerMorning.gd` (table cached from JSON, static funcs only).

## What would a human do?
Put the offer and its two branches in data, write the pure rules (when it appears, what each choice pays and costs), test every branch.

## Prefab check
N/A.

## Spec
`promoter_trap.json`: {"promoter": {"name": "Marcus Vance"}, "opponent": {...Hector's full profile above...}, "offer": {"purse_advance": 5000,
"sanctioned": false, "televised": true}, "trigger": {"after_bouts": 2, "career_bouts_max": 2}, "outcomes": {"win": {"prestige": 250},
"ko_loss": {"chin": -40}, "loss": {}}, "reject": {"note": "low-purse amateur circuit"}}.
`PromoterTrap.gd` (extends RefCounted, static):
- `should_offer(record: Dictionary, already_offered: bool) -> bool` - true exactly when wins+losses+draws == trigger.after_bouts and not offered.
- `offer() -> Dictionary` - {promoter, opponent, purse_advance, sanctioned, televised} (a deep copy; callers may edit it).
- `sign(cash: int) -> Dictionary` - {cash: cash + purse_advance, booked_opponent: opponent.name, unsanctioned: true}.
- `reject() -> Dictionary` - {booked_opponent: "", note}.
- `settle(result: String, chin: int, prestige: int) -> Dictionary` - result "win" | "ko_loss" | "loss": returns {chin, prestige} after the
  outcome; chin never below 0.

## Done = (tier: new files only - parse + this test)
`python Godot/tools/check_scripts.py Godot/scripts/PromoterTrap.gd Godot/tests/promoter_trap_test.gd`;
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/promoter_trap_test.gd` -> prints `PROMOTER_TRAP_TEST FAILS=0`, rc 0,
no SCRIPT ERROR. Test (house style of tests/shown_record_test.gd, one _check per case with the numbers in the message): should_offer at 1/2/3
bouts and already-offered; offer() numbers match the JSON; offer() returns a copy; sign adds 5000; settle win +250, ko_loss -40, chin 30 ->
0 floor, loss unchanged. List 3 mutants (advance 5000->4000, ko_loss chin -40->-30, after_bouts 2->1) with the FAIL count each in your final
message. Commit + push.

## The one trap
Stats are on our 0-100 scale as given; do not invent fields that are not in the profile.

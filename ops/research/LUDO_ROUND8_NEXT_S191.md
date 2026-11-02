# Ludo (lead designer) - round 8: WHAT TO BUILD NEXT + its own GDScript (S191, 2026-10-10)

Operator S191: "ask ludo what we should build next , i think it can also write code if you ask it for it". Asked in the project's Ask
Ludo chat after the project document was updated to V1-V15 (LUDO_PROJECT_DOC_BACKUP_S191.md). The prompt gave our live / built-pure /
in-progress status and asked for (1) the next 5 builds in order with a visible acceptance test each, (2) GDScript for item 1 under 200
lines with a headless test. Read with the browser JS tool; "=" "&" "?" "%" were masked by the tool's filter and are restored here.

## Ludo's answer, verbatim

1) The Next 5 Things to Build (In Build Order)

Wire Composure into the Live Fight Engine

Why: It is the foundational mechanical gear behind the stool state diagnosis, fighter plan adherence, and towel panic thresholds.
Visual Acceptance Test: When Leo takes a clean hook or lands his pad chain, his live card displays his composure tier tag changing color (Focused in green, Rattled in yellow, Shaken in orange, Broken in flashing red).

Wire the 3-Lane 2-AP Corner & Table 1 Stool Triage

Why: Connects the between-round 45-second break to the live composure state, replacing the legacy corner with the approved triage loop.
Visual Acceptance Test: When the bell sounds, the corner drawer slides open showing 2 pip pips per lane, displays Leo's computed State Word (e.g., PANICKED), and picking Calm visibly drops his pulse by 25 BPM on the HUD card.

Wire Doctor Stoppage Inspection & Towel/Wave-On Choice

Why: This is the core dramatic climax of Bout 2 (Ray Miller), teaching risk vs. long-term athlete preservation before the demo ends.
Visual Acceptance Test: In Round 3 at 3+ cut pips, the ref waves time out, a ringside doctor overlay pops up with stoppage odds, and choosing Wave Him On finishes the bout while branding Leo's post-fight sheet with Cut-Prone Scar (Level 1).

Integrate Monday–Saturday Fight Week Cadence (Week 4)

Why: Bridges macro camp planning into Fight Night, locking in the Tuesday Lock One / Sacrifice One trade-off and Friday Weigh-in Roulette.
Visual Acceptance Test: Advancing into Week 4 transitions the right HUD panel into 6 daily cards; confirming Tuesday locks a permanent +15% power badge onto Leo's cross and dims his hook guard.

Wire the First-Hour Flow & Marcus Vance's Trap

Why: Packages the entire 60-minute onboarding loop (Bout 1 → Bout 2 → Office) into the final playable demo .exe.
Visual Acceptance Test: Following Bout 2's scorecard, Marcus Vance walks into the Anvil Street office dialogue scene presenting the clickable $5,000 contract vs. the amateur circuit door.

2) GDScript Implementation: ComposureEngine.gd

Here is the self-contained, pure GDScript module for Item 1, complete with headless unit tests that print PASS/FAIL lines.

```gdscript
# res://scripts/combat/ComposureEngine.gd
class_name ComposureEngine
extends RefCounted

enum Tier { FOCUSED, RATTLED, SHAKEN, BROKEN }

const TIER_THRESHOLDS = {
	Tier.FOCUSED: 70,
	Tier.RATTLED: 45,
	Tier.SHAKEN: 20
}

# --- 1. INITIALIZATION ---
static func calculate_start_composure(stats: Dictionary, traits: Array) -> float:
	var fight_iq: float = stats.get("fight_iq", 50.0)
	var chin: float = stats.get("chin", 50.0)
	var val: float = 30.0 + (fight_iq * 0.35) + (chin * 0.20)

	if "Iron Will" in traits:
		val += 15.0
	if "Gatekeeper Composure" in traits:
		val += 10.0
	if "Fragile Confidence" in traits:
		val -= 15.0

	return clampf(val, 20.0, 90.0)

# --- 2. LIVE DELTAS ---
static func apply_event_delta(current: float, event_name: String) -> float:
	var delta: float = 0.0
	match event_name:
		"head_shot_taken": delta = -4.0
		"rocked": delta = -12.0
		"knockdown_suffered": delta = -25.0
		"cut_opened": delta = -10.0
		"rope_trapped_second": delta = -1.0
		"pad_chain_executed": delta = 8.0
		"knockdown_scored": delta = 15.0
		"whiff_punished": delta = 3.0
		"triple_slip_success": delta = 4.0
		"round_won": delta = 6.0
		"round_lost": delta = -6.0
		"hostile_crowd": delta = -3.0
	return clampf(current + delta, 0.0, 100.0)

static func apply_passive_stool_recovery(current: float, conditioning: float) -> float:
	var recovery: float = conditioning * 0.15
	return clampf(current + recovery, 0.0, 100.0)

# --- 3. GETTERS & TIERS ---
static func get_tier(composure: float) -> Tier:
	if composure >= TIER_THRESHOLDS[Tier.FOCUSED]:
		return Tier.FOCUSED
	elif composure >= TIER_THRESHOLDS[Tier.RATTLED]:
		return Tier.RATTLED
	elif composure >= TIER_THRESHOLDS[Tier.SHAKEN]:
		return Tier.SHAKEN
	return Tier.BROKEN

static func get_modifiers(tier: Tier) -> Dictionary:
	match tier:
		Tier.FOCUSED:
			return {"adherence": 1.00, "guard": 1.00, "counter_latency": 0.0, "can_chain": true}
		Tier.RATTLED:
			return {"adherence": 0.75, "guard": 0.85, "counter_latency": 0.15, "can_chain": true}
		Tier.SHAKEN:
			return {"adherence": 0.40, "guard": 0.65, "counter_latency": 0.30, "can_chain": true}
		Tier.BROKEN:
			return {"adherence": 0.10, "guard": 0.40, "counter_latency": 0.60, "can_chain": false}
	return {}

# --- 4. HEADLESS TEST RUNNER ---
static func run_tests() -> bool:
	(six tests: Leo 77.15, Damian 50.65, clamps 20/90, knockdown 75 -> 50 Rattled, Broken disables chains + guard 0.40,
	 stool recovery 50 + 66 x 0.15 = 59.9; prints [PASS]/[FAIL] lines and a summary)
```

To run this headless test anytime via Godot CLI:

godot --headless -s --script res://scripts/combat/ComposureEngine.gd -e "ComposureEngine.run_tests()"

(Ludo's follow-up suggestions: "Can you write the complete under-200-line Godot composure module and headless test, including JSON
loading and live-engine wiring?" / "Can you define the exact composure thresholds, modifiers, and event impacts so every outcome is
deterministic and visibly ...")

## Claude's reading (for the verdict)
- ORDER: Ludo's 5 = composure wired -> the 2-AP corner + stool -> doctor + towel/wave-on -> the Mon-Sat fight week -> the first-hour flow +
  Vance's trap. It matches our queue (LUDO-CORNER2 carries composure; then DOC wiring, WEEK1 wiring, HOUR1). TAKE the order.
- NEW asks inside the acceptance tests: a composure TIER TAG on the fight HUD card (green/yellow/orange/flashing red) and "Calm drops his
  pulse by 25 BPM". The tier tag fits the approved V14 + V12 - take it into CORNER2's HUD part. The -25 BPM is a NEW number not in the
  approved stool table (Water Rinse is -8 BPM there) - not built until Ludo's table carries it and the operator approves it.
- THE CODE: correct arithmetic for the approved formula, but (a) it duplicates Composure.gd that Arena is already building to our house
  style (data in JSON, no class_name, a SceneTree test the runner can run); (b) its numbers are hard-coded; (c) it adds counter-latency
  0.30 (Shaken) and 0.60 (Broken) that the approved V14 table does not have (Shaken = "flinches on feints", Broken = "drops high guard"),
  and gives Shaken can_chain true (approved); (d) the run command (`-e`) is not a Godot CLI flag. Verdict: Ludo CAN write correct GDScript
  for a pure module, but its code is a reference, not a merge - Arena/Codex build to our gates. The two new latency numbers go to Ludo
  as a question if CORNER2 needs them.

## Operator ruling (S191, in chat): "why not add those ?" / "it sounds a good addition" -> D43
The counter-latency 0.30 s (Shaken) / 0.60 s (Broken), Calm -25 BPM on a Panicked fighter and the HUD band tag are APPROVED and built.

## Correction (Claude, S191)
"Calm drops a panicked fighter's pulse by 25 BPM" was NOT new: Ludo's approved corner table already carries it
(`Godot/assets/data/ludo_corner.json` tone_effects.panicked.calm.bpm = -25, merged as LUDO-CORNER1 dd07c15d). Claude misread the stool
table (it checked only the Water Rinse row, -8 BPM). D43 item (2) needs no new build.

# Operator direction, 2026-09-14 night: a modular single-actor catalog, assembled by Godot code

Pasted by the operator in chat after stopping the UFC pilot ("Ok stop it"), preceded by "This what we will do, do not
interrupt me until I prompt you". Saved verbatim below; Claude's notes on what the project has already measured about
each claim are in `HIGGSFIELD_CATALOG_V0.md` once the templates have been run as written.

---

You must make a modular catalog of single-actor actions, reactions, and looped states.You will then use Godot’s code to piece those individual assets together into a fluid, responsive simulation.Here is the exact formula for structuring your Higgsfield prompts to get game-ready, realistic assets for Godot.1. The Strategy: Use "Invisible Target" PromptingSince Higgsfield animates one character at a time, you must tell the AI to behave as if an opponent is physically there. This forces the generated skeleton to exhibit realistic weight distribution, physics, and muscle resistance.Always structure your prompts with Physics Constraints, Target Spatial Points, and Recovery Frames.2. The Core Prompt Templates (Copy & Paste)Group your prompts by combat phase. Run these individually in Higgsfield to build your animation library.Phase A: Striking & FootworkThe Attacker (Realistic Jab-Cross Combo):"Animate a professional lightweight MMA fighter executing a sharp jab-cross combination. Start from a deep, balanced Southpaw stance. The character must step forward on the jab, rotate their hips sharply on the cross, and keep their guard up. Include rapid head movement off the center line during the punches. The move must snap back to the defensive stance by frame 45. Keep root motion active at the hips."The Defender (Reaction to Head Strike):"Animate a humanoid character standing in an orthodox fight stance suddenly getting struck hard on the left jaw. The head must snap back violently at frame 15, causing the character to stumble backward two steps, losing balance before resetting their guard by frame 50."Phase B: Clinch & TakedownsThe Attacker (Double-Leg Takedown Entry):"Animate a wrestler executing a explosive double-leg takedown entry into an invisible opponent. The character changes levels cleanly by bending at the knees, drives forward forcefully with the shoulder at waist height, and extends their arms to wrap around invisible legs. The animation ends with the character driving upward and driving through the hips. Keep root motion enabled."The Defender (Getting Taken Down):"Animate a character standing, who is suddenly struck in the lower torso by a takedown at frame 10. The character's hips must be swept backward, their back arches, and they hit the canvas flat on their back by frame 35, absorbing the impact with their arms slammed against the floor."Phase C: Ground & Pound (The Loops)The Attacker (Postured Up in Guard):"Animate a character postured up inside an opponent's guard. The character is sitting on their shins, throwing alternating, heavy downward hammerfists and elbows into a ground-level target. The movement should show heavy torso rotation and gravity-driven force on the downward strokes. Loop seamlessly from frame 1 to 60."3. How to Assemble the Simulation in GodotOnce you export these .glb animations from Blender into Godot, you need code to glue them together. When the Attacker triggers a takedown animation, Godot must instantly snap the Defender to the correct coordinate and play the matching get_taken_down animation.Create an AnimationTree with a StateMachine for both fighters, and use this script template to synchronize them:gdscriptextends Node3D

@onready var attacker_anim: AnimationPlayer = $Attacker/AnimationPlayer
@onready var defender_anim: AnimationPlayer = $Defender/AnimationPlayer

func trigger_takedown():
	# 1. Align the characters spatially so the invisible targets match perfectly
	var target_position = $Attacker.global_position + ($Attacker.global_transform.basis.z * -1.2)
	$Defender.global_position = target_position
	$Defender.look_at($Attacker.global_position, Vector3.UP)
	
	# 2. Play the synchronized Higgsfield animations at the exact same millisecond
	attacker_anim.play("higgsfield_double_leg_entry")
	defender_anim.play("higgsfield_taken_down_flat")
	
	# 3. Apply root motion so the engine moves their actual capsule colliders
	$Attacker.set_root_motion_tracking(true)
	$Defender.set_root_motion_tracking(true)
Use code with caution.4. Golden Rules for Higgsfield-to-Godot RealismEnforce "Keep Feet Planti": Always mention footwork stability in your prompts (e.g., "Keep the trailing foot anchored until the weight shifts"). Without this, AI animations suffer from "foot-sliding," which ruins game realism.Isolate Root Motion: Ensure Higgsfield puts the forward movement velocity on the Hips/Root bone rather than moving the whole mesh away from its origin point. Godot requires clean Root Motion to calculate realistic character velocity and ring boundaries.

---

## Second message (same evening), followed by: "Now tell me your thoughts about this process"

For a manager/simulation-style UFC game (where AI fights AI based on attributes, strategies, and random rolls), this workflow is actually a massive advantage. You don’t need to worry about instant controller input latency; instead, your primary goal is to seamlessly transition from one modular combat state to another based on background calculations.To execute this, you will use Godot as the "Brain" (running mathematical simulation loops) and your Higgsfield-generated animation catalog as the "Visual Layer."1. Building the Modular Higgsfield Animation CatalogIn a simulation game, characters spend long periods in static positions (like standing in a guard stance or grinding in a clinch) before an event happens. You need to prompt Higgsfield to create two types of animations: Seamless Loops and Action Transients.Use these exact prompt templates to build your simulation library:A. Idle & Movement Loops (The Background State)Striking Idle Loop:"Animate a professional MMA fighter in a relaxed, bouncing orthodox stance. The character shifts weight subtly from front foot to back foot, keeps hands up protecting the face, and breathes heavily. The loop must start and end at the exact same pose at frame 90 for a seamless looping cycle."Clinch/Cage Press Loop (Attacker):"Animate a fighter leaning forward, pushing their forehead and shoulders against an invisible wall at chest height. Their hands are locked around an invisible torso, and their feet are digging into the canvas to drive forward pressure. Loop seamlessly from frame 1 to 120."B. Action Transients (The Decisions)The Success Roll (e.g., Low Kick):"Animate an MMA fighter executing a violent Muay Thai low leg kick targeting an invisible opponent's lead thigh. The pivot on the standing foot must be clean, hip rotates fully, and the kicking leg snaps back to the starting orthodox stance by frame 45."The Fail/Counter Roll (e.g., Blocked Kick):"Animate a fighter throwing a heavy body kick, but upon impact at frame 20, the leg bounces back awkwardly as if striking a solid shield. The fighter loses minor balance, stumbles one step back, and re-establishes their defensive guard stance by frame 50."2. Architeching the Godot 4 Simulation EngineIn Godot, your simulation loop will run on a timer. Every time the timer ticks (e.g., every 1.5 seconds), the engine checks the fighters' stats (e.g., Striking, Takedown Defense, Fatigue), rolls a random number, determines the outcome, and triggers the matching Higgsfield animations.Here is a structural blueprint using GDScript for your main simulation supervisor:gdscriptextends Node3D

enum FighterState { STANDING, CLINCH, GROUND }

# Mock Fighter Stats
var fighter_a = {"name": "Striker Pro", "striking": 85, "stamina": 100, "state": FighterState.STANDING}
var fighter_b = {"name": "Grapple King", "tk_defense": 70, "stamina": 100, "state": FighterState.STANDING}

@onready var anim_a : AnimationPlayer = $FighterA/AnimationPlayer
@onready var anim_b : AnimationPlayer = $FighterB/AnimationPlayer
@onready var sim_timer : Timer = $SimulationTimer

func _ready():
	# Start the fight! Set both to their Higgsfield idle loops initially
	anim_a.play("higgsfield_striking_idle_loop")
	anim_b.play("higgsfield_striking_idle_loop")
	sim_timer.start()

func _on_simulation_timer_timeout():
	# This function runs automatically every 1.5 seconds to calculate the fight logic
	if fighter_a["state"] == FighterState.STANDING:
		_process_standing_round()

func _process_standing_round():
	# Roll to see what action Fighter A attempts
	var action_roll = randf()
	
	if action_roll < 0.6: # 60% chance to just stay in the idle loop
		return 
		
	elif action_roll < 0.85: # 25% chance to strike
		print("Fighter A throws a punch!")
		# Roll Fighter A's striking vs Fighter B's defense variables
		if randi_range(0, 100) < fighter_a["striking"]:
			# Success! Play synchronized Hit/Get Hit animations
			anim_a.play("higgsfield_jab_cross_combo")
			anim_b.play("higgsfield_head_snap_reaction")
			fighter_b["stamina"] -= 5
		else:
			# Fail! Fighter B dodges or blocks
			anim_a.play("higgsfield_jab_cross_combo")
			anim_b.play("higgsfield_lean_back_evade")
			
	else: # 15% chance to attempt a takedown
		_execute_takedown_attempt()

func _execute_takedown_attempt():
	print("Fighter A shoots for a takedown!")
	# Snap positions to ensure the Higgsfield invisible spatial targets match perfectly
	$FighterB.global_position = $FighterA.global_position + ($FighterA.global_transform.basis.z * -1.2)
	
	if randi_range(0, 100) > fighter_b["tk_defense"]:
		# Takedown is successful
		anim_a.play("higgsfield_double_leg_entry")
		anim_b.play("higgsfield_taken_down_flat")
		fighter_a["state"] = FighterState.GROUND
		fighter_b["state"] = FighterState.GROUND
		# Queue up ground loops once the transient finishes
		anim_a.queue("higgsfield_ground_top_idle_loop")
		anim_b.queue("higgsfield_ground_bottom_idle_loop")
	else:
		# Takedown fails (Sprawl)
		anim_a.play("higgsfield_double_leg_entry")
		anim_b.play("higgsfield_sprawl_defense")
Use code with caution.3. Tips for Maintaining Realism in a Simulation ContextUse queue() for Animations: Notice the anim_a.queue() method in the script. Because simulation actions happen dynamically, using .queue() tells Godot to play the transitional move (the takedown) completely through to its last frame, and then smoothly blend right into the looping state (ground control) without an unnatural visual pop.Blend Time (Cross-fading): In your Godot AnimationPlayer settings, set a default Blend Time of roughly 0.2 or 0.3 seconds. This tells Godot to mathematically interpolate the bone positions between the end of an idle loop and the beginning of a sudden strike, making the AI's physical reactions look organic.Tie Dynamic UI to the Animations: Since it is a manager game, users will look at health bars, stamina wheels, or a text commentary feed. Trigger those UI updates at the exact frame the punch lands by adding Method Call Tracks inside Godot's animation timeline directly on the frame where the Higgsfield strike impacts.

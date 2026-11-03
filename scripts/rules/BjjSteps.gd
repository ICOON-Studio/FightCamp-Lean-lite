extends RefCounted
## S376 BJJCOACH1 (operator S375 "Yes, build it", from BJJ DOJO on the itch scan, ops/research/S375_ITCH_MMA_SCAN.md):
## the coach's steps for every no-gi syllabus move (BeltRoad.SYLLABUS ids), 4-6 short cues the way a coach calls them on
## the mat. On Ana's mat (Playbook, MatPlayer) the steps split the move's GrappleMap film: each step owns an even share of
## its keyframes (a short film with fewer keyframe gaps than steps splits by time), the step playing lights up, a click
## plays that step and holds on where it ends. Unfilmed moves (BjjFilm) still show their steps, without the film.
##   steps(id) -> [cue]   starts(key_t, n) -> step start times   index_at(starts, t)   end_of(starts, i, length)
## Pure static.

const STEPS := {
	# White belt - the foundations
	"shrimp_bridge": ["Elbows in, frame on the neck and hip", "Bridge high to make space", "Shrimp: hips out to the side",
		"Knee in through the gap", "Recover guard"],
	"frame_recover_guard": ["Frame: forearm on the neck, hand on the hip", "Turn onto your side", "Shrimp away, hips back",
		"Knee in between you", "Swing the leg over: closed guard"],
	"seatbelt_escape": ["Two hands on the choking arm", "Chin down, protect the neck", "Slide your shoulders to the mat on the choking-arm side",
		"Clear the top hook off your leg", "Turn in and come up on top"],
	"posture_closed_guard": ["Hands on the hips", "Head up, back straight", "Elbows in: no arm to grab", "Hips back onto the heels",
		"Stand one foot up to open the guard"],
	"bullfighter_pass": ["Stand, grip both knees", "Push the knees to one side", "Step around, outside the legs", "Drop the chest across",
		"Pin in side control"],
	"knee_cut_pass": ["Pin the near leg with your shin", "Underhook or crossface", "Slide the knee across the thigh", "Hips low, stay heavy",
		"Free the back leg: side control"],
	"scissor_sweep": ["Grip behind the neck and the sleeve or wrist", "Hip out, shin across the belly", "Bottom leg low behind the knee",
		"Pull and scissor the legs", "Roll up into mount"],
	"hip_bump_sweep": ["Sit up from closed guard, post a hand", "Reach over the shoulder for the arm", "Bump the hips into the chest",
		"Roll over the posted side", "Come up in mount"],
	"double_leg": ["Level change from the stance", "Penetration step between the feet", "Head up, outside the hip",
		"Wrap both legs behind the knees", "Drive and turn the corner", "Land in side control"],
	"armbar_guard": ["Arm across your chest, hold it", "Foot on the hip, angle out", "Swing the leg over the head",
		"Knees pinched, thumb up", "Hips up to finish"],
	"kimura": ["Grip the wrist", "Over the arm, grab your own wrist", "Elbow tight to your body", "Turn the arm behind the back",
		"Rotate slowly to finish"],
	"americana": ["Side control, pin the wrist to the mat", "Elbow bent, palm up", "Figure four over the wrist",
		"Slide the wrist toward the hip", "Lift the elbow to finish"],
	"rear_naked_choke": ["Seatbelt, hooks in", "Choking arm under the chin", "Hand on the other biceps", "Other hand behind the head",
		"Elbows together, chest forward"],
	"guillotine": ["Wrap the neck, wrist under the chin", "Lock the hands", "Close the guard", "Hips up, forearm into the throat",
		"Arch back to finish"],
	# Blue belt - building a game
	"de_la_riva": ["Hook the outside leg", "Grip the ankle and an arm", "Off-balance forward", "Kick the hip away",
		"Sweep or take the back"],
	"single_leg_x": ["Enter under the leg from guard", "Hug the leg", "Outside foot on the hip, inside hook behind the knee",
		"Off-balance forward", "Sweep or attack the foot"],
	"deep_half": ["From half guard, underhook the near leg", "Dive under, head to the hip", "Hug the leg with both of yours",
		"Get under the hips", "Tip forward to sweep"],
	"butterfly_sweep": ["Sit up, hooks inside the thighs", "Underhook one arm, overhook the other", "Pull the chest onto yours",
		"Fall to the overhook side", "Lift with the hook, come up on top"],
	"over_under_pass": ["One arm under a leg, one over", "Stack the legs", "Hips low, head on the belly", "Walk the hips around",
		"Pin in side control"],
	"leg_drag": ["Grip the ankle", "Drag the leg across the body", "Pin the hip with your knee", "Settle the hips, chest heavy",
		"Walk around to side control"],
	"arm_drag_back": ["Grab the wrist, then the triceps", "Pull the arm across", "Hips out to the side", "Climb behind, seatbelt",
		"Hooks in: back control"],
	"berimbolo": ["De la Riva hook in", "Invert under the hips", "Spin under the legs", "Come out behind", "Seatbelt: take the back"],
	"triangle": ["One arm in, one arm out", "Shoot the leg over the shoulder", "Lock the ankle behind your knee",
		"Angle out, pull the head down", "Squeeze the knees, hips up"],
	"straight_ankle_lock": ["Ashi garami: legs around the leg", "Wrist bone under the Achilles", "Grip, elbow tight",
		"Squeeze the knees, hips forward", "Arch back to finish"],
	"darce": ["Thread the arm under the arm and neck", "Lock on your biceps", "Hand behind your head", "Walk the hips around",
		"Squeeze the elbows"],
	# Purple belt - a full system
	"k_guard": ["Knee shield, grip the ankle", "Turn in on your side", "Inside leg hooks the near leg", "Spin under to the legs",
		"Enter a leg lock or the back"],
	"waiter_sweep": ["Deep half underneath", "Hook the far leg", "Lift the leg like a tray", "Tip over the shoulder", "Come up on top"],
	"body_lock_pass": ["Lock the hands around the waist", "Head on the chest, hips low", "Pin the legs together",
		"Step over the trapped leg", "Slide to side control"],
	"outside_heel_hook": ["Outside ashi: leg across the hip", "Hide the heel under your armpit", "Clamp the knees",
		"Wrist blade on the heel", "Turn the body away to finish"],
	"kneebar": ["Trap the leg between your thighs", "Hug the foot to your chest", "Kneecap past your hips", "Squeeze the knees",
		"Hips forward to extend"],
	"toe_hold": ["Control the foot from outside", "Figure four on the foot", "Toes toward the hip", "Pin the knee",
		"Rotate slowly to finish"],
	"anaconda": ["Front headlock, arm under the neck and arm", "Lock the gable grip", "Roll under the near shoulder",
		"Walk the feet around", "Squeeze to finish"],
	"north_south_choke": ["Walk from side control to north-south", "Arm under the neck, biceps on the throat", "Head to the side",
		"Drop the shoulder, hips low", "Squeeze the biceps in"],
	"back_triangle": ["From the back, trap one arm", "Leg over the shoulder, across the neck", "Lock the figure four",
		"Keep the arm inside", "Squeeze the knees"],
	# Brown belt - mastery
	"inside_heel_hook": ["Legs tied up: 50/50 or the saddle", "Pin the knee line", "Heel in the crook of the elbow", "Lock the hands",
		"Rotate to the outside to finish"],
	"saddle_entry": ["Pass toward the legs", "Slide the shin between the legs", "Triangle your legs on the thigh",
		"Knee line trapped", "Control the foot"],
	"calf_slicer": ["Trap the leg from the back or the truck", "Shin behind the knee", "Figure four the leg",
		"Pull the foot to the hip", "Squeeze to finish"],
	"crucifix": ["From the turtle, trap one arm with your legs", "Seatbelt the other arm", "Roll onto your back",
		"Both arms trapped", "Choke or arm lock"],
	"mounted_triangle": ["High mount, isolate one arm", "Push the arm across the face", "Slide the knee over the shoulder",
		"Lock the triangle", "Sit back and squeeze"],
	"counter_pass": ["Frame on the hip and shoulder", "Hips away, make space", "Knee in before the pass lands",
		"Turn in", "Recover guard"],
	"wrestle_up": ["Sit up on the elbow", "Post the hand behind", "Underhook or grab a leg", "Up on the knees",
		"Drive in on a single leg"],
	"clock_choke": ["Turtle in front: arm deep under the neck", "Grip behind the far shoulder", "Head on the back, feet wide",
		"Walk the feet around like a clock", "Squeeze as the body turns"],
	# Off the syllabus but filmed (BjjFilm)
	"omoplata": ["Swing the leg over the shoulder", "Turn to face the feet", "Sit up, arm over your hips", "Walk the hips away",
		"Lean forward to finish"],
}


static func steps(id: String) -> Array:
	return STEPS.get(id, [])


## When each of n steps starts on a film whose keyframes are reached at key_t (GrapplePlayer.key_times): an even share of
## the keyframe gaps each when there are at least n gaps, else an even share of the time.
static func starts(key_t: PackedFloat32Array, n: int) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	var gaps := key_t.size() - 1
	var length := key_t[gaps] if gaps > 0 else 0.0
	for i in n:
		out.append(key_t[floori(float(i * gaps) / n)] if gaps >= n else length * i / n)
	return out


## The step playing at time t (-1 before the first).
static func index_at(at: PackedFloat32Array, t: float) -> int:
	var i := at.size() - 1
	while i >= 0 and t < at[i] - 0.0001:
		i -= 1
	return i


## Where step i ends: the next step's start, the film's end for the last.
static func end_of(at: PackedFloat32Array, i: int, length: float) -> float:
	return at[i + 1] if i + 1 < at.size() else length

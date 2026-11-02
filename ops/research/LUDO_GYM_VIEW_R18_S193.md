# LUDO ROUND 18 (S193, 2026-10-10) - HOW TO PRESENT THE GYM (a clear training floor)

Operator S193 (verbatim, with a screenshot of the gym's bottom strip - office desks, physio table, reception sign): "why these are visible
in the gym floor, i want a clear gym floor scene , ask ludo how to present the gym".
Question (sent, TEXT ONLY, 6 sections): what the default view shows / hides and why (reference games); camera numbers; the other rooms
(reach, appear, return); floor alive yet clear; HUD regions at 1920x1080 / 1280x720; a Godot build list with script-measurable checks.
Context given to Ludo: the current 3/4 view (~50 deg), floor in the top two thirds, other rooms cut open in the bottom third; past rulings
(rooms stay 3D; rooms are expansions opened from their place in the gym, not a menu; the floor is a TRAINING floor; bright and alive;
icons over text; the 2:00 day).

## Ludo's answer (verbatim, saved byte-exact via Tools/arena_rx.py; LaTeX as Ludo wrote it)

SECTION 1 — The Default Gym View: Inclusion & Exclusion Rules
1.1 The Operator’s Core Diagnosis

The current layout suffers from visual split-brain syndrome. By displaying the active training floor in the top $66%$ of the viewport while slicing open passive non-training rooms (Office, Physio, Reception) in the bottom $33%$, the presentation breaks three spatial laws of management games:

Focal Dilution: The eye is drawn to ambient non-functional animations (a secretary typing, a physio washing hands) instead of the athlete's drilled footwork, route execution, and fatigue flags.
Aspect Ratio Cramping: The training floor is squashed into a cramped, letterboxed horizontal strip flanked by HUD rails, forcing stations to bunch together unnaturally.
Loss of Scale and Growth: If ancillary rooms are always cut open and fully visible from day one, unlocking facility upgrades feels like populating pre-existing clutter rather than claiming and modernizing real physical territory.
1.2 Industry Precedents & Comparative Analysis

| Title | Structural View Philosophy | Ancillary Space Handling | Rejection / Adoption for FightCamp |
| :--- | :--- | :--- | :--- |
| Two Point Hospital | Full dollhouse cut-away isometric camera. | All rooms rendered simultaneously; visual noise kept in check through uniform stylized walls and strict functional room zoning. | Reject Simultaneous Rooms: TPH is about facility-wide queue logistics. FightCamp is an intimate, high-stakes athletic simulation centered on 1–3 boxers. |
| Motorsport Manager | Dedicated 3D HQ compound with discrete building focal jumps. | The factory floor, wind tunnel, and design center exist within one continuous compound, but the camera frames only one functional space at a time. | Adopt Framing Rule: Move the camera smoothly between sub-facilities rather than cramming them into a single wide shot. |
| Football Manager | Data-first tactical pitch with 3D match views separated from back-office screens. | Office, boardroom, and medical facilities are kept off the match pitch entirely to preserve clean tactical clarity. | Adopt Separation of Concerns: Management menus and staff rooms should never encroach on athletic drill spaces. |
| The Sims 4 | Dynamic cut-away architecture utilizing floor/room slice toggles. | Walls fade or drop to cut-away heights when the cursor enters a designated active zone. | Adopt Wall Dissolve: Drop exterior and interior partition walls dynamically during focused room zooms. |
| Punch Club | Fixed 2.5D cross-section side view. | Shows garage equipment next to kitchen/bed areas; functional for 2D, but looks messy and crowded in 3D perspective. | Reject Cross-Section: Flattening everything into a shared wide frame creates unnecessary visual clutter in a 3D engine. |

1.3 Exact Visual Manifest: What Shows vs. What Is Excluded
+-----------------------------------------------------------------------------------+
|                           FIGHTCAMP: 3D GYM SCENE MANIFEST                        |
+-----------------------------------------------------------------------------------+
|  ZONE                    | DEFAULT VIEW STATUS   | REASON / VISUAL BEHAVIOUR      |
+--------------------------+-----------------------+--------------------------------+
|  Training Floor Ring     | VISIBLE (Focal Center)| Primary sparring & tactical area|
|  Heavy Bag Array (3 bags)| VISIBLE (Zone East)   | Power drills; bag physics active|
|  Speed Bag Platforms (2) | VISIBLE (Zone NE)     | Cadence audio & hand speed fx   |
|  Pads / Drill Square     | VISIBLE (Zone Center) | Yellow perimeter decal         |
|  Cardio Station (Bikes)  | VISIBLE (Zone NW)     | Conditioning status readouts   |
|  Weights / Dumbbells     | VISIBLE (Zone West)   | Hypertrophy & core conditioning |
|  Floor Drill Routes      | VISIBLE (Dynamic)     | ClubRoutes1 glowing spline paths|
|  Active Fighter + Coach  | VISIBLE (High Contrast| Dynamic keylight, clear outline|
|  Background Members      | VISIBLE (Capped: 4)   | Low-saturation ambient life    |
+--------------------------+-----------------------+--------------------------------+
|  Manager's Office        | HIDDEN (Exterior Wall)| Occluded by brick perimeter wall|
|  Physio / Medical Room   | HIDDEN (Exterior Wall)| Frosted glass door hotspot only |
|  Lounge / Reception      | HIDDEN (Exterior Wall)| Double-swing entry door hotspot |
|  Locker / Shower Core    | HIDDEN (Exterior Wall)| Louvered door hotspot only      |
|  Baths / Chairs / Sofas  | EXCLUDED FROM FLOOR   | Strict rule: 100% athletic gear |
+-----------------------------------------------------------------------------------+

SECTION 2 — Camera Architecture & Viewport Math
2.1 Spatial Configuration

The camera uses Godot 4’s Camera3D configured in Perspective projection with a narrow field of view. This minimizes edge distortion, keeps the floor reading cleanly, and avoids the flat lighting limitations of an orthographic camera.

       [Camera3D] 
           \
            \  Elevation: 46.0°
             \  FOV: 38.0°
              \
               v
 [NW: Cardio]       [CENTER: Ring & Pads]       [NE: Bags]
====================== 100% TRAINING FLOOR ======================
 [SW: Weights]                                  [SE: Entry Doors]
                                                        |
                                            (Hotspot to Office/Physio)

+--------------------------------------------------------------------+
| PARAMETER                       | VALUE        | TOLERANCE / UNIT  |
+---------------------------------+--------------+-------------------+
| Projection Mode                 | Perspective  | Non-negotiable    |
| Field of View (Vertical FOV)    | 38.0°        | ±1.0°             |
| Pitch Angle (Down from horizon) | 46.0°        | Fixed at default  |
| Yaw Angle (Turntable rotation)  | -35.0°       | Isometric bias    |
| Default Arm Distance (Radius)   | 22.50 m      | ±0.50 m           |
| Focal Target Point (LookAt)     | (0.0, 0.0, 0)| Ring/Pads Center  |
| Camera Height ($Y$-offset)      | 16.18 m      | Calculated        |
| Ground Groundplane Span ($XZ$)  | 17.5m x 11.2m| Framed clear area |
+--------------------------------------------------------------------+

2.2 Zoom Levels & Frustum Boundaries

Three zoom stops are clamped via smooth spring-arm damping:

                  ZOOM TIERS & VIEWPORT COVERAGE
       
    Distance
     26.0m +---------------------------------------------+
           | ZOOM 0: OVERVIEW (Full Floor + Perimeter)  |
     22.5m +---------------------------------------------+ <--- DEFAULT
           | ZOOM 1: TACTICAL FLOOR (Active Drill Zone)  |
     14.0m +---------------------------------------------+
           | ZOOM 2: FOCUS INSPECT (Fighter + Pad Coach) |
      0.0m +---------------------------------------------+

Zoom 0 — Facility Overview ($D = 26.0\text{ m}$, Pitch $= 50.0^\circ$):
Shows the entire training floor from exterior boundary wall to wall.
Used for macro route setup (ClubRoutes1) across all training stations.
Ancillary rooms remain occluded behind solid ceiling/roof planes and exterior walls.
Zoom 1 — Default Tactical Floor ($D = 22.5\text{ m}$, Pitch $= 46.0^\circ$):
Frames all 6 training stations without edge bleeding.
Station footprints fill $\ge 72%$ of unmasked HUD viewport space.
Non-training rooms are pushed entirely beyond the bottom and right frustum planes.
Zoom 2 — Boxer Focus ($D = 14.0\text{ m}$, Pitch $= 38.0^\circ$):
Centers on the selected athlete.
Displays real-time slip/counter animations, footwork drills, and sweat/fatigue particles.
Background stations fall off into an artistic, shallow depth-of-field blur.
2.3 Safe Frame Constraints & Pan Clamping
# Pan limits in world space (Meters from ring center)
const PAN_LIMIT_MIN_X: float = -6.50
const PAN_LIMIT_MAX_X: float =  6.50
const PAN_LIMIT_MIN_Z: float = -4.50
const PAN_LIMIT_MAX_Z: float =  4.00

# Strict exclusion: Camera target vector can NEVER pan positive Z into ancillary wings
static func clamp_camera_target(target: Vector3) -> Vector3:
	target.x = clampf(target.x, PAN_LIMIT_MIN_X, PAN_LIMIT_MAX_X)
	target.y = 0.0 # Locked to gym floor baseline
	target.z = clampf(target.z, PAN_LIMIT_MIN_Z, PAN_LIMIT_MAX_Z)
	return target

SECTION 3 — The Ancillary Rooms: Transitions, Hotspots & Room Navigation
3.1 Structural Philosophy: Contiguous, Non-Rendered Presence

The Office, Physio Room, Lounge, and Locker Room are not instanced into disconnected UI scenes or floating skyboxes. They exist on the same $Y = 0.0$ ground floor, positioned immediately south and south-east of the main gym's southern perimeter wall ($Z \ge +7.5\text{ m}$).

In the default view:

The dividing brick wall is solid and fully opaque ($H = 3.2\text{ m}$).
A secondary spatial shader cull disables rendering for all meshes inside non-active rooms, saving draw calls and keeping the floor visually clean.
       +---------------------------------------------+
       |             MAIN TRAINING FLOOR             |
       |  [Bikes]      [Ring / Pads]       [Bags]    |
       +===================[DOOR]====================+ <--- SOUTH BRICK WALL
       |   OFFICE   |   PHYSIO   |  LOUNGE / LOCKER  |      (Solid in Default)
       +------------+------------+-------------------+

3.2 Doorway Interactive Hotspots

Along the southern perimeter wall sit distinct, stylized architectural portals:

[DOOR A: Glass / Steel]  --> "OFFICE: Contracts, Roster & Vance Comms"
[DOOR B: Frosted Pane]    --> "PHYSIO: Cuts, Physical Therapy & Recovery"
[DOOR C: Orange Decal]   --> "RECEPTION / LOUNGE: Member Dues & Facility Renown"

Idle State: Solid architectural frames. A subtle, pulsing $0.6\text{ m}$ circular bronze floor decal projects in front of each doorway.
Hover State (Mouse-over): The decal brightens, and a high-contrast overhead brass signet illuminates (e.g., Caduceus icon for Physio, Ledger icon for Office).
Click Event: Triggers the camera transition sequence.
3.3 Camera Transition & Wall Dissolve Specs

When a doorway hotspot or quick-travel HUD hotkey is triggered, the transition executes over $0.45\text{ seconds}$ using an ease-in-out cubic curve.

   Frame 0.0s              Frame 0.18s             Frame 0.32s            Frame 0.45s
+---------------+       +---------------+       +---------------+       +---------------+
| CAMERA: Floor | ----> | WALL DISSOLVE | ----> | CAMERA PAN    | ----> | ROOM TARGET   |
| Wall Opaque   |       | Alpha -> 0.0  |       | Slerp to Room |       | Interior Full |
+---------------+       +---------------+       +---------------+       +---------------+

# RoomTransitionController.gd
class_name RoomTransitionController
extends RefCounted

const TRANSITION_TIME_SEC: float = 0.45

# Exact Transform definitions for room camera frames
const ROOM_CAMERAS: Dictionary = {
	"FLOOR_DEFAULT": {
		"pos": Vector3(10.5, 16.18, 14.5),
		"target": Vector3(0.0, 0.0, 0.0),
		"fov": 38.0
	},
	"OFFICE": {
		"pos": Vector3(-5.5, 7.8, 12.2),
		"target": Vector3(-5.5, 1.2, 8.8),
		"fov": 42.0
	},
	"PHYSIO": {
		"pos": Vector3(0.2, 6.5, 12.0),
		"target": Vector3(0.2, 1.0, 8.5),
		"fov": 40.0
	},
	"LOUNGE": {
		"pos": Vector3(6.0, 7.0, 12.5),
		"target": Vector3(6.0, 1.0, 9.0),
		"fov": 44.0
	}
}

static func evaluate_wall_alpha(progress_norm: float, entering_room: bool) -> float:
	# Front partition walls dissolve early during entry transitions
	if entering_room:
		return clampf(1.0 - (progress_norm * 2.5), 0.0, 1.0)
	else:
		return clampf((progress_norm - 0.4) * 1.66, 0.0, 1.0)

3.4 Returning to the Floor

Navigation back to the gym floor is fast, predictable, and requires only a single input:

Clicking the screen-edge chevron, pressing ESC / Space, or selecting any training station instantly swings the camera back to FLOOR_DEFAULT ($0.35\text{ s}$ reverse tween).
Partition walls instantly snap to full opacity once the camera crosses back over the $Z = +7.5\text{ m}$ threshold.
SECTION 4 — Floor Clarity, Dynamic Motion & Visual Hierarchy
4.1 Visual Hierarchy & Value Structure

To maintain clean gameplay readability, visual contrast is strictly managed across four depths:

DEPTH 0: ACTIVE FIGHTER + COACH =====> Brightest highlights, bold silhouettes, full animations
DEPTH 1: TRAINING STATIONS ==========> High-readability gym equipment, subtle ambient bounce
DEPTH 2: BACKGROUND MEMBERS (Max 4) => Muted secondary tones, desaturated tracksuits
DEPTH 3: FLOOR / WALL SHELL =========> Low-saturation dark concrete, subtle matte finishes

+-------------------+----------------+---------------+--------------------------+
| ELEMENT CLASS     | ALBEDO VALUE   | SATURATION    | SHADOW CAST / RECEIVE    |
+-------------------+----------------+---------------+--------------------------+
| Floor Concrete    | Low (0.18)     | Desaturated   | Receives all; casts none |
| Perimeter Walls   | Mid-Low (0.24) | Muted brick   | Static baked bounce      |
| Training Stations | Mid (0.45)     | Controlled    | Sharp directional shadow |
| Ambient Members   | Mid (0.40)     | Max 30% sat   | Soft contact shadows     |
| Active Boxer      | High (0.85)    | 100% vibrant  | Keylight shadow caster   |
| Yellow Pad Decal  | Vivid (#FFCC00)| 95% vibrant   | Unshaded emissive pulse  |
+-------------------+----------------+---------------+--------------------------+

4.2 Dynamic Crowding & Density Limits

A busy gym feels lively, but too many moving bodies turn the floor into visual noise. Strict caps keep the space readable:

# GymCrowdDirector.gd
class_name GymCrowdDirector
extends RefCounted

const MAX_AMBIENT_MEMBERS: int = 4
const MAX_SIMULTANEOUS_MOVERS: int = 2

# Allowed idle stations for ambient background members
const AMBIENT_SPOTS: Array[String] = [
	"HEAVY_BAG_SLOT_2",
	"SPEED_BAG_SLOT_2",
	"TREADMILL_SLOT_2",
	"MAT_STRETCH_A"
]

static func filter_allowed_members(unlocked_prestige: int) -> int:
	if unlocked_prestige < 100:
		return 1 # Early game (Anvil Street garage): Only Sal "The Anvil" Barone
	elif unlocked_prestige < 300:
		return 2
	elif unlocked_prestige < 600:
		return 3
	return MAX_AMBIENT_MEMBERS

Sal "The Anvil" Barone: Stays on Heavy Bag 2 or the corner stretch mat. He acts as living set dressing without competing with your active prospect for space.
Ambient Pathing: Background members only walk when the active fighter is stationary. If your active fighter begins a transition along a ClubRoutes1 spline, ambient walk cycles lock to idle workouts to preserve visual clarity.
4.3 Floor Surfaces & Spline Decal Architecture

The gym floor uses three functional visual elements:

The Tactical Ring ($5.0\text{ m} \times 5.0\text{ m}$): Raised $0.4\text{ m}$ off the floor with deep blue canvas and crisp white ropes. It acts as an unmistakable landmark near the center-west of the scene.
The Active Drill Square ($3.0\text{ m} \times 3.0\text{ m}$): High-visibility hazard-yellow dashed decal painted on the concrete. This highlights the pad station where the head coach runs mitt routines.
ClubRoutes1 Splines: Screen-space projected ribbons that follow station vectors. When a training day is active, they project a subtle directional pulse ($12%$ opacity) that brightens to $85%$ only while editing the day plan or hovering over stations.
SECTION 5 — HUD Ergonomics & Screen Real Estate

To give the training floor maximum breathing room, the interface is laid out around the edges like an analytical command deck.

+-----------------------------------------------------------------------------------+
| [TOP BAR: Gym Name | Roster Dropdown | Cash | Prestige | Date] [|< << > >>] Speed |
+------------------+---------------------------------------------+------------------+
|                  |                                             |                  |
| [LEFT RAIL]      |                                             | [RIGHT RAIL]     |
| Fighter Mini-Bio |             CLEAR 3D TRAINING               | Fight Week Flow  |
| Pulse (BPM)      |                   FLOOR                     | Mon-Sat Schedule |
| Stamina Gauge    |                                             | Locked Pad Chain |
| Morale / Composure|        (Zero UI overlap on stations)       | Active Opponent  |
|                  |                                             | Tell Readouts    |
|                  |                                             |                  |
+------------------+---------------------------------------------+------------------+
| [BOTTOM DRAWER: Retracted] Selected Fighter Quick Actions (Pads/Rest/Spar)        |
+-----------------------------------------------------------------------------------+

Exact Coordinates & Screen Anchors
+--------------------+---------------------------+---------------------------+
| UI REGION          | 1920 x 1080 RESOLUTION    | 1280 x 720 RESOLUTION     |
+--------------------+---------------------------+---------------------------+
| Top Bar            | (0, 0) to (1920, 56)      | (0, 0) to (1280, 42)      |
| Left Roster Column | (0, 72) to (290, 840)     | (0, 54) to (200, 560)     |
| Right Schedule Rail| (1610, 72) to (1920, 920) | (1070, 54) to (1280, 610) |
| Bottom Action Tray | (340, 980) to (1580, 1080)| (220, 650) to (1060, 720) |
| Active Floor Area  | (290, 56) to (1610, 980)  | (200, 42) to (1070, 650)  |
+--------------------+---------------------------+---------------------------+

Viewport Coverage Breakdown (1080p Basis)
Total Screen Area: $1920 \times 1080 = 2{,}073{,}600\text{ px}^2$
Total HUD Footprint: $548{,}200\text{ px}^2$ ($26.4%$ total screen cover)
Unobstructed 3D Viewport: $1{,}525{,}400\text{ px}^2$ ($73.6%$ clean screen space)
All station models fall safely within the central $73.6%$ window, ensuring zero overlap with side panels across standard resolutions.
SECTION 6 — Engine Implementation Plan: Godot 4 Build Pipeline
===================== GYM PRESENTATION BUILD REFACTOR =====================
  1. GymClubLayout.gd   --> Relocate non-training rooms behind South Wall
  2. GymClub3D.gd       --> Add visibility cull masks & wall dissolve hooks
  3. GymCameraController.gd --> Implement locked 3-tier camera rig
  4. GymFloorHUD.gd     --> Anchor UI elements to edge rails
  5. Audit Suite        --> Automatic layout verification script
===========================================================================

6.1 Architectural Relocations (GymClubLayout.gd)
[ ] Move Office_Group, Physio_Group, and Lounge_Group origins to $Z \ge +8.0\text{ m}$.
[ ] Align the main dividing brick wall (SouthWall_Mesh) along $Z = +6.8\text{ m}$, spanning $X \in [-12.0, 12.0]\text{ m}$ with height $H = 3.2\text{ m}$.
[ ] Clear all non-boxing props (couches, desks, filing cabinets) off the main floor plane ($Z \in [-6.5, 6.5]\text{ m}$).
6.2 Camera Rig Controller (GymCameraController.gd)
# GymCameraController.gd
extends Camera3D

@export var target_node: Node3D
@export var transition_speed: float = 6.0

var current_mode: String = "FLOOR_DEFAULT"
var target_cam_transform: Transform3D
var base_floor_pos: Vector3 = Vector3(9.5, 16.18, 14.5)
var base_floor_target: Vector3 = Vector3(0.0, 0.0, -0.5)

func _ready() -> void:
	fov = 38.0
	setup_floor_default()

func setup_floor_default() -> void:
	current_mode = "FLOOR_DEFAULT"
	look_at_from_position(base_floor_pos, base_floor_target, Vector3.UP)
	target_cam_transform = global_transform

func transition_to_room(room_id: String) -> void:
	if not RoomTransitionController.ROOM_CAMERAS.has(room_id):
		return
	current_mode = room_id
	var c_data: Dictionary = RoomTransitionController.ROOM_CAMERAS[room_id]
	var cam_pos: Vector3 = c_data["pos"]
	var cam_target: Vector3 = c_data["target"]
	
	var temp_cam: Camera3D = Camera3D.new()
	add_child(temp_cam)
	temp_cam.fov = c_data["fov"]
	temp_cam.look_at_from_position(cam_pos, cam_target, Vector3.UP)
	target_cam_transform = temp_cam.global_transform
	temp_cam.queue_free()

func _process(delta: float) -> void:
	global_transform = global_transform.interpolate_with(target_cam_transform, clampf(delta * transition_speed, 0.0, 1.0))

6.3 Automated Verification & Screen Budget Test Script

This automated test suite runs headlessly to verify the scene layout against the operator's guidelines.

# GymPresentationAudit.gd
class_name GymPresentationAudit
extends RefCounted

static func run_presentation_audit(
	camera: Camera3D,
	floor_viewport_rect: Rect2,
	ancillary_room_nodes: Array[Node3D],
	training_station_nodes: Array[Node3D]
) -> Dictionary:
	var report: Dictionary = {
		"pass_clean_floor_ratio": false,
		"pass_zero_ancillary_visible": false,
		"pass_all_stations_in_safe_view": false,
		"measured_floor_screen_ratio": 0.0,
		"culled_ancillary_count": 0,
		"failed_reasons": []
	}

	# 1. Assert unoccluded floor screen budget >= 70%
	var total_screen_area: float = 1920.0 * 1080.0
	var clear_floor_area: float = floor_viewport_rect.size.x * floor_viewport_rect.size.y
	var floor_ratio: float = clear_floor_area / total_screen_area
	report["measured_floor_screen_ratio"] = floor_ratio

	if floor_ratio >= 0.70:
		report["pass_clean_floor_ratio"] = true
	else:
		report["failed_reasons"].append("Floor screen area below 70%: got %0.2f" % floor_ratio)

	# 2. Check that no ancillary room meshes sit inside the camera frustum in default view
	var visible_ancillary_count: int = 0
	for room_node in ancillary_room_nodes:
		for child in room_node.get_children():
			if child is VisualInstance3D and child.visible:
				var aabb: AABB = child.get_transformed_aabb()
				if camera.is_position_in_frustum(aabb.position) or camera.is_position_in_frustum(aabb.end):
					visible_ancillary_count += 1

	if visible_ancillary_count == 0:
		report["pass_zero_ancillary_visible"] = true
		report["culled_ancillary_count"] = ancillary_room_nodes.size()
	else:
		report["failed_reasons"].append("Ancillary meshes detected in default camera frustum: count = %d" % visible_ancillary_count)

	# 3. Verify all active training stations sit comfortably inside safe screen bounds
	var all_stations_visible: bool = true
	for st in training_station_nodes:
		var screen_pt: Vector2 = camera.unproject_position(st.global_position)
		if not floor_viewport_rect.has_point(screen_pt):
			all_stations_visible = false
			report["failed_reasons"].append("Station outside viewport safe bounds: %s at %v" % [st.name, screen_pt])

	report["pass_all_stations_in_safe_view"] = all_stations_visible
	return report

6.4 Verification Output

When executed against the updated scene, GymPresentationAudit.run_presentation_audit() confirms:

Floor Coverage: $73.6%$ ($> 70.0%$ threshold) $\rightarrow$ PASS
Ancillary Meshes in Default View: $0$ ($= 0$ requirement) $\rightarrow$ PASS
Training Station Containment: All 6 functional stations fully within safe viewport area $\rightarrow$ PASS

The training floor reads cleanly as a focused athletic space, while ancillary management rooms remain integrated parts of the 3D world—hidden behind solid wall layouts until navigated to directly.

Can you continue with SECTION 2 and specify exact camera angle, height, FOV, framing, zoom, and pan limits?
Can you design the Godot 4 default gym camera view as a visual concept image showing stations, safe HUD space, and hidden rooms?
Can you continue with SECTION 3 covering room door hotspots, cut-away walls, transitions, and returning to the training floor?

## CLAUDE'S VERDICT (for the operator's approval on the board, D39)
TAKE:
- The default gym view is the TRAINING FLOOR ONLY: ring, bags, pads square, cardio, weights, drill routes, the fighter + coach, at most
  4 background members. Office, physio, reception/lounge and lockers are NOT drawn in the default view: they sit behind a solid south wall
  (3.2 m) and their meshes are culled until opened.
- Rooms are reached from their place in the gym (operator S172): a door hotspot per room on that wall (bronze floor decal, icon +
  tooltip on hover) and the same rooms from the HUD; click -> 0.45 s ease-in-out camera move with the wall dissolving; a back button /
  Esc returns to the floor view. Rooms stay 3D.
- Camera: three zooms (overview / default floor / boxer focus) with Ludo's numbers (default pitch 46 deg, FOV 38 deg) as the starting
  values, pan clamped so the camera never frames the rooms in floor mode.
- Checks a script measures: training floor >= 70% of the 1920x1080 frame in the default view; ZERO other-room meshes in the default
  frustum; every training station inside the HUD-safe area at 1920x1080 and 1280x720.
CORRECT (our record wins): positions come from OUR GymClubLayout (Ludo's coordinates are examples); stations are the ones we have (4
heavy bags, no speed bags yet); the HUD keeps today's regions (top bar, left roster, right day rail, bottom fighter card) and the safe
area is measured from them; switch `gym_floor_view` defaults OFF until the operator OKs the stills.
BUILD (after approval): GYMVIEW1 on Cursor (Godot UI/gameplay) - GymClubLayout/GymClub3D/camera + the three checks as a test that goes
RED on today's tree (the bottom strip shows the rooms), then green; game-camera stills of the floor view and one room opened, on the board.

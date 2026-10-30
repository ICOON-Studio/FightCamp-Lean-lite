extends RefCounted
## Who appears in the 3D ring (split from FightView.gd S307, 500-line rule): the two boxers' bodies and sizes, the corner
## teams (CornerCrew), and the corner minute between rounds (CornerMinute, docs/FIGHT_NIGHT_SCRIPT.md v2).
##   bodies_for(limit)  body_scales(limit, her_cm, opp_cm)  crew(stage, pro)  corner(view) -> bool

const CornerCrew := preload("res://scripts/fight3d/CornerCrew.gd")
const CornerMinute := preload("res://scripts/fight3d/CornerMinute.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")

const BODIES := ["res://assets/models/metahuman/mh_boxer_10.glb", "res://assets/models/metahuman/mh_boxer_11.glb",
	"res://assets/models/metahuman/mh_boxer_12.glb"]
## Standing height of each body above (mh_boxer_10/11/12.json height_cm).
const BODY_CM := [162.0, 169.0, 178.0]


## Our fighter's body by her weight class; the opponent gets another (so the two faces differ).
static func bodies_for(limit: float) -> Array:
	var ours := _class_body(limit)
	return [BODIES[ours], BODIES[(ours + 1) % BODIES.size()]]


static func _class_body(limit: float) -> int:
	return 0 if limit <= 57.5 else (1 if limit <= 63.0 else 2)


## S300 (operator: "the one fighter look enormous" - a lightweight drawn on the 178 cm middleweight body): each body is
## scaled to her height (her own, else her class body's), so both are the class's size; a uniform scale also scales the
## build (178 cm / 70 kg at 165 cm reads ~57 kg). Kept within 0.88-1.12 so no body is stretched past believable.
static func body_scales(limit: float, her_cm: float, opp_cm: float) -> Array:
	var ours := _class_body(limit)
	var theirs := (ours + 1) % BODIES.size()
	var her := her_cm if her_cm > 0.0 else float(BODY_CM[ours])
	var opp := opp_cm if opp_cm > 0.0 else float(BODY_CM[ours])
	return [clampf(her / float(BODY_CM[ours]), 0.88, 1.12), clampf(opp / float(BODY_CM[theirs]), 0.88, 1.12)]


## The corner teams, hidden until the first bell (built with the fight, so the bell never waits on loading).
static func crew(stage: Node3D, pro: bool) -> Node3D:
	var c := CornerCrew.new()
	stage.add_child(c)
	c.build(stage, pro)
	return c


## After a round that does not end the bout: the corner minute plays and the view's corner_done(pick) starts the next
## round. False when there is no corner (the last round, a stoppage, no crew).
static func corner(view: Node) -> bool:
	if view.crew == null or str(view._stop) != "" or int(view.round_n) >= int(view.total):
		return false
	var m: Dictionary = view.main.modal
	var r: Dictionary = (m["rounds"] as Array)[int(view.round_n) - 1]
	var f: Dictionary = view.main.career.fighter_by_id(str(view.fid))
	var names := [str(f["first"]), str(f["bout"]["opp"]["first"])]
	var en: Dictionary = r.get("energy", {})
	var card := CornerCard.card(r.get("card", CornerCard.summarize([])), float(en.get("a_end", 100.0)), names)
	view.hide_hud()
	Engine.time_scale = view.pace()
	var cm := CornerMinute.new()
	view.add_child(cm)
	cm.done.connect(view.corner_done)
	cm.run(view, view.stage, view.crew, {"round": int(view.round_n), "card": card, "won": bool(r.get("won", false)),
		"pro": (view.crew.actors as Dictionary).has("cutman"), "names": names})
	return true

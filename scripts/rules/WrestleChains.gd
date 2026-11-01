extends RefCounted
## S337 Standing wrestling chains: six tie-ups, the opponent's reaction picks the answer.
## Pure data + static helpers. Preloads nothing; graph.json is read by the caller and passed into clip_for.

const TIES: Array = [
	{"id": "collar_tie", "name": "Collar tie"},
	{"id": "underhook", "name": "Underhook"},
	{"id": "wrist_control", "name": "Wrist control"},
	{"id": "two_on_one", "name": "2-on-1"},
	{"id": "russian_tie", "name": "Russian tie"},
	{"id": "front_headlock", "name": "Front headlock"},
]

const ANSWERS: Array = [
	{"tie": "collar_tie", "reaction": "leans in on the tie", "technique": "Snapdown", "finish": "Front headlock", "points": 0, "link": "front_headlock", "clip": ["snapdown", "snap"]},
	{"tie": "collar_tie", "reaction": "carries her head high", "technique": "Duck under", "finish": "Go-behind", "points": 2, "link": "", "clip": ["duck under"]},
	{"tie": "collar_tie", "reaction": "squares up", "technique": "Slide by", "finish": "Bodylock go-behind", "points": 2, "link": "", "clip": ["body lock", "bodylock"]},
	{"tie": "collar_tie", "reaction": "steps back", "technique": "Snatch single", "finish": "Single leg", "points": 2, "link": "", "clip": ["single_leg_takedown", "single leg"]},
	{"tie": "collar_tie", "reaction": "pushes hard", "technique": "Arm drag", "finish": "Go-behind", "points": 2, "link": "", "clip": ["arm drag"]},
	{"tie": "underhook", "reaction": "pressures into it", "technique": "Throw-by", "finish": "Go-behind", "points": 2, "link": "", "clip": ["arm drag"]},
	{"tie": "underhook", "reaction": "squares her hips", "technique": "Bodylock", "finish": "Throw", "points": 2, "link": "", "clip": ["throw", "body lock"]},
	{"tie": "underhook", "reaction": "reaches for the far arm", "technique": "Knee tap", "finish": "Knee tap", "points": 2, "link": "", "clip": ["ankle pick", "knee tap"]},
	{"tie": "underhook", "reaction": "drops her head", "technique": "Front headlock", "finish": "Front headlock", "points": 0, "link": "front_headlock", "clip": ["front headlock"]},
	{"tie": "underhook", "reaction": "stays heavy", "technique": "Russian tie", "finish": "Russian tie", "points": 0, "link": "russian_tie", "clip": ["2-on-1", "russian"]},
	{"tie": "wrist_control", "reaction": "pulls her wrist back", "technique": "Snatch single", "finish": "Single leg", "points": 2, "link": "", "clip": ["single_leg_takedown"]},
	{"tie": "wrist_control", "reaction": "posts a hand on the mat", "technique": "Go-behind", "finish": "Go-behind", "points": 2, "link": "", "clip": ["#946"]},
	{"tie": "wrist_control", "reaction": "straightens her arm", "technique": "Elbow pass", "finish": "Double leg", "points": 2, "link": "", "clip": ["double_leg_takedown", "double leg"]},
	{"tie": "wrist_control", "reaction": "gives the arm", "technique": "Two on one", "finish": "2-on-1", "points": 0, "link": "two_on_one", "clip": ["2-on-1"]},
	{"tie": "two_on_one", "reaction": "pulls her arm free", "technique": "Duck under", "finish": "Go-behind", "points": 2, "link": "", "clip": ["duck under"]},
	{"tie": "two_on_one", "reaction": "turns in", "technique": "Snatch single", "finish": "Single leg", "points": 2, "link": "", "clip": ["single_leg_takedown"]},
	{"tie": "two_on_one", "reaction": "lifts her elbow", "technique": "Underhook", "finish": "Underhook", "points": 0, "link": "underhook", "clip": ["underhook"]},
	{"tie": "russian_tie", "reaction": "keeps her head on my side", "technique": "Foot block", "finish": "Foot block", "points": 2, "link": "", "clip": ["sweep"]},
	{"tie": "russian_tie", "reaction": "keeps her head on the far side", "technique": "Fireman's carry", "finish": "Fireman's carry", "points": 2, "link": "", "clip": ["fireman"]},
	{"tie": "russian_tie", "reaction": "pulls her arm away", "technique": "Double leg", "finish": "Double leg", "points": 2, "link": "", "clip": ["double_leg_takedown", "double leg"]},
	{"tie": "russian_tie", "reaction": "posts on my head", "technique": "Uchi-mata", "finish": "Throw", "points": 2, "link": "", "clip": ["uchi", "ouchi", "throw"]},
	{"tie": "russian_tie", "reaction": "squares up", "technique": "Attack the far leg", "finish": "High crotch", "points": 2, "link": "", "clip": ["single_leg_takedown"]},
	{"tie": "russian_tie", "reaction": "stands tall", "technique": "Keyhole lock", "finish": "Throw", "points": 2, "link": "", "clip": ["throw"]},
	{"tie": "russian_tie", "reaction": "drops her head", "technique": "Snapdown", "finish": "Front headlock", "points": 0, "link": "front_headlock", "clip": ["snapdown"]},
	{"tie": "front_headlock", "reaction": "stays flat on the mat", "technique": "Go-behind", "finish": "Go-behind", "points": 2, "link": "", "clip": ["#1385"]},
	{"tie": "front_headlock", "reaction": "rolls", "technique": "Gator roll", "finish": "Near fall", "points": 2, "link": "", "clip": ["gator"]},
	{"tie": "front_headlock", "reaction": "digs for a leg", "technique": "Shuck", "finish": "Go-behind", "points": 2, "link": "", "clip": ["#1353"]},
	{"tie": "front_headlock", "reaction": "turtles", "technique": "Cement job", "finish": "Near side cradle", "points": 2, "link": "", "clip": ["cement", "cradle"]},
	{"tie": "front_headlock", "reaction": "lifts her head", "technique": "Guillotine", "finish": "Front headlock", "points": 0, "link": "", "clip": ["guillotine"]},
	{"tie": "front_headlock", "reaction": "sprawls back", "technique": "Snapdown again", "finish": "Go-behind", "points": 2, "link": "", "clip": ["snapdown"]},
]


static func tie(id: String) -> Dictionary:
	for t in TIES:
		if t["id"] == id:
			return t
	return {}


static func answers(tie_id: String) -> Array:
	var out := []
	for a in ANSWERS:
		if a["tie"] == tie_id:
			out.append(a)
	return out


static func answer_for(tie_id: String, reaction: String) -> Dictionary:
	for a in ANSWERS:
		if a["tie"] == tie_id and a["reaction"] == reaction:
			return a
	return {}


static func links(tie_id: String) -> Array:
	var out := []
	for a in ANSWERS:
		if a["tie"] == tie_id and a["link"] != "":
			if not out.has(a["link"]):
				out.append(a["link"])
	return out


static func clip_for(row: Dictionary, transitions: Array) -> Array:
	var keywords: Array = row["clip"]
	if keywords.is_empty():
		return []
	var out := []
	for t in transitions:
		var title_lower: String = str(t["title"]).to_lower()
		var tags: Array = t["tags"] if t.has("tags") else []
		for kw in keywords:
			var kw_str: String = str(kw)
			if kw_str.begins_with("#"):
				var id_str: String = str(int(t["id"]))
				var target: String = kw_str.substr(1)
				if id_str == target:
					out.append(t)
					break
			else:
				var kw_lower: String = kw_str.to_lower()
				if title_lower.contains(kw_lower) or tags.has(kw_lower):
					out.append(t)
					break
	return out

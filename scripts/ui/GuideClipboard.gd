extends RefCounted
## S533 owner Q-S294-287 "C clipboard" (his mark on the old guide: "can we try something more fancy for a guide"): the guide is
## the old trainer's clipboard - this stage's jobs as a checklist, ticked as they are done, the job now on a yellow band, the
## trainer's line under it. Mockup: docs/mockups/s533/guide_c.png. FirstWeekStrip builds the panel; this file draws the paper.
##   paper() -> StyleBoxFlat      title(c) -> String      rows(c) -> [[words, "done" | "now" | "later"]]
##   job_list(c) -> Control       clip() -> Control      face(path, px) -> Control (round, named GuideFace inside)

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")

const PAPER := Palette.CLIP_PAPER
const WOOD := Palette.CLIP_BOARD
const INK := Palette.PAPER_INK
const FADED := Palette.PAPER_MUTED
const BAND := Palette.CLIP_BAND
const RED := Palette.CLIP_TITLE
const ROW_W := 380.0

const TITLES := {"FIRST WEEK": "Week 1 jobs", "FIRST FIGHT": "First fight jobs", "THE GYM": "Gym jobs"}
const JOBS := {
	"sign": "Sign your first boxer", "coach": "Hire an assistant coach", "week": "Plan the week", "go": "Start the week",
	"offer": "Answer the show's offer", "prep": "Set the fight plan", "fight": "Weigh in and fight",
	"second": "Sign a second boxer", "book": "Book every boxer a bout", "goal": "Talk about the next goal",
}


static func paper() -> StyleBoxFlat:
	var s := UI.box(PAPER, WOOD, 10, 10, 26, 18)
	s.shadow_color = Color(Palette.PAGE, Palette.SHADOW_A)
	s.shadow_size = 18
	s.shadow_offset = Vector2(0, 8)
	return s


static func title(c: Career) -> String:
	var st := FirstWeek.stage(c)
	return str(TITLES.get(str(st[0]), "Jobs")) if not st.is_empty() else "Jobs"


## The stage's jobs in order. THE GYM's jobs are FirstHour.tasks (any order); the others follow the guide's steps.
static func rows(c: Career) -> Array:
	var st := FirstWeek.stage(c)
	if st.is_empty():
		return []
	var out: Array = []
	if str(st[0]) == "THE GYM":
		var done := FirstHour.tasks(c)
		var now_given := false
		for k in FirstHour.TASKS:
			var state := "done" if bool(done.get(k, false)) else ("later" if now_given else "now")
			if state == "now":
				now_given = true
			out.append([str(JOBS.get(k, k)), state])
		return out
	var steps: Array = st[1]
	var at := steps.find(c.guide)
	for i in steps.size():
		out.append([str(JOBS.get(str(steps[i]), str(steps[i]))), "done" if i < at else ("now" if i == at else "later")])
	return out


static func job_list(c: Career) -> Control:
	var v := UI.vbox(4)
	v.name = "GuideJobs"
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for r in rows(c):
		v.add_child(_row(str(r[0]), str(r[1])))
	return v


static func _row(words: String, state: String) -> Control:
	var p := PanelContainer.new()
	p.name = "Job_" + state
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_theme_stylebox_override("panel", UI.box(BAND if state == "now" else Palette.CLEAR, Palette.CLEAR, 6, 0, 10, 2))
	var h := UI.hbox(12)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(h)
	var tone := INK if state == "now" else FADED
	var box := Panel.new()
	box.custom_minimum_size = Vector2(22, 22)
	box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_theme_stylebox_override("panel", UI.box(FADED if state == "done" else Palette.CLEAR, tone, 4, 3, 0, 0))
	h.add_child(box)
	var l := UI.label(words, 24, tone, "handbold" if state == "now" else "hand", true)
	l.custom_minimum_size = Vector2(ROW_W, 0)
	h.add_child(l)
	if state == "done":   # crossed out: a line through the words
		var strike := ColorRect.new()
		strike.color = FADED
		strike.mouse_filter = Control.MOUSE_FILTER_IGNORE
		strike.set_anchors_preset(Control.PRESET_CENTER_LEFT)
		strike.offset_top = 1.0
		strike.offset_bottom = 3.0
		strike.offset_right = minf(ROW_W, l.get_theme_font("font").get_string_size(words, HORIZONTAL_ALIGNMENT_LEFT, -1, 24).x)
		l.add_child(strike)
	return p


## The clipboard's metal clip, drawn over the top edge.
static func clip() -> Control:
	var row := UI.hbox(0)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.z_index = 1   # over the paper's top edge
	var c := Panel.new()
	c.custom_minimum_size = Vector2(150, 30)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var s := UI.box(Palette.CLIP_METAL, Palette.CLIP_METAL_EDGE, 8, 2, 0, 0)
	c.add_theme_stylebox_override("panel", s)
	row.add_child(c)
	return row


## The old trainer's face in a round frame (the drawn circle masks the picture).
static func face(path: String, px: float) -> Control:
	var ring := Panel.new()
	ring.name = "GuideFaceRing"
	ring.custom_minimum_size = Vector2(px, px)
	ring.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ring.add_theme_stylebox_override("panel", UI.box(PAPER, PAPER, int(px / 2.0), 0, 0, 0))
	ring.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	var t := TextureRect.new()
	t.name = "GuideFace"
	t.texture = load(path)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	t.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ring.add_child(t)
	return ring

extends RefCounted
## RANKSHOWUI: one line under the fighter card's name row. The words come from RankLine.before
## on the division rows. A pro, and anyone off the amateur table, gets nothing.

const UI := preload("res://scripts/ui/UI.gd")
const AfterFight := preload("res://scripts/state/AfterFight.gd")
const RankLine := preload("res://scripts/rules/RankLine.gd")
const Region := preload("res://scripts/state/Region.gd")


static func build(c: Career, f: Dictionary) -> Control:
	if bool(f.get("pro", false)):
		return null
	if str(f.get("sport", "")) == "bjj" or not f.has("div"):
		return null
	var got: Dictionary = RankLine.before(AfterFight.rows(c, f), str(f["name"]), Region.RANK_MIN_WINS)
	var lab := UI.label(str(got["words"]), UI.BODY, UI.FG)
	lab.name = "RankRow"
	lab.clip_text = true
	lab.autowrap_mode = TextServer.AUTOWRAP_OFF
	lab.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	lab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return lab

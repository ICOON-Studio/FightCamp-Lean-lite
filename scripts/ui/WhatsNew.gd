extends RefCounted
## S544 (owner on turning pro v17: "i click turn pro now , i expect to see what changed , bring up the players profile show
## me what is new"): after a decision the boxer's profile opens and says what changed, while the route carries `new`
## (set by the act; gone on the next page).
## S545 (owner on the pop-up of four icon tiles that S544 put over the profile: "this looks like AI slop"; its button
## left it open over Fights: "the window doesnt go away"): NO pop-up. The profile's top card is the moment (`card`): the
## title, one line, what changed as plain "was -> now" words, and the one next action pulsing. The bars that are new
## carry NEW on the profile itself (ProBars.mark).
##   news_pro(c, f, before) / news_wait(c, f, before) -> the route's `new` record (plain values, read once at the click)
##   news_sign(c, f, p, before) -> S545 KNOWBUILD1: a prospect signed (the place taken, the season held, the read so far)
##   card(main, body, news) -> fills the profile's top card      marks(news) -> the ProBars rows that carry a NEW chip

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const DarkOverview := preload("res://scripts/ui/DarkOverview.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const ProStart := preload("res://scripts/rules/ProStart.gd")


## What the page needs to say after Turn pro now. before = {cash, hunger, conf} read just before the click.
static func news_pro(c: Career, f: Dictionary, before: Dictionary) -> Dictionary:
	var s: Dictionary = f.get("pro_start", {})
	return {"kind": "pro", "fid": str(f["id"]), "w": int(f["w"]), "l": int(f["l"]), "paid": int(before.get("cash", c.cash)) - c.cash,
		"purse": int(f.get("purse", 0)), "share": roundi(load("res://scripts/state/Roster.gd").share_of(f) * 100.0),
		"conf": int(s.get("conf", 50)), "hunger": int(s.get("hunger", 0)), "due": int(f.get("pro_due", c.day))}


## What the page needs to say after Not yet.
static func news_wait(c: Career, f: Dictionary, before: Dictionary) -> Dictionary:
	var s: Dictionary = f.get("pro_start", {})
	return {"kind": "wait", "fid": str(f["id"]), "hunger_from": int(before.get("hunger", 0)), "hunger": int(s.get("hunger", 0)),
		"left": maxi(0, int(s.get("patience", 0)) - 1), "back": int(f.get("pro_back", c.day)), "last": not ProStart.can_wait(s)}


## S545 KNOWBUILD1: a prospect signed from the card or the trial: the place taken, the season it is held to, the read.
static func news_sign(c: Career, f: Dictionary, p: Dictionary, before: Dictionary) -> Dictionary:
	var r: Dictionary = load("res://scripts/rules/ProspectClock.gd").ranges(p["know"], p) if p.has("know") else {}
	var read := "" if r.is_empty() else "body %d-%d, skills %d-%d" % [int(r["body"]["lo"]), int(ceil(float(r["body"]["hi"]))), int(r["skills"]["lo"]), int(ceil(float(r["skills"]["hi"])))]
	return {"kind": "sign", "fid": str(f["id"]), "used": int(before.get("used", 0)), "places": int(before.get("places", 0)),
		"held": int(f.get("held_to", c.day)), "read": read, "days": int((p.get("trial", {}) as Dictionary).get("days", 0)),
		"stipend": int(f.get("weekly_salary", GameMoney.FIGHTER_STIPEND))}


static func marks(news: Dictionary) -> Array:
	return ["conf", "hunger"] if str(news.get("kind", "")) == "pro" else (["hunger", "patience"] if str(news.get("kind", "")) == "wait" else [])


## The one sentence under the card's title.
static func line(news: Dictionary) -> String:
	if str(news["kind"]) == "sign":
		return "Signed for the season. Plan the first week." if int(news["days"]) == 0 else "Signed after %d trial day%s. Plan the first week." % [int(news["days"]), "" if int(news["days"]) == 1 else "s"]
	if str(news["kind"]) == "pro":
		return "The debut is %s. Two bouts are on the table: a safe tune-up and a risky step up." % Clock.fmt(int(news["due"]))
	if bool(news["last"]):
		return "The last Not yet. Next a rival gym calls: turn pro then, or lose the boxer."
	return "The boxer stays amateur. Time for about two amateur bouts before the next call."


## What changed, in plain words: [{id, cap, was, now, col, tip}]. `was` may be "".
static func facts(n: Dictionary) -> Array:
	if str(n["kind"]) == "sign":
		return [
			{"id": "place", "cap": "PLACES", "was": "%d of %d" % [int(n["used"]), int(n["places"])], "now": "%d of %d" % [int(n["used"]) + 1, int(n["places"])], "col": Palette.HEADER,
				"tip": "Each boxer holds one of the gym's places. A wrong signing holds it too, until the season ends."},
			{"id": "held", "cap": "HELD TO", "was": "", "now": Clock.fmt(int(n["held"])), "col": Palette.ACCENT,
				"tip": "Signed for the season: Let go opens after the season's national final."},
			{"id": "stipend", "cap": "STIPEND", "was": "", "now": "%s a week" % GameMoney.text(int(n["stipend"])), "col": Palette.WARN,
				"tip": "The gym stipend, paid every week from today."},
			{"id": "read", "cap": "THE READ", "was": "", "now": str(n["read"]), "col": Palette.TEXT,
				"tip": "What the gym has seen so far. Training, sparring and bouts narrow it week by week."},
		]
	if str(n["kind"]) == "pro":
		return [
			{"id": "record", "cap": "RECORD", "was": "amateur %d-%d" % [int(n["w"]), int(n["l"])], "now": "Pro 0-0", "col": Palette.HEADER,
				"tip": "The amateur record stays on the History tab. Amateur bouts, rankings and the nationals are over for this boxer."},
			{"id": "purse", "cap": "PAY", "was": "%s a week" % GameMoney.text(GameMoney.FIGHTER_STIPEND), "now": "%s a fight" % GameMoney.text(int(n["purse"])), "col": Palette.GOOD,
				"tip": "The weekly gym stipend stops. The gym keeps %d%% of each purse; the purse grows with each win." % int(n["share"])},
			{"id": "paid", "cap": "PAID TODAY", "was": "", "now": "-%s" % GameMoney.text(int(n["paid"])), "col": Palette.BAD,
				"tip": "The boxing board's licence, the scans, medical and bloods, and your coach's trainer licence if the coach had none."},
		]
	return [
		{"id": "patience", "cap": "PATIENCE", "was": "", "now": "%d Not yet left" % int(n["left"]), "col": Palette.HEADER,
			"tip": "Each Not yet spends a patience mark. With none left the next call comes from a rival gym: turn pro then, or the boxer leaves."},
		{"id": "hunger", "cap": "HUNGER", "was": str(int(n["hunger_from"])), "now": str(int(n["hunger"])), "col": Palette.WARN,
			"tip": "How much the boxer wants it. Each Not yet takes %d. A risky pro bout brings it back; at 0 the boxer asks to leave." % -ProStart.NOT_YET_HUNGER},
		{"id": "back", "cap": "NEXT CALL", "was": "", "now": Clock.fmt(int(n["back"])), "col": Palette.ACCENT,
			"tip": "The same offer returns in %d weeks. Wins in between raise the debut's ticket sales." % ProStart.NOT_YET_WEEKS},
	]


## The profile's top card after the decision: title and line, the facts, the one next action.
static func card(main: Node, body: VBoxContainer, news: Dictionary) -> void:
	var pro := str(news["kind"]) == "pro"
	var signed := str(news["kind"]) == "sign"
	var row := UI.hbox(36)
	row.name = "WhatsNewRow"
	body.add_child(row)
	var left := UI.vbox(2)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_stretch_ratio = 1.3
	row.add_child(left)
	var title := UI.display("SIGNED" if signed else ("A PRO FROM TODAY" if pro else "NOT YET"), 44, Palette.HEADER if pro or signed else Palette.TEXT)
	title.name = "NewsTitle"
	left.add_child(title)
	MenuFx.slam(title)
	left.add_child(UI.label(line(news), UI.BODY, Palette.TEXT, "body", true))
	for t in facts(news):
		var v := UI.vbox(2)
		v.name = "Fact_" + str(t["id"])
		v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		v.mouse_filter = Control.MOUSE_FILTER_STOP
		v.tooltip_text = str(t["tip"])
		v.add_child(UI.label(str(t["cap"]), 15, Palette.MUTED, "caps"))
		var h := UI.hbox(8)
		if str(t["was"]) != "":
			h.add_child(UI.label("%s  \u2192" % str(t["was"]), UI.BODY, Palette.MUTED, "body"))
		h.add_child(UI.label(str(t["now"]), 20 if str(t["id"]) == "read" else 26, t["col"], "bold"))
		if signed and str(t["was"]) == "":
			h.add_child(load("res://scripts/ui/ProBars.gd").new_chip())
		v.add_child(h)
		row.add_child(v)
	var go := UI.button("Plan the week", "Go", main.act.bind("ftab", "3")) if signed else \
		UI.button("Pick the first pro fight" if pro else "Find an amateur bout", "Go", main.act.bind("go", "fights:0"))
	go.name = "NewsGo"
	DarkOverview.main_style(go)
	go.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	go.custom_minimum_size.x = 320.0
	Pulse.breathe(go)
	row.add_child(go)

extends RefCounted
## S544 (owner on turning pro v17: "i click turn pro now , i expect to see what changed , bring up the players profile show
## me what is new"): after a decision the boxer's profile opens with the pop-up ProNews over it - what the decision
## changed as before -> after tiles (ResultTiles.tile, the result page's own tile) - and on the profile the things
## that are new carry NEW (ProBars.mark) while the route carries `new` (set by the act; gone on the next page).
##   news_pro(c, f, before) / news_wait(c, f, before) -> the route's `new` record (plain values, read once at the click)
##   tiles(news) / line(news) -> the pop-up's content      marks(news) -> the ProBars rows that carry a NEW chip

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const ResultTiles := preload("res://scripts/ui/ResultTiles.gd")
const DarkOverview := preload("res://scripts/ui/DarkOverview.gd")
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


static func marks(news: Dictionary) -> Array:
	return ["conf", "hunger"] if str(news.get("kind", "")) == "pro" else (["hunger", "patience"] if str(news.get("kind", "")) == "wait" else [])


## The one sentence under the pop-up's title.
static func line(news: Dictionary) -> String:
	if str(news["kind"]) == "pro":
		return "The debut is %s. Two bouts are on the table: a safe tune-up and a risky step up." % Clock.fmt(int(news["due"]))
	if bool(news["last"]):
		return "That was the last Not yet. Next time a rival gym calls, and it is turn pro or lose the boxer."
	return "The boxer stays amateur for now. There is time for about two amateur bouts before the promoter calls again."


static func tiles(news: Dictionary) -> Array:
	return _pro_tiles(news) if str(news["kind"]) == "pro" else _wait_tiles(news)


static func _pro_tiles(n: Dictionary) -> Array:
	return [
		{"id": "record", "icon": "trophy", "col": Palette.HEADER, "big": "PRO 0-0", "side": "was amateur %d-%d" % [int(n["w"]), int(n["l"])], "label": "the record starts again",
			"tip": "The amateur record stays on the History tab. Amateur bouts, rankings and the nationals are over for this boxer."},
		{"id": "purse", "icon": "ticket", "col": Palette.GOOD, "big": "%s A FIGHT" % GameMoney.text(int(n["purse"])), "side": "was %s a week" % GameMoney.text(GameMoney.FIGHTER_STIPEND),
			"label": "the gym keeps %d%% of each purse" % int(n["share"]),
			"tip": "The weekly club stipend stops. The purse grows with each win. The club's amateur ticket cut ends too."},
		{"id": "paid", "icon": "clipboard-pen", "col": Palette.BAD, "big": "-%s" % GameMoney.text(int(n["paid"])), "label": "paid today: licence and medical",
			"tip": "The boxing board's licence, the scans, medical and bloods, and your coach's trainer licence if the coach had none."},
		{"id": "bars", "icon": "flame", "col": Palette.WARN, "big": "2 NEW BARS", "side": "%d and %d" % [int(n["conf"]), int(n["hunger"])], "label": "confidence · hunger, under loyalty",
			"tip": "Two new bars on this boxer for pro fights 1 to 6. Confidence moves the win chance by up to 5 points. Hunger falls with safe wins and rises with a risky bout; at 0 the boxer asks to leave."},
	]


static func _wait_tiles(n: Dictionary) -> Array:
	return [
		{"id": "patience", "icon": "refresh-cw", "col": Palette.HEADER, "big": "%d NOT YET LEFT" % int(n["left"]), "pips": [int(n["left"]), ProStart.PATIENCE - 1], "label": "patience: one spent",
			"tip": "Each Not yet spends a patience mark. With one mark left the next call comes from a rival gym: turn pro then, or the boxer leaves."},
		{"id": "hunger", "icon": "flame", "col": Palette.WARN, "big": "%d" % int(n["hunger"]), "side": "was %d" % int(n["hunger_from"]), "label": "hunger: waiting costs it",
			"tip": "How much the boxer wants it. Each Not yet takes %d. A risky pro bout brings it back; at 0 the boxer asks to leave." % -ProStart.NOT_YET_HUNGER},
		{"id": "back", "icon": "play", "col": Palette.ACCENT, "big": Clock.fmt(int(n["back"])).to_upper(), "label": "the promoter calls again",
			"tip": "The same offer returns in %d weeks. Wins in between raise the debut's ticket sales." % ProStart.NOT_YET_WEEKS},
	]

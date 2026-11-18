extends SceneTree
## S516 MATRECEIPT1 wired: every open (live or headless, Grapplers._close) adds each brought plan line's tries and wins to
## the athlete's season book (f["mat_book"] = {edge: [tried, worked]}), and the plan panel's row reads the coach's verdict.
## Population: Ana (NoGi.athlete) with the coach's drafted plan (escapes from five bottom positions + a finish), four
## opens on their own days (each draws its own field). The book must equal the opens' receipts added up. Prints MAT_BOOK failures=N.

const Grapplers := preload("res://scripts/state/Grapplers.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const MatReceipt := preload("res://scripts/rules/MatReceipt.gd")
const MatLines := preload("res://scripts/rules/MatLines.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")

const SC := "side_control_bottom"

var _fails := 0


func _initialize() -> void:
	Grapplers.live = false
	var c := Career.new()
	c.seed = 11
	c.cash = 5000
	c.grapplers = [NoGi.athlete()]
	var ana: Dictionary = c.grapplers[0]
	var rl := BjjTree.rules_for(str(ana.get("belt", "white")))
	ana["bjj_plan"] = MatLines.draft(ana, [SC, "mount_bottom", "back_bottom", "half_guard_bottom", "closed_guard_bottom"], rl)
	_check((ana["bjj_plan"]["lines"] as Array).size() >= 2, "the coach drafts lines: %s" % str(ana["bjj_plan"]["lines"]))
	_check(not ana.has("mat_book"), "no book before any open")
	var want := {}
	for d in [33, 68, 103, 138]:
		_check(Grapplers.enter(c, "ana", d) == "", "she enters the open on day %d" % d)
		var seen := (ana.get("opens", []) as Array).size()
		c.day = d
		Grapplers.day(c)
		var fresh: Array = (ana["opens"] as Array).slice(0, (ana["opens"] as Array).size() - seen)
		MatReceipt.season_add(want, MatReceipt.receipt(ana["bjj_plan"], ana, fresh, rl))
	var book: Dictionary = ana.get("mat_book", {})
	_check(str(book) == str(want) and not book.is_empty(), "the book is the four opens' receipts added up: %s" % str(book))
	var tried := 0
	for k in book:
		tried += int(book[k][0])
		_check(int(book[k][1]) <= int(book[k][0]), "worked never above tried on %s" % k)
	_check(tried > 0, "the plan's lines were tried %d times over four opens" % tried)
	var e0 := str(book.keys()[0]) if not book.is_empty() else ""
	var v := MatReceipt.verdict_of(book, e0)
	_check(v in ["works", "fails", "even", "too early"], "the coach's verdict is a word: %s" % v)
	print("MAT_BOOK failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1

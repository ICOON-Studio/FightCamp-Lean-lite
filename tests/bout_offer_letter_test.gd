extends SceneTree
## S535 OFFERBUILD1 (owner Q-S294-296 "Yes, build it"; mockup ops/previews/s535_offer_mockup/offer.png): a bout offer opens as
## the host club's LETTER, not as a second tale of the tape. Centre: the letter (crest, the matchmaker's line, the night, time
## to prepare, money, sanction, IF YOUR BOXER WINS / LOSES, the answer-by stamp). Left: our boxer and what a pass costs.
## Right: the coach's read with the win range, the opponent, WHAT DECIDES IT. Under it: Pass, Full report, Accept the bout.
## Every number is the game's; a fact not known reads "not on tape"; names only in the two headers.
## Prints BOUT_OFFER_LETTER failures=N.

const MAIN := preload("res://scenes/Main.tscn")
const Sim := preload("res://scripts/state/Sim.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutCompare := preload("res://scripts/ui/BoutCompare.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const CoachRead := preload("res://scripts/rules/CoachRead.gd")
const CoachReadWire := preload("res://scripts/state/CoachReadWire.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const UI := preload("res://scripts/ui/UI.gd")

const LETTER := ["LetterHead", "LetterTitle", "LetterLede", "Term_night", "Term_prepare", "Term_club", "Term_sanction",
	"IfWin", "IfLoss", "LetterSign", "LetterStamp"]
const MINE := ["MineName", "Mine_Record", "Mine_Last5", "Mine_Streak", "Mine_Shape", "Mine_Scale", "Mine_Pass"]
const READ := ["ReadQuote", "ReadWin", "ReadRange", "ReadGain", "ReadRisk", "ReadSure"]
const OPP := ["OppName", "Opp_Last5", "Opp_Streak", "Opp_Style", "Opp_Best", "Decides_Record", "Decides_Reach",
	"Decides_Experience", "ScoutLine"]
const OLD_TABLE := ["VersusCard", "Versus", "Side_red", "Side_blue", "Tape_AGE", "Tape_HEIGHT", "Tape_STANCE", "Tape_WEIGHT", "VersusWin"]

var failures := 0
var main: Node


func _initialize() -> void:
	MenuFx.instant = true
	root.size = Vector2i(1920, 1080)
	main = MAIN.instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	c.guide = ""
	c.first_hour = {}
	var f: Dictionary = c.fighter()
	f["offers"].append(Bouts._offer("lucy:t1", (Data.OPPONENTS[0] as Dictionary).duplicate(true), c.day + 19, c.day + 3, 4))
	f["offers"].append(Bouts._offer("lucy:t2", Data.MISMATCH.duplicate(true), c.day + 19, c.day + 3, 4))
	var o: Dictionary = Bouts.find_offer(c, "lucy:t1")[1]
	var opp: Dictionary = o["opp"]

	main.act("openBout", "lucy:t1")
	await _frames(4)
	var page: Control = main.find_child("OfferPage", true, false)
	_check(page != null, "the offer opens on the letter page")
	if page == null:
		_end()
		return
	var letter: Control = page.find_child("OfferLetter", true, false)
	_check(letter != null, "the centre is the host club's letter")
	for n in LETTER:
		_check(page.find_child(n, true, false) != null, "the letter has " + n)
	_check(page.find_child("OfferMine", true, false) != null, "left: our boxer")
	for n in MINE:
		_check(page.find_child(n, true, false) != null, "our boxer's slate has " + n)
	_check(page.find_child("OfferRead", true, false) != null, "right: the coach's read")
	for n in READ:
		_check(page.find_child(n, true, false) != null, "the read has " + n)
	_check(page.find_child("OfferOpp", true, false) != null, "right: the opponent")
	for n in OPP:
		_check(page.find_child(n, true, false) != null, "the opponent's slate has " + n)
	for n in OLD_TABLE:
		_check(main.find_child(n, true, false) == null, "the old stat table is gone (%s)" % n)
	for side in ["OfferMine", "OfferOpp"]:
		var body: TextureRect = (page.find_child(side, true, false) as Node).find_child("Body", true, false)
		_check(body != null and body.texture != null, "%s shows the painted body" % side)

	# Every number is the game's.
	_check(_words(page, "LetterHead").contains(str(opp["club"]).to_upper()), "the letter is headed by the host club (%s)" % _words(page, "LetterHead"))
	_check(_words(page, "LetterTitle") == "Bout offer", "it is titled Bout offer")
	_check(_words(page, "Term_night").contains(Clock.fmt(int(o["day"]))), "the night is the offer's day (%s)" % _words(page, "Term_night"))
	_check(_words(page, "Term_prepare").contains("2 weeks"), "time to prepare is the days to the bout (%s)" % _words(page, "Term_prepare"))
	_check(_words(page, "Term_club").contains(UI.money(BoutRules.TICKET_CUT)), "the club's money is the ticket cut (%s)" % _words(page, "Term_club"))
	_check(_words(page, "Term_sanction").contains("Legal, even match") and _words(page, "Term_sanction").contains("%d bouts against %d" % [int(o["own_bouts"]), int(o["their_bouts"])]),
		"the sanction says legal, on both boxers' bouts (%s)" % _words(page, "Term_sanction"))
	_check(_words(page, "IfWin").contains("+%d members" % BoutRules.WIN_MEMBERS) and _words(page, "IfWin").contains("Record %d-%d" % [int(f["w"]) + 1, int(f["l"])])
		and _words(page, "IfWin").contains("Loyalty %+d" % int(Loyalty.MOVES["bout_won"])), "a win: the members, the record, the loyalty (%s)" % _words(page, "IfWin"))
	_check(_words(page, "IfLoss").contains("%d member" % BoutRules.LOSS_MEMBERS) and _words(page, "IfLoss").contains("%d if stopped" % BoutRules.STOPPED_LOSS_MEMBERS)
		and _words(page, "IfLoss").contains("Record %d-%d" % [int(f["w"]), int(f["l"]) + 1]), "a loss: the members, the record (%s)" % _words(page, "IfLoss"))
	_check(_words(page, "LetterStamp").contains(Clock.fmt(int(o["expires"])).to_upper()) and _words(page, "LetterStamp").contains("3 DAYS LEFT"),
		"the stamp is the answer-by day (%s)" % _words(page, "LetterStamp"))
	var read := BoutCompare.win_read(c, f, opp, BoutRead.camp_for(f, int(o["day"]) - c.day))
	_check(_words(page, "ReadWin") == "%d%%" % int(read["mid"]), "the win chance is the game's (%s)" % _words(page, "ReadWin"))
	var r := CoachRead.read(CoachReadWire.facts(c, f, o))
	_check(_words(page, "ReadQuote").contains(str(r["verdict"])), "the read's verdict is the coach read's (%s)" % _words(page, "ReadQuote"))
	_check(_words(page, "ReadGain").contains(str(r["gain"])) and _words(page, "ReadRisk").contains(str(r["cost"])) and _words(page, "ReadSure").contains("%d of 3" % int(r["sure"])),
		"gain, risk and how sure are the coach read's")
	_check(_words(page, "Mine_Record").contains("%d-%d" % [int(f["w"]), int(f["l"])]), "our record (%s)" % _words(page, "Mine_Record"))
	var price := Bouts.pass_price(c, f, o)
	var pass_words := "costs nothing" if price == 0 else "loyalty %d" % price
	_check(_words(page, "Mine_Pass").contains(pass_words), "what a pass costs is Bouts.pass_price (%s)" % _words(page, "Mine_Pass"))
	_check(_words(page, "Decides_Experience").contains("%d bouts" % int(o["own_bouts"])) and _words(page, "Decides_Experience").contains("%d bouts" % int(o["their_bouts"])),
		"experience is both boxers' bouts (%s)" % _words(page, "Decides_Experience"))
	_check(_words(page, "Decides_Record").contains("%d-%d" % [int(opp["w"]), int(opp["l"])]), "the opponent's record (%s)" % _words(page, "Decides_Record"))
	var s := BoutRead.stage(opp)
	_check(_words(page, "ScoutLine").contains("%d of %d found" % [int(s["found"]), int(s["all"])]), "the scouting line (%s)" % _words(page, "ScoutLine"))
	# A fact not known reads "not on tape".
	_check(not OppFile.known(opp, "weapon") and _words(page, "Opp_Best").contains("not on tape"), "the best punch is not on tape yet (%s)" % _words(page, "Opp_Best"))
	opp["file_found"] = ["weapon"]
	main.render()
	await _frames(3)
	page = main.find_child("OfferPage", true, false)
	_check(_words(page, "Opp_Best").contains(str(opp["threat"])), "found on tape, it is shown (%s)" % _words(page, "Opp_Best"))
	(opp["file_found"] as Array).clear()
	main.render()
	await _frames(3)
	page = main.find_child("OfferPage", true, false)

	# Names only in the two headers; tooltips explain.
	var named: Array = []
	_names(page, [str(f["name"]), str(f["first"]), str(opp["name"]), str(opp["name"]).get_slice(" ", 0)], named)
	_check(named.is_empty(), "names only in the headers (%s)" % str(named))
	var echo: Array = []
	_tips(page, echo)
	_check(echo.is_empty(), "no tooltip repeats its own label (%s)" % str(echo))

	# The answer.
	var accept: Button = main.find_child("Accept", true, false)
	var pass_b: Button = main.find_child("Pass", true, false)
	var report: Button = main.find_child("FullReport", true, false)
	_check(accept != null and not accept.disabled, "Accept is live on a legal offer")
	_check(accept != null and _words_of(accept).contains("Accept the bout") and _words_of(accept).contains(Clock.fmt(int(o["day"]))) and _words_of(accept).contains(UI.money(BoutRules.TICKET_CUT)),
		"Accept carries the date and the money (%s)" % (_words_of(accept) if accept != null else "?"))
	_check(pass_b != null and _words_of(pass_b).contains(pass_words), "Pass shows its cost (%s)" % (_words_of(pass_b) if pass_b != null else "?"))
	var answer: Control = main.find_child("OfferAnswer", true, false)
	_check(answer != null and answer.get_global_rect().end.y <= 1080.0, "the answer row is on the screen (ends at %.0f)" % (answer.get_global_rect().end.y if answer != null else -1.0))
	_check(page.get_global_rect().end.x <= 1920.0 and page.get_global_rect().end.y <= 1080.0, "the whole page fits 1920x1080 (ends %s)" % str(page.get_global_rect().end))
	_check(report != null, "the full report is one click away")
	if report != null:
		report.pressed.emit()
		await _frames(2)
		_check(main.find_child("BoutStats", true, false) != null and main.find_child("OfferPage", true, false) == null, "Full report opens the report")
		var back: Button = main.find_child("BackToVersus", true, false)
		_check(back != null, "a way back to the letter")
		if back != null:
			back.pressed.emit()
			await _frames(2)
			_check(main.find_child("OfferLetter", true, false) != null, "back on the letter")

	# An unsafe pair: the letter says so and cannot be accepted.
	main.act("openBout", "lucy:t2")
	await _frames(3)
	page = main.find_child("OfferPage", true, false)
	var unsafe: Button = main.find_child("Accept", true, false)
	_check(unsafe != null and unsafe.disabled and unsafe.tooltip_text.contains("sanction"), "an unsafe offer cannot be accepted, and the button says why")
	_check(page != null and _words(page, "Term_sanction").contains("Not safe"), "the letter's sanction line says not safe")
	_check(page != null and not _words(page, "Mine_Pass").contains("loyalty -"), "passing an unsafe offer costs nothing (%s)" % (_words(page, "Mine_Pass") if page != null else "?"))

	main.act("openBout", "lucy:t1")
	await _frames(3)
	accept = main.find_child("Accept", true, false)
	if accept != null:
		accept.pressed.emit()
		await _frames(2)
	_check(not (f["bout"] as Dictionary).is_empty(), "Accept books the bout")
	_end()


func _end() -> void:
	print("BOUT_OFFER_LETTER failures=%d" % failures)
	print("PASS bout_offer_letter_test" if failures == 0 else "FAIL bout_offer_letter_test")
	quit(1 if failures > 0 else 0)


func _frames(n: int) -> void:
	for i in n:
		await process_frame


## Every word under the node called `name`, in tree order.
func _words(under: Node, name: String) -> String:
	var n := under.find_child(name, true, false)
	return _words_of(n) if n != null else ""


func _words_of(n: Node) -> String:
	var out: Array = []
	_collect(n, out)
	return " ".join(PackedStringArray(out))


func _collect(n: Node, out: Array) -> void:
	if n is Label and str((n as Label).text) != "":
		out.append(str((n as Label).text))
	elif n is Button and str((n as Button).text) != "":
		out.append(str((n as Button).text))
	for ch in n.get_children():
		_collect(ch, out)


func _names(n: Node, words: Array, out: Array) -> void:
	if str(n.name) in ["MineName", "OppName"]:
		return
	if n is Label:
		for w in words:
			if str((n as Label).text).contains(str(w)):
				out.append("%s: %s" % [n.name, (n as Label).text])
	for ch in n.get_children():
		_names(ch, words, out)


func _tips(n: Node, out: Array) -> void:
	if n is Control and str((n as Control).tooltip_text) != "":
		var tip := str((n as Control).tooltip_text).strip_edges().to_lower()
		var own := _words_of(n).strip_edges().to_lower()
		if tip == own or (own != "" and tip.trim_suffix(".") == own.trim_suffix(".")):
			out.append("%s: %s" % [n.name, tip])
	for ch in n.get_children():
		_tips(ch, out)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)

extends VBoxContainer
## CLUB: Staff (hire a coach), Members, Facilities, Records (S388), beside Money (AreaHead joins the two). S394 the Floor tab went, PLAYER_PATH 6.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Data := preload("res://scripts/state/Data.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Region := preload("res://scripts/state/Region.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const TopCards := preload("res://scripts/ui/TopCards.gd")
const RecordsPage := preload("res://scripts/ui/RecordsPage.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	AreaHead.add(self, main, "gym")
	match int(main.route["tab"]):
		0, 1, 2:
			# S396 screen cut: People = the staff and the members (Routes.gd).
			_staff(main, c)
			_members(c)
			# S396 blind round 2 (labels and values 1,600 px apart): the two cards side by side.
			var cols := UI.hbox(16)
			cols.name = "PeopleCols"
			var n := get_child_count()   # staff, members, then the members' "why they join" card
			var two := [get_child(n - 3), get_child(n - 2)]
			for ch in two:
				remove_child(ch)
				cols.add_child(ch)
			add_child(cols)
			move_child(cols, get_child_count() - 2)
		3:
			_facilities(main, c)
		4:
			add_child(RecordsPage.build(main, c))


## S397 blind round 4 ("rating 58" is a raw number): a coach's rating in words.
static func _grade(r: int) -> String:
	return "a solid club coach" if r < 65 else ("a strong coach" if r < 80 else "an elite coach")


func _members(c: Career) -> void:
	var card := UI.card("MEMBERS")
	var target := Membership.natural_members(c.reputation)
	# S396 blind review ("57 (growing toward 57)" read as debug): the count says where it is heading, the cap says only itself.
	var drift := "steady" if target == c.members else ("growing toward %d" % target if target > c.members else "falling toward %d" % target)
	var books := UI.kv("On the books", "%d, %s" % [c.members, drift], UI.FG, "mono")
	books.name = "Members"
	Tips.card(books, func(): return TopCards.members(c))   # S362 J90 6g
	UI.add_rows(card[1], [
		books,
		UI.kv("Reputation", "known locally" if c.reputation < 30 else ("known in the region" if c.reputation < 60 else "a name in the sport"), UI.FG, "mono"),
		UI.kv("Dues", "%s a month each" % UI.money(Membership.weekly_rate()), UI.FG, "mono"),
	] + ([UI.kv("Evening classes", "need a coach")] if c.coach.is_empty() else []))
	card[1].add_child(UI.muted("Reputation grows with your fighters' wins (+%d each) and a well-kept gym; the count walks toward what the gym can carry, a few a week." % BoutRules.WIN_REPUTATION, UI.SMALL, true))
	add_child(card[0])
	var why := UI.card("WHY THEY JOIN")
	var rows: Array = []
	# S397 round 1 (blind: a member quotes the training on day one): the quotes start once a week has run.
	for line in (Region.why_join(c) if c.day >= 7 else []):
		rows.append(UI.label("\"%s\"" % line, UI.BODY, UI.FG, "italic", true))
	if rows.is_empty():
		rows.append(UI.muted("The members say why they come once the gym has run a week.", UI.BODY, true))
	UI.add_rows(why[1], rows)
	add_child(why[0])


func _facilities(main: Node, c: Career) -> void:
	var card := UI.card("FACILITIES")
	var rows: Array = []
	for f in c.facilities:
		var right: Array = []
		if str(f["state"]) == "worn":
			right.append(UI.chip("worn", "amber"))
			var b := UI.button("Repair, %s" % UI.money(int(f["repair"])), "Btn", main.act.bind("repair", f["id"]))
			b.name = "Repair_" + str(f["id"])
			right.append(b)
		else:
			right.append(UI.chip("good", "green"))
		var kit_row := UI.row(f["name"], "", Color(0, 0, 0, 0), right)
		kit_row.name = "Kit_" + str(f["id"])
		Tips.card(kit_row, func(): return TopCards.kit(c, f))   # S362 J90 6g
		rows.append(kit_row)
	UI.add_rows(card[1], rows)
	add_child(card[0])


func _staff(main: Node, c: Career) -> void:
	var card := UI.card("STAFF")
	add_child(card[0])
	var rows: Array = []
	if not c.head.is_empty():   # S397 rank 5: you, the head coach, and your edge (HeadCoach)
		rows.append(_you(c))
	if not c.coach.is_empty():   # S397 round 1 (blind: "a tiny green square marks the hire"): the assistant as a card
		rows.append(_assistant(main, c, c.coach, true))
	# S396 blind review: Money paid a BJJ coach Staff never named. The no-gi classes' coach is paid by the class.
	if not c.grapplers.is_empty():
		var bjj := Sim.bjj_money(c)
		rows.append(UI.row("No-gi classes' coach, by the class", "%s a class, %s a week" % [UI.money(BjjSide.COACH_CLASS), UI.money(int(bjj["coach"]))], UI.GREEN))
	if c.coach.is_empty():
		var pair := UI.hbox(14)   # S397 round 2 (blind: "spec strings"): two cards side by side, one table each
		for coach in Data.COACHES:
			pair.add_child(_assistant(main, c, coach, false))
		rows.append(pair)
	UI.add_rows(card[1], rows)
	# (S398 rank 5 round 3, blind: "What Luke brings repeats the card": the hired assistant's card carries it now.)


## S397 rank 5: the head coach's row - the photo from the start, the name, the edge as a result.
static func _you(c: Career) -> Control:
	var cd := HeadCoach.card(HeadCoach.of(c.head))
	var h := UI.hbox(14)
	h.name = "HeadCoachRow"
	var pic := PromoShot.picture(str(cd.get("photo", "")), Vector2(64, 64))
	if pic != null:
		h.add_child(pic)
	var v := UI.vbox(2)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(UI.label("%s, head coach (you)" % c.head.get("name", HeadCoach.DEFAULT_NAME), UI.BODY, UI.FG, "bold"))
	v.add_child(UI.label("%s: %s" % [cd.get("title", ""), str(cd.get("edge", "")).to_lower()], UI.SMALL, UI.GOLD, "bold"))
	v.add_child(UI.muted(str(cd.get("plain", "")), UI.SMALL, true))
	h.add_child(v)
	return h


## S397 rank 5 rounds 1-2 (the designer's 8/10 version; blind round 2: "a comparison table, the better value shown"): an assistant
## as a card - a real photo, a one-line pitch, and the rules' own numbers: the session share (Sim: 0.5 + rating x 0.7 / 100; none
## = 60%), the plan lines taught (PlanBoard), the evening classes' money and the weekly cost net of them.
static func _assistant(main: Node, c: Career, coach: Dictionary, hired: bool) -> Control:
	var card := PanelContainer.new()
	card.name = "Assistant_" + str(coach["id"])
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sb := StyleBoxFlat.new()
	sb.bg_color = UI.PANEL2 if not hired else UI.PANEL
	sb.border_color = UI.GREEN if hired else UI.LINE
	sb.set_border_width_all(2 if hired else 1)
	sb.set_corner_radius_all(10)
	sb.set_content_margin_all(14)
	card.add_theme_stylebox_override("panel", sb)
	var v := UI.vbox(8)
	card.add_child(v)
	var head := UI.hbox(12)
	var pic := PromoShot.picture(_assistant_photo(c, str(coach["id"])), Vector2(72, 72))
	if pic != null:
		head.add_child(pic)
	var who := UI.vbox(2)
	who.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	who.add_child(UI.label(str(coach["name"]), UI.BODY + 1, UI.FG, "bold"))
	who.add_child(UI.chip(("HIRED - " if hired else "") + str(coach["kind"]).to_upper(), "green" if hired else ""))
	who.add_child(UI.muted("%s, %s." % [str(coach["spec"]), coach["note"]], UI.SMALL, true))
	head.add_child(who)
	v.add_child(head)
	var r := float(coach["rating"])
	var net := int(coach["salary"]) - GameMoney.CLASSES_WITH_COACH
	for kv in [["Training quality", "%d%% (alone: 60%%)" % roundi((0.5 + r * 0.7 / 100.0) * 100.0)], ["Fight-plan lines", "%d" % PlanBoard.arrow_limit(r)],
			["Cost a week", UI.money(int(coach["salary"]))], ["Evening classes", "+%s a week" % UI.money(GameMoney.CLASSES_WITH_COACH)],
			["Net a week", "-%s" % UI.money(net)]] + ([] if hired else [["To sign", UI.money(GameMoney.COACH_SIGNING_FEE)]]):
		v.add_child(UI.kv(str(kv[0]), str(kv[1]), UI.RED if str(kv[0]) == "Net a week" else UI.FG, "mono"))
	if not hired:
		var b := UI.button("Hire %s" % str(coach["name"]).get_slice(" ", 0), "BtnSolid", main.act.bind("hire", coach["id"]))
		b.name = "Hire_" + str(coach["id"])
		v.add_child(b)
	return card


## The assistants' photos (S398 round 3, blind: "Luke and Marcus wear women's faces"): Marcus Hale the corner's man in a shirt, Luke Reid
## a young ex-boxer's studio photo; when the head coach took the corner's man (the ex-pro card), Marcus takes a second ex-boxer.
static func _assistant_photo(c: Career, id: String) -> String:
	var mine := str(HeadCoach.card(HeadCoach.of(c.head)).get("photo", ""))
	if id == "reid":
		return "mh_boxer_07"
	return "mh_boxer_08" if mine == "mh_staff_trainer" else "mh_staff_trainer"

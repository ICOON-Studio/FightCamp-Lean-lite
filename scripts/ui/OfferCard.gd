extends RefCounted
## S387 (blind critic, the offers list 3/10: "no face, record, style or win chance"): one card per bout offer. The opponent's photo,
## name, record and style; the date and answer-by; the win band read off BoutRead; the gap, rank and ticket-cut chips; Open.

const UI := preload("res://scripts/ui/UI.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutCompare := preload("res://scripts/ui/BoutCompare.gd")

const PHOTO := Vector2(96, 120)
const BAND_W := 170.0


static func make(main: Node, c: Career, f: Dictionary, o: Dictionary) -> PanelContainer:
	var opp: Dictionary = o["opp"]
	var unsafe := bool(o["mismatch"])
	var card := PanelContainer.new()
	card.name = "Offer_" + str(o["id"])
	card.theme_type_variation = "Card"
	var h := UI.hbox(16)
	card.add_child(h)
	var photo := PromoShot.picture(str(Faces.pair(f, opp)[1]), PHOTO)
	if photo != null:
		h.add_child(photo)
	var who := UI.vbox(2)
	who.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	who.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	who.add_child(UI.muted("%s's offer" % f["first"], UI.SMALL))
	who.add_child(UI.display(str(opp["name"]).to_upper(), 30))
	who.add_child(UI.label("%d-%d, %s, %s" % [opp["w"], opp["l"], opp["stance"], str(opp["style"]).to_lower()], UI.SMALL, UI.FG, "semi"))
	var why := "Not safe: %s has %d bouts, %s has %d" % [f["first"], int(o["own_bouts"]), str(opp["name"]).split(" ")[1], int(o["their_bouts"])]
	who.add_child(UI.label(why if unsafe else "%s, answer by %s" % [Clock.fmt(int(o["day"])), Clock.fmt(int(o["expires"]))],
		UI.SMALL, UI.RED if unsafe else UI.MUTED, "body", true))
	var chips := UI.hbox(6)
	for chip in BoutCompare.offer_chips(c, f, o):
		chips.add_child(chip)
	who.add_child(chips)
	h.add_child(who)
	h.add_child(_band(c, f, o))
	var open := UI.button("Open", "BtnSolid" if not unsafe else "Btn", main.act.bind("openBout", o["id"]))
	open.name = "Open_" + str(o["id"])
	open.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(open)
	return card


static func _band(c: Career, f: Dictionary, o: Dictionary) -> Control:
	var b := BoutRead.band(f, o["opp"], BoutRead.camp_for(f, int(o["day"]) - c.day), c.seed)
	var lo := roundi(float(b["lo"]) * 100.0)
	var hi := roundi(float(b["hi"]) * 100.0)
	var v := UI.vbox(0)
	v.custom_minimum_size = Vector2(BAND_W, 0)
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	v.add_child(UI.caps("WIN CHANCE"))
	v.add_child(UI.display("%d-%d%%" % [lo, hi], 34, UI.GREEN if lo >= 50 else (UI.RED if hi <= 50 else UI.FG)))
	return v

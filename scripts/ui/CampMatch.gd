extends RefCounted
## S381 C229 stage 3: the FIGHT CAMP modal's Partner card - who plays her opponent in sparring. Two states, a click
## switches: "Club mates - free" or "<Southpaw / Pressure / Sparring> mate - other club - $160" (BoutRules.partner_fee,
## the only camp cash). An ink picture on the left (tools/bake_partner_pics.gd: the southpaw mate is the shadow-jab card
## mirrored; a pressure / sparring mate jabs orthodox; club mates stand in the sparring guard), a green
## "MATCHES <HER>" tag when the mate copies the opponent's free stance or style, and the round-1 cost of an orthodox
## boxer who never faced a southpaw (BoutRules.never_faced, -0.6 in round 1 only; the mate takes it away, adds nothing).
##   partner_card(main, f, opp, on, h) -> Button "Partner"     picture(f, opp, on) -> Texture2D

const UI := preload("res://scripts/ui/UI.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CampCard := preload("res://scripts/ui/CampCard.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

const PIC_W := 108.0
## The bodies the partner is drawn on, by sex (never her own or her opponent's; tools/bake_partner_pics.gd bakes them).
const PARTNER_STEMS := {"f": ["mh_boxer_10", "mh_boxer_12", "mh_boxer_17"], "m": ["mh_boxer_01", "mh_boxer_03", "mh_boxer_07"]}


static func partner_card(main: Node, f: Dictionary, opp: Dictionary, on: bool, h: float) -> Button:
	var b := CampCard._shell("Partner", on, main.act.bind("cpartner", ""))
	b.custom_minimum_size = Vector2(0, h)
	var v := CampCard._fill(b, CampCard.INSET, CampCard.INSET)
	# S382 proof stills: the picture on the left, full height (on top it ran the words past the card's frame and cut her head)
	var hb := UI.hbox(10)
	hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(hb)
	var pic := TextureRect.new()
	pic.name = "Pic"
	pic.custom_minimum_size = Vector2(PIC_W, 0)
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	pic.texture = picture(f, opp, on)
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(pic)
	var w := UI.vbox(2)
	w.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	w.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hb.add_child(w)
	if on and BoutRules.partner_matches(opp):
		var tag := UI.chip("MATCHES THE OPPONENT", "green")   # S448: names in the header only
		tag.name = "Matches"
		tag.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		w.add_child(tag)
	var mate := BoutRules.partner_word(opp)
	var title := UI.label(mate.left(1).to_upper() + mate.substr(1) if on else "Club mates", 20, UI.FG, "bold", true)
	title.name = "Title"
	w.add_child(title)
	var line := UI.label("other club - %d visits - %s" % [BoutRules.PARTNER_VISITS, UI.money(BoutRules.partner_fee())] if on
		else "free (click: %s, %s)" % [mate, UI.money(BoutRules.partner_fee())], 15, UI.MUTED, "body", true)
	line.name = "Line"
	w.add_child(line)
	var risk := risk_line(f, opp, on)
	if risk != "":
		var r := UI.label(risk, 14, UI.GREEN if on else UI.AMBER, "body", true)
		r.name = "Risk"
		w.add_child(r)
	if on:
		b.add_child(CampCard._check(false))
	return b


## The round-1 line against a southpaw: the cost without a southpaw in her camp, its absence with the mate; "" otherwise.
static func risk_line(f: Dictionary, opp: Dictionary, on: bool) -> String:
	var stance := str(f.get("stance", "orthodox"))
	var lefty := bool((f.get("bout", {}) as Dictionary).get("lefty", false))
	if BoutRules.never_faced(stance, opp, {"partner": on}, lefty):
		return "'never faced a southpaw' -%.1f in round 1" % BoutRules.NEVER_FACED
	if on and BoutRules.never_faced(stance, opp, {"partner": false}, lefty):
		return "no 'never faced a southpaw' in round 1"
	return ""


## The mate on a body that is neither hers nor her opponent's: the mirrored jab for a southpaw mate, the orthodox jab for
## any other outside mate, the sparring guard for club mates.
static func picture(f: Dictionary, opp: Dictionary, on: bool) -> Texture2D:
	var kind := "sparring"
	if on:
		kind = "southpaw" if str(opp.get("stance", "")).to_lower() == "southpaw" else "shadow"
	var pair := Faces.pair(f, opp)
	var pool: Array = PARTNER_STEMS["m" if Faces.MEN_CM.has(str(pair[0])) else "f"]
	for s in pool:
		var path := "%s%s_%s.png" % [CampCard.PICS, s, kind]
		if not (s in pair) and ResourceLoader.exists(path):
			return load(path)
	return null

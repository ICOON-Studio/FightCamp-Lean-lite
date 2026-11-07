extends RefCounted
## S396 screen cut (docs/STRUCTURE_DESIGN_S395.md 5.4 navigation rule: "every name anywhere is a link"): a line of text where
## each name the game knows - our fighters and grapplers, the region's rivals - is underlined and opens her page or her file.
##   NameLinks.label(main, c, text, size, colour) -> RichTextLabel

const UI := preload("res://scripts/ui/UI.gd")


## [name, act, arg] for every person the career knows, longest names first (so "Ana Ribeiro" wins over "Ana").
static func people(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters:
		out.append([str(f["name"]), "fighter", str(f["id"])])
	for g in c.grapplers:
		out.append([str(g["name"]), "fighter", str(g["id"])])
	for r in c.rivals:
		out.append([str(r["name"]), "rivalfile", str(r["name"])])
	out.sort_custom(func(a, b): return str(a[0]).length() > str(b[0]).length())
	return out


## BBCode with each known full name wrapped as a link (meta "act|arg").
static func bbcode(c: Career, text: String) -> String:
	var out := text.replace("[", "[lb]")
	for p in people(c):
		var n := str(p[0])
		if n != "" and out.contains(n):
			out = out.replace(n, "[url=%s|%s][u]%s[/u][/url]" % [p[1], p[2], n])
	return out


static func label(main: Node, c: Career, text: String, size: int = UI.BODY, colour: Color = UI.FG) -> RichTextLabel:
	var r := RichTextLabel.new()
	r.bbcode_enabled = true
	r.fit_content = true
	r.scroll_active = false
	r.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r.add_theme_font_override("normal_font", UI.font("body"))
	r.add_theme_font_size_override("normal_font_size", size)
	r.add_theme_color_override("default_color", colour)
	r.text = bbcode(c, text)
	r.meta_clicked.connect(func(meta):
		var kv := str(meta).split("|")
		if kv.size() == 2:
			main.act(kv[0], kv[1]))
	return r

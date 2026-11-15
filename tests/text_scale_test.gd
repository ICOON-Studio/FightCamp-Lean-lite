extends SceneTree
## S491 ("whenyou change to large fonts everything breaks inthe scene going out of bound"): Text size grows the letters and
## keeps the 1920 x 1080 canvas. Red on the old code: Largest set content_scale_factor 1.3 (a 1477-wide canvas).

const Settings := preload("res://scripts/state/Settings.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")
const TV := preload("res://scripts/ui/TV.gd")

var failures := 0


func _initialize() -> void:
	await _run()
	print("TEXT_SCALE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _run() -> void:
	var d := Settings.read("user://text_scale_test.none")
	d["text"] = 3   # Largest
	Settings.apply(d, self)
	_check(is_equal_approx(root.content_scale_factor, 1.0), "the canvas is not zoomed (factor %.2f)" % root.content_scale_factor)
	_check(is_equal_approx(TextScale.factor(), 1.0), "a headless run stays at Medium whatever the file says (%.2f)" % TextScale.factor())
	TextScale.use(self, float(Settings.TEXT_SIZES[3][1]))   # what Largest does in a window
	_check(is_equal_approx(TextScale.factor(), 1.3), "Largest scales the letters 1.3 (%.2f)" % TextScale.factor())
	var box := Control.new()
	root.add_child(box)
	var l := Label.new()
	l.add_theme_font_size_override("font_size", 20)
	box.add_child(l)
	var b := Button.new()
	box.add_child(b)
	b.add_theme_font_size_override("font_size", 30)   # a builder that sets its size after add_child
	var r := RichTextLabel.new()
	r.add_theme_font_size_override("normal_font_size", 10)
	box.add_child(r)
	await process_frame
	_check(l.get_theme_font_size("font_size") == 26, "a 20 px label reads 26 px (%d)" % l.get_theme_font_size("font_size"))
	_check(b.get_theme_font_size("font_size") == 39, "a size set after add_child is scaled too (%d)" % b.get_theme_font_size("font_size"))
	_check(r.get_theme_font_size("normal_font_size") == 13, "rich text scales (%d)" % r.get_theme_font_size("normal_font_size"))
	var other := Control.new()
	root.add_child(other)
	box.remove_child(l)
	other.add_child(l)
	await process_frame
	await process_frame
	_check(l.get_theme_font_size("font_size") == 26, "a re-parented label is not scaled twice (%d)" % l.get_theme_font_size("font_size"))
	TextScale.use(self, float(Settings.TEXT_SIZES[1][1]))   # Medium: nothing touched
	var m := Label.new()
	m.add_theme_font_size_override("font_size", 20)
	root.add_child(m)
	await process_frame
	_check(m.get_theme_font_size("font_size") == 20, "Medium leaves a 20 px label at 20 (%d)" % m.get_theme_font_size("font_size"))
	_check(TextScale.scaled(22, 1.15) == 25, "Large: 22 px -> 25 px")
	var cut := TV.label("Draw the lead", 20, Color.WHITE, "bold")
	root.add_child(cut)
	var px := TextScale.fit(cut, 110.0, 20, 14)
	var wide := cut.get_theme_font("font").get_string_size(cut.text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
	_check(px < 20 and wide <= 110.0, "fit shrinks 'Draw the lead' into 110 px (%d px, %.0f wide)" % [px, wide])
	var long := TV.label("Hands up, move your head", 20, Color.WHITE, "bold")
	root.add_child(long)
	TextScale.fit(long, 60.0, 20, 14)
	_check(long.tooltip_text == long.text, "a line that cannot fit keeps its full text on hover")


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1

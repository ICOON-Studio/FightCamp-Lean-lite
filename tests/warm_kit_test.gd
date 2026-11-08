extends SceneTree
## WarmKit: every piece loads, and each nine-slice border and its padding fit inside the piece, so a screen never gets a
## broken frame. Prints WARM_KIT failures=<n>.

const WarmKit := preload("res://scripts/ui/WarmKit.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _initialize() -> void:
	for piece in ["wall", "board", "paper", "sticky", "chalk", "magnet", "tray"]:
		_check(WarmKit.tex(piece) != null, "loads " + piece)
	for piece in WarmKit.SLICE.keys():
		var t: Texture2D = WarmKit.tex(piece)
		if t == null:
			continue
		var s: StyleBoxTexture = WarmKit.box(piece)
		_check(s.texture == t, "box uses its texture " + piece)
		var shortest: float = minf(float(t.get_width()), float(t.get_height()))
		_check(s.texture_margin_left * 2.0 < shortest, "border fits " + piece)
		_check(s.content_margin_left < shortest / 2.0, "padding fits " + piece)
		_check(s.content_margin_left > 0.0, "content is padded " + piece)
	var nodes: Array = [WarmKit.wall(), WarmKit.panel("paper"), WarmKit.magnet(), WarmKit.tray()]
	for n in nodes:
		_check(n is Control, "builds a control")
		(n as Node).free()
	print("WARM_KIT failures=%d" % failures)
	quit(1 if failures > 0 else 0)

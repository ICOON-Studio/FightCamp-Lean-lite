extends SceneTree
## S533 STEPPAY2 phase 2: what PlaceEdge does to exchanges_test's even fight (tools/exchange_balance.gd, Lucy vs Data.OPPONENTS[1]
## at her own fight power, 2,000 bouts): win share saying nothing and with wrong calls, the rule off (the game before) and on.
## Usage: godot --headless --audio-driver Dummy --path . --script res://tools/place_edge_exch_probe.gd
const XB := preload("res://tools/exchange_balance.gd")
const PlaceEdge := preload("res://scripts/rules/PlaceEdge.gd")


func _initialize() -> void:
	for on in [false, true]:
		PlaceEdge.on = bool(on)
		var none := XB.share(0.0, "none", 1, null, {}, 2000)
		var wrong := XB.share(0.0, "wrong", 1, null, {}, 2000)
		print("PLACE_EXCH rule=%s none=%.4f wrong=%.4f gap=%.4f ratio=%.3f" % ["on" if bool(on) else "off", none, wrong, none - wrong, wrong / maxf(none, 0.0001)])
	PlaceEdge.on = true
	quit(0)

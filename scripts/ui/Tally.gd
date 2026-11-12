extends RefCounted
## S442 owner (animated numbers): a number, bar or graph that CHANGES in front of the player moves to its new value -
## 0.45 s, never blocking input, skipped by any click - and tints green (up) or red (down) for a moment. Only a value that
## just changed moves: the first time a key is shown (a screen opening) it is set at once. Screens rebuild on every
## action, so the last shown value is kept here by a stable key ("cash", "money:net", ...), not on the node.
##   Tally.number(label, key, value, fmt)   a counter that rolls through the values; fmt(int) -> String
##   Tally.bar(bar, key, frac)              a Bar / any control with `frac` that slides
##   Tally.skip_all()                       every running roll ends at its value (a click does it)
## No glow or particles here: those are for milestones only (ops/research/UX_AUDIT_S442.md, "Numbers that move").

const SECONDS := 0.45
const UP := Color("#2fb56e")
const DOWN := Color("#e2483d")

static var last: Dictionary = {}     # key -> the value the player last saw
static var _runs: Dictionary = {}    # key -> [tween, end Callable]
static var instant := DisplayServer.get_name() == "headless"


class Skipper extends Node:
	var on_click: Callable

	func _input(e: InputEvent) -> void:
		if e is InputEventMouseButton and (e as InputEventMouseButton).pressed:
			on_click.call()


static func number(l: Label, key: String, value: int, fmt: Callable) -> void:
	var had := last.has(key)
	var from := int(last.get(key, value))
	last[key] = value
	_end(key)
	l.text = str(fmt.call(value))
	if not had or from == value or instant:
		return
	l.text = str(fmt.call(from))
	_run(l, key, func(t: Tween):
		t.tween_method(func(v: float): l.text = str(fmt.call(roundi(v))), float(from), float(value), SECONDS) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT),
		func(): if is_instance_valid(l): l.text = str(fmt.call(value)), value > from)


static func bar(b: Control, key: String, frac: float) -> void:
	var had := last.has(key)
	var from := float(last.get(key, frac))
	last[key] = frac
	_end(key)
	b.set("frac", frac)
	if not had or is_equal_approx(from, frac) or instant:
		return
	b.set("frac", from)
	_run(b, key, func(t: Tween):
		t.tween_property(b, "frac", frac, SECONDS).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT),
		func(): if is_instance_valid(b): b.set("frac", frac), frac > from)


static func skip_all() -> void:
	for key in _runs.keys():
		_end(key)


static func running(key: String) -> bool:
	return _runs.has(key)


## Starts the roll once the node is in the tree (a rebuilt screen adds it a moment later); a tint fades back over it.
static func _run(n: Control, key: String, add: Callable, finish: Callable, up: bool) -> void:
	_runs[key] = [null, finish]
	var go := func():
		if not _runs.has(key) or not is_instance_valid(n):
			return
		_wire_skipper(n.get_tree())
		var t := n.create_tween().set_parallel(true)
		add.call(t)
		var was := n.modulate
		t.tween_property(n, "modulate", was, SECONDS).from(UP if up else DOWN)
		t.chain().tween_callback(func(): _runs.erase(key))
		_runs[key] = [t, func(): _restore(n, was, finish)]
	if n.is_inside_tree():
		go.call()
	else:
		n.tree_entered.connect(go, CONNECT_ONE_SHOT)


static func _end(key: String) -> void:
	if not _runs.has(key):
		return
	var r: Array = _runs[key]
	_runs.erase(key)
	if r[0] is Tween and (r[0] as Tween).is_valid():
		(r[0] as Tween).kill()
	(r[1] as Callable).call()


static func _wire_skipper(tree: SceneTree) -> void:
	if tree == null or tree.root.has_node("TallySkipper"):
		return
	var s := Skipper.new()
	s.name = "TallySkipper"
	s.on_click = skip_all
	tree.root.add_child.call_deferred(s)


static func _restore(n: Control, was: Color, finish: Callable) -> void:
	finish.call()
	if is_instance_valid(n):
		n.modulate = was

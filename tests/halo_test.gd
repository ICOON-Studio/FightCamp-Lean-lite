extends SceneTree
## S427 the shared outline (scripts/ui/Halo.gd; operator C273: "use proper outline effects throught all project not cheap
## solutions"): the chosen frame, the hover frame and the cut-out picture's line all come from Halo, never take a click,
## and the screens that mark "this one is chosen" use it instead of a flat border.

const Halo := preload("res://scripts/ui/Halo.gd")

var failures := 0


func _initialize() -> void:
	var host := Button.new()
	host.size = Vector2(300, 200)
	root.add_child(host)
	var ring := Halo.ring(host, Halo.GOLD, 12.0)
	_check(ring.get_parent() == host and ring.name == "Halo", "ring: a child of the host named Halo")
	_check(ring.mouse_filter == Control.MOUSE_FILTER_IGNORE, "ring: never takes a click")
	_check(ring.material is ShaderMaterial, "ring: drawn by the halo shader")
	_check(ring.visible and float(ring.get("power")) == 1.0, "ring: full strength and on show")
	_check(ring.offset_left == -Halo.MARGIN and ring.offset_bottom == Halo.MARGIN, "ring: glow room outside the host")
	await process_frame
	var m := ring.material as ShaderMaterial
	var px: Vector2 = m.get_shader_parameter("rect_px")
	_check(px.is_equal_approx(host.size + Vector2.ONE * Halo.MARGIN * 2.0), "ring: the shader knows its size %s" % px)
	_check(float(m.get_shader_parameter("radius_px")) == 12.0, "ring: the corner radius is passed on")

	var other := Button.new()
	other.size = Vector2(300, 200)
	root.add_child(other)
	var hov := Halo.hover(other)
	_check(hov.name == "HaloHover" and not hov.visible, "hover: dark until the mouse is over it")
	other.mouse_entered.emit()
	_check(hov.visible and float(hov.get("power")) > 0.3, "hover: lit under the mouse")
	other.mouse_exited.emit()
	_check(not hov.visible, "hover: dark again when the mouse leaves")

	# Inside a container (most cards are PanelContainers) the halo still reaches outside the card.
	var card := PanelContainer.new()
	card.size = Vector2(240, 120)
	root.add_child(card)
	card.add_child(Label.new())
	var cring := Halo.ring(card)
	await process_frame
	await process_frame
	_check(cring.position.is_equal_approx(-Vector2.ONE * Halo.MARGIN), "container: the halo starts outside the card %s" % cring.position)
	_check(cring.size.is_equal_approx(card.size + Vector2.ONE * Halo.MARGIN * 2.0), "container: and reaches round it %s" % cring.size)
	_check(card.size.is_equal_approx(Vector2(240, 120)), "container: the card keeps its own size %s" % card.size)

	var pic := TextureRect.new()
	root.add_child(pic)
	Halo.cutout(pic)
	_check(pic.material is ShaderMaterial, "cutout: the picture gets the figure line")

	# The screens that mark a chosen thing use Halo, and none of them paints a flat gold border for it any more.
	for path in ["res://scripts/ui/DuesBoards.gd", "res://scripts/fight3d/CornerBar.gd", "res://scripts/fight3d/NowPlate.gd",
			"res://scripts/ui/GuideLight.gd"]:
		var src := FileAccess.get_file_as_string(path)
		_check(src.contains("Halo.ring("), "%s marks the chosen thing with Halo.ring" % path.get_file())
		_check(not src.contains("border_color = GOLD") and not src.contains("border_color = WoodKit.HEAD"),
			"%s has no flat gold border" % path.get_file())
	print("HALO failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)

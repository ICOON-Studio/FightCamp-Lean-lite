extends RefCounted
## S498 ONELOOK1 round 2 - THE CONSISTENCY CHECK (operator on Q-S294-261: "i do not like the wooden panels , some pictures
## ahve some dont , how do you call this consistent ?"). Walks what is on screen and names every piece that breaks the
## one look. tests/one_look_test.gd runs it on every page of the test club and the fight HUD at Medium and Largest text;
## tools/onelook_stills.gd prints it beside each still. A fault is a line "<rule> <node path>: <what>".
## Rules:
##   picture   no panel or button is drawn from a picture (StyleBoxTexture) - no wood, no paper, no plaster.
##   card      a free-standing card (a panel of 280x120 px or more that is not inside another card) is THE panel:
##             WoodKit.is_panel (CARD, 1 px LINE edge, 6 px corners), or the top-bar strip (WoodKit.is_bar).
##   colour    anything inside a card, and every button, is filled with a palette colour (a see-through one counts) -
##             never the wood brown (WOOD, SECOND).
##   paper     no light-filled panel bigger than a tag (a paper card, a cream note, a cork board).
##   wall      the page sits on the one wall: the gym picture (or the bout page's own) at Palette.WALL_EXPOSURE, and
##             no other picture covers a third of the screen.

const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const CARD_MIN := Vector2(280, 120)
const WALLS := ["gym_backdrop.jpg", "versus_backdrop.jpg"]
const BIG_PICTURE := 0.33
const PAPER_MIN := Vector2(160, 60)
## Pictures that ARE the page's content, not a backdrop: the gym itself on Home.
const CONTENT := ["GymPicture"]


static func faults(root: Node, screen: Vector2 = Vector2(1920, 1080)) -> Array:
	var out: Array = []
	var pal: Array = Palette.all().values() + Palette.BELTS.values() + [Palette.BELT_BAR_RED, Palette.STRIPE_OFF]
	var brown := [Palette.WOOD, Palette.SECOND]
	_walk(root, false, out, pal, brown, screen)
	var wall := root.find_child("PaintedWall", true, false) as TextureRect
	if wall != null and wall.is_visible_in_tree():
		var path := str(wall.texture.resource_path) if wall.texture != null else ""
		if not WALLS.has(path.get_file()):
			out.append("wall %s: the page wall is %s" % [_where(wall, root), path.get_file()])
		if not wall.modulate.is_equal_approx(Palette.WALL_EXPOSURE):
			out.append("wall %s: exposure %s, not the house %s" % [_where(wall, root), wall.modulate, Palette.WALL_EXPOSURE])
	return out


static func _walk(n: Node, in_card: bool, out: Array, pal: Array, brown: Array, screen: Vector2) -> void:
	for ch in n.get_children():
		if ch is CanvasItem and not (ch as CanvasItem).is_visible_in_tree():
			continue
		if ch is CanvasLayer and not (ch as CanvasLayer).visible:
			continue
		var here := in_card
		if ch is Control:
			var c := ch as Control
			var boxed := c is PanelContainer or c is Panel   # S498: the HUD draws its plates on plain Panels
			var key := "panel" if boxed else ("normal" if c is Button else "")
			if key != "":
				var sb := c.get_theme_stylebox(key)
				if sb is StyleBoxTexture:
					var tex := (sb as StyleBoxTexture).texture
					out.append("picture %s: drawn from %s" % [_where(c), str(tex.resource_path).get_file() if tex != null else "a texture"])
				elif sb is StyleBoxFlat:
					var bg := (sb as StyleBoxFlat).bg_color
					var solid := bg.a >= 0.5
					var big := c.size.x >= CARD_MIN.x and c.size.y >= CARD_MIN.y
					if boxed and solid and bg.get_luminance() > 0.45 and c.size.x >= PAPER_MIN.x and c.size.y >= PAPER_MIN.y:
						out.append("paper %s: a light %s panel %dx%d" % [_where(c), bg.to_html(false), c.size.x, c.size.y])
					elif boxed and solid and big and not in_card:
						if not WoodKit.is_panel(sb) and not WoodKit.is_bar(sb):
							out.append("card %s: %s edge %s, not the house panel" % [_where(c), bg.to_html(false), (sb as StyleBoxFlat).border_color.to_html(false)])
						here = true
					elif bg.a > 0.05:
						if _is_one(bg, brown):
							out.append("colour %s: the wood brown %s" % [_where(c), bg.to_html(false)])
						elif not _is_one(bg, pal) and not (c is Button and WoodKit.is_plate(sb)):
							out.append("colour %s: %s is not a palette colour" % [_where(c), bg.to_html(false)])
					if boxed and solid:
						here = true
			elif c is TextureRect and c.name != "PaintedWall" and c.name != "PaintedPaper" and not CONTENT.has(str(c.name)):
				var r := c.get_global_rect()
				if r.size.x * r.size.y >= BIG_PICTURE * screen.x * screen.y and (c as TextureRect).texture != null:
					out.append("wall %s: a %dx%d picture behind the page (%s)" % [_where(c), r.size.x, r.size.y,
						str((c as TextureRect).texture.resource_path).get_file()])
		_walk(ch, here, out, pal, brown, screen)


static func _is_one(col: Color, list: Array) -> bool:
	for p in list:
		var t: Color = p
		if absf(t.r - col.r) < 0.012 and absf(t.g - col.g) < 0.012 and absf(t.b - col.b) < 0.012:
			return true
	return false


static func _where(c: Node, root: Node = null) -> String:
	var parts: Array = []
	var n := c
	while n != null and parts.size() < 4:
		parts.push_front(str(n.name))
		n = n.get_parent()
	return "/".join(parts)

extends RefCounted
## S412 operator: "the whole presentation reminds web browser not a game". A button is a plate with a lip under it;
## pressed, the lip goes, the word sinks and the plate gives a little. UI.gd builds every button style from this.


static func style(bg: Color, lip: Color, radius: int, pad_h: int, pad_v: int, lip_h: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.set_corner_radius_all(radius)
	s.content_margin_left = pad_h
	s.content_margin_right = pad_h
	s.content_margin_top = pad_v
	s.content_margin_bottom = pad_v
	s.anti_aliasing = true
	if bg.a > 0.0:
		s.border_color = lip
		s.border_width_bottom = lip_h
		s.content_margin_top = pad_v + (3 - lip_h)
		s.content_margin_bottom = maxi(0, pad_v - (3 - lip_h))
	return s


static func squash(b: Button, to: float) -> void:
	b.pivot_offset = b.size * 0.5
	b.create_tween().tween_property(b, "scale", Vector2.ONE * to, 0.06)

extends PanelContainer
## S384 GAMETREE1: a card of Ana's Playbook centre column that can carry a red dashed mark - all round (a leak tile, design
## 5.1) or in its top-right corner (a plan card whose miss is costly: the opponent owns the answer and the miss lands in a
## hole or hands over 2+ points, design 7). The panel itself is the stylebox the caller sets.

const DASH_RED := Color("#e2483d")

var dash := false     # the red dashed outline
var corner := false   # the red dashed top-right corner


func _draw() -> void:
	var w := 2.0
	if dash:
		var r := Rect2(Vector2(1, 1), size - Vector2(2, 2))
		for pair in [[r.position, Vector2(r.end.x, r.position.y)], [Vector2(r.end.x, r.position.y), r.end],
				[r.end, Vector2(r.position.x, r.end.y)], [Vector2(r.position.x, r.end.y), r.position]]:
			draw_dashed_line(pair[0], pair[1], DASH_RED, w, 7.0, true, true)
	if corner:
		var x := size.x - 6.0
		var y := 6.0
		draw_dashed_line(Vector2(x - 26.0, y), Vector2(x, y), DASH_RED, 2.5, 5.0, true, true)
		draw_dashed_line(Vector2(x, y), Vector2(x, y + 26.0), DASH_RED, 2.5, 5.0, true, true)

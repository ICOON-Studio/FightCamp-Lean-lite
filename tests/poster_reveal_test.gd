extends SceneTree
## S387 PosterReveal's cut: two neighbours share one edge path exactly (walked the other way), a tab sits on the side it was told to,
## an outer edge stays straight. Headless Accept opens no modal, so every test that books a bout keeps its flow.

const PosterReveal := preload("res://scripts/ui/modals/PosterReveal.gd")

var failures := 0


func _initialize() -> void:
	var a := Vector2(0, 100)
	var b := Vector2(105, 100)
	var n := Vector2(0, 1)
	var fwd := PosterReveal.edge(a, b, n, 100.0)
	var back := PosterReveal.edge(b, a, n, 100.0)
	_check(fwd.size() > 10, "a tabbed edge has its curve")
	_check(fwd.size() == back.size(), "both walks have the same points")
	var worst := 0.0
	for i in range(1, fwd.size()):
		worst = maxf(worst, fwd[i].distance_to(back[back.size() - i]))
	_check(worst < 0.01, "the two neighbours share the path (worst %.4f)" % worst)
	var far := 0.0
	for q in fwd:
		far = maxf(far, q.y - 100.0)
	_check(far > 20.0 and far < 45.0, "the tab stands out on its side (%.1f px)" % far)
	_check(PosterReveal.edge(a, b, Vector2.ZERO, 100.0).size() == 1, "an outer edge is straight")
	print("POSTER_REVEAL failures=%d" % failures)
	print("PASS poster_reveal_test" if failures == 0 else "FAIL poster_reveal_test")
	quit(failures)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)

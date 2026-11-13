extends SceneTree
## S447 CrowdFlashes: camera flashes on the crowd's seats. A burst fires all its flashes within BURST_SPREAD_S and every one is
## gone FLASH_S later; the idle rate over a minute sits near IDLE_PER_S; most flashes come from the near rows; the star texture
## is bright at the centre and empty at the corners; the real RingSet builds the flashes on its crowd.

const CF := preload("res://scripts/fight3d/CrowdFlashes.gd")
const RingSet := preload("res://scripts/fight3d/RingSet.gd")
const DT := 1.0 / 60.0

var failures := 0


func _initialize() -> void:
	_burst_fires_and_fades()
	_idle_rate()
	_near_share()
	_texture()
	_ring_has_flashes()
	print("CROWD_FLASHES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + what)


func _make(near_n: int = 20, far_n: int = 80) -> Node3D:
	var near: Array = []
	var all: Array = []
	for i in near_n:
		var p := Vector3(-3.0 + i * 0.3, 0.5, 6.0)
		near.append(p)
		all.append(p)
	for i in far_n:
		all.append(Vector3(-6.0 + i * 0.15, 2.5, 10.0))
	var f: Node3D = CF.new()
	root.add_child(f)
	f.setup(all, near, 11)
	return f


func _burst_fires_and_fades() -> void:
	var f := _make()
	f.set_process(false)
	f.burst(6)
	var t := 0.0
	var peak := 0
	while t < CF.BURST_SPREAD_S + 0.02:
		f.step(DT)
		peak = maxi(peak, f.active())
		t += DT
	_check(f.fired >= 6, "a burst of 6 fires all 6 within the spread (fired %d)" % f.fired)
	_check(peak >= 2, "a burst shows several flashes at once (peak %d)" % peak)
	var after := 0.0
	while after < CF.FLASH_S + 2.0 * DT:
		f.step(DT)
		after += DT
	# idle flashes may still start; none of the burst's may still show: anything active now started within FLASH_S
	_check(f.active() <= 2, "the burst is gone FLASH_S after its spread (active %d)" % f.active())
	print("  burst: fired %d, peak on screen %d" % [f.fired, peak])
	f.queue_free()


func _idle_rate() -> void:
	var f := _make()
	f.set_process(false)
	for i in 3600:
		f.step(DT)
	var lo := int(60.0 * CF.IDLE_PER_S * 0.6)
	var hi := int(60.0 * CF.IDLE_PER_S * 1.4)
	_check(f.fired >= lo and f.fired <= hi, "a quiet minute fires %d flashes (bar %d-%d)" % [f.fired, lo, hi])
	print("  idle minute: %d flashes" % f.fired)
	f.queue_free()


func _near_share() -> void:
	var f := _make(20, 80)
	f.set_process(false)
	var near_hits := 0
	var total := 0
	for i in 400:
		f.call("_fire")
		for x in f.get_children():
			var m := x as MeshInstance3D
			if m != null and m.visible:
				total += 1
				if m.position.z < 8.0:
					near_hits += 1
		f.step(CF.FLASH_S + 0.01)
	var share := float(near_hits) / maxf(1.0, float(total))
	# near rows hold 20 of 100 seats; NEAR_ROWS_SHARE sends most flashes there
	_check(share > 0.55, "most flashes come from the near rows (%.2f of %d)" % [share, total])
	print("  near-row share %.2f of %d" % [share, total])
	f.queue_free()


func _texture() -> void:
	var img := CF.star_texture().get_image()
	var c := img.get_width() / 2
	_check(img.get_pixel(c, c).a > 0.95, "the star's centre is full bright")
	_check(img.get_pixel(1, 1).a < 0.05, "the star's corner is empty")
	var d := int(c - c * 0.5 * 0.7071)
	_check(img.get_pixel(c, c / 2).a > img.get_pixel(d, d).a * 2.0, "half way out, the spike is brighter than the glow on the diagonal")


func _ring_has_flashes() -> void:
	var ring: Node3D = RingSet.new()
	root.add_child(ring)
	ring.build(5.5, 0.6)
	var fl: Node3D = ring.get("flashes")
	_check(fl != null, "RingSet builds CrowdFlashes")
	if fl != null:
		_check(fl.seats.size() > 200, "flashes sit on the real crowd's seats (%d)" % fl.seats.size())
		_check(fl.near.size() > 30 and fl.near.size() < fl.seats.size(), "the near rows are a part of the crowd (%d)" % fl.near.size())
	ring.queue_free()

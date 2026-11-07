extends Node
## S385 Round 1, ported S390: the sound effects manager. Static entry points from any script.
## NO autoload - finds or creates /root/Sfx. Manages buses, players, cooldowns.
## It runs through the tree's pause (KnockdownReplay freezes the ring; the crowd stays on) and keeps its own rng: a click must
## never move the global sequence the game's rolls read.

const SoundBank := preload("res://scripts/audio/SoundBank.gd")
const POOL_SIZE := 16
const LOOP_COUNT := 2
const BUS_DEFS := {"Music": -14.0, "SFX": -4.0, "Crowd": -12.0, "UI": -10.0, "Voice": -6.0}
const LIMIT_DB := -1.0        # SOUND_BENCHMARK R11: Master ends in a hard limiter at -1 dB
const DUCK_ATTACK_S := 0.02   # R7: attack 10-20 ms, release 0.4-0.8 s
const DUCK_RELEASE_S := 0.4

static var _node: Node = null
var played: Dictionary = {}   # id -> plays this run (tests and probes read it)
var _pool: Array = []
var _loop_players: Array = []
var _loops: Dictionary = {}
var _cooldowns: Dictionary = {}
var _ranks: Dictionary = {}   # pool player -> the priority of what it plays
var _ducks: Dictionary = {}   # bus -> its running duck tween
var _streams: Dictionary = {}
var _rng := RandomNumberGenerator.new()
var _buses_ready := false


static func ensure() -> Node:
	if _node != null and is_instance_valid(_node):
		return _node
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree == null:
		return null
	var n: Node = tree.root.get_node_or_null("Sfx")
	if n == null:
		n = new()
		n.name = "Sfx"
		n.process_mode = Node.PROCESS_MODE_ALWAYS
		tree.root.add_child(n)
		n._init_buses()
		n._init_pool()
	_node = n
	return n


## opts: "power" 0..1 (SoundBank.intensity), "delay" seconds. False when the id has no kept file or is cooling down.
static func play(id: String, opts: Dictionary = {}) -> bool:
	var n := ensure()
	if n == null:
		return false
	return n._do_play(id, opts)


static func loop(id: String) -> void:
	var n := ensure()
	if n == null:
		return
	n._do_loop(id)


## Never creates the manager: this runs from _exit_tree, at quit too.
static func stop(id: String, fade: float = 0.5) -> void:
	if _node != null and is_instance_valid(_node):
		_node._do_stop(id, fade)


## Drops a bus `db` under its mix level for `seconds`, then eases it back.
static func duck(bus_name: String, db: float, seconds: float) -> void:
	var n := ensure()
	if n == null:
		return
	n._do_duck(bus_name, db, seconds)


func _init_buses() -> void:
	if _buses_ready:
		return
	_buses_ready = true
	for bname in BUS_DEFS:
		_ensure_bus(bname, BUS_DEFS[bname])
	_ensure_bus("Room", 0.0)
	var room_idx := AudioServer.get_bus_index("Room")
	if room_idx >= 0 and AudioServer.get_bus_effect_count(room_idx) == 0:
		var rev := AudioEffectReverb.new()
		rev.room_size = 0.6
		rev.damping = 0.7
		rev.wet = 0.3
		rev.dry = 0.0
		AudioServer.add_bus_effect(room_idx, rev)
	if AudioServer.get_bus_effect_count(0) == 0:
		var limiter := AudioEffectHardLimiter.new()
		limiter.ceiling_db = LIMIT_DB
		AudioServer.add_bus_effect(0, limiter)


func _ensure_bus(bname: String, vol_db: float) -> void:
	if AudioServer.get_bus_index(bname) >= 0:
		return
	AudioServer.add_bus()
	var idx := AudioServer.bus_count - 1
	AudioServer.set_bus_name(idx, bname)
	AudioServer.set_bus_volume_db(idx, vol_db)
	AudioServer.set_bus_send(idx, "Master")


func _init_pool() -> void:
	_rng.randomize()
	for i in POOL_SIZE:
		var p := AudioStreamPlayer.new()
		p.name = "SfxPool_%d" % i
		add_child(p)
		_pool.append(p)
	for i in LOOP_COUNT:
		var p := AudioStreamPlayer.new()
		p.name = "Loop_%d" % i
		add_child(p)
		_loop_players.append(p)


func _do_play(id: String, opts: Dictionary) -> bool:
	if SoundBank.files(id).is_empty():
		return false
	var cd := SoundBank.cooldown(id)
	if cd > 0.0:
		var last: float = _cooldowns.get(id, -999.0)
		var now: float = Time.get_ticks_msec() / 1000.0
		if now - last < cd:
			return false
		_cooldowns[id] = now
	var delay: float = float(opts.get("delay", 0.0))
	if delay > 0.0 and is_inside_tree():
		get_tree().create_timer(delay).timeout.connect(_fire.bind(id, opts))
		return true
	_fire(id, opts)
	return true


func _fire(id: String, opts: Dictionary) -> void:
	var rank := SoundBank.priority(id)
	var player := _voice(rank)
	if player == null or not player.is_inside_tree():
		return
	var file_list := SoundBank.files(id)
	var intens := SoundBank.intensity(float(opts.get("power", SoundBank.NEUTRAL)))
	var spread := SoundBank.pitch(id)
	player.stream = _stream(str(file_list[_rng.randi() % file_list.size()]))
	player.bus = SoundBank.bus(id)
	player.volume_db = SoundBank.volume_db(id) + float(intens["volume_db"])
	player.pitch_scale = float(intens["pitch_scale"]) * (1.0 + _rng.randf_range(-spread, spread))
	player.play()
	_ranks[player] = rank
	played[id] = int(played.get(id, 0)) + 1


func _stream(path: String) -> AudioStream:
	if not _streams.has(path):
		_streams[path] = load(path)
	return _streams[path]


## A free voice, else the oldest voice of the lowest priority at or under `rank`; null when every voice outranks this sound.
func _voice(rank: int) -> AudioStreamPlayer:
	var pick: AudioStreamPlayer = null
	var pick_rank := rank + 1
	for p: AudioStreamPlayer in _pool:
		if not p.playing:
			return p
		var r: int = _ranks.get(p, 0)
		if r > rank:
			continue
		if r < pick_rank or (r == pick_rank and p.get_playback_position() > pick.get_playback_position()):
			pick = p
			pick_rank = r
	return pick


func _do_loop(id: String) -> void:
	if _loops.has(id):
		return
	var file_list := SoundBank.files(id)
	if file_list.is_empty():
		return
	var player: AudioStreamPlayer = null
	for p: AudioStreamPlayer in _loop_players:
		if not p.playing:
			player = p
			break
	if player == null or not player.is_inside_tree():
		return
	var stream := _stream(str(file_list[0]))
	if stream is AudioStreamOggVorbis:
		(stream as AudioStreamOggVorbis).loop = true   # the import says loop=false; the manifest's kind decides
	player.stream = stream
	player.bus = SoundBank.bus(id)
	player.volume_db = SoundBank.volume_db(id)
	player.pitch_scale = 1.0
	player.play()
	_loops[id] = player
	played[id] = int(played.get(id, 0)) + 1


func _do_stop(id: String, fade: float) -> void:
	if not _loops.has(id):
		return
	var player: AudioStreamPlayer = _loops[id]
	_loops.erase(id)
	if fade > 0.0 and is_inside_tree():
		var tw := create_tween()
		tw.tween_property(player, "volume_db", -40.0, fade)
		tw.tween_callback(player.stop)
	else:
		player.stop()


## The newest duck takes the bus over from where it stands, so overlapping ducks never strand it low.
func _do_duck(bus_name: String, db: float, seconds: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx < 0 or not is_inside_tree():
		return
	var running: Tween = _ducks.get(bus_name)
	if running != null:
		running.kill()
	var base: float = BUS_DEFS.get(bus_name, 0.0)
	var set_db := func(v: float) -> void: AudioServer.set_bus_volume_db(idx, v)
	var tw := create_tween()
	tw.tween_method(set_db, AudioServer.get_bus_volume_db(idx), base + db, DUCK_ATTACK_S)
	tw.tween_interval(seconds)
	tw.tween_method(set_db, base + db, base, DUCK_RELEASE_S)
	_ducks[bus_name] = tw


## S395: a sub-bass impact for the big-shot moment. Generates a short 55 Hz tone with a 0.3 s exponential decay.
## Engine.time_scale does not slow AudioStreamPlayer, so the heavier hit is a separate low layer under the punch.
static func sub_bass() -> void:
	var n := ensure()
	if n == null:
		return
	n._play_sub_bass()


func _play_sub_bass() -> void:
	var sr := 22050
	var dur := 0.3
	var n_samples := int(sr * dur)
	var data := PackedByteArray()
	data.resize(n_samples * 2)
	var freq := 55.0
	var tau := 0.12
	for i in n_samples:
		var t := float(i) / sr
		var env := exp(-t / tau)
		var sample := sin(TAU * freq * t) * env
		var val := int(clampf(sample, -1.0, 1.0) * 32767.0)
		data[i * 2] = val & 0xFF
		data[i * 2 + 1] = (val >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sr
	stream.stereo = false
	stream.data = data
	var player := AudioStreamPlayer.new()
	player.name = "SubBass_%d" % Engine.get_process_frames()
	player.stream = stream
	player.volume_db = -6.0
	player.bus = "SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

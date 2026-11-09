extends RefCounted
## S396 truth pass (P15, docs/STRUCTURE_DESIGN_S395.md rank 1): the player's settings, kept apart from the career on this
## machine (user://settings.cfg). Every option here works; an option that would do nothing is not offered.
##   Settings.read() -> {key: value}   Settings.write(d)   Settings.apply(d, tree)

const Sfx := preload("res://scripts/audio/Sfx.gd")

const PATH := "user://settings.cfg"
## Text size: the whole interface scales (Window.content_scale_factor).
const TEXT_SIZES := [["Small", 0.9], ["Medium", 1.0], ["Large", 1.15], ["Largest", 1.3]]
const WINDOWS := [["Windowed", "windowed"], ["Full screen", "fullscreen"]]
## S397 blind round 4 (speed buttons beside CONTINUE read as a second clock): how fast CONTINUE runs the days (Main.speed).
const CLOCK := [["Normal", 1], ["Fast", 2], ["Fastest", 3]]
## The sound buses a player sets, with the label shown.
const SOUND := [["Master", "Sound: all"], ["SFX", "Sound: punches, ring"], ["Crowd", "Sound: crowd"], ["Music", "Sound: music"]]
const DEFAULTS := {"text": 1, "window": 0, "vol_Master": 100, "vol_SFX": 90, "vol_Crowd": 70, "vol_Music": 80,
	"autosave": true, "clock": 1}


static func read(path: String = PATH) -> Dictionary:
	var d := DEFAULTS.duplicate()
	var cf := ConfigFile.new()
	if cf.load(path) == OK:
		for k in DEFAULTS:
			d[k] = cf.get_value("settings", k, DEFAULTS[k])
	d["text"] = clampi(int(d["text"]), 0, TEXT_SIZES.size() - 1)
	d["window"] = clampi(int(d["window"]), 0, WINDOWS.size() - 1)
	d["clock"] = clampi(int(d["clock"]), 0, CLOCK.size() - 1)
	for b in SOUND:
		d["vol_" + str(b[0])] = clampf(float(d["vol_" + str(b[0])]), 0.0, 100.0)
	return d


static func write(d: Dictionary, path: String = PATH) -> bool:
	var cf := ConfigFile.new()
	for k in DEFAULTS:
		cf.set_value("settings", k, d.get(k, DEFAULTS[k]))
	return cf.save(path) == OK


## Puts the settings on screen and in the speakers. `tree` null (a test) skips the window.
static func apply(d: Dictionary, tree: SceneTree) -> void:
	for b in SOUND:
		Sfx.set_user(str(b[0]), float(d["vol_" + str(b[0])]))
	if tree == null or tree.root == null:
		return
	tree.root.content_scale_factor = float(TEXT_SIZES[int(d["text"])][1])
	if DisplayServer.get_name() == "headless":
		return
	var full := str(WINDOWS[int(d["window"])][1]) == "fullscreen"
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if full else DisplayServer.WINDOW_MODE_WINDOWED)
	if not tree.root.has_meta("fit_pixels"):
		tree.root.set_meta("fit_pixels", true)
		tree.root.size_changed.connect(_fit_pixels.bind(tree.root))
	_fit_pixels(tree.root)


## S408 operator's close-ups: a 1080-line interface squeezed into a shorter window drew every letter soft (measured: same
## label at 0.93 scale against true size). A window a little under 1080 tall gets the interface at its true pixels.
static func _fit_pixels(root: Window) -> void:
	var want := root.size if root.size.y >= 900 and root.size.y < 1080 else Vector2i(1920, 1080)
	if root.content_scale_size != want:
		root.content_scale_size = want

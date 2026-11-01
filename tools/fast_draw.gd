extends RefCounted
## S334 cloud stills (.github/workflows/fight-stills.yml): a software GPU (Mesa llvmpipe on a GitHub runner) takes seconds
## to draw one 1080p frame, so an hour covered ~30 s of fight. Two ways to draw only what a tool saves:
## `-- fastdraw` stops drawing while the fight plays (clips, bones, modifiers and hits still run every frame); on llvmpipe
##   Vulkan the fight then sat at exactly 1 frame a second (a wait, not work), so the stills use the other way:
## `-- fastshrink` keeps drawing but renders every SubViewportContainer (the fight's 3D) at 1/SHRINK size without MSAA
##   between saves, full size for the saved frames.
## At a save the tree pauses, three frames draw (motion blur and TAA settle on a still pose), the image is taken, play goes on.
## Without either flag nothing changes.

const SHRINK := 8

static var _small := true
static var _msaa := {}   # SubViewport instance id -> its own MSAA, put back for a save


static func mode() -> String:
	var args := OS.get_cmdline_user_args()
	if args.has("fastshrink"):
		return "shrink"
	return "off" if args.has("fastdraw") else ""


static func on() -> bool:
	return mode() != ""


static func begin() -> void:
	if mode() == "off":
		RenderingServer.render_loop_enabled = false
	elif mode() == "shrink":
		var tree := Engine.get_main_loop() as SceneTree
		tree.process_frame.connect(func():
			if _small and tree.get_frame() % 15 == 0:
				_size(tree, true))


static func _size(tree: SceneTree, small: bool) -> void:
	for c in tree.root.find_children("*", "SubViewportContainer", true, false):
		(c as SubViewportContainer).stretch_shrink = SHRINK if small else 1
		for v in c.get_children():
			if v is SubViewport:
				var id: int = v.get_instance_id()
				if small and (v as SubViewport).msaa_3d != Viewport.MSAA_DISABLED:
					_msaa[id] = (v as SubViewport).msaa_3d
					(v as SubViewport).msaa_3d = Viewport.MSAA_DISABLED
				elif not small and _msaa.has(id):
					(v as SubViewport).msaa_3d = _msaa[id]


## The frame as drawn now (await it).
static func shot(tree: SceneTree) -> Image:
	if not on():
		await RenderingServer.frame_post_draw
		return tree.root.get_texture().get_image()
	tree.paused = true
	if mode() == "shrink":
		_small = false
		_size(tree, false)
	else:
		RenderingServer.render_loop_enabled = true
	for i in 3:
		await RenderingServer.frame_post_draw
	var img := tree.root.get_texture().get_image()
	if mode() == "shrink":
		_small = true
		_size(tree, true)
	else:
		RenderingServer.render_loop_enabled = false
	tree.paused = false
	return img

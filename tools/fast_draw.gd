extends RefCounted
## S334 cloud stills (.github/workflows/fight-stills.yml): a software GPU (Mesa llvmpipe on a GitHub runner) takes seconds
## to draw one 1080p frame, so an hour covered ~30 s of fight. `-- fastdraw` stops drawing while the fight plays (clips,
## bones, modifiers and hits still run every frame; the probes read bones, not pixels) and draws only the frames a tool
## saves: the tree pauses, three frames draw (motion blur and TAA settle on a still pose), the image is taken, play goes on.
## Without the flag nothing changes.


static func on() -> bool:
	return OS.get_cmdline_user_args().has("fastdraw")


static func begin() -> void:
	if on():
		RenderingServer.render_loop_enabled = false


## The frame as drawn now (await it).
static func shot(tree: SceneTree) -> Image:
	if not on():
		await RenderingServer.frame_post_draw
		return tree.root.get_texture().get_image()
	tree.paused = true
	RenderingServer.render_loop_enabled = true
	for i in 3:
		await RenderingServer.frame_post_draw
	var img := tree.root.get_texture().get_image()
	RenderingServer.render_loop_enabled = false
	tree.paused = false
	return img

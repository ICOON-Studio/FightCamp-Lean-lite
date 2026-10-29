## No class_name ON PURPOSE (S74): a global class is only known after an editor import
## rebuilds the untracked class cache, so every fresh worktree failed to compile its
## callers. Callers preload this script as a const.
extends RefCounted
## Raw model bytes that survive an export (S74).
##
## The fighters and clips are read through GLTFDocument/FBXDocument at runtime,
## not through their imported scenes. An export ships only the IMPORTED copy of
## a .glb/.fbx, so the raw file is not in the .pck. The playable build ships
## the raw files beside the executable under the same relative path
## (<exe dir>/assets/...), and this reads them from there when res:// has none.


static func _beside_exe(res_path: String) -> String:
	return OS.get_executable_path().get_base_dir().path_join(res_path.trim_prefix("res://"))


static func exists(res_path: String) -> bool:
	return FileAccess.file_exists(res_path) or FileAccess.file_exists(_beside_exe(res_path))


static func read(res_path: String) -> PackedByteArray:
	if FileAccess.file_exists(res_path):
		return FileAccess.get_file_as_bytes(res_path)
	return FileAccess.get_file_as_bytes(_beside_exe(res_path))

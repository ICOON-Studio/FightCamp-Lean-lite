# GDScript traps that cost a fix cycle (moved from CLAUDE.md s9, S213)

- `var x := <call>` fails when the call returns Variant - type it (`var n: int = ...`). `%` in a format string is `%%`.
- A variable name reused in one function is a parse error, even across blocks.
- `remove_child(node)` before `queue_free()` on UI rebuilds. A Label outside a Container: break lines with `\n`.
- Full-rect-anchored Controls: never assign `size` on mount. TextureRect: set `expand_mode`/`stretch_mode` BEFORE texture.
- Scene scripts compiled before autoloads use `get_node_or_null("/root/GameState")`, never the bare identifier.
- `callv` with the wrong arity returns `{}`, not null. Headless `get_bone_global_pose()` needs the skeleton updated.
- A Label that has already grown to its text never shrinks back: set `clip_text`/overrun BEFORE `size` (S213 STRESSHDR1).
- `get_theme_stylebox()` / any theme read on a Control not yet in the tree returns Godot's default (dark grey box), with no error. Copying it into an override paints every button dark (S407 Money). Do it in `b.ready.connect(func(): ..., CONNECT_ONE_SHOT)`. `WarmKit.panel` is safe: it sets its own override first.

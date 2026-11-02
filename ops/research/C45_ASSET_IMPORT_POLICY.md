# C45 asset import policy

## Decision

Commit Godot's `.import` sidecars for importable assets. Do not add a
`.gitignore` rule for them. The repository already contains 37 tracked
sidecars and `Godot/.gitignore` ignores only `.godot/`; committing the
generated sidecars keeps a clone and a clean checkout on the same imported
resource state, and prevents an asset from silently resolving to `null` until
someone happens to run the editor import step.

After adding new importable art, audio, or fonts, run the Godot import step,
review the generated text sidecars, and stage only the intended paths:

```text
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --import
git add -- Godot/assets/<owned-file>.import
```

Never use `git add -A` for this operation. `.godot/` remains local cache and
is still ignored.

## Audit on 2026-09-08

The asset tree contains 732 content files and 687 `.import` sidecars. The
import-producing types are complete: 8 JPG, 1 MP3, 343 PNG, 331 SVG, and 4
TTF files all have sidecars. Of the 687 sidecars, 37 are tracked and 650 were
untracked generated text files awaiting this decision.

The 45 content files without sidecars are expected non-import inputs:

| folder | missing sidecars | type breakdown |
| --- | ---: | --- |
| `assets/data` | 33 | JSON |
| `assets/fonts` | 1 | Markdown source note |
| `assets/icons` | 1 | Markdown credits |
| `assets/icons/flags` | 2 | JSON country data, license text |
| `assets/icons/lucide` | 1 | license text |
| `assets/shaders` | 2 | shader source and Godot UID metadata |
| `assets/ui` and icon subfolders | 3 | README files |
| `assets/videos` | 2 | OGV video and UID metadata |

JSON is read by `FileAccess`, shader source is loaded directly, and the OGV
video is used directly by the video player. None of those inputs should gain a
fabricated `.import` sidecar.

## Reference audit

The static audit covered 342 `.gd` and `.tscn` files. It found 61 unique
quoted `res://assets/...` strings: 56 resolved to files, 20 of those were
importable assets with valid sidecars, 36 were the expected JSON/docs/shader/
video inputs, four were runtime directories, and one was the deliberate
missing-portrait fixture in `generated_portrait_fallback_test.gd`.

The 20 exact importable references break down as audio 1, fonts 3, icons 1,
images 13, and UI 2. A literal search leaves 667 importable files without an
exact reference. That is not proof of dead art: `IconKit`, `TechniqueGlyphs`,
generated portraits, and other runtime builders select paths from directories
or IDs. No asset is deleted on the basis of this audit; those files remain
`UNKNOWN` unless a caller proves them unused.

`Godot/tools/check_asset_imports.py` checks production `.gd` and `.tscn`
sources for literal paths with import-producing extensions and reports a
missing file or missing sibling sidecar before the game is run. Tests can be
included explicitly with `--include-tests`; the existing missing-portrait
fixture is intentional and documents fallback behaviour.

## R143 - WHERE A LICENSED ASSET LIVES (operator ruling 2026-09-13: every asset available at any time)

- **Raw archive, once:** `AssetLibrary/<store>/<publisher>/<pack>_<storeid>.unitypackage` (or `.zip`).
  It sits outside `Godot/`, so it is never imported, and it goes through Git LFS.
- **Usable files:** animation packs go in `Godot/assets/anim/audition/<pack>/`; other third-party
  packs (environments, props, characters, UI) go in `Godot/assets/vendor/<pack>/`. Binaries go
  through LFS, and the `.import` sidecars are ordinary git, generated with the import pass above.
  Unity-only files (`.mat`, `.prefab`, `.unity`, `.controller`, `.cs`) are never copied in; the
  materials are rebuilt as Godot resources.
- **Registered before use:** add one entry to `Godot/assets/asset_manifest.json` with licence,
  restrictions and status (approved / candidate / placeholder / rejected).
  `tests/asset_manifest_test.gd` fails on an unclaimed asset folder, a vanished pack, or shipped
  code that references a pack that is not approved. Promote a pack to approved in the SAME commit
  that first binds it.
- **Exempt from LFS by design:** R122's `ramsterz/` and `ramsterz_h2h/` stay plain blobs.
  Converting them would rewrite history.

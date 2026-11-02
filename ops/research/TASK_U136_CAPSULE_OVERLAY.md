# U136 — DRAW THE CAPSULES ON THE FIGHTER, SO A HUMAN CAN SEE WHAT WE HAVE BEEN MEASURING

**Owner:** cursor (`composer-2.5`, MEDIUM, `-p --force --trust`).
**Worktree `FightCamp-U114`, cut a FRESH branch off `origin/master`.**
**Tier: parse gate on every touched `.gd`, then your own new test, then
`run_tests.py --only capsule_overlay` and `--only body`. NO FULL SUITE** — it is
Claude's, once, at integration.

## THE ASK, IN ONE LINE

**Put the capsule set on screen.** Twelve sessions have argued about capsule
radii, endpoint insets, spheres and "the neck reads 0.0%" **entirely in
numbers**, and the operator's two standing complaints — *"bodies overlap"* and
*"I see no difference"* — are both things you would see in one second with the
capsules drawn.

## WHAT EXISTS ALREADY, SO YOU DO NOT REBUILD IT

- `Godot/scripts/FighterCapsules.gd` — **~950 lines, do NOT open it whole.**
  `build(skel, height_scale) -> Array` returns `[{name, p0, p1, r}, ...]` in
  METRES. `build_report(skel, height_scale) -> Dictionary` returns the same
  under `"capsules"`, plus **`"shapes"`**, which is the thing this overlay
  colours by. Read `sed -n '265,300p'` for `build`/`build_report`'s signature
  and `grep -n 'static func' Godot/scripts/FighterCapsules.gd` for the rest.
  **You need `build_report`, `posed` and `SPHERES_ON_LOAD`, nothing else.**
- `Godot/scripts/CapsuleShape.gd` — small, read it whole. `shape(L, r)` returns
  one of `"SEGMENT"`, `"STOUT"`, `"NEEDLE"`, `"BALL"`.
- `FighterCapsules.posed(skel, rest_caps, height_scale, world)` moves the set
  onto the skeleton's **current pose** in world metres. **Read its doc comment
  before calling it** — it says explicitly that passing a real `world` transform
  AND a `height_scale` scales twice; pass `1.0` for the scale in that case.
- `Godot/scripts/FightBodyLayers.gd` and `FightStagePlayer.set_body_layers(on)`
  (`:492`) are the pattern for a togglable visual layer on a mounted fighter —
  copy that shape, do not invent a new one.
- `Godot/scripts/FightWorldLiveScreen.gd:296` holds `_body_layers` and
  `:588` reads it out of an `options` dictionary. **That is where your toggle
  goes and that is how it is switched from a tool.**

## WHAT TO BUILD

**`Godot/scripts/FightCapsuleOverlay.gd`** — a `Node3D` that takes a mounted
fighter and draws its capsule set as wireframe or translucent geometry, plus the
wiring to turn it on.

1. **One drawn volume per capsule**, in the fighter's own world space, following
   the **current pose** (via `posed`), not the rest pose. A capsule draws as a
   capsule; **a capsule whose `p0 == p1` draws as a SPHERE** — that is not an
   edge case, `FighterCapsules.SPHERES_ON_LOAD` promotes the head to exactly
   that on every build today.
2. **Coloured by band**, read from `build_report`'s `"shapes"` — never
   recomputed in the overlay, because a view that derives its own classification
   can disagree with the build it is drawing. Four bands: `SEGMENT`, `STOUT`,
   `NEEDLE`, `BALL`.
3. **Not colour alone.** Maria's M23/M24 discipline is standing law here: never
   hue-only. Each band must also differ in something a colourblind viewer reads
   — opacity, outline weight, a hatch, whatever you can do cheaply in 3D. **Two
   bands that differ only in hue is a rejected delivery.**
4. **A toggle**, in the same shape as `body_layers`: an `options` key
   `capsule_overlay`, default **OFF**, threaded through
   `FightWorldLiveScreen` to the stage player the way `_body_layers` already is.
   **Default OFF** — this is a debug view, not a feature.
5. **A per-capsule name label is OPTIONAL and must be separately switchable.**
   Fifteen labels on one body is unreadable; if you add them, they are their own
   flag.

## THE GATE — AND IT ASSERTS THE QUANTITY A VIEWER SEES

A new test `Godot/tests/capsule_overlay_test.gd`. **A test that only checks the
node exists is not a gate.** Assert, headless:

1. The overlay produces **one drawn child per capsule in the set**, and the count
   equals `build_report(...)["capsules"].size()` — read, never hardcoded.
2. **A promoted sphere is drawn as a sphere.** Find the capsule whose
   `p0 == p1` and assert its drawn node is the sphere form, not a zero-length
   capsule. **If `SPHERES_ON_LOAD` is ever emptied this assertion must go red
   rather than silently pass**, so derive which capsule to check from the data
   and `push_error` if none is a sphere.
3. **Each drawn volume's world position matches its capsule's own midpoint to
   within 1 mm.** This is the assertion that catches the real bug: a
   full-rect/scale mistake puts the geometry at the origin or at twice the size
   and a "does it exist" test never notices.
4. **The four bands produce four distinguishable appearances** — assert the
   non-hue property differs between at least two band pairs, so rule 3 above is
   enforced by the test and not only by the brief.
5. **Toggled off, nothing is drawn.** Zero children.

## TRAPS, EACH OF WHICH HAS COST A PASS ON THIS PROJECT

- **A Control with full-rect anchors must never have `size` assigned** when
  mounted — with anchors at 0..1 that writes the OFFSETS and the node ends up
  twice its parent (R31). Not your 3D nodes, but it bites any 2D label layer you
  add.
- **`remove_child(node)` before `queue_free()`** on any rebuild, or new nodes get
  renamed and your count assertion drifts.
- **Scene scripts compile before the autoloads.** Use
  `get_node_or_null("/root/GameState")` plus `has_method`, **never the bare
  `GameState` identifier** — a bare autoload identifier in a scene script is a
  compile error.
- **A freshly retargeted clip names its tracks with a BARE bone name**
  (`get_subname_count() == 0`). Irrelevant if you only read poses, but if you
  advance an animation to get a pose, you will meet it.
- **`var x := <call>` fails when the call returns Variant** — write the type.
  **`%` in a format string must be `%%`.** **Reusing a variable name inside one
  function is a parse error even across separate `if`/`for` blocks.**
- **A parse error HANGS a headless test for 600 s instead of failing it.** Parse
  gate first, always.
- **Your test must not print the runner's failure vocabulary on purpose.**
  `run_tests.py` reads the log for any line starting `FAIL`/`FAILED`, any
  `failures=N` with `N > 0`, any `N failure(s)` — and condemns the test for it
  even while it exits 0. Use `checks_failed=` for any deliberate diagnostic.

## Owned files

- `Godot/scripts/FightCapsuleOverlay.gd` (new)
- `Godot/tests/capsule_overlay_test.gd` (new)
- `Godot/scripts/FightWorldLiveScreen.gd` (the option key and the thread-through
  ONLY — keep the diff to the `_body_layers` pattern)
- `Godot/scripts/FightStagePlayer.gd` (the setter, mirroring `set_body_layers`)
- `research/U136_DIGEST.md`

**You own NOTHING else.** Do **not** edit `FighterCapsules.gd`,
`CapsuleShape.gd`, `ApproachBand.gd` or any probe under `Godot/tools/`.

## Read these and nothing else

`research/S53_THE_BALL_CAPSULE.md` (why the head is a sphere),
`Godot/scripts/CapsuleShape.gd`, the named line ranges of `FighterCapsules.gd`,
and `FightBodyLayers.gd` as the pattern. Do **NOT** read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any other digest, and do not
explore to "get oriented".

`RESEARCH_INDEX.md` is 789 documents and 220 tools, one line each — **GREP IT,
NEVER READ IT WHOLE** (214 KB). Worth running: `grep -i 'overlay' RESEARCH_INDEX.md`,
`grep -i 'capsule' RESEARCH_INDEX.md`. **A negative result is a result.**

## Rules

- **DO NOT fetch and DO NOT rebase** — the checkout is current.
- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only, and `git show --stat HEAD` after.
- Commit after each step — an honest partial beats an uncommitted whole.
- Push your branch, write the digest, send one line with
  `python Tools/agent_comms.py send`. **Do NOT edit `HANDOFF.md`.**
  **Your mail rides your branch, so say the branch name in the message.**

## And then argue against it

End the digest with the strongest case that this overlay is **the wrong way to
see the problem** — that a wireframe of fifteen volumes on a moving body is
unreadable at speed and a single still frame with two bodies would have said
more. Say what you would build instead. **Name your own weakest point
unprompted.**

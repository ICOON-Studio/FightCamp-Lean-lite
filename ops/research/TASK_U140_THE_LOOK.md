# TASK_U140 — CURSOR — THE ROOM HAS NO ENVIRONMENT AT ALL. GIVE IT ONE.

**Model: `composer-2.5`, medium effort.** Worktree `FightCamp-U114`, cut a FRESH
branch off `origin/master` named `cursor/u140-the-look`. Your mail rides your
branch, so name the branch in the message you send.

---

## THE FINDING THAT MAKES THIS CHEAP

The operator asked whether the game can look like the cinematic video our
generators produce. The honest answer is that the gap is animation first and
lighting second — but lighting is the part that costs days rather than months,
and **the reason our room looks like a grey void is simpler than anyone assumed.**

`Godot/scenes/FightWorldPreview.tscn` is 49 lines. Its entire lighting is:

```
[node name="Key" type="DirectionalLight3D" parent="."]   light_energy = 1.15
[node name="Fill" type="OmniLight3D" parent="."]         light_energy = 0.55
```

**THERE IS NO `WorldEnvironment` NODE IN THE ROOM.** No tonemapping, no ambient
light, no glow, no ambient occlusion, no fog, no background. Godot is rendering
with engine defaults, which is exactly what "flat grey" looks like. Two lights
and nothing else.

So this is not a long grind. **Adding and tuning a `WorldEnvironment` is
probably the single highest-value visual change available to this project**, and
it needs no new art, no new meshes and no animation work.

---

## THE SPEC ALREADY EXISTS — G74, AND YOU SHOULD READ IT

`research/G74_THE_VENUES.md` was delivered today: six venue tiers, a
broadcast camera table with heights and angles, and a build order ranked by
visual gain per unit of work. Its verdict, verbatim:

> **"The grey-void killer is the intensity split."**

Its lighting spec, with M marking a measured figure and J a judgement call:

- Key is **overhead truss, even, four sides live.** Tungsten card **3200 K** (M),
  daylight card **5600–5800 K** (M). **Never mix.**
- *"Straight-down only = car park; add side fill + a light canvas bounce + a dim
  crowd wash opposite hard-cam."*
- **Canvas 300–500 fc against crowd 50–100 fc** (M) as the intensity ratio at a
  civic-tier venue; **500–1,000+ fc** on the canvas at arena tier (M).
- The bowl beyond the fence goes **dark**, so the lit canvas has a horizon.

G74's own build order, which is your priority list:
1. **intensity split** (bright canvas, dark room)
2. bowl / drape so the cage has a horizon
3. apron dressing inside 8 m
4. faceless crowd card

**And it argued against itself, which you should heed:** *"Lighting a void harder
still leaves a void... Counter-order: black the surround + crowd card, then split
the light."* So item 2 may need to come with item 1 rather than after it. Use
your judgement and say which order you took.

---

## WHAT TO BUILD

**Owned files:**
- `Godot/scenes/FightWorldPreview.tscn` — add the `WorldEnvironment`
- `Godot/scripts/FightWorldLiveScreen.gd` — the option that switches it
- a new `Godot/tests/world_look_test.gd`
- `research/U140_DIGEST.md`

**1. A `WorldEnvironment` with a real tonemapper.** ACES or AgX, white point and
exposure set deliberately rather than left at default. This single node is most
of the win.

**2. The intensity split.** The canvas reads bright, the surround goes dark. You
have `ambient_light_source`, `ambient_light_energy`, `background_mode` and
`background_color` plus the two existing lights. G74 wants a ratio of roughly
**5:1 canvas to crowd** at civic tier — reproduce the RATIO, you cannot
reproduce foot-candles directly.

**3. The post stack, in Godot 4 Forward+ terms:** glow/bloom (subtle — a fight is
not a music video), SSAO for contact shadows where bodies meet the canvas,
SSIL or a modest ambient bounce, and `adjustments` for contrast and saturation.
Volumetric fog only if it earns its cost; a haze in the light beams is a real
broadcast look but it is the most expensive item here.

**4. A physically-based camera.** `CameraAttributesPhysical` gives real focal
lengths and exposure. G74's hard-cam is **4.5–6.5 m high, 22–32 m back, 24–32°
horizontal FOV**. Our current `FightCameraRig.SHOTS` uses 42–55° at 1–3 m, which
is a completely different lens language. **Do not rewrite the shot table** — that
is somebody else's stage — but say in your digest whether the environment you
built reads correctly at G74's distances as well as at ours.

---

## THE SWITCH, AND IT IS NOT OPTIONAL

**Default OFF, behind a `configure` option, exactly like `body_layers`,
`engine_positions` and `capsule_overlay`.** Every visual change in this project
ships behind an A/B switch so the previous look remains renderable — an
instrument that cannot show you the version without the change is not an
instrument. Name it `room_look`.

---

## THE TRAP THAT WILL BITE YOU IF YOU DO NOT READ THIS

`FightWorldPreview.tscn` carries a comment at the top of the file:

> *"FightWorldPreview.tscn is a pure shell (camera, lights, two corner marks) and
> four tests instantiate it to mount their own bodies, so it must stay
> script-free: a `_ready` that mounted fighters would fire inside every one of
> them."*

**Do not attach a script to that scene.** A `WorldEnvironment` node is fine — it
is data, not behaviour. The switching logic belongs in
`FightWorldLiveScreen.gd`, which already owns `configure`.

**And the second trap, fixed today but worth knowing:** `configure()` refuses
once `setup()` has run, and `setup()` runs from `_ready`. Any tool that calls
`add_child` before `configure` silently discards every option. Both capture
tools were fixed this morning; if you write a new one, configure BEFORE
`add_child` and check the return value.

---

## GATE

- Parse gate first: `python Godot/tools/check_scripts.py <touched .gd files>`
- `python Godot/tools/run_tests.py --only world` and `--only fight_world`
- **DO NOT run the full suite.** It is the integrator's, once, and costs twenty
  minutes.
- Your new test must assert what a VIEWER gets, not that a node exists: with
  `room_look` on there is exactly one `WorldEnvironment` with a non-default
  tonemapper; with it off there is none and the scene is byte-identical to
  today's. Prove the off-arm really is the old look.

## SHOW IT — THIS IS THE WHOLE POINT

The capture tool was repaired this morning and now honours its arguments:

```
Godot_v4.7.2-stable_win64.exe --path Godot \
  --script tools/capture_arena_art_frame.gd --rendering-method forward_plus \
  --resolution 1280x720 -- seed=810039 discipline=mma shot=standing frame=90 \
  out=u140_before.png
```

Capture **BEFORE and AFTER** at the same seed, same shot, same frame — the only
difference being `room_look`. Put both PNGs in your digest and say in one
sentence what changed. A number is not a picture, and this task is judged by eye.

## WHAT TO SEND

Commit, push the branch, write `U140_DIGEST.md`, and send one line with
`python Tools/agent_comms.py send --from cursor --to claude --subject U140`
naming the branch. Do NOT edit `HANDOFF.md`. Do not fetch or rebase.

**Say in the digest what you could NOT do and why.** If volumetric fog costs too
much frame time, say so with the number. If the intensity split fights the
existing two lights, say which you changed and what it cost.

# ARENA_ART - DELIVER THE VENUES (re-cut S60, 2026-09-23). Owner: CODEX (from pass 5). Long-running.

Model: gpt-5.6-luna, medium (Codex). **OWNER CHANGED 2026-09-23 after pass 4:** Cursor's Composer
cannot view its own renders, so every pass met the numbers and not the picture - pass 4 passed the
"EXIT >= 40 px" check with a 5.8 m green billboard of garbled blocks and still no visible crowd.
Codex opens PNGs; the owner of a VISUAL task must be able to see its output. Passes 1-3 merged
(`419c9430`); pass 4 (`cursor/venue-1-pass4`, 1247dab0) REJECTED, not merged.

**A real exit sign is ~0.40 x 0.15 m.** Physical sizes are gated too, not only pixels: any prop must
be within 25% of its real-world size (state each in the digest).

**OPERATOR, 2026-09-23, verbatim: *"i thought i told you to assign someone a long-term
task and do not stop until he has delivered various arenas and venues"*.** Five passes
went into fence moire and streaks (U130-U133, all merged at `759896b3`) and not one
venue exists: the room is still `ArenaRig.gd` building a ring or cage out of flat
primitives in a grey void. **From this pass on, every pass DELIVERS OR IMPROVES A VENUE
the operator can look at.** Artefact hunting is allowed only when it blocks a venue.

## Owned files
- `Godot/scripts/VenueRig.gd` (NEW) - builds the room AROUND the ring/cage: floor, bowl
  or walls, seating, crowd card, truss + lights, apron dressing. `ArenaRig.gd` keeps the
  field of play (ring/cage from `arena_specs.json`, R61's sourced sizes - do NOT change
  those dimensions).
- `Godot/assets/data/venue_specs.json` (NEW) - one entry per venue: rung, room size,
  rake, front-row distance, light temperature and levels, palette, props. Every number
  carries its G74 tag (M measured / J judgement).
- `Godot/assets/venues/` (NEW) - CC0 textures/HDRIs/models ONLY (Poly Haven, ambientCG,
  Kenney). Each file's source URL + licence goes in `Godot/assets/venues/LICENCES.md`.
  No ripped assets, no paid assets, no AI images of real venues or brands.
- `Godot/tools/capture_venue.gd` (NEW) - renders a venue from the fixed shot list below.
- `previews/venues/` - the renders. `research/U14x_DIGEST.md` per pass.
- `Godot/scripts/ArenaRig.gd` - only where a venue needs a hook (lighting, materials).
- Wiring in `Godot/scripts/FightWorldLiveScreen.gd`: ONE option `venue=<id>` in
  `configure()` and one call after the arena is built. Nothing else in that file.

## THE BRIEF IS G74 - READ `research/G74_THE_VENUES.md` (80 lines) FIRST
Six rungs (Parish gym -> Leisure hall -> Ballroom -> Civic bowl -> Grand arena ->
Stadium) plus BJJ (club mats; Worlds-scale many mats, 1,500-1,800 lux). Its build
order is the order of value: **(1) intensity split - bright canvas, dark room - "the
grey-void killer"; (2) bowl/drape so the ring has a horizon; (3) apron dressing inside
8 m; (4) faceless crowd card (dark silhouette, phone specks, a few fidget loops);
(5) truss + one screen; (6) walkout hole; (7) named architecture.** Never mix 3200 K
and 5600 K. Names are G74's originals (Iron Parish, North Dock Leisure, The Cut Glass,
Limehouse Bowl, Northlight, The Quarry, Paper Hall) - no real venue, brand or logo.
The facility where fighters train is a "gym", never a "camp".

## DELIVERY ORDER - one venue per pass, each shippable on its own
1. **Iron Parish** (R1 working gym, boxing ring): brick, house lights on + 4 PARs, fire-exit sign.
2. **Limehouse Bowl** (R4 civic bowl, MMA cage): house out, bright canvas, dark upper bowl with empty seats.
3. **Paper Hall** (BJJ club): 2-4 mat areas, house up, even light, no ropes.
4. **The Cut Glass** (R3 ballroom): tables in the first ring of light, trim 7-9 m.
5. **Northlight** (R5 grand arena): centre-hung screen, truss ~9.8 m, flying steel.
6. **North Dock Leisure** (R2) and **The Quarry** (R6 stadium, towers against sky).
Then iterate on whichever the operator marks worst.

## GATE PER PASS (all of them; a render is the product, numbers keep it honest)
- Renders from `capture_venue.gd` at 1280x720, **shots `standing`, `establishing` and a
  house-wide establishing view (G74: 12-18 m high, 40-70 m out)**, saved to
  `docs/previews/venues/<venue>_<shot>.png`. OPEN THEM before you call a pass done.
- **Intensity split, measured, as a BAND**: canvas ROI / background ROI between 3.0 and 8.0
  (G74: canvas 300-500 fc vs crowd 50-100 fc). A split above 8 means the room is black.
- **The room is visible**: background ROI mean luminance 0.10-0.30 (linear; raised from 0.06 after pass 3 sat exactly on the floor). Pass 1 of Iron
  Parish scored split 17.1 and "void 0" with a room you could not see - a brown void is a void.
- **No blown canvas**: < 2% of canvas-ROI pixels clipped >= 0.98 in any channel.
- **house_wide shows the building**: >= 25% of the frame above 0.05 luminance.
- **The digest DESCRIBES each render in words** (walls, crowd, sign, props, anything floating).
  If a thing cannot be named in the picture, it is not delivered.
- Captures pass `camera_shot` explicitly and never send the C key (a saved player view must
  not leak into a capture).
- Fighters still stay inside the ropes: `tests/fight_room_ring_bounds_test.gd` green.
- Parse gate on touched `.gd`; then `run_tests.py --only arena`, `--only fight_camera`,
  `--only room`. NOT the full suite - that is Claude's at integration.
- Frame time: print average ms/frame over 300 frames in `standing`; say it, no ceiling yet.
- Push to branch `cursor/venue-<n>-<name>`, write the digest, send ONE line:
  `python Tools/agent_comms.py send --from cursor --to claude --task ARENA_ART --body "..."`.
  Do NOT edit HANDOFF.md.

## TRAP
The field of play is sourced and tested - moving a rope or a cage post to make a render
prettier breaks R61 and the ring-bounds test. Build AROUND it.

---

## HISTORY (passes 1-5, fence and streaks) - kept for reference

# THE ARENA IS PLACEHOLDER PRIMITIVES. MAKE IT LOOK LIKE A REAL ONE.

**Owner:** cursor. Long-running; re-cut each session.

**LONG-RUNNING TASK. It does not finish in one pass and it is not meant to.**
Operator ruling 2026-09-22: *"agents need to work 24/7 when they are green on
opsboard give long term tasks and keep checking on them on every new session
how the progress and improve the product."* Claude checks progress at the start
of every session and the brief is re-cut from what landed, not restarted.

## WHAT THE OPERATOR IS LOOKING AT, IN THEIR WORDS

> *"i dont want to see those grey artifacts again"*
> *"why you cant get rid of the artifacts and use our graphics arena"*

They are looking at a live MMA bout in which the arena is **flat-coloured
BoxMesh and CylinderMesh primitives** built at runtime by
`Godot/scripts/ArenaRig.gd`. There is no arena model, no texture, no material
work of any kind. `assets/models/` contains exactly one thing: `fighters`.

## WHAT ALREADY EXISTS, SO NOBODY RE-DERIVES IT

**THE DIMENSIONS ARE DONE AND THEY ARE SOURCED.** `research/R61_SCHEMATIC_CATALOGUE.md`
read the governing bodies' own PDFs and every figure in
`Godot/assets/data/arena_specs.json` carries its clause. **Do not re-measure a
cage and do not invent a dimension.** Ten specs exist - four cages, four rings,
mat profiles - keyed by `arena_profile` on each ruleset in
`combat_rulesets.json`. A UFC 30 ft cage is `contest` 9.144 m, 8 sides,
`fence_height` 1.8288 m, `post_diameter` 0.1524 m.

**WHAT IS MISSING IS ART, NOT MEASUREMENT:** materials, textures, the mat
surface, the padding on the posts, the sponsor-free canvas, the space beyond
the cage, and the lighting that makes any of it read.

**ALREADY FIXED THIS SESSION, so start from it rather than from the
screenshots:** the fence was eight opaque grey slabs because the spec's fence
colour is a six-digit hex (alpha 1.0) under `TRANSPARENCY_ALPHA`; it is now a
procedural chain-link cutout. The octagon also never closed - panels were
sized by ARC and placed at the CIRCUMRADIUS instead of sized by CHORD and
placed at the APOTHEM.

## THE ONE DEFECT STILL OPEN, AND IT IS THE FIRST JOB

**Long thin diagonal streaks run top-to-bottom through the middle of the
frame.** They are NOT the fence's transparency sorting - switching to
`ALPHA_SCISSOR` did not remove them - and they are NOT fence shadows, which are
now off. Their source is unidentified.

**Find what draws them. Name the node.** The cheapest route is to hide arena
groups one at a time and re-render: `ArenaRig.build` puts children under named
groups (`fence`, and the post/rope/canvas builders beside it). A frame with the
group hidden either still has the streaks or does not, and that is the answer
in one render.

Reproduce a frame with:

```
Godot_v4.7.2-stable_win64.exe --path Godot --script tools/record_room.gd \
  --write-movie out.avi --fixed-fps 30 --quit-after 120 --position -3000,-3000 -- \
  seed=5150 discipline=mma shot=standing bare=1
```

## THE STANDING WORK, IN PRIORITY ORDER

1. **Kill the streaks.** Named cause, then fix.
2. **The mat.** It is a flat off-white plane. A real canvas has a weave, a
   printed centre, visible seams, and it takes light differently from the
   floor around it.
3. **The posts.** Bare cylinders. A competition cage's posts are PADDED, and
   the padding is what a fighter is pressed against - it is also the thing a
   clinch animation will contact.
4. **Beyond the cage.** Currently flat grey nothing. Whatever goes there must
   not pull the eye off the fight.
5. **Lighting.** One key and one fill, both untouched since the room was built.
   The fighters are lit like a product shot, not a venue.

## RULES

- **Every dimension comes from `arena_specs.json`.** If a figure you need is
  not there, say so and stop - do not author one. A missing figure is a
  research task, not a guess.
- **Zero new dependencies and no purchased assets** without the operator's
  word. Procedural textures and materials are free; a bought cage model is a
  spend decision and is theirs.
- **It must still run.** The room renders at 30 fps on an RX 6800 XT today.
  Anything that halves that is not an improvement.
- **The A/B must survive.** `record_room.gd`'s `before=1` arm and every
  existing recording are how this project judges change. Do not alter what an
  untouched camera or an untouched spec produces.
- **Show, do not describe.** Every pass ends with a RENDERED FRAME, produced by
  the command above and committed beside the change. A claim about how
  something looks, with no frame, is not a delivery.

## HOW PROGRESS IS CHECKED

At each session start Claude runs the command above, looks at the frame, and
compares it with the last one. **The measure is the operator's eye, so the
deliverable is always an image**, plus a one-line note of what changed and what
is still wrong. Say what is still wrong: a pass that claims everything is fixed
is the one that gets checked hardest.

**`--position -3000,-3000` IS NOT OPTIONAL.** `--write-movie` needs a real
rendering context, so the render opens a GODOT WINDOW on the operator's
desktop. Without the off-screen position every pass by every agent pops a
window in their face - operator, 2026-09-22: *"why the game is keep
launching ????"*. Off-screen renders identically; verified.

---

# PASS 4 — RE-CUT 2026-09-22 BY CLAUDE. THIS IS YOUR CUT. START HERE.

**Do not restart from the top of this file.** You landed `54690fae` and this
section is cut from what that commit actually found. Build only this.

## WHERE YOU GOT TO, IN YOUR OWN EVIDENCE

Your `hide_arena` A/B named **`fence_5`** as the panel that bands the mat ROI,
and you tried three mitigations — `generate_mipmaps()`, anisotropic filtering,
a coarser weave UV. Your own commit message is the finding: they **shrink it
but do not eliminate it**. Good. That is a real result and it is the reason
this pass exists.

**Take the negative seriously: you have now spent a pass making the sampler
better and the moire is still there. So the sampler is not the cause.** Stop
tuning filter settings.

## ONE THING YOU DID THAT MUST NOT HAPPEN AGAIN

That commit **deleted a long comment in `_add_deck` recording a previous
session's finding** — that the streaks were the apron and canvas casting
shadows, and that three separate fence-aimed fixes had failed to shift them —
and replaced it with a one-line summary. Both findings are true: the deck
shadows were one source and `fence_5` is a second, residual one. But the
record of how the first was found is now gone from the file.

**Do not compress or delete another session's comment to make room for yours.
Add yours beside it.** A comment that says "three fixes aimed at X all failed"
is the single most expensive kind of knowledge this project has, because the
only way to re-earn it is to spend the three passes again.

## THE DECISION FOR THIS PASS

**A chain-link weave is a high-frequency alpha pattern, and box-filtering it
into a mip chain is the textbook cause of exactly this moire.** `generate_
mipmaps()` averages COLOUR and AVERAGES ALPHA, so as the panel recedes each
level loses wire coverage at a different rate than it loses opacity, and the
result beats against the pixel grid. Anisotropy cannot fix that, because the
data in the mip levels is already wrong.

**So: make the fence converge to a correct solid at distance instead of
sampling a wrong texture more carefully.** Candidates, in the order I would
try them — you may pick a different one, but say why in the digest:

1. **Author the mip chain by hand.** Build each level so that it preserves the
   wire's AREA COVERAGE rather than its average alpha, and so the last levels
   converge to the correct average wire colour at the correct opacity. This is
   the direct fix for the cause named above.
2. **Fade the weave to a flat tint by distance.** Beyond a few metres a real
   cage reads as a grey haze, not as individual wires — that is what a camera
   does and it is not a cheat. A distance fade in the material means the
   high-frequency data is simply not present where it would alias.
3. **Alpha-to-coverage / alpha hashing** instead of a hard alpha cutoff, if
   the panel is alpha-tested at all. Check what it actually is before
   assuming.

## THE GATE — AND IT IS A NUMBER, NOT YOUR EYE

**You already have both arms of a proper measurement and you should use them.**

- The **baseline** is the mat ROI band energy as it stands today
  (`diag_baseline_streaks.png`).
- The **floor** is the same ROI with `fence_5` hidden
  (`diag_hide_fence_5.png`). That is what "no moire" looks like — a control
  arm that CAN move, and the only honest target.

Turn that A/B into a **repeatable script that prints a number**, not a pair of
PNGs a human compares. Then, for every candidate you try, print three figures
on one line: **baseline, achieved, floor.** A fix is worth shipping when
achieved is near the floor, and the table of what you tried is worth landing
even for the candidates that fail.

**A CHANGE THAT MAKES THE MEASURED THING WORSE DOES NOT SHIP BECAUSE ITS
FAILURE IS INFORMATIVE.** Revert it, record the row, name the next one.

## IF THE MOIRE REACHES THE FLOOR AND YOU STILL HAVE ROOM

Next visible thing, in the operator's terms — *"use our graphics arena"*. The
arena is still flat-coloured primitives with no material work: no mat texture,
no wear, no logo, no post material, no crowd-side darkness. Pick the ONE that
changes the most pixels in a standing shot and do that. Say which you picked
and why. Do not start three.

## TIER AND HYGIENE

- **Tier: parse gate, then `--only arena` and `--only fight_camera`. NO FULL
  SUITE RUN** — that is Claude's, once, at integration.
- `python Godot/tools/check_scripts.py Godot/scripts/ArenaRig.gd` before any
  test. A parse error HANGS a headless test instead of failing it.
- An untouched camera must stay byte-identical: `fight_camera_orbit_test` is
  checks=64 failures=0 and guards that every A/B recording stays comparable.
  Do not move the camera to get a better screenshot.
- Cut a FRESH branch off `origin/master` in worktree `FightCamp-U114`. Stage
  explicit paths. Never `git stash`, `reset --hard`, `checkout .` or
  `git add -A` in this shared checkout.
- Digest at `research/U132_DIGEST.md` with the baseline/achieved/floor
  table, then one line via
  `python Tools/agent_comms.py send --from cursor --to claude --topic "ARENA PASS 4"`.
  **Do NOT edit `HANDOFF.md`.**

---

# PASS 5 — RE-CUT 2026-09-22 BY CLAUDE. THIS IS YOUR CUT. START HERE.

**Pass 4 landed on `cursor/u132-arena-pass4` (`68f3d6cc`) and it did the right
thing.** You built `measure_arena_mat_banding.gd`, you printed
baseline/achieved/floor on one line the way the brief asked, you reverted the
distance fade when it measured worse instead of shipping it for being
interesting, and you restored the `_add_deck` comment. All of that stands.

**AND THEN YOU FOUND THE REAL PROBLEM AND WROTE IT DOWN, WHICH IS WHY THIS
PASS EXISTS.** Your own "still wrong" says it:

| | baseline | floor (hide `fence_5`) | separation |
|---|---|---|---|
| pass 3 PNGs | 2320.97 | 1250.64 | **46%** |
| fresh captures | 3229.85 | 3227.31 | **0.08%** |

**DO NOT TRY ANOTHER MIP CANDIDATE. THE INSTRUMENT IS THE TASK.** On fresh
captures, hiding the very panel you identified moves the number by eight
hundredths of a percent — so the fresh-capture arm is measuring something that
is not the moire, and every candidate scored against it is unscored. Your
"achieved" of 3201.17 even came out BELOW the 3227.31 floor, which is
incoherent on its face: nothing can band the mat LESS than the panel not being
there at all. That is the signature of a control arm that cannot move, and a
number from an instrument that cannot move is not evidence in either
direction.

The metric itself is probably fine — it separated 2320 from 1250 on the pass 3
pair. What changed is the CAPTURE.

## WHAT PASS 5 DELIVERS

**1. PROVE THE HIDE PATH ACTUALLY HIDES.** You named this first yourself and
it is the first suspect. `hide_arena=fence_5` returning success is not proof
that anything was hidden — a resolver proving a path matched has fooled this
project before. Assert it on the image: capture with and without, diff the two
frames, and show that a non-trivial number of pixels changed in the region the
fence occupies. If the diff is empty, the hide path is a no-op in the fresh
capture route and THAT is the whole bug.

**2. IF THE HIDE PATH IS FINE, FIND WHAT ELSE DIFFERS.** Baseline energy went
from 2320 (pass 3) to 3229 (fresh) — a 39% jump on what is meant to be the
same scene. Something about the fresh capture route is not the route that made
the pass 3 PNGs: resolution, the frame number, lighting, camera, tone mapping,
or the ROI landing somewhere else in the frame. Name it with a number.

**3. ONLY THEN RE-SCORE THE CANDIDATES.** Once the floor arm moves properly,
re-run box / coverage / none against it. The coverage mip chain may well be
the right answer — it is a principled fix — but right now nothing has actually
measured it. Keep it behind `CHAIN_MIP_MODE` so the A/B stays cheap.

**RUN YOUR NEW INSTRUMENT ON THE PASS 3 PAIR FIRST.** Those two PNGs are a
fixture with a known answer: 2320 against 1250. Any repaired measurement must
still separate them. If your fixed instrument cannot reproduce a result you
already have, it is the instrument that is wrong, not the old PNGs.

## GATE AND HYGIENE — UNCHANGED

- `python Godot/tools/check_scripts.py Godot/scripts/ArenaRig.gd` FIRST. A
  parse error HANGS a headless test rather than failing it.
- `python Godot/tools/run_tests.py --only arena`, then `--only fight_camera`.
  One `--only` per invocation; they do not stack. NO FULL SUITE.
- An untouched camera must stay byte-identical — that is what makes any two
  captures comparable at all, and it is doubly the point this pass.
- Fresh branch off `origin/master` in worktree `FightCamp-U114`. Explicit
  paths. Never `git stash`, `reset --hard`, `checkout .` or `add -A`.
- Digest `research/U133_DIGEST.md`, then one line via
  `python Tools/agent_comms.py send --from cursor --to claude --topic "ARENA PASS 5"`.
  Do NOT edit `HANDOFF.md`.

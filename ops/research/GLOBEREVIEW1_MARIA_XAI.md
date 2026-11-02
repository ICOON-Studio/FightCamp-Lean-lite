# Maria reply via xAI API (model grok-4.7, route responses+web_search (stream), 21934 chars, 317 s)
# Task: research/TASK_GLOBEREVIEW1.md

POLISH.

I am not signing 8.2. That number measures the climb from 4.8. Against a $19.99 Steam Early Access store page it is about two points high. The layout of picture 2 is the right layout. Keep it. What is on screen is still a dark sphere with a stroked texture and a sticker, staged in a void. One focused round, not a redesign. Do not ship the demo on this globe.

## A. Scores, and the first five seconds

**Picture 2 — 6.0 / 10.**
Five seconds: I know the verb. Pick a country, read three bars, press the yellow button. The glove is the only thing that tells me this is boxing and not a strategy-game shell. The UK is findable. Then the sphere fails. Europe is a brown wash, Africa falls off the face of the earth, the highlight has no edge, and the white label is a maps pin. I would not put this frame on the store page. I would not be embarrassed by it in a private build. Those are different bars, and 8.2 conflates them.

**Picture 3 — 5.0 / 10.**
Five seconds: same globe, then the eye snags. Empty wells, a grid of tiny cells (`58`, `12`, `10`, `M`, `JI`) that do not resolve into a system, two lines of dossier text floating in a dead rectangle. I stop choosing a market and start wondering if the panel failed to load. The globe did not get worse. The screen did. A player forgives an unfinished gym. They do not forgive a broken panel on step one of a new career.

**Picture 4 — 4.0 / 10.**
Five seconds: this is the screen they actually see first, and it is the worst of the three. The Pacific is a radial grey disc. Australia is a stain. Coasts on the limb are hairlines. “NOTHING CHOSEN YET.” tells me what I already know, in a developer’s voice, and the button is a mud slab. I move the mouse to check whether the world is interactive or still loading. If I cannot name three landmasses without squinting, the picker has not started.

Picture 1 is a lighting and material brief, not a comp to trace. Its relief, its key light, and the way the limb separates from the ground are the target. Its type is not. “CINTED MINGDOM”, “80,49”, “19,0.5” are generative-image failures. Do not chase that file into the game.

## B. Why one more round

The delta since 4.8 is real: hierarchy, palette family, a readable pick, a card that can hold three pillars. That is layout, and layout is done enough. What is not done is the object. A management sim sells trust in the first screen. Football Manager can be plain because twenty years of data sit behind the list. We do not have that credit. Our first screen is a picture of a world, and the picture still looks assembled.

Shipping now puts picture 4, or picture 3’s card, in the first GIF. That is the frame people use to decide whether the rest of the sim is finished. Hold the globe one round. Do not hold the career flow.

## C. Five changes, in payoff order

### 1. Kill the fake light. One key, one rim, every rotation.
Fixes the dead centre-bright disc in **picture 4**, and the muddy brown fog in **pictures 2 and 3**.

The highlight in picture 4 sits in the middle of the disc no matter which ocean is facing us. That is a view-space radial gradient, or a texture painted for the Europe framing and then left behind when the globe yaws. A lit sphere does not do that. Africa going black in picture 2 is the same bug from the other side: falloff with no fill and no rim, so the limb dies into the background.

Godot 4, on the existing `SphereMesh` (`radial_segments` 64, `rings` 48 — enough at this size):

- Remove any `CanvasItem` radial overlay, and any emission texture that was painted to fake a highlight. Lighting lives in the material only. Country-ID lookup stays in UV0 and is not touched.
- `DirectionalLight3D` key, direction from upper left, about `(−0.45, 0.55, 0.65)` normalized. Color `#FFE0B8`, energy `1.1`. Shadow off. The player should be able to point at the light.
- Second directional, rim, from back-right `(0.6, 0.15, −0.75)`. Color `#9BB4D0`, energy `0.55`. This is the edge that picture 4 does not have.
- `WorldEnvironment`: ambient `#1A120C` at energy `0.06`. Not white ambient, not zero. Background `#070605`. Tonemap ACES, exposure `1.05`. Glow on, intensity `0.25`, bloom `0.15`, HDR threshold `1.0`, so only coast peaks and the medallion bloom. If the whole landmass blooms, the threshold is too low.
- Ocean albedo `#0E141C`, roughness `0.42`, metallic `0.12`, clearcoat `0.35`, clearcoat roughness `0.25`. That is lacquered desk-globe, not car paint and not matte plastic.
- Land albedo `#3A2C22` lit, `#1A1410` in shadow. Roughness `0.72`, metallic `0.0`.
- Specular on ocean only. A broad, soft highlight upper-left of the disc, never a hard dot, never centred unless the key is in the camera.

Definition of done: rotate 180° to the Pacific and the limb is still a cool edge against the ground, and Australia still has form. If the bright spot stays glued to screen-centre, the overlay is still in the tree.

### 2. The idle frame is the product. Frame the Atlantic and make unselected land readable.
Fixes **picture 4** first. Pictures 2 and 3 inherit a globe people can actually scan.

Picture 4 is what “no selection” currently means: a dark orb and an apology. Unselected is not a loading state. It is the invitation.

- Default yaw so the Atlantic faces the camera. Europe left-of-centre on the disc, Americas on the left limb, Africa lower centre, UK near the optical centre. Do not open on the Pacific. We have nothing to sell there yet.
- Camera: `Camera3D`, perspective, FOV `30` (telephoto — a 60° lens balloons the silhouette and is why the sphere feels pasted on). Globe centre at `(700, 548)` on a 1920×1080 frame. Diameter `640px`. Right limb ends by `x = 1020`, so it clears the card (card left edge `1468`) by a deliberate gap, not a collision. Lift it `36px` off the bottom safe area. An `8°` downward tilt, so we see a little of the north and the sphere sits, rather than staring us in the face like a billboard.
- Unselected land must hold `#4A3828` on the lit side and never drop the coast below `#A68648` at `0.75` opacity. If a coastline disappears in shadow, it is too thin or the albedo is too low, not “moody.”
- Idle motion: yaw `+7°` over `9s`, sine ease, reverse, loop. No constant spin. A spin reads as a loading orb — picture 4 already risks that.
- Four dormant market seeds visible before any click, as `6px` gold dots (`#E0B44A`) with a `2px` dark ring: London, New York, Mexico City, Tokyo. Opacity pulse `0.35 → 0.8` over `2.2s`, staggered `0.4s`. They are targets, not labels. The first hover replaces the dot with the pin.
- Hover, any country: land albedo lerp to `#6A5038` in `140ms`, coast to `#F0D78C`. No hover means picture 4 stays dead even after the relight.
- Idle card copy is not “NOTHING CHOSEN YET.” Use a real empty state, same frame as the picked card: headline `SELECT A MARKET`, one line in `#CDB892` at `15px` — “Where the gym opens. The market sets the fighters, the purses, and the crowd.” Three gauge tracks drawn empty at `8%` fill, not hidden. A collapsed panel reads as a bug. A ghost panel reads as a system waiting.

### 3. Coasts are inlay, not a 1px stroke.
Fixes the SVG-on-a-ball read in **pictures 2 and 3**, and the illegible Australia outline in **picture 4**.

Uniform hairline gold is the cheapest tell on the sphere. On the lit side it aliases (Scandinavia and the Mediterranean in picture 2 are jagged). On the dark side it vanishes. A brass inlay catches light on the facing edge and still glints on the limb.

Shader terms, one spatial shader on the globe, `render_mode diffuse_burley, specular_schlick_ggx`:

- A coastline SDF in a texture, not a vector line projected in screen space. Screen-space strokes are what shimmer when the idle yaw starts.
- Width: about `2.5px` at the facing centre of a `640px` globe, tapering with `NdotV` so the limb does not thicken into a halo. `smoothstep` the SDF. Do not use a hard `step` — that is the aliasing.
- Coast color `#E4C57A`, emission `#E8C97A` at energy `0.35` on the lit side, `0.15` in shadow. Emission is what keeps the inlay alive when Lambert goes to zero. Picture 4’s missing continents are an emission problem as much as an albedo problem.
- A thin normal bevel: offset the SDF into the normal, `0.15` strength, so the coast has a highlight line and a shadow line. This is the relief in picture 1, faked cheaply, and it is most of the “physical object” read without a displacement mesh.
- Selected country only: add emission `#E8B84A` at `0.22` inside the land mask, plus the coast at full. Unselected neighbours stay matte. The current UK glow is a yellow blot with no edge. The country border should be the brightest thing in that region, not a fog over Britain and the North Sea.
- MSAA `4x`. Coastlines this thin will crawl without it the moment the globe yaws. Bloom from change 1 softens the last remaining step.

Do not model raised continent geometry for the demo. A normal-from-SDF plus the two lights will outrun a heavy displace mesh at this camera size, and it will not fight the country-ID raycast.

### 4. The pin is a small prop, not a Google Maps sticker.
Fixes the sticker feel in **pictures 2 and 3**. Picture 1 had the right silhouette; the game flattened it.

- Medallion `56px` at 1080p. Outer ring `3px` `#E6C56A`, inner disc `#7A1E22` (oxblood, not primary red), glove in `#F3E6C8`. A flat red disc with a flat icon is the style break against an otherwise brass screen.
- Build it as a small 3D prop parented to the hit point: a `CylinderMesh` stem, `2px` wide, `32px` long, albedo `#C9A44C`, roughness `0.35`; a disc for the medallion, billboarded on Y only so it doesn’t tumble. One `OmniLight3D` is unnecessary if the key from change 1 hits it. If the medallion stays in a `Sprite3D`, give that sprite a normal map. A flat quad will keep looking like a UI decal, which is what pictures 2 and 3 are.
- Contact: a `Decal` at the stem’s base, `18px`, multiply black at `0.45`, soft. Picture 2’s pin floats. The shadow is what nails it to the ocean.
- Selection ring on the surface: `72px` diameter, `1.5px` stroke `#E8C56B`, opacity breathing `0.3 → 0.85` over `1.6s`. It sits on the globe, occluded by the sphere, not drawn as a screen circle around the label. The ring in picture 3 is the right idea and the wrong space.
- Label: stop the white pill. Cream plaque `#F4EDE0`, radius `2px` not `8px`, `1px` stroke `#8A7340`, text `#1A140C` at `13px`, tracking `+40`, padding `10px` horizontal, height `28px`. Offset `14px` right of the medallion, never covering it. Shadow `0, 2, 8` at `60%` black. Radius `2px` is a nameplate. Radius `8px` is a mobile chip. Picture 2’s label is readable and slightly cheap; this keeps the read and loses the app.
- Motion on select: camera ease to the country, `650ms`, `TRANS_CUBIC`, `EASE_OUT`, max arc `12°`. Stem scales `0 → 1` in `240ms` with an `8%` overshoot. Label fades in over `120ms` starting at `180ms`. A cut with a pop-in sprite is what makes the pick feel like a web control.

Drop the pin if the raycast misses. Never leave a medallion at the last good hit while the label says a different country. That desync is an instant “prototype” read.

### 5. Stage it. The void is doing more damage than the model.
Fixes composition across **pictures 2, 3, and 4**. This is the gap between those frames and the usable half of picture 1.

Radar rings are the wrong metaphor. They say sonar and missile track. This game is a gym, a licence, a purse. Picture 1 understood that: engraved meridians, a cartographer’s ground, the sphere sitting on something. The rings also fail as drawing. They are screen-space circles of constant weight, they do not take the globe’s light, and in picture 4 they run into the panel gutter and die. A motif that does not know about the object or the UI is decoration.

- Retire the rings as a hero. Replace with meridians and a tropic, albedo `#3A3228` at `12%` opacity, masked to a disc behind the globe only, never crossing the card, never crossing the title. If someone fights to keep a ring, one ring, `1px`, `#6B5A38` at `10%`, behind the globe, and it does not leave that mask.
- Contact shadow under the sphere: ellipse `520 × 70px`, centred `30px` below the globe’s bottom, `#000000` at `50%`, blur `36px`. This is the single cheapest “it exists in a room” fix on the board.
- Ground: radial, centre `#16130F`, edge `#070605`. No pure `#000000` anywhere in the frame. A pure black field cannot take a vignette, which is why the corners of pictures 2–4 do nothing. With a lifted centre, a `12%` vignette finally has something to darken.
- Grade the type so it belongs to the same light as the brass. Title `CHOOSE THE MARKET`: `#F3E6C8`, `26px`, tracking `+80`, not `#FFFFFF`. White-on-black is a debug theme. Search field and `MARKET LIST` keep their gold stroke `#C6A15A`, `1px`, fill `#12100E`. Button label on those stays `#F3E6C8`.
- CTA, picked state: fill `#E0B44A`, text `#1A1408`, height `52px`, inset `24px` from the card edges, radius `2px`. Disabled: fill `#2A241C`, text `#8A7B66`. Picture 4’s disabled button is a muddy brown slab at low contrast. A disabled control should look made, not unstyled.
- Talent bar: the saturated red in pictures 2 and 3 is a health bar. Move it to oxblood `#8E2E32`. Popularity and economy stay brass `#C6A15A` on a track of `#1C1814`. Three bars, one of them neon, breaks the metal.
- Card relationship, composition only: card width `420px`, left edge `x = 1468`, top aligned to the title baseline, `1px` rule `#C6A15A` on the left and top only — not a full glowing box. Shared light direction means the card’s top edge is `1px` lighter (`#E8C97A`) and the bottom edge is `#6E5428`. Flat panels next to a lit sphere is the other style break.

Card wreckage, briefly, because it is in its own round and because picture 3 cannot ship beside this globe: do not draw a container you cannot fill. The mystery grid and the empty dossier well are worse than a short card. Picture 2’s card — flag, name, tier, three bars, one line of counts, one button — is the density this screen can hold until the dossier is real. Empty rectangles read as missing art. Missing sections read as editing.

## D. What looks amateur, cheap, or generated

On the game frames, not as taste notes — as things a player clocks:

- **Picture 4’s centre-locked highlight.** Classic fake-3D. A real key light moves across the object when the object turns. This one stays painted on the screen. It is the same family of tell as an AI render that cannot keep a light direction between two angles.
- **Hairline gold of constant weight, jagged on Scandinavia and the Med in picture 2, gone on the dark limb in all three.** Vector stroke wrapped on a ball. No AA strategy, no thickness in depth, no metal response.
- **No contact shadow, no floor, no air.** The sphere is composited, not placed. Pictures 2–4 all do this. Picture 1, for all its faults, does not.
- **Pure white UI type and a pure yellow button against pure black.** Ungraded sRGB. Shipped premium UI is cream, brass, and a lifted black. `#FFFFFF` and a flat `#F0C000`-family button are a web template.
- **The white maps pill** in pictures 2 and 3. Readable, and it belongs to a different product.
- **Flat glove pictogram.** At `56px`, a flat icon on a 3D object is a sticker. Picture 1’s medallion at least has a bevel and a shadow.
- **Picture 3’s data grid and empty wells.** This is the “very amateur” note, and it is fair. Tiny misaligned cells, stray letters, a dossier that is two lines in a void. It looks like a `Control` layout that overflowed, or a placeholder that was never given a hide rule. Players do not distinguish “card rework in progress” from “this build is broken.”
- **“NOTHING CHOSEN YET.”** with the period, in small tracked caps. That is a log line. Player-facing empty states do not narrate the null.
- **Radar rings that ignore both the globe and the panel.** A circle that slides under the sphere without changing weight, then butts into the card gutter, is a shape drawn in the UI layer. It does not convince anyone the world is round.
- **Picture 1 itself, if anyone is tempted to sample it.** Garbled display type, nonsense stats, a label that does not match the card title. Use it for relief, light direction, and the parchment *idea* at low opacity. Do not colour-pick its card, and do not let generated type into a reference the team traces.

Also missing, and players feel it without naming it: no grade. One ACES tonemap and a warm shadow lift (`#1A120C` instead of `#000000`) would put pictures 2 and 4 in the same world. Right now each frame is an ungraded composite of a viewport and a theme.

## E. What shipped games do on this screen that we do not

**XCOM 2 — Geoscape, mission site selected.** The Earth is dark and still readable at every camera stop. Selection is a beam plus a ring that belongs to the surface, and the camera eases to the site instead of popping a sticker. The right-hand panel is either full or absent. We have the panel and the ring, and none of the light, the ease, or the rule about empty containers. Do not take their cyan hologram. Take the discipline.

**XCOM: Enemy Unknown — Geoscape / Mission Control.** Same lesson, older and even clearer: the globe is the hero, the UI is a brass-and-blue instrument around it, and an unselected Earth is still a picture you can read from the couch.

**Mass Effect 2 — Galaxy Map.** Black ground, and the map object still separates, because the limb carries a rim light. Our picture 4 fails exactly the test that map passed in 2010. Side dossier appears for the thing under the reticle, not as a stack of empty boxes.

**Stellaris — Galaxy view, system selected.** The unselected state is dense with things you are allowed to want. Selection adds a bracket and a panel. It does not turn the rest of the map off. Our idle state turns the world off and then apologises.

**Anno 1800 — main menu, and the new-session screen.** This is the tonal target, closer than any sci-fi geoscape. Brass is dark in the creases and bright on the edge. Type is cream. Nothing is pure black. Engraved lines sit in a ground plane. A boxing gym’s heritage — licences, purses, a club plaque — lives in that mercantile light, not in a sonar scope.

**Crusader Kings III — bookmark / “select a character” screen, and the map.** Heraldic frames, antique gold that is actually `#8A6A32` in shadow and only hits `#E8C97A` on a bevel. Parchment used as a material, not a sepia wash that eats contrast. Picture 1 is reaching for this and overshooting into a generated print. CK3 shows the usable dose.

**Civilization VI — leader selection, and the globe in the opening presentation.** The hero object is lit like a product, from a direction you can name, with a graded ground behind it. Our sphere is lit like a texture with a gradient multiplied on top.

**Cities: Skylines — New Game, map selection.** The management-sim version of this problem. A 3D preview of the place you are about to commit to, a side panel of real facts, no empty module, no decorative circles. The preview is allowed to be the fantasy. Ours is not, yet.

**Motorsport Manager — New Career, team select. F1 Manager 2024 — Career, team select.** The hero object (the car) is a small product shot: key light, rim, ground shadow, UI kept off the silhouette. Stats sit beside it and do not compete with it. We have the split. We do not have the product shot. A `640px` globe with a `30°` lens and a floor shadow is that shot.

**Total War: Three Kingdoms — campaign map, any coast.** Coasts and rivers catch a directional light and stay readable in cloud shadow. That is the material bar for “a line on a map that still feels made of something.” Our coast is a stroke.

**Football Manager — job selection.** Not a globe, and that is the point. FM survives a plain list because every row is true, dense, and finished. We do not get to be plain. If our picture is simpler than FM’s list, it has to be more beautiful than FM’s list. Picture 4 is neither.

**Frostpunk — main menu.** The generator is a hero object in a black field that is not actually black, with brass instruments that look designed when they are idle. Idle is the state Frostpunk gets right and picture 4 gets wrong.

None of these put a white maps pin on an unlit sphere and call it the first decision of a campaign. The ones with a globe always answer three questions in the first second: where is the light, where am I allowed to click, and what happens to the panel when I have not clicked yet. We answer the second question only after a country is already chosen, and only in pictures 2 and 3.

## Lock these, and the round is done

Palette, so nobody invents a new gold mid-task:

| Role | Hex |
|---|---|
| Ground edge | `#070605` |
| Ground centre | `#16130F` |
| Ocean | `#0E141C` |
| Ocean lit | `#1C2836` |
| Land shadow | `#1A1410` |
| Land | `#3A2C22` |
| Land lit / hover | `#6A5038` |
| Coast | `#E4C57A` |
| Coast peak | `#F0D78C` |
| Brass shadow | `#8A6A32` |
| Brass | `#C6A15A` |
| Brass edge | `#E8C97A` |
| Oxblood | `#7A1E22` |
| Talent bar | `#8E2E32` |
| Cream type | `#F3E6C8` |
| Ink | `#1A140C` |
| CTA | `#E0B44A` |
| Disabled fill | `#2A241C` |

Ship the globe when all of these are true in a 1920×1080 capture, idle and UK-picked, side by side:

- A new player can name three landmasses on the idle frame in two seconds.
- They can point to the key light, and it stays put when the globe yaws.
- The limb separates from the ground on the Pacific side.
- The pin casts a shadow and the label is a plaque, not a pill.
- No empty rectangle, no pure white type, no pure black fill, no radar ring crossing the card.
- The UK frame could sit on the store page next to the short description without a caption apologising for it.

That is a polish round. It is buildable in Godot 4 on the mesh you already have. Layout stays. Ludo’s climb from 4.8 stays. The 8.2 does not.

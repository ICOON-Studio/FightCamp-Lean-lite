# Kalli reply via xAI API (model grok-4.7, route responses+web_search (stream), 16678 chars, 244 s)
# Task: research/TASK_GLOBEREVIEW1.md

I’ll score the three captures against a paid Early Access bar, not Ludo’s 8.2, and check a few shipped “pick your starting world” screens so the comparison is specific.**Polish.**

Ludo’s 8.2 is a similarity score against his own still. It is not a ship score. The skeleton is right. The first frame is not.

## A. Scores

Judged as the first screen of a $19.99 Early Access save, the screen a player will screenshot. Picture 1 is not scored. It is not a game screen.

**2 — 5.6/10.** The only capture that looks like a menu someone finished. It still looks like a menu, not a market.

First 5 seconds: the eye hits CHOOSE THE MARKET, jumps to the gold button, then scans three bars that all say “you’re fine” (92, 90, 74). The globe is glanced at and dropped. The UK pin is a sticker on a dark ball. Feeling: cold, tidy, slightly cheap. A player who wanted a gym already wants the button. A player who wanted to choose a country has nothing to choose with. The bars do not disagree with each other hard enough to be a decision.

**3 — 4.7/10.** Same globe, worse screenshot. The card got ambition and lost the build.

First 5 seconds: the eye sticks on the chip row. `58  12`, `10  M  8`, `B  6  JI  6` reads as a broken font or a failed generate, not as sport culture. Trust drops before GRADE A+ is read. The dossier well under VANGUARD TRAINING CENTRE is an empty dark rectangle with two lines in it. Feeling: this build is not done. The selection ring around the UK is the one thing this capture does better than 2, and it is not enough to carry the frame.

**4 — 3.2/10.** This is the real first frame. It fails.

First 5 seconds: a black sphere, gold scribbles, the Pacific. Australia is a faint outline. Europe is in the dark. NOTHING CHOSEN YET. is a whisper in the top-right of a dead column. The button is a brown slab. Feeling: it didn’t load, or there is nothing to pick. Search and MARKET LIST are the only live controls, and nothing tells you that. A demo dies here even if the gym sim behind it is deep.

The white band under 3 and 4 is the capture margin. Not docked.

## B. Polish.

Do not ship. Do not redesign. One round, scoped to the five changes below, then reshoot 2, 3 and 4 at 1920×1080 and 1280×720 before anyone scores it again.

Shipping now puts picture 4 in the demo and picture 3’s chip row in the first negative Steam post. The layout grid can stay: title, search, list, globe, card, one primary button. That grid is the part that is actually at a 7. The sphere, the idle, and the pick are not.

Do not spend the round chasing picture 1. That still is an AI plate. The header reads CINTED MINGDOM. The stats read 80,49 and 19,0.5. The lit landmass sits south of the pin and does not read as the UK. Art-directing the game at that image is how the gold-on-black cliché got into the build in the first place.

## C. Five changes, in payoff order

### 1. Make the sphere a world, not a gold stroke on black
Fixes **4**, then **2** and **3**. This is the amateur tell in all three game captures.

At 1080p the globe mesh should be a UV sphere, radius such that the disc is **780px**, centered in the left column, sitting **40px lower** than it sits in picture 4. Segments 96×48 minimum or the limb facets. Pure `#000000` behind it is why it looks like a Shadertoy. Background is a radial vignette, `#14110E` behind the globe falling to `#070605` at the screen edge.

ShaderMaterial, one country-index texture (R = country id, A = land mask):

- Ocean albedo `#0C1014`, roughness 0.32, a tight specular so the upper-left limb has one highlight, not a chrome ball.
- Land albedo `#1C1610`, roughness 0.82. No photo texture. A land mask is enough.
- Coast: gold `#D6B25E` only as a 1.5px screen-space edge where land meets ocean. It is an edge, not the whole map.
- Borders: `#8A7344` at 0.35 alpha, 1px, from the id texture. Without borders every country is the same scribble.
- Fresnel rim: `pow(1.0 - ndotv, 3.2) * vec3(0.79, 0.64, 0.35)`, max contribution 0.35. This is the only lesson worth taking from picture 1.
- Key light: DirectionalLight3D, `#F3E6C8`, energy 1.1, from upper left (yaw −35, pitch −50). Fill ambient `#0E0C0A` at 0.15. No second light “to be safe” or the form dies and you are back to picture 4.
- Optional height: raise land 0.6% of radius along the land mask. Normal strength 0.35. That is the difference between picture 1’s relief and picture 4’s shell. Do not import a NASA bump and crank it.

WorldEnvironment glow stays off the globe. If glow is on, threshold 0.92, intensity 0.35, and only the pin and the selected edge are allowed over the threshold. Bloom on the coastline is how this becomes the reference plate in motion.

Fails if abused: fresnel above ~0.5 turns it into a product render. City-light textures turn it into a wallpaper and fight the brass. A photo-realistic earth albedo makes the UI look pasted on a documentary. Land fill darker than `#16120E` and you have spent the round to get picture 4 back.

### 2. Idle must invite a click. Open on the Atlantic, not the Pacific.
Fixes **4**. Picture 4 is the demo’s first frame and it faces empty ocean.

Default globe rotation: longitude −30° toward the camera, so Britain sits right of center, the US East and Caribbean left of center, West Africa lower left. Japan and Mexico are one drag away, not a treasure hunt. Idle yaw drift **0.35 deg/s**, stops on the first mouse-down, never resumes. A spinning menu makes countries unclickable.

Six recommended starts only, data flag `recommended_start`: UK, USA, Mexico, Cuba, Japan, Thailand. Each is a **6px** disc, `#E0B44A`, billboarded on the capital, opacity pulsing 0.4→1.0 on a 1.6s sine. No other country gets a dot.

On-globe prompt, bottom-center of the globe column, 14px, tracking 1.2px, `#C4A574`: `DRAG TO ROTATE  ·  CLICK A MARKET`. Fade in at 400ms. After the first drag, fade to 0.35 over 300ms. Do not put this prompt in the dead card. The card is not where the eye is.

Hover, idle or picked: raycast to the sphere, lat/long to country id. Hovered land lifts luminance 8% over 80ms and gains a 1px `#C4A574` edge. Cursor becomes a point. Ocean hover does nothing. No tooltip spam on the ocean.

Fails if abused: beacons on every country and the idle state is a Christmas tree. Drift above ~1 deg/s and players miss clicks and call it broken. A “helpful” snap-to-nearest-country on release will fight anyone trying to frame a coastline. Hover lift above ~15% flickers the whole map as the mouse crosses Europe.

### 3. A pick lights the country. A pin is not a selection.
Fixes **2** and **3**. In both, the UK is a label and a medallion. The country itself stays as dark as the sea. Picture 1 at least tried to light land, and lit the wrong land. Do the intent, not the plate.

On click, over 180ms ease-out cubic:

- Selected land albedo mixes from `#1C1610` to `#4A3418`. Edge goes to `#F2D48A` at 2px.
- A contact glow under the pin: additive sprite, `#E8C56B`, 48px, alpha 0.55 falling to 0.22. Not a second radar ring.
- Pin punch: scale 1.0 → 1.08 → 1.0 in 90ms. Medallion **40px** diameter, stem 2px `#C4A574`, 28px long, plus a 2px contact shadow on the sphere so it sits on the world instead of floating in UI space.
- The white label pill goes. It is a stock Control in a brass screen. Replace with a plate: fill `#1A140C` at 0.92, 1px border `#D6B25E`, text `#F2E6CC` at 13px, padding 6×10, corner radius **2px**. Offset 14px right of the medallion, slide in 8px over 120ms. It must not cover the selected country. If the country is near the limb, flip the plate to the free side.

Unselected land stays at `#1C1610`. The pick has to read in a 400px-wide Steam thumbnail. That is the test, not the full-screen capture.

Picture 3’s surface ring can stay as a 1px circle at the pin’s contact, 36px across, `#D6B25E` at 0.7. It is the only selection cue that currently works. It is not a substitute for lighting the country.

Fails if abused: selected fill at `#FFD700` or brighter looks like a highlighter, not Britain. Lighting neighbor countries “for context” kills the read. A 300ms+ fill feels laggy on a menu click. Leaving the white pill and adding a brass one means two labels.

### 4. Delete the radar rings.
Fixes **2**, **3** and **4**. Three concentric circles do not mean range, reputation, or travel. They mean sci-fi HUD. Nothing in this game is a radar. Elaborating them (a sweep, ticks, a fourth ring) makes the screen more amateur, not less.

Replace with two things that earn the space:

- Contact shadow under the globe: ellipse **640×72px**, `#000000` at 0.55, blurred, so the sphere sits on a floor. Picture 4’s ball currently floats in a void, which is why the lower half of the frame is dead.
- One graticule, not three ornaments: lat/long at 30° steps, `#A89060` at 0.08 alpha, 1px. Enough to say “globe.” A single parchment arc behind the sphere, radius 820px, 1px `#3A3226` at 0.3, is allowed if someone misses the reference’s compass. One. Behind. Not interactive.

Fails if abused: a compass rose with degree labels, tick marks, and a rotating bezel. That is picture 1’s costume, and picture 1’s costume came with broken type. If the rings “have to stay for brand,” drop them to a single ring at 0.08 alpha. Three rings at full contrast is the cheap version.

### 5. The right column is half the screen. It cannot be a hole or a glitch.
Composition, not a card redesign. Fixes **4** first, **3** second. Picture 2’s card is the one to protect while this happens: three bars, a tier line, one button. Picture 3 added rows the layout cannot hold.

Idle card, picture 4. NOTHING CHOSEN YET. at the top of a void is not an empty state. Center this in the card, 320px measure:

- 18px `#F2E6CC`: Pick a market
- 13px `#A89880`, two lines: Where the gym opens decides who walks in, what you can charge, and who will put you on television.
- Three ghost rows at 0.3 alpha, same labels the picked card uses (Combat popularity, Talent depth, Media and purses), bars empty. The player learns the card before the first click.
- Disabled button: label `SELECT A MARKET`, fill `#2A2418`, text `#8A7344`. The current brown slab reads as a missing texture. Do not hide the button. A disabled primary is a promise that a click will light it.

Picked card, picture 3, one rule for this round: **if a row clips, it does not render.** The sport row is already broken at 1920×1080, not only at 1280×720. `JI` and `M` in a grid of naked numbers is the same failure as CINTED MINGDOM, except this one is in the game. Chip spec if you keep the row: height 28px, padding 8×10, gap 6, 2-letter code plus a word, wrap to two rows, never clip, never scale the font below 11px. A missing row ships. A garbage row does not.

Talent bar is alarm-red beside GRADE A+. Red means a problem. Recolor inside one metal family: popularity `#E0B44A`, talent `#C4844A`, purses `#C4A574`. Grade sits in an end cap, 11px `#1A140C` on the metal, not floating past the bar. The red can return later for a market that is actually hostile (sanctioned, gyms closing, purses unpaid). Using it as decoration now means you cannot use it as a warning later.

The dossier well: either fill it or shrink it. Two lines in a 200px-tall hole (LONDON BOXING / VANGUARD TRAINING CENTRE) reads as placeholder copy in a placeholder panel. Until the dossier has a rent figure, a fighter count, and a rival gym, cut the well to the height of its text plus 16px. Empty black is not minimal. It is unfinished.

Fails if abused: writing a paragraph of lore into the idle card. Two lines. Ghost bars that animate or shimmer. Showing all 12 weight classes as chips because the data exists. The card’s job on this screen is “what does this market do to my gym,” not a federation encyclopedia. And do not turn the three bars into a single averaged “market score.” 92/90/74 already fails to force a tradeoff; an average fails harder.

## D. What looks amateur, AI-made, or cheap

Picture 1 is an AI still, and it shows. CINTED MINGDOM. Stats `80,49` and `19,0.5` with labels too small and too melted to read. The pin says United Kingdom while the gold land sits on the wrong part of Europe. Parchment, compass rose, brass, and bloom are the default “luxury map” plate. It is not evidence of what a shipped game looks like. It is evidence of what a model draws when asked for one.

The build inherited the plate and not the volume. Pictures 2, 3 and 4 are a black ball, gold hairline coasts, and radar rings. That combination reads as a crypto dashboard or a dark-mode Dribbble shot. Players have seen it on store pages for games that were not finished. Coastlines with no land fill is the specific tell. A globe you cannot find a country on until a pin appears is a decoration.

Picture 3’s chip row is the in-game version of the AI text failure. Naked numbers, a stray M, a stray JI, clipped cells. A player cannot tell bug from art. Same capture: UNITED KINGDOM COMBAT ASSOCIATION as a header with nothing under it, and a dossier that names LONDON BOXING and VANGUARD TRAINING CENTRE inside a void. Those names feel generated because nothing else in the well is real.

The white UNITED KINGDOM pill on the globe is a default Control. Rounded, flat white, drop-shadowed like a map widget from a web template. It fights every brass decision around it.

Picture 4’s disabled button is low-contrast brown on near-black. Designed disabled states look quiet. This one looks unloaded.

The glove medallion is the right object and the muddiest execution. At the size in pictures 2 and 3 the glove turns into a red blob with a gold rim. At 40px it needs a one-shape silhouette: glove, no shading, no inner text. A detailed emblem at that size is noise, which is the cheap version of “premium.”

Large empty regions do the rest of the damage. Under the globe in 2 and 4. The lower half of the card in 2. The dossier well in 3. The entire right column in 4. Black space is only premium when the object in it is worth looking at. Here the object is the space.

## E. What shipped games do on this beat

**Football Manager’s new-game nation and club browser, and FM26’s international nation select.** Not a globe. A flag, a ranking, a continent group, a row you can scan. FM26’s nation select is cards with a flag and a world ranking, grouped by continent, and it is readable because the choice is the layout. We have MARKET LIST and then we hide the list. The globe is allowed to be the poster. It is not allowed to be the only way to compare 27 gyms against a purse grade. The list has to be one click away and, on idle, already showing six recommended markets so picture 4 is never empty.

**F1 Manager 2024, Create a Team, Choose an Origin.** Six origins, each a starting condition: who is backing you, what the car and the facilities are, what you are giving up. The screen is the tradeoff. Our 92 / 90 / 74 does not tell a player that London will fill the gym and eat the rent, or that a weaker market will hand them fighters and no television. Until the card can say that in one sentence and three numbers that can actually be bad, the gold button is a confirm, not a decision.

**Crusader Kings III, the ruler select on the map before the campaign starts.** The selected realm lights. The side panel is never a void. Map modes (development, culture, faith) let you shop the world, and you can use them before you commit. Our globe has two states, dark and pinned. A market layer, even one, would do more than another gauge: color countries by talent depth or by purse, toggled from the card, 150ms blend. One mode. A row of mode icons is a different game.

**Civilization VI, the leader select.** Full-bleed identity, one sentence of what this choice changes, a confirm that feels like casting. We do not need a portrait. We need the sentence the idle card in change 5 is holding a place for. Without it, every market is the same black panel with different bars, and Tier 1 is a sticker.

**Motorsport Manager, team select.** The car is different per team. Budget and HQ are visible before you lock in. Hard starts look hard. Our markets will all photograph as the same card unless the selected country on the globe, and one hostile number on the card, can be seen at thumbnail size.

The pattern in all five: the pick is readable before it is pretty, the panel is never blank, and the first frame is aimed at the decision. We have the pretty sketch, a blank first frame, and a decision that cannot be lost. That is the gap. It is one round if the round is spent on the sphere, the idle, the lit country, the deleted rings, and a card that would survive a screenshot. It is not one round if it is spent matching picture 1.

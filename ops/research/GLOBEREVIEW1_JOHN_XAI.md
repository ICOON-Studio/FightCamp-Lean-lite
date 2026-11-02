# John reply via xAI API (model grok-4.7, route responses+web_search (stream), 28276 chars, 279 s)
# Task: research/TASK_GLOBEREVIEW1.md

I'll review the globe against the four captures and ground the market numbers in published sources before scoring.POLISH. Do not ship the globe. Ludo’s 8.2 is a score for a working picker, not for a $19.99 first screen. The panel layout in pictures 2–4 is the right composition. The globe material, the idle camera, and the pick itself are not.

## A. Scores, and the first five seconds

Scored as the frame a paying Early Access player sees at 1920×1080, globe weighted over the card. Card notes are called out so the in-flight card rework is not double-counted. An 8 is “I would put this in the trailer.” A 6 is “I would put this in a devlog.”

| Picture | What it is | Score | Globe-only, if the card were finished |
|---|---|---|---|
| 2 | UK picked, the build Ludo scored 8.2 | **6.1 / 10** | 6.1 |
| 3 | Today’s master, UK picked | **5.2 / 10** | 6.0 |
| 4 | Today’s master, idle, no pick | **3.6 / 10** | 3.6 |

Picture 2 is a competent dark UI with a traced sphere, a readable pin, and three bars a player can parse. It is not a hero object. Picture 3 is the same globe with a card that now looks broken in the same frame, so the screenshot gets worse even though the globe did not. Picture 4 is the screen New Career actually opens on, and it fails the load test: a player cannot tell the globe has loaded.

**Picture 2, first five seconds.** The eye hits the white “UNITED KINGDOM” pill, then the gold pin, then the three bars. Combat popularity 92, talent 90, economy 74 are legible. The sphere itself has no form: land and ocean are the same near-black, the coastline is a hairline, there is no specular, no rim, no light under the pin. The radar rings do not move. Nothing asks the player to rotate, compare, or hesitate. A player who already knows they want the UK clicks CHOOSE MARKET inside five seconds and never discovers that the globe is interactive. That is a menu, not a market decision. For a sim that is selling Football Manager depth, the first decision should feel expensive. This one feels like confirming a dropdown.

**Picture 3, first five seconds.** Same globe, same flat read. Then the card breaks the spell. The eye drops to a row of dark chips whose labels resolve as “M”, “B”, “JI” and stray numbers (58, 12, 10, 8, 6). That is a clipped control, and it is the thing a Steam reviewer crops. Below it, “LONDON BOXING VANGUARD TRAINING CENTRE” reads as filler, not as a gym a player could name. The grades (S, A+, B+) are the right language and the hub row (London, Manchester, Birmingham) is the right structure. The empty rectangles under the hub dossier make the panel look mid-rework, which it is. Five seconds in, the player is checking whether the demo is buggy, not choosing a market.

**Picture 4, first five seconds.** This is the one that matters, because it is the open. The sphere is facing the Pacific: Australia, Indonesia, and a scrape of Southeast Asia, all in hairline gold on black. Europe, and therefore every playable hub, is on the far side or lost in the limb. “NOTHING CHOSEN YET.” sits in small grey type at the top of an empty panel and is easy to miss. The CHOOSE MARKET button is correctly disabled, which is the only finished behaviour in the frame. There is no “drag to rotate,” no country under the cursor, no light raking the sphere, no motion. On a laptop at half brightness this is a black circle. The honest first-five-seconds read is: the scene did not load.

The reference plate (picture 1) is not a ship target. Its pin and its relief lighting are the only parts worth taking. Its card overlaps the globe, its highlight sits on Iberia while the pin claims the UK, and its type is broken (“CINITED MINGDOM”, “80,49”, “19,0.5”). Matching that plate would ship the look the operator already rejected.

## The numbers on the card are a credibility problem, separate from the shader

A deep management sim is judged on whether the first screen knows its sport. The UK card currently does not.

The UK at mid-2024 was 69,281,400 people, up 755,300 (1.1%) on mid-2023, per the ONS statistical bulletin released 26 September 2025. [[1]](https://x.com/ONS/status/1971492578098020793) London’s regional population is on the order of 8.8 million (Ciphr’s compilation of ONS mid-2024 estimates gives 8,799,800; a separate 2024 regional series puts London at almost 9.1 million). Birmingham inside its city boundary is 1,121,375 in that same compilation. [[2]](https://www.ciphr.com/infographics/biggest-cities-in-the-uk-by-population) [[3]](https://www.statista.com/statistics/294729/uk-population-by-region/) Three English cities are a reasonable EA slice of that country. They are not the country.

Club counts, so the “27 gyms” line can be labelled honestly:

- England Boxing, the amateur NGB for England, reported 1,014 affiliated clubs and 26,500 members for the 2022–23 season (CEO note, 2 June 2023). [[4]](https://www.englandboxing.org/news_articles/england-boxing-new-season-2023-24/)
- Its own 2022–27 progress note says the 2024/25 season peaked at 1,086 clubs, the most in the history of amateur boxing in England, and over 36,000 individual members. [[5]](https://www.englandboxing.org/about/what-we-do/progress-against-key-strategic-objectives-for-2022-2027/)
- An older “What we do” page still says “more than 980 affiliated clubs and more than 23,000 members.” Treat that as stale against the two figures above. [[6]](https://www.englandboxing.org/about/what-we-do/?s=)
- Written evidence from England Boxing and the British Boxing Board of Control, on the parliamentary record, says more than 1,000 affiliated clubs, 27,000 members, and 150,000 recreational members across England. The 27,000 and the 36,000 are different cuts (carded versus individual versus recreational). Report the range; do not collapse it. [[7]](https://committees.parliament.uk/writtenevidence/126757/pdf/)
- A commercial business directory, not an official census, listed 1,008 boxing-club businesses in the UK as of August 2026, of which London 111 (11%), Birmingham 16 (1.6%), Manchester 15 (1.5%). Useful as an order-of-magnitude check, not as a licence count. [[8]](https://www.poidata.io/report/boxing-club/united-kingdom)

“3 cities · 27 gyms” and “3 hubs · 27 licensed gyms” are two orders of magnitude below either the NGB count or the commercial directory. As an EA content cap that is fine. Printed on the market card as if it were the market, it tells a boxing player the game has not done the reading. England Boxing’s own club affiliation is £240 a year from 1 June 2025, with a carded boxer at £13 and a coach or official at £26. [[9]](https://www.englandboxing.org/news_articles/a-message-to-england-boxing-clubs-members-and-coaches/) Those are real operating costs a gym-management sim can use. Twenty-seven is not a market fact.

The federation line is wrong in the same way. There is no United Kingdom Combat Association. Amateur boxing in England is England Boxing, recognised by Sport England and, from 1 August 2025, aligned with World Boxing rather than the IBA. [[10]](https://www.englandboxing.org/news_articles/important-update-england-boxing-ends-membership-with-iba-and-eubc/) Professional boxing has been the British Boxing Board of Control since 1929. The Board’s own about page says approximately 2,500 licence holders, of which around 1,100 are active boxers, the vast majority semi-professional, and only a few dozen earning a full-time living. [[11]](https://bbbofc.com/about-us) In October 2025 the Board’s general secretary told The Athletic the licence-holder count was just over 3,000, and that the Board does not record ethnicity. [[12]](https://www.nytimes.com/athletic/6752038/2025/10/29/boxing-black-promoters-managers-trainers/) Quote one of those, or invent a name that is obviously fictional. “United Kingdom Combat Association” is neither.

“London Boxing Vanguard Training Centre” is the same tell. A UK player can name Repton, Fitzroy Lodge, Peacock, Rotunda. “Vanguard Training Centre” is prompt cadence.

On the gauges, so design does not launder an estimate into a measurement:

- **Combat popularity 92 / Grade S.** Defensible as an in-game index, not as a published statistic. The media evidence for a high UK score is real: Fabio Wardley vs Frazer Clarke, 31 March 2024, O2 Arena, Sky Sports Main Event and Sky Sports Action, peak audience 746,000, average 438,000 across the four-hour broadcast, reach 1.7 million. That was the fifth most-watched boxing event on Sky Sports in the previous ten years, and the biggest heavyweight audience in that span. [[13]](https://insidersport.com/2024/04/04/boxxer-wardley-v-clarke-sky-sports/) [[14]](https://www.broadcastnow.co.uk/broadcasting/wardley-v-clarke-reaches-17m-on-sky-sports/5192104.article) A January 2024 poll of 2,000 UK adults found 4.4% planned to box at least monthly that year (men 5.88%, women 2.86%; ages 16–24 at 8.91%). Greater London 5.36%, North West 5.41%, West Midlands 3.95%, Scotland 5.06%, Wales 6.45%, Yorkshire and the Humber 1.82%. [[15]](https://oursportinglife.co.uk/boxing-statistics-uk/) That is stated intent in a small poll, roughly 160 respondents per region, not Sport England participation. Statista republishes the Active Lives boxing series (England, age 16+, at least twice in 28 days, including boxing fitness; 171,926 respondents in the Nov 2023–Nov 2024 wave) but the count itself is paywalled, so it is not quoted here. [[16]](https://www.statista.com/statistics/899195/boxing-participation-uk/) Label 92 as an in-game index. Do not let a tooltip imply Sport England measured it.
- **Talent 90 / Grade A+.** The pyramid underneath a high talent grade is the 36,000-plus England Boxing individual members at the 2024/25 peak, the 150,000 recreational members in the parliamentary evidence, and roughly 1,100 active licensed professionals, of whom a few dozen box full time. [[5]](https://www.englandboxing.org/about/what-we-do/progress-against-key-strategic-objectives-for-2022-2027/) [[7]](https://committees.parliament.uk/writtenevidence/126757/pdf/) [[11]](https://bbbofc.com/about-us) That supports “deep amateur base, thin full-time pro tip.” It does not support a single red bar with no legend. The red-versus-brass encoding is unexplained in all three pictures.
- **Economy 74 / Grade B+.** ESTIMATE, and it should stay marked that way in the design doc. The surrounding gym economy, not the boxing purse market, is what has a published size: the ukactive / Grant Thornton UK Health & Fitness Market Report 2026, backed by Sport England and 4GLOBAL, puts UK health-and-fitness membership at 12.2 million, income at £6.5 billion, visits at 679 million in 2025, penetration at 18.0%, and sites at 5,842. [[17]](https://www.blkboxfitness.com/blogs/education/uk-health-fitness-market-report-2026-launches) Seventy-four is a reasonable relative grade for “strong media market, high rent, mid purse ceiling.” It is not a measured purse index. The card currently presents all three bars with the same visual authority.

One market-design consequence of the poll, held lightly because the regional cells are small: the three hubs match the high-intent English regions (London, North West, West Midlands) and ignore Wales, which scored highest in that poll, and Scotland, which scored in line with London. A flag that says United Kingdom and a card that only offers three English cities is an England market in a UK header. England Boxing does not govern Scotland, Wales, or Northern Ireland. If the EA scope is three English cities, say “England” or say “playable hubs.”

## B. POLISH

One more round. Not a redesign, and not a chase of picture 1.

Ship the panel architecture: search, market list, globe on the left, full-height card on the right, disabled confirm until a pick. That is cleaner than the reference, where the card eats the globe. Do not ship the idle state, the unlit sphere, or the broken chip row. Early Access players forgive a missing league. They do not forgive a first screen that looks unloaded, and picture 4 looks unloaded. The store page will be judged against Motorsport Manager, which shipped at the same $19.99 and whose new-career series pick states the economic trade before you confirm. [[18]](https://stmstat.com/app/415200/screenshots) A black sphere will be the screenshot in the first negative review, and it will stick to the capsule.

The round is small if it is scoped to material, camera, pick feedback, and one honesty pass on the card copy. It is not small if it turns into “make it look like the Midjourney plate.”

## C. Five changes, in payoff order

Each one names the picture it fixes. Sizes are at 1080p. Colours are the brass system already implied by the UI; the failure is that the 3D scene does not use it.

### 1. Make the idle globe a globe, and point it at a market

Fixes picture 4. Lifts 2 and 3.

Picture 4’s sphere is an unlit mesh with a sub-pixel gold stroke, and the camera is resting on Australia. Both are bugs, not taste.

In the globe’s `StandardMaterial3D`, or a `ShaderMaterial` if you are already sampling a country-id texture:

- Ocean albedo `#14110E`. Land albedo `#2C261C`. They must separate with the lights off. Right now they do not, which is why picture 4 has no continents, only a trace.
- Roughness 0.62 on land, 0.38 on ocean. Metallic 0.08 land, 0.22 ocean. A little metal on the water is what makes a dark sphere read as wet rather than untextured.
- Rim: `rim_enabled = true`, rim colour `#E8C872`, rim tint 0.65, so the silhouette holds at any yaw. Fresnel power around 3.0 if you do it in shader. Strength 0.35. This is the single control that stops picture 4 being a black disc.
- Coastline emission `#E8C872`, energy 1.6 at idle, 2.2 on hover. Screen-space width about 1.5px at 1080p, not a 1px stroke that disappears on a laptop. If the coastline is a texture, multiply by emission and by a fresnel term so the limb stays readable: `emission = coastline.r * vec3(0.91, 0.78, 0.45) * (1.1 + 0.7 * fresnel)`.
- `DirectionalLight3D`, direction approximately `(-0.35, 0.75, 0.45)`, colour `#FFE6B8`, energy 1.15, shadows off. A fill at energy 0.2, colour `#3A2E22`, from the opposite side, so the dark hemisphere is not clipped to black. `WorldEnvironment` ambient energy 0.12, ambient colour `#1A140C`. Ambient at 1.0 is why so many Godot globes look flat; ambient at 0.0 with no directional is why this one looks unloaded.
- Glow on, or the emission never blooms and the coastline stays a hairline. `glow_enabled = true`, intensity 0.55, strength 0.7, bloom 0.12, HDR threshold 0.85. Cap it. Picture 1’s blown gold edges are the failure mode if bloom is left at default.

Camera: the idle yaw must put Europe on the lit face, UK near the upper third of the disc, not the Pacific. Then a sine drift of ±6 degrees over 8 seconds. Do not spin. A full revolution is a screensaver and it is one of the cheap tells. Drift says the object is alive; a spin says the screen is waiting.

Under the search field, one line, 15px, colour `#C4A35A` at 0.75 alpha, fade in over 400ms: `DRAG TO ROTATE  ·  CLICK A COUNTRY`. Picture 4 has no invitation at all. Hide it on first pick.

### 2. Fill the selected country. Separate land from ocean for everyone else

Fixes pictures 2, 3, and 4.

A pin on an outline is a marker. A filled territory is a decision. Pictures 2 and 3 only have the marker, so the UK never changes state on the globe itself; the card does all the work, and the globe is a logo.

Build it as a country-id texture sampled in the globe shader, with uniforms `selected_id`, `hover_id`, and `pick_strength`.

- Unselected land `#2C261C`, ocean `#14110E`, as above.
- Hover, unselected: mix toward `#6B5428` at 0.35, 140ms, `TRANS_CUBIC` / `EASE_OUT`.
- Selected: mix toward `#C4A35A` at 0.62, plus a 2px stroke `#FFE7A8` at emission energy 2.6. Tween `pick_strength` 0 to 1 over 200ms, same easing.
- Non-playable countries get the land colour and no hover. Playable countries get a 1px brass tick at the capital, 8px, so the idle globe in picture 4 shows that three hubs exist before a click. At this globe scale the UK is a small target; a tick is what makes it findable.

Click magnetism of 16px around each playable country. The UK at a 620px sphere is on the order of 20px wide; Belgium, if it ever becomes playable, will be a miss. A globe that misses clicks feels broken even when the shader is finished.

### 3. Make the pick an event: stem, medallion, local light, drop

Fixes pictures 2 and 3. This is the one idea in picture 1 worth stealing, minus the AI type.

The current pin is a flat red disc. It does not light the sphere, it does not arrive, and the white pill next to it is the brightest pixel on the screen, so the label hierarchy beats the object hierarchy.

- Stem: cylinder, 4×56px on screen, albedo `#C9A227`, metallic 0.92, roughness 0.32.
- Medallion: 40px disc, fill `#8B1E1E`, 2px rim `#E8C872`, glove glyph 18px `#F4EBD4`. The red is allowed here. It is not allowed as an unexplained bar colour (see change 5).
- `OmniLight3D` parented to the pin, colour `#E8C872`, energy 0.0 at spawn, range sized so the pool is about 140px on screen, attenuation 1.8. Tween energy to 0.75 over 180ms as the pin lands. This is what pictures 2 and 3 lack: the UK does not glow because it was chosen.
- Label: kill the pure-white pill. Fill `#1A140C` at 0.92, 1px stroke `#E8C872`, text `#F3E6C4`, 13px, tracking tight, height 28px, horizontal padding 12px. The white pill in pictures 2 and 3 is a default `StyleBoxFlat` and it is the amateur tell on an otherwise disciplined panel.
- Motion: pin starts 22px above its rest, drops in 260ms, `TRANS_BACK`, `EASE_OUT`. Light follows. Do not bounce twice. One overshoot is weight; two is a mobile game.

### 4. Ground the sphere: bloom already covered, plus shadow, rings, and a chart-room backdrop that is not picture 1

Fixes the void in pictures 2, 3, and 4.

Picture 1’s parchment compass is why that plate looks like a generated concept. Do not import it. The void in 2–4 is the opposite mistake: three faint circles and nothing else, so the sphere floats.

- Backdrop radial, centre `#12100C`, edge `#050403`. A compass rose behind the globe at 6% opacity, `#C4A35A`, 900px diameter. At 6% it reads as a chart room. At picture 1’s opacity it reads as a prompt.
- Contact shadow: ellipse 440×56px, `#000000` at 0.5, under the sphere, so it sits. Pictures 2–4 have no contact, which is why the globe feels pasted on.
- Radar rings stay. They are the right motif and they are currently a PNG. Three rings, diameters 780, 980, 1180px, 1px stroke `#C4A35A` at alpha 0.20, 0.12, 0.07. A 36-degree sweep arc, `#E8C872` at 0.28, one revolution per 9 seconds, linear, looping. In Godot that is a shader on a quad in front of the backdrop and behind the globe: `sweep = smoothstep(0.0, 0.02, abs(fract(angle - TIME / 9.0) - 0.5))` inverted, or a rotating `MeshInstance3D` if you would rather not write the arc. Motion here is what makes picture 4 feel attended rather than stuck.
- Frame: globe diameter 620px, not the current crop that lets the rings run off the panel. Left margin 72px, gap to the card 40px. The UK pin should land on the lit upper-left third of the disc after change 1, not in the lower shadow where pictures 2 and 3 leave it.

### 5. One card pass that stops contaminating the globe shot, and make the list the real control

Fixes picture 3 outright, and the “I click through in five seconds” problem in picture 2.

The card rework is its own round. Two items in it are blocking the globe, because they are in the same screenshot.

- Do not draw the sport-culture chip row until each chip is a 24px glyph plus an 11px label that fits. The “M / JI / B” row in picture 3 is worse than an empty row. Minimum gap 8px. If it does not fit at 1080p, it does not ship in the demo capture. The brief already flags this at 720p; it is still clipped at 1080p in picture 3, so it is not a resolution bug, it is a layout bug.
- Replace “3 CITIES · 27 GYMS” and “3 HUBS · 27 LICENSED GYMS” with a line that tells the truth: `3 PLAYABLE HUBS  ·  27 GYMS IN THIS BUILD`. Second line, 13px, `#A89878`: `ENGLAND: 1,086 AFFILIATED CLUBS AT THE 2024/25 PEAK`. That one line does more for “this sim knows boxing” than any shader. Same treatment for the federation: `ENGLAND BOXING  ·  AMATEUR` and `BBBofC  ·  PROFESSIONAL`, or a clearly fictional body. Delete “United Kingdom Combat Association” and “Vanguard Training Centre.”
- Talent bar: either recolour it to `#C9A227` like the other two, or keep `#A33B3B` and add a 10px legend, “depth / attrition”, 11px, `#A89878`. An unexplained red bar reads as a stylesheet accident. Picture 2 and picture 3 disagree on whether grades exist. Pick picture 3’s grades; they are the better system. S / A+ / B+ can stay.
- The globe is theatre. The list is the control. `MARKET LIST` is already in the header and it is the right call; it is not yet the primary path. Football Manager’s nation select does not make you hunt a country on a sphere. A list row hovered should drive `hover_id` on the globe, and a globe hover should scroll the list. Selection happens in either, confirmation stays on the brass button. Without that link, change 2’s fill only helps players who already know where the UK is.

Do not add a fourth gauge. Three is the right number. Do not add parchment, film grain, or a second pin style.

## D. What reads as amateur, generated, or cheap

1. Picture 1’s type is generated and broken. “CINITED MINGDOM”, “80,49”, “19,0.5”, and a gold wash on Iberia while the callout says United Kingdom. If any of that language or that mismatch survives into the demo, it confirms the earlier “amateur AI” note on sight. The plate is a lighting reference. It is not a layout reference and it is not a copy reference.
2. Picture 3’s chip row is the live version of the same failure. Truncated glyphs in dark boxes are what an unfinished icon font looks like. Players do not distinguish “art pass pending” from “generated UI.” They screenshot it.
3. “London Boxing Vanguard Training Centre” and “United Kingdom Combat Association” are generated names. Real institutions have awkward, specific names. These have the smooth cadence of a prompt. A player who has been to a club will feel it in the first read.
4. The white pill label is a default control. It does not share the brass of the pin, the rings, or the button. On a dark screen the brightest element should be the decision, not a stock `Label`.
5. Picture 4’s unlit sphere is the cheap version of dark luxury. Dark luxury is a rim light and a specular. Without them it is a mesh with a black albedo, which is what an early Godot prototype looks like before `WorldEnvironment` is set. That is the thing the operator was reacting to, even if the coastline art is now hand-placed rather than generated.
6. Radar rings that do not move read as three decorative circles exported from a mock. Motion is the difference between a system and a texture.
7. The talent bar is red and the other two are brass, with no key, in both picked shots. Inconsistent encoding inside a three-item system looks like two people edited the scene.
8. Picture 2’s card is half empty and picture 3’s card is half broken. Neither is the globe’s fault, and both will be in the review screenshot. Empty panel and clipped chips are the two cheapest looks in a management UI.
9. “NOTHING CHOSEN YET.” is placeholder copy left in the shipping view. It is also too small and too high to function as the empty-state instruction.
10. The idle camera on Australia, with every playable market on the dark side, reads as a default transform that was never set. Players interpret unset transforms as unfinished games.

None of pictures 2–4 look like a raw image generator. They look like a real Godot scene that has not had its lighting pass, plus a card that still contains generated copy and a clipped control. That combination is enough. Players do not grade the two separately.

## E. What shipped games do on this screen that this one does not

**Football Manager 26, International Management nation select.** Nations are flag cards grouped by continent, with world ranking on the card, and an unavailable nation is marked with the reason rather than hidden. The blog write-up of that screen calls it one of the cleaner parts of the update specifically because it is simple and the exception is visible. [[19]](https://www.footballmanagerblog.org/2026/05/fm26-international-management-live-world-cup-mode.html) SI’s own UI note for FM26 was efficiency, familiarity, predictability, and a tile-and-card system whose job is to make depth reachable without a hunt. [[20]](https://www.footballmanager.com/features/total-football-total-control-fm26s-reimagined-user-interface) FightCamp has named FM as the depth target. FM does not make the first decision a rotation puzzle. The globe can stay as theatre. It cannot be the only legible index. Picture 2’s `MARKET LIST` is the seed of the right answer and it is not yet wired to the sphere.

**Motorsport Manager (SEGA, 2016), new-career series select, $19.99.** Three series, named, with the reward-versus-pressure trade stated on the same screen before confirm. The player knows what the choice does to money and to difficulty. [[18]](https://stmstat.com/app/415200/screenshots) [[21]](https://www.youtube.com/watch?v=T-QGqVJ9ses) FightCamp’s three bars do not say what 74 economy does to rent, what 90 talent does to the intake, or what 92 popularity does to a purse. A grade without a consequence is a decoration. At the same price, MM made the first screen a decision.

**F1 Manager 2024, Create a Team origin screen (Frontier, shipped 23 July 2024).** Origin cards state starting budget, car strength, and facility level before the player confirms. Hungry Newcomer and Technical Breakthrough are different careers because the numbers differ, not because the badge differs. [[22]](https://www.f1manager.com/features/new/create-a-team-create-a-legacy) [[23]](https://corp.formula1.com/f1-manager-2024-out-now-with-new-create-a-team-mode/) The UK pick is FightCamp’s origin screen. It currently changes a pin and a card. It does not show a starting overdraft, a weekly rent, or a talent-pool size in units the player will meet in week one. Add one line under the bars: rent band, intake per month, media ceiling. Even as ESTIMATE values, in the game’s own currency, that line is what turns 74 into a choice.

**Civilization VI, map highlight and lighting.** Civ’s selection is a filled territory with a readable coast, not a pin on an outline, and land, coast, and ocean separate under a directional light. The series does not actually select from a globe; the map is a wrapped plane, and a true globe has been a fan request rather than a shipped map type. [[24]](https://gamerant.com/civilization-civ-7-should-add-new-map-type-globe-connected/) The relevant standard is the fill and the lighting, both missing in pictures 2–4. Picture 1 attempted the relief and missed the geography. The master should take the fill and the light, not the parchment.

**Crusader Kings, map modes.** The same geography, recolored by the question being asked: realm, development, economy. FightCamp’s three pillars are that feature. A shipped grand-strategy UI would let the player toggle the globe fill between popularity, talent, and purses instead of burying the comparison in a side card that only exists after a pick. One toggle, three fills, driven by the same country-id shader as change 2. That is the change that makes the globe a management tool. It is also the change that justifies keeping a globe at all, given FM and MM both declined to have one.

## Verdict, short enough to read back to the board

Picture 2 is a 6.1, not an 8.2. Picture 3 is a 5.2 because the card regressed in the same frame. Picture 4 is a 3.6, and picture 4 is the screen you ship, because it is the screen they open. The layout is ahead of the reference. The material, the idle camera, the pick, and three lines of copy are not. One polish round, scoped to the five changes above, is the difference between a devlog globe and a first screen that can sit next to a $19.99 management sim without apologising. Do not open a second round to chase picture 1.

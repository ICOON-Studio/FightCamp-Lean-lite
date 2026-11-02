# M34 — The pitch look: main menu, hub and fight-night hype

Maria Art Director · FightCamp (Godot 4.7.2, 1920×1080) · 2026-09-25 (Nicosia) · art only, no code touched

Tags: **[S]** = seen in a source I fetched today (URL in §9) · **[P]** = my proposal or judgement · **[J]** = from an earlier FightCamp job (M32/M33, repo docs).
Every on-screen word I wrote that isn't already in the game is **EXAMPLE** (Kalli owns words). Every picture in the mocks is **MOCK ART — AI** (existing AI images from the repo) or procedural Pillow drawing. No new AI image was generated (see §10).

---

## 0. Decisions

| # | Decision | Tag |
|---|---|---|
| D1 | **Stills + a thin live layer**, not full 2D animation. Each screen gets one high-res illustrated still (AI-assisted or rendered from a 3D scene we own/buy), plus 1–3 cheap live layers: slow parallax drift (≤ 12 px), dust motes, one light shaft, a crowd foreground on fight night. Video only for an optional 20–30 s attract/intro. | [P] |
| D2 | **Four directions** mocked, all in the Motorsport Manager / Hollywood Animal family: **A Brass & leather**, **B Fight poster**, **C Arena night**, **D Six A.M.** (today's M32 tokens, illustrated). | [P] |
| D3 | **My favourite: A (Brass & leather).** Fallback: **C (Arena night)**. Lowest cost: **D**. B is the boldest but the costliest to keep consistent. The operator picks. | [P] |
| D4 | Hub in all directions = today's 8 rail items (The day, Gym, Staff, Training, Schedule, Scouting, Rankings, Office). J54's IA is not in the repo yet (only the task file). | [J] |
| D5 | Fight-night hype = **5 beats** (announcement → weigh-in faceoff → walkout → ring intro → bell), styled in A. "How hard it was to get here" goes on screen in every beat: 19 months, 6 weeks of fight camp, 72.4 → 66.4 kg, 212 rounds, 11–2 (all EXAMPLE numbers). | [P] |
| D6 | **M32 amendment (flagged):** cinematic dissolves/wipes (360–400 ms) are allowed **only** at boot→title, title→hub, hub→fight-night and between fight-night beats. Everywhere else the M32 rule stays: 160–240 ms slides, never whole-screen fades. | [P] amends [J] |
| D7 | The "shiny button" = **one diagonal sheen that sweeps once (~600 ms) on hover/focus**, then stops. Never loops. No continuous pulse anywhere. | [P] |
| D8 | Buying: **no 2D GUI pack on any store matches the MM/HA brass look.** Best buys are for *backgrounds* (a Blender boxing-gym scene to render from) and we already own the fight venue (Marpa MMA Arena). Frames/buttons should be drawn by us as 9-slice PNGs from the mocks. | [S]/[P] |
| D9 | Portraits: the repo's AI portraits make the mocks look finished, but their generator and terms are not recorded. Before any of this ships, portraits need a clean source (commission, or re-generate with recorded terms). | [J]/[P] |

---

## 1. Reference board

File: `M34_reference_board.png` (1920×1080): 12 small credited thumbnails of real screenshots I fetched today, plus a text-only row for Fight Night Champion. Full URLs are in §9.

| Game · screen (frame) | Background: still or animated | Transition I could confirm | Fits FightCamp? |
|---|---|---|---|
| **Hollywood Animal** · studio lot hub (Steam ss 00) [S] | A lit 2.5D studio lot as the hub itself, with panels on top. Live in game [P, judged from stills + store listing]. | Not observable in stills. The operator's sheet asks for its "animated video fadeouts" [S operator sheet]. | **Yes, core.** The place *is* the menu. Our gym plays the same role: hotspots on the gym picture (Direction A hub). |
| **Hollywood Animal** · cast / filler cards (ss 05) and operator sheet [S] | Cards over the lot. Chamfered brass frames, portraits, pill tags, green film card "LIMPIN' LUKE $431,000", brass date plate "18 JAN 1929" with chevron pause/play/fast buttons. | — | **Yes.** Source of A's frames, cards and date bar. |
| **Hollywood Animal** · lot at night + department panel (ss 11) [S] | Same lot relit for night. | — | **Yes.** Cheap mood change: one illustration, two gradings (A uses this for day/fight-night). |
| **Motorsport Manager** · HQ/car screen (ss 00) [S] | A 3D garage behind the UI. Steam discussion confirms a Bink intro, `AttractIntro.bk2`, an FMV with voice-over before the menu [S]. | Video intro, then menu. | **Yes in spirit.** A dense data UI over a real-feeling place. We can't do live 3D in the menu on our budget, so we use stills. |
| **EA UFC 5** · main menu (Sherman Tam portfolio) [S] | A vertical text list at left over a 3D fighter and an arena screen. | — | **Partly.** Left list + hero figure = our title layout (A, B). 3D is out of budget. |
| **EA UFC 5** · career hub (same source) [S] | Tiles over a 3D fighter in a gym. The same portfolio shows a "Fight Week" camp screen [S]. | — | **Yes.** A fight-camp-to-fight-week flow is the same arc as ours. |
| **Creed: Rise to Glory** · stage intro (gameuidatabase scrn 65233) [S] | Still black title card: "DELPHI GYM / 5 MONTHS BEFORE UNDERGROUND CHAMPIONSHIP". Character intro 65239 shows "AXEL RAMIREZ 35-25-3, 22 wins by knockout" [S]. | Card, then scene. | **Yes, direct precedent** for the "how hard to get here" beat: time before the fight + record on screen. |
| **FIFA 20** · title screen (gameuidatabase scrn 8907) [S] | Key art: hero player + big logo. The mode select (8830) is a tile hub [S]. | — | **Partly.** Hero + logo title is safe but generic. Tiles = Direction C. |
| **Undisputed** · walkout with pyro (Steam ss 00) [S] | In-engine cinematic walkout. | — | **Mood only.** We do the walkout as a still + lower third (beat 3). |
| **Football Manager 26** · home/portal (Steam ss 09) [S] | Still UI, tile portal, little illustration. | — | **Structure yes, look no.** The dense home is good; the empty flat panels are what the operator complained about. |
| **Punch Club 2: Fast Forward** · city map hub (Steam ss 06) [S] | Pixel-art city, lightly animated. | — | **No for look** (pixel art); **yes for idea:** the "map as menu" is the gym-hotspot idea again. |
| **WWE 2K24** · entrance showcase (Steam ss 02) [S] | In-engine cinematic entrance. | — | **Mood only**, same as Undisputed. |
| **Fight Night Champion** (no frame fetched) [S text] | futurefive.co.nz: the game boots straight into a hazy knockdown, with no menu first (cold open). gamingbolt: ESPN-style ticker in the menus. Manual: "Legacy Central" hub. | Cold open. | **Idea only:** the ticker = our "On the wire" strip. Not on the board as an image because I didn't fetch a frame. |

What the board says [P]: the games that feel "buyable" all put **a place or a person behind the UI** (lot, garage, gym, fighter) and keep **one hero** per screen. The cheap ones (FM, the old FightCamp look) show equal flat panels. Transitions I could verify are *intros* (MM's Bink FMV, FNC's cold open, Creed's title card). Inside menus I couldn't see motion in stills, so every duration in §5 is my proposal.

---

## 2. Still vs animated, per screen (tiny budget)

| Screen | Treatment | Why | Cost [P] |
|---|---|---|---|
| Boot / studio logo | Still logo, cut in; 400 ms dissolve to title | Nothing to animate | ~0 |
| Title | **High-res still** (gym at dawn or night) + **parallax 2 layers** (foreground ropes/bag drift ≤ 12 px over ~20 s, ping-pong, eased) + dust motes (≤ 40 particles, GPUParticles2D) + one light shaft (additive sprite, static) | Reads as alive without an animator. HA/MM depth for free. | 1 illustration split in 2–3 layers; Godot built-ins |
| Optional attract/intro video | 20–30 s, skippable, **only if** we ever get the budget (MM precedent) | Nice to have, not needed | High; defer |
| Home hub | **Still** gym illustration (A: fills the stage; C/D: blurred behind glass). Dust only. Hotspot pins static; they react on hover. | Data screen: motion competes with reading | 1 illustration (can be the title one, re-graded) |
| Other hub tabs | Same still, re-framed/blurred; no new art per tab at first | Budget | 0 |
| Fight-night beats | **Stills** per beat + one live layer each: announcement (none), weigh-in (camera flash = single 120 ms brighten, not a loop), walkout (tunnel dust + slow push-in 2 %), ring intro (crowd foreground parallax), bell (one ring expansion, 240 ms) | This is the "hype": motion is earned here | 3 illustrations (tunnel, weigh-in stage, arena) + reuse of portraits |
| Fight | existing game | — | — |

**Answer:** AI-assisted stills (or renders of a bought/owned 3D scene) + subtle parallax/particle layers. Not frame-by-frame 2D animation: for a tiny budget it costs far more and can look cheap when underfunded [P]. Rendering our own stills from the owned Marpa MMA Arena and a bought Blender gym scene gives stills we fully control, with clean terms (§6) [P].

---

## 3. The four directions

All four show the same EXAMPLE save (Harbour Street Boxing Club, Lisbon, Mon 12 Oct 2026, Week 41, $24,180, four fighters, Vance vs Ardanza in 12 days). Each fixes the operator's complaints: no equal grey panels (one hero per screen), no long uppercase dev captions (sentence case, tiny caps labels only), no monospace (Inter tabular figures), portraits instead of initials, no empty slots (the space fills with illustration), and no bare numbers (every number has a unit, a label or a comparison: "67.9 kg · limit 66.7 · 1.2 kg to cut"). State always carries an icon + words, never colour alone.

### A — Brass & leather *(favourite)* · `M34_A_brass_title.png`, `M34_A_brass_hub.png`

- **Look:** closest to Hollywood Animal. Warm gym picture fills the screen, and brass art-deco chamfered frames sit on top.
- **Palette [P]:** ground #15100c, panel #2a2019, brass #c9a15a / highlight #ecd29a, text #f6eddc, main action gold #f0c233 with ink #1b1207 text, go green #4fc46a, gym tint teal #2f8a8f / #7fd0cf (club badge, selected tab).
- **Type:** Inter for everything; display = **Big Shoulders Display** (OFL, *proposal*), ≥ 44 px once per screen (FIGHTCAMP logo; fighter names on cards are a second use, a deliberate exception to discuss).
- **Background:** the gym illustration, graded warm, vignette, dust, one light shaft. On the hub the picture *is* the menu: pins for The ring, Office, Staff room, Weights, each with a one-line state ("2 sparring rounds today", "Worn bench · 72 %"). HA-style tutorial coach-mark "This is your gym… Tip 1 of 4".
- **Buttons:** chamfered plates; main action = gold gradient + one diagonal sheen on hover/focus; secondary = dark leather with brass hairline.
- **Cards:** HA cast cards: portrait top, weight class in small caps, name in display face, record right-aligned, condition bar, one status line with icon.
- **Date/time bar:** HA brass plate top-centre: sun glyph, "Mon 12 Oct 2026", "Week 41", then the green **Continue** chevron ("to Tue") as the plate's end.
- **Maps back to M32/M33:** GOOD/AMBER/BAD/gold-for-one-action are kept; GROUND/PANEL become warm browns; Inter sizes 15/18/22/30/44 kept; 3 surfaces (stage picture, frames, cards) + 1 hero (next-fight card).
- **Pros:** most "buyable" at first glance; the gym is visible and alive; the HA reference is literal. **Cons:** busy; brass on photo needs careful contrast; hotspots need the gym art to stay in sync with the gym state.
- **Self-attack:** the pins sit on a picture that doesn't change when you upgrade the gym, so it could feel like a lie. Fix: 3–4 gym-tier variants, or small overlay props. Two display uses on the hub break the once-per-screen rule. Brass everywhere risks "casino".
- **Cost to build [P]:** medium. 9-slice chamfer frame (3 sizes), gold/leather buttons, sheen shader (tiny), date plate, card scene; 1–3 gym illustrations; a hotspot system (code: Claude).

### B — Fight poster · `M34_B_poster_title.png`, `M34_B_poster_hub.png`

- **Look:** old boxing bill posters: cream paper, black ink, one red, halftone portraits.
- **Palette [P]:** paper #efe6d2, ink #17130f, poster red #c7372f, main action yellow-gold strip, green Continue.
- **Type:** **Anton** display (OFL, *proposal*) + Inter.
- **Background:** dark desaturated gym photo; the UI is paper sheets pinned on top. The title is a full poster: halftone red portrait, FIGHTCAMP, "Run the gym · Build the fighter · Make the walk" (EXAMPLE).
- **Buttons:** flat paper/ink strips with a red underline for focus; the sheen is a thin light glint across the gold strip.
- **Cards:** trading-card roster (halftone portrait, name, record in red, weight class, condition, status line).
- **Date/time bar:** ticket stub (perforated edge) with the green Continue next to it.
- **Maps back:** a light theme is a big departure from M32's dark ground. Semantic colours kept; red must not read as "bad" (BAD is paired with icons).
- **Pros:** most distinctive and ownable; the halftone hides portrait-source inconsistencies. **Cons:** cream surfaces are tiring over long sessions; red brand colour clashes with BAD red; hardest to extend to data-heavy tabs.
- **Self-attack:** it looks like a boxing *history* game, not a modern MMA/boxing management game. The cream "Today" list gets gray and flat, the thing the operator hates, as soon as it's long.
- **Cost:** medium-high. Halftone shader or pre-baked portraits, paper textures, a second (light) token set for every widget.

### C — Arena night · `M34_C_arena_title.png`, `M34_C_arena_hub.png`

- **Look:** Motorsport Manager / modern EA sports: cool steel, frosted glass over a blurred gym, cyan accent.
- **Palette [P]:** ground #0d1420, glass panels ≈ #1a2434 at 80 % with background blur, cyan gym tint #39b6dc, text #eef3fa, gold for the one action, green Continue.
- **Type:** **Barlow Condensed** SemiBold/Bold display (OFL, *proposal*) + Inter.
- **Background:** the gym picture blurred behind glass; on the title, a large fighter portrait blended into the right half.
- **Buttons:** title = row of tiles (Last save card with portrait + Continue, New career, Load, Settings, Quit), cyan underline on focus; sheen = a soft glass highlight on hover.
- **Cards:** landscape roster cards: portrait left, condition bar, status line.
- **Date/time bar:** full-width header strip: club badge + name, cash, date with sun glyph, green Continue ("1 day").
- **Hub hero:** wide next-fight card + a **fight-camp weight line chart** (W1–W6, limit line, "1.2 kg to cut in 11 days").
- **Maps back:** closest to M32 structure; GROUND/PANEL just get cooler and glassier. Tokens map almost 1:1.
- **Pros:** reads "modern sports game"; easy to build in Godot (StyleBoxFlat + a blur shader); data-friendly. **Cons:** least distinctive (many games look like this); blur costs GPU on low-end machines.
- **Self-attack:** MM's charm is its busy place, and C mostly throws the place away behind blur. Without good art, C slides back to "grey-blue panels".
- **Cost:** low-medium.

### D — Six A.M. · `M34_D_sixam_title.png`, `M34_D_sixam_hub.png`

- **Look:** today's M32/M33 tokens **exactly** (GROUND #1c2230, PANEL #2a3347, TEXT #f3f5fa…, gold for the one action, Continue = INK on green), but illustrated: a dawn-lit gym behind the title, a blurred office desk behind the hub.
- **Type:** the repo display file (Oswald Bold, file name says Bebas) + Inter.
- **Hub:** M32 THE DAY layout: 7-day strip where *shapes* mark events, the Continue unit, a next-fight hero with 4 fact tiles, Needs you, roster rows with portraits, On the wire with a picture, a "Your gym" picture card at the foot of the rail.
- **Pros:** cheapest (tokens and layout already specified in M32); the smallest change for Claude. **Cons:** least "wow"; closest to the look the operator already called flat.
- **Self-attack:** the illustration is only a backdrop; the panels are still equal-ish rectangles. It's an improvement, not a pitch.
- **Cost:** low.

### Direction comparison

| | A Brass & leather | B Fight poster | C Arena night | D Six A.M. |
|---|---|---|---|---|
| Family | Hollywood Animal | vintage bill poster (HA cards) | Motorsport Manager / EA | M32 illustrated |
| Display face (proposal) | Big Shoulders Display | Anton | Barlow Condensed | Oswald Bold (in repo) |
| Background | gym picture *is* the hub | dark photo under paper | blurred gym behind glass | dawn gym / blurred desk |
| Sheen | gold plate, diagonal, once | glint on gold strip, once | glass highlight, once | gold, once |
| Date bar | HA brass plate + chevron Continue | ticket stub | header strip | M32 7-day strip |
| Wow / cost | high / medium | high / med-high | medium / low-med | low / low |

---

## 4. Fight-night hype storyboard (styled in Direction A)

Files: `M34_story_1_announcement.png` … `M34_story_5_bell.png` (1920×1080) + `M34_story_contact_strip.png` (1920×560, with the transition between beats). All numbers EXAMPLE. No blood anywhere (blood stays at doctor/stoppage).

| Beat | What's on screen | "How hard it was" on screen | Live layer [P] |
|---|---|---|---|
| 1 Announcement ("The fight is made · 6 weeks out") | Split portraits with a brass diagonal, VANCE vs ARDANZA, 11–2 vs 14–1 (ranked #6), "Welterweight · 10 rounds · Co-main event · Dockside Hall · Sat 24 Oct". "The road here" timeline: Debut Mar 2025 → First KO → First loss (✕ icon + word) → Regional title → Dockside Hall Oct 2026. Gold "Start fight camp". | "19 months · 13 fights · 2 losses"; "Weight today 72.4 kg · limit 66.7 kg" | none (still) |
| 2 Weigh-in faceoff ("Official weigh-in · Fri 23 Oct · limit 66.7 kg") | Both fighters, weight plates 66.4 kg / 66.6 kg, each with ✓ "Made weight". Six week tiles: Base, Strength, Sparring, Sparring, The cut, Taper, with the weight per week. Week 4 shows an amber ⚠ "rib bruise · 2 days off". | "72.4 → 66.4 kg · 6.0 kg cut · 212 rounds sparred" | single camera-flash brighten (120 ms), not a loop |
| 3 Walkout | Procedural tunnel toward a bright doorway, the fighter hooded from behind with two cornermen, rim light. Brass lower third: portrait, "Walking out · Red corner", DARIO VANCE, "11–2 (7 KO) · Harbour Street BC · coach Sam Okafor". "On the line tonight": Win → regional #5, $6,500 purse · $1,300 win bonus, gym sold 212 tickets. | "Debut to Dockside Hall: 19 months" | dust in the light, 2 % push-in |
| 4 Ring intro | The gym picture relit as the hall, spotlight, crowd heads foreground. "Tale of the tape": age, height, reach, record, knockouts, **fight camp (6 vs 8 weeks)**, **weigh-in**. | camp weeks and weigh-in rows | crowd foreground parallax |
| 5 Bell | Brass bell on a wooden plaque, one static ring arc. "ROUND 1", "Six weeks. 6.0 kg. Nineteen months. Now it's three minutes." Plan + corner lines, "Skip intro: Space · Fight starts on its own after the bell". | the whole sentence | one ring expansion on the bell sound, then cut |

Precedent: Creed's "5 months before…" card and the "35-25-3, 22 wins by knockout" intro [S]; UFC 5's "Fight Week" [S].
Honest limits: the weigh-in "faceoff" uses front-facing portraits (the repo has no profile/face-to-face art). The walkout figures and bell are procedural placeholders for real illustrations.

---

## 5. Transition spec

M32 timings kept: 100 / 150 / 160 / 200 / 240 ms. New: **360 ms** and **400 ms**, only for the cinematic moments (amendment).

| Screen change | Type | Duration | Easing | Status |
|---|---|---|---|---|
| Boot → studio logo | hard cut in | 0 | — | M32 |
| Logo → title | **cross-dissolve** (logo out while title art comes up); parallax + dust start after | 400 ms | ease-in-out (cubic) | **Amendment** (whole-screen dissolve) |
| Title → hub | **brass wipe**: a vertical chamfered brass bar sweeps left→right, revealing the hub behind it; title menu slides out 24 px | 360 ms | emphasized decelerate (cubic-bezier 0.05, 0.7, 0.1, 1) | **Amendment** |
| Hub tab → tab | shell (rail, date bar, cash) stays still; content slides 32 px + fades in, old content fades out | 240 ms in / 160 ms out | decelerate in / accelerate out | M32 |
| Card / drawer open (fighter, offer) | slide from the right edge 48 px | 200 ms | decelerate | M32 |
| Selection change (rail, list row) | highlight moves | 160 ms | ease-out | M32 |
| Hover / focus | button lift 2 px + tint | 100 ms in / 150 ms out | ease-out | M32 |
| Button sheen | one diagonal sweep on hover/focus enter; never repeats until the pointer leaves and comes back | ~600 ms | ease-in-out | new, once only (no loop) |
| Hub → fight night (beat 1) | **brass wipe** (same as title→hub) | 360 ms | emphasized decelerate | **Amendment** |
| Beat 1 → 2 → 3 | **dissolve** | 400 ms | ease-in-out | **Amendment**, skippable |
| Beat 3 → 4 | **light bloom**: the doorway light grows to fill the screen, then settles into the arena | 400 ms | ease-in then ease-out | **Amendment**, skippable; peak brightness capped (no white flash) |
| Beat 4 → 5 | cut on the bell sound | 0 | — | — |
| Bell → fight | **hard cut on the bell sound** + one brass ring expanding from the bell (not flashing) | 240 ms ring | decelerate | M32 range |
| Back (any hub drawer/tab) | reverse slide | 240 ms | accelerate | M32 |
| Fight-night skip (Space/Esc) | jump to beat 5 (or fight) with a 160 ms slide | 160 ms | ease-out | M32 |

Rules: no continuous pulse anywhere; no looping sheen; no state shown by colour alone (icons + words); dissolves/wipes **only** in the rows marked Amendment; "Reduce motion" setting turns all 360/400 ms moments into 160 ms cuts and removes parallax/dust [P].

---

## 6. Buyable assets survey (pages read 2026-09-25)

| Candidate | Link | Price (as read) | Licence | Contents | Look-fit to MM/HA |
|---|---|---|---|---|---|
| ArtStation · **MMA/Boxing Gym Asset Pack Vol.1** (PixelPress) | artstation.com/marketplace/p/vw8wn | **$24.99 = Personal/Standard**; **$49.99 = Commercial (Extended)** | Commercial needs the $49.99 tier | UE 5–5.5 project; "56 assets" = 28 unique meshes, 90 textures (4K clamped to 2K); **3D, not 2D UI** | Low for UI; OK as a render source if we have Unreal. **Corrects the first pass:** $24.99 is not the commercial price. |
| ArtStation · **Boxing Gym – Blender Scene** (MikyMiky) | artstation.com/marketplace/p/JmNkB | $24.99, Standard License | Commercial scope of "Standard" **NOT VERIFIED** | .blend, Cycles, 83 objects, 2K textures, volumetric light, mural walls | **High for backgrounds**: render our own title/hub stills |
| ArtStation · PBR Boxing Ring A/B (Suresh Maya) | artstation marketplace | from $10 | NOT VERIFIED | 3D ring | Low |
| GraphicRiver · **Ultimate Boxing Game Assets** (codethislab) | graphicriver.net/item/…/13344661 | $13 Regular | Regular = "a single end product which end users are not charged for", so a **paid game needs Extended** (price NOT VERIFIED) | 2015, 1380×1920 portrait, layered, cartoony | Poor |
| itch.io · GUI tag (top rated) | itch.io/game-assets/tag-gui | various | various | Almost all pixel art | Poor |
| itch.io · **Super Fight — Wrestling Arena GUI Kit** (auragamestudio) | itch.io | $3.15 | **Licence not stated on page** | 155 PNGs + 6 mockups + vector source, "engine-agnostic", chrome/neon | Low (neon arcade) |
| itch.io · **Nexelume Sports Broadcast & Scoreboard UI** | itch.io | $9.99 | Commercial end-product use, no attribution; **page says generative AI was used** | SVG/PNG, dark/light, 28 screens at 1920×1080, 96 icons | Medium for broadcast lower-thirds / fight-night HUD |
| Layer Lab · **GUI Pro – Minimal Game Dark** (Layer Store) | layerlab.io/products/gui-pro-minimal-game-dark | **$49 (30 % sale; regular $69.99)** | 5 seats; "Unity/Godot package" + Godot guide | 1080×1920 portrait, read-only PSD, 652 icons, 584 prefabs, 430 sprites | Low (casual/minimal) |
| Same, on **GameDev Market** | gamedevmarket.net/asset/gui-pro-minimal-game-dark | $70 | "Commercial use, Unlimited projects, Royalty free" | 9-slice notes | Low |
| Same, on **Unity Asset Store** | assetstore.unity.com/packages/2d/gui/gui-pro-minimal-game-dark-358058 | $69.99 | **Single Entity** (rendered page) | 198.5 MB, May 26 2026 | Low |
| GDM other Layer Lab | gamedevmarket.net | Fantasy Hero $50, The Stone $25, Casual Blue $50, Pro Casual $40, Mono Round $15 | GDM licence | GUI kits | Low (fantasy/casual) |
| Unity · **Heat – Complete Modern UI** (Michsky) | Unity Asset Store | $69.99 (v1.1.8, May 13 2026) | **Single Entity** on the rendered page; **contradicts the brief** ("Extension"). Still a UGUI code system | Unity prefabs/scripts | Rejected: code system + look |
| Unity · Dark UI Kit | Unity | $19.99 | **Extension Asset**, cannot ship in Godot | — | — |
| Unity · Modern UI Kit Dark & Light | Unity | $4.99 | Single Entity | — | Low |
| Unity · RPG UI Kit Dark Realm | Unity | $9.99 (Jun 10 2026) | Single Entity | — | Low (fantasy) |
| Unity · GUI Pro Minimal Blue / Light | Unity | $69.99 each | Single Entity | — | Low |
| Unity · GUI Pro Minimal Dark (+PSD) | Unity | $2,099.99 | Single Entity | layered PSD | Low; absurd price for us |
| Unity · OBSIDIAN UI | Unity | $39.99 (2021) | Single Entity | — | Low-medium (dark premium) |
| Unity · Mech Car Combat UI Kit | Unity | $14.99 | Single Entity | — | Low |
| Unity · Soccer Football UI Icons | Unity | $19.99 | Single Entity | icons | Low |
| Unity · GUI Pro Casual Game | Unity | $19.99 | Single Entity | — | Poor |
| Humble Bundle (software, today) | humblebundle.com/software | — | — | Only Synty/3D/audio/Unreal/Godot-course bundles | None fit |
| OFL display fonts (Big Shoulders Display, Anton, Barlow Condensed, Oswald) | github.com/google/fonts | $0 | SIL OFL 1.1 (licence files kept in `_src/fonts/`) | TTF | High |
| Paid foundries | — | NOT VERIFIED (not checked) | — | — | — |
| **Owned:** Marpa **MMA Arena** | Unity cache on Beast (read-only) + repo ASSET_REPORT_2026-09-20 | owned | Unity Asset Store EULA; standing project rule = non-Extension art may be used in Godot [J] | 452.9 MB, 31 FBX/PNG meshes (OctagonCage etc.) | **High for fight-night venue renders** |
| Owned: Poly Ronin Old-School Gym | same | owned | as above | gym props | Medium (render source) |
| Owned: Magicpot Fighting Motions, RamsterZ Full Mount / Hand to Hand | same | owned | as above | animations | n/a for front end |
| Owned: SlimUI 3D Modern Menu UI | same | owned | code asset | Unity menu system | **Rejected** (code, Unity-only) |

Unity licence types above come from pages **rendered in a real browser**. The server-side HTML of Unity pages showed "Extension Asset" even for a plain 3D art pack, so that HTML is not trustworthy. Unity EULA (unity.com/legal/as-terms, updated Dec 4 2024) §2.3.2 defines Extension Assets as Editor Extension / Scripting / Services, per seat on ≤ 2 computers. I found no engine clause in a keyword search, so "non-Extension art may ship in Godot" stays the project's rule [J], not something I verified.

**Plainly: no Unity 2D GUI pack (or any store GUI pack I read) fits the MM/HA brass-and-leather or premium sports-management look.** The frames and buttons should be ours.

### Top 5 (by gap closed)

1. **Blender "Boxing Gym" scene, $24.99** → **illustrated backgrounds** (title + hub). Render at 4K, paint over/grade. *Verify the commercial scope of "Standard License" before buying.*
2. **Owned Marpa MMA Arena** (+ Poly Ronin gym) → **fight-night venue and walkout stills**. Already paid; renders port.
3. **OFL display fonts ($0)** → **display font** for the picked direction (Big Shoulders / Anton / Barlow Condensed).
4. **Nexelume Sports Broadcast UI, $9.99** → **fight-night lower-thirds/HUD bits and icons**, as a starting point only (AI-disclosed; re-draw in our style).
5. **Layer Lab GUI Pro Minimal Dark via Layer Store ($49 sale) or GDM ($70)** → **9-slice button/frame construction reference** only. Low look-fit; buy only if Claude wants a Godot-ready 9-slice example. Otherwise skip.

**Portraits:** no store item closes this gap. Commission a portrait set, or re-generate with recorded tool + terms. The current repo portraits' provenance is not recorded. **Frames/buttons:** draw ourselves from Direction A (a few hours of art: 3 chamfer 9-slices, 2 button states + sheen mask, date plate).

---

## 7. Never-list additions

- Never loop the sheen; never pulse anything.
- Never use whole-screen fades or dissolves outside the four Amendment rows in §5.
- Never put a number on screen without a unit, label or comparison.
- Never show initials where a portrait should be; never leave an empty dark slot (fill it with illustration or a clear "nobody here yet" card with an action).
- Never use real fighters, real promotions, real venues or real brands in art or words (the repo gym art has fictional "TEAM GOALS"/hex-logo signage and the office art says "IRON LEGACY MMA"; both fictional, but the "MAY 2024" calendar should be repainted).
- Never ship a picture whose generator and terms aren't recorded.
- Never ship Unity Extension Assets or Unity code assets (SlimUI, Heat) in the Godot build.
- Never call the building "camp": it's "the gym". "Fight camp" means the training block only (Kalli to confirm).
- Never show blood before the doctor/stoppage screens, including in hype art.

---

## 8. Self-attack

- **The mocks lean on portraits I can't vouch for.** The repo AI portraits make every mock look finished. Without them A and C lose most of their appeal. Real cost = portraits.
- **A is the prettiest but the most fragile:** brass-on-photo contrast, hotspots tied to one gym picture, and two display uses on the hub.
- **I couldn't generate new art** (no working image tool), so walkout, bell and crowd are procedural. They show composition, not final quality. The operator should judge beats 3 and 5 on layout.
- **The transitions are proposals.** I verified intros (MM FMV, FNC cold open, Creed card) but not in-menu motion in any reference, so the 360/400 ms numbers are my taste, not measured.
- **B may be the one the operator remembers,** and I ranked it third. A light theme is a bigger build than I can honestly call "medium".
- **Four directions may be too many.** If the operator wants speed: A vs C.
- **The storyboard might be too long** for players who've seen it 30 times. It needs skip (Space) from the first frame, and a "short version" after the first few fights [P].
- **Budget:** even "stills + parallax" needs ~5–7 finished illustrations (title, hub gym ×1–3 tiers, weigh-in stage, tunnel, arena). That's the real spend.

---

## 9. Sources (all fetched 2026-09-25)

Reference frames (on the board):
- Hollywood Animal, Steam app 2680550: ss 00 https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2680550/4e38f7376a10b9029c1d40c7d8c1da64eaf805fe/ss_4e38f7376a10b9029c1d40c7d8c1da64eaf805fe.1920x1080.jpg · ss 05 https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2680550/ss_d5b03dfd9e01a60812c6297031815884421a9745.1920x1080.jpg · ss 11 https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2680550/ss_29edbeee60c930cd5d81a106139dc2d583f7ce58.1920x1080.jpg (store: released Apr 10 2025, $19.99)
- Motorsport Manager, Steam 415200, ss 00: https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/415200/ss_cfa613ab902191e4c167aeb5741b38a89d12e626.1920x1080.jpg · intro files: https://steamcommunity.com/app/415200/discussions/0/208684375410837812/
- EA UFC 5 (Sherman Tam portfolio): https://www.shermantam.com/projects/ufc-5 · images: https://images.squarespace-cdn.com/content/v1/63cddc5d19faa63fa52a539e/bf91af72-7298-4ed5-878a-62f3e2b10d63/MainMenu_example.png · https://images.squarespace-cdn.com/content/v1/63cddc5d19faa63fa52a539e/8de763c7-d102-4f7a-b4f7-583db6bdb030/ufc5_careerhub_example.png · https://images.squarespace-cdn.com/content/v1/63cddc5d19faa63fa52a539e/ed7abb8c-92b9-4c8c-9613-06077b9fe372/ufc5_careerhub_trainingcamp.png
- Creed: Rise to Glory (Game UI Database, game 1671): stage intro https://www.gameuidatabase.com/uploads/Creed-Rise-to-Glory01152023-010415-4860.jpg · character intro https://www.gameuidatabase.com/uploads/Creed-Rise-to-Glory01152023-010416-92265.jpg · main menu https://www.gameuidatabase.com/uploads/Creed-Rise-to-Glory01152023-010413-30177.jpg
- FIFA 20 (Game UI Database, game 178): title https://www.gameuidatabase.com/uploads/FIFA-2007192020-080631-75926.jpg
- Undisputed, Steam 1451190, ss 00: https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/1451190/ss_67a2f6b6c5e344bec65117190cc4744930d40634.1920x1080.jpg
- Football Manager 26, Steam 3551340, ss 09: https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/3551340/0f9eb2837c5e2dbf514156ebdad8a3c5894ab611/ss_0f9eb2837c5e2dbf514156ebdad8a3c5894ab611.1920x1080.jpg
- Punch Club 2: Fast Forward, Steam 1161590, ss 06: https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/1161590/ss_7687b504b328f094c5b250d6465f15f124718c96.1920x1080.jpg
- WWE 2K24, Steam 2315690, ss 02: https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2315690/ss_81e9d8ebeddac03d15ec5197564714af400f0b5b.1920x1080.jpg
- Fight Night Champion (text only): futurefive.co.nz review; gamingbolt review; game manual on docslib.
- Operator sheet: `research/refs/operator_hollywood_animal_2026-09-25.png` (Beast, read-only copy).

Assets: https://www.artstation.com/marketplace/p/vw8wn/mma-boxing-gym-asset-pack-vol-1 · https://www.artstation.com/marketplace/p/JmNkB/boxing-gym-blender-scene · https://graphicriver.net/item/ultimate-boxing-game-assets/13344661 · https://itch.io/game-assets/tag-gui · https://layerlab.io/products/gui-pro-minimal-game-dark · https://gamedevmarket.net/asset/gui-pro-minimal-game-dark · https://assetstore.unity.com/packages/2d/gui/gui-pro-minimal-game-dark-358058 · https://unity.com/legal/as-terms · https://www.humblebundle.com/software · https://github.com/google/fonts (OFL faces) · Lucide 1.48.0 (ISC).

Project: M32_MENU_ART_DIRECTION.md, M33_ICONS_AND_TYPE.md [J]; repo `research/TASK_J54_MENU_ARCHITECTURE_SURVEY.md`; `ASSET_REPORT_2026-09-20`; Beast `%APPDATA%/Unity/Asset Store-5.x` (listing only).

---

## 10. Honesty flags

1. **No new AI images were generated.** There is no GenerateImage tool in my session. Wonder's `generate_image` refused (account not registered). Figma Weave refused (account not linked). Every picture is either an **existing repo AI image** (`Godot/assets/images/`: gym_environment, office_overview, office_calendar, splash_fighter, athletes/generated male_01–03 and female_01–02, fallback/striker) or procedural Pillow drawing. All are labelled "MOCK ART — AI (existing repo image)" on the mocks.
2. **Repo image provenance is NOT RECORDED** (generator, prompt, terms); the images are unreferenced by code. The portraits are realistic faces of fictional people as far as I know. I can't prove they resemble no one.
3. The gym art contains fictional "TEAM GOALS", "BUILT DAILY · EARNED FOREVER" and hex-logo signage; the office art contains fictional "IRON LEGACY MMA" and "MAY 2024".
4. **J54 IA doesn't exist yet**; I used today's 8 rail items.
5. **Heat (Michsky) shows "Single Entity", not "Extension Asset"**, on the rendered Unity page. This contradicts the brief. It's still rejected (Unity UGUI code + look).
6. **Unity server HTML mislabels licence types**; I trusted only browser-rendered pages.
7. **NOT VERIFIED:** GraphicRiver Extended price; ArtStation Standard License commercial scope; Super Fight licence (not stated); paid foundry prices; Unity's engine-portability of non-Extension art (project rule, not checked in the EULA text beyond a keyword search). The GameDev Market GUI category grid would not render, so I read individual product pages only.
8. **Fight Night Champion:** no frame fetched; text sources only.
9. Motion labels on the reference board are judged from stills except MM's intro (source-confirmed).
10. **Icons:** `icons/` holds 52 Lucide SVGs: the 24 from M33 plus **28 new in M34** (Lucide 1.48.0, ISC): arrow-right, bell, calendar, chevron-right, chevrons-right, clock, fast-forward, flag, flame, folder-open, footprints, house, landmark, log-out, mail, map-pin, megaphone, mic, pause, play, plus, scale, settings, star, sun, swords, timer, trophy. These are new chrome icons and need M33-style review before use.
11. **Display faces per direction are proposals.** The repo file `BebasNeue-Regular.ttf` is Oswald Bold.
12. Every word on the mocks and storyboard that isn't already in the game is EXAMPLE (names, gym, numbers, tagline "Run the gym. Build the fighter. Make the walk.", "Tip 1 of 4", the bell line…). Kalli owns words.
13. Walkout figures, crowd, tunnel and bell are procedural stand-ins, not final illustrations.
14. Nothing was written on Beast; no .gd/.tscn/HANDOFF.md edits, no commits, no pushes; nothing delivered.

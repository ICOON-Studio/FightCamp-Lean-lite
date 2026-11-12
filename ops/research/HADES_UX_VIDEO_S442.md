# Hades-style menus: what one video teaches us (S442)

Source: YouTube DExN9-pZ1ks, "the secret formula for making great main menus!", channel Oliver Age 24,
10 min 49 s (649 s), 720p. Watched in full: transcript for all 10:49 (faster-whisper base.en, local), 100 evenly
spaced frames (one every 6.5 s), 1 frame a second for 6:15-6:49 (Dead Cells and Hades), one every 2 s for
9:00-10:34, and every single frame (30 fps) of two Hades hover moments to time them. Work files stay in
E:\FightCamp\tmp\hades_video (not in the repo).

IMPORTANT: the moment he linked (t=565 s = 9:25) is NOT the Hades part. At 9:25 the presenter is on a patterned
background saying these are favourite games and he is only nitpicking ("please forgive me" bubble). The Hades
part is **6:25-6:48**. The idea behind the hover labels comes back as the last line of the closing recipe at
**10:20-10:24**: hide what the player does not need until he needs it. Both are covered below.

## 1. The video in five lines
- A solo/small-team developer reviews the title menus of seven indie games (Wildfrost, Hollow Knight, Dome Keeper,
  Dead Cells, Hades, Celeste, Undertale) to pull out a recipe; parts 2-3 (building it in Unity) are other videos.
- The main menu is the front door: it sets the tone, should feel polished, and must get you playing fast.
- Three basics: it does everything needed (functional), needs no tutorial (intuitive), matches the game (thematic);
  break a rule only on purpose.
- Most of the craft is contrast and restraint: a few colours, the UI set apart from a busy background, one font
  family, the chosen button clearly lit, the main action bigger and grouped apart from the rest.
- Final recipe (9:51-10:24): limited palette, contrast UI vs background, consistent fonts and buttons, highlight the
  selection, put the most-used actions first, make the next step obvious, small animations, group logically,
  hide non-essentials until needed.

## 2. Every technique shown

| Technique | What happens on screen (time) | Why it works (per the video) | Where it fits in FightCamp | Risk for us |
|---|---|---|---|---|
| Three basics: functional, intuitive, thematic | Typed checklist card (2:36-2:55) | A menu that fails any one loses the player before the game | A check for every new screen next to "screen logic of the moment" | None; it is a checklist, not a feature |
| Break rules on purpose | Surgeon Simulator clip (3:15), horror vs ukulele joke (3:26) | Known rules can be bent if intentional | Our "serious sim" look: any playful break must be a choice | Using it to excuse clutter |
| Vertical stack of short, same-style buttons | Wildfrost Play/Settings/Credits/Exit, the hovered one lights white (4:07-4:33) | Readable and obvious at once | Every left-hand menu list (Home, Fighter page tabs) | Long stacks of 8+ items stop being glanceable |
| Limited palette matched to the game | "Palette" swatch pop-ups over Wildfrost, Hollow Knight, Dead Cells, Hades, Celeste, Undertale | Unity of look; nothing competes by colour | Our dark + wood/slate theme: one accent colour for "act here" | Too few colours can hide states (risk, injury) we need colour for |
| Contrast: UI vs background | Wildfrost outlines vs no outlines, light vs dark (4:27); Hollow Knight white text on dark (4:46) | The eye separates "things I can click" from scenery | Menus over the gym art and the HUD over the 3D ring | Bright arena lights behind white HUD text |
| Flat panels behind buttons on a noisy picture | Dome Keeper: flat purple button plates on a textured painting, labelled with arrows (5:12-5:18) | The noise of the art cannot eat the text | Every panel that sits on a painted gym/arena picture | Plates look "Excel-like" (his S416 note) unless styled as our wood/slate |
| Most-used actions grouped, rare ones to the side | Dome Keeper: New Game/Options/Quit centred low, Modding/Updates/Credits in a small side stack (5:18-5:25) | Follows what the player wants most often | Home: "Advance week", "Book fight" big and central; staff, records, settings off to a side rail | Players hunting for a moved item |
| Group what competes for attention | Dead Cells: DLC text in yellow, update banner, new-game news each pull the eye different ways (5:31-6:10); fix = put promos together on one side | One focal point per area | News/offers/mail on one card, not scattered over Home | Hiding a real alert in a "promo" corner |
| One font family | "THERE ARE 4 DIFFERENT FONTS" caption over Dead Cells (6:23-6:28) | Mixed fonts read as noise | Our theme: one display face + one body face, nothing else | Number fonts (tabular) still need their own style |
| Selected button highlight | Hollow Knight: small ornaments either side of the hovered item (4:39-4:59); Hades: gold text, dark brush stroke, emblem (6:33-6:38); Celeste: hovered word turns yellow (8:07) | You always know where you are | Every button and list row; keyboard focus too | A highlight style different on every screen |
| Logo glow matching the game's post-processing | Hollow Knight title glow, arrow "GLOW" (4:59) | Ties UI to the game's look | Title screen only (Halo.gd glow already exists) | Glow on body text kills legibility |
| Ambient movement | Snow particles (Wildfrost, Celeste), floating dust (Hollow Knight) | Life without stealing focus | Title and Home backgrounds (MenuFx.dust already) | Particles behind dense tables = distraction, CPU |
| Hover-to-reveal labels on secondary icons | Hades icon row (6:39-6:47): five grey icons, the hovered one turns white and a small-caps name appears under it | Keeps the screen tidy and clean | Utility rows (week tools, HUD chrome during a fight) | Detail in section 4 |
| Make the first prompt unmistakable | Celeste: a round "C" in the corner meant "press C"; he took it for a copyright mark and thought the game had frozen (6:49-7:48) | A key prompt that looks like a logo is invisible | Any "press to continue" / skip / speed-up prompt in the fight | Our icon-only buttons can fail exactly like this |
| Fixes for that prompt | Write "Press" beside it; make it look like a key (square); pulse it slowly; also accept Space/Enter (7:34-8:01) | Each removes the doubt | Prompts written as words + key cap; accept Enter/Space/click on every "continue" | None worth naming |
| Main action bigger and set apart | Celeste "CLIMB" on top, larger, the rest smaller below; colour cycling on the selected one (8:07-8:26) | The default action is obvious | "Advance week" / "Fight" bigger than everything else on its screen | Two "main" buttons on one screen cancels it |
| Minimal can still carry mood | Undertale: black screen, controls list, two options, yellow on select (8:33-9:05) | Restraint works if the style is strong | Our quiet screens (results, history) | He would move the instructions to their own screen |

## 3. The moment he pointed at, and the Hades moment itself

**9:25 (t=565):** no game is on screen. The presenter sits in front of a blue pattern of yellow squares and red
triangles, with a thought bubble "please forgive me lol" at 9:26-9:28; he says the games he picked apart are
favourites. At 9:38 a CRT shows "Chapter 4: the secret formula", and the typed recipe runs 9:51-10:24.

**The Hades menu (6:25-6:48), measured frame by frame at 30 fps:**
- Always visible: the HADES logo top left; three main words PLAY / OPTIONS / QUIT in white small caps on the left;
  a bottom-left row of five dim grey icons (Supergiant logo, Discord, envelope, music disc, shop bag); the version
  number top right. The main words are never hidden.
- Hidden: only the names of the five icons in the bottom row.
- On hover over an icon: the icon goes from dim grey to bright white and a small white small-caps word appears
  centred under it: WEB SITE, FEEDBACK, MAILING LIST, SOUNDTRACK, STORE. Both changes land in **one frame (under
  35 ms), no fade, no delay**. When the pointer leaves, both vanish in one frame, also with no fade. Moving from one
  icon to the next, there are about 0.2 s of gap where nothing is lit while the cursor crosses the empty space.
- On hover over a main word (PLAY etc.): the word turns gold and a small emblem appears to its left in the first
  frame; then a dark brush-stroke bar wipes in behind the word from left to right in about **0.15 s** (5 frames).
  On leaving, all of it disappears in one frame.
- The presenter says the hidden labels keep the screen tidy and clean, and he likes the flourish on the highlighted
  button.

## 4. Hover-to-reveal labels for FightCamp

Where it helps:
- Rows of small tools the player uses every week and already knows (week tools, sort/filter buttons, the gym's
  utility icons, the save/settings/help cluster). After a few weeks the words are clutter.
- HUD chrome over the 3D fight: camera, speed, replay, pause, show/hide stats. The fight is to be watched; words
  sitting on top of the picture cost view.
- Dense management screens where every row has the same 3-4 small action icons: the word appears on the row you
  point at, not on 20 rows at once.

Where it hurts:
- A first-time player: an icon with no word is a guess (the video's own Celeste story at 6:49 is exactly this).
- Primary actions (Advance week, Book fight, Accept offer, the corner's calls): they must be read without moving
  the mouse.
- Anything that must be read at a glance or under time pressure, which is the corner bar between rounds.
- Controller or touch: there is no hover. A controller needs focus to do the same job; touch needs words.
- Our own house rules: "words, not symbols" for the corner bar, "game words, not jargon", "graphics, not
  paragraphs". Hover labels serve the last one but can break the first two if used on the wrong buttons.

How "words, not symbols" and hover labels live together:
1. Primary actions always keep their words. The corner bar during a fight stays as he ruled: words, always shown.
2. Secondary chrome (utility icons, HUD view toggles, row actions) may hide the word, but only after the player has
   used that button: show the word for the first 3 uses (count per button in the settings/save), then hide it
   and reveal on hover. A new button arrives with its word.
3. A setting "Always show button labels" (default OFF, so the 3-use rule runs): the player who wants
   words forever turns it on; nobody is stranded.
4. Keyboard/controller focus reveals the label exactly like hover does.
5. The icon must already be readable on its own (shape + one colour), and the hidden word is the same word the
   full button would carry (no new names).

## 5. Ten lessons for FightCamp, most valuable first

1. **One main action per screen, bigger and apart.** On Home, the week button and on the fight offer the accept
   button get the largest Button (min 64 px high, our accent colour), placed alone; the rest in a smaller side
   VBoxContainer (Dome Keeper / Celeste pattern). Check every screen in the layout snapshot: exactly one.
2. **One highlight style everywhere, with a two-step hover.** A shared helper (in MenuFx.gd next to `hover_grow`):
   on `mouse_entered` and `focus_entered` set text colour to the accent and show a small emblem at once (0 s), then
   tween a dark plate's `scale:x` from 0 to 1 (pivot left) over 0.15 s, TRANS_QUAD EASE_OUT; on `mouse_exited` /
   `focus_exited` hide everything at once. Same on every list row and button.
3. **Hover-revealed labels for secondary icons only, with a learning period.** A small `IconLabelButton` (TextureButton
   + Label under it): icon `modulate` 0.55 grey at rest, 1.0 on hover; the Label's `visible` toggles instantly (no
   fade, like Hades) after a 0.05 s debounce so a passing cursor does not flicker. Label shown always until
   `uses >= 3` (stored per button id in the settings), and always while "Always show labels" is on. Never on the
   corner bar, never on the main action.
4. **Fight HUD chrome fades, the fight info stays.** In FightHud.gd: camera/speed/replay icons sit at
   `modulate:a` 0.35 and tween to 1.0 in 0.12 s when the pointer enters their strip (one Control with
   `mouse_entered` on the strip), back to 0.35 after 1.5 s idle. Score bug, round clock and the corner bar never fade.
5. **No prompt that can look like a logo.** Every "continue / skip / speed up" prompt is a key cap (square
   StyleBoxFlat, 2 px border) plus the word ("Space  Continue"), pulsing `scale` 1.0-1.06 over 1.2 s loops; and
   Enter, Space and left click all work (Celeste lesson).
6. **Flat plates under text on painted pictures.** Any Label/Button over gym or arena art sits on a plate (our wood
   or slate StyleBox, 85-90% opacity), never bare text on the painting (Dome Keeper). Add it to the shared theme so
   no screen forgets.
7. **Group what competes, one focal point per area.** Offers, news, mail and reminders on Home go into one card
   with one header, newest first; no yellow promo text sprinkled elsewhere (Dead Cells critique). Alerts that need
   action still go on the thing they act on (our "only actionable info" rule).
8. **One font family, counted.** Theme gets one display font and one body font; a test or the layout snapshot tool
   lists every font resource used by a screen and fails on a third (Dead Cells had four).
9. **Small ambient motion on calm screens only.** MenuFx.dust / slow art drift (already 26 s scale) on Title and
   Home; none behind tables, stat sheets or the fight HUD. Keep each under 1% CPU.
10. **Run the three-basics check on every screen before it reaches him.** Functional (every action the moment allows
    is here, nothing it does not allow), intuitive (a first-time player knows the next click without a tip),
    thematic (fits the serious-sim look). Add the three lines to the critic brief beside "screen logic of the
    moment".

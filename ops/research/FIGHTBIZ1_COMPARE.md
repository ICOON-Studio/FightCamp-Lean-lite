# FIGHTBIZ1 - The Fight Business demo read: its 2D fight, its 3D fight, its loop (S539)

Source: the installed demo (E:\SteamLibrary\...\The Fight Business Demo, Electron + React, demo 0.1.0, MMA, by Arkatee
Studios). Read-only: the script bundles, the style sheets and a few pictures were pulled out of resources/app.asar into
Claude's scratchpad and read there; a 12-week test career was played on the hidden desktop (one bout watched start to
finish in both views). Everything below is our own summary in our words and numbers; none of their code, text or art is in
the repo. Screenshots only, in ops/previews/s539_fightbiz/ (git-ignored, board only). Not repeated from MMAEMPIRE1_COMPARE.md.

Save note: the owner's own copy of the demo was open at the same time (started 04:28) and shares the save folder; my test
career overwrote save slot 1 for a few minutes. I restored his week-1 save ("Foundry MMA", Justin Sane) from a copy taken
before I started, checked its database hash, and his running game has since saved over it again with his own career. His
save is his; my test career sits in the scratchpad only.

## Top 5 for the owner

1. THEIR "2D FIGHT" IS PICTURES, NOT ANIMATION: about 60 painted pictures, both fighters in each (every punch, kick,
   knee and knockdown, landed and missed), popped in for about 1.1 s with a zoom, a streak and an impact burst. Cheap, readable.
2. IT IS ONLY THEIR BACKUP. The main view is 3D (Godot web export, plain blue/red mannequins with no faces, 59 bought
   MMA clips). The 2D shows only if the 3D fails; here the 3D ran, so the 2D was read from the code and art.
3. WE COULD BUILD THE SAME 2D VIEW FROM OUR OWN 3D IN ABOUT 4 DAYS (about 40 side-camera stills + a Tween player); the
   same pictures can be the card game's resolution art. Probe first: 12 stills, one round, shown to you beside the 3D.
4. BETWEEN ROUNDS THEY GIVE A "ROUND READ": likely winner, a score range (e.g. 14.2-15.2), urgency, four calls and a
   "take the corner's call" button. Ours says what happened, not how sure. Worth a probe on our corner card.
5. THE SIM DECIDES, THE PICTURE FOLLOWS - like ours. Their tactics are 24 sliders a round set before the fight, calls
   only between rounds; ours (a call every 30 s that changes the exchange) is deeper.

## 1. How their fight is drawn

### The 2D picture view (third choice, a fallback)
- Exchange pictures: about 60 files at 410 x 371, both fighters in one cartoon picture (big round heads, blue vs red,
  black shorts, MMA gloves), a white star burst on a landed shot, a "MISS" streak on a missed one. A picture is picked
  from four facts of the strike: kind (punch / leg kick / body kick / head kick / clinch knee / ground punch), target
  (head / body / legs), the side it lands on (left / right), landed or missed. If the fighters stand the other way round,
  the picture is mirrored instead of drawing a second set. Knockdowns have 5 frames; ground and pound one each way.
- Paired pose sheets: 12 two-fighter poses (guard, jab each way, kick each way, clinch, takedown each way, ground top each
  way) on one 4 x 3 sheet; a second, plainer stick-figure version of the same 12 exists (looks like an earlier draft).
- Idle: a 4 x 4 sheet of single fighters, 8 facing directions for blue and 8 for red. The direction is picked from the
  angle between the two fighters (snapped to 45 degrees). Each fighter's position comes from the sim (x, y in percent of
  the cage), drawn bigger when "nearer" (width about 10.5% to 12.7% of the view), with a small walk bob.
- Motion is all CSS: a pose pair pops in over 0.24 s (zoom from 0.90 to 1.035 to 1.0); kicks and ground punches get a
  0.46 s nudge; a takedown plays an entry picture then a result picture over 1.8 s; a paired strike picture holds about
  1.1 s; a strike line runs 0.42 s, the impact ring 0.48 s, a white flash 0.35 s; a big shot gets a gold glow.
- So a move is ONE drawn frame plus tweens. No skeleton, no frame-by-frame animation.

### The 3D view (first choice)
- A Godot 4 web export (index.wasm + .pck, about 80 MB) served by the app on a private local address and shown in a frame;
  the page sends it the current exchange and gets back sound cues and "ready". A load bar ("Loading fighters...").
- 59 MMA clips (jabs, crosses, hooks, uppercuts, body shots, kicks, knees, elbows, clinch, takedown pair, ground and
  pound, block, dodge, hit reactions, knockdown, knockout, stand up, steps and pivots). For each clip and each side a table
  gives three moments as fractions of the clip: start, contact, end (e.g. a body hook contacts at 41% of the clip). This
  is the same idea as our contact-time numbers; theirs is one small data file.
- Fighters are plain blue and red mannequins. They sidestep the whole "does the boxer look right" problem by not having
  faces, skin or hair in the fight at all. The camera is one high broadcast angle; ground work zooms in.
- Second choice: a three.js 3D viewer with the same two mannequins (a "backup 3D viewer").

### Pace and controls
- Feed speed list (Realtime by default), Pause, "Skip to end of round". Realtime is real time: a 5-minute round takes 5
  minutes. One sim step = 15 fight seconds (20 a round). Skip resolves the rest of the round at once (our bout ended in a
  round-2 stoppage inside the skip).
- Beside the view: health, stamina, live strike / takedown / control / submission counts, a momentum bar, strikes landed
  by head / body / legs, and a text feed ("Live Action") of every step in plain sentences.

### How the fight is simulated (enough to compare)
- 3 rounds (5 for a title), 20 steps a round. Each step both fighters act; the fight is always in one of 9 phases (long
  range, pocket, clinch, cage control, takedown battle, top control, guard, submission threat, scramble).
- Damage goes to head, body and legs; "hurt" meters rise; a knockdown, a stoppage or a submission is a chance each step
  built from head damage, power against chin, the hurt meter and the plan. Stats used: striking, wrestling, grappling,
  cardio, chin, speed, power, fight IQ (plus sub-stats per skill).
- The plan fit (how the sliders suit the fighter and the opponent) and the scouting report are numbers the sim reads.
- Every step writes a sentence and a list of strikes for the pictures; the picture never decides anything.

## 2. Could WE make a 2D view (or the card game's resolutions)? What it takes

Their method: one key picture per exchange outcome, tweens for life. For a boxing view we would need, per corner:
- 6 punches (jab, straight, lead hook, rear hook, body hook, uppercut) x landed / blocked / missed = 18 pairs,
  + guard, clinch, a knockdown (3 frames), the referee step-in, a corner sit = about 25 pairs. Mirror the pair for the
  other corner, as they do, or render both (about 40-50 pictures). Each card-game art (karate, judo, wrestling, BJJ,
  kickboxing) would need its own set of about 20.

Two ways to get the pictures:
1. FROM OUR OWN 3D (recommended): our boxers, our v2 clips, the hidden desktop still tools. A fixed side camera, each
   punch frozen at its contact frame for both boxers, a flat toon shader and outline pass, transparent background. Days:
   1 to set up the camera and shader and render the batch, 1 to fix bad frames, 1 for a Control scene that swaps
   TextureRects with a Tween from the settled exchanges (scripts/rules/Exchanges.gd:10 six 30-second exchanges a round),
   1 for wiring and one golden-path test = about 4 days. Same characters as the 3D, no new art seat, no licence question.
   Risk: our known pose problems (guard, knee) show up in a still just as in a film - the stills inherit them.
2. GENERATED ART (Ludo or Higgsfield): faster to look nice, but the same two boxers must stay the same across 40 pictures,
   and both fighters in one frame with the right punch is where generators fail. Worth one try at 6 pictures before any
   batch. Theirs look generated in one cartoon style (one sheet is plainly a first draft of the other).

For the card game the 2D picture route is the natural fit: a card resolves, the matching pair picture pops with a burst.
No 3D, no animation tree. The owner's "animated resolutions" become a 1-second pop, zoom and impact ring.

## 3. Their loop vs ours

| Theirs (MMA, you are the MANAGER) | Ours (boxing, you RUN THE GYM) |
|---|---|
| Recruit from a market; rating hidden until scouted (GBP 250 a week-long report, GBP 750 full) | Walk-in at reception; opponent fog by ranges (scripts/rules/BoutRead.gd:94 rating_range) |
| Contract = signing fee + manager cut % (26% asked) + length (36 weeks) + loyalty bonus; 2 guaranteed fights | Club dues and a stipend; no cut of purses beyond the gym share |
| Promotions send bout offers about 9 weeks out: purse 2,201 + win bonus 1,509; accept, decline or stall 4 weeks | We ask for fights; amateur bouts in 1-2 weeks with no camp |
| Fight week press conference: 3 questions, 4 tones each (respectful / professional / confident / aggressive) -> hype +4, rivalry tone, public perception +2 | None in amateur; a media layer belongs to pro / promotion |
| Tactics: 24 sliders in 4 groups per round, 5 presets, two timing windows (finish push, protect lead) | Plan lines + a call every 30 s (scripts/rules/Exchanges.gd:10-11, edge best/ok/wrong at :18) |
| Between rounds: round read with a score range + 4 recommended calls + full menu | Corner card from the beats the ring played (scripts/rules/CornerCard.gd:62) |
| After: rankings update screen, result page (momentum per minute, fight reads, stat comparison, target mix), cage speech (4 tones), "who do you want next" call-out, post-fight press (2 questions) | Result page = the fight and what it decided (S440) |
| Money in the test: GBP 10,000 -> 660 by week 10 (fee 4,066 + monthly costs), +1,046 after the win | Gym bills by the week, 8 weeks below zero closes the gym |
| Also: youth academy, betting site, social feed, hall of fame, records room | Weekly training choices are the core |

## 4. Worth taking (each with the probe it needs; nothing built before its probe)

1. 2D EXCHANGE PICTURES as (a) the card game's resolution view and (b) a cheap second view of our settled rounds.
   Probe: render 12 pair stills from our 3D (jab, straight, lead hook x landed / missed x both corners) with the side camera;
   play one 3-minute round as a picture swap from a real settled round; show the owner both (picture round and the 3D film
   of the same round). Keep only if he picks it as readable or likes it beside the 3D. About 1.5 days for the probe.
2. ROUND READ WITH A RANGE on our corner card: "you probably won it, 10-9, not sure" plus one recommended call with a
   one-tap accept. Probe (S534 rule): 200 seeded bouts with and without the read; it stays only if the player's call
   choice changes and the win rate of an average player moves (a number that changes no decision is not a mechanic).
3. CLIP CONTACT TABLE: their start / contact / end fractions per clip in one data file. If FIGHTPLAYER2 does not already
   keep its contact moments as one table, it is a cheap tidy-up (no new layer, data only). Check first.
4. FEED SPEED + PAUSE + "SKIP TO END OF ROUND" on our fight view, if not already all there: plain controls players expect.
5. PRESS TONES (four tones -> hype / rivalry numbers): park for the pro / promotion layer; not for amateurs.

## 5. What we do better
- The fight is played, not pre-set: a call every 30 seconds that changes the exchange, against their pre-fight sliders and
  between-round calls only. 24 sliders a round is depth by count; most players will press a preset.
- The gym is the game: training is a weekly choice, money is real club money. They are an agent with a cut.
- Our opponent fog gives ranges that narrow; theirs is hidden until a paid report.
- Their 3D mannequins have no faces at all; ours aim at real-looking boxers (harder, but it is the product).

## Not done
- A second fight: the next card for the test fighter was in week 18 and the demo stops at week 13, so only one full bout
  (plus the rest of that card, settled off-screen) was watched.
- The 2D view never showed live (the 3D loaded); it was read from the code and its picture files.

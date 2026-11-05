# FightCamp sound benchmark (S385): which games are praised for sound, why, how they did it, and our bar

Research date 2026-11-05. Written for the CEO's brief: "top sound quality, check which games have been praised for
sound, why, how they did and try to surpass them".

Our constraints: every effect, ambience and piece of music is GENERATED with Ludo.ai audio (text-to-SFX up to 10 s,
looping ambiance, text-to-music, speech presets), then mixed in Godot 4.7 (buses, AudioStreamPlayer/3D,
AudioStreamRandomizer, bus effects). Nobody but the CEO can hear, so every rule below is either a NUMBER a script can
check or a named question for his ear.

Labels: **DOCUMENTED** = backed by the linked page (opened or search-confirmed this session). **INFERENCE** = our own
reasoning from those sources plus common practice. **NOT FOUND** = searched and no primary source turned up.

Prior research this builds on: `ops/research/J22_WHAT_A_FIGHT_SOUNDS_LIKE.md`, `J22B_..._PART_TWO.md`,
`J40_FIGHT_AUDIO_SHORTLIST.md`, and the live cue list `docs/audio/SOUND_LIST.md` (S385, Ludo pipeline, `assets/audio/sounds.json`).

---

## 0. The short version

1. The games that win audio awards share five habits: **layered impacts** (several short sounds built into one hit),
   **lots of variants with no-repeat logic**, **sound driven by game data** (force, surface, fatigue, tension),
   **a clear priority order in the mix** (the important sound is never ducked, everything else makes room), and
   **mix states with real quiet in them** (dynamics, not a wall of noise).
2. The boxing games are NOT the benchmark for crowd and commentary. Undisputed (2024) is praised for punch sounds but
   criticised for a droning, unreactive crowd and commentary that is repetitive and sometimes wrong. Fight Night
   Champion's commentary was praised but its lines repeated too often. That is the gap we can beat.
3. Our unfair advantage: **the fight is settled before it is shown** (Week 5 rule: "the 3D fight never decides - it shows
   the settled round"). We know the big shot, the knockdown and the momentum swing BEFORE they play. No live-simulated
   boxing game can do that. We can pull the crowd down into near-silence half a second before the big shot, start the
   "ooh" on the wind-up, and never have a commentator say something false.
4. Our files today (measured below): all mono 48 kHz (good), but every file is peak-normalised to about -1.3 dBFS, so
   the hierarchy is inverted - the "big shot" measures **quieter** (-19.6 LUFS) than the ordinary power punch (-16.2 LUFS);
   the power punch is squashed (crest factor about 8 dB); the big shot is dull (energy rolls off around 3 kHz) and has
   a gap inside it; the crowd "loop" is 8 seconds long and would repeat about 22 times in one 3-minute round.
5. Godot's Movie Maker mode (`--write-movie out.avi --fixed-fps 30`) records the game's full mix to a file **without
   playing it through speakers**. That is how we check a whole fight's audio with numbers on his PC without a sound.

---

## 1. Combat sports games

### Fight Night Round 3 / Round 4 / Champion (EA Chicago, then EA Canada, 2006-2011)
- **Praise (DOCUMENTED):** 2006 reviews call Round 3's punch effects convincing ([outnow.ch](https://outnow.ch/en/Games/2006/FightNightRound3/Review/));
  an Operation Sports retrospective credits its mic'd-up impact sounds ([Operation Sports](https://www.operationsports.com/fight-night-round-3-was-a-generation-ahead-of-its-time)).
  Champion's reviews praise hearing every heavy blow and the crowd lifting tension, and single out the Tessitore/Atlas
  commentary, but several say the commentary lines repeat far too often
  ([Impulse Gamer](https://impulsegamer.com/ps3fightnightchampion.html), [GamesRadar](https://gamesradar.com/fight-night-champion-review-2-2/2),
  [VideoGamer](https://www.videogamer.com/reviews/fight-night-champion-review)). Fans felt Round 4 lacked impact next to
  Champion ([GameFAQs board](https://gamefaqs.gamespot.com/boards/996445-fight-night-champion/57892936) - opinion, not fact).
- **How (partly NOT FOUND):** no audio postmortem or GDC audio talk for the series turned up. What is documented: Round 4's
  audio was rebuilt "from the ground up" with more responsive crowd reactions ([Destructoid](https://www.destructoid.com/fight-night-round-4-producer-talks-sound-cutscenes/));
  Champion had a dedicated subset of bare-knuckle punch sounds and recorded actors' dialogue while they performed the boxing
  moves, under studio audio director Gordon Durity (Post Magazine, March 2011, via [search summary](https://digital.copcomm.com/i/26533/31)).
  Round 3's damage feedback (blur, red vignette in first-person mode) is documented as VISUAL only
  ([GameZone](https://gamezone.com/?p=101009)).
- **Lesson:** punches recorded close and dry ("mic'd-up") read as real; commentary is the first thing reviewers punish when
  it repeats.

### Undisputed (Steel City Interactive, 2024)
- **Praise and complaints (DOCUMENTED, reviews):** split. Some reviews say the studio nailed satisfying punch sounds; others
  say punches don't sound distinct enough by type or power and that big power-punch landings are overdone. The crowd is
  called droning, stale and not matched to the ring or the venue size; commentary is called repetitive, boring and sometimes
  wrong or out of sync ([The AU Review](https://www.theaureview.com/games/undisputed-review/),
  [Impulse Gamer](https://www.impulsegamer.com/undisputed-review-ps5/), [OpenCritic roundup](https://opencritic.com/game/17418/undisputed/reviews),
  [Digital Trends hands-on](https://digitaltrends.com/gaming/undisputed-hands-on-impressions)).
- **How (NOT FOUND):** no audio interview found; their GDC talk is about building the game in Unity
  ([GDC Vault](https://gdcvault.com/play/1029388/Undisputed-Punching-Above-Class-(Presented)).
- **Lesson for us:** the current best boxing sim loses points exactly on (a) punch type/power not audible, (b) crowd not
  reacting, (c) commentary wrong. All three are data problems, and we own the data.

### EA Sports UFC (EA Vancouver, 2014-2023)
- **Praise (DOCUMENTED):** a UFC 5 review says the crowd reacts as a real one would and the commentators react with shock to a
  stunning knockout ([Windows Central](https://www.windowscentral.com/gaming/ea-sports-ufc-5-review-a-knockout-entry)).
- **How:** commentator Jon Anik says he recorded **92 hours solo** for UFC 3 ([Bloody Elbow](https://bloodyelbow.com/2020/07/23/joe-rogan-wont-provide-commentary-ea-ufc-4-video-game-replaced-daniel-cormier-mma-news)).
  EA's FIFA team built its crowd from real match recordings (see FIFA below). No strike-sound breakdown found.
- **Lesson:** convincing commentary costs tens of hours of lines. We should not ship commentary we cannot fund at that scale.

### Creed: Rise to Glory (Survios, VR, 2018) and The Thrill of the Fight (Halfbrick/Ian Fitz, VR)
- **Creed (DOCUMENTED):** sound rated "pretty good" with satisfying flesh-crunching effects; the theme song pumps you up for
  six or seven listens, then wears thin ([waytoomany.games](https://waytoomany.games/2018/09/25/review-creed-rise-to-glory-psvr/),
  [Meta blog](https://www.meta.com/blog/creed-rise-to-glory-update-brings-viktor-drago-and-danny-wheeler/)); the PS VR2 edition
  added 3D audio ([PlayStation Blog](https://blog.playstation.com/?p=375947)).
- **Thrill of the Fight (DOCUMENTED):** the developer did most sound himself from stock audio with trial and error
  ([Meta blog](https://www.meta.com/blog/come-out-swinging-in-the-thrill-of-the-fight-available-now-on-oculus-quest/)); reviewers
  call it minimal but effective - bell, crowd, glove "biffs" ([VR Grid](https://www.thevrgrid.com/thrill-of-the-fight/)); punch
  impact is computed from punch speed and a fixed mass ([VR Heaven](https://vrheaven.io/?p=15417)); in the sequel the crowd
  moves from cheers to gasps with your performance ([TechRadar](https://www.techradar.com/gaming/the-thrill-of-the-fight-2-vr-gaming-preview))
  and was authored in Wwise ([Yannis Brown portfolio](https://yannisbrown.com/project_category/highlight-projects/)).
- **Lessons:** (1) a short music loop that is heard every fight burns out in under ten listens; (2) a few honest sounds scaled
  by real force beat many generic ones.

### Punch-Out!! (Nintendo, Wii 2009)
- **Praise and how (DOCUMENTED, reviews):** opponents telegraph attacks with a visual or an audio cue, then flash before they
  strike ([The Phoenix](https://blog.thephoenix.com/Boston/recroom/83974-punch-out/%3Frel=inf), [Giant Bomb](https://giantbomb.com/reviews/punch-out-review)).
- **Lesson:** a wind-up sound is a readable tell. In a fight you WATCH, a short cue before a power punch (breath, glove
  creak, crowd "ooh") lets the player read what is coming.

### Sifu (Sloclap, 2022)
- **Praise (DOCUMENTED):** reviewers call the soundtrack and sound design a high point
  ([Gameranx](https://gameranx.com/updates/id/286462/article/sifu-developers-offers-a-look-behind-the-soundtrack/)).
- **How:** lead sound designer Lucas Rousselot; each level got its own sonic identity from its materials and environment
  ([Krotos](https://sound.krotosaudio.com/?p=501)); weapon clashes, destruction and character attack efforts were captured for
  the game (Gameranx); the podcast with Rousselot covers a "Gameplay audio" option and level-shaped music
  ([podcast](https://www.podbean.com/ew/dir-uej86-17926d60)). No per-hit layer breakdown found.
- **Lesson:** the room changes the fight sound. A club hall and an arena should not share one reverb.

### Mortal Kombat 1 (NetherRealm, 2023)
- **Quote:** "Combined with our ducking system, we ensure that each hit punches through the mix." - Matt Swanson,
  [A Sound Effect](https://www.asoundeffect.com/mortal-kombat-1-game-audio/).
- **How (DOCUMENTED, same interview):** separate impact groups for face hits, body blows, blades, blunt weapons and magic;
  body hits get more crunch, face hits more squish; a shared core library of punch/kick impacts and blocks, with custom
  launch/impact/block sounds for weapons and specials; each actor records 50+ effort and reaction categories (300-400 files,
  about half used in core play); a ducking system plus more side-chain compression than earlier games; months of weekly
  move-by-move balancing in calibrated rooms; the game's speed leaves little time for a sound to "speak". MK1 also narrates
  fatalities for blind players ([Game Developer](https://gamedeveloper.com/business/mortal-kombat-1-s-accessibility-options-include-fatality-narration)).
- **Lesson:** split impacts by TARGET (head vs body) and by TYPE, keep each hit short, and duck the rest under it.

### Street Fighter 6 (Capcom, 2023)
- **Praise and how (DOCUMENTED):** Real Time Commentary by around ten pre-recorded community commentators (play-by-play plus
  colour, colour can be switched off) ([Wikipedia](https://en.wikipedia.org/wiki/Street_Fighter_6), [Gematsu](https://gematsu.com/2022/08/street-fighter-6-real-time-commentary-feature-adds-tasty-steve-james-chen)).
  With the accessibility group ePARA it added distance-to-opponent sounds and different hit sounds for high, mid and low
  attacks, and separate volume sliders for attacks, footsteps, Super Arts, environment and system sounds
  ([TechRadar](https://www.techradar.com/news/street-fighter-6s-game-changing-accessibility-features-set-a-new-standard),
  [Automaton](https://automaton-media.com/en/?p=16131)). Line counts NOT FOUND.
- **Lesson:** sounds that tell you WHAT happened (height, target) are both accessibility and readability. Head, body and
  block must be told apart by ear alone.

---

## 2. Sports crowd and broadcast feel

### FIFA / EA Sports FC (EA Vancouver)
- **Quote:** "Loops aren't a compelling way for anybody to have an atmosphere" - Paul Boechler,
  [Sound Particles](https://blog.soundparticles.com/how-paul-boechler-created-live-stadium-crowds-from-fifa-recordings).
- **How (DOCUMENTED):** three layers - a looping bed only to fill gaps, home/away chant pools picked at random when one ends,
  and one-shot reactions per event (applause for a good tackle, jeers, appeals, goal cheers) that vary by context (a blowout
  goal is not a cup-winning goal); crowd speech recorded for groups of about 7k, 15k, 20k and 40k people; many spaced mics
  around the pitch (inter-mic delay sells stadium size); mic 1-2 m from the crowd gets the front row, farther gets size but
  loses chant words; the team avoids heavy limiting and uses upward expansion and dynamic EQ so the big moments stand out;
  one-shots duck the chants and bed. EA receives 100+ match recordings a year; broadcasters in 2020 got 800+ clips per league
  ([Sound Particles](https://blog.soundparticles.com/how-paul-boechler-created-live-stadium-crowds-from-fifa-recordings),
  [CFJC/CP](https://cfjctoday.com/?p=838128)). EA's audio director says sports commentary must be right "99.9%" of the time
  ([Designing Sound, Gordon Durity](https://designingsound.org/2015/10/28/spectral-analysis-interview-with-gordon-durity/)).
- **Lesson:** crowd = bed + reactions + swells, sized to the venue, never one loop.

### NBA 2K (Visual Concepts)
- **How (DOCUMENTED):** 2K12 added 500+ arena-specific sounds and music clips ([OS dev insight](https://www.osftw.com/features/1344/nba-2k12-developer-insight-11-audio));
  for 2K17 the team travelled 16,000+ miles to record all 30 arenas; 2K19's effects change with the arena you play in
  ([PowerUp Gaming](https://powerup-gaming.com/2018/08/18/the-sound-effects-in-nba-2k19-are-different-based-on-which-arena-you-play-in));
  2K10 brought a conversational commentary system from MLB 2K. Its crowd samples were tested for the 2020 NBA bubble and
  dropped for "contamination" (squeaks, whistles baked in) ([SVG](https://www.sportsvideo.org/2020/09/03/nba-returns-new-category-of-a1-makes-fan-free-stands-come-alive/)).
- **Lesson:** venue identity is a feature; and a crowd bed must be CLEAN (no baked-in whistles or squeaks) or it cannot be reused.

### Football Manager (Sports Interactive)
- **What we found (DOCUMENTED):** FM2012 added a visual crowd system; for over a decade the community has shipped crowd,
  chant and commentary sound packs because the default match audio is thin ([Giant Bomb](https://www.giantbomb.com/games/3030-33212/),
  [FM Scout FM24 pack](https://www.fmscout.com/a-fm24-audio-match-commentary.html)).
- **Lesson (INFERENCE):** management-sim players care about match audio enough to mod it in. A management game that ships a
  reactive crowd is ahead of the genre leader here.

### Rocket League (Psyonix)
- **How (DOCUMENTED):** one person (Mike Ault) made all music and sound at launch ([GameSided](https://gamesided.com/2015/08/17/sound-rocket-league-interview-psyonixs-mike-ault/2));
  GDC 2018 talk on the audio journey ([GDC Vault](https://gdcvault.com/play/1025265/The-Audio-Journey-of-Rocket)); a 2019 update
  added HDR audio and the team tests mixes on everyday listening setups because most players don't have good speakers
  ([Psyonix, via devtrackers](https://devtrackers.gg/rocket-league/p/20a929a2-under-the-hood-an-inside-look-at-hdr-audio-coming-to-rocket-league)).
- **Lesson:** a tiny team can reach a praised sound if the mix has priorities and is checked on bad speakers.

---

## 3. Impact and weapon audio benchmarks

### DOOM (2016) / DOOM Eternal (id Software)
- **Quote:** "weapons were really the main character in DOOM" - [ADSR Sounds Q&A](https://www.adsrsounds.com/news/the-sound-design-of-doom-exclusive-qa/).
- **How (DOCUMENTED, same Q&A):** audio director made weapons top priority - never ducked, not even for voice - and built the
  mix around them; metal impacts distorted and layered so sounds stay "chunky"; the Gauss rifle uses a short impulse, a cut to
  silence, then the main shot, so the shot seems to pull air out of the room; demon voices are pitched/processed human takes
  blended with animal and synth layers; space-dependent reverb layers baked into weapon fire plus Wwise reverb regions;
  authored at 96 kHz/24-bit, delivered at 48 kHz/16-bit. DOOM (2016) was a BAFTA Audio nominee ([Wikipedia](https://en.wikipedia.org/wiki/British_Academy_Games_Award_for_Audio_Achievement)).
- **Lesson:** pick the "main character" sound (for us: the landed punch, and above all the big shot) and protect it; a
  gap of silence right before a hit makes it bigger.

### Battlefield (DICE) - HDR audio
- **Awards:** BAFTA Audio Achievement for Bad Company 2 (2010) and Battlefield 3 (2011) ([Wikipedia](https://en.wikipedia.org/wiki/British_Academy_Games_Award_for_Audio_Achievement)).
- **How (DOCUMENTED):** HDR = an automatic mixer that maps the game world's loudness (sounds tagged in dB SPL across about
  130 dB, quietest audible to pain) into the range a living room can play; a "window" slides to follow the loudest sound and
  everything below the window is pushed down or culled; it acts on logical volumes, not the waveform; attack/release set too
  fast causes colouring or pumping ([DICE slides via Slideshare](https://www.slideshare.net/slideshow/adaptive-mixing-in-frostbite/3128152),
  [Designing Sound](https://designingsound.org/2013/06/21/finding-your-way-with-high-dynamic-range-audio-in-wwise/)). Durity adds that
  in Battlefield the backpack's weight changes footsteps and exhaustion changes breathing and gait
  ([Designing Sound](https://designingsound.org/2015/10/28/spectral-analysis-interview-with-gordon-durity/)).
- **Lesson:** loud events should make quiet ones get out of the way automatically, and the body's state (fatigue) should
  change its sounds.

### God of War (2018) - the Leviathan axe (Santa Monica Studio)
- **Awards:** BAFTA Audio Achievement 2018 (and Ragnarök 2022) ([Wikipedia](https://en.wikipedia.org/wiki/British_Academy_Games_Award_for_Audio_Achievement)).
- **How (DOCUMENTED):** the sound emitter rides on the axe so you hear it come back, tied to its spin speed; three separate
  rumbles (trigger, flight, catch); a small camera shake; a 0.1 s wiggle before it pulls free (it was longer and felt slow);
  return flight capped at 1.5 s; the recall and catch use placed frames with zero blend time so they land with weight
  ([Game Developer, "Recalling the Leviathan Axe"](https://www.gamedeveloper.com/design/recalling-the-leviathan-axe));
  GDC talk by lead sound designer Mike Niederquell on workflows and mix philosophy ([GDC Vault](https://gdcvault.com/play/1026054/The-Sound-Design-for-God)).
- **Lesson:** impact "feel" is sound + animation timing + camera together. The hit sound must land on the contact frame,
  and the contact frame must not be blended away.

### The Last of Us Part II (Naughty Dog)
- **Awards:** The Game Awards Best Audio Design 2020 ([Gaming Audio News](https://gamingaudionews.com/2020/12/11/game-awards-2020-best-audio-design/)); BAFTA nominee.
- **Quote:** "Foley, uniquely, invisibly, and intimately connects the player to the character" - [A Sound Effect](https://www.asoundeffect.com/the-last-of-us-part-ii-sound/).
- **How (DOCUMENTED, same interview):** 50-60 recordings per Foley tag, about 30 kept, **8-15 implemented per tag**, alternates
  in reserve; 40 surface types; Foley banks of 1,500-1,800 sound IDs (vs 300-400 in Uncharted 4); looping movement sounds shaped
  by gameplay variables for wide variation at low memory; Clicker vocal "jolts" tagged to exact animation frames; a high
  dynamic range target balanced against keeping story dialogue clear; shared reverb impulse responses so gameplay and
  cutscenes sound identical.
- **Lesson:** our 8-15 per frequent event is an industry-proven count, not luxury; tag sounds to the exact frame.

### Hellblade: Senua's Sacrifice (Ninja Theory)
- **Awards:** BAFTA Audio Achievement 2017 ([Wikipedia](https://en.wikipedia.org/wiki/British_Academy_Games_Award_for_Audio_Achievement));
  the sequel won The Game Awards Best Audio Design 2024 ([Pure Xbox](https://purexbox.com/news/2024/12/xboxs-hellblade-2-brings-home-multiple-awards-at-tga-2024)).
- **How (DOCUMENTED):** the voices inside Senua's head were recorded with a binaural microphone (3Dio)
  ([3Dio](https://3diosound.com/pages/gaming), [A Sound Effect on Hellblade II](https://www.asoundeffect.com/?p=748333)).
- **Lesson (INFERENCE):** binaural only works on headphones and from source recording; a generator cannot fake it reliably.
  We take the principle (a sound placed close to the listener feels intimate - the corner's voice between rounds) but not
  the technique.

### Ghost of Tsushima (Sucker Punch)
- **Awards:** BAFTA Audio Achievement 2020 ([Wikipedia](https://en.wikipedia.org/wiki/British_Academy_Games_Award_for_Audio_Achievement)).
- **Quote:** "the audio is all about the katana sounds and character Foley" - [A Sound Effect](https://www.asoundeffect.com/ghost-of-tsushima-sound/).
- **How (DOCUMENTED, same interview + [GameSpot](https://www.gamespot.com/articles/ghost-of-tsushima-sound-team-breaks-down-the-games/1100-6480186/)):
  sword blanks scraped, clanged and swung; blades through fruit, vegetables and cloth for cuts; mix states through every
  mission - exploration lets wildlife lead, infiltration lowers Foley and ambience so the music's tension comes through,
  combat brings music and combat sounds forward; combat swings are quieter when no enemy is near; guiding wind on three
  splines about 5 m apart; the team avoided white-noise build-up across weather.
- **Lesson:** each moment of the game is a different mix, written down as a state.

---

## 4. Management/sim and UI sound praised for feel

### Two Point Hospital / Campus / Museum (Two Point Studios; audio by Cedar Studio)
- **Quote (the music brief):** "Think lift music" ([Production Expert](https://www.production-expert.com/production-expert-1/2018/10/10/ever-wanted-to-create-sound-for-a-video-game-see-how-the-team-from-cedar-studio-created-the-music-amp-fx-for-the-game-two-point-hospital)).
- **How (DOCUMENTED):** every effect made from scratch (a yoghurt drink blown through straws onto an umbrella; a manipulated
  plunger for building a machine); music did not need to loop, so tracks run 3-4 minutes; many small files cut so sounds
  hit on cue even when the game runs faster than real time; a tannoy announcer and radio DJ with adverts
  ([Production Expert](https://www.production-expert.com/production-expert-1/2018/10/10/ever-wanted-to-create-sound-for-a-video-game-see-how-the-team-from-cedar-studio-created-the-music-amp-fx-for-the-game-two-point-hospital),
  [Audient](https://audient.com/news/2018/09/17/two-point-hospital-880/)). A deaf-gamer review notes each notification icon has
  its own success/failure sound, yet the game is playable without sound ([Can I Play That](https://caniplaythat.com/2019/02/24/deaf-game-review-two-point-hospital/)).
- **Lesson:** a management game's sound is mostly the announcer, the music and short status sounds that say good/bad;
  sounds must stay in sync when time runs fast (our week clock).

### Hades (Supergiant)
- **Praise (DOCUMENTED, reviews):** reviewers tie the sound to combat feel - music that swells at the right moment, distinct
  feedback on hits, the coin-and-wine clink at the Well of Charon ([Medium UX analysis](https://medium.com/@Nat.Rowley/how-hades-creates-a-responsive-underworld-915715a7c2a),
  [Wccftech](https://wccftech.com/review/hades-damned-great/)).
- **How:** audio director Darren Korb made the effects, directed voice and composed; the music system was built to stay fresh
  over hundreds of hours ([gameplay.co](https://gameplay.co/hades-game-music-sound-design-darren-korb-supergiant-games/),
  [The Outerhaven](https://www.theouterhaven.net/2021/09/in-discussion-supergiant-games-greg-kasavin/)). No hit-layer breakdown found.
- **Lesson:** in a game played for hundreds of hours, music must be built to vary (layers, sections), not one track on loop.

### Balatro (LocalThunk)
- **Quote:** "never too loud or overbearing" - [NY Game Critics](https://nygamecritics.com/2024/12/13/games-of-the-year-balatro-can-grab-anyones-attention-even-players-who-didnt-previously-like-poker/).
- **How (weakly documented):** one main piece of music with crunchy effects that heighten scoring; every draw has its own cue.
  A design breakdown claims each scored card plays a rising note, but that is NOT confirmed by the developer
  ([blakecrosley.com](https://blakecrosley.com/es/guides/design/balatro)).
- **Lesson (INFERENCE):** small, quiet, musical UI sounds stacked in a rising sequence make a payout feel big without being loud.

### Awards at a glance (DOCUMENTED, [BAFTA list](https://en.wikipedia.org/wiki/British_Academy_Games_Award_for_Audio_Achievement))
| Game | Audio award |
|---|---|
| Battlefield: Bad Company 2 / Battlefield 3 | BAFTA Audio Achievement 2010 / 2011 |
| Hellblade: Senua's Sacrifice | BAFTA Audio Achievement 2017 |
| God of War / God of War Ragnarok | BAFTA Audio Achievement 2018 / 2022 |
| Ghost of Tsushima | BAFTA Audio Achievement 2020 |
| The Last of Us Part II | The Game Awards Best Audio Design 2020; BAFTA nominee |
| Senua's Saga: Hellblade II | The Game Awards Best Audio Design 2024 |
| DOOM (2016) | BAFTA Audio nominee |
| Any boxing game | none found |

---

## 5. Where FightCamp starts: the 12 files we have (measured 2026-11-05, ffmpeg 9.0.2)

Files in `assets/audio/fight` and `assets/audio/crowd` (Ludo MP3 converted to Ogg). Short files cannot be measured with
integrated loudness (gating needs 400 ms; they read -70 LUFS), so they were measured LOOPED 20 times.

| File | Ch | Length | Peak dBFS | Loudness (looped) | Crest | Energy roll-off | Finding |
|---|---|---|---|---|---|---|---|
| punch_jab_head_1 | mono | 0.16 s | -1.3 | -18.3 LUFS | ~16 dB | ~6.8 kHz | OK length; one variant only |
| punch_power_head_1 | mono | 0.68 s | -1.4 | -16.2 LUFS | ~8 dB | ~8.9 kHz | squashed (crest < 10 dB); long for a punch |
| punch_big_1 | mono | 0.92 s | -1.3 | **-19.6 LUFS** | ~18 dB | **~3.0 kHz** | QUIETER than a normal punch; dull; silence gap at 0.70-0.73 s (two hits?) |
| punch_body_1 | mono | 0.24 s | -1.5 | n/m | ~23 dB | ~5.8 kHz | brighter than expected for a body shot |
| punch_blocked_1 | mono | 0.31 s | -1.4 | n/m | ~18 dB | ~5.6 kHz | - |
| punch_miss_1 | mono | 0.48 s | -1.6 | -16.0 LUFS (raw) | ~13 dB | ~5.2 kHz | a miss as loud as a power punch |
| bell_round_start_1 / end_1 | mono | 1.1 / 1.4 s | -3.9 / -6.5 TP | -17.4 / -16.5 LUFS | - | - | fine as a start |
| footwork_canvas_1 | mono | 1.4 s | -1.2 | -21.0 LUFS | - | - | far too loud for footwork |
| knockdown_fall_1 | mono | 1.4 s | -1.3 | -20.1 LUFS | - | - | - |
| crowd_roar_1 | mono | 2.8 s | -3.7 TP | -18.7 LUFS | - | - | one variant |
| crowd_arena_loop_1 | stereo | **8.0 s** | -9.1 TP | -20.6 LUFS | - | - | repeats ~22x per 3-min round; seam RMS -27.9 dB start vs -24.6 dB end (3.3 dB jump) |

What it tells us: the generator (or our conversion) **peak-normalises everything to about -1.3 dBFS**, which erases the
hierarchy (big shot < power punch, footwork and miss as loud as hits). Levels must be set by a loudness CLASS per event,
not by peak. Good news: everything is already mono 48 kHz.

---

## 6. FightCamp sound bar - 24 rules

Each rule: what, which game it comes from, the check without ears, and the question for the CEO's ear. Numbers marked
INFERENCE are our starting values to tune, not industry law.

**R1. A punch is three layers, chosen separately at runtime.** Transient "snap" (glove leather, 0-30 ms, energy mostly above
2 kHz) + body "thud" (30-150 ms, energy 60-250 Hz) + tail/room (150-600 ms, from the bus reverb, never baked into the file).
Generate each layer as its own Ludo prompt ("one short leather glove slap, dry, no reverb, no tail"), not one mixed hit.
4 transients x 4 bodies = 16 combinations from 8 files. *From:* DOOM (layered metal impacts), MK1 (shared core impact
library + custom layers). *Check:* transient files: duration <= 80 ms, spectral roll-off >= 6 kHz; body files: centroid
<= 400 Hz, duration <= 200 ms; no file in `fight/` has a tail past its class limit (R14). *Ear:* "Does a jab sound like
leather on a face - not a slap, not a gunshot, not a pillow?"

**R2. Head, body, block and miss are different families.** Body = more low thud, less snap; head = sharper crack; block =
glove-on-glove/forearm, muffled; miss = air whoosh only. *From:* MK1 (face vs body groups), SF6 (high/mid/low hit sounds),
Undisputed (criticised: punch types not distinct). *Check:* mean spectral centroid of the body pool is >= 30% lower than the
head pool; block pool roll-off < head pool; miss pool has no transient above -20 dBFS in the first 20 ms (INFERENCE values).
*Ear:* blind test on the sound board: 10 random hits, he names head/body/block; pass = 9 of 10.

**R3. Minimum variants per frequent event.** Jab head, power head, body: >= 8 per layer (or >= 8 full hits if not layered);
block and miss: >= 6; footwork steps: >= 10; crowd reactions per type: >= 4; big shot: >= 3; knockdown fall: >= 3; referee
count: 1 take per number. The bell stays 1-2 on purpose (an icon should be identical). The current `SOUND_LIST.md` counts
(4/4/3) are below this bar. *From:* TLOU2 (8-15 implemented per Foley tag), J22 (8-12 per impact), ~491 beats per fight.
*Check:* script counts files per event in `assets/audio/sounds.json` against this table. *Ear:* the "20 jabs in a row" clip:
does any two sound like a copy?

**R4. No immediate repeats, ever.** Every pool uses `AudioStreamRandomizer.playback_mode = PLAYBACK_RANDOM_NO_REPEATS`
(Godot's default) and our player also forbids the same file within the last `min(3, pool_size - 1)` plays. *From:* standard
random-container practice (Wwise/FMOD), [Godot docs](https://docs.godotengine.org/en/stable/classes/class_audiostreamrandomizer.html).
*Check:* unit test fires 1,000 events per pool: zero repeats inside the window; each file's share within +-30% of even.
*Ear:* none needed.

**R5. Small, typed randomisation.** Impacts: pitch +-1 semitone (`random_pitch_semitones = 1.0`), volume +-1.5 dB
(`random_volume_offset_db = 1.5`); footwork/cloth: +-1.5 semitones, +-2 dB; voices and bell: +-0.3 semitone, +-1 dB;
UI sounds tuned to the music key: 0 random pitch (R18). (INFERENCE; the current list's +-4% equals about 0.7 semitone.)
*Check:* test reads every randomizer resource and asserts its ranges match the event's class. *Ear:* "Does any punch sound
chipmunk-high or slowed-down?"

**R6. The fight data drives the sound.** Each landed punch passes `power` (0-1), `target` (head/body), `is_big_shot`,
`fatigue` (0-1) and `round`. Mapping (INFERENCE start): power picks the pool (light < 0.4 <= medium < 0.75 <= heavy),
adds 0 to +6 dB and lowers the body layer up to 2 semitones; fatigue >= 0.6 drops the transient layer 3 dB (arm punches
sound tired) and raises the boxer's breathing; the big shot adds a sweetener layer (sub drop + crack). *From:* Thrill of
the Fight (speed x mass), Battlefield (exhaustion changes breathing and gait), MK1 (categories), Undisputed (criticised:
power not audible). *Check:* test feeds power 0.2/0.5/0.9 and asserts rising level and the right pool; every played punch
writes one log line with its parameters. *Ear:* blind order test - three punches, he says which was hardest; pass 9 of 10.

**R7. One priority ladder; the top is never ducked.** Order: big shot / knockdown > referee count, bell > landed punches >
corner voice > crowd reactions > crowd bed > music > gym/menu ambience > UI. Lower layers duck under higher ones; the big
shot and knockdown are never ducked by anything. Start values (INFERENCE): crowd bed and music duck 6-9 dB, attack 10-20 ms,
release 0.4-0.8 s under a big shot; 2-3 dB under normal punches. Godot: a sidechain `AudioEffectCompressor` on the Crowd and
Music buses keyed from an "Impacts_Key" bus ([docs](https://docs.godotengine.org/en/stable/classes/class_audioeffectcompressor.html)).
*From:* DOOM (weapons never ducked), MK1 (ducking + side-chain), Battlefield HDR, FIFA (one-shots duck the bed). *Check:* a
Movie Maker render of a scripted fight (section 8): the crowd bus is >= 6 dB lower for 300 ms after each big shot than in
the second before it. *Ear:* "Does the knockout punch LAND, or get lost in the crowd?"

**R8. Near-silence before the big shot - our signature.** Because the round is settled before it plays, the director knows
the big shot's timestamp. 0.6-1.0 s before it: crowd bed down 10-12 dB with a low-pass sweep to ~1 kHz, music to silence,
breathing and glove sounds up; on contact: full sweetened hit, then the crowd erupts (swell + reaction) 150-300 ms later.
*From:* DOOM Gauss rifle (impulse, silence, shot), Ghost of Tsushima mix states; no boxing game does this because none knows
the future. *Check:* render: short-term loudness in the 500 ms before every big shot is >= 8 dB below the 3 s before that,
and the 1 s after is the loudest second of the round. *Ear:* "Does the hush feel like the crowd holding its breath - or like
the sound broke?"

**R9. The crowd is a system, not a loop.** Three bed intensities (calm / tense / roaring) crossfaded by a `momentum` value
from the fight data; one-shot reactions with >= 4 variants each: ooh (near miss / big slip), gasp (knockdown), cheer (flurry,
knockdown), applause (end of round), boo/whistle (stalling, clinch); each bed >= 60 s long, built from two loops of different
lengths played offset so the combination repeats rarely. Reactions fire within 300 ms of the event - or BEFORE it on a
telegraphed power punch (we know it lands). *From:* FIFA (bed + chants + reactions), Thrill of the Fight 2 (cheers to gasps),
UFC 5 (crowd reacts), Undisputed (criticised: droning, unreactive). *Check:* in a render, crowd-bus loudness per 1 s
correlates with logged momentum (r >= 0.6); each bed file >= 60 s; reaction log shows delay <= 300 ms. *Ear:* "Eyes closed for
one round - can you tell who is winning?"

**R10. The crowd and the room scale with the venue.** Amateur club show (100-300 people, small hall), regional/national
amateur, pro debut (1,000-3,000): own bed set and own reverb size per venue. *From:* FIFA (crowd recorded at 7k/15k/20k/40k),
NBA 2K (per-arena sound), Sifu (each level its own sonic identity), Undisputed (criticised: crowd ignores venue size).
*Check:* test maps every venue type to a bed set and reverb preset; no two venue tiers share a bed. *Ear:* "Club hall vs pro
debut: do they sound like different places?"

**R11. Loudness targets for the whole mix.** Measured over >= 30 minutes of real play (Sony's method): integrated -20 LUFS
+-2 for the PC build, true peak <= -1 dBTP, loudness range <= 20 LU. Reference points: Sony console -23 LUFS +-2 and portable
-18 LUFS +-2, -1 dBTP, 20 LU ([Designing Sound / Garry Taylor](https://designingsound.org/2012/07/30/video-games-and-loudness-standards-interview-with-sonys-garry-taylor/),
[Sony slides](https://www.sambuz.com/doc/loudness-and-how-to-measure-it-ppt-presentation-886969)). -20 sits between them because
a PC player hears us on headsets and small desk speakers (INFERENCE; tune with his ear). Master bus ends in
`AudioEffectHardLimiter` with `ceiling_db = -1.0` ([docs](https://docs.godotengine.org/en/stable/classes/class_audioeffecthardlimiter.html)).
*Check:* `ffmpeg -i fight.avi -af ebur128=peak=true -f null -` on a 30-min Movie Maker render. *Ear:* "Is the game
noticeably quieter or louder than a YouTube video at the same volume knob?"

**R12. Per-file loudness classes, not peak normalising.** Every file is normalised to its class by loudness measured looped
(start values, INFERENCE): big shot -14 LUFS, power punch -17, jab -19, body -18, block -21, miss -25, footwork -30,
knockdown fall -17, bell -16, referee voice -18, crowd reaction -20, crowd bed -26, UI click -24, music -18 (music and beds
measured unlooped over their full length). Peaks stay <= -1 dBFS. Buses then do the mixing. *From:* our measurement above
(peak-normalising inverted the big shot), Battlefield (sounds tagged with their loudness). *Check:* lint script: each file
within +-1.5 LU of its class. *Ear:* the "one round in order" clip: does anything jump out or vanish?

**R13. Formats.** 48 kHz everywhere. Short frequent SFX: WAV 16-bit mono (Godot imports as Quite OK Audio by default -
low CPU, no decode latency); music and beds: Ogg Vorbis quality 6-8 (about 190-260 kbps), stereo; never MP3 for anything that
loops. Ludo delivers MP3: decode it ONCE to WAV and keep the MP3 only as the raw record. *From:* DOOM (authored 96/24,
delivered 48 kHz), [Godot import docs](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_audio_samples.html)
(WAV for short repetitive effects, Ogg for music and long sounds; nothing gained above 48 kHz or 24-bit). *Check:* ffprobe
over `assets/audio`: sample rate 48000, codec per folder rule, no mp3 in shipped folders. *Ear:* none.

**R14. Mono for anything placed in the ring; tight starts; short tails.** Punches, footwork, referee, corner, bell: mono
(they are positioned by `AudioStreamPlayer3D`). Stereo only for beds, music and wide crowd reactions. Leading silence <= 5 ms
on every impact (so it lands on the contact frame). Tail limits (to -45 dBFS): jab <= 0.25 s, power <= 0.40 s, body <= 0.35 s,
block <= 0.30 s, big shot <= 1.2 s, footwork <= 0.20 s; the room comes from the venue reverb bus. *From:* MK1 (game speed
leaves no time for long sounds), Godot docs (use bus reverb, don't bake). *Check:* ffprobe channels per folder; silencedetect
for start and tail; a stereo file whose side channel is > 30 dB below mid is fake stereo - make it mono. *Ear:* "Does any hit
smear or ring on?"

**R15. Sound fires on the contact frame.** Impacts trigger on the animation's contact event, not on the beat's start; tolerance
1 frame (33 ms at 30 fps) early or late (INFERENCE; people notice sound arriving early sooner than late). The contact frame is not
blended away. *From:* God of War (placed frames with zero blend on catch/recall), TLOU2 (vocal jolts tagged to frames).
*Check:* test logs `audio_play_time - contact_frame_time` for every punch of a scripted round; max |delta| <= 33 ms. *Ear:*
"In the slow-motion close-up, does the sound hit with the glove?"

**R16. Boxing authenticity: bell, clapper, referee, corner.** Round start and end bells as real ring bells (not a school or
phone bell), loud enough to cut the roar (bell >= 6 dB above the crowd bed at that moment); the 10-seconds-left wooden clapper
(two sticks) on every round; referee lines "Box!", "Break!", "Stop!" and the count 1-10 at one number per 1.0 s +- 0.1 s,
which the crowd hushes under; corner between rounds: stool, water squirt, ice, close-miked trainer voice for the corner call
(the intimate, close voice is where Hellblade's lesson applies). *From:* real boxing; J22 cue list; Hellblade (close voices).
*Check:* referee count timing test; bell vs bed level in render; every round has exactly one clapper at T-10 s. *Ear:* "Does
the bell sound like a boxing bell? Does the corner sound like someone talking in your ear?"

**R17. No commentary until it can be right and varied; announcer and referee first.** A commentator line plays only if (a) the
pool for that event has >= 4 lines, (b) no line repeats within a fight and no more than once per 3 fights, (c) every factual
claim (who, which round, what punch, the score) is generated from the settled fight data. Until a speech budget exists, the
voice is the ring announcer (names, weights, record, decision) + referee + corner. *From:* Fight Night Champion and Undisputed
(repetition and wrong lines are the #1 complaint), UFC (92 hours of lines), SF6 (colour commentary can be switched off),
FIFA/Durity (must be right "99.9%"). *Check:* tests for repeat window and claim-vs-data; line count per event in sounds.json.
*Ear:* "Does the generated voice sound like a person in a hall - or a robot?"

**R18. UI sounds: short, quiet, one family, in the music's key.** Click/tap <= 150 ms; card flip <= 250 ms; confirm / cash /
level-up <= 600 ms; hover sounds none or 6 dB under the click. All made from one source family (e.g. leather + wood + a soft
bell, matching a boxing gym), pitched notes tuned to the menu music's key; successive ticks of one payout step up the scale
(+1 scale step per tick). UI bus about -10 dB under SFX. Good and bad outcomes have different sounds (success rises, failure
falls). *From:* Two Point (each notification icon its own success/failure sound), Balatro (quiet, never overbearing; rising
cues - unconfirmed), Hades (distinct feedback). *Check:* duration lint; fundamental pitch of each tonal UI file within +-30
cents of a note in the chosen key (FFT peak, script in section 7); UI loudness class -24 LUFS +-1.5. *Ear:* "After 30 minutes
of menus, is any sound annoying?"

**R19. Music: long, layered, never the same loop all night.** Menu and week music loops >= 90 s; fight-night/walk-out >= 60 s;
each track generated in 2-3 versions at the same tempo and key (full / drums+bass only / pad only) so the game can add or
remove a layer as poor-man stems; music ducks under speech and the big moment (R7); no music during a live round (crowd is
the music), music returns between rounds and at the decision. Loops must join with no click: last and first 10 ms within
1 dB RMS and no step at the seam. *From:* Hades (music built to stay fresh for hundreds of hours), Creed (theme wore thin
after 6-7 plays), Two Point (3-4 min tracks), Ghost of Tsushima (music forward or back per mix state). *Check:* duration,
seam lint, same-BPM test across stems (ffmpeg onset grid or the generator's metadata). *Ear:* "After an hour, do you still
like it? Does any stem pair clash?"

**R20. Every moment is a written mix state.** States: menu/gym, fight live, big-shot close-up (slow motion: crowd low-passed
to ~1 kHz, impact pitched down 3-5 semitones, sub layer up), knockdown count (crowd hushed except a rising murmur, referee
forward), between rounds (corner forward, crowd -6 dB), decision (announcer forward, then crowd release). Each state is a
table of bus volumes and filter settings in one script, with tweened transitions (0.2-1.0 s). *From:* Ghost of Tsushima (mix
states through every mission), TLOU2 (no bump between gameplay and cutscene). *Check:* test enters each state and asserts the
bus table; render shows no bus jump faster than 50 ms except on impacts. *Ear:* "Do the transitions feel like a TV broadcast
cutting - or like sound dropping out?"

**R21. The 80% sounds get the most care: gym bed and footwork.** The sounds heard most are the gym (bags, ropes, timer buzzer,
people) and footwork, not the knockout. Gym bed >= 120 s with no repeat audible within 60 s, plus positioned point sources
(heavy bag thumps, rope loop, pad pops) tied to what the gym's stations are doing. *From:* Durity ("prioritise what players hear
80% of the time"; games are weakest at repetitive footsteps and audible loops), TLOU2 (Foley = more than half of memory).
*Check:* bed length; autocorrelation of the bed's loudness envelope shows no repeat under 60 s; every active gym station has a
sound pool. *Ear:* "Leave the gym screen on for 5 minutes - can you hear it loop?"

**R22. Readable by ear, adjustable by bus.** Head/body/block/miss distinct (R2); separate volume sliders for Master, SFX, Crowd,
Voice, Music, UI; a "big moments" cue that works with music off. *From:* SF6 (separate sliders, attack-height sounds), MK1
(audio description), Two Point (playable without sound - the reverse also matters). *Check:* settings test for six sliders
saved to the config; R2 blind test. *Ear:* covered by R2.

**R23. Checked on bad speakers too.** Every sound's identity must survive a laptop/monitor speaker: a punch keeps clear energy
in 1-5 kHz, not only below 120 Hz. *From:* Rocket League (tests on everyday setups). *Check:* for each impact, energy in
1-5 kHz is within 15 dB of energy in 60-250 Hz (ffmpeg band filters + volumedetect). *Ear:* he plays one fight on headphones
and one on his monitor speakers.

**R24. His ear closes it - with a protocol.** A sound is "unheard" until he keeps it on the sound board (existing EAR RULE in
`SOUND_LIST.md`). Each batch reaches him as: (1) the A/B clip (old vs new), (2) the context clip (the sound inside a rendered
round), (3) one question with 3 buttons: keep / redo / worse. Never more than 10 sounds per sitting. *From:* MK1 (weekly
move-by-move balancing), operator S133 rule. *Check:* every file in sounds.json has an `ear` field = keep + date. *Ear:* this IS
the ear step.

---

## 7. What generated-audio pipelines get wrong, and how ffmpeg catches it

All commands run on his PC (ffmpeg 9.0.2 is installed) and are cheap (no GPU, seconds per file). `f` = the file.

| # | Failure | Why it happens | ffmpeg check (flag when) |
|---|---|---|---|
| 1 | **Low-pass mush** (dull, no snap) | MP3 encoding cuts highs; generators average toward soft | `ffmpeg -i f -af aspectralstats=measure=rolloff+centroid,ametadata=print:file=- -f null -` - flag an impact transient whose mean roll-off < 5 kHz (our big shot: ~3 kHz) |
| 2 | **Long tails / baked reverb** | prompts like "cinematic" add room and decay | `-af silencedetect=noise=-45dB:d=0.05` - the last `silence_start` minus the onset must be under the class tail limit (R14) |
| 3 | **Leading silence** | generator pads the start | same silencedetect: a `silence_end` > 0.005 at the file start = trim |
| 4 | **Inconsistent loudness / peak-normalised** | every output pushed to about -1 dBFS peak | short files: `-af "aloop=loop=19:size=2e6,ebur128"` (integrated reads -70 LUFS below 400 ms otherwise); long files: `-af ebur128=peak=true`. Flag > +-1.5 LU from class (R12) |
| 5 | **Squashed transient** | heavy limiting in the generator | `-af astats=measure_overall=Peak_level+RMS_level:measure_perchannel=none` - crest (peak minus RMS) < 10 dB on an impact = squashed (our power punch: ~8 dB) |
| 6 | **Clipping / overs** | over-hot output | `astats` `Peak_level` > -1.0 dB, or `-af ebur128=peak=true` true peak > -1 dBTP |
| 7 | **MP3 loop gap** | MP3 adds encoder delay and padding, so a loop gets a gap | `ffprobe -show_entries stream=codec_name` - any mp3 in a loop = reject; decode once to WAV/Ogg and re-cut the loop |
| 8 | **Loop seam click/jump** | the generator's "loop" is not sample-matched | RMS of the first and last 10 ms: `-af atrim=0:0.01,astats` vs `-af atrim=start=<dur-0.01>,astats`; flag > 1 dB (our crowd loop: 3.3 dB) |
| 9 | **Fake or unwanted stereo** | generator outputs stereo for everything | `ffprobe -show_entries stream=channels`; for stereo, compare `-af "pan=mono|c0=0.5*c0-0.5*c1,volumedetect"` (side) with `pan=mono|c0=0.5*c0+0.5*c1` (mid): side > 30 dB under mid = fake stereo, make mono; 3D-placed events must be mono anyway |
| 10 | **Double hit / stray events** | the model "tells a story" (two punches, a grunt) | silencedetect with `d=0.02` finds a gap inside the file (our big shot: 0.70-0.73 s); a second onset = regenerate |
| 11 | **Music or voice baked into an SFX** | "no music" in the prompt ignored | duration far longer than asked + high loudness range (`ebur128` LRA > 6 LU on a "single hit") = suspect; the ear confirms |
| 12 | **Duration drift** | asked 0.3 s, got 1.2 s | `ffprobe -show_entries format=duration` vs the prompt's duration in the `.ludo.json` record |
| 13 | **DC offset / hiss** | generator artefacts | `astats` `DC_offset` > 0.001 or `Noise_floor` above -60 dB on an SFX = clean or regenerate |
| 14 | **Sample-rate mix** | 44.1 kHz outputs next to 48 kHz | `ffprobe -show_entries stream=sample_rate` must be 48000 |
| 15 | **Same sound, new name** | regenerating with one prompt gives near-identical takes | compare two variants' loudness envelopes (`astats` with `reset=1` per 10 ms) - correlation > 0.95 = not a real variant |

Tonal UI pitch check (R18): ffmpeg has no pitch meter; a 20-line Python script (numpy FFT on the WAV, strongest peak between
150 Hz and 2 kHz, cents off the nearest note of the key) does it. Spectra for a human look: `-lavfi showspectrumpic=s=800x400`
writes a PNG we can open with the file tool.

---

## 8. How we check a whole fight without ears (Godot)

- **Render, don't play:** Godot Movie Maker (`--write-movie out.avi --fixed-fps 30 --quit-after N`) writes the full mix as
  uncompressed audio inside the AVI (or a WAV beside a PNG sequence) and does not play it through speakers
  ([Godot docs](https://docs.godotengine.org/en/stable/tutorials/animation/creating_movies.html)). Run it on the hidden desktop
  like our stills. Then `ffmpeg -i out.avi -vn -c:a pcm_s16le fight.wav` and run every render check in section 6.
- **Log every sound:** the audio director script writes one line per played sound (time, event, file, pitch, dB, bus, mix state,
  fight-data inputs). Tests check R4, R6, R9, R15, R17 from the log alone, headless, with the Dummy driver.
- **Bus layout (start):** Master (HardLimiter -1.0 dB) <- SFX_Impacts, SFX_Body (footwork/breath), Voice (referee, corner,
  announcer), Crowd (sidechain compressor keyed from an impacts key bus), Music (sidechain compressor keyed from Voice and the
  impacts key), UI, Venue_Reverb (send). This refines the bus gains already in `SOUND_LIST.md` (Music -14, SFX -4, Crowd -12,
  UI -10), which stay as starting gains.

---

## 9. What would surpass the benchmarks (our edge, in plain words)

1. **The crowd knows the story.** We compute momentum, so the crowd builds, groans, hushes and erupts in step with the
   fight - the thing reviewers say Undisputed lacks.
2. **Silence before the big shot.** We know it is coming; nobody else does.
3. **Never a wrong line.** Every spoken claim is written from the settled result.
4. **Every punch tells you its power and target by ear** (R2, R6) - Undisputed's other complaint.
5. **Venue identity across the career:** a club hall to a pro debut sounds like a climb.
6. **Measured, not guessed:** every asset passes the lint (section 7) before he hears it, so his time goes to taste only.

## Sources
All links are inline above. Main primary sources: A Sound Effect interviews (MK1, TLOU2, Ghost of Tsushima); ADSR DOOM Q&A;
Game Developer "Recalling the Leviathan Axe"; Sound Particles interview with Paul Boechler (FIFA); Designing Sound (HDR in
Wwise; Gordon Durity; Garry Taylor loudness); DICE Frostbite HDR slides; Godot 4 docs (AudioStreamRandomizer, compressor,
hard limiter, audio import, Movie Maker); Wikipedia BAFTA Audio Achievement list. Reviews are used only for what players
praised or criticised, never for how a game was made.

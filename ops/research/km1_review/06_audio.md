# Reviewer #6 — Audio

## What the evidence says the game is

FightCamp is a PC combat-sports gym-management sim in Godot 4.7.2. The player runs a gym, books bouts, and watches 3D fights. The current milestone (S122, "PLAYABLE WITH A BOXER") is gated on 36 boxing clips passing the C223 animation gate; audio is explicitly a Stage-C concern per `AgentComms/roadmap.json` (`stage C`: "The fight is a BROADCAST" — cage/referee/corner/crowd/sound).

Audio evidence today:
- `Godot/scripts/FightAudio.gd` (480 lines) is an autoload that plays fight SFX and crowd from CC0 Freesound samples.
- `Godot/assets/audio/fight/` holds 10 glove landed, 6 glove blocked, 8 thud, 8 canvas scuff, 2 bell, 2 crowd murmur, 2 crowd roar WAVs — all CC0, ledgered in `fight/LICENCES.md`.
- `Godot/assets/audio/music/` holds a rejected Ludo.ai gym pilot plus 30 re-encoded Pixabay Music tracks under the Pixabay Content Licence.
- `Godot/assets/audio/unbreakable_noise_menu.mp3` is the current menu theme; `S75_PHASE0.html` lists it as a YouTube rip with no licence to ship.
- `Godot/scripts/UserSettings.gd` and `SettingsBoardPanel.gd` expose music volume/mute and playlist selection only — no SFX or crowd controls.
- `D18_MIC_CORNER_CALLS.md` and `D19_SOURCE_THE_CORNER.md` research a mic-corner-call feature, but no code implements it.
- `J22`/`J22B`/`J40` research define a 59-cue, ~300-file fight-audio target; the build covers roughly 5 of those cue families and ~38 files.

Audio playback cannot be verified: the operator runs Godot with the Dummy audio driver, so all playback-dependent conclusions are marked "Not verified".

## Missing material

- No `default_bus_layout.tres`; buses are created at runtime by `FightAudio`.
- No asset-manifest entries for `res://assets/audio/` (audio is outside the managed roots in `asset_manifest.json`).
- No corner-voice / mic recognition implementation despite D18/D19 research.
- No fighter breath, effort vocals, or pain cues.
- No kick/knee/elbow-specific impact layers; all strikes route through `punch_head`/`punch_body`.
- No dedicated ground/MMA Foley (mat thumps, cage rattle, cloth shorts, under-mat boom).
- No per-event crowd envelopes beyond a single murmur loop and two roar one-shots.

## Strengths to protect

1. **Licence discipline for fight samples.** `Godot/assets/audio/fight/LICENCES.md` lists every WAV with Freesound URL, author, CC0 tag, and date. This is the right pattern; keep it for every future asset.
2. **Layered impact design.** `FightAudio._play_strike_layers` plays glove + thud, and significant strikes boost the thud. This matches the J22/J22B recommendation to prefer layered thud/slap/leather over baked L/M/H one-shots.
3. **Bus separation.** `FightAudio` creates `Master`, `SFX`, `Crowd`, and `Music` buses, giving the mix a sensible separation even if no layout file exists yet.
4. **Beat routing is wired and tested.** `FightAudio.on_beat()` is called from `FightWorldLiveScreen.gd:1698/:1840` and `FightNightScreen.gd:1079`; round begin/end call `begin_round()`/`end_round()`. `tests/fight_audio_test.gd` asserts buses, sample counts, beat routing, crowd swell, and bell playback.
5. **Music playlists are licence-clean.** The S94 Pixabay playlist is re-encoded to small Ogg files and sourced from human-made tracks flagged non-AI, with licence terms recorded.

## Findings

### 1. Menu theme is an unlicensed YouTube rip — cannot ship

- **What:** `Godot/assets/audio/unbreakable_noise_menu.mp3` is used as the opening menu theme, hardcoded in `Godot/scripts/UserSettings.gd:9` as `MUSIC_PATH`.
- **Where:** `Godot/scripts/UserSettings.gd:9`; `Godot/assets/audio/unbreakable_noise_menu.mp3`; `Godot/assets/audio/unbreakable_noise_menu.mp3.import` (loop=true).
- **Evidence:** `research/S75_PHASE0.html` legal inventory row: "Menu music `unbreakable_noise_menu.mp3` — Taken from a YouTube video (operator, 2026-09-25) — no licence to ship it." Status `<span class="chip bad">Cannot ship</span>`. Action: "Fine in private builds. Before any public build: replace with a licensed or commissioned track."
- **Why it matters:** Shipping a YouTube-ripped track is a hard copyright blocker for EA/Steam. The game currently boots straight into it.
- **Severity:** Critical.
- **Confidence:** High.
- **Fix:** Replace `MUSIC_PATH` with one of the Pixabay playlist tracks or a newly commissioned/licensed menu theme, then remove `unbreakable_noise_menu.mp3` from the repo and export filters.
- **Effort:** Small (a few hours if using an existing playlist track; longer if commissioning).
- **CONFIRMED** by `S75_PHASE0.html`.

### 2. Settings expose only music volume — no SFX or crowd controls

- **What:** The settings screen has Music Level, Music On/Muted, and Playlist. There are no sliders or toggles for SFX, Crowd, or Master volume.
- **Where:** `Godot/scripts/SettingsBoardPanel.gd:119-141` builds only `music_volume`, `music_muted`, and `playlist_index`; `Godot/scripts/UserSettings.gd:38-56` stores only music fields.
- **Evidence:** No `sfx_volume`, `crowd_volume`, `master_volume`, or `voice_volume` constants, variables, setters, or UI rows exist. `FightAudio` hardcodes `SOUND_ENABLED := true` and `_CROWD_BASE_DB := -18.0`.
- **Why it matters:** Players expect independent control of music and fight audio. A management-sim audience will often turn music down or off while keeping fight SFX. The lack of SFX/crowd controls is a standard-of-care gap.
- **Severity:** Medium.
- **Confidence:** High.
- **Fix:** Add `sfx_volume_percent`, `crowd_volume_percent`, and `master_volume_percent` to `UserSettings`, persist them, and apply them to the `SFX`, `Crowd`, and `Master` buses in `FightAudio`/`UserSettings`. Mirror them in `SettingsBoardPanel._build_audio()`.
- **Effort:** Small.
- **CONFIRMED** by code inspection.

### 3. Audio assets are outside the licence gate

- **What:** `Godot/assets/asset_manifest.json` manages `assets/anim/`, `assets/models/`, and `assets/vendor/` but does not list `assets/audio/` as a managed root or include any audio packs.
- **Where:** `Godot/assets/asset_manifest.json` `managed_roots` array (lines 9-13) has no `res://assets/audio/` entry; no audio pack appears in the `packs` list.
- **Evidence:** `asset_manifest_test.gd` enforces that shipped code may reference only packs with status `"approved"`. Audio files are shipped but not tracked by the manifest, so the gate cannot catch an unlicensed audio file being referenced.
- **Why it matters:** The manifest exists precisely because the Reallusion CC export and Tripo free-plan fighters were once shipped by accident. Audio needs the same guard, especially once packs like Pixabay/Ludo/third-party SFX enter the build.
- **Severity:** Medium.
- **Confidence:** High.
- **Fix:** Add `res://assets/audio/` to `managed_roots` and add pack entries for `fight_cc0_samples`, `pixabay_music_playlist`, and `unbreakable_menu_placeholder` with correct statuses (`approved`, `approved`, `rejected`).
- **Effort:** Small.
- **CONFIRMED** by code inspection.

### 4. Corner voice / mic calls are researched but not implemented

- **What:** D18/D19 produced a detailed design for opt-in mic corner calls (Vosk, 38-word vocabulary, crowd-masking probability, push-to-talk). No code implements it.
- **Where:** Research in `research/D18_MIC_CORNER_CALLS.md` and `D19_SOURCE_THE_CORNER.md`; no references in `Godot/scripts/` to `Vosk`, `corner voice`, mic input, or `AudioEffectCapture`.
- **Evidence:** `S75_DIGEST.md` collected D18/D18B as research only. `AgentComms/roadmap.json` stage C done-when list includes "corner" presence and "sound: impacts, crowd, corner, commentary bed"; the corner audio portion is absent.
- **Why it matters:** Mic corner calls are in the product sheet (`S75_PHASE0.html`: "Mic corner calls with crowd noise: a settings option, off by default, keyboard fallback always there") and a stated selling point. Right now there is no audio fallback either.
- **Severity:** High (for the promised feature); Medium (for current vertical slice).
- **Confidence:** High.
- **Fix:** Implement the keyboard fallback first: a between-rounds corner-instruction picker with canned VO or simple text-to-speech cues. Defer true mic recognition until after D19's sourcing gaps are closed and a Vosk integration route is chosen.
- **Effort:** Large for full feature; Medium for keyboard-only fallback.
- **CONFIRMED** by missing code.

### 5. Sample count is far below the researched variation floor

- **What:** J22 recommends ~8-12 variants for high-rate landed punches/kicks and ~7 as a practical floor. The build has 10 glove landed, 6 thud, 6 blocked, 8 canvas scuff, 2 bell, 2 murmur, 2 roar. No kicks, knees, elbows, bodyfalls, or ground Foley exist.
- **Where:** `Godot/assets/audio/fight/` listing; `Godot/scripts/FightAudio.gd:18-21` presets are `punch_head`, `punch_body`, `block`, `miss`, `punch_head_sig`, `punch_body_sig`.
- **Evidence:** J22 §1 cue list has 59 cues; J22 §2 recommends 7+ quasi-randomized one-shots for high-rate events; J40 shortlist confirms free-world gaps in kick/leather/mat/breath. `tests/fight_audio_test.gd:54-65` checks only the small pools that exist.
- **Why it matters:** With ~491 beats/fight (J22) and many of them landed strikes, 10 glove files will repeat audibly within seconds. Repetition undermines the "authentic fight-night" identity.
- **Severity:** High.
- **Confidence:** High.
- **Fix:** Follow J22/J40 priorities: (1) increase landed-strike layers to at least 12 glove + 12 thud + 6 slap/bone; (2) add kick/knee/elbow layers; (3) add block leather and slip whoosh; (4) add bodyfall/mat/cage Foley. Use CC0/Mixkit/Pixabay first, then commission or buy a $47 Gamemaster Pro pack if the operator approves.
- **Effort:** Large.
- **CONFIRMED** by file count and research.

### 6. All strikes collapse to punch_head/punch_body — no ruleset or limb identity

- **What:** `FightAudio._route_beat` maps every landed action to `punch_head` or `punch_body` based only on `target_region`. It ignores `technique` (kick/knee/elbow), `discipline`, and `limb`.
- **Where:** `Godot/scripts/FightAudio.gd:433-466`.
- **Evidence:** `punch_head`/`punch_body` presets play the same glove+thud layers regardless of whether the engine threw a boxing jab, a muay thai head kick, or an MMA ground strike. There are no `kick_head`, `knee_body`, `elbow`, or `ground_strike` presets.
- **Why it matters:** Kickboxing and Muay Thai are in v1 scope. A head kick sounding identical to a jab is a readability and authenticity failure. J22 explicitly lists `imp_kick_head`, `imp_kick_body`, `imp_kick_leg`, `imp_knee`, `imp_elbow`, `imp_ground_strike` as distinct cues.
- **Severity:** High.
- **Confidence:** High.
- **Fix:** Expand `_route_beat` to read `technique`/`technique_class`/`limb` and route to new presets. Add at least `kick_head`, `kick_body`, `kick_leg`, `knee`, `elbow`, `ground_strike` cue families.
- **Effort:** Medium.
- **CONFIRMED** by code inspection.

### 7. Grapple audio reuses punch cues and ignores ground Foley

- **What:** Grapple beats grade >= 2 play `punch_body` or `punch_body_sig`; there is no dedicated ground control bed, mat scuff, cloth, or cage rattle.
- **Where:** `Godot/scripts/FightAudio.gd:469-478`.
- **Evidence:** J22/J22B §Q3 note that prolonged `grapple_control` should be quieter — breath + intermittent scrape + ducked/murmuring crowd — not impact spam. The build plays a body-shot sound on grapples.
- **Why it matters:** Grappling is a core part of MMA and the ground game is already reachable. Hearing a punch thud every time a control position advances will read as broken.
- **Severity:** High.
- **Confidence:** High.
- **Fix:** Add `grapple_control` (low bed/scrape), `grapple_transition`, `mat_thump`, and `cloth_shorts` cues. Route grade 2/3 grapples to transition/mat sounds, not punch_body. Duck the crowd bed during long control.
- **Effort:** Medium.
- **CONFIRMED** by code inspection and J22B research.

### 8. Crowd system is too simple for broadcast authenticity

- **What:** `FightAudio` has one looping murmur bed and two roar one-shots. Swell is a 2.5 s volume fade between `_CROWD_BASE_DB` and `_CROWD_SWELL_DB`. There is no idle/murmur/stall distinction, no near-finish swell, and no per-event envelope.
- **Where:** `Godot/scripts/FightAudio.gd:14-16`, `:262-312`, `:285-294`.
- **Evidence:** J22B Q4 maps engine grades to crowd cues (`crowd_cheer_landed`, `crowd_cheer_significant`, `crowd_gasp_kd`, `crowd_finish`, optional `crowd_near_finish`, `crowd_murmur` for stall). The build has only murmur + roar.
- **Why it matters:** Crowd sells the broadcast. A single murmur loop plus volume dip cannot express landed strikes, significant strikes, knockdowns, submission threats, finishes, or lulls.
- **Severity:** Medium.
- **Confidence:** High.
- **Fix:** Implement J22's 7-cue crowd family. Add `crowd_cheer_landed`, `crowd_cheer_significant`, `crowd_gasp_kd`, `crowd_finish`, optional `crowd_near_finish`, and a disapproval/stall murmur. Rate-limit landed cheers so they don't fire on every beat.
- **Effort:** Medium.
- **CONFIRMED** by code inspection.

### 9. No fighter breath / effort / pain layer

- **What:** There are no breath loops, exertion grunts, pain vocals, or fatigue-driven vocal beds. `FightAudio` has no voice bus or voice samples.
- **Where:** `Godot/assets/audio/fight/` has no `voice/` folder; `Godot/scripts/FightAudio.gd` has no breath/effort code.
- **Evidence:** J22 §C lists `voc_effort_light`, `voc_effort_heavy`, `voc_pain_light`, `voc_pain_heavy`, `breath_loop`, `breath_burst`, `voc_knockdown` as core cues. J40 §2.5 notes continuous breath loops are "NOT FOUND" in free audio and recommends synth/generate/commission.
- **Why it matters:** Fighters sound silent except for impacts and crowd. In a long fight, breath is the main humanising layer and the carrier of fatigue information.
- **Severity:** Medium.
- **Confidence:** High.
- **Fix:** Generate or commission a small breath loop bank (low/medium/high fatigue) and sparse effort/pain one-shots. Gate them by fatigue and significant events so they don't spam. ElevenLabs Creator (~$22) or a Foley day are the cleanest paths per J40.
- **Effort:** Medium.
- **CONFIRMED** by missing assets.

### 10. No runtime bus layout file — mixing is code-only

- **What:** `FightAudio._ensure_buses()` creates buses at runtime. There is no `default_bus_layout.tres` in the Godot project.
- **Where:** `Godot/scripts/FightAudio.gd:57-66`; `Glob` search for `default_bus_layout.tres` returned no matches.
- **Evidence:** Runtime bus creation works, but it prevents authoring ducking/sidechain, reverb sends, EQ, or compression in the editor. Every mix change requires a code edit.
- **Why it matters:** Stage C ("broadcast") will need ducking between music, crowd, and impacts, plus arena reverb. Doing it all in code is error-prone and not visible to non-programmers.
- **Severity:** Medium.
- **Confidence:** High.
- **Fix:** Create `Godot/default_bus_layout.tres` with `Master`, `SFX`, `Crowd`, `Music`, and `Voice` buses. Move `FightAudio._ensure_buses()` to a safety fallback that only adds missing buses.
- **Effort:** Small.
- **CONFIRMED** by missing file and code inspection.

### 11. Defensive outcomes other than "blocked" are silent

- **What:** `FightAudio._route_beat` handles `blocked` via `contact == "blocked"`, but slips (`slipped`), partial blocks (`absorbed`/`glancing`), and misses all play either `miss` or no sound.
- **Where:** `Godot/scripts/FightAudio.gd:422-430`, `:439-468`.
- **Evidence:** J22 §B lists `def_slip_air`, `def_parry`, `def_block_glove`, `def_block_arm`, `def_catch_kick`, etc. The test fixture in `tests/fight_stage_director_test.gd` produces `slipped` and `absorbed` beats, but `FightAudio` has no cue for them.
- **Why it matters:** Defence is a major part of the broadcast. A slipped head kick should have a whoosh/air cue; a caught kick or parry should have a distinct sound. Silence makes defence invisible to the ear.
- **Severity:** Medium.
- **Confidence:** High.
- **Fix:** Add `slip_whoosh`, `parry`, `catch_kick`, and `absorbed_thud` presets and route by `contact` and `defense_class`.
- **Effort:** Small.
- **CONFIRMED** by code inspection.

### 12. Menu music may continue under fight audio

- **What:** `UserSettings` keeps a single `AudioStreamPlayer` for background music. `FightAudio.begin_round()` starts the crowd but nothing stops or ducks the menu music player.
- **Where:** `Godot/scripts/UserSettings.gd:226-236`, `:286-296`; `Godot/scripts/FightAudio.gd:262-270` (`start_crowd`).
- **Evidence:** `FightNightScreen` and `FightWorldLiveScreen` call `FIGHT_AUDIO.begin_round()`; neither calls `UserSettings.stop_music()` or `set_music_muted()`. The music player's `process_mode` is `PROCESS_MODE_ALWAYS`, so it will continue across scene changes unless explicitly stopped.
- **Why it matters:** Music clashing with crowd/impacts during a fight is a common amateur-audio failure.
- **Severity:** Medium.
- **Confidence:** Medium (logic is clear, but playback not verified).
- **Fix:** Add `pause_music_during_fight` / `duck_music_during_fight` logic in `UserSettings`, called from `FightAudio.begin_round()` and `end_round()`.
- **Effort:** Small.
- **ASSUMPTION** pending playback verification.

### 13. Round end may double-bell if both screens are involved

- **What:** `FightAudio.end_round()` plays the bell. `FightNightIntro._beat_bell()` also plays the bell. Depending on scene flow, the start-of-round bell and end-of-round bell may fire close together or overlap.
- **Where:** `Godot/scripts/FightAudio.gd:412-419`; `Godot/scripts/FightNightIntro.gd:354-356`.
- **Evidence:** No guard exists to prevent a bell from playing while another bell is already playing. `_bell_player` is a single `AudioStreamPlayer` without `is_playing()` checks.
- **Why it matters:** Overlapping or cut-off bells break the broadcast polish.
- **Severity:** Low.
- **Confidence:** Medium.
- **Fix:** Add a `last_bell_time_s` guard or check `_bell_player.is_playing()` before triggering a new bell.
- **Effort:** Small.
- **ASSUMPTION** pending playback verification.

### 14. FightAudio `_load_pcm_wav` is a custom WAV parser — maintenance risk

- **What:** Instead of using Godot's `ResourceLoader.load()` for WAVs, `FightAudio` parses RIFF/WAVE chunks manually.
- **Where:** `Godot/scripts/FightAudio.gd:98-139`.
- **Evidence:** The parser handles only PCM 8/16-bit, skips non-`fmt `/`data` chunks, and does not validate chunk alignment or extended fmt headers. It also bypasses Godot's import pipeline (no `.import` caching, no loop metadata from the editor).
- **Why it matters:** A custom parser is a latent bug surface for non-PCM WAVs, odd chunk ordering, or stereo vs mono mismatches. It also means audio files are not preloaded efficiently.
- **Severity:** Low.
- **Confidence:** High.
- **Fix:** Replace `_load_pcm_wav` with `ResourceLoader.load(path)` after ensuring the `.import` files are committed; keep the parser only as a fallback for dynamically generated PCM.
- **Effort:** Small.
- **CONFIRMED** by code inspection.

### 15. Ludo.ai gym theme is present but operator-rejected

- **What:** `Godot/assets/audio/music/gym_theme_ludo_pilot.mp3` exists but was rejected by the operator on 2026-09-27 for lacking melody.
- **Where:** `Godot/assets/audio/music/gym_theme_ludo_pilot.mp3`; `Godot/assets/audio/music/SOURCES.md:4-5`.
- **Evidence:** `SOURCES.md`: "REJECTED by the operator 2026-09-27: 'just a pilot with rythm drums there was no melody or anything else' - redo with a lead melody".
- **Why it matters:** It is dead weight in the repo and could be referenced accidentally.
- **Severity:** Low.
- **Confidence:** High.
- **Fix:** Remove the rejected file and its `.import` from the repo, or mark it `rejected` in the asset manifest if kept for provenance.
- **Effort:** Small.
- **CONFIRMED** by `SOURCES.md`.

## Bottom line

Audio is currently a prototype that meets the "fight makes sounds" bar for internal builds but is not close to the Stage-C broadcast identity. The single blocker is the unlicensed menu music. The largest quality gaps are sample variety (repetition), missing cue families (kicks, grappling, breath/voice, defence), and missing mix controls. Corner voice is researched but unimplemented. All playback-dependent feel judgements (sync, ducking, balance) are marked not-verified because the build runs Dummy audio here.

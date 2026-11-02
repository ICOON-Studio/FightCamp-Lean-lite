# JOHN_SFX_S274_BRIEF_JOHN - John answer (seat queue SQ8)

Brief: research/JOHN_SFX_S274_BRIEF.md
Sent: 2026-10-20 15:40 | collected: 2026-10-20 16:10 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): JOHN_SFX_S274.md
Verify the sources before using it.

---

Starting on JOHN SFX S274 now. I'll go through every GDC Bundle year from 2015 to 2024, then the other free sources, and build the layered set for each cue. Everything gets pasted here in full when it's done.

The SFX research is underway. I won't download any audio, since Claude downloads the approved batch.

**JOHN_SFX_S274 is done (part 1 of 2).** The Sonniss GDC bundles from 2015 to 2024 are the best free source of studio fight sound. Each pack in them holds only 2–5 sample files, though, and none is a boxing library. I checked every file name and size against Sonniss's official torrent file lists and tracklists, without downloading any audio.

**Sonniss licence**, from the [Sonniss GDC licence page](https://sonniss.com/gdc-bundle-license/) (v2.0, effective 2026-08-27): "may use and modify the licensed sound effects for personal and commercial projects without attribution to the original creator." You can't sell or redistribute the sounds as sounds, and AI training is banned. Using them in a game sold on Steam is fine.

**The best Sonniss finds:**
- **2017:**
  - Borg Sound "Gym, Boxing, Punching bag hits, chain perspective.wav".
  - Gamemaster `punch_blocked_02.wav` and `punch_general_body_impact_03.wav`, at 96 kHz/24-bit.
  - "Crowd Lutte .wav". Going by the name, it's probably a Senegalese wrestling crowd (GUESS).
- **2018:** Chris Alan "Face Slap Hard 04", "Deep Punch 02" and "Body Slam Floor 08".
- **2019:** 2496 arena crowd swells.
- **2020:**
  - PMSFX Lethal Blow, recorded at 192 kHz/24-bit.
  - Sonic Bat "SBssa_Crowd Booing 002.wav", at 96 kHz/24-bit.

No bundle year has ring ropes, a corner stool or a real boxing bell. The best free bell is BigSoundBank "Boxing bell #1" (#1926): CC0, 48 kHz/24-bit, recorded on a Neumann KM184.

**Other sources:**
- **Kenney Impact Sounds (CC0):** 130 OGG files, e.g. `impactPunch_heavy/medium`, `impactSoft`, `impactBell_heavy` and `footstep_carpet`.
- **Mixkit:** a free licence with no attribution, and video games are allowed. You can't redistribute the files on their own or register them with a rights-management service. It has 12 boxing sounds (IDs 2049–2165), a boo (#463) and a cheer (#462).
- **Pixabay:** free with no attribution, but you can't resell the sounds on their own. They're mostly MP3, and I couldn't open the individual pages (UNVERIFIED).
- **OpenGameArt (CC0):** low quality.
- **Excluded:**
  - moodfrog and SFXMint, because they're AI-generated.
  - floraphonic, because it costs $5.
  - The SoundSpool bell, which is a bicycle bell recorded on a Zoom H1.

**S274 layers for each cue (part 2 of 2).** S means a Sonniss bundle, followed by its year.

- **Head, clean:** Deep Punch 02 (S2018) · PM_LB_DESIGNED_PUNCH_SIMPLE_CLEAN_DEEP_48 (S2020) · PUNCH_DESIGNED_LIGHT_78 (S2020) · Kenney impactPunch_medium
- **Body, clean:** punch_general_body_impact_03 (S2017) · Gym punching bag hits (S2017) · PM_LB_SOURCE_PUNCH_SMACK_LETTUCE…16 (S2020) · Kenney impactPunch_heavy
- **Blocked:** punch_blocked_02 (S2017) · PM_LB_DESIGNED_GRAB_BLOCK_THROW_7 (S2020) · RTS "FLOG Leather Hit Smack 01" (S2019)
- **Glancing:** Face Slap Hard 04 (S2018) · Whoosh_Cloth_Leather_Fight_174 (S2016) · Kenney impactSoft_medium
- **Swing whoosh:** Airborne "Whoosh,Organic,Fabric,Glove…" (S2019) · Soundholder t-shirt fast swings (S2019) · David Dumais HighSwings15 (S2020)
- **Footwork on canvas:** Filmnoise "SNEAKER PLASTIC FLOOR MAT…" and "SOCKS WOOD DECK…FIGHT" (S2016) · Studio 23 Doormat_Scrapes_01 (S2019) · Kenney footstep_carpet
- **Ropes (GUESS substitute):** Boat Pulley "BOAT_042…Tension_Release_w_Wood_Creaks" (S2015) · Systematic-Sound leather jacket movement (S2020)
- **Bell:** BigSoundBank #1926 · Mechanical Wave BELLHand_Metallic Bell_22 (S2024) · Kenney impactBell_heavy · Chris Alan cowbell (S2018)
- **Corner stool (GUESS substitute):** "Drop metal handle on floor" (S2017) · Borg duffel bag drop/place (S2019) · Kenney impactWood/Plank_medium
- **Crowd bed:** Crowd Lutte (S2017) · SBssa_Crowd Talking 010 (S2020) · SBhma EHF Cup Match 002 (S2024)
- **Rise:** 2496 Forum "Short Swell 2" · 2496 Staples "Short Swell 24" (5.1, needs a stereo fold-down) · GAF "Cheer Applause…Crescendo" (S2016)
- **Roar:** 2496 Rose Bowl "Big Surge" (5.1) · SBssa_Goal Miss 002 · Sound Ex Machina "Score 4" (S2015) · Mixkit #462
- **Boo:** SBssa_Crowd Booing 002 · Airborne "Boo,Aww" (S2018) · basketball "boo, crowd clapping…" (S2017) · Mixkit #463
- **Applause:** Soundrangers audience_cheers_13 (S2018) · Sound Ex Machina "Crowd Applause 4" and "Audience applauding 09" (S2015) · BigSoundBank #0019
- **Knockdown thud:** Body Slam Floor 08 (S2018) · RL_bodyfall_Wood_Rustic…Soft_Impact_07 (S2019) · IMPACT_LOW_THUD_10 (S2020) · Baxter "10 Hit Deep Thud" (S2019)

**Download size:**
- **Torrent route, about 500.6 MB for the 42 Sonniss files.** You tick single files in Sonniss's official torrents, which the licence allows. By year: 2015 59.4 MB, 2016 33.2, 2017 115.9, 2018 10.6, 2019 62.8, 2020 135.5, 2024 83.3.
- **Non-Sonniss files:** the Kenney zip, two BigSoundBank files and two Mixkit files. Their sizes are UNVERIFIED, so the grand total of about 0.5 GB is a GUESS.
- **ZIP route, 168.3 GB.** Sonniss doesn't say which ZIP part holds which pack, so you'd need the full bundle for each of the 7 years. Use the torrent route.

**Not verified:**
- I couldn't open the 2024 GDC page because of a Cloudflare check.
- Several Sonniss product pages don't list sample rate or bit depth.
- The Freesound and NSFRL licences are unconfirmed.

The full report, including Appendix B, is attached. Appendix B lists every file in the roughly 100 candidate packs, with the exact licence quotes.

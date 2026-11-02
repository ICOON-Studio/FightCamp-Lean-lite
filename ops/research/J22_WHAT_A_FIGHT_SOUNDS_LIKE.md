59 distinct cues, ≈302 total files with variants, cheapest viable route ≈ $47 USD (Gamemaster Pro Sound Collection + Sonniss GDC / CC0 for gaps).

# FightCamp J22 — What a Fight Has to Sound Like and What That Costs

**Research date:** 2026-09-20 (Asia/Nicosia)  
**Scope:** Cue list + sourcing only (no audio files). Beat model: one beat ≈ 1.1 s; three 3‑min rounds ≈ **491 beats/fight**. Beat fields: technique, body region (head/neck, body, L/R leg, arms), contact quality (landed / significant), knockdown, blocked/slipped, round+time, fatigue. Disciplines: boxing, kickboxing/Muay Thai, MMA, wrestling, judo, BJJ. **Zero fight audio today.**

**Label legend:** **DOCUMENTED** = claim tied to a URL opened this session · **INFERENCE** = reasoned from beat model + industry practice · **NOT FOUND** = searched/fetched; no verified figure.

---

Absolute floor ≈ $0 (Sonniss + CC0 only) with frank combat-impact quality risk.

---

## 1) Full cue list (grouped) with beat-data triggers

Variant counts below are **recommended for FightCamp** (INFERENCE from published “7” baseline + ~491 beats/fight; see §2). They are **not** invented pack contents.

### A. Impacts (core of perceived realism)

| Cue ID | What it sells | Primary beat triggers | Rec. variants |
|--------|---------------|----------------------|---------------|
| `imp_punch_head` | Glove/fist → head/neck | technique ∈ punches; region=head/neck; landed | 8–12 |
| `imp_punch_body` | Body shot thud | punches; region=body; landed | 8–12 |
| `imp_punch_leg` | Low punch / rare | punches; region=L/R leg; landed | 5 |
| `imp_kick_head` | Kick / head kick | kicks (KB/MT/MMA); head; landed | 8 |
| `imp_kick_body` | Body kick | kicks; body; landed | 8 |
| `imp_kick_leg` | Shin-on-thigh / low kick | kicks; L/R leg; landed | 8–12 |
| `imp_knee` | Clinch / mid-range knee | knee techniques; landed | 6 |
| `imp_elbow` | Elbow (MT/MMA) | elbow; landed | 6 |
| `imp_significant_overlay` | Extra “beef” on big hits | contact=significant (any strike) | 6–8 |
| `imp_knockdown` | Heavy finishing impact | knockdown=true | 4–6 |
| `imp_bodyfall_canvas` | Fighter hits mat/canvas | knockdown or throw/slam land | 5–8 |
| `imp_slam_mat` | Wrestling/judo slam | slam/takedown complete | 5–8 |
| `imp_throw_land` | Judo/BJJ throw landing | throw technique success | 5 |
| `imp_ground_strike` | GnP / ground punches | ground + punch landed | 6 |
| `imp_clinch_body` | Body-in-clinch thud | clinch contact / dirty boxing | 5 |
| `imp_glove_on_glove` | Leather-on-leather (blocked punch feel) | punch + blocked (shared w/ defensive) | 6 |
| `foley_grab_flesh` | Grab / clinch grip | grab, clinch start, underhooks | 5 |
| `foley_scrape_mat` | Flesh/shorts on mat (BJJ/wrestle) | ground scramble beats | 5–8 |

**DOCUMENTED industry parallel:** EA Sports UFC 2 split impacts into feel categories (“slappy”, “thuddy”, “light”, “meaty”, “boney”), layered Foley + library, and built **hundreds of strike×body-part combinations**; critical strikes got extra Hollywood layers. Source: https://www.supergmusic.com/sound-design-ea-sports-ufc-2/

**INFERENCE for FightCamp:** Prefer **layered** playback (thud + slap + leather ± bone) driven by region + contact quality, rather than one baked L/M/H file per technique (see §3). Cue IDs above can be one-shots *or* mix buses that fire layer subsets.

**Subtotal A:** 18 distinct cues · ≈ **120–150 files** at recommended variants.

### B. Defensive

| Cue ID | What it sells | Primary beat triggers | Rec. variants |
|--------|---------------|----------------------|---------------|
| `def_block_glove` | Catch on gloves | blocked + punch | 6–8 |
| `def_block_arm` | Check / forearm | blocked + kick/knee | 5–6 |
| `def_slip_air` | Slip / roll near-miss whoosh | slipped=true | 5–6 |
| `def_parry` | Deflect | parry / redirect techniques | 4–5 |
| `def_catch_kick` | Catch kick | catch-kick success | 4 |
| `def_sprawl` | Sprawl impact | sprawl vs takedown | 4–5 |
| `def_guard_scrape` | BJJ frame / guard | BJJ defensive frames | 4 |
| `def_clinch_pummel` | Pummel / hand fight | clinch hand-fight beats | 4 |

**Subtotal B:** 8 cues · ≈ **40 files**.

### C. Effort / breath / pain (fighters)

| Cue ID | What it sells | Primary beat triggers | Rec. variants |
|--------|---------------|----------------------|---------------|
| `voc_effort_light` | Short strike effort | strike thrown; fatigue low–mid | 8–12 |
| `voc_effort_heavy` | Big commitment | significant strike / power technique | 6–8 |
| `voc_pain_light` | Taken shot | landed against; not significant | 6–8 |
| `voc_pain_heavy` | Hurt | significant against / knockdown | 5–6 |
| `voc_fatigue_ramp` | Tired vocal colour | fatigue high; any effort | 5–6 |
| `breath_loop` | Continuous breath bed | always; intensity←fatigue | 3–4 loops |
| `breath_burst` | After flurry | multi-hit windows / round late | 5 |
| `voc_knockdown` | Knockdown vocal | knockdown=true | 3–4 |

**DOCUMENTED:** UFC 2 treated fight vocals as mostly sparse (fighters often quiet in real fights), with a 1–4 “noisiness” scale per fighter and more vocals in gym than fight; separate recording day for whiffs/grunts. https://www.supergmusic.com/sound-design-ea-sports-ufc-2/

**INFERENCE:** Do **not** voice every beat; gate by fatigue + significant/knockdown. Plan ≥2 speaker banks (e.g. deeper / higher) if roster diversity matters — banks multiply file count (not counted in M below unless product requires them).

**Subtotal C:** 8 cues · ≈ **50 files** (single bank).

### D. Crowd

| Cue ID | What it sells | Primary beat triggers | Rec. variants |
|--------|---------------|----------------------|---------------|
| `crowd_idle_loop` | Bed | fight running | 2–3 long loops |
| `crowd_cheer_landed` | Hit reaction | landed (rate-limit) | 6–8 |
| `crowd_cheer_significant` | Big hit | significant | 5–6 |
| `crowd_gasp_kd` | Knockdown | knockdown | 4 |
| `crowd_round_swell` | End of round | round end | 3–4 |
| `crowd_finish` | Stoppage / decision energy | fight end | 3–4 |
| `crowd_murmur` | Soft disapproval / lull | optional; long idle | 2–3 |

**DOCUMENTED:** UFC 2 prioritized crowd + commentary as first-class; critical strikes sold by crowd as much as impact. https://www.supergmusic.com/sound-design-ea-sports-ufc-2/

**Subtotal D:** 7 cues · ≈ **28 files**.

### E. Room / canvas / gear Foley

| Cue ID | What it sells | Primary beat triggers | Rec. variants |
|--------|---------------|----------------------|---------------|
| `room_tone_arena` | Space | always under mix | 2 loops |
| `canvas_scuff` | Foot on canvas/mat | movement / stance shifts | 7–8 |
| `canvas_step` | Steps | locomotion beats | 7–8 |
| `rope_creak` | Boxing ropes | rope lean / clinch on ropes | 4 |
| `cage_rattle` | MMA cage | cage press / slam to fence | 5–6 |
| `mat_bass_thump` | Under-mat boom on slam | slam / bodyfall | 4–5 |
| `cloth_shorts` | Shorts / rashguard | scrambles, sprawls | 5 |
| `leather_creak` | Glove/wrap creak | prep, clinch, rare | 4 |

**DOCUMENTED:** UFC 2 rented a gym Octagon, then recorded real UFC Octagon scuffs/slams/cage; under-mat mics for bass. https://www.supergmusic.com/sound-design-ea-sports-ufc-2/

**Subtotal E:** 8 cues · ≈ **42 files**.

### F. Officials / corner

| Cue ID | What it sells | Primary beat triggers | Rec. variants |
|--------|---------------|----------------------|---------------|
| `ref_break_clap` | Ref separates | clinch break / reset | 3 |
| `corner_between_round` | Stool / bucket / towel bed | between rounds | 3–4 |
| `water_bottle` | Corner drink | between rounds | 2–3 |
| `coach_shout_distant` | Distant corner (optional) | between rounds / late fight | 4 |
| `ref_verbal` | “Fight!” etc. (optional VO) | round start | 2–3 |

**INFERENCE:** Keep sparse; FightCamp is a sim, not a broadcast show. Skip full commentary unless scope expands.

**Subtotal F:** 5 cues · ≈ **16 files**.

### G. Bell / rounds / time

| Cue ID | What it sells | Primary beat triggers | Rec. variants |
|--------|---------------|----------------------|---------------|
| `bell_start` | Round start | round begin | 2–3 |
| `bell_end` | Round / fight end | round end | 2–3 |
| `ten_sec_warn` | Clapper / warning (optional) | t−10 s in round | 2 |
| `airhorn_alt` | Org-style end (optional) | alt to bell | 2 |
| `ui_round_card` | Card flip / whoosh (optional UI) | round change | 2 |

**Subtotal G:** 5 cues · ≈ **12 files**.

### Cue totals (implementation set)

| Group | Distinct cues | ≈ Files w/ variants |
|-------|---------------|---------------------|
| Impacts | 18 | 135 |
| Defensive | 8 | 40 |
| Effort/breath | 8 | 50 |
| Crowd | 7 | 28 |
| Room/canvas | 8 | 42 |
| Officials/corner | 5 | 16 |
| Bell/rounds | 5 | 12 |
| **TOTAL** | **59** | **≈302** |

**INFERENCE:** If using **layered** impacts (thud/slap/leather as separate banks of ~8 each = 24 layer files covering most strike×region via mix rules), **distinct cue count stays ~59** but **baked one-shot impact files drop**; combinatorial variety rises (see §3). M≈302 assumes mostly one-shot banks as above.

---

## 2) How many variants before repetition is audible?

| Claim | Status | Source |
|-------|--------|--------|
| Book *Audio for Games* suggests **7** quasi-randomized footsteps as a practical setup (“Nonstandard Randomization”, cited p. 116) | **DOCUMENTED** (via thesis citing the book) | https://www.diva-portal.org/smash/get/diva2:1025742/FULLTEXT01.pdf |
| Thesis compared **7 vs 64** footstep samples (quasi-random, no consecutive repeat); **64 perceived more realistic** | **DOCUMENTED** | same PDF / http://urn.kb.se/resolve?urn=urn%3Anbn%3Ase%3Altu%3Adiva-52372 |
| Informal industry write-up: **no magic number**; examples **3–8** or **10–16** per step type/surface depending on memory and focus | **DOCUMENTED** | http://blog.lostchocolatelab.com/2010/03/footsteps-informal-game-sound-study.html |
| Practitioner consensus (forums): often **3–5** or **~7** per surface + subtle pitch/volume; shuffle containers | **DOCUMENTED** (community, not GDC paper) | https://www.reddit.com/r/GameAudio/comments/1rrogai/steps_sounds/ |
| Published **punch-specific** “magic number” from GDC/Wwise talks | **NOT FOUND** (searched; punches discussed as layered categories in UFC 2 write-up, not a fixed N) | — |
| Official Wwise “7 variations” product doc for punches | **NOT FOUND** | — |

**INFERENCE for FightCamp (~491 beats/fight, impacts every beat when active):**

- Treat **7 as the published baseline floor** for high-rate one-shots (footstep literature).
- For **landed punches/kicks** (highest rate): target **8–12** distinct performances **or** fewer files with **layered** construction + pitch/vol randomization.
- Use **shuffle / no-immediate-repeat** (Wwise-style Random Container practice is industry-standard; specific Wwise punch tutorial: https://gameaudioresource.com/2019/08/08/983/).
- Rare events (bell, knockdown): **2–4** is enough.

---

## 3) One sample L/M/H vs layered thud + slap + leather

**Industry practice (DOCUMENTED):** UFC 2 designed by **feel category + layering** (slap of foot on flesh + meat/thud of body + “flappiness” for gut; leather/flesh language in reviews). Critical hits added extra Hollywood layers. https://www.supergmusic.com/sound-design-ea-sports-ufc-2/

BOOM Violent Combat keywords explicitly include **PUNCH, SLAP, LEATHER, IMPACT, KICK, GRAPPLE**, etc., and sells both raw Construction Kit and Designed one-shots — i.e. the market expects designers to **combine** elements. https://www.boomlibrary.com/sound-effects/violent-combat/

| Approach | What you store | Variety per file | Fit to beat data |
|----------|----------------|------------------|------------------|
| **Baked L / M / H one-shots** | 3 loudness variants per cue | Low–medium: once you hear the same M file, it’s the same transient shape | Maps cleanly to contact quality but **repeats the whole fingerprint** |
| **Layered thud + slap + leather (± bone/cloth)** | Small banks per layer; runtime mix by region + significant flag | **Higher variety per source file** (INFERENCE): same slap + different thud/leather = new composite; N layers with V variants ≈ large combinatorial space | Head → more slap/bone; body → more thud; gloves → leather; significant → add bone/Hollywood layer |

**Answer:** **Layered thud+slap+leather gives more variety per file** and matches documented fight-game/film practice. Use L/M/H only as **gain/EQ macros** on the mix, or as which **subset of layers** fires — not as three fully baked clones of the same hit.

---

## 4) Top 5 cues if only five are affordable (rank = perceived realism)

Ranked for a beat-driven fight sim (INFERENCE from UFC 2 priorities + beat frequency):

1. **Landed strike impacts (layered punch/kick by region)** — without these the sim is mute violence.  
2. **Significant / knockdown impact + bodyfall** — sell the peaks players remember.  
3. **Block / glove leather + slip whoosh** — makes defense read as physical, not animation-only.  
4. **Effort/pain vocals (sparse) + fatigue breath** — humanizes ~491 beats without cartoon spam.  
5. **Crowd bed + cheer on significant/KD** — cheapest “broadcast legitimacy” layer (UFC 2: crowd carried critical moments).

*Next cut if budget grows:* canvas scuffs, bell, cage/rope, corner beds.

---

## 5) Sourcing with real prices (routes RANKED)

All prices USD unless noted. Taxes/VAT extra where stores say so.

### Commercial packs (verified)

| Product | Price | Contents (as published) | Licence note | URL |
|---------|-------|-------------------------|--------------|-----|
| Unity **Punch & Combat SFX** | **$15** | Listing shows pack; search aggregators cite **179** WAVs (punches, kicks, blocks, falls, whooshes) — treat 179 as **secondary** until Unity page enumerates | Standard Unity Asset Store EULA | https://assetstore.unity.com/packages/audio/sound-fx/punch-combat-sfx-268225 |
| Unity **Punch Sound Pack** (Gamemaster) | **$10** | **45** punches + **150** bonus (whooshes, UI, some grunts, Foley); ~16.3 MB | Unity EULA / RF commercial in product | https://assetstore.unity.com/packages/audio/sound-fx/punch-sound-pack-58260 · https://gamemaster-audio.itch.io/punch-sound-pack |
| Unity **Punches And Fighting Sounds** | **$14.99** | Size 12.5 MB (clip count **NOT FOUND** on page) | Unity EULA | https://marketplace.unity.com/packages/audio/sound-fx/punches-and-fighting-sounds-293202 |
| Unity **Combat Hits – Hand To Hand** | **$29** | Search cites **335** WAVs; Unity page did not enumerate in fetch | Unity EULA | https://marketplace.unity.com/packages/audio/sound-fx/combat-hits-hand-to-hand-fighting-sfx-263530 |
| GameDev Market **Swords and Fists** | **$12** | **50** punches, 60 swords, 20 clubs, 20 movement; WAV 16-bit/44.1 | GDM Pro Licence (commercial in Media Products; no resale as SFX; **no AI training**) | https://gamedevmarket.net/asset/swords-and-fists-fighting-sfx-pack |
| Gamemaster **Punch and Combat Sounds** (itch) | **min $10** | **720** sounds: 68 punches/kicks, 395 male screams/grunts, 198 cloth/leather, 59 whooshes | RF commercial (author claim) | https://gamemaster-audio.itch.io/punch-and-combat-sounds |
| Gamemaster **Pro Sound Collection** | **$47** | **8,076** SFX across 17 packs (includes punch/combat); “normally $342” separate | RF commercial (author claim) | same itch pages |
| BOOM **Violent Combat** | **From $139** (official) | Designed: **100 files / 600 sounds / 0.7 GB**; Construction Kit: **524 files / 3,986 sounds / 5.6 GB**; Bundle: **624 files / 4,586 sounds / 6.3 GB** | Media licence; games OK; **no AI/ML training**; no resale as library | https://www.boomlibrary.com/sound-effects/violent-combat/ · terms: https://www.boomlibrary.com/terms-conditions-regular/ |
| BOOM Designed (reseller) | **$139** | 600 designed sounds | same | https://www.proaudiostar.com/boom-library-boom-violent-combat-designed.html |
| BOOM Construction Kit (reseller) | **$209** | 3,986 raw sounds | same | https://plugshaven.com/boom-library-boom-violent-combat-construction-kit.html |
| BOOM Bundle upper (Big Fish range) | **$139–$265** range listed | CK + Designed | same | https://www.bigfishaudio.com/Violent-Combat |
| Epic / UE Marketplace **Punch & Fighting Sounds Vol. 2** | Price **NOT FOUND** (fetch timeout); secondary sources mention bundle add-ons | — | UE Marketplace EULA | https://www.unrealengine.com/marketplace/en-US/product/fight-sounds-vol |

### Free / CC / RF honesty (combat impacts)

| Source | Cost | Commercial ship? | Combat-impact honesty |
|--------|------|------------------|------------------------|
| **Sonniss GDC Game Audio Bundle** (incl. 2026) | **$0** | **Yes** — RF, commercial, no attribution required; lifetime unlimited projects; **no AI/ML training** | Sample taste of vendor libraries — **may not cover full FightCamp cue list**; great for beds/whooshes/odds | https://gdc.sonniss.com/ · licence https://sonniss.com/gdc-bundle-license/ (v2.0 effective **27 Aug 2026**) · archive https://sonniss.com/gameaudiogdc/ |
| **Freesound** | **$0** | **Per-file:** CC0 OK commercial; CC-BY OK w/ attribution; **CC-BY-NC not OK** for paid/ad/IAP games | Combat hits exist but quality/consistency uneven; many packs are toys/cartoon; **must check each licence**; never assume site-wide commercial | https://freesound.org/help/faq/ |
| Generic “CC0 combat packs” online | Varies | Only if **true CC0** and provenance clean | **High risk** of game rips / mislabelled files — **do not ship other-game assets** (Freesound FAQ: taking from games illegal in ~99.9% cases) | FAQ above |

### AI audio (frank)

| Tool | Pricing (opened/searched) | Commercial? | Combat impacts vs ambience |
|------|---------------------------|-------------|----------------------------|
| **ElevenLabs SFX** | Free $0 (personal only); **Starter $6/mo**; **Creator $22/mo** (1st mo $11); Pro $99/mo. SFX ~**200 credits/generation** (pricing page). Paid = commercial RF in projects; **do not sell standalone SFX libraries** | Paid: yes for games/YouTube/ads | **Ambience, whooshes, crowd beds, bells: usable.** **Meaty layered fight impacts: weak vs recorded Foley/libraries** — expect heavy editing or hybrid. | https://elevenlabs.io/sound-effects · https://elevenlabs.io/pricing?price.platform=creative_platform |
| **Ludo.ai SFX** | Indie **$15/mo** annual ($180/yr); Pro **$35/mo** annual; SFX = **2 credits**/gen; commercial licence on plans | Yes (ToS: use/modify/distribute in commercial games) | Same frank split: **OK for UI/ambience/simple hits; not a substitute for BOOM/Foley meat** | https://ludo.ai/pricing · https://ludo.ai/tools/game-sound-effects-generator · https://ludo.ai/docs/game-asset-generation |
| **Adobe Firefly Generate Sound Effects** | Credits via CC/Firefly plans; Generate SFX listed under premium audio (FAQ); commercial use for **non-beta** Firefly outputs | Yes for GA features | Same: better for **supporting** SFX than championship-grade punches | https://blog.adobe.com/en/publish/2026/08/20/adobe-firefly-expands-its-creative-ai-studio-generate-music-speech-and-sound-effects-in-one-place · https://helpx.adobe.com/creative-cloud/apps/generative-ai/generative-credits-faq.html |
| **Motifect** | — | — | **NOT an audio/SFX product** — text-to-**motion** for 3D. **NOT FOUND** as combat AI audio. | https://motifect.io/en |

### DIY recording costs

| Item | Figure | Status |
|------|--------|--------|
| Phone-only Foley at home | ≈ **$0** | **INFERENCE** / common guidance |
| Portable recorder ballpark | ≈ **$100–200** | **INFERENCE** from budget Foley guides (not a receipt) |
| Mic + interface starter | ≈ **$200–500** | **INFERENCE** same class of guides |
| Gym / Octagon rental day (UFC 2 style) | Exact 2026 price | **NOT FOUND** |
| Pro Foley stage day | Exact | **NOT FOUND** |
| Props (leather, pads, watermelon myths, etc.) | Varies | **NOT FOUND** as a fixed kit price |

**DOCUMENTED quality bar:** Real fight recordings often sound flat; BOOM notes selective pre-processing; UFC 2 still layered Hollywood on critical strikes. DIY can work for **canvas scuffs, breath, cloth, bell** faster than for **hero impacts**.

### Route totals for the **whole** §1 cue list (ranked)

| Rank | Route | Approx. cash outlay | Coverage of 59 cues | Realism risk |
|------|-------|---------------------|---------------------|--------------|
| **1** | **Sonniss GDC + curated CC0/CC-BY Freesound** | **≈ $0** | Partial; hunt required | **High** on hero impacts |
| **2** | **Gamemaster Pro Sound Collection $47** + Sonniss/CC0 for crowd/bell/room gaps | **≈ $47** | Strong on punches/grunts/Foley; fill gaps free | **Medium–low** if edited |
| **3** | Unity/GDM stack e.g. $15+$10+$12 (+optional $29) | **≈ $37–$66** | Impacts/defense heavy; still need crowd/breath/room | **Medium** |
| **4** | AI hybrid: ElevenLabs Creator **1 month ≈ $22** (or Starter $6) + free beds + one $10–15 punch pack | **≈ $16–$37** | Fast iteration; impacts need curation | **Medium–high** on meat |
| **5** | Ludo Indie annual **$180/yr** ($15/mo) as generator + free beds | **≈ $15–$180** depending on months kept | Same as AI frank answer | **Medium–high** on meat |
| **6** | **BOOM Violent Combat Designed $139** | **≈ $139** | Excellent designed hits; still add vocals/crowd/bell | **Low** for impacts |
| **7** | **BOOM Construction Kit ≈ $209** (reseller) or Bundle **≤ ~$265** (Big Fish range) | **≈ $209–$265** | Best raw layering source for punches/grapples | **Lowest** for impacts |
| **8** | DIY gym + mics | **≈ $200–500+** gear; venue **NOT FOUND** | Can own unique canvas/cage/breath | Time cost high; impact design still needed |

**Cheapest viable (recommended line for header):** **≈ $47 USD** — Gamemaster Pro Collection + free Sonniss/CC0 to close crowd/bell/room — because $0-only leaves hero impacts unreliable for a commercial fight sim.

**Adobe Firefly** plan prices vary by CC tier; treat as **credit-metered add-on**, not a fixed “whole cue list” dollar total (**exact whole-list Firefly $ NOT FOUND**).

---

## 6) Licences — commercial ship? AI remix forbidden? Blockers

| Source | Ship in commercial FightCamp? | AI training / remix blockers | Other blockers |
|--------|-------------------------------|------------------------------|----------------|
| **Unity Asset Store** | Yes under Standard EULA for game inclusion | Check each publisher; don’t assume AI-OK | Single-entity seat rules; no redistributing raw assets |
| **GameDev Market Pro** | Yes in Media Products | **Creator: no AI training** on Swords and Fists listing | No resale as SFX; no NFT |
| **BOOM Library** | **Yes** for games (explicit) | **Forbidden:** use CONTENT to train NN/AI/ML | No resale as library; no “primarily sound product”; fingerprinting/enforcement mentioned | https://www.boomlibrary.com/terms-conditions-regular/ |
| **Sonniss GDC bundle** | **Yes**, RF commercial, no attribution | **Forbidden:** AI/ML training (licence v2.0, 27 Aug 2026) | No selling sounds as-is / as a library | https://sonniss.com/gdc-bundle-license/ |
| **Freesound** | Only **CC0** or **CC-BY** (with credit); **not CC-BY-NC** | Uploader GenAI prefs (Jul 2026); respect CC + prefs | **Never use ripped game audio**; verify each file | https://freesound.org/help/faq/ |
| **ElevenLabs SFX** | Paid plans: commercial in projects | Don’t build competing SFX products; don’t sell standalone libraries | Free tier = non-commercial | https://elevenlabs.io/sound-effects |
| **Ludo.ai** | Yes in commercial games per docs/ToS | Follow ToS prohibited content | Subscription/credits required for volume | https://ludo.ai/docs/game-asset-generation |
| **Adobe Firefly** (GA, non-beta) | Commercial OK per Adobe | Partner/beta models may differ | Credits / plan limits | Adobe blog + credits FAQ above |
| **Other games’ assets** (UFC, Undisputed, etc.) | **NEVER** | — | Copyright — hard blocker | Freesound FAQ; general IP |

**AI “remix” of commercial libraries:** BOOM and Sonniss **forbid AI/ML training** on their content. Feeding BOOM/Sonniss/Unity pack audio into ElevenLabs/Ludo/Firefly to “make variants” may violate those library EULAs even if the AI vendor grants rights to **its** outputs — **treat as a blocker unless counsel clears it**. Safer: AI-generate from text prompts **without** seeding paid libraries, or layer/edit traditionally.

**Motifect:** not audio — ignore for this licence matrix.

---

## URL list opened / searched this session

1. https://assetstore.unity.com/packages/audio/sound-fx/punch-combat-sfx-268225  
2. https://www.boomlibrary.com/sound-effects/violent-combat/  
3. https://www.boomlibrary.com/terms-conditions-regular/  
4. https://assetstore.unity.com/packages/audio/sound-fx/punch-sound-pack-58260  
5. https://elevenlabs.io/sound-effects  
6. https://elevenlabs.io/pricing?price.platform=creative_platform  
7. https://freesound.org/help/faq/  
8. https://www.diva-portal.org/smash/get/diva2:1025742/FULLTEXT01.pdf  
9. http://blog.lostchocolatelab.com/2010/03/footsteps-informal-game-sound-study.html  
10. https://www.reddit.com/r/GameAudio/comments/1rrogai/steps_sounds/  
11. https://www.supergmusic.com/sound-design-ea-sports-ufc-2/  
12. https://sonniss.com/gdc-bundle-license/  
13. https://gdc.sonniss.com/ (fetch timeout once; confirmed via search + licence page)  
14. https://sonniss.com/gameaudiogdc/  
15. https://gamedevmarket.net/asset/swords-and-fists-fighting-sfx-pack  
16. https://marketplace.unity.com/packages/audio/sound-fx/punches-and-fighting-sounds-293202  
17. https://marketplace.unity.com/packages/audio/sound-fx/combat-hits-hand-to-hand-fighting-sfx-263530  
18. https://www.bigfishaudio.com/Violent-Combat  
19. https://www.proaudiostar.com/boom-library-boom-violent-combat-designed.html  
20. https://plugshaven.com/boom-library-boom-violent-combat-construction-kit.html  
21. https://gamemaster-audio.itch.io/punch-and-combat-sounds  
22. https://gamemaster-audio.itch.io/punch-sound-pack  
23. https://ludo.ai/pricing  
24. https://ludo.ai/tools/game-sound-effects-generator  
25. https://ludo.ai/docs/game-asset-generation  
26. https://blog.adobe.com/en/publish/2026/08/20/adobe-firefly-expands-its-creative-ai-studio-generate-music-speech-and-sound-effects-in-one-place  
27. https://helpx.adobe.com/creative-cloud/apps/generative-ai/generative-credits-faq.html  
28. https://motifect.io/en  
29. https://www.unrealengine.com/marketplace/en-US/product/fight-sounds-vol (timeout; price NOT FOUND)  
30. https://gameaudioresource.com/2019/08/08/983/  

---

## Bottom line for FightCamp

- Build **~59 cue types**, budget **~300 files** (or fewer files if **layered** thud/slap/leather).  
- Published variation science centers on **~7** as a cited floor; **more is better** for high-rate hits; **no punch-specific GDC magic number found**.  
- Spend first dollars on **impacts + block leather + sparse vocals + crowd**.  
- **Cheapest serious route ≈ $47**; **$0** only if accepting impact-quality risk.  
- **Never** ship other-game audio; respect **no-AI-training** clauses on BOOM/Sonniss/some GDM assets.

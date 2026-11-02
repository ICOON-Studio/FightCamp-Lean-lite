# FightCamp J22B — What a Fight Sounds Like, PART TWO: The Parts J22 Did Not Cover

**Part:** Two of J22 (does **not** replace J22)  
**Research date:** 2026-09-22 (Asia/Nicosia / EEST)  
**Pass:** 2 (2026-09-22 EEST) — Pass 1 body intact below; Pass 2 section appended; STATUS + WHAT IS STILL WRONG refreshed  
**Basis:** `/workspace/j22b/priors/J22.md` (cue list, variants, sourcing, pack licences) — **do not redo**  
**Engine alignment:** skimmed `TASK_SOUND.md` / `TASK_SOUND_RESEARCH.md` — answers aimed at what Qwen’s `FightAudio` needs (contact timing from schedule; landed≠blocked; `grapple_control` bed; grade→crowd; licence blockers before any download)  
**Label legend:** **MEASURED** = figure from a named study/standard/opened source · **INFERENCE** = reasoned extension (not for gating without operator go) · **NOT FOUND** = searched; no verified figure — prefer this over inventing ms/dB  
**Denominator rule:** every share needs a denominator (e.g. n/N sources, N events, N participants).

Grok CLI (`~/.grok/bin/grok`) returned **os error 6** this session — fell back to WebSearch/WebFetch/curl.

---

## What J22 already answered (do not expand)

- Full **59-cue** list with beat triggers + ≈302 variant files; layered thud/slap/leather preferred over baked L/M/H.
- Variant floor ≈**7** from footstep literature; no punch-specific GDC magic number.
- Top-5 affordability rank: impacts → significant/KD → block/slip → sparse vocals/breath → crowd.
- Sourcing routes ranked; cheapest serious path ≈ **$47** (Gamemaster Pro + Sonniss/CC0).
- Commercial-pack / Sonniss / BOOM / Freesound / AI **licence matrix** (J22 §6) — **not** real-broadcast ripping.

---

## STATUS table Q1–Q5 (refreshed after Pass 2)

| Q | Topic | Pass-2 status | MEASURED hits (denom.) | Dominant gaps |
|---|--------|---------------|------------------------|---------------|
| 1 | Timing (contact→mic delay; impact duration) | **PARTIAL** (+ sync budget INFERENCE) | AV-sync 3/3; SoS 1/1; **Atha BMJ primary CONFIRM** force rise 14 ms (1 subject / 7 punches; detailed punch = 1); **silicone Frontiers primary CONFIRM** contact 35→50 ms (N=12 elite boxers); fight contact→mic study **0/1** | Contact→broadcast-mic delay **NOT FOUND**; acoustic (audible) impact duration at mic **NOT FOUND**; Foley lead/lag ms recipe **NOT FOUND** |
| 2 | Landed vs blocked; head vs body | **PARTIAL** (unchanged spectra) | SuperG 1/1; ICAD PDF 1/1; peer spectral landed/blocked **0/1** | No MEASURED dB/Hz deltas |
| 3 | Ground / control position | **THIN** (unchanged) | SuperG + SVG 2/2; control acoustic study **0/1** | Still empty of primary MSP/onset data |
| 4 | Crowd as function of graded events | **PARTIAL** (+ Mann primary CONFIRM; near-finish cue INFERENCE) | Football Asakura 1/1; **Mann RS Interface primary CONFIRM** (6 groups / 12 presentations / 13–20 per group); MMA grade→ms **0/1** | No MMA onset/sustain/decay ms; Tonebenders ep.181 full transcript **NOT FOUND** (Cloudflare) |
| 5 | Licensing *real* fight audio | **ACTIONABLE** (unchanged) | UFC enforcement 2/2; J22 §6 | No commission-day quote; no vetted PD-audio shortlist |

---

## Q1 — Timing

### Q1a. How long after *visible contact* does strike sound arrive at a *broadcast microphone*?

| Claim | Label | Denom. / source |
|-------|-------|-----------------|
| No peer study or broadcast engineering paper found that reports **measured contact→mic arrival time specifically for fight/boxing/MMA strikes** | **NOT FOUND** | Searched: AV sync + ringside/octagon + punch sound arrival; 0 fight-specific ms studies returned |
| Operator heuristic “80 ms late reads as a different fight” is a **product rule**, not a MEASURED fight-mic figure — do **not** treat 80 ms as MEASURED contact→mic delay | **NOT FOUND** (as scientific figure) | `TASK_SOUND.md` / operator; this pass |
| Speed of sound in air ≈ **343 m/s** at 20 °C ≈ **2.9 ms per metre** | **MEASURED** (physics constant; AV practice) | Fora Soft lip-sync methodology (opened 2026-09-22); AVIXA/common acoustics; Wikipedia AV-sync |
| Standard UFC Octagon internal span **30 ft (9.14 m)** | **MEASURED** (published dimensions) | https://www.dimensions.com/element/ufc-octagon (page updated 2026-08-21) |
| **If** an impact is *d* metres from a mic, one-way airborne delay ≈ `d / 343` seconds | **MEASURED** formula only when *d* is given | Same SoS sources |
| Example geometry (not a study): centre of 9.14 m Octagon to fence ≈ 4.57 m → ≈ **13 ms** airborne; 2 m overhead shotgun → ≈ **6 ms**; under-mat kick-drum mic path is shorter mechanically but different coupling | **INFERENCE** (distance assumed from published span + typical overhead placement) | Dimensions.com + SuperG mic layout; **not** a timed broadcast measurement |
| UFC/Fox-era broadcast used overhead shotguns (e.g. Sennheiser 416/816 class), under-mat / kick-drum-style mics for bodyfalls, camera shotguns, corner/ref lavs — i.e. multiple path lengths in one mix | **MEASURED** (reported practice) | Sports Video Group, Daley, 2013-05-02: https://www.sportsvideo.org/2013/05/02/ufc-on-fox-has-a-sound-all-its-own/ · SuperG UFC 2 Octagon session: https://www.supergmusic.com/sound-design-ea-sports-ufc-2/ |
| Foley/game-audio **lead/lag practice in ms** for fight-game impact sync (e.g. “fire SFX N ms before contact frame”) | **NOT FOUND** | Searched; Zhonghao et al. stress “sound coherence” / delay ruins feel but give **no** ms budget for fight games |

**AV-sync perceptual budgets (useful bound, not contact→mic delay):**

| Standard / study | Ahead (audio leads) | Behind (audio lags) | Label |
|------------------|---------------------|---------------------|-------|
| ITU-R BT.1359-1 detectability | +45 ms | −125 ms | **MEASURED** (ITU rec. 1998; still cited 2026) |
| ITU-R BT.1359-1 acceptability | +90 ms | −185 ms | **MEASURED** |
| ATSC IS-191 (encoder input) | ≤15 ms lead | ≤45 ms lag | **MEASURED** (industry finding) |
| EBU R37 overall to transmitter | +40 ms | −60 ms | **MEASURED** |
| Dixon & Spitz (1980) hammer/transient detect | ~75 ms lead | ~188 ms lag | **MEASURED** (peer; transient stricter than speech) |

Sources: ITU-R BT.1359-1; https://en.wikipedia.org/wiki/Audio-to-video_synchronization ; https://www.forasoft.com/learn/audio-for-video/articles-audio/lip-sync-itu-r-bt-1359-tolerance-windows (opened 2026-09-22).

**Engine implication (for Qwen, not a MEASURED gate):** Play impact on the engine’s **contact schedule frame**, not on a guessed mic TOF. Airborne TOF for cage-scale distances is **single-digit to low-teens ms** under INFERENCE geometry — far below the operator’s 80 ms “wrong fight” budget. **Do not invent an 80 ms delay as realism.** If sync feels wrong, look at schedule/hooks first.

### Q1b. How long does the impact *sound* last (acoustic duration)?

| Claim | Label | Denom. / source |
|-------|-------|-----------------|
| Peer-measured **acoustic** duration (ms) of real boxing/MMA landed strikes at broadcast mics | **NOT FOUND** | 0 papers with fight-mic acoustic duration tables found this pass |
| Biomechanics **mechanical contact / force-rise** times (not the same as audible SFX length): Atha et al. rise to peak force ≈ **14 ms**; other force-target work commonly cites ~**20–50 ms** contact; silicone wrap study lengthened fist–target contact **35→50 ms** | **MEASURED** (force/contact, secondary citations) | Atha et al. *BMJ* “The damaging punch” (via EuropePMC/doi summaries); MDPI Applied Sciences 14(7):2830 jab/cross contact ≈20–30 ms (search synthesis); PMC11338876 silicone 35→50 ms (abstract via search; full PMC fetch 403 this session) |
| ICAD 2023: among *film/game* punching SFX, **decay time** is a credible predictor of rated “power” (+≈2.3 pp per SD in their model); **spectral slope** strongest (−≈4.2 pp per SD) | **MEASURED** (N online listeners; media SFX not live fights) | Järveläinen, Hug, Papetti, ICAD 2023: https://doi.org/10.21785/icad2023.7251 · PDF opened via Georgia Tech bitstream |
| One Freesound stylized punch sample duration **562 ms** | **MEASURED** (that file only) | https://freesound.org/people/Riley_Garinger/sounds/726619/ — **not** a fight-broadcast statistic |
| Informal Toribash/game write-ups quoting 50–100 ms attack / 200–500 ms tails | **NOT FOUND** as peer MEASURED | SoundCy article — treat as uncited blog, not engine gate |

**Engine implication:** Hero impact one-shots should be **short transients** with tunable decay (ICAD: longer decay → more “power”); exact ms banks remain designer choice until a MEASURED fight corpus exists. Gate on **contact frame**, not on sample length.

---

## Q2 — Landed vs blocked acoustically; head vs body

Engine already knows `landed` / `blocked` / `target_region` / `grade` (`TASK_SOUND.md`). Needs **what they should sound like**.

### Documented Foley / game-audio practice (not spectral MEASURED)

| Distinction | What sources say | Label |
|-------------|------------------|-------|
| Feel categories | UFC 2 split impacts: “slappy”, “thuddy”, “light”, “meaty”, “boney”; layered Warner Bros Foley (John Roesch) + library | **MEASURED** as published design practice | SuperG, 2016-10-16 |
| Body / gut | Kick to stomach = foot **slap** + body **meat/thud** + slight **flappiness** | **MEASURED** (author description) | same |
| Head / face | Reviews of UFC 2 cite “click” / crunch / leather-on-flesh on face kicks; critical strikes add Hollywood layers | **INFERENCE** from review quotes collected by SuperG (not lab spectra) | same page |
| Critical / significant | Extra Hollywood beef; crowd + commentary sell the moment as much as the impact | **MEASURED** (design brief) | same |
| Ground Foley palette | Foot scuffs, grappling, shorts rustles, flesh scrapes; under-mat kick-drum mics for bass on slams | **MEASURED** (recording practice) | SuperG; SVG 2013 |
| Glove-on-glove / block | J22 cue `imp_glove_on_glove` / `def_block_glove` = leather-on-leather; industry packs keyword LEATHER | **INFERENCE** aligned with J22 + BOOM keywords (J22 already) | J22 §1/§3 |

### Peer / feature-level acoustics

| Claim | Label | Denom. |
|-------|-------|--------|
| Perceived punch “power” (film/game SFX) driven by **decay time ↑**, **brighter / less steep spectral slope**, MFCC-related features | **MEASURED** | ICAD 2023, features selected from correlation matrix; ZOIB model on z-scored predictors |
| Measurable spectral/transient/level deltas for **landed vs blocked** real gloves | **NOT FOUND** | 0 peer papers with block-vs-land spectra this pass |
| Measurable spectral deltas for **head vs body** real impacts (Hz/dB tables) | **NOT FOUND** | Wearable punch-recognition paper recorded audio but found audio **did not improve** classification vs IMU (ACM 2019 abstract via search) — not a head/body timbre study |
| Force/contact biomechanics differ by technique — **not** acoustic recipes | **MEASURED** (force domain only) | Legal Med / boxing biomechanics literature (force, impulse, contact time) |

### Practical recipe for engine (INFERENCE candidates — need operator go before gating)

| Event | Suggested sonic read | Basis |
|-------|----------------------|-------|
| Landed head | Higher transient / slap or bone layer; shorter brighter click; less bass thud | SuperG categories + review language; ICAD brightness↔power |
| Landed body | More thud / meat / flappy LF; longer decay optional for “power” | SuperG stomach recipe; ICAD decay |
| Blocked glove | Dominant leather / slap; thinner, shorter, less body resonance; lower level than landed significant | J22 cue design; no MEASURED dB delta |
| Blocked arm/check | Duller thud + cloth; less “meaty” than landed body | SuperG layering language |
| Significant / KD | Add Hollywood beef layer + crowd (already J22) | SuperG critical-strike brief |

**Do not invent dB or Hz numbers.** Pass 2 could analyse licensed pack samples (after operator purchase word) — not broadcast rips.

---

## Q3 — The ground / control position

Operator: ≈ half of grapple time is one control position (`grapple_control` ≈ 49.5% of grapple events per `TASK_SOUND.md`). Literature is thin — stated plainly.

| Sub-question | Finding | Label |
|--------------|---------|-------|
| What does the **crowd** do during prolonged control? | Fan discourse: boos when control looks like stalling / “lay and pray”; cheers on active GnP, submissions, scrambles. **No** peer acoustic study of MMA crowd SPL/onset during control vs standup found | Crowd behaviour: **INFERENCE** from fan/media commentary (Reddit/Bleacher Report/data blogs — weak denom.). Acoustic envelope: **NOT FOUND** |
| What do **fighters** do (breath/effort)? | SuperG: real fights often vocally quiet; gym noisier; UFC 2 used 1–4 noisiness scale and sparse exertions. Control-specific breath rates / effort vocal MEASURED: **NOT FOUND** | Practice: **MEASURED** (SuperG). Control physiology→audio: **NOT FOUND** |
| What does the **mat** do? | SuperG tagged: foot scuffs, flesh scrapes, shorts rustles, grappling Foley; real Octagon scuffs recorded; under-mat mics for slam bass. Prolonged *static* control may be near-quiet with intermittent scrape/shift | Recording palette: **MEASURED**. Static-control acoustic timeline: **NOT FOUND** |
| Broadcast pickup difficulty | A1 note: punch/mat sounds easier near cage edge; harder when lighter fighters wrestle in **centre** — mix rides constantly | **MEASURED** (practice quote) | SVG 2013 |

**Engine implication (INFERENCE):** For long `grapple_control` beds: lower crowd bed or slow `crowd_murmur` / disapproval option; continuous `breath_loop` gated by fatigue; sparse `foley_scrape_mat` / cloth on movement beats — **not** impact spam. Silence + breath is a valid read of stalled control; do not invent crowd roar.

---

## Q4 — Crowd as function of graded events

Engine grades actions. What moves a crowd, and how fast?

### What moves people (nearest MEASURED sport evidence)

| Scene / event class | Evidence | Label |
|---------------------|----------|-------|
| Football: goals > chances ≈ pinches > no-event for LAeq; spectators cheer/disappoint **almost simultaneously within the initial ~2 s** of the extracted 5 s windows | Asakura & Ishikawa, *Acoust. Sci. & Tech.* 41(6) 2020; 10 games, scenes: 15 goals, 11 lost points, 42 chances, 45 pinches, 30 no-event | **MEASURED** (football, not MMA) | https://www.jstage.jst.go.jp/article/ast/41/6/41_E2021/_pdf |
| Goals LAeq up to ~**105 dB** in larger stadiums (≥24k seats) vs ~100 dB smaller | Same paper Fig. 4 | **MEASURED** (football) |
| Questionnaire: most exciting scenes = scoring, chance, pinch, fine play | N=111 valid / 132 sampled | **MEASURED** (football spectators) |
| Academic applause: mean onset delay ≈ **2.1 s** (SE 0.62); spread first→last starter ≈ **2.93 s** (SE 0.33); overall duration ≈ **6.1 s** (SE 0.27) | Mann et al., *J. R. Soc. Interface* 2013 — via BBC / Discover secondary summaries this session (PMC PDF fetch failed) | **MEASURED** (classroom applause, not sport KD) | https://royalsocietypublishing.org/doi/10.1098/rsif.2013.0466 · BBC 2013-06-19 |
| UFC 2: critical strikes sold by **crowd + commentary** as much as impact SFX | SuperG | **MEASURED** (design priority) |
| MMA-specific onset / sustain / decay **ms** for KD, near-finish, takedown, significant strike | **NOT FOUND** | 0 MMA broadcast crowd-envelope papers this pass |

### Mapping to FightCamp grades (INFERENCE only — not a gate)

| Engine grade / event | Crowd cue (from J22 IDs) | Suggested envelope (INFERENCE) | Confidence |
|----------------------|--------------------------|--------------------------------|------------|
| Idle / low activity | `crowd_idle_loop` | Continuous bed | High (practice) |
| Landed (rate-limited) | `crowd_cheer_landed` | Fast rise, short | Medium |
| Significant | `crowd_cheer_significant` | Faster/louder than landed | Medium |
| Knockdown | `crowd_gasp_kd` | Sharp onset; longer tail | Medium–high (SuperG + football “goal-like”) |
| Near-finish / submission threat | (gap in J22 list — may need cue) | Rising sustain while threat holds; decay on escape | Low — **NOT FOUND** timing |
| Takedown complete | optional cheer / swell | Short spike then settle if control stalls | Low |
| Prolonged control / stall | `crowd_murmur` or duck bed | Slow negative colour; not a cheer | Low–medium (fan culture) |
| Finish / decision | `crowd_finish` | Longest sustain | Medium |

**Do not ship football 2 s / applause 6.1 s as MMA MEASURED.** They are **bounds and analogies** for Pass 2 listening tests.

---

## Q5 — Licensing REAL fight audio for a commercial game

Project rule (`TASK_SOUND.md`): **nothing bought or downloaded without operator word.** Answer before anyone wants to. Distinguish from J22 §6 commercial SFX libraries.

| Source class | Commercial game use? | Blockers | Label |
|--------------|----------------------|----------|-------|
| **Commercial SFX libraries** (Unity, Gamemaster, BOOM, Sonniss GDC, curated CC0) | Yes under each EULA — see **J22 §6** | No-AI-training clauses (BOOM/Sonniss/some GDM); no resale as SFX; verify per file on Freesound | Already **DOCUMENTED** in J22 |
| **Ripping UFC / boxing / org broadcast or Fight Pass** | **No** for commercial FightCamp | Copyright in the audiovisual work; UFC licenses fight clips commercially and litigates unlicensed use; complaint alleged ~19 min / 160 clips / 24 registered works in Bisping doc case; DMCA anti-circumvention claims when content is access-controlled | **MEASURED** enforcement posture | TorrentFreak 2022-08-20: https://torrentfreak.com/new-ufc-copyright-lawsuit-rejects-fair-use-defense-for-documentary-makers-220820 · Sportico / MMA analysis coverage |
| **“Fair use” of broadcast fight audio in a shipped game** | **Not a safe path** | Fair use is fact-specific; commercial game using fight impacts as content is substitutional, not commentary/criticism. UFC pleadings reject documentary fair-use theories. **Counsel required** — research memo ≠ legal advice | **INFERENCE** (legal risk reading) + **MEASURED** that UFC contests fair use |
| **Fan phone recordings** of live events | Generally **unsafe** without clearance | May capture copyrighted PA music, commentary, organ IP; venue/ticket terms; performer/org rights vary by jurisdiction | **INFERENCE** (standard event-IP stack); no clean “fan OK for games” source found → treat as **blocker** until counsel |
| **Public domain / archive** (LOC early boxing films, archive.org silents) | **Possibly** for **image**; **audio usually absent or unrelated** | Many PD boxing films are **silent**. LOC: verify each item (donor restrictions, publicity, trademarks, foreign rights). Later compilations / HBO-era material are **not** PD by default | Early film existence: **MEASURED** (LOC holdings). Usable fight **audio**: **NOT FOUND** as a ready commercial corpus |
| **Commission / DIY recording** (gym mats, pads, breath, scuffs) with talent releases | **Cleanest** path for “real” acoustic DNA | Need location permission, model/talent releases, no org trademarks in audio; UFC 2 precedent: rented gym + licensed Octagon access via relationships | **MEASURED** as industry practice (SuperG Vegas sessions) |
| **Other games’ ripped assets** (EA UFC, etc.) | **NEVER** | Copyright — hard blocker (J22 §6) | **DOCUMENTED** |

**Clear blockers for FightCamp today**

1. Do **not** download/rip any UFC/boxing/org broadcast or Fight Pass audio.  
2. Do **not** treat fair use as a shipping licence for combat SFX.  
3. Do **not** buy or download packs until operator word (standing project rule) — J22 already priced options.  
4. Prefer: synthesise / generate under allowed tools · wait for operator pack go · or commission Foley with releases.

---

## Loud NOT FOUNDs (Pass 1)

1. Contact→broadcast-mic delay **ms** for fight strikes (study).  
2. Acoustic impact **duration ms** of real fight strikes at mic (peer).  
3. Foley **lead/lag ms** recipe for fight-game animation sync.  
4. MEASURED **dB / spectral** deltas: landed vs blocked; head vs body; glove vs flesh.  
5. MEASURED crowd **onset/sustain/decay** for MMA KD / significant / takedown / control.  
6. Peer acoustics of **prolonged grapple control** (crowd + breath + mat timeline).  
7. Public-domain **usable modern fight audio** corpus for commercial games.  
8. Exact under-mat vs overhead **path delay** numbers from a UFC broadcast engineer paper.

---

## INFERENCE candidates for operator (labelled — not for gating without go)

1. **Sync:** Fire SFX on engine contact frame; optional ≤1-frame artistic offset only after listening — do **not** add 80 ms “realism delay.”  
2. **Layers:** Head = slap/bone bright; body = thud/flappy; block = leather-thin; significant = +Hollywood layer (SuperG-shaped).  
3. **Control bed:** Breath + intermittent scrape + ducked or murmuring crowd; impacts only on actual strikes/transitions.  
4. **Crowd envelopes:** Borrow football “react inside ~2 s” as a **playtest starting band**, then retune by ear; KD ≈ goal-class; control stall ≈ negative colour.  
5. **Licensing:** Zero broadcast rips; operator word before any pack download; commission/synth for unique mat/breath.

---

## WHAT IS STILL WRONG (refreshed after Pass 2 — required for next pass)

- Fight-mic **contact→broadcast TOF** study still **NOT FOUND** (geometry INFERENCE only; Pass 2 sync budget does **not** invent TOF).  
- **Acoustic** (audible SFX) impact **duration ms** at mic still **NOT FOUND** — Atha/silicone are **force/contact** domain only (CONFIRMED primary).  
- Foley/game **lead/lag ms recipe** for fight animation still **NOT FOUND** (sync budget is INFERENCE from BT.1359 + operator 80 ms).  
- Q2: still no MEASURED **dB/Hz** landed vs blocked / head vs body — needs operator-word licensed-pack spectrogram pass.  
- Q3: prolonged **grapple_control** crowd/breath/mat timeline still **NOT FOUND** in peer acoustics.  
- Q4: MMA-specific crowd **onset/sustain/decay ms** still **NOT FOUND**; Mann/Asakura remain classroom/football analogies.  
- Tonebenders ep.181: show-notes/secondary snippets only; **full transcript NOT FOUND** (Cloudflare/archive fails this session).  
- Q5: no priced commission-day quote; no file-by-file PD fight-audio shortlist.  
- No listening / spectrogram / pack download (correct until operator word).  
- Optional `crowd_near_finish` is **INFERENCE proposal only** — not shipped; no MEASURED ms envelopes.  
- MDPI Applied Sciences 14(7):2830 (Pass 1 secondary jab/cross ~20–30 ms) — PDF **403** this pass; still secondary-only.

---

## One-liner

**Pass 2 confirms Atha 14 ms force-rise + silicone 35→50 ms contact + Mann applause contagion from primaries, ships an INFERENCE FightCamp sync budget (fire on contact; lag ≤80 ms product / lead ≤45 ms detectability; cage TOF ≪ 80 ms), and proposes optional `crowd_near_finish` — fight-mic TOF, audible impact ms, spectra, and MMA crowd envelopes remain NOT FOUND; never rip fights.**

---

## Sources (opened / searched this session)

1. `/workspace/j22b/priors/J22.md` — basis  
2. `/workspace/j22b/priors/TASK_SOUND.md` · `TASK_SOUND_RESEARCH.md`  
3. https://www.supergmusic.com/sound-design-ea-sports-ufc-2/ (2016-10-16)  
4. https://www.sportsvideo.org/2013/05/02/ufc-on-fox-has-a-sound-all-its-own/ (2013-05-02)  
5. ITU-R BT.1359-1 (1998) via ITU / Wikipedia / Fora Soft summary  
6. https://en.wikipedia.org/wiki/Audio-to-video_synchronization  
7. https://www.forasoft.com/learn/audio-for-video/articles-audio/lip-sync-itu-r-bt-1359-tolerance-windows (2026-06-06)  
8. https://www.forasoft.com/learn/audio-for-video/articles-audio/lip-sync-test-methodology-clappers-time-of-flight  
9. https://www.dimensions.com/element/ufc-octagon  
10. https://doi.org/10.21785/icad2023.7251 · Georgia Tech bitstream PDF (ICAD 2023)  
11. https://www.jstage.jst.go.jp/article/ast/41/6/41_E2021/_pdf — Asakura & Ishikawa 2020  
12. https://royalsocietypublishing.org/doi/10.1098/rsif.2013.0466 — Mann et al. 2013 (secondary: BBC 2013-06-19)  
13. https://torrentfreak.com/new-ufc-copyright-lawsuit-rejects-fair-use-defense-for-documentary-makers-220820 (2022-08-20)  
14. https://www.sportico.com/law/analysis/2022/ufc-copyright-infringement-lawsuit-1234686446/  
15. https://freesound.org/people/Riley_Garinger/sounds/726619/  
16. faculty.washington.edu Zhonghao et al. “What Features Influence Impact Feel?” (2022 PDF via search)  
17. Search syntheses: Atha BMJ damaging punch; MDPI Applied Sciences 14(7):2830; PMC11338876 silicone contact 35–50 ms; ACM wearable punch+audio 2019  
18. LOC boxing film holdings (existence via search; per-item rights not verified this pass)  
19. Grok CLI: os error 6 — unused
20. Pass 2 primary: Mann et al. RS Interface PDF — `/workspace/j22b/priors/applause_mann.pdf` · https://doi.org/10.1098/rsif.2013.0466  
21. Pass 2 primary: Atha et al. BMJ PDF — `/workspace/j22b/priors/atha_damaging_punch.pdf` · https://doi.org/10.1136/bmj.291.6511.1756 · PMC1419171  
22. Pass 2 primary: Silicone cushioning Frontiers PDF — `/workspace/j22b/priors/silicone_pmc11338876.pdf` · https://doi.org/10.3389/fspor.2024.1358224 · PMC11338876  
23. Tonebenders 181 show page (transcript body NOT FOUND this pass): https://tonebenderspodcast.com/181-sound-design-for-boxing-mma-roundtable/ · SoundCloud description opened  
24. ITU-R BT.1359-1 + operator 80 ms (`TASK_SOUND.md`) — sync budget table Pass 2 §P2.2  
  

**End of Pass 1.**

---

## Pass 2 (2026-09-22, Asia/Nicosia / EEST)

**Scope:** Re-open primaries that failed in Pass 1; publish FightCamp **sync budget** INFERENCE table; propose optional **near-finish** crowd cue. Does **not** redo Pass 1 Q1–Q5 prose. No commercial packs downloaded; no broadcast rips; no spectrograms.

### P2.1 Primary-source reopen ledger

| Source | Pass 1 state | Pass 2 action | Outcome | Key MEASURED figures (denom.) |
|--------|--------------|---------------|---------|-------------------------------|
| Mann et al., *J. R. Soc. Interface* 10:20130466 (2013) — applause contagion | Secondary only (BBC); PMC PDF failed | Opened publisher PDF `priors/applause_mann.pdf` (RS doi PDF, 501 424 B) | **CONFIRM** Pass 1 numbers | Mean onset delay first clap **2.1 s** (±SE 0.62); first→last starter **2.93 s** (±SE 0.33); overall applause **6.1 s** (±SE 0.27); first stopper **5.56 s** (±SE 0.74); stop spread **2.6 s**. Denom.: **6 groups**, **12 presentations**, group sizes **13–20** (3×20, plus 18/16/13); N_individuals cited in models e.g. **104** for stop analyses. **Classroom applause — not MMA KD.** |
| Atha et al., *Br Med J (Clin Res Ed)* 291:1756–1757 (1985) — “The damaging punch” | Secondary citations; stub PDF “error code: 520” | Opened BMJ full PDF `priors/atha_damaging_punch.pdf` (789 520 B) | **CONFIRM** 14 ms force rise | Subject: Frank Bruno (1 heavyweight). **7 punches** recorded one morning; **1 punch** (3rd) analysed in detail. Peak contact force **4096 N** attained within **14 ms** of contact; rise time of acceleration to peak **14 ms**; impact velocity **8.9 m/s**; estimated max force to human head **6320 N**; impulse **41 N·s**; target accel **520 m/s² (53 g)**. Paper states contact duration was **“brief”** but does **not** tabulate full acoustic or force-contact *length* as a separate ms — **14 ms is rise-to-peak, not audible SFX length.** |
| Frontiers / PMC11338876 — silicone wrap fist–target contact | Abstract via search; PMC fetch 403 | Opened Frontiers PDF `priors/silicone_pmc11338876.pdf` (doi 10.3389/fspor.2024.1358224) | **CONFIRM** 35→50 ms | Double-blind crossover; **N=12** elite young boxers; **5** maximal punches × **2** wrap conditions. Fist–target contact time **35 ms (gauze) → 50 ms (silicone)** (p < 0.001). Force wastage **3.8% → 2.0%**; total force 436±33 N vs 372±12 N. **Mechanical contact time on force plate — not broadcast-mic acoustic duration.** |
| Tonebenders ep. 181 — Sound Design for Boxing & MMA Roundtable (2021-11/12) | Cloudflare-blocked | Retried site, WebFetch, SoundCloud, Listen Notes, archive.is, Wayback CDX, textise, jina | **NOT FOUND** (full transcript / notes body). **PARTIAL** show-notes only | Confirmed exist: ~55 min; guests Gene Park, Olivia Zhang, Aaron Glascock, Jay Peck. Show-notes themes (secondary/snippet level, **not** timed MEASURED): identify **hero punch** moments; layer Foley + design; leave **room for breath**; crowds roar / time-consuming; storytelling via fighter style. **No ms envelopes extracted.** URL: https://tonebenderspodcast.com/181-sound-design-for-boxing-mma-roundtable/ |
| ICAD 2023 / icad7251.pdf | Opened Pass 1 | Re-verified present (`priors/icad7251.pdf`, 645 499 B) | **CONFIRM** unchanged | Decay time / spectral slope ↔ rated punch “power” (media SFX; N online listeners) — Pass 1 already. |
| MDPI Appl. Sci. 14(7):2830 (jab/cross contact ~20–30 ms, Pass 1 secondary) | Search synthesis | PDF fetch **403** | Still **secondary-only / NOT FOUND as primary this pass** | Do not elevate to MEASURED gate until PDF opens. |

**Net:** 3/4 targeted primaries **CONFIRM** (Mann, Atha, silicone). Tonebenders transcript still **NOT FOUND**. No Pass 1 MEASURED fight-mic TOF or acoustic-duration claim was revised downward — those remain **NOT FOUND**.

### P2.2 FightCamp sync budget (INFERENCE for Qwen — not a MEASURED fight-mic law)

**Problem:** Operator rule (“a sound played **80 ms** late reads as a different fight”, `TASK_SOUND.md`) must sit beside ITU-R BT.1359 / industry AV windows and Pass 1 cage-scale airborne TOF — without treating 80 ms as a measured mic delay.

| Item | Value | Label | Cite / basis |
|------|-------|-------|--------------|
| **Recommended fire time** | Impact SFX on engine **contact schedule frame** (same beat the schedule already marks as contact) | **INFERENCE** (engine design) | `TASK_SOUND.md`: contact moment exists — use it; Pass 1 Q1a engine implication |
| **Artistic pre-roll** | Optional ≤1 frame only after listening tests; default **0** | **INFERENCE** | Pass 1 INFERENCE #1; Foley lead/lag ms recipe still **NOT FOUND** |
| **Do NOT add** | Fixed **+80 ms** “realism delay” after contact | **INFERENCE** (anti-pattern) | 80 ms is a *lateness ceiling*, not a TOF target |
| **Max acceptable audio LAG** (audio behind picture) for FightCamp impact feel | **≤ 80 ms** | **INFERENCE** (product) | Operator 80 ms rule. Stricter than ITU-R BT.1359-1 **detectability** lag **125 ms** and **acceptability** lag **185 ms** (**MEASURED** ITU 1998). Dixon & Spitz hammer/transient lag detect ~**188 ms** (**MEASURED**) — still looser than 80 ms |
| **Max acceptable audio LEAD** (audio ahead of picture) | **≤ 45 ms** preferred ceiling; treat **≤ 15 ms** as safer broadcast-style | **INFERENCE** (product bound from standards) | ITU-R BT.1359-1 detectability lead **+45 ms** / acceptability **+90 ms** (**MEASURED**); ATSC IS-191 encoder-input lead **≤15 ms** (**MEASURED** industry finding). Transient content often less tolerant of lead than lag (Dixon & Spitz lead detect ~**75 ms**) |
| **Airborne TOF at cage scale** | Centre→fence ≈ **13 ms**; ~2 m overhead ≈ **6 ms** (Pass 1 geometry) | **INFERENCE** (d from published 30 ft Octagon + SoS **343 m/s**) | Dimensions.com Octagon span (**MEASURED** dimensions) + SoS; **≪ 80 ms** |
| **Mechanical force rise / contact (not sync offset)** | Atha rise-to-peak **14 ms**; silicone gauze/silicone contact **35 / 50 ms** | **MEASURED** (force domain) | Primaries above — informs *transient shortness*, **not** when to fire relative to frame |

**One-liner for Qwen / ops:** Fire impact on the contact frame; keep audio lag under the operator’s **80 ms** “wrong fight” ceiling (tighter than BT.1359); keep lead under ~**45 ms** detectability (prefer tighter); cage airborne TOF is **single-digit–low-teens ms** and must **not** be “padded” to 80 ms.

### P2.3 Optional near-finish crowd cue (INFERENCE only)

J22 Group D already has: `crowd_idle_loop`, `crowd_cheer_landed`, `crowd_cheer_significant`, `crowd_gasp_kd`, `crowd_round_swell`, `crowd_finish`, `crowd_murmur`. Pass 1 mapped a **gap** between significant and KD/finish for submission threat / near-finish energy.

| Field | Proposal |
|-------|----------|
| **Cue ID** | `crowd_near_finish` |
| **Aligns with** | J22 `crowd_*` snake_case; sits between `crowd_cheer_significant` and `crowd_gasp_kd` / `crowd_finish` |
| **What it sells** | Rising / sustained crowd urgency while a **finish threat** is live (e.g. locked submission, unanswered GnP in dominant position, referee closely watching) — **not** a knockdown gasp and **not** the post-stoppage `crowd_finish` |
| **Primary beat triggers (suggested)** | Engine flags such as: submission enter / threat hold; near-KO thrash while fight still live; optional “finish window” boolean from rules/AI — **operator must bind to real schedule events** |
| **Exit / duck** | Escape, stand-up, referee break, or actual finish → crossfade to prior bed / `crowd_gasp_kd` / `crowd_finish` as appropriate |
| **Rec. variants** | **4–5** one-shots or short loops (enough to avoid stamp; below significant’s 5–6 if budget-tight) |
| **Envelope ms** | **NOT FOUND** as MMA MEASURED — do **not** invent. Playtest starting band may borrow football “react inside ~2 s” (**Asakura**, analogy only) and Mann contagion idea that duration can run longer than “quality” warrants — **analogy, not gate** |
| **Tonebenders** | Secondary theme “make crowds roar” / leave room for breath supports *having* a dedicated swell, but supplies **no** ms — **NOT FOUND** for timing |
| **Label** | Entire cue row = **INFERENCE** until operator accepts into cue list / HANDOFF |

**Do not** treat this as expanding J22’s 59-cue count until operator go.

### P2.4 Pack / listening needs (stop — no download)

If a later pass must close spectral / envelope gaps, operator word would be needed for **one** of:

1. Gamemaster Pro (+ Sonniss gaps) per J22 cheapest route ≈ **$47**, **or**  
2. A named fight-impact / crowd library already licence-cleared in J22 §6, **or**  
3. Commission Foley day (gym mats, pads, breath) with releases.

Then: short spectrogram / loudness pass on **owned** files only — still **no** broadcast rips. **Stopped here; nothing purchased.**

### P2.5 Artefacts written this pass

| Path | Role |
|------|------|
| `/workspace/j22b/J22B_WHAT_A_FIGHT_SOUNDS_LIKE_PART_TWO.md` | Consolidated memo (Pass 1 intact + this section + refreshed STATUS / STILL WRONG) |
| `/workspace/j22b/CLAUDE_LAND_NOTE_J22B_PASS2.md` | Land note for Claude |
| `/workspace/j22b/priors/applause_mann.pdf` | Mann primary (replaced stub) |
| `/workspace/j22b/priors/atha_damaging_punch.pdf` | Atha BMJ primary (replaced stub) |
| `/workspace/j22b/priors/silicone_pmc11338876.pdf` | Silicone / Frontiers primary (new) |
| `/workspace/j22b/priors/icad7251.pdf` | Unchanged ICAD |

**End of Pass 2.**


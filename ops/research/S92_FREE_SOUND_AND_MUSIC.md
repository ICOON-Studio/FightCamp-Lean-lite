# S92 - FREE SOUND AND MUSIC: GENERATORS AND PACKS (Claude, 2026-09-26)
Operator: "quality is fine" (the Ludo gym-theme pilot), then "aren't there any other free generators specialised on
sound and music? or any free sound packs that fit in the game?". Every licence below was READ at the source today
unless marked.

## Free generators
| Tool | Cost | Licence (read) | Runs where | Verdict |
|---|---|---|---|---|
| **ACE-Step 1.5** (github ace-step/ACE-Step-1.5, HF ACE-Step/Ace-Step1.5) | free | **MIT** (code + weights); README: "You can strictly use the generated music for commercial purposes", trained on "professionally licensed" + public-domain/royalty-free music | locally, "< 4 GB VRAM"; Windows portable package; AMD via `start_gradio_ui_rocm.bat` (ROCm on Windows needs Python 3.12) | **BEST FREE MUSIC ROUTE.** Unknown: whether the RX 6800 XT (RDNA2) is on AMD's Windows ROCm list - test it; CPU fallback is slow. PC thermal rule applies (run alone, idle priority) |
| ACE-Step v1 3.5B | free | Apache-2.0 | local | older |
| Stable Audio Open 1.0 (Stability) | free | "Stability AI Community" licence (gated on HF) - free for small revenue, read terms before shipping | local | second choice, SFX/loops more than songs |
| MusicGen (Meta) | free | **CC-BY-NC-4.0 - non-commercial** | local | **cannot ship** |
| Higgsfield audio | - | its tool states there is no general music/SFX model | - | not available |
| Ludo.ai | music 3 cr, SFX 2 cr | commercial EULA | cloud | works (pilot accepted); 1 credit left |
| Suno / Udio / ElevenLabs free tiers | free | NOT READ today - free tiers are generally non-commercial; do not use without reading | cloud | skip unless a paid plan |

## Free packs that fit
| Pack | Licence (read) | What fits |
|---|---|---|
| **Kenney** Impact Sounds (130), Interface Sounds (100), UI Audio (50), Music Jingles (85) - kenney.nl | **CC0** | UI clicks, confirms, cash, level-up/win/lose jingles, generic impacts |
| **Pixabay Music + Sound Effects** | Pixabay Content License: free, no attribution, modify OK; only STANDALONE resale banned | real composers' tracks for menus, training, walkouts; crowd, bells, gym ambience. Risk: some Pixabay tracks are also registered with YouTube Content ID by their uploaders - pick tracks and keep the page URL + date |
| Freesound CC0 + Sonniss GDC bundles | approved by the operator 2026-09-25 (U175) | already the fight SFX source (7 folders) |

## Decision (lead developer)
- **Music:** ACE-Step 1.5 locally is the free route - pilot it in a session of its own (install the portable package,
  one ROCm test, then the same gym-theme prompt as the Ludo pilot so the two can be compared by ear). If ROCm will not
  run on the 6800 XT, Pixabay Music is the free fallback, Ludo the paid one.
- **SFX/UI:** add Kenney's four CC0 packs for UI and jingles; fight SFX stay Freesound/Sonniss.
- Every file keeps its source row (the S92 portrait rule applies to audio: no unsourced file ships).

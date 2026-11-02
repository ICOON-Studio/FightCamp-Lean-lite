# K34 — KALLI — HOW NBA 2K MOVES FROM ONE ANIMATION TO THE NEXT, IN ITS DEVELOPERS' OWN WORDS

Delivered by Kalli in its Grok Bot chat on 2026-09-13 (sent 20:24), collected with `grokbots.py read --to Kalli`;
tables converted from tab-separated text, wording unchanged. Task: `research/TASK_K34.md`. Claude's
reading is recorded at the foot. The game itself was not opened: its executable is protected (EasyAntiCheat,
Quago, an anti-tamper protector's `.arch` / `.xcode` sections) and its data is in Oodle-compressed archives.

Research only · access 2026-09-13 · published sources only (no leaks / datamines / forum rumour)

Claude collects as: research/K34_NBA2K_TRANSITIONS.md

Labels: DOCUMENTED / SECONDARY / NOT FOUND

Parent-held (cite only): Bollo inertialization GDC 2018; Unreal keep under 0.4 s; Unity 250 ms; Clavet motion matching GDC 2016 ruled OUT at FightCamp scale; boxing/MMA blend lengths unpublished.

## 1 — 2K Courtside / official gameplay blogs (2K22–2K26)

| Finding | Mechanism or number | Label | Source |
|---|---|---|---|
| 2K21 next-gen movement + Impact Engine | Motion engine for non-dribble locomotion; dribble rebuilt; foot-planting rewritten for procedural micro-steps; Impact Engine resolves mid-air collisions on the fly instead of “snatching”; Transition Stops / hard cuts / stops named — no ms/frames | DOCUMENTED | Mike Wang, PS Blog 2020-10-14 https://blog.playstation.com/2020/10/14/nba-2k21-gameplay-deep-dive-movement-impact-and-more/ · 2K Newsroom Courtside pointer https://newsroom.2k.com/news/nba-2k21-next-generation-movement-and-impact-engine-revealed-in-second-courtside-report |
| 2K22 signature size-ups | ~50 unique signature size-ups; string via dribble packages — no transition mechanism / ms | DOCUMENTED (thin) | https://nba.2k.com/en-GB/2k22/ |
| 2K23 Courtside on transitions / ProPLAY / pose matching | — | NOT FOUND | Season/marketing only |
| 2K24 ProPLAY debut | ProPLAY translates real NBA footage into gameplay anims (shots, dribbles, passes, rebounds, blocks, defense, off-ball); Dribble Breakdowns = signature size-up sequences — no blend timings | DOCUMENTED | https://nba.2k.com/en-GB/2k24/features/ · https://newsroom.2k.com/news/nbar-2k24-unveils-gameplay-enhancements |
| 2K25 Dribble Engine + ProPLAY expansion | Quote-class: previous games used manually programmed, pre-scripted animation transitions from a mocap library; now dribble engine generates dynamic motion from real-world footage — “Stops are tighter, launches are more explosive…”; Shot Canceling breaks advanced shot into hesi/fake/other dribble; Signature Go-To Shots = dribble-into-shot from footage | DOCUMENTED | https://nba.2k.com/2k25/courtside-report/gameplay/ · https://newsroom.2k.com/news/nbar-2k25-reveals-new-gen-gameplay-enhancements-powered-by-proplay |
| 2K25 ProPLAY counts | 9,000 new ProPLAY anims; 1,500 dribbling; 1,100 signature shots; 1,300+ off-ball; 150 signature motion styles — no ms | DOCUMENTED | Same Courtside / Newsroom |
| 2K25 patches | Tuned catch collisions for anim coverage; ball attachment on dunk/layup mid-dribble; dribble branch repairs — no timings | DOCUMENTED | https://nba.2k.com/2k25/patch-updates/ |
| 2K26 Motion Engine + collisions | ProPLAY Motion Engine for all on-court movement; “Dynamic lower-body pose matching adjusts legs/feet on the fly to remove skating… launch, plant, and cut realistically”; ML; system-driven player-to-player collisions more reliable than previously scripted mocap; no-dip catch-and-shoot “seamlessly transition” into shot; revamped Signature Size-Ups — biggest movement change since 2K21 | DOCUMENTED | https://nba.2k.com/2k26/courtside-report/gameplay/ · https://newsroom.2k.com/news/nbar-2k26-debuts-new-gen-9-gameplay-improvements-including-an-all-new-dynamic-motion-engine-powered-by-proplay |
| Explicit “motion matching” (Clavet sense) in Courtside | — | NOT FOUND | Official language = ProPLAY / dynamic motion / lower-body pose matching / pre-scripted → dynamic |

## 2 — Talks (VC / 2K engineers)

| Finding | Mechanism or number | Label | Source |
|---|---|---|---|
| VC/2K GDC or Animation Summit talk on transition algorithms | — | NOT FOUND | — |
| SIGGRAPH VC/2K transition paper | — | NOT FOUND | — |
| Mike Wang official deep-dives (Impact, ProPLAY, Dribble Engine, Motion Engine + pose matching) | Marketing / Courtside spokesperson — not a technical conference paper | DOCUMENTED | PS Blog / 2K Newsroom / Courtside (§1) |
| FIFA Animation Warping for Responsiveness | Warping over blending for turns / time-to-target — no published ms | DOCUMENTED (EA, not VC) | Paul McComas, Jason Sanmiya · GDC Vault https://gdcvault.com/play/1012578/Animation-Warping-for-Responsiveness-in |
| Environmental and Motion Matched Interactions (Madden, FIFA and Beyond) | Motion matching + multi-character interactions | DOCUMENTED (EA) | Henry Allen · GDC Animation Summit https://www.gdcvault.com/play/1027465/Animation-Summit-Environmental-and-Motion |
| 2K13 Developer Insight #3 – Animations | ~4,000 new mocap anims; dedicated “transition / in-between” anims to connect main moves — no technique/ms | SECONDARY | https://www.nba-live.com/nba-2k13-developer-insight-3-animations/ |

## 3 — Patents (Take-Two / 2K / Visual Concepts)

| Finding | Mechanism or number | Label | Source |
|---|---|---|---|
| US11620781B1 · System and method for virtual character locomotion · grant 2023 (filed 2020) · Take-Two | Data-driven motion / archetype blocks + blackboard; transition tables define permissions, rate of blend, sync, skeletal filtering over a transition window (wildcards e.g. higher blend in snow) — no numeric default blend ms; open-world flavour, not labeled Visual Concepts / NBA 2K | DOCUMENTED | https://patents.google.com/patent/US11620781B1/en |
| US11951384B2 · Virtual character animation using motion capture · grant 2024 · Take-Two | ML hand-pose from wearable + optical (~0.5 s / 32 frames @60 fps window in preferred emb.); IK; surface contact offsets — not runtime locomotion transition selection between gameplay clips | DOCUMENTED (adjacent) | https://patents.google.com/patent/US11951384B2/en |
| US10395410B2 · Real-time pose-based deformation · Take-Two | Mesh/skin deformation from pose — not clip blending / transition selection | DOCUMENTED (weak relevance) | https://patents.google.com/patent/US10395410B2/en |
| Pose-matching / local bone-phase motion matching patents often mis-cited as 2K | Assignees are Electronic Arts (e.g. US10388053, US11123636, US11562523 / US11995754) — do not cite as TTWO/VC | NOT FOUND as TTWO | — |
| VC-specific published patent on basketball blending / ProPLAY / collision anim selection | — | NOT FOUND | — |

## 4 — Published transition timings (any sports / interactive)

| Finding | Mechanism or number | Label | Source |
|---|---|---|---|
| Interactive games / mocap transition guideline | ~10 frames @30 fps ≈ 333 ms; 5 frames often discontinuous; 20 frames usually enough | DOCUMENTED | Mizuguchi et al., “Data driven motion transitions for interactive games,” EG 2001 Short Presentations |
| Computing transition duration (user study + lit) | Search 0.03–2 s; example optimal 0.5 s; user optima 5–35 frames; JND ≈ 7–8 frames (~0.27 s); fixed baseline 0.33 s (10f); Rose et al. 0.3–0.8 s; Lee et al. 1–2 s; Arikan 2 s; Pullen/Bregler 0.2–0.8 s; velocity method preferred for boxing-class motions (overlong blends hurt) | DOCUMENTED | Wang & Bodenheimer, SCA 2004 https://eecs.vuse.vanderbilt.edu/People/bobbyb/pubs/sca2004wb.pdf |
| Unreal inertialization / Unity default | Keep under 0.4 s; Unity 250 ms | Parent-held | Bollo / engine docs |
| FIFA animation warping | Warping for responsiveness — ms blend NOT FOUND | DOCUMENTED technique | GDC Vault McComas/Sanmiya |
| Madden FieldSENSE / BOOM Tech | Branching + physics; Hit Everything >3,500 anims; N-Teract → Driven Ragdoll → collide → PTM reselect fall/stumble/recovery (can reselect mid-interaction) — ms NOT FOUND | DOCUMENTED mechanism | EA press / Inside EA FieldSENSE · Madden NFL 25 BOOM Tech |
| NBA 2K published blend / stop / cut / collision ms or frames | — | NOT FOUND | — |
| Boxing / MMA published blend lengths | — | NOT FOUND | Parent + this pass |

## GAPS

| Gap | Notes |
|---|---|
| Any official 2K ms/frame blend length | Courtside never publishes it |
| VC/2K GDC technical talk on transitions | Not found |
| Take-Two patent clearly mapping to ProPLAY / NBA collision selection | US11620781 is closest TTWO locomotion patent; not VC-labelled |
| 2K23 motion-system Courtside | Silent |
| Industry “motion matching” wording in Courtside | Closest: dynamic lower-body pose matching (2K26) + abandonment of pre-scripted transitions (2K25) |

## Closing — punch → hit reaction → guard
NBA 2K’s published path is qualitative only: from pre-scripted transition graphs (explicitly abandoned for dribble in 2K25) to footage-driven dynamic motion (tighter stops, explosive launches) to ML lower-body pose matching for plant/cut and system-driven collisions instead of scripted contact clips (2K26). That is the plausible shape of a natural join — select or generate a contact-appropriate reaction, then plant feet / match lower body so the next clip does not skate — not a millisecond recipe from 2K.

For FightCamp’s punch → hit → guard sequence, no NBA 2K number exists. The most transferable published anchors remain: keep joins under parent-held engine guidance (Unity ~250 ms, Unreal inertialization <0.4 s), treat SCA/Wang–Bodenheimer ~0.2–0.8 s (often ~0.33 s / 10f@30) as the academic sports-adjacent band, and prefer velocity-aware / short blends for boxing-class motions so the join does not outrun the performances (your 2.8× joint-speed spike). Madden/FIFA add the idea of branching / warping / mid-contact reselection, still without published ms windows. Motion matching at Clavet scale stays out; 2K’s own word for the plant fix is pose matching, not a full motion-match database.

End K34.


## Claude's reading (2026-09-13)

- **2K publishes no blend timings.** Its direction is qualitative: pre-scripted transitions abandoned for
  dribbling in 2K25, footage-driven motion, and in 2K26 'dynamic lower-body pose matching' that adjusts legs
  and feet on the fly to remove skating - the same defect as our realism test's R3 - plus system-driven
  collisions instead of scripted contact clips.
- **The numbers that exist are academic and they bracket our joins from above.** Mizuguchi et al. 2001: about
  10 frames at 30 fps (~333 ms), 5 frames often discontinuous, 20 usually enough. Wang and Bodenheimer 2004:
  a just-noticeable difference of ~7-8 frames (~0.27 s) and a velocity-aware way to choose a transition's length,
  preferred for boxing-class motion. Our joins are 0.05 s (into a hit), 0.10 s (into a strike), 0.20 s (back to
  stance) - one and a half to six frames - and R5 measures them at 2.81x the performances' own joint speed.
- Acted on in S4a (d) part 3: inertialized joins (Bollo 2018, already in G57/J19) with the join length swept
  against these published values and judged by R5, never chosen to pass it.
- Not opened by Claude: the 2K blogs, the two papers, the patents.

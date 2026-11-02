# LUDO ROUND 47 - DOWNLOAD APPROVAL (S215, 2026-10-13)

Asked in Ask Ludo chat "Gym Management Screen" (the FightCamp chat; title read before sending). Operator rule S215: "i want everything
approved by ludo assistant first". Ask text: compact version of `LUDO_ROUND47_DOWNLOADS_S215.txt` (1,856 chars, boxing-demo scope,
PC deep-sim line). Reply 13.7k chars over 2 messages (the first ended mid-sentence, "continue" finished it). The tables and lists
below are Ludo's own words, trimmed of decoration. NOTHING HAS BEEN DOWNLOADED YET - this is Ludo's verdict, the operator approves.

## Verdict matrix (Ludo)
| Batch | Verdict | Priority | Fetch | Avoid | Licence |
|---|---|---|---|---|---|
| A Mixamo combat clips | SPLIT: APPROVE ~45 now / LATER 316 (MMA) | P0 now, P3 later | hit reactions, knockdowns/get-ups, idles/walks, corner/ref/win-loss clips, missing certified strikes | kicks, elbows, knees, sprawls, takedowns, submissions, BJJ ground, capoeira/spinning | Clean: Mixamo royalty-free for commercial games |
| B Clothes + hair | SPLIT: APPROVE 8 outfits + 6 hairstyles now / LATER the rest | P1 now | boxing trunks + boots, handwraps/training shorts, coach tracksuit/polo, 6 clean hairs | heavy/obese bodies, sexualised gear, ring-walk robes, gi/kimono, rashguards | Ludo: clean under Fab / Unreal EULA (NOT verified by Claude - WARDROBE1 re-check) |
| C Gym props | APPROVE NOW (curated) | P0 | ring (canvas, turnbuckles, ropes, stairs, stools), heavy/teardrop/aqua bags, speed-bag platforms, treadmill/rower/air bike, rack + platform + dumbbells, lockers, coach bench, water, physio table | isolation machines (pec deck, hack squat), octagons, grappling cages, tatami, low-poly cartoon packs | Clean: CC0 / Quaternius / Kenney |
| D ViCoS + QuickMagic | HARD SKIP | P4 reject | nothing | all ViCoS files, QuickMagic guard-pass data | CC BY-NC-SA 4.0: non-commercial + share-alike, unusable for a paid Steam game |

## Batch A now-list (~45 clips)
- Hit reactions (14): light head snaps (jab L/R), heavy head whips (cross/overhand), torso/solar-plexus crumples (body hook/shovel hook), guard-rattle flinches.
- Knockdowns, falls, get-ups (12): flash knockdown, heavy knockdown (back / face-first), 10-count struggle (rising 7-9), TKO stoppage wave-off.
- Locomotion and ring space (10): stance-locked forward/back/lateral walks (orthodox + southpaw), corner stool sit/rise/breathing idles.
- Missing certified boxing attacks (9): variations for boxing_overhand, boxing_shovel_hook, boxing_lead_uppercut.
- Rule: Mixamo .fbx source files must not be redistributed standalone (shipping them compiled in the game is fine).

## Ludo's build order
1. Purge Batch D from planning docs and dependency manifests.
2. Batch A: download the ~45 boxing clips, run the batch retarget to the MetaHuman skeleton, map flinch/knockdown/get-up to combat events.
3. Batch B: import trunks, training shorts, handwraps, 6 hairstyles; blue/red corner shaders.
4. Batch C: instantiate props into the authored equipment slots (Round 45, EQUIPSLOTS1A) and check that buying equipment updates the 3D floor.

## Claude's notes (not Ludo's)
- Batch A needs the operator's Mixamo login (logged out after 24 h of inactivity on 2026-10-13); the queue holds 361, so the ~45 must be picked by name from it.
- Batch B licence: Ludo asserted Fab/Unreal terms cover it; the Fab MetaHuman licence for use in Godot is not verified - check on the asset page before downloading.
- Harmony4D (2.2 GB, on offline D:) is a separate dataset; its licence was not part of this ask.

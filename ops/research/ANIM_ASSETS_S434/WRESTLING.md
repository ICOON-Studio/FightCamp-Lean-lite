# WRESTLING - where wrestling / grappling animation can come from, and how we code it (S434)

Operator S434: "how can [we] find wrestling animations and code it?" (with "yes watch the preview and check the licence").
Research only: no game code touched, nothing bought, nothing signed into. Claude, 2026-11-11.

## The short answer

1. **We already have the best wrestling source there is, and it is in the game.** GrappleMap (`assets/grapplemap/`, public
   domain) holds 125 standing sequences, 44 single legs, 27 double legs, 30 arm drags, 22 collar ties, 18 ankle picks,
   17 body locks, 16 throws, 13 sprawls, 11 whizzers, 11 two-on-ones (tag counts read off `GrappleMap.txt` today). Ana's
   BJJ already plays it on two of our MetaHuman women (GrapplePose / GrapplePlayer / GrappleGrip / GrappleContact /
   GrappleLimbs), and `WrestleChains.gd` + `TieUpPanel.gd` already map the six tie-ups to GrappleMap clips.
   Wrestling is not a new pipeline; it is the standing half of the one we have.
2. **Nobody sells sport wrestling as paired animation.** I watched the three paired-wrestling previews on sale: all are
   pro-wrestling finishers or action-movie throws (people flipped through the air, slams, flips). Same verdict as R144
   (S21) and R142: the store has no shots, sprawls, hand fighting or single legs done for real.
3. **The one real two-person grappling mocap on sale is RTK Motion** (BJJ, not wrestling: a 12-camera capture of a former
   IBJJF world champion and a partner, both bodies in one shared space, $99 a capture). Worth ONE test capture, but only
   after we read its full LICENSE.txt (one clause may forbid "rig workflows" without a pricier Fab tier) and after his yes.
4. **Free paired clips on hand:** Mixamo's "Double Leg Takedown" attacker + victim (two variants, already in
   `C:/Users/user/Downloads/`) and "Shoulder Throw" aggressor + victim. Good as a weight/impact reference for the fall,
   not as our main source.
5. **How to code it** is the GrappleMap way, made general: positions are nodes, moves are edges, one clock drives both
   bodies, the pair is laid on the pose on screen before a move starts, hands are pinned to anchors on the other body by
   IK every frame, capsules keep limbs out of bodies. Build plan at the end (seven steps, each one file under 500 lines).

## What we already have (primary sources read this session)

| What | Where | State |
|---|---|---|
| GrappleMap: 601 two-person positions + 1,485 moves, 23 joints per person per keyframe, no timing | `assets/grapplemap/GrappleMap.txt`, `graph.json`, `LICENSE` ("released ... into the Public Domain") | In the game. `GrappleMapDB.gd` decodes, `GrapplePose.gd` turns joints into our 22 MetaHuman bones, `GrappleTiming.gd` sets the timing (calibrated on Sekai clip lengths), `GrapplePlayer.gd` plays a pair with one clock |
| Grips and contact | `GrappleGrip.gd` (fingers curl near the other's skin), `GrappleContact.gd` (capsules, pinned grips come along), `GrappleLimbs.gd` (arms and legs swing out of the other's trunk, eased), `GrappleDrawn.gd` (overlap on the drawn skeleton) | In the game, tests `grapple_*_test.gd` |
| Chaining moves | `GrappleGraph.gd` (`align()`: relabel + turn + shift so the next move starts where the last one ended), `TheatreChains.gd`, `GrappleTheatre.gd` | In the game (`jump=theatre`) |
| Standing wrestling rules | `scripts/rules/WrestleChains.gd` (6 tie-ups, 30 answers, opponent's reaction picks the answer, `clip_for()` finds the GrappleMap move), `TieUpPanel.gd` | In the game (ground-move browser tab) |
| Ana's matches | `BjjMatch.gd` already scores takedowns (IBJJF no-gi 2) and maps `double_leg_takedown`, `arm_drag`, `body_lock` GrappleMap moves | In the game |
| Boxing clinch | `scripts/fight3d/Clinch.gd`: one Cascadeur-authored two-person clinch (`assets/anim/baked/clinch_att.res` / `clinch_vic.res`, baked by `tools/pair_bake.gd`), played pure, hands aimed by `CornerIK` (analytic two-bone IK with a Callable target) | In the game; one hold only, no entries or exits |
| Mixamo paired takedowns | `C:/Users/user/Downloads/Double_Leg_Takedown_{Attacker,Victim}__Mma_Takedown_To_{Ground_And_Pound,Standing_Mma_Idle}.fbx` | On disk since 2026-09-28, not retargeted |
| CMU two-person trials | 18_05 / 19_05 (two-man wrestle/push), 22_17 (arm wrestle) - `R155_CMU_PAIRED_GROUND_TRUTH.md` | Free, used before as the anchor fixture; not technique |

Weak points of GrappleMap, so we know what to fix: sparse keyframes (median 4 per move), so moves can look floaty; one
1.8 m body for everyone (the pair is scaled as one); no hand roll, no fingers; no weight or impact (a takedown "arrives",
it does not land). The S379 audit's impact dip / carry layers are not on main (GrappleTheatre header).

## Every source checked, with its licence

Prices as listed 2026-11-11, before tax. "Fab Standard" = Fab's licence: use "with any compatible tools" (so Godot is
fine), commercial games allowed, never resold or given away on their own; Personal and Professional tiers give the same
rights (fab.com/eula, read today). "No AI" on a Fab listing = not to be used with generative AI; we never feed clips to
generators anyway (standing rule from R140).

### A. Free, usable today

| Source | Licence | What it has for wrestling | Verdict |
|---|---|---|---|
| **GrappleMap** (eel.is/GrappleMap, our copy in `assets/grapplemap`) | Public domain (LICENSE file) | Standing 125, single leg 44, double leg 27, arm drag 30, collar tie 22, ankle pick 18, body lock 17, throw 16, trip 13, sprawl 13, whizzer 11, two-on-one 11, duck under 4, sacrifice throw 4 | **THE ROUTE.** Already decoded and playing on our bodies. Also: GrappleMap is an editor, so new sequences we pose (e.g. a boxing clinch tie-up, a sprawl variant) can be written in its own format and drop into `GrappleMapDB` unchanged. Check that its editor builds on Windows before counting on that. |
| **Mixamo** (Adobe) | Royalty-free for commercial games (Adobe FAQ, read 2026-09-10, R-series); files not to be redistributed on their own | Paired: Double Leg Takedown attacker/victim x2 (to ground and pound 218 frames; to standing 106 frames), Shoulder Throw aggressor/victim ("thrown over the shoulder with a leg hook"), Fist Fight A/B, Hell Slammer A/B (pro-wrestling), Brutal Assassination (pipe, no). Singles: Grab And Slam, Getting Thrown, Sweep Fall, Leg Sweep x5, Mma Idle/Kicks. Read from a public 2,446-clip index (huggingface Linzhan/Mixamo-Animations-Characters `metadata.csv`) | **Use the double leg as a reference** for weight and the drop (what GrappleMap lacks), maybe for the boxing-ring "clinch to fall" moment. One take each; not a library. Retarget route exists (`mixamo_walk`, MIXAMO_WALKS_S399). |
| **CMU mocap** | "free for all uses"; may ship in a sold game; may not be resold as data; credit line | 18/19 two-man wrestle/push, 22/23 arm wrestle. No martial arts (R155) | Fixture for contact checks only. |
| **Rokoko free packs** | Commercial use allowed (OWNED_MOCAP_S381) | Single-person combat; no grappling | Not for wrestling. |

### B. Paid packs (none is sport wrestling) - reels watched today

I downloaded the three paired-wrestling preview reels at 480p with yt-dlp into the scratchpad and read them as
contact sheets (one frame every 3 s). Stills stay in the scratchpad, never the repo:
`C:\Users\user\AppData\Local\Temp\claude\6e55807c7cbb878a\cc06cf94-1b7f-4ff3-ac8d-fa7ac72dd524\scratchpad\reels\`.

| Pack | Seller / store | Price | Licence | Contents | What the reel shows | Verdict |
|---|---|---|---|---|---|---|
| Grab & Throw Takedown Animation Pack | Raise Creation, Fab 23c75ad8 | EUR 20.58 | Fab Standard, AI use allowed; FBX | 23 paired takedowns + 23 `_React` victims + idle: back/face/chest slams, hip sweep, clinch knee takedown, armbreak, roll flips, climbs, back lift, rear arch drop | Keyframed in Cascadeur (watermark). Flips over shoulders, a man climbing onto another, victims landing 2 m away, an Unreal crowd of mannequins. Action game, not sport | **Skip.** Only HipSweep / ClinchKnee are near anything real; not worth a buy |
| Paired Suplex Wrestling Animations | Jon Van Dam, Fab 16dc7f2d | EUR 13.42 | Fab Standard, AI allowed; **Unreal format only** (we would need Unreal Editor to export FBX) | 12 paired suplex sequences that chain | Grey mannequins, suplexes with motion-trail effects | **Skip.** Pro-wrestling; UE-only format |
| Wrestler Finishers Vol. 1 (Vol. 2 the same) | RamsterZ, Fab ef384d4c / ramsterzanimations.com | EUR 35.80 Fab (No AI, UE only); $34.99 direct as raw FBX on UE4 Mannequin (R144) | Fab Standard / RamsterZ direct | 24 paired finishers (12 + 12), staggers, taunts | Night-city brawlers: body slams, overhead lifts, power bombs, punches | **Skip for wrestling.** R144 kept it as a $35 pipeline test only; GrappleMap has since replaced that need |
| Wrestling Finisher Animset | wemakethegame, Unity 203451 | EUR 110.40 | Standard Unity Asset Store EULA | 31 anims, attacker (1p) + victim (2p) | No reel on the page | **Skip** (pro-wrestling finishers, price) |
| Judo AnimSet | wemakethegame, Unity | EUR 110.40 | Unity EULA (Fab copy is dearer and No AI - R140) | 8 paired throws (unnamed) + breakfalls, rolls, rises | Not re-watched (R140 audited it) | **The only sport-real paid pack.** Interesting later for breakfalls (ukemi) and a hip throw for Ana; not wrestling shots |
| Martial Arts Master | RamsterZ, Unity 311647 | EUR 45.99 | Unity EULA | 30 paired pairs incl. clinch knees, a wall/cage pin (R142) | - | Muay Thai / cage clinch reference; no ground (R144 line 2) |
| Hand to Hand finishers Vol. 1 | RamsterZ, Fab 7c627390 | EUR 26.85 | Fab, No AI, UE only | 12 paired finishers | - | Skip (brawler) |
| Grab Animations | Jon Van Dam, Fab 48ba5d38 | EUR 17.00 | Fab, No AI, UE only | 10 grab-attempt clips (lead-in to a paired move) | - | Skip |
| Street Fight Combat Pack | FiftyFive, Fab 93c8c26d | EUR 17.89 | Fab, No AI, UE only | "grapple attack animations + reactions" among strikes | - | Skip (unnamed, street) |
| Combat Animations Pack #01 | XM3, Fab 5efb6adb | EUR 25.95 | Fab, No AI, FBX, UE5 Manny | 20 single strikes | - | Not grappling |
| Paired Animation System / Grapple Component | AdrenalineGames EUR 8.94 / Jon Van Dam EUR 53.71 | - | Unreal C++/Blueprint plugins | Play two montages in sync, align actors, camera | - | Not usable in Godot. The ideas (one montage per actor, warp to a sync point) are the same as our plan below |
| Reallusion / ActorCore "Studio Mocap Hand-to-Hand Combat", "Wrestling Motions" | Reallusion | - | Needs iClone 8; export to a game engine needs Reallusion's export licence | 68 choreographed movie-fight moves incl. "takedowns"; a buyer complained nothing is broken into techniques | - | Skip (movie choreography, extra licence and software) |
| "MoCap Combat Animations - Dual Character" | Gamma Studio, Fab | EUR 31-62 | - | wire strangles, rifle butts (R144) | - | Skip, recorded so nobody buys it |

### C. Real two-person grappling capture (paid data)

| Source | What | Format | Price | Licence (from its pages; LICENSE.txt itself not readable without buying) | Verdict |
|---|---|---|---|---|---|
| **RTK Motion** (huggingface `rtk-training/*-commercial`, mirrored on claru.ai) | BJJ lessons: kimura from side control (~20 s), side control attacks, De La Riva lessons 002-011 (60-139 s each). Former IBJJF world champion + partner. **No wrestling or takedowns listed** | BVH per person (56-joint Captury skeleton, finger chains) + world-space joints JSON, 60 fps, **both people in one shared space** | $99 per capture (Single-Capture Commercial Licence); Gumroad mesh tier $249; Fab "Studio Bundle" rigged FBX $599+ | Allowed: unlimited commercial productions, modify, "embedded in a game build". Not allowed: AI/ML training, redistributing the raw files, sublicensing. **Open question: "mesh/rig workflows require a separate Fab tier"** - retargeting onto our MetaHuman may count as a rig workflow. Read LICENSE.txt (or ask RTK in writing) before paying | **Best real data on sale.** One test capture ($99) for Ana's ground game, through `GrapplePose`'s joint route (its world joints fit our joints-to-bones solve directly). Needs his yes (money). Not for wrestling |
| Academic two-person sets: InterHuman | 2-person text-motion | joints | free | CC BY-NC-SA 4.0 - **non-commercial** (github tr3e/InterGen, read today) | No |
| Hi4D | 20 pairs in close contact, scans | SMPL | free on application | research access by form; SMPL bodies are non-commercial | No |
| Harmony4D, ViCoS, QuickMagic, SMPL-X | - | - | - | rejected by us before (licence) | No |

### D. Video to motion, and capture

| Tool | Two people in contact? | Licence / cost | Verdict |
|---|---|---|---|
| Move.ai | Multi-person only on Enterprise, custom price; self-serve plans track 1 person | Commercial on paid plans | No price for what we need; close contact unproven |
| DeepMotion Animate 3D | Multi-person in beta; its own guide says keep performers apart, no crossings or close contact | Paid plans commercial; free output non-commercial | Grappling is the case it warns against |
| Rokoko Vision / suits | Vision: single person. Inertial suits drift and are crushed in grappling (R144) | - | Fine for striking, wrong for the mat |
| QuickMagic | merged the two bodies in tangled positions (earlier test) | rejected | No |
| Optical studio day, two wrestlers | The real industry route (Xsens/Vicon case studies) | needs a quote | Only if the game ever needs dozens of signature takedowns |

## How to code it in Godot (concrete, for our files)

The industry pattern (UE "paired / synced animations", the old WWE and UFC games, and GrappleMap) is the same everywhere:
**one move = one clip per body, authored together in one space; one clock drives both; before it plays the two bodies
are aligned to its start; contact points are kept by IK; positions and moves form a graph.** We already do all of this
for the ground. What is missing is to make it one shared system the boxing clinch, wrestling and Ana's BJJ all use.

1. **One pair format (`PairTake`).** Every two-person move, whatever its source, becomes the same thing: per keyframe the
   joints (or bone poses) of A and B in ONE shared frame (the pair's root, on the mat between their hips), a list of
   contacts per frame (`{who, bone, other, anchor, from_t, to_t}`, e.g. A right hand on B `neck_back` 0.2-1.4 s), the
   position it starts in and the one it ends in (graph node ids), and a timing array. GrappleMap moves already are this
   minus the contacts; a Mixamo / RTK / Cascadeur pair is baked into it by `tools/pair_bake.gd` (already bakes both
   halves of the clinch).
2. **One clock.** Never two AnimationPlayers left to run on their own (Q54: Godot has no sync between two players).
   `GrapplePlayer` already does this: one `t`, both poses sampled at `t` every frame. Captured pairs play the same way:
   one driver calls `seek(t)` on both players (or samples both tracks itself), same speed scale, same hit-stop.
3. **Lay the move on what is on screen (alignment / warp).** Before a move starts, find the turn about the vertical, the
   shift and the relabel (which body is A, mirror) that best lays its first keyframe on the current pose -
   `GrappleGraph.align()` does exactly this - then blend the last shown pose into keyframe 0 over 0.2-0.4 s with the feet
   kept down. For a standing move from boxing range, walk/step the two into the move's start gap first (the clinch does
   this with `RangeBreath` + `ENGAGE_M`), so nothing slides 30 cm in one frame.
4. **Grips by IK on anchors on the other body.** Named anchors per body (neck back, collar, wrist, elbow outside, waist
   belt line, knee pit, ankle - `G70_TYPED_GRIP_ANCHORS.md`, `C150_PAIRED_ANCHOR_CONTRACT.md`), each a point in a bone's
   space so it moves with that bone. During a contact window the hand (or foot) is pulled onto the anchor by two-bone IK:
   `CornerIK.reach(side, Callable)` already takes a target that is read every frame, and `GrapplePose` has wrist/ankle IK.
   Order matters: the held body is posed first, then the holder's IK reads it the same frame (`skeleton_updated` or
   process priority), otherwise the grip trails one frame. Ease each grip in and out (the existing 0.3 s eases). Fingers
   close with `GrappleGrip`.
5. **Bodies never pass through each other.** Capsules sized to our skin, limbs pushed out about their own shoulder/hip,
   holding hands exempt - `GrappleContact` + `GrappleLimbs` + `GrappleDrawn`, already measured on the ground. Standing
   adds one rule: the pair's two hips keep a floor gap per tie-up (the clinch's `MIN_M` 0.32 m idea).
6. **Weight and impact.** Takedowns need a landing: a short dip and settle on both bodies at the frame the back hits the
   mat, a camera bump and a sound (`GrapplePlayer.impact()` exists; the S379 dip/carry layers never reached main). Use the
   Mixamo double leg's drop timing as the reference for how fast a body falls.
7. **The graph.** Positions are nodes (GrappleMap's 601 + standing tie-ups: open stance, collar tie, over-under, body
   lock, front headlock, two-on-one, Russian tie), moves are edges. The sim picks the edge (`WrestleChains`: the
   opponent's reaction picks the answer; `BjjTree` / `BjjMatch` on the ground); the view plays it; while nothing happens
   the pair "breathes" in the node's pose (GrapplePlayer already). A move that has no clip shows the nearest one
   (`clip_for`), never a frozen pair.

### How it fits what we have

- **Ana's BJJ:** her match already starts standing and scores takedowns. With steps 1-7 her standing phase is a real
  wrestling exchange (tie-up, reaction, shot / sprawl / pull guard) whose last keyframe IS the ground position the BJJ
  tree continues from - one continuous film, no cut. Takedown edges come straight from GrappleMap (single/double leg,
  ankle pick, body lock, arm drag, trips).
- **Boxing clinch:** today one Cascadeur hold, looped, with hands aimed by IK. The same system gives it an ENTRY (from
  inside range: a collar tie or over-under from GrappleMap's standing set, scaled into the gloves' reach), a HOLD (the
  current baked pair, plus the 0.4 s sway), and EXITS (the referee's break, a push-off, a spin off the ropes) as edges.
  Gloves cannot grip, so boxing contacts are "glove on elbow outside / arm over shoulder blade" anchors (Clinch.gd's
  existing offsets), not finger grips.
- **MMA later** (the first update): the same graph, with the fence as a node property and strikes from positions.

## Build plan (each step one file under 500 lines, one test, Discipline line in each brief)

| # | Step | Files | Test (ruler first, red on main) | Seat |
|---|---|---|---|---|
| 1 | `PairTake` data + bake: one format for every pair; `pair_bake.gd` writes it for the clinch and the Mixamo double leg (both halves, shared root, contact windows read off hand-to-bone distance < 4 cm) | `scripts/grapple/PairTake.gd` (pure), `tools/pair_bake.gd` | `tests/pair_take_test.gd`: round-trip the clinch, contacts found where the hands are; bone lengths kept | Qwen (pure module) |
| 2 | `PairAnchors.gd`: named anchors per body (neck back, collar L/R, wrist L/R, elbow outside L/R, waist, knee pit L/R, ankle L/R) as bone-local offsets for MetaHuman | `scripts/grapple/PairAnchors.gd` | `tests/pair_anchors_test.gd`: each anchor on the skin (within 2 cm of the capsule surface) on two different bodies | Qwen |
| 3 | `PairGrip.gd`: during a contact window, two-bone IK pulls the hand to the other body's anchor, eased; holder solved after the held body | `scripts/grapple/PairGrip.gd` (reuses CornerIK's solver) | `tests/pair_grip_test.gd`: hand-to-anchor error < 2 cm while the held body moves; no joint pop > 15 deg/frame | Cursor or Claude |
| 4 | `PairPlayer.gd`: one clock, align to the shown pose (`GrappleGraph.align`), 0.3 s lead-in, hit-stop shared, impact dip | `scripts/grapple/PairPlayer.gd` | `tests/pair_player_test.gd`: both bodies at the same t every frame; no 30 cm root jump at a move start | Cursor |
| 5 | Standing wrestling in Ana's match: tie-up nodes + `WrestleChains` edges played by `GrapplePlayer`, landing in the BJJ tree's position | `scripts/rules/WrestleChains.gd` (data), `scripts/ui/MatNight.gd` wiring | golden path: one match opens standing, a takedown lands in a ground node, the BJJ tree continues; every menu that shows it listed (S425 rule) | Cursor (UI) + Qwen (data) |
| 6 | Boxing clinch entry / hold / exits as edges | `scripts/fight3d/Clinch.gd` + `PairPlayer` | `clinch_beats_test`, `clinch_rest_test` stay green; new `clinch_entry_test`: no frame where heads are < 0.25 m before the tie | after HUMANFIGHT2B lands (it owns the fight stack now) |
| 7 | Optional, money: one RTK capture ($99) through `GrapplePose`'s joint route to see real BJJ next to GrappleMap | `tools/rtk_bvh_source.py` (`python -I`) | the critics' film side by side | his yes first; read LICENSE.txt first |

Order: 1-4 build the shared machinery (no new art), 5 puts wrestling in Ana's match, 6 brings it to the boxing clinch
once the HUMANFIGHT work is in. Each step is a VISUAL change and closes on stills from the game's own camera plus his OK,
never on a green test alone.

## Questions only the operator can answer

- Buy one RTK Motion BJJ capture ($99) as a quality test, after its full licence is read? (money)
- Wrestling as its own discipline (a wrestler on the roster) or only as Ana's standing phase and the boxing clinch? (scope)

## Sources

- GrappleMap: https://eel.is/GrappleMap/index.html ; `assets/grapplemap/LICENSE`
- Fab: Grab & Throw https://www.fab.com/listings/23c75ad8-7c73-4e5d-bb62-18d0e01e5585 (reel youtube 4yNiYIvEw5A);
  Paired Suplex https://www.fab.com/zh-cn/listings/16dc7f2d-eac7-4c6e-9045-4ac0cdf19d70 (reel i3fbqXmOLTQ);
  Wrestler Finishers Vol 1 https://www.fab.com/listings/ef384d4c-a51d-447e-8013-01cfe1cb86e9 (reel 2REfPMh4V-8);
  Grab Animations https://www.fab.com/listings/48ba5d38-296b-4622-9440-aef8df8cf1a0 ; Grapple Component
  https://www.fab.com/listings/929dbe39-a6b0-4e2a-b167-b6dc60a604d8 ; Paired Animation System
  https://www.fab.com/listings/42fb74a4-85a7-43a1-9ba6-5c85e7c2faa6 ; Hand to Hand finishers
  https://www.fab.com/listings/7c627390-107a-438c-8e48-49d0a62a9e5b ; Street Fight Combat Pack
  https://www.fab.com/listings/93c8c26d-d9e5-4b91-90d7-47f26012797e ; Combat Animations Pack #01
  https://www.fab.com/listings/5efb6adb-e103-49a6-b188-957019977d3b ; Fab EULA https://www.fab.com/eula
- Unity: Wrestling Finisher Animset https://assetstore.unity.com/packages/3d/animations/wrestling-finisher-animset-203451
- RTK Motion: https://huggingface.co/datasets/rtk-training/bjj-kimura-lesson001-commercial ;
  https://claru.ai/datasets/rtk-training-bjj-delariva-lesson011-commercial
- Mixamo index: https://huggingface.co/datasets/Linzhan/Mixamo-Animations-Characters (`metadata.csv`)
- InterHuman licence: https://github.com/tr3e/InterGen ; Hi4D: https://yifeiyin04.github.io/Hi4D/
- Move.ai pricing: https://www.move.ai/pricing , https://docs.move.ai/knowledge/how-does-pricing-work-for-move-pro
- Reallusion Hand-to-Hand: https://marketplace.reallusion.com/studio-mocap-hand-to-hand-combat
- Earlier studies: R140, R142, R144 (lines 1-2), R155, Q54, BJJ_SOURCES_S334, WRESTLE_S336, OWNED_MOCAP_S381,
  ANIM_SOURCE_S270, topics/paired_holds.md, clinch.md, takedowns_throws.md, clips_sources.md

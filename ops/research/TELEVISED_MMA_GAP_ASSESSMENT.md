# Televised MMA — blunt gap assessment

**Desk:** Cursor (cloud audit, 2026-09-12)
**Status:** research only. No `.gd` / `.tscn` writes. No `HANDOFF.md`.
**Question:** against a believable televised MMA fight, what do we actually have?

This file wins over older feel-audits where they disagree. `U18_WHAT_MAKES_A_FIGHT_FEEL_REAL.md` (2026-09-09) still describes the live slot as 2.5D with `FightWorldPreview` unused. That was true then. The 3D room exists now. The player still never sees it.

---

## The one sentence

**We have a serious fight ledger and a boxing slideshow in a lab. We do not have a televised MMA fight.**

The sim can score an MMA bout. The production screen draws two silhouettes. The only watchable 3D path is a **dev-tier boxing demo**: two hardcoded men, sliding on a line, under a camera that was never lifted onto the canvas. Grapple film is bound in a dictionary and never reaches that room. There is no octagon, no referee, no crowd, no cut, no sound, no walkout, no broadcast graphic.

A UFC PPV is a **show**. We have the **card**.

---

## 1. The playable 3D path — what a human can actually open

There are three rooms. Only one is a fight the player is allowed to watch, and it is not 3D.

| Route | Tier | What it is | What it is not |
|---|---|---|---|
| `fight_night` | **setpiece / player** | `FightNightScreen` → `RingStagePanel`. 2.5D venue + lime/red silhouettes + kit HUD + corner dock. Boxing / MMA / kickboxing / muay thai go through `FightBeatAdapter`; judo and friends stay on `FightSimulation`. | 3D bodies. Cage. Camera. Clips. |
| `fight_world_live` | **dev, no rail** | `FightWorldLive.tscn`. Instances the preview shell, mounts two boxers, drives `FightBeatAdapter` at 1.1 s/beat, prints technique + clip (or `NO CLIP`) on Labels. | Career fighters. MMA. Grapple. Broadcast camera. HUD. Sound. |
| `fight_world_preview` | **dev, no rail** | Script-free shell: camera, two lights, two spawn marks. Four tests instantiate it. | A fight. |
| `FightAnimLab` | **dev instrument** | One body, one clip at a time, optional `FightBodyLayers`. Built so a human can *watch* a file. | A bout. |

`FightWorldLiveScreen` is explicit:

- `DISCIPLINE := "boxing"`
- `FIGHTER_A` / `FIGHTER_B` are `f01` welter and `f02` heavy, always male, always orthodox, always the same nine boxing techniques.
- Seed `94301`, three rounds, hardcoded.
- It **reads** the fight. It never drives it. One presented beat per `BEAT_SECONDS` of wall clock; `advance_beat` still consumes 280 ticks (14 fight-seconds).

**The player-facing 3D MMA path does not exist.** `SceneRouter` will not put a booked cage fight into `FightWorldLive`. The live room will not accept an MMA ruleset, a cage spec, or two career athletes without a rewrite of constants.

### Camera — shipped as a table, not as a shot

`FightCameraRig` exists. `FightWorldPreview.tscn` bakes Q55's **establishing** shot at `surface_y = 0`: eye `(0, 1.80, 2.60)`, fov 42°, perspective. Tight and low-mat sit in the table and have **no editor**.

`FightWorldLive` builds the boxing ring (`ArenaRig.surface_y` = **1.2700 m**) and never calls `FightCameraRig.apply`. Measured on this host, 2026-09-12, same scene the operator would open:

| quantity | world y |
|---|---:|
| camera (`FightCamera` baked) | **1.80** |
| fighter A node | 2.14 |
| fighter B node | 2.24 |
| canvas | 1.27 |
| `FightCameraRig.apply("establishing", 1.27)` (the test, unused) | **3.07** |

The baked lens is **below the bodies**. A real-renderer capture of `FightWorldLive` at t=0 and after eight beats is four bare feet, their shadows, and three ropes. No torso. No head. No punch. TASK_U58 is still OPEN; the module landed, the room did not use it.

M14 already typed the home shot the show needs: fov 50°, pitch −20…−22°, eye **3.8–4.2 m above FLOOR**, stand-off 9–11 m, over the near ropes. None of those numbers are on the live camera.

Two lights (`Key` + `Fill`). M14's plot (overhead cluster, two corner fills, canvas bounce) is paper.

No shot cut. No replay. No knockdown frame. No claim-tight. A static isometric was replaced by a static close-wrong perspective. That is not a broadcast.

### Space — a line, not a cage

Spawn marks sit **0.900 m** centre-to-centre (R117 stopgap). The live driver then slides both bodies along that one axis, symmetrically about the midpoint, toward a labelled-inference table:

| band | metres (invented here) |
|---|---|
| LONG | 1.10 |
| MID | 0.95 |
| POCKET | 0.80 |

Cap 0.6 m/s (M18 / Thomson mean ring speed). No circling. `WalkLeft` / `WalkRight` are deliberately unbound because they carry 0.884 m of real travel and would fight the driver. Yaw is set once at mount (`face_each_other`) and never recomputed.

A televised MMA fight is two men **cutting off a circle**. Ours is two men on a railway.

---

## 2. The fight simulation — strong ledger, wrong grain for a picture

Two engines still ship.

**`FightRealtime`** (20 Hz, integer tick, separate RNG streams) is the live core for boxing / MMA / kickboxing / muay thai:

- `FightIntent` decides; `ImpactModel` prices wear + rare shock; six contact words (`clean` / `glancing` / `absorbed` / `blocked` / `slipped` / `missed`).
- `FightFootwork` owns speed off mass and stats (C96: the live screen used to hand empty stats and the wrong weight key — fixed in the builder, still a demo pair).
- `RingSpace` + `Quantise`: real positions on a ~6 m ring. The **3D room does not read them**. It maps a BAND word to a gap.
- `FightClock`, rest, bell.
- `JudgePanel` + `RoundScoring`: N judges, 10-point must, splits possible under the right profile.
- `FightTrauma`: face cost, cuts as data.
- `GrappleSeat` + `GrappleResolve`: standing / clinch / ground, takedowns, control, submissions. Own RNG stream so boxing seeds do not move.
- Stoppages authored against measured output, not a guess (R84).

**`FightSimulation`** is the older 14 s/exchange atomic engine. Still production for judo / taekwondo / wrestling. Untouched on purpose until realtime can pin its scorecards.

**`FightBeatAdapter`** is the seam the picture is allowed to use. G42's rule is load-bearing and correct:

> We may drop a punch. We may not show a different punch.

It windows 280 ticks, picks one impact (knockdown > shocked > highest wear), copies fields, invents nothing. Q45 measured the cost:

| ruleset | thrown | shown | drop rate | distinct techniques shown |
|---|---:|---:|---:|---:|
| boxing | 48,831 | 3,970 | 91.9% | 8 |
| mma | 31,204 | 2,246 | 92.8% | **21** |
| kickboxing | 20,852 | 1,569 | 92.5% | 14 |
| muay thai | 35,539 | 2,352 | 93.4% | 5 (+ unnamed) |

A broadcast also drops punches. A broadcast still **fills the second** with footwork, feints, breath, camera, and crowd. We fill it with a 1.1 s still of one named technique, or with a man holding guard.

Grapple beats exist and are **`GRAPPLE_BEATS_DEFAULT := false`**. `FightWorldLive.begin` does not pass `grapple_beats: true`. The contract test still asserts "grapple events are never returned as beats" on the default path. That is not a stale test. That is the live room.

MMA ruleset in data: **3 × 300 s**, cage profile, 10-point must with control / takedowns / submissions weighted. No 5 × 5 championship override on the 3D path. No referee as a time actor. No cage-fence position. `U23` is still true: a man who was just cracked is, on the next tick, as capable as before. There is event vocabulary (`shocked`, `knockdown`). There is no hitstun state that occupies the next two seconds.

U18's cadence finding is not retired. Davis 2015: ~20 punches / min, ~47 hip actions / min. Our presented grain is still **one named action per 14 fight-seconds**. The 20 Hz core is busier than that; the picture is not.

---

## 3. Animation / render pipeline — a real stack, a thin vocabulary, a dead MMA half

### Bodies

Twelve rigged GLBs (4 boxing, 4 MMA, 4 bare-knuckle; six female). `FighterPhysique` scales them. The live room mounts two boxers and never the MMA meshes.

Faces / skin are a known defect (M14: frame only; no face fixes). That is already enough to kill "televised" on a tight.

### The stack that actually plays

```
FightRealtime 20 Hz
    → FightBeatAdapter (14 s window, drop ~92%)
        → FightStageDirector (role from region + contact; no RNG)
            → FightClipBinding (role → file, or "")
                → FightStagePlayer (graft once; play or honest idle)
                    → BoneTrackGraft / FightClipSlice / FightClipMirror / FightClipRetarget
```

M19's rule is the one honest thing on this stage: **no neighbour's clip**. Missing clip → thrower holds guard, receiver may still react. R103 caught the previous lie (57% of action beats played a jab the engine never threw). The fidelity gate now asserts `AnimationPlayer.current_animation`, not a category string.

### What is bound

Director roles with film: idle, strike_head (the unsliced 2.47 s combo — leftover), strike_body, strike_leg, react_head (4 takes), react_body (7 takes), react_leg, block (`BlockStart` only), slip (3 takes), knockdown (2 takes).

Typed punches from **one** authored combo file, sliced and mirrored: jab / cross / hook_rear + lead mirrors. `uppercut` is in the punch list and has **no clip**.

Catalogue ids with a file: `boxing_double_jab`, `boxing_overhand`, several muay/kickboxing kicks and knees. **Both boxing uppercuts and the horizontal elbow were unbound after someone watched them** (R127): the "uppercut" file lifts a knee and finishes facing away; the "elbow" spins the man so the strike arrives behind him. Coverage went down on purpose. That was correct.

Locomotion: `loc_advance` / `loc_retreat` only. In-place walks. Live overlays them when a body is idle and the gap is moving.

Paired (attacker + victim, one performance): takedown, throw, sweep, escape, clinch break, armbar, strangle. Seven roles. `PairedStagePlayer` can play them. **`FightWorldLive` never constructs one.** The live presenter is two independent `FightStagePlayer`s. A takedown bound in JSON is still a man holding guard in the room.

Eleven further grapple kinds are deliberately unbound (control, stall, mount, pass, back, …) because nobody has watched the leftover paired files. Four of those files include **weapon** takes (axe-to-face, knife, sword). They sit in `assets/anim/audition/`. They must never ship. Audition is the right folder. Do not "use the rest of the pack" blind.

### What sits on disk unused

- `ramsterz_h2h`: **124** FBX (121 `H2H_*`). A minority are bound.
- `ramsterz` paired: **37** FBX (32 `Paired_*` plus weapon meshes). Seven roles use 14 of those files.
- Q56 ("the hundred and thirty clips the game never plays") is still OPEN.

R124's count at time of writing: ~41 clip files in play, ~18 bound roles, ~13 technique ids, most with one take. Undisputed was measured at ~2,699 named fighter clips. Buying our way there is not a plan.

### Multipliers — on in the lab, off in the fight

| multiplier | state | lives on the live bout? |
|---|---|---|
| Slice + mirror | on | yes, for the one combo file |
| Tempo ±15% (`FightStagePlayer.tempo_for`) | on | **not set** by `FightWorldLive` |
| Phase offset (anti-aerobics) | on | yes (0.0 / 0.5) |
| Crossfade 0.10 s | on | yes; 0.10 s itself is **not visually confirmed** (shorter than the capture interval) |
| Bone-masked layering (`FightBodyLayers`) | **built, lab default ON** | **no**. Live still has one `AnimationPlayer` per body. A punch owns the whole skeleton. The pair slides. |
| Additive stance offsets | off | no |
| Shot director | table only | no |

The operator already watched the defect layering was built to kill: *"they move their legs but they do not move"* / *"they just appear at different place."* The fix exists. The watchable room does not use it.

Retarget is real (UE4 mannequin → our 22-bone rig) and has been wrong in ways tests cannot see: R108 hip 137° out without rest correction; R116 both men fought back-to-back because forward was defined as −Z and the test used the same wrong axis; R127 "uppercut" is a knee. **The suite being green means the wiring held, not that it looked like a fight.**

---

## 4. Test evidence — what is proven, what is theatre

The fight stack is one of the most tested surfaces in the repo. That is not the same as "we have seen a fight."

### Proven (occurrence, not permission)

| gate | what it actually pins |
|---|---|
| `fight_realtime_test` | 20 Hz core: seeds, impacts, stamina, stoppage, judges. Ledger. |
| `fight_beat_adapter_test` + contract | Beats copy engine fields; default path **does not** emit grapple beats. |
| `fight_beat_grapple_test` | Grapple beats when the option is on. |
| `fight_stage_technique_fidelity_test` | The clip that **started** is the clip the beat named, or degrade. Replay byte-identical. |
| `fight_world_live_test` | Dev route, two skeletons, a named clip **and** a degrade both occur if you step the room. Re-run 2026-09-12: **18/0**. Seed 94301, **73 beats, 66 action, 42 named clips, 24 honest degrades** (36% of action beats still hold guard — uppercuts + slip-counter). |
| `fight_world_mount_test` / `pair` / `anim` | Feet on deck; facing uses local +Z; a clip can move a bone. |
| `fight_camera_rig_test` | Arithmetic: `apply` on ring deck puts the camera at **y = 3.07**, cage at **y = 1.93**; perspective; unknown shot is a no-op. Re-run 2026-09-12: **10/0**. **Does not open the live scene**, which is why the live camera can sit at 1.80 and this test stays green. |
| `fight_clip_*` / retarget / slice / mirror | Files load, windows exist, mirrors exist. |
| `paired_stage_player_test` | A pair can be grafted in isolation. |
| `fight_night_realtime_test` | Production night talks to the adapter. Still `RingStagePanel`. |
| `judge_panel_test` | No real official is named. Splits exist under the right profile. |

### Not proven

- That the live camera frames two men on a 1.27 m canvas. (It does not. No test looks at a pixel.)
- That a punch and a walk can occupy one body on the live path.
- That a takedown plays in `FightWorldLive`.
- That MMA meshes, a cage, or a career bout ever mount.
- That 0.10 s blend is visible.
- That a receiver reaction reads as the contact the engine scored, rather than "a flinch we own."
- That anything sounds like a hit.
- That a human watching would say "that is a televised fight."

R103's own lesson applies to this whole area: **asserted is not the quantity the player sees.** The fidelity test fixed that for clip names. Nothing has fixed it for framing, ground, or "does this look like UFC."

Contact sheets exist for receiver takes (`CaptureR109Reactions`, `CaptureR110Ladder`) and for the 2.5D burst (`CaptureFightSceneFx` → `docs/previews/arena_style/fight_scene_hit.png`). There is **no checked-in frame of `FightWorldLive`**. Captured for this audit under xvfb + gl_compatibility: the establishing shot is ankles and ropes. The animation lab is the only place a human is invited to look at a whole body.

Headless Godot writes a dummy rasterizer. Visual claims need `xvfb-run` and a real renderer. Most of the suite never pays that cost.

---

## 5. Against a televised MMA fight — the score

A UFC / PFL / ONE broadcast, bluntly, is:

walkout → cage → lights → crowd → announcer → two named men who cut off a circle → a referee in the shot → continuous stand-up with missed jabs and stance changes → clinch that takes time → a takedown that is one performance → ground that has a seat the living room can read → GnP / attempt / finish or stand-up → cuts and swelling that accumulate → a director who cuts Cam-1 / tight / canvas / replay → a lower-third that tells the truth → sound that sells contact → a decision graphic the judges already wrote.

| layer | televised MMA | ours, today | gap |
|---|---|---|---|
| Who watches it | the player, on fight night | a developer, on a hidden route | **the show is off the rail** |
| Discipline on the 3D path | MMA | boxing constants | 100% |
| Arena | cage, fence, canvas texture, crowd bowl | boxing ring, empty void, 2 lights | ~90% |
| Camera | director, Cam-1 home, tight as a *claim* | one mis-aimed static | ~95% |
| Movement | 2-D cut-off, cage-craft | 1-D slide, 0.3 m band spread | ~85% |
| Stand-up volume | continuous; most punches are still *visible motion* | one named clip / 14 s fight / 1.1 s wall; ~92% of impacts dropped with nothing in the hole | the slideshow |
| Defence | slips, covers, checks as actions | contact words; some react/block/slip film; no layering so they replace the walk | half a picture |
| Clinch | time, dirty boxing, break | a BAND word + sim events, not drawn | ~95% |
| Takedown | paired, grounded, fence optional | JSON + `PairedStagePlayer` + option off + live unused | **100% on the watchable path** |
| Ground | seats the camera can read (G38 / Q55) | sim seats; 3D none; low-mat shot unused | 100% |
| Damage you can see | cuts, swelling, sweat, stance collapse | Labels; trauma is data | 100% |
| Referee | in frame; breaks; 10-count; wave-off | none | 100% |
| HUD | broadcast lower-third (M13 already designed) | debug Labels on 3D; real HUD lives on the 2.5D night | split brain |
| Sound | hits, canvas, crowd, corner, announce | J22 still OPEN | 100% |
| Walkout / card / replay package | the first ten minutes of the show | none | 100% |
| Faces | broadcast-readable | known defect | kill-shot on a tight |
| Decision | three-judge graphic | `ScorecardRead` + U24 panel exist as kit; not on the 3D room | ledger ahead of picture |

**Even against our own bar we are not there.** M13 / G42 / G43 already refused fighting-game theatre: wide + HUD carry the fight; tight is a claim; most punches are not drawn. That bar is cheaper than Undisputed and still unmet:

1. The player cannot open the 3D room from fight night.
2. The home shot is not on the men.
3. The HUD is not on the 3D room.
4. The hole left by dropped punches is empty (no footwork layer, no crowd, no camera move).
5. Ground is a scored fact with no picture.

Call it **~20% of a management-sim fight picture, 0% of a televised MMA show.** The 20% is the ledger, the honest degrade, the twelve bodies, and a boxing clip that sometimes matches the beat. Do not confuse that with a product.

---

## 6. What would actually move the picture (and what would not)

Do not buy 2,699 clips. Do not reopen G42. Do not put a stun-zoom on a jab.

**Order, if the goal is "I can watch an MMA fight and not laugh":**

1. **Put the live room on the rail, on a cage, with two career athletes, MMA ruleset, `grapple_beats: true`.** Until that, every clip purchase is a lab toy.
2. **Aim the camera with `FightCameraRig.apply(..., ArenaRig.surface_y(spec))`, then move the eye to M14's Cam-1 numbers.** One correct static wide beats three unused shots. TASK_U58 / M20 / Q55 are already the paper.
3. **Mount the M13 HUD on that wide.** Heart rate, pips, seat, clock. The picture confirms the sentence. Right now the sentence is a debug Label.
4. **Wire `FightBodyLayers` into `FightWorldLive`.** The slide is the thing the operator already rejected. The module exists.
5. **Play paired takedown / sweep / escape / one finish in that room, or degrade honestly.** Binding without a presenter is config theatre (R103 wearing a new hat).
6. **Fill the 14-second hole** without inventing punches: layered walk, idle breathing, crowd bed, camera hold. U18's burst payload is the other half — 3–6 drawn motions inside the window, still from scored facts.
7. Sound (J22). A silent cage will never feel televised.
8. Referee as a body *or* as a HUD actor (count, break, wave-off). Not optional on a show.
9. Faces last. A wrong face on a correct wide is survivable. A tight on these faces is a lie.

**Refuse:** aliasing an uppercut back onto the knee-lift file to win a coverage number; binding weapon paired clips; a shot-switcher before the establishing shot is on the canvas; treating `fight_world_live_test` going green as "we have a fight."

---

## Sources (read for this file; not re-derived)

`FightWorldLiveScreen.gd`, `FightWorldStage.gd`, `FightWorldPreview.tscn`, `FightWorldLive.tscn`, `SceneRouter.gd`, `FightNightScreen.gd`, `RingStagePanel.gd`, `FightCameraRig.gd`, `FightBeatAdapter.gd`, `FightRealtime.gd` (header + grapple / impact constants only), `FightClipBinding.gd`, `FightStagePlayer.gd`, `FightStageDirector.gd`, `PairedStagePlayer.gd`, `FightBodyLayers.gd`, `ArenaRig.gd`, `combat_rulesets.json` (mma + boxing headers), `fight_world_live_test.gd`.

Research already on disk: R103 digest, Q45, R124, R127 notes in the binding file, M13, M14, M19, G42, G43, U18, U23, TASK_U58. Clip inventory counted on disk 2026-09-12: 124 H2H FBX, 37 paired FBX, 12 fighter GLBs.

Set aside: AGENTS.md "one Cursor task per session / execute brief" — brief printed completed U24; the operator asked for this audit. The open Cursor build tasks (U52, U53, U58, U60, U60B, U61) were not started.

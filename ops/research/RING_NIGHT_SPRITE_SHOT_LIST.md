# Ring Night fighter sprites — shot list

Status: **ART LOCK, NOT LANDED** · 2026-09-08 · Version A (male MMA, lime/red corners)  
Owner: Maria Art Director · Game: FightCamp · Godot 4.7.2  
Scope: **shot list + AI brief only.** No `.gd` / `.tscn` / `HANDOFF.md`.  
Replaces: `Godot/assets/images/fight/fighter_lime.png` and `fighter_red.png` (both **1024×1536** RGBA, facing **right**).  
Does not replace: Cage Desk identity plates (`plate_fighter_identity` stays graphic sil). Faces do not become portraits.

Concept C Ring Night: side-on 2.5D billboards over `arena_profile`. Player never puppets limbs. Clips are presentation of an already-resolved `animation_family`. Ripped / celebrity / UFC likeness never ships.

---

## Locked engine numbers

| Fact | Value | Why it binds the sheet |
| --- | --- | --- |
| Tick at 1× | `FIGHT_TICK_SECONDS = 1.4` | One clip must finish (or hold last frame) inside 1.4 s |
| Speed | 1× / 2× / 4× on the Timer | Same frame counts; engine will drop frames at 2×/4× |
| Pause | Corner dock + 8 s combo window | Frame 0 and last frame are **idle-legal freeze poses** |
| On-screen ours | ~256×384 in a 300×384 `TextureRect` | 2:3 cell, `KEEP_ASPECT_CENTERED` |
| On-screen theirs | ~213×320 in a 250×320 `TextureRect` | Same cell; engine scales down |
| Pivot | `pivot_offset = size * (0.5, 0.86)` | Feet on the 86% line |
| Facing | Author **right**; side B is `flip_h` | Never author a left-facing sheet |
| Phase | `STANDING` / `GROUND` | Ground clips may end off idle-stand |
| Families | see shot table | Do not invent a clip per named move |

Generate at **1024×1536**. Ship cells at **512×768** (exactly 2× the on-screen ours size). Horizontal strips. Godot: `hframes = N`, `vframes = 1`, filter **linear**, mipmaps **off**, `fix_alpha_border` on.

| Strip | Cells | Sheet px | FPS | Duration |
| --- | --- | --- | --- | --- |
| Idle / ground idle | 8 | **4096×768** | 12 | 0.667 s loop |
| Action | 16 | **8192×768** | 12 | 1.333 s + hold last → 1.4 s |
| Ground idle | 8 | **4096×768** | 8 | 1.000 s loop (heavier) |

Feet contact **y = 661** in a 768 cell (86%). Head never closer than **y = 48**. Fighter occupies ~90% of cell height. Transparent background. Optional 8 px contact shadow, no arena.

**Palette pair (same body, two kits):**

- **Ours / lime:** shorts + wrist tape + rim `#C6FF3D`
- **Theirs / red:** shorts + wrist tape + rim `#E5433A` (`UITokens.BAD`)

Skin, hair, tattoos identical. Recolor kit only.

---

## Shot table — Version A (male MMA)

Two palettes per row (`_lime` / `_red`). Files land under `Godot/assets/images/fight/sheets/`. Still replacements are **frame 0 of idle**.

| # | File stem | Engine family | Frames | In pose | Out pose | Motion (one line) |
| --- | --- | --- | --- | --- | --- | --- |
| 0 | `mma_m_{lime,red}_idle` | hold / between ticks | 8 loop | orthodox guard | same | Bounce, chin tucked, rear heel light, gloves high |
| 1 | `mma_m_{lime,red}_feint` | `feint_setup` | 16 | idle | idle | Shoulder/jab feint, eyes drop a level-change fake, recover |
| 2 | `mma_m_{lime,red}_strike` | `strike` / `power_strike` | 16 | idle | idle | Rear cross: hips, rear heel up, head off centre line, recover |
| 3 | `mma_m_{lime,red}_counter` | `counter_strike` | 16 | idle | idle | Slip outside, return cross, recover |
| 4 | `mma_m_{lime,red}_evade` | miss / `evade` | 16 | idle | idle | Pull-back + cover, reset (target plays this when `landed=false`) |
| 5 | `mma_m_{lime,red}_hit` | target on `landed` | 16 | idle | idle | Impact through the torso, weight sits, recover guard |
| 6 | `mma_m_{lime,red}_footwork` | `footwork_adaptation` | 16 | idle | idle | Half-step circle, pivot on ball of lead foot |
| 7 | `mma_m_{lime,red}_escape` | `defensive_escape` | 16 | idle or clinch | idle | Hips back / sprawl-threat, hands peel, reset |
| 8 | `mma_m_{lime,red}_clinch` | `clinch` / `clinch_control` | 16 | idle | clinch hold | Collar-tie, dirty-box, knee threaten; arms occupy partner space |
| 9 | `mma_m_{lime,red}_clinch_p` | partner of 8 | 16 | idle | clinch hold | **Synced to 8.** Over-under, absorb, same freeze on last |
| 10 | `mma_m_{lime,red}_shot` | `level_change` / `takedown` | 16 | idle | **ground top** | Double-leg: drop, penetrate, finish on top |
| 11 | `mma_m_{lime,red}_shot_p` | partner of 10 | 16 | idle | **ground bottom** | **Synced to 10.** Sprawl fails, hips taken, lands back |
| 12a | `mma_m_{lime,red}_ground_top` | `GROUND` hold | 8 loop | ground top | same | Chest-heavy control, small weight shifts |
| 12b | `mma_m_{lime,red}_ground_bot` | `GROUND` hold | 8 loop | ground bottom | same | Guard / turtle, hips live, no flop |
| 13 | `mma_m_{lime,red}_scramble` | `scramble` / `ground_scramble` | 16 | ground | idle **or** new ground | Hip escape / granby; last frame must be a legal freeze |
| 14 | `mma_m_{lime,red}_sub` | `submission` / `submission_attack` | 16 | ground top | hold | Mount or back, hunting choke; no gore, no tap cinema |
| 15 | `mma_m_{lime,red}_sub_p` | partner of 14 | 16 | ground bottom | defend hold | **Synced to 14.** Frame-matched |

**Counts:** 17 stems × 2 palettes = **34 sheets**. P0 stills are idle frame 0 exported at 1024×1536, not extra stems. Partner rows (9, 11, 15) keep today’s two-`TextureRect` stage.

Female MMA is the same table with stem `mma_f_`. Do not mix sets. Boxing / kickboxing / Muay Thai gloves and stance are later ruleset packs, not this lock.

---

## Paste this to the image model (every still)

```text
Original fictional MMA fighter, licensed sports-management game sprite.
NOT a celebrity, NOT a UFC/Bellator/ONE likeness, NOT a real athlete.

Photographic 2.5D game sprite, side-on profile, camera at chest height,
35mm, almost orthographic, very little foreshortening.
Dark cinematic fight-night key from arena spots, charcoal shadows.
Full body head-to-feet, isolated, transparent background, no arena, no cage,
no crowd, no HUD, no text, no watermark.

Elite MMA physique, not bodybuilder. Natural neck, traps, calves, knuckles.
4oz-style MMA gloves, tight shorts, wrist tape, no shirt, no robe, no belt, no shoes.
Orthodox stance, facing RIGHT. Same silhouette volume every frame.

Canvas 1024×1536. Fighter fills 90% height. Feet on the 86% line.
Sharp still (no motion blur). Consistent hair, tattoos, shorts across the set.
```

Add one of:

- lime kit: `acid-lime shorts, wrist tape and rim light #C6FF3D`
- red kit: `crimson shorts, wrist tape and rim light #E5433A`

Then the **one-line motion** from the shot table, plus:

```text
12 fps stepped, not cinematic 24fps smear. 16 frames (or 8 if idle).
Start and end on a freeze-legal silhouette. Locked camera, no zoom, no pan.
Even cell spacing, identical canvas, feet on the same baseline.
```

## Paste this to the video model (then extract frames)

```text
[same style lock] One shot, locked camera, 1.4 seconds max.
12 fps stepped. Loop if idle; otherwise recover to the named out-pose.
Real MMA mechanics: weight in the hips and lead foot. No flying kicks, no WWE,
no slow-mo, no opponent in frame unless this is a partner-synced clip.
Must freeze cleanly at 0.0s and 1.333s.
```

## Negative (always)

```text
celebrity, known fighter, UFC, McGregor, Khabib, Jones, logo, brand, championship belt,
photoreal face close-up, beauty portrait, anime, pixel art, Unreal cinematic hero,
plastic skin, extra fingers, extra limbs, six-pack cartoon, 10oz boxing gloves,
shoes, robe, flying kick, wire-fu, motion blur, camera pan, dutch angle, text,
watermark, HUD, octagon ads, ripped game screenshot, left-facing, cropped feet
```

---

## Land order (so the stage never goes empty)

| Pass | What ships | Engine change |
| --- | --- | --- |
| **P0** | Idle frame 0 as `fighter_lime.png` / `fighter_red.png` at 1024×1536 | **None.** Drop-in. |
| **P1** | Idle + hit + evade + strike strips | SpriteFrames on the two existing `TextureRect`s; keep current lunge tween as fallback |
| **P2** | Feint, counter, footwork, escape | Map `RingStagePanel._family()` names onto SpriteFrames |
| **P3** | Shot / clinch / ground / sub + partner sheets | Stop using lunge-as-takedown; play synced A/B frames; freeze on last for pause |

Do not generate unique roster faces for Ring Night. Identity stays on Cage Desk. These two bodies are **corner colours**, not athletes.

---

## Refusals

- Photoreal profile heroes (Cage Desk already forbids them).
- One prompt that asks for “sprites and animation” in a single image.
- Per-move mocap libraries (the sim has families, not a clip per technique).
- Dual-fighter plates that replace both sprites with one texture (breaks `flip_h` and independent hit/evade).
- Blood, broken joints, sexualised posing, mixed-sex bouts.
- 24 fps motion blur (cannot slice to a sheet).
- Camera orbit around the cage (Concept C is side-on).

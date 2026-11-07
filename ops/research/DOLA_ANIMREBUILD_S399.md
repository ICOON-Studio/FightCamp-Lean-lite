# Dola (Cici) - animation rebuild design, second designer (S399). Designer text, not scored; Claude owns the design.

You are a senior animation systems designer for a 3D boxing management game (Godot 4, MetaHuman bodies, real motion-capture clips from Rokoko and ActionForge). The attached files are our animation handover, the film fault checklist, and the task brief for a rebuild.

The problem: every animation fix of the last two weeks lost or tied on film. Too many layers (foot plant, footwork rig, knee track, corner IK, hit snap, elbow clear, floor clear, body life, exchange beats, clinch) write the same bones every frame, so a fix in one is undone or hidden by the next. The proposal is a REBUILD: a library of real captured clips (paired clips where the two boxers touch), ONE picker that chooses the clip for each moment from the fight model's event, physics only for impact, and far fewer layers.

Write the design that a strict reviewer would score 8/10 against shipped boxing games (Undisputed, Fight Night Champion) and the way sports games really do it (motion matching, paired animations, procedural hit reactions on top). Sections:

1. TARGET: what one library entry holds; the picker (inputs: the model's event + both boxers' pose and distance; output: the clip pair + blend time; how it avoids visible repeats); where impact physics or additive hit reactions apply and where they must NOT; which few layers survive (root placement, foot lock, look-at) and why.
2. CLIP GAP LIST: for each fight event (jab, cross, hook, uppercut, body shots, slip, roll, block, clinch entry and break, hurt, knockdown, corner), what a library needs, which need paired two-person captures, and a realistic minimum count for a small indie studio.
3. MIGRATION in steps of ONE change each, each judged on a 2-minute film against today's build. Step 1 must be small and visible.
4. RISKS: what gets worse first; how BJJ ground grappling can use the same picker later without blocking boxing now.

Plain text, under 1500 words, no code. Say what you are unsure of.

----- MESSAGE BREAK -----

# ANIM_REBUILD_DESIGN.md
**Status**: Draft | Scope: Boxing animation system rework | Constraint: Document-only, no code changes
---

## 1. TARGET

### Clip library entry
Each entry is a self-contained unit storing:
- Unique ID + tags: style (orthodox/southpaw), stance range, intensity, body zone targeted, handedness, round phase
- Base clip: single-boxer motion capture, start/end stance pose (joint positions + facing direction), duration, usable motion range (m)
- Paired partner clip: where contact or mutual positioning happens, the matching motion for the opponent; includes relative offset/alignment data so both move as a unit
- Blend-in window (frames), blend-out window (frames), acceptable speed stretch range
- Provenance: Rokoko / ActionForge / Ailive / Ludo Animate; no Meshy assets

### The picker
**Inputs**:
- Fight model event: punch type, target zone, power level, defensive action, clinch state, corner position
- Current boxer state: pose (guard height, weight distribution, forward/back offset), facing, momentum
- Opponent state: distance, stance, relative position, active or incoming action
- Recent clip history (last 3–5 selections)

**Outputs**:
- Selected clip pair (attacker + defender)
- Blend start point, blend duration, playback speed scaling
- Priority flag: lock clip if in contact/impact; yield to physics only on hit reactions

**Repeat avoidance**:
- Exclude the identical clip from the last 3 uses
- Apply a similarity threshold: reject clips with matching start stance + same motion category if used within the last 5 rounds
- Vary intensity tags; shuffle within equal-score candidates

### Impact / reaction boundaries
| Area | Allowed | Must NOT apply |
|---|---|---|
| Clip base motion | Full playback, root drives movement | No IK/overriding bones during active clip |
| Impact moment | Additive reaction only: head snap, torso shift, arm recoil — 4–10 frame procedural layer, cleared immediately | No full-body pose rewrite; do not overwrite clip root motion |
| After reaction | Blend back to next clip’s base pose within 6–12 frames | Persistent IK that drifts away from clip |
| Clinch / paired segments | Lock both actors to clip relative positioning | Independent root movement breaking alignment |
| Recovery / standing reset | Root placement only to stay within ring bounds | Rewriting joint poses outside short reactions |

### Surviving layers — minimal set
- **Root placement**: Keeps boxers inside ring boundaries; corrects accumulated drift; adjusts lateral position slightly between clips. Why: Mocap clips drift; clips don’t perfectly align edge-to-edge. Constrained: only translate, never rotate or alter joint pose.
- **Foot lock / ground alignment**: Ensures feet contact floor surface height; prevents floating/sinking. Why: Capture stages are flat; rings vary. Constrained: no shifting hips/knees — only vertical foot adjustment.
- **Look-at**: Gaze toward opponent’s head or active hand. Why: Mocap often lacks consistent eye direction; improves readability. Constrained: only head/neck, no torso rotation; blend out fully during strong reactions.
- **[Uncertain]**: Whether subtle procedural weight shift adds value without fighting clips. Keep disabled until proven.

---

## 2. CLIP GAP LIST

Minimum viable library for a small indie studio — counts include stance + intensity variations; paired = two-person capture required.

| Event category | Single needed | Paired needed | Notes |
|---|---:|---:|---|
| Jab | 8 | 4 | varied range + height; paired = defender slips/parries |
| Cross / straight | 6 | 4 | paired = defender takes on guard or slips |
| Hook (head/body) | 6 | 4 | paired = impact reaction included |
| Uppercut | 4 | 2 | close-range only |
| Body shot (dig) | 4 | 3 | paired = opponent folds forward |
| Slip / lateral movement | 6 | 2 | paired = coordinated with incoming punch |
| Roll / duck | 4 | 2 | paired = attacker adjusts path |
| Block / parry / cover | 6 | 4 | paired = incoming contact present |
| Clinch entry | 2 | 2 | mutual hold, paired mandatory |
| Clinch break / reset | 2 | 2 | clean separation, paired mandatory |
| Hurt / stunned | 4 | 1 | single = recovery posture; paired = opponent maintains distance |
| Knockdown / fall | 3 | 1 | single = going down; paired = no interference |
| Corner — enter / stand | 2 | 0 | positioning + idle variations |
| Corner — receive / reset | 3 | 1 | stationary guard + body shot responses |
| Corner — leave / walk out | 2 | 0 | return to centre |
| **Total minimum** | **68** | **32** | **100 entries to launch** |

**Uncertains**:
- Whether paired defensive clips are worth extra capture time vs procedural reactions
- If intensity gradations beyond 2 levels (light/full) are distinguishable on-screen

---

## 3. MIGRATION — one change at a time

Every step: blind A/B film vs main (2 min, fixed seed), passes a guard test that fails on main before merge.

| Step | Change | Owned files | Fault removed |
|---|---|---|---|
| **1** | Install picker + 3 base idle/jab clips; disable all pose writers except root + foot alignment; route only jab events through picker | Picker script, clip registry, 3 clip sets | Jabs: multiple layers fighting → clean consistent motion |
| 2 | Add cross + hook entries; extend picker to select by event type | Clip registry, picker filters | Limited variety → distinct punch motions |
| 3 | Add paired defender reactions for jab/cross; lock relative positioning during contact | Paired clip loader, alignment utility | Attacker/defender motions uncoordinated → matched timing |
| 4 | Enable repeat avoidance; add blend smoothing | Picker history, blend transition | Same motion repeats visibly → varied sequences |
| 5 | Add clinch entry/break paired clips; lock clip priority during contact | Clinch state → clip mapping | Clinch poses drift/separate → stable hold + clean break |
| 6 | Add corner idle/reset set; constrain picker to corner tags | Corner state filter | Corner motion mismatches → consistent stationary behaviour |
| 7 | Add hurt/knockdown + impact reaction layer (short additive only) | Reaction mask, post-impact blend | Hit reactions lost or overwritten → visible snap + return to clip |
| 8 | Remove legacy writers one by one; confirm no regression | Legacy scripts archived | Ongoing conflict between layers → stable minimal set |

Step 1 is intentionally small: only jabs change visibly; everything else stays existing motion. Easy to judge, easy to revert.

---

## 4. RISKS & EXTENSIBILITY

### What degrades first
- **Motion variety temporarily drops**: Step 1–3 have few clips; early builds will loop more. Mitigation: fast capture of 2–3 variations per event early; communicate this is transitional.
- **Transitions between clips may feel stiff**: Edge blending across different source takes is harder than layering IK. Mitigation: short overlap windows + shared end stances; adjust blend times from film results.
- **Foot placement less precise**: Removing FootPlant/KneeTrack removes per-frame correction. Mitigation: keep foot lock layer; add pose pre-processing to align clip start feet.
- **Edge cases fail**: Rare events (disrupted exits, simultaneous strikes) have no clip → fall back to last safe motion. Mitigation: explicit fallback clips; log gaps to fill.

### BJJ / grappling — same picker, no blocking now
- **Design rule**: The picker does not care *what* the motion is — only event, state, distance, and tags. Boxing tags and BJJ tags are separate.
- **Shared foundation**: Root placement, blend timing, paired alignment, repeat avoidance, history all work identically standing or on ground.
- **Phase separation**:
  - Standing boxing: uses `boxing/*` tags → no ground clips selected
  - Transition: uses `clinch/takedown` paired clips → both actors move together to floor
  - Ground/BJJ: uses `bjj/*` tags → clip library expands; picker unchanged
- **No cross-contamination**: BJJ clip sets are added later; nothing in boxing rebuild references ground states.
- **Uncertain**: Whether root placement constraints need adjustment on uneven ground or during rolling motion — design for overrides later.

---

## RESULT lines
RESULT: writers today 10+, fighting pairs ~6
RESULT: library entries needed 100 minimum, have ~12 usable, paired captures needed 32
RESULT: migration steps 8; step 1 = Route jab events through picker + 3 clips, disable conflicting pose writers, keep root/foot lock only
RESULT: BJJ path: tag-isolated clip sets, no picker rewrite; ground alignment layer added later

---

Would you like me to finalize this as the ready-to-commit `ANIM_REBUILD_DESIGN.md` file, or adjust any section (clip counts, migration scope, risk framing) before review?
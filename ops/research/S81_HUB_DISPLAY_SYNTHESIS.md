# S81 HUB DISPLAY - SYNTHESIS AND RECOMMENDATION
Claude, 2026-09-26. The operator asked (2026-09-25, verbatim): "should it be still images, 2.5d animated like mad games
tycoon or 2point hospital, should we use more our 3d engine to show the fighters actually doing the exercises in the gym
animated". Brief: `TASK_HUB_DISPLAY_EVAL.md`.

## What came in
| Memo | Agent, lens | Recommends |
|---|---|---|
| `D24_HUB_DISPLAY_EVAL.md` | Dola, fresh player eyes (saw both images) | **C-light on HOME**; fallback A with occupancy variants |
| `G106_HUB_DISPLAY_EVAL.md` | Grok, dated player reviews (no images) | **A with state** (occupancy plates + live pin badges); 3D stays on fight night |
| `C208_HUB_DISPLAY_EVAL.md` | Codex, 3D cost, **measured** | **C for the training floor** (fixed camera); stills for admin hubs |
| `Q179_HUB_DISPLAY_EVAL.md` | Qwen, clip census, **measured** | **A now, grow into C**, heavy bag first |
| `U177_HUB_DISPLAY_EVAL.md` | Cursor, cost of B, **measured from the repo** | **A for HOME and the area hubs**; the GYM FLOOR tab as C (or a narrow B only if 3D fails the art bar), driven by `get_gym_hub().floor`; 0 TileMap/Sprite2D code exists, 25 station visuals + backdrop tiers + loops needed for B |
| K80 / J56 / M36 | Kalli, John, Maria | **not collected** - their shared Grok Bot account hit its weekly limit (resets ~2026-10-01) |
**All five collected memos land on the same split: stills for HOME, our fighters in space for the gym floor.**
Plus three competitor surveys the operator asked for the same night: `S81_CAGE_LEGACY_SURVEY.md` (played),
`S81_FIGHT_BUSINESS_SURVEY.md`, `S81_PUNCH_CLUB_2_SURVEY.md` (played to the city map).

## The facts everyone agreed on
- **The complaint is real**: the HOME picture is the same at 3 fighters and 30, before and after an upgrade (Dola saw
  "36 of 40 floor spaces used" over an empty floor; Codex found the gym-floor pin describes a mat over a picture of weights).
- **3D is cheap to RENDER**: 3 idling fighters 5.8 ms/frame, 12 fighters 6.7 ms p95 8.0 ms, in a stripped scene on the
  operator's PC (C208, measured with its own tool; heat NOT measured).
- **3D has nothing to PLAY**: 351 animation clips on disk, **0 training clips**; 18 of the 25 station types need one
  (Q179, measured). Fight clips are not exercise loops (C208).
- **Players ignore scenery that carries no data** after the first hours (G106: FM, Punch Club, Undisputed reviews), and
  love a room when **the room is the interface** (Two Point; Punch Club 2's garage, which I played: the rug, the bench,
  the robot ARE the buttons).
- **Both direct competitors ship stills** (Cage Legacy pixel banners; The Fight Business dark-and-gold photos - the
  same mood as ours). Stills alone make us look like them.

## Decision: TWO LAYERS - HOME stays a picture that tells the truth; the gym floor becomes our 3D engine
1. **HOME = A with state (now, Claude, GUI lane).** The picture changes with the gym: occupancy/tier variants of the
   same camera (sparse / working / packed), and every pin carries a live count ("Ring · 2 sparring", "Floor · 3 on a
   plan", "Office · 3 offers"). The operator's ROOM EXPANSION lands here too: every room built (recovery suite, kitchen,
   dorms, film room, media office) is a new pin and a visible change. This is cheap, fixes the "lie", and keeps the
   information the player reads at a glance.
2. **The GYM FLOOR = C, our own 3D engine (Codex, 3D lane).** Reached from HOME's gym-floor pin and the Fighters hub:
   the real floor from `get_floor()`, the player's own fighters on the stations they are programmed on. It is the one
   thing no competitor can show. It starts with the missing clips, not the scene: **single-body training loops are
   exactly what text-to-motion does well** (Higgsfield kimodo, ~0.1 credit a clip, one body - the reason it failed for
   grappling is the reason it suits a bag drill). First: heavy bag, skipping, shadowboxing; retargeted with the existing
   pipeline and reviewed at the station.
3. **B (2.5D sprites) is not chosen**: a second art language and a second animation pipeline (Codex, Qwen), and it
   would put us next to Punch Club and Cage Legacy's pixel look instead of away from it.

**Why not C on HOME, which the handover's tie-break named?** The evidence arrived and moved it: HOME is where the
player reads cash, the next fight and what needs him (Codex, Grok), players click through scenery by hour 5 unless it
carries data (Grok), and we have zero training clips to fill it (Qwen). The 3D floor is where watching your fighters
work IS the information.

**Gate for the 3D floor (C208's numbers, kept):** p95 under 33 ms with the real UI and room art; sustained CPU under
88 C on the operator's PC; a fighter visibly on the station he is programmed on (never a fight idle pretending to
train); and it must look at least as good as the still. **Fallback if it fails:** A variants per tier on the floor too.

## Slices
- **S82 (Claude):** HOME with state - pin counts from the live reads, occupancy variant swap, and the first extra room
  (the operator's media office or film room) as a pin that appears when built.
- **C209 (Codex, gpt-6-astra):** training clips - heavy bag, skipping, shadowboxing via text-to-motion inside the
  existing budget, retargeted, one audition render each at a station. No floor scene yet.
- **Then:** the 3D floor scene on the gym-floor route, three stations, gated as above.

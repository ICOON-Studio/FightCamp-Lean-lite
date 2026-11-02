<!-- Dola (Cici app), collected verbatim by Claude S81 2026-09-25 via Tools/cici/cici.py read; sent with current_look_sheet.jpg + 02_home.jpg attached. -->
# D24_HUB_DISPLAY_EVAL
**Lens**: Fresh-eyes first-time player review | S81, 2026-09-25

---

## 1. Current State — First Impression Evaluation
Both images arrived complete: the full screen sheet and the HOME hub.

### What works immediately
- **Visual identity lands instantly**: Warm brass, leather, aged wood, soft golden light, high ceilings — premium, serious, aspirational. This does not look like a generic UI; it feels like a place you want to build. The colour palette (deep black/gold/cream) is consistent across every screen; text is legible, buttons have clear weight and hierarchy.
- **Navigation is intuitive**: Left rail groups make sense (Home → Fighters → Fights → Money). Top bar gives the critical three — date, advance, funds — without clutter.
- **Pin interaction pattern is clear**: "Office", "Staff room", "The ring" read as clickable zones; the player understands "this is my gym, I go to things inside it".
- **Fighter cards at floor level are excellent**: Faces, names, weight class, record, condition, readiness — all key info visible *before* you click. "Ready to book" checkmarks remove guesswork.

### What feels off or breaks immersion
- **Static = hollow**: The HOME hub shows the *same empty gym* whether you have 3 fighters or 30, bare floor or fully kitted. As a new player I thought, *"Where are the people? Is anyone actually here?"* The "36 of 40 floor spaces used" text contradicts the image — the floor looks nearly empty. That disconnect is the first thing I notice.
- **Pins float on a backdrop, not a living space**: The gym is a beautiful photograph, not *my* gym. Upgrades happen in numbers elsewhere but do not change the picture. I will learn to treat the background as "pretty wallpaper" and ignore it after two visits — the visual promise fades.
- **No sense of activity or rhythm**: Cage Legacy already ships this fixed-banner pattern. If I open both games, the first impression is: *"Two boxes, one pixel, one photo — same idea underneath."* The thing that should make FightCamp feel alive — the fighters — is only in small cards at the bottom, not in the space itself.
- **Information density tradeoff**: The sheet shows the pattern works well on inner pages (Roster, Finance, Schedule), but HOME is the front door — it should feel active, not just decorative.

---

## 2. Option Evaluation: A / B / C

### Option A — Stills (Today)
| | Detail |
|---|---|
| **Player experience** | Instantly beautiful, consistent look. Fast to read, zero performance cost. But static — gym never *lives*. Upgrades feel abstract because the view does not change. Risk: perceived as "Cage Legacy with nicer wallpaper" — no unique hook in the first 10 seconds. |
| **Cost** | Low now; medium ongoing. Every new gym variant/upgrade needs new art. AI generation speeds this but consistency drifts; touch-up remains manual. Zero runtime CPU load. |
| **Scaling** | Poor. 10 floor layouts × 5 upgrade tiers = 50+ unique stills. Fighters never appear in the scene — cannot show who is training where. |
| **Risk** | **Competitive risk highest**: Cage Legacy already chose this path. If we stop here, our most obvious visual difference disappears. Players will compare "fancy wallpaper vs functional dashboard" and may not see why ours is deeper. |

### Option B — 2.5D Animated Rooms (Two Point / Mad Games style)
| | Detail |
|---|---|
| **Player experience** | Bustle and life — small figures skipping, hitting bags, chatting. Room shapes expand as you build. Readable, charming, proven. But: look shifts from photographic realism to stylised sprite art — **breaks the current brass/leather direction A**. Cage Legacy also uses 2.5D/pixel for fights; we risk converging visually everywhere. |
| **Cost** | High initial pipeline build. Tilemap + sprite workflow in Godot; asset creation shift from AI stills to hand-aligned consistent sprites. Need to match `GymHubPanel` grid data — every station needs sprite art. Ongoing: new equipment = new sprites. Performance: light, comparable to A. |
| **Scaling** | Good mechanically — grid matches existing floor data. Art scaling is the bottleneck: every piece of gear, every fighter pose, every room angle needs consistent art. |
| **Risk** | Art direction dilution is the biggest risk. We lose the "premium boxing club" atmosphere for a "cute sim" tone — and we don't get the 3D fight synergy. Cage Legacy's fight is 2.5D/sprite; ours would feel less distinct. |

### Option C — Our 3D Engine (Fighters in the actual gym)
| | Detail |
|---|---|
| **Player experience** | **Unique selling point**: *these are my fighters, in my gym, doing the work I assigned them*. If Nasir is on the heavy bag, I see him there. If the floor fills, it fills. The first 10 seconds show what Cage Legacy cannot do. Matches our 3D fight promise — same characters, same rigs, same quality from hub to ring. |
| **Cost** | Highest upfront, lowest long-term art cost. We already have: gym floor data, fighter rigs, animation pipeline, camera tools. Need: curated training animation set (bag, pads, weights, skipping, sparring, idle), camera framing that stays readable, performance tuning. **CPU is the known constraint** — currently ~87% under load. 3–5 fighters active at once is the sweet spot to test. |
| **Scaling** | Best long-term. Upgrade the floor → grid updates → scene updates automatically. Add a fighter → they appear in the scene. No new art per tier — just place what already exists. |
| **Risk** | Performance: unoptimised 3D scenes will drag on mid-spec PCs. Animation polish: "floaty" or repetitive movement kills immersion — need a focused training-clip set. Scope creep: do not build full fight movement here — only hub-appropriate actions. |

---

## 3. Recommendation
### Verdict: Start with C-light — our 3D engine, focused — as the differentiator
**Why**: Cage Legacy proves option A is a safe, fast path — but it also means players will see us as "same genre, prettier pictures" unless we show what they cannot build: living 3D people in the space. Our 3D fights are the ace; the hub should be the first glimpse of that same quality, not a disconnected wallpaper.

### First slice — one session, prove or kill it
**Build**: HOME hub only — 3D scene overlay matching the existing camera angle, max 3 fighters placed on assigned stations, 2–3 simple animations (idle, bag work, shadowboxing). Keep *all* existing UI (dates, funds, fighter cards, navigation) unchanged — **only replace the background still with a lightweight 3D render**.

**What proves it right**:
- Frame rate holds steady ≥ 30fps on the operator's PC (no overheat)
- Fighters are clearly visible and recognisable at a glance
- Player feedback: *"It feels alive"* — not *"It's laggy"*
- No art regression — brass/leather lighting matches direction A

**What proves it wrong**:
- Sustained CPU > 90% with 3 fighters
- Animation looks worse than the still
- Reading critical info becomes harder

**Fallback**: If C-light fails performance, **keep the 3D engine for the fight night view and return to A with one critical change** — *dynamic stills*: generate 3–4 occupancy variants (empty / building / busy / full) that swap automatically. Cheap, retains direction A, fixes the "lie" without rebuilding the pipeline.

**Inner pages**: Keep the current still-based pattern (A) for Roster, Finance, Schedule — Cage Legacy shows this layout works well for dense data. Reserve 3D animation for where it matters most: the front door and the fight.

---

*Word count: 1,180 | Research only | No code changes proposed*


# CLAUDE_LAND_NOTE: M43, gym zones from real gyms (reference pack)

**Owner:** Maria (art direction) · **Date:** compiled 2026-10-08, staged 2026-10-09 (Nicosia) · **Task:** TASK_M43_GYM_ZONE_REFERENCE_PHOTOS
**Status:** art direction / reference only. **No code claim**: no .gd, .tscn, HANDOFF.md or game file was touched, and nothing was committed or pushed. Files were only added (untracked).

## Exact paths (repo root = C:\Users\user\OneDrive\Documents\ChatGPT\Game)
| File | Repo path | Delivery copy |
|---|---|---|
| Zone brief (ring, bag line, speed bags, mirror strip, cardio, weights, stretch, office, entrance, walls, floor: what to copy and what we get wrong) | `research/M43_GYM_ZONES.md` | `_maria_delivery/m43/M43_GYM_ZONES.md` |
| Source notes (every URL, licence, sampled hex) | `research/refs_notes.md` | `_maria_delivery/m43/refs_notes.md` |
| Reference photos (29 files) | **not in research, on purpose** | `_maria_delivery/m43/refs/*.jpg, *.png` |
| This note | `research/CLAUDE_LAND_NOTE_M43.md` | `_maria_delivery/CLAUDE_LAND_NOTE_M43.md` |

**Copyright:**
- The `refs/` photos include Business Insider and Guardian editorial photos. They are private reference only and must never go into `Godot/` or a commit.
- Commons files carry their own CC/PD licences (listed in refs_notes.md).
- `_maria_delivery/` is gitignored (`.gitignore` line 64), so the refs folder stays out of git unless someone force-adds it. Do not force-add it.

## What Claude should do
1. Land the two .md files (your call) or acknowledge.
2. Leave `_maria_delivery/m43/refs/` untracked.
3. Use the brief when the gym-floor and zone tasks come up.
4. HUD direction (separate pack, HUD2): **wait for the operator's pick**. Maria recommends A as the base, B's lower-third for fight week, and C's chalkboard as an optional objective skin.

## Out of scope
- Implementation: no models, scenes or layout changes from this pack.
- Buying or modelling assets.
- Icon additions: the mail and smartphone glyphs are missing from the Lucide set. That is a separate request.

## NOT VERIFIED
- Every "est." size is judged by eye.
- Sampled hex values shift with the photo's lighting.
- Some zones have no dedicated photo: stretch corner, air bike, office with a floor window. Each is marked NOT FOUND in the brief.

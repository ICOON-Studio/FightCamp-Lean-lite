# M28_GYM_FLOOR_BOARDS.md — PASS 3

Maria Art Director · 2026-09-22 · art only — LOOK; **no geometry, no code, no copy**

**Re-cut** from pass 1 / 2 / 2b still-wrong lists. Does not restart M28.  
**Inputs landed:** Gym Floor = priority #1 (lead yes); `FLOW_PASS1_SCREEN_MAP.md` (Beast-verified); `grade` = **integer**, engine break `grade >= 2` = significant — **no named grade labels**.  
**Still gated:** blood ruling pass 1 §4 — operator; not boarded here.

Boards (files to land):

| File | What |
| --- | --- |
| `M28_board_gym_floor_keep.png` | Gym Floor establishing + three stations (KEEP) |
| `M28_board_gym_floor_reject.png` | Art deco campus (REJECT) |
| `M28_board_roster_filler.png` | HA still \| legal \| naked \| clutter |
| `M28_board_dust_sweat.png` | Dust / sweat vs jab-flash + grade map |
| `M28_GYM_FLOOR_BOARDS.md` | This spec |
| `CLAUDE_LAND_NOTE_M28_PASS3.md` | Land note |

---

## Three lines

1. **Gym Floor is the management establishing shot** — view + teach (bags / ring / office), Cage Desk, not an art-deco lot.  
2. **Legal roster filler = only what `UIKit.squad_row` already draws** — pass-2 wear/purse-on-row was aspirational; several fields are **NOT COMPUTED** as row columns.  
3. **Micro VFX rides integer `grade >= 2`** — never invent PERFECT/GREAT labels; most punches still get nothing.

---

## A. GYM FLOOR ESTABLISHING

### Job
Give the player a **place** that is both a **view of the camp** and a **teacher** of the week loop. Three stations readable without opening every subpanel.

### KEEP (`M28_board_gym_floor_keep.png`)
- Establishing interior: bags · ring · office door as **three teachable stations**.  
- Surfaces: M22 ground/panel/hairline; sodium/ice scarce; no gold chrome.  
- Sits above (or as the face of) existing `GymHubPanel` floor — art direction for presence, not a second campus game.

### REJECT (`M28_board_gym_floor_reject.png`)
- Art deco / HA studio lot / neon select / gold transport metaphors. Wrong identity; expensive; competes with fight budget.

### Station labels on the board
Board text on stations is **LOOK placeholder**. Final words **DEPEND ON KALLI** / NEEDS WORDS (her flow already has rail label **GYM** / creation gold **OPEN GYM**). Do not treat board copy as shipped strings.

### Chrome on the board
“MANAGEMENT VIEW” / “RETURN TO DESK” on the keep board = **NOT COMPUTED** route labels — placeholders for eye only. Real leave/arrive words come from Kalli + SceneRouter inventory.

### How it ties to flow (Kalli pass 1)
| Flow fact | Look implication |
| --- | --- |
| Creation: market → city → gym → **OPEN GYM** → CareerRoot `day_feed` | First post-creation teach may be THE DAY; Gym Floor should be **one rail hop** (GYM), not a forced second tutorial modal covering the floor |
| Rail aliases `gym` / `gym_floor` / `roster` | One Gym Floor presence; roster is a **tab/mode**, not a rival establishing world |
| Dual chrome risk (ShellChrome+SceneRouter vs ManagementChrome+DIRECT_SCENES) | **Look:** one Continue strip visual language — do not art two clocks. Dual Continue = presentation defect if both visible |
| Fight result `leave()` CTA **NEEDS WORDS** | Heavier `nav_fight_out` must land the eye on a **named** leave control (Kalli words); Maria: same weight family as pass 1, never a settings-modal dissolve |

---

## B. ROSTER ROW — FILLER AUDIT

Board: `M28_board_roster_filler.png` (HA operator still as left column).

### Live columns (`UIKit.SQUAD_COLUMNS` + `squad_row`) — COMPUTED

| Column / mark | Fields read |
| --- | --- |
| Avatar | initials from `name` (no portrait texture required) |
| Fighter | `name`; sub: `age`, `sex`, `discipline_label`/`discipline`, `weight_class_label`/`weight_class` |
| Record | `record.wins/losses/draws`; optional `ko`, `sub` |
| Cond | `condition` (gauge + number; BAD tint if &lt; 50) |
| Morale | `morale` (gauge) |
| Weight / Plan / Next bout | columns exist in `SQUAD_COLUMNS` — values from fighter dict (see row builder) |
| Flag chips | `FLAG_LABELS`: `medical_hold`, `ask`, `weight`, `contract`, `loyalty`, `empty_book`, `training_blocked`, `commission_battery` |

### Pass-2 filler claims vs reality

| Claimed filler (pass 2) | On squad row? |
| --- | --- |
| Age / wear pip | **Age yes**; wear texture / M11 last-walk stamp **NOT COMPUTED** on row |
| Last result stamp | **NOT COMPUTED** as its own chip (record W-L-D is not “last result”) |
| Hold badge | **Partial** — `medical_hold` flag exists; M6 hold family not the same chip |
| Region doctor mark | **NOT COMPUTED** on roster row (fight HUD / M23 territory) |
| Purse / money truth | **NOT COMPUTED** on roster row (books / contract surfaces) |
| Condition / morale | **Yes — already legal filler** |
| Finish counts KO/SUB | **Yes — already legal filler** |

**Ruling:** Legal filler for this pass = **emphasize and discipline what squad_row already shows** (subline + record finishes + cond/morale + one flag). Do **not** invent HA dual-score jewellery or genre pills. Naked name-only = reject as target. HA-clone clutter = reject.

---

## C. DUST / SWEAT vs JAB FLASH

Board: `M28_board_dust_sweat.png`

| Layer | Status |
| --- | --- |
| A Mat dust | KEEP — build first; feet/mat; thin under free camera |
| B Sweat micro | KEEP — only with high gas (M24); not HUD pulse |
| Jab / full-screen flash | REJECT |
| Invented named grades | REJECT |

### Integer grade map (engine paste — no enum labels)

Engine: `grade` is **int**. Meaningful break used in adapters/audio/UIKit: **`grade >= 2`** (“significant”). There are **no** named grade strings to map art to. If product wants labels later, that is an engine add — **say so; do not invent**.

| Gate | World effect |
| --- | --- |
| not landed / glance | nothing |
| landed + grade &lt; 2 | nothing (reaction + instruments only) |
| landed + grade ≥ 2 | allow A and/or B micro bump |
| KD / finish | M15 frame + mat contact; still no jab fireworks |
| Blood §4 | **ACCEPTED (fallback)** — doctor/stoppage only; board deferred |

---

## D. TRANSITION WEIGHTS — ALIGNED TO FLOW PASS 1

| Weight | Flow pair (COMPUTED / noted) | Look |
| --- | --- | --- |
| `nav_light` | Rail hops inside CareerRoot (day_feed ↔ gym ↔ training ↔ …) | ≤150 ms hairline; same M22 |
| `nav_week` | Shell **Continue** → `GameState.advance_day` (not its own scene) | Short dim + clock-desk; **one** Continue chrome — if dual Management Continue appears, that is a defect to kill, not to art twice |
| `nav_fight_in` | fight_week → weigh_in → fight_night | Heavier; land HOME + instruments |
| `nav_fight_out` | fight_result → leave → day_feed | Verdict grammar then desk; **eye on leave CTA** (words NEEDS WORDS — Kalli). Look must not bury an unnamed control |
| `nav_career` | crowning / retirement paths | Slowest; no particle rain |
| Creation | OPEN GYM → day_feed | Treat as light-to-medium enter-career, not fight_in |

**Dual navigation systems:** art one shell language. Do not paint ManagementChrome as a second “premium” skin.

---

## E. ARGUE AGAINST YOURSELF — strongest board

**Strongest board this pass:** Gym Floor establishing KEEP.

**Best case it is WRONG for this game:**

1. **Expense without new verbs.** `GymHubPanel` already mounts `UIKit.floor_grid` with stations, move-armed cells, roster tab, store. An establishing “landscape” risks a second expensive surface that **does not add a player verb** — only a prettier shell around wiring that already teaches via grid + tabs.  
2. **Too close to the reference job.** Even in Cage Desk paint, “view + three callouts + teach” is the Hollywood Animal studio-lot *job*. Players who know HA may read it as a clone attempt; the reject board kills the skin, not the structural rhyme.  
3. **Solves a problem the player may not have.** Flow says first meaningful post-title decisions are market/city/gym golds, then THE DAY. The gap may be **words and dual-chrome**, not the absence of a postcard. If the player is lost, Kalli’s unnamed fight-result leave and dual Continue are the sharper fixes — cheaper than a landscape.  
4. **Alias trap.** `gym` / `gym_floor` / `roster` already multiply destinations; an establishing mode can become a fourth way to mean “gym,” worsening the dual-route problem her map names.

**What I still hold after attacking it:** keep the board as the **target presence** for the existing floor (lighten callouts, no second campus sim), and prioritize **killing dual Continue chrome** + **visible leave CTA** in the same pass family — landscape is direction, not a license to build a lot map.

---

## F. BLOOD — still gated

Pass 1 §4 unchanged. Instruments not gore. **Not boarded.** Waiting operator accept/refuse.

---

## WHAT IS STILL WRONG (end of pass 3)

1. Gym Floor keep board uses **placeholder words/chrome** — not Kalli-final; station copy not shipped.  
2. No live FightCamp hub capture for true side-by-side with HA still (used operator still + drawn legal row).  
3. Dual Continue / dual chrome **reachability still NOT COMPUTED** in her map — look rule stated, play proof missing.  
4. Fight-result leave CTA still **NEEDS WORDS** — presentation can reserve eye-slot only.  
5. Blood **ACCEPTED (fallback)** — doctor/stoppage board deferred.  
6. Dust/sweat boards are diagrams, not in-engine particle prototypes (still zero particles in project).  
7. Self-attack stands: Gym Floor may be over-scoped relative to fixing dual nav + leave CTA first.

---

## Files to land (name every one)

Under `_maria_delivery/` and `research/`:

- `M28_GYM_FLOOR_BOARDS.md`
- `CLAUDE_LAND_NOTE_M28_PASS3.md`
- `M28_board_gym_floor_keep.png`
- `M28_board_gym_floor_reject.png`
- `M28_board_roster_filler.png`
- `M28_board_dust_sweat.png`

Prior M28 files already on master stay as history.

Claude writes HANDOFF block; Maria does not edit `HANDOFF.md`.

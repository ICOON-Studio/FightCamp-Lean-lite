# J30 — How to Write a Move Script for Two-Fighter Combat Sports Animation

**Author:** John Research  
**Date:** 2026-09-14  
**Scope:** Research only. Method + template. No engine. No invented ms.  
**Problem (operator):** parts feel on different clocks; strike/reaction lack cohesion; distance reads robotic — no written execute-script for both bodies.

**Claim labels:** **DOCUMENTED** (URL opened) / **INFERENCE** / **NOT FOUND**.

---

## DECISIONS

A two-fighter move script is one document for **one exchange** (technique + outcome reaction) on **one shared clock**. It must contain:

1. **Identity** — technique, outcome (landed head/body, block, slip, miss), lead side, range band, naming ID.  
2. **Roles** — Thrower / Receiver (same idea as UE Contextual Anim roles). — **DOCUMENTED** (UE CAS roles)  
3. **Shared clock** — one timeline; contact = frame 0 (or labelled contact frame); all onsets relative to it. — **INFERENCE** (craft + UE sync)  
4. **Distance before / at contact / after** — metres or stance-widths; selects clip set / warp. — **DOCUMENTED** (UE distance selection criteria)  
5. **Alignment** — facing / offset at contact; warp window if root motion stretches to the target. — **DOCUMENTED** (Motion Warping / CAS)  
6. **Thrower phases** — anticipation → attack/throw → contact → follow-through/retract → recovery; body-part onsets (feet→hips→trunk→shoulder→arm) as measured blanks. — **DOCUMENTED** (craft phases + Menzel punch phases)  
7. **Receiver by outcome** — head/neck/trunk/feet response onsets; not a generic hit clip. — **INFERENCE** (paired asset practice)  
8. **Contact** — bone/point pair, contact frame, optional hit-stop hold. — **DOCUMENTED** (craft impact frame; Menzel contact phase)  
9. **Guard hand + footwork both men** — rear hand job; step/pivot enter and exit to stance. — **INFERENCE** (coaching + Fight Score geography)  
10. **Enter / exit** — from stance or prior exchange; to stance or next payoff (Fight Score: Frame→Transition→Payoff→Frame). — **DOCUMENTED** (Weapons of Choice Fight Score)

**Coverage matrix (shot list):** rows = technique × outcome × distance × direction/angle — **INFERENCE** as production practice; public UFC “coverage matrix” doc: **NOT FOUND** (GDC Vault paywalled). Prefer **paired capture** for contact exchanges when possible; else author both sides on one timeline then mark contact. Hayes: combos captured as one piece beats stitching bite-sized clips. — **DOCUMENTED**

**Tool split (this PC):** **Cascadeur** — two characters, contact/AutoPhysics, fulcrum cleanup, export. **Blender 5.2** — two armatures, NLA strips on one timeline, retarget/export. — **DOCUMENTED**

---

## SOURCES

| URL | Who | Year | What it says | Grade |
|-----|-----|------|--------------|-------|
| https://weaponsofchoice.com/the-textbook-of-stage-combat/foundations-of-staged-violence/choreography-basics/the-fight-score-method/ | Weapons of Choice | n.d. | Fight Score: Frames, Transitions, Tracks, Engagement, Payoff; geography before techniques | A |
| https://weaponsofchoice.com/the-textbook-of-stage-combat/foundations-of-staged-violence/fighting/choreographic-notation/ | Weapons of Choice | n.d. | Numbered attack/defence notation; footwork often learned in rehearsal not fully written | B |
| https://www.georgiaentertainment.com/2026/01/thom-williams-on-orchestrating-the-beats-as-a-stunt-coordinator-and-second-unit-director/ | Thom Williams | 2026 | Stunt coord breaks “…and they fight” into beats; previs as guidebook | B |
| https://www.studiobinder.com/blog/how-to-storyboard-a-fight-scene/ | StudioBinder | n.d. | Rehearse choreography, then shot list / storyboard | B |
| https://www.player.one/ufc-3-creative-director-explains-tech-123285 | Brian Hayes / Player.One | 2018 | Old: bite-sized clips stitched; UFC3: motion fields; **combos captured as one piece** | A |
| https://www.gdcvault.com/play/1021794/Animation-Bootcamp-UFC-Animation | Dowsett / Harrower (EA) | ~2015 | Two-man animation content + procedural (abstract only; full talk paywalled) | C |
| https://vorixo.github.io/devtricks/contextual-anim/ | vori / Doğa | 2024 | UE Contextual Anim: Roles, AnimSets, warp points, sync transform+timing, distance criteria | A |
| https://www.quodsoler.com/blog/motion-warping-character-attacks-using-blueprints-no-c-required | Quod Soler | n.d. | Motion Warping: named warp target, notify window, root motion required | B |
| https://charios.com/blog/2d-attack-animation-anatomy | Charios | 2026 | Attack anatomy: anticipation / action(contact) / recovery | B |
| https://rebusfarm.net/blog/follow-through-and-overlapping-action-the-animation-principle-that-prevents-stiff-motion | RebusFarm | n.d. | Overlap: torso→shoulder→elbow→hand delays; follow-through after primary | B |
| https://sunstrikestudios.com/en/blog/timing_in_animation/ | Sunstrike | 2026 | Mark contact/impact/settle on charts; layered root→torso→limbs | B |
| https://pmc.ncbi.nlm.nih.gov/articles/PMC8659887/ | Menzel & Potthast | 2021 | Punch phases attack/contact/retraction; 1000 Hz sensing; bag, not bout | A |
| https://cascadeur.com/help/getting_started/scenes/scenes_with_multiple_characters | Cascadeur | n.d. | Multi-character scenes + namespaces | A |
| https://cascadeur.com/help/tools/physics_tools/autophysics/autophysics_settings | Cascadeur | n.d. | Touch Points Movement keeps contact during interaction | A |
| https://docs.blender.org/manual/en/latest/editors/nla/tracks.html | Blender 5.2 Manual | n.d. | NLA tracks/strips for layered timing | A |
| https://lecture.nakayasu.com/en/docs/blender/nla/ | Nakayasu | n.d. | Two Mixamo chars: place, NLA, sync kick/fall timing | B |

Labanotation for game boxing scripts: **NOT FOUND** as common practice. Fighting-game startup/active/recovery: already on record — map to phases, do not replace body-part clock.

---

## THE TEMPLATE

Fields marked **S** = source-supported; **O** = ours (measure or production choice).

```
EXCHANGE_ID:          [S naming] e.g. BOX_JAB_HEAD_LAND_ORTH_MID
TECHNIQUE:            jab | cross | lead_hook | rear_hook | uppercut | body_shot
OUTCOME:              land_head | land_body | blocked | slipped | missed
LEAD:                 orthodox | southpaw   THROWER_SIDE: lead|rear
RANGE_BAND:           close | mid | far     (define cm later)     [O]
ROLES:                Thrower=T  Receiver=R                        [S UE]

DISTANCE_BEFORE_m:    ____   [O measure / select AnimSet]
DISTANCE_CONTACT_m:   ____   [O]
DISTANCE_AFTER_m:     ____   [O]
FACING_OFFSET_deg:    ____   [O]
WARP_WINDOW:          start_f=__ end_f=__  target=R.chest|head   [S UE]

SHARED_CLOCK_FPS:     30 and 60 columns
CONTACT_FRAME:        0 (= glove/bone meets target)               [S craft+lab]

THROWER_PHASES (fill onset / peak in frames @30 | @60; blanks until measured):
  anticipation_start:  __|__   [S craft]
  attack_start:        __|__   (= fist moves toward target)       [S Menzel]
  contact:             0 | 0
  contact_end:         __|__   [S Menzel contact phase]
  retract_start:       __|__   [S Menzel]
  recovery_end:        __|__   (= guard/stance settled)           [S craft]

THROWER_CHAIN onset (relative to contact; successive break — not same frame):
  rear_foot / lead_foot: __|__
  hips:                  __|__
  trunk:                 __|__
  shoulder:              __|__
  elbow:                 __|__
  fist:                  __|__   [S overlap principle; values O/TO MEASURE]

RECEIVER_BY_OUTCOME (only fill the active outcome row):
  land_head:  head __|__  neck __|__  trunk __|__  feet __|__
  land_body:  trunk __|__ hips __|__  feet __|__
  blocked:    guard_hand __|__  absorb __|__
  slipped:    head __|__  trunk __|__  feet __|__
  missed:     (optional flinch) __|__  or none
  [O TO MEASURE; structure S craft]

CONTACT_POINT:     T.fist → R.head|body|glove                     [O]
GUARD_HAND_T:      rear hand stays at chin / job during throw     [O/INFERENCE]
FOOTWORK_T:        enter step? pivot? exit to stance              [O]
FOOTWORK_R:        plant / give ground / circle                   [O]

ENTER_FROM:        stance | prior_exchange_id                     [S Fight Score]
EXIT_TO:           stance | next_exchange_id                      [S Fight Score]
CAPTURE_NOTE:      paired_mocap | solo_clips+timeline_align       [S Hayes+tools]
```

---

## A FILLED EXAMPLE — jab to head, landed

```
EXCHANGE_ID: BOX_JAB_HEAD_LAND_ORTH_MID
TECHNIQUE: jab   OUTCOME: land_head   LEAD: orthodox   THROWER_SIDE: lead
RANGE_BAND: mid
ROLES: T=Thrower R=Receiver
DISTANCE_*: TO MEASURE (film or tape marks at capture)
FACING_OFFSET_deg: TO MEASURE
WARP_WINDOW: TO MEASURE if using root-motion stretch

SHARED_CLOCK_FPS: 30 | 60    CONTACT_FRAME: 0

THROWER_PHASES (experienced bag jab means — DOCUMENTED Menzel 2021; NOT bout pair):
  attack (throw) mean: 117 ms → ~3.5 f@30 | ~7 f@60     [DOCUMENTED]
  contact mean:        144 ms → ~4.3 f@30 | ~9 f@60     [DOCUMENTED]
  retract mean:        262 ms → ~7.9 f@30 | ~16 f@60    [DOCUMENTED]
  total mean:          523 ms → ~15.7 f@30 | ~31 f@60   [DOCUMENTED]
  anticipation_start:  TO MEASURE (lab paper starts at fist toward target)
  recovery_end:        TO MEASURE after retract to defensive pose
  BODY-PART CHAIN:     TO MEASURE (paper is glove/fist phases, not feet→hips→arm)

RECEIVER land_head:    TO MEASURE from paired footage (onset head vs trunk vs feet)
CONTACT_POINT:         T.lead_fist → R.head
GUARD_HAND_T:          rear hand near chin — TO CONFIRM on footage
FOOTWORK_*:            TO MEASURE
ENTER_FROM / EXIT_TO:  stance
CAPTURE_NOTE:          prefer paired capture; else align solo jab + head-hit on one timeline at contact
LIMIT:                 bag/single-max ≠ live bout exchange — DOCUMENTED limitation
```

No other ms invented.

---

## HOW TO MEASURE IT FROM VIDEO

1. **Pick contact first** — first frame glove/bone meets head/body/pads; set as 0. — **INFERENCE** (craft “impact frame”) aligned with Menzel contact definition.  
2. **Mark thrower** — first frame fist moves toward target (attack); last contact; fist back to guard (retract end). — **DOCUMENTED** (Menzel phase defs)  
3. **Mark receiver** — first frame head/trunk/feet react; peak displacement; settle. — **INFERENCE**  
4. **Mark distance** — stills before / at contact / after (floor marks or measure in DCC). — **O**  
5. **Do not move parts on separate clocks** — if fist peaks while feet/hips still “idle,” fix the script then the clip. — **INFERENCE** (operator symptom ↔ overlap principle)  
6. **Frame rate:** playback/analysis often 30/60; lab punch work used **1000 Hz** sensing / Vicon validation — **DOCUMENTED** (Menzel). Prefer ≥60 fps source for phase marking; 24 fps film is coarse.  
7. **Authoring:** Cascadeur — both characters, lock contact (Touch Points), fulcrum clean, export. Blender — both armatures, NLA strips, scrub to shared contact, export. Runtime later may warp distance (UE pattern) but **script still owns contact frame**. — **DOCUMENTED**

---

## OUT OF SCOPE

Engine code, invented body-part ms, full GDC Vault transcripts (paywalled), UFC broadcast as measure source.

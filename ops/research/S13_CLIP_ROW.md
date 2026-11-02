# S13 — THE CLIP ROW WAS MOSTLY A TRANSLATION PROBLEM

Greenlit by the operator 2026-09-18 ("Go 2") off `now`'s OPTION 2: S9's CLIP
row, 101,277 degraded beats, 73.2% of all degrades and 30.2% of every action
beat, described as "a standing strike with no clip: bind an owned one, or buy
it".

**Most of it was neither a missing clip nor a purchase. It was the THAI NAME of
a move already on file.** `Mat Yaep` is a jab. `Mat Trong` is a cross. `Te
Chiang` is a diagonal round kick to the body, which is what the roundhouse film
already plays for four other ids.

## WHAT MOVED

`tools/measure_presentation_split.gd`, the same instrument S9 used, re-run on
the same population after the table landed
(`research/S13_PRESENTATION_SPLIT.md`):

| state | S9, before | S13, after | change |
|---|---:|---:|---:|
| EXACT — the move the engine named | 98,055 (29.2%) | **158,731 (47.3%)** | **+60,676** |
| SUBSTITUTE — a different move plays | 66,543 (19.8%) | 66,543 (19.8%) | 0 |
| DEGRADE — he holds his guard | 138,353 (41.2%) | **77,677 (23.2%)** | **−60,676** |
| GENERIC | 16,894 (5.0%) | 16,894 (5.0%) | 0 |
| SILENT (must be 0) | 0 | 0 | 0 |

**The CLIP row itself: 101,277 → 40,601 beats, 30.2% → 12.1% of action beats.**
It is no longer the majority of the degrade queue (73.2% → 52.3%).

**SUBSTITUTE DID NOT MOVE, AND THAT IS THE CHECK THAT MATTERS.** Not one beat
changed which move it shows. Every beat this stage touched went from showing
NOTHING to showing the move the engine actually named; none went from showing
one move to showing a different one. The conservation is exact — the same
60,676 leaves DEGRADE and arrives in EXACT — which is what says the change is
the table and nothing else.

`tools/measure_technique_demand.gd`: coverage **30.3% → 48.4%**, ids bound
14 → 31, ids fired 55 (unchanged).

## THIS IS AN UPPER BOUND ON WHAT THE EYE GETS, AND S6c IS WHY

`measure_presentation_split` reproduces `FightStagePlayer._thrower_clip` from
each beat's own flags. **It measures that function, not the picture.** S6c paid
for this distinction one stage ago: routing `mma_guard_gnp` moved 4.65 points
out of the degrade column on the same kind of instrument, and in a RUNNING room
only 11 of 79 routed beats (13.9%) actually played a film — every other refusal
was `already_playing`.

The same ceiling applies here. A beat that now resolves EXACT still has to find
the fighter's body free: `thrower_held` — a man who HAS his clip and does not
play it because a set piece owns him (`FightStagePlayer.gd:830`) — is a real
fourth outcome that needs a running room and **is not measured by this stage or
by S9**. So read +60,676 as "beats that can now be shown", not "beats the
operator will see". What IS load-bearing is the direction: none of them could
have been shown before, and no beat changed which move it shows.

`fight_stage_technique_fidelity_test` is the part that does run through the
player, and it asserts `silent_claims == 0` — so every id bound here resolves to
a role the library actually holds. That is the graft proven, not the occupancy.

## POPULATION AND CATALOGUE

U56's two men, carried unchanged so every number here is commensurate with S9's.
**A: reach 183 cm**, power 60 / technique 62 / speed 58 / defense 55 /
conditioning 60 / fight_iq 50 / grapple 40. **B: reach 176 cm**, power 55 /
technique 48 / speed 62 / defense 58 / conditioning 70 / fight_iq 55 /
grapple 70. Eight differentiated quantities; not two copies of one man. Neither
carries a `technique_progress` record, so each is handed his RULESET's whole
tier 1–2 palette — they differ by attributes inside the rules rather than by
having techniques removed, and both are legal for every ruleset measured.
Catalogue: `res://assets/data/combat_rulesets.json`, 100 bouts × 3 rounds ×
four rulesets, seed bases 560000 +1000 per ruleset, 335,443 action beats.

## THE METHOD, AND WHY THE OLD CEILING WAS NEVER A CEILING

U56's "59.0% ceiling" has been quoted for three stages as the limit of what we
own. **It is now 71.3%, and it moved because the number was never a ceiling.**

`measure_technique_demand` computes it as today's coverage plus every unbound
fired id whose TOKEN-MATCHES A CLIP FILENAME in `Q47_INVENTORY.csv`. Nothing in
that heuristic can connect `muay_thai_mat_yaep` to `H2H_JabInPlace.FBX`: the id
and the file share no token. So the ids this stage bound were mostly invisible
to it, and 12.3 of the 18.1 points gained were points the "ceiling" said did not
exist.

**The instrument that found them was `technique_catalog.json`'s own `name`
field** — "Mat Yaep (Jab)", "Te Kot (Down Roundhouse)", "Khao Ti (Knee Slap)".
The catalogue has been telling us what each id IS all along, in English, in
brackets. **When a coverage number is derived from filenames, read the data's own
names before believing its ceiling.**

## WHAT IS BOUND, AND ON WHAT EVIDENCE

Sixteen aliases in `FightBeatAdapter.TECHNIQUE_CLIP_ALIASES` and three new
`FightClipBinding.BINDINGS` keys. Aliases rather than second BINDINGS rows
because every target is a role `FightStagePlayer.prepare` already grafts: a
duplicate binding would copy a path and a window that can drift, and would have
to be hand-added to `technique_roles()` or it would lift `has_clip` and never
play.

| id | catalogue name | plays |
|---|---|---|
| `muay_thai_mat_yaep` | Mat Yaep (Jab) | `jab` |
| `muay_thai_mat_trong` | Mat Trong (Cross) | `cross` |
| `muay_thai_mat_wiang_san` | Mat Wiang San (Hook) | `hook_lead` |
| `muay_thai_mat_wiang_yao` | Mat Wiang Yao (Overhand) | `boxing_overhand` (haymaker) |
| `muay_thai_switch_kick` | Switch Kick | roundhouse |
| `muay_thai_body_kick` | Body Kick | roundhouse |
| `muay_thai_te_chiang` | Te Chiang (Diagonal Kick) | roundhouse |
| `muay_thai_low_kick` | Low Kick | right cut kick |
| `muay_thai_te_kot` | Te Kot (Down Roundhouse) | right cut kick |
| `muay_thai_khao_ti` | Khao Ti (Knee Slap) | straight knee |
| `muay_thai_khao_chiang` | Khao Chiang (Diagonal Knee) | straight knee |
| `muay_thai_te_khao` | Te Khao (Axe Heel Kick) | **axe kick (new)** |
| `tkd_naeryochagi` | Naeryo-chagi (Axe Kick) | **axe kick (new)** |
| `tkd_spinning_hook` | Dwi-huryeo-chagi | **spinning hook kick (new)** |
| `muay_thai_low_cross_hook` | Low Kick – Cross – Hook | cut kick, **PARTIAL** |
| `muay_thai_switch_cross` | Switch Kick – Cross | roundhouse, **PARTIAL** |
| `muay_thai_jab_teep_switch` | Mat Yaep – Thip – Switch Kick | `jab`, **PARTIAL** |

New bindings: `kickboxing_axe_kick` → `H2H_AxeKick_InPlace`,
`muay_thai_thip_khang` → `H2H_LowSideKick_InPlace`,
`kickboxing_spinning_hook` → `H2H_SpinningHookKick_InPlace`. All three windows
and `readable_s` are C92's measured values (content = file length, dead air
0.000 on each); none was copied off a neighbour.

The three PARTIAL rows show what the combination OPENS with — the pattern
`kickboxing_jab_lowkick` established. Incomplete, not false, and a bought
combination clip upgrades all three.

## WHAT WAS WATCHED

`tools/audit_unbound_contact_sheets.gd`, nine samples per film, both views,
`research/S13_SHEETS/`. The mannequins are `f05_m_mma_light_rigged` and
`f09_m_bare_welter_rigged` at 70.0 kg — named because the standing rule says to
name a population, but a film audit is not an engine measurement and nothing
here is a finding about the fight.

- **`H2H_KneeStrike_Forward`** (the CONTROL, already bound): a committed knee
  driven UP the centreline into the body, hips square behind it, hands tight to
  the head, with a hop off the support foot.
- **`H2H_AxeKick_InPlace`**: he steps in, the leg swings up past head height
  until it is vertical above him, then chops down through the centre. A textbook
  axe kick.
- **`H2H_SpinningHookKick_InPlace`**: he is BACK-TO-CAMERA in frame 1, turns
  through, and the leg whips out at head height on the far side of the rotation.
- **`H2H_LowSideKick_InPlace`** (S6b's sheet, re-read): torso bladed and leaned
  away, support foot pivoted, leg thrusting out sideways at thigh height.

## THE REFUSALS, WITH THEIR COST

Every one is recorded in `FightClipBinding.gd` beside the binding it sits next
to, so nobody re-binds it to win the number back.

| id | beats | why not |
|---|---:|---|
| `muay_thai_khao_khong` | 4,762 | Curving Knee — arcs in from OUTSIDE; the film drives straight up |
| `muay_thai_khao_tat` | 4,743 | Horizontal Knee — travels ACROSS; the film drives straight up |
| `kickboxing_hook_kick` | 2,805 | a hook kick does not turn the man's back to his opponent; the only film we own spins |

**The knee split is the whole judgement of this stage.** One film, four ids,
19,068 beats. The film's line of attack is VERTICAL, so the two ids that travel
up were bound and the two that travel across or around were not. Height is not a
line of attack — that is S6b's ruling on the high kick, applied to knees.

## WHAT IS STILL A PURCHASE — and the remaining CLIP row IS this list

40,601 beats, and the top of the degrade queue now reads as the shopping list
exactly:

| id | beats | what is missing |
|---|---:|---|
| `muay_thai_horizontal_elbow` | 4,769 | an elbow thrown across the front, on the spot (R127) |
| `muay_thai_khao_khong` | 4,762 | a curving knee |
| `muay_thai_khao_tat` | 4,743 | a horizontal knee |
| `muay_thai_sok_phung` | 4,705 | a forward thrust elbow |
| `kickboxing_teep` | 4,500 | a push kick (S6b) |
| `kickboxing_front_kick` | 4,492 | a push kick (S6b) |
| `muay_thai_mat_soei` | 3,644 | an uppercut that reads as one (R127) |
| `muay_thai_teep` | 3,162 | a push kick (S6b) |
| `muay_thai_thip_top` | 3,019 | a slapping foot-thrust |
| `kickboxing_hook_kick` | 2,805 | a non-spinning hook kick |

**Three families cover 39,601 of the 40,601: push kicks (15,173), elbows
(9,474) and knees that do not travel up (9,505), plus the uppercut and the hook
kick.** That is a far more specific purchase brief than "the CLIP row", and it is
what a shopping task should be pointed at — unlike OPTION 1, this one names the
moves, the counts and the reason each is missing. No SKU has been looked for yet;
that is a shopping job and it has not been done.

## THE TRAP THIS STAGE CLOSED

`tests/fight_clip_alias_test.gd` is new and it is a CONTRACT test between two
tables that live in different files and do not know about each other:
`FightClipBinding` decides what is BOUND, `FightStagePlayer.prepare` decides
what is GRAFTED, and a role can be the first without being the second — in
which case `has_clip` is true, every coverage number we publish moves, and the
fighter stands still. `FightClipBinding.gd` names that defect (R103) in a
comment; nothing tested it, and S13 took the alias table from three rows to
nineteen, widening the gap twentyfold.

162 checks, and it found one thing on its first run: **`getup` is bound and is
in none of the four role lists.** That is not a defect — `prepare:208` appends
it BY NAME, outside every list, because a get-up is queued behind a knockdown
rather than asked for by the director. The test's model of "what gets grafted"
was wrong and now says so in its own comment. A by-name append in `prepare` is
invisible to every list-based reader, and there is exactly one of them today.

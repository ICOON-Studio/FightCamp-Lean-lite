# K28 — ONE CLIP, TWELVE DIFFERENT BODIES

Owner: kalli. Task: `research/TASK_K28.md`. Stage S4a input.
Delivered in Kalli's chat on 2026-09-13 (1:06-1:09 PM, after the first send misrouted into a John chat) and filed by Claude from the transcript; Grok Bot's tables arrive tab-separated and are re-set as markdown tables. Labels are Kalli's own.


Study only · access ~2026-09-13 · no code · no repo · no tests

Claude collects as: research/K28_ONE_CLIP_TWELVE_BODIES.md

DECISIONS
HEADLINE (Q5): mostly MOOT. Same weight class + females never fight males → the canvas never hosts flyweight-woman vs heavyweight-man. One shared clip across twelve bodies is an authoring/QA problem, not a live matchup problem.
Do nothing for matchups first. At 9–11 m / 20° down, within-class FK retarget is usually good enough until playtests show contact bugs.
If ONE engineering fix: hand-aim IK at punch impact (blend to opponent head socket) — highest residual value for within-class height outliers.
Author clips on a mid archetype; stress-test extreme bodies offline only — do not buy twelve clip sets.
Optional later: 2–3 body archetypes (Fight Night–style), not per-fighter libraries.
HW caveat: within-heavyweight height can still be large — “same class” ≠ “same proportions.”
NOT FOUND: any published angular/mm visibility threshold for this fight camera — do not invent one. Lab footskate <21 mm is lab-only.
Out of scope: faces/skin (K26), stance (K27), GDScript.
Q5 first — does weight class save us?

Yes, for the case that was scaring you.

The expensive nightmare is one in-place punch clip on a 50 kg flyweight woman and a 110 kg heavyweight man in the same bout. Your booking already forbids that (weight-class match + no mixed sex). Class-mean height gaps fly→heavy are on the order of ~25–30 cm in published division averages (Fight Matrix 2021 update) — and those two never share a canvas under your rules.

What remains:

Within-class height and limb variance (two welters, one short, one tall).
Non-match uses of the same clip on all twelve (gym idle, menus, marketing).

So: stop planning as if twelve-body extremes co-fight. Plan for same-class pairs, with HW as the within-class outlier risk.

Q1 — What actually goes wrong

Shared mesh-free humanoid clips (22 bones) retarget by copying rotations (FK). Different limb lengths move end effectors (hands, feet) to different world places. That is the whole failure family.

Camera for visibility judgment: 9–11 m back, 3.8–4.2 m up, 20° down, over the ropes. No published “noticeable at this camera” tolerance was found — NOT FOUND. Judgments below are engineering common sense + lab perception work, not a measured fight-cam study.

| Failure | What happens | Visible at our fight cam? |
|---|---|---|
| Foot float / sink | Shorter legs leave FK feet short of the floor (order-of-magnitude: ~10% shorter legs → ~10% short — StraySpark UE retarget guide, 2026-07-29). UE IK Retargeter exists to keep foot contact across sizes. | Usually subtle in-place. Lab: footskate <21 mm often perceptible up close (Pražák et al., SCA 2011). Fight-cam mapping NOT FOUND. |
| Foot slide | Root translation vs different leg length (worse in locomotion than true in-place). | Mild for in-place punches; more obvious in walk cycles / close replay. |
| Punch short / through head | Fist ends at this body’s relative head height, not a shared world head plane (Epic: FK end locations differ with proportions). | More visible than foot mm-errors when contact silhouette or hit timing breaks. Exact 10 m threshold NOT FOUND. |
| Hand–torso self-clip | Proportion / rest-pose mismatch (Unity Muscle Settings exist to reduce self-overlap). | Partially masked by distance, ropes, motion — extreme cases still read as silhouette. |
| Bow-legged / odd stance width | Hip–femur mapping / T-pose misconfig (common humanoid retarget footgun). | Low salience at 10 m unless extreme — measured threshold NOT FOUND. |
| “Wrong weight” look | Mesh volume / secondary flesh — not fixed by bone retarget. Fight Night used per-body-type deform (EA art, 2011). | Silhouette readable at fight cam; separate from clip sharing. |

Engine anchors: Unity Humanoid Retargeting + IK manuals; Unreal IK Rig Animation Retargeting (“characters of any size… precise hand or foot contact”); UE “Fix Foot Sliding with IK Retargeter.”

Q2 — 165 cm vs 195 cm, same “head” punch

ΔH = 30 cm (~18% taller).

Without aim IK: the taller man’s fist goes to his authored relative head/chest height in world space — higher than the shorter man’s. Each looks roughly self-consistent against a same-size opponent. Against a mismatched opponent, misses of tens of cm are possible; an exact miss vector for an arbitrary clip is NOT FOUND (depends on authoring skeleton).

What games do (published):

| Approach | Evidence |
|---|---|
| Relative / touch IK + player scaling | EA Sports MMA — HumanIK, relative IK, touch tags, foot pin, retarget across builds (MCV 2010-12-03; GameDev.net 2010-11-30; CGW 2011) |
| Hand IK to opponent head | Engine pattern: Two Bone IK / set IK position to head; Unity Animation Rigging; UE forum boxing discussions |
| High/low punch layers by target height | Community advice (StackExchange) — not a shipped postmortem |
| Retarget Source per authoring body | UE4 retargeting blog: tall vs short sources when mixing proportions |
| Forbid mismatch | Real boxing weight classes — you already do this for sex + class |
| Uniform clip scale alone | Helps stride/height ratio; does not replace contact IK for punches |
Q3 — What shipped games actually do
| Source | Practice |
|---|---|
| EA Sports MMA (2010) | Shared anim + procedural contact (relative IK, touch tags, foot pinning, player scaling) for varying builds — the clearest public boxing/MMA-adjacent write-up. |
| EA UFC (GDC) | Abstract: 100+ fighters, unique proportions, procedural solutions. Talk details paywalled → method NOT FOUND beyond abstract. |
| UFC 2009 Undisputed (GDC) | Abstract: full-body IK targeting. Details NOT FOUND without the talk. |
| Fight Night Champion | Multiple body types + per-type secondary deform — not one uniform scale for all. Punch clip-set strategy NOT FOUND in public art blogs. |
| Engine default | Retarget-and-accept for similar humanoids + IK correction for contacts/feet. |

Per-fighter full clip libraries as a published boxing/MMA requirement: NOT FOUND. Teams publish retarget + procedural contact, not twelve authored punch sets.

Winner in practice for a small shared clip buy: retarget-and-accept within similar bodies, plus contact IK if needed — not per-size clip farms, not forbidding same-class height variance entirely.

Q4 — Cheap fixes, ranked (smallest work that reads)
| Rank | Fix | Cost | Value under YOUR rules |
|---|---|---|---|
| 1 | Do nothing (matchups) | 0 | Highest ROI — extremes never meet; cam is forgiving. |
| 2 | Hand-aim IK at impact | Low–med | Best single engineering fix for residual within-class ΔH / contact bugs. Matches EA MMA “touch/relative IK” pattern. |
| 3 | Foot plant / leg IK | Low | Cleans float/slide; weak for punch aim. |
| 4 | 2–3 body archetypes | Med content | Fight Night path; reduces retarget stress long-term. |
| 5 | Uniform scale of whole clip | Low | Weak alone — wrong proportions; do not treat as the fix. |
| Avoid | Twelve per-fighter clip sets | High | Not what published pipelines buy for this problem. |

If forced to one engineering line: hand-aim IK.

If optimising ship cost including “ship nothing”: do nothing until within-class playtests fail contact, then add hand-aim IK.

Within-class height (the residual)
| Comparison | Published magnitude | Implication |
|---|---|---|
| Fly vs heavy (class means) | Fly ~164 cm; HW ~189–194 cm → ~25–30 cm (Fight Matrix 2021) | Moot on canvas under booking |
| Within HW (championship anthropometry) | Mean 192.6 ± 6.5 cm; observed 178–213 cm (Δ up to ~35 cm) — PMC 8786172 | Can rival fly→heavy in rare HW pairs |
| Adjacent capped classes | Means often a few inches apart (Fight Matrix 2021); within-fly SD NOT FOUND | Shared clip usually fine; tall/short outliers → IK or archetype |

Linealboxing-style claim that large height gaps are uncommon because of weight classes aligns with your booking: https://linealboxing.com/does-height-matter-in-boxing/

Rejects
Inventing a fight-cam mm/degree visibility tolerance
Paying for twelve punch libraries to solve a matchup your rules prevent
Uniform scale as the “one true fix”
Treating menu/gym idle on all twelve as proof that matchups are broken
Claiming EA UFC GDC method details we could not read
Sources (read ~2026-09-13)
Unity Retargeting / IK / Muscle manuals (docs.unity3d.com)
Unreal IK Rig Animation Retargeting; Fix Foot Sliding with IK Retargeter; UE4 intro-to-retargeting blog
StraySpark UE retarget guide (2026-07-29)
MoCap Online animation retargeting guide
EA MMA: MCV diary 2010-12-03; GameDev.net “Building Brawl” 2010-11-30
Fight Night Champion art (EA, 2011-02-16)
Pražák / Hoyet / O’Sullivan, SCA 2011 (footskate perception)
HW anthropometry PMC8786172; Fight Matrix division height averages 2021

End K28. Weight class already did the expensive work — buy the shared clips, author mid, IK only if contact fails.

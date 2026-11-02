# D58 - Dola fresh eyes: the physio (S110)

Collected S111 2026-09-27 with `cici.py read --visible-only` (the tail of the chat, verbatim; Dola's answer to the attached render).

## Applied (S111)
no body at the table (the only idle on our rigs is a fight guard): ice pack + notes card + NEXT ON THE TABLE tag; a relaxed/lying clip is a Codex follow-up

## Dola's answer
Cheapest fix
Swap the animation clip only — keep the same rig/position:
Replace guard stance → neutral rest stand: feet shoulder-width, arms relaxed at sides or hands resting lightly on table edge, shoulders dropped, jaw loose.
No model movement, no prop changes, no new skeleton — single animation swap = lowest cost, zero geometry work.
3. Floating / overlapping / readability
Minor: Region tags can clip body outlines or overlap adjacent charts when values are long — add 4–6px padding to label bounds.
Minor: Colour band edges bleed slightly into the fighter name text on low-contrast amber — 1px text stroke or 10% darker text fixes this.
None: Props (ice chest, foam rollers, sink, mat) sit clean on floor grid; no floating geometry or Z-fighting.
4. ONE change to ship first
Replace the fighter’s combat guard pose with a relaxed recovery stand animation
Why first: it’s the strongest visual dissonance in the room — fixing it immediately makes the space feel like a physio/treatment room, not a training annex. It costs almost nothing (clip swap, no modelling/UV work) and raises perceived polish far more than any UI tweak.
Saved to: research/D58_DIGEST.md
Would you like me to turn this into a prioritised task card with exact animation clip names and UI padding values for direct implementation? Tap Fast and select Pro to get it.
Attached: physio.png - answer D58 from this image, not the web.
D58 DIGEST — THE PHYSIO ROOM (S110)
Assigned: 2026-09-27 | Owner: Dola | Source: physio.png direct review
1. Two-second test result
✅ Pass — wall answers instantly
Table
Status	Colour	Visual cue	Decision
Fit	Green	Full green bar, no lit region	Train hard
Sore	Amber	Amber bar, one lit body region	Go light / modify
Out	Red	Red bar, lit region + MED HOLD	No training
Top chart = green → fully clear. Middle = amber → caution/light work. Bottom = red → ruled out. Readable at a glance, no delay.
2. Fighting guard at treatment table
Impact
Moderate immersion break: Fighter stands upright but hands up, elbows tucked — combat guard inside a recovery space. Reads as "waiting to spar" not "here for treatment".
Low technical cost to fix: Rig and position are fine — only the animation is wrong.
Cheapest fix
Swap animation clip only: replace guard → relaxed idle: feet apart, arms loose at sides or hands resting on table edge, shoulders dropped. Same rig, same spot, no modelling work.
3. Floating / overlapping / readability
✅ Props: Ice chest, rollers, sink, mat — all grounded clean, no floating or Z-fighting.
⚠️ Labels: Middle/red region tags sit close to body outlines; at a glance they slightly crowd the lit area — minor but noticeable.
⚠️ Text contrast: Amber-band text is slightly harder to distinguish against mid-tones than green/red — subtle, but slows the 2-second scan.
❌ No floating geometry anywhere visible.
4. ONE change to ship first
Replace the guard stance with a relaxed recovery idle animation
Why first: it’s the biggest feeling mismatch in the whole room. Everything else reads "care and rest" — this one pose reads "alert and fighting". Fix costs nothing but a clip swap, and immediately makes the room feel like a physio space.
Saved to: research/D58_DIGEST.md
I can turn this into a ready-to-implement task list with exact animation names and label spacing values — tap Fast and select Pro to get it.

# TASK_G84 - where the hands and feet ARE in the five most-used ground holds, as surface grips (Grok)

Model: Grok, Research mode, Expert. NEVER Build. Owner: grok. Assigned S63, 2026-09-24, after G83.

## Why
S63 wires a contact solver into the live fight room: after the two clip halves pose, each declared
GRIP (a hand or foot of one man placed at a point ALONG a body segment of the other, e.g. "his left
hand halfway along the other man's neck") is solved by moving the ARM or LEG only - the bodies stay
where the engine put them. The grips we declare today were written by hand from memory. C170's
closed guard failed because a wrist grip and an ankle lock drifted; nobody had a source for where
those hands and feet should be.

## The question
For each of these five holds - **mount (top), closed guard (bottom man attacking and top man
postured), half guard, side control, back control (seat-belt + hooks)** - list the grips a
competent fighter holds in the DEFAULT controlling version of the position (MMA rules, no gi,
so no collar/sleeve grips), each as:
`hand/foot | which man | segment of the OTHER man it holds (neck, upper back, wrist, forearm,
upper arm, waist, hip, thigh, ankle, head) | where along it (0 = proximal end, 1 = distal) |
grip type (cupping, wrapping, posting, hooking, crossed ankles) | how often it is held (always /
usually / sometimes)`.
And which grips the OPPONENT typically has at the same time (a mount bottom man frames on hips;
a closed-guard top man posts on the chest or controls biceps).

Label every row MEASURED (instructional/coaching literature counts only when it SHOWS the grip -
cite it; a grappling-statistics or motion-capture study is best), DERIVED, or JUDGEMENT. Where two
schools disagree (e.g. closed guard: overhook vs collar-tie-equivalent head control), give both.

## Deliverable
ONE Markdown table per hold (paste as Markdown, not a docx), then a one-paragraph "what an
animator gets wrong most often" per hold. Claude transcribes it to
`research/G84_WHERE_THE_HANDS_ARE.md`. No code, no test.

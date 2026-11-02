# CLIPREVIEW1 - Grok Expert (grok.com, Browser 1) - S259, verbatim from the page (get_page_text)
Round 1: frame sheet (before_after_stack.jpg). Round 2: the mp4 itself (operator S259: "why you do not upload the video file on grok ?").

## Round 1 (frames)
AFTER reads more like two real boxers. Stability improved (root >4 m/s gone; sliding cut roughly in half). Both sides still break badly on spacing and residual foot issues.

Which side / breaks
AFTER is clearer and more grounded. BEFORE shows more "legs fly / slide" (e.g. top-row frames 1, 3, 5 and bottom-row 1, 2 — rear feet skid or lift unnaturally while torsos collide). AFTER still has planted-foot sliding on ~13–15% of frames (186/161 of 1,200), hips too low on red (116 frames <0.70 m), and near-identical torso merges. Torso twist >50° is almost unchanged (17 → 19 frames on red). Worst visual breaks in both: every close exchange (roughly frames 2–4 and 7–9 in each strip) where chests occupy the same volume and feet splay or slide instead of staying planted or executing small controlled steps.

Feet during punches
Planted feet stay planted or execute small, deliberate moves only.
Jab: rear foot pushes (ball of foot), lead foot plants or advances ~5–15 cm (step-and-drag / push step); total stance width stays ~shoulder-width (~0.4–0.6 m). No free sliding.
Cross: rear foot pivots (heel raises, toe stays, ~30–45° rotation) while lead foot plants hard; push from rear is the power source.
Hook: lead foot either plants solidly or pivots on the ball (~20–40°); rear foot may step or pivot slightly to keep base. Feet rarely leave the ground more than a few cm; large lifts or continuous sliding are errors.
Sources: coaching consensus (step-and-drag, pivot on ball of foot) and plantar-pressure studies showing forefoot drive during power punches. Your sliding metric (still 13–15% of frames) is still well above a realistic "planted or controlled step" rate.

Punch speed
Amateur data (Stanley et al. 2018, ~6 years experience, maximal bag punches):
Jab: peak fist velocity 5.85 ± 0.85 m/s, delivery (guard to extension) 405 ± 150 ms.
Rear cross: 6.97 ± 0.86 m/s, 495 ± 150 ms.
Lead hook: 11.95 ± 1.84 m/s, 657 ± 145 ms.
Rear hook ~11.5 m/s, uppercuts ~10.6–11.6 m/s, deliveries ~580–630 ms.
Elite/professional straights commonly cited 7–11 m/s peak; return/snap-back is fast (often total cycle <500–600 ms for jab). A "bullet" jab is unrealistically faster than ~300–400 ms full extension.
Fight Night Champion is widely regarded as the gold standard for readable, impactful punch animation (motion blur + good weight transfer). Undisputed later sped selected punches to reduce visible flaws and improve impact feel. Games generally do not run punches at pure real-time peak speed; they slightly stretch or use blur/follow-through so the eye can track intent and reaction. Your operator complaint matches a common sim failure: extension too short/fast relative to the visual distance traveled.

Spacing
Jab/long range: chest-centre ~1.0–1.5 m (full arm + small step). Hook/pocket range: ~0.6–0.9 m. Clinch: <0.4–0.5 m (chest contact or near-contact). Your measured 0.557 m in exchanges is already inside clinch territory and produces torso merging.
Fighting games prevent this with capsule/sphere collision on the root or hips, IK limits that stop arms/torsos interpenetrating, root separation forces when distance drops below a threshold, or animation layers that force a "close-range" stance with elbows in. Pure root-motion without collision response lets models occupy the same space.

Three worst problems (priority)
1. Torso merging / spacing (0.557 m unchanged) — enforce minimum root/hip separation (~0.55–0.70 m at mid-range, tighter only in explicit clinch states), contact collision or soft constraint, compact close-range animations when distance collapses.
2. Residual planted-foot sliding (13–15%) — strong foot-plant IK during punch wind-up and impact, only small push-steps/pivots (5–20 cm or pure rotation), zero free sliding while a punch is active.
3. Unnatural torso twist + low hips — clamp torso/hip rotation relative to the planted base (~30–45° max for most punches), raise hip height floor in exchanges, drive rotation from feet/hips.
(85 sources)

## Round 2 (the video, 2 min 10 s)
AFTER is clearly better in motion. Root stability and foot control improved; the "legs fly" look is reduced. Remaining defects are still obvious on video.
- 0.0–1.0 s: start at range; AFTER already a bit more planted.
- 1.0–4.5 s: close exchanges. Torsos repeatedly near-merge. BEFORE more rear-foot skidding and small lifts; AFTER feet lower and more stable but still slides. Red's hips drop low multiple times.
- 4.8–6.2 s: slip-cross counter (overlay ~5.0–5.8 s). Arm extension on both sides completes in roughly 4–8 frames at 30 fps (~0.13–0.27 s). Reads snappy/fast, closer to a bullet than a readable 0.4 s amateur jab/cross. AFTER cleaner but still too quick and the torsos stay glued.
- 6.5–11.5 s: red stays low (hips well under 0.70 m on many frames). Mostly small shuffles; AFTER less floaty. Occasional torso twist >45–50° on red. Spacing tight.
- 12.0–13.5 s: best separation of the clip; guards up, feet more planted. No clear jab.
- 14.0–15.0 s and 17.0–18.5 s: re-close; same torso-merge and residual slide.
- 19.0–20.0 s: red low again, blue upright.
Jab speed: no isolated long-range jab clearly visible; the punches that fire (~5 s cross/counter, close shots) extend in ~0.15–0.30 s - faster than the ~0.40 s amateur delivery (Stanley 2018), reads as "bullet". Games add a few frames or motion blur so intent reads.
Updated top 3: (1) spacing / torso merge (1–6 s, 14–18 s): separation constraint, compact close-range layer under ~0.65 m; (2) punch timing: stretch jab/cross extension to ~0.35–0.45 s (or 2–4 frames of wind-up and follow-through), keep return snappy; (3) residual foot slide + low/twisted hips: plant IK in punch windows, only pivots or short steps.

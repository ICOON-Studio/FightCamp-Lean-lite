# Menus art style A/B (S398) - plan

Operator S398: "i dont mind changign to stylized art if this helps with the reviews" (after "this looks like a poor
text-adventure. add graphics and stunning visuals"). Main session's terms: ONE style for every page; measure first with a
blind A/B (fresh critics, neutral names, a control arm) on Fight prep and the walk-in card; roll out only on a clear win;
images from Ludo (upload reference pictures, never describe them), Tripo for 3D props, no new subscriptions; every asset
stored in the project; the 3D fight bodies stay MetaHuman; graphics carry information (the operator's actionable rule).

## What the built rounds already say
- Fight prep w5 (the game's own dark move renders as card pictures) scored LOWER than the text version: 5.4 / 6.0 vs
  6.4 / 5.8 - critics: "ten near-identical red-versus-blue renders carry nothing". Pictures must differ at a glance and
  say something (the kind of threat, where it lands, how dangerous) - not decorate.
- w6 uses coloured kind icons (Lucide) instead; scores pending.

## The A/B
- Arms (same page, same data, same layout; only the art changes):
  A = today (MetaHuman studio portrait, Lucide icons), B = stylized (flat illustration with bold shapes), C = control:
  today's look with one neutral change (a different accent colour) to measure critic noise.
- Pages: Fight prep (portrait + 4 matchup pictures) and the walk-in card (portrait + 3 trait pictures).
- Critics: 3 fresh blind per arm per page, neutral file names (page_1.png, page_2.png ...), the usual rubric; B wins only
  if its mean beats A by >= 0.5 AND beats C by >= 0.5 (C - A shows the noise floor).

## Assets for arm B (Ludo, Add to Project FightCamp, then into assets/ui/style_b/)
1. Opponent portraits: upload the studio photos of 4 boxers (assets/ui/face/studio/*.jpg) as references; ask for one
   flat-illustration bust each, same framing, plain backdrop.
2. Threat pictures (one per kind, readable at 64 px): best weapon (a glove and the target zone lit), habit (a repeating
   arrow over the guard), weakness (a fading figure / a dropping bar), their game (footprints driving forward).
3. Answer pictures: step off at an angle, elbows tight, busy start, pressure answer - the same style.
Store under assets/ui/style_b/ with a SOURCE.md (Ludo project, prompt, date); swap through one const so A/B is a flag.

## Order
After the S398 built rounds (Week, Fight prep) close: brief Ludo through Chrome (memory: reference_ludo_ai, upload
pictures), bake the arms, run the critics, report to the main session with the numbers.

# Why our gym does not look like Two Point Hospital - and the fix (S206)

Operator S206 (mark 4 on the HUD still, verbatim): "what is that ? i can't understand wtf am i wtaching right now , how are these
assets made in the game ? why we cannot have beautiful graphics and assets like 2point hospital ?"
Sources: John's research `J_TPH_LOOK_S206_reply.txt` (44k chars, every claim sourced), Maria's art-direction brief
`M_GYM_STYLE_S206_reply.txt` (readability checklist: one-second name test, silhouette from above, colour per station).

## The answer in one line
Our gym mixes three styles that clash: photoreal scanned gear (Poly Haven / Sketchfab), toy-like Kenney pieces and realistic MPFB
human bodies. Two Point is ONE chunky stylised style ("clay-like, not too rendered", no dirt), lit warmly, with zones you read at a
glance. A 1-2 person team cannot keep photorealism consistent; it can keep a stylised look consistent.

## What John recommends, in order of visual gain per hour (his estimates, one generalist)
0. One-page style sheet (~2 h): chunky stylised gym, Gleason's palette (brick-red walls, grey concrete, black steel, red/black/white
   leather), flat colours, props 10-25% oversized, warm key + cool fill, bright and alive.
1. Lighting + post pass (6-10 h, FREE): AgX tonemapper, SSAO + SSIL, warm key light, warm lamps over ring and bags, one colour grade.
2. Stylised characters (16-30 h, FREE): Quaternius Ultimate Modular (CC0), bigger hands/feet, our animations retargeted.
3. One prop family (12-20 h, MONEY): Shrimple3D Fitness Gym Pack US$39.99 (has rings/cages) or Synty Shops Pack US$199.99;
   recolour to the style sheet; remove every photoreal and mismatched piece.
4. Readability (10-16 h): cutaway walls, colour-coded floor mats per zone, one hero object per zone, fight posters on brick.
5. Polish (8-14 h): subtle tilt-shift, outline A/B test, idle variants.
Total ~54-92 h. NOT: mixing photoreal gear with stylised people; AI generation as the main asset source; grime textures.

## Claude's recommendation
Do step 1 (lighting, free) now behind the gym_look2 switch and show you stills; take the stylised direction (steps 2-4) as the
gym's art direction; buy the US$39.99 Shrimple3D pack first (rings/cages included) and only consider Synty if it falls short.
The fight scene keeps its current bodies until the gym look is approved (the certified moves were measured on them).

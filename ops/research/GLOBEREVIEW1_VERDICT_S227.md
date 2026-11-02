# GLOBEREVIEW1 - verdict (Claude, S227): one polish round on the globe (GLOBE3), then ship

Operator (Q-S225-8, verbatim): "use more agents to review". Three independent reviewers were given the same 4 pictures
(uploaded, not described): Ludo's reference, the globe Ludo scored 8.2, today's master UK-picked, today's master idle.
Replies (saved whole): GLOBEREVIEW1_MARIA_XAI.md (art direction), GLOBEREVIEW1_KALLI_XAI.md (game design), GLOBEREVIEW1_JOHN_XAI.md
(research, sourced).

## The verdict is unanimous: POLISH, not ship
| Reviewer | Globe Ludo scored 8.2 | Today, UK picked | Today, idle (the first frame a player sees) |
|---|---|---|---|
| Kalli | 5.6 | 4.7 | 3.2 |
| John | 6.1 | 5.2 | 3.6 |
| Maria | "about two points under 8.2" | - | - |
All three: the LAYOUT is right (title, search, list, globe left, full-height card right, one button) - keep it. The sphere material, the
idle frame, the pick and the card's broken rows are not. All three: do NOT chase Ludo's reference picture (its text is garbled, its
highlight sits on Iberia while the pin says UK) - take only its relief light and its pin.

## What GLOBE3 builds (Maria's spec + palette are binding; the others agree point by point)
1. **Real light** (all 3): one warm key from upper left + one cool rim from back right, lighting in the material only, no painted
   highlight glued to screen centre; ocean lacquer vs matte land so land and sea separate everywhere; ACES, light bloom on coasts only.
2. **The idle frame is the product** (all 3): open on the Atlantic (UK near centre), unselected land readable, slow 7 deg sway (no spin),
   a few market seed dots before any click, hover lights a country, a real empty-state card instead of "NOTHING CHOSEN YET".
3. **A pick lights the country** (Kalli, John; Maria item 3): the selected country is filled and its border is the brightest thing in
   the region; coasts become a brass inlay (SDF, smooth, 4x MSAA) instead of a 1 px stroke.
4. **The pin is a prop** (all 3): smaller oxblood/brass medallion on a stem with a contact shadow, a ring on the surface, a cream plaque
   label (2 px radius, not a pill), camera ease + stem pop on select.
5. **Stage it** (all 3): radar rings go (Kalli: "delete"; Maria: meridians at 12% behind the globe instead); a contact shadow under the
   sphere; a lifted ground (no pure black), cream type instead of pure white, the talent bar oxblood instead of health-bar red.

## The card (already in GLOBE2C round 2, #199) - added from the reviews
- A row that clips does not render (all 3 saw the sport chips clipped at 1920x1080 too, not only 1280x720).
- No empty containers (the empty hub dossier and the mystery chip grid read as missing art).
- Federations: "United Kingdom Combat Association" does not exist (John, sourced: the British Boxing Board of Control since 1929;
  England Boxing for amateurs). House rule: organisations are real. The block hides until the data names real bodies -> data task
  ORGS1 (backlog) to put the real federations per market in the data.

## Not taken now (backlog)
- John's Crusader-Kings map modes (globe fill by popularity / talent / purses) - good, after the demo.
- John's "origin line" (rent band, monthly intake, media ceiling under the bars, as F1 Manager does) - after the demo, with real numbers.

## Next
His OK on the board -> TASK_GLOBE3 to cloud Cursor (globe shader + scene, GlobePicker / globe scripts only; the card stays with #199),
red-first tests on the measurable items (key-light direction constant under yaw, no ring nodes crossing the card, idle yaw on the
Atlantic), stills at both sizes, idle + UK, rendered by Claude on the PC and shown to Ludo, Maria, Kalli and John again.

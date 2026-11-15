# Colour inventory (S490)

Operator: "do we have a colour pallete ? i see some menus lookdifferent than others".

**Answer:** yes, one: `scripts/ui/UI.gd` (about 30 named colours), plus WoodKit's 4 chalk inks for the approved wood and slate look. But 136 of the 314 `.gd` files under `scripts/ui` and `scripts/fight3d` write raw colours of their own: about 280 other hex values (417 distinct values if you count `Color(r, g, b)` literals, which include 3D materials). They fall into 11 look families, listed below.

Method: a regex over every `.gd` for `Color("#...")`, `Color.html(...)` and `Color(r, g, b[, a])`, plus each file's local `const` colour tables. 3D material colours (RingSet, FightStage, CornerCrew, PadWork, Referee, Mitts, ArtStyle, FaceFill, FaceMarks, MHRig) are left out of the roles because they are lighting and material tints, not UI.

Picture: `palette.png` beside this file (rendered from `palette.html`).

## Key findings

1. **UI.gd holds two looks.** Its constants are the S332 cream-paper whiteboard (PANEL #f6efe0, FG #241f1a, GOLD #27589e). Since S417 the theme's Card, Modal and TopBar are WoodKit slate textures, and `WoodKit.ink()` swaps the paper inks for chalk at run time. So the palette's own names do not describe what the player sees.
2. **TV.gd is a second full palette** (brown-gold, S333). It was meant for the fight HUD, but 34 files import it, including the result page, result tabs, corner swap cards, body tips and the headline card. Those menus look browner and use different greens and reds from the gym menus.
3. **DarkOverview.gd is a third dark palette** with its own BAND table. The fighter Overview tab draws the attribute bands in different colours from AttrBoard for the same data: solid #3f7fe0 vs #27589e, strong #2fb56e vs #23935d, fair #f08a24 vs #d97a00, elite #a36cff vs #8a5cf0.
4. **Office.gd has its own palette**: 27 hex, zero `UI.*` references, cool blue-black (#0b0f15) where every other menu is warm brown.
5. **Tips.gd (every hover card) uses navy ink #1f2a44** left over from look B instead of UI.FG brown, and has 0 UI colour constants.
6. **Meaning colours have no single source.** 14 greens, 22 reds, 10 ambers, 15 blues, 12 golds and 8 purples do the same jobs.
7. **Naming traps:** `UI.GOLD` is blue (#27589e), and so is `DarkOverview.TONE["gold"]` (#3f7fe0), while `TV.GOLD`, `Halo.GOLD` and `DuesBoards.GOLD` are real golds. Move tiers put green (usable) below blue (sharp); attribute bands put blue (solid) below green (strong).

## Look families

| Family | Files | Key colours | Note |
|---|---|---|---|
| A. Cream paper (UI.gd constants - the official palette) | UI.gd, HomeLook, AttrBoard, ComboStrip, MoveBook, MoveTip + every file that only says UI.X | wall #cfe0ea, panel #f6efe0, panel2 #ebe1cc, ink #241f1a, muted #5d5243, primary #27589e, good #23935d, bad #e2483d, warn #d97a00, elite #8a5cf0 | Written S332 for look B whiteboard. Since S417 the theme's Card, Modal and TopBar are WoodKit textures, so these paper inks sit on slate and WoodKit.ink() swaps them for chalk at run time. |
| B. Wood and slate chalk (WoodKit.gd, approved S417) | WoodKit, FirstWeekStrip, Halo, PlanChart, GamePlan, DuesBoards, RosterRowBits, CornerIcons, BodyPanels, NowPlate | slate #262a2d, frame #8a6a3d, ink #efe6d8, muted #b8a88f, title #f2c14e, blue #8fbcff, good #6fd39a, bad #ff6b5e, gold #f2b544 | The approved menu look. Only 4 inks are defined; good/bad/warn are not, so each file picks its own. |
| C. Fight broadcast brown-gold (TV.gd, S333) | TV + 34 importers: CornerSwapCards, CallButtons, BodyTip, BodyFigure, EnergyPips, ResultTabs, AftermathTiles, MatchStats, CornerStats, SwapLink, HeadlineCard, RecoverCards, ResultPage, HudArc, HudBars, ReactionBubbles | bg #1d1714, panel #2a211c, line #4a3a30, ink #f3ece2, muted #b5a595, gold #e9b84a, good #6cc27a, bad #e0503c, warn #f0a020 | The pre-look-B menu palette kept for the fight. It is ALSO used by the result page, corner cards and body tips - menus, not only the HUD. |
| D. Dark Overview (DarkOverview.gd) | DarkOverview (fighter Overview tab), ApproachCard, Tally, TapeVersus | panel #181311, inset #0d0a09, edge #c8402f, ink #f1e8da, muted #c9b9a2, head #ffd54a, good #2fb56e, bad #e2483d, warn #f08a24, solid #3f7fe0, elite #a36cff | A third dark palette, close to B and C but every value different. ApproachCard copies it by hand. |
| E. Whiteboard navy marker (WhiteboardKit, Tips) | WhiteboardKit, Tips (every hover card), WeekStrip, WeekCards, MatchupCards, DrillCard | board #f4f2ec, card #fffdf6, ink #1f2a44, pencil #6b7280, red #c8312a, good #1c6e43, bad #a8261f, watch #8f5100, note #fbe7a1 | Look B leftovers: navy ink instead of brown. The hover cards (Tips) are the most-seen screen in this family. |
| F. Warm paper cards (RosterCards) | RosterCards, HomeNeeds, DuesWire, Interview, FightPoster | paper #fff8ee, deep #f4e9d7, edge #cdbba3, ink #231f1b, muted #6e6256, red #c23b2e, blue #2a62c9, green #1c8a4b, purple #7a3fb0 | Near UI.PANEL / UI.FG but not equal; its own six attribute tile colours. |
| G. Office desktop navy (areas/Office.gd) | areas/Office.gd only - 27 hex of its own, 0 UI colour constants (it still calls UI helpers) | bg #0b0f15, panel #121821, line #283242, ink #e9e4da, dim #97a1b0, head #c9bfae, blue #5aa3ff, good #5fcf7a, bad #d93a3a, warn #f2b84b | A cool blue-black OS desktop: the one screen with no brown in it. |
| H. BJJ charcoal and yellow (MatMap) | MatMap, MatTree, MatGlyph, GrapplerPage (belts); MatPlayer + MoveStudio light studio | bg #1d1e22, box #2a2c31, card #26272b, text #eef0f3, dim #a3a8b2, owned #ffd54a, opp #2f6fdb, miss #ff6a5c, ahead #a98bff, studio #f1eee8 | Neutral grey charcoal, not warm brown. |
| I. Navy glass (gym hub) | GymHub, GymEquip, HomeCorners, TitleScreen | plate #172442, title #0d142e | Navy see-through plates over the gym picture, 0.86-0.92 alpha. |
| J. 3D fight HUD overlays (fight3d) | HudBars, HudArc, HudRegroup, ScoreBug, RoundBoard, CornerBar, SidePanel, Broadcast, RoundGraphics, TapeCard, ReadPanel, BodyHolo, SharedHolo | slate #1a1512, glass #0b0a0a, ink #f7f2e6, her red #db4238, red #f26659, their blue #4278e0, blue #80a6ff, good #7fd18b, gold #f2c14e, ready #f5c518, holo #40bfff | Red corner and blue corner are drawn in 4 reds and 5 blues across these files. |
| K. Iso gym map (IsoGym.gd) | IsoGym only | wall #f4f1ec, side #dcd6cf, floor #e9c998, edge #5a6172, blue #2f6fdb, red #d9412f | Bright room tiles - a map, fine to differ. |
| L. 3D materials (not UI) | RingSet, FightStage, CornerCrew, PadWork, Referee, Mitts, ArtStyle, FaceFill, FaceMarks, MHRig, FighterFace | ring canvas #174799, corner reds #9e0f0f / #990f0f, blues #0f2999 | Material tints, outside the menu palette. |

## Roles: the different values used for one job

| Role | Count | Values (where) |
|---|---|---|
| Panel background (dark) | 22 | #1d1714 (TV.BG); #2a211c (TV.PANEL); #181311 (DarkOverview); #211a15 (CornerSwapCards); #1a1512 (RoundBoard/CornerBar); #241b14 (SidePanel); #14100c (HudRegroup); #1b1612 (HeadlineCard); #14120f (WeekTired); #120d0a (VersusPanel); #0d0a09 (HoverLabel); #262a2d (FirstWeekStrip); #2a2d33 (ReadPanel); #0b0f15 (Office.BG); #121821 (Office.PANEL); #1b2740 (Money); #292e38 (DuesWire); #172442 (GymHub); #1d1e22 (MatMap); #26272b (MatTree); #090f17 (BodyHolo); #0f1217 (TapeRoom) |
| Panel background (light) | 12 | #f6efe0 (UI.PANEL); #ebe1cc (UI.PANEL2); #fff8ee (RosterCards); #f4e9d7 (RosterCards deep); #fffdf6 (Tips); #f4f2ec (WhiteboardKit); #fbf7ee (HomeNeeds/DuesWire); #fbfaf6 (Interview); #f1eee8 (MatPlayer/MoveStudio); #f4f1ec (IsoGym); #f3ead6 (FightPoster); #fde58a (DrillCard gold) |
| Ink on dark | 11 | #efe6d8 (WoodKit.INK/UI.TOP_INK); #f3ece2 (TV.FG); #f1e8da (DarkOverview); #e9e4da (Office); #f4efe4 (TapeVersus); #eef0f3 (MatMap); #efe8dc (HudArc); #f3ead8 (ScoreBug); #f7f2e6 (HudRegroup); #d8d0c0 (CornerBar); #e8ddd0 (HeadlineCard) |
| Ink on light | 4 | #241f1a (UI.FG); #231f1b (RosterCards); #1b1918 (FightPoster); #1f2a44 (Tips/WhiteboardKit (navy)) |
| Muted text | 14 | #5d5243 (UI.MUTED); #b8a88f (WoodKit.SOFT); #c9b9a2 (DarkOverview); #b5a595 (TV.MUTED); #cfc7b8 (TapeVersus); #97a1b0 (Office); #a3a8b2 (MatMap); #7a6e60 (ScoreBug); #6e6256 (RosterCards); #5e6773 (Tips); #6b7280 (WhiteboardKit); #8a929e (WeekStrip); #4b5563 (DrillCard); #7a8794 (WeekCards) |
| Primary / blue accent | 15 | #27589e (UI.GOLD (named gold, is blue)); #8fbcff (WoodKit.BLUE); #3f7fe0 (DarkOverview); #2f6fdb (ComboStrip/IsoGym/MatGlyph/WeekCards); #6f9cf0 (CornerStats/MatchStats); #5b9bff (RoundBoard); #3a7ce0 (ScoreBug); #4278e0 (Broadcast/RoundGraphics); #80a6ff (HudArc/HudBars/TapeCard); #5aa3ff (Office); #6ea2f2 (Shell); #2a62c9 (RosterCards); #1f4f9c (FightPoster); #7fb3e6 (ProOffer); #5fb4f0 (RecoverCards) |
| Header / gold / yellow | 12 | #f2c14e (WoodKit.HEAD/Halo/DuesBoards); #ffd54a (DarkOverview/MatMap/UI.YELLOW); #e9b84a (TV.GOLD); #f2cd6a (HeadlineCard); #f4c56a (GuideLight); #f2b544 (PlanChart); #f5c518 (ReadPanel); #e8c15a (Shell); #f0b429 (CallButtons); #e0a400 (WeekCards); #e9a800 (FlipCard); #c9bfae (Office HEAD) |
| Good / green | 14 | #23935d (UI.GREEN); #2fb56e (DarkOverview/Tally/ApproachCard); #6cc27a (TV.GREEN + 9 files); #5fcf7a (Office); #1c6e43 (Tips); #3f8f5a (WhiteboardKit); #58d68d (TapeVersus); #2fae6e (RoundBoard); #5ac76a (SidePanel); #7fd18b (HudRegroup/CornerBar); #6fd39a (GamePlan); #59cc80 (WhyCard); #1c8a4b (RosterCards); #9fe0c0 (UI.MINT) |
| Bad / red | 22 | #e2483d (UI.RED + 12 files); #e0503c (TV.RED + 8 files); #e06060 (CallButtons/CornerSwap/SwapLink); #d93a3a (Office); #c8312a (Tips/WhiteboardKit/WeekStrip); #a8261f (Tips BAD); #c8302a (FightPoster); #d4202a (ReadPanel); #d9412f (IsoGym); #c23b2e (RosterCards); #c8402f (DarkOverview edge); #c62832 (GrapplerPage); #f26659 (HudArc/HudBars/WhyCard); #db4238 (Broadcast); #ff6a5c (MatMap/MatPlayer); #ff6b5e (GamePlan); #ff7a6e (Shell); #ff7a6a (Office); #ff8a6a (HudRegroup/CornerBar); #ff8a78 (HeadlineCard); #ff4d2e (SharedHolo); #ff4033 (BodyCallouts) |
| Warning / amber | 10 | #d97a00 (UI.AMBER); #f08a24 (DarkOverview/ApproachCard); #f0a020 (TV.AMBER + 6 files); #f2b84b (Office); #8f5100 (Tips WATCH); #ff9a3c (SharedHolo/HudRegroup); #ffb347 (Shell); #f2bf4c (WhyCard); #ffcf6a (RoundHits few); #ff7a1f (RoundHits many) |
| Elite / purple | 8 | #8a5cf0 (UI.PURPLE); #a36cff (DarkOverview); #a050e0 (BodyTip doctor); #a98bff (MatMap ahead); #7b3fc4 (GrapplerPage belt); #7a3fb0 (RosterCards); #7c3aed (WeekCards/MatchupCards); #c9b3ff (HeadlineCard) |
| Borders / rules | 15 | #d3c7ae (UI.LINE); #ddd2bc (UI.ROWLINE); #aeb8c0 (UI.FRAME); #4a3a30 (TV.LINE/CornerSwap/HeadlineCard); #3a2e26 (TV.ROWLINE/SwapLink); #3a2f28 (DarkOverview side); #5a4a3a (RoundBoard/CornerBar/BodyPanels); #283242 (Office); #cdbba3 (RosterCards); #d8d4cb (Tips); #e2ded4 (Tips/WhiteboardKit rule); #3b3430 (WhiteboardKit frame); #cfd6dd (MatchupCards/WeekCards); #8a6a3d (FirstWeekStrip brass); #5a6172 (IsoGym) |

## The five attribute bands (weak / fair / solid / strong / elite)

| Source | weak | fair | solid | strong | elite |
|---|---|---|---|---|---|
| AttrBoard (UI.*) | #e2483d | #d97a00 | #27589e | #23935d | #8a5cf0 |
| DarkOverview | #e2483d | #f08a24 | #3f7fe0 | #2fb56e | #a36cff |
| Move tiers (ComboStrip/MoveBook/MoveTip) | #5d5243 | #d97a00 | #23935d | #27589e | #8a5cf0 |

Move tiers map unlearned / raw / usable / sharp / signature onto the same five slots, so green and blue swap places between attributes and moves.
Body damage bands are a third scale: BodyTip and BodyFigure use fine #6cc27a, hurt #f0a020, critical #e0503c, doctor #a050e0; SharedHolo uses hurt #ff9a3c, critical and doctor #ff4d2e.

## Worst files (drift most from UI.gd)

| File | Why |
|---|---|
| `scripts/ui/areas/Office.gd` | 27 own hex, 0 UI colour constants (it still calls UI helpers); its own blue-black palette |
| `scripts/ui/TV.gd` | a whole second palette; 34 files import it, menus included |
| `scripts/ui/DarkOverview.gd` | own panel/ink/band/tone tables; bands differ from AttrBoard on the same data |
| `scripts/ui/CornerSwapCards.gd` | 15 hex, a 3rd red #e06060, own card brown |
| `scripts/fight3d/HudRegroup.gd` | 13 hex, 0 UI colour constants, 2 greens 2 reds of its own |
| `scripts/ui/Tips.gd` | 11 own hex, navy ink on every hover card, 0 UI colour constants |
| `scripts/ui/RosterCards.gd` | 12 hex: near-UI paper + 6 tile colours |
| `scripts/ui/modals/HeadlineCard.gd` | 12 hex incl. a purple ribbon |
| `scripts/ui/MatMap.gd` | 10 hex charcoal + yellow (with MatTree, MatGlyph) |
| `scripts/ui/WeekCards.gd` | 10 hex: 3 golds, own blue, tile table |
| `scripts/ui/CallButtons.gd` | 9 hex: 4 golds + TV greens/reds |
| `scripts/ui/FightPoster.gd` | 8 hex, 0 UI colour constants |
| `scripts/ui/IsoGym.gd` | 13 hex - a map, lower priority |

## Files with the most raw colour literals

Office.gd 33, RingSet.gd 25 (3D), HudRegroup.gd 21, DarkOverview.gd 18, CornerSwapCards.gd 15, MatMap.gd 15, HudBars.gd 15, TV.gd 14, IsoGym.gd 14, RosterCards.gd 13, HeadlineCard.gd 12, WeekCards.gd 12, Tips.gd 11, FightPoster.gd 11.

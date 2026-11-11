# HALOSWEEP1 - chosen frames use the shared halo

The quiet frame stays. The chosen state no longer paints a flat gold (or marker-blue) border. It adds `Halo.ring` in the colour that border used, at that box's corner radius. A clickable row with no hover of its own gets `Halo.hover` while it is not chosen.

Stills are real windowed renders on the hidden desktop, under `docs/mockups/s427/halosweep/`. Each line is what the still script printed. `visible=true` means a child named Halo was on screen.

| File | Was the chosen frame | Now | Still | Printed rect |
|---|---|---|---|---|
| scripts/grapple/BeltMatch.gd | Her plan, the first call card, had a `UI.GOLD` border (thicker than the others). | Same `UI.LINE` border as the other calls. `Halo.ring` on the first card, `Halo.hover` on the rest. | belt_match.png | `HALO_RECT belt_match control=Call_0 rect=(80.0, 120.0, 680.0, 110.0) halo=Halo visible=true halo_rect=(54.0, 94.0, 732.0, 162.0)` |
| scripts/ui/areas/GrapplerPage.gd | The belt she is on had a `UI.GOLD` border. | Same `UI.LINE` border as the other belts. `Halo.ring` on hers. The belt bars are not clickable. | grappler_belt.png | `HALO_RECT grappler_belt control=Belt_blue rect=(80.0, 120.0, 420.0, 36.0) halo=Halo visible=true halo_rect=(54.0, 94.0, 472.0, 88.0)` |
| scripts/ui/Bracket.gd | Her bout boxes used a `UI.GOLD` border. The champion box always used one. Drawn with `draw_style_box`, so the halo is a child placed over each box and rebuilt when the rects change. | Both keep the `UI.LINE` border. One `Halo.ring` per her bout and one on the champion box. No second copy of the shader. | bracket.png | `HALO_RECT bracket control=Bracket rect=(80.0, 120.0, 960.0, 220.0) halo=Halo visible=true halo_rect=(54.0, 147.0, 308.0, 106.0)` |
| scripts/ui/CoachSteps.gd | The step the film is on had a `UI.GOLD` border. | Same `UI.LINE` border. `Halo.ring` on the lit step. A filmed step that is not lit gets `Halo.hover` (the row is the button and had no hover). | coach_steps.png | `HALO_RECT coach_steps control=Step_1 rect=(80.0, 120.0, 560.0, 32.0) halo=Halo visible=true halo_rect=(54.0, 94.0, 612.0, 84.0)` |
| scripts/ui/CreateScreen.gd | A picked coach or building card grew a second panel with a `WoodKit.HEAD` rim. A picked start card switched its own edge to `WoodKit.HEAD`. | The rim is gone. Picked cards keep the unchosen edge (slate, or the soft chalk edge on a start card) and get `Halo.ring`. The others get `Halo.hover`. The click overlay forwards the mouse so the hover can light. | create_card.png | `HALO_RECT create_card control=Coach_expro rect=(80.0, 120.0, 392.0, 220.0) halo=Halo visible=true halo_rect=(54.0, 94.0, 444.0, 272.0)` |
| scripts/ui/GamePlan.gd | The open line had a `UI.GOLD` border. | Same `UI.LINE` border as a closed line. `Halo.ring` while it is open. The line is opened by its button, which already has a hover. | game_plan.png | `HALO_RECT game_plan control=Line_long_ rect=(80.0, 120.0, 720.0, 719.0) halo=Halo visible=true halo_rect=(54.0, 94.0, 772.0, 771.0)` |
| scripts/ui/MatSystems.gd | The route already in the plan had a `UI.GOLD` border. | Same `UI.LINE` border. `Halo.ring` on that route. The Use button is the click. | mat_systems.png | `HALO_RECT mat_systems control=Sys_kimura_to_back rect=(80.0, 120.0, 360.0, 115.0) halo=Halo visible=true halo_rect=(54.0, 94.0, 412.0, 167.0)` |
| scripts/ui/MatTree.gd | The chosen goal tile had a `UI.GOLD` border. The next-opponent chip always had one. | Goal tiles keep `UI.LINE`. The chosen goal gets `Halo.ring`, the others `Halo.hover`. The opponent chip keeps `UI.LINE` and gets `Halo.ring`. | mat_tree.png | `HALO_RECT mat_tree control=Goal_back rect=(80.0, 120.0, 132.0, 64.0) halo=Halo visible=true halo_rect=(54.0, 94.0, 184.0, 116.0)` |
| scripts/ui/TapeRoom.gd | The tell's node had a `UI.GOLD` border. Each arrow's label pill had one too. | Both keep `UI.LINE`. `Halo.ring` on the tell and on each pill. They are not clickable. | tape_room.png | `HALO_RECT tape_room control=TellNode rect=(80.0, 120.0, 560.0, 81.0) halo=Halo visible=true halo_rect=(54.0, 94.0, 612.0, 133.0)` |
| scripts/ui/FlowView.gd | The START card had a `UI.GOLD` border and a tween on `border_color`. | Same `UI.LINE` border as the other cards, shadow kept. `Halo.ring` on START. The border tween is gone. The card already lifts under the mouse. | flow_view.png | `HALO_RECT flow_view control=Card_long rect=(80.0, 120.0, 480.0, 160.0) halo=Halo visible=true halo_rect=(54.0, 94.0, 532.0, 212.0)` |
| scripts/ui/DrillCard.gd | The card you hold took a `WoodKit.HEAD` edge. The drag preview was the same flat edge. | Idle edge stays the soft chalk line. Hover of a card you are not holding stays blue. The held card and the drag preview get `Halo.ring` in `WoodKit.HEAD`. | drill_card.png | `HALO_RECT drill_card control=Drill_move_Jab rect=(80.0, 120.0, 420.0, 190.0) halo=Halo visible=true halo_rect=(54.0, 94.0, 472.0, 242.0)` |
| scripts/ui/WeekBoard.gd | No `UI.box` chosen border. Line 405 is the weight label's vertical flag, not a frame. | Left as it is. The lit Hold, Cut and twist answer use the theme variation PillOn. That is a theme style, not a frame this screen paints. | none | none |

## Chosen frames found beyond the listed lines

Converted with the same rule:

- CreateScreen start cards: `Color(WoodKit.HEAD) if on` on the card's own edge (the listed line was only the coach/building rim).
- DrillCard's held card: `WoodKit.HEAD if picked` (the listed line was the drag preview).
- MatTree plan node that is the selected position: `Color("#ffd54a") if on`. `Halo.ring` when selected, `Halo.hover` on the others. The node is the click and had no hover.
- MatTree plan step that is not a base move: `Color("#ffd54a") if not base`. `Halo.ring` on those steps. The edge button already has its own hover.

Left alone, on purpose:

- CreateScreen stepper fill and the current step's label colour. LineEdit focus, caret and selection (a theme-style focus, not a chosen card).
- GrapplerPage "drilling" and "signature" words. Those are ink colours.
- Bracket connector when her bout is won, her name in the box, and the champion's name. Those are ink and a line, not a frame.
- GamePlan answer buttons (`ChoiceOn`), the "made for this game" icon and name. Ink and a theme button.
- FlowView step-number disc (gold fill, border width 0) and the arrow pills (each arrow's own colour).
- TapeRoom "Suggested" line under an answer. Ink.
- MatTree step-number chip (gold fill, charcoal border) and the red dashed corner on a costly miss (a status mark).
- WeekBoard PillOn, as in the table.

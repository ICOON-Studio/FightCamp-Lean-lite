# Building the approved menus in the game (S403, operator "Build them")

The spec for a screen is its picture and HTML in `docs/mockups/s403/`. Layout, words, order and look come from there. Numbers come from the running game, never from the mockup: the mockup's eight MMA fighters, prices and dates are examples.

1. **Art:** `scripts/ui/WarmKit.gd` for wall, whiteboard, paper, sticky, chalkboard, magnet. Fonts as the mockup: Barlow, Permanent Marker, Kalam (`assets/fonts/`). No new art.
2. **Icons:** `scripts/ui/KitIcon.gd`: `KitIcon.icon("camp", 24, colour, tooltip)`. Same meaning, same icon, every screen. Never draw your own. A fighter's state is one of booked, camp, injured, offer, contract, free, leaving, retiring.
3. **Words:** the mockup's labels. Icon plus tooltip where the mockup has them. No his/her (no_pronoun_test). Plain words (plain_words_test).
4. **Attributes and skills:** the 10 attributes and 12 skills are not in the game yet (TASK_FIGHTERMODEL4A). Show what the game has today, under today's names, and do not invent values.
5. **Two states, as in the game's rules for everything MMA:**
   - Built but not usable now: grey, with the reason on it, no red pin.
   - Not built: full colour, drawn as it will work, with the `warn` icon on its header, input off, tooltip "Not built yet". One mark per panel, not per row. Use an honest empty or example state: never a made-up number that looks real.
6. **Nothing is lost.** Every action the screen has today must still be reachable after the move. If the mockup has no place for one, put it in the page's second tab and say so in the PR body.
7. **Only what the player can act on** (operator S398). No text addressed to a designer.
8. **Fits 1920x1080** with no page scroll. A long table scrolls inside its own panel. Also check 1280x720 does not overlap.
9. Files under 500 lines. Split a panel into its own script rather than growing the page. Numbers and rules go in pure `scripts/rules/` modules with tests, never in a screen.
10. **Never change a game number or rule.** This is a screen task.
11. `Godot` only through `python ops/Tools/godot_slot.py run --who <seat> -- <cmd>`, headless, `--audio-driver Dummy`. Parse check before a test. Read `ops/research/GDSCRIPT_TRAPS.md` first. Nothing opens on the owner's monitors.
12. You cannot see images. Claude opens the stills after you land, so name every panel node (`name = "CoachesPanel"`), and state in the PR body which rows are not built and which actions moved.
13. Button styles: `BtnSolid` is the filled blue button (Buy, the chosen option), `BtnPrimary` is white, `Btn` is outlined. On a blackboard an outlined button needs a cream font. Never read the theme before the node is in the tree (GDSCRIPT_TRAPS). Whiteboard content needs an inset of about 30 px to clear the frame; text on paper about 18 px to clear the torn edge.

## The game look (S410, operator Q-S294-134: "Build it like the right, painted surfaces")
Reference: docs/mockups/s409/concepts/roster_painted.png and versus_painted.png; worked examples on main: scripts/ui/RosterCards.gd, scripts/ui/VersusPanel.gd. The s403 mockups stay the spec for what a page contains; this section is how it looks. A page gets a painted concept and the operator's yes BEFORE it is briefed (feedback_ludo_painted_concepts_s400).
14. **The surface behind the page:** a clean Ludo painting, full bleed, through `MenuFx.set_wall(main, path)`. Shell clears it before each page. Never inside the page's margins.
15. **The people are the picture:** `RosterCards.body(stem, size)`, the real full-body renders in assets/ui/art/fullbody. `VersusPanel.kit_stem` picks a corner's kit.
16. **Data as labelled tiles,** icon plus a word, the sentence on hover. The page's small text is 16 px or more; 14 only inside a tile.
17. **Titles** in the brush font on the painting. On paint, the off tab takes a light ink (`RosterCards._tab`).
18. **Score the look first,** with hard fails, then the options (feedback_critics_blind_to_presentation_s408).

# TASK STRESSHDR1 (S212) - the profile header gets the STRESS mini-bar (tooltip names the real causes) and the CAREER WEAR pill

Agent: Antigravity (agy, free tier) - operator S212: "use antigravity for the stress tooltip wiring".
Worktree E:/FightCamp/wt/STRESSHDR1, branch agy/stresshdr1, cut from origin/cursor/profile2e (the new profile screen).
FILE TOOLS ONLY: use only your file read and file write/edit tools. Run NO shell commands, no grep, no git, no Godot. Claude runs the
parse gate, the tests, the stills and the commit when you finish.

## Approved design (operator board Q-S207-2 "Approve all" on `research/LUDO_ROUND43_VERDICT_S208.md` section 5)
"STRESS" mini-bar and a "CAREER WEAR" pill in the header strip, colours by band (green / yellow / orange / red), badge
"{stress} STRAINED". The tooltip names the real causes from his stress log ("STRAINED 62 - two hard weeks and a weight cut"); effects
come only from our stress rules. The tooltip text is ALREADY WRITTEN: `StressCauses.tooltip(state)` - do not write another.

## Prior research
- `Godot/scripts/rules/StressCauses.gd` - `static func tooltip(state: Dictionary) -> String` (line ~165). `state` = the athlete's stress
  dictionary: `athlete.get("stress", {})` (see `ProfileMedical.gd` `_stress_state` ~line 50 for how the screen already reads it, incl.
  a non-dictionary fallback). Test: `tests/stress_causes_test.gd`.
- `Godot/scripts/rules/StressRules.gd` - `band(stress: float) -> String` (~line 81). `ProfileTabsLayout._stress_band_color(band)` gives
  the band colour already used on the Medical tab; reuse it.
- Career wear: `athlete.get("career_wear", 0.0)` (float, written by GameState after fights via CareerWear.gd). Band it with the same 4
  colours: < 25 green, < 50 yellow, < 75 orange, else red (state these thresholds as named consts at the top of the file).
- The header strip = `Godot/scripts/ui/ProfileOverview.gd` `_build_banner(athlete)` (~line 258, 733 lines total - read only lines
  1-60 and 230-340). It already places, left to right: Name (x 12), Nickname (x 300), Identity line (x 470, w 940), MORALE (x 1430,
  w 190), COMPOSURE (x 1630, w 250). Labels are built with `_label_to(parent, text, pos, size, font_px, color, font, node_name)`.

## What would a human do?
A UI programmer fits two small readouts into the existing strip without moving the name: shorten the Identity line's width, put
STRESS (label + a 60 px bar + badge) and CAREER WEAR (a pill) between Identity and MORALE, tooltip on hover via `tooltip_text`.

## Prefab check
None - our UI. No new fonts, no new textures.

## Do
1. In `_build_banner`: add a node "StressBar" (Control containing: Label "STRESS", a 60x8 bar filled to stress/100 in the band colour,
   Label badge "<stress int> <BAND>" e.g. "62 STRAINED") and set `tooltip_text = StressCauses.tooltip(state)` on the StressBar control
   with `mouse_filter = MOUSE_FILTER_STOP` so the tooltip shows. Only when the athlete has stress data; nothing drawn otherwise.
2. Add a node "WearPill" (a Panel with rounded StyleBoxFlat in the wear band colour + Label "CAREER WEAR <int>%") with a tooltip
   "Career wear <int>/100 - knockdowns, hard fights and age add to it; it never fully heals". Only when `career_wear` exists.
3. Shrink the Identity label width so nothing overlaps (all five existing labels keep their names and order). Banner width stays.
4. preload StressCauses/StressRules at the top like the file's other preloads (check how `QuickLook`, `FighterReadout` are loaded).
5. Extend `Godot/tests/profile_overview_test.gd` (read it first; follow its style): (a) athlete with stress {stress: 62, log with two
   hard days + a weight cut} -> node "StressBar" exists, its tooltip_text == StressCauses.tooltip(that state), badge text contains
   "62"; (b) athlete without stress -> no "StressBar"; (c) career_wear 40 -> "WearPill" text contains "40"; (d) no node rects overlap
   inside the banner (compare each child's Rect2).
6. Write `research/STRESSHDR1_DIGEST.md`: what you changed (file, function, line numbers), the test cases, and anything you were
   unsure of.

## Owned files
- `Godot/scripts/ui/ProfileOverview.gd` (only `_build_banner` + preloads/consts at the top)
- `Godot/tests/profile_overview_test.gd`
- `research/STRESSHDR1_DIGEST.md` (NEW)
Never touch ProfileStage.gd (another agent owns it now).

## GDScript traps
`var x := <call>` fails when the call returns Variant - type it (`var n: int = ...`). A variable name reused in one function is a
parse error, even across blocks. `%` in a format string is `%%`.

## After you finish (Claude)
Parse gate + `profile_overview_test` + `--only profile,stress`; game-camera stills of the header (hover tooltip shown); Ludo reviews
the stills, then the operator (S212 rule: "visual approvements and UI must pass from ludo first then ask me").


## S212 ADDENDUM (operator: "use animated meters")
The STRESS bar fill and the WEAR pill value animate: on build, tween the bar width from 0 to its value (0.5 s, ease out); if the band
changed since the last build, a 0.3 s colour pulse. Use a Tween created on the bar node (create_tween()); no assets.

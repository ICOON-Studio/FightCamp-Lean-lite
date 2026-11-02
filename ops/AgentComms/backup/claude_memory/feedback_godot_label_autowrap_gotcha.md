---
name: feedback-godot-label-autowrap-gotcha
description: "In the FightCamp Godot project, Label.autowrap_mode does not reliably reflow text for a manually-positioned Label added to a plain Control (not a Container) via add_child() - neither clip_text nor custom_minimum_size fix it; explicit \n line breaks are the only proven-reliable approach"
metadata:
  type: feedback
  originSessionId: a097cbf7-f586-4498-8789-03364a500757
  modified: 2026-08-30T21:46:30.758Z
---

In the FightCamp project (`C:\Users\user\OneDrive\Documents\ChatGPT\Game`),
a `Label` with `autowrap_mode = TextServer.AUTOWRAP_WORD_SMART` that is
manually positioned (`.position`/`.size` set directly) and added via
`add_child()` to a plain `Control`/`Panel` (not a `Container` like
`VBoxContainer`) does **not** reliably wrap long text onto multiple lines
in this codebase's actual runtime behavior - it stays on one line and gets
cut off mid-word at the label's right edge instead.

**Why this matters:** an existing code comment in `OfficeHub.gd`
(`_build_phone_popup`) claimed `clip_text = true` was "load-bearing" for
keeping wrapped text inside a frame, and a separate comment near
`_build_fight_test()`'s `test_legend` claimed `custom_minimum_size` was
"what actually fixed" wrapping. Both claims turned out to be false when
re-tested during the Stage 3 consistency audit (2026-08-31): a longer
Menu-Modernization description string exposed the bug (`_build_phone_popup`'s
description and "Relationships" labels both clipped mid-word), and neither
removing `clip_text` nor adding `custom_minimum_size` (nor both together)
made the text actually wrap across four separate rebuild-and-recapture
cycles. Only explicit `\n` characters inserted into the string at chosen
break points reliably produced multiple lines - the same approach
`RosterScreen.gd`'s own `staff_note` label already used successfully
(`"COACH RATING BOOSTS EVERY ACTIVE SESSION.\nCAPACITY LIMITS HOW MANY
ATHLETES CAN TRAIN AT ONCE."`).

**How to apply:**
- Do not trust `autowrap_mode` alone (with or without `clip_text`/
  `custom_minimum_size`) to wrap a manually-positioned Label's long text in
  this project. Verify with a real capture/screenshot before assuming it
  works, not just by reading the code.
- When a Label needs to show more text than fits on one line, write the
  string with explicit `\n` breaks at points that fit the label's actual
  pixel width, rather than relying on the engine to reflow it. As a rough
  budget: RosterScreen.gd's staff_note fits ~50 characters per line at 11pt
  in a 440px-wide label; scale proportionally for other font sizes/widths.
- `_add_today_row()`'s `detail_label` in `OfficeHub.gd` still uses
  `autowrap_mode` + `custom_minimum_size` without `clip_text` - it hasn't
  visibly broken yet only because the detail strings used there happen to
  be short enough not to need wrapping. Treat it as carrying the same
  latent risk, not as a counterexample.
- This may affect other screens neither Codex nor Claude has audited yet
  (`AthleteProfileScreen.gd`, `TrainingScreen.gd`, `GymFloor.gd`,
  `RecruitmentScreen.gd`, `CityScreen.gd`, `CountryMap.gd`, `MainMenu.gd`
  all set `autowrap_mode` somewhere per a project-wide grep) - worth a
  dedicated sweep if anyone reports clipped/truncated copy on those screens.
- If a Container-based layout (inside a `VBoxContainer`/`HBoxContainer`)
  ever needs wrapped text instead, that's a materially different code path
  (the container manages the child's actual size) and this specific gotcha
  may not apply the same way - re-verify empirically rather than assuming.

See also [[feedback-godot-verification-gate]] (the sibling lesson about
this project's headless test/capture tooling).

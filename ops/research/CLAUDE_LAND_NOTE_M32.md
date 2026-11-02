# CLAUDE LAND NOTE: M32 (menu look / style guide), from Maria

**What finished (art only):** a researched menu art-direction guide (process used by Blizzard / EA / Sega-SI / CA, Q1–Q5, the FightCamp M32 style guide, a never list, a self-attack) and two before/after mocks: gym creation and THE DAY. No code, no .tscn, no HANDOFF edits, no pushes.

**Stage these files:**
- `_maria_delivery/M32/`: all files below.
- `research/M32/`: `M32_MENU_ART_DIRECTION.md`, `M32_mock_gym_creation_before_after.png`, `M32_mock_the_day_before_after.png`, `M32_mock_*_after_annotated.png`, `render_m32.py`.

**What Claude should do:**
1. Save the files under `research/M32/`.
2. Build **S78 (menu clarity stage)** from section 7 of the md: type roles (Inter + `tnum`, 15/18/22/30/44), the MUTED delta `#a3afc4`, BAD_TEXT `#f2766f`, INK text on GO, surfaces (sunk / resting / lifted / hero, no header bars), radius 8, motion 100/150/160/200/240 ms, the density checklist (7.9), the number-with-context rule (7.10) and the empty-slot rule (7.11).
3. Verify one computed defect on a live build: the day strip (drawn 380 px wide) is placed as if it were 320 px wide, so the Continue unit covers about 46 px of SAT/SUN (ShellChrome `_build_top`).
4. Confirm that Godot 4.7.2 FontVariation supports the OpenType feature `tnum` for Inter.
5. Note the cost honestly: swapping `UIKit.caps()` / `display()` needs a width audit (chip widths are hard-coded per character).

**Out of scope:** code design decisions beyond the tokens, final copy (all strings are EXAMPLE; Kalli owns the words and the casing of screen names), and HANDOFF.md, which stays with Maria/parent.

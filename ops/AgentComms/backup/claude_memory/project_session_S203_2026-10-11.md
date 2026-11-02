---
name: project-session-s203
description: S203 2026-10-11 - PROFILE2A quick-look card built on the game camera; PROFILE2B briefed; 4 seats busy; board answers were comment requests
metadata:
  type: project
---
S203 (2026-10-11): operator approved Ludo r37 profile ("approve all - build A then B then C"); Q-S200-1/2 answers were
COMMENT requests ("open it on tool for my comments") -> stills posted to 8787/review, not picks. Built PROFILE2A (410 px
quick-look card, QuickLook.gd + ui/QuickLookCard.gd, 496033ce) and shot it with tools/quick_look_stills.gd (as_game).
Merged PROFILEFORM1 (Qwen). Briefed PROFILE2B (Cursor after NIGHTLY3), SCOUTFID1 (Arena), PROFILELAYOUT1 (Qwen), NIGHTLY3 (Cursor).

**Why:** the profile is the main player screen; the verdict's "no invented numbers" is the acceptance bar for 2B/2C.
**How to apply:** a board answer marked comment_only is a request to post the still on 8787/review, not a decision -
keep the dependent task held. A new class_name is not in the global cache for check_scripts: load the script by path
(`load(SELF_PATH).new()`), never `ClassName.new()` inside its own file. DevJump `booked: true` fails on seed 707 week 8
(same-sex division rule) - pick another seed for a booked-fight still. Related: [[feedback-ludo-is-lead-designer]]
[[feedback-no-placeholder-screens-ask-ludo]] [[project-session-s202]]

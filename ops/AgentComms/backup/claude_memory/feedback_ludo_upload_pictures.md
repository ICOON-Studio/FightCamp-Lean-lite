---
name: feedback_ludo_upload_pictures
description: "Operator S220 - a picture for Ludo is UPLOADED through Ask Ludo's upload screen, never described in text/code"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0f1fcebb-33a4-4ec0-9970-09f799f6ef89
  modified: 2026-10-13T19:36:43.898Z
---

Operator S220 (verbatim): "when i ask youto show a picture to ludo i excpect you to upload the image not write the description of
the image in  code". Every Ludo round about something visual (a screen, a still, a card, the gym) carries the real picture through
the upload modal (method in [[reference_ludo_ai]]: picture icon -> unhide input[type=file] -> read_page ref -> file_upload). One
image per upload; for two, send two messages.

**Why:** S220 rounds 56 and 57 went text-only ("the upload is blocked") and Ludo designed against Claude's description; once the
picture was uploaded (57b) Ludo judged the real screen. A description is Claude's reading of the picture, not the picture.

**How to apply:** never write "no picture this round" again - upload first, then the question. If the upload truly fails, stop and
tell the operator instead of sending a text-only visual round.

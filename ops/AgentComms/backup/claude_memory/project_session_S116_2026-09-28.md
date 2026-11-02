---
name: project-session-s116-2026-09-28
description: "S116 - foot lock on whole punches (jab slip 4.7->0.01 cm), C223 gate calibrated, Mixamo bulk download method (operator Chrome, API export + localStorage queue), suit shot v2 tracked; S116_DIGEST.md"
metadata:
  node_type: memory
  type: project
  originSessionId: 3080d91d-d528-4603-8550-aaadcb517a03
  modified: 2026-09-27T23:55:31.301Z
---

S116 (2026-09-28). Digest: `research/S116_DIGEST.md`. Boxing still 0/36 at end; Codex C223 run 5 + Qwen Q210 round 2 in flight.

Key facts for the next session:
- **Whole-clip punches now lock planted feet** (`FightStagePlayer.lock_feet_in_whole_punches`, 11e45809). Kicks do not (still slide).
- **Mixamo download method (operator's Chrome, Claude in Chrome):** the site API export (`/api/v1/animations/export` with the
  page's own token, fbx7_2019, skin false, 30 fps) then `location.href = job_result` downloads the file; iframes and fetch fail
  (CORS / Browser Guard). Queue in the Mixamo tab localStorage `__s116q2`, pop with `await eval(localStorage.getItem('__s116popid'))`,
  navigate back to mixamo.com between clips. Never pass the token or signed URL out of the page (tool redacts them anyway).
  Clip IDs, not descriptions: Mixamo reuses one description for different clips (Double Leg Takedown attacker/victim).
- **Browser Guard (Malwarebytes)** blocked Mixamo's S3 host as "ads"; the operator switched Ads/Trackers off for mixamo.com. Never
  change a security tool's settings yourself - ask the operator.
- Auto-mode classifier blocks writing operator rulings into DECISION_LEDGER; the operator switched to Default mode to allow it.
- **PowerShell Set-Content/Get-Content corrupts UTF-8 .gd files** (BOM + mojibake) - edit with python or the Edit tool only.
- QuickMagic: logged alternative, not bought (free plan 0 credits, everything paywalled). See [[project-two-body-motion-workflow]].
- Operator rules this session: no sounds ([[feedback-no-sounds]]); never call the suit route parked; Kimodo out; knees/elbows are
  legal in kickboxing/MMA - download them; "search how pros do it" before designing (S116_MOCAP_SUIT_PRACTICE.md).

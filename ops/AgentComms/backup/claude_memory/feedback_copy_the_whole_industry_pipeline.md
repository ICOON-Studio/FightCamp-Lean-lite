---
name: feedback_copy_the_whole_industry_pipeline
description: "Before building any production pipeline, write out the FULL professional workflow and mark every step we skip; the suit route's VIDEO-TO-3D SOLVE failed, but its Blender-MCP AUTHORING worked (C199_Hold) and was never bound in the game"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 8dabac61-fbe3-49ee-adbf-d873c7291826
  modified: 2026-09-27T19:48:55.552Z
---

Operator, 2026-09-25 (S73): "why you do not copy the whole technique that the real animators do and duplicate that
with higgsfield ... why you never question what real actors/animators use?" Also: "you will need to have a model for
the arm - try to find if there is anything specific prefab for that".

**CORRECTED S114 (operator: "we have already done these steps and produced clips that fixed the grip"):** the Blender-MCP
AUTHORING half of C199 WORKED - C199_Hold built in the live Blender, contacts fixed, exported as game clips - only its game
integration was never done (TASK_C222 step 1). What failed was the video-to-3D SOLVE, and SMPL-X is licence-banned
(legal alternative: SAM 3D Body / MHR, G95). SMPL-X below is NOT usable for shipped animation.

The colour-suit route (C180/C199) copied ONE piece of optical mocap (a suit) and skipped calibration, calibrated
multi-view, point markers on joints and a body-model solve (C199 pass 1 used hand-built capsules, "not SMPL"). G76
had already documented the full studio chain and the two-person SMPL fitters (CloseInt, BUDDI, Reaction Priors,
MultiPhys) - it was researched and then not applied.

**Why:** a partial copy of a proven pipeline fails at the skipped step, and the credits go before anyone sees it.

**How to apply:** before any pipeline task file, put a table in it: studio step | our equivalent | cheapest test |
status. Name the standard prefab/model for each step (SMPL-X/MANO for bodies and hands). Test the weakest link free
first. Show the operator the whole chain before paid generation. Related: [[feedback_show_the_full_chain_before_spend]],
[[feedback_search_for_the_thing_not_the_category]].

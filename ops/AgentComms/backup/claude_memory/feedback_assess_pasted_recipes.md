---
name: feedback_assess_pasted_recipes
description: "When the operator pastes an AI-written recipe and asks for thoughts: save it verbatim, grade it against measured project facts (right / fails with numbers / how I'd run it), don't execute it literally; 'do not interrupt me until I prompt you' means record only"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5a7d1b2f-c085-4027-8915-a7f0e2ac0dd7
  modified: 2026-09-14T21:01:09.349Z
---

On 2026-09-14 night the operator said "This what we will do, do not interrupt me until I prompt you", pasted two long
AI-generated recipes (Gemini-style, ending "Use code with caution.": a Higgsfield single-actor catalog with "invisible target"
prompts and a Godot supervisor script), then asked "Now tell me your thoughts about this process". The answer that landed:
what is right (brain + clip layer is already FightCamp's architecture; loops + transients; one action per generation; impact
frame drives reactions/UI), what fails with the project's own numbers (snap + same-millisecond contact held 0/36; frame numbers
mean nothing to a 20 fps text model and long clips freeze; quality wording is not carried; `set_root_motion_tracking` is not
Godot 4), and how I would run it. The operator accepted it ("You are free to adjust the templates if you want to for better
result, and we continue with your adjustments") and then took the recommended option on the follow-up strategy question.

**Why:** the operator's pasted recipes are directions in shape but carry untested or wrong claims; building them literally
repeats measured failures, and arguing without numbers is not what lands - the numbers are.
**How to apply:** while told not to interrupt, only save the pasted text verbatim in research (no generations, no
builds); when prompted, answer in three parts (right / fails, with the measured number / how I'd run it), then put the one
decision that shapes the next session to AskUserQuestion. Related: [[feedback_enhance_proposals_aaa_presentation]],
[[feedback_quote_rulings_verbatim]], [[project_engine_first_2026-09-14]].


**VERIFY EVERY SPECIFIC ID BEFORE BUILDING ON IT (2026-09-21).** Across two
pasted animation recipes, **five of six CMU citations were wrong**: `87_04` and
`87_05` are "backflip" and "cartwheels" (subject 87 is acrobatics, single
person), subject 17 is "different walking styles" not Wushu, and
`19_03 / 19_04` is ONE PERSON AT TWO TRIALS rather than a pair — 18 is subject
A and 19 is subject B of the same capture. **Following that last one would put
the same body on both sides**, which is exactly the single-body collapse the
recipe existed to prevent.

**The MECHANISM in those recipes was right every time; the SPECIFICS were not.**
So: take the mechanism, check every file id, url, dataset name and licence claim
yourself, and record which you verified and which you did not. One fetch per
claim is cheap; a session spent on a hallucinated file id is not.
See [[reference_cmu_paired_mocap]].

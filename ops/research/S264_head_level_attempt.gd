extends RefCounted
## RETIRED, NOT A TEST: S264's first attempt at ZIVAMOTION1 #4's "chin tucked and level through the torso pitch". It is
## kept as a record of WHY the obvious fix does not work - do not re-try it blind.
##
## The census (tools/fight_motion_probe.gd FIGHT_HEAD_SUMMARY) measures the SPINE SEGMENTS: hips->neck (torso_lean) and
## neck->HEAD BONE ORIGIN (head_lean). On seed 95501 the head's segment amplified the torso's pitch - head_follow_k 2.53
## (1 deg of torso pitch tipped the segment 2.5 deg), torso up to 61.8 deg, the segment up to 104.6 deg from vertical.
##
## The attempt rotated the HEAD bone about the chest's lateral axis to hold the segment at HEAD_LEVEL_FOLLOW_K of the
## torso's pitch. It could not work, and the reason is geometry, not a bug: A BONE'S OWN ROTATION DOES NOT MOVE ITS OWN
## ORIGIN, so rotating the head bone cannot change the neck->head-origin segment the census (and the visible line from his
## chin to his neck) is made of. Two A/B runs confirmed it: head_follow_k 2.53 (off) -> 2.52 -> 2.53 (on) with head_max
## unchanged at 104.6 deg.
##
## What the segment's direction CAN be changed by is the NECK bone (its parent) - and S262 already found that touching the
## neck opens the MetaHuman head/body seam (see the S262 commit "neck untouched (MetaHuman head/body seam)"). So this
## clause is either neck work with a seam guard, or clip authoring. Operator's call; the pass was reverted.
##
## The original test's own words, kept for the record:

---
name: feedback_author_layouts_not_pack
description: Gym floor junk came from a capacity packer meeting quota tests; author layouts from real-gym rules and test the rules; never feed Ludo a junk still as a reference
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2e79d2d5-4ac1-4d72-b5dd-e71fde852ec6
  modified: 2026-10-11T12:29:59.105Z
---

The operator kept spotting junk on the gym floor (S200: "wtf is the heavy bag doing in there", "what is this for next to the
heavy bags", "wtf are these blue things"): 6 first-aid cabinets in a row, 7 speed bags, a heavy bag in the weights, step boxes
as a "water bench". Root cause: floor_zones are filled by a packer to pass quotas (>= 45% fill, >= 6 bags, east = west); when
the right item does not fit it puts whatever fits. Also: "if you give such trash reference it will generate trash" - Ludo
copied the filler from our in-game still.

**Why:** a quota test rewards filling space, not a believable gym; the packer satisfies it with nonsense.

**How to apply:** lay the floor out by hand from G121_REAL_GYM_FLOOR_PLANS.md rules (bags hung on walls >= 1.5 m apart, ring
back with 1.5 m clear, one strength corner, quiet recovery, clear walk); gate RULES (bag on a wall, nothing behind a bag,
item in a zone of its kind) instead of fill %. Ask Ludo from data and rules, not from a picture of a floor that has filler on
it. Check an item's catalogue meaning before trusting its look (cardio_floor = jump ropes, drawn as a bike). Related:
[[feedback_gym_floor_is_a_training_floor]], [[feedback_gates_must_derive_not_copy]].

---
name: feedback_a_new_key_breaks_a_hash_even_at_zero
description: "a dict key added unconditionally breaks a byte-identity/hash test even when its value is always the neutral default - the KEY's presence changes the serialized string, not just its value"
metadata:
  node_type: memory
  type: feedback
  originSessionId: b8add24e-181e-45ff-b1e9-727b687ee8cf
  modified: 2026-10-02T08:43:51.348Z
---

S141: merging Q226 + Q233 broke `fight_strike_whole_test.gd`'s pinned OFF-arm SHA-256 hashes (a
strict byte-identity gate). Every switch-gated function elsewhere in the same merge correctly
returned `{}` when off (`_speed_bias_for`, `_identity_bias` - "OFF = {} = byte-identical" is the
house convention). One spot didn't: `_run_impact`'s event dict added `"pushback_m":
float(technique_eff.get("pushback_m", 0.0))` as a literal key, unconditionally, in every action
event. `technique_eff` was `{}` when the switch was off, so the VALUE was always a harmless `0.0` -
but the KEY still appeared in the event's JSON, changing the serialized string (and therefore the
hash) even though nothing semantic changed.

**Why:** a byte-identity/hash-pinned test checks the SHAPE of the output, not just its meaning. Adding
a key with a neutral value is invisible to a human reading the diff ("it's just 0.0, who cares") and
invisible to a semantic test ("the number is right"), but it is NOT invisible to `JSON.stringify(...)
.sha256_text()` or any other exact-match/hash comparison.

**How to apply:** when a new switch-gated feature adds a field to a shared dict (an event, a log
entry, a result), don't add the key with a default value inside the literal - add the KEY itself only
when the switch is actually on, the same way the project's other OFF-arms return `{}` rather than a
dict full of defaults. Grep for `"OFF = {} = byte-identical"` comments nearby to find the pattern to
match. And when scoping an "affected tests" list for an engine-core change (anything touching
`FightRealtime.gd`'s event shape), include any test with "byte-identical" or "HASH" in its name/
comments explicitly - a narrow affected-system list by subsystem name will not surface this kind of
break; it only showed up here because a broad ~25-test suite was run out of caution, not because
anything pointed at the specific test. See [[feedback_open_the_output_before_the_gate]] and
[[feedback_assert_the_quantity_the_user_sees]] for the same family of "the gate that should have
caught it didn't, because it wasn't looking at the right thing."

# U138 — THE LAST TWO COPIES OF THE SWEEP

**Owner:** cursor (`composer-2.5`, MEDIUM). Worktree `FightCamp-U114`.
**Cut a FRESH branch off `origin/master` named `cursor/u138-sweep-cutover`.**
**Tier: parse gate, then `--only approach_sweep`, then the two tool re-runs.
NO FULL SUITE RUN** — that is Claude's, once, at integration.

## YOUR U137 LANDED AND IS MERGED

`ApproachSweep.gd` is on master, the blind contract test passes
(`SUITE total=1 fails=0`), and `s47_contact_offsets.gd` and
`s52_present_ratio.gd` call it. **Your "no numeric change" report was the right
answer and you checked it properly** — master already scored every blocker per
direction, and you proved the module was actually being called before reporting
no-change. That check is what made the null result mean anything.

**Two copies were deliberately left behind and this task is those two.**

## OWNED FILES

- `Godot/tools/s53_ball_capsules.gd`   (convert — was Claude's last session)
- `Godot/tools/s54_flat_cap.gd`        (convert — Claude wrote it this session)
- `research/U138_DIGEST.md`      (NEW)

You own nothing else. **Do NOT edit** `ApproachSweep.gd`, `FighterCapsules.gd`,
`CapsuleDistance.gd`, `ApproachBand.gd`, any test, or `HANDOFF.md`.

## THE JOB, AND S54 IS THE ONE WITH A TWIST IN IT

Both tools carry a private `_exposure` and a private `_sphere_direction` that
duplicate `ApproachSweep`. Replace them with calls and delete the dead helpers.

**`s53_ball_capsules.gd` is the straightforward one.** Its `_exposure` already
scores every blocker without an early exit, so it should convert cleanly and
its numbers should not move.

**`s54_flat_cap.gd` IS NOT, AND THIS IS THE WHOLE INTEREST OF THE TASK.** It
does not measure clearance with `point_to_segment` at all. It calls
`CapsuleDistance.surface(hand, other_cap, flat_names)` — which returns the
signed distance to the capsule wearing **whichever cap that arm gives it**,
hemispherical or flat — and computes `depth = hand_r - surface`.

`ApproachSweep.blocker()` as it stands hard-codes the hemispherical form. So a
naive conversion of `s54` would **silently measure the DOME in both arms**, the
flat-cap column would become a copy of the control, and the tool would print a
confident table showing the change does nothing.

**So do NOT convert `s54` by forcing it through the existing `blocker()`.**
Choose one and say in the digest which you chose and why:

- **(a)** Leave `s54`'s inner loop alone and convert only what genuinely
  matches — its `_sphere_direction`, and anything else that is a true
  duplicate. Report honestly that the blocker scan cannot be shared without
  changing `ApproachSweep`'s contract, which you do not own.
- **(b)** Convert it and, where the shared code would change the meaning, keep
  `s54`'s own call — a partial cutover, clearly commented at the call site
  saying why that one line did not move.

**(a) or (b) are both acceptable. Making `s54` report the dome twice is not.**
If you believe `ApproachSweep` should grow a distance-function parameter, say
so in the digest as a RECOMMENDATION — do not implement it, because its blind
contract test pins the current signature and you do not own that test.

## THE GATE — capture before, convert, compare

Run each tool on the unchanged tree FIRST and save the log; convert; run again;
diff.

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s53_ball_capsules.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s54_flat_cap.gd
```

**`s54` prints its own non-vacuity block and it MUST stay green.** In
particular the first check — that the control arm reproduces the tree's old
`FightPoseSolver.segment_distance` path to `0.000000000 m`. If your conversion
breaks that, the control has stopped being the control and every row in the
table is a new measurement wearing the old name. `s54` ends with
`SUITE total=1 fails=0`; if it reads `fails=` anything else, your conversion is
wrong, not the tool.

**EXPECTED: no number moves in either tool.** This is a refactor. If a number
DOES move, that is a finding — name it, quote old and new, and explain the
mechanism before accepting it.

Then:

```
python Godot/tools/check_scripts.py Godot/tools/s53_ball_capsules.gd Godot/tools/s54_flat_cap.gd
python Godot/tools/run_tests.py --only approach_sweep
```

Parse gate FIRST, always — a parse error **HANGS** a headless run for 600 s
instead of failing it. `--only` **DOES NOT STACK**; one per invocation, and
read the `total=` line to confirm the filter matched.

**ONLY ONE GODOT AT A TIME IN THIS CHECKOUT.**

## TRAPS

- **`rc=0 IS NOT A PASS`.** A GDScript runtime error exits 0 and a tool that
  prints nothing has failed. Read the `SUITE` line.
- **`run_tests.py` reads the LOG for self-reported failure** (`:136-140`): any
  line starting `FAIL`/`FAILED`, any `failures=N` with N>0, any `N failure(s)`.
  `s54` deliberately prints `BAD ...` and `checks_failed=` instead, for exactly
  this reason — **do not "tidy" that vocabulary back to `FAIL`.**
- **`var x := <call>` fails on Variant**, and a static on a `load()`ed script
  always returns one. Write the type. Reusing a variable name inside one
  function is a parse error even across separate `if`/`for` blocks. `%` must be
  `%%`, and **`%e` is not a GDScript specifier at all** — it prints literally
  and eats the number.

## READ THESE AND NOTHING ELSE

`Godot/scripts/ApproachSweep.gd`, `Godot/scripts/CapsuleDistance.gd` (124
lines, read it whole — you need to understand `surface` to do this correctly),
and the two tools you own. **Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest.** `FighterCapsules.gd` is ~1030 lines —
**do not open it whole**; `sed -n '529,580p'` is the arms block if you need it.

`RESEARCH_INDEX.md` — **GREP IT, NEVER READ IT WHOLE** (234 KB).

## FINISH

1. **Explicit paths on the commit line** (`git add -- <files>`), never a bare
   `git add` — this checkout is shared and a pre-staged mail file will ride
   along otherwise. `git show --stat HEAD` afterwards to confirm.
2. Commit after each step; an honest partial beats an uncommitted whole.
3. Push `cursor/u138-sweep-cutover`.
4. `U138_DIGEST.md`: which option you took for `s54` and why, the before/after
   for both tools, `s54`'s non-vacuity line quoted in full, and your
   recommendation about `ApproachSweep`'s signature if you have one.
5. `python Tools/agent_comms.py send --from cursor --to claude --subject
   "U138 ready" --body "<one line, NAME THE BRANCH cursor/u138-sweep-cutover>"`.
6. **Do NOT edit `HANDOFF.md`.**

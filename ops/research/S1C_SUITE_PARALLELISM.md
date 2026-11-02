# THE SUITE CAN RUN 3.5x FASTER, AND THE ONE THING THAT BROKE IS UNDERSTOOD

Claude, 2026-09-12. Measured during S1c, on the operator's question *"any way to
expedite this?"*

**`run_tests.py --jobs N` has existed all along and nobody has ever trusted it.**
Its own help says why: *"concurrent Godot has produced spurious engine errors
before (C70 reported fails=214 when the truth was 0), so PROVE a jobs value
against a serial run before trusting it."* Nobody had. Every session has paid
about 45 minutes for the integration gate.

This is that proof.

---

## THE MEASUREMENT

Same tree, same commit, back to back:

| run | wall clock | result |
|---|---|---|
| serial (`--jobs 1`) | **~45 min** | `SUITE total=270 fails=7` |
| `--jobs 4` | **12 min 40 s** | `SUITE total=270 fails=8` |

**3.5x faster.** Then the part that matters — a test-by-test diff of all 270:

```
269 of 270 agree EXACTLY.
The single disagreement:
  fight_metres_test.gd   serial PASS   jobs4 FAIL (hang, timeout)
```

**C70's failure mode did NOT reproduce.** There were no spurious engine errors,
no mass false failures, no corruption. Each parallel test already gets its own
`user://`, `APPDATA`/`XDG_DATA_HOME`/`HOME` and log file, so it is *more*
isolated than the serial path, not less.

---

## THE ONE FAILURE, AND IT IS NOT A PARALLELISM BUG

`fight_metres_test.gd` re-run **alone, serially: PASS in 488 seconds.**

It is not flaky and it is not corrupted by concurrency. **It is simply the
heaviest test we own — 488 s of a ~2,700 s serial suite, 18% of the whole gate in
a single file.** Under 4-way contention it shares a CPU three ways and crosses
the runner's 600 s timeout, which the runner correctly reports as a hang.

So the fix is one flag, not a redesign:

```
python Godot/tools/run_tests.py --jobs 4 --timeout 1800
```

---

## THE PROTOCOL TO USE UNTIL `--jobs 4 --timeout 1800` HAS ONE CLEAN RUN

1. `python Godot/tools/run_tests.py --jobs 4 --timeout 1800` — about 13 minutes.
2. **Re-run every failure serially, one at a time**, before believing it:
   `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/<name>.gd`
3. A failure that reproduces serially is real. One that does not is contention.

That is 13 minutes plus a handful of seconds per failure, against 45 minutes.
**Do NOT quote a `--jobs` number as the integration result without step 2** — a
hang under load is indistinguishable from the hang a parse error causes, and that
ambiguity is exactly what R75 was written about.

---

## THE SEPARATE FINDING WORTH ITS OWN LINE

**`fight_metres_test` is 18% of the suite.** 488 seconds in one file. Nothing
else comes close. Whatever it is doing — and it prints per-bucket distance
histograms, so it is running a great many bouts — it is worth asking whether it
needs that many, because halving it would take a bigger bite out of the gate than
any other single change available.

It is also the reason `--jobs` looked broken: with it fixed or split, the
parallel run would have matched the serial one exactly on the first try.

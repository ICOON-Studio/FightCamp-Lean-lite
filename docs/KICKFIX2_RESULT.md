# KICKFIX2 — blocked at E1's N=12 limp stop

2026-11-26 · ARENA cloud clone · kickboxing · no page or test changed.

**This is not an 8-of-9 result and the requested measurement sequence is incomplete.**
E1's completed trial was committed and pushed as `e6d988d` before any next run.
The queue then stopped on the task's limp warning: **5 of 9 stoppage bouts (55.6%)
reached a limp by the end of the stopping beat**. This count conservatively includes
same-beat onset; it does not establish that limping preceded the beat or caused the
stoppage. I have not continued past that warning or claimed unmeasured results.
Independently, E1 must be dropped because its low kick landed **71/76 (93.4%)**, above
the trial's 90% ceiling.

## Measurements

Use and landing rates below combine both fighters. Use means selections per fighter-beat;
landing means hits / (hits + blocks + misses), as in `balance.mjs`. Knockdowns and
stoppages combine both corners. The committed result contains the standard nine bars,
feedback counts, exact commands, and raw aggregate JSON.

| Version | Bars passed | Each red bar with its number | Low kick lands | Body / head kick used and lands | Knockdowns / bout | Stoppages |
|---|---|---|---|---|---|---|
| **E1, N=12**; N=56 dropped | **4/9** | **Dead switch:** rear uppercut 2.1% (<3%). **Landing:** jab 83.3% (short 0%), body hook 73.3% (short 6.7%), overhand 84.6% (short 15.4%), low kick 93.4% (short 0%); ceiling 65%. **Bout endings:** stops 75% (>40%), knockdowns 3.5 (>2.5), draws 0%. **Plan mix:** two punches 9.5% (<15%), none 34.6% (>25%). **Mirror:** wins 33.3% of decided bouts (<40%). | **93.4% (71/76)** | **Body:** used 12.1% (47/390), lands 38.6% (17/44). **Head:** used 6.4% (25/390), lands 54.2% (13/24). | **3.5 (42/12)** | **75% (9/12)** |
| E2, prepared; N=12 not run | Not measured | Queue stopped before E2; no pass/fail or survival claim | Not measured | Not measured | Not measured | Not measured |
| E3, prepared; N=12 not run | Not measured | Queue stopped before E3; no pass/fail or survival claim | Not measured | Not measured | Not measured | Not measured |

E1's four green bars were range (Inside/Mid/Long 26/30/45%), no mandatory action
(top: Cross 24%), clinch frequency (0.7/bout), and order (55% ordered beats; most
frequent first slot 56%). Percentages are rounded independently by the instrument.
Historical B's 6/9 at N=56 remains the prior best bar count, but its dead body/head
kicks are not solved by this trial. A 12-bout mirror result is noisy; it is not a
full-run comparison or a new best version.

No N=56 run was started. E2/E3 are **unmeasured prepared tweaks**, not failed trials;
their JSON files are retained for review/resumption, with no invented result files.
E4 was not designed or run after the stop. No Boxer-style bout was run, so the
prediction that the Boxer eats low kicks remains untested.

## Feedback loops and stop decision

- **Limp:** 6/12 bouts (50%) reached at least one fighter's four-mark limp. Those
  bouts ended in **5 stoppages, 1 points decision, 0 draws**. The other six bouts
  ended in four stoppages and two points decisions. Thus 5/9 stoppages had a limp
  by the end of their stopping beat, exceeding half. This alarm appeared already
  in E1, which inherits A's explicit free Check, before introducing E2's reflex
  check. Applying the warning conservatively, the sequence stops here rather
  than assuming the new check will repair it. A chronology/causality finding
  would require finer traces; these aggregate counts do not provide one.
- **Stamina bar at the last completed bell:** mean **6.04 of 8**. All 12 bouts
  reached at least one bell. For a stopped bout this is its most recent completed
  round, not an invented final bell after the stoppage. Mean current stamina at
  those bells was **2.63**. Mean bar at bout end across all bouts was **5.88 of 8**.
  `N.capMin` remains **4**. The bar did not simply collapse to its floor on average.
- **Independent trial gate:** low kick 93.4% >90%, so E1 is dropped even without
  the limp alarm. The largest action-switch share was Cross 95/390 = 24.4%, so
  the >40% mandatory-switch trial gate did not trigger. Held-hand rates are not
  action-switch rates in the instrument's must-switch bar.

E1 changes body-kick damage and price together, as specified: it does not isolate
which caused the observed mix. It still produced 34.6% no-hand-punch plans and 75%
stoppages in this small sample. Cheaper/lighter body kicks alone did **not** clear
those failures, and the low kick's defensive incentive remains unresolved.

## Rules and regression checks

A, B, and C result texts were read before the task or code. Their numbers support
the task's diagnosis: B loses the body/head kicks after removing Long; A/C keep
both kicks alive but have very high low-kick landing rates. E1 therefore starts
from **A's Long/Mid reach**, not B's restriction.

- E1: A plus body kick **2 health / 2 stamina** (both ACT and actual FEET cost),
  retaining the body-cap loss and catch. Head kick stays **4 health / 4 stamina**.
- Prepared E2: A plus hold/back reflex checks and no separate Check switch.
- Prepared E3: E1 plus E2. These are source replacements loaded in memory, not
  edits to `kick.html`. Original guard-break behavior is retained.
- `node proto/twohands/tools/kick_test.mjs`: **12/12 passed**, before and after.
- `node proto/twohands/tools/page_parse.mjs kick.html order.html switch.html`:
  **all three parse**, before and after.
- The original kick-test assertions were also evaluated against the tweaks in
  memory, without editing their file. **E1: 11/12**: test 1, “a low kick lands on
  a planted leg and marks it,” expects the base page's 2 damage; A/E1 intentionally
  do 1. The leg mark still occurs. All other assertions pass.
- **Prepared E2/E3: 9/12 each** on those same assertions. Test 1 now faces a
  holding defender who checks by reflex, so its expected hit/mark is obsolete.
  Test 2, “a check stops the low kick and the kicker takes the damage,” supplies
  the removed `feet: 'check'` action, so cost lookup rejects that unsupported
  input. Test 6, “a rear-leg kick drops the rear hand in its moment: his overhand
  lands,” still has the exposed rear hand, but the defender's hold first checks
  the low kick: the kicker takes 1 check damage and the overhand is a 5-damage
  counter, not the old 4-damage non-counter. These are listed rule changes, not
  tests deleted or rewritten. Test 9 still accepts Check syntactically in
  `ordOf`; that does not mean the removed switch is legal.
- Separate targeted assertions passed: Long/Mid body/head reach; head 4 damage
  and actual cost 4; E1/E3 body 2 damage and actual cost 2; cap floor 4; E2/E3
  hold/back check while in/teep/low/body/head kick plans expose the leg.
- Source hashes confirmed `kick.html`, `balance.mjs`, `kick_test.mjs`, and
  `page_parse.mjs` unchanged. No repository page, tool, or test is changed or
  deleted by this PR. No table is committed or written to the page's vtable.

## Execution and reproducibility

Cloud override used: no PC watchdog, E: drive, Python, Godot, or images. One balance
run at a time, Node v22.22.3, **jobs=2** (both available cores), `iters=300`, seed=1
(worker seeds 100/101). Setting play jobs explicitly also avoids the tool's default
seven-worker rounding of N=12 to 14. The actual sample is **12 bouts, 195 beats**.

The E1 table took **8,764 seconds**, and play took **750 seconds**. Its table remains
local at `tmp_kick/kick_fix_e1.vt.json`; only tweak/result/docs paths are committed.
Run from the repository root:

```sh
node proto/twohands/tools/balance.mjs table tweak=ops/research/s558_balance/kick_fix_e1.json out=tmp_kick/kick_fix_e1.vt.json iters=300 jobs=2
node --import ./tmp_kick/telemetry.mjs proto/twohands/tools/balance.mjs play who=mix opp=mirror n=12 tweak=ops/research/s558_balance/kick_fix_e1.json table=tmp_kick/kick_fix_e1.vt.json jobs=2 json=tmp_kick/kick_fix_e1_n12.json
```

The temporary observational loader below is included here so the feedback counts
can be reproduced without committing a tool change. Save it as
`tmp_kick/telemetry.mjs`. It changes only aggregate observation inside `bouts` and
printing; it adds no RNG calls and changes no plan, solve, resolution, recovery,
knockdown, scoring, or rule. Table construction used the uninstrumented command.

```js
import { registerHooks } from 'node:module';
registerHooks({ load(url, context, nextLoad) {
 const r = nextLoad(url, context);
 if (!url.endsWith('/proto/twohands/tools/balance.mjs')) return r;
 let s = String(r.source);
 const replace = (a,b) => {
  if (!s.includes(a)) throw Error('Telemetry anchor missing: '+a);
  s = s.replace(a,b);
 };
 replace('const o = { n, w: 0,', 'const o = { feedback: { limpBouts: 0, limpStops: 0, limpPoints: 0, limpDraws: 0, bellBouts: 0, bellCap: 0, bellSt: 0, endCap: 0 }, n, w: 0,');
 replace('let done = false; const t = [0, 0];', 'let done = false, limped = false, lastBell = null; const t = [0, 0];');
 replace('endBeat(S); o.beats++;', 'endBeat(S); if (S.f.some(m => m.legs >= N.limp)) limped = true; o.beats++;');
 replace('if (!done) { const [x, y] = S.f, lvl', 'if (!done) { lastBell = S.f.map(m => ({cap:m.cap,st:m.st})); const [x, y] = S.f, lvl');
 replace('if (!done) { if (t[0] > t[1])', `o.feedback.endCap += (S.f[0].cap + S.f[1].cap) / 2;
    if(lastBell) { o.feedback.bellBouts++; o.feedback.bellCap += (lastBell[0].cap + lastBell[1].cap) / 2; o.feedback.bellSt += (lastBell[0].st + lastBell[1].st) / 2; }
    if(limped) { o.feedback.limpBouts++; if(done) o.feedback.limpStops++; else if(t[0]===t[1]) o.feedback.limpDraws++; else o.feedback.limpPoints++; }
    if (!done) { if (t[0] > t[1])`);
 replace("if (arg('json', '')) fs.writeFileSync", "console.log('FEEDBACK ' + JSON.stringify(o.feedback)); if (arg('json', '')) fs.writeFileSync");
 return {...r, source:s};
}});
```

## Page decision — three plain lines

No version should go on the page from this measurement.

E1 would give the player a 2-health, 2-stamina body kick, with the 4-health, 4-stamina head kick unchanged.

Keep the current page: E1 fails the trial gate, and E2/E3 have no bout evidence yet.

KICKFIX2 BLOCKED: conservative limp stop triggered at E1 N=12 (5/9 stoppages reached a limp); E1 also exceeds the 90% low-kick trial ceiling. E2/E3 and surviving N=56 measurements remain unrun.

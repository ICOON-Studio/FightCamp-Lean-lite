// probe_guard_bar.js (S553): HOW OFTEN DOES THE GUARD BAR BREAK in Ring Switches, as tuned and under two first guesses?
// A measurement only: it reads probe_switch_bots.js (the page's rules as that probe holds them), counts on top of them
// and changes nothing on disk. The S552 handover question to the owner: "The guard bar almost never breaks as tuned.
// Should I make it matter?" - this is the number behind "almost never".
//   node proto/twohands/tools/probe_guard_bar.js [bouts a man, default 400]
// Arms: as tuned (6 points, +1 back every beat, -1 for a blocked big punch) | no +1 in a beat it blocked a big punch |
// 4 points | both. Population: the probe's "sensible player" and "sensible, 1 in 4 off" against its three men.
const fs = require('fs'), path = require('path');
const src = fs.readFileSync(path.join(__dirname, 'probe_switch_bots.js'), 'utf8');
const cutAt = src.indexOf('const pc = (x)');
if (cutAt < 0) throw new Error('probe_switch_bots.js changed: no "const pc" line');
const wear = "D.g = Math.max(0, D.g - (a.d >= 3 ? 1 : 0));";
const back = "m.g = Math.min(N.guard, m.g + N.grec);";
if (!src.includes(wear) || !src.includes(back)) throw new Error('probe_switch_bots.js changed: the guard lines are not as expected');
const real = "resolve(S, [human(S, eps), ai(S)]);";   // the bout's own beat: the test player also replays beats in his head, and those must not be counted
if (!src.includes(real)) throw new Error('probe_switch_bots.js changed: the bout loop is not as expected');
const n = Number(process.argv[2] || 400);

function arm(label, guard, restAfterWear) {
  let body = src.slice(0, cutAt)
    .replace(/guard: 6/, 'guard: ' + guard)
    .replace(wear, wear + " if (a.d >= 3) D.wore = 1; if (STAT.real) { STAT.blocks++; if (a.d >= 3) STAT.big++; if (D.g <= 0 && !D.brokeNow) { D.brokeNow = 1; STAT.breaks[v]++; } }")
    .replace(real, "{ const pl = [human(S, eps), ai(S)]; STAT.real = 1; resolve(S, pl); STAT.real = 0; }")
    .replace(back, restAfterWear ? back : "m.g = Math.min(N.guard, m.g + (m.wore ? 0 : N.grec));")
    .replace("function endBeat(S) { for (const m of S.f) {", "function endBeat(S) { for (const m of S.f) { STAT.low = Math.min(STAT.low, m.g); if (m.g > 0) m.brokeNow = 0;");
  body = body.replace("if (m.held) m.held--; } }", "m.wore = 0; if (m.held) m.held--; } }");
  const run = new Function('STAT', 'n', body + `
    const out = [];
    for (const eps of [0, 0.25]) for (oppI = 0; oppI < 3; oppI++) { OPP = OPPS[oppI]; STAT.blocks = STAT.big = 0; STAT.breaks = [0, 0]; STAT.low = 99;
      const r = boutHuman(eps, n); out.push({ eps, opp: OPP.n, wins: r[0], stops: r[1], beats: r[2], blocks: STAT.blocks / n, big: STAT.big / n, brYou: STAT.breaks[0] / n, brHim: STAT.breaks[1] / n, low: STAT.low }); }
    return out;`);
  const rows = run({ blocks: 0, big: 0, breaks: [0, 0], low: 99 }, n);
  console.log('\n' + label);
  for (const r of rows) console.log(`  ${r.eps ? 'careless 1 in 4' : 'sensible       '} v ${r.opp.padEnd(18)} wins ${(100 * r.wins).toFixed(0).padStart(3)}%  stoppages ${(100 * r.stops).toFixed(0).padStart(3)}%  blocked punches a bout ${r.blocks.toFixed(1).padStart(5)} (big ${r.big.toFixed(1).padStart(4)})  guard breaks a bout: yours ${r.brYou.toFixed(2)}  his ${r.brHim.toFixed(2)}  lowest bar seen ${r.low}`);
}
console.log(`GUARD BAR PROBE: ${n} bouts a man, 3 rounds of 6 beats; the probe's own bots (different men: hp 20 / 26 / 22, read 0.75 / 0.45 / 0.6)`);
arm('AS TUNED: 6 points, +1 back every beat', 6, true);
arm('NO +1 in a beat it blocked a big punch (6 points)', 6, false);
arm('4 POINTS, +1 back every beat', 4, true);
arm('4 POINTS and no +1 in a beat it blocked a big punch', 4, false);

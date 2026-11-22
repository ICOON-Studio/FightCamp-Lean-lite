import { PLAYERS, OPPONENTS, NAME, CFG, TIERS, NCODES } from './cards.mjs';
import { playBout } from './bout.mjs';
import { readerBot, greedyBot, randomBot, allSeeingBot } from './bots.mjs';
import { beginnerBot, tableBot } from './bots2.mjs';
const args = Object.fromEntries(process.argv.slice(2).map((a) => a.split('=')));
for (const [k, v] of Object.entries(args)) { if (k in CFG) CFG[k] = Number(v); else if (k.startsWith('t')) { const [_, tn, f] = k.split('.'); TIERS[tn][f] = Number(v); } }
const per = Number(args.per || 20), tier = Number(args.tier || 3);
const mix = (a, l) => ({ name: 'mix', start: (i) => { a.start && a.start(i); l.start && l.start(i); }, pick: (v) => a.pick(v), lead: (v) => l.lead(v), observe: (...x) => { a.observe && a.observe(...x); l.observe && l.observe(...x); }, corner: (v) => a.corner(v) });
const bots = { reader: (s) => readerBot({ seed: s }), r2: (s) => readerBot({ seed: s, dmgK: 2 }), r4: (s) => readerBot({ seed: s, dmgK: 4 }), r4k: (s) => readerBot({ seed: s, dmgK: 4, kdK: 2 }), p0: (s) => readerBot({ seed: s, plain: [0, 0, 0, 0, 0] }), p1: (s) => readerBot({ seed: s, plain: [1.5, 0, 0, 0, 0] }), p2: (s) => readerBot({ seed: s, plain: [1.5, 1, 0.3, 0, 0] }), p3: (s) => readerBot({ seed: s, plain: [1.5, 1, 0.3, 0.5, 0] }), p4: (s) => readerBot({ seed: s, plain: [1.5, 1, 0.3, 1, 0.5] }), p5: (s) => readerBot({ seed: s, plain: [3, 1.5, 0.5, 0.5, 0.3] }), w0: (s) => readerBot({ seed: s, windK: 0 }), w5: (s) => readerBot({ seed: s, windK: 0.5 }), w0d2: (s) => readerBot({ seed: s, windK: 0, dmgK: 2 }), w3d2: (s) => readerBot({ seed: s, windK: 0.3, dmgK: 2 }), greedy: (s) => greedyBot(s), table: () => tableBot(), beginner: () => beginnerBot(), random: (s) => randomBot(s),
  'readAns+greedLead': (s) => mix(readerBot({ seed: s }), greedyBot(s)), 'greedAns+readLead': (s) => mix(greedyBot(s), readerBot({ seed: s })), allsee: (s) => allSeeingBot(s),
  k2: (s) => readerBot({ seed: s, windK: 2 }), k4: (s) => readerBot({ seed: s, windK: 4 }), k4d: (s) => readerBot({ seed: s, windK: 4, dmgK: 2 }), k8: (s) => readerBot({ seed: s, windK: 8 }),
  rw: (s) => readerBot({ seed: s, corner: 'water' }), ri: (s) => readerBot({ seed: s, corner: 'ice' }), re: (s) => readerBot({ seed: s, corner: 'eyes' }), p1w: (s) => readerBot({ seed: s, corner: 'water', plain: [1.5, 0, 0, 0, 0] }), p4w: (s) => readerBot({ seed: s, corner: 'water', plain: [1.5, 1, 0.3, 1, 0.5] }), seew: (s) => readerBot({ seed: s, corner: 'water', see: true }),
  gA: (s) => mix(greedyBot(s), readerBot({ seed: s, corner: 'water' })), gB: (s) => mix(readerBot({ seed: s, corner: 'water' }), greedyBot(s)),
  A: (s) => mix(readerBot({ seed: s, plain: [1.5, 1, 0.3, 1, 0.5] }), greedyBot(s)), B: (s) => mix(readerBot({ seed: s, plain: [1.5, 0, 0, 0, 0] }), greedyBot(s)), B0: (s) => mix(readerBot({ seed: s, plain: [0, 0, 0, 0, 0] }), greedyBot(s)),
  Bsee: (s) => mix(readerBot({ seed: s, plain: [0, 0, 0, 0, 0], see: true }), greedyBot(s)), C3: (s) => mix(readerBot({ seed: s, plain: [3, 1.5, 0.5, 0, 0] }), greedyBot(s)), F: (s) => mix(readerBot({ seed: s, plain: [1.5, 0, 0, 0, 0], film: 2 }), greedyBot(s)) };
for (const nm of (args.bots || 'reader,greedy,table,beginner').split(',')) {
  let n = 0, w = 0, s = 310000; const d = { lg: 0, lt: 0, ag: 0, at: 0, lc: 0, ac: 0, hlc: 0, hac: 0, nl: 0, na: 0, stop: 0, tired: 0, ex: 0 };
  for (const p of PLAYERS) for (const o of OPPONENTS) for (let i = 0; i < per; i++) {
    s++; const t = []; const st = playBout(p, o, bots[nm](s), { seed: s, tier, transcript: t });
    n++; w += st.win; if (st.method === 'stop') d.stop++; d.tired += st.oppTired; d.ex += st.exchanges;
    for (const e of t) { const g = e.beats.reduce((a, b) => a + b.toB, 0), tk = e.beats.reduce((a, b) => a + b.toA, 0), mc = e.you.filter((c) => c).length, hc = e.him.filter((c) => c).length;
      if (e.youLead) { d.lg += g; d.lt += tk; d.lc += mc; d.hac += hc; d.nl++; } else { d.ag += g; d.at += tk; d.ac += mc; d.hlc += hc; d.na++; } }
  }
  console.log(nm.padEnd(18), `${(100 * w / n).toFixed(0)}% win ${(100 * d.stop / n).toFixed(0)}% stop tired ${(100 * d.tired / d.ex).toFixed(0)}% | my lead: deal ${(d.lg / d.nl).toFixed(1)} take ${(d.lt / d.nl).toFixed(1)} cards ${(d.lc / d.nl).toFixed(2)} v his ${(d.hac / d.nl).toFixed(2)} | his lead: deal ${(d.ag / d.na).toFixed(1)} take ${(d.at / d.na).toFixed(1)} cards ${(d.ac / d.na).toFixed(2)} v his ${(d.hlc / d.na).toFixed(2)}`);
}

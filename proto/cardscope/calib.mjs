// CARDSCOPE greybox - sizing aid. Calibration seeds only (300000+); the bar tables run on other seeds.
// node proto/cardscope/calib.mjs [bouts a pair]  -> the shape of the fight for each bot, and the classes.
import { PLAYERS, OPPONENTS, TIERS, CFG } from './cards.mjs';
import { playBout } from './bout.mjs';
import { randomBot, greedyBot, readerBot, allSeeingBot } from './bots.mjs';
import { beginnerBot, tableBot } from './bots2.mjs';

export function cell(mk, per, opts = {}) {
  const a = { n: 0, win: 0, stop: 0, one: 0, late: 0, split: 0, pts: 0, kd: 0, ex: 0, tired: 0, dP: 0, dO: 0, lP: 0, tP: 0, hh: [0, 0, 0, 0], ah: [0, 0, 0, 0, 0], hl: 0, hab: 0, pair: [] };
  let s = 300000;
  for (const p of PLAYERS) for (const o of OPPONENTS) {
    let w = 0;
    for (let i = 0; i < per; i++) {
      s++;
      const st = playBout(p, o, mk(s), { ...opts, seed: s });
      a.n++; a.win += st.win; w += st.win; a.one += st.oneSided; a.late += st.late; a.kd += st.kdP + st.kdO; a.ex += st.exchanges; a.tired += st.oppTired;
      a.dP += st.dmgP; a.dO += st.dmgO; a.lP += st.leadsP; a.tP += st.trapsP; a.hl += st.hisLeads; a.hab += st.habitLeads;
      for (let k = 0; k < 4; k++) a.hh[k] += st.hisHid[k]; for (let k = 0; k < 5; k++) a.ah[k] += st.ansHid[k];
      if (st.method === 'stop') a.stop++; else { a.pts++; a.split += st.split; }
    }
    a.pair.push(Math.round(100 * w / per));
  }
  const p = (x, n = a.n) => (100 * x / Math.max(1, n)).toFixed(0).padStart(3);
  return `${p(a.win)}% win ${p(a.stop)}% stop ${p(a.one)}% one-sided ${p(a.late)}% late ${p(a.split, a.pts)}% split ${(a.kd / a.n).toFixed(2)} kd | he tired ${p(a.tired, a.ex)}% | dmg ${(a.dP / a.ex).toFixed(1)}/${(a.dO / a.ex).toFixed(1)} | my traps ${p(a.tP, a.lP)}% | his hidden nothing/punch/guard/feint ${a.hh.map((x) => p(x, a.hl)).join('/')} | my answers punch/block/evade/none/feint ${a.ah.map((x) => p(x, a.hl)).join('/')} | habit ${p(a.hab, a.hl)}% | pairs ${a.pair.join(' ')}`;
}
if (process.argv[1].endsWith('calib.mjs')) {
  // name=value pairs resize a number for this run only: kdLine=20  t.3.ans=2 (class 3, field ans)  per=40  only=reader,greedy
  const args = Object.fromEntries(process.argv.slice(2).map((a) => a.split('=')));
  for (const [k, v] of Object.entries(args)) { if (k in CFG) CFG[k] = Number(v); else if (k.startsWith('t.')) { const [, tn, f] = k.split('.'); TIERS[tn][f] = Number(v); } }
  const per = Number(args.per || 40), only = (args.only || 'reader,allseeing,greedy,table,beginner,random,tiers').split(',');
  const say = (nm, f) => { if (only.includes(nm.trim())) console.log(nm, f()); };
  say('reader   ', () => cell((s) => readerBot({ seed: s }), per));
  say('allseeing', () => cell((s) => allSeeingBot(s), per));
  say('greedy   ', () => cell((s) => greedyBot(s), per));
  say('table    ', () => cell(() => tableBot(), per));
  say('beginner ', () => cell(() => beginnerBot(), per));
  say('random   ', () => cell((s) => randomBot(s), per));
  if (only.includes('tiers')) for (const t of [1, 2, 3, 4, 5]) console.log(TIERS[t].name.padEnd(12), 'beginner', cell(() => beginnerBot(), per, { tier: t }).slice(0, 8), ' reader', cell((s) => readerBot({ seed: s }), per, { tier: t }).slice(0, 8), ' table', cell(() => tableBot(), per, { tier: t }).slice(0, 8));
}
// extras: node proto/cardscope/calib.mjs only=extras  -> forced answers to the hidden card, film, counting, corner
if (process.argv[1].endsWith('calib.mjs') && process.argv.includes('only=extras')) {
  const per = Number((process.argv.find((a) => a.startsWith('per=')) || 'per=30').slice(4));
  const win = (mk, opts) => cell(mk, per, opts).slice(0, 4);
  console.log('free', win((s) => readerBot({ seed: s })), 'always block', win((s) => readerBot({ seed: s, hiddenAnswer: 8 })), 'jab', win((s) => readerBot({ seed: s, hiddenAnswer: 1 })),
    'punch', win((s) => readerBot({ seed: s, hiddenAnswer: -2 })), 'empty', win((s) => readerBot({ seed: s, hiddenAnswer: 0 })));
  let on = 0, df = 0;
  const f2 = win((s) => { const b = readerBot({ seed: s, film: 2, flip: true }); const e = b.end; b.end = (st) => { on += b.stat.applies; df += b.stat.differs; e && e(st); }; return b; });
  console.log('film2', f2, 'flips', df, 'of', on, 'film1', win((s) => readerBot({ seed: s, film: 1 })), 'noCount', win((s) => readerBot({ seed: s, count: false })), 'noLearn', win((s) => readerBot({ seed: s, learn: false })));
  console.log('corner informed', win((s) => readerBot({ seed: s })), 'random', win((s) => readerBot({ seed: s, corner: 'random' })), 'water', win((s) => readerBot({ seed: s, corner: 'water' })),
    'ice', win((s) => readerBot({ seed: s, corner: 'ice' })), 'eyes', win((s) => readerBot({ seed: s, corner: 'eyes' })));
}

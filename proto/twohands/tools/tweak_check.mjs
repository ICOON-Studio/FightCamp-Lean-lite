// Does a tweak file still fit the page? (Its "src" pairs are exact text of order.html: any edit of those lines breaks it.)
// Loads the page with the tweak and plays one beat; with `southpaw` it also checks the open-stance rule itself.
//   node proto/twohands/tools/tweak_check.mjs <tweak.json> [southpaw]
import { loadTweaked, readTweak } from './balance.mjs';
const R = loadTweaked(1, readTweak(process.argv[2]), null), { plan0, man, N, resolve } = R, ring = () => ({ range: 2, f: [man(N.hp), man(N.hp)] });
const one = (a, b) => resolve(ring(), [{ ...plan0(), ...a }, { ...plan0(), ...b }]).filter((e) => e.k === 0 && e.id).map((e) => `${e.a} ${e.t}`).join(', ');
console.log('TWEAK_CHECK loads; a cross at a lead hand held high, rear hand low: ' + one({ rear: 'cross' }, { hl: 'high', hr: 'low' }) + ' | at a rear hand held high, lead hand low: ' + one({ rear: 'cross' }, { hl: 'low', hr: 'high' }));
if (process.argv[3] === 'southpaw') { const ok = /hit/.test(one({ rear: 'cross' }, { hl: 'high', hr: 'low' })) && /block/.test(one({ rear: 'cross' }, { hl: 'low', hr: 'high' })) && /block/.test(one({ rear: 'rbody' }, { hl: 'high', hr: 'low' }));
  console.log(ok ? 'TWEAK_CHECK southpaw PASS: the rear straights are stopped by the rear hand, not the lead hand' : 'TWEAK_CHECK southpaw FAIL'); process.exitCode = ok ? 0 : 1; }

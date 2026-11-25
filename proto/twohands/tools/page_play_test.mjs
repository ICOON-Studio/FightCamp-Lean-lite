// THE PAGE ITSELF IS PLAYED (S557). rules_test.mjs tests the rules above the page mark; nothing ran the page's own half
// (the bell, the cards, what the player is shown). In S556 a comment swallowed "cards.push(sc)" there: no round reached
// the cards and every bout on points ended "A DRAW 0-0", with 34 rule tests green. This runs the whole script of
// order.html against stand-in page elements and a timer queue, clicks "Fight this beat" to the last bell, and reads
// what the page wrote.
//   node proto/twohands/tools/page_play_test.mjs
import fs from 'node:fs';
import path from 'node:path';
import assert from 'node:assert/strict';
import { fileURLToPath } from 'node:url';
import { mulberry } from './rules.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const html = fs.readFileSync(path.join(here, '..', 'order.html'), 'utf8');
const src = html.slice(html.indexOf('<script>') + 8, html.lastIndexOf('</script>'));

function page(seed) {
  const els = {}, q = [];
  const mk = (id) => ({ id, innerHTML: '', textContent: '', className: '', src: '', disabled: false, onclick: null, style: { setProperty() {} }, dataset: {}, classList: { add() {}, remove() {} },
    offsetWidth: 0, offsetHeight: 0, clientWidth: 100, clientHeight: 100, naturalWidth: 1, naturalHeight: 1, querySelector: () => null, querySelectorAll: () => [], appendChild() {},
    insertAdjacentHTML(_, h) { this.innerHTML += h; }, click() { if (this.onclick) this.onclick({ target: this }); } });
  const document = { getElementById: (id) => els[id] || (els[id] = mk(id)), querySelector: () => null, querySelectorAll: () => [], createElement: () => mk('new'), body: mk('body'), addEventListener() {} };
  const MathS = Object.create(Math); MathS.random = mulberry(seed);
  const Audio = function () { this.play = () => Promise.resolve(); };
  const fn = new Function('document', 'window', 'location', 'setTimeout', 'fetch', 'Audio', 'Image', 'Math', 'innerWidth', 'innerHeight', src +
    ';return { get: () => ({ F, P, round, beat, range, cards, phase, seen, seenRound }), setP: (p) => { P = { ...plan0(), ...p }; P.ord = ordOf(P); }, setOpp: (i) => { oppI = i; setup(); }, draw, trim, N, ACT };');
  const G = fn(document, { addEventListener() {} }, { search: '' }, (f) => { q.push(f); return q.length; }, () => new Promise(() => {}), Audio, function () {}, MathS, 1920, 1080);
  // one click of the gold button, then every timer the beat queues (the pictures fall back to their stills: no picture is loaded here)
  const click = async () => { els.go.click(); for (let i = 0; i < 4000; i++) { await new Promise((r) => setImmediate(r)); if (!q.length) return; q.shift()(); } throw new Error('the beat never settled'); };
  return { els, G, click };
}

let n = 0; const test = async (name, f) => { try { await f(); n++; } catch (e) { process.exitCode = 1; console.log(`FAIL ${name}\n  ${e.message}`); } };

await test('a bout played to the last bell: every round goes on the cards, and the result adds them up', async () => {
  let done = 0;
  for (const seed of [3, 4, 5, 6, 7, 8]) { const { els, G, click } = page(seed); G.setOpp(0); await click();   // "Fight The Jabber"
    assert.equal(G.get().phase, 'plan'); let rounds = 0;
    for (let b = 0; b < 18 && G.get().phase !== 'over'; b++) { const r0 = G.get().round; G.setP({ hl: 'low', hr: 'high' }); await click();   // both hands held: the cheapest way to hear three bells
      const s = G.get(); if (s.phase !== 'over' && s.round > r0) { rounds++; assert.equal(s.cards.length, rounds, `after bell ${rounds} the cards hold ${s.cards.length} rounds`);
        assert.match(els.score.innerHTML, new RegExp(`R${rounds} (10|9)-(10|9)`), 'the score line shows the round'); assert.equal(s.seenRound.length, 0, 'a new round: nothing seen of him yet'); } }
    const s = G.get(); assert.equal(s.phase, 'over', 'the bout ended'); const said = els.said.textContent;
    if (/referee stops it/.test(said)) continue;
    done++; assert.equal(s.cards.length, G.N.rounds, 'three rounds on the cards'); const t = [0, 1].map((k) => s.cards.reduce((a, c) => a + c[k], 0));
    assert.ok(t[0] >= 27 && t[1] >= 27, `the cards add up to a real score, not ${t.join('-')}`); assert.ok(said.includes(`${t[0]}-${t[1]}`), `the result names the cards: "${said}"`); }
  assert.ok(done >= 1, 'at least one of the six bouts went to the cards');
});

await test('ZIVAFIX1: his last three beats are on his card before you choose, holds included', async () => {
  const { els, G, click } = page(11); G.setOpp(1); await click(); assert.match(els.him.innerHTML, /nothing yet/);
  for (let b = 0; b < 3; b++) { G.setP({ hl: 'high', hr: 'high' }); await click(); }
  const s = G.get(); assert.equal(s.seen.length, 3); const h = els.him.innerHTML;
  for (const w of ['Last beat', 'Before that', 'And before']) assert.ok(h.includes(w), `"${w}" is on his card`);
  assert.match(h, /This round, 3 beats:[\s\S]*his lead hand - held high \d, held low \d, thrown \d/, 'the hover counts what each hand did this round');
});

await test('ZIVAFIX1: the stamina bar says what body punches took and for how long; a man down twice reads "one more ends it"; a landed punch says its points', async () => {
  const { els, G, click } = page(2); G.setOpp(2); await click();
  const { F } = G.get(); F[0].cap = 6; F[0].st = 5; F[0].kd = 2; G.draw(); const y = els.you.innerHTML;
  assert.match(y, /Stamina 5 of 6 \(was 8\)/); assert.match(y, /<s style="width:25%"><\/s>/, 'the lost end of the bar is drawn'); assert.match(y, /for the rest of the bout[\s\S]*never goes under 4/);
  assert.match(y, /down 2x - one more ends it/); F[0].kd = 1; G.draw(); assert.ok(!/one more ends it/.test(els.you.innerHTML), 'not after the first knockdown');
  assert.match(els.score.innerHTML, /A counter adds health, not points/);
});

await test('ZIVAFIX1: a switch the stamina cannot pay is switched off in words, never silently', async () => {
  const { els, G, click } = page(2); await click(); const { F } = G.get();
  G.setP({ lead: 'hook', rear: 'over' }); F[0].st = 2; els.story.innerHTML = ''; G.trim();
  assert.equal(G.get().P.rear, null, 'the overhand (3 stamina) is off'); assert.equal(G.get().P.lead, 'hook', 'the hook (2) stays');
  assert.match(els.story.innerHTML, /Switched off<\/b><span>Overhand - you have 2 stamina/);
  G.setP({ lead: 'hook' }); els.story.innerHTML = ''; G.trim(); assert.equal(els.story.innerHTML, '', 'nothing is said when nothing is switched off');
});

console.log(`PAGE_PLAY_TEST ${n} passed${process.exitCode ? ' - FAILURES above' : ''}`);

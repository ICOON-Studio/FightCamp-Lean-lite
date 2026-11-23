// The page's words. Pure: no document, no game state, so node can import this module and a broken import fails the
// test. Every line the player reads about a card is built here, from the same CARDS the engine plays.
import { CARDS, N, FLOOR, STYLES } from './cards.mjs';
import { TRAINING, cardVariant } from './career.mjs';
import { STRIP, guideLines, volleyThreat, threatLine } from './guide.mjs';

export const esc = (s) => String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
const RANGE = { K: 'KICK', P: 'PUNCH', C: 'CLINCH', G: 'GROUND', T: 'TOP', B: 'GUARD' };
// the two engine answers are not cards: the page used to look them up in CARDS and die on the missing key
const STEP = {
  '@in': 'KICK → PUNCH, PUNCH → CLINCH',
  '@out': 'CLINCH → PUNCH, PUNCH → KICK',
  '@stand': 'stand up from the top position',
  '@up': 'get up: win back one rung',
  '@cover': `a strike lands for ${N.cover} less`,
  '@break': 'break a submission: pay its price in wind',
  '@pull': 'sit to guard from any standing range (BJJ)',
};
export const isStep = (id) => typeof id === 'string' && id[0] === '@';
export const names = (id) => (isStep(id) ? FLOOR[id] || id : CARDS[id]?.n || id);
export function cardText(id) {
  if (isStep(id)) return `${FLOOR[id] || id} · ${STEP[id] || 'a step'}`;
  const c = CARDS[id];
  if (!c) return String(id);
  const at = c.at ? c.at.map((x) => RANGE[x] || x).join(' / ') : 'ANSWER';
  const effect = c.k === 'strike' ? `${c.dmg} damage${c.pts ? ` + ${c.pts} point${c.pts === 1 ? '' : 's'}` : ''}${c.drain ? ' · drains wind' : ''}`
    : c.k === 'shot' ? `Takedown · rung ${c.to} · ${c.pts} points${c.dmg ? ` · ${c.dmg} damage` : ''}`
    : c.k === 'hold' ? `${c.hk === 'sub' ? 'Submission' : 'Pin'} · countdown ${c.count}${c.brk ? ` · break at ${c.brk} wind` : ''}`
    : c.k === 'adv' ? `Advance one rung · ${c.pts} points`
    : c.k === 'setup' ? 'Grip setup · makes throws reliable'
    : c.fx === 'block' ? `a strike: ${c.guard || N.block} off`
    : c.fx ? `${c.vs}` : c.act ? 'Escape / stand up' : c.vs || 'Move';
  return `${c.w} wind · ${at} · ${effect}`;
}
export function card(id, extra = '') {
  const c = CARDS[id] || {};
  const kind = c.k === 'strike' ? 'punch' : c.k === 'ans' ? 'defence' : isStep(id) ? 'footwork' : 'corner';
  return `<article class="card ${kind} ${extra}"><b>${esc(names(id))}</b><small>${esc(cardText(id))}</small></article>`;
}
export function previewTraining(option) {
  const c = CARDS[option.id];
  if (c.k === 'strike') return `Preview: ${c.dmg} damage${c.pts ? `, ${c.pts} point` : ''}; trained version: ${c.dmg + 1} damage.`;
  if (c.fx === 'block') return `Preview: ${cardText(option.id)}; trained version blocks ${N.block + 1} damage.`;
  if (c.k === 'hold') return `Preview: ${cardText(option.id)}; trained version shortens the hold countdown by one.`;
  if (c.pts) return `Preview: ${cardText(option.id)}; trained version scores ${c.pts + 1} points.`;
  return `Preview: ${cardText(option.id)}; trained version costs ${Math.max(0, c.w - 1)} wind.`;
}
// The PLAY gate row "the printed numbers equal the engine's" (plan section 7): every number a card line, a step
// line or a training preview prints must be the engine's own number for that card. Returns { checked, problems };
// empty problems = the table shows the rules as they play.
export function printedProblems() {
  const problems = []; let checked = 0;
  const has = (t, frag, what) => { checked++; if (!t.includes(frag)) problems.push(`${what}: the line is "${t}" but the engine says "${frag}"`); };
  for (const id of Object.keys(CARDS)) {
    const c = CARDS[id];
    if (!['boxing', 'bjj', 'core'].includes(c.st)) continue;
    const t = cardText(id);
    has(t, `${c.w} wind`, `${id} wind`);
    if (c.k === 'strike') { has(t, `${c.dmg} damage`, `${id} damage`); if (c.pts) has(t, `${c.pts} point`, `${id} points`); }
    else if (c.k === 'shot') { has(t, `rung ${c.to}`, `${id} the rung`); has(t, `${c.pts} point`, `${id} points`); if (c.dmg) has(t, `${c.dmg} damage`, `${id} damage`); }
    else if (c.k === 'hold') { has(t, `countdown ${c.count}`, `${id} the countdown`); if (c.brk) has(t, `break at ${c.brk}`, `${id} the break price`); }
    else if (c.k === 'adv') has(t, `${c.pts} point`, `${id} points`);
    else if (c.k === 'ans' && c.fx === 'block') has(t, `${c.guard || N.block} off`, `${id} the block`);
  }
  for (const id of ['@in', '@out', '@stand', '@up', '@pull']) has(cardText(id), FLOOR[id], `${id} the step name`);
  has(cardText('@cover'), `lands for ${N.cover} less`, '@cover the cover number');
  for (const s of STYLES) for (const o of TRAINING[s]) {
    const c = CARDS[o.id], v = CARDS[cardVariant(o.id, 1)], t = previewTraining(o);
    if (c.k === 'strike') has(t, `${c.dmg} damage`, `${o.id} the preview keeps the base damage`);
    else has(t, cardText(o.id), `${o.id} the preview keeps the base line`);
    if (c.k === 'strike') has(t, `${v.dmg} damage`, `${o.id} the trained damage`);
    else if (c.fx === 'block') has(t, `${v.guard} damage`, `${o.id} the trained block`);
    else if (c.pts) has(t, `${v.pts} point`, `${o.id} the trained points`);
    else if (c.k !== 'hold') has(t, `${v.w} wind`, `${o.id} the trained wind`);
  }
  return { checked, problems };
}
// ---- round 8: the guide on the table -----------------------------------------------------------------
// the range strip: the four ranges of the bout, the one you are at lit. key = posKey(S, m) ('K','P','C','T0'..'B3'),
// or null for the picture on the How to play page. On the ground the strip also says which side you are on.
export function rangeStrip(key, extra = '') {
  const at = key ? (key[0] === 'T' || key[0] === 'B' ? 'G' : key[0]) : null;
  const side = key ? (key[0] === 'T' ? `you are on top${+key[1] ? `, ground step ${key[1]}` : ''}` : key[0] === 'B' ? `you are underneath${+key[1] ? `, ground step ${key[1]}` : ''}` : '') : '';
  return `<span class="rangestrip${extra ? ' ' + extra : ''}" id="range">${STRIP.map(([k, w]) => `<span class="range-cell${at === k ? ' on' : ''}">${w}</span>`).join('')}${side ? `<small>${side}</small>` : ''}</span>`;
}
// his volley, face up: every card and step he has laid this turn, with the line the answer table uses for it
export function volleyRow(S) {
  if (!S.inc.length) return '';
  return `<div class="volley" id="volley"><span class="tiny">His volley, face up</span>${S.inc.map((p) => `<span class="volley-card${p.id[0] === '@' ? ' step' : ''}"><b>${esc(names(p.id))}</b><small>${esc(cardText(p.id))}</small></span>`).join('')}</div>`;
}
// the answer table: his volley, the low-health warning in red when the volley as laid would knock you out (or leave you
// under a quarter), then one card per answer. options = answerOptions(S, 0): [null, ...]; null is Take it.
export function answerTable(S, options) {
  const warn = threatLine(volleyThreat(S, 0));
  return `${volleyRow(S)}${warn ? `<p class="warn" id="warning">${esc(warn)}</p>` : ''}<h2>Answer the visible volley</h2><div class="offers">${options.map((o, i) => `<button class="card defence" data-answer="${i}" data-id="${o ? o.id : '@'}"><b>${o ? esc(names(o.id)) : 'Take it'}</b><small>${o ? esc(cardText(o.id)) : 'No answer cost: his volley resolves as it lies.'}</small></button>`).join('')}</div>`;
}
// the How to play page (round 8, item 4): the same six lines the coach says, and the picture of the strip
export function howtoLines() {
  return guideLines().map((l) => `<div class="howto-line" data-line="${l.id}"><b>${esc(l.title)}</b><span>${esc(l.text)}</span></div>`).join('');
}

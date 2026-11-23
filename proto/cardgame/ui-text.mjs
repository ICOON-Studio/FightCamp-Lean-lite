// The page's words. Pure: no document, no game state, so node can import this module and a broken import fails the
// test. Every line the player reads about a card is built here, from the same CARDS the engine plays.
import { CARDS, N, FLOOR } from './cards.mjs';

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

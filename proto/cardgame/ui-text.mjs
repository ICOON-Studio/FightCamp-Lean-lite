// The page's words. Pure: no document, no game state, so node can import this module and a broken import fails the
// test. Every line the player reads about a card is built here, from the same CARDS the engine plays.
import { CARDS, N, FLOOR, STYLES, MOVE } from './cards.mjs';
import { TRAINING, cardVariant } from './career.mjs';
import { PLACES_PICTURE, guideLines, volleyThreat, threatLine } from './guide.mjs';
import { WORDS, GUARD_WORDS } from './board.mjs';
import { placeKey, keyWords, legalNow } from './engine.mjs';

export const esc = (s) => String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
// ROUND 9 (item 7): no codes on the screen, ever. A place is printed in plain fight words - the standing ranges by the
// name fighters use, the ground places by what the two bodies are doing (board.mjs WORDS is the one table of them).
const RANGE = { K: 'at kicking range', P: 'at punching range', C: 'in the clinch', over: 'standing over a man who is down', gt: 'in his guard, on top', gb: 'in his guard, underneath', past: 'past his guard', pin: 'pinned under him', down: 'on the floor, apart' };
// the two engine answers are not cards: the page used to look them up in CARDS and die on the missing key
const STEP = {
  '@in': 'Step in a range (over a grounded man: follow him down)',
  '@out': 'Step out of a range or the clinch (over a grounded man: walk away)',
  '@stand': 'stand up in his guard - the legs still round you, and your turn ends here',
  '@back': 'back away out of his legs, out of the reach of his feet',
  '@up': 'get up: it takes your turn, and he may punch you as you rise',
  '@cover': `a strike lands for ${N.cover} less`,
  '@break': 'break a submission: pay its price in wind; both stay down, he one layer back',
  '@pull': 'pull guard off a tie that has stood a turn, or sit down with none',
  '@frame': 'frame off his tie: it fails, and you both stay where you are',
  '@base': 'keep your base: his pull or his sweep fails',
  '@escape': 'fight the hold as he puts it on: it fails, and he stays where he is',
  '@kick': `kick up off your back: ${N.kickDmg} damage, no card needed`,
};
export const isStep = (id) => typeof id === 'string' && id[0] === '@';
export const names = (id) => (isStep(id) ? FLOOR[id] || id : CARDS[id]?.n || id);
export function cardText(id) {
  if (isStep(id)) return `${FLOOR[id] || id} · ${STEP[id] || 'a step'}`;
  const c = CARDS[id];
  if (!c) return String(id);
  const at = c.at ? c.at.map((x) => RANGE[typeof x === 'string' ? x : x.p] || x).join(' / ') : 'ANSWER';
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
// ---- round 9, item 7: WHERE EACH MAN IS, in plain fight words (audit 4a-4c) ------------------------------
// The one-switch strip is gone. Two lines: the player's own place and the other man's, each in the words a corner
// speaks, with the join between them (ranges, the clinch and who holds the tie, leg reach, the guard's kind).
export function joinWords(S) {
  const j = S.j, me = S.at[0], him = S.at[1];
  if (j.kind === 'clinch') return j.by === 0 ? 'you have the tie' : j.by === 1 ? 'he has the tie' : 'no tie held';
  if (j.kind === 'entangled') return j.g ? GUARD_WORDS[j.g] : j.top === 'back' ? 'you have his back' : j.top === 'mount' ? 'he is mounted under you' : 'side control';
  if (me === 'stand' && him === 'stand') return j.reach === 'K' ? 'apart at kicking range' : 'apart at punching range';
  if ((me === 'stand' || him === 'stand') && (j.leg === true || j.leg === false)) return j.leg ? 'inside the reach of his feet' : 'out of reach of his feet';
  return 'apart';
}
export function whereLine(S, who = 0) {
  const me = who === 0, at = S.at[who];
  const words = me ? WORDS[at].own : WORDS[at].him;
  return `${me ? 'You' : 'He'}: ${words}`;
}
// the two lines, the way the page prints them: "You: standing, out of reach of his feet. He: on his back."
export function whereEachIs(S, extra = '') {
  const j = S.j, leg = j.leg === true ? ', inside the reach of his feet' : j.leg === false ? ', out of reach of his feet' : '';
  return `<span class="where${extra ? ' ' + extra : ''}" id="range"><b>${esc(whereLine(S, 0))}${esc(leg && ((S.at[0] === 'stand') !== (S.at[1] === 'stand')) ? (S.at[1] === 'stand' ? ', out of reach of his feet' : '') : '')}</b> · <b>${esc(whereLine(S, 1))}</b><small>${esc(joinWords(S))}</small></span>`;
}
// the picture on the How to play page: the paper's own list of places (no switch, no light)
export function placePicture(extra = '') {
  return `<span class="rangestrip${extra ? ' ' + extra : ''}" id="range">${PLACES_PICTURE.map((w) => `<span class="range-cell">${w}</span>`).join('')}</span>`;
}
// a move's name follows the STATE (audit 4c, 6): Step in over a grounded man reads Follow him down, Step out reads Walk
// away, Pull guard with no tie reads Sit down. Never a new button: the same button, the state's name.
export function moveName(S, m, id) {
  const me = S.at[m], him = S.at[1 - m], j = S.j;
  if (id === '@in') { if (me === 'stand' && (him === 'seat' || him === 'back')) return j.leg ? 'Follow him down' : 'Step in'; return 'Step in'; }
  if (id === '@out') { if (me === 'stand' && (him === 'seat' || him === 'back')) return 'Walk away'; if (me === 'stand' && him === 'gbot') return 'Back away'; if (j.kind === 'clinch') return 'Step out of the clinch'; return 'Step out'; }
  if (id === '@pull') return S.tie && S.tie.by === m ? 'Pull guard' : 'Sit down';
  if (id === '@stand') return 'Stand up in the guard';
  return FLOOR[id] || id;
}
export const namesIn = (S, m, id) => moveName(S, m, id);
// the old name, kept for the parts of the page that only want a label: the state-free name of a move
export const rangeStrip = (key, extra = '') => placePicture(extra);
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

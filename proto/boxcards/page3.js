// BOXCARDS3 page (step A): you against the reading bot. THE DEFENCE IS LAID, NOT ASKED: when he leads you see how many
// cards and his first one, and lay your answers under them; then both lines turn over. No "take it" button.
import { N, CARDS, DECK, newBout, exchange, bell, verdict, volleyCost, slipCost, nextLead, tick, legalVolley, legalLine, ansCost } from './rules3.mjs';
import { reader } from './bot3.mjs';
const TXT = { jab: '1 point, 1 health. Never countered, never out-stepped.', cross: '2 points, 3 health.', hook: '2 points, 3 health.', body: '1 point. His stamina bar 1 shorter all bout. A block does not stop it.',
  upper: '2 points, 4 health. A block does not stop it.', feint: 'Lands nothing. It draws out whatever he laid against it.', block: 'Stops one head punch. Wasted on a body hook or uppercut.',
  slip: 'One punch misses. Add a punch of yours: it lands and his volley ends.', step: 'His punch falls short, his volley ends. Wasted on a jab. Puts you on the ropes.', clinch: 'Smothers his punch, his volley ends. Not against his first card.' };
const $ = (id) => document.getElementById(id), who = ['You', 'He'], nm = (id) => CARDS[id].n, bot = reader();
const seed0 = +(new URLSearchParams(location.search).get('seed') || 0);
let seed = seed0 || Math.floor(Math.random() * 1e6);
let S, lead, a, x, phase, pick = [], pickIdx = [], lines = [], lastText = '', note = '';
let his = null;    // while he leads: { volley, line: your answers by place, sel: the place you are filling }
let last = null;   // the exchange just turned over: { volley, line, mine }
const say = (e) => { const you = e.k === 0, w = who[e.k], c = e.id && nm(e.id), my = you ? 'Your' : 'His'; return ({ rest: `${w} take${you ? '' : 's'} a breather (2 points to ${you ? 'him' : 'you'})`, feint: `${w} feint${you ? '' : 's'}`,
  drawn: `${my} ${c} is drawn out by the feint`, clinch: `${w} tie${you ? '' : 's'} up before the ${c} lands`, warned: `the referee takes a point from ${you ? 'you' : 'him'} for holding`, slipped: `${w} slip${you ? '' : 's'} the ${c}`,
  counter: `${w} counter${you ? '' : 's'}`, traded: `${w} fire${you ? '' : 's'} back`, short: `${my} ${c} falls short`, wasted: `${my} ${c} is wasted`, body: `${my} ${c} lands to the body`, clean: `${my} ${c} lands clean`,
  blocked: `${my} ${c} is blocked`, knockdown: you ? 'YOU ARE DOWN' : 'HE IS DOWN', count: `${w} lose${you ? '' : 's'} the lead to the count`, kept: `${w} keep${you ? '' : 's'} ${e.n} card${e.n > 1 ? 's' : ''} unthrown` }[e.t]); };
const aname = (x) => !x ? 'No defence' : x.trade ? 'Trade: your ' + nm(x.id) : x.with ? 'Slip + ' + nm(x.with) : nm(x.id);
const log = (t, cls = '') => lines.unshift({ t, cls });
const sentence = (ev) => ev.map(say).join('; ') + '.';

function start() { S = newBout(seed, seed % 2); lead = S.first; S.round = 1; log(`Round 1. ${who[lead]} lead${lead ? 's' : ''} first.`, 'bell'); a = lead; x = 0; step(); }
function step() {
  if (S.over) return end(S.over);
  if (x === 2 * N.leads) {
    const sc = bell(S); log(`BELL. The judges give the round ${sc[0]}-${sc[1]}.`, 'bell');
    if (S.round === N.rounds) return end(verdict(S));
    S.round++; lead = nextLead(S, lead);
    log(`Round ${S.round}. ${who[lead]} lead${lead ? 's' : ''} first.`, 'bell'); a = lead; x = 0;
  }
  tick(S, x); pick = []; pickIdx = []; his = null; note = '';
  if (S.f[a].skip) { S.f[a].skip = 0; const t = say({ t: 'count', k: a }); log(t + '.'); last = null; return shown(t + '.'); }
  if (a === 1) { const volley = bot.lead(S, 1);
    if (!volley.length) { const ev = exchange(S, 1, [], null); log(sentence(ev)); last = null; return shown(sentence(ev)); }
    his = { volley, line: volley.map(() => null), sel: 0 }; phase = 'lay'; return render(); }
  phase = 'lead'; render();
}
function turnOver() { const line = his.line.map((v) => v && { ...v }), ev = exchange(S, 1, [...his.volley], line);
  log('He leads ' + his.volley.map(nm).join(' - ') + '. ' + sentence(ev)); last = { volley: his.volley, line, mine: false, kept: ev.find((e) => e.t === 'kept')?.n || 0 }; shown(sentence(ev)); }
function throwIt() { const v = [...pick]; if (!legalVolley(S, 0, v)) return; const xo = {}, ev = exchange(S, 0, v, bot.lay, xo);
  log((v.length ? 'You lead ' + v.map(nm).join(' - ') + '. ' : '') + sentence(ev)); last = v.length ? { volley: v, line: xo.line, mine: true, kept: ev.find((e) => e.t === 'kept')?.n || 0 } : null; shown(sentence(ev)); }
function shown(text) { phase = 'shown'; lastText = text; x++; a = 1 - a; render(); }
function end(v) { phase = 'over'; const t = v.t ? ' ' + v.t.join('-') : ''; lastText = v.win < 0 ? 'A DRAW' + t : `${v.win === 0 ? 'YOU WIN' : 'HE WINS'} by ${v.how}${t}`; log(lastText, 'bell'); render(); }

// laying your defence: a hand card goes on the place you have picked
function why(line) { const m = S.f[0]; let w = 0, steps = 0; line.forEach((v) => { w += ansCost(m, v); if (v?.id === 'step') steps++; });
  return w > m.wind ? 'Not enough stamina for that.' : steps > 1 ? 'Only one step back in a line.' : line.some((v) => v?.id === 'step') && m.ropes ? 'You are on the ropes: no step back.'
    : line.some((v, i) => v?.id === 'clinch' && (i === 0 || m.held)) ? (m.held ? 'No clinch twice running.' : 'No clinch against his first card.') : 'You do not hold that card twice.'; }
function place(id) { const i = his.sel, cur = his.line[i], k = CARDS[id].k; let v;
  if (k === 'ans') v = { id }; else if (k === 'punch' && cur?.id === 'slip') v = { id: 'slip', with: id }; else if (k === 'punch' && i === 0 && (id === 'cross' || id === 'hook')) v = { id, trade: 1 };
  else { note = k === 'punch' ? 'A punch goes on a Slip (a counter)' + (i === 0 ? '.' : ', or a Cross or Lead hook against his first card (a trade).') : 'A feint is for your own lead.'; return render(); }
  const line = his.line.map((o, j) => (j === i ? v : o));
  if (!legalLine(S, 0, line, line.length)) { note = why(line); return render(); }
  his.line = line; note = ''; render(); }
const usedIn = (line) => line.flatMap((v) => (!v ? [] : v.with ? [v.id, v.with] : [v.id]));

function man(el, k) { const m = S.f[k], pips = []; for (let i = 0; i < N.cap; i++) pips.push(`<span class="pip ${i < m.wind ? 'on' : i >= m.cap ? 'gone' : ''}"></span>`);
  const hp = []; for (let i = 0; i < N.kdAt; i++) hp.push(`<span class="pip ${i < N.kdAt - m.daze ? 'hp' : ''}"></span>`);
  const tags = [m.hurt ? '<span class="tag bad" title="Has been down this round: no health comes back before the bell">hurt</span>' : '', m.ropes ? '<span class="tag bad" title="No second step back until he has led">on the ropes</span>' : '',
    m.held ? '<span class="tag" title="No clinch twice running">just clinched</span>' : '', m.holds ? `<span class="tag" title="The third hold in a round costs a point">holds ${m.holds}</span>` : '', m.kds ? `<span class="tag bad">down ${m.kds}x</span>` : ''].join('');
  const used = Object.keys(DECK).map((id) => { const n = m.pile.filter((c) => c === id).length; return n ? `${nm(id)} ${n} of ${DECK[id]}` : ''; }).filter(Boolean).join(', ');
  el.innerHTML = `<h2>${k ? 'Him' : 'You'}</h2><div><span class="lab" title="Every clean head punch takes some. At 0 a big punch puts him down. A little comes back between exchanges.">Health ${Math.max(0, N.kdAt - m.daze)} of ${N.kdAt}</span><div class="pips">${hp.join('')}</div></div>
    <div><span class="lab" title="Pays for every card. 3 comes back before each exchange. A body punch shortens the bar for the whole bout.">Stamina ${m.wind} of ${m.cap}</span><div class="pips">${pips.join('')}</div></div>
    <div><span class="lab">This round</span><div><b>${m.pts}</b> points, ${m.thrown} punches thrown</div></div><div>${tags}</div>
    <div class="used"><span class="lab">${k ? 'Cards he has played' : 'Cards you have played'}</span><br>${used || 'none yet'}</div>`; }
const face = (id, extra = '', cls = '', n = '') => `<button class="card ${cls}" ${extra}><span class="w">${id === 'slip' ? slipCost(S.f[0]) : CARDS[id].w} stamina</span><b>${nm(id)}</b><small>${TXT[id]}</small>${n ? `<span class="n">${n}</span>` : ''}</button>`;
const slot = (v, i, cls = '', extra = '') => `<button class="slot ${v ? 'full' : ''} ${cls}" ${extra} data-s="${i}"><b>${aname(v)}</b>${v ? '' : '<small>it lands if it is a punch</small>'}</button>`;
const rows = (top, bottom, labTop, labBottom) => `<div class="row"><span class="lab rl">${labTop}</span>${top}</div><div class="row"><span class="lab rl">${labBottom}</span>${bottom}</div>`;
function render() {
  $('where').innerHTML = `Round <b>${S.round}</b> of ${N.rounds} - exchange <b>${Math.min(x + (phase === 'shown' || phase === 'over' ? 0 : 1), 6)}</b> of 6`;
  $('rounds').innerHTML = S.cards.map((c, i) => `<span>R${i + 1}: you ${c[0]}-${c[1]}</span>`).join('');
  man($('you'), 0); man($('him'), 1);
  const me = S.f[0];
  $('lines').innerHTML = lines.map((l) => `<div class="${l.cls}">${l.t}</div>`).join(''); $('opts').innerHTML = ''; $('acts').innerHTML = '';
  if (phase === 'lead') {
    const cost = volleyCost(pick);
    $('said').textContent = 'Your lead: up to three cards, in order. He sees the first one and how many follow.';
    $('volley').innerHTML = pick.map((id) => face(id, 'disabled', 'pick')).join('') + (pick.length ? `<span class="lab">${cost} stamina if all turn</span>` : '');
    $('hand').innerHTML = me.hand.map((id, i) => { const isAns = CARDS[id].k === 'ans', n = pickIdx.indexOf(i) + 1; const no = isAns || (!n && (pick.length >= N.volley || cost + CARDS[id].w > me.wind)); return face(id, `data-i="${i}"`, (n ? 'pick ' : '') + (no ? 'no ' : '') + (isAns ? 'ans' : ''), n || ''); }).join('');
    $('acts').innerHTML = `<button class="btn" id="rest" title="Stamina back and a fresh hand. The judges give him 2 points.">Breather (+${N.rest} stamina, new hand, 2 points to him)</button> <button class="btn go" id="go" ${legalVolley(S, 0, pick) && pick.length ? '' : 'disabled'}>Throw it</button>`;
    $('go').onclick = throwIt; $('rest').onclick = () => { pick = []; pickIdx = []; throwIt(); };
    for (const b of $('hand').querySelectorAll('.card')) b.onclick = () => toggle(+b.dataset.i);
  } else if (phase === 'lay') {
    const n = his.volley.length, laid = usedIn(his.line), cost = his.line.reduce((s, v) => s + ansCost(me, v), 0), left = [...laid];
    $('said').textContent = `He leads with a ${nm(his.volley[0])}${n > 1 ? ` and ${n - 1} more face down` : ''}. Lay your defence under his cards.`;
    $('volley').innerHTML = rows(his.volley.map((id, i) => (i === 0 ? face(id, 'disabled', 'now') : '<span class="card down"></span>')).join(''),
      his.line.map((v, i) => slot(v, i, i === his.sel ? 'sel' : '')).join(''), 'His cards', 'Your defence') + `<span class="lab">${note || (cost ? cost + ' stamina if all are used' : 'pick a place, then a card from your hand - or leave it empty')}</span>`;
    $('hand').innerHTML = me.hand.map((id, i) => { const j = left.indexOf(id), on = j >= 0; if (on) left.splice(j, 1); return face(id, `data-i="${i}"`, (on ? 'pick ' : '') + (CARDS[id].k === 'ans' ? 'ans' : '')); }).join('');
    $('acts').innerHTML = `<button class="btn go" id="go">Turn them over</button>`;
    $('go').onclick = turnOver;
    for (const b of $('volley').querySelectorAll('.slot')) b.onclick = () => { const i = +b.dataset.s; if (his.sel === i && his.line[i]) his.line[i] = null; his.sel = i; note = ''; render(); };
    for (const b of $('hand').querySelectorAll('.card')) b.onclick = () => { if (!b.classList.contains('pick')) place(me.hand[+b.dataset.i]); };
  } else {
    $('said').textContent = lastText;
    $('volley').innerHTML = !last ? '' : rows(last.volley.map((id, i) => (i < last.volley.length - last.kept ? face(id, 'disabled') : '<span class="card down"></span>')).join(''),
      last.line.map((v, i) => slot(v, i, 'done', 'disabled')).join(''), last.mine ? 'Your cards' : 'His cards', last.mine ? 'His defence' : 'Your defence');
    $('hand').innerHTML = me.hand.map((id) => face(id, 'disabled')).join('');
    $('acts').innerHTML = phase === 'over' ? '<button class="btn go" id="again">Another bout</button>' : '<button class="btn go" id="next">Next</button>';
    if (phase === 'over') $('again').onclick = () => { seed = Math.floor(Math.random() * 1e6); lines = []; last = null; start(); }; else $('next').onclick = step;
  }
}
function toggle(i) { const me = S.f[0], id = me.hand[i]; if (CARDS[id].k === 'ans') return; const p = pickIdx.indexOf(i);
  if (p >= 0) pickIdx.splice(p, 1); else { if (pickIdx.length >= N.volley || volleyCost(pick) + CARDS[id].w > me.wind) return; pickIdx.push(i); }
  pick = pickIdx.map((j) => me.hand[j]); render(); }
window.addEventListener('keydown', (e) => { if (e.key === 'Enter') (document.getElementById('next') || document.getElementById('go'))?.click(); });
start();

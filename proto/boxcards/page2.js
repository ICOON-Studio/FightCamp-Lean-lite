// BOXCARDS2 page: you against the reading bot. His volley lies face down and turns one punch at a time; every answer
// shows what it does and costs before you lay it. The bot reads its own hand and the table only (bot2.mjs).
import { N, CARDS, DECK, newBout, answers, exchange, bell, verdict, volleyCost, slipCost, nextLead, tick, legalVolley } from './rules2.mjs';
import { reader, clone } from './bot2.mjs';
const TXT = { jab: '1 point. Never countered, never out-stepped.', cross: '2 points, head 3.', hook: '2 points, head 3.', body: '1 point. His wind bar 1 shorter all bout. A block does not stop it.',
  upper: '2 points, head 4. A block does not stop it.', feint: 'Lands nothing. Your next punch turns hidden: he answers blind.', block: 'Stops one head punch. Wasted on a body hook or uppercut.',
  slip: 'One punch misses. Add a punch of yours: it lands and his volley ends.', step: 'His punch falls short, his volley ends. Puts you on the ropes.', clinch: 'Smothers his punch, his volley ends. Not on his first card.' };
const $ = (id) => document.getElementById(id), who = ['You', 'He'], nm = (id) => CARDS[id].n, bot = reader();
const seed = +(new URLSearchParams(location.search).get('seed') || Math.floor(Math.random() * 1e6));
let S, lead, a, x, phase, pick = [], pickIdx = [], lines = [], lastText = '';
let his = null;   // while he leads: { volley, given: [your answers so far], view: the punch waiting for you, ev: what has happened }
const STOP = { stop: 1 };
const say = (e) => { const you = e.k === 0, w = who[e.k], c = e.id && nm(e.id), my = you ? 'Your' : 'His'; return ({ rest: `${w} take${you ? '' : 's'} a breather (2 points to ${you ? 'him' : 'you'})`, feint: `${w} feint${you ? '' : 's'}`,
  clinch: `${w} tie${you ? '' : 's'} up before the ${c} lands`, warned: `the referee takes a point from ${you ? 'you' : 'him'} for holding`, slipped: `${w} slip${you ? '' : 's'} the ${c}`, counter: `${w} counter${you ? '' : 's'}`,
  traded: `${w} fire${you ? '' : 's'} back`, short: `${my} ${c} falls short`, wasted: `${my} ${c} is wasted`, body: `${my} ${c} lands to the body`, clean: `${my} ${c} lands clean`, blocked: `${my} ${c} is blocked`,
  knockdown: you ? 'YOU ARE DOWN' : 'HE IS DOWN', count: `${w} lose${you ? '' : 's'} the lead to the count`, kept: `${w} keep${you ? '' : 's'} ${e.n} card${e.n > 1 ? 's' : ''} unthrown` }[e.t]); };
const aname = (x) => !x.id ? 'Take it' : x.trade ? 'Trade: fire your ' + nm(x.id) : x.with ? 'Slip and counter with your ' + nm(x.with) : nm(x.id);
const acost = (x, m) => !x.id ? 0 : x.id === 'slip' ? slipCost(m) + (x.with ? CARDS[x.with].w : 0) : CARDS[x.id].w;
const log = (t, cls = '') => lines.unshift({ t, cls });
const sentence = (ev) => ev.map(say).join('; ') + '.';

function start() { S = newBout(seed, seed % 2); lead = S.first; S.round = 1; log(`Round 1. ${who[lead]} lead${lead ? 's' : ''} first.`, 'bell'); a = lead; x = 0; step(); }
function step() {
  if (S.over) return end(S.over);
  if (x === 2 * N.leads) {
    const sc = bell(S); log(`BELL. The judges give the round ${sc[0]}-${sc[1]}.`, 'bell');
    if (S.round === N.rounds) return end(verdict(S));
    S.round++; const was = lead; lead = nextLead(S, lead);
    log(`Round ${S.round}. ${who[lead]} lead${lead ? 's' : ''} first.`, 'bell'); a = lead; x = 0;
  }
  tick(S, x); pick = []; pickIdx = []; his = null;
  if (S.f[a].skip) { S.f[a].skip = 0; const t = say({ t: 'count', k: a }); log(t + '.'); return shown(t + '.'); }
  if (a === 1) { his = { volley: bot.lead(S, 1), given: [] }; return ask(); }
  phase = 'lead'; render();
}
// he leads: replay the answers you have given on a copy until the next punch waits for you, or the exchange is over
function ask() {
  const T = clone(S), ev = []; let i = 0, view = null;
  try { exchange(T, 1, [...his.volley], (t, d, v) => { if (i < his.given.length) return his.given[i++]; view = v; throw STOP; }, { ev }); }
  catch (e) { if (e !== STOP) throw e; }
  his.ev = ev; his.view = view;
  if (!view) { let j = 0; const real = exchange(S, 1, [...his.volley], () => his.given[j++]); log('He leads. ' + sentence(real)); return shown(sentence(real)); }
  phase = 'answer'; render();
}
function preview(ans) { const T = clone(S), ev = []; let i = 0; const given = [...his.given, ans];
  try { exchange(T, 1, [...his.volley], () => { if (i < given.length) return given[i++]; throw STOP; }, { ev }); } catch (e) { if (e !== STOP) throw e; }
  const news = ev.slice(his.ev.length).filter((e) => e.t !== 'feint'); return news.length ? sentence(news) : 'Nothing lands.'; }
function throwIt() { const v = [...pick]; if (!legalVolley(S, 0, v)) return; const ev = exchange(S, 0, v, bot.answer);
  log((v.length ? 'You lead ' + v.map(nm).join(' - ') + '. ' : '') + sentence(ev)); shown(sentence(ev), v); }
function shown(text, mine) { phase = 'shown'; lastText = text; lastMine = mine || null; x++; a = 1 - a; render(); }
let lastMine = null;
function end(v) { phase = 'over'; const t = v.t ? ' ' + v.t.join('-') : ''; lastText = v.win < 0 ? 'A DRAW' + t : `${v.win === 0 ? 'YOU WIN' : 'HE WINS'} by ${v.how}${t}`; log(lastText, 'bell'); render(); }

function man(el, k) { const m = S.f[k], pips = []; for (let i = 0; i < N.cap; i++) pips.push(`<span class="pip ${i < m.wind ? 'on' : i >= m.cap ? 'gone' : ''}"></span>`);
  const dz = []; for (let i = 0; i < N.kdAt; i++) dz.push(`<span class="pip ${i < m.daze ? 'dz' : ''} ${i === N.kdAt - 1 ? 'line' : ''}"></span>`);
  const tags = [m.hurt ? '<span class="tag bad" title="Has been down this round: the head does not clear before the bell">hurt</span>' : '', m.ropes ? '<span class="tag bad" title="No second step back until he has led">on the ropes</span>' : '',
    m.held ? '<span class="tag" title="No clinch twice running">just clinched</span>' : '', m.holds ? `<span class="tag" title="The third hold in a round costs a point">holds ${m.holds}</span>` : '', m.kds ? `<span class="tag bad">down ${m.kds}x</span>` : ''].join('');
  const used = Object.keys(DECK).map((id) => { const n = m.pile.filter((c) => c === id).length; return n ? `${nm(id)} ${n} of ${DECK[id]}` : ''; }).filter(Boolean).join(', ');
  el.innerHTML = `<h2>${k ? 'Him' : 'You'}</h2><div><span class="lab" title="Pays for every card. 3 comes back before each exchange. A body punch shortens the bar for the whole bout.">Wind ${m.wind} of ${m.cap}</span><div class="pips">${pips.join('')}</div></div>
    <div><span class="lab" title="A clean big punch that fills the bar to the gold line puts him down.">Head ${m.daze} of ${N.kdAt}</span><div class="pips">${dz.join('')}</div></div>
    <div><span class="lab">This round</span><div><b>${m.pts}</b> points, ${m.thrown} punches thrown</div></div><div>${tags}</div>
    <div class="used"><span class="lab">${k ? 'Cards he has played' : 'Cards you have played'}</span><br>${used || 'none yet'}</div>`; }
const face = (id, extra = '', cls = '', n = '') => `<button class="card ${cls}" ${extra}><span class="w">${id === 'slip' ? slipCost(S.f[0]) : CARDS[id].w} wind</span><b>${nm(id)}</b><small>${TXT[id]}</small>${n ? `<span class="n">${n}</span>` : ''}</button>`;
const down = (n) => Array(n).fill('<span class="card down"></span>').join('');
function render() {
  $('where').innerHTML = `Round <b>${S.round}</b> of ${N.rounds} - exchange <b>${Math.min(x + (phase === 'shown' || phase === 'over' ? 0 : 1), 6)}</b> of 6`;
  $('rounds').innerHTML = S.cards.map((c, i) => `<span>R${i + 1}: you ${c[0]}-${c[1]}</span>`).join('');
  man($('you'), 0); man($('him'), 1);
  const me = S.f[0];
  $('lines').innerHTML = lines.map((l) => `<div class="${l.cls}">${l.t}</div>`).join(''); $('opts').innerHTML = ''; $('acts').innerHTML = '';
  if (phase === 'lead') {
    const cost = volleyCost(pick);
    $('said').textContent = 'Your lead: up to three cards, in order. He will see them one at a time.';
    $('volley').innerHTML = pick.map((id) => face(id, 'disabled', 'pick')).join('') + (pick.length ? `<span class="lab">${cost} wind if all turn</span>` : '');
    $('hand').innerHTML = me.hand.map((id, i) => { const isAns = CARDS[id].k === 'ans', n = pickIdx.indexOf(i) + 1; const no = isAns || (!n && (pick.length >= N.volley || cost + CARDS[id].w > me.wind)); return face(id, `data-i="${i}"`, (n ? 'pick ' : '') + (no ? 'no ' : '') + (isAns ? 'ans' : ''), n || ''); }).join('');
    $('acts').innerHTML = `<button class="btn" id="rest" title="Wind back and a fresh hand. The judges give him 2 points.">Breather (+${N.rest} wind, new hand, 2 points to him)</button> <button class="btn go" id="go" ${legalVolley(S, 0, pick) && pick.length ? '' : 'disabled'}>Throw it</button>`;
    $('go').onclick = throwIt; $('rest').onclick = () => { pick = []; pickIdx = []; throwIt(); };
    for (const b of $('hand').querySelectorAll('.card')) b.onclick = () => toggle(+b.dataset.i);
  } else if (phase === 'answer') {
    const v = his.view, turned = [...v.seen, v.shown];
    $('said').textContent = v.shown ? `His ${nm(v.shown)} is coming.${v.left ? ' ' + v.left + ' more face down.' : ' It is his last card.'}` : `He feinted: a hidden punch is coming.${v.left ? ' ' + v.left + ' more face down.' : ''}`;
    $('volley').innerHTML = turned.map((id, i) => id ? face(id, 'disabled', i === turned.length - 1 ? 'now' : '') : '<span class="card down now"></span>').join('') + down(v.left) + (his.ev.length ? `<span class="lab">${sentence(his.ev)}</span>` : '');
    $('hand').innerHTML = me.hand.map((id) => face(id, 'disabled', CARDS[id].k === 'ans' ? 'ans' : '')).join('');
    $('opts').innerHTML = v.legal.map((ans, i) => `<button class="opt" data-i="${i}"><b>${aname(ans)}${ans.id ? ' - ' + acost(ans, me) + ' wind' : ''}</b><small>${v.shown ? preview(ans) : blindText(ans)}</small></button>`).join('');
    for (const b of $('opts').querySelectorAll('.opt')) b.onclick = () => { his.given.push(v.legal[+b.dataset.i]); ask(); };
  } else {
    $('said').textContent = lastText;
    $('volley').innerHTML = (lastMine || (his ? his.volley.slice(0, his.volley.length - (his.ev.find((e) => e.t === 'kept')?.n || 0)) : [])).map((id) => face(id, 'disabled')).join('');
    $('hand').innerHTML = me.hand.map((id) => face(id, 'disabled')).join('');
    $('acts').innerHTML = phase === 'over' ? '<button class="btn go" id="again">Another bout</button>' : '<button class="btn go" id="next">Next</button>';
    if (phase === 'over') $('again').onclick = () => { location.search = ''; }; else $('next').onclick = step;
  }
}
const blindText = (ans) => !ans.id ? 'Whatever it is, it lands.' : ans.id === 'block' ? 'Stops a jab, cross or hook. Wasted if it is a body hook or an uppercut.' : ans.id === 'step' ? 'It falls short and his volley ends - unless it is a jab.'
  : ans.id === 'clinch' ? 'Smothers it whatever it is; his volley ends.' : 'It misses whatever it is; his volley goes on.';
function toggle(i) { const me = S.f[0], id = me.hand[i]; if (CARDS[id].k === 'ans') return; const p = pickIdx.indexOf(i);
  if (p >= 0) pickIdx.splice(p, 1); else { if (pickIdx.length >= N.volley || volleyCost(pick) + CARDS[id].w > me.wind) return; pickIdx.push(i); }
  pick = pickIdx.map((j) => me.hand[j]); render(); }
window.addEventListener('keydown', (e) => { if (e.key === 'Enter') (document.getElementById('next') || document.getElementById('go'))?.click(); });
start();

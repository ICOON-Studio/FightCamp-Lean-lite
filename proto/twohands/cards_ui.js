// S574 the card fight page: draws table.mjs (proto/octagon, served at ./octagon/ by the junction or serve.py's /octagon/ map).
import { VERSIONS, TYPE, POOL, STYLES, CARDS, setRules, newGame, table, throwCard, autoKeep, autoSwap } from './octagon/table.mjs';
const $ = (id) => document.getElementById(id), q = new URLSearchParams(location.search);
const rules = setRules(VERSIONS[q.get('rules')] ? q.get('rules') : 'ours');
const ids = Object.keys(POOL), pickId = (v, d) => (POOL[v] ? v : d);
let me = pickId(q.get('me'), 'metronome'), him = pickId(q.get('him'), 'truck'), seed = +(q.get('seed') || Math.ceil(Math.random() * 9999));
const opt = (sel, list, val) => { sel.innerHTML = list.map(([v, t]) => `<option value="${v}"${v === val ? ' selected' : ''}>${t}</option>`).join(''); };
opt($('rules'), Object.entries(VERSIONS).map(([v, o]) => [v, o.label]), rules);
const fighterList = ids.map((id) => [id, `${POOL[id].n} - ${STYLES[POOL[id].style].n}`]);
opt($('me'), fighterList, me); opt($('him'), fighterList, him); $('seed').value = seed;
const url = () => `?rules=${$('rules').value}&me=${$('me').value}&him=${$('him').value}&seed=${$('seed').value}`;
$('rules').onchange = () => { location.search = url(); };   // a rule set changes the engine's tables: a fresh page
$('new').onclick = $('again').onclick = () => { if ($('seed').value == seed && me === $('me').value && him === $('him').value) $('seed').value = seed + 1; history.replaceState(null, '', url()); start(); };
$('q').onclick = () => { const h = $('help'); h.style.display = h.style.display === 'block' ? 'none' : 'block'; };

let G, sel = null, combo = [], keep, swap;
function start() { me = $('me').value; him = $('him').value; seed = +$('seed').value || 1; G = newGame({ seed, me, him }); sel = null; combo = []; keep = swap = undefined;
  $('over').style.display = 'none'; $('result').innerHTML = '<span class="n">Pick a card, then Throw (or press Enter).</span>'; $('log').innerHTML = ''; draw(); }

const esc = (s) => String(s).replace(/[&<>"]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' })[c]);
const nm = (id) => (CARDS[id] ? CARDS[id].n : id), chip = (id) => (CARDS[id] ? `<span class="chip ${CARDS[id].type}" title="${esc(CARDS[id].t)}">${esc(CARDS[id].n)}</span>` : '');
const bar = (lab, v, m, col) => `<div class="bar"><div class="t"><span>${lab}</span><span>${v} / ${m}</span></div><div class="g"><i style="width:${Math.max(0, 100 * v / m)}%;background:${col}"></i></div></div>`;
function side(P, status, extra) { return `<div class="who"><b title="${esc(P.trait)}">${esc(P.name)}</b><span>${esc(P.style)}</span></div>`
  + bar('Head', P.head, P.headMax, '#c9584e') + bar('Body', P.body, P.bodyMax, '#c98a4e') + bar('Stamina', P.st, P.stMax, '#4e9bc9')
  + `<div class="pips" title="Room behind him before the ropes: at 0 he is pinned">Space to the ropes ${[0, 1, 2].map((i) => `<i class="${i < P.cage ? 'on' : ''}"></i>`).join('')}</div>`
  + `<div class="chips">${P.rocked ? '<span class="chip warn">ROCKED</span>' : ''}${status ? status.split(/, (?=[A-Z]{3})/).map((s) => `<span class="chip warn" title="${esc(s)}">${esc(s.split(' (')[0])}</span>`).join('') : ''}</div>` + (extra || ''); }

function draw() { const T = table(G);
  $('you').innerHTML = side(T.you, T.statusYou);
  const hisCards = T.hisLast.length ? `<div class="chips" title="His last cards, newest first">Last: ${T.hisLast.map(chip).join('')}</div>` : '';
  const reads = (T.cutShows ? `<div class="chips">His cut shows: ${chip(T.cutShows)}</div>` : '') + (T.readHand ? `<div class="chips">You read: ${T.readHand.map(chip).join('')}</div>` : '');
  $('hims').innerHTML = side(T.him, T.statusHim, `<div class="chips" style="color:var(--muted);font-size:.78rem">${T.him.cards} cards in hand</div>` + hisCards + reads);
  const lead = T.lead === 'none' ? 'nobody' : T.lead === 'you' ? '<b>You</b>' : '<b>Him</b>';
  const tell = T.tellYou ? `<div class="tell">Your tell: his card is <b style="color:${T.tellYou === 'AC' ? 'var(--A)' : 'var(--D)'}">${T.tellYou === 'AC' ? 'an Attack or a Counter' : 'a Feint or a Defend'}</b></div>`
    : T.tellHim ? '<div class="tell">His tell: he sees the colour of your card this time</div>' : '';
  $('ring').innerHTML = `<div class="rd">Round ${T.round} of ${T.rounds} &middot; exchange ${T.ex} of ${T.exchanges}</div>`
    + `<div class="range">${['long', 'mid', 'close'].map((r) => `<div class="${T.range === r ? 'on' : ''}">${r.toUpperCase()}</div>`).join('')}</div>`
    + `<div class="score"><span>Judges <b>${T.judges[0]} - ${T.judges[1]}</b></span><span title="Damage plus clean counters this round">This round <b>${T.thisRound[0]} - ${T.thisRound[1]}</b></span></div>`
    + `<div class="lead">The Lead: ${lead}</div>` + tell;
  const H = T.hand, selC = H.find((c) => c.id === sel && !c.why); if (!selC) { sel = null; combo = []; }
  const canCombo = selC && T.comboOk && selC.chain && selC.type === 'A';
  $('hand').innerHTML = H.map((c) => { const inCombo = combo.includes(c.id), dead = !!c.why && !inCombo;
    const rg = ['long', 'mid', 'close'].map((r) => `<i class="${(c.legal || []).includes(r) ? 'on' : ''}">${r[0].toUpperCase()}</i>`).join('');
    const sp = c.type === 'A' ? `<div class="spd ${c.now > c.spd ? 'up' : c.now < c.spd ? 'down' : ''}"><small>SPEED</small>${c.now}</div>` : `<div class="spd"><small>SPEED</small>${c.spd}</div>`;
    const short = c.dmg ? `${c.dmg} to the ${c.zone || 'head'}${c.type === 'C' ? ' if he attacks' : ''}` : c.type === 'D' ? (c.covers === 'none' ? 'blocks nothing' : 'blocks an attack') : c.type === 'F' ? 'beats a Counter or a Defend' : '';
    return `<div class="card ${c.type}${c.id === sel ? ' sel' : ''}${inCombo ? ' combo' : ''}${dead ? ' dead' : ''}" data-id="${c.id}" title="${esc(c.n + ' - ' + c.t + (c.why ? '\n\nNOT NOW: ' + c.why : ''))}">`
      + `<div class="band">${TYPE[c.type].toUpperCase()}${c.chain ? ' &middot; CHAIN' : ''}</div>${c.count > 1 ? `<span class="n2">x${c.count}</span>` : ''}${c.always ? '<span class="alw">ALWAYS THERE</span>' : ''}`
      + `<div class="nm">${esc(c.n)}</div><div class="row">${sp}<div class="cost">stamina<br><b style="color:var(--ink);font-size:1rem">${c.cost}</b></div></div><div class="rg">${rg}</div><div class="short">${short}</div></div>`; }).join('');
  [...$('hand').querySelectorAll('.card')].forEach((el) => { el.onclick = () => { const id = el.dataset.id, c = H.find((x) => x.id === id);
    if (canCombo && id !== sel && c.type === 'A' && c.count) { combo = combo.includes(id) ? combo.filter((x) => x !== id) : [...combo, id].slice(0, 2); return draw(); }
    if (c.why) return; sel = sel === id ? null : id; combo = []; keep = swap = undefined; draw(); }; el.ondblclick = () => { if (!H.find((x) => x.id === el.dataset.id).why) { sel = el.dataset.id; go(); } }; });
  const handIds = [...new Set(G.S.f[0].hand)];
  const keepOpts = handIds.filter((id) => id !== sel && ['C', 'D'].includes(CARDS[id].type)), deadOpts = handIds.filter((id) => id !== sel && H.find((x) => x.id === id && x.why));
  const k0 = keep === undefined ? autoKeep(G, sel) : keep, s0 = swap === undefined ? autoSwap(G, sel) : swap;
  const so = (list, val, none) => `<option value=""${!val ? ' selected' : ''}>${none}</option>` + list.map((id) => `<option value="${id}"${id === val ? ' selected' : ''}>${esc(nm(id))}</option>`).join('');
  $('plan').innerHTML = `<button id="go"${sel ? '' : ' disabled'}>Throw${sel ? ': ' + esc(nm(sel)) + (combo.length ? ' + ' + combo.map(nm).join(' + ') : '') : ''}</button>`
    + (canCombo ? `<span>Combo: click up to 2 more attacks</span>` : '')
    + `<label title="If he throws a combo, this card in your hand answers it">If he combos <select id="keep">${so(keepOpts, k0, 'nothing')}</select></label>`
    + `<label title="Throw away one card you cannot use now and draw a new one">Swap a dead card <select id="swap">${so(deadOpts, s0, 'no swap')}</select></label>`;
  $('go').onclick = go; $('keep').onchange = (e) => { keep = e.target.value || null; }; $('swap').onchange = (e) => { swap = e.target.value || null; };
  if (T.over) { const O = T.over; $('overt').textContent = O.winner === 'draw' ? 'A draw' : O.winner === 'you' ? 'You win' : 'He wins';
    $('overd').textContent = `by ${O.how.toLowerCase()}${O.score ? ' ' + Math.max(...O.score) + '-' + Math.min(...O.score) : ' in round ' + O.round}`; $('over').style.display = 'flex'; } }

function go() { if (!sel || G.over) return; const res = throwCard(G, { card: sel, then: combo, react: keep, discard: swap });
  if (res.error) { $('result').innerHTML = `<span class="h">Not now: ${esc(res.error)}</span>`; return; }
  const L = G.log[G.log.length - 1];
  $('result').innerHTML = `<span class="vs">R${L.round} E${L.ex}: ${esc(G.short[0])} ${esc(nm(res.you))} v ${esc(G.short[1])} ${esc(nm(res.him))}</span>` + res.lines.map((e) => `<span class="${e.k === 0 ? 'y' : e.k === 1 ? 'h' : 'n'}">${esc((e.who ? e.who + ' ' : '') + e.t)}</span>`).join('');
  $('log').insertAdjacentHTML('afterbegin', `<div>R${L.round} E${L.ex} &middot; you ${esc(nm(res.you))}, he ${esc(nm(res.him))} &middot; ${esc(res.lines.map((e) => (e.who ? e.who + ' ' : '') + e.t).join('; '))}</div>`);
  sel = null; combo = []; keep = swap = undefined; draw(); }
document.addEventListener('keydown', (e) => { if (e.key === 'Enter' && sel && !/SELECT|INPUT/.test(document.activeElement.tagName)) go(); if (e.key === 'Escape') $('help').style.display = 'none'; });
start();

/* FightCamp card game prototype - the page.
   A plain script (no modules, no build, no libraries) driven by rules.js.
   It only draws what the rules module reports; it makes no game decisions.
   Keys: 1-5 play a card from your hand, Enter is the same as the gold button. */
(function () {
  'use strict';
  var R = window.FightCampRules;
  var screenEl = document.getElementById('screen');
  var whereEl = document.getElementById('where');
  if (!R) {
    screenEl.textContent = 'rules.js did not load next to index.html';
    return;
  }
  var S = { screen: 'pick', game: null, fight: null, busy: false, reveal: null, pending: null, mode: 'react' };
  var STAT_KEYS = ['power', 'speed', 'stamina', 'chin', 'technique', 'defence'];
  var seedCount = 0;
  /* ---------- little helpers ------------------------------------------- */
  function h(tag, cls, text) {
    var el = document.createElement(tag);
    if (cls) el.className = cls;
    if (text !== undefined && text !== null) {
      if (text.nodeType === 1) el.appendChild(text); else el.textContent = text;
    }
    return el;
  }
  function clear(el) { while (el.firstChild) el.removeChild(el.firstChild); }
  function add(parent) { for (var i = 1; i < arguments.length; i++) if (arguments[i]) parent.appendChild(arguments[i]); return parent; }
  function bar(cls, ratio) {
    var b = h('div', 'bar ' + cls), i = h('i');
    i.style.width = Math.max(0, Math.min(100, Math.round(ratio * 100))) + '%';
    return add(b, i);
  }
  function meter(label, ratio, cls, word) {
    return add(h('div', 'meter'), h('span', 'lab', label), bar(cls, ratio), h('span', 'val', word));
  }
  function windWord(side) {
    var r = side.stamina / side.maxStamina;
    return side.stamina <= 0 ? 'empty' : r < 0.2 ? 'reeling' : r < 0.45 ? 'breathing hard' : r < 0.75 ? 'working' : 'fresh';
  }
  function headWord(side) { return side.head >= 70 ? 'badly hurt' : side.head >= 40 ? 'hurt' : side.head >= 18 ? 'marked up' : 'clean'; }
  function bodyWord(side) { return side.body >= 60 ? 'body badly hurt' : side.body >= 30 ? 'sore' : side.body >= 10 ? 'working' : 'fresh'; }
  function statWords(key, v) {
    var bands = {
      power: ['feather-fisted', 'ordinary', 'heavy hands', 'one-punch power'],
      speed: ['slow', 'ordinary', 'quick hands', 'lightning'],
      stamina: ['short wind', 'ordinary', 'big engine', 'relentless'],
      chin: ['glass jaw', 'ordinary', 'good chin', 'granite'],
      technique: ['raw', 'ordinary', 'sharp', 'textbook'],
      defence: ['easy to hit', 'ordinary', 'hard to hit', 'elusive']
    };
    var idx = v >= 80 ? 3 : v >= 66 ? 2 : v >= 52 ? 1 : 0;
    return bands[key][idx];
  }
  function deckCounts(deck) {
    var out = {}, order = [];
    deck.forEach(function (id) { if (!out[id]) { out[id] = 0; order.push(id); } out[id]++; });
    return { out: out, order: order };
  }
  function deckPeek(deck, extra) {
    var wrap = h('div', 'deckpeek'), c = deckCounts(deck);
    c.order.forEach(function (id) {
      var n = c.out[id] - ((extra && extra[id]) || 0);
      if (n > 0) wrap.appendChild(h('span', null, R.CARDS[id].name + ' x' + n));
    });
    for (var id in (extra || {})) if (extra[id] > 0) wrap.appendChild(h('span', null, '+' + R.CARDS[id].name + ' x' + extra[id]));
    return wrap;
  }
  function cardFace(id, opts) {
    opts = opts || {};
    var c = R.CARDS[id];
    var el = h(opts.tag || 'button', 'card ' + c.kind + (opts.small ? ' small' : ''));
    if (el.tagName === 'BUTTON') el.type = 'button';
    add(el,
      h('div', 'kind', R.KIND_LABEL[c.kind]),
      h('div', 'name', c.name),
      h('div', 'effect', c.effect),
      h('div', 'cost', String(opts.cost || c.cost)));
    if (opts.onClick) el.addEventListener('click', opts.onClick);
    if (opts.chosen) el.classList.add('chosen');
    return el;
  }
  function button(label, opts) {
    opts = opts || {};
    var b = h('button', 'btn' + (opts.primary ? ' primary' : ''), label);
    b.type = 'button';
    if (opts.onClick) b.addEventListener('click', opts.onClick);
    if (opts.disabled) b.disabled = true;
    return b;
  }
  function setWhere(text) { whereEl.textContent = text; }
  /* ---------- the pick screen ------------------------------------------- */
  var PICKABLE = ['ada', 'mara'];
  function renderPick() {
    setWhere('step 1 of 4 - pick your boxer');
    clear(screenEl);
    add(screenEl,
      h('h1', null, 'Pick your boxer'),
      h('p', 'lead muted', 'You are the coach. Your boxer does the fighting; you pick the camp, read the opponent, and shout the corners. Two fighters are free this month.'));
    var grid = h('div', 'pick');
    PICKABLE.forEach(function (id) {
      var b = R.boxerById(id);
      var card = h('button', 'fighter');
      card.type = 'button';
      add(card, add(h('div', 'who'), h('h2', null, b.name), h('span', 'style', R.STYLES[b.style].name)), h('div', 'muted', b.blurb));
      var grid2 = h('div', 'stats');
      STAT_KEYS.forEach(function (k) {
        add(grid2, h('div', null, k.charAt(0).toUpperCase() + k.slice(1) + ': ' + statWords(k, b.stats[k])),
          bar('', (b.stats[k] - 10) / 90));
      });
      add(card, grid2, h('div', 'tiny', 'Fight deck'), deckPeek(b.deck));
      card.addEventListener('click', function () { startGame(id); });
      grid.appendChild(card);
    });
    add(screenEl, grid);
    var how = h('div', 'sheet');
    add(how, h('div', 'tiny', 'How it plays'));
    add(how, h('p', 'muted', 'Camp: four weeks, one drill a week - the drills decide which cards your boxer brings. Scouting: you see the opponent’s style and some habits. Fight: three rounds of six exchanges, both corners play one card face down and turn them over together. Corner: one card between rounds, and each one costs something. Every card is a trade: what it is worth depends on the opponent’s card, the distance, and what you know from film.'));
    add(screenEl, how);
  }
  function startGame(boxerId) {
    seedCount += 1;
    var seed = (Date.now() % 100000) * 100 + seedCount;
    S.game = R.createGame({ seed: seed, playerBoxerId: boxerId });
    S.fight = null;
    S.reveal = null;
    S.screen = 'camp';
    render();
  }
  /* ---------- camp ------------------------------------------------------- */
  function renderCamp() {
    var g = S.game;
    setWhere('step 2 of 4 - fight camp, week ' + (g.week + 1) + ' of 4');
    clear(screenEl);
    var boxer = R.boxerById(g.playerBoxerId);
    add(screenEl, h('h1', null, 'Camp - week ' + (g.week + 1) + ' of 4'),
      h('p', 'lead muted', 'Four weeks, one drill a week. Training does not make you better at everything: it decides which cards your boxer brings to the fight.'));
    var layout = h('div', 'camp');
    var offers = h('div', 'offers');
    g.offers[g.week].forEach(function (id) {
      var c = null;
      R.CAMP_CARDS.forEach(function (x) { if (x.id === id) c = x; });
      var el = h('button', 'card ' + (c.add ? 'footwork' : c.stat ? 'defence' : 'corner'));
      el.type = 'button';
      add(el,
        h('div', 'kind', c.add ? 'Deck' : c.scout ? 'Deck + file' : 'Stat'),
        h('div', 'name', c.name),
        h('div', 'effect', c.text));
      el.addEventListener('click', function () {
        R.pickCampCard(g, id);
        S.screen = g.phase === 'scout' ? 'scout' : 'camp';
        render();
      });
      offers.appendChild(el);
    });
    var side = h('aside', 'side');
    add(side, h('div', 'tiny', boxer.name + ' - ' + R.STYLES[boxer.style].name));
    var statGrid = h('div', 'stats');
    STAT_KEYS.forEach(function (k) {
      var v = Math.min(99, boxer.stats[k] + (g.mods.stat[k] || 0));
      add(statGrid, h('div', null, k.charAt(0).toUpperCase() + k.slice(1)), bar('', (v - 10) / 90));
    });
    add(side, statGrid, h('div', 'tiny', 'Deck right now'));
    var deck = boxer.deck.slice();
    g.picks.forEach(function (pickId) {
      R.CAMP_CARDS.forEach(function (c) {
        if (c.id !== pickId) return;
        for (var id in (c.add || {})) for (var i = 0; i < c.add[id]; i++) deck.push(id);
      });
    });
    add(side, deckPeek(deck));
    if (g.picks.length) {
      add(side, h('div', 'tiny', 'Done so far'));
      var ul = h('ul', 'history');
      g.picks.forEach(function (id) {
        var name = id;
        R.CAMP_CARDS.forEach(function (c) { if (c.id === id) name = c.name; });
        ul.appendChild(h('li', null, '- ' + name));
      });
      add(side, ul);
    }
    add(layout, offers, side);
    add(screenEl, layout);
  }
  /* ---------- scouting file --------------------------------------------- */
  function renderScout() {
    var g = S.game, sc = g.scouting;
    setWhere('step 3 of 4 - the scouting file');
    clear(screenEl);
    add(screenEl, h('h1', null, 'The scouting file'),
      h('p', 'lead muted', sc.summary + ' A habit is not a weakness by itself: it forecasts the opponent’s choice in one situation.'));
    var layout = h('div', 'file');
    var sheet = h('div', 'sheet');
    add(sheet, h('h2', null, sc.name), h('div', 'stl muted', sc.styleName + ' - ' + (R.STYLES[sc.style].blurb)));
    add(sheet, h('div', 'muted', sc.blurb));
    var stats = h('div', 'stats');
    STAT_KEYS.forEach(function (k) {
      add(stats, h('div', null, k.charAt(0).toUpperCase() + k.slice(1) + ': ' + statWords(k, sc.stats[k])), bar('', (sc.stats[k] - 10) / 90));
    });
    add(sheet, stats);
    add(sheet, h('div', 'tiny', 'On film (' + sc.known.length + ' of ' + (sc.known.length + sc.fleeting) + ')'));
    var habits = h('div', 'habits');
    if (!sc.known.length) habits.appendChild(h('div', 'habit blank', 'Nothing on film. Read the opponent live.'));
    sc.known.forEach(function (k) { habits.appendChild(h('div', 'habit', k.text)); });
    if (sc.fleeting) habits.appendChild(h('div', 'habit blank', sc.fleeting === 1 ? 'One habit nobody has put on film for you.' : sc.fleeting + ' habits nobody has put on film for you.'));
    add(sheet, habits);
    var right = h('div', 'sheet');
    add(right, h('h2', null, 'Your corner'), h('div', 'muted', 'What camp built:'));
    var stats2 = h('div', 'stats');
    var me = R.boxerById(g.playerBoxerId);
    STAT_KEYS.forEach(function (k) {
      var v = Math.min(99, me.stats[k] + (g.mods.stat[k] || 0));
      add(stats2, h('div', null, k.charAt(0).toUpperCase() + k.slice(1) + ': ' + statWords(k, v)), bar('', (v - 10) / 90));
    });
    add(right, stats2, h('div', 'tiny', 'Your fight deck'), deckPeek(deckWithMods(me.deck, g.mods.add)));
    add(right, h('div', 'tiny', 'The plan'));
    add(right, h('p', 'muted', 'Three rounds, six exchanges a round. Slip the straight punches, roll the hooks, do not hook a man who is holding. Win the exchanges that suit you and stay off the ropes.'));
    add(layout, sheet, right);
    add(screenEl, layout);
    var start = h('div', 'row');
    start.appendChild(button('Touch gloves - start the fight', {
      primary: true,
      onClick: function () {
        S.fight = R.startFight(S.game);
        S.reveal = null;
        S.mode = 'react';
        S.screen = 'fight';
        render();
      }
    }));
    add(screenEl, start);
  }
  function deckWithMods(deck, add) {
    var out = deck.slice();
    for (var id in (add || {})) for (var i = 0; i < add[id]; i++) out.push(id);
    return out;
  }
  function conditionWords(condition) {
    var key = Object.keys(condition)[0];
    var cardName = function (id) { return R.CARDS[id] ? R.CARDS[id].name : 'card'; };
    var labels = { exchange: 'at the opening of a round', lastSelfCard: 'after the opponent’s own ' + cardName(condition.lastSelfCard),
      selfHurt: 'when hurt', lastTookClean: 'after taking a clean hit', selfLowStamina: 'when wind is low',
      inFightRange: 'at ' + condition.inFightRange + ' range', selfAhead: 'when ahead on damage', lastOppCard: 'after your ' + cardName(condition.lastOppCard) };
    return labels[key] || 'when the film condition is true';
  }
  /* ---------- the fight -------------------------------------------------- */
  function renderFight() {
    var f = S.fight, me = f.player, foe = f.opponent;
    var ex = f.phase === 'corner' || f.phase === 'over' ? 6 : Math.min(f.exchange + 1, 6);
    setWhere('step 4 of 4 - round ' + f.round + ' of 3, exchange ' + ex + ' of 6');
    clear(screenEl);
    var strip = h('div', 'scorestrip');
    add(strip, h('span', null, 'Round ' + f.round));
    var roundPips = h('div', 'pips');
    for (var r = 1; r <= 3; r++) { var p = h('i'); if (r < f.round) p.className = 'on'; if (r === f.round) p.className = 'now'; roundPips.appendChild(p); }
    add(strip, roundPips, h('span', null, 'Exchange ' + ex + ' of 6'));
    var exPips = h('div', 'pips');
    for (var e = 0; e < 6; e++) { var q = h('i'); if (e < ex) q.className = 'on'; exPips.appendChild(q); }
    add(strip, exPips);
    if (f.rounds.length) {
      var last = f.rounds[f.rounds.length - 1];
      add(strip, h('span', null, 'Judges: ' + last.scores.map(function (s) { return s[0] + '-' + s[1]; }).join(' / ')));
    }
    add(strip, h('span', 'spacer'));
    if (f.range !== 'mid') add(strip, h('span', null, f.range === 'out' ? 'Fighting at range' : 'Fighting inside'));
    var arena = h('div', 'arena');
    arena.appendChild(panel(me, false, f));
    var stage = h('div', 'stage');
    buildStage(stage, f);
    arena.appendChild(stage);
    arena.appendChild(panel(foe, true, f));
    var logWrap = h('div', 'logwrap');
    var hd = h('div', 'hd');
    add(hd, h('span', null, 'The corner'), h('span', 'spacer'));
    if (f.scouting.known.length) add(hd, h('span', null, 'On film: ' + f.scouting.known.map(function (k) { return k.text; }).join(' ')));
    var log = h('div', 'log');
    var shown = f.events.slice(-40);
    if (S.busy && S.pending) shown = shown.slice(0, -1);
    shown.forEach(function (ev) {
      var row = h('div');
      add(row, h('span', 'r', 'R' + ev.round + ' E' + (ev.exchange + 1)), h('span', 'tiny', 'Tell: ' + ev.tell.text), h('span', ev.knockdowns.length ? 'kd' : null, ev.text));
      log.appendChild(row);
    });
    add(logWrap, hd, log);
    var handWrap = h('div', 'handwrap');
    var handHd = h('div', 'handhd');
    add(handHd, h('span', null, 'Your hand'), h('span', 'spacer'), h('span', null, 'Wind ' + me.stamina + ' of ' + me.maxStamina),
      h('span', null, 'Keys 1-5 play a card'));
    var modeBar = h('div', 'row modebar');
    modeBar.appendChild(button('React — safe; Speed 65+ adds accuracy', { primary: S.mode === 'react', onClick: function () { S.mode = 'react'; renderFight(); } }));
    modeBar.appendChild(button('Predict — costs 2 wind; right read wins clean, wrong read exposes you', { primary: S.mode === 'predict', onClick: function () { S.mode = 'predict'; renderFight(); } }));
    modeBar.appendChild(h('span', 'small-note', 'Film forecasts: ' + R.CARDS[R.predictedCard(f)].name + ' (estimate only; no hidden hand is shown).'));
    var hand = h('div', 'hand');
    me.hand.forEach(function (id, i) {
      var cost = R.cardCost(me, id);
      var disabled = S.busy || f.phase !== 'fight';
      var el = cardFace(id, { cost: cost, onClick: function () { playCard(id); } });
      if (disabled) el.disabled = true;
      if (cost > me.stamina) { el.classList.add('gassed'); el.title = 'Not enough wind: this one goes out flat.'; }
      var key = h('div', 'small-note', (i + 1) + (cost > me.stamina ? ' - no wind' : ''));
      el.appendChild(key);
      hand.appendChild(el);
    });
    add(handWrap, handHd, modeBar, hand);
    var fit = h('div', 'fight');
    var reads = R.scoutingPrediction(f);
    var readBox = h('div', 'sheet reads');
    add(readBox, h('div', 'tiny', 'Opponent tell: ' + f.tell.text + ' (' + Math.round(f.tell.accuracy * 100) + '% reliable)'));
    if (reads.length) {
      add(readBox, h('div', 'tiny', 'Film read for this exchange'));
      reads.forEach(function (read) {
        add(readBox, h('div', 'readline', (read.active ? 'NOW: ' : 'IF: ') + 'Film says the opponent looks for ' + read.cardName +
          ' ' + conditionWords(read.condition) + ' — about ' + Math.round(read.chance * 100) + '% chance it is in the five-card hand.'));
      });
    } else add(readBox, h('div', 'muted', 'No habits on film; read the opponent from the exchanges.'));
    add(fit, strip, readBox, arena, logWrap, handWrap);
    add(screenEl, fit);
    log.scrollTop = log.scrollHeight;
  }
  function panel(side, isFoe, f) {
    var box = h('div', 'cornerbox' + (isFoe ? ' foe' : ''));
    add(box, h('div', 'nm', side.name), h('div', 'stl', side.styleName));
    var meters = h('div', 'meters');
    add(meters,
      meter('Wind', side.stamina / side.maxStamina, 'wind', windWord(side)),
      meter('Head', side.head / 100, 'hurt', headWord(side)),
      meter('Body', side.body / 100, 'hurt', bodyWord(side)));
    add(box, meters);
    var hits = h('div', 'small-note', side.totals.landed + ' landed of ' + side.totals.thrown + (side.knockdowns ? ' - down ' + side.knockdowns + 'x' : ''));
    add(box, hits);
    return box;
  }
  function buildStage(stage, f) {
    var slots = h('div', 'slots');
    var line = h('div', 'line'), verdict = h('div', 'verdict'), action = h('div', 'row');
    if (S.reveal) {
      var ev = S.reveal;
      slots.appendChild(cardFace(ev.player.card, { small: true, tag: 'div' }));
      slots.appendChild(cardFace(ev.opponent.card, { small: true, tag: 'div' }));
      line.textContent = ev.text + (ev.player.code === 'l' && ev.player.hit || ev.opponent.code === 'l' && ev.opponent.hit ? ' (a losing card can still land 30% chip damage)' : '') + (ev.mode === 'predict' ? (ev.correctRead ? ' — read right: clean win' : ' — read wrong: exposed') : '');
      if (ev.knockdowns.length) verdict.textContent = 'knockdown';
      else if (ev.stoppage) verdict.textContent = 'the referee steps in';
      else if (ev.player.dealt > ev.opponent.dealt) { verdict.textContent = 'you take the exchange'; verdict.className = 'verdict good'; }
      else if (ev.player.dealt < ev.opponent.dealt) { verdict.textContent = 'the opponent takes the exchange'; verdict.className = 'verdict bad'; }
      else { verdict.textContent = 'nothing in it'; verdict.className = 'verdict'; }
      if (ev.stoppage || f.phase === 'over') action.appendChild(button('See the result', { primary: true, onClick: function () { S.screen = 'result'; S.reveal = null; render(); } }));
      else if (f.phase === 'corner') action.appendChild(button('To the corner', { primary: true, onClick: function () { S.screen = 'corner'; S.reveal = null; render(); } }));
      else action.appendChild(h('span', 'small-note', 'Pick your next card below.'));
    } else {
      add(slots, add(h('div', 'slot'), h('div', 'card facedown', 'FACE DOWN')),
        add(h('div', 'slot'), h('div', 'card facedown', 'OPPONENT')));
      line.textContent = 'Both corners choose blind, then the cards turn over together.';
      verdict.textContent = 'exchange ' + Math.min(f.exchange + 1, 6);
    }
    add(stage, slots, line, verdict, action);
  }
  function playCard(id) {
    if (S.busy || !S.fight || S.fight.phase !== 'fight') return;
    if (S.fight.player.hand.indexOf(id) < 0) return;
    var f = S.fight;
    S.busy = true;
    S.reveal = null;
    var ev = R.playExchange(S.game, id, S.mode); // the rules resolve at once...
    S.pending = ev;
    S.mode = 'react';
    renderFight();                              // ...the cards stay face down for a beat
    setTimeout(function () {                    // then they turn over together
      S.busy = false;
      S.reveal = S.pending;
      S.pending = null;
      if (S.fight.phase === 'over' || S.fight.phase === 'corner') renderFight();
      else renderFight();
    }, 520);
  }
  /* ---------- the corner ------------------------------------------------- */
  function renderCorner() {
    var f = S.fight, r = f.rounds[f.rounds.length - 1];
    setWhere('between rounds - your corner');
    clear(screenEl);
    add(screenEl, h('h1', null, 'Back to the corner'),
      h('p', 'lead muted', 'Round ' + r.round + ': you landed ' + r.player.landed + ' and the opponent landed ' + r.opponent.landed +
        '. The judges gave it ' + r.scores.map(function (s) { return s[0] + '-' + s[1]; }).join(', ') +
        '. Pick one thing for the next round. Every one of them costs something.'));
    var row = h('div', 'corner');
    f.corner.forEach(function (id) {
      var c = null;
      R.CORNER_CARDS.forEach(function (x) { if (x.id === id) c = x; });
      var el = h('button', 'card corner');
      el.type = 'button';
      add(el, h('div', 'kind', c.stamina < 0 ? 'costs ' + Math.abs(c.stamina) + ' wind' : 'corner'), h('div', 'name', c.name), h('div', 'effect', c.text));
      el.addEventListener('click', function () {
        R.pickCorner(S.game, id);
        S.reveal = null;
        S.mode = 'react';
        S.screen = 'fight';
        render();
      });
      row.appendChild(el);
    });
    add(screenEl, row);
    if (f.foeCornerPick) {
      var cornerPick = R.CORNER_CARDS.filter(function (c) { return c.id === f.foeCornerPick; })[0];
      add(screenEl, h('p', 'small-note', 'The opponent’s corner is going with: ' + cornerPick.name + ' - ' + cornerPick.text));
    }
  }
  /* ---------- the result ------------------------------------------------- */
  function renderResult() {
    var f = S.fight, res = f.result;
    setWhere('the verdict');
    clear(screenEl);
    var win = res.winner === 'player', draw = res.winner === 'draw';
    add(screenEl, h('div', 'verdictline', win ? 'You win' : draw ? 'A draw' : 'The opponent wins'),
      h('h2', null, res.text),
      h('p', 'lead muted', res.method === 'stoppage' ? 'Stopped in round ' + res.round + '.' : 'Three rounds, three judges.'));
    var layout = h('div', 'result');
    var left = h('div', 'sheet');
    add(left, h('div', 'tiny', 'The cards'));
    var table = h('table', 'cards');
    var head = h('tr');
    add(head, h('th', null, 'Judge'), h('th', null, 'You'), h('th', null, 'Opponent'));
    table.appendChild(head);
    if (res.scorecards) {
      res.scorecards.forEach(function (c) {
        var tr = h('tr');
        add(tr, h('td', null, c.judge), h('td', 'n ' + (c.player > c.opponent ? 'win' : ''), c.player), h('td', 'n ' + (c.opponent > c.player ? 'win' : ''), c.opponent));
        table.appendChild(tr);
      });
    } else {
      var tr = h('tr');
      add(tr, h('td', null, 'no cards - it did not go that far'), h('td', 'n', '-'), h('td', 'n', '-'));
      table.appendChild(tr);
    }
    add(left, table, h('div', 'tiny', 'Round by round'));
    var table2 = h('table', 'cards');
    var head2 = h('tr');
    add(head2, h('th', null, 'Round'), h('th', null, 'Judges (you-opponent)'), h('th', null, 'Landed'), h('th', null, 'Damage'));
    table2.appendChild(head2);
    f.rounds.forEach(function (rd) {
      var tr = h('tr');
      add(tr, h('td', null, 'R' + rd.round),
        h('td', 'n', rd.scores.map(function (s) { return s[0] + '-' + s[1]; }).join('  ')),
        h('td', 'n', rd.player.landed + ' / ' + rd.opponent.landed),
        h('td', 'n', Math.round(rd.player.damage) + ' / ' + Math.round(rd.opponent.damage)));
      table2.appendChild(tr);
    });
    add(left, table2);
    var right = h('div', 'sheet');
    add(right, h('div', 'tiny', 'The fight in numbers'));
    var sum = h('table', 'cards');
    sum.appendChild(add(h('tr'), h('th', null, ''), h('th', null, f.player.name), h('th', null, f.opponent.name)));
    [['Landed', function (s) { return s.totals.landed; }], ['Thrown', function (s) { return s.totals.thrown; }],
      ['Damage done', function (s) { return Math.round(s.totals.damage); }], ['Knockdowns', function (s) { return s.knockdowns; }],
      ['Head damage taken', function (s) { return Math.round(s.head); }], ['Wind left', function (s) { return s.stamina; }]].forEach(function (pair) {
      var tr = h('tr');
      add(tr, h('td', null, pair[0]), h('td', 'n', pair[1](f.player)), h('td', 'n', pair[1](f.opponent)));
      sum.appendChild(tr);
    });
    add(right, sum, h('div', 'tiny', 'What you saw'));
    var seen = h('div', 'habits');
    if (!f.scouting.known.length) seen.appendChild(h('div', 'habit blank', 'You fought without film. Next time, scout the opponent.'));
    f.scouting.known.forEach(function (k) { seen.appendChild(h('div', 'habit', k.text)); });
    add(right, seen);
    add(layout, left, right);
    add(screenEl, layout);
    var again = h('div', 'row');
    add(again,
      button('Fight again', { primary: true, onClick: function () { startGame(S.game.playerBoxerId); } }),
      button('Pick another boxer', { onClick: function () { S.screen = 'pick'; S.fight = null; S.game = null; render(); } }));
    add(screenEl, again);
  }
  /* ---------- router ------------------------------------------------------ */
  function render() {
    if (S.screen === 'pick') return renderPick();
    if (S.screen === 'camp') return renderCamp();
    if (S.screen === 'scout') return renderScout();
    if (S.screen === 'corner') return renderCorner();
    if (S.screen === 'result') return renderResult();
    return renderFight();
  }
  document.addEventListener('keydown', function (e) {
    if (S.screen === 'fight' && S.fight && S.fight.phase === 'fight' && !S.busy && /^[1-5]$/.test(e.key)) {
      var id = S.fight.player.hand[Number(e.key) - 1];
      if (id) { e.preventDefault(); playCard(id); }
      return;
    }
    if (e.key === 'Enter') {
      var gold = document.querySelector('.btn.primary');
      if (gold && !gold.disabled) { e.preventDefault(); gold.click(); }
    }
  });
  render();
})();
